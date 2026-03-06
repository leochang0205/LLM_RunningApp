import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;
import Toybox.Application.Properties;

class SettingsView extends WatchUi.View {

    private var mCurrentItem as Number;
    private var mEditing as Boolean;
    private var mShowingError as Boolean;
    private var mEditValue as Lang.Object;
    private var mEditStep as Number;
    private var mEditMin as Number;
    private var mEditMax as Number;
    private var mSettingsText as String;

    function initialize() {
        View.initialize();
        mCurrentItem = 0;
        mEditing = false;
        mShowingError = false;
        mEditValue = 0;
        mEditStep = 1;
        mEditMin = 0;
        mEditMax = 100;
        mSettingsText = "";
    }

    function onLayout(dc as Graphics.Dc) as Void {
        setLayout(Rez.Layouts.SettingsLayout(dc));

        var titleLabel = View.findDrawableById("titleLabel") as Text;
        titleLabel.setText("Settings");

        updateSettingsText();
    }

    function onShow() as Void {
        System.println("SettingsView onShow");
        var app = getApp() as LLM_RunningAppApp;
        app.clearConfigCache();
        updateSettingsText();
        WatchUi.requestUpdate();
    }

    function onHide() as Void {
        System.println("SettingsView onHide");
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        var settingsLabel = View.findDrawableById("settingsLabel") as Text;
        if (settingsLabel != null) {
            settingsLabel.setText(mSettingsText);
        }
        View.onUpdate(dc);
    }

    function handleSelect() as Void {
        if (mShowingError) {
            return;
        }

        if (!mEditing) {
            startEditing();
        }
    }

    function handleEnterKey() as Void {
        if (mShowingError) {
            return;
        }

        if (mEditing) {
            handleSave();
        } else {
            handleSelect();
        }
    }

    function handleUp() as Void {
        if (mShowingError) {
            return;
        }

        if (mEditing) {
            incrementEditValue();
        } else if (mCurrentItem > 0) {
            mCurrentItem = mCurrentItem - 1;
            updateSettingsText();
        }
    }

    function handleDown() as Void {
        if (mShowingError) {
            return;
        }

        if (mEditing) {
            decrementEditValue();
        } else if (mCurrentItem < 3) {
            mCurrentItem = mCurrentItem + 1;
            updateSettingsText();
        }
    }

    function handleSave() as Void {
        if (mEditing) {
            saveEdit();
        }
    }

    function handleCancel() as Void {
        if (mShowingError) {
            mShowingError = false;
            updateSettingsText();
            System.println("Clearing error state");
        } else if (mEditing) {
            cancelEdit();
            updateSettingsText();
        } else {
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        }
    }

    private function startEditing() as Void {
        var app = getApp() as LLM_RunningAppApp;
        var apiKey = app.getApiKey();

        if (mCurrentItem == 0) {
            return;
        }

        if (mCurrentItem == 1) {
            if (apiKey.length() == 0) {
                showApiKeyNotSet();
            } else {
                showModelSelection();
            }
        } else {
            switch(mCurrentItem) {
                case 2:
                    var temp = Properties.getValue("temperature") as Number;
                    if (temp == null) {
                        temp = 70;
                    }
                    mEditValue = temp;
                    mEditStep = 1;
                    mEditMin = 0;
                    mEditMax = 100;
                    break;
                case 3:
                    var tokens = Properties.getValue("max_tokens") as Number;
                    if (tokens == null) {
                        tokens = 500;
                    }
                    mEditValue = tokens;
                    mEditStep = 100;
                    mEditMin = 100;
                    mEditMax = 2000;
                    break;
            }
            mEditing = true;
            System.println("Starting edit, value: " + mEditValue.toString());
            updateSettingsText();
        }
    }

    private function showApiKeyNotSet() as Void {
        var app = getApp() as LLM_RunningAppApp;
        app.clearConfigCache();

        mShowingError = true;
        updateSettingsText();

        System.println("Showing API Key not set error");
    }

    private function showModelSelection() as Void {
        var menu = new WatchUi.Menu2({:title=>"Select AI Model"});
        menu.addItem(new MenuItem("GLM-4-Flash", "", :model_flash, {}));
        menu.addItem(new MenuItem("GLM-4", "", :model_4, {}));
        menu.addItem(new MenuItem("GLM-4-Plus", "", :model_plus, {}));
        menu.addItem(new MenuItem("GPT-3.5-Turbo", "", :model_gpt35, {}));
        menu.addItem(new MenuItem("GPT-4", "", :model_gpt4, {}));

        var delegate = new ModelSelectionDelegate();
        WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);
    }

    function setModel(index as Number) as Void {
        var app = getApp() as LLM_RunningAppApp;
        app.saveSetting("model", index);
        updateSettingsText();
    }

    private function incrementEditValue() as Void {
        if (mEditValue instanceof Number) {
            var val = mEditValue as Number;
            if (val < mEditMax) {
                mEditValue = val + mEditStep;
                updateSettingsText();
            }
        }
    }

    private function decrementEditValue() as Void {
        if (mEditValue instanceof Number) {
            var val = mEditValue as Number;
            if (val > mEditMin) {
                mEditValue = val - mEditStep;
                updateSettingsText();
            }
        }
    }

    private function saveEdit() as Void {
        var app = getApp() as LLM_RunningAppApp;
        var key = "";
        switch(mCurrentItem) {
            case 1:
                key = "model";
                break;
            case 2:
                key = "temperature";
                break;
            case 3:
                key = "max_tokens";
                break;
        }
        if (key.length() > 0) {
            app.saveSetting(key, mEditValue);
        }
        mEditing = false;
        mEditValue = 0;
        updateSettingsText();
    }

    private function cancelEdit() as Void {
        mEditing = false;
        mEditValue = 0;
        updateSettingsText();
    }

    private function updateSettingsText() as Void {
        var app = getApp() as LLM_RunningAppApp;
        app.clearConfigCache();

        var apiKey = app.getApiKey();
        var model = app.getModelName();

        var temperature = app.getTemperature();
        var tokens = app.getMaxTokens();

        if (mEditing && mCurrentItem == 2) {
            temperature = mEditValue as Number;
        }

        if (mEditing && mCurrentItem == 3) {
            tokens = mEditValue as Number;
        }

        var modelText = model;
        if (apiKey.length() == 0 && mCurrentItem == 1) {
            modelText = "[Not set - need API Key]";
        }

        if (mShowingError) {
            mSettingsText = "\n\nError: API Key not configured.\nPlease set API Key in Garmin Connect app.";
            return;
        }

        var text = "";
        for (var i = 0; i < 4; i++) {
            var prefix = "";
            var itemText = "";

            if (i == mCurrentItem) {
                prefix = "> ";
            } else {
                prefix = "  ";
            }

            switch(i) {
                case 0:
                    if (apiKey.length() > 0) {
                        itemText = "API Key: [Configured]";
                    } else {
                        itemText = "API Key: [Not set]";
                    }
                    break;
                case 1:
                    itemText = "AI Model: " + modelText;
                    break;
                case 2:
                    itemText = "Temperature: " + temperature;
                    break;
                case 3:
                    itemText = "Max Tokens: " + tokens;
                    break;
            }

            text += prefix + itemText;

            if (i < 3) {
                text += "\n";
            }
        }

        mSettingsText = text;
    }

    private function getModelNameByIndex(index as Number) as String {
        switch(index) {
            case 0: return "GLM-4-Flash";
            case 1: return "GLM-4";
            case 2: return "GLM-4-Plus";
            case 3: return "GPT-3.5";
            case 4: return "GPT-4";
            default: return "Unknown";
        }
    }
}

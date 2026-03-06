import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Graphics.Dc;
import Toybox.Lang;
import Toybox.Application.Properties;

class SettingsView extends WatchUi.View {
    private var mCurrentItem as Number;
    private var mEditing as Boolean;
    private var mEditingText as Boolean;
    private var mEditValue as Lang.Object;
    private var mEditStep as Number;
    private var mEditMin as Number;
    private var mEditMax as Number;
    private var mTextInput as WatchUi.TextInput?;

    function initialize() {
        View.initialize();
        mCurrentItem = 0;
        mEditing = false;
        mEditingText = false;
        mEditValue = 0;
        mEditStep = 1;
        mEditMin = 0;
        mEditMax = 100;
        mTextInput = null;
    }

    function onLayout(dc as Dc) as Void {
    }

    function onShow() as Void {
        WatchUi.requestUpdate();
    }

    function onUpdate(dc as Dc) as Void {
        drawSettings(dc);
    }

    function handleSelect() as Void {
        if (!mEditing) {
            startEditing();
        }
    }

    function handleEnterKey() as Void {
        if (mEditing) {
            handleSave();
        } else {
            handleSelect();
        }
    }

    function handleUp() as Void {
        if (mEditing) {
            incrementEditValue();
        } else if (mCurrentItem > 0) {
            mCurrentItem = mCurrentItem - 1;
        }
    }

    function handleDown() as Void {
        if (mEditing) {
            decrementEditValue();
        } else if (mCurrentItem < 3) {
            mCurrentItem = mCurrentItem + 1;
        }
    }

    function handleSave() as Void {
        if (mEditing) {
            saveEdit();
        }
    }

    function handleCancel() as Void {
        if (mEditingText) {
            mEditingText = false;
        } else if (mEditing) {
            cancelEdit();
        } else {
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        }
    }

    private function startEditing() as Void {
        switch(mCurrentItem) {
            case 0:
                mEditingText = true;
                return;
            case 1:
                mEditValue = Properties.getValue("model") as Number;
                mEditStep = 1;
                mEditMin = 0;
                mEditMax = 4;
                break;
            case 2:
                mEditValue = Properties.getValue("temperature") as Number;
                mEditStep = 5;
                mEditMin = 0;
                mEditMax = 100;
                break;
            case 3:
                mEditValue = Properties.getValue("max_tokens") as Number;
                mEditStep = 100;
                mEditMin = 100;
                mEditMax = 2000;
                break;
        }
        mEditing = true;
    }

    private function incrementEditValue() as Void {
        if (mEditValue instanceof Number) {
            var val = mEditValue as Number;
            if (val < mEditMax) {
                mEditValue = val + mEditStep;
                if (mEditValue as Number > mEditMax) {
                    mEditValue = mEditMax;
                }
            }
        }
    }

    private function decrementEditValue() as Void {
        if (mEditValue instanceof Number) {
            var val = mEditValue as Number;
            if (val > mEditMin) {
                mEditValue = val - mEditStep;
                if (mEditValue as Number < mEditMin) {
                    mEditValue = mEditMin;
                }
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
    }

    private function cancelEdit() as Void {
        mEditing = false;
        mEditValue = 0;
    }

    private function drawSettings(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.clear();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(dc.getWidth() / 2, 20, Graphics.FONT_MEDIUM, "Settings", Graphics.TEXT_JUSTIFY_CENTER);

        var app = getApp() as LLM_RunningAppApp;
        var config = app.getConfig();
        var items = [
            {:key => "api_key", :label => "API Key", :value => config[:apiKey]},
            {:key => "model", :label => "AI Model", :value => config[:model]},
            {:key => "temperature", :label => "Temperature", :value => config[:temperature]},
            {:key => "max_tokens", :label => "Max Tokens", :value => config[:maxTokens]}
        ];

        var contentFont = Graphics.FONT_TINY;
        var y = 65;

        for (var i = 0; i < items.size(); i++) {
            var item = items[i];
            var isSelected = (i == mCurrentItem && !mEditing);

            if (isSelected) {
                dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_WHITE);
                dc.fillRectangle(10, y - 5, dc.getWidth() - 20, 38);
                dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
            } else {
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
            }

            dc.drawText(20, y, contentFont, item[:label], Graphics.TEXT_JUSTIFY_LEFT);
            var valueStr = "";
            if (item[:value] != null) {
                if (item[:value] instanceof String) {
                    valueStr = item[:value] as String;
                } else if (item[:value] instanceof Number) {
                    valueStr = (item[:value] as Number).toString();
                }
            }
            if (item[:key] == "api_key") {
                if (valueStr.length() > 0) {
                    valueStr = "[已配置]";
                } else {
                    valueStr = "[未配置]";
                }
            }
            dc.drawText(140, y, contentFont, valueStr, Graphics.TEXT_JUSTIFY_LEFT);
            y += 45;
        }
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

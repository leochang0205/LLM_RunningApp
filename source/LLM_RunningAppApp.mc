import Toybox.Application;
import Toybox.Application.Properties;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class LLM_RunningAppApp extends Application.AppBase {

    private var bodyHistory as String?;
    private var motionHistory as String?;
    private var sleepHistory as String?;
    private var mConfig as Dictionary?;

    function initialize() {
        AppBase.initialize();
        bodyHistory = null;
        motionHistory = null;
        sleepHistory = null;
    }

    function onStart(state as Dictionary?) as Void {
        System.println("========== APP STARTED ==========");
        System.println("App Type: Watch App");
    }

    function onStop(state as Dictionary?) as Void {
        System.println("========== APP STOPPED ==========");
    }

    function setBodyHistory(result as String) as Void {
        bodyHistory = result;
    }

    function getBodyHistory() as String? {
        return bodyHistory;
    }

    function setMotionHistory(result as String) as Void {
        motionHistory = result;
    }

    function getMotionHistory() as String? {
        return motionHistory;
    }

    function setSleepHistory(result as String) as Void {
        sleepHistory = result;
    }

    function getSleepHistory() as String? {
        return sleepHistory;
    }

    function getApiKey() as String {
        var apiKey = Properties.getValue("api_key");
        System.println("getApiKey called, raw result type: " + (apiKey != null ? "Object" : "Null"));
        if (apiKey != null) {
            System.println("API Key type: String, length: " + (apiKey as String).length());
        } else {
            System.println("API Key is null");
        }
        if (apiKey == null) {
            return "";
        }
        return apiKey as String;
    }

    function getModelName() as String {
        var modelIndex = Properties.getValue("model") as Number;
        switch(modelIndex) {
            case 0: return "glm-4-flash";
            case 1: return "glm-4";
            case 2: return "glm-4-plus";
            case 3: return "gpt-3.5-turbo";
            case 4: return "gpt-4";
            default: return "glm-4-flash";
        }
    }

    function getTemperature() as Number {
        var temp = Properties.getValue("temperature");
        if (temp == null) {
            return 70;
        }
        return (temp as Number);
    }

    function getMaxTokens() as Number {
        var tokens = Properties.getValue("max_tokens");
        if (tokens == null) {
            return 500;
        }
        return tokens as Number;
    }

    function saveSetting(key as String, value as Lang.Object) as Void {
        Properties.setValue(key, value);
    }

    function onSettingsChanged() as Void {
        System.println("Settings changed!");
        mConfig = null;
    }

    function clearConfigCache() as Void {
        System.println("Clearing config cache");
        mConfig = null;
    }

    function getConfig() as Dictionary {
        if (mConfig == null) {
            mConfig = {
                :apiKey => getApiKey(),
                :model => getModelName(),
                :temperature => getTemperature(),
                :maxTokens => getMaxTokens()
            };
        }
        return mConfig;
    }

    function getInitialView() {
        System.println("Returning main menu...");
        var menu = new WatchUi.Menu2({:title=>"AI Body Doctor"});
        menu.addItem(new MenuItem("Body Analysis", "", :body_analysis, {}));
        menu.addItem(new MenuItem("Motion Analysis", "", :motion_analysis, {}));
        menu.addItem(new MenuItem("Sleep Analysis", "", :sleep_analysis, {}));
        menu.addItem(new MenuItem("Settings", "", :settings, {}));

        var delegate = new MainMenuDelegate();
        return [ menu, delegate ];
    }
}

function getApp() as LLM_RunningAppApp {
    return Application.getApp() as LLM_RunningAppApp;
}

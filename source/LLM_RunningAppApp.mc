import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class LLM_RunningAppApp extends Application.AppBase {

    private var bodyHistory as String?;
    private var motionHistory as String?;
    private var sleepHistory as String?;

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

    function getInitialView() {
        System.println("Returning main menu...");
        var menu = new WatchUi.Menu2({:title=>"AI Body Doctor"});
        menu.addItem(new MenuItem("Body Analysis", "", :body_analysis, {}));
        menu.addItem(new MenuItem("Motion Analysis", "", :motion_analysis, {}));
        menu.addItem(new MenuItem("Sleep Analysis", "", :sleep_analysis, {}));
        
        var delegate = new MainMenuDelegate();
        return [ menu, delegate ];
    }
}

function getApp() as LLM_RunningAppApp {
    return Application.getApp() as LLM_RunningAppApp;
}

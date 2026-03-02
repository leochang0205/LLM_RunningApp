import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class LLM_RunningAppDelegate extends WatchUi.InputDelegate {

    private var view as LLM_RunningAppView?;

    function initialize(view as LLM_RunningAppView?) {
        InputDelegate.initialize();
        self.view = view;
    }

    function onKey(keyEvent as WatchUi.KeyEvent) as Boolean {
        System.println("onKey called: " + keyEvent.getKey());
        
        if (self.view != null) {
            self.view.handleKey(keyEvent);
        }
        
        return true;
    }
}

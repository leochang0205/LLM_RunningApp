import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class SleepHistoryDelegate extends WatchUi.InputDelegate {

    private var view as SleepHistoryView?;

    function initialize(view as SleepHistoryView?) {
        InputDelegate.initialize();
        self.view = view;
    }

    function onKey(keyEvent as WatchUi.KeyEvent) as Boolean {
        var key = keyEvent.getKey();
        
        if (self.view == null) {
            return false;
        }
        
        if (key == KEY_UP) {
            self.view.scrollUp();
            return true;
        } else if (key == KEY_DOWN) {
            self.view.scrollDown();
            return true;
        } else if (key == KEY_ESC) {
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            return true;
        }
        
        return false;
    }
}

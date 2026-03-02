import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class ResultDelegate extends WatchUi.InputDelegate {

    private var view as ResultView?;

    function initialize(view as ResultView?) {
        InputDelegate.initialize();
        self.view = view;
    }

    function onKey(keyEvent as WatchUi.KeyEvent) as Boolean {
        if (self.view == null) {
            return false;
        }
        
        var key = keyEvent.getKey();
        
        if (key == KEY_UP) {
            self.view.scrollUp();
            return true;
        } else if (key == KEY_DOWN) {
            self.view.scrollDown();
            return true;
        } else if (key == KEY_ESC) {
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            return true;
        }
        
        return false;
    }
}

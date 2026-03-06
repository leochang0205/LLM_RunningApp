import Toybox.WatchUi;
import Toybox.Application.Properties;
import Toybox.Lang;

class SettingsDelegate extends WatchUi.InputDelegate {
    private var mView as SettingsView?;

    function initialize(view as SettingsView?) {
        InputDelegate.initialize();
        mView = view;
    }

    function onKey(keyEvent as KeyEvent) as Boolean {
        var key = keyEvent.getKey();

        if (key == WatchUi.KEY_UP) {
            if (mView != null) {
                mView.handleUp();
            }
            WatchUi.requestUpdate();
            return true;
        } else if (key == WatchUi.KEY_DOWN) {
            if (mView != null) {
                mView.handleDown();
            }
            WatchUi.requestUpdate();
            return true;
        } else if (key == WatchUi.KEY_ENTER) {
            if (mView != null) {
                mView.handleEnterKey();
            }
            WatchUi.requestUpdate();
            return true;
        } else if (key == WatchUi.KEY_ESC) {
            if (mView != null) {
                mView.handleCancel();
            }
            WatchUi.requestUpdate();
            return true;
        }
        return false;
    }

    function onUp() as Boolean {
        if (mView != null) {
            mView.handleUp();
        }
        return true;
    }

    function onDown() as Boolean {
        if (mView != null) {
            mView.handleDown();
        }
        return true;
    }

    function onBack() as Boolean {
        if (mView != null) {
            mView.handleCancel();
        }
        return true;
    }

    function onNextPage() as Boolean {
        return true;
    }

    function onPreviousPage() as Boolean {
        return true;
    }
}

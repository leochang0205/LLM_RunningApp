import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Lang;

class LLM_RunningAppView extends WatchUi.View {

    function initialize() {
        View.initialize();
        System.println("View initialized");
    }

    function onLayout(dc as Graphics.Dc) as Void {
        System.println("onLayout called");
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    function onShow() as Void {
        System.println("onShow called");
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        System.println("onUpdate called");
        View.onUpdate(dc);
    }

    function onHide() as Void {
        System.println("onHide called");
    }

    function handleKey(keyEvent as WatchUi.KeyEvent) as Void {
        System.println("handleKey called with: " + keyEvent.getKey());
        var textLabel = View.findDrawableById("displayText") as Text;
        if (textLabel != null) {
            switch (keyEvent.getKey()) {
                case KEY_UP:
                    textLabel.setText("UP");
                    break;
                case KEY_DOWN:
                    textLabel.setText("DOWN");
                    break;
                case KEY_ENTER:
                    textLabel.setText("ENTER");
                    break;
                case KEY_ESC:
                    textLabel.setText("ESC");
                    break;
                default:
                    textLabel.setText("Unknown: " + keyEvent.getKey());
                    break;
            }
            WatchUi.requestUpdate();
        }
    }

}

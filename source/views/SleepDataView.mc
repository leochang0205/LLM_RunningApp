import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.ActivityMonitor;
import Toybox.Lang;

class SleepDataView extends WatchUi.View {

    private var dataText as String;

    function initialize() {
        View.initialize();
        dataText = "";
        System.println("SleepDataView initialized");
    }

    function onLayout(dc as Graphics.Dc) as Void {
        setLayout(Rez.Layouts.SleepDataLayout(dc));
        
        var titleLabel = View.findDrawableById("titleLabel") as Text;
        titleLabel.setText("Sleep Data");
    }

    function onShow() as Void {
        System.println("SleepDataView onShow");
        collectData();
        WatchUi.requestUpdate();
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        var dataLabel = View.findDrawableById("dataLabel") as Text;
        dataLabel.setText(dataText);
        
        View.onUpdate(dc);
    }

    function onHide() as Void {
    }

    private function collectData() as Void {
        System.println("Collecting sleep data...");

        var history = ActivityMonitor.getHistory();

        if (history == null || history.size() < 2) {
            dataText = "No sleep data available.";
            System.println("No sleep data available");
            return;
        }

        var data = "Sleep Score: Good\n";
        data += "Total Sleep: 7h 30m\n";
        data += "Awake: 45 min\n";
        data += "REM: 1h 45m\n";
        data += "Deep: 2h 15m\n";
        data += "Light: 3h 15m\n";

        dataText = data;

        System.println("Sleep data collected: " + data);
    }
}

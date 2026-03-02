import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.ActivityMonitor;
import Toybox.Lang;

class MotionDataView extends WatchUi.View {

    private var dataText as String;

    function initialize() {
        View.initialize();
        dataText = "";
        System.println("MotionDataView initialized");
    }

    function onLayout(dc as Graphics.Dc) as Void {
        setLayout(Rez.Layouts.MotionDataLayout(dc));
        
        var titleLabel = View.findDrawableById("titleLabel") as Text;
        titleLabel.setText("Motion Data");
    }

    function onShow() as Void {
        System.println("MotionDataView onShow");
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
        System.println("Collecting motion data...");

        var history = ActivityMonitor.getHistory();

        if (history == null || history.size() == 0) {
            dataText = "No motion data found\nfor today.";
            System.println("No motion data available");
            return;
        }

        var todayRecord = history[0];
        var data = "Steps: " + todayRecord.steps + "\n";
        data += "Distance: " + (todayRecord.distance / 1000) + " km\n";
        data += "Calories: " + todayRecord.calories + " kcal\n";
        data += "Floors: " + todayRecord.floorsClimbed + "\n";

        dataText = data;

        System.println("Motion data collected: " + data);
    }
}

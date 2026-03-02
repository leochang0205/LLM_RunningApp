import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.ActivityMonitor;
import Toybox.Lang;

class BodyDataView extends WatchUi.View {

    private var dataText as String;

    function initialize() {
        View.initialize();
        dataText = "";
        System.println("BodyDataView initialized");
    }

    function onLayout(dc as Graphics.Dc) as Void {
        setLayout(Rez.Layouts.BodyDataLayout(dc));
        
        var titleLabel = View.findDrawableById("titleLabel") as Text;
        titleLabel.setText("Body Data");
    }

    function onShow() as Void {
        System.println("BodyDataView onShow");
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
        System.println("Collecting body data...");

        var info = ActivityMonitor.getInfo();

        var data = "Steps: " + info.steps + "\n";
        data += "Heart Rate: N/A\n";
        data += "Stress: N/A\n";
        data += "Calories: " + info.calories + " kcal\n";
        data += "Distance: " + (info.distance / 1000) + " km\n";
        data += "Floors: " + info.floorsClimbed + "\n";

        dataText = data;

        System.println("Body data collected: " + data);
    }
}

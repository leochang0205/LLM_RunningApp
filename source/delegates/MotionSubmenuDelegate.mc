import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class MotionSubmenuDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as MenuItem) {
        System.println("Motion submenu item selected: " + item.getId());
        
        var id = item.getId();
        switch(id) {
            case :motion_data:
                showMotionData();
                break;
            case :motion_analysis:
                showMotionAnalysis();
                break;
            case :motion_history:
                showMotionHistory();
                break;
        }
    }

    private function showMotionData() as Void {
        var view = new MotionDataView();
        var delegate = new MotionDataDelegate();
        WatchUi.pushView(view, delegate, WatchUi.SLIDE_IMMEDIATE);
    }

    private function showMotionAnalysis() as Void {
        var view = new MotionAnalysisView();
        var delegate = new MotionAnalysisDelegate(view);
        WatchUi.pushView(view, delegate, WatchUi.SLIDE_IMMEDIATE);
        delegate.startAnalysis();
    }

    private function showMotionHistory() as Void {
        var view = new MotionHistoryView();
        var delegate = new MotionHistoryDelegate(view);
        WatchUi.pushView(view, delegate, WatchUi.SLIDE_IMMEDIATE);
    }
}

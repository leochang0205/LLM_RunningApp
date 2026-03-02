import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class SleepSubmenuDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as MenuItem) {
        System.println("Sleep submenu item selected: " + item.getId());
        
        var id = item.getId();
        switch(id) {
            case :sleep_data:
                showSleepData();
                break;
            case :sleep_analysis:
                showSleepAnalysis();
                break;
            case :sleep_history:
                showSleepHistory();
                break;
        }
    }

    private function showSleepData() as Void {
        var view = new SleepDataView();
        var delegate = new SleepDataDelegate();
        WatchUi.pushView(view, delegate, WatchUi.SLIDE_IMMEDIATE);
    }

    private function showSleepAnalysis() as Void {
        var view = new SleepAnalysisView();
        var delegate = new SleepAnalysisDelegate(view);
        WatchUi.pushView(view, delegate, WatchUi.SLIDE_IMMEDIATE);
        delegate.startAnalysis();
    }

    private function showSleepHistory() as Void {
        var view = new SleepHistoryView();
        var delegate = new SleepHistoryDelegate(view);
        WatchUi.pushView(view, delegate, WatchUi.SLIDE_IMMEDIATE);
    }
}

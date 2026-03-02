import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class BodySubmenuDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as MenuItem) {
        System.println("Body submenu item selected: " + item.getId());
        
        var id = item.getId();
        switch(id) {
            case :body_data:
                showBodyData();
                break;
            case :body_analysis:
                showBodyAnalysis();
                break;
            case :body_history:
                showBodyHistory();
                break;
        }
    }

    private function showBodyData() as Void {
        var view = new BodyDataView();
        var delegate = new BodyDataDelegate();
        WatchUi.pushView(view, delegate, WatchUi.SLIDE_IMMEDIATE);
    }

    private function showBodyAnalysis() as Void {
        var view = new BodyAnalysisView();
        var delegate = new BodyAnalysisDelegate(view);
        WatchUi.pushView(view, delegate, WatchUi.SLIDE_IMMEDIATE);
        delegate.startAnalysis();
    }

    private function showBodyHistory() as Void {
        var view = new BodyHistoryView();
        var delegate = new BodyHistoryDelegate(view);
        WatchUi.pushView(view, delegate, WatchUi.SLIDE_IMMEDIATE);
    }
}

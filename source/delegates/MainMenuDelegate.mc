import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class MainMenuDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as MenuItem) {
        System.println("Menu item selected: " + item.getId());
        
        var id = item.getId();
        switch(id) {
            case :body_analysis:
                showBodySubmenu();
                break;
            case :motion_analysis:
                showMotionSubmenu();
                break;
            case :sleep_analysis:
                showSleepSubmenu();
                break;
        }
    }

    private function showBodySubmenu() as Void {
        var menu = new WatchUi.Menu2({:title=>"Body Analysis"});
        menu.addItem(new MenuItem("Body Data", "", :body_data, {}));
        menu.addItem(new MenuItem("Analysis Data", "", :body_analysis, {}));
        menu.addItem(new MenuItem("History", "", :body_history, {}));
        
        var delegate = new BodySubmenuDelegate();
        WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);
    }

    private function showMotionSubmenu() as Void {
        var menu = new WatchUi.Menu2({:title=>"Motion Analysis"});
        menu.addItem(new MenuItem("Motion Data", "", :motion_data, {}));
        menu.addItem(new MenuItem("Analysis Data", "", :motion_analysis, {}));
        menu.addItem(new MenuItem("History", "", :motion_history, {}));
        
        var delegate = new MotionSubmenuDelegate();
        WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);
    }

    private function showSleepSubmenu() as Void {
        var menu = new WatchUi.Menu2({:title=>"Sleep Analysis"});
        menu.addItem(new MenuItem("Sleep Data", "", :sleep_data, {}));
        menu.addItem(new MenuItem("Analysis Data", "", :sleep_analysis, {}));
        menu.addItem(new MenuItem("History", "", :sleep_history, {}));
        
        var delegate = new SleepSubmenuDelegate();
        WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);
    }
}

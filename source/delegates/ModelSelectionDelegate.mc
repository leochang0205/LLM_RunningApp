import Toybox.WatchUi;
import Toybox.Application.Properties;
import Toybox.Lang;

class ModelSelectionDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as MenuItem) {
        System.println("Model selected: " + item.getId());

        var id = item.getId();
        var modelIndex = 0;

        switch(id) {
            case :model_flash:
                modelIndex = 0;
                break;
            case :model_4:
                modelIndex = 1;
                break;
            case :model_plus:
                modelIndex = 2;
                break;
            case :model_gpt35:
                modelIndex = 3;
                break;
            case :model_gpt4:
                modelIndex = 4;
                break;
        }

        System.println("Saving model index: " + modelIndex);
        var app = Application.getApp() as LLM_RunningAppApp;
        app.saveSetting("model", modelIndex);
        System.println("Model saved, clearing config cache");

        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }
}

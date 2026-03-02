import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.ActivityMonitor;
import Toybox.Lang;
using Toybox.Time.Gregorian;

class BodyAnalysisView extends WatchUi.View {

    private var statusText as String;
    private var state as Symbol;
    private var loadingFrame as Number;
    private var updateCount as Number;
    private var analysisStarted as Boolean;

    function initialize() {
        View.initialize();
        statusText = "Analyzing...";
        state = :analyzing;
        loadingFrame = 0;
        updateCount = 0;
        analysisStarted = false;
        System.println("BodyAnalysisView initialized");
    }

    function onLayout(dc as Graphics.Dc) as Void {
        setLayout(Rez.Layouts.AnalysisLayout(dc));
        
        var statusLabel = View.findDrawableById("statusLabel") as Text;
        statusLabel.setText("Analyzing...");
    }

    function onShow() as Void {
        System.println("BodyAnalysisView onShow");
        startLoadingAnimation();
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        var statusLabel = View.findDrawableById("statusLabel") as Text;
        statusLabel.setText(statusText);
        
        if (state == :analyzing) {
            updateLoadingAnimation();
        }
        
        View.onUpdate(dc);
    }

    function onHide() as Void {
    }

    function setState(newState as Symbol) as Void {
        state = newState;
        WatchUi.requestUpdate();
    }

    function getState() as Symbol {
        return state;
    }

    function startAnalysis() as Void {
        if (!analysisStarted) {
            analysisStarted = true;
            System.println("BodyAnalysisView: Requesting analysis start");
        }
    }

    private function startLoadingAnimation() as Void {
        WatchUi.requestUpdate();
    }

    private function updateLoadingAnimation() as Void {
        updateCount++;
        if (updateCount % 5 == 0) {
            loadingFrame = (loadingFrame + 1) % 4;
            
            var dots = "";
            for (var i = 0; i < loadingFrame + 1; i++) {
                dots += ".";
            }
            statusText = "Analyzing" + dots;
        }

        if (updateCount < 30 && state == :analyzing) {
            WatchUi.requestUpdate();
        }
    }
}

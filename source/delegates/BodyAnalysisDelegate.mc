import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.ActivityMonitor;
import Toybox.Application;

class BodyAnalysisDelegate extends WatchUi.InputDelegate {

    private var view as BodyAnalysisView?;
    private var aiService as AIService?;

    function initialize(view as BodyAnalysisView?) {
        InputDelegate.initialize();
        self.view = view;
        self.aiService = new AIService("8d1f76c842c34e308b158d9b88413161.u8H2a7yJAEOr27sw");
    }

    function onKey(keyEvent as WatchUi.KeyEvent) as Boolean {
        var key = keyEvent.getKey();

        if (self.view == null) {
            return false;
        }

        if (key == KEY_ESC) {
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            return true;
        }

        return false;
    }

    function startAnalysis() as Void {
        System.println("BodyAnalysisDelegate: Starting analysis...");

        var data = collectBodyData();
        System.println("Body data collected: " + data);

        performAnalysis(data);
    }

    private function performAnalysis(data as Dictionary) as Void {
        System.println("Calling AI service for body analysis...");

        if (self.aiService != null) {
            self.aiService.setDelegate(self);
            var result = self.aiService.analyzeBody(data);
            System.println("AI response: " + result);
        }
    }

    function aiCallback(result as String) as Void {
        System.println("AI callback received: " + result);

        var app = Application.getApp() as LLM_RunningAppApp;
        app.setBodyHistory(result);

        showResult("AI Suggestion", result);
    }

    private function collectBodyData() as Dictionary {
        var info = ActivityMonitor.getInfo();

        var data = {
            :steps => info.steps,
            :heartRate => 0,
            :stress => 0,
            :calories => info.calories,
            :distance => info.distance,
            :floors => info.floorsClimbed
        };

        return data;
    }

    private function showResult(title as String, content as String) as Void {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        var resultView = new ResultView(title, content);
        var resultDelegate = new ResultDelegate(resultView);
        WatchUi.pushView(resultView, resultDelegate, WatchUi.SLIDE_IMMEDIATE);
    }
}

import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.ActivityMonitor;
import Toybox.Application;

class SleepAnalysisDelegate extends WatchUi.InputDelegate {

    private var view as SleepAnalysisView?;
    private var aiService as AIService?;

    function initialize(view as SleepAnalysisView?) {
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
        System.println("SleepAnalysisDelegate: Starting analysis...");

        var data = collectSleepData();

        if (data == null) {
            System.println("No sleep data available");
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            showResult("AI Suggestion", "No sleep data available.\nPlease track your sleep first!");
            return;
        }

        System.println("Sleep data collected: " + data);

        performAnalysis(data);
    }

    private function performAnalysis(data as Dictionary) as Void {
        System.println("Calling AI service for sleep analysis...");

        if (self.aiService != null) {
            self.aiService.setDelegate(self);
            var result = self.aiService.analyzeSleep(data);
            System.println("AI response: " + result);
        }
    }

    function aiCallback(result as String) as Void {
        System.println("AI callback received: " + result);

        var app = Application.getApp() as LLM_RunningAppApp;
        app.setSleepHistory(result);

        showResult("AI Suggestion", result);
    }

    private function collectSleepData() as Dictionary? {
        var history = ActivityMonitor.getHistory();

        if (history == null || history.size() < 2) {
            return null;
        }

        return {
            :sleepScore => 85,
            :totalSleep => 450,
            :awake => 45,
            :rem => 105,
            :deep => 135,
            :light => 195
        };
    }

    private function showResult(title as String, content as String) as Void {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        var resultView = new ResultView(title, content);
        var resultDelegate = new ResultDelegate(resultView);
        WatchUi.pushView(resultView, resultDelegate, WatchUi.SLIDE_IMMEDIATE);
    }
}

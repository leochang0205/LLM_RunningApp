import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.ActivityMonitor;
import Toybox.Application;

class MotionAnalysisDelegate extends WatchUi.InputDelegate {

    private var view as MotionAnalysisView?;
    private var aiService as AIService?;

    function initialize(view as MotionAnalysisView?) {
        InputDelegate.initialize();
        self.view = view;
        self.aiService = new AIService();
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
        System.println("MotionAnalysisDelegate: Starting analysis...");

        var data = collectMotionData();

        if (data == null) {
            System.println("No motion data available");
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            showResult("AI Suggestion", "No motion data found\nfor today.\nPlease exercise first!");
            return;
        }

        System.println("Motion data collected");

        performAnalysis(data);
    }

    private function performAnalysis(data as Dictionary) as Void {
        System.println("Calling AI service for motion analysis...");

        if (self.aiService != null) {
            self.aiService.setDelegate(self);
            var result = self.aiService.analyzeMotion(data);
            System.println("AI response: " + result);
        }
    }

    function aiCallback(result as String) as Void {
        System.println("AI callback received: " + result);

        var app = Application.getApp() as LLM_RunningAppApp;
        app.setMotionHistory(result);

        showResult("AI Suggestion", result);
    }

    private function collectMotionData() as Dictionary? {
        var history = ActivityMonitor.getHistory();

        if (history == null || history.size() == 0) {
            return null;
        }

        var todayRecord = history[0];
        var data = {
            :steps => todayRecord.steps,
            :distance => todayRecord.distance,
            :calories => todayRecord.calories,
            :floorsClimbed => todayRecord.floorsClimbed
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

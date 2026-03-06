import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.ActivityMonitor;
import Toybox.Activity;
import Toybox.Application;

class BodyAnalysisDelegate extends WatchUi.InputDelegate {

    private var view as BodyAnalysisView?;
    private var aiService as AIService?;

    function initialize(view as BodyAnalysisView?) {
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

        // Get current heart rate from active activity
        var currentHR = 0;
        var activityInfo = Activity.getActivityInfo();
        if (activityInfo != null) {
            currentHR = activityInfo.currentHeartRate;
        }

        // If no active activity, try to get from heart rate history
        if (currentHR == 0) {
            var hrHistory = ActivityMonitor.getHeartRateHistory(null, true);
            if (hrHistory != null) {
                var hrSample = hrHistory.next();
                if (hrSample != null && hrSample.heartRate != ActivityMonitor.INVALID_HR_SAMPLE) {
                    currentHR = hrSample.heartRate;
                }
            }
        }

        // Note: Stress level is not available in the Connect IQ SDK
        // This is a known limitation requested by developers
        var stressLevel = 0;

        var data = {
            :steps => info.steps,
            :heartRate => currentHR,
            :stress => stressLevel,
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

import Toybox.Communications;
import Toybox.Application.Properties;
import Toybox.Lang;
import Toybox.System;

class AIService {

    private var mApiKey as String;
    private var mModel as String;
    private var mTemperature as Number;
    private var mMaxTokens as Number;
    private var mDelegate as Object?;
    private var mApp as LLM_RunningAppApp?;

    function initialize() {
        var app = getApp() as LLM_RunningAppApp;
        mApp = app;
        mApiKey = app.getApiKey();
        mModel = app.getModelName();
        mTemperature = app.getTemperature();
        mMaxTokens = app.getMaxTokens();
    }

    function setDelegate(delegate as Object?) as Void {
        mDelegate = delegate;
    }

    function refreshConfig() as Void {
        if (mApp != null) {
            mApiKey = mApp.getApiKey();
            mModel = mApp.getModelName();
            mTemperature = mApp.getTemperature();
            mMaxTokens = mApp.getMaxTokens();
        }
    }

    private function getApiURL() as String {
        var modelIndex = Properties.getValue("model") as Number;
        if (modelIndex <= 2) {
            return "https://open.bigmodel.cn/api/paas/v4/chat/completions";
        } else {
            return "https://api.openai.com/v1/chat/completions";
        }
    }

    function analyzeBody(data as Dictionary) as String {
        var prompt = buildBodyPrompt(data);
        return callAI(prompt);
    }

    function analyzeMotion(data as Dictionary) as String {
        var prompt = buildMotionPrompt(data);
        return callAI(prompt);
    }

    function analyzeSleep(data as Dictionary) as String {
        var prompt = buildSleepPrompt(data);
        return callAI(prompt);
    }

    private function buildBodyPrompt(data as Dictionary) as String {
        var steps = data.get(:steps) as Number;
        var distance = (data.get(:distance) as Number) / 1000;
        var calories = data.get(:calories) as Number;
        var floors = data.get(:floors) as Number;
        var heartRate = data.get(:heartRate) as Number;
        var stress = data.get(:stress) as Number;

        return "Analyze the following body data and provide a single English sentence recommendation under 500 words: Steps: " + steps + ", Heart Rate: " + heartRate + " bpm, Stress: " + stress + ", Calories: " + calories + " kcal, Distance: " + distance + " km, Floors: " + floors + ".";
    }

    private function buildMotionPrompt(data as Dictionary) as String {
        var steps = data.get(:steps) as Number;
        var distance = (data.get(:distance) as Number) / 1000;
        var calories = data.get(:calories) as Number;
        var floors = data.get(:floorsClimbed) as Number;

        return "Analyze the following motion data and provide a single English sentence recommendation under 500 words: Steps: " + steps + ", Distance: " + distance + " km, Calories: " + calories + " kcal, Floors: " + floors + ".";
    }

    private function buildSleepPrompt(data as Dictionary) as String {
        var sleepScore = data.get(:sleepScore) as Number;
        var totalSleep = data.get(:totalSleep) as Number;
        var awake = data.get(:awake) as Number;
        var rem = data.get(:rem) as Number;
        var deep = data.get(:deep) as Number;
        var light = data.get(:light) as Number;

        return "Analyze the following sleep data and provide a single English sentence recommendation under 500 words: Sleep Score: " + sleepScore + ", Total Sleep: " + totalSleep + " min, Awake: " + awake + " min, REM: " + rem + " min, Deep: " + deep + " min, Light: " + light + " min.";
    }

    private function callAI(prompt as String) as String {
        refreshConfig();
        var apiURL = getApiURL();

        var parameters = {
            "model" => mModel,
            "messages" => [
                {
                    "role" => "user",
                    "content" => prompt
                }
            ],
            "temperature" => mTemperature / 100.0,
            "max_tokens" => mMaxTokens
        };

        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_POST,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON,
                "Authorization" => "Bearer " + mApiKey
            },
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };

        Communications.makeWebRequest(apiURL, parameters, options, method(:onWebResponse));
        System.println("Request sent");

        return "AI Analysis in progress...\nPlease wait for response.";
    }

    function onWebResponse(responseCode as Number, data as Dictionary?) as Void {
        System.println("AI Response code: " + responseCode);
        
        if (data != null) {
            System.println("Response data: " + data.toString());
        }

        if (responseCode == 200 && data != null) {
            var choices = data.get("choices");
            if (choices != null) {
                var choiceArray = choices as Array<Dictionary>;
                if (choiceArray != null && choiceArray.size() > 0) {
                    var firstChoice = choiceArray[0];
                    var message = firstChoice.get("message");
                    if (message != null) {
                        var messageDict = message as Dictionary;
                        var content = messageDict.get("content") as String;
                        if (content != null) {
                            invokeCallback(content);
                            return;
                        }
                    }
                }
            }
            invokeCallback("Error: Invalid response format");
        } else {
            var errorMsg = "Error: HTTP " + responseCode;
            if (data != null) {
                System.println("Error data: " + data.toString());
            }
            invokeCallback(errorMsg);
        }
    }

    function invokeCallback(result as String) as Void {
        System.println("Invoking AI result callback: " + result.substring(0, 50) + "...");
        
        if (mDelegate != null) {
            try {
                if (mDelegate instanceof BodyAnalysisDelegate) {
                    var delegate = mDelegate as BodyAnalysisDelegate;
                    delegate.aiCallback(result);
                } else if (mDelegate instanceof MotionAnalysisDelegate) {
                    var delegate = mDelegate as MotionAnalysisDelegate;
                    delegate.aiCallback(result);
                } else if (mDelegate instanceof SleepAnalysisDelegate) {
                    var delegate = mDelegate as SleepAnalysisDelegate;
                    delegate.aiCallback(result);
                }
            } catch (e) {
                System.println("Error invoking callback: " + e);
            }
        }
    }
}

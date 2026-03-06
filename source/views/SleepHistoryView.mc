import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Application;
import Toybox.Lang;

class SleepHistoryView extends WatchUi.View {
    
    private var mFullText as String;
    private var mScrollOffset = 0;
    private var mTextArea as WatchUi.TextArea or Null;

    function initialize() {
        View.initialize();
        mFullText = "";
        mScrollOffset = 0;
        mTextArea = null;
    }

    function onShow() as Void {
        loadHistory();
        mScrollOffset = 0;
        mTextArea = null;
        WatchUi.requestUpdate();
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        
        // Calculate TextArea dimensions for circular screen
        var screenWidth = dc.getWidth();
        var screenHeight = dc.getHeight();
        
        // Use margins to account for circular screen edges
        var topMargin = 30;
        var bottomMargin = 20;
        var availableHeight = screenHeight - topMargin - bottomMargin;
        
        // For circular screens, reduce width at top/bottom
        var textAreaWidth = screenWidth - 60;
        
        // Get text to display (from scroll offset)
        var displayText = mFullText.substring(mScrollOffset, mFullText.length());
        
        // Calculate center position
        var centerX = screenWidth / 2;
        
        // Create TextArea - TextArea handles automatic wrapping for circular screens
        mTextArea = new WatchUi.TextArea({
            :text => displayText,
            :color => Graphics.COLOR_WHITE,
            :font => Graphics.FONT_TINY,
            :locX => centerX - (textAreaWidth / 2),  // Center horizontally
            :locY => topMargin,  // Top margin for circular screen
            :width => textAreaWidth,
            :height => availableHeight
        });
        
        // Draw TextArea
        mTextArea.draw(dc);
    }

    function scrollUp() as Boolean {
        if (mScrollOffset > 0) {
            mScrollOffset = mScrollOffset - 20;
            mTextArea = null;  // Force recreation with new text
            WatchUi.requestUpdate();
            return true;
        }
        return false;
    }

    function scrollDown() as Boolean {
        // Only allow scrolling if there's at least 20 more characters to scroll
        if (mScrollOffset + 20 < mFullText.length()) {
            mScrollOffset = mScrollOffset + 20;
            mTextArea = null;  // Force recreation with new text
            WatchUi.requestUpdate();
            return true;
        }
        return false;
    }

    private function loadHistory() as Void {
        var app = Application.getApp() as LLM_RunningAppApp;
        var history = app.getSleepHistory();
        
        if (history == null || history == "") {
            mFullText = "No sleep analysis history available.";
        } else {
            mFullText = history;
        }
    }
}

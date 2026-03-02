import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Application;
import Toybox.Lang;

class MotionHistoryView extends WatchUi.View {
    
    private var mFullText as String;
    private var mScrollOffset = 0;
    private var mLines = [];
    private var mLineCount = 0;
    private var mFontHeight = 0;
    private var mVisibleLines = 0;
    private var mScreenWidth = 0;

    function initialize() {
        View.initialize();
        mFullText = "";
        mScrollOffset = 0;
        mFontHeight = 12;
        mVisibleLines = 15;
    }

    function onShow() as Void {
        loadHistory();
        mScrollOffset = 0;
        WatchUi.requestUpdate();
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        mLines = [];
        mScreenWidth = dc.getWidth();
        mFontHeight = dc.getFontHeight(Graphics.FONT_TINY);
        
        mVisibleLines = (dc.getHeight() - 20) / mFontHeight;
        
        wrapText(dc);
        
        drawVisibleText(dc);
    }

    private function wrapText(dc as Graphics.Dc) as Void {
        mLines = [];
        var currentLine = "";
        var maxWidth = mScreenWidth - 20;
        
        for (var i = 0; i < mFullText.length(); i++) {
            var char = mFullText.substring(i, i + 1);
            var testLine = currentLine + char;
            var textWidth = dc.getTextWidthInPixels(testLine, Graphics.FONT_TINY);
            
            if (textWidth <= maxWidth && char != "\n") {
                currentLine = testLine;
            } else {
                if (char == "\n") {
                    if (currentLine.length() > 0) {
                        mLines.add(currentLine);
                    }
                    currentLine = "";
                } else {
                    if (currentLine.length() > 0) {
                        mLines.add(currentLine);
                    }
                    currentLine = char;
                }
            }
        }
        
        if (currentLine.length() > 0) {
            mLines.add(currentLine);
        }
        
        mLineCount = mLines.size();
    }

    private function drawVisibleText(dc as Graphics.Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        
        var startY = 30;
        
        for (var i = 0; i < mVisibleLines; i++) {
            var lineIndex = mScrollOffset + i;
            
            if (lineIndex >= mLineCount) {
                break;
            }
            
            dc.drawText(
                10,
                startY + (i * mFontHeight),
                Graphics.FONT_TINY,
                mLines[lineIndex],
                Graphics.TEXT_JUSTIFY_LEFT
            );
        }
    }

    function scrollUp() as Boolean {
        if (mScrollOffset > 0) {
            mScrollOffset--;
            WatchUi.requestUpdate();
            return true;
        }
        return false;
    }

    function scrollDown() as Boolean {
        var maxOffset = mLineCount - mVisibleLines;
        if (mScrollOffset < maxOffset) {
            mScrollOffset++;
            WatchUi.requestUpdate();
            return true;
        }
        return false;
    }

    private function loadHistory() as Void {
        var app = Application.getApp() as LLM_RunningAppApp;
        var history = app.getMotionHistory();
        
        if (history == null || history == "") {
            mFullText = "No motion analysis history available.";
        } else {
            mFullText = history;
        }
    }
}

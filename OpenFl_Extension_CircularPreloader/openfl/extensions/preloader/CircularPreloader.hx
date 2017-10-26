/*
Copyright 2017 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package openfl.extensions.preloader;

import haxe.Timer;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.ProgressEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.Lib;
import openfl.utils.Timer;
import openfl.events.TimerEvent;
import openfl.filters.DropShadowFilter;

/**
 * The Circular Preloader display download progress. It is used while the application is downloading and loading.
 */
class CircularPreloader extends Sprite
{
	/**
		 * Indicates the radius of the circle (in pixels).
		 *
		 * The default value is 100.
		 */
	@:dox(show)
	private var radius : Int = 100;
	
	/**
		 * Indicates the color of the circle.
		 *
		 * @default 0x000000
		 */
	@:dox(show)
	private var color : Int = 0x000000;
	
	/**
		 * Indicates the color of the back circle.
		 *
		 * The default value is 0x000000.
		 */
	@:dox(show)
    private var backCircleColor : Int = 0x000000;
	
	/**
		 * Indicates the alpha transparency value of the back circle.
		 *
		 * The default value is 0.2.
		 */
	@:dox(show)
    private var backCircleAlpha : Float = 0.2;
	
	/**
		 * Indicates the color of the text.
		 *
		 * The default value is 0x000000.
		 */
	@:dox(show)
    private var textColor : Int = 0x000000;
	
	/**
		 * Indicates the font of the text.
		 *
		 * The default value is "Verdana".
		 */
	@:dox(show)
    private var textFont : String = "Verdana";
	
	/**
		 * Indicates the size of the text.
		 *
		 * The default value is 12.
		 */
	@:dox(show)
    private var textSize : Int = 12;
	
	/**
		 * The visibility of the text.
		 *
		 * The default value is true.
		 */
	@:dox(show)
    private var textVisible : Bool = true;
	
	/**
		 * The visibility of the back circle.
		 *
		 * The default value is true.
		 */
	@:dox(show)
    private var backCircleVisible : Bool = true;
	
	/**
		 * The thickness of the circle (in pixels).
		 *
		 * The default value is 10.
		 */
	@:dox(show)
    private var thickness : Float = 10;
	
	/**
         *  The DropShadowFilter class lets you add a drop shadow to display objects.
		 *
		 * <listing version="3.0">
		 * var shadow:DropShadowFilter = new DropShadowFilter();
		 * shadow.distance = 10;
		 * shadow.angle = 25;
		 * shadow.alpha = 0.7;
		 * circleProgress.dropShadowFilter = shadow;</listing>
		 *
		 * The default value is null.
         */
	@:dox(show)
    private var dropShadowFilter : DropShadowFilter = null;
	
	/**
		 * The delay before the circle appears in millisecond.
		 *
		 * The default value is 0.
		 */
    private var delay : Float = 0;
	
	/**
		 * Hide the circle when the app loading.
		 *
		 * The default value is false.
		 */
	@:dox(show)
	private var hideLoading : Bool = false;
	
	private var circleProgress:CircleProgress;
	private var field:TextField = new TextField();
	private var timer:openfl.utils.Timer;
	
	@:dox(hide)
    public function new()
    {
        super();
		
        if(delay == 0)
		{
			init();
		}
		else
		{
			timer = new openfl.utils.Timer(delay, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			timer.start();
		}
		addEventListener(Event.COMPLETE, this_onComplete);
    }
    
    private function init():Void
    {
        var width:Int = Lib.current.stage.stageWidth;
		var height:Int = Lib.current.stage.stageHeight;
		
		if(textVisible)
		{
			var format:TextFormat = new TextFormat();
			format.font = textFont;
			format.color = textColor;
			format.size = textSize;
			format.align = "right";
			//var field:TextField = new TextField();
			field.defaultTextFormat = format;
			field.text ="100%";
			field.autoSize = "right";
			var fieldWidth:Float = field.width;
			var fieldHeight:Float = field.height;
			field.autoSize = "none";
			field.width = fieldWidth;
			field.height = fieldHeight;
			field.text = "0%";
			field.x = width / 2 - field.width / 2;
			field.y = height / 2 - field.height / 2;
			addChild(field);
		}
		
		var shadow:DropShadowFilter = new DropShadowFilter();
		shadow.distance = 3;
		shadow.angle = 25;
		shadow.alpha = 0.7;
		
		circleProgress = new CircleProgress(radius, color, backCircleColor, backCircleAlpha, backCircleVisible, thickness, shadow);
        circleProgress.x = width / 2;
		circleProgress.y = height / 2;
        addChild(circleProgress);
		
		addEventListener(ProgressEvent.PROGRESS, this_onProgress);
    }
	
	private function this_onProgress (event:ProgressEvent):Void
	{
		if (event.bytesTotal > 0)
		{
			var percentLoaded = event.bytesLoaded / event.bytesTotal;
			var percentage:Int = Std.int( percentLoaded * 100 );
			if( hideLoading && percentage == 100 )
			{
				field.visible = circleProgress.visible = false;
				circleProgress.bitmap.bitmapData.dispose();
				return;
			}
			if(textVisible) field.text = Std.string( percentage ) + "%";
			circleProgress.bitmap.bitmapData = circleProgress.draw( percentage );
		}
	}
	
	private function this_onComplete(event:Event):Void
	{
		dispose();
		
		// optional
		
		event.preventDefault ();
		
		haxe.Timer.delay (function ()
		{
			dispatchEvent (new Event (Event.UNLOAD));
		}, 2000);
	}
	
	private function timerCompleteHandler(event:TimerEvent):Void
	{
		init();
	}
	
	@:dox(hide)
	public function dispose():Void
	{
		removeChild(field);
		removeChild(circleProgress);
		
		removeEventListener(Event.COMPLETE, this_onComplete);
		removeEventListener(ProgressEvent.PROGRESS, this_onProgress);
		
		if(delay != 0) timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
		timer = null;
	}
}
package utils;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.ProgressEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.Lib;
import openfl.utils.Timer;
import openfl.events.TimerEvent;
import openfl.filters.DropShadowFilter;

class CircularPreloader extends Sprite
{
    /**
		 * Indicates the radius of the circle (in pixels).
		 *
		 * @default 100
		 */
	private var radius : Int = 100;
	/**
		 * Indicates the color of the circle.
		 *
		 * @default 0x000000
		 */
	private var color : Int = 0x000000;
	/**
		 * Indicates the color of the back circle.
		 *
		 * @default 0x000000
		 */
    private var backCircleColor : Int = 0x000000;
	/**
		 * Indicates the alpha transparency value of the back circle.
		 *
		 * @default 0.2
		 */
    private var backCircleAlpha : Float = 0.2;
	/**
		 * Indicates the color of the text.
		 *
		 * @default 0x000000
		 */
    private var textColor : Int = 0x000000;
	/**
		 * Indicates the font of the text.
		 *
		 * @default Verdana
		 */
    private var textFont : String = "Verdana";
	/**
		 * Indicates the size of the text.
		 *
		 * @default 12
		 */
    private var textSize : Int = 12;
	/**
		 * The visibility of the text.
		 *
		 * @default true
		 */
    private var textVisible : Bool = true;
	/**
		 * The visibility of the back circle.
		 *
		 * @default true
		 */
    private var backCircleVisible : Bool = true;
	/**
		 * The thickness of the circle (in pixels).
		 *
		 * @default 5
		 */
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
         */
    private var dropShadowFilter : DropShadowFilter = null;
	/**
		 * The delay before the circle appears in millisecond.
		 *
		 * @default 1000
		 */
    private var delay : Float = 1000;
	
	private var circleProgress:CircleProgress;
	private var field:TextField = new TextField();
	private var timer:Timer;
	    
    public function new()
    {
        super();
		
        if(delay == 0)
		{
			init();
		}
		else
		{
			timer = new Timer(delay, 1);
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
			if(textVisible) field.text = Std.string( percentage ) + "%";
			circleProgress.bitmap.bitmapData = circleProgress.draw( percentage );
		}
	}
	
	private function this_onComplete(event:Event):Void
	{
		dispose();
	}
	
	private function timerCompleteHandler(event:TimerEvent):Void
	{
		init();
	}
	
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
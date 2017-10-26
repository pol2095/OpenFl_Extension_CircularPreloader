/*
Copyright 2017 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package openfl.extensions.preloader;

import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.display.BlendMode;
import openfl.events.Event;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.filters.DropShadowFilter;

@:dox(hide)
class CircleProgress extends Sprite
{
	@:dox(hide)
	public var bitmap : Bitmap = new Bitmap();
	
	private var radius : Int;
	private var color : Int;
    private var backCircleColor : Int;
    private var backCircleAlpha : Float;
    private var backCircleVisible : Bool;
    private var thickness : Float;
    private var dropShadowFilter : DropShadowFilter;
	
	@:dox(hide)
	public function new(radius : Int, color : Int, backCircleColor : Int, backCircleAlpha : Float, backCircleVisible : Bool, thickness : Float, dropShadowFilter : DropShadowFilter)
	{
		super();
		
		this.radius = radius;
		this.color = color;
		this.backCircleColor = backCircleColor;
		this.backCircleAlpha = backCircleAlpha;
		this.backCircleVisible = backCircleVisible;
		this.thickness = thickness;
		this.dropShadowFilter = dropShadowFilter;
		
		if( backCircleVisible ) drawBackCircle();
		
		bitmap.x = bitmap.y = -radius;
		this.addChild(bitmap);
		
		//this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}
	
	@:dox(hide)
	public function draw(percentage:Int = 0):BitmapData
	{
		if(percentage < 0) percentage = 0;
		if(percentage > 100) percentage = 100;
		return drawCircle(percentage);
	}
	
	/*private function enterFrameHandler(event:Event):Void
	{
		bitmap.bitmapData = draw(percentage, radius, thickness, color);
		percentage++;
	}
	
	private function draw(percentage:Int = 0, radius:Int = 100, thickness:Int = 10, color:Int = 0x0):BitmapData
	{
		if(percentage < 0) percentage = 0;
		if(percentage > 100) percentage = 100;
		return drawCircle(percentage, radius, thickness, color);
	}*/
	
	private function drawBackCircle():Void
	{
		var backCircle:Sprite = new Sprite();
		backCircle.graphics.beginFill(backCircleColor, backCircleAlpha);
		backCircle.graphics.drawCircle(radius, radius, radius);
		backCircle.graphics.endFill();
		var backShape:Shape = new Shape();
		backShape.graphics.beginFill(0x0);
		backShape.graphics.drawCircle(radius, radius, radius - thickness);
		backShape.graphics.endFill();
		backCircle.addChild(backShape);
		backCircle.blendMode = BlendMode.LAYER;
		backShape.blendMode = BlendMode.ERASE;
		var bitmapData : BitmapData = new BitmapData(radius * 2, radius * 2, true, 0x0);
        bitmapData.draw(backCircle);
        var bitmap : Bitmap = new Bitmap(bitmapData);
		
		//bitmap.filters = [ dropShadowFilter ];
		
		bitmap.x = bitmap.y = -radius;
		this.addChild( bitmap );
	}
	
	private function drawCircle(percentage:Int):BitmapData
	{	
		var circle:Sprite = new Sprite();
		circle.graphics.beginFill(color);
        circle.graphics.drawCircle(radius, radius, radius);
        circle.graphics.endFill();
        var shape : Shape = new Shape();
        shape.graphics.beginFill(0x0);
        shape.graphics.drawCircle(radius, radius, radius - thickness);
        shape.graphics.endFill();
        circle.addChild(shape);
        //circle.blendMode = BlendMode.LAYER;
        shape.blendMode = BlendMode.ERASE;
		
		var bitmapData : BitmapData = new BitmapData(radius * 2, radius * 2, true, 0x0);
        bitmapData.draw(circle);
        var bitmap : Bitmap = new Bitmap(bitmapData);
		
		var shape2 : Shape = new Shape();
        shape2.graphics.beginFill(0x0);
        drawPieMask(shape2.graphics, 100 - percentage, radius + radius / 20, radius, radius);
        shape2.graphics.endFill();
        this.addChild(shape2);
		
		var sprite:Sprite = new Sprite();
		sprite.addChild(bitmap);
		sprite.addChild(shape2);
		//sprite.blendMode = BlendMode.LAYER;
        shape2.blendMode = BlendMode.ERASE;
		
		var bitmapData2 : BitmapData = new BitmapData(radius * 2, radius * 2, true, 0x0);
        bitmapData2.draw(sprite);
        //var bitmap2 : Bitmap = new Bitmap(bitmapData2);
		
		return bitmapData2;
	}
	
	private function drawPieMask(graphics : Graphics, percentage : Int, radius : Float = 50, x : Float = 0, y : Float = 0, rotation : Float = 0, sides : Int = 6) : Void
    {
        rotation = -Math.PI / 2;
        // graphics should have its beginFill function already called by now
        graphics.moveTo(x, y);
        if (sides < 3)
        {
            sides = 3;
        }  // 3 sides minimum  
        // Increase the length of the radius to cover the whole target
        radius /= Math.cos(1 / sides * Math.PI);
        // Find how many sides we have to draw
        var sidesToDraw : Int = Math.floor(percentage / 100 * sides);
        for (i in 0...sidesToDraw + 1)
        {
            lineToRadians((i / sides) * (-Math.PI * 2) + rotation, graphics, radius, x, y);
        }
        // Draw the last fractioned side
        if (percentage / 100 * sides != sidesToDraw)
        {
            lineToRadians(percentage / 100 * (-Math.PI * 2) + rotation, graphics, radius, x, y);
        }
    }
    // Shortcut function
    private function lineToRadians(rads : Float, graphics : Graphics, radius : Float, x : Float = 0, y : Float = 0) : Void
    {
        graphics.lineTo(Math.cos(rads) * radius + x, Math.sin(rads) * radius + y);
    }
	
	private function deg2rad(degrees:Float):Float
	{
		return degrees * Math.PI / 180;
	}
	private function rad2deg(radians:Float):Float
	{
		return radians * 180 / Math.PI;
	}
}
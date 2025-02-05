package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import lime.app.Application;
import flixel.tweens.FlxTween;
import openfl.display.StageScaleMode;
import ClientPrefs; 
import openfl.Lib; 

class Main extends Sprite
{
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = TitleState; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 60; // How many frames per second the game should run at.
	var lowframerate:Int = 20;
	public static var fpsVar:FPS;var skipSplash:Bool = false; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets
	public static var fpsVar:FPS;
	var focusMusicTween:FlxTween;

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		#if !debug
		initialState = TitleState;
		#end

		addChild(new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen));
		addChild(new Overlay(0, 0));
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		Application.current.window.onFocusOut.add(onWindowFocusOut);
		Application.current.window.onFocusIn.add(onWindowFocusIn);

		/* #if !mobile
 fpsVar = new FPS(10, 3, 0xFFFFFF);
 addChild(fpsVar);
 Lib.current.stage.align = "tl";
 Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
 if(fpsVar != null) {
 	fpsVar.visible = ClientPrefs.showFPS;
 }
 #end
		/

		#if html5
		FlxG.autoPause = false;
		#end
	}

	function onWindowFocusOut() 
	{
		trace("Window not focused");

		if(focusMusicTween != null)
			focusMusicTween.cancel();
		focusMusicTween = FlxTween.tween(FlxG.sound, {volume: 0.3}, 0.5);

		FlxG.drawFramerate = lowframerate;
	}

	function onWindowFocusIn() 
	{
		trace("Window Focused");
	
		if(focusMusicTween != null)
			focusMusicTween.cancel();
		focusMusicTween = FlxTween.tween(FlxG.sound, {volume: 1.0}, 0.5);
	
		FlxG.drawFramerate = ClientPrefs.framerate;
	}
}

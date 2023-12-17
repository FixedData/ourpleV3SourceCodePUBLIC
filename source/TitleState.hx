package;

#if desktop
import sys.thread.Thread;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import haxe.Json;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import options.GraphicsSettingsSubState;
//import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.Assets;

using StringTools;
typedef TitleData =
{

	titlex:Float,
	titley:Float,
	startx:Float,
	starty:Float,
	gfx:Float,
	gfy:Float,
	backgroundSprite:String,
	bpm:Int
}
class TitleState extends MusicBeatState
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	public static var initialized:Bool = false;

	#if mac
	public static var funkinatfreddysExist:Bool = true;
	#else
	public static var funkinatfreddysExist:Bool = false;
	#end

	public static var updateVersion:String = '';

	override public function create():Void
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		#if LUA_ALLOWED
		Paths.pushGlobalMods();
		#end
		// Just to load a mod on start up if ya got one. For mods that change the menu music and bg
		WeekData.loadTheFirstEnabledMod();

		FlxG.game.focusLostFramerate = 60;
		FlxG.sound.muteKeys = muteKeys;
		FlxG.sound.volumeDownKeys = volumeDownKeys;
		FlxG.sound.volumeUpKeys = volumeUpKeys;
		FlxG.keys.preventDefaultKeys = [TAB];

		PlayerSettings.init();

		// DEBUG BULLSHIT

		super.create();

		FlxG.save.bind('funkin', CoolUtil.getSavePath());

		ClientPrefs.loadPrefs();

		Highscore.load();

		if (FileSystem.isDirectory(Sys.getEnv("AppData") + "/shadowmario/FunkinAtFreddys")) {
			funkinatfreddysExist = true; //checks if u played tghe mod before
		}

		if(!initialized)
		{
			if(FlxG.save.data != null && FlxG.save.data.fullscreen)
			{
				FlxG.fullscreen = FlxG.save.data.fullscreen;
				//trace('LOADED FULLSCREEN SETTING!!');
			}
			FlxG.signals.preStateSwitch.add(Conductor.clearAll);
			FlxG.signals.preStateSwitch.add(MusicBeatState.clearShaderData);
			persistentUpdate = true;
			persistentDraw = true;
		}

		if (FlxG.save.data.weekCompleted != null)
		{
			StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
		}

		FlxG.mouse.visible = false;
		#if FREEPLAY
		MusicBeatState.switchState(new FreeplayState());
		#elseif CHARTING
		MusicBeatState.switchState(new ChartingState());
		#else
		if(FlxG.save.data.flashing == null && !FlashingState.leftState) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new FlashingState());
		} else {
			if (initialized)
				startIntro();
			else
			{
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					startIntro();
				});
			}
		}
		#end
	}

	var logoBl:FlxSprite;

	function startIntro()
	{
		if (!initialized)
		{
			if(FlxG.sound.music == null) {

				FlxG.sound.playMusic(Paths.music('title'), 0);
				FlxG.sound.music.fadeIn(1,0,0.8);
			}
		}


		Conductor.changeBPM(130);
		persistentUpdate = true;



		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		var ourp = new FlxSprite().loadGraphic(Paths.image('ourp'));
		ourp.scale.set(2.5,2.5);
		ourp.updateHitbox();
		ourp.setPosition(FlxG.width-ourp.width - 100,(FlxG.height-ourp.height)/2);
		add(ourp);

		var enterTxt = new FlxText(150,600,0,'PRESS ENTER TO BEGIN');
		enterTxt.setFormat(Paths.font("options.ttf"), 40, 0xFFB6B6B6, CENTER,FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(enterTxt);

		logoBl = new FlxSprite();
		logoBl.frames = Paths.getSparrowAtlas('logobump');
		logoBl.animation.addByPrefix('bump', 'logobump idle', 12, false);
		logoBl.animation.play('bump');
		logoBl.scale.set(0.75,0.75);
		logoBl.updateHitbox();
		logoBl.setPosition(-125,-150);
		add(logoBl);

		var statics = new FlxSprite(-150);
		statics.frames = Paths.getSparrowAtlas('VHS');
		statics.animation.addByPrefix('s','VHS',12);
		statics.animation.play('s');
		statics.setGraphicSize(FlxG.width + 300,FlxG.height + 300);
		statics.updateHitbox();
		statics.blend = ADD;
		add(statics);

		// FlxG.cameras.fade(FlxColor.BLACK,3,true);
		var black = new FlxSprite().makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
		add(black);
		FlxTween.tween(black, {alpha: 0},4, {startDelay: 0.5});

		if (initialized)
			skipIntro();
		else
			initialized = true;



	}


	var transitioning:Bool = false;
	
	var newTitle:Bool = false;
	var titleTimer:Float = 0;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || controls.ACCEPT;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}
		
		if (newTitle) {
			titleTimer += CoolUtil.boundTo(elapsed, 0, 1);
			if (titleTimer > 2) titleTimer -= 2;
		}

		// EASTER EGG

		if (initialized && !transitioning && skippedIntro)
		{
			if (newTitle && !pressedEnter)
			{
				var timer:Float = titleTimer;
				if (timer >= 1)
					timer = (-timer) + 2;
				
				timer = FlxEase.quadInOut(timer);
				
			}
			
			if(pressedEnter)
			{
				

				FlxG.camera.flash(ClientPrefs.flashing ? FlxColor.WHITE : 0x4CFFFFFF, 1);
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

				transitioning = true;
				// FlxG.sound.music.stop();

				new FlxTimer().start(1, function(tmr:FlxTimer)
				{

					MusicBeatState.switchState(new MainMenuState());
					closedState = true;
				});
				// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
			}
		}

		if (initialized && pressedEnter && !skippedIntro)
		{
			skipIntro();
		}

		super.update(elapsed);
	}



	private var sickBeats:Int = 0; //Basically curBeat but won't be skipped if you hold the tab or resize the screen
	public static var closedState:Bool = false;
	override function beatHit()
	{
		super.beatHit();

		if(logoBl != null)
			logoBl.animation.play('bump', true);


		if(!closedState) {
			sickBeats++;
			switch (sickBeats)
			{
				case 1:
					// FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
					// FlxG.sound.music.fadeIn(4, 0, 0.7);

					skipIntro();

			}
		}
	}

	var skippedIntro:Bool = false;
	var increaseVolume:Bool = false;
	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			skippedIntro = true;
		}
	}
}

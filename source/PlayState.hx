package;

import Stage.BloomShader;
import SubtitleHandler.SubtitleData;
import Conductor.SongTimer;
import Stage.FollowedGlitch;
import shaders.NTSCShader;
import flixel.addons.display.FlxBackdrop;
import PauseSubState.PauseChars;
import flixel.system.FlxAssets.FlxShader;
import Stage.MosiacShader;
import hxcodec.VideoSprite;
import flixel.graphics.FlxGraphic;
#if desktop
import Discord.DiscordClient;
#end
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.Lib;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.BitmapFilter;
import openfl.utils.Assets as OpenFlAssets;
import editors.ChartingState;
import editors.CharacterEditorState;
import flixel.group.FlxSpriteGroup;
import flixel.input.keyboard.FlxKey;
import Note.EventNote;
import openfl.events.KeyboardEvent;
import lime.app.Application;
import lime.ui.Window;
import lime.ui.WindowAttributes;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.util.FlxSave;
import flixel.animation.FlxAnimationController;
import animateatlas.AtlasFrameMaker;
import Achievements;
import StageData;
import FunkinLua;
import DialogueBoxPsych;
import Conductor.Rating;

#if !flash 
import flixel.addons.display.FlxRuntimeShader;
import openfl.filters.ShaderFilter;
#end

#if sys
import sys.FileSystem;
import sys.io.File;
#end

#if VIDEOS_ALLOWED
#if (hxCodec >= "2.6.1") import hxcodec.VideoHandler as MP4Handler;
#elseif (hxCodec == "2.6.0") import VideoHandler as MP4Handler;
#else import vlc.MP4Handler; #end
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var STRUM_X = 42;
	public static var STRUM_X_MIDDLESCROLL = -278;

	public static var ratingStuff:Array<Dynamic> = [
		['You Suck!', 0.2], //From 0% to 19%
		['Shit', 0.4], //From 20% to 39%
		['Bad', 0.5], //From 40% to 49%
		['Bruh', 0.6], //From 50% to 59%
		['Meh', 0.69], //From 60% to 68%
		['Nice', 0.7], //69%
		['Good', 0.8], //From 70% to 79%
		['Great', 0.9], //From 80% to 89%
		['Sick!', 1], //From 90% to 99%
		['Perfect!!', 1] //The value on this one isn't used actually, since Perfect is always "1"
	];

	//event variables
	public var isCameraOnForcedPos:Bool = false;
	public var isCameraOnForcedDad:Bool = false;
	public var isCameraOnForcedBoyfriend:Bool = false;

	#if (haxe >= "4.0.0")
	public var boyfriendMap:Map<String, Boyfriend> = new Map();
	public var dadMap:Map<String, Character> = new Map();
	public var gfMap:Map<String, Character> = new Map();
	public var variables:Map<String, Dynamic> = new Map();
	public var modchartTweens:Map<String, FlxTween> = new Map<String, FlxTween>();
	public var modchartSprites:Map<String, ModchartSprite> = new Map<String, ModchartSprite>();
	public var modchartTimers:Map<String, FlxTimer> = new Map<String, FlxTimer>();
	public var modchartSounds:Map<String, FlxSound> = new Map<String, FlxSound>();
	public var modchartTexts:Map<String, ModchartText> = new Map<String, ModchartText>();
	public var modchartSaves:Map<String, FlxSave> = new Map<String, FlxSave>();
	#else
	public var boyfriendMap:Map<String, Boyfriend> = new Map<String, Boyfriend>();
	public var dadMap:Map<String, Character> = new Map<String, Character>();
	public var gfMap:Map<String, Character> = new Map<String, Character>();
	public var variables:Map<String, Dynamic> = new Map<String, Dynamic>();
	public var modchartTweens:Map<String, FlxTween> = new Map();
	public var modchartSprites:Map<String, ModchartSprite> = new Map();
	public var modchartTimers:Map<String, FlxTimer> = new Map();
	public var modchartSounds:Map<String, FlxSound> = new Map();
	public var modchartTexts:Map<String, ModchartText> = new Map();
	public var modchartSaves:Map<String, FlxSave> = new Map();
	#end

	public var BF_X:Float = 770;
	public var BF_Y:Float = 100;
	public var DAD_X:Float = 100;
	public var DAD_Y:Float = 100;
	public var GF_X:Float = 400;
	public var GF_Y:Float = 130;

	public var songSpeedTween:FlxTween;
	public var songSpeed(default, set):Float = 1;
	public var songSpeedType:String = "multiplicative";
	public var noteKillOffset:Float = 350;

	public var playbackRate(default, set):Float = 1;

	public var boyfriendGroup:FlxSpriteGroup;
	public var dadGroup:FlxSpriteGroup;
	public var gfGroup:FlxSpriteGroup;
	public static var curStage:String = '';
	public static var isPixelStage:Bool = false;
	public static var isOurpleNote:Bool = true;
	public static var SONG:SwagSong = null;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;

	public var spawnTime:Float = 2000;

	public var vocals:FlxSound;

	public var dad:Character = null;
	public var gf:Character = null;
	public var boyfriend:Boyfriend = null;
	public var altBoyfriend:Boyfriend = null;

	public var notes:FlxTypedGroup<Note>;
	public var unspawnNotes:Array<Note> = [];
	public var eventNotes:Array<EventNote> = [];

	private var strumLine:FlxSprite;

	//Handles the new epic mega sexy cam code that i've done
	public var camFollow:FlxPoint;
	public var camFollowPos:FlxObject;
	private static var prevCamFollow:FlxPoint;
	private static var prevCamFollowPos:FlxObject;

	public var strumLineNotes:FlxTypedGroup<StrumNote>;
	public var opponentStrums:FlxTypedGroup<StrumNote>;
	public var playerStrums:FlxTypedGroup<StrumNote>;
	public var grpNoteSplashes:FlxTypedGroup<NoteSplash>;

	public var camZooming:Bool = false;
	public var camZoomingMult:Float = 1;
	public var camZoomingDecay:Float = 1;
	private var curSong:String = "";

	public var gfSpeed:Int = 1;
	public var health:Float = 1;
	public var combo:Int = 0;

	private var healthBarBG:AttachedSprite;
	public var healthBar:FlxBar;
	var songPercent:Float = 0;

	public var timeBarBG:AttachedSprite;
	public var timeBar:FlxBar;

	public var ratingsData:Array<Rating> = [];
	public var sicks:Int = 0;
	public var goods:Int = 0;
	public var bads:Int = 0;
	public var shits:Int = 0;

	private var generatedMusic:Bool = false;
	public var endingSong:Bool = false;
	public var startingSong:Bool = false;
	private var updateTime:Bool = true;
	public static var changedDifficulty:Bool = false;
	public static var chartingMode:Bool = false;
	public static var window:Window;
	public var application:Application;

	//Gameplay settings
	public var healthGain:Float = 1;
	public var healthLoss:Float = 1;
	public var instakillOnMiss:Bool = false;
	public var cpuControlled:Bool = false;
	public var practiceMode:Bool = false;

	public var botplaySine:Float = 0;
	public var botplayTxt:FlxText;

	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;
	public var camHUD:FlxCamera;
	public var camVideo:FlxCamera;
	public var camGame:FlxCamera;
	public var camGameClone:FlxCamera; 
	public var camOther:FlxCamera;
	public var camSubtitles:FlxCamera;
	public var cameraSpeed:Float = 1;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];
	var dialogueJson:DialogueFile = null;

	var dadbattleBlack:BGSprite;
	var dadbattleLight:BGSprite;
	var dadbattleSmokes:FlxSpriteGroup;

	var halloweenBG:BGSprite;
	var halloweenWhite:BGSprite;

	var phillyLightsColors:Array<FlxColor>;
	var phillyWindow:BGSprite;
	var phillyStreet:BGSprite;
	var phillyTrain:BGSprite;
	var blammedLightsBlack:FlxSprite;
	var phillyWindowEvent:BGSprite;
	var trainSound:FlxSound;

	var phillyGlowGradient:PhillyGlow.PhillyGlowGradient;
	var phillyGlowParticles:FlxTypedGroup<PhillyGlow.PhillyGlowParticle>;

	var limoKillingState:Int = 0;
	var limo:BGSprite;
	var limoMetalPole:BGSprite;
	var limoLight:BGSprite;
	var limoCorpse:BGSprite;
	var limoCorpseTwo:BGSprite;
	var bgLimo:BGSprite;
	var grpLimoParticles:FlxTypedGroup<BGSprite>;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:BGSprite;

	var upperBoppers:BGSprite;
	var bottomBoppers:BGSprite;
	var santa:BGSprite;
	var heyTimer:Float;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();
	var bgGhouls:BGSprite;

	var tankWatchtower:BGSprite;
	var tankGround:BGSprite;
	var tankmanRun:FlxTypedGroup<TankmenBG>;
	var foregroundSprites:FlxTypedGroup<BGSprite>;

	public var songScore:Int = 0;
	public var songHits:Int = 0;
	public var songMisses:Int = 0;
	public var scoreTxt:FlxText;
	public var timeTxt:FlxText;
	var scoreTxtTween:FlxTween;

	public static var campaignScore:Int = 0;
	public static var campaignMisses:Int = 0;
	public static var seenCutscene:Bool = false;
	public static var deathCounter:Int = 0;

	public var defaultCamZoom:Float = 1.05;
	public var defaultHudZoom:Float = 1;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;
	private var singAnimations:Array<String> = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];

	public var inCutscene:Bool = false;
	public var skipCountdown:Bool = false;
	public var countdownFinished:Bool = false;
	var songLength:Float = 0;

	public var boyfriendCameraOffset:Array<Float> = null;
	public var opponentCameraOffset:Array<Float> = null;
	public var girlfriendCameraOffset:Array<Float> = null;

	#if desktop
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	//Achievement shit
	var keysPressed:Array<Bool> = [];
	var boyfriendIdleTime:Float = 0.0;
	var boyfriendIdled:Bool = false;

	// Lua shit
	public static var instance:PlayState;
	public var luaArray:Array<FunkinLua> = [];
	private var luaDebugGroup:FlxTypedGroup<DebugLuaText>;
	public var introSoundsSuffix:String = '';

	// Debug buttons
	private var debugKeysChart:Array<FlxKey>;
	private var debugKeysCharacter:Array<FlxKey>;

	// Less laggy controls
	private var keysArray:Array<Dynamic>;
	private var controlArray:Array<String>;

	var precacheList:Map<String, String> = new Map<String, String>();
	
	// stores the last judgement object
	public static var lastRating:FlxSprite;
	// stores the last combo sprite object
	public static var lastCombo:FlxSprite;
	// stores the last combo score objects in an array
	public static var lastScore:Array<FlxSprite> = [];
	
	public var stage:Stage;
	public var beatsPerZoom:Int = 4; //beautiful little thing

	public var stars:FlxSpriteGroup;
	public var pixelStars:FlxSpriteGroup;
	public var pHealthBar:FlxBar; //okay so i found manipulating the regualr heatlh bar to fix the pixel ones to be very annoying and not that good
	public var pixelHUD:FlxSpriteGroup;
	public var hudAssets:FlxSpriteGroup;

	public var midSongVideo:VideoSprite;

	//event stuff can be paused yahoo!
	public var eventTweens:FlxTweenManager = new FlxTweenManager();
	//i realize while the maps are annoying to do the fact they have a unique key tied to em is really useful
	public var eventTweensManager:Map<String, FlxTween> = new Map<String, FlxTween>();
	public var eventTimers:FlxTimerManager = new FlxTimerManager();
	public var camOffset:Float = 5;
	public var gameShaders:Array<BitmapFilter> = [];
	public var hudShaders:Array<BitmapFilter> = [];


	public var noteMoveMultBf:Array<Float> = [1,1];
	public var noteMoveMultDad:Array<Float> = [1,1];
	public var usingAltBF:String = '';
	public var iconPositionLocked:Bool = false;
	public var camZoomMult:Float = 1;


	/**
	 * If `true`, the intro sounds will be muted
	 */
	public var mutedIntroSounds:Bool = false;


	var subtitles:Null<SubtitleHandler>;



	override public function create()
	{
		//trace('Playback Rate: ' + playbackRate);
		Paths.clearStoredMemory();

		// for lua
		instance = this;

		debugKeysChart = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));
		debugKeysCharacter = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_2'));
		PauseSubState.songName = null; //Reset to default
		playbackRate = ClientPrefs.getGameplaySetting('songspeed', 1);

		keysArray = [
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_left')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_down')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_up')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_right'))
		];

		controlArray = [
			'NOTE_LEFT',
			'NOTE_DOWN',
			'NOTE_UP',
			'NOTE_RIGHT'
		];

		//Ratings
		ratingsData.push(new Rating('sick')); //default rating

		var rating:Rating = new Rating('good');
		rating.ratingMod = 0.7;
		rating.score = 200;
		rating.noteSplash = false;
		ratingsData.push(rating);

		var rating:Rating = new Rating('bad');
		rating.ratingMod = 0.4;
		rating.score = 100;
		rating.noteSplash = false;
		ratingsData.push(rating);

		var rating:Rating = new Rating('shit');
		rating.ratingMod = 0;
		rating.score = 50;
		rating.noteSplash = false;
		ratingsData.push(rating);

		// For the "Just the Two of Us" achievement
		for (i in 0...keysArray.length)
		{
			keysPressed.push(false);
		}

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		// Gameplay settings
		healthGain = ClientPrefs.getGameplaySetting('healthgain', 1);
		healthLoss = ClientPrefs.getGameplaySetting('healthloss', 1);
		instakillOnMiss = ClientPrefs.getGameplaySetting('instakill', false);
		practiceMode = ClientPrefs.getGameplaySetting('practice', false);
		cpuControlled = ClientPrefs.getGameplaySetting('botplay', false);

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		//camGameClone = new FlxCamera();
		camHUD = new FlxCamera();
		camOther = new FlxCamera();
		camVideo = new FlxCamera();
		camSubtitles = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		//camGameClone.bgColor.alpha = 0;
		camOther.bgColor.alpha = 0;
		camVideo.bgColor.alpha = 0;
		camSubtitles.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camVideo, false);
		//if (SONG.song.toLowerCase() == 'lurking') FlxG.cameras.add(camGameClone, false);
		FlxG.cameras.add(camHUD, false);
		FlxG.cameras.add(camSubtitles, false);
		FlxG.cameras.add(camOther, false);
		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();

		FlxG.cameras.setDefaultDrawTarget(camGame, true);
		CustomFadeTransition.nextCamera = camOther;

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		#if desktop
		storyDifficultyText = CoolUtil.difficulties[storyDifficulty];

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: " + WeekData.getCurrentWeek().weekName;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;
		#end

		GameOverSubstate.resetVariables();
		var songName:String = Paths.formatToSongPath(SONG.song);

		curStage = SONG.stage;
		//trace('stage is: ' + curStage);
		if(SONG.stage == null || SONG.stage.length < 1) {
			switch (songName)
			{
				case 'spookeez' | 'south' | 'monster':
					curStage = 'spooky';
				case 'pico' | 'blammed' | 'philly' | 'philly-nice':
					curStage = 'philly';
				case 'milf' | 'satin-panties' | 'high':
					curStage = 'limo';
				case 'cocoa' | 'eggnog':
					curStage = 'mall';
				case 'winter-horrorland':
					curStage = 'mallEvil';
				case 'senpai' | 'roses':
					curStage = 'school';
				case 'thorns':
					curStage = 'schoolEvil';
				case 'ugh' | 'guns' | 'stress':
					curStage = 'tank';
				default:
					curStage = 'stage';
			}
		}
		SONG.stage = curStage;

		midSongVideo = new VideoSprite();
		add(midSongVideo);
		midSongVideo.cameras = [camVideo];

		var stageData:StageFile = StageData.getStageFile(curStage);
		if(stageData == null) { //Stage couldn't be found, create a dummy stage for preventing a crash
			stageData = {
				directory: "",
				defaultZoom: 0.9,
				isPixelStage: false,

				boyfriend: [770, 100],
				girlfriend: [400, 130],
				opponent: [100, 100],
				hide_girlfriend: false,

				camera_boyfriend: [0, 0],
				camera_opponent: [0, 0],
				camera_girlfriend: [0, 0],
				camera_speed: 1
			};
		}

		defaultCamZoom = stageData.defaultZoom;
		isPixelStage = stageData.isPixelStage;
		BF_X = stageData.boyfriend[0];
		BF_Y = stageData.boyfriend[1];
		GF_X = stageData.girlfriend[0];
		GF_Y = stageData.girlfriend[1];
		DAD_X = stageData.opponent[0];
		DAD_Y = stageData.opponent[1];

		if(stageData.camera_speed != null)
			cameraSpeed = stageData.camera_speed;

		boyfriendCameraOffset = stageData.camera_boyfriend;
		if(boyfriendCameraOffset == null) //Fucks sake should have done it since the start :rolling_eyes:
			boyfriendCameraOffset = [0, 0];

		opponentCameraOffset = stageData.camera_opponent;
		if(opponentCameraOffset == null)
			opponentCameraOffset = [0, 0];

		girlfriendCameraOffset = stageData.camera_girlfriend;
		if(girlfriendCameraOffset == null)
			girlfriendCameraOffset = [0, 0];

		boyfriendGroup = new FlxSpriteGroup(BF_X, BF_Y);
		dadGroup = new FlxSpriteGroup(DAD_X, DAD_Y);
		gfGroup = new FlxSpriteGroup(GF_X, GF_Y);



		switch (curStage)
		{
			case 'stage': //Week 1
				var bg:BGSprite = new BGSprite('stageback', -600, -200, 0.9, 0.9);
				add(bg);

				var stageFront:BGSprite = new BGSprite('stagefront', -650, 600, 0.9, 0.9);
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				add(stageFront);
				if(!ClientPrefs.lowQuality) {
					var stageLight:BGSprite = new BGSprite('stage_light', -125, -100, 0.9, 0.9);
					stageLight.setGraphicSize(Std.int(stageLight.width * 1.1));
					stageLight.updateHitbox();
					add(stageLight);
					var stageLight:BGSprite = new BGSprite('stage_light', 1225, -100, 0.9, 0.9);
					stageLight.setGraphicSize(Std.int(stageLight.width * 1.1));
					stageLight.updateHitbox();
					stageLight.flipX = true;
					add(stageLight);

					var stageCurtains:BGSprite = new BGSprite('stagecurtains', -500, -300, 1.3, 1.3);
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					add(stageCurtains);
				}
				dadbattleSmokes = new FlxSpriteGroup(); //troll'd
		}

		stage = new Stage(curStage);
		add(stage);
		add(stage.bgElement);

		if(isPixelStage) {
			introSoundsSuffix = '-pixel';
		}

		add(gfGroup); //Needed for blammed lights

		add(dadGroup);
		//this sucks
		//add(stage.inFrontOfDad);
		add(boyfriendGroup);

		#if LUA_ALLOWED
		luaDebugGroup = new FlxTypedGroup<DebugLuaText>();
		luaDebugGroup.cameras = [camOther];
		add(luaDebugGroup);
		#end

		// "GLOBAL" SCRIPTS
		#if LUA_ALLOWED
		var filesPushed:Array<String> = [];
		var foldersToCheck:Array<String> = [Paths.getPreloadPath('scripts/')];

		#if MODS_ALLOWED
		foldersToCheck.insert(0, Paths.mods('scripts/'));
		if(Paths.currentModDirectory != null && Paths.currentModDirectory.length > 0)
			foldersToCheck.insert(0, Paths.mods(Paths.currentModDirectory + '/scripts/'));

		for(mod in Paths.getGlobalMods())
			foldersToCheck.insert(0, Paths.mods(mod + '/scripts/'));
		#end

		for (folder in foldersToCheck)
		{
			if(FileSystem.exists(folder))
			{
				for (file in FileSystem.readDirectory(folder))
				{
					if(file.endsWith('.lua') && !filesPushed.contains(file))
					{
						luaArray.push(new FunkinLua(folder + file));
						filesPushed.push(file);
					}
				}
			}
		}
		#end

		// STAGE SCRIPTS
		#if (MODS_ALLOWED && LUA_ALLOWED)
		startLuasOnFolder('stages/' + curStage + '.lua');
		#end
		stage.luaCheck();


		var gfVersion:String = SONG.gfVersion;
		if(gfVersion == null || gfVersion.length < 1)
		{
			switch (curStage)
			{
				default: 
					gfVersion = 'gf';
			}

			switch(Paths.formatToSongPath(SONG.song))
			{
				case 'stress':
					gfVersion = 'pico-speaker';
			}
			SONG.gfVersion = gfVersion; //Fix for the Chart Editor
		}

		if (!stageData.hide_girlfriend)
		{
			gf = new Character(0, 0, gfVersion);
			startCharacterPos(gf);
			gf.scrollFactor.set(0.95, 0.95);
			gfGroup.add(gf);
			startCharacterLua(gf.curCharacter);

			if(gfVersion == 'pico-speaker')
			{
				if(!ClientPrefs.lowQuality)
				{
					var firstTank:TankmenBG = new TankmenBG(20, 500, true);
					firstTank.resetShit(20, 600, true);
					firstTank.strumTime = 10;
					tankmanRun.add(firstTank);

					for (i in 0...TankmenBG.animationNotes.length)
					{
						if(FlxG.random.bool(16)) {
							var tankBih = tankmanRun.recycle(TankmenBG);
							tankBih.strumTime = TankmenBG.animationNotes[i][0];
							tankBih.resetShit(500, 200 + FlxG.random.int(50, 100), TankmenBG.animationNotes[i][1] < 2);
							tankmanRun.add(tankBih);
						}
					}
				}
			}
		}

		dad = new Character(0, 0, SONG.player2);
		startCharacterPos(dad, true);
		dadGroup.add(dad);
		startCharacterLua(dad.curCharacter);
		if (curStage == 'backstage')
		{
			//dad.zoomFactor = 1.5;
		}

		if (usingAltBF != '') {
			altBoyfriend = new Boyfriend(0, 0, usingAltBF);
			startCharacterPos(altBoyfriend);
			boyfriendGroup.add(altBoyfriend);
			startCharacterLua(altBoyfriend.curCharacter);
		}

		boyfriend = new Boyfriend(0, 0, SONG.player1);
		startCharacterPos(boyfriend);
		boyfriendGroup.add(boyfriend);
		startCharacterLua(boyfriend.curCharacter);

		add(stage.fgElement);

		var camPos:FlxPoint = new FlxPoint(girlfriendCameraOffset[0], girlfriendCameraOffset[1]);
		if(gf != null)
		{
			camPos.x += gf.getGraphicMidpoint().x + gf.cameraPosition[0];
			camPos.y += gf.getGraphicMidpoint().y + gf.cameraPosition[1];
		}

		if(dad.curCharacter.startsWith('gf')) {
			dad.setPosition(GF_X, GF_Y);
			if(gf != null)
				gf.visible = false;
		}

		var file:String = Paths.json(songName + '/dialogue'); //Checks for json/Psych Engine dialogue
		if (OpenFlAssets.exists(file)) {
			dialogueJson = DialogueBoxPsych.parseDialogue(file);
		}

		var file:String = Paths.txt(songName + '/' + songName + 'Dialogue'); //Checks for vanilla/Senpai dialogue
		if (OpenFlAssets.exists(file)) {
			dialogue = CoolUtil.coolTextFile(file);
		}
		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;
		doof.nextDialogueThing = startNextDialogue;
		doof.skipDialogueThing = skipDialogue;

		Conductor.songPosition = -5000 / Conductor.songPosition;

		strumLine = new FlxSprite(ClientPrefs.middleScroll ? STRUM_X_MIDDLESCROLL : STRUM_X, 50).makeGraphic(FlxG.width, 10);
		if(ClientPrefs.downScroll) strumLine.y = FlxG.height - 150;
		strumLine.scrollFactor.set();

		hudAssets = new FlxSpriteGroup();
		stars = new FlxSpriteGroup();
		pixelHUD = new FlxSpriteGroup();
		pixelStars = new FlxSpriteGroup();
		if (ClientPrefs.hideHud) {
			hudAssets.visible = false;
			stars.visible = false;
			pixelHUD.visible = false;
			pixelStars.visible = false;
		}

		
		var showTime:Bool = (ClientPrefs.timeBarType != 'Disabled');
		timeTxt = new FlxText(STRUM_X + (FlxG.width / 2) - 248, 19, 400, "", 32);
		timeTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeTxt.scrollFactor.set();
		timeTxt.alpha = 0;
		timeTxt.borderSize = 2;
		timeTxt.visible = showTime;
		if(ClientPrefs.downScroll) timeTxt.y = FlxG.height - 44;

		if(ClientPrefs.timeBarType == 'Song Name')
		{
			timeTxt.text = SONG.song;
		}
		updateTime = showTime;

		var timebarImage:String = 'timeBars/';
		switch (SONG.song.toLowerCase()) {
			case 'guy' | 'golden' | 'dismantle':
				timebarImage += 'guy';
			default:
				timebarImage += SONG.song.toLowerCase();
		}

		timeBarBG = new AttachedSprite(timebarImage);
		if (timeBarBG.graphic == null) timeBarBG.loadGraphic(Paths.image('timeBars/blank'));
		//timeBarBG.x = timeTxt.x;
		timeBarBG.screenCenter(X);
		timeBarBG.y = timeTxt.y - 22; // + (timeTxt.height / 4);
		timeBarBG.scrollFactor.set();
		timeBarBG.alpha = 0;
		timeBarBG.visible = showTime;
		timeBarBG.xAdd = -8;
		timeBarBG.yAdd = -40 - 2;
		timeBarBG.antialiasing = false;

		timeBar = new FlxBar(timeBarBG.x, timeBarBG.y+ 30, LEFT_TO_RIGHT, Std.int(timeBarBG.width - 10), Std.int(timeBarBG.height/2 -14), this,
			'songPercent', 0, 1);
		timeBar.scrollFactor.set();
		timeBar.createFilledBar(0xFF000000, FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]));
		timeBar.numDivisions = 800; //How much lag this causes?? Should i tone it down to idk, 400 or 200?
		timeBar.alpha = 0;
		timeBar.visible = showTime;
		hudAssets.add(timeBar);
		hudAssets.add(timeBarBG);
		//hudAssets.add(timeTxt);
		timeBarBG.sprTracker = timeBar;

		strumLineNotes = new FlxTypedGroup<StrumNote>();
		add(strumLineNotes);
		add(grpNoteSplashes);

		if(ClientPrefs.timeBarType == 'Song Name')
		{
			timeTxt.size = 24;
			timeTxt.y += 3;
		}

		var splash:NoteSplash = new NoteSplash(100, 100, 0);
		grpNoteSplashes.add(splash);
		splash.alpha = 0.0;

		opponentStrums = new FlxTypedGroup<StrumNote>();
		playerStrums = new FlxTypedGroup<StrumNote>();

		// startCountdown();

		generateSong(SONG.song);

		// After all characters being loaded, it makes then invisible 0.01s later so that the player won't freeze when you change characters
		// add(strumLine);

		camFollow = new FlxPoint();
		camFollowPos = new FlxObject(0, 0, 1, 1);

		snapCamFollowToPos(camPos.x, camPos.y);
		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}
		if (prevCamFollowPos != null)
		{
			camFollowPos = prevCamFollowPos;
			prevCamFollowPos = null;
		}
		add(camFollowPos);

		FlxG.camera.follow(camFollowPos, LOCKON, 1);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow);

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;
		moveCameraSection();
		

		healthBarBG = new AttachedSprite('healthBar');
		healthBarBG.y = FlxG.height * 0.84;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		healthBarBG.visible = !ClientPrefs.hideHud;
		healthBarBG.xAdd = -4;
		healthBarBG.yAdd = -4;
		healthBarBG.antialiasing = false;
		if (ClientPrefs.downScroll) healthBarBG.y = 0.11 * FlxG.height;
		
		
		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.visible = !ClientPrefs.hideHud;
		healthBar.alpha = ClientPrefs.healthBarAlpha;
		
		var leftPizza:FlxSprite = new FlxSprite(healthBarBG.getGraphicMidpoint().x - (152 / 2.2) - (healthBarBG.width / 2), healthBarBG.getGraphicMidpoint().y - (142 / 1.85)).loadGraphic(Paths.image('pizza'));
		leftPizza.scrollFactor.set();
		leftPizza.updateHitbox();
		leftPizza.antialiasing = false;
		
		var rightPizza:FlxSprite = new FlxSprite(healthBarBG.getGraphicMidpoint().x - (152 / 1.8) + (healthBarBG.width / 2), healthBarBG.getGraphicMidpoint().y - (142 / 1.85)).loadGraphic(Paths.image('pizza'));
		rightPizza.scrollFactor.set();
		rightPizza.updateHitbox();
		rightPizza.antialiasing = false;
		

		stars.cameras = [camHUD];
		for (i in -2...3)
		{
			var star:FlxSprite = new FlxSprite(healthBarBG.getGraphicMidpoint().x + ((i * 75)) - (150 / 2), healthBarBG.getGraphicMidpoint().y - (50 / 2));
			star.frames = Paths.getSparrowAtlas('star');
			star.animation.addByPrefix('flash', 'star', 30, true);
			star.animation.addByIndices('still', 'star', [19], "", 30, true);
			star.animation.play('still', true);
			star.antialiasing = false;
			star.cameras = [camHUD];
			star.scrollFactor.set();
			star.scale.set(0.85, 0.85);
			stars.add(star);

			if (SONG.song.toLowerCase() == 'followed') 
				star.setPosition(0,((FlxG.height - star.height)/2) - ((i * 75)));
			

		}



		hudAssets.add(rightPizza);
		hudAssets.add(leftPizza);
		hudAssets.add(healthBar);
		hudAssets.add(healthBarBG);
		


		healthBarBG.visible = !ClientPrefs.hideHud;

		healthBarBG.sprTracker = healthBar;


		var pPizzaL = new FlxSprite().loadGraphic(Paths.image('pixelHUD/pizzaL'));
		pixelHUD.add(pPizzaL);
		var pPizzaR = new FlxSprite().loadGraphic(Paths.image('pixelHUD/pizzaR'));
		pixelHUD.add(pPizzaR);
		var pHPBG = new FlxSprite().loadGraphic(Paths.image('pixelHUD/hpbar'));
		pixelHUD.add(pHPBG);

		for (i in pixelHUD) {
			i.cameras = [camHUD];
			i.scrollFactor.set();
			i.scale.set(6,6);
			i.updateHitbox();
		}
		pHPBG.setPosition((FlxG.width - pHPBG.width)/2,healthBarBG.y - (healthBar.height/2));
		pPizzaL.setPosition(pHPBG.x - (pPizzaL.width/2),pHPBG.y + (pHPBG.height - pPizzaL.height)/2);
		pPizzaR.setPosition(pHPBG.x + pHPBG.width - (pPizzaR.width/2),pHPBG.y + (pHPBG.height - pPizzaR.height)/2);
		pHealthBar = new FlxBar(pHPBG.x + 6, pHPBG.y + 6, RIGHT_TO_LEFT, Std.int(pHPBG.width - 12), Std.int(pHPBG.height - 12), this,
		'health', 0, 2);
		pixelHUD.add(pHealthBar);
		pHealthBar.scrollFactor.set();
		pHealthBar.cameras = [camHUD];


		for (i in 0...5)
		{
			var star = new FlxSprite(pHPBG.getGraphicMidpoint().x + 172 + ((i - (5/2))*(12*6)),pHPBG.y+pHPBG.height + 9).loadGraphic(Paths.image('pixelHUD/stars'),true,11,10);//ngl this sucks ass but erm lol!
			//ill fix these positions later because holy this sucks
			star.animation.add('still',[0]);
			star.animation.add('flash',[0,1,2],12);
			star.animation.add('grey',[1]);
			star.animation.add('yellow',[2]);
			star.animation.play('still', true);
			star.scale.set(6,6);
			star.updateHitbox();
			pixelStars.add(star);
		}
		for (i in pixelStars) {
			i.cameras = [camHUD];
			i.scrollFactor.set();
		}

		pixelStars.visible = pixelHUD.visible = isPixelStage;

		//for (i in pixelHUD) i.pixelPerfectRender = true;



		iconP1 = new HealthIcon(boyfriend.healthIcon, true);
		iconP1.y = healthBar.y - 75;
		iconP1.visible = !ClientPrefs.hideHud;
		iconP1.alpha = ClientPrefs.healthBarAlpha;

		iconP2 = new HealthIcon(dad.healthIcon, false);
		iconP2.y = healthBar.y - 75;
		iconP2.visible = !ClientPrefs.hideHud;
		iconP2.alpha = ClientPrefs.healthBarAlpha;

		add(pixelHUD);
		add(pixelStars);
		add(hudAssets);
		add(stars);
		add(iconP1);
		add(iconP2);



		reloadHealthBarColors();

		scoreTxt = new FlxText(0, 0.11 * FlxG.height, FlxG.width, "", 20);
		scoreTxt.setFormat(Paths.font("DIGILF__.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.25;
		scoreTxt.visible = !ClientPrefs.hideHud;
		scoreTxt.screenCenter(X);
		if (ClientPrefs.downScroll && !ClientPrefs.middleScroll) scoreTxt.y =  FlxG.height * 0.78;
		
		if (ClientPrefs.middleScroll)
		{
			scoreTxt.x = healthBar.getGraphicMidpoint().x - (healthBar.width * 2) - 50;
			scoreTxt.y = healthBar.getGraphicMidpoint().y - 25;
		}
		hudAssets.add(scoreTxt);

		botplayTxt = new FlxText(400, timeBarBG.y + 55, FlxG.width - 800, "BOTPLAY", 32);
		botplayTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		botplayTxt.scrollFactor.set();
		botplayTxt.borderSize = 1.25;
		botplayTxt.visible = cpuControlled;
		add(botplayTxt);
		if(ClientPrefs.downScroll) {
			botplayTxt.y = timeBarBG.y - 78;
		}

		
		strumLineNotes.cameras = [camHUD];
		grpNoteSplashes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		leftPizza.cameras = [camHUD];
		rightPizza.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		botplayTxt.cameras = [camHUD];
		timeBar.cameras = [camHUD];
		timeBarBG.cameras = [camHUD];
		timeTxt.cameras = [camHUD];
		doof.cameras = [camHUD];

		startingSong = true;
		
		#if LUA_ALLOWED
		for (notetype in noteTypeMap.keys())
		{
			startLuasOnFolder('custom_notetypes/' + notetype + '.lua');
		}
		for (event in eventPushedMap.keys())
		{
			startLuasOnFolder('custom_events/' + event + '.lua');
		}
		#end
		noteTypeMap.clear();
		noteTypeMap = null;
		eventPushedMap.clear();
		eventPushedMap = null;

		if(eventNotes.length > 1)
		{
			for (event in eventNotes) event.strumTime -= eventNoteEarlyTrigger(event);
			eventNotes.sort(sortByTime);
		}

		// SONG SPECIFIC SCRIPTS
		#if LUA_ALLOWED
		var filesPushed:Array<String> = [];
		var foldersToCheck:Array<String> = [Paths.getPreloadPath('data/' + Paths.formatToSongPath(SONG.song) + '/')];

		#if MODS_ALLOWED
		foldersToCheck.insert(0, Paths.mods('data/' + Paths.formatToSongPath(SONG.song) + '/'));
		if(Paths.currentModDirectory != null && Paths.currentModDirectory.length > 0)
			foldersToCheck.insert(0, Paths.mods(Paths.currentModDirectory + '/data/' + Paths.formatToSongPath(SONG.song) + '/'));

		for(mod in Paths.getGlobalMods())
			foldersToCheck.insert(0, Paths.mods(mod + '/data/' + Paths.formatToSongPath(SONG.song) + '/' ));// using push instead of insert because these should run after everything else
		#end

		for (folder in foldersToCheck)
		{
			if(FileSystem.exists(folder))
			{
				for (file in FileSystem.readDirectory(folder))
				{
					if(file.endsWith('.lua') && !filesPushed.contains(file))
					{
						luaArray.push(new FunkinLua(folder + file));
						filesPushed.push(file);
					}
				}
			}
		}
		#end

		var daSong:String = Paths.formatToSongPath(curSong);
		if (isStoryMode && !seenCutscene)
		{
			switch (daSong)
			{
				case 'guy' | 'golden' | 'man' | 'cashmoney':
					startVideo(daSong);
				default:
					startCountdown();
			}
			seenCutscene = true;
		}
		else
		{
			switch (daSong) {
				case 'restless':
					//hudAssets.members[4].visible =false;
					camHUD.visible = false;
					healthBar.createFilledBar(0xFF000000,
					FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]));
					healthBar.updateBar();
					
					new FlxTimer().start(0.5, function (f:FlxTimer) {
						boyfriend.playAnim('intro',true);
						boyfriend.animation.finishCallback = function (n:String) {
							triggerEventNote('Change Character','bf','cryingchild');
							startCountdown();
							camHUD.visible = true;
							setNotePosition('middle');
						}
					});


				default:
					startCountdown();
			}

		}
		RecalculateRating();


		var creditFrame = new FlxSprite().loadGraphic(Paths.image('credit'));
		creditFrame.scale.set(1.5,1.5);
		creditFrame.updateHitbox();
		creditFrame.setPosition(-creditFrame.width, 90);
		creditFrame.cameras = [camOther];
		add(creditFrame);

		var creditTxt = new FlxText(0,creditFrame.y+10,creditFrame.width);
		creditTxt.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		creditTxt.text = CoolUtil.CreateCredits(SONG.song);

		creditTxt.applyMarkup(creditTxt.text, [new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.WHITE,true,false,0xFFCB00E5),'@'),new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.WHITE),'^^')]);
		creditTxt.x = creditFrame.x;
		creditFrame.setGraphicSize(Std.int(creditFrame.width),Std.int(creditTxt.height)+25);
		creditFrame.updateHitbox();

		creditTxt.cameras = [camOther];
		add(creditTxt);
		if (SONG.song.toLowerCase() == 'bite' && curStage == 'bite') creditTxt.text = 'awkward';
		if (creditTxt.text.contains('awkward')) {
			remove(creditFrame);
			creditFrame.destroy();
			remove(creditTxt);
			creditTxt.destroy();
		}
		else {
			var time = (Conductor.crochet / 1000 / playbackRate)*2;
			if (SONG.song.toLowerCase() == 'bite') time = 18; 

			new SongTimer().startAbs(time, function (f:SongTimer) {
				eventTweens.tween(creditTxt, {x:10},1, {ease: FlxEase.cubeOut});
				eventTweens.tween(creditFrame, {x: 10}, 1, {ease: FlxEase.cubeOut, onComplete: function (f:FlxTween) {
					eventTweens.tween(creditTxt, {x: -creditFrame.width},1.5, {startDelay: 2,ease: FlxEase.cubeIn});
					eventTweens.tween(creditFrame, {x: -creditFrame.width},1.5, {startDelay: 2,ease: FlxEase.cubeIn, onComplete: function (f:FlxTween) {
						remove(creditFrame);
						creditFrame.destroy();
						remove(creditTxt);
						creditTxt.destroy();
					}});
				}});

			});
		}
	
		//PRECACHING MISS SOUNDS BECAUSE I THINK THEY CAN LAG PEOPLE AND FUCK THEM UP IDK HOW HAXE WORKS
		if(ClientPrefs.hitsoundVolume > 0) precacheList.set('hitsound', 'sound');
		precacheList.set('missnote1', 'sound');
		precacheList.set('missnote2', 'sound');
		precacheList.set('missnote3', 'sound');

		//pausemenu precache
		var precachePauseDirectory:String = SONG.song.toLowerCase() == 'followed' ? 'followed/' : '';
		precacheList.set('newpause', 'music');
		precacheList.set('pausemenu/${precachePauseDirectory}exit', 'image');
		precacheList.set('pausemenu/${precachePauseDirectory}options', 'image');
		precacheList.set('pausemenu/${precachePauseDirectory}pmbg', 'image');
		precacheList.set('pausemenu/${precachePauseDirectory}restart', 'image');
		precacheList.set('pausemenu/${precachePauseDirectory}resume', 'image');

		precacheList.set('alphabet', 'image');

		
		
		//application = new Application();
		#if desktop
		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText, SONG.song, SONG.song.toLowerCase());
		#end

		if(!ClientPrefs.controllerMode)
		{
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
		}
		callOnLuas('onCreatePost', []);

		iconP1.scale.set(1.2,1.2); //i feel so schizo for doing this BUT it fixes the icons being incorrect spot at the beginning of a song
		iconP2.scale.set(1.2,1.2);
		iconP1.updateHitbox();
		iconP2.updateHitbox();
		//if (!isStoryMode) updateHUD();
		if (SONG.song.toLowerCase() == 'beatbox') updateHUD(); //temp 

		stage.createPost();

		for (i in stage.hudElement) i.cameras = [camHUD];

		super.create();

		cacheCountdown();
		cachePopUpScore();
		for (key => type in precacheList)
		{
			//trace('Key $key is type $type');
			switch(type)
			{
				case 'image':
					Paths.image(key);
				case 'sound':
					Paths.sound(key);
				case 'music':
					Paths.music(key);
			}
		}
		Paths.clearUnusedMemory();

		subtitles = SubtitleHandler.getSubsFromSong(SONG.song);
		if (subtitles != null) {
			add(subtitles);
			subtitles.cameras = [camSubtitles];
		}


		
		CustomFadeTransition.nextCamera = camOther;
		if(eventNotes.length < 1) checkEventNote();


		if (ClientPrefs.superfuckingHD) {

			// var median = CoolUtil.initializeShader('superfuckinghd');
			// addShader(median);
			var shimmer = CoolUtil.initializeShader('shimmershader');
			shimmer.setFloat('iTime',0.5);
			stage.updateiTime.push(shimmer);
			addShader(shimmer,'');

			var bloomshader = new BloomShader();
			bloomshader.glowAmount = 0.3;
			dad.shader = bloomshader;
			boyfriend.shader = bloomshader;
			if (gf != null)
				gf.shader = bloomshader;
			for (i in modchartSprites) {
				i.shader = bloomshader;
				i.antialiasing = true;
			}

			for (i in stage.bgElement) {
				if (i is FlxSprite) {
					var sprite = cast(i,FlxSprite);
					sprite.shader = bloomshader;
					sprite.antialiasing = true;
				}
			}
			for (i in stage.fgElement) {
				if (i is FlxSprite) {
					var sprite = cast(i,FlxSprite);
					sprite.shader = bloomshader;
					sprite.antialiasing = true;
				}
			}
			var coolrays = new FollowedGlitch();
			coolrays.glowAmount = 0.1;
			addShader(coolrays);

			//add funny lights that move around on screen
			//maybe add motion blur that either ramps on camera movement or onbeathit
			FlxG.sound.music.volume = 0;
		}



		// var shader2 = CoolUtil.initializeShader('shimmershader');
		// shader2.updateiTime = true;
		// var shader3 = new FollowedGlitch();
		// shader3.glowAmount = 0.5;
		// addRuntimeShader('shimmer',shader2);
		// addRuntimeShader('mosaic',shader);
		// addRuntimeShader('followedglitch',shader3);
		// removeRuntimeShader('mosaic');
		// removeRuntimeShader('followedglitch');

		
		camGame.setFilters(gameShaders);
		camHUD.setFilters(hudShaders);

	}


	public function setNotePosition(?mode:String = 'default' ,?moveTime:String = '') { //todo scoretxt for regular pos
		var playerPosition:Array<Float> = [732,732 + (112 * 1),732 + (112 * 2),732 + (112 * 3)];
		var oppPosition:Array<Float> = [92,92 + (112 * 1),92 + (112 * 2),92 + (112 * 3)];
		var middlePosition:Array<Float> = [412,412 + (112 * 1),412 + (112 * 2),412 + (112 * 3)];
		var time = Std.parseFloat(moveTime);

		switch (mode.toLowerCase().trim()) {
			case 'middlescroll' | 'm' | 'middle':
				for (i in 0...4) {
					if (ClientPrefs.middleScroll) break;
					if (!Math.isNaN(time)) {
						FlxTween.tween(strumLineNotes.members[i], {alpha: 0},time, {ease: FlxEase.cubeOut});
						FlxTween.tween(playerStrums.members[i], {x: middlePosition[i]},time, {ease: FlxEase.cubeOut});
						FlxTween.tween(opponentStrums.members[i], {x: middlePosition[i]},time, {ease: FlxEase.cubeOut});
					}
					else {
						strumLineNotes.members[i].alpha = 0;
						opponentStrums.members[i].visible = false;
	
						playerStrums.members[i].x = middlePosition[i];
						opponentStrums.members[i].x = 2000;
						
						scoreTxt.x = healthBar.getGraphicMidpoint().x - (healthBar.width * 2) - 50;
						scoreTxt.y = healthBar.getGraphicMidpoint().y - 25;	
					}
				}

			case 'swap':
				for (i in 0...4) {
					
					if (ClientPrefs.middleScroll) break;
					if (!Math.isNaN(time)) {
						FlxTween.tween(strumLineNotes.members[i], {alpha: 1},time, {ease: FlxEase.cubeOut});
						FlxTween.tween(playerStrums.members[i], {x:  oppPosition[i]},time, {ease: FlxEase.cubeOut});
						FlxTween.tween(opponentStrums.members[i], {x: playerPosition[i]},time, {ease: FlxEase.cubeOut});
					}
					else {
						strumLineNotes.members[i].alpha = 1;
						playerStrums.members[i].x = oppPosition[i];
						opponentStrums.members[i].x = playerPosition[i];	
					}
				}
			default:
				for (i in 0...4) {
					if (ClientPrefs.middleScroll) break;
					if (!Math.isNaN(time)) {
						FlxTween.tween(strumLineNotes.members[i], {alpha: 1},time, {ease: FlxEase.cubeOut});
						FlxTween.tween(playerStrums.members[i], {x:  playerPosition[i]},time, {ease: FlxEase.cubeOut});
						FlxTween.tween(opponentStrums.members[i], {x: oppPosition[i]},time, {ease: FlxEase.cubeOut});
					}
					else {
						strumLineNotes.members[i].alpha = 1;
						playerStrums.members[i].x = playerPosition[i];
						opponentStrums.members[i].x = oppPosition[i];	
					}
				}
		}

	}

	public function playVideo(video:String)
	{
		midSongVideo.playVideo(Paths.video(video));
		midSongVideo.canvasHeight = FlxG.height;
		midSongVideo.canvasWidth = FlxG.width+5;
	}

	public function updateHUD():Void
	{
		var offsets = [24+12,8+8,-8-8,-24-12];

		destroyStaticArrows();
		skipArrowStartTween = true;
		generateStaticArrows(0);
		generateStaticArrows(1);
		if (isPixelStage) 
		{
			for (i in 0...playerStrums.length) {
				playerStrums.members[i].x += offsets[i];
				opponentStrums.members[i].x += offsets[i];
				opponentStrums.members[i].x += 50;			
			}
		}

		stars.visible = hudAssets.visible = healthBarBG.visible = !isPixelStage;
		pixelStars.visible = pixelHUD.visible = isPixelStage;

	}

	private function cameraFixes(){ //used only in like lurking thanks nom
		camGameClone.scroll.x = camGame.scroll.x;
		camGameClone.scroll.y = camGame.scroll.y;
		camGameClone.zoom = camGame.zoom;
	}
	
	function destroyStaticArrows():Void
	{
		playerStrums.forEach(function(i:StrumNote)
		{
			playerStrums.remove(i);
			i.destroy();
		});
		opponentStrums.forEach(function(i:StrumNote)
		{
			opponentStrums.remove(i);
			i.destroy();
		});
		strumLineNotes.forEach(function(i:StrumNote)
		{
			strumLineNotes.remove(i);
			i.destroy();
		});
	}


	#if (!flash && sys)
	public var runtimeShaders:Map<String, Array<String>> = new Map<String, Array<String>>();
	public function createRuntimeShader(name:String):FlxRuntimeShader
	{
		if(!ClientPrefs.shaders) return new FlxRuntimeShader();

		#if (!flash && MODS_ALLOWED && sys)
		if(!runtimeShaders.exists(name) && !initLuaShader(name))
		{
			FlxG.log.warn('Shader $name is missing!');
			return new FlxRuntimeShader();
		}

		var arr:Array<String> = runtimeShaders.get(name);
		return new FlxRuntimeShader(arr[0], arr[1]);
		#else
		FlxG.log.warn("Platform unsupported for Runtime Shaders!");
		return null;
		#end
	}

	public function initLuaShader(name:String, ?glslVersion:Int = 120)
	{
		if(!ClientPrefs.shaders) return false;

		if(runtimeShaders.exists(name))
		{
			FlxG.log.warn('Shader $name was already initialized!');
			return true;
		}

		var foldersToCheck:Array<String> = [Paths.mods('shaders/')];
		if(Paths.currentModDirectory != null && Paths.currentModDirectory.length > 0)
			foldersToCheck.insert(0, Paths.mods(Paths.currentModDirectory + '/shaders/'));

		for(mod in Paths.getGlobalMods())
			foldersToCheck.insert(0, Paths.mods(mod + '/shaders/'));
		
		for (folder in foldersToCheck)
		{
			if(FileSystem.exists(folder))
			{
				var frag:String = folder + name + '.frag';
				var vert:String = folder + name + '.vert';
				var found:Bool = false;
				if(FileSystem.exists(frag))
				{
					frag = File.getContent(frag);
					found = true;
				}
				else frag = null;

				if (FileSystem.exists(vert))
				{
					vert = File.getContent(vert);
					found = true;
				}
				else vert = null;

				if(found)
				{
					runtimeShaders.set(name, [frag, vert]);
					//trace('Found shader $name!');
					return true;
				}
			}
		}
		FlxG.log.warn('Missing shader $name .frag AND .vert files!');
		return false;
	}
	#end

	function set_songSpeed(value:Float):Float
	{
		if(generatedMusic)
		{
			var ratio:Float = value / songSpeed; //funny word huh
			for (note in notes) note.resizeByRatio(ratio);
			for (note in unspawnNotes) note.resizeByRatio(ratio);
		}
		songSpeed = value;
		noteKillOffset = 350 / songSpeed;
		return value;
	}

	function set_playbackRate(value:Float):Float
	{
		if(generatedMusic)
		{
			if(vocals != null) vocals.pitch = value;
			FlxG.sound.music.pitch = value;
		}
		playbackRate = value;
		FlxG.animationTimeScale = value;
		Conductor.safeZoneOffset = (ClientPrefs.safeFrames / 60) * 1000 * value;
		setOnLuas('playbackRate', playbackRate);
		return value;
	}

	public function addTextToDebug(text:String, color:FlxColor) {
		#if LUA_ALLOWED
		luaDebugGroup.forEachAlive(function(spr:DebugLuaText) {
			spr.y += 20;
		});

		if(luaDebugGroup.members.length > 34) {
			var blah = luaDebugGroup.members[34];
			blah.destroy();
			luaDebugGroup.remove(blah);
		}
		luaDebugGroup.insert(0, new DebugLuaText(text, luaDebugGroup, color));
		#end
	}

	public function reloadHealthBarColors() {
		healthBar.createFilledBar(FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]),
			FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]));
		pHealthBar.createFilledBar(FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]),
			FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]));

		healthBar.updateBar();
		pHealthBar.updateBar();
	}

	public function addCharacterToList(newCharacter:String, type:Int) {
		switch(type) {
			case 0:
				if(!boyfriendMap.exists(newCharacter)) {
					var newBoyfriend:Boyfriend = new Boyfriend(0, 0, newCharacter);
					boyfriendMap.set(newCharacter, newBoyfriend);
					boyfriendGroup.add(newBoyfriend);
					startCharacterPos(newBoyfriend);
					newBoyfriend.alpha = 0.00001;
					startCharacterLua(newBoyfriend.curCharacter);
				}

			case 1:
				if(!dadMap.exists(newCharacter)) {
					var newDad:Character = new Character(0, 0, newCharacter);
					dadMap.set(newCharacter, newDad);
					dadGroup.add(newDad);
					startCharacterPos(newDad, true);
					newDad.alpha = 0.00001;
					startCharacterLua(newDad.curCharacter);
				}

			case 2:
				if(gf != null && !gfMap.exists(newCharacter)) {
					var newGf:Character = new Character(0, 0, newCharacter);
					newGf.scrollFactor.set(0.95, 0.95);
					gfMap.set(newCharacter, newGf);
					gfGroup.add(newGf);
					startCharacterPos(newGf);
					newGf.alpha = 0.00001;
					startCharacterLua(newGf.curCharacter);
				}
		}
	}

	function startCharacterLua(name:String)
	{
		#if LUA_ALLOWED
		var doPush:Bool = false;
		var luaFile:String = 'characters/' + name + '.lua';
		#if MODS_ALLOWED
		if(FileSystem.exists(Paths.modFolders(luaFile))) {
			luaFile = Paths.modFolders(luaFile);
			doPush = true;
		} else {
			luaFile = Paths.getPreloadPath(luaFile);
			if(FileSystem.exists(luaFile)) {
				doPush = true;
			}
		}
		#else
		luaFile = Paths.getPreloadPath(luaFile);
		if(Assets.exists(luaFile)) {
			doPush = true;
		}
		#end

		if(doPush)
		{
			for (script in luaArray)
			{
				if(script.scriptName == luaFile) return;
			}
			luaArray.push(new FunkinLua(luaFile));
		}
		#end
	}

	public function getLuaObject(tag:String, text:Bool=true):FlxSprite {
		if(modchartSprites.exists(tag)) return modchartSprites.get(tag);
		if(text && modchartTexts.exists(tag)) return modchartTexts.get(tag);
		if(variables.exists(tag)) return variables.get(tag);
		return null;
	}

	function startCharacterPos(char:Character, ?gfCheck:Bool = false) {
		if(gfCheck && char.curCharacter.startsWith('gf')) { //IF DAD IS GIRLFRIEND, HE GOES TO HER POSITION
			char.setPosition(GF_X, GF_Y);
			char.scrollFactor.set(0.95, 0.95);
			char.danceEveryNumBeats = 2;
		}
		char.x += char.positionArray[0];
		char.y += char.positionArray[1];
	}

	public function onVideoEnded():Void
	{
		switch (SONG.song.toLowerCase()) {
			case 'dismantle':
				setSongTime(31856);
			case 'followed':
				stage.followedEyes.visible = true;
				dad.visible = true;
				boyfriend.visible = true;
				camGame.flash();
			case 'lurking':
				camGame.visible = true;
				midSongVideo.visible = false;
				stars.visible = true;
				hudAssets.visible = true;
				iconP1.visible = true;
				iconP2.visible = true;
				camVideo.visible = false;
		}
	}

	public function onVideoStarted():Void
	{
		switch (SONG.song.toLowerCase()) {
			case 'lurking':
				camGame.visible = false;
		}
	}

	public function startVideo(name:String)
	{
		#if VIDEOS_ALLOWED
		inCutscene = true;
		camGame.visible = false;
		camHUD.visible = false;

		var filepath:String = Paths.video(name);
		#if sys
		if(!FileSystem.exists(filepath))
		#else
		if(!OpenFlAssets.exists(filepath))
		#end
		{
			FlxG.log.warn('Couldnt find video file: ' + name);
			startAndEnd();
			return;
		}

		var video:MP4Handler = new MP4Handler();
		video.skipKeys = [FlxKey.SPACE,FlxKey.ENTER];
		video.playVideo(filepath);
		video.finishCallback = function()
		{
			camGame.visible = true;
			camHUD.visible = true;
			startAndEnd();
			return;
		}
		#else
		FlxG.log.warn('Platform not supported!');
		startAndEnd();
		return;
		#end
	}

	function startAndEnd()
	{
		if(endingSong)
			endSong();
		else
			startCountdown();
	}

	var dialogueCount:Int = 0;
	public var psychDialogue:DialogueBoxPsych;
	//You don't have to add a song, just saying. You can just do "startDialogue(dialogueJson);" and it should work
	public function startDialogue(dialogueFile:DialogueFile, ?song:String = null):Void
	{
		// TO DO: Make this more flexible, maybe?
		if(psychDialogue != null) return;

		if(dialogueFile.dialogue.length > 0) {
			inCutscene = true;
			precacheList.set('dialogue', 'sound');
			precacheList.set('dialogueClose', 'sound');
			psychDialogue = new DialogueBoxPsych(dialogueFile, song);
			psychDialogue.scrollFactor.set();
			if(endingSong) {
				psychDialogue.finishThing = function() {
					psychDialogue = null;
					endSong();
				}
			} else {
				psychDialogue.finishThing = function() {
					psychDialogue = null;
					startCountdown();
				}
			}
			psychDialogue.nextDialogueThing = startNextDialogue;
			psychDialogue.skipDialogueThing = skipDialogue;
			psychDialogue.cameras = [camHUD];
			add(psychDialogue);
		} else {
			FlxG.log.warn('Your dialogue file is badly formatted!');
			if(endingSong) {
				endSong();
			} else {
				startCountdown();
			}
		}
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		inCutscene = true;
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();
		senpaiEvil.x += 300;

		var songName:String = Paths.formatToSongPath(SONG.song);
		if (songName == 'roses' || songName == 'thorns')
		{
			remove(black);

			if (songName == 'thorns')
			{
				add(red);
				camHUD.visible = false;
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					if (Paths.formatToSongPath(SONG.song) == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
										camHUD.visible = true;
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	function tankIntro()
	{
		var cutsceneHandler:CutsceneHandler = new CutsceneHandler();

		var songName:String = Paths.formatToSongPath(SONG.song);
		dadGroup.alpha = 0.00001;
		camHUD.visible = false;
		//inCutscene = true; //this would stop the camera movement, oops

		var tankman:FlxSprite = new FlxSprite(-20, 320);
		tankman.frames = Paths.getSparrowAtlas('cutscenes/' + songName);
		tankman.antialiasing = ClientPrefs.globalAntialiasing;
		addBehindDad(tankman);
		cutsceneHandler.push(tankman);

		var tankman2:FlxSprite = new FlxSprite(16, 312);
		tankman2.antialiasing = ClientPrefs.globalAntialiasing;
		tankman2.alpha = 0.000001;
		cutsceneHandler.push(tankman2);
		var gfDance:FlxSprite = new FlxSprite(gf.x - 107, gf.y + 140);
		gfDance.antialiasing = ClientPrefs.globalAntialiasing;
		cutsceneHandler.push(gfDance);
		var gfCutscene:FlxSprite = new FlxSprite(gf.x - 104, gf.y + 122);
		gfCutscene.antialiasing = ClientPrefs.globalAntialiasing;
		cutsceneHandler.push(gfCutscene);
		var picoCutscene:FlxSprite = new FlxSprite(gf.x - 849, gf.y - 264);
		picoCutscene.antialiasing = ClientPrefs.globalAntialiasing;
		cutsceneHandler.push(picoCutscene);
		var boyfriendCutscene:FlxSprite = new FlxSprite(boyfriend.x + 5, boyfriend.y + 20);
		boyfriendCutscene.antialiasing = ClientPrefs.globalAntialiasing;
		cutsceneHandler.push(boyfriendCutscene);

		cutsceneHandler.finishCallback = function()
		{
			var timeForStuff:Float = Conductor.crochet / 1000 * 4.5;
			FlxG.sound.music.fadeOut(timeForStuff);
			FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, timeForStuff, {ease: FlxEase.quadInOut});
			moveCamera(true);
			startCountdown();

			dadGroup.alpha = 1;
			camHUD.visible = true;
			boyfriend.animation.finishCallback = null;
			gf.animation.finishCallback = null;
			gf.dance();
		};

		camFollow.set(dad.x + 280, dad.y + 170);
		switch(songName)
		{
			case 'ugh':
				cutsceneHandler.endTime = 12;
				cutsceneHandler.music = 'DISTORTO';
				precacheList.set('wellWellWell', 'sound');
				precacheList.set('killYou', 'sound');
				precacheList.set('bfBeep', 'sound');

				var wellWellWell:FlxSound = new FlxSound().loadEmbedded(Paths.sound('wellWellWell'));
				FlxG.sound.list.add(wellWellWell);

				tankman.animation.addByPrefix('wellWell', 'TANK TALK 1 P1', 24, false);
				tankman.animation.addByPrefix('killYou', 'TANK TALK 1 P2', 24, false);
				tankman.animation.play('wellWell', true);
				FlxG.camera.zoom *= 1.2;

				// Well well well, what do we got here?
				cutsceneHandler.timer(0.1, function()
				{
					wellWellWell.play(true);
				});

				// Move camera to BF
				cutsceneHandler.timer(3, function()
				{
					camFollow.x += 750;
					camFollow.y += 100;
				});

				// Beep!
				cutsceneHandler.timer(4.5, function()
				{
					boyfriend.playAnim('singUP', true);
					boyfriend.specialAnim = true;
					FlxG.sound.play(Paths.sound('bfBeep'));
				});

				// Move camera to Tankman
				cutsceneHandler.timer(6, function()
				{
					camFollow.x -= 750;
					camFollow.y -= 100;

					// We should just kill you but... what the hell, it's been a boring day... let's see what you've got!
					tankman.animation.play('killYou', true);
					FlxG.sound.play(Paths.sound('killYou'));
				});

			case 'guns':
				cutsceneHandler.endTime = 11.5;
				cutsceneHandler.music = 'DISTORTO';
				tankman.x += 40;
				tankman.y += 10;
				precacheList.set('tankSong2', 'sound');

				var tightBars:FlxSound = new FlxSound().loadEmbedded(Paths.sound('tankSong2'));
				FlxG.sound.list.add(tightBars);

				tankman.animation.addByPrefix('tightBars', 'TANK TALK 2', 24, false);
				tankman.animation.play('tightBars', true);
				boyfriend.animation.curAnim.finish();

				cutsceneHandler.onStart = function()
				{
					tightBars.play(true);
					FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom * 1.2}, 4, {ease: FlxEase.quadInOut});
					FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom * 1.2 * 1.2}, 0.5, {ease: FlxEase.quadInOut, startDelay: 4});
					FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom * 1.2}, 1, {ease: FlxEase.quadInOut, startDelay: 4.5});
				};

				cutsceneHandler.timer(4, function()
				{
					gf.playAnim('sad', true);
					gf.animation.finishCallback = function(name:String)
					{
						gf.playAnim('sad', true);
					};
				});

			case 'stress':
				cutsceneHandler.endTime = 35.5;
				tankman.x -= 54;
				tankman.y -= 14;
				gfGroup.alpha = 0.00001;
				boyfriendGroup.alpha = 0.00001;
				camFollow.set(dad.x + 400, dad.y + 170);
				FlxTween.tween(FlxG.camera, {zoom: 0.9 * 1.2}, 1, {ease: FlxEase.quadInOut});
				foregroundSprites.forEach(function(spr:BGSprite)
				{
					spr.y += 100;
				});
				precacheList.set('stressCutscene', 'sound');

				tankman2.frames = Paths.getSparrowAtlas('cutscenes/stress2');
				addBehindDad(tankman2);

				if (!ClientPrefs.lowQuality)
				{
					gfDance.frames = Paths.getSparrowAtlas('characters/gfTankmen');
					gfDance.animation.addByPrefix('dance', 'GF Dancing at Gunpoint', 24, true);
					gfDance.animation.play('dance', true);
					addBehindGF(gfDance);
				}

				gfCutscene.frames = Paths.getSparrowAtlas('cutscenes/stressGF');
				gfCutscene.animation.addByPrefix('dieBitch', 'GF STARTS TO TURN PART 1', 24, false);
				gfCutscene.animation.addByPrefix('getRektLmao', 'GF STARTS TO TURN PART 2', 24, false);
				gfCutscene.animation.play('dieBitch', true);
				gfCutscene.animation.pause();
				addBehindGF(gfCutscene);
				if (!ClientPrefs.lowQuality)
				{
					gfCutscene.alpha = 0.00001;
				}

				picoCutscene.frames = AtlasFrameMaker.construct('cutscenes/stressPico');
				picoCutscene.animation.addByPrefix('anim', 'Pico Badass', 24, false);
				addBehindGF(picoCutscene);
				picoCutscene.alpha = 0.00001;

				boyfriendCutscene.frames = Paths.getSparrowAtlas('characters/BOYFRIEND');
				boyfriendCutscene.animation.addByPrefix('idle', 'BF idle dance', 24, false);
				boyfriendCutscene.animation.play('idle', true);
				boyfriendCutscene.animation.curAnim.finish();
				addBehindBF(boyfriendCutscene);

				var cutsceneSnd:FlxSound = new FlxSound().loadEmbedded(Paths.sound('stressCutscene'));
				FlxG.sound.list.add(cutsceneSnd);

				tankman.animation.addByPrefix('godEffingDamnIt', 'TANK TALK 3', 24, false);
				tankman.animation.play('godEffingDamnIt', true);

				var calledTimes:Int = 0;
				var zoomBack:Void->Void = function()
				{
					var camPosX:Float = 630;
					var camPosY:Float = 425;
					camFollow.set(camPosX, camPosY);
					camFollowPos.setPosition(camPosX, camPosY);
					FlxG.camera.zoom = 0.8;
					cameraSpeed = 1;

					calledTimes++;
					if (calledTimes > 1)
					{
						foregroundSprites.forEach(function(spr:BGSprite)
						{
							spr.y -= 100;
						});
					}
				}

				cutsceneHandler.onStart = function()
				{
					cutsceneSnd.play(true);
				};

				cutsceneHandler.timer(15.2, function()
				{
					FlxTween.tween(camFollow, {x: 650, y: 300}, 1, {ease: FlxEase.sineOut});
					FlxTween.tween(FlxG.camera, {zoom: 0.9 * 1.2 * 1.2}, 2.25, {ease: FlxEase.quadInOut});

					gfDance.visible = false;
					gfCutscene.alpha = 1;
					gfCutscene.animation.play('dieBitch', true);
					gfCutscene.animation.finishCallback = function(name:String)
					{
						if(name == 'dieBitch') //Next part
						{
							gfCutscene.animation.play('getRektLmao', true);
							gfCutscene.offset.set(224, 445);
						}
						else
						{
							gfCutscene.visible = false;
							picoCutscene.alpha = 1;
							picoCutscene.animation.play('anim', true);

							boyfriendGroup.alpha = 1;
							boyfriendCutscene.visible = false;
							boyfriend.playAnim('bfCatch', true);
							boyfriend.animation.finishCallback = function(name:String)
							{
								if(name != 'idle')
								{
									boyfriend.playAnim('idle', true);
									boyfriend.animation.curAnim.finish(); //Instantly goes to last frame
								}
							};

							picoCutscene.animation.finishCallback = function(name:String)
							{
								picoCutscene.visible = false;
								gfGroup.alpha = 1;
								picoCutscene.animation.finishCallback = null;
							};
							gfCutscene.animation.finishCallback = null;
						}
					};
				});

				cutsceneHandler.timer(17.5, function()
				{
					zoomBack();
				});

				cutsceneHandler.timer(19.5, function()
				{
					tankman2.animation.addByPrefix('lookWhoItIs', 'TANK TALK 3', 24, false);
					tankman2.animation.play('lookWhoItIs', true);
					tankman2.alpha = 1;
					tankman.visible = false;
				});

				cutsceneHandler.timer(20, function()
				{
					camFollow.set(dad.x + 500, dad.y + 170);
				});

				cutsceneHandler.timer(31.2, function()
				{
					boyfriend.playAnim('singUPmiss', true);
					boyfriend.animation.finishCallback = function(name:String)
					{
						if (name == 'singUPmiss')
						{
							boyfriend.playAnim('idle', true);
							boyfriend.animation.curAnim.finish(); //Instantly goes to last frame
						}
					};

					camFollow.set(boyfriend.x + 280, boyfriend.y + 200);
					cameraSpeed = 12;
					FlxTween.tween(FlxG.camera, {zoom: 0.9 * 1.2 * 1.2}, 0.25, {ease: FlxEase.elasticOut});
				});

				cutsceneHandler.timer(32.2, function()
				{
					zoomBack();
				});
		}
	}

	var startTimer:FlxTimer;
	var finishTimer:FlxTimer = null;

	// For being able to mess with the sprites on Lua
	public var countdownOnyourmarks:FlxSprite;
	public var countdownReady:FlxSprite;
	public var countdownSet:FlxSprite;
	public var countdownGo:FlxSprite;
	public static var startOnTime:Float = 0;

	function cacheCountdown()
	{
		var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
		introAssets.set('default', ['ready', 'set', 'onyourmarks', 'go']);
		introAssets.set('pixel', ['pixelUI/ready-pixel', 'pixelUI/set-pixel', 'pixelUI/date-pixel']);

		var introAlts:Array<String> = introAssets.get('default');
		if (isPixelStage) introAlts = introAssets.get('pixel');
		
		for (asset in introAlts)
			Paths.image(asset);
		
		Paths.sound('intro3' + introSoundsSuffix);
		Paths.sound('intro2' + introSoundsSuffix);
		Paths.sound('intro1' + introSoundsSuffix);
		Paths.sound('introGo' + introSoundsSuffix);
	}

	public function startCountdown():Void
	{
		if(startedCountdown) {
			callOnLuas('onStartCountdown', []);
			return;
		}

		inCutscene = false;
		var ret:Dynamic = callOnLuas('onStartCountdown', [], false);
		if(ret != FunkinLua.Function_Stop) {
			if (skipCountdown || startOnTime > 0) skipArrowStartTween = true;

			generateStaticArrows(0);
			generateStaticArrows(1);
			for (i in 0...playerStrums.length) {
				setOnLuas('defaultPlayerStrumX' + i, playerStrums.members[i].x);
				setOnLuas('defaultPlayerStrumY' + i, playerStrums.members[i].y);
			}
			for (i in 0...opponentStrums.length) {
				setOnLuas('defaultOpponentStrumX' + i, opponentStrums.members[i].x);
				setOnLuas('defaultOpponentStrumY' + i, opponentStrums.members[i].y);
				//if(ClientPrefs.middleScroll) opponentStrums.members[i].visible = false;
			}

			startedCountdown = true;
			Conductor.songPosition = -Conductor.crochet * 5;
			setOnLuas('startedCountdown', true);
			callOnLuas('onCountdownStarted', []);

			var swagCounter:Int = 0;

			if(startOnTime < 0) startOnTime = 0;

			if (startOnTime > 0) {
				clearNotesBefore(startOnTime);
				setSongTime(startOnTime - 350);
				return;
			}
			else if (skipCountdown)
			{
				setSongTime(0);
				return;
			}

			startTimer = new FlxTimer().start(Conductor.crochet / 1000 / playbackRate, function(tmr:FlxTimer)
			{
				stage.onCountdownTick();
				if (gf != null && tmr.loopsLeft % Math.round(gfSpeed * gf.danceEveryNumBeats) == 0 && gf.animation.curAnim != null && !gf.animation.curAnim.name.startsWith("sing") && !gf.stunned)
				{
					gf.dance();
				}
				if (tmr.loopsLeft % boyfriend.danceEveryNumBeats == 0 && boyfriend.animation.curAnim != null && !boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.stunned)
				{
					if (usingAltBF != '') altBoyfriend.dance();
					boyfriend.dance();
				}
				if (tmr.loopsLeft % dad.danceEveryNumBeats == 0 && dad.animation.curAnim != null && !dad.animation.curAnim.name.startsWith('sing') && !dad.stunned)
				{
					dad.dance();
				}

				var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
				introAssets.set('default', ['onyourmarks', 'ready', 'set', 'go']);
				introAssets.set('pixel', ['pixelUI/ready-pixel', 'pixelUI/set-pixel', 'pixelUI/date-pixel']);

				var introAlts:Array<String> = introAssets.get('default');
				var antialias:Bool = ClientPrefs.globalAntialiasing;
				if(isPixelStage) {
					introAlts = introAssets.get('pixel');
					antialias = false;
				}

				// head bopping for bg characters on Mall
				if(curStage == 'mall') {
					if(!ClientPrefs.lowQuality)
						upperBoppers.dance(true);

					bottomBoppers.dance(true);
					santa.dance(true);
				}

				switch (swagCounter)
				{
					case 0:
						countdownOnyourmarks = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
						countdownOnyourmarks.cameras = [camHUD];
						countdownOnyourmarks.scrollFactor.set();
						countdownOnyourmarks.updateHitbox();
						countdownOnyourmarks.angle = FlxG.random.float( 5, 12);

						if (PlayState.isPixelStage)
							countdownOnyourmarks.setGraphicSize(Std.int(countdownOnyourmarks.width * daPixelZoom));

						countdownOnyourmarks.screenCenter();
						countdownOnyourmarks.antialiasing = antialias;
						insert(members.indexOf(notes), countdownOnyourmarks);
						FlxTween.tween(countdownOnyourmarks, {y: countdownOnyourmarks.y + 66, alpha: 0, angle: 0}, Conductor.crochet / 800, {
							ease: FlxEase.cubeIn
						});
						
						FlxTween.tween(countdownOnyourmarks.scale, {y: 0.7, x: 0.7}, Conductor.crochet / 800, {
							ease: FlxEase.cubeIn,
							onComplete: function(twn:FlxTween)
							{
								remove(countdownOnyourmarks);
								countdownOnyourmarks.destroy();
							}
						});
						if (!mutedIntroSounds) FlxG.sound.play(Paths.sound('intro3' + introSoundsSuffix), 0.6);
					case 1:
						countdownReady = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
						countdownReady.cameras = [camHUD];
						countdownReady.scrollFactor.set();
						countdownReady.updateHitbox();
						countdownReady.angle = FlxG.random.float( -12, -5);

						if (PlayState.isPixelStage)
							countdownReady.setGraphicSize(Std.int(countdownReady.width * daPixelZoom));

						countdownReady.screenCenter();
						countdownReady.antialiasing = antialias;
						insert(members.indexOf(notes), countdownReady);
						FlxTween.tween(countdownReady, {y: countdownReady.y + 66, alpha: 0, angle: 0}, Conductor.crochet / 800, {
							ease: FlxEase.cubeIn
						});
						
						FlxTween.tween(countdownReady.scale, {y: 0.7, x: 0.7}, Conductor.crochet / 800, {
							ease: FlxEase.cubeIn,
							onComplete: function(twn:FlxTween)
							{
								remove(countdownReady);
								countdownReady.destroy();
							}
						});
						if (!mutedIntroSounds) FlxG.sound.play(Paths.sound('intro2' + introSoundsSuffix), 0.6);
					case 2:
						countdownSet = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
						countdownSet.cameras = [camHUD];
						countdownSet.scrollFactor.set();
						countdownSet.angle = FlxG.random.float( 5, 12);

						if (PlayState.isPixelStage)
							countdownSet.setGraphicSize(Std.int(countdownSet.width * daPixelZoom));

						countdownSet.screenCenter();
						countdownSet.antialiasing = antialias;
						insert(members.indexOf(notes), countdownSet);
						FlxTween.tween(countdownSet, {y: countdownSet.y + 66, alpha: 0, angle: 0}, Conductor.crochet / 800, {
							ease: FlxEase.cubeIn
						});
						
						FlxTween.tween(countdownSet.scale, {y: 0.7, x: 0.7}, Conductor.crochet / 800, {
							ease: FlxEase.cubeIn,
							onComplete: function(twn:FlxTween)
							{
								remove(countdownSet);
								countdownSet.destroy();
							}
						});
						if (!mutedIntroSounds) FlxG.sound.play(Paths.sound('intro1' + introSoundsSuffix), 0.6);
					case 3:
						countdownGo = new FlxSprite().loadGraphic(Paths.image(introAlts[3]));
						countdownGo.cameras = [camHUD];
						countdownGo.scrollFactor.set();
						countdownGo.angle = FlxG.random.float( -10, -5);
						countdownGo.scale.set(1.4, 1.4);

						if (PlayState.isPixelStage)
							countdownGo.setGraphicSize(Std.int(countdownGo.width * daPixelZoom));

						countdownGo.updateHitbox();

						countdownGo.screenCenter();
						countdownGo.antialiasing = antialias;
						insert(members.indexOf(notes), countdownGo);
						FlxTween.tween(countdownGo, {alpha: 0, angle: 0}, Conductor.crochet / 800, {
							ease: FlxEase.cubeIn
						});
						
						FlxTween.tween(countdownGo.scale, {y: 0.85, x: 0.85}, Conductor.crochet / 800, {
							ease: FlxEase.sineOut,
							onComplete: function(twn:FlxTween)
							{
								remove(countdownGo);
								countdownGo.destroy();
							}
						});
						if (!mutedIntroSounds) FlxG.sound.play(Paths.sound('introGo' + introSoundsSuffix), 0.6);
					case 4:
						countdownFinished = true;
				}

				notes.forEachAlive(function(note:Note) {
					if(ClientPrefs.opponentStrums || note.mustPress)
					{
						note.copyAlpha = false;
						note.alpha = note.multAlpha;
						if(ClientPrefs.middleScroll && !note.mustPress) {
							note.alpha *= 0.35;
						}
					}
				});
				callOnLuas('onCountdownTick', [swagCounter]);

				swagCounter += 1;
				// generateSong('fresh');
			}, 5);
		}
	}

	public function addBehindGF(obj:FlxObject)
	{
		insert(members.indexOf(gfGroup), obj);
	}
	public function addBehindBF(obj:FlxObject)
	{
		insert(members.indexOf(boyfriendGroup), obj);
	}
	public function addBehindDad (obj:FlxObject)
	{
		insert(members.indexOf(dadGroup), obj);
	}

	public function clearNotesBefore(time:Float)
	{
		var i:Int = unspawnNotes.length - 1;
		while (i >= 0) {
			var daNote:Note = unspawnNotes[i];
			if(daNote.strumTime - 350 < time)
			{
				daNote.active = false;
				daNote.visible = false;
				daNote.ignoreNote = true;

				daNote.kill();
				unspawnNotes.remove(daNote);
				daNote.destroy();
			}
			--i;
		}

		i = notes.length - 1;
		while (i >= 0) {
			var daNote:Note = notes.members[i];
			if(daNote.strumTime - 350 < time)
			{
				daNote.active = false;
				daNote.visible = false;
				daNote.ignoreNote = true;

				daNote.kill();
				notes.remove(daNote, true);
				daNote.destroy();
			}
			--i;
		}
	}

	public function updateScore(miss:Bool = false)
	{
		scoreTxt.text = 'Score:\n' + songScore;
		scoreTxt.size = 42;
		scoreTxt.antialiasing = false;

		if(ClientPrefs.scoreZoom && !miss && !cpuControlled)
		{
			if(scoreTxtTween != null) {
				scoreTxtTween.cancel();
			}
			scoreTxt.scale.x = 1.075;
			scoreTxt.scale.y = 1.075;
			scoreTxtTween = FlxTween.tween(scoreTxt.scale, {x: 1, y: 1}, 0.2, {
				onComplete: function(twn:FlxTween) {
					scoreTxtTween = null;
				}
			});
		}
		callOnLuas('onUpdateScore', [miss]);
	}

	public function setSongTime(time:Float)
	{
		if(time < 0) time = 0;

		FlxG.sound.music.pause();
		vocals.pause();

		FlxG.sound.music.time = time;
		FlxG.sound.music.pitch = playbackRate;
		FlxG.sound.music.play();

		if (Conductor.songPosition <= vocals.length)
		{
			vocals.time = time;
			vocals.pitch = playbackRate;
		}
		vocals.play();
		Conductor.songPosition = time;
		songTime = time;
	}

	function startNextDialogue() {
		dialogueCount++;
		callOnLuas('onNextDialogue', [dialogueCount]);
	}

	function skipDialogue() {
		callOnLuas('onSkipDialogue', [dialogueCount]);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		FlxG.sound.music.pitch = playbackRate;
		FlxG.sound.music.onComplete = finishSong.bind();
		vocals.play();

		if(startOnTime > 0)
		{
			setSongTime(startOnTime - 500);
		}
		startOnTime = 0;

		if(paused) {
			//trace('Oopsie doopsie! Paused sound');
			FlxG.sound.music.pause();
			vocals.pause();
		}

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;
		FlxTween.tween(timeBar, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		FlxTween.tween(timeTxt, {alpha: 1}, 0.5, {ease: FlxEase.circOut});

		switch(curStage)
		{
			case 'tank':
				if(!ClientPrefs.lowQuality) tankWatchtower.dance();
				foregroundSprites.forEach(function(spr:BGSprite)
				{
					spr.dance();
				});
		}

		#if desktop
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText, SONG.song, SONG.song.toLowerCase(), true, songLength,SONG.song.toLowerCase());
		#end
		setOnLuas('songLength', songLength);
		callOnLuas('onSongStart', []);
	}

	var debugNum:Int = 0;
	private var noteTypeMap:Map<String, Bool> = new Map<String, Bool>();
	private var eventPushedMap:Map<String, Bool> = new Map<String, Bool>();
	private function generateSong(dataPath:String):Void
	{
		songSpeedType = ClientPrefs.getGameplaySetting('scrolltype','multiplicative');

		switch(songSpeedType)
		{
			case "multiplicative":
				songSpeed = SONG.speed * ClientPrefs.getGameplaySetting('scrollspeed', 1);
			case "constant":
				songSpeed = ClientPrefs.getGameplaySetting('scrollspeed', 1);
		}

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		vocals.pitch = playbackRate;
		FlxG.sound.list.add(vocals);
		FlxG.sound.list.add(new FlxSound().loadEmbedded(Paths.inst(PlayState.SONG.song)));

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped

		var songName:String = Paths.formatToSongPath(SONG.song);
		var file:String = Paths.json(songName + '/events');
		#if MODS_ALLOWED
		if (FileSystem.exists(Paths.modsJson(songName + '/events')) || FileSystem.exists(file)) {
		#else
		if (OpenFlAssets.exists(file)) {
		#end
			var eventsData:Array<Dynamic> = Song.loadFromJson('events', songName).events;
			for (event in eventsData) //Event Notes
			{
				for (i in 0...event[1].length)
				{
					var newEventNote:Array<Dynamic> = [event[0], event[1][i][0], event[1][i][1], event[1][i][2]];
					var subEvent:EventNote = {
						strumTime: newEventNote[0] + ClientPrefs.noteOffset,
						event: newEventNote[1],
						value1: newEventNote[2],
						value2: newEventNote[3]
					};
					eventNotes.push(subEvent);
					eventPushed(subEvent);
				}
			}
		}

		for (section in noteData)
		{
			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;
				var isPixelNotes:Bool = section.pixelNoteSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote,false,false,isPixelNotes);
				swagNote.mustPress = gottaHitNote;
				swagNote.sustainLength = songNotes[2];
				swagNote.gfNote = (section.gfSection && (songNotes[1]<4));
				swagNote.noteType = songNotes[3];
				if(!Std.isOfType(songNotes[3], String)) swagNote.noteType = editors.ChartingState.noteTypeList[songNotes[3]]; //Backward compatibility + compatibility with Week 7 charts

				swagNote.scrollFactor.set();

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				var floorSus:Int = Math.floor(susLength);
				if(floorSus > 0) {
					for (susNote in 0...floorSus+1)
					{
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

						var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + (Conductor.stepCrochet / FlxMath.roundDecimal(songSpeed, 2)), daNoteData, oldNote, true,false,isPixelNotes);
						sustainNote.mustPress = gottaHitNote;
						sustainNote.gfNote = (section.gfSection && (songNotes[1]<4));
						sustainNote.noteType = swagNote.noteType;
						sustainNote.scrollFactor.set();
						swagNote.tail.push(sustainNote);
						sustainNote.parent = swagNote;
						unspawnNotes.push(sustainNote);

						if (sustainNote.mustPress)
						{
							sustainNote.x += FlxG.width / 2; // general offset
						}
						else if(ClientPrefs.middleScroll)
						{
							sustainNote.x += 310;
							if(daNoteData > 1) //Up and Right
							{
								sustainNote.x += FlxG.width / 2 + 25;
							}
						}
					}
				}

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else if(ClientPrefs.middleScroll)
				{
					swagNote.x += 310;
					if(daNoteData > 1) //Up and Right
					{
						swagNote.x += FlxG.width / 2 + 25;
					}
				}

				if(!noteTypeMap.exists(swagNote.noteType)) {
					noteTypeMap.set(swagNote.noteType, true);
				}
			}
			daBeats += 1;
		}
		for (event in songData.events) //Event Notes
		{
			for (i in 0...event[1].length)
			{
				var newEventNote:Array<Dynamic> = [event[0], event[1][i][0], event[1][i][1], event[1][i][2]];
				var subEvent:EventNote = {
					strumTime: newEventNote[0] + ClientPrefs.noteOffset,
					event: newEventNote[1],
					value1: newEventNote[2],
					value2: newEventNote[3]
				};
				eventNotes.push(subEvent);
				eventPushed(subEvent);
			}
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByTime);
		generatedMusic = true;
	}

	function eventPushed(event:EventNote) {
		switch(event.event) {
			case 'PlayVideoSprite':
				// if (event.value2 == '1')
					preloadvideo(event.value1);
			case 'Change Character':
				var charType:Int = 0;
				switch(event.value1.toLowerCase()) {
					case 'gf' | 'girlfriend' | '1':
						charType = 2;
					case 'dad' | 'opponent' | '0':
						charType = 1;
					default:
						charType = Std.parseInt(event.value1);
						if(Math.isNaN(charType)) charType = 0;
				}

				var newCharacter:String = event.value2;
				addCharacterToList(newCharacter, charType);

			case 'Dadbattle Spotlight':
				dadbattleBlack = new BGSprite(null, -800, -400, 0, 0);
				dadbattleBlack.makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
				dadbattleBlack.alpha = 0.25;
				dadbattleBlack.visible = false;
				add(dadbattleBlack);

				dadbattleLight = new BGSprite('spotlight', 400, -400);
				dadbattleLight.alpha = 0.375;
				dadbattleLight.blend = ADD;
				dadbattleLight.visible = false;

				dadbattleSmokes.alpha = 0.7;
				dadbattleSmokes.blend = ADD;
				dadbattleSmokes.visible = false;
				add(dadbattleLight);
				add(dadbattleSmokes);

				var offsetX = 200;
				var smoke:BGSprite = new BGSprite('smoke', -1550 + offsetX, 660 + FlxG.random.float(-20, 20), 1.2, 1.05);
				smoke.setGraphicSize(Std.int(smoke.width * FlxG.random.float(1.1, 1.22)));
				smoke.updateHitbox();
				smoke.velocity.x = FlxG.random.float(15, 22);
				smoke.active = true;
				dadbattleSmokes.add(smoke);
				var smoke:BGSprite = new BGSprite('smoke', 1550 + offsetX, 660 + FlxG.random.float(-20, 20), 1.2, 1.05);
				smoke.setGraphicSize(Std.int(smoke.width * FlxG.random.float(1.1, 1.22)));
				smoke.updateHitbox();
				smoke.velocity.x = FlxG.random.float(-15, -22);
				smoke.active = true;
				smoke.flipX = true;
				dadbattleSmokes.add(smoke);


			case 'Philly Glow':
				blammedLightsBlack = new FlxSprite(FlxG.width * -0.5, FlxG.height * -0.5).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
				blammedLightsBlack.visible = false;
				insert(members.indexOf(phillyStreet), blammedLightsBlack);

				phillyWindowEvent = new BGSprite('philly/window', phillyWindow.x, phillyWindow.y, 0.3, 0.3);
				phillyWindowEvent.setGraphicSize(Std.int(phillyWindowEvent.width * 0.85));
				phillyWindowEvent.updateHitbox();
				phillyWindowEvent.visible = false;
				insert(members.indexOf(blammedLightsBlack) + 1, phillyWindowEvent);


				phillyGlowGradient = new PhillyGlow.PhillyGlowGradient(-400, 225); //This shit was refusing to properly load FlxGradient so fuck it
				phillyGlowGradient.visible = false;
				insert(members.indexOf(blammedLightsBlack) + 1, phillyGlowGradient);
				if(!ClientPrefs.flashing) phillyGlowGradient.intendedAlpha = 0.7;

				precacheList.set('philly/particle', 'image'); //precache particle image
				phillyGlowParticles = new FlxTypedGroup<PhillyGlow.PhillyGlowParticle>();
				phillyGlowParticles.visible = false;
				insert(members.indexOf(phillyGlowGradient) + 1, phillyGlowParticles);
		}

		if(!eventPushedMap.exists(event.event)) {
			eventPushedMap.set(event.event, true);
		}
	}

	function eventNoteEarlyTrigger(event:EventNote):Float {
		var returnedValue:Null<Float> = callOnLuas('eventEarlyTrigger', [event.event, event.value1, event.value2, event.strumTime], [], [0]);
		if(returnedValue != null && returnedValue != 0 && returnedValue != FunkinLua.Function_Continue) {
			return returnedValue;
		}

		switch(event.event) {
			case 'Kill Henchmen': //Better timing so that the kill sound matches the beat intended
				return 280; //Plays 280ms before the actual position
		}
		return 0;
	}

	function sortByTime(Obj1:Dynamic, Obj2:Dynamic):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	public var skipArrowStartTween:Bool = false; //for lua
	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var targetAlpha:Float = 1;
			if (player < 1)
			{
				if(!ClientPrefs.opponentStrums) targetAlpha = 0;
				else if(ClientPrefs.middleScroll) targetAlpha = 0;
			}

			var babyArrow:StrumNote = new StrumNote(ClientPrefs.middleScroll ? STRUM_X_MIDDLESCROLL : STRUM_X, strumLine.y, i, player);
			babyArrow.downScroll = ClientPrefs.downScroll;
			if (!isStoryMode && !skipArrowStartTween)
			{
				//babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {/*y: babyArrow.y + 10,*/ alpha: targetAlpha}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}
			else
			{
				babyArrow.alpha = targetAlpha;
			}

			if (player == 1)
			{
				playerStrums.add(babyArrow);
			}
			else
			{
				if(ClientPrefs.middleScroll)
				{
					babyArrow.x += 310;
					if(i > 1) { //Up and Right
						babyArrow.x += FlxG.width / 2 + 25;
					}
				}
				opponentStrums.add(babyArrow);
			}

			strumLineNotes.add(babyArrow);
			babyArrow.postAddedToGroup();
		}
	}
	var pausedmidSongVideo:Bool = false;
	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}
			eventTweens.active = false;
			eventTimers.active = false;

			
			if (midSongVideo != null && midSongVideo.bitmap.isPlaying) {
				midSongVideo.bitmap.pause();
				pausedmidSongVideo = true;
			}

			if (startTimer != null && !startTimer.finished)
				startTimer.active = false;
			if (finishTimer != null && !finishTimer.finished)
				finishTimer.active = false;
			if (songSpeedTween != null)
				songSpeedTween.active = false;

			if(carTimer != null) carTimer.active = false;

			var chars:Array<Character> = [boyfriend, gf, dad];
			for (char in chars) {
				if(char != null && char.colorTween != null) {
					char.colorTween.active = false;
				}
			}
			// for (sound in modchartSounds) {
			// 	sound.pause();

			// }
			for (tween in modchartTweens) {
				tween.active = false;
			}
			for (timer in modchartTimers) {
				timer.active = false;
			}

		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (midSongVideo != null && pausedmidSongVideo) {
				midSongVideo.bitmap.resume();
				pausedmidSongVideo = false;
			}

			if (startTimer != null && !startTimer.finished)
				startTimer.active = true;
			if (finishTimer != null && !finishTimer.finished)
				finishTimer.active = true;
			if (songSpeedTween != null)
				songSpeedTween.active = true;

			if(carTimer != null) carTimer.active = true;

			var chars:Array<Character> = [boyfriend, gf, dad];
			for (char in chars) {
				if(char != null && char.colorTween != null) {
					char.colorTween.active = true;
				}
			}

			eventTweens.active = true;
			eventTimers.active = true;

			for (tween in modchartTweens) {
				tween.active = true;
			}
			for (timer in modchartTimers) {
				timer.active = true;
			}
			// for (i in modchartSounds) {
			// 	i.resume();
			// }
			paused = false;
			callOnLuas('onResume', []);

			#if desktop
			if (startTimer != null && startTimer.finished)
			{
				DiscordClient.changePresence(detailsText, SONG.song, SONG.song.toLowerCase(), true, songLength - Conductor.songPosition - ClientPrefs.noteOffset,SONG.song.toLowerCase());
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song, SONG.song.toLowerCase());
			}
			#end
		}

		super.closeSubState();
	}

	override public function onFocus():Void
	{

		// if (midSongVideo != null && pausedmidSongVideo)  {
		// 	midSongVideo.bitmap.resume();
		// 	pausedmidSongVideo = false;
		// }

		#if desktop
		if (health > 0 && !paused)
		{
			if (Conductor.songPosition > 0.0)
			{
				DiscordClient.changePresence(detailsText, SONG.song, SONG.song.toLowerCase(), true, songLength - Conductor.songPosition - ClientPrefs.noteOffset);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song, SONG.song.toLowerCase());
			}
		}
		#end

		super.onFocus();
	}

	override public function onFocusLost():Void
	{




		// if (midSongVideo != null && midSongVideo.bitmap.isPlaying)  {
		// 	midSongVideo.bitmap.pause();
		// 	pausedmidSongVideo = true;
		// }

		#if desktop
		if (health > 0 && !paused)
		{
			DiscordClient.changePresence(detailsPausedText, SONG.song, SONG.song.toLowerCase());
		}
		#end

		super.onFocusLost();
	}

	function resyncVocals():Void
	{
		if(finishTimer != null) return;

		vocals.pause();

		FlxG.sound.music.play();
		FlxG.sound.music.pitch = playbackRate;
		Conductor.songPosition = FlxG.sound.music.time;
		if (Conductor.songPosition <= vocals.length)
		{
			vocals.time = Conductor.songPosition;
			vocals.pitch = playbackRate;
		}
		vocals.play();
	}

	public var paused:Bool = false;
	public var canReset:Bool = true;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var limoSpeed:Float = 0;
	var restlessIntro:Bool = false;

	override public function update(elapsed:Float)
	{
		/*if (FlxG.keys.justPressed.NINE)
		{
			iconP1.swapOldIcon();
		}*/
		callOnLuas('onUpdate', [elapsed]);
		// if (midSongVideo != null && FlxG.keys.justPressed.SPACE && midSongVideo.bitmap.isPlaying) {
		// 	switch (SONG.song.toLowerCase()) {
		// 		case 'dismantle':
		// 			midSongVideo.bitmap.stop();
		// 			midSongVideo.bitmap.
		// 			midSongVideo = null;
		// 			setSongTime(38000);
		// 			clearNotesBefore(Conductor.songPosition);
		// 	}

		// } 
		eventTweens.update(elapsed);
		eventTimers.update(elapsed);




		if (SONG.song.toLowerCase() == 'restless' && boyfriend.curCharacter == 'cryingchildintro' && boyfriend.animation.curAnim.curFrame == 12 && boyfriend.animation.curAnim.name == 'intro' && !restlessIntro) {
			restlessIntro = true;
			FlxG.sound.play(Paths.sound('crushed'));
			FlxG.camera.zoom += 0.6;
			FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom -0.6},1, {ease:FlxEase.cubeOut});
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null && !endingSong && !isCameraOnForcedPos){
			moveCameraSection(Std.int(curStep / 16), true);
		}

		switch (curStage)
		{
			case 'tank':
				moveTank(elapsed);
			case 'schoolEvil':
				if(!ClientPrefs.lowQuality && bgGhouls.animation.curAnim.finished) {
					bgGhouls.visible = false;
				}
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				phillyWindow.alpha -= (Conductor.crochet / 1000) * FlxG.elapsed * 1.5;

				if(phillyGlowParticles != null)
				{
					var i:Int = phillyGlowParticles.members.length-1;
					while (i > 0)
					{
						var particle = phillyGlowParticles.members[i];
						if(particle.alpha < 0)
						{
							particle.kill();
							phillyGlowParticles.remove(particle, true);
							particle.destroy();
						}
						--i;
					}
				}
			case 'limo':
				if(!ClientPrefs.lowQuality) {
					grpLimoParticles.forEach(function(spr:BGSprite) {
						if(spr.animation.curAnim.finished) {
							spr.kill();
							grpLimoParticles.remove(spr, true);
							spr.destroy();
						}
					});

					switch(limoKillingState) {
						case 1:
							limoMetalPole.x += 5000 * elapsed;
							limoLight.x = limoMetalPole.x - 180;
							limoCorpse.x = limoLight.x - 50;
							limoCorpseTwo.x = limoLight.x + 35;

							var dancers:Array<BackgroundDancer> = grpLimoDancers.members;
							for (i in 0...dancers.length) {
								if(dancers[i].x < FlxG.width * 1.5 && limoLight.x > (370 * i) + 170) {
									switch(i) {
										case 0 | 3:
											if(i == 0) FlxG.sound.play(Paths.sound('dancerdeath'), 0.5);

											var diffStr:String = i == 3 ? ' 2 ' : ' ';
											var particle:BGSprite = new BGSprite('gore/noooooo', dancers[i].x + 200, dancers[i].y, 0.4, 0.4, ['hench leg spin' + diffStr + 'PINK'], false);
											grpLimoParticles.add(particle);
											var particle:BGSprite = new BGSprite('gore/noooooo', dancers[i].x + 160, dancers[i].y + 200, 0.4, 0.4, ['hench arm spin' + diffStr + 'PINK'], false);
											grpLimoParticles.add(particle);
											var particle:BGSprite = new BGSprite('gore/noooooo', dancers[i].x, dancers[i].y + 50, 0.4, 0.4, ['hench head spin' + diffStr + 'PINK'], false);
											grpLimoParticles.add(particle);

											var particle:BGSprite = new BGSprite('gore/stupidBlood', dancers[i].x - 110, dancers[i].y + 20, 0.4, 0.4, ['blood'], false);
											particle.flipX = true;
											particle.angle = -57.5;
											grpLimoParticles.add(particle);
										case 1:
											limoCorpse.visible = true;
										case 2:
											limoCorpseTwo.visible = true;
									} //Note: Nobody cares about the fifth dancer because he is mostly hidden offscreen :(
									dancers[i].x += FlxG.width * 2;
								}
							}

							if(limoMetalPole.x > FlxG.width * 2) {
								resetLimoKill();
								limoSpeed = 800;
								limoKillingState = 2;
							}

						case 2:
							limoSpeed -= 4000 * elapsed;
							bgLimo.x -= limoSpeed * elapsed;
							if(bgLimo.x > FlxG.width * 1.5) {
								limoSpeed = 3000;
								limoKillingState = 3;
							}

						case 3:
							limoSpeed -= 2000 * elapsed;
							if(limoSpeed < 1000) limoSpeed = 1000;

							bgLimo.x -= limoSpeed * elapsed;
							if(bgLimo.x < -275) {
								limoKillingState = 4;
								limoSpeed = 800;
							}

						case 4:
							bgLimo.x = FlxMath.lerp(bgLimo.x, -150, CoolUtil.boundTo(elapsed * 9, 0, 1));
							if(Math.round(bgLimo.x) == -150) {
								bgLimo.x = -150;
								limoKillingState = 0;
							}
					}

					if(limoKillingState > 2) {
						var dancers:Array<BackgroundDancer> = grpLimoDancers.members;
						for (i in 0...dancers.length) {
							dancers[i].x = (370 * i) + bgLimo.x + 280;
						}
					}
				}
			case 'mall':
				if(heyTimer > 0) {
					heyTimer -= elapsed;
					if(heyTimer <= 0) {
						bottomBoppers.dance(true);
						heyTimer = 0;
					}
				}
		}

		if(!inCutscene) {
			var lerpVal:Float = CoolUtil.boundTo(elapsed * 2.4 * cameraSpeed * playbackRate, 0, 1);
			camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));
			if(!startingSong && !endingSong && boyfriend.animation.curAnim != null && boyfriend.animation.curAnim.name.startsWith('idle')) {
				boyfriendIdleTime += elapsed;
				if(boyfriendIdleTime >= 0.15) { // Kind of a mercy thing for making the achievement easier to get as it's apparently frustrating to some playerss
					boyfriendIdled = true;
				}
			} else {
				boyfriendIdleTime = 0;
			}
		}

		super.update(elapsed);

		setOnLuas('curDecStep', curDecStep);
		setOnLuas('curDecBeat', curDecBeat);

		if(botplayTxt.visible) {
			botplaySine += 180 * elapsed;
			botplayTxt.alpha = 1 - Math.sin((Math.PI * botplaySine) / 180);
		}

		if (controls.PAUSE && startedCountdown && canPause)
		{
			var ret:Dynamic = callOnLuas('onPause', [], false);
			if(ret != FunkinLua.Function_Stop) {
				openPauseMenu();
			}
		}

		if (FlxG.keys.anyJustPressed(debugKeysChart) && !endingSong && !inCutscene)
		{
			openChartEditor();
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		var mult:Float = FlxMath.lerp(1, iconP1.scale.x, CoolUtil.boundTo(1 - (elapsed * 9 * playbackRate), 0, 1));
		iconP1.scale.set(mult, mult);

		var mult:Float = FlxMath.lerp(1, iconP2.scale.x, CoolUtil.boundTo(1 - (elapsed * 9 * playbackRate), 0, 1));
		iconP2.scale.set(mult, mult);

		var iconOffset:Int = 26;

		if (isPixelStage) {
			var pixelOffset:Int = 0;
			iconP1.x = pixelHUD.members[1].x + (pixelHUD.members[1].width - 150)/2 + pixelOffset;
			iconP2.x = pixelHUD.members[0].x + (pixelHUD.members[0].width - 150)/2 + pixelOffset;
		}
		else if (!isPixelStage && !iconPositionLocked){
			iconP1.x = healthBar.getGraphicMidpoint().x + (healthBar.width / 2) - (iconP1.width / 2.5);
			iconP2.x = healthBar.getGraphicMidpoint().x - (healthBar.width / 2) - (iconP2.width / 2.5);
		}


		if (health > 2)
			health = 2;

		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		if (FlxG.keys.anyJustPressed(debugKeysCharacter) && !endingSong && !inCutscene) {
			persistentUpdate = false;
			paused = true;
			cancelMusicFadeTween();
			MusicBeatState.switchState(new CharacterEditorState(SONG.player2));
		}
		
		if (startedCountdown)
		{
			Conductor.songPosition += FlxG.elapsed * 1000 * playbackRate;
		}

		if (startingSong)
		{
			if (startedCountdown && Conductor.songPosition >= 0)
				startSong();
			else if(!startedCountdown)
				Conductor.songPosition = -Conductor.crochet * 5;
		}
		else
		{
			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}

				if(updateTime) {
					var curTime:Float = Conductor.songPosition - ClientPrefs.noteOffset;
					if(curTime < 0) curTime = 0;
					songPercent = (curTime / songLength);

					var songCalc:Float = (songLength - curTime);
					if(ClientPrefs.timeBarType == 'Time Elapsed') songCalc = curTime;

					var secondsTotal:Int = Math.floor(songCalc / 1000);
					if(secondsTotal < 0) secondsTotal = 0;

					if(ClientPrefs.timeBarType != 'Song Name')
						timeTxt.text = FlxStringUtil.formatTime(secondsTotal, false);
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom * camZoomMult, FlxG.camera.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125 * camZoomingDecay * playbackRate), 0, 1));
			camHUD.zoom = FlxMath.lerp(defaultHudZoom, camHUD.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125 * camZoomingDecay * playbackRate), 0, 1));
		}

		FlxG.watch.addQuick("secShit", curSection);
		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		// RESET = Quick Game Over Screen
		if (!ClientPrefs.noReset && controls.RESET && canReset && !inCutscene && startedCountdown && !endingSong)
		{
			health = 0;
			trace("RESET = True");
		}
		doDeathCheck();

		if (unspawnNotes[0] != null)
		{
			var time:Float = spawnTime;
			if(songSpeed < 1) time /= songSpeed;
			if(unspawnNotes[0].multSpeed < 1) time /= unspawnNotes[0].multSpeed;

			while (unspawnNotes.length > 0 && unspawnNotes[0].strumTime - Conductor.songPosition < time)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.insert(0, dunceNote);
				dunceNote.spawned=true;
				callOnLuas('onSpawnNote', [notes.members.indexOf(dunceNote), dunceNote.noteData, dunceNote.noteType, dunceNote.isSustainNote]);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			if(!inCutscene)
			{
				if(!cpuControlled) {
					keyShit();
				} else if(boyfriend.animation.curAnim != null && boyfriend.holdTimer > Conductor.stepCrochet * (0.0011 / FlxG.sound.music.pitch) * boyfriend.singDuration && boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss')) {
					boyfriend.dance();
					if (usingAltBF != '') altBoyfriend.dance();
					//boyfriend.animation.curAnim.finish();
				}

				if(startedCountdown)
				{
					var fakeCrochet:Float = (60 / SONG.bpm) * 1000;
					notes.forEachAlive(function(daNote:Note)
					{
						var strumGroup:FlxTypedGroup<StrumNote> = playerStrums;
						if(!daNote.mustPress) strumGroup = opponentStrums;

						var strumX:Float = strumGroup.members[daNote.noteData].x;
						var strumY:Float = strumGroup.members[daNote.noteData].y;
						var strumAngle:Float = strumGroup.members[daNote.noteData].angle;
						var strumDirection:Float = strumGroup.members[daNote.noteData].direction;
						var strumAlpha:Float = strumGroup.members[daNote.noteData].alpha;
						var strumScroll:Bool = strumGroup.members[daNote.noteData].downScroll;

						strumX += daNote.offsetX;
						strumY += daNote.offsetY;
						strumAngle += daNote.offsetAngle;
						strumAlpha *= daNote.multAlpha;

						if (strumScroll) //Downscroll
						{
							//daNote.y = (strumY + 0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed);
							daNote.distance = (0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed * daNote.multSpeed);
						}
						else //Upscroll
						{
							//daNote.y = (strumY - 0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed);
							daNote.distance = (-0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed * daNote.multSpeed);
						}

						var angleDir = strumDirection * Math.PI / 180;
						if (daNote.copyAngle)
							daNote.angle = strumDirection - 90 + strumAngle;

						if(daNote.copyAlpha)
							daNote.alpha = strumAlpha;

						if(daNote.copyX)
							daNote.x = strumX + Math.cos(angleDir) * daNote.distance;

						if(daNote.copyY)
						{
							daNote.y = strumY + Math.sin(angleDir) * daNote.distance;

							//Jesus fuck this took me so much mother fucking time AAAAAAAAAA
							if(strumScroll && daNote.isSustainNote)
							{
								if (daNote.animation.curAnim.name.endsWith('end')) {
									daNote.y += 10.5 * (fakeCrochet / 400) * 1.5 * songSpeed + (46 * (songSpeed - 1));
									daNote.y -= 46 * (1 - (fakeCrochet / 600)) * songSpeed;
									if(PlayState.isPixelStage || daNote.isPixelNote) {
										daNote.y += 8 + (6 - daNote.originalHeightForCalcs) * PlayState.daPixelZoom;
										daNote.x += 12;
									} else {
										daNote.y -= 19;
									}
								}
								daNote.y += (Note.swagWidth / 2) - (60.5 * (songSpeed - 1));
								daNote.y += 27.5 * ((SONG.bpm / 100) - 1) * (songSpeed - 1);
							}
						}

						if (!daNote.mustPress && daNote.wasGoodHit && !daNote.hitByOpponent && !daNote.ignoreNote)
						{
							opponentNoteHit(daNote);
						}

						if(!daNote.blockHit && daNote.mustPress && cpuControlled && daNote.canBeHit) {
							if(daNote.isSustainNote) {
								if(daNote.canBeHit) {
									goodNoteHit(daNote);
								}
							} else if(daNote.strumTime <= Conductor.songPosition || daNote.isSustainNote) {
								goodNoteHit(daNote);
							}
						}

						var center:Float = strumY + Note.swagWidth / 2;
						if(strumGroup.members[daNote.noteData].sustainReduce && daNote.isSustainNote && (daNote.mustPress || !daNote.ignoreNote) &&
							(!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
						{
							if (strumScroll)
							{
								if(daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= center)
								{
									var swagRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);
									swagRect.height = (center - daNote.y) / daNote.scale.y;
									swagRect.y = daNote.frameHeight - swagRect.height;

									daNote.clipRect = swagRect;
								}
							}
							else
							{
								if (daNote.y + daNote.offset.y * daNote.scale.y <= center)
								{
									var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
									swagRect.y = (center - daNote.y) / daNote.scale.y;
									swagRect.height -= swagRect.y;

									daNote.clipRect = swagRect;
								}
							}
						}
						
						if (daNote.isSustainNote && isOurpleNote)
						{
							//daNote.alpha = 1;
						}
						
						if (ClientPrefs.middleScroll && !daNote.mustPress)
						{
							daNote.alpha = 0;
						}

						// Kill extremely late notes and cause misses
						if (Conductor.songPosition > noteKillOffset + daNote.strumTime)
						{
							if (daNote.mustPress && !cpuControlled &&!daNote.ignoreNote && !endingSong && (daNote.tooLate || !daNote.wasGoodHit)) {
								noteMiss(daNote);
							}

							daNote.active = false;
							daNote.visible = false;

							daNote.kill();
							notes.remove(daNote, true);
							daNote.destroy();
						}
					});
				}
				else
				{
					notes.forEachAlive(function(daNote:Note)
					{
						daNote.canBeHit = false;
						daNote.wasGoodHit = false;
					});
				}
			}
			checkEventNote();
		}

		#if debug
		if(!endingSong && !startingSong) {
			if (FlxG.keys.justPressed.ONE) {
				KillNotes();
				FlxG.sound.music.onComplete();
			}
			if(FlxG.keys.justPressed.TWO) { //Go 10 seconds into the future :O
				setSongTime(Conductor.songPosition + 10000);
				clearNotesBefore(Conductor.songPosition);
			}
		}
		#end
		//if (SONG.song.toLowerCase() == 'lurking') cameraFixes();

		setOnLuas('cameraX', camFollowPos.x);
		setOnLuas('cameraY', camFollowPos.y);
		setOnLuas('botPlay', cpuControlled);
		callOnLuas('onUpdatePost', [elapsed]);
	}

	function openPauseMenu()
	{
		persistentUpdate = false;
		persistentDraw = true;
		paused = true;

		if(FlxG.sound.music != null) {
			FlxG.sound.music.pause();
			vocals.pause();
		}
		openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		//}

		#if desktop
		DiscordClient.changePresence(detailsPausedText, SONG.song, SONG.song.toLowerCase());
		#end
	}

	function openChartEditor()
	{
		persistentUpdate = false;
		paused = true;
		cancelMusicFadeTween();
		MusicBeatState.switchState(new ChartingState());
		chartingMode = true;

		#if desktop
		DiscordClient.changePresence("Chart Editor", null, null, true);
		#end
	}

	public var isDead:Bool = false; //Don't mess with this on Lua!!!
	function doDeathCheck(?skipHealthCheck:Bool = false) {
		if (((skipHealthCheck && instakillOnMiss) || health <= 0) && !practiceMode && !isDead)
		{
			var ret:Dynamic = callOnLuas('onGameOver', [], false);
			if(ret != FunkinLua.Function_Stop) {
				boyfriend.stunned = true;
				deathCounter++;

				paused = true;

				vocals.stop();
				FlxG.sound.music.stop();

				if (altBoyfriend != null) altBoyfriend = null;

				persistentUpdate = false;
				persistentDraw = false;
				for (tween in modchartTweens) {
					tween.active = true;
				}
				for (timer in modchartTimers) {
					timer.active = true;
				}
				openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x - boyfriend.positionArray[0], boyfriend.getScreenPosition().y - boyfriend.positionArray[1], camFollowPos.x, camFollowPos.y));

				// MusicBeatState.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

				#if desktop
				// Game Over doesn't get his own variable because it's only used here
				DiscordClient.changePresence("Game Over - " + detailsText, SONG.song, SONG.song.toLowerCase());
				#end
				isDead = true;
				return true;
			}
		}
		return false;
	}

	public function checkEventNote() {
		while(eventNotes.length > 0) {
			var leStrumTime:Float = eventNotes[0].strumTime;
			if(Conductor.songPosition < leStrumTime) {
				return;
			}

			var value1:String = '';
			if(eventNotes[0].value1 != null)
				value1 = eventNotes[0].value1;

			var value2:String = '';
			if(eventNotes[0].value2 != null)
				value2 = eventNotes[0].value2;

			triggerEventNote(eventNotes[0].event, value1, value2);
			eventNotes.shift();
		}
	}

	public function getControl(key:String) {
		var pressed:Bool = Reflect.getProperty(controls, key);
		//trace('Control result: ' + pressed);
		return pressed;
	}

	var eventCounter:Int = 0;
	var followedGlitch:FlxTween; //this like sucsk to do but im trying to be fast so sorry mb
	var followedShaderTween:FlxTween;
	var dismantleShader:Bool = false; //mayeb to do add remove runtime shaders because remove doesnt work for em
	var dismantleScanlines:FlxBackdrop = null;

	public function triggerEventNote(eventName:String, value1:String, value2:String) {
		stage.onEventTrigger(eventName,value1,value2);
		switch(eventName) {
			case 'cashmoneyShaders':
				if (!ClientPrefs.shaders) return;
				switch (Std.parseInt(value1)) {
					case 0:
						stage.glitchShader2.squareAmount = Std.parseFloat(value2);
					case 1: //also works on OMC
						stage.chromaticShaderCash.strength = Std.parseFloat(value2.split(',')[0]);
						if (eventTweensManager.exists('cashmoneyTween')) eventTweensManager.get('cashmoneyTween').cancel();
						eventTweensManager.set('cashmoneyTween',eventTweens.tween(stage.chromaticShaderCash, {strength: Std.parseFloat(value2.split(',')[1])},0.25, {onComplete: function (t:FlxTween) {
							eventTweensManager.remove('cashmoneyTween');
						}}));

					case 2:
						if (stage.crtShader == null) return;
						if (Std.parseFloat(value2.split(',')[0]) <= 0) {
							for (i in modchartSprites) eventTweens.tween(i, {alpha: 0},Std.parseFloat(value2.split(',')[1]),{ease: FlxEase.cubeInOut});
							eventTweens.tween(stage.omcWhite, {alpha: 1},Std.parseFloat(value2.split(',')[1]),{ease: FlxEase.cubeInOut});
							eventTweens.color(boyfriend,Std.parseFloat(value2.split(',')[1]),FlxColor.WHITE,FlxColor.BLACK, {ease: FlxEase.cubeInOut});
							eventTweens.color(dad,Std.parseFloat(value2.split(',')[1]),FlxColor.WHITE,FlxColor.BLACK, {ease: FlxEase.cubeInOut});

						}
						else {
							for (i in modchartSprites) eventTweens.tween(i, {alpha: 1},Std.parseFloat(value2.split(',')[1]),{ease: FlxEase.cubeInOut});
							eventTweens.tween(stage.omcWhite, {alpha: 0},Std.parseFloat(value2.split(',')[1]),{ease: FlxEase.cubeInOut});
							eventTweens.color(boyfriend,Std.parseFloat(value2.split(',')[1]),FlxColor.BLACK,FlxColor.WHITE, {ease: FlxEase.cubeInOut});	
							eventTweens.color(dad,Std.parseFloat(value2.split(',')[1]),FlxColor.BLACK,FlxColor.WHITE, {ease: FlxEase.cubeInOut});	
						}
						if (eventTweensManager.exists('crtWarpOMC')) eventTweensManager.get('crtWarpOMC').cancel();
						eventTweensManager.set('crtWarpOMC',eventTweens.tween(stage.crtShader, {warpStrength: Std.parseFloat(value2.split(',')[0])},Std.parseFloat(value2.split(',')[1]), {ease: FlxEase.cubeInOut, onComplete: function (t:FlxTween) {
							eventTweensManager.remove('crtWarpOMC');
						}}));


					
						
				}
			

			case 'followedCamShake' | 'camShakeTween':
				@:privateAccess {
					if (value1.split(',')[1] == null) {
						camGame._fxShakeDuration = Std.parseFloat(value1);
						camGame._fxShakeIntensity = 0;
						eventTweens.tween(camGame, {_fxShakeIntensity: Std.parseFloat(value2)}, Std.parseFloat(value1), {ease: FlxEase.sineInOut, onComplete: function (f:FlxTween) {
							camGame._fxShakeIntensity = 0;
						}});
					}
					else {
						camVideo._fxShakeDuration = Std.parseFloat(value1);
						camVideo._fxShakeIntensity = 0;
						eventTweens.tween(camVideo, {_fxShakeIntensity: Std.parseFloat(value2)}, Std.parseFloat(value1), {ease: FlxEase.sineInOut, onComplete: function (f:FlxTween) {
							camVideo._fxShakeIntensity = 0;
						}});


					}
	
				}


			case 'followedGlitchTrans':
				if (Std.parseInt(value1) != 8 && !ClientPrefs.shaders) return;
				
				switch (Std.parseInt(value1)) {
					case 0: //apply shader 
						addShader(stage.glitchShader2);
					case 1: //remove shader
						removeShader(stage.glitchShader2);
					case 2: //edit shader value
						stage.glitchShader2.squareAmount = Std.parseFloat(value2);
						stage.glitchShader2.iTime = Std.parseFloat(value2)*5;
					case 3:
						stage.followedBeatsPerZoomShader = Std.parseInt(value2);
					case 4: 
						removeShader(stage.followedGlitchShader3);
					case 5:
						
						addShader(stage.followedIntenseChromaticAbb);
					case 6:
						removeShader(stage.followedIntenseChromaticAbb);	
					case 7:
						eventTweens.tween(stage.followedIntenseChromaticAbb, {amount: 0.15},Std.parseFloat(value2.split(',')[2]), {ease: FlxEase.sineIn});	
						eventTweens.tween(stage.followedIntenseChromaticAbb, {speed: 0.6},Std.parseFloat(value2.split(',')[2]), {ease: FlxEase.sineIn});	
					case 8:
						triggerEventNote('TweenObjectAlpha','stage.followedEyes,0,${Std.parseFloat(value2.split(',')[2])-0.25}','sineInOut');
						triggerEventNote('TweenObjectAlpha','stage.followedGradient,0,${Std.parseFloat(value2.split(',')[2])-0.25}','sineInOut');
						if (ClientPrefs.shaders) {
							var mosaic = new MosiacShader();
							mosaic.pixelSize = Std.parseFloat(value2.split(',')[0]);
							addShader(mosaic);
							eventTweens.tween(mosaic, {pixelSize: Std.parseFloat(value2.split(',')[1])}, Std.parseFloat(value2.split(',')[2]), {ease: FlxEase.sineInOut, onComplete: function (f:FlxTween) {
								removeShader(mosaic);
								mosaic = null;
							}});	
						}

				}

			case 'followedGlitch':
				if (!ClientPrefs.shaders) return;
				if (followedGlitch != null) followedGlitch.cancel();
				var val:Float = Std.parseFloat(value1);
				if (Math.isNaN(val)) val = 0.5;
				stage.glitchShader.glitchEffect =val;

				followedGlitch = eventTweens.tween(stage.glitchShader, {glitchEffect: 0.00001},1, {ease: FlxEase.sineOut});

			case 'PlayVideoSprite':
				if (value1 == 'lurking' && !ClientPrefs.flashing) return;
				playVideo(value1);
				midSongVideo.finishCallback = onVideoEnded;
				midSongVideo.openingCallback = onVideoStarted;
			case 'followedFlicker' | 'toggleCamVisible':
				if (eventName == 'followedFlicker' && !ClientPrefs.flashing) return; 
				camGame.visible = !camGame.visible;
				if (value1 == '')
					camVideo.visible = !camVideo.visible;
			case 'followedVignetteAlpha':
				if (followedGlitch != null) followedGlitch.cancel();
				if (followedShaderTween != null) followedShaderTween.cancel();
				var val:Float = Std.parseFloat(value1);
				if (Math.isNaN(val)) val = 0.5;
				if (val > 1) {
					followedGlitch = eventTweens.tween(stage.followedVignette, {alpha: 0},2, {ease: FlxEase.sineOut});
					if (ClientPrefs.shaders)
						followedShaderTween = eventTweens.tween(stage.bloomShader, {glowAmount: 0.05},2, {ease: FlxEase.sineOut});
					return;
				}
				stage.followedVignette.alpha = val+0.25;
				followedGlitch = eventTweens.tween(stage.followedVignette, {alpha: val},1, {ease: FlxEase.sineOut});
				if (ClientPrefs.shaders) {
					stage.bloomShader.glowAmount = val+0.1;
					followedShaderTween = eventTweens.tween(stage.bloomShader, {glowAmount: val-0.2},1, {ease: FlxEase.sineOut});
				}
			case 'followedScenes': //this is poopy but whatever
				switch (eventCounter) {
					case 0: //start intro cutscene
						if (ClientPrefs.shaders) {
							var mosaic = new MosiacShader();
							mosaic.pixelSize = 40;
							camVideo.setFilters([new ShaderFilter(mosaic)]);
							eventTweens.tween(mosaic, {pixelSize: 0.001},4, {startDelay: 5, onComplete: function (f:FlxTween) {
								camVideo.setFilters([]);
								mosaic = null;
							}});
						}

						stage.followedScene1.visible = true;
						stage.followedScene1.animation.play('s');
	
						new SongTimer().startAbs(21.96, function (f:SongTimer) {
							stage.followedScene1.visible = false;
							isCameraOnForcedBoyfriend=false;
							dad.visible = true;
							boyfriend.visible = true;
							triggerEventNote('camFlash','','');
							camHUD.alpha = 1;
						});
					case 2: //activate glitchy eyes
						stage.followedEyes.alpha = 1;				
					case 1: //fancy bump
						if (ClientPrefs.shaders) {
							var shader = new FollowedGlitch();
							addShader(shader);
							shader.glowAmount = 0;
							eventTweens.tween(shader, {glowAmount: 0.5}, 1.4, {ease: FlxEase.sineInOut, onComplete: function (f:FlxTween) {
								removeShader(shader);
							}});
						}

						isCameraOnForcedPos=true;
						eventTweens.tween(camFollow, {x: dad.getMidpoint().x + 150 + dad.cameraPosition[0] + opponentCameraOffset[0],y: dad.getMidpoint().y - 100 + dad.cameraPosition[1] + opponentCameraOffset[1]}, 1.4, {ease: FlxEase.sineInOut,onComplete: function (f:FlxTween) {
							isCameraOnForcedPos=false;
						}});


					case 3: //into the second phase
						if (ClientPrefs.shaders) {
							var shader = new FollowedGlitch();
							addShader(shader);
							shader.glowAmount = 0;
							eventTweens.tween(shader, {glowAmount: 0.3}, 0.5, {ease: FlxEase.sineInOut, onComplete: function (f:FlxTween) {
								removeShader(shader);
								stage.followedEyes.shader = stage.bloomShader;
							}});
						}


						isCameraOnForcedPos=true;
						var zoom = camGame.zoom;
						eventTweens.tween(camGame, {zoom: camGame.zoom + 3},0.5, {ease: FlxEase.sineInOut});
						eventTweens.tween(boyfriend, {alpha: 0},0.5, {ease: FlxEase.sineInOut});
						eventTweens.tween(camFollow, {x: dad.getMidpoint().x + 150 + dad.cameraPosition[0] + opponentCameraOffset[0],y: dad.getMidpoint().y - 100 + dad.cameraPosition[1] + opponentCameraOffset[1] - 100}, 0.5, {ease: FlxEase.sineInOut,onComplete: function (f:FlxTween) {


							camGame.zoom = zoom + 0.5;	
							eventTweens.tween(camGame, {zoom: zoom},0.5, {ease: FlxEase.backOut});
							snapCamToCharacter('dad');
							stage.followedEyes.scale.set(1.5,1.5); //why did i do this why why why
							stage.followedEyes.updateHitbox();
							isCameraOnForcedPos=false;
							isCameraOnForcedDad=true;
	
						}});
					case 4: //puppet appear
						isCameraOnForcedPos=true;
						eventTweens.tween(camFollow, {x: dad.getMidpoint().x + 150 + dad.cameraPosition[0] + opponentCameraOffset[0],y: dad.getMidpoint().y - 100 + dad.cameraPosition[1] + opponentCameraOffset[1] -125}, 2, {ease: FlxEase.sineInOut});
						triggerEventNote('tweenZoom','1.4,2,sdfds','sineinout');
						eventTweens.tween(stage.followedChandel, {alpha: 1},2, {startDelay: 0.5,ease: FlxEase.sineInOut});
						stage.followedPuppets.forEach(function (f:FlxSprite) {
							eventTweens.tween(f, {alpha: 1},2, {startDelay: 0.5,ease: FlxEase.sineInOut});					
						});
					case 5: //drop the puppets //imma redo this
						
						stage.followedPuppets.members[0].animation.play('s');
						stage.followedPuppets.members[0].animation.finishCallback = function (name:String) {
							stage.followedPuppets.members[1].animation.play('s');	
							stage.followedPuppets.members[1].animation.finishCallback = function (name:String) {
								stage.followedPuppets.members[2].animation.play('s');		
								stage.followedPuppets.members[2].animation.finishCallback = function (name:String) {
									stage.followedPuppets.members[3].animation.play('s');	
									stage.followedPuppets.members[3].animation.finishCallback = function (name:String) {
										stage.removeElement('stage.followedChandel');	
										stage.followedPuppets2.add(stage.followedChandel); //TODO FIX THIS SHIT
										eventTweens.tween(stage.followedHands, {alpha: 1},2, {startDelay: 0.5,ease: FlxEase.sineInOut});
										if (ClientPrefs.shaders)
											eventTweens.tween(stage.bloomShader, {glowAmount: 0.25},1.8, {ease: FlxEase.sineOut, startDelay: 0.3});	
									}	
								}
							}	
						}
					case 6: //going into freddy
				
						triggerEventNote('tweenZoom','3.5,3,sdfds','sineinout');

					case 7: //freddy time
						if (ClientPrefs.shaders) {
							stage.bloomShader.glowAmount = 0.7;
							stage.bloomShader.glowAmount = 0.25;
							dad.shader = stage.followedGlitchShader3;
							eventTweens.tween(stage.bloomShader, {glowAmount: 0.25}, 1.5, {ease: FlxEase.sineInOut});
						}

						stage.followedEyes.alpha = 1;
						stage.followedPuppets.visible = false;
						stage.followedPuppets2.forEach(function (f:FlxSprite) {
							f.alpha = 1;
						});			

						camGame.zoom = 2.5;
						triggerEventNote('tweenZoom','1.7,0.5,sdfds','backout');
						stage.followedEyes.color = FlxColor.RED;
						stage.followedGradient.visible = true;
						stage.followedGradient.color = 0xFF800000;
						stage.followedGradient.alpha = .5;

					case 8: //bonnie
						if (ClientPrefs.shaders) {
							stage.bloomShader.glowAmount = 0.7;
							dad.shader = stage.followedGlitchShader3;
							eventTweens.tween(stage.bloomShader, {glowAmount: 0.25}, 1.5, {ease: FlxEase.sineInOut});
						}
	

						eventTweens.tween(stage.followedPuppets2.members[2], {alpha: 0},1, {ease: FlxEase.sineOut});

						triggerEventNote('TweenObjectAlpha','stage.followedEyes,1,0.001','');
						triggerEventNote('TweenObjectAlpha','stage.followedGradient,0.5,0.001','');
						stage.followedEyes.color = 0xFF8628E2;
						stage.followedGradient.color = 0xFF591A97;
					case 9: //chica
						if (ClientPrefs.shaders) {
							dad.shader = stage.followedGlitchShader3;
							stage.bloomShader.glowAmount = 0.7;
							eventTweens.tween(stage.bloomShader, {glowAmount: 0.25}, 1.5, {ease: FlxEase.sineInOut});
						}



						eventTweens.tween(stage.followedPuppets2.members[1], {alpha: 0},1, {ease: FlxEase.sineOut});
						triggerEventNote('TweenObjectAlpha','stage.followedEyes,1,0.001','');
						triggerEventNote('TweenObjectAlpha','stage.followedGradient,0.4,0.001','');
						stage.followedEyes.color = 0xFFE27705;	
						stage.followedGradient.color = 0xFF935009;
					case 10: // foxy	
						if (ClientPrefs.shaders)
							dad.shader = stage.followedGlitchShader3;

						eventTweens.tween(stage.followedPuppets2.members[0], {alpha: 0},1, {ease: FlxEase.sineOut});
						triggerEventNote('tweenZoom','1.5,0.25,sdfds','backout');
						stage.followedGoGoGo.visible = true; 
					case 11: //end foxy go black
						stage.followedGoGoGo.visible = false;
						stage.followedSinnohbg.visible = true;
						stage.followedSinnohbg2.visible = true;
						stage.followedSinnohbg3.visible = true;
						stage.followedSinnohbg3.alpha = 0;
						boyfriend.visible = true;
						boyfriend.alpha = 1;
						defaultCamZoom = 6;
						camGame.visible = false;
						isCameraOnForcedDad = false;
						stage.followedScene2.visible = true;
						stage.followedScene2.animation.play('idle');
						stage.followedScene2.animation.finishCallback = function (name:String) {
							stage.followedScene2.visible = false;
							camGame.flash(FlxColor.BLACK);
							camGame.visible = true;
							isCameraOnForcedPos=true;
							snapCamToCharacter('dad');
							camFollow.x += 50;
							camFollowPos.x = camFollow.x;
							eventTweens.tween(camFollow, {x: dad.getMidpoint().x + 150 + dad.cameraPosition[0] + opponentCameraOffset[0]}, 1.5, {ease: FlxEase.expoInOut, onComplete: function (f:FlxTween) {
								isCameraOnForcedPos=false;
							}});
							defaultCamZoom = 1.85;
							eventTweens.tween(camGame, {zoom: 1.85 * camZoomMult},1.5, {ease: FlxEase.expoInOut});
							if (ClientPrefs.shaders) {
								addShader(stage.followedIntenseChromaticAbb);
								stage.followedIntenseChromaticAbb.amount = 0.0;
								stage.followedIntenseChromaticAbb.speed = 0.6;
								if (ClientPrefs.flashing) eventTweens.tween(stage.followedIntenseChromaticAbb, {amount: 0.02},12);
								stage.glitchShader2.squareAmount = 0;
								stage.glitchShader2.glowAmount = 0;		
								stage.updateiTimeHARD.push(stage.glitchShader2);
								stage.followedSinnohbg.shader = stage.glitchShader2;
								stage.followedSinnohbg2.shader = stage.glitchShader2;
								eventTweens.tween(stage.glitchShader2, {squareAmount: 0.04},5, {startDelay: 5});
							}


						}
					case 12:
						if (ClientPrefs.shaders && ClientPrefs.flashing) {
							eventTweens.tween(stage.followedIntenseChromaticAbb, {amount: 0.08},2);
	
						}
						stage.followedPuppets.visible = false;
						stage.followedPuppets2.visible = false;
						stage.followedChandel.visible = false;
						stage.followedHands.visible = false;
						stage.followedGoGoGo.visible = false;
						stage.followedEyes.visible = false;
						stage.followedGradient.visible = false;
						triggerEventNote('tweenZoom','2.5,2,sdf','sineinout');

					case 13:
						triggerEventNote('tweenZoom','1.85,0.1,sdf','cubeout');
						triggerEventNote('camFlash','','');
						stage.followedSinnohbg.visible = false;
						stage.followedSinnohbg2.visible = false;
						if (ClientPrefs.shaders) {
							stage.followedSinnohbg.shader = null;
							stage.followedSinnohbg2.shader = null;
						}
	
						stage.followedSinnohbg3.alpha = 1;
						
					case 14:
						dad.visible = false;

	
						isCameraOnForcedPos = true;
						eventTweens.tween(camFollow, {
							x: boyfriend.getMidpoint().x - 100 - (boyfriend.cameraPosition[0] - boyfriendCameraOffset[0]),
							y: boyfriend.getMidpoint().y - 100 + (boyfriend.cameraPosition[1] + boyfriendCameraOffset[1])
						}, 0.6, {ease: FlxEase.sineInOut, onComplete: function (f:FlxTween) {
						}});
						eventTweens.tween(stage.followedSinnohbg3, {alpha: 0},0.75, {ease:FlxEase.sineInOut});
						eventTweens.tween(boyfriend, {alpha: 0.8},1.5, {ease:FlxEase.sineInOut});
 
					case 15:
						if (ClientPrefs.shaders) {
							addShader(stage.glitchShader3);
							stage.glitchShader3.glitchy = ClientPrefs.flashing ? 0.04 : 0.02;
						}


						dad.alpha = 0.8;
						dad.visible = true;
						defaultCamZoom = 1.5;
						eventTweens.tween(camGame, {zoom: 1.5},0.5, {ease: FlxEase.backOut});
						isCameraOnForcedPos = false;			
						isCameraOnForcedBoyfriend = true;
						stage.followedfinalbg.visible = true;
					case 16:
						if (ClientPrefs.shaders) {
							eventTweens.tween(stage.followedIntenseChromaticAbb, {amount: 0.01},2);
							eventTweens.tween(stage.glitchShader3, {glitchy: 0.01},2, {ease:FlxEase.sineInOut});
						}
	
							
					case 17:
						eventTweens.tween(stage.followedfinalbg, {alpha: 0},4, {ease:FlxEase.sineInOut});
					case 18:
						isCameraOnForcedPos = true;
						triggerEventNote('tweenZoom','1.7,1.1,sdf','sineinout');
						eventTweens.tween(camFollow, {y: dad.getMidpoint().y - 100 + dad.cameraPosition[1] + opponentCameraOffset[1]}, 1.1, {ease: FlxEase.sineInOut});
					case 19:
						if (ClientPrefs.shaders) {
							eventTweens.tween(stage.glitchShader3, {glitchy: 0.0},0.3, {ease:FlxEase.sineInOut, onComplete: function (f:FlxTween) {
								removeShader(stage.glitchShader3);
							}});
							eventTweens.tween(stage.followedIntenseChromaticAbb, {amount: 0.0},0.3, {onComplete: function (f:FlxTween) {
								removeShader(stage.followedIntenseChromaticAbb);
							}});

							var shader = new FollowedGlitch();
							addShader(shader);
							shader.glowAmount = 0;
							eventTweens.tween(shader, {glowAmount: 0.3}, 0.3, {ease: FlxEase.circIn, onComplete: function (f:FlxTween) {
								eventTweens.tween(shader, {glowAmount: 0}, 0.2, {ease: FlxEase.circOut, onComplete: function (f:FlxTween) {
									removeShader(shader);
								}});

							}});
						}
						stage.followedEnding.alpha = 1;
						
						eventTweens.tween(dad, {alpha: 0}, 0.6, {ease: FlxEase.sineInOut, startDelay: 0.2});
						eventTweens.tween(boyfriend, {alpha: 0}, 0.6, {ease: FlxEase.sineInOut, startDelay: 0.2});
						eventTweens.tween(camHUD, {alpha: 0}, 0.5, {ease: FlxEase.sineInOut});
						stage.followedVignette.alpha = 0;
						beatsPerZoom = 111111;
						triggerEventNote('tweenZoom','0.275,0.9,sdf','expoout');






					
				}
				eventCounter++;
			
			case 'followedFlashing':

				if (Std.parseInt(value2) == 0) stage.followedfinalFlashes.visible = true;
				else stage.followedfinalFlashes.visible = false;

				switch (Std.parseInt(value1)) {
					case 0:
						stage.followedfinalPurple.visible = !stage.followedfinalPurple.visible;
						eventTweens.color(stage.followedfinalPurple,0.5,0xFFB71DC0,FlxColor.BLACK);

					case 1:
						stage.followedfinalFlashes.animation.play('1');
					case 2:
						stage.followedfinalFlashes.animation.play('2');
					case 3:
						stage.followedfinalFlashes.animation.play('3');
					case 4:
						stage.followedfinalFlashes.animation.play('4');

					
				}



			case 'camFlash':
				var color = FlxColor.fromString(value1.split(',')[0]);
				if (value1.split(',')[0] == null || value1.split(',')[0] == '') color = FlxColor.WHITE; if (!ClientPrefs.flashing) color.alphaFloat = 0.5;
				var speed:Float = Std.parseFloat(value1.split(',')[1]);
				if (Math.isNaN(speed)) speed = 0.5;
				if (value2.toLowerCase().contains('hud')) camHUD.flash(color,speed);
				else if (value2.toLowerCase().contains('other')) camOther.flash(color,speed);
				else camGame.flash(color,speed);

			case 'lurkingCutscene':
				if (!ClientPrefs.flashing) return;
				stage.lurkingcutIntro.visible = true;
				stage.lurkingcutIntro.animation.play('s');
				stage.lurkingcutIntro.animation.finishCallback = function (string) {
					stars.visible = false;
					hudAssets.visible = false;
					iconP1.visible = false;
					iconP2.visible = false;
					stage.lurkingcutIntro.visible = false;
					stage.lurkingcutIntro.kill();
					new FlxTimer().start(0,(f)->stage.lurkingcutIntro.destroy());
					
					triggerEventNote('PlayVideoSprite','lurking','');
					if (!ClientPrefs.flashing) {
						var darken = new FlxSprite().makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
						darken.alpha = 0.8;
						darken.blend = ADD;
						add(darken);
						darken.cameras = [camVideo];

						var darken = new FlxSprite().makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
						darken.alpha = 0.8;
						add(darken);
						darken.cameras = [camVideo];

					}
				}
				
			case 'dotMatrix':
				var dotmatrix = CoolUtil.initializeShader('dotmatrix');
				dotmatrix.setFloat('iTime', 0.005);
				stage.updateiTime.push(dotmatrix);
				addShader(dotmatrix);
				addShader(dotmatrix,'asd');
			case 'dismantledShader': //only on hud
				dismantleShader = !dismantleShader; //really need a remove runtime sahder thingy
				if (!dismantleShader) {
					if (dismantleScanlines != null) {
						dismantleScanlines.kill();
						dismantleScanlines.destroy();
					}
					while (gameShaders.length > 0) gameShaders.pop();
					while (hudShaders.length > 0) hudShaders.pop();
					defaultHudZoom = 1;
					camHUD.zoom = 1;
					return;
				}
				if (SONG.song.toLowerCase() != 'terminated') {
					dismantleScanlines = new FlxBackdrop(Paths.image('scanlines3'),Y);
					dismantleScanlines.scrollFactor.set();
					dismantleScanlines.screenCenter();
					dismantleScanlines.alpha = 0.8;
					dismantleScanlines.blend = BlendMode.LAYER;
					add(dismantleScanlines);
					dismantleScanlines.velocity.y = -20;
					dismantleScanlines.cameras = [camHUD];
				}


				var ntscShader = new shaders.NTSCShader();
				var coolwarp = CoolUtil.initializeShader('ChromCRT');
				coolwarp.setFloat('iTime',0.12);
				stage.updateiTime.push(coolwarp);
				addShader(coolwarp,'asd');
				addShader(ntscShader);
				defaultHudZoom = 0.9;
				camHUD.zoom = 0.9;
			case 'setNotePosition':
				setNotePosition(value1,value2);
			case 'snapZoom':
				defaultCamZoom = Std.parseFloat(value1);
				camGame.zoom = Std.parseFloat(value1);

			case 'TweenNotesAlpha':
				switch (value1.split(',')[0].toLowerCase().trim()) {
					case 'bf' | 'boyfriend' | 'player':
						for (i in 4...8) {
							if (eventTweensManager.exists('playerNoteAlpha$i')) eventTweensManager.get('playerNoteAlpha$i').cancel();
							eventTweensManager.set('playerNoteAlpha$i',eventTweens.tween(strumLineNotes.members[i], {alpha: Std.parseFloat(value1.split(',')[1])},Std.parseFloat(value1.split(',')[2]), {ease: FunkinLua.getFlxEaseByString(value2), onComplete: function (t:FlxTween) {
								eventTweensManager.remove('playerNoteAlpha$i');
							}}));
						}
					case 'dad' | 'opponent' | 'opp':
						for (i in 0...4) {
							if (eventTweensManager.exists('opponentNoteAlpha$i')) eventTweensManager.get('opponentNoteAlpha$i').cancel();
							eventTweensManager.set('opponentNoteAlpha$i',eventTweens.tween(strumLineNotes.members[i], {alpha: Std.parseFloat(value1.split(',')[1])},Std.parseFloat(value1.split(',')[2]), {ease: FunkinLua.getFlxEaseByString(value2), onComplete: function (t:FlxTween) {
								eventTweensManager.remove('opponentNoteAlpha$i');
							}}));
						}
					}
			case 'TweenObjectAlpha':
				try {
					var alphaObj:Dynamic;
					if (value1.split(',')[0].startsWith('stage.')) alphaObj = stage.getElement(value1.split(',')[0]);
					else alphaObj = FunkinLua.getObjectDirectly(value1.split(',')[0]);
					if (eventTweensManager.exists('objectTweenAlpha${value1.split(',')[0]}')) eventTweensManager.get('objectTweenAlpha${value1.split(',')[0]}').cancel();
					eventTweensManager.set('objectTweenAlpha${value1.split(',')[0]}',eventTweens.tween(alphaObj, {alpha: Std.parseFloat(value1.split(',')[1])},Std.parseFloat(value1.split(',')[2]), {ease: FunkinLua.getFlxEaseByString(value2), onComplete: function (t:FlxTween) {
						eventTweensManager.remove('objectTweenAlpha${value1.split(',')[0]}');
					}}));
				}
				catch(e:Dynamic) {
					FlxG.log.error('TweenAlpha failed! Object "${value1.split(',')[0]}" is null!\n"${value1.split(',')[0]}" Error: $e');
					return;
				}

			case 'mosaic':
				if (ClientPrefs.shaders) {
					var mosaic = new MosiacShader();
					addShader(mosaic);
					eventTweens.tween(mosaic, {pixelSize: Std.parseFloat(value1.split(',')[0])},Std.parseFloat(value1.split(',')[1]), {ease: FunkinLua.getFlxEaseByString(value2), onComplete: function (f:FlxTween) {
						if (value1.split(',')[2] != null) eventTweens.tween(mosaic, {pixelSize: 0},Std.parseFloat(value1.split(',')[1])/2, {ease: FunkinLua.getFlxEaseByString(value2), onComplete: function (f:FlxTween) {
							removeShader(mosaic);
						}})
						else {
							removeShader(mosaic);
						}
					}});
				}
			case 'tweenZoom':
				if (eventTweensManager.exists('gameCameraZoom')) eventTweensManager.get('gameCameraZoom').cancel();
				if (eventTweensManager.exists('hudCameraZoom')) eventTweensManager.get('hudCameraZoom').cancel();

				camZooming = false;
				if (value1.split(',')[2] != null) defaultCamZoom = Std.parseFloat(value1.split(',')[0]);
				//	trace('defaultzoom' + defaultCamZoom);
				eventTweensManager.set('gameCameraZoom',eventTweens.tween(FlxG.camera, {zoom: Std.parseFloat(value1.split(',')[0])},Std.parseFloat(value1.split(',')[1]), {ease: FunkinLua.getFlxEaseByString(value2), onComplete: function (t:FlxTween) {
					//if (value1.split(',')[2] != null)  FlxG.camera.zoom = defaultCamZoom;
					camZooming = true;
					//trace('defaultzoomPost' + defaultCamZoom);
					eventTweensManager.remove('gameCameraZoom');
				}}));
				if (value1.split(',')[2] == null) {
					eventTweensManager.set('hudCameraZoom',eventTweens.tween(camHUD, {zoom: camHUD.zoom + Std.parseFloat(value1.split(',')[0])/50},Std.parseFloat(value1.split(',')[1]), {ease: FunkinLua.getFlxEaseByString(value2), onComplete: function (t:FlxTween) {
						eventTweensManager.remove('hudCameraZoom');
					}}));
				}


			case 'updateHUD':
				updateHUD();
			case 'BGswap':
				stage.bgSwap(Std.parseInt(value1));
			case 'Dadbattle Spotlight':
				var val:Null<Int> = Std.parseInt(value1);
				if(val == null) val = 0;

				switch(Std.parseInt(value1))
				{
					case 1, 2, 3: //enable and target dad
						if(val == 1) //enable
						{
							dadbattleBlack.visible = true;
							dadbattleLight.visible = true;
							dadbattleSmokes.visible = true;
							defaultCamZoom += 0.12;
						}

						var who:Character = dad;
						if(val > 2) who = boyfriend;
						//2 only targets dad
						dadbattleLight.alpha = 0;
						new FlxTimer().start(0.12, function(tmr:FlxTimer) {
							dadbattleLight.alpha = 0.375;
						});
						dadbattleLight.setPosition(who.getGraphicMidpoint().x - dadbattleLight.width / 2, who.y + who.height - dadbattleLight.height + 50);

					default:
						dadbattleBlack.visible = false;
						dadbattleLight.visible = false;
						defaultCamZoom -= 0.12;
						FlxTween.tween(dadbattleSmokes, {alpha: 0}, 1, {onComplete: function(twn:FlxTween)
						{
							dadbattleSmokes.visible = false;
						}});
				}

			case 'Hey!':
				var value:Int = 2;
				switch(value1.toLowerCase().trim()) {
					case 'bf' | 'boyfriend' | '0':
						value = 0;
					case 'gf' | 'girlfriend' | '1':
						value = 1;
				}

				var time:Float = Std.parseFloat(value2);
				if(Math.isNaN(time) || time <= 0) time = 0.6;

				if(value != 0) {
					if(dad.curCharacter.startsWith('gf')) { //Tutorial GF is actually Dad! The GF is an imposter!! ding ding ding ding ding ding ding, dindinding, end my suffering
						dad.playAnim('cheer', true);
						dad.specialAnim = true;
						dad.heyTimer = time;
					} else if (gf != null) {
						gf.playAnim('cheer', true);
						gf.specialAnim = true;
						gf.heyTimer = time;
					}

					if(curStage == 'mall') {
						bottomBoppers.animation.play('hey', true);
						heyTimer = time;
					}
				}
				if(value != 1) {
					boyfriend.playAnim('hey', true);
					boyfriend.specialAnim = true;
					boyfriend.heyTimer = time;
				}

			case 'Set GF Speed':
				var value:Int = Std.parseInt(value1);
				if(Math.isNaN(value) || value < 1) value = 1;
				gfSpeed = value;

			case 'Philly Glow':
				var lightId:Int = Std.parseInt(value1);
				if(Math.isNaN(lightId)) lightId = 0;

				var doFlash:Void->Void = function() {
					var color:FlxColor = FlxColor.WHITE;
					if(!ClientPrefs.flashing) color.alphaFloat = 0.5;

					FlxG.camera.flash(color, 0.15, null, true);
				};

				var chars:Array<Character> = [boyfriend, gf, dad];
				switch(lightId)
				{
					case 0:
						if(phillyGlowGradient.visible)
						{
							doFlash();
							if(ClientPrefs.camZooms)
							{
								FlxG.camera.zoom += 0.5;
								camHUD.zoom += 0.1;
							}

							blammedLightsBlack.visible = false;
							phillyWindowEvent.visible = false;
							phillyGlowGradient.visible = false;
							phillyGlowParticles.visible = false;
							curLightEvent = -1;

							for (who in chars)
							{
								who.color = FlxColor.WHITE;
							}
							phillyStreet.color = FlxColor.WHITE;
						}

					case 1: //turn on
						curLightEvent = FlxG.random.int(0, phillyLightsColors.length-1, [curLightEvent]);
						var color:FlxColor = phillyLightsColors[curLightEvent];

						if(!phillyGlowGradient.visible)
						{
							doFlash();
							if(ClientPrefs.camZooms)
							{
								FlxG.camera.zoom += 0.5;
								camHUD.zoom += 0.1;
							}

							blammedLightsBlack.visible = true;
							blammedLightsBlack.alpha = 1;
							phillyWindowEvent.visible = true;
							phillyGlowGradient.visible = true;
							phillyGlowParticles.visible = true;
						}
						else if(ClientPrefs.flashing)
						{
							var colorButLower:FlxColor = color;
							colorButLower.alphaFloat = 0.25;
							FlxG.camera.flash(colorButLower, 0.5, null, true);
						}

						var charColor:FlxColor = color;
						if(!ClientPrefs.flashing) charColor.saturation *= 0.5;
						else charColor.saturation *= 0.75;

						for (who in chars)
						{
							who.color = charColor;
						}
						phillyGlowParticles.forEachAlive(function(particle:PhillyGlow.PhillyGlowParticle)
						{
							particle.color = color;
						});
						phillyGlowGradient.color = color;
						phillyWindowEvent.color = color;

						color.brightness *= 0.5;
						phillyStreet.color = color;

					case 2: // spawn particles
						if(!ClientPrefs.lowQuality)
						{
							var particlesNum:Int = FlxG.random.int(8, 12);
							var width:Float = (2000 / particlesNum);
							var color:FlxColor = phillyLightsColors[curLightEvent];
							for (j in 0...3)
							{
								for (i in 0...particlesNum)
								{
									var particle:PhillyGlow.PhillyGlowParticle = new PhillyGlow.PhillyGlowParticle(-400 + width * i + FlxG.random.float(-width / 5, width / 5), phillyGlowGradient.originalY + 200 + (FlxG.random.float(0, 125) + j * 40), color);
									phillyGlowParticles.add(particle);
								}
							}
						}
						phillyGlowGradient.bop();
				}

			case 'Kill Henchmen':
				killHenchmen();

			case 'Add Camera Zoom':
				if(ClientPrefs.camZooms /*&& FlxG.camera.zoom < 1.35*/) {
					var camZoom:Float = Std.parseFloat(value1);
					var hudZoom:Float = Std.parseFloat(value2);
					if(Math.isNaN(camZoom)) camZoom = 0.015;
					if(Math.isNaN(hudZoom)) hudZoom = 0.03;

					FlxG.camera.zoom += camZoom;
					camHUD.zoom += hudZoom;
				}

			case 'Trigger BG Ghouls':
				if(curStage == 'schoolEvil' && !ClientPrefs.lowQuality) {
					bgGhouls.dance(true);
					bgGhouls.visible = true;
				}

			case 'Play Animation':
				//trace('Anim to play: ' + value1);
				var char:Character = dad;
				switch(value2.toLowerCase().trim()) {
					case 'bf' | 'boyfriend':
						char = boyfriend;
					case 'gf' | 'girlfriend':
						char = gf;
					default:
						var val2:Int = Std.parseInt(value2);
						if(Math.isNaN(val2)) val2 = 0;

						switch(val2) {
							case 1: char = boyfriend;
							case 2: char = gf;
						}
				}

				if (char != null)
				{
					char.playAnim(value1, true);
					char.specialAnim = true;
				}

			case 'Camera Follow Pos':
				if(camFollow != null)
				{
					var val1:Float = Std.parseFloat(value1);
					var val2:Float = Std.parseFloat(value2);
					if(Math.isNaN(val1)) val1 = 0;
					if(Math.isNaN(val2)) val2 = 0;

					isCameraOnForcedPos = false;
					if(!Math.isNaN(Std.parseFloat(value1)) || !Math.isNaN(Std.parseFloat(value2))) {
						camFollow.x = val1;
						camFollow.y = val2;
						isCameraOnForcedPos = true;
					}
				}

			case 'Alt Idle Animation':
				var char:Character = dad;
				switch(value1.toLowerCase().trim()) {
					case 'gf' | 'girlfriend':
						char = gf;
					case 'boyfriend' | 'bf':
						char = boyfriend;
					default:
						var val:Int = Std.parseInt(value1);
						if(Math.isNaN(val)) val = 0;

						switch(val) {
							case 1: char = boyfriend;
							case 2: char = gf;
						}
				}

				if (char != null)
				{
					char.idleSuffix = value2;
					char.recalculateDanceIdle();
				}

			case 'Screen Shake':
				var valuesArray:Array<String> = [value1, value2];
				var targetsArray:Array<FlxCamera> = [camGame, camHUD];
				for (i in 0...targetsArray.length) {
					var split:Array<String> = valuesArray[i].split(',');
					var duration:Float = 0;
					var intensity:Float = 0;
					if(split[0] != null) duration = Std.parseFloat(split[0].trim());
					if(split[1] != null) intensity = Std.parseFloat(split[1].trim());
					if(Math.isNaN(duration)) duration = 0;
					if(Math.isNaN(intensity)) intensity = 0;

					if(duration > 0 && intensity != 0) {
						targetsArray[i].shake(intensity, duration);
					}
				}


			case 'Change Character':
				var charType:Int = 0;
				switch(value1.toLowerCase().trim()) {
					case 'gf' | 'girlfriend':
						charType = 2;
					case 'dad' | 'opponent':
						charType = 1;
					default:
						charType = Std.parseInt(value1);
						if(Math.isNaN(charType)) charType = 0;
				}

				switch(charType) {
					case 0:
						if(boyfriend.curCharacter != value2) {
							var ogShader:Dynamic = null;
							if (ClientPrefs.superfuckingHD) {
								ogShader = boyfriend.shader;
							}
							if (boyfriend.shader != null) { //maybe
								boyfriend.shader = null;
							}
							if(!boyfriendMap.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							var lastAlpha:Float = boyfriend.alpha;
							boyfriend.alpha = 0.00001;
							boyfriend = boyfriendMap.get(value2);
							boyfriend.alpha = lastAlpha;
							iconP1.changeIcon(boyfriend.healthIcon);
							if (ClientPrefs.superfuckingHD) {
								boyfriend.shader = ogShader;
							}
						}
						setOnLuas('boyfriendName', boyfriend.curCharacter);

					case 1:
						if(dad.curCharacter != value2) {
							var ogShader:Dynamic = null;
							if (ClientPrefs.superfuckingHD) {
								ogShader = dad.shader;
							}
							if (dad.shader != null) { //maybe
								dad.shader = null;
							}
							if(!dadMap.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							var wasGf:Bool = dad.curCharacter.startsWith('gf');
							var lastAlpha:Float = dad.alpha;
							dad.alpha = 0.00001;
							dad = dadMap.get(value2);
							if(!dad.curCharacter.startsWith('gf')) {
								if(wasGf && gf != null) {
									gf.visible = true;
								}
							} else if(gf != null) {
								gf.visible = false;
							}
							dad.alpha = lastAlpha;
							iconP2.changeIcon(dad.healthIcon);
							if (ClientPrefs.superfuckingHD) {
								dad.shader = ogShader;
							}
						}
						setOnLuas('dadName', dad.curCharacter);

					case 2:
						if(gf != null)
						{
							if(gf.curCharacter != value2)
							{
								var ogShader:Dynamic = null;
								if (ClientPrefs.superfuckingHD) {
									ogShader = gf.shader;
								}
								if (gf.shader != null) { //maybe
									gf.shader = null;
								}
								if(!gfMap.exists(value2))
								{
									addCharacterToList(value2, charType);
								}

								var lastAlpha:Float = gf.alpha;
								gf.alpha = 0.00001;
								gf = gfMap.get(value2);
								gf.alpha = lastAlpha;
								if (ClientPrefs.superfuckingHD) {
									gf.shader = ogShader;
								}
							}
							setOnLuas('gfName', gf.curCharacter);
						}
				}
				reloadHealthBarColors();
				stage.updateChars();

			case 'BG Freaks Expression':
				if(bgGirls != null) bgGirls.swapDanceType();

			case 'Change Scroll Speed':
				if (songSpeedType == "constant")
					return;
				var val1:Float = Std.parseFloat(value1);
				var val2:Float = Std.parseFloat(value2);
				if(Math.isNaN(val1)) val1 = 1;
				if(Math.isNaN(val2)) val2 = 0;

				var newValue:Float = SONG.speed * ClientPrefs.getGameplaySetting('scrollspeed', 1) * val1;

				if(val2 <= 0)
				{
					songSpeed = newValue;
				}
				else
				{
					songSpeedTween = FlxTween.tween(this, {songSpeed: newValue}, val2 / playbackRate, {ease: FlxEase.linear, onComplete:
						function (twn:FlxTween)
						{
							songSpeedTween = null;
						}
					});
				}

			case 'Set Property':
				var killMe:Array<String> = value1.split('.');
				if(killMe.length > 1) {
					FunkinLua.setVarInArray(FunkinLua.getPropertyLoopThingWhatever(killMe, true, true), killMe[killMe.length-1], value2);
				} else {
					FunkinLua.setVarInArray(this, value1, value2);
				}
		}
		callOnLuas('onEvent', [eventName, value1, value2]);
	}

	function moveCameraSection(?id:Int = 0, isNote:Bool = false):Void {
		if(SONG.notes[id] == null || curStage == 'vhs') return;

		if (gf != null && SONG.notes[id].gfSection)
		{
			var yOffsetB:Float = 0;
			var xOffsetB:Float = 0;
			if (ClientPrefs.followChars){
				if (gf.animation.curAnim.name.startsWith('singUP')){
					yOffsetB = -camOffset;
					xOffsetB = 0;
				}
				else if (gf.animation.curAnim.name.startsWith('singDOWN')){
					yOffsetB = camOffset;
					xOffsetB = 0;
				}
				else if (gf.animation.curAnim.name.startsWith('singLEFT')){
					yOffsetB = 0;
					xOffsetB = -camOffset;
				}
				else if (gf.animation.curAnim.name.startsWith('singRIGHT')){
					yOffsetB = 0;
					xOffsetB = camOffset;
				}
				else if (!gf.animation.curAnim.name.startsWith('sing')){
					yOffsetB = 0;
					xOffsetB = 0;
				}
			}
			camFollow.set(gf.getMidpoint().x + xOffsetB, gf.getMidpoint().y + yOffsetB);
			camFollow.x += gf.cameraPosition[0] + girlfriendCameraOffset[0];
			camFollow.y += gf.cameraPosition[1] + girlfriendCameraOffset[1];
			callOnLuas('onMoveCamera', ['gf']);
			return;
		}

		if (!SONG.notes[id].mustHitSection)
		{
			moveCamera(true, true);
			callOnLuas('onMoveCamera', ['dad']);
		}
		else
		{
			moveCamera(false, true);
			callOnLuas('onMoveCamera', ['boyfriend']);
		}
	}

	var cameraTwn:FlxTween;
	public function moveCamera(isDad:Bool, isNote:Bool = false)
	{
		var boyfriendCamDisplace:Array<Float> = [0.,0.];
		var dadCamDisplace:Array<Float> = [0.,0.0];
		var offsets:Array<Float> = [0.,0.];
		if (isNote && ClientPrefs.followChars){
			if (isCameraOnForcedDad) isDad = true;
			if (isCameraOnForcedBoyfriend) isDad = false;
			var char = isDad ? dad : boyfriend;
			switch (char.animation.curAnim.name) {
				case 'singUP' | 'singUP-alt':
					offsets = [0,-camOffset];
				case 'singDOWN' | 'singDOWN-alt':
					offsets = [0,camOffset];
				case 'singLEFT' | 'singLEFT-alt':
					offsets = [-camOffset,0];
				case 'singRIGHT' | 'singRIGHT-alt':
					offsets = [camOffset,0];
					
			}
			dadCamDisplace[0] *= noteMoveMultDad[0]; //purpose is if u want more SPECIFIC cam move control otherwise just use camOffset
			dadCamDisplace[1] *= noteMoveMultDad[1];
			boyfriendCamDisplace[0] *= noteMoveMultBf[0];
			boyfriendCamDisplace[1] *= noteMoveMultBf[1];
		}
		if (SONG.notes[curSection].mustHitSection) boyfriendCamDisplace = offsets;
		else dadCamDisplace = offsets;

		if (isCameraOnForcedDad)  {
			dadCamDisplace = offsets;
			boyfriendCamDisplace = [0,0];
		}
		if (isCameraOnForcedBoyfriend) {
			boyfriendCamDisplace = offsets;
			dadCamDisplace = [0,0];
		}

		if(isDad)
		{
			camFollow.set(dad.getMidpoint().x + 150 + dadCamDisplace[0], dad.getMidpoint().y - 100 + dadCamDisplace[1]);
			camFollow.x += dad.cameraPosition[0] + opponentCameraOffset[0];
			camFollow.y += dad.cameraPosition[1] + opponentCameraOffset[1];
		}
		else
		{
			camFollow.set(boyfriend.getMidpoint().x - 100 + boyfriendCamDisplace[0], boyfriend.getMidpoint().y - 100 + boyfriendCamDisplace[1]);
			camFollow.x -= boyfriend.cameraPosition[0] - boyfriendCameraOffset[0];
			camFollow.y += boyfriend.cameraPosition[1] + boyfriendCameraOffset[1];
		}
	}


	public function snapCamToCharacter(?char:String = 'bf') {
		var point = new FlxPoint(0,0);
		switch (char.toLowerCase().trim()) {
			case 'bf' | 'boyfriend':
				point.set(
					boyfriend.getMidpoint().x - 100 - (boyfriend.cameraPosition[0] - boyfriendCameraOffset[0]),
					boyfriend.getMidpoint().y - 100 + (boyfriend.cameraPosition[1] + boyfriendCameraOffset[1])
				);
			case 'dad':
				point.set(
					dad.getMidpoint().x + 150 + (dad.cameraPosition[0] + opponentCameraOffset[0]),
					dad.getMidpoint().y - 100 + (dad.cameraPosition[1] + opponentCameraOffset[1])
				);
			case 'gf' | 'girlfriend':
				point.set(
					gf.getMidpoint().x + ( gf.cameraPosition[0] + girlfriendCameraOffset[0]),
					gf.getMidpoint().y + (gf.cameraPosition[1] + girlfriendCameraOffset[1])
				);
		}
		snapCamFollowToPos(point.x,point.y);
	}

	function snapCamFollowToPos(x:Float, y:Float) {
		camFollow.set(x, y);
		camFollowPos.setPosition(x, y);
	}

	public function finishSong(?ignoreNoteOffset:Bool = false):Void
	{
		var finishCallback:Void->Void = endSong; //In case you want to change it in a specific song.

		updateTime = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		vocals.pause();
		if(ClientPrefs.noteOffset <= 0 || ignoreNoteOffset) {
			finishCallback();
		} else {
			finishTimer = new FlxTimer().start(ClientPrefs.noteOffset / 1000, function(tmr:FlxTimer) {
				finishCallback();
			});
		}
	}


	public var transitioning = false;
	public var notSeenEndingCutscene:Bool = true;
	public function endSong():Void
	{
		//Should kill you if you tried to cheat
		if(!startingSong) {
			notes.forEach(function(daNote:Note) {
				if(daNote.strumTime < songLength - Conductor.safeZoneOffset) {
					health -= 0.05 * healthLoss;
				}
			});
			for (daNote in unspawnNotes) {
				if(daNote.strumTime < songLength - Conductor.safeZoneOffset) {
					health -= 0.05 * healthLoss;
				}
			}

			if(doDeathCheck()) {
				return;
			}
		}

		timeBarBG.visible = false;
		timeBar.visible = false;
		timeTxt.visible = false;
		canPause = false;
		endingSong = true;
		camZooming = false;
		inCutscene = false;
		updateTime = false;

		deathCounter = 0;
		seenCutscene = false;

		#if ACHIEVEMENTS_ALLOWED
		if(achievementObj != null) {
			return;
		} else {
			var achieve:String = checkForAchievement(['week1_nomiss', 'week2_nomiss', 'week3_nomiss', 'week4_nomiss',
				'week5_nomiss', 'week6_nomiss', 'week7_nomiss', 'ur_bad',
				'ur_good', 'hype', 'two_keys', 'toastie', 'debugger']);

			if(achieve != null) {
				startAchievement(achieve);
				return;
			}
		}
		#end

		// var daGAMES = SONG.song.toLowerCase();
		// if (notSeenEndingCutscene) {
		// 	switch (daGAMES) {
		// 		case 'terminated':
		// 			var black = new FlxSprite().makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
		// 			black.cameras = [camOther];
		// 			add(black);
		// 			startVideo(daGAMES);
		// 	}
		// 	notSeenEndingCutscene = false;
		// 	return;
		// }


		var ret:Dynamic = callOnLuas('onEndSong', [], false);
		if(ret != FunkinLua.Function_Stop && !transitioning) {
			if (SONG.validScore)
			{
				#if !switch
				var fcmaybe = '';
				if (ratingFC.contains('FC')) fcmaybe = 'fc';
				if (ratingFC == 'SFC') fcmaybe = 'pfc';
				var percent:Float = ratingPercent;
				if(Math.isNaN(percent)) percent = 0;
				trace(storyDifficulty);
				Highscore.saveScore(SONG.song, songScore, storyDifficulty, percent,fcmaybe);
				#end
			}
			playbackRate = 1;

			if (chartingMode)
			{
				openChartEditor();
				return;
			}

			if (isStoryMode)
			{
				campaignScore += songScore;
				campaignMisses += songMisses;

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					WeekData.loadTheFirstEnabledMod();
					FlxG.sound.playMusic(Paths.music('freakyMenu'));

					cancelMusicFadeTween();
					if(FlxTransitionableState.skipNextTransIn) {
						CustomFadeTransition.nextCamera = null;
					}
					MusicBeatState.switchState(new OurpleStoryState());

					// if ()
					if(!ClientPrefs.getGameplaySetting('practice', false) && !ClientPrefs.getGameplaySetting('botplay', false)) {
						StoryMenuState.weekCompleted.set(WeekData.weeksList[storyWeek], true);

						if (SONG.validScore)
						{
							Highscore.saveWeekScore(WeekData.getWeekFileName(), campaignScore, storyDifficulty);
						}

						FlxG.save.data.weekCompleted = StoryMenuState.weekCompleted;
						FlxG.save.flush();
					}
					changedDifficulty = false;
				}
				else
				{
					var difficulty:String = CoolUtil.getDifficultyFilePath();

					trace('LOADING NEXT SONG');
					trace(Paths.formatToSongPath(PlayState.storyPlaylist[0]) + difficulty);

					var winterHorrorlandNext = (Paths.formatToSongPath(SONG.song) == "eggnog");
					if (winterHorrorlandNext)
					{
						var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
							-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
						blackShit.scrollFactor.set();
						add(blackShit);
						camHUD.visible = false;

						FlxG.sound.play(Paths.sound('Lights_Shut_off'));
					}

					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;

					prevCamFollow = camFollow;
					prevCamFollowPos = camFollowPos;

					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0] + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					if(winterHorrorlandNext) {
						new FlxTimer().start(1.5, function(tmr:FlxTimer) {
							cancelMusicFadeTween();
							LoadingState.loadAndSwitchState(new PlayState());
						});
					} else {
						cancelMusicFadeTween();
						LoadingState.loadAndSwitchState(new PlayState());
					}
				}
			}
			else
			{
				trace('WENT BACK TO FREEPLAY??');
				WeekData.loadTheFirstEnabledMod();
				cancelMusicFadeTween();
				if(FlxTransitionableState.skipNextTransIn) {
					CustomFadeTransition.nextCamera = null;
				}

				if (ratingFC.contains('FC')) FreeplayState.fanfare = 'FC';
				if (ratingFC == 'SFC') FreeplayState.fanfare = 'PFC';
				

				
				MusicBeatState.switchState(new FreeplayState());
				//FlxG.sound.playMusic(Paths.music('fp'));
				changedDifficulty = false;
			}
			transitioning = true;
		}
	}

	#if ACHIEVEMENTS_ALLOWED
	var achievementObj:AchievementObject = null;
	function startAchievement(achieve:String) {
		achievementObj = new AchievementObject(achieve, camOther);
		achievementObj.onFinish = achievementEnd;
		add(achievementObj);
		trace('Giving achievement ' + achieve);
	}
	function achievementEnd():Void
	{
		achievementObj = null;
		if(endingSong && !inCutscene) {
			endSong();
		}
	}
	#end

	public function KillNotes() {
		while(notes.length > 0) {
			var daNote:Note = notes.members[0];
			daNote.active = false;
			daNote.visible = false;

			daNote.kill();
			notes.remove(daNote, true);
			daNote.destroy();
		}
		unspawnNotes = [];
		eventNotes = [];
	}

	public var totalPlayed:Int = 0;
	public var totalNotesHit:Float = 0.0;

	public var showCombo:Bool = false;
	public var showComboNum:Bool = true;
	public var showRating:Bool = true;

	private function cachePopUpScore()
	{
		var pixelShitPart1:String = '';
		var pixelShitPart2:String = '';
		if (isPixelStage)
		{
			pixelShitPart1 = 'pixelHUD/';
			pixelShitPart2 = '-pixel';
		}

		var followed:String = '';
		if (SONG.song.toLowerCase() == 'followed') followed = 'followed/';

		Paths.image(pixelShitPart1 + followed + "sick" + pixelShitPart2,SONG.song.toLowerCase() == 'followed' ? 'ourplesecrets' : null);
		Paths.image(pixelShitPart1 + followed + "sick100" + pixelShitPart2,SONG.song.toLowerCase() == 'followed' ? 'ourplesecrets' : null);
		Paths.image(pixelShitPart1 + followed + "good" + pixelShitPart2,SONG.song.toLowerCase() == 'followed' ? 'ourplesecrets' : null);
		Paths.image(pixelShitPart1 + followed + "bad" + pixelShitPart2,SONG.song.toLowerCase() == 'followed' ? 'ourplesecrets' : null);
		Paths.image(pixelShitPart1 + followed + "shit" + pixelShitPart2,SONG.song.toLowerCase() == 'followed' ? 'ourplesecrets' : null);
		Paths.image(pixelShitPart1 + "combo" + pixelShitPart2);
		
		for (i in 0...10) {
			Paths.image(pixelShitPart1 + 'num' + i + pixelShitPart2);
		}
	}


	private function popUpScore(note:Note = null):Void
	{
		var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition + ClientPrefs.ratingOffset);
		//trace(noteDiff, ' ' + Math.abs(note.strumTime - Conductor.songPosition));

		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.35;
		//

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;

		//tryna do MS based judgment due to popular demand
		var daRating:Rating = Conductor.judgeNote(note, noteDiff / playbackRate);

		totalNotesHit += daRating.ratingMod;
		note.ratingMod = daRating.ratingMod;
		if(!note.ratingDisabled) daRating.increase();
		note.rating = daRating.name;
		score = daRating.score;

		if(daRating.noteSplash && !note.noteSplashDisabled)
		{
			spawnNoteSplashOnNote(note);
		}

		if(!practiceMode && !cpuControlled) {
			songScore += score;
			if(!note.ratingDisabled)
			{
				songHits++;
				totalPlayed++;
				RecalculateRating(false);
			}
		}

		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';
		var followed:String = SONG.song.toLowerCase() == 'followed' ? 'followed/' : '';

		if (PlayState.isPixelStage)
		{
			pixelShitPart1 = 'pixelHUD/';
			pixelShitPart2 = '-pixel';
		}

		var isitonehundra:String = '';
		if (ratingFC == 'SFC' && (daRating.image == 'sick')) isitonehundra = '100';

		rating.loadGraphic(Paths.image(pixelShitPart1 + followed + daRating.image + isitonehundra + pixelShitPart2,SONG.song.toLowerCase() == 'followed' ? 'ourplesecrets' : null));
		rating.cameras = [camHUD];
		rating.setPosition(iconP1.getGraphicMidpoint().x + 75, iconP1.getGraphicMidpoint().y - 50);
		rating.acceleration.y = 550 * playbackRate * playbackRate;
		rating.velocity.y -= FlxG.random.int(140, 200) * playbackRate;
		rating.velocity.x -= FlxG.random.int(0, 20) * playbackRate;
		rating.visible = (!ClientPrefs.hideHud && showRating);
		rating.angle = FlxG.random.int( -10, 10);
		rating.angularVelocity = FlxG.random.int(-20, 20) * playbackRate;
		rating.scrollFactor.set();
		rating.scale.set(0.85, 0.85);
	
		if (isitonehundra == '100') {
			rating.color = FlxColor.YELLOW;
			FlxTween.color(rating, 0.25,FlxColor.YELLOW,FlxColor.WHITE);
		}


		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
		comboSpr.cameras = [camHUD];
		comboSpr.screenCenter();
		comboSpr.x = coolText.x;
		comboSpr.acceleration.y = FlxG.random.int(200, 300) * playbackRate * playbackRate;
		comboSpr.velocity.y -= FlxG.random.int(140, 160) * playbackRate;
		comboSpr.visible = (!ClientPrefs.hideHud && showCombo);
		comboSpr.x += ClientPrefs.comboOffset[0];
		comboSpr.y -= ClientPrefs.comboOffset[1];
		comboSpr.y += 60;
		comboSpr.velocity.x += FlxG.random.int(1, 10) * playbackRate;
		comboSpr.antialiasing = false;

		insert(members.indexOf(strumLineNotes), rating);
		
		if (!ClientPrefs.comboStacking)
		{
			if (lastRating != null) lastRating.kill();
			lastRating = rating;
		}

		if (!PlayState.isPixelStage)
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = ClientPrefs.globalAntialiasing;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = ClientPrefs.globalAntialiasing;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.85));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.85));
		}
		
		rating.antialiasing = false;

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		if(combo >= 1000) {
			seperatedScore.push(Math.floor(combo / 1000) % 10);
		}
		seperatedScore.push(Math.floor(combo / 100) % 10);
		seperatedScore.push(Math.floor(combo / 10) % 10);
		seperatedScore.push(combo % 10);

		var daLoop:Int = 0;
		var xThing:Float = 0;
		if (showCombo)
		{
			insert(members.indexOf(strumLineNotes), comboSpr);
		}
		if (!ClientPrefs.comboStacking)
		{
			if (lastCombo != null) lastCombo.kill();
			lastCombo = comboSpr;
		}
		if (lastScore != null)
		{
			while (lastScore.length > 0)
			{
				lastScore[0].kill();
				lastScore.remove(lastScore[0]);
			}
		}
		comboSpr.x = xThing + 50;
		/*
			trace(combo);
			trace(seperatedScore);
		 */

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2 / playbackRate, {
			startDelay: Conductor.crochet * 0.001 / playbackRate
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2 / playbackRate, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();

				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.002 / playbackRate
		});
	}

	public var strumsBlocked:Array<Bool> = [];
	private function onKeyPress(event:KeyboardEvent):Void
	{
		var eventKey:FlxKey = event.keyCode;
		var key:Int = getKeyFromEvent(eventKey);
		//trace('Pressed: ' + eventKey);

		if (!cpuControlled && startedCountdown && !paused && key > -1 && (FlxG.keys.checkStatus(eventKey, JUST_PRESSED) || ClientPrefs.controllerMode))
		{
			if(!boyfriend.stunned && generatedMusic && !endingSong)
			{
				//more accurate hit time for the ratings?
				var lastTime:Float = Conductor.songPosition;
				Conductor.songPosition = FlxG.sound.music.time;

				var canMiss:Bool = !ClientPrefs.ghostTapping;

				// heavily based on my own code LOL if it aint broke dont fix it
				var pressNotes:Array<Note> = [];
				//var notesDatas:Array<Int> = [];
				var notesStopped:Bool = false;

				var sortedNotesList:Array<Note> = [];
				notes.forEachAlive(function(daNote:Note)
				{
					if (strumsBlocked[daNote.noteData] != true && daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !daNote.isSustainNote && !daNote.blockHit)
					{
						if(daNote.noteData == key)
						{
							sortedNotesList.push(daNote);
							//notesDatas.push(daNote.noteData);
						}
						canMiss = true;
					}
				});
				sortedNotesList.sort(sortHitNotes);

				if (sortedNotesList.length > 0) {
					for (epicNote in sortedNotesList)
					{
						for (doubleNote in pressNotes) {
							if (Math.abs(doubleNote.strumTime - epicNote.strumTime) < 1) {
								doubleNote.kill();
								notes.remove(doubleNote, true);
								doubleNote.destroy();
							} else
								notesStopped = true;
						}

						// eee jack detection before was not super good
						if (!notesStopped) {
							goodNoteHit(epicNote);
							pressNotes.push(epicNote);
						}

					}
				}
				else{
					callOnLuas('onGhostTap', [key]);
					if (canMiss) {
						noteMissPress(key);
					}
				}

				// I dunno what you need this for but here you go
				//									- Shubs

				// Shubs, this is for the "Just the Two of Us" achievement lol
				//									- Shadow Mario
				keysPressed[key] = true;

				//more accurate hit time for the ratings? part 2 (Now that the calculations are done, go back to the time it was before for not causing a note stutter)
				Conductor.songPosition = lastTime;
			}

			var spr:StrumNote = playerStrums.members[key];
			if(strumsBlocked[key] != true && spr != null && spr.animation.curAnim.name != 'confirm')
			{
				spr.playAnim('pressed');
				spr.resetAnim = 0;
			}
			callOnLuas('onKeyPress', [key]);
		}
		//trace('pressed: ' + controlArray);
	}

	function sortHitNotes(a:Note, b:Note):Int
	{
		if (a.lowPriority && !b.lowPriority)
			return 1;
		else if (!a.lowPriority && b.lowPriority)
			return -1;

		return FlxSort.byValues(FlxSort.ASCENDING, a.strumTime, b.strumTime);
	}

	private function onKeyRelease(event:KeyboardEvent):Void
	{
		var eventKey:FlxKey = event.keyCode;
		var key:Int = getKeyFromEvent(eventKey);
		if(!cpuControlled && startedCountdown && !paused && key > -1)
		{
			var spr:StrumNote = playerStrums.members[key];
			if(spr != null)
			{
				spr.playAnim('static');
				spr.resetAnim = 0;
			}
			callOnLuas('onKeyRelease', [key]);
		}
		//trace('released: ' + controlArray);
	}

	private function getKeyFromEvent(key:FlxKey):Int
	{
		if(key != NONE)
		{
			for (i in 0...keysArray.length)
			{
				for (j in 0...keysArray[i].length)
				{
					if(key == keysArray[i][j])
					{
						return i;
					}
				}
			}
		}
		return -1;
	}

	// Hold notes
	private function keyShit():Void
	{
		// HOLDING
		var parsedHoldArray:Array<Bool> = parseKeys();

		// TO DO: Find a better way to handle controller inputs, this should work for now
		if(ClientPrefs.controllerMode)
		{
			var parsedArray:Array<Bool> = parseKeys('_P');
			if(parsedArray.contains(true))
			{
				for (i in 0...parsedArray.length)
				{
					if(parsedArray[i] && strumsBlocked[i] != true)
						onKeyPress(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, true, -1, keysArray[i][0]));
				}
			}
		}

		// FlxG.watch.addQuick('asdfa', upP);
		if (startedCountdown && !boyfriend.stunned && generatedMusic)
		{
			// rewritten inputs???
			notes.forEachAlive(function(daNote:Note)
			{
				// hold note functions
				if (strumsBlocked[daNote.noteData] != true && daNote.isSustainNote && parsedHoldArray[daNote.noteData] && daNote.canBeHit
				&& daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !daNote.blockHit) {
					goodNoteHit(daNote);
				}
			});

			if (parsedHoldArray.contains(true) && !endingSong) {
				#if ACHIEVEMENTS_ALLOWED
				var achieve:String = checkForAchievement(['oversinging']);
				if (achieve != null) {
					startAchievement(achieve);
				}
				#end
			}
			else if (boyfriend.animation.curAnim != null && boyfriend.holdTimer > Conductor.stepCrochet * (0.0011 / FlxG.sound.music.pitch) * boyfriend.singDuration && boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
			{
				boyfriend.dance();
				if (usingAltBF != '') altBoyfriend.dance();
				//boyfriend.animation.curAnim.finish();
			}
		}

		// TO DO: Find a better way to handle controller inputs, this should work for now
		if(ClientPrefs.controllerMode || strumsBlocked.contains(true))
		{
			var parsedArray:Array<Bool> = parseKeys('_R');
			if(parsedArray.contains(true))
			{
				for (i in 0...parsedArray.length)
				{
					if(parsedArray[i] || strumsBlocked[i] == true)
						onKeyRelease(new KeyboardEvent(KeyboardEvent.KEY_UP, true, true, -1, keysArray[i][0]));
				}
			}
		}
	}

	private function parseKeys(?suffix:String = ''):Array<Bool>
	{
		var ret:Array<Bool> = [];
		for (i in 0...controlArray.length)
		{
			ret[i] = Reflect.getProperty(controls, controlArray[i] + suffix);
		}
		return ret;
	}

	function noteMiss(daNote:Note):Void { //You didn't hit the key and let it go offscreen, also used by Hurt Notes
		//Dupe note remove
		notes.forEachAlive(function(note:Note) {
			if (daNote != note && daNote.mustPress && daNote.noteData == note.noteData && daNote.isSustainNote == note.isSustainNote && Math.abs(daNote.strumTime - note.strumTime) < 1) {
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		});
		combo = 0;
		health -= daNote.missHealth * healthLoss;
		
		if(instakillOnMiss)
		{
			vocals.volume = 0;
			doDeathCheck(true);
		}

		//For testing purposes
		//trace(daNote.missHealth);
		songMisses++;
		vocals.volume = 0;
		if(!practiceMode) songScore -= 10;

		totalPlayed++;
		RecalculateRating(true);

		var char:Character = boyfriend;
		if(daNote.gfNote) {
			char = gf;
		}

		if(char != null && !daNote.noMissAnimation && char.hasMissAnimations)
		{
			var animToPlay:String = singAnimations[Std.int(Math.abs(daNote.noteData))] + 'miss' + daNote.animSuffix;
			char.playAnim(animToPlay, true);
		}

		callOnLuas('noteMiss', [notes.members.indexOf(daNote), daNote.noteData, daNote.noteType, daNote.isSustainNote]);
	}

	function noteMissPress(direction:Int = 1):Void //You pressed a key when there was no notes to press for this key
	{
		if(ClientPrefs.ghostTapping) return; //fuck it

		if (!boyfriend.stunned)
		{
			health -= 0.05 * healthLoss;
			if(instakillOnMiss)
			{
				vocals.volume = 0;
				doDeathCheck(true);
			}

			if (combo > 5 && gf != null && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;

			if(!practiceMode) songScore -= 10;
			if(!endingSong) {
				songMisses++;
			}
			totalPlayed++;
			RecalculateRating(true);

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			/*boyfriend.stunned = true;

			// get stunned for 1/60 of a second, makes you able to
			new FlxTimer().start(1 / 60, function(tmr:FlxTimer)
			{
				boyfriend.stunned = false;
			});*/

			if (usingAltBF != '') if (altBoyfriend.hasMissAnimations) altBoyfriend.playAnim(singAnimations[Std.int(Math.abs(direction))] + 'miss', true);
			if(boyfriend.hasMissAnimations) {
				boyfriend.playAnim(singAnimations[Std.int(Math.abs(direction))] + 'miss', true);
			}
			vocals.volume = 0;
		}
		callOnLuas('noteMissPress', [direction]);
	}

	function opponentNoteHit(note:Note):Void
	{

		if (Paths.formatToSongPath(SONG.song) != 'tutorial')
			camZooming = true;

		if(note.noteType == 'Hey!' && dad.animOffsets.exists('hey')) {
			dad.playAnim('hey', true);
			dad.specialAnim = true;
			dad.heyTimer = 0.6;
		} else if(!note.noAnimation) {
			var altAnim:String = note.animSuffix;

			if (SONG.notes[curSection] != null)
			{
				if (SONG.notes[curSection].altAnim && !SONG.notes[curSection].gfSection) {
					altAnim = '-alt';
				}
			}

			var char:Character = dad;
			var animToPlay:String = singAnimations[Std.int(Math.abs(note.noteData))] + altAnim;
			if(note.gfNote) {
				char = gf;
			}

			if(char != null)
			{
				char.playAnim(animToPlay, true);
				char.holdTimer = 0;
			}
		}

		if (SONG.needsVoices)
			vocals.volume = 1;

		var time:Float = 0.15;
		if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end')) {
			time += 0.15;
		}
		StrumPlayAnim(true, Std.int(Math.abs(note.noteData)), time);
		note.hitByOpponent = true;

		callOnLuas('opponentNoteHit', [notes.members.indexOf(note), Math.abs(note.noteData), note.noteType, note.isSustainNote]);
		stage.opponenetNoteHit();

		if (!note.isSustainNote)
		{
			if (ClientPrefs.superfuckingHD) {
				if (FlxG.sound.music.volume != 0)
					FlxG.sound.music.volume = 0;

				var foot:FlxSound = new FlxSound().loadEmbedded(Paths.sound('HD/' + SONG.song.toLowerCase() + '/foot'));
				//foot.pitch = 0.1;
				foot.play();

			}
			note.kill();
			notes.remove(note, true);
			note.destroy();
		}
	}

	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit)
		{
			if(cpuControlled && (note.ignoreNote || note.hitCausesMiss)) return;

			if (ClientPrefs.hitsoundVolume > 0 && !note.hitsoundDisabled)
			{
				FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.hitsoundVolume);
			}

			if(note.hitCausesMiss) {
				noteMiss(note);
				if(!note.noteSplashDisabled && !note.isSustainNote) {
					spawnNoteSplashOnNote(note);
				}

				if(!note.noMissAnimation)
				{
					switch(note.noteType) {
						case 'Hurt Note': //Hurt note
							if(boyfriend.animation.getByName('hurt') != null) {
								boyfriend.playAnim('hurt', true);
								boyfriend.specialAnim = true;
							}
					}
				}

				note.wasGoodHit = true;
				if (!note.isSustainNote)
				{
					note.kill();
					notes.remove(note, true);
					note.destroy();
				}
				return;
			}

			if (!note.isSustainNote)
			{
				combo += 1;
				if(combo > 9999) combo = 9999;
				popUpScore(note);

				if (ClientPrefs.superfuckingHD) {
					if (FlxG.sound.music.volume != 0)
						FlxG.sound.music.volume = 0;
					// var foot:FlxSound = new FlxSound().loadEmbedded(Paths.sound('hdfoot'));
					// //foot.pitch();
					// foot.pitch = FlxG.random.float(0.5,1);
					// foot.play();
				}
			}
			health += note.hitHealth * healthGain;

			if(!note.noAnimation) {
				var animToPlay:String = singAnimations[Std.int(Math.abs(note.noteData))];

				if(note.gfNote)
				{
					if(gf != null)
					{
						gf.playAnim(animToPlay + note.animSuffix, true);
						gf.holdTimer = 0;
					}
				}
				else
				{
					if (usingAltBF != '')  {
						altBoyfriend.playAnim(animToPlay + note.animSuffix, true);
						altBoyfriend.holdTimer = 0;
					}
					boyfriend.playAnim(animToPlay + note.animSuffix, true);
					boyfriend.holdTimer = 0;
				}

				if(note.noteType == 'Hey!') {
					if(boyfriend.animOffsets.exists('hey')) {
						boyfriend.playAnim('hey', true);
						boyfriend.specialAnim = true;
						boyfriend.heyTimer = 0.6;
					}

					if(gf != null && gf.animOffsets.exists('cheer')) {
						gf.playAnim('cheer', true);
						gf.specialAnim = true;
						gf.heyTimer = 0.6;
					}
				}
			}

			if(cpuControlled) {
				var time:Float = 0.15;
				if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end')) {
					time += 0.15;
				}
				StrumPlayAnim(false, Std.int(Math.abs(note.noteData)), time);
			} else {
				var spr = playerStrums.members[note.noteData];
				if(spr != null)
				{
					spr.playAnim('confirm', true);
				}
			}
			note.wasGoodHit = true;
			vocals.volume = 1;

			var isSus:Bool = note.isSustainNote; //GET OUT OF MY HEAD, GET OUT OF MY HEAD, GET OUT OF MY HEAD
			var leData:Int = Math.round(Math.abs(note.noteData));
			var leType:String = note.noteType;
			callOnLuas('goodNoteHit', [notes.members.indexOf(note), leData, leType, isSus]);
			stage.playerNoteHit();

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}
	}

	public function spawnNoteSplashOnNote(note:Note) {
		if(ClientPrefs.noteSplashes && note != null) {
			var strum:StrumNote = playerStrums.members[note.noteData];
			if(strum != null) {
				spawnNoteSplash(strum.x, strum.y, note.noteData, note);
			}
		}
	}

	public function spawnNoteSplash(x:Float, y:Float, data:Int, ?note:Note = null) {
		if (isPixelStage) return;
		var skin:String = 'noteSplashes';
		if(PlayState.SONG.splashSkin != null && PlayState.SONG.splashSkin.length > 0) skin = PlayState.SONG.splashSkin;

		var hue:Float = 0;
		var sat:Float = 0;
		var brt:Float = 0;
		if (data > -1 && data < ClientPrefs.arrowHSV.length)
		{
			hue = ClientPrefs.arrowHSV[data][0] / 360;
			sat = ClientPrefs.arrowHSV[data][1] / 100;
			brt = ClientPrefs.arrowHSV[data][2] / 100;
			if(note != null) {
				skin = note.noteSplashTexture;
				hue = note.noteSplashHue;
				sat = note.noteSplashSat;
				brt = note.noteSplashBrt;
			}
		}

		var splash:NoteSplash = grpNoteSplashes.recycle(NoteSplash);
		splash.setupNoteSplash(x, y, data, skin, hue, sat, brt);
		grpNoteSplashes.add(splash);
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	var carTimer:FlxTimer;
	function fastCarDrive()
	{
		//trace('Car drive');
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		carTimer = new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
			carTimer = null;
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			if (gf != null)
			{
				gf.playAnim('hairBlow');
				gf.specialAnim = true;
			}
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		if(gf != null)
		{
			gf.danced = false; //Sets head to the correct position once the animation ends
			gf.playAnim('hairFall');
			gf.specialAnim = true;
		}
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		if(!ClientPrefs.lowQuality) halloweenBG.animation.play('halloweem bg lightning strike');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		if(boyfriend.animOffsets.exists('scared')) {
			boyfriend.playAnim('scared', true);
		}

		if(gf != null && gf.animOffsets.exists('scared')) {
			gf.playAnim('scared', true);
		}

		if(ClientPrefs.camZooms) {
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;

			if(!camZooming) { //Just a way for preventing it to be permanently zoomed until Skid & Pump hits a note
				FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 0.5);
				FlxTween.tween(camHUD, {zoom: 1}, 0.5);
			}
		}

		if(ClientPrefs.flashing) {
			halloweenWhite.alpha = 0.4;
			FlxTween.tween(halloweenWhite, {alpha: 0.5}, 0.075);
			FlxTween.tween(halloweenWhite, {alpha: 0}, 0.25, {startDelay: 0.15});
		}
	}

	function killHenchmen():Void
	{
		if(!ClientPrefs.lowQuality && ClientPrefs.violence && curStage == 'limo') {
			if(limoKillingState < 1) {
				limoMetalPole.x = -400;
				limoMetalPole.visible = true;
				limoLight.visible = true;
				limoCorpse.visible = false;
				limoCorpseTwo.visible = false;
				limoKillingState = 1;

				#if ACHIEVEMENTS_ALLOWED
				Achievements.henchmenDeath++;
				FlxG.save.data.henchmenDeath = Achievements.henchmenDeath;
				var achieve:String = checkForAchievement(['roadkill_enthusiast']);
				if (achieve != null) {
					startAchievement(achieve);
				} else {
					FlxG.save.flush();
				}
				FlxG.log.add('Deaths: ' + Achievements.henchmenDeath);
				#end
			}
		}
	}

	function resetLimoKill():Void
	{
		if(curStage == 'limo') {
			limoMetalPole.x = -500;
			limoMetalPole.visible = false;
			limoLight.x = -500;
			limoLight.visible = false;
			limoCorpse.x = -500;
			limoCorpse.visible = false;
			limoCorpseTwo.x = -500;
			limoCorpseTwo.visible = false;
		}
	}

	var tankX:Float = 400;
	var tankSpeed:Float = FlxG.random.float(5, 7);
	var tankAngle:Float = FlxG.random.int(-90, 45);

	function moveTank(?elapsed:Float = 0):Void
	{
		if(!inCutscene)
		{
			tankAngle += elapsed * tankSpeed;
			tankGround.angle = tankAngle - 90 + 15;
			tankGround.x = tankX + 1500 * Math.cos(Math.PI / 180 * (1 * tankAngle + 180));
			tankGround.y = 1300 + 1100 * Math.sin(Math.PI / 180 * (1 * tankAngle + 180));
		}
	}

	override function destroy() {
		for (lua in luaArray) {
			lua.call('onDestroy', []);
			lua.stop();
		}
		luaArray = [];

		#if hscript
		if(FunkinLua.hscript != null) FunkinLua.hscript = null;
		#end

		if(!ClientPrefs.controllerMode)
		{
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
		}
		FlxG.animationTimeScale = 1;
		FlxG.sound.music.pitch = 1;
		super.destroy();
	}

	public static function cancelMusicFadeTween() {
		if(FlxG.sound.music.fadeTween != null) {
			FlxG.sound.music.fadeTween.cancel();
		}
		FlxG.sound.music.fadeTween = null;
	}

	var lastStepHit:Int = -1;
	override function stepHit()
	{
		super.stepHit();
		if (Math.abs(FlxG.sound.music.time - (Conductor.songPosition - Conductor.offset)) > (20 * playbackRate)
			|| (SONG.needsVoices && Math.abs(vocals.time - (Conductor.songPosition - Conductor.offset)) > (20 * playbackRate)))
		{
			resyncVocals();
		}

		if(curStep == lastStepHit) {
			return;
		}

		lastStepHit = curStep;
		stage.stepHit(curStep);
		setOnLuas('curStep', curStep);
		callOnLuas('onStepHit', []);
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	var lastBeatHit:Int = -1;

	//really bad fix but whatever
	public var preventBFIdle:Bool = false;

	override function beatHit()
	{
		super.beatHit();




		if(lastBeatHit >= curBeat) {
			//trace('BEAT HIT: ' + curBeat + ', LAST HIT: ' + lastBeatHit);
			return;
		}

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, ClientPrefs.downScroll ? FlxSort.ASCENDING : FlxSort.DESCENDING);
		}

		iconP1.scale.set(1.2, 1.2);
		iconP2.scale.set(1.2, 1.2);

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (gf != null && curBeat % Math.round(gfSpeed * gf.danceEveryNumBeats) == 0 && gf.animation.curAnim != null && !gf.animation.curAnim.name.startsWith("sing") && !gf.stunned)
		{
			gf.dance();
		}
		if (curBeat % boyfriend.danceEveryNumBeats == 0 && boyfriend.animation.curAnim != null && !boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.stunned && !preventBFIdle)
		{
			if (usingAltBF != '') altBoyfriend.dance();
			boyfriend.dance();
		}
		if (curBeat % dad.danceEveryNumBeats == 0 && dad.animation.curAnim != null && !dad.animation.curAnim.name.startsWith('sing') && !dad.stunned)
		{
			dad.dance();
		}
		if (camZooming && curBeat % beatsPerZoom == 0 /*&& FlxG.camera.zoom < 1.35*/ && ClientPrefs.camZooms)
		{
			FlxG.camera.zoom += 0.015 * camZoomingMult;
			camHUD.zoom += 0.03 * camZoomingMult;
		}

		lastBeatHit = curBeat;

		stage.beatHit(curBeat);
		setOnLuas('curBeat', curBeat); //DAWGG?????
		callOnLuas('onBeatHit', []);
	}

	override function sectionHit()
	{
		super.sectionHit();

		if (SONG.notes[curSection] != null)
		{

			// if (camZooming && FlxG.camera.zoom < 1.35 && ClientPrefs.camZooms)
			// {
			// 	FlxG.camera.zoom += 0.015 * camZoomingMult;
			// 	camHUD.zoom += 0.03 * camZoomingMult;
			// }

			if (SONG.notes[curSection].mustHitSection) {
				switch (boyfriend.curCharacter) {
					case 'followbf4':
						camZoomMult = 1.1;
					default:
						camZoomMult = 1;
				}
			}
			else {
				switch (dad.curCharacter) {
					// case 'shadow2':
					// 	camZoomMult = 1;
					case 'sinnoh':
						camZoomMult = 1.3;	
					case 'shadowfred':
						camZoomMult = 1.2;
					default:
						camZoomMult = 1;
				}
			}

			if (SONG.notes[curSection].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[curSection].bpm);
				setOnLuas('curBpm', Conductor.bpm);
				setOnLuas('crochet', Conductor.crochet);
				setOnLuas('stepCrochet', Conductor.stepCrochet);
			}
			setOnLuas('mustHitSection', SONG.notes[curSection].mustHitSection);
			setOnLuas('altAnim', SONG.notes[curSection].altAnim);
			setOnLuas('gfSection', SONG.notes[curSection].gfSection);
		}
		stage.sectionHit(curSection);
		setOnLuas('curSection', curSection);
		callOnLuas('onSectionHit', []);
	}

	#if LUA_ALLOWED
	public function startLuasOnFolder(luaFile:String)
	{
		for (script in luaArray)
		{
			if(script.scriptName == luaFile) return false;
		}

		#if MODS_ALLOWED
		var luaToLoad:String = Paths.modFolders(luaFile);
		if(FileSystem.exists(luaToLoad))
		{
			luaArray.push(new FunkinLua(luaToLoad));
			return true;
		}
		else
		{
			luaToLoad = Paths.getPreloadPath(luaFile);
			if(FileSystem.exists(luaToLoad))
			{
				luaArray.push(new FunkinLua(luaToLoad));
				return true;
			}
		}
		#elseif sys
		var luaToLoad:String = Paths.getPreloadPath(luaFile);
		if(OpenFlAssets.exists(luaToLoad))
		{
			luaArray.push(new FunkinLua(luaToLoad));
			return true;
		}
		#end
		return false;
	}
	#end

	public function callOnLuas(event:String, args:Array<Dynamic>, ignoreStops = true, exclusions:Array<String> = null, excludeValues:Array<Dynamic> = null):Dynamic {
		var returnVal = FunkinLua.Function_Continue;
		#if LUA_ALLOWED
		if(exclusions == null) exclusions = [];
		if(excludeValues == null) excludeValues = [];

		for (script in luaArray) {
			if(exclusions.contains(script.scriptName))
				continue;

			var myValue = script.call(event, args);
			if(myValue == FunkinLua.Function_StopLua && !ignoreStops)
				break;
			
			if(myValue != null && myValue != FunkinLua.Function_Continue) {
				returnVal = myValue;
			}
		}
		#end
		return returnVal;
	}

	public function setOnLuas(variable:String, arg:Dynamic) {
		#if LUA_ALLOWED
		for (i in 0...luaArray.length) {
			luaArray[i].set(variable, arg);
		}
		#end
	}

	function StrumPlayAnim(isDad:Bool, id:Int, time:Float) {
		var spr:StrumNote = null;
		if(isDad) {
			spr = strumLineNotes.members[id];
		} else {
			spr = playerStrums.members[id];
		}

		if(spr != null) {
			spr.playAnim('confirm', true);
			spr.resetAnim = time;
		}
	}
	
	function starCheck(i:Int, cap:Int)
	{
		if (i < cap)
		{
				pixelStars.members[i].animation.play('yellow');

				if (stars.members[i].color != 0xFFFCDD03)
				{
					stars.members[i].y -= 20;
					FlxTween.tween(stars.members[i], {y: stars.members[i].y + 20}, 0.25, {ease: FlxEase.sineOut});
				}
				stars.members[i].color = 0xFFFCDD03;
			

		}
		else
		{
			pixelStars.members[i].animation.play('grey');
			stars.members[i].color = 0xFFFFFFFF;

		}
	}

	public var ratingName:String = '?';
	public var ratingPercent:Float;
	public var ratingFC:String;
	public function RecalculateRating(badHit:Bool = false) {
		setOnLuas('score', songScore);
		setOnLuas('misses', songMisses);
		setOnLuas('hits', songHits);

		var ret:Dynamic = callOnLuas('onRecalculateRating', [], false);
		if(ret != FunkinLua.Function_Stop)
		{
			if(totalPlayed < 1) //Prevent divide by 0
				ratingName = '?';
			else
			{
				// Rating Percent
				ratingPercent = Math.min(1, Math.max(0, totalNotesHit / totalPlayed));
				//trace((totalNotesHit / totalPlayed) + ', Total: ' + totalPlayed + ', notes hit: ' + totalNotesHit);

				// Rating Name
				if(ratingPercent >= 1)
				{
					ratingName = ratingStuff[ratingStuff.length-1][0]; //Uses last string
				}
				else
				{
					for (i in 0...ratingStuff.length-1)
					{
						if(ratingPercent < ratingStuff[i][1])
						{
							ratingName = ratingStuff[i][0];
							break;
						}
					}
				}
			}

			// Rating FC
			ratingFC = "";
			if (sicks > 0) ratingFC = "SFC";
			if (goods > 0) ratingFC = "GFC";
			if (bads > 0 || shits > 0) ratingFC = "FC";
			if (songMisses > 0 && songMisses < 10) ratingFC = "SDCB";
			else if (songMisses >= 10) ratingFC = "Clear";
			
			if (ratingFC.endsWith('FC'))
			{
				for (i in 0...stars.members.length)
				{
					if (stars.members[i].animation.curAnim.name != 'flash')
					{
						stars.members[i].animation.play('flash', true);
						stars.members[i].color = 0xFFFFFFFF;
					}
					if (pixelStars.members[i].animation.curAnim.name != 'still')
					{
						pixelStars.members[i].animation.play('still', true);
					}
				}

			}
			else
			{
				for (i in 0...stars.members.length)
				{
					if (stars.members[i].animation.curAnim.name != 'still')
					{
						stars.members[i].animation.play('still', true);
					}
					if (pixelStars.members[i].animation.curAnim.name != 'still')
					{
						pixelStars.members[i].animation.play('still', true);
					}
					
					if (ratingPercent * 100 > 95)
					{
						starCheck(i, 100);
					}
					else if (ratingPercent * 100 > 90)
					{
						starCheck(i, 5);
					}
					else if (ratingPercent * 100 > 80)
					{
						starCheck(i, 4);
					}
					else if (ratingPercent * 100 > 70)
					{
						starCheck(i, 3);
					}
					else if (ratingPercent * 100 > 60)
					{
						starCheck(i, 2);
					}
					else if (ratingPercent * 100 > 50)
					{
						starCheck(i, 1);
					}
				}
			}
		}
		updateScore(badHit); // score will only update after rating is calculated, if it's a badHit, it shouldn't bounce -Ghost
		setOnLuas('rating', ratingPercent);
		setOnLuas('ratingName', ratingName);
		setOnLuas('ratingFC', ratingFC);
	}

	#if ACHIEVEMENTS_ALLOWED
	private function checkForAchievement(achievesToCheck:Array<String> = null):String
	{
		if(chartingMode) return null;

		var usedPractice:Bool = (ClientPrefs.getGameplaySetting('practice', false) || ClientPrefs.getGameplaySetting('botplay', false));
		for (i in 0...achievesToCheck.length) {
			var achievementName:String = achievesToCheck[i];
			if(!Achievements.isAchievementUnlocked(achievementName) && !cpuControlled) {
				var unlock:Bool = false;
				
				if (achievementName.contains(WeekData.getWeekFileName()) && achievementName.endsWith('nomiss')) // any FC achievements, name should be "weekFileName_nomiss", e.g: "weekd_nomiss";
				{
					if(isStoryMode && campaignMisses + songMisses < 1 && CoolUtil.difficultyString() == 'HARD'
						&& storyPlaylist.length <= 1 && !changedDifficulty && !usedPractice)
						unlock = true;
				}
				switch(achievementName)
				{
					case 'ur_bad':
						if(ratingPercent < 0.2 && !practiceMode) {
							unlock = true;
						}
					case 'ur_good':
						if(ratingPercent >= 1 && !usedPractice) {
							unlock = true;
						}
					case 'roadkill_enthusiast':
						if(Achievements.henchmenDeath >= 100) {
							unlock = true;
						}
					case 'oversinging':
						if(boyfriend.holdTimer >= 10 && !usedPractice) {
							unlock = true;
						}
					case 'hype':
						if(!boyfriendIdled && !usedPractice) {
							unlock = true;
						}
					case 'two_keys':
						if(!usedPractice) {
							var howManyPresses:Int = 0;
							for (j in 0...keysPressed.length) {
								if(keysPressed[j]) howManyPresses++;
							}

							if(howManyPresses <= 2) {
								unlock = true;
							}
						}
					case 'toastie':
						if(/*ClientPrefs.framerate <= 60 &&*/ !ClientPrefs.shaders && ClientPrefs.lowQuality && !ClientPrefs.globalAntialiasing) {
							unlock = true;
						}
					case 'debugger':
						if(Paths.formatToSongPath(SONG.song) == 'test' && !usedPractice) {
							unlock = true;
						}
				}

				if(unlock) {
					Achievements.unlockAchievement(achievementName);
					return achievementName;
				}
			}
		}
		return null;
	}
	#end

	var curLight:Int = -1;
	var curLightEvent:Int = -1;



	//new setup for later use todo use this from now on and convert everything else to it
	var cameraShaderMap:Map<String, FlxShader> = new Map();
	public function addRuntimeShader(shaderTag:String, shader:Dynamic, ?camera:FlxCamera = null) 
	{
		if (cameraShaderMap.exists(shaderTag)) {
			trace('shaderTag Exists! please make a new tag');
			return;
		}
		if (camera == null) camera = camGame; 

		if (shader is FlxRuntimeShader) {
			shader.tag = shaderTag;
		}

		cameraShaderMap.set(shaderTag,shader);

		if (camera.filters == null) camera.filters = [];
		camera.filters.push(new ShaderFilter(cameraShaderMap.get(shaderTag)));
	}

	public function removeRuntimeShader(shaderTag:String, ?camera:FlxCamera = null):Bool
	{
		if (camera == null) camera = camGame;
		for (i in camera.filters) {
			if (i is ShaderFilter) //this might be a little unnecessary but it works so its ok
			{
				var sf = cast(i, ShaderFilter);

				if (sf.shader is FlxRuntimeShader) 
				{
					var shader = cast (sf.shader,FlxRuntimeShader);
					if (shader.tag == shaderTag) {
						trace('removed runtimeShader!');
						camera.filters.remove(i);
						return true;

					}
				}
				else {
					if (sf.shader == cameraShaderMap.get(shaderTag))  
					{
						trace('removed shader!');
						camera.filters.remove(i);
						return true;
					}
				}

			}
		}

		return false;

	}

	public function removeShader(shader:FlxShader, ?camera:String = 'game'):Bool //cool utility to remove and apply shaders
		{
			if (!ClientPrefs.shaders) return false;
			if (camera == 'game') {
				for (f in gameShaders)
				{
					if (f is ShaderFilter)
					{
						var sf = cast(f, ShaderFilter);
						if (sf.shader == shader)
						{
							gameShaders.remove(f);
							return true;
						}
					}
				}
			}
			else {
				for (f in hudShaders)
				{
					if (f is ShaderFilter)
					{
						var sf = cast(f, ShaderFilter);
						if (sf.shader == shader)
						{
							hudShaders.remove(f);
							return true;
						}
					}
				}
			}
			return false;
		}
	
		public function addShader(shader:FlxShader, ?camera:String = 'game'):ShaderFilter
		{
			var filter:ShaderFilter = null;
			if (!ClientPrefs.shaders) return filter;
			if (camera == 'game') gameShaders.push(filter = new ShaderFilter(shader));
			else hudShaders.push(filter = new ShaderFilter(shader));
			return filter;
		}
	
		public function removeAllShaders(?camera:String = 'game'):Void { //errr remove freakin all of them like a fucking boss?
			if (camera == 'game') while (gameShaders.length > 0) gameShaders.pop();
			else while (hudShaders.length > 0) hudShaders.pop();
		}


		public function preloadvideo(video:String) {
			var vid = new VideoSprite();
			vid.playVideo(Paths.video(video));
			vid.graphicLoadedCallback = function () {
				trace('videoloaded');
				
			}
			vid.finishCallback = function () {
				vid = null;
			}
		}
}
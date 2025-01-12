package;

import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import sys.FileSystem;
import flixel.FlxBasic;
import flixel.util.FlxSort;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.util.FlxStringUtil;

import options.OptionsState;

using StringTools;
class PauseSubState extends MusicBeatSubstate
{

	var menuItems:FlxTypedGroup<PauseSprite>;

	var optionShit:Array<String> = [
		'resume',
		'options',
		'restart',
		'exit'
	];

	var difficultyChoices = [];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;
	//var botplayText:FlxText;

	public static var songName:String = '';

	public static var pauseCharacter:PauseChars;
	var directory:String = '';


	public var scaryFollowed:FlxSprite;
	public var followedMode:Bool = false;
	public var followedTweenover:Bool = false;

	public static var insidePause:Bool = false;


	public function new(x:Float, y:Float)
	{
		super();
		insidePause = true;


		for (i in 0...CoolUtil.difficulties.length) {
			var diff:String = '' + CoolUtil.difficulties[i];
			difficultyChoices.push(diff);
		}
		difficultyChoices.push('BACK');
		if (PlayState.SONG.song.toLowerCase() == 'followed') directory = 'followed/';


		pauseMusic = new FlxSound();
		pauseMusic.loadEmbedded(Paths.music('newpause'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));
		FlxG.sound.list.add(pauseMusic);
		if (PlayState.SONG.song.toLowerCase() == 'followed') pauseMusic.pitch = 0.25;
		
		var tint:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		tint.alpha = 0;
		tint.scrollFactor.set();
		add(tint);

		pauseCharacter = new PauseChars();
		add(pauseCharacter);

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('pausemenu/${directory}pmbg'));
		bg.x = -bg.width;
		bg.scale.set(1.8,1.8);
		bg.updateHitbox();
		bg.scrollFactor.set();
		add(bg);
		menuItems = new FlxTypedGroup<PauseSprite>();
		add(menuItems);

		for (i in 0...optionShit.length)
		{
			var menuItem:PauseSprite = new PauseSprite(50, 1000);
			menuItem.frames = Paths.getSparrowAtlas('pausemenu/${directory}' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', 'pm_' + optionShit[i] + 'idle', 24);
			menuItem.animation.addByPrefix('selected', 'pm_' + optionShit[i] + 'c', 24);
			menuItem.animation.play('idle');
			menuItem.zIndex = i;
			menuItem.ID = i;
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
		}

		menuItems.forEach(function(spr:PauseSprite){
			spr.alpha = 0;
			FlxTween.tween(spr, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut,startDelay: spr.ID*0.1});
			FlxTween.tween(spr, {y: -25}, 0.4, {ease: FlxEase.backOut,startDelay: spr.ID*0.1});
		});

		FlxTween.tween(tint, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(bg, {alpha: 1,x: 0}, 0.3, {ease: FlxEase.quartOut});

	
		regenMenu();
		if (PlayState.SONG.song.toLowerCase() == 'followed') {
			scaryFollowed = new FlxSprite();
			scaryFollowed.frames = Paths.getSparrowAtlas('followed/scaryasf','ourplesecrets');
			scaryFollowed.animation.addByPrefix('i','i',12,false);
			scaryFollowed.animation.addByIndices('s','i',[0],"", 24, true);
			scaryFollowed.animation.play('s');
			scaryFollowed.setGraphicSize(FlxG.width,FlxG.height);
			scaryFollowed.updateHitbox();
			add(scaryFollowed);
			scaryFollowed.alpha = 0;
		}



		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		if (pauseCharacter.yesFriend) FlxG.mouse.visible = true;
	}

	var holdTime:Float = 0;
	var cantUnpause:Float = 0.1;
	override function update(elapsed:Float)
	{
		cantUnpause -= elapsed;
		if (pauseMusic.volume < 0.8)
			pauseMusic.volume += 0.04 * elapsed;

		super.update(elapsed);

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP && !followedMode)
		{
			changeSelection(-1);
		}
		if (downP && !followedMode)
		{
			changeSelection(1);
		}
		var mouseX = FlxG.mouse.getPositionInCameraView(FlxG.cameras.list[FlxG.cameras.list.length - 1]).x;//overlap wasnt being nice
        var mouseY = FlxG.mouse.getPositionInCameraView(FlxG.cameras.list[FlxG.cameras.list.length - 1]).y;
		if (pauseCharacter.yesFriend && FlxG.mouse.visible && FlxG.mouse.justPressed && (mouseY >= pauseCharacter.bfChar.y && mouseY <= (pauseCharacter.bfChar.y + pauseCharacter.bfChar.height) && mouseX >= pauseCharacter.bfChar.x && mouseX <= (pauseCharacter.bfChar.x+pauseCharacter.bfChar.width))) {
			trace('yes!');
			FlxG.mouse.visible = false;
			PlayState.instance.vocals.stop();
			FlxG.sound.music.stop();
			PlayState.instance.vocals.volume = 0;
			FlxG.sound.music.volume = 0;
			PlayState.instance.camGame.visible = false;
			PlayState.instance.camHUD.visible = false;
			PlayState.instance.camOther.visible = false;		

			WeekData.reloadWeekFiles(false);
			CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();	
			PlayState.storyPlaylist = ['yes-friend'];
			PlayState.isStoryMode = false;
		
			var diffic = CoolUtil.getDifficultyFilePath(2);

			PlayState.storyDifficulty = 2;
		
			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
			PlayState.campaignScore = 0;
			PlayState.campaignMisses = 0;
			new FlxTimer().start(.1, function(tmr:FlxTimer)
			{
				MusicBeatState.switchState(new PlayState());
				// MusicBeatState.resetState();
				// FreeplayState.destroyFreeplayVocals();
				// close();
			});

		}

		var daSelected:String = optionShit[curSelected];

		if (accepted && (cantUnpause <= 0 || !ClientPrefs.controllerMode) && !followedMode)
		{
			if (PlayState.SONG.song.toLowerCase() != 'bite') FlxG.mouse.visible = false;


			switch (daSelected)
			{
				case "resume":
					close();
				case "restart":
					restartSong();
				case "options":
					PlayState.instance.paused = true; // For lua
					PlayState.instance.vocals.volume = 0;
					MusicBeatState.switchState(new OptionsState());
					// if(ClientPrefs.pauseMusic != 'None')
					// {
					// 	FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.pauseMusic)), pauseMusic.volume);
					// 	FlxTween.tween(FlxG.sound.music, {volume: 1}, 0.8);
					// 	FlxG.sound.music.time = pauseMusic.time;
					// }
					OptionsState.onPlayState = true;
				case "exit":
					if (PlayState.SONG.song.toLowerCase() == 'followed' && FlxG.save.data.firstFollowedExit == null) {
						scaryFollowed.alpha = 1;
						new FlxTimer().start(8, function (f:FlxTimer) {
							scaryFollowed.animation.play('i');
							followedTweenover = true;
						});
						pauseMusic.stop();
						new FlxTimer().start(0.2, function (f:FlxTimer) {
							followedMode = true;
						});

					}
					else {
						PlayState.deathCounter = 0;
						PlayState.seenCutscene = false;
	
						WeekData.loadTheFirstEnabledMod();
						if(PlayState.isStoryMode) {
							MusicBeatState.switchState(new OurpleStoryState());
						} else {
							MusicBeatState.switchState(new FreeplayState());
						}
						PlayState.cancelMusicFadeTween();
						//FlxG.sound.playMusic(Paths.music('freakyMenu'));
						PlayState.changedDifficulty = false;
						PlayState.chartingMode = false;
					}

			}
	
		}
		if (followedTweenover && followedMode && (controls.ACCEPT || controls.UI_LEFT || controls.UI_RIGHT || controls.UI_DOWN || controls.UI_UP)) {
			FlxG.save.data.firstFollowedExit = true;
			FlxG.save.flush();
			FlxG.stage.window.alert("Who are you running from?", "");
			Sys.exit(0);
		}
	}

	public static function restartSong(noTrans:Bool = false)
	{
		PlayState.instance.paused = true; // For lua
		FlxG.sound.music.volume = 0;
		PlayState.instance.vocals.volume = 0;

		if(noTrans)
		{
			FlxTransitionableState.skipNextTransOut = true;
			FlxG.resetState();
		}
		else
		{
			MusicBeatState.resetState();
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();
		insidePause = false;

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;


		menuItems.forEach(function(spr:PauseSprite)
		{ //maybe todo? do some z sorting bis //done
			spr.animation.play('idle');
			spr.updateHitbox();
			spr.zIndex = spr.ID;
			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				spr.centerOffsets();
				spr.zIndex = 10;
			}

		});
		//tbh i havent really looked into how sorting works so this is basically primarily ripped from a tutorial on this so thank you guy
		var sortByZ = function(order:Int, obj1:PauseSprite, obj2:PauseSprite):Int
		{
			return FlxSort.byValues(order, obj1.zIndex, obj2.zIndex);
		}
		menuItems.sort(sortByZ, FlxSort.ASCENDING);


	}

	function regenMenu():Void {
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.updateHitbox();
			spr.scale.x = 1.5;
			spr.scale.y = 1.5;

		});
		curSelected = 0;
		changeSelection();
	}
}


class PauseSprite extends FlxSprite { //realize now tbh i could of made an array of values instead

	public var zIndex:Int = 0;

	public function new(x:Float = 0, y:Float = 0) {
		super(x, y);
	}
}

class PauseChars extends FlxTypedGroup<FlxBasic>
{

	public var itsHim:Bool = false;
	public var directory:String = '';
	public var yesFriend:Bool = false;
	//public var pos = new FlxPoint();
	public var bfChar:FlxSprite;
	public function new() {
		itsHim = false;

        super();
		var song = PlayState.SONG.song.toLowerCase();
		if (song == 'dismantle' && FlxG.random.bool(50)) song += '1';
		if (song == 'performance' && FlxG.random.bool(50)) song += '1';
		if (song == 'fear' && FlxG.random.bool(50)) song += '1';
		if (song == 'guy' && FlxG.random.bool(5))  { //5
			song += '1';
			yesFriend = true;
		}
		//if (song == 'yes-friend') song = 'guy1';
		if (song == 'followed') {
			var timestamp:String = '0';
			trace(FlxMath.roundDecimal(Conductor.songPosition / 1000, 2));
			if (FlxMath.roundDecimal(Conductor.songPosition / 1000, 2) > 22) timestamp = '1';
			if (FlxMath.roundDecimal(Conductor.songPosition / 1000, 2) > 90) timestamp = '2';
			if (FlxMath.roundDecimal(Conductor.songPosition / 1000, 2) > 156) timestamp = '3';
			if (FlxMath.roundDecimal(Conductor.songPosition / 1000, 2) > 309) timestamp = '4';
			directory = 'followed/';
			song = 'sheddy' + timestamp;
		}




		bfChar = new FlxSprite();
		if (FlxG.random.bool(0.006)) { //0.006
			bfChar.loadGraphic(Paths.image('friend/pause','ourplesecrets')); //0.006
			itsHim = true;
		}
		else if (FileSystem.exists(Paths.getPath('images/pausemenu/${directory}chars/' + song + '.png',IMAGE))) 
			bfChar.loadGraphic(Paths.image('pausemenu/${directory}chars/$song'));
		else if (PlayState.SONG.song.toLowerCase() != 'followed') 
			bfChar.loadGraphic(Paths.image('pausemenu/defaultportrait'));
		
		
		bfChar.setGraphicSize(0,720);
		bfChar.updateHitbox();
		bfChar.screenCenter(Y);
		bfChar.x = FlxG.width;
		add(bfChar);
		FlxTween.tween(bfChar, {x: FlxG.width - bfChar.width}, 0.35, {ease: FlxEase.quartOut});

	}
	// override function update(elapsed:Float) {
	// 	pos.x = 
		
	// }
}

package;

import FreeplayState.CabinetGlitchChrom;
import FreeplayState.SongMetadata;
import FreeplayState.DancingFuck;
import FreeplayState.Cabinets;
import flixel.addons.display.FlxRuntimeShader;
import flixel.addons.display.FlxBackdrop;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.group.FlxSpriteGroup;
#if desktop
import Discord.DiscordClient;
#end
import editors.ChartingState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import flixel.sound.FlxSound;
import openfl.utils.Assets as OpenFlAssets;
import WeekData;
import flixel.math.FlxPoint;
#if MODS_ALLOWED
import sys.FileSystem;
#end
import flixel.system.FlxAssets.FlxShader;

using StringTools;

class FreeplayStateFollowed extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	private static var curSelected:Int = 0;

	var curDifficulty:Int = -1;

	private static var lastDifficultyName:String = '';

	private var curPlaying:Bool = false;

	var cabinets:FlxTypedGroup<Cabinets>;
	var arrows:FlxSpriteGroup;
	var friends:FlxTypedGroup<DancingFuck>;

	public static var fanfare:String = ''; // make blank

	var wall:FlxSprite;

	var updateiTime:Array<Dynamic> = [];
	var updateiTimeRtime:Array<FlxRuntimeShader> = [];

	var followedCounter:Int;
	var pfcCounter:Int;

	var cabLength:Array<Int> = [];
	var megaOurple:Bool = false;

	var fazNews:Array<Dynamic> = []; //int,bool,flxtween
	
	var scoreText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;


	var pngoptions:FlxSpriteGroup;
	var pngSelecting:Bool = false;
	var pngSelect:Int = 1; //i h ate tghis but im crunching so fuck alll lol


	override function create()
	{
		// Paths.clearStoredMemory();
		// Paths.clearUnusedMemory();

		persistentUpdate = true;
		PlayState.isStoryMode = false;
		WeekData.reloadWeekFiles(false);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		// FlxG.sound.playMusic(Paths.music('fp'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 1);

		for (i in 0...WeekData.weeksList.length)
		{
			if (weekIsLocked(WeekData.weeksList[i]))
				continue;

			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var leSongs:Array<String> = [];
			var leChars:Array<String> = [];

			for (j in 0...leWeek.songs.length)
			{
				leSongs.push(leWeek.songs[j][0]);
				leChars.push(leWeek.songs[j][1]);
			}

			WeekData.setDirectoryFromWeek(leWeek);
			for (song in leWeek.songs)
			{
				var colors:Array<Int> = song[2];
				if (colors == null || colors.length < 3)
				{
					colors = [146, 113, 253];
				}
				addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]));
			}
		}
		WeekData.loadTheFirstEnabledMod();

		wall = new FlxBackdrop(Paths.image('followedFP/wall'),X);
		wall.y = -50;
		wall.setGraphicSize(1280);
		wall.updateHitbox();
		add(wall);

		cabinets = new FlxTypedGroup<Cabinets>();
		add(cabinets);

		friends = new FlxTypedGroup<DancingFuck>();
		add(friends);

		arrows = new FlxSpriteGroup();
		add(arrows);

		if (lastDifficultyName == '')
		{
			lastDifficultyName = CoolUtil.defaultDifficulty;
		}

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		PlayState.storyDifficulty = curDifficulty = 2;
		trace(curDifficulty + 'cureed');
		for (i in 0...songs.length)
		{
			Paths.currentModDirectory = songs[i].folder;

			followedCounter++;
			var thesong = songs[i].songName.toLowerCase();
			// #if !debug
			// if (Highscore.getScore(songs[i].songName, curDifficulty) == 0) {
			// 	thesong = 'blank';
			// 	followedCounter--;
			// }
			// #end
			trace(Highscore.getScore(songs[i].songName, curDifficulty));
			var song = 'followedFP/followed_fp';
			if (songs[i].songName == 'followed') song = 'followedFP/followed';
			FlxG.sound.music.stop();

			var cab = new Cabinets('$song');
			cab.scale.set(1.5, 1.5);
			cab.updateHitbox();
			cab.y = FlxG.height - cab.height;
			cab.changeY = false;
			cab.startPosition.x = (FlxG.width - cab.width) / 2;
			cab.distancePerItem.x = 500;
			switch (thesong) {
				case 'followed':
					if (ClientPrefs.shaders) {
						var chrom = CoolUtil.initializeShader('arcade/followed');
						updateiTimeRtime.push(chrom);
						chrom.setFloat('iTime',0.5);
						cab.shader = chrom;
					}


			}
			

			cabinets.add(cab);

			// var friend = new DancingFuck('${Highscore.getFC(songs[i].songName, curDifficulty)}dance', 115, -100);
			// if (friend.graphic == null) friend.makeGraphic(1,1,FlxColor.TRANSPARENT); //dumb asf fix but wahtever

			// if (FlxG.random.bool(3)) friend.loadGraphic(Paths.image('freeplay/${Highscore.getFC(songs[i].songName, 2)}Breadbear'));
			// friend.tracker = cab;
			// friend.scale.set(0.3, 0.3);
			// friend.updateHitbox();
			// friends.add(friend);
			// friend.ID = i;

			cabLength.push(i);

		}
		if (followedCounter == songs.length) {
			
		}
		trace('FollowedCOunter ' + followedCounter + ' pfcCOutner ' + pfcCounter);

		var b = new FlxSprite().makeGraphic(FlxG.width,50,FlxColor.BLACK);
		b.y = FlxG.height - b.height;
		//add(b);
		b.alpha = 0.6;

		
		scoreText = new FlxText(0,0,FlxG.width,'0000');
		scoreText.setFormat(Paths.font("options.ttf"), 32, FlxColor.WHITE, CENTER);
		scoreText.y = FlxG.height - scoreText.height + 20;
		//add(scoreText);



		WeekData.setDirectoryFromWeek();

		var arrow = new FlxSprite();
		arrow.frames = Paths.getSparrowAtlas('freeplay/freeplayarrow');
		arrow.animation.addByPrefix('i', 'normal', 12);
		arrow.animation.addByPrefix('s', 'press', 12);
		arrow.animation.play('i');
		arrow.scale.set(2, 2);
		arrow.updateHitbox();
		arrow.setPosition(cabinets.members[curSelected].startPosition.x - arrow.width - 10, (cabinets.members[curSelected].height - arrow.height) / 2);
		arrow.flipX = true;
		arrows.add(arrow);

		var arrow = new FlxSprite();
		arrow.frames = Paths.getSparrowAtlas('freeplay/freeplayarrow');
		arrow.animation.addByPrefix('i', 'normal', 12);
		arrow.animation.addByPrefix('s', 'press', 12);
		arrow.animation.play('i');
		arrow.scale.set(2, 2);
		arrow.updateHitbox();
		arrow.setPosition(cabinets.members[curSelected].startPosition.x + cabinets.members[curSelected].width + 10,
			(cabinets.members[curSelected].height - arrow.height) / 2);
		arrows.add(arrow);

		if (curSelected >= cabLength.length)
			curSelected = 0;


		pngoptions = new FlxSpriteGroup(); //gross but we speedrunning
		add(pngoptions);
		var authentic = new FlxSprite(0,900);
		authentic.frames = Paths.getSparrowAtlas('freeplay/auth');
		authentic.animation.addByPrefix('i','auth i',12);
		authentic.animation.addByPrefix('s','auth s',12);	
		var refined = new FlxSprite(0,900);
		refined.frames = Paths.getSparrowAtlas('freeplay/refined');
		refined.animation.addByPrefix('i','refined i',12);
		refined.animation.addByPrefix('s','refined s',12);	
		refined.animation.play('s');
		refined.screenCenter(X);
		authentic.screenCenter(X);
		pngoptions.add(refined);
		pngoptions.add(authentic);
		//pngoptions.alpha = 0;

		var vignette = new FlxSprite().loadGraphic(Paths.image('freeplay/menuvig'));
		add(vignette);
		vignette.alpha = 0.8;

		if (!FlxG.save.data.firstTimeFreeplay)
		{
			var black = new FlxSprite().makeGraphic(1280, 720, FlxColor.BLACK);
			add(black);

			var warn = new FlxSprite().loadGraphic(Paths.image('freeplay/warning'));
			warn.screenCenter(X);
			warn.y = FlxG.height - warn.height;
			add(warn);
		}

		changeSelection();
		changeDiff();

		if (fanfare != '') {//FANFARE EYAYYAEY
			var currentvol = FlxG.sound.music.volume;
			FlxG.sound.music.pause();

			var fc = new FlxSprite();
			fc.frames = Paths.getSparrowAtlas('freeplay/$fanfare');
			fc.animation.addByPrefix('s', 'FC idle');
			fc.animation.play('s');
			fc.scale.set(2, 2);
			fc.updateHitbox();
			fc.screenCenter(X);
			fc.y = FlxG.height;
			add(fc);

			var confetti = new FlxSprite();
			confetti.frames = Paths.getSparrowAtlas('freeplay/happy');
			confetti.animation.addByPrefix('s', 'happy idle');
			confetti.animation.play('s');
			confetti.setGraphicSize(FlxG.width);
			confetti.updateHitbox();
			add(confetti);
			friends.members[curSelected].offsetY = -300;
			FlxTween.tween(fc, {y: (FlxG.height - fc.height) / 2}, 1, {ease: FlxEase.backOut,startDelay: 0.25});
			FlxG.sound.play(Paths.music('${fanfare}fanfare'),1,false, function () {
				FlxG.sound.play(Paths.sound('thatfuckingrock'));
				FlxTween.tween(friends.members[curSelected], {offsetY: -100},8, {ease: FlxEase.smootherStepInOut, onComplete: function (f:FlxTween) {
					remove(fc);
					remove(confetti);
					FlxG.sound.music.resume();
					FlxG.sound.music.fadeIn(1, currentvol, 1);
					fanfare = '';
				}});
			}); //ON COMPLETE THEN MAKE THE ROCK FALL

		}

		super.create();
	}

	override function closeSubState()
	{
		changeSelection(0, false);
		persistentUpdate = true;
		super.closeSubState();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, color));
	}

	function weekIsLocked(name:String):Bool
	{
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked
			&& leWeek.weekBefore.length > 0
			&& (!StoryMenuState.weekCompleted.exists(leWeek.weekBefore) || !StoryMenuState.weekCompleted.get(leWeek.weekBefore)));
	}

	var instPlaying:Int = -1;

	public static var vocals:FlxSound = null;

	var holdTime:Float = 0;

	override function update(elapsed:Float)
	{

		for (i in updateiTime) i.update(elapsed); //just make it a runtime or smth

		for (i in updateiTimeRtime) i.setFloat('iTime', i.getFloat('iTime') + elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!FlxG.save.data.firstTimeFreeplay && controls.ACCEPT)
		{
			FlxG.camera.shake(0.1, 1, function()
			{
				FlxG.save.data.firstTimeFreeplay = true;
				FlxG.save.flush();
				MusicBeatState.resetState();
			});
		}

		if (FlxG.save.data.firstTimeFreeplay && fanfare == '')
		{
			if (fazNews[1] == false) {
				fazNews[1] = true;
				new FlxTimer().start(0.5, function (f:FlxTimer) {
					cabinets.members[fazNews[0]].y += 20;
					fazNews[1] = false;	
				});
			}
			var upP = controls.UI_LEFT_P;
			var downP = controls.UI_RIGHT_P;

			var accepted = controls.ACCEPT;
			var space = FlxG.keys.justPressed.SPACE;
			var ctrl = FlxG.keys.justPressed.CONTROL;

			var shiftMult:Int = 1;
			if (FlxG.keys.pressed.SHIFT)
				shiftMult = 3;

			if (cabLength.length > 1)
			{
				if (upP&& !pngSelecting)
				{
					arrows.members[0].animation.play('s');
					changeSelection(-shiftMult);
					holdTime = 0;
				}
				if (downP&& !pngSelecting)
				{
					arrows.members[1].animation.play('s');
					changeSelection(shiftMult);
					holdTime = 0;
				}

				if (controls.UI_LEFT_R)
					arrows.members[0].animation.play('i');
				if (controls.UI_RIGHT_R)
					arrows.members[1].animation.play('i');

				if ((controls.UI_LEFT || controls.UI_RIGHT) && !pngSelecting)
				{
					var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
					holdTime += elapsed;
					var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

					if (holdTime > 0.5 && checkNewHold - checkLastHold > 0)
					{
						changeSelection((checkNewHold - checkLastHold) * (controls.UI_LEFT ? -shiftMult : shiftMult));
						changeDiff();
					}
				}
				else if (controls.UI_LEFT || controls.UI_RIGHT) {
					if (controls.UI_LEFT_P)  {
						pngSelect--;
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);

					}
					if (controls.UI_RIGHT_P){
						pngSelect++;
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
					} 

					if (pngSelect % 2 == 0) {
						pngoptions.members[0].animation.play('i');
						pngoptions.members[1].animation.play('s');
					}
					else {
						pngoptions.members[0].animation.play('s');
						pngoptions.members[1].animation.play('i');
					}
				}

				if (FlxG.mouse.wheel != 0)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
					changeSelection(-shiftMult * FlxG.mouse.wheel, false);
					changeDiff();
				}
			}
				// if (controls.UI_LEFT_P)
				// 	changeDiff(-1);
				// else if (controls.UI_RIGHT_P)
				// changeDiff(1);
			// else if (upP || downP)
			// 	changeDiff();

			if (controls.BACK)
			{
				if (pngSelecting) {
					//FlxTween.tween(pngoptions, {y: 900},1, {ease: FlxEase.backIn});
					pngoptions.forEach(function (f:FlxSprite) {
						FlxTween.tween(f, {y:900},1, {ease: FlxEase.backIn});
					});
					pngSelecting = false;
					return;
				}
				persistentUpdate = false;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
			}

			if (ctrl)
			{
				persistentUpdate = false;
				openSubState(new GameplayChangersSubstate());
			}
			else if (space)
			{
				if (instPlaying != curSelected)
				{
					#if PRELOAD_ALL
					destroyFreeplayVocals();
					FlxG.sound.music.volume = 0;
					Paths.currentModDirectory = songs[curSelected].folder;
					var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
					PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
					if (PlayState.SONG.needsVoices)
						vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
					else
						vocals = new FlxSound();

					FlxG.sound.list.add(vocals);
					FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
					vocals.play();
					vocals.persist = true;
					vocals.looped = true;
					vocals.volume = 0.7;
					instPlaying = curSelected;
					#end
				}
			}
			else if (accepted)
			{
				var png:String = '';

				if (songs[curSelected].songName != 'followed') return;
				trace("play");
				persistentUpdate = false;
				var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
				var poop:String = Highscore.formatSong(songLowercase, (png == '' ? 2 : 3)); //data todo fix week to have all dificulties again
				trace(poop);

				PlayState.SONG = Song.loadFromJson(poop, songLowercase);
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = png == '' ? 2 : 3;

				trace('CURRENT WEEK: ' + WeekData.getWeekFileName());

				if (FlxG.keys.pressed.SHIFT)
				{
					LoadingState.loadAndSwitchState(new ChartingState());
				}
				else
				{
					LoadingState.loadAndSwitchState(new PlayState());
				}

				FlxG.sound.music.volume = 0;

				destroyFreeplayVocals();
			}
			else if (controls.RESET)
			{
				persistentUpdate = false;
				openSubState(new ResetScoreSubState(songs[curSelected].songName, curDifficulty, songs[curSelected].songCharacter));
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
	
			if (Math.abs(lerpScore - intendedScore) <= 10)
				lerpScore = intendedScore;

			scoreText.text = 'Score: $lerpScore';

			for (i in friends)
			{
				if (i.ID == curSelected)
				{
					if (fanfare == '')
					{
						i.offsetX = FlxMath.lerp(i.offsetX, 115, CoolUtil.boundTo(elapsed * 18, 0, 1));
						i.offsetY = FlxMath.lerp(i.offsetY, -110, CoolUtil.boundTo(elapsed * 18, 0, 1));
					}
				}
				else
					i.offsetY = FlxMath.lerp(i.offsetY, -100, CoolUtil.boundTo(elapsed * 18, 0, 1));
			}
			for (i in cabinets)
			{
				if (i.targetY == 0)
				{
					wall.x = i.x;
					arrows.members[0].x = FlxMath.lerp(arrows.members[0].x, i.x - arrows.members[0].width - 10, CoolUtil.boundTo(elapsed * 26, 0, 1));
					arrows.members[1].x = FlxMath.lerp(arrows.members[1].x, i.x + i.width + 10, CoolUtil.boundTo(elapsed * 26, 0, 1));
					i.scale.x = FlxMath.lerp(i.scale.x, 1.6, CoolUtil.boundTo(elapsed * 18, 0, 1));
					i.scale.y = FlxMath.lerp(i.scale.y, 1.6, CoolUtil.boundTo(elapsed * 18, 0, 1));
					i.y = FlxMath.lerp(i.y, FlxG.height - i.height - 20, CoolUtil.boundTo(elapsed * 18, 0, 1));
				}
				else
				{
					i.scale.x = FlxMath.lerp(i.scale.x, 1.5, CoolUtil.boundTo(elapsed * 18, 0, 1));
					i.scale.y = FlxMath.lerp(i.scale.y, 1.5, CoolUtil.boundTo(elapsed * 18, 0, 1));
					i.y = FlxMath.lerp(i.y, FlxG.height - i.height, CoolUtil.boundTo(elapsed * 18, 0, 1));
				}
			}
		}
		for (i in friends)
		{ // trust me i know this is dumb bare with me
			if (i.ID < curSelected)
			{
				i.offsetX = FlxMath.lerp(i.offsetX, 95, CoolUtil.boundTo(elapsed * 18, 0, 1));
			}
			else if (i.ID > curSelected)
			{
				i.offsetX = FlxMath.lerp(i.offsetX, 135, CoolUtil.boundTo(elapsed * 18, 0, 1));
			}
		}

		super.update(elapsed);
	}

	public static function destroyFreeplayVocals()
	{
		if (vocals != null)
		{
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficulties.length - 1;
		if (curDifficulty >= CoolUtil.difficulties.length)
			curDifficulty = 0;

		lastDifficultyName = CoolUtil.difficulties[curDifficulty];

		PlayState.storyDifficulty = curDifficulty;
	}

	function changeSelection(change:Int = 0, playSound:Bool = true)
	{
		if (playSound)
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = cabLength.length - 1;
		if (curSelected >= cabLength.length)
			curSelected = 0;

		var bullShit:Int = 0;

		//trace(curDifficulty); //need to fix


		#if !switch
		if (megaOurple) {
			if (curSelected != cabLength.length-1) {
				intendedScore = Highscore.getScore(songs[curSelected].songName, 2);
		
			}

		}
		else {
			intendedScore = Highscore.getScore(songs[curSelected].songName, 2);
		}

		#end


		for (i in cabinets)
		{
			i.targetY = bullShit - curSelected;
			bullShit++;

			if (change == 0 && playSound)
				i.snapToPosition();
		}

		if (megaOurple && curSelected == cabLength.length-1)
			return;
		Paths.currentModDirectory = songs[curSelected].folder;
		PlayState.storyWeek = songs[curSelected].week;

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = WeekData.getCurrentWeek().difficulties;
		if (diffStr != null)
			diffStr = diffStr.trim(); // Fuck you HTML5

		if (diffStr != null && diffStr.length > 0)
		{
			var diffs:Array<String> = diffStr.split(',');
			var i:Int = diffs.length - 1;
			while (i > 0)
			{
				if (diffs[i] != null)
				{
					diffs[i] = diffs[i].trim();
					if (diffs[i].length < 1)
						diffs.remove(diffs[i]);
				}
				--i;
			}

			if (diffs.length > 0 && diffs[0].length > 0)
			{
				CoolUtil.difficulties = diffs;
			}
		}

		if (CoolUtil.difficulties.contains(CoolUtil.defaultDifficulty))
		{
			curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(CoolUtil.defaultDifficulty)));
		}
		else
		{
			curDifficulty = 0;
		}

		var newPos:Int = CoolUtil.difficulties.indexOf(lastDifficultyName);
		// trace('Pos of ' + lastDifficultyName + ' is ' + newPos);
		if (newPos > -1)
		{
			curDifficulty = newPos;
		}
		
	}
}

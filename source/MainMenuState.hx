package;

import openfl.filters.ShaderFilter;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.6.3'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		'story',
		'freeplay',
		'options',
		'credits'
	];

	var storybg:FlxSprite;
	var freeplaybg:FlxSprite;
	var optionsbg:FlxSprite;
	var creditsbg:FlxSprite;

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;

	override function create()
	{
		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		if (FlxG.sound.music.length != 118142) { //weird asf way to do this but err lol?
			FlxG.sound.playMusic(Paths.music('freakyMenu'),0);
			FlxG.sound.music.fadeIn(2,0,1);
		}


		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(80).loadGraphic(Paths.image('mainmenu/bg'));
		bg.scrollFactor.set(0, 0);
		bg.setGraphicSize(Std.int(bg.width * 1.7));
		bg.x = 0;
		bg.updateHitbox();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		var checker:FlxBackdrop = new FlxBackdrop(Paths.image('mainmenu/grid'));
		checker.scrollFactor.set();
		checker.velocity.set(40, 40);
		checker.alpha = 0.5;
		add(checker);

		var scale:Float = 1.4;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		var storybggrey:FlxSprite = new FlxSprite(110, 310).loadGraphic(Paths.image('mainmenu/storybggrey'));
		storybggrey.scrollFactor.set(0, 0);
		storybggrey.updateHitbox();
		storybggrey.scale.x = scale;
		storybggrey.scale.y = scale;
		storybggrey.antialiasing = false;
		add(storybggrey);

		var freeplaybggrey:FlxSprite = new FlxSprite(435, 304).loadGraphic(Paths.image('mainmenu/freeplaybggrey'));
		freeplaybggrey.scrollFactor.set(0, 0);
		freeplaybggrey.updateHitbox();
		freeplaybggrey.scale.x = scale;
		freeplaybggrey.scale.y = scale;
		freeplaybggrey.antialiasing = false;
		add(freeplaybggrey);

		var optionsbggrey:FlxSprite = new FlxSprite(782.5, 305).loadGraphic(Paths.image('mainmenu/optionsbggrey'));
		optionsbggrey.scrollFactor.set(0, 0);
		optionsbggrey.updateHitbox();
		optionsbggrey.scale.x = scale;
		optionsbggrey.scale.y = scale;
		optionsbggrey.antialiasing = false;
		add(optionsbggrey);

		var creditsbggrey:FlxSprite = new FlxSprite(1090, 305).loadGraphic(Paths.image('mainmenu/creditsbggrey'));
		creditsbggrey.scrollFactor.set(0, 0);
		creditsbggrey.updateHitbox();
		creditsbggrey.scale.x = scale;
		creditsbggrey.scale.y = scale;
		creditsbggrey.antialiasing = false;
		add(creditsbggrey);

		storybg = new FlxSprite(110, 310).loadGraphic(Paths.image('mainmenu/storybg'));
		storybg.scrollFactor.set(0, 0);
		storybg.updateHitbox();
		storybg.scale.x = scale;
		storybg.scale.y = scale;
		storybg.antialiasing = false;
		add(storybg);

		freeplaybg = new FlxSprite(435, 304).loadGraphic(Paths.image('mainmenu/freeplaybg'));
		freeplaybg.scrollFactor.set(0, 0);
		freeplaybg.updateHitbox();
		freeplaybg.scale.x = scale;
		freeplaybg.scale.y = scale;
		freeplaybg.antialiasing = false;
		add(freeplaybg);

		optionsbg = new FlxSprite(782.5, 305).loadGraphic(Paths.image('mainmenu/optionsbg'));
		optionsbg.scrollFactor.set(0, 0);
		optionsbg.updateHitbox();
		optionsbg.scale.x = scale;
		optionsbg.scale.y = scale;
		optionsbg.antialiasing = false;
		add(optionsbg);

		creditsbg = new FlxSprite(1090, 305).loadGraphic(Paths.image('mainmenu/creditsbg'));
		creditsbg.scrollFactor.set(0, 0);
		creditsbg.updateHitbox();
		creditsbg.scale.x = scale;
		creditsbg.scale.y = scale;
		creditsbg.antialiasing = false;
		add(creditsbg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		var letterbox1:FlxBackdrop = new FlxBackdrop(Paths.image('mainmenu/lettabox'),X);
		letterbox1.scrollFactor.set();
		letterbox1.y = FlxG.height - letterbox1.height;
		letterbox1.velocity.x = 40;
		add(letterbox1);

		var letterbox2:FlxBackdrop = new FlxBackdrop(Paths.image('mainmenu/lettabox2'),X);
		letterbox2.scrollFactor.set();
		letterbox2.velocity.x = -40;
		add(letterbox2);

		magenta = new FlxSprite(80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.set(0, 0);
		magenta.setGraphicSize(Std.int(magenta.width * 1.6));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFFfd719b;
		add(magenta);
		
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, 50);
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', 'mm_' + optionShit[i] + 'idle', 24);
			menuItem.animation.addByPrefix('selected', 'mm_' + optionShit[i] + 'c', 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
		}



		FlxG.camera.follow(camFollowPos, null, 1);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}
			if (FlxG.keys.justPressed.FIVE) {
				//MusicBeatState.switchState(new ShaderTestState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					//if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						{
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story':
										MusicBeatState.switchState(new OurpleStoryState());
									case 'freeplay':
										MusicBeatState.switchState(new FreeplayState());
									#if MODS_ALLOWED
									case 'mods':
										MusicBeatState.switchState(new ModsMenuState());
									#end
									case 'awards':
										MusicBeatState.switchState(new AchievementsMenuState());
									case 'credits':
										openSubState(new CreditsSubstate());
										
									case 'options':
										LoadingState.loadAndSwitchState(new options.OptionsState());
								}
							}
						}
					});
				}
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	override function closeSubState() {
		selectedSomethin = false;
		super.closeSubState();
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		
		var daChoice:String = optionShit[curSelected];

		switch(daChoice)
		{
			case 'story':
				storybg.alpha = 1;
				optionsbg.alpha = 0;
				freeplaybg.alpha = 0;
				creditsbg.alpha = 0;
			case 'freeplay':
				storybg.alpha = 0;
				optionsbg.alpha = 0;
				freeplaybg.alpha = 1;
				creditsbg.alpha = 0;
			case 'options':
				storybg.alpha = 0;
				optionsbg.alpha = 1;
				freeplaybg.alpha = 0;
				creditsbg.alpha = 0;
			case 'credits':
				storybg.alpha = 0;
				optionsbg.alpha = 0;
				freeplaybg.alpha = 0;
				creditsbg.alpha = 1;
		}




		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
			
		});
	}
}

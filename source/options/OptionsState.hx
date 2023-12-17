package options;

import flixel.group.FlxSpriteGroup;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxTiledSprite;
#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class OptionsState extends MusicBeatState
{
	var options:Array<String> = ['Note Colors', 'Controls', 'Adjust Delay and Combo', 'Graphics', 'Visuals and UI', 'Gameplay'];
	private var grpOptions:FlxTypedGroup<FlxText>;
	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;
	public static var onPlayState:Bool = false;
	public static var onOptionSubstate:Bool = false;


	public static var spikes:FlxSpriteGroup; //weird fuckery but it looks cool?

	function openSelectedSubstate(label:String) {
		onOptionSubstate = true;
		grpOptions.visible = false;
		switch(label) {
			case 'Note Colors':
				openSubState(new options.NotesSubState());
			case 'Controls':
				openSubState(new options.ControlsSubState());
			case 'Graphics':
				openSubState(new options.GraphicsSettingsSubState());
			case 'Visuals and UI':
				openSubState(new options.VisualsUISubState());
			case 'Gameplay':
				openSubState(new options.GameplaySettingsSubState());
			case 'Adjust Delay and Combo':
				LoadingState.loadAndSwitchState(new options.NoteOffsetState());
		}
	}


	override function create() {
		#if desktop
		DiscordClient.changePresence("Options Menu", null);
		#end
		
		persistentUpdate = persistentDraw = true;

		FlxG.sound.playMusic(Paths.music('options'));

		var bg = new FlxSprite().loadGraphic(Paths.image('options/bg'));
		bg.setGraphicSize(1280);
		bg.updateHitbox();
		add(bg);

		var guy = new FlxSprite();
		guy.frames = Paths.getSparrowAtlas('options/guy');
		guy.animation.addByPrefix('s','guy g',8);
		guy.animation.play('s');
		guy.y = FlxG.height - guy.height;
		add(guy);

		spikes = new FlxSpriteGroup();

		var spike = new FlxBackdrop(Paths.image('mainmenu/lettabox'),X);
		spike.flipY = true;
		spike.velocity.x = -40;
		spikes.add(spike);

		var spike = new FlxBackdrop(Paths.image('mainmenu/lettabox'),X);
		spike.y = FlxG.height - spike.height;
		spike.velocity.x = 40;
		spikes.add(spike);


		grpOptions = new FlxTypedGroup<FlxText>();
		add(grpOptions);
		
		add(spikes);
		for (i in 0...options.length)
		{
			var optionstxt = new FlxText(650,0,0,options[i]);
			optionstxt.setFormat(Paths.font("options.ttf"), 40, FlxColor.WHITE, CENTER,FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			optionstxt.screenCenter(Y);
			optionstxt.y += (60 * (i - (options.length / 2))) + 50;
			optionstxt.ID = i;
			grpOptions.add(optionstxt);
		}

		changeSelection();
		ClientPrefs.saveSettings();

		super.create();
	}

	override function closeSubState() {
		//add(spikes);
		super.closeSubState();
		ClientPrefs.saveSettings();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		if (!onOptionSubstate) {
			if (!grpOptions.visible) {

				grpOptions.visible = true;
			} 
			if (controls.UI_UP_P) {
				changeSelection(-1);
			}
			if (controls.UI_DOWN_P) {
				changeSelection(1);
			}
	
			if (controls.BACK) {
				FlxG.sound.play(Paths.sound('cancelMenu'));
				if(onPlayState)
				{
					StageData.loadDirectory(PlayState.SONG);
					LoadingState.loadAndSwitchState(new PlayState());
					FlxG.sound.music.volume = 0;
				}
				else MusicBeatState.switchState(new MainMenuState());
			}
	
			if (controls.ACCEPT) {
				openSelectedSubstate(options[curSelected]);
			}
		}


	}
	
	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		for (i in grpOptions) {
			i.alpha = 0.8;
			i.color = FlxColor.WHITE;
			i.borderColor = FlxColor.BLACK;
			if (i.ID == curSelected){
				i.alpha = 1;
				i.color = 0xFFA04EBA;
				i.borderColor = 0xFFFFFFFF;
			} 
		}

		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}

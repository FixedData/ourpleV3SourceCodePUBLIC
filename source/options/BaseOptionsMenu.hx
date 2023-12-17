package options;

import flixel.addons.display.FlxBackdrop;
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
import flixel.math.FlxPoint;
import Controls;

using StringTools;

class BaseOptionsMenu extends MusicBeatSubstate
{
	private var curOption:Option = null;
	private var curSelected:Int = 0;
	private var optionsArray:Array<Option>;

	private var grpOptions:FlxTypedGroup<OptionFlxText>;
	private var checkboxGroup:FlxTypedGroup<CheckboxThingie>;
	private var grpTexts:FlxTypedGroup<AttachedFlxText>;

	private var boyfriend:Character = null;
	private var descBox:FlxSprite;
	private var descText:FlxText;

	public var title:String;
	public var rpcTitle:String;

	public function new()
	{
		super();

		if(title == null) title = 'Options';
		if(rpcTitle == null) rpcTitle = 'Options Menu';
		
		#if desktop
		DiscordClient.changePresence(rpcTitle, null);
		#end
		

		// avoids lagspikes while scrolling through menus!
		grpOptions = new FlxTypedGroup<OptionFlxText>();
		add(grpOptions);

		grpTexts = new FlxTypedGroup<AttachedFlxText>();
		add(grpTexts);

		checkboxGroup = new FlxTypedGroup<CheckboxThingie>();
		add(checkboxGroup);

		descBox = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		descBox.alpha = 0.6;
		add(descBox);

		var titleText = new FlxText(25, 80, 0, title, 32);
		titleText.setFormat(Paths.font("options.ttf"), 40, FlxColor.WHITE, CENTER,FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		titleText.alpha = 0.6;
		add(titleText);

		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("options.ttf"), 28, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		//descText.borderSize = 2.4;
		add(descText);

		for (i in 0...optionsArray.length)
		{
			var optionText = new OptionFlxText(650,0,optionsArray[i].name);
			optionText.startPosition.y = 185.5;
			optionText.distancePerItem.y = 46.25;
			grpOptions.add(optionText);
			optionText.changeX = false;
			optionText.isMenuItem = true;
			optionText.targetY = i;
			optionText.snapToPosition();


			if(optionsArray[i].type == 'bool') {
				var checkbox:CheckboxThingie = new CheckboxThingie(optionText.x + optionText.width + 10, optionText.y, optionsArray[i].getValue() == true);
				checkbox.sprTracker = optionText;
				checkbox.offsetX = optionText.width + 10;
				checkbox.offsetY = 5;
				checkbox.ID = i;
				checkboxGroup.add(checkbox);
			} else {
				var valueText:AttachedFlxText = new AttachedFlxText('' + optionsArray[i].getValue(), optionText.width + 10);
				valueText.sprTracker = optionText;
				valueText.copyAlpha = true;
				valueText.ID = i;
				grpTexts.add(valueText);
				optionsArray[i].setChild(valueText);
			}

			if(optionsArray[i].showBoyfriend && boyfriend == null)
			{
				reloadBoyfriend();
			}
			updateTextFrom(optionsArray[i]);
		}

		changeSelection();
		reloadCheckboxes();

		//remove(OptionsState.spikes);
		//add(OptionsState.spikes);

	}

	public function addOption(option:Option) {
		if(optionsArray == null || optionsArray.length < 1) optionsArray = [];
		optionsArray.push(option);

	}

	var nextAccept:Int = 5;
	var holdTime:Float = 0;
	var holdValue:Float = 0;
	override function update(elapsed:Float)
	{
		if (controls.UI_UP_P)
		{
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P)
		{
			changeSelection(1);
		}

		if (controls.BACK) {
			OptionsState.onOptionSubstate = false;
			close();
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}

		if(nextAccept <= 0)
		{
			var usesCheckbox = true;
			if(curOption.type != 'bool')
			{
				usesCheckbox = false;
			}

			if(usesCheckbox)
			{
				if(controls.ACCEPT)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					curOption.setValue((curOption.getValue() == true) ? false : true);
					curOption.change();
					reloadCheckboxes();
				}
			} else {
				if(controls.UI_LEFT || controls.UI_RIGHT) {
					var pressed = (controls.UI_LEFT_P || controls.UI_RIGHT_P);
					if(holdTime > 0.5 || pressed) {
						if(pressed) {
							var add:Dynamic = null;
							if(curOption.type != 'string') {
								add = controls.UI_LEFT ? -curOption.changeValue : curOption.changeValue;
							}

							switch(curOption.type)
							{
								case 'int' | 'float' | 'percent':
									holdValue = curOption.getValue() + add;
									if(holdValue < curOption.minValue) holdValue = curOption.minValue;
									else if (holdValue > curOption.maxValue) holdValue = curOption.maxValue;

									switch(curOption.type)
									{
										case 'int':
											holdValue = Math.round(holdValue);
											curOption.setValue(holdValue);

										case 'float' | 'percent':
											holdValue = FlxMath.roundDecimal(holdValue, curOption.decimals);
											curOption.setValue(holdValue);
									}

								case 'string':
									var num:Int = curOption.curOption; //lol
									if(controls.UI_LEFT_P) --num;
									else num++;

									if(num < 0) {
										num = curOption.options.length - 1;
									} else if(num >= curOption.options.length) {
										num = 0;
									}

									curOption.curOption = num;
									curOption.setValue(curOption.options[num]); //lol
									//trace(curOption.options[num]);
							}
							updateTextFrom(curOption);
							curOption.change();
							FlxG.sound.play(Paths.sound('scrollMenu'));
						} else if(curOption.type != 'string') {
							holdValue += curOption.scrollSpeed * elapsed * (controls.UI_LEFT ? -1 : 1);
							if(holdValue < curOption.minValue) holdValue = curOption.minValue;
							else if (holdValue > curOption.maxValue) holdValue = curOption.maxValue;

							switch(curOption.type)
							{
								case 'int':
									curOption.setValue(Math.round(holdValue));
								
								case 'float' | 'percent':
									curOption.setValue(FlxMath.roundDecimal(holdValue, curOption.decimals));
							}
							updateTextFrom(curOption);
							curOption.change();
						}
					}

					if(curOption.type != 'string') {
						holdTime += elapsed;
					}
				} else if(controls.UI_LEFT_R || controls.UI_RIGHT_R) {
					clearHold();
				}
			}

			if(controls.RESET)
			{
				for (i in 0...optionsArray.length)
				{
					var leOption:Option = optionsArray[i];
					leOption.setValue(leOption.defaultValue);
					if(leOption.type != 'bool')
					{
						if(leOption.type == 'string')
						{
							leOption.curOption = leOption.options.indexOf(leOption.getValue());
						}
						updateTextFrom(leOption);
					}
					leOption.change();
				}
				FlxG.sound.play(Paths.sound('cancelMenu'));
				reloadCheckboxes();
			}
		}

		if(boyfriend != null && boyfriend.animation.curAnim.finished) {
			boyfriend.dance();
		}

		if(nextAccept > 0) {
			nextAccept -= 1;
		}
		super.update(elapsed);
	}

	function updateTextFrom(option:Option) {
		var text:String = option.displayFormat;
		var val:Dynamic = option.getValue();
		if(option.type == 'percent') val *= 100;
		var def:Dynamic = option.defaultValue;
		option.text = text.replace('%v', val).replace('%d', def);
	}

	function clearHold()
	{
		if(holdTime > 0.5) {
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		holdTime = 0;
	}
	
	function changeSelection(change:Int = 0)
	{
		curSelected += change;
		if (curSelected < 0)
			curSelected = optionsArray.length - 1;
		if (curSelected >= optionsArray.length)
			curSelected = 0;

		descText.text = optionsArray[curSelected].description;
		descText.screenCenter(Y);
		descText.y += 270;

		var bullShit:Int = 0;

		for (i in grpOptions.members) {
			i.targetY = bullShit - curSelected;
			bullShit++;

			i.alpha = 0.8;
			i.color = FlxColor.WHITE;
			i.borderColor = FlxColor.BLACK;
			if (i.targetY == 0) {
				i.alpha = 1;
				i.color = 0xFFA04EBA;
				i.borderColor = 0xFFFFFFFF;
			}
		}

		for (text in grpTexts) {
			text.alpha = 0.8;
			text.color = FlxColor.WHITE;
			text.borderColor = FlxColor.BLACK;
			if(text.ID == curSelected) {
				text.alpha = 1;
				text.color = 0xFFA04EBA;
				text.borderColor = 0xFFFFFFFF;
			}
		}

		descBox.setPosition(descText.x - 10, descText.y - 10);
		descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
		descBox.updateHitbox();

		if(boyfriend != null)
		{
			boyfriend.visible = optionsArray[curSelected].showBoyfriend;
		}
		curOption = optionsArray[curSelected]; //shorter lol
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	public function reloadBoyfriend()
	{
		var wasVisible:Bool = false;
		if(boyfriend != null) {
			wasVisible = boyfriend.visible;
			boyfriend.kill();
			remove(boyfriend);
			boyfriend.destroy();
		}

		boyfriend = new Character(840, 170, 'bf_ourple', true);
		boyfriend.setGraphicSize(Std.int(boyfriend.width * 0.75));
		boyfriend.updateHitbox();
		boyfriend.dance();
		insert(1, boyfriend);
		boyfriend.visible = wasVisible;
	}

	function reloadCheckboxes() {
		for (checkbox in checkboxGroup) {
			checkbox.daValue = (optionsArray[checkbox.ID].getValue() == true);
		}
	}
}

class AttachedFlxText extends FlxText
{
	public var offsetX:Float = 0;
	public var offsetY:Float = 0;
	public var sprTracker:FlxSprite;
	public var copyVisible:Bool = true;
	public var copyAlpha:Bool = false;
	public function new(text:String = "", ?offsetX:Float = 0, ?offsetY:Float = 0,?size:Int = 40, ?bold = 1) {
		super(0, 0, text, bold);

		setFormat(Paths.font("options.ttf"), size, FlxColor.WHITE, CENTER,FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		this.offsetX = offsetX;
		this.offsetY = offsetY;
	}

	override function update(elapsed:Float) {
		if (sprTracker != null) {
			setPosition(sprTracker.x + offsetX, sprTracker.y + offsetY);
			if(copyVisible) {
				visible = sprTracker.visible;
			}
			if(copyAlpha) {
				alpha = sprTracker.alpha;
			}
		}

		super.update(elapsed);
	}
}

class OptionFlxText extends FlxText { //im honestly so fucking lost as to why i never did this before
	public var targetY:Int = 0;
	public var changeX:Bool = true;
	public var changeY:Bool = true;
	public var isMenuItem:Bool = false;
	public var distancePerItem:FlxPoint = new FlxPoint(20, 120);
	public var startPosition:FlxPoint = new FlxPoint(0, 0); //for the calculations
	public var snapPosOnly:Bool = false;

	public function new(x:Float, y:Float, text:String = "", ?font:String = 'options.ttf',?size:Int = 40)
	{
		super(x, y);
		this.font = Paths.font(font);
		this.borderStyle = FlxTextBorderStyle.OUTLINE;
		this.borderColor = FlxColor.BLACK;
		this.startPosition.x = x;
		this.startPosition.y = y;
		this.text = text;
		this.size = size;
	}


	override function update(elapsed:Float)
	{
		if (isMenuItem)
		{
			if (!snapPosOnly) {
				var lerpVal:Float = CoolUtil.boundTo(elapsed * 9.6, 0, 1);
				if(changeX)
					x = FlxMath.lerp(x, (targetY * distancePerItem.x) + startPosition.x, lerpVal);
				if(changeY)
					y = FlxMath.lerp(y, (targetY * 1.3 * distancePerItem.y) + startPosition.y, lerpVal);
			}
			else {
				if(changeX)
					x = (targetY * distancePerItem.x) + startPosition.x;
				if(changeY)
					y = (targetY * 1.3 * distancePerItem.y) + startPosition.y;
			}

		}
		super.update(elapsed);
	}

	public function snapToPosition()
		{
			if (isMenuItem)
			{
				if(changeX)
					x = (targetY * distancePerItem.x) + startPosition.x;
				if(changeY)
					y = (targetY * 1.3 * distancePerItem.y) + startPosition.y;
			}
		}
}
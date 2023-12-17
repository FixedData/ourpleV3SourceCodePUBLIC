package options;

import options.BaseOptionsMenu.AttachedFlxText;
import options.BaseOptionsMenu.OptionFlxText;
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

class ControlsSubState extends MusicBeatSubstate {
	private static var curSelected:Int = 1;
	private static var curAlt:Bool = false;

	private static var defaultKey:String = 'Reset to Default Keys';
	private var bindLength:Int = 0;

	var optionShit:Array<Dynamic> = [
		['NOTES'],
		['Left:', 'note_left'],
		['Down:', 'note_down'],
		['Up:', 'note_up'],
		['Right:', 'note_right'],
		[''],
		['UI'],
		['Left:', 'ui_left'],
		['Down:', 'ui_down'],
		['Up:', 'ui_up'],
		['Right:', 'ui_right'],
		[''],
		['Reset:', 'reset'],
		['Accept:', 'accept'],
		['Back:', 'back'],
		['Pause:', 'pause'],
		[''],
		['VOLUME'],
		['Mute:', 'volume_mute'],
		['Up:', 'volume_up'],
		['Down:', 'volume_down'],
		[''],
		['DEBUG'],
		['Key 1:', 'debug_1'],
		['Key 2:', 'debug_2']
	];

	private var grpOptions:FlxTypedGroup<OptionFlxText>;
	private var grpInputs:Array<AttachedFlxText> = [];
	private var grpInputsAlt:Array<AttachedFlxText> = [];
	var rebindingKey:Bool = false;
	var nextAccept:Int = 5;

	public function new() {
		super();

		// var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		// bg.color = 0xFFea71fd;
		// bg.screenCenter();
		// bg.antialiasing = ClientPrefs.globalAntialiasing;
		// add(bg);
		


		grpOptions = new FlxTypedGroup<OptionFlxText>();
		add(grpOptions);

		optionShit.push(['']);
		optionShit.push([defaultKey]);

		for (i in 0...optionShit.length) {
			var isCentered:Bool = false;
			var isDefaultKey:Bool = (optionShit[i][0] == defaultKey);
			if(unselectableCheck(i, true)) {
				isCentered = true;
			}

			var optionText:OptionFlxText = new OptionFlxText(600, 300, optionShit[i][0]);
			optionText.isMenuItem = true;
			if(isCentered) {
				//optionText.screenCenter(X);
				optionText.x += 200;
				optionText.y -= 55;
				optionText.startPosition.y -= 55;
			}
			optionText.changeX = false;
			optionText.distancePerItem.y = 60;
			optionText.targetY = i - curSelected;
			optionText.snapToPosition();
			grpOptions.add(optionText);

			if(!isCentered) {
				addBindTexts(optionText, i);
				bindLength++;
				if(curSelected < 0) curSelected = i;
			}
		}
		changeSelection();
	}

	var leaving:Bool = false;
	var bindingTime:Float = 0;
	override function update(elapsed:Float) {
		if(!rebindingKey) {
			if (controls.UI_UP_P) {
				changeSelection(-1);
			}
			if (controls.UI_DOWN_P) {
				changeSelection(1);
			}
			if (controls.UI_LEFT_P || controls.UI_RIGHT_P) {
				changeAlt();
			}

			if (controls.BACK) {
				OptionsState.onOptionSubstate = false;
				ClientPrefs.reloadControls();
				close();
				FlxG.sound.play(Paths.sound('cancelMenu'));
			}

			if(controls.ACCEPT && nextAccept <= 0) {
				if(optionShit[curSelected][0] == defaultKey) {
					ClientPrefs.keyBinds = ClientPrefs.defaultKeys.copy();
					reloadKeys();
					changeSelection();
					FlxG.sound.play(Paths.sound('confirmMenu'));
				} else if(!unselectableCheck(curSelected)) {
					bindingTime = 0;
					rebindingKey = true;
					if (curAlt) {
						grpInputsAlt[getInputTextNum()].alpha = 0;
					} else {
						grpInputs[getInputTextNum()].alpha = 0;
					}
					FlxG.sound.play(Paths.sound('scrollMenu'));
				}
			}
		} else {
			var keyPressed:Int = FlxG.keys.firstJustPressed();
			if (keyPressed > -1) {
				var keysArray:Array<FlxKey> = ClientPrefs.keyBinds.get(optionShit[curSelected][1]);
				keysArray[curAlt ? 1 : 0] = keyPressed;

				var opposite:Int = (curAlt ? 0 : 1);
				if(keysArray[opposite] == keysArray[1 - opposite]) {
					keysArray[opposite] = NONE;
				}
				ClientPrefs.keyBinds.set(optionShit[curSelected][1], keysArray);

				reloadKeys();
				FlxG.sound.play(Paths.sound('confirmMenu'));
				rebindingKey = false;
			}

			bindingTime += elapsed;
			if(bindingTime > 5) {
				if (curAlt) {
					grpInputsAlt[curSelected].alpha = 1;
				} else {
					grpInputs[curSelected].alpha = 1;
				}
				FlxG.sound.play(Paths.sound('scrollMenu'));
				rebindingKey = false;
				bindingTime = 0;
			}
		}

		if(nextAccept > 0) {
			nextAccept -= 1;
		}
		super.update(elapsed);
	}

	function getInputTextNum() {
		var num:Int = 0;
		for (i in 0...curSelected) {
			if(optionShit[i].length > 1) {
				num++;
			}
		}
		return num;
	}
	
	function changeSelection(change:Int = 0) {
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = optionShit.length - 1;
			if (curSelected >= optionShit.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var bullShit:Int = 0;

		for (i in 0...grpInputs.length) {
			grpInputs[i].alpha = 0.8;
			grpInputs[i].color = FlxColor.WHITE;
			grpInputs[i].borderColor = FlxColor.BLACK;
		}
		for (i in 0...grpInputsAlt.length) {
			grpInputsAlt[i].alpha = 0.8;
			grpInputsAlt[i].color = FlxColor.WHITE;
			grpInputsAlt[i].borderColor = FlxColor.BLACK;
		}

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.8;
				item.color = FlxColor.WHITE;
				item.borderColor = FlxColor.BLACK;
				if (item.targetY == 0) {
					item.alpha = 1;
					item.color = 0xFFA04EBA;
					item.borderColor = 0xFFFFFFFF;
					if(curAlt) {
						for (i in 0...grpInputsAlt.length) {
							if(grpInputsAlt[i].sprTracker == item) {
								grpInputsAlt[i].alpha = 1;
								grpInputsAlt[i].color = 0xFFA04EBA;
								grpInputsAlt[i].borderColor = 0xFFFFFFFF;
								break;
							}
						}
					} else {
						for (i in 0...grpInputs.length) {
							if(grpInputs[i].sprTracker == item) {
								grpInputs[i].alpha = 1;
								grpInputs[i].color = 0xFFA04EBA;
								grpInputs[i].borderColor = 0xFFFFFFFF;
								break;
							}
						}
					}
				}
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	function changeAlt() {
		curAlt = !curAlt;
		for (i in 0...grpInputs.length) {
			if(grpInputs[i].sprTracker == grpOptions.members[curSelected]) {
				grpInputs[i].alpha = 0.8;
				grpInputs[i].color = FlxColor.WHITE;
				grpInputs[i].borderColor = FlxColor.BLACK;
				if(!curAlt) {
					grpInputs[i].alpha = 1;
					grpInputs[i].color = 0xFFA04EBA;
					grpInputs[i].borderColor = 0xFFFFFFFF;
				}
				break;
			}
		}
		for (i in 0...grpInputsAlt.length) {
			if(grpInputsAlt[i].sprTracker == grpOptions.members[curSelected]) {
				grpInputsAlt[i].alpha = 0.8;
				grpInputsAlt[i].color = FlxColor.WHITE;
				grpInputsAlt[i].borderColor = FlxColor.BLACK;
				if(curAlt) {
					grpInputsAlt[i].alpha = 1;
					grpInputsAlt[i].color = 0xFFA04EBA;
					grpInputsAlt[i].borderColor = 0xFFFFFFFF;
				}
				break;
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	private function unselectableCheck(num:Int, ?checkDefaultKey:Bool = false):Bool {
		if(optionShit[num][0] == defaultKey) {
			return checkDefaultKey;
		}
		return optionShit[num].length < 2 && optionShit[num][0] != defaultKey;
	}

	private function addBindTexts(optionText:OptionFlxText, num:Int) {
		var keys:Array<Dynamic> = ClientPrefs.keyBinds.get(optionShit[num][1]);
		var text1 = new AttachedFlxText(InputFormatter.getKeyName(keys[0]), 200);
		text1.setPosition(optionText.x + 200, optionText.y);
		text1.sprTracker = optionText;
		grpInputs.push(text1);
		add(text1);

		var text2 = new AttachedFlxText(InputFormatter.getKeyName(keys[1]), 400);
		text2.setPosition(optionText.x + 400, optionText.y);
		text2.sprTracker = optionText;
		grpInputsAlt.push(text2);
		add(text2);
	}

	function reloadKeys() {
		while(grpInputs.length > 0) {
			var item:AttachedFlxText = grpInputs[0];
			item.kill();
			grpInputs.remove(item);
			item.destroy();
		}
		while(grpInputsAlt.length > 0) {
			var item:AttachedFlxText = grpInputsAlt[0];
			item.kill();
			grpInputsAlt.remove(item);
			item.destroy();
		}

		trace('Reloaded keys: ' + ClientPrefs.keyBinds);

		for (i in 0...grpOptions.length) {
			if(!unselectableCheck(i, true)) {
				addBindTexts(grpOptions.members[i], i);
			}
		}


		var bullShit:Int = 0;
		for (i in 0...grpInputs.length) {
			grpInputs[i].alpha = 0.6;
		}
		for (i in 0...grpInputsAlt.length) {
			grpInputsAlt[i].alpha = 0.6;
		}

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
					if(curAlt) {
						for (i in 0...grpInputsAlt.length) {
							if(grpInputsAlt[i].sprTracker == item) {
								grpInputsAlt[i].alpha = 1;
							}
						}
					} else {
						for (i in 0...grpInputs.length) {
							if(grpInputs[i].sprTracker == item) {
								grpInputs[i].alpha = 1;
							}
						}
					}
				}
			}
		}
	}
}
package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class StrumNote extends FlxSprite
{
	private var colorSwap:ColorSwap;
	public var resetAnim:Float = 0;
	private var noteData:Int = 0;
	public var direction:Float = 90;//plan on doing scroll directions soon -bb
	public var downScroll:Bool = false;//plan on doing scroll directions soon -bb
	public var sustainReduce:Bool = true;
	public var animOffsets:Map<String, Array<Float>>;

	private var player:Int;
	
	public var texture(default, set):String = null;
	private function set_texture(value:String):String {
		if(texture != value) {
			texture = value;
			reloadNote();
		}
		return value;
	}

	public function new(x:Float, y:Float, leData:Int, player:Int) {
		colorSwap = new ColorSwap();
		shader = colorSwap.shader;
		noteData = leData;
		this.player = player;
		this.noteData = leData;
		super(x, y);
		
		#if (haxe >= "4.0.0")
		animOffsets = new Map();
		#else
		animOffsets = new Map<String, Array<Float>>();
		#end

		var skin:String = 'NOTE_assets';
		if(PlayState.SONG.arrowSkin != null && PlayState.SONG.arrowSkin.length > 1) skin = PlayState.SONG.arrowSkin;
		texture = skin; //Load texture and anims

		scrollFactor.set();
	}

	public function reloadNote()
	{
		var lastAnim:String = null;
		if(animation.curAnim != null) lastAnim = animation.curAnim.name;

		if(PlayState.isPixelStage)
		{
			loadGraphic(Paths.image('pixelHUD/' + texture));
			width = width / 4;
			height = height / 4;
			loadGraphic(Paths.image('pixelHUD/' + texture), true, Math.floor(width), Math.floor(height));

			antialiasing = false;
			setGraphicSize(Std.int(width * PlayState.daPixelZoom));

			animation.add('green', [6]);
			animation.add('red', [7]);
			animation.add('blue', [5]);
			animation.add('purple', [4]);
			switch (Math.abs(noteData) % 4)
			{
				case 0:
					animation.add('static', [0]);
					animation.add('pressed', [8, 12], 12, false);
					animation.add('confirm', [8, 12], 8, false);
					addOffset('static',0,-6);
					addOffset('pressed',0,-6);
					addOffset('confirm',0,-6);
				case 1:
					animation.add('static', [1]);
					animation.add('pressed', [9, 13], 12, false);
					animation.add('confirm', [9, 13], 8, false);
					addOffset('static',0,-6);
					addOffset('pressed',0,-6);
					addOffset('confirm',0,-6);
				case 2:
					animation.add('static', [2]);
					animation.add('pressed', [10, 14], 12, false);
					animation.add('confirm', [10, 14], 8, false);
					addOffset('static',0,-6);
					addOffset('pressed',0,-6);
					addOffset('confirm',0,-6);
				case 3:
					animation.add('static', [3]);
					animation.add('pressed', [11, 15], 12, false);
					animation.add('confirm', [11, 15], 8, false);
					addOffset('static',0,-6);
					addOffset('pressed',0,-6);
					addOffset('confirm',0,-6);
			}
		}
		else
		{
			frames = Paths.getSparrowAtlas(texture);
			animation.addByPrefix('green', 'arrowUP');
			animation.addByPrefix('blue', 'arrowDOWN');
			animation.addByPrefix('purple', 'arrowLEFT');
			animation.addByPrefix('red', 'arrowRIGHT');

			antialiasing = false;
			setGraphicSize(Std.int(width * 0.7));

			switch (Math.abs(noteData) % 4)
			{
				case 0:
					animation.addByPrefix('static', 'arrowLEFT');
					animation.addByPrefix('pressed', 'left press', 30, false);
					animation.addByPrefix('confirm', 'left confirm', 30, false);
					if (PlayState.isOurpleNote)
					{
					addOffset('confirm', 2, 0,-1);
					addOffset('pressed', 9, -3,-1); 

					}
				case 1:
					animation.addByPrefix('static', 'arrowDOWN');
					animation.addByPrefix('pressed', 'down press', 30, false);
					animation.addByPrefix('confirm', 'down confirm', 24, false);
					if (PlayState.isOurpleNote)
					{
					addOffset('confirm', -3, -10);
					addOffset('pressed', 3, -10);
					}
				case 2:
					animation.addByPrefix('static', 'arrowUP');
					animation.addByPrefix('pressed', 'up press', 30, false);
					animation.addByPrefix('confirm', 'up confirm', 30, false);
					if (PlayState.isOurpleNote)
					{
					addOffset('confirm', 2, 6);
					addOffset('pressed', 1.5, 12.5);
					}
				case 3:
					animation.addByPrefix('static', 'arrowRIGHT');
					animation.addByPrefix('pressed', 'right press', 30, false);
					animation.addByPrefix('confirm', 'right confirm', 30, false);
					if (PlayState.isOurpleNote)
					{
					addOffset('confirm',-2, 0,1);
					addOffset('pressed', -7, 0,1);
					}
			}
		}
		updateHitbox();

		if(lastAnim != null)
		{
			playAnim(lastAnim, true);
		}
	}

	public function postAddedToGroup() {
		playAnim('static');
		x += Note.swagWidth * noteData;
		x += 50;
		x += ((FlxG.width / 2) * player);
		ID = noteData;
	}

	override function update(elapsed:Float) {
		if(resetAnim > 0) {
			resetAnim -= elapsed;
			if(resetAnim <= 0) {
				playAnim('static');
				resetAnim = 0;
			}
		}
		//if(animation.curAnim != null){ //my bad i was upset
		if(animation.curAnim.name == 'confirm' && !PlayState.isPixelStage) {
			centerOrigin();
		//}
		}

		super.update(elapsed);
	}

	public function playAnim(anim:String, ?force:Bool = false) {
		animation.play(anim, force);
		centerOffsets();
		centerOrigin();

		if (anim == 'static') angle = 0;
		var daOffset = animOffsets.get(anim);
		if (animOffsets.exists(anim))
		{
			centerOffsets();
			offset.set(offset.x + daOffset[0], offset.y + daOffset[1]);
			angle = daOffset[2];
		}
		else
			centerOffsets();
		
		if(animation.curAnim == null || animation.curAnim.name == 'static') {
			colorSwap.hue = 0;
			colorSwap.saturation = 0;
			colorSwap.brightness = 0;
		} else {
			if (noteData > -1 && noteData < ClientPrefs.arrowHSV.length)
			{
				colorSwap.hue = ClientPrefs.arrowHSV[noteData][0] / 360;
				colorSwap.saturation = ClientPrefs.arrowHSV[noteData][1] / 100;
				colorSwap.brightness = ClientPrefs.arrowHSV[noteData][2] / 100;
			}

			if(animation.curAnim.name == 'confirm' && !PlayState.isPixelStage) {
				centerOrigin();
			}
		}
	}
	
	public function addOffset(name:String, x:Float = 0, y:Float = 0, angle:Float = 0)
	{
		animOffsets[name] = [x, y, angle];
	}

}

package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class CheckboxThingie extends FlxSprite
{
	public var sprTracker:FlxSprite;
	public var daValue(default, set):Bool;
	public var copyAlpha:Bool = true;
	public var offsetX:Float = 0;
	public var offsetY:Float = 0;
	public function new(x:Float = 0, y:Float = 0, ?checked = false) {
		super(x, y);

		// frames = Paths.getSparrowAtlas('check');
		// animation.addByPrefix('checked','check selected');
		// animation.addByPrefix('unchecked','check idle');
		loadGraphic(Paths.image('check2'),true,54,51);
		animation.add('checked',[0]);
		animation.add('unchecked',[1]);

		antialiasing = false;
		//setGraphicSize(Std.int(0.9 * width));
		//scale.set(0.2,0.2);
		//updateHitbox();

		animationFinished(checked ? 'checking' : 'unchecking');
		animation.finishCallback = animationFinished;
		daValue = checked;
	}

	override function update(elapsed:Float) {
		if (sprTracker != null) {
			setPosition(sprTracker.x + offsetX, sprTracker.y + offsetY);
			if(copyAlpha) {
				alpha = sprTracker.alpha;
			}
		}
		super.update(elapsed);
	}

	private function set_daValue(check:Bool):Bool {
		if(check) {
			if(animation.curAnim.name != 'checked' && animation.curAnim.name != 'checking') {
				animation.play('checked', true);
				//offset.set(-10,110);
			}
		} else if(animation.curAnim.name != 'unchecked' && animation.curAnim.name != 'unchecking') {
			animation.play("unchecked", true);
			//offset.set(-10,120);
		}
		return check;
	}

	private function animationFinished(name:String)
	{
		switch(name)
		{
			case 'checking':
				animation.play('checked', true);
				//offset.set(-10,110);
			case 'unchecking':
				animation.play('unchecked', true);
				//offset.set(-10,120);
		}
	}
}
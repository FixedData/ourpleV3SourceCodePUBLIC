package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxTimer;
import flixel.group.FlxSpriteGroup;
import flixel.FlxG;
import flixel.FlxSprite;


class OurpleStoryState extends MusicBeatState
{
    var guys:Array<FlxSprite> = [];
    var twoFreakinOptions:Array<String> = [
        'whoguy',
        'nft'
    ];

    var options:FlxSpriteGroup;
    var curSelect:Int = 0;

    var weeks:Array<Array<String>> = [
        ['guy','golden','dismantle'],
        ['man','cashmoney']
    ];

    override function create()
    {
        var bg = new FlxSprite().loadGraphic(Paths.image('story/bg'));
        bg.setGraphicSize(FlxG.width); //seperate black bars so it goes behind
        bg.updateHitbox();
        add(bg);

        var guyingout = new FlxBackdrop(Paths.image('story/guys'),XY,50,50);
        guyingout.velocity.set(40,40);
        guyingout.scale.set(1.5,1.5);
        add(guyingout);

       FlxTween.tween(guyingout, {x: -80},2, {type: PINGPONG, ease: FlxEase.circInOut});

        var b = new FlxSprite().makeGraphic(FlxG.width,62,FlxColor.BLACK);
        add(b);

        var b = new FlxSprite(0,FlxG.height-62).makeGraphic(FlxG.width,62,FlxColor.BLACK);
        add(b);

        options = new FlxSpriteGroup();

        for (i in 0...twoFreakinOptions.length) {
            var guy = new FlxSprite().loadGraphic(Paths.image('story/guy${i+1}'));
            guy.scale.set(1.5,1.5);
            guy.updateHitbox();
            add(guy);
            guy.ID = i;
            guys.push(guy);

            var op = new FlxSprite(); //i forgor that sprite sheet gen adds frame width and height
            op.frames = Paths.getSparrowAtlas('story/${twoFreakinOptions[i]}');
            op.scale.set(1.5,1.5);
            op.updateHitbox();
            op.animation.addByPrefix('i','i');
            op.animation.addByPrefix('s','s');
            op.animation.play('s');
            op.ID = i;
            options.add(op);

        }
        add(options);
        change();

        super.create();

    }

    override function update(elapsed:Float){
		super.update(elapsed);

        if (controls.UI_UP_P) change(-1);
        if (controls.UI_DOWN_P) change(1);

        if (controls.BACK) {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            MusicBeatState.switchState(new MainMenuState());
        }
        if (controls.ACCEPT) loadPlayState();
    }

    function change(?val:Int = 0) {
        curSelect += val;
    
        if (val != 0) FlxG.sound.play(Paths.sound('scrollMenu'), 1);

        if (curSelect < 0) curSelect = twoFreakinOptions.length - 1;
        if (curSelect >= twoFreakinOptions.length) curSelect = 0;

        for (i in guys) 
            if (i.ID == curSelect) i.visible = true;
            else i.visible = false;
      
        for (i in options) 
            if (i.ID == curSelect) i.animation.play('s');
            else i.animation.play('i');
        
    }

    function loadPlayState() {
        FlxG.sound.play(Paths.sound('confirmMenu'));
		WeekData.reloadWeekFiles(true);
		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();	
	
		PlayState.storyPlaylist = weeks[curSelect];
		PlayState.isStoryMode = true;
	
		var diffic = CoolUtil.getDifficultyFilePath(2);
		if(diffic == null) diffic = '';
	
		PlayState.storyDifficulty = 2;
	
		PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
		PlayState.campaignScore = 0;
		PlayState.campaignMisses = 0;
		new FlxTimer().start(.1, function(tmr:FlxTimer)
		{
			LoadingState.loadAndSwitchState(new PlayState());
			FreeplayState.destroyFreeplayVocals();
		});
    }
}
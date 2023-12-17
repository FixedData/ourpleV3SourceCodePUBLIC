package;

import Stage.MosiacShader;
import Stage.Fishlens;
import Stage.GlitchShader2;
import Stage.BloomShader;
import Stage.GlitchShaderA;
import Stage.FollowedGlitch;
import flixel.FlxCamera;
import flixel.input.keyboard.FlxKeyList;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxAssets.FlxShader;
import openfl.filters.ShaderFilter;
import flixel.text.FlxText;
import Stage.Glitch2;
import openfl.filters.BitmapFilter;
import flixel.FlxSprite;
import flixel.FlxG;
import Stage.*;

//add every shader and a button to it

class ShaderTestState extends MusicBeatState {

    var array:Array<BitmapFilter> = [];
    var itime:Array<Dynamic> = [];
    var text:FlxText;
    var currentShader:String = '';


    override function create() {
        super.create();



        var loadScreen = new FlxSprite();
        loadScreen.frames = Paths.getSparrowAtlas('load');
        loadScreen.animation.addByPrefix('s','load s',8);
        loadScreen.animation.play('s');
        loadScreen.setGraphicSize(FlxG.width,FlxG.height);
        loadScreen.updateHitbox();
        add(loadScreen);

        text = new FlxText(0,0,FlxG.width,'press 1 to 9 to test shaders',40);
        text.y = FlxG.height - text.height;
        text.alignment = CENTER;
        add(text);

        var cam = new FlxCamera();
        cam.bgColor.alpha = 0;
        FlxG.cameras.add(cam,false);
        text.cameras = [cam];

        FlxG.camera.setFilters(array);






    }

    override function update(elapsed:Float) {

        if (FlxG.keys.justPressed.ZERO) {
            pop();
        }
        if (FlxG.keys.justPressed.ONE) {
            var shader = new Glitch2();
            shader.glitchy = 0.1;
            addShader(shader,true);
            currentShader = 'glitch2';
        }
        if (FlxG.keys.justPressed.TWO) {
            var shader = new FollowedGlitch();
            shader.squareAmount = 0.1;
            shader.glowAmount = 0.2;
            addShader(shader,true);
            currentShader = 'FollowedGlitch';
        }
        if (FlxG.keys.justPressed.THREE) {
            var shader = new GlitchShaderA();
            shader.glitchEffect = 0.3;
            addShader(shader,true);
            currentShader = 'GlitchShaderA';
        }
        if (FlxG.keys.justPressed.FOUR) {
            var shader = new BloomShader();
            shader.glowAmount = 0.3;
            addShader(shader);
            currentShader = 'BloomShader';
        }
        if (FlxG.keys.justPressed.FIVE) {
            var shader = new GlitchShader2();
            shader.amount = 0.05;
            addShader(shader,true);
            currentShader = 'GlitchShader2';
        }
        if (FlxG.keys.justPressed.SIX) {
            var shader = new Fishlens();
            shader.chromatic = 0.3;
            shader.intensity = 1.1;
            addShader(shader);
            currentShader = 'Fishlens';
        }
        if (FlxG.keys.justPressed.SEVEN) {
            var shader = new MosiacShader();
            shader.pixelSize = 10;
            addShader(shader);
            currentShader = 'MosiacShader';
        }
        if (controls.BACK) {
            MusicBeatState.switchState(new MainMenuState());
        }

        text.text = 'press 1 to 7 to test shaders.\n0 to reset.' + '\nCurrent Shader: ' + currentShader;
        text.y = FlxG.height - text.height;

        for (i in itime) i.update(elapsed);

        super.update(elapsed);

    }

    function addShader(shader:FlxShader, itime:Bool = false) {
        pop();
        array.push(new ShaderFilter(shader));
        if (itime) this.itime.push(shader);
    }
    function pop():Void {
        while (array.length > 0) array.pop();
    }
}
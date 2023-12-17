package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.util.FlxColor;
import sys.FileSystem;
import sys.io.File;
import haxe.Json;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;

//i thought this could be really useful for in the future

typedef SubtitleContent = {
    var sub:String;
    var firstStep:Int;
    var finalStep:Int;
    @:optional var fontSize:Int;
    @:optional var color:String;
    @:optional var skipFadeOut:Bool;
    @:optional var skipFadeIn:Bool; //these sucks todo add a thing that auto checks time between
} 

typedef SubtitleData = {
    var subtitles:Array<SubtitleContent>;
} 

class SubtitleHandler extends FlxTypedGroup<FlxText> {

    public inline static function getSubsFromSong(song:String) {
        //maybe todo make a format to song path that doesnt ignore mods
        if (FileSystem.exists('assets/data/' + Paths.formatToSongPath(song) + '/subtitles.json') || FileSystem.exists('mods/data/' + Paths.formatToSongPath(song) + '/subtitles.json')) {
            trace('eeyes subs!');
            return new SubtitleHandler(Json.parse(Paths.getTextFromFile('data/' + Paths.formatToSongPath(song) + '/subtitles.json')));
        }
        else {
            trace('no subs');
            return null;
        }


    }

    var songSubtitles:Array<SubtitleContent> = [];
    var curSubData:SubtitleContent;
    var allowedToFade:Bool = true;
    
    public function new (subs:SubtitleData) {
        super();
        songSubtitles = subs.subtitles;

        
    }

    function createSub(data:SubtitleContent) {
        //trace('generatingtext');
        killText();
        curSubData = data;

        var defaultColor:FlxColor = FlxColor.WHITE;
        if (curSubData.color != null) defaultColor = FlxColor.fromString(curSubData.color);

        var defaultFontSize:Int = 32;
        if (curSubData.fontSize != null) defaultFontSize = curSubData.fontSize;

        var text = new FlxText(0,0,0,curSubData.sub,defaultFontSize);
        text.setFormat(Paths.font("bite.ttf"), defaultFontSize, defaultColor, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);   
        text.screenCenter(X);
        text.y = FlxG.height - text.height - 100;
        add(text); 
        var skipAlpha:Bool = false;
        if (curSubData.skipFadeIn != null) skipAlpha = true;
        trace('fadein: ' + curSubData.skipFadeIn + ' fadeout: ' + curSubData.skipFadeOut);
        if (!skipAlpha) {
            text.alpha = 0;
            FlxTween.tween(text, {alpha: 1}, 0.2, {ease: FlxEase.quadOut});
        }
        //trace('finalStep: ' + songSubtitles[0].finalStep + 'firstStep: ' + songSubtitles[1].firstStep);

        // if (songSubtitles[1] != null) {
        //     if (songSubtitles[0].finalStep != songSubtitles[1].firstStep) {
        //         text.alpha = 0;
        //         FlxTween.tween(text, {alpha: 1}, 0.2, {ease: FlxEase.quadOut});
        //     }
        // }
        // else {
        //     text.alpha = 0;
        //     FlxTween.tween(text, {alpha: 1}, 0.2, {ease: FlxEase.quadOut});
        // }

    }

    function getCurStep():Int //i do not care if u want floats for more precision a int will work fine shoot yo self
    {
        var lastChange = Conductor.getBPMFromSeconds(Conductor.songPosition);
		return Std.int(lastChange.stepTime + ((Conductor.songPosition - ClientPrefs.noteOffset) - lastChange.songTime) / lastChange.stepCrochet);
    }

    //maybe rewrite adding a check if the text is currently still persisting so it skips the fades 

    override public function update(elapsed:Float) {
        super.update(elapsed);
        var currentStep = getCurStep();
        if (members.length > 0) {
            if (currentStep >= curSubData.finalStep)  {
                // if (songSubtitles[1] != null) { //unfinisghed
                //     if (songSubtitles[0].finalStep == songSubtitles[1].firstStep) {
                //        // trace('eeyup! the same!');
                //         killText();
                //     }
                //     else
                //         fadeText();
                // }
                // else
                //     fadeText();
                var skipfadeOut:Bool = false;
                if (curSubData.skipFadeOut != null) skipfadeOut = true;
                if (!skipfadeOut)
                    fadeText();
                else
                    killText();
            }
        }
        if (songSubtitles[0] != null) if (currentStep >= songSubtitles[0].firstStep) createSub(songSubtitles.shift());


    }
    
    function fadeText() {
        allowedToFade = false;
        for (i in members) {
            FlxTween.tween(i, {alpha: 0}, 0.2, {ease: FlxEase.quadOut, onComplete: function (f:FlxTween) {
                killText();
                allowedToFade=true;
            }});
        }
    }

    function killText() {
        curSubData = null;
       
        for (i in members) {
            remove(i);
            FlxTween.cancelTweensOf(i);
            i.kill();
            i.destroy();
        }
        clear();

    }

}
package;

//infry
import FreeplayState.CabinetGlitchChrom;
import shaders.ChromaticAbb;
import flixel.math.FlxVector;
import flixel.math.FlxMath;
import openfl.Lib;
import haxe.macro.Type.TypedExpr;
import flixel.system.FlxAssets.FlxShader;
import openfl.filters.ShaderFilter;
import openfl.filters.BitmapFilter;
import CoolUtil as Util;
import haxe.SysTools;
import flixel.util.FlxTimer;
import flixel.group.FlxSpriteGroup;
import flixel.addons.effects.FlxTrail;
import flixel.math.FlxPoint;
import flixel.addons.display.FlxBackdrop;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxBasic;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.display.FlxRuntimeShader;
using StringTools;

class Stage extends FlxTypedGroup<FlxBasic>
{
	private var dad:Character;
	private var bf:Character;

	public var curStage:String = '';
	private var curBeat:Int = 0;
	private var curStep:Int = 0;
	private var curSection:Int = 0;

	public var bgElement:FlxTypedGroup<FlxSprite>;
	public var fgElement:FlxTypedGroup<FlxSprite>;
	public var inFrontOfDad:FlxTypedGroup<FlxSprite>;
	public var hudElement:Array<FlxSprite> = [];
	public var game = PlayState.instance;
	public var usingLua:Bool = false;

	public var updateiTime:Array<FlxRuntimeShader> = [];
	public var updateiTimeHARD:Array<Dynamic> = [];

	//stuff you dont need to really touch
	//-------------------------------------------------------------//

	//watchful
	public var wLight:FlxSprite;
	public var wCouch:FlxSprite;
	public var wBed:FlxSprite;
	public var wClock:FlxSprite;
	public var wOffice:FlxSprite;

	public var wRlines:FlxSprite;
	public var wRLight:FlxSprite;
	public var wRCouch:FlxSprite;
	public var wRBed:FlxSprite;
	public var wRClock:FlxSprite;
	var fearhitbox:FlxSprite;

	//lurking
	public var lurkingcutIntro:FlxSprite;

	//faznews
	var ogCharYs:Array<Float> = [];
	var faznewsTweens:Array<FlxTween> = [];

	//followed
	public var followedScene1:FlxSprite;
	public var followedScene2:FlxSprite;
	public var followedGradient:FlxSprite;
	public var followedEyes:FlxSprite;
	public var followedVignette:FlxSprite;
	public var followedChandel:FlxSprite;
	public var followedHands:FlxSprite;
	public var followedGoGoGo:FlxSprite;
	public var followedStatic:FlxSprite;
	public var followedSinnohbg:FlxSprite;
	public var followedSinnohbg2:FlxSprite;
	public var followedSinnohbg3:FlxSprite;
	public var followedfinalbg:FlxSprite;
	public var followedfinalFlashes:FlxSprite;
	public var followedfinalPurple:FlxSprite;
	public var followedEnding:FlxSprite;

	public var followedPuppets:FlxSpriteGroup;
	public var followedPuppets2:FlxSpriteGroup;

	public var glitchShader:GlitchShaderA;
	public var glitchShader2:FollowedGlitch;
	public var glitchShader3:Glitch2;
	public var bloomShader:BloomShader;
	public var followedGlitchShader3:GlitchShader2;
	public var followedIntenseChromaticAbb:CabinetGlitchChrom;

	public var followedBeatsPerZoomShader:Int = 4;
	public var followedTween:FlxTween;
	public var followedTween2:FlxTween;

	//trapped
	public var trappedWires:FlxSprite;
	public var trappedGradient:FlxSprite;
	public var trappedBG2:FlxSprite;
	public var trappedFG2:FlxSprite;
	public var trappedGlitchy:Int = -1;
	var salvageGhost:FlxTrail;
	public var trappedBlack:FlxSprite;
	public var trappedFire:FlxSprite;
	public var trappedFireBG:FlxSprite;
	public var trappedBlend:FlxSprite;
	public var trappedOurple:FlxSprite;
	public var trappedAbome:FlxSprite;
	public var trappedBonnie:FlxSprite;
	public var traphallucinations:Array<FlxSprite> = [];
	public var trappedShader:TrappedShader;

	//restless
	var cryingfnaf4:FlxSprite;
	var cryingbed:FlxSprite;
	var cryinglive:FlxSprite;	

	//bite-png
	public var CamIdle:FlxSprite;
	public var CamPop:FlxSprite;
	
	//color
	var slops:FlxSpriteGroup;
	var slopping:Bool = false;


	public var omcWhite:FlxSprite;




	//cashmoney 
	public var chromaticShaderCash:ChromaticAbb;


	public var crtShader:CRTshader = null;


	public function new(stage:String)
	{
		super();

		curStage = stage;
		bgElement = new FlxTypedGroup<FlxSprite>();
		fgElement = new FlxTypedGroup<FlxSprite>();
		//inFrontOfDad = new FlxTypedGroup<FlxSprite>();
	}


	public function buildStage()
	{
		trace('not using lua stage!');

		switch (curStage)
		{
			case 'chef':
				var bg = new FlxSprite(-450,-100).loadGraphic(bgPath('bg'));
				add(bg);
				bg.scale.set(1.2,1.2);
				bg.updateHitbox();
			case 'color':
				var bg = new FlxSprite().loadGraphic(bgPath('stage', false, 'ourplesecrets'));
				bg.antialiasing = false;
				addElement(bg);
				GameOverSubstate.characterName = 'slopfriend';
				slops = new FlxSpriteGroup();
				var slopoffs:Array<Array<Float>> = [[-177, 260], [-142, 260], [-142, 322], [-142, 295]];
				addElement(slops);
				for (i in 1...5)
				{
					trace(Std.string(i));
					var slop = new FlxSprite(slopoffs[i-1][0], slopoffs[i-1][1]);
					slop.frames = bgPath('slop' + i, true, 'ourplesecrets');
					if (i != 2)
						slop.animation.addByPrefix('yell', 'yell', 12);
					else
						slop.animation.addByPrefix('yell', 'yell', 18);
					slop.animation.play('yell');
					slop.visible = false;
					slops.add(slop);
				}
				//addElement(slops);
			case 'yes-friend':
				var bg = new FlxSprite().loadGraphic(bgPath('friend_bg'));
				bg.antialiasing = false;
				addElement(bg);
			case 'bite-png':
				var bg = new FlxSprite().loadGraphic(bgPath('punios'));
				bg.scale.set(1.5,1.5);
				bg.updateHitbox;
				addElement(bg);

				CamPop = new FlxSprite();
				CamPop.frames = bgPath('CamPop',true);
				CamPop.cameras = [game.camHUD];
				CamPop.animation.addByPrefix('pop','idle',24,false);
				CamPop.animation.addByPrefix('unpop','backidle', 24, false);
				CamPop.updateHitbox;
				CamPop.alpha = 0;
				addElement(CamPop);

				CamIdle = new FlxSprite();
				CamIdle.frames = bgPath('CamIdle',true);
				CamIdle.scale.set(2.6,2.7);
				CamIdle.cameras = [game.camHUD];
				CamIdle.animation.addByPrefix('idle','idle',12,true);
				CamIdle.screenCenter();
				CamIdle.updateHitbox;
				CamIdle.antialiasing = false;
				CamIdle.alpha = 0;
				addElement(CamIdle);
				
			case 'trapped-png':

				var bg = new FlxSprite().loadGraphic(bgPath('fnaf3'));
				bg.scale.set(3,3);
				bg.updateHitbox();
				addElement(bg);
				GameOverSubstate.characterName = 'brooketrapped';

			case 'watchful': //bed //clock // couch // office // --END light //

				wCouch = new FlxSprite().loadGraphic(bgPath('couch'));
				addElement(wCouch);
				wClock = new FlxSprite().loadGraphic(bgPath('clock'));
				addElement(wClock);
				wOffice = new FlxSprite(10).loadGraphic(bgPath('office'));
				addElement(wOffice);
				wBed = new FlxSprite().loadGraphic(bgPath('bed'));
				addElement(wBed);
				wLight = new FlxSprite().loadGraphic(bgPath('light'));
				addElement(wLight);

				wRCouch = new FlxSprite(299,210).loadGraphic(bgPath('retro/couch'));
				addElement(wRCouch);
				wRClock = new FlxSprite(299+4,211).loadGraphic(bgPath('retro/clock'));
				addElement(wRClock);
				wRBed = new FlxSprite(299,210).loadGraphic(bgPath('retro/bed'));
				addElement(wRBed);
				wRLight = new FlxSprite(299+6,210).loadGraphic(bgPath('retro/light'));
				addElement(wRLight);

				fearhitbox = new FlxSprite().makeGraphic(140,130);
				fearhitbox.setPosition(wOffice.x + 444,wOffice.y + 116);

				wRBed.visible = false;
				wRCouch.visible = false;
				wRClock.visible = false;
				wRLight.visible = false;

				wRlines = new FlxSprite().loadGraphic(bgPath('retro/scanline'));
				addElement(wRlines,true);
				wRlines.visible = false;
				wRlines.cameras = [game.camOther];
				wRlines.setGraphicSize(FlxG.width);
				wRlines.updateHitbox();
			case 'beatbox':
				var bg = new FlxSprite().loadGraphic(bgPath('bg'));
				addElement(bg);

			case 'faznews':
				var bg = new FlxSprite().loadGraphic(bgPath('bg'));
				addElement(bg);

				var b = new FlxSprite().makeGraphic(FlxG.width,100,FlxColor.BLACK);
				hudElement.push(b);
				addElement(b);

				var b = new FlxSprite(0,FlxG.height - 100).makeGraphic(FlxG.width,100,FlxColor.BLACK);
				hudElement.push(b);
				addElement(b);

			case 'followed':
				game.skipCountdown = true;
				game.camHUD.alpha = 0;

				if (ClientPrefs.shaders) {
					bloomShader = new BloomShader();
					glitchShader = new GlitchShaderA();
					glitchShader2 = new FollowedGlitch();
					glitchShader3 = new Glitch2();
					glitchShader3.glitchy = 0;
					followedGlitchShader3 = new GlitchShader2();
					followedIntenseChromaticAbb = new CabinetGlitchChrom();
					followedIntenseChromaticAbb.amount = 0;
					followedIntenseChromaticAbb.speed = 0;

					updateiTimeHARD.push(followedIntenseChromaticAbb);
					updateiTimeHARD.push(glitchShader);	
					updateiTimeHARD.push(followedGlitchShader3);
					updateiTimeHARD.push(glitchShader3);
					followedGlitchShader3.amount = 0.0;
					glitchShader.glitchEffect = 0.00001;
					bloomShader.glowAmount = 0.0001;



					// chromaticShaderCash = new ChromaticAbb();
					// chromaticShaderCash.strength = 0;
					//game.addShader(chromaticShaderCash);
				}


				followedGradient = flixel.util.FlxGradient.createGradientFlxSprite(FlxG.width, Std.int(FlxG.height/2-100), ([0xFFFFFFFF,FlxColor.BLACK]));
				addElement(followedGradient); 
				followedGradient.color = 0xFF4B1E5E;
				followedGradient.setPosition(-100,-50);
				followedGradient.visible = false;

				followedVignette = new FlxSprite().loadGraphic(bgPath('vignette',false,'ourplesecrets'));
				followedVignette.scale.set(0.5,0.5);
				followedVignette.updateHitbox();
				followedVignette.screenCenter();
				followedVignette.scrollFactor.set();
				addElement(followedVignette);
				followedVignette.alpha = 0;

				followedEyes = new FlxSprite();
				followedEyes.frames = bgPath('idle',true,'ourplesecrets');
				followedEyes.animation.addByPrefix('s','idle eyes',12);
				followedEyes.animation.play('s');
				followedEyes.shader = glitchShader;
				addElement(followedEyes);
				followedEyes.alpha = 0;

				followedGoGoGo = new FlxSprite(-15,-100);
				followedGoGoGo.frames = bgPath('gogogobg',true,'ourplesecrets');
				//followedGoGoGo.animation.addByPrefix('s','i',4);
				followedGoGoGo.animation.addByIndices('s1','i',[0],'');
				followedGoGoGo.animation.addByIndices('s2','i',[6],'');
				followedGoGoGo.animation.addByIndices('notgo1','i',[1],'');
				followedGoGoGo.animation.addByIndices('notgo2','i',[3],'');
				followedGoGoGo.animation.play('s');
				addElement(followedGoGoGo);
				followedGoGoGo.visible = false; 

				//todo 
				//ending set bpz to 2111111
				//manually do zooms

	

				var pupoffset:Array<Float> = [1,-15];
				
				followedHands = new FlxSprite(60 + pupoffset[0],-300 + pupoffset[1]);
				followedHands.frames = bgPath('hands',true,'ourplesecrets');
				followedHands.animation.addByPrefix('i','idle',8);
				followedHands.animation.play('i');
				addElement(followedHands);
				followedHands.alpha = 0;

				followedChandel = new FlxSprite(60 + pupoffset[0],-300 + pupoffset[1]);
				followedChandel.frames = bgPath('chandelier',true,'ourplesecrets');
				followedChandel.animation.addByPrefix('i','i',8);
				followedChandel.animation.play('i');
				addElement(followedChandel);
				followedChandel.alpha = 0;

				followedPuppets = new FlxSpriteGroup();
				followedPuppets.alpha = 0;
				addElement(followedPuppets);

				followedPuppets2 = new FlxSpriteGroup();
				addElement(followedPuppets2);
	

				var followedPuppetnames:Array<String> = ['chica','bonnie','freddy','foxy'];
				var positions:Array<Array<Float>> = [[215,-80],[491,-80],[550,-30],[155,-20]];

				for (i in 0...followedPuppetnames.length) {
					var puppet = new FlxSprite(60 + pupoffset[0],-300+5 + pupoffset[1]);
					puppet.frames = bgPath('puppets/${followedPuppetnames[i]}',true,'ourplesecrets');
					puppet.animation.addByPrefix('i','idle',24);
					puppet.animation.addByPrefix('s','fall',24,false);	
					puppet.animation.play('i');
					followedPuppets.add(puppet);

					var puppet = new FlxSprite(positions[i][0] + pupoffset[0],positions[i][1] + pupoffset[1]);
					puppet.frames = bgPath('puppets/${followedPuppetnames[i]}2',true,'ourplesecrets');
					puppet.animation.addByPrefix('i','i',8);
					puppet.animation.play('i');
					followedPuppets2.add(puppet);
					puppet.alpha = 0;
				}

				followedSinnohbg = new FlxSprite().loadGraphic(bgPath('sinnoh2',false,'ourplesecrets'));
				addElement(followedSinnohbg);
				followedSinnohbg.visible = false;

				followedSinnohbg2 = new FlxSprite().loadGraphic(bgPath('sinnoh2u',false,'ourplesecrets'));
				addElement(followedSinnohbg2);
				followedSinnohbg2.visible = false;

				followedSinnohbg3 = new FlxSprite();
				followedSinnohbg3.frames = bgPath('finalbg2',true,'ourplesecrets');
				followedSinnohbg3.animation.addByPrefix('i','i',12);
				followedSinnohbg3.animation.play('i');
				followedSinnohbg3.visible = false;
				addElement(followedSinnohbg3);

				followedfinalbg = new FlxSprite(-300,-100);
				followedfinalbg.frames = bgPath('distortedbg',true,'ourplesecrets');
				followedfinalbg.animation.addByPrefix('i','i',12);
				followedfinalbg.animation.play('i');
				followedfinalbg.scale.set(3,3);
				followedfinalbg.updateHitbox();
				addElement(followedfinalbg);
				followedfinalbg.visible = false;

				followedEnding = new FlxSprite(-2150,-1700).loadGraphic(bgPath('arcade',false,'ourplesecrets'));
				followedEnding.scale.set(6,6);
				followedEnding.updateHitbox();
				followedEnding.scrollFactor.set();
				addElement(followedEnding,true);
				
				followedEnding.alpha = 0;

				followedStatic = new FlxSprite();
				followedStatic.frames = bgPath('sttat',true,'ourplesecrets');
				followedStatic.animation.addByPrefix('s','sttat i');
				followedStatic.animation.play('s');
				followedStatic.setGraphicSize(FlxG.width,FlxG.height);
				followedStatic.updateHitbox();
				followedStatic.cameras = [game.camOther];
				addElement(followedStatic);
				followedStatic.alpha = 0;
				//followedStatic.color = FlxColor.WHITE;

				followedScene1 = new FlxSprite();
				followedScene1.frames = Paths.getSparrowAtlas('bgs/followed/cutscenes/followed2','ourplesecrets');
				followedScene1.animation.addByPrefix('s','im kms',12,false);
				followedScene1.setGraphicSize(0,720);
				followedScene1.updateHitbox();
				followedScene1.cameras = [game.camVideo];
				addElement(followedScene1);
				followedScene1.visible = false;

				followedScene1.animation.finishCallback = function (name:String) {
					//followedScene1.destroy();
				}

				followedScene2 = new FlxSprite().loadGraphic(bgPath('cutscenes/cutscene2',false,'ourplesecrets'),true,723,405);
				followedScene2.animation.add('idle',CoolUtil.numberArray(49),5,false); //49
				followedScene2.setGraphicSize(0,720);
				followedScene2.updateHitbox();
				followedScene2.cameras = [game.camVideo];
				addElement(followedScene2);
				followedScene2.visible = false;

				followedScene2.animation.finishCallback = function (name:String) {
					//followedScene2.destroy();
				}

				followedfinalPurple = new FlxSprite().makeGraphic(FlxG.width,FlxG.height,0xFFB71DC0);
				followedfinalPurple.cameras = [game.camVideo];
				followedfinalPurple.visible = false;
				addElement(followedfinalPurple);

				followedfinalFlashes = new FlxSprite();
				followedfinalFlashes.frames = bgPath('flashingend',true,'ourplesecrets');
				var flashesFPS = ClientPrefs.flashing ? 1 : 2;
				followedfinalFlashes.animation.addByPrefix('1','1');
				followedfinalFlashes.animation.addByPrefix('2','2',Std.int(16/flashesFPS),false);
				followedfinalFlashes.animation.addByPrefix('3','3',Std.int(16/flashesFPS));
				followedfinalFlashes.animation.addByPrefix('4','4',Std.int(13/flashesFPS),false);
				followedfinalFlashes.cameras = [game.camVideo];
				followedfinalFlashes.setGraphicSize(FlxG.width,FlxG.height);
				followedfinalFlashes.updateHitbox();
				followedfinalFlashes.visible = false;
				addElement(followedfinalFlashes);

				var explain = new FlxSprite().loadGraphic(bgPath('wanring',false,'ourplesecrets'));
				explain.screenCenter();
				explain.cameras = [game.camOther];
				addElement(explain,true);
				explain.alpha = 0;
				game.eventTweens.tween(explain, {alpha: 1},2, { onComplete: function (f:FlxTween) {
					game.eventTweens.tween(explain, {alpha: 0},2, {startDelay: 3, onComplete: function (f:FlxTween) {
						explain.destroy();
					}});
				}});






			

			case 'cashmoney':
				if (ClientPrefs.shaders) {
					chromaticShaderCash = new ChromaticAbb();
					chromaticShaderCash.strength = 0;
					game.addShader(chromaticShaderCash);
					glitchShader2 = new FollowedGlitch();
					glitchShader2.squareAmount = 0.0;
					updateiTimeHARD.push(glitchShader2);

				}


				var bg = new FlxSprite().loadGraphic(bgPath('bg'));
				addElement(bg);

				var bg = new FlxSprite().loadGraphic(bgPath('bg1'));
				addElement(bg);

				var moneyvignette = new FlxSprite().loadGraphic(bgPath('gradient_but_moneybags'));
				addElement(moneyvignette,true);	

			case 'fear':
				var bg = new FlxSprite(-50).loadGraphic(bgPath('bg'));
				bg.scale.set(1.5,1.5);
				bg.updateHitbox();
				addElement(bg);

			case 'trapped':
				if (ClientPrefs.shaders) {
					trappedShader = new TrappedShader();
					updateiTimeHARD.push(trappedShader);
					game.addShader(trappedShader);

					// trappedShader.waveSpeed = 0.002;
					// trappedShader.waveintensity = 6;
					// trappedShader.glowAmount = 0.4;

					trappedShader.waveSpeed = 0.;
					trappedShader.waveintensity = 0;
					trappedShader.glowAmount = 0;
				}

				game.skipCountdown = true;
				game.usingAltBF = 'brooketrapped2';
				GameOverSubstate.characterName = 'brooketrappednew';

				var stage = new FlxSprite().loadGraphic(bgPath('window'));
				addElement(stage);

				trappedFireBG = new FlxSprite(0,-250).loadGraphic(bgPath('fire'),true,630,354);
				trappedFireBG.animation.add('bg',[0,1,2,3,4,5,6,7,8],13);
				trappedFireBG.animation.play('bg');
				trappedFireBG.setGraphicSize(Std.int(FlxG.width * 1.5));
				trappedFireBG.updateHitbox();
				trappedFireBG.flipX = true;
				trappedFireBG.scrollFactor.set(0.9,0.9);
				trappedFireBG.blend = ADD;
				addElement(trappedFireBG);
				trappedFireBG.antialiasing = ClientPrefs.globalAntialiasing;

				var stage = new FlxSprite().loadGraphic(bgPath('newbg'));
				addElement(stage);

				trappedBG2 = new FlxSprite().loadGraphic(bgPath('stage2'));
				addElement(trappedBG2);

				trappedOurple = new FlxSprite(800,550);
				trappedOurple.frames = bgPath('phantomourple',true);
				trappedOurple.animation.addByPrefix('i','i',8);
				trappedOurple.animation.play('i');
				trappedOurple.scale.set(.8,0.8);
				trappedOurple.alpha = 0.6;
				trappedOurple.updateHitbox();
				traphallucinations.push(trappedOurple);
				addElement(trappedOurple);	

				trappedAbome = new FlxSprite(-100,300);
				trappedAbome.frames = bgPath('abome',true);
				trappedAbome.animation.addByPrefix('i','i',8);
				trappedAbome.animation.play('i');
				trappedAbome.scale.set(.35,0.35);
				trappedAbome.alpha = 0.6;
				trappedAbome.updateHitbox();
				traphallucinations.push(trappedAbome);
				addElement(trappedAbome);

				trappedBonnie = new FlxSprite(1300,250);
				trappedBonnie.frames = bgPath('bonnie',true);
				trappedBonnie.animation.addByPrefix('i','i',8);
				trappedBonnie.animation.play('i');
				trappedBonnie.scale.set(.35,0.35);
				trappedBonnie.alpha = 0.6;
				trappedBonnie.updateHitbox();
				traphallucinations.push(trappedBonnie);
				addElement(trappedBonnie);

				for (i in traphallucinations) i.alpha = 0;

				trappedFG2 = new FlxSprite().loadGraphic(bgPath('stage2fg'));
				addElement(trappedFG2,true);	
				trappedFG2.scrollFactor.set(1.2,1.2);

				trappedGradient = new FlxSprite().loadGraphic(bgPath('gradient'));
				addElement(trappedGradient,true);
				
				trappedWires = new FlxSprite().loadGraphic(bgPath('wires'));
				trappedWires.scrollFactor.set(1.3,1.3);
				addElement(trappedWires,true);

				trappedBG2.alpha = 0;
				trappedFG2.alpha = 0;

				trappedBlack = new FlxSprite().makeGraphic(1280,720,FlxColor.BLACK);
				trappedBlack.cameras = [game.camOther];
				addElement(trappedBlack,true);

				trappedBlend = new FlxSprite().loadGraphic(bgPath('fireblend'));
				trappedBlend.setGraphicSize(FlxG.width+480,FlxG.height+360);
				trappedBlend.updateHitbox();
				trappedBlend.screenCenter(); //wtf cinema.lua why do you zoom out the camera
				trappedBlend.scrollFactor.set();
				hudElement.push(trappedBlend);
				trappedBlend.blend = ADD;
				addElement(trappedBlend);
				trappedBlend.antialiasing = ClientPrefs.globalAntialiasing;	

				trappedFire = new FlxSprite(0,-50).loadGraphic(bgPath('fire'),true,630,354);
				trappedFire.animation.add('bg',[0,1,2,3,4,5,6,7,8],12);
				trappedFire.animation.play('bg');
				trappedFire.setGraphicSize(Std.int(FlxG.width * 2));
				trappedFire.updateHitbox();
				trappedFire.scrollFactor.set(1.1,1.1);
				trappedFire.blend = ADD;
				addElement(trappedFire,true);
				trappedFire.antialiasing = ClientPrefs.globalAntialiasing;	
				
				trappedFire.alpha = 0;
				trappedFireBG.alpha = 0;			
				trappedBlend.alpha = 0;	

			case 'restless':
				//game.skipCountdown=true;
				game.isCameraOnForcedBoyfriend=true;

				cryingfnaf4 = new FlxSprite(25,100);
				cryingfnaf4.frames = bgPath('fnaf4',true);
				cryingfnaf4.animation.addByPrefix('i','i',8);
				cryingfnaf4.animation.play('i');
				addElement(cryingfnaf4);

				cryingbed = new FlxSprite(20,100);
				cryingbed.frames = bgPath('bedroom',true);
				cryingbed.animation.addByPrefix('i','i',8);
				cryingbed.animation.play('i');
				addElement(cryingbed);

				cryinglive = new FlxSprite(25,90);
				cryinglive.frames = bgPath('livingroom',true);
				cryinglive.animation.addByPrefix('i','i',8);
				cryinglive.animation.play('i');
				addElement(cryinglive);

				cryinglive.alpha = 0;
				cryingbed.alpha = 0;
				cryingfnaf4.alpha = 0;

				
		}
	}

	public function createPost()
	{
		this.dad = PlayState.instance.dad;
		this.bf = PlayState.instance.boyfriend;

		// var lol = new FollowedGlitch();
		// lol.glowAmount = 0.1;//maybe for when terrminated fire zoom out 0.1 
		// game.addShader(lol); 

		// var lol = new Glitch2();
		// //lol.glowAmount = 0.1;//maybe for when terrminated fire zoom out 0.1 
		// lol.GLITCH.value[0] = 0.1;
		// updateiTimeHARD.push(lol);
		// game.addShader(lol);
		switch (curStage) {
			case 'bite-png':
				dad.visible = false;
			case 'yes-friend':
				dad.visible = false;
				game.stars.visible = false;
				game.iconP1.visible = false;
				game.iconP2.visible = false;
				game.hudAssets.visible = false;
				game.setNotePosition('middle');
				game.camZooming = true;
				game.camZoomMult = 4;
				game.camZoomingMult = 12;		

			case 'watchful':
				game.snapCamToCharacter('dad');
				bf.visible = false;
			case 'beatbox':
				game.snapCamToCharacter('dad');
				game.isCameraOnForcedPos = true;
				game.setNotePosition('middle');
			case 'bon':
				lurkingcutIntro = new FlxSprite();
				lurkingcutIntro.frames = Paths.getSparrowAtlas('bgs/lurking/shadowbontransition');
				lurkingcutIntro.animation.addByPrefix('s','shadowbontransition idle',8,false);
				lurkingcutIntro.setGraphicSize(1280,720);
				lurkingcutIntro.updateHitbox();
				lurkingcutIntro.cameras = [PlayState.instance.camVideo];
				add(lurkingcutIntro);
				lurkingcutIntro.visible = false;
				game.preloadvideo('lurking');
				//dad.cameras = [game.camGameClone];

			case 'faznews':
				ogCharYs = [bf.y,dad.y];
				game.snapCamToCharacter('dad');
				game.setNotePosition('swap');
				game.camOffset = 15;
			case 'followed':
				game.snapCamToCharacter('dad');
				dad.visible = false;
				//game.isCameraOnForcedDad = true;
				bf.visible = false;
				game.hudAssets.visible = false;
				game.iconP1.visible = false;
				game.iconP2.visible = false;
				dad.shader = glitchShader;
				
				for (i in game.opponentStrums) i.x = -1000;
				game.healthGain = 0; //possible temp
				game.healthLoss = 0;

				var b = new FlxSprite().makeGraphic(1280,720,FlxColor.BLACK);
				b.cameras = [game.camOther];
				addElement(b);
				game.eventTweens.tween(b, {alpha: 0},3, {startDelay: 5, onComplete: function (t:FlxTween) {
					remove(b);
					b.destroy();
				}});
				game.isCameraOnForcedBoyfriend=true;

				game.snapCamToCharacter();


			case 'stage0':
				game.setNotePosition('swap');
			case 'fear':
				game.camOffset = 25;
				game.hudAssets.visible = false;
				game.iconP1.visible = false;
				game.iconP2.visible = false;
			case 'omc':
				omcWhite = new FlxSprite().makeGraphic(FlxG.width,FlxG.height);
				game.addBehindDad(omcWhite);
				omcWhite.alpha = 0;
				
				bf.color = FlxColor.WHITE;
				dad.color = FlxColor.WHITE;
				
				chromaticShaderCash = new ChromaticAbb();
				chromaticShaderCash.strength = 0;
				game.addShader(chromaticShaderCash);
				crtShader = new CRTshader();
				crtShader.warpStrength = 1;
				game.addShader(crtShader);
				game.addShader(crtShader,'sad');

				game.defaultHudZoom = 0.9;

				var scan = new FlxSprite();
				scan.frames = Paths.getSparrowAtlas('stage/gofish/scan');
				scan.animation.addByPrefix('Symbol 1','Symbol 1',12);
				scan.animation.play('Symbol 1');
				scan.cameras = [game.camOther];
				addElement(scan);
			case 'trapped':
				game.snapCamToCharacter();
				game.altBoyfriend.visible = false;
				game.hudAssets.alpha = 0;
				game.iconP1.alpha = 0;
				game.iconP2.alpha = 0;
				game.stars.alpha = 0;
				game.timeBar.visible = false;
				game.timeTxt.visible = false;
				game.timeBarBG.visible = false;
			case 'restless':
				game.camZooming = true;
				dad.visible = false;
				game.iconP2.visible = false;
				for (i in game.opponentStrums) i.x = -1000;
				game.snapCamToCharacter();
				game.hudAssets.members[2].visible = false;

				game.hudAssets.members[4].visible = false;
				game.hudAssets.members[5].visible = false;
				game.hudAssets.members[6].visible = false;
				game.hudAssets.members[3].scale.set(1.25,1.25);
				game.hudAssets.members[3].updateHitbox();			

				game.hudAssets.members[3].screenCenter(X);
				game.iconPositionLocked = true;
				game.iconP1.screenCenter(X);
				game.iconP1.setPosition(game.iconP1.x+15,game.iconP1.y+10);
				game.stars.forEach(function (i:FlxSprite) {
					i.visible = false;
					i.y = ClientPrefs.downScroll ? i.y + 75 : i.y - 75;
				});
					
							


		}


		for (i in updateiTime) i.setFloat('iTime', 0.005); //need this so no null ref //data todo? move updateitime into playstate?
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		var trueElapsed:Float = (elapsed / (1 / 60));
		for (i in updateiTime) i.setFloat('iTime', i.getFloat('iTime') + elapsed);
		for (i in updateiTimeHARD) i.update(elapsed);


		switch (curStage) {
			case 'watchful':
				if (FlxG.mouse.visible && FlxG.mouse.justPressed && FlxG.mouse.overlaps(fearhitbox)) {
					trace('yes!');
					FlxG.mouse.visible = false;
					game.vocals.stop();
					FlxG.sound.music.stop();
					game.vocals.volume = 0;
					FlxG.sound.music.volume = 0;
					game.camGame.visible = false;
					game.camHUD.visible = false;
					game.camOther.visible = false;		

					WeekData.reloadWeekFiles(false);
					CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();	
					PlayState.storyPlaylist = ['fear'];
					PlayState.isStoryMode = false;
				
					var diffic = CoolUtil.getDifficultyFilePath(2);

					PlayState.storyDifficulty = 2;
				
					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
					PlayState.campaignScore = 0;
					PlayState.campaignMisses = 0;
					new FlxTimer().start(.1, function(tmr:FlxTimer)
					{
						MusicBeatState.resetState();
						FreeplayState.destroyFreeplayVocals();
					});


				}
			case 'restless':
				game.iconP1.alpha = FlxMath.lerp(game.iconP1.alpha, game.health/2+0.1,CoolUtil.boundTo(elapsed * 24, 0, 1));
		}

	}

	var cashchromaticTween:FlxTween;
	public function beatHit(curBeat:Int)
	{
		this.curBeat = curBeat;

		switch (curStage)
		{
			case 'faznews':
				if (dad.animation.curAnim.name == 'idle') {
					dad.y = ogCharYs[1] + 20;
					faznewsTweens[0] = game.eventTweens.tween(dad, {y: ogCharYs[1]},0.2, {ease: FlxEase.cubeOut});
				}
				if (bf.animation.curAnim.name == 'idle') {
					bf.y = ogCharYs[0] + 20;
					faznewsTweens[1] = game.eventTweens.tween(bf, {y: ogCharYs[0]},0.2, {ease: FlxEase.cubeOut});
				}
			case 'followed':
				if (followedGoGoGo.visible) {
					if (curBeat % 2 == 0) {
						if (FlxG.random.bool(50)) 
							followedGoGoGo.animation.play('notgo1');
						else 
							followedGoGoGo.animation.play('notgo2');
					}
					else {
						if (FlxG.random.bool(50)) 
							followedGoGoGo.animation.play('s1');
						else 
							followedGoGoGo.animation.play('s2');
					}
				}
				if (curBeat % followedBeatsPerZoomShader == 0 && ClientPrefs.shaders) {
					if (game.dad.curCharacter != 'foxyfollow')
					followedGlitchShader3.amount = 0.05;
					if (followedTween != null) followedTween.cancel();
					followedTween = game.eventTweens.tween(followedGlitchShader3, {amount: game.dad.curCharacter == 'foxyfollow' ? 0.002 : 0.004},0.5, {ease: FlxEase.backOut});
				}
			case 'bite-png':
				if (curBeat == 64) {
					dad.visible = true;
				}
				if (curBeat == 319) {
					CamPop.alpha = 1;
					CamPop.animation.play('pop');
					game.iconP2.changeIcon('bchica');
				}
				if (curBeat == 320) {
					CamPop.alpha = 0;
					CamIdle.alpha = 1;
					CamIdle.animation.play('idle');
				}
				if (curBeat == 382) {
					CamIdle.alpha = 0;	
					CamPop.alpha = 1;
				}
				if (curBeat == 383) {
					CamPop.animation.play('unpop');
				}
				if (curBeat == 384) {
					CamPop.alpha = 0;
				}


		}
	}

	public function stepHit(curStep:Int)
	{
		this.curStep = curStep;

		switch (curStage)
		{
			case 'trapped':
				for (i in traphallucinations) {
					if (i.alpha != 0) i.alpha = FlxG.random.float(0.1,0.5);
				}
				if (trappedGlitchy == 2) {
					dad.alpha = FlxG.random.float(0.3,1);
					trappedBG2.alpha = FlxG.random.float(0,0.1);
					trappedFG2.alpha = FlxG.random.float(0,0.1);
				}
				if (trappedGlitchy == 1) {
					trappedBG2.alpha = FlxG.random.float(0.9,1);
					trappedFG2.alpha = FlxG.random.float(0.9,1);
					trappedWires.alpha = FlxG.random.float(0,0.07);
				}


		}
	}
	var slopcounter:Int = 0;
	
	public function sectionHit(curSec:Int)
	{
		this.curSection = curSec;
		switch (curStage) {
			case 'color':
				if (slopping)
				{
					var index:Int = slopcounter;
					var time:Float = 1.5;
					var flip:Bool = FlxG.random.bool(50);
					switch (slopcounter)
					{
						case 0:
							index = 1;
							time = 1.4;
						case 1:
							index = 3;
							time = 1.2;
						case 2: 
							index = 2;
							time = 0.9;
						case 3:
							index = 0;
							time = 1.15;
					}
					if (flip)
					{
						slops.members[index].flipX = true;
						slops.members[index].x += 1000;
					}
					else{
						slops.members[index].flipX = false;
					}
					slops.members[index].scale.x = FlxG.random.float(0.75, 1.35);
					slops.members[index].scale.y = FlxG.random.float(0.75, 1.35);
					slops.members[index].animation.play('yell', true);
					slops.members[index].visible = true;
					if (flip)
					{
						FlxTween.tween(slops.members[index], {x: slops.members[index].x - 1200}, time, {ease: FlxEase.linear, onComplete: function (t:FlxTween) {
							slops.members[index].visible = false;
							slops.members[index].x += 200;
							}
						});
					}else{
						FlxTween.tween(slops.members[index], {x: slops.members[index].x + 1200}, time, {ease: FlxEase.linear, onComplete: function (t:FlxTween) {
							slops.members[index].visible = false;
							slops.members[index].x -= 1200;
							}
						});
					}
					slopcounter += 1;
					if (slopcounter > 3)
					{
						slopcounter = 0;
					}
				}
		}

	}


	public function opponenetNoteHit()
	{
		switch (curStage) {

				
			case 'faznews':
				//infry
				if (faznewsTweens[0] != null) faznewsTweens[0].cancel();
				dad.y = ogCharYs[1];
				faznewsTweens[0] = game.eventTweens.tween(dad, {y: ogCharYs[1]-20},0.2, {ease: FlxEase.cubeOut});
		}
	}

	public function playerNoteHit()
	{
		switch (curStage) {
			case 'faznews':
				if (faznewsTweens[1] != null) faznewsTweens[1].cancel();
				bf.y = ogCharYs[0];
				faznewsTweens[1] = game.eventTweens.tween(bf, {y: ogCharYs[0]-20},0.2, {ease: FlxEase.cubeOut});
		}
	}

	public function onCountdownTick() {
		switch (curStage) {
			case 'faznews':
				dad.y = ogCharYs[1] + 20;
				faznewsTweens[0] = game.eventTweens.tween(dad, {y: ogCharYs[1]},0.2, {ease: FlxEase.cubeOut});
				bf.y = ogCharYs[0] + 20;
				faznewsTweens[1] = game.eventTweens.tween(bf, {y: ogCharYs[0]},0.2, {ease: FlxEase.cubeOut});
				
		}
	}


	public function bgSwap(b:Int) //was gonna make another stage event class but this time nah //actually maybe it depends tbh
	{
		switch (curStage) {
			case 'restless':
				switch (b) {
					case 0:
						game.triggerEventNote('tweenZoom','2,2,sdf','backinout');
						game.eventTweens.tween(cryingbed, {alpha: 1},2, {ease: FlxEase.sineInOut});
						game.eventTweens.tween(cryingfnaf4, {alpha: 0},2, {ease: FlxEase.sineInOut});
						game.eventTweens.tween(cryinglive, {alpha: 0},2, {ease: FlxEase.sineInOut});
					case 1:
						game.triggerEventNote('tweenZoom','2,2,sdf','backinout');
						game.eventTweens.tween(cryingbed, {alpha: 0},2, {ease: FlxEase.sineInOut});
						game.eventTweens.tween(cryingfnaf4, {alpha: 1},2, {ease: FlxEase.sineInOut});
						game.eventTweens.tween(cryinglive, {alpha: 0},2, {ease: FlxEase.sineInOut});
					case 2:
						game.triggerEventNote('tweenZoom','2,2,sdf','backinout');
						game.eventTweens.tween(cryingbed, {alpha: 0},2, {ease: FlxEase.sineInOut});
						game.eventTweens.tween(cryingfnaf4, {alpha: 0},2, {ease: FlxEase.sineInOut});
						game.eventTweens.tween(cryinglive, {alpha: 1},2, {ease: FlxEase.sineInOut});
					case 3:
						game.eventTweens.tween(cryingbed, {alpha: 0},2, {ease: FlxEase.sineInOut});
						game.eventTweens.tween(cryingfnaf4, {alpha: 0},2, {ease: FlxEase.sineInOut});
						game.eventTweens.tween(cryinglive, {alpha: 0},2, {ease: FlxEase.sineInOut});
					case 4:
						game.triggerEventNote('tweenZoom','4,2,sdf','sineinout');
						game.eventTweens.tween(cryingbed, {alpha: 0},1, {ease: FlxEase.sineInOut});
						game.eventTweens.tween(cryingfnaf4, {alpha: 0},1, {ease: FlxEase.sineInOut});
						game.eventTweens.tween(cryinglive, {alpha: 0},1, {ease: FlxEase.sineInOut});

						game.eventTweens.tween(game.camHUD, {alpha: 0},2, {ease: FlxEase.sineInOut});	
						game.eventTweens.tween(game.camGame, {alpha: 0},2, {ease: FlxEase.sineInOut});		
				}
			case 'trapped':
				switch (b) {
					case 0: //percs
						trappedFG2.alpha = 0;
						trappedBG2.alpha = 0;
						trappedGradient.alpha = 1;
						trappedWires.alpha = 1;
						dad.visible = true;
						flxTrailDad.visible = true;
						salvageGhost.visible = false;
						bf.visible = true;
						game.altBoyfriend.visible = false;
						trappedGlitchy = 3;
						trappedBlend.alpha = 0;
						trappedFire.alpha = 0;
						trappedFireBG.alpha = 0;
					case 1: //reality
						trappedFG2.alpha = 1;
						trappedBG2.alpha = 1;
						trappedGradient.alpha = 0;
						trappedWires.alpha = 0;
						dad.visible = false;
						flxTrailDad.visible = false;
						salvageGhost.visible = true;
						bf.visible=false;
						game.altBoyfriend.visible = true;
						trappedGlitchy = 1;
						trappedBlend.alpha = 0;
						trappedFire.alpha = 0;
						trappedFireBG.alpha = 0;
					case 2: //flicker
						trappedGlitchy = 2;
					case 3: //percs wore off
						trappedGlitchy = 3;
						dad.visible = true;
						flxTrailDad.visible = true;
						salvageGhost.visible = true;
						game.eventTweens.tween(flxTrailDad, {alpha:0}, 5, {ease: FlxEase.sineInOut});
						game.eventTweens.tween(dad, {alpha:0}, 5, {ease: FlxEase.sineInOut});
						game.altBoyfriend.visible = true;
						game.altBoyfriend.alpha = 0;
						game.eventTweens.tween(trappedGradient, {alpha:0}, 10, {ease: FlxEase.sineInOut});
						game.eventTweens.tween(trappedWires, {alpha:0}, 10, {ease: FlxEase.sineInOut});
						game.eventTweens.tween(trappedBG2, {alpha:1}, 10, {ease: FlxEase.sineInOut});
						game.eventTweens.tween(trappedFG2, {alpha:1}, 10, {ease: FlxEase.sineInOut});

						game.eventTweens.tween(trappedFire, {alpha:0}, 8, {ease: FlxEase.sineInOut});
						game.eventTweens.tween(trappedFireBG, {alpha:0}, 3, {ease: FlxEase.sineInOut});
						game.eventTweens.tween(trappedBlend, {alpha:0}, 8, {ease: FlxEase.sineInOut});

						game.eventTweens.tween(bf, {alpha:0}, 10, {ease: FlxEase.sineInOut});
						game.eventTweens.tween(game.altBoyfriend, {alpha:1}, 10, {ease: FlxEase.sineInOut});
						game.eventTweens.tween(salvageGhost, {alpha: 0},10, {ease: FlxEase.sineOut});
					case 5: //fire
						trappedFG2.alpha = 0;
						trappedBG2.alpha = 0;
						trappedGradient.alpha = 1;
						trappedWires.alpha = 1;
						dad.visible = true;
						flxTrailDad.visible = true;
						salvageGhost.visible = false;
						bf.visible = true;
						game.altBoyfriend.visible = false;
						trappedGlitchy = 3;

						trappedBlend.alpha = 1;
						trappedFire.alpha = 1;
						trappedFireBG.alpha = 1;
					case 6: //ending
						game.isCameraOnForcedPos = true;
						game.eventTweens.tween(game.camFollow, {x: trappedBG2.getGraphicMidpoint().x},1);

				}

				
				
			case 'watchful':
				FlxG.mouse.visible = false;
				wBed.visible = false;
				wCouch.visible = false;
				wClock.visible = false;
				wLight.visible = false;
				wOffice.visible = false;
				wRBed.visible = false;
				wRCouch.visible = false;
				wRClock.visible = false;
				wRLight.visible = false;
				wRlines.visible = false;


				if (!dad.curCharacter.contains('retro')) {
					game.iconP1.changeIcon('icon-ourplebf');
					var showTime:Bool = (ClientPrefs.timeBarType != 'Disabled');
					game.scoreTxt.visible = !ClientPrefs.hideHud;
					game.timeBar.visible = showTime;
					game.timeBarBG.visible = showTime;
					game.timeTxt.visible = showTime;

					game.isCameraOnForcedPos = false;
					game.camGame.zoom = 2.5;
					game.defaultCamZoom = 1.9;
					PlayState.isPixelStage = false;
				}
				else {
					game.iconP1.changeIcon('pixelbf');
					game.scoreTxt.visible = false;
					game.timeBar.visible = false;
					game.timeBarBG.visible = false;
					game.timeTxt.visible = false;
					PlayState.isPixelStage = true;
					game.isCameraOnForcedPos = true;
					game.snapCamToCharacter('dad');
					game.camGame.zoom = 14;
					game.defaultCamZoom = 14;
					wRlines.visible = true;
					var mosaic = new MosiacShader();
					game.addShader(mosaic);
					mosaic.pixelSize = 40;
					FlxTween.tween(mosaic, {pixelSize: 1}, 1.5, {ease: FlxEase.circOut, onComplete: function (t:FlxTween) {
						game.removeShader(mosaic);
						mosaic = null;
					}});
				}
				var cola = FlxColor.WHITE;
				if (!ClientPrefs.flashing) cola.alphaFloat = 0.5;
				game.camGame.flash(cola,0.25,null,true);
				switch (b) 
				{
					case 0: //kinda gross tbh but whatever
						if (dad.curCharacter.contains('retro')) wRBed.visible = true;
						else wBed.visible = true;
					case 1:
						if (dad.curCharacter.contains('retro')) wRClock.visible = true;
						else wClock.visible = true;
					case 2:
						if (dad.curCharacter.contains('retro')) wRCouch.visible = true;
						else wCouch.visible = true;
					case 3:
						if (dad.curCharacter.contains('retro')) wRLight.visible = true;
						else wLight.visible = true;
					case 4:
						FlxG.mouse.visible = true;
						wOffice.visible = true;
					case 5:
						wLight.visible = true;
				}
		}
	}


	public function onEventTrigger(event:String,v1:String,v2:String) {
		switch (event) {
			case 'slop':
				slopping = !slopping;
				slopcounter = 0;
			case '':
				if (curStage == 'trapped') {
					if (ClientPrefs.shaders) {
						if (v1 == 'shader1') {
							trappedShader.waveSpeed = 0.002;
							trappedShader.waveintensity = 6;
							trappedShader.glowAmount = 0.4;

						}
						if (v1 == 'shader2') {
							 //trappedShader.waveSpeed = 0;
							// trappedShader.waveintensity = 0;
							 //trappedShader.glowAmount = 0;
							updateiTimeHARD.pop();
							game.eventTweens.tween(trappedShader, { glowAmount: 0, waveSpeed: 0},3);

						}
						
					}

				}
		}
	}

	//functions you dont need to really touch
	//-------------------------------------------------------------//


	public function luaCheck()
	{
		if (Lambda.count(PlayState.instance.modchartSprites) == 0)  //okay this is stupid? but i mean it probably will work like 90% of the time? or so idfk im not gonna risk moving lua elements into this class rn and breaking stuff
			buildStage();
		else {
			usingLua = true;
			trace('stage is a lua' + Lambda.count(PlayState.instance.modchartSprites));
		}

	}
	/**
	 * !! Use this to add the sprite !!
	 * @param object the FlxSprite
	 * @param inFrontOfCharacters whether the sprite will be in front of the characters
	 */
	public function addElement(object:FlxSprite, ?inFrontOfCharacters:Bool = false):Void
	{
		if (!inFrontOfCharacters) bgElement.add(object);
		else fgElement.add(object);
	}
	/**
	 * removes the sprite. ONLY WORKS ON PUBLIC VARS i think? idfk try it out if ya want
	 * @param object the FlxSprite
	 * @param destroy destroy the object?
	 */
	public function removeElement(object:String,?destroy=false):Void
	{
		if (object.startsWith('stage.')) object = object.replace('stage.','');
		var element = Reflect.getProperty(this,object);
		for (i in bgElement) if (i == element) bgElement.remove(i);
		for (i in fgElement) if (i == element) fgElement.remove(i);
		if (destroy) {
			element.kill();
			element.destroy();
		}
	}
	//infry
	/**
	 * returns the stage sprite being called. purpose is to dynamically grab stage sprites from other states
	 * @param object the FlxSprite you're getting
	 */
	public function getElement(object:String):FlxSprite {

		if (object.startsWith('stage.')) object = object.replace('stage.','');
		var element = Reflect.getProperty(this,object);

		return element;
	}

	function bgPath(image:String,?sparrow:Bool = false, library:String = 'shared'):Dynamic {
		if (sparrow) return Paths.getSparrowAtlas('bgs/$curStage/$image',library);
		else return Paths.image('bgs/$curStage/$image',library);
	}

	var flxTrailDad:FlxTrail;


	public function updateChars():Void { //fix for using the stage var of chars after a char change has occured
		//yknow this technically counts as a oncharacter change event

		this.dad = PlayState.instance.dad;
		this.bf = PlayState.instance.boyfriend;

		if (flxTrailDad != null) {
			flxTrailDad.visible = false;
			flxTrailDad.destroy();
		}
		if (salvageGhost != null)
		{
			salvageGhost.visible = false;
			salvageGhost.destroy();
		}

		switch (curStage) {
			case 'cashmoney':
				if (!ClientPrefs.shaders) return;
				dad.shader = glitchShader2;
			case 'trapped':

				flxTrailDad = new FlxTrail(dad,null,8,4,0.25);
				game.addBehindDad(flxTrailDad);

				salvageGhost = new FlxTrail(dad,null,8,2,0.3); //testing
				game.addBehindDad(salvageGhost);
				salvageGhost.visible = false;	



				
		}

	}


		
}

//shaders idk why i did em in the stage class
//-------------------------------------------------------------//

class TrappedShader extends FlxShader 
{

	@:isVar
	public var glowAmount(get, set):Float = 0.;

	function get_glowAmount()
	{
		return (bloom.value[0]);
	}
	function set_glowAmount(v:Float)
	{
		bloom.value = [v, v];
		return v;
	}

	@:isVar
	public var waveSpeed(get, set):Float = 0.;

	function get_waveSpeed()
	{
		return (this.speed.value[0]);
	}
	function set_waveSpeed(v:Float)
	{
		this.speed.value = [v, v];
		return v;
	}


	@:isVar
	public var waveintensity(get, set):Float = 0.;

	function get_waveintensity()
	{
		return (this.intensity.value[0]);
	}
	function set_waveintensity(v:Float)
	{
		this.intensity.value = [v, v];
		return v;
	}
	

	@:glFragmentSource('
	#pragma header

	vec2 fragCoord=openfl_TextureCoordv*openfl_TextureSize;
	
	uniform float iTime;
	
	uniform float speed;
	uniform float intensity;
	uniform float bloom;
	
	const float blurSize=1./512.;
	
	void main()
	{
		vec4 sum = vec4(0);
		vec2 texcoord=fragCoord.xy/openfl_TextureSize.xy;
		
		// blur in y (vertical)
		// take nine samples, with the distance blurSize between them
		sum+=flixel_texture2D(bitmap,vec2(texcoord.x-4.*blurSize,texcoord.y))*.05;
		sum+=flixel_texture2D(bitmap,vec2(texcoord.x-3.*blurSize,texcoord.y))*.09;
		sum+=flixel_texture2D(bitmap,vec2(texcoord.x-2.*blurSize,texcoord.y))*.12;
		sum+=flixel_texture2D(bitmap,vec2(texcoord.x-blurSize,texcoord.y))*.15;
		sum+=flixel_texture2D(bitmap,vec2(texcoord.x,texcoord.y))*.16;
		sum+=flixel_texture2D(bitmap,vec2(texcoord.x+blurSize,texcoord.y))*.15;
		sum+=flixel_texture2D(bitmap,vec2(texcoord.x+2.*blurSize,texcoord.y))*.12;
		sum+=flixel_texture2D(bitmap,vec2(texcoord.x+3.*blurSize,texcoord.y))*.09;
		sum+=flixel_texture2D(bitmap,vec2(texcoord.x+4.*blurSize,texcoord.y))*.05;
		
		// blur in y (vertical)
		// take nine samples, with the distance blurSize between them
		sum+=flixel_texture2D(bitmap,vec2(texcoord.x,texcoord.y-4.*blurSize))*.05;
		sum+=flixel_texture2D(bitmap,vec2(texcoord.x,texcoord.y-3.*blurSize))*.09;
		sum+=flixel_texture2D(bitmap,vec2(texcoord.x,texcoord.y-2.*blurSize))*.12;
		sum+=flixel_texture2D(bitmap,vec2(texcoord.x,texcoord.y-blurSize))*.15;
		sum+=flixel_texture2D(bitmap,vec2(texcoord.x,texcoord.y))*.16;
		sum+=flixel_texture2D(bitmap,vec2(texcoord.x,texcoord.y+blurSize))*.15;
		sum+=flixel_texture2D(bitmap,vec2(texcoord.x,texcoord.y+2.*blurSize))*.12;
		sum+=flixel_texture2D(bitmap,vec2(texcoord.x,texcoord.y+3.*blurSize))*.09;
		sum+=flixel_texture2D(bitmap,vec2(texcoord.x,texcoord.y+4.*blurSize))*.05;
		
		vec2 uv=fragCoord.xy/openfl_TextureSize.xy;
		uv.y+=(sin((uv.x+(iTime*.5))*10.)*speed)+
		(sin((uv.x+(iTime*.2))*intensity)*.01);
		
		vec4 texColor=texture2D(bitmap,uv);
	
		gl_FragColor= sum * bloom + texColor;
	}

	')
	public function new()
	{
		super();
		this.iTime.value = [0,0];
	}
	public function update(elapsed:Float) {
		this.iTime.value[0] += elapsed;
	}
}

class CRTshader extends FlxShader 
{

	@:isVar
	public var warpStrength(get, set):Float = 1;

	function get_warpStrength()
	{
		return (warp.value[0]);
	}
	function set_warpStrength(v:Float)
	{
		warp.value = [v, v];
		return v;
	}
	

	@:glFragmentSource('
	#pragma header

	uniform float warp;

	void main()
	{
    	// squared distance from center
    	vec2 uv=openfl_TextureCoordv.xy;
   	 	vec2 dc=abs(.5-uv)*abs(.5-uv);
    
    	// warp the fragment coordinates
    	uv.x-=.5;uv.x*=1.+(dc.y*(.3*warp));uv.x+=.5;
    	uv.y-=.5;uv.y*=1.+(dc.x*(.4*warp));uv.y+=.5;
    
    	// sample inside boundaries, otherwise set to black
    	if(uv.y>1.||uv.x<0.||uv.x>1.||uv.y<0.)
    	gl_FragColor=vec4(0.,0.,0.,1.);
    	else
    	{
      	  	gl_FragColor=flixel_texture2D(bitmap,uv);
    	}
	}

	')
	public function new()
	{
		super();
		this.warp.value = [1,1];
	}
}
class Glitch2 extends FlxShader //me make into hardcode kay?
{


	@:isVar
	public var glitchy(get, set):Float = 0;

	function get_glitchy()
	{
		return (GLITCH.value[0]);
	}
	function set_glitchy(v:Float)
	{
		GLITCH.value = [v, v];
		return v;
	}
	
	@:glFragmentSource('
	#pragma header

	vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
    uniform float iTime;
	uniform float GLITCH;

	float sat( float t ) {
		return clamp( t, 0.0, 1.0 );
	}
	
	vec2 sat( vec2 t ) {
		return clamp( t, 0.0, 1.0 );
	}
	
	//remaps inteval [a;b] to [0;1]
	float remap  ( float t, float a, float b ) {
		return sat( (t - a) / (b - a) );
	}
	
	//note: t=[0;0.5;1], y=[0;1;0]
	float linterp( float t ) {
		return sat( 1.0 - abs( 2.0*t - 1.0 ) );
	}
	
	vec3 spectrum_offset( float t ) {
		vec3 ret;
		float lo = step(t,0.5);
		float hi = 1.0-lo;
		float w = linterp( remap( t, 1.0/6.0, 5.0/6.0 ) );
		float neg_w = 1.0-w;
		ret = vec3(lo,1.0,hi) * vec3(neg_w, w, neg_w);
		return pow( ret, vec3(1.0/2.2) );
	}
	
	//note: [0;1]
	float rand( vec2 n ) {
	  return fract(sin(dot(n.xy, vec2(12.9898, 78.233)))* 43758.5453);
	}
	
	//note: [-1;1]
	float srand( vec2 n ) {
		return rand(n) * 2.0 - 1.0;
	}
	
	float mytrunc( float x, float num_levels )
	{
		return floor(x*num_levels) / num_levels;
	}
	vec2 mytrunc( vec2 x, float num_levels )
	{
		return floor(x*num_levels) / num_levels;
	}
	
	void main()
	{
		vec2 uv = fragCoord.xy / openfl_TextureSize.xy;
		uv.y = uv.y;
		
		float time = mod(iTime*100.0, 32.0)/110.0;

		float gnm = sat( GLITCH );
		float rnd0 = rand( mytrunc( vec2(time, time), 6.0 ) );
		float r0 = sat((1.0-gnm)*0.7 + rnd0);
		float rnd1 = rand( vec2(mytrunc( uv.x, 10.0*r0 ), time) ); //horz
		//float r1 = 1.0f - sat( (1.0f-gnm)*0.5f + rnd1 );
		float r1 = 0.5 - 0.5 * gnm + rnd1;
		r1 = 1.0 - max( 0.0, ((r1<1.0) ? r1 : 0.9999999) ); //note: weird ass bug on old drivers
		float rnd2 = rand( vec2(mytrunc( uv.y, 40.0*r1 ), time) ); //vert
		float r2 = sat( rnd2 );
	
		float rnd3 = rand( vec2(mytrunc( uv.y, 10.0*r0 ), time) );
		float r3 = (1.0-sat(rnd3+0.8)) - 0.1;
	
		float pxrnd = rand( uv + time );
	
		float ofs = 0.05 * r2 * GLITCH * ( rnd0 > 0.5 ? 1.0 : -1.0 );
		ofs += 0.5 * pxrnd * ofs;
	
		uv.y += 0.1 * r3 * GLITCH;
	
		const int NUM_SAMPLES = 20;
		const float RCP_NUM_SAMPLES_F = 1.0 / float(NUM_SAMPLES);
		
		vec4 sum = vec4(0.0);
		vec3 wsum = vec3(0.0);
		for( int i=0; i<NUM_SAMPLES; ++i )
		{
			float t = float(i) * RCP_NUM_SAMPLES_F;
			uv.x = sat( uv.x + ofs * t );
			vec4 samplecol = texture2D( bitmap, uv,-10.);
			vec3 s = spectrum_offset( t );
			samplecol.rgb = samplecol.rgb * s;
			sum += samplecol;
			wsum += s;
		}
		sum.rgb /= wsum;
		sum.a *= RCP_NUM_SAMPLES_F;
	
		//gl_FragColor.a = sum.a;
		//gl_FragColor.rgb = sum.rgb; // * outcol0.a;
		gl_FragColor = sum;
	}
	
    ')
	public function new()
	{
		super();
		this.iTime.value = [1, 1];
		this.GLITCH.value = [0,0];
		// this.chromo.value = [0,0];
	}

	public function update(elapsed){
		this.iTime.value[0] += elapsed;
	}

}

class GlitchShader2 extends FlxShader
{

    @:isVar
	public var amount(get, set):Float = 0;

    function get_amount()
    {
        return (size.value[0]);
    }
    
    function set_amount(v:Float)
    {
        size.value = [v, v];
        return v;
    }


	@:glFragmentSource('
    #pragma header
    vec2 uv = openfl_TextureCoordv.xy;
    vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
    uniform float iTime;

    vec3 permute(vec3 x) { return mod(((x*34.0)+1.0)*x, 289.0); }
       uniform float size;
    float snoise(vec2 v){
      const vec4 C = vec4(0.211324865405187, 0.366025403784439,
               -0.577350269189626, 0.024390243902439);
      vec2 i  = floor(v + dot(v, C.yy) );
      vec2 x0 = v -   i + dot(i, C.xx);
      vec2 i1;
      i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
      vec4 x12 = x0.xyxy + C.xxzz;
      x12.xy -= i1;
      i = mod(i, 289.0);
      vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
      + i.x + vec3(0.0, i1.x, 1.0 ));
      vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy),
        dot(x12.zw,x12.zw)), 0.0);
      m = m*m ;
      m = m*m ;
      vec3 x = 2.0 * fract(p * C.www) - 1.0;
      vec3 h = abs(x) - 0.5;
      vec3 ox = floor(x + 0.5);
      vec3 a0 = x - ox;
      m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );
      vec3 g;
      g.x  = a0.x  * x0.x  + h.x  * x0.y;
      g.yz = a0.yz * x12.xz + h.yz * x12.yw;
      return 130.0 * dot(m, g);
    }
    
    //	Simplex 3D Noise 
    //	by Ian McEwan, Ashima Arts
    
    vec4 permute(vec4 x){return mod(((x*34.0)+1.0)*x, 289.0);}
    vec4 taylorInvSqrt(vec4 r){return 1.79284291400159 - 0.85373472095314 * r;}
    
    float snoise(vec3 v){ 
      const vec2  C = vec2(1.0/6.0, 1.0/3.0) ;
      const vec4  D = vec4(0.0, 0.5, 1.0, 2.0);
    
    // First corner
      vec3 i  = floor(v + dot(v, C.yyy) );
      vec3 x0 =   v - i + dot(i, C.xxx) ;
    
    // Other corners
      vec3 g = step(x0.yzx, x0.xyz);
      vec3 l = 1.0 - g;
      vec3 i1 = min( g.xyz, l.zxy );
      vec3 i2 = max( g.xyz, l.zxy );
    
      //  x0 = x0 - 0. + 0.0 * C 
      vec3 x1 = x0 - i1 + 1.0 * C.xxx;
      vec3 x2 = x0 - i2 + 2.0 * C.xxx;
      vec3 x3 = x0 - 1. + 3.0 * C.xxx;
    
    // Permutations
      i = mod(i, 289.0 ); 
      vec4 p = permute( permute( permute( 
                 i.z + vec4(0.0, i1.z, i2.z, 1.0 ))
               + i.y + vec4(0.0, i1.y, i2.y, 1.0 )) 
               + i.x + vec4(0.0, i1.x, i2.x, 1.0 ));
    
    // Gradients
    // ( N*N points uniformly over a square, mapped onto an octahedron.)
      float n_ = 1.0/7.0; // N=6
      vec3  ns = n_ * D.wyz - D.xzx;
    
      vec4 j = p - 49.0 * floor(p * ns.z *ns.z);  //  mod(p,N*N)
    
      vec4 x_ = floor(j * ns.z);
      vec4 y_ = floor(j - 7.0 * x_ );    // mod(j,N)
    
      vec4 x = x_ *ns.x + ns.yyyy;
      vec4 y = y_ *ns.x + ns.yyyy;
      vec4 h = 1.0 - abs(x) - abs(y);
    
      vec4 b0 = vec4( x.xy, y.xy );
      vec4 b1 = vec4( x.zw, y.zw );
    
      vec4 s0 = floor(b0)*2.0 + 1.0;
      vec4 s1 = floor(b1)*2.0 + 1.0;
      vec4 sh = -step(h, vec4(0.0));
    
      vec4 a0 = b0.xzyw + s0.xzyw*sh.xxyy ;
      vec4 a1 = b1.xzyw + s1.xzyw*sh.zzww ;
    
      vec3 p0 = vec3(a0.xy,h.x);
      vec3 p1 = vec3(a0.zw,h.y);
      vec3 p2 = vec3(a1.xy,h.z);
      vec3 p3 = vec3(a1.zw,h.w);
    
    //Normalise gradients
      vec4 norm = taylorInvSqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));
      p0 *= norm.x;
      p1 *= norm.y;
      p2 *= norm.z;
      p3 *= norm.w;
    
    // Mix final noise value
      vec4 m = max(0.6 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0);
      m = m * m;
      return 42.0 * dot( m*m, vec4( dot(p0,x0), dot(p1,x1), 
                                    dot(p2,x2), dot(p3,x3) ) );
    }
    
    float rand(float n){return fract(sin(n) * 43758.5453123);}
    
    float noise(float p){
        float fl = floor(p);
      float fc = fract(p);
        return mix(rand(fl), rand(fl + 1.0), fc);
    }
    
    void main()
    {
        vec2 uv = fragCoord.xy / openfl_TextureSize.xy;
        //float n = 1.5;
        float n = noise(fragCoord.y + iTime);
        float sdist = snoise(vec2(0.0, uv.y * 8.0 + iTime * 2.0));
        uv.x += size * sdist * snoise(vec3(vec2(uv.x, floor(fragCoord.y / n) * n) + vec2(iTime * 4.4, iTime * 0.2), iTime * 0.4));
        vec2 uv_r = uv + size * 0.1 * sdist * snoise(vec3(vec2(uv.x, floor(fragCoord.y / n) * n) + vec2(iTime * 4.4, iTime * 0.2), iTime * 0.4));
        vec2 uv_b = uv - size * 0.05 * sdist * snoise(vec3(vec2(uv.x, floor(fragCoord.y / n) * n) + vec2(iTime * 4.4, iTime * 0.2), iTime * 0.4));
        vec4 r = flixel_texture2D(bitmap, uv_r);
        //vec4 g = flixel_texture2D(bitmap, uv);
        vec4 b = flixel_texture2D(bitmap, uv_b);

		vec4 col = flixel_texture2D(bitmap,uv);
		col.r = r.r;
		col.b = b.b;
		gl_FragColor = col;

        //gl_FragColor = vec4(r.r, g.g, b.b, 1.0);
    }')
	public function new()
	{
		super();
        this.iTime.value = [0.0];
        this.size.value = [0.05];

	}

    public function update(elapsed:Float) {
        this.iTime.value[0] += elapsed;
    }
}

class Fishlens extends FlxShader //me make into hardcode kay?
{
	@:isVar
	public var intensity(get, set):Float = 1;
	function get_intensity()
	{
		return (power.value[0]);
	}
	function set_intensity(v:Float)
	{
		power.value = [v, v];
		return v;
	}

	@:isVar
	public var chromatic(get, set):Float = 0;

	function get_chromatic()
	{
		return (chromo.value[0]);
	}
	function set_chromatic(v:Float)
	{
		chromo.value = [v, v];
		return v;
	}
	
	@:glFragmentSource('
	#pragma header
	vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;

	uniform float power;
	uniform float chromo;
	
	void main()
	{
		// uv (0 to 1)
		vec2 uv = fragCoord/openfl_TextureSize.xy;
		
		// uv (-1 to 1, 0 - center)
		uv.x = 2. * uv.x - 1.;
		uv.y = 2. * uv.y - 1.;
		
		float barrel_power = power; // increase for BIGGER EYE!
		float theta = atan(uv.y, uv.x);
		float radius = length(uv);
		radius = pow(radius, barrel_power);
		uv.x = radius * cos(theta);
		uv.y = radius * sin(theta);
		
		// uv (0 to 1)
		uv.x = 0.5 * (uv.x + 1.);
		uv.y = 0.5 * (uv.y + 1.);
	
		float chromo_x = chromo;
		float chromo_y = chromo;
		vec4 col = flixel_texture2D(bitmap,uv);
		col.r = flixel_texture2D(bitmap, vec2(uv.x - chromo_x*0.016, uv.y - chromo_y*0.009)).r;
		col.g = flixel_texture2D(bitmap, vec2(uv.x + chromo_x*0.0125, uv.y - chromo_y*0.004)).g;
		col.b = flixel_texture2D(bitmap, vec2(uv.x - chromo_x*0.0045, uv.y + chromo_y*0.0085)).b;
		gl_FragColor = col;
		
		// output
		//gl_FragColor = vec4(flixel_texture2D(bitmap, vec2(uv.x - chromo_x*0.016, uv.y - chromo_y*0.009)).r, flixel_texture2D(bitmap, vec2(uv.x + chromo_x*0.0125, uv.y - chromo_y*0.004)).g, flixel_texture2D(bitmap, vec2(uv.x - chromo_x*0.0045, uv.y + chromo_y*0.0085)).b, 1.0);;
	}
    ')
	public function new()
	{
		super();
		this.power.value = [1, 1];
		this.chromo.value = [0,0];
	}

}
class FollowedGlitch extends FlxShader 
{
	@:isVar
	public var squareAmount(get, set):Float = 0.;
	function get_squareAmount()
	{
		return (prob.value[0]);
	}
	function set_squareAmount(v:Float)
	{
		prob.value = [v, v];
		return v;
	}

	@:isVar
	public var glowAmount(get, set):Float = 0.;
	function get_glowAmount()
	{
		return (intensityChromatic.value[0]);
	}
	function set_glowAmount(v:Float)
	{
		intensityChromatic.value = [v, v];
		return v;
	}

	@:isVar
	public var iTime(get, set):Float = 0.;
	function get_iTime()
	{
		return (time.value[0]);
	}
	function set_iTime(v:Float)
	{
		time.value = [v, v];
		return v;
	}

	@:glFragmentSource('
	// https://www.shadertoy.com/view/XtyXzW

	#pragma header

	uniform float time;
	uniform float prob;
	uniform float intensityChromatic;
	
	int sampleCount = 50;

	float _round(float n) {
		return floor(n + .5);
	}

	vec2 _round(vec2 n) {
		return floor(n + .5);
	}

	vec3 tex2D(sampler2D _tex,vec2 _p)
	{
		vec3 col=texture2D(_tex,_p).xyz;
		if(.5<abs(_p.x-.5)){
			col=vec3(.1);
		}
		return col;
	}

	#define PI 3.14159265359
	#define PHI (1.618033988749895)

	// --------------------------------------------------------
	// Glitch core
	// --------------------------------------------------------

	float rand(vec2 co){
		return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
	}

	float glitchScale = .4;

	vec2 glitchCoord(vec2 p, vec2 gridSize) {
		vec2 coord = floor(p / gridSize) * gridSize;;
		coord += (gridSize / 2.);
		return coord;
	}

	struct GlitchSeed {
		vec2 seed;
		float prob;
	};
		
	float fBox2d(vec2 p, vec2 b) {
	vec2 d = abs(p) - b;
	return min(max(d.x, d.y), 0.0) + length(max(d, 0.0));
	}

	GlitchSeed glitchSeed(vec2 p, float speed) {
		float seedTime = floor(time * speed);
		vec2 seed = vec2(
			1. + mod(seedTime / 100., 100.),
			1. + mod(seedTime, 100.)
		) / 100.;
		seed += p; 
		return GlitchSeed(seed, prob);
	}

	float shouldApply(GlitchSeed seed) {
		return _round(
			mix( mix(rand(seed.seed), 1., seed.prob - .5),  0.,(1. - seed.prob) * .5));
	}

	// gamma again 
	float GAMMA = 1.;

	vec3 gamma(vec3 color, float g) {
		return pow(color, vec3(g));
	}

	// --------------------------------------------------------
	// Glitch effects
	// --------------------------------------------------------

	// Swap

	vec4 swapCoords(vec2 seed, vec2 groupSize, vec2 subGrid, vec2 blockSize) {
		vec2 rand2 = vec2(rand(seed), rand(seed+.1));
		vec2 range = subGrid - (blockSize - 1.);
		vec2 coord = floor(rand2 * range) / subGrid;
		vec2 bottomLeft = coord * groupSize;
		vec2 realBlockSize = (groupSize / subGrid) * blockSize;
		vec2 topRight = bottomLeft + realBlockSize;
		topRight -= groupSize / 2.;
		bottomLeft -= groupSize / 2.;
		return vec4(bottomLeft, topRight);
	}

	float isInBlock(vec2 pos, vec4 block) {
		vec2 a = sign(pos - block.xy);
		vec2 b = sign(block.zw - pos);
		return min(sign(a.x + a.y + b.x + b.y - 3.), 0.);
	}

	vec2 moveDiff(vec2 pos, vec4 swapA, vec4 swapB) {
		vec2 diff = swapB.xy - swapA.xy;
		return diff * isInBlock(pos, swapA);
	}

	void swapBlocks(inout vec2 xy, vec2 groupSize, vec2 subGrid, vec2 blockSize, vec2 seed, float apply) {
		
		vec2 groupOffset = glitchCoord(xy, groupSize);
		vec2 pos = xy - groupOffset;
		
		vec2 seedA = seed * groupOffset;
		vec2 seedB = seed * (groupOffset + .1);
		
		vec4 swapA = swapCoords(seedA, groupSize, subGrid, blockSize);
		vec4 swapB = swapCoords(seedB, groupSize, subGrid, blockSize);
		
		vec2 newPos = pos;
		newPos += moveDiff(pos, swapA, swapB) * apply;
		newPos += moveDiff(pos, swapB, swapA) * apply;
		pos = newPos;
		
		xy = pos + groupOffset;
	}


	// Static

	void staticNoise(inout vec2 p, vec2 groupSize, float grainSize, float contrast) {
		GlitchSeed seedA = glitchSeed(glitchCoord(p, groupSize), 5.);
		seedA.prob *= .5;
		if (shouldApply(seedA) == 1.) {
			GlitchSeed seedB = glitchSeed(glitchCoord(p, vec2(grainSize)), 5.);
			vec2 offset = vec2(rand(seedB.seed), rand(seedB.seed + .1));
			offset = _round(offset * 2. - 1.);
			offset *= contrast;
			p += offset;
		}
	}


	// Freeze time

	void freezeTime(vec2 p, inout float time, vec2 groupSize, float speed) {
		GlitchSeed seed = glitchSeed(glitchCoord(p, groupSize), speed);
		//seed.prob *= .5;
		if (shouldApply(seed) == 1.) {
			float frozenTime = floor(time * speed) / speed;
			time = frozenTime;
		}
	}


	// --------------------------------------------------------
	// Glitch compositions
	// --------------------------------------------------------

	void glitchSwap(inout vec2 p) {

		vec2 pp = p;
		
		float scale = glitchScale;
		float speed = 5.;
		
		vec2 groupSize;
		vec2 subGrid;
		vec2 blockSize;    
		GlitchSeed seed;
		float apply;
		
		groupSize = vec2(.6) * scale;
		subGrid = vec2(2);
		blockSize = vec2(1);

		seed = glitchSeed(glitchCoord(p, groupSize), speed);
		apply = shouldApply(seed);
		swapBlocks(p, groupSize, subGrid, blockSize, seed.seed, apply);
		
		groupSize = vec2(.8) * scale;
		subGrid = vec2(3);
		blockSize = vec2(1);
		
		seed = glitchSeed(glitchCoord(p, groupSize), speed);
		apply = shouldApply(seed);
		swapBlocks(p, groupSize, subGrid, blockSize, seed.seed, apply);

		groupSize = vec2(.2) * scale;
		subGrid = vec2(6);
		blockSize = vec2(1);
		
		seed = glitchSeed(glitchCoord(p, groupSize), speed);
		float apply2 = shouldApply(seed);
		swapBlocks(p, groupSize, subGrid, blockSize, (seed.seed + 1.), apply * apply2);
		swapBlocks(p, groupSize, subGrid, blockSize, (seed.seed + 2.), apply * apply2);
		swapBlocks(p, groupSize, subGrid, blockSize, (seed.seed + 3.), apply * apply2);
		swapBlocks(p, groupSize, subGrid, blockSize, (seed.seed + 4.), apply * apply2);
		swapBlocks(p, groupSize, subGrid, blockSize, (seed.seed + 5.), apply * apply2);
		
		groupSize = vec2(1.2, .2) * scale;
		subGrid = vec2(9,2);
		blockSize = vec2(3,1);
		
		seed = glitchSeed(glitchCoord(p, groupSize), speed);
		apply = shouldApply(seed);
		swapBlocks(p, groupSize, subGrid, blockSize, seed.seed, apply);
	}

	void glitchStatic(inout vec2 p) {
		staticNoise(p, vec2(.5, .25/2.) * glitchScale, .2 * glitchScale, 2.);
	}


	void glitchColor(vec2 p, inout vec3 color) {
		vec2 groupSize = vec2(.75,.125) * glitchScale;
		vec2 subGrid = vec2(0,6);
		float speed = 5.;
		GlitchSeed seed = glitchSeed(glitchCoord(p, groupSize), speed);
		seed.prob *= .3;
		if (shouldApply(seed) == 1.) 
			color = vec3(0, 0, 0);
	}

	vec4 transverseChromatic(vec2 p) {
		vec2 destCoord = p;
		vec2 direction = normalize(destCoord - 0.5); 
		vec2 velocity = direction * intensityChromatic * pow(length(destCoord - 0.5), 3.0);
		float inverseSampleCount = 1.0 / float(sampleCount); 
		
		//mat3x2 increments = mat3x2(velocity * 1.0 * inverseSampleCount, velocity * 2.0 * inverseSampleCount, velocity * 4.0 * inverseSampleCount);

		vec2 increment1 = vec2(velocity * 1.0 * inverseSampleCount);
		vec2 increment2 = vec2(velocity * 2.0 * inverseSampleCount);
		vec2 increment3 = vec2(velocity * 4.0 * inverseSampleCount);

		vec3 accumulator = vec3(0);
		//mat3x2 offsets = mat3x2(0); 
		vec2 offsets1 = vec2(0);
		vec2 offsets2 = vec2(0);
		vec2 offsets3 = vec2(0);


		for (int i = 0; i < sampleCount; i++) {
			accumulator.r += texture2D(bitmap, destCoord + offsets1).r; 
			accumulator.g += texture2D(bitmap, destCoord + offsets2).g; 
			accumulator.b += texture2D(bitmap, destCoord + offsets3).b; 
			offsets1 -= increment1;
			offsets2 -= increment2;
			offsets3 -= increment3;

			//offsets -= increments;
		}
		//vec2 uv = fragCoord/openfl_TextureSize.xy;
		vec4 newColor = vec4(accumulator / float(sampleCount), flixel_texture2D(bitmap,(openfl_TextureCoordv*openfl_TextureSize)/openfl_TextureSize.xy).a);
		return newColor;
	}

	void main() {
		vec2 p = openfl_TextureCoordv.xy;
		vec4 color = texture2D(bitmap, p);
		
		glitchSwap(p);
		glitchStatic(p);

		color = transverseChromatic(p);
		glitchColor(p, color.rgb);
		gl_FragColor = color;
	}
')
	public function new()
	{
		super();
		intensityChromatic.value = [0,0];
		iTime = 0.1;
	}

	public function update(elapsed) {
        iTime += elapsed;
    }

}
class BloomShader extends FlxShader 
{
	@:isVar
	public var glowAmount(get, set):Float = 0.;

	function get_glowAmount()
	{
		return (strength.value[0]);
	}
	function set_glowAmount(v:Float)
	{
		strength.value = [v, v];
		return v;
	}
	
	@:glFragmentSource('
        #pragma header
		vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
		const float blurSize = 1.0/512.0;
		const float intensity = 0.35;
		uniform float strength;
		void main()
		{
		   vec4 sum = vec4(0);
		   vec2 texcoord = fragCoord.xy/openfl_TextureSize.xy;
		
		   //thank you! http://www.gamerendering.com/2008/10/11/gaussian-blur-filter-shader/ for the 
		   //blur tutorial
		   // blur in y (vertical)
		   // take nine samples, with the distance blurSize between them
		   sum += flixel_texture2D(bitmap, vec2(texcoord.x - 4.0*blurSize, texcoord.y)) * 0.05;
		   sum += flixel_texture2D(bitmap, vec2(texcoord.x - 3.0*blurSize, texcoord.y)) * 0.09;
		   sum += flixel_texture2D(bitmap, vec2(texcoord.x - 2.0*blurSize, texcoord.y)) * 0.12;
		   sum += flixel_texture2D(bitmap, vec2(texcoord.x - blurSize, texcoord.y)) * 0.15;
		   sum += flixel_texture2D(bitmap, vec2(texcoord.x, texcoord.y)) * 0.16;
		   sum += flixel_texture2D(bitmap, vec2(texcoord.x + blurSize, texcoord.y)) * 0.15;
		   sum += flixel_texture2D(bitmap, vec2(texcoord.x + 2.0*blurSize, texcoord.y)) * 0.12;
		   sum += flixel_texture2D(bitmap, vec2(texcoord.x + 3.0*blurSize, texcoord.y)) * 0.09;
		   sum += flixel_texture2D(bitmap, vec2(texcoord.x + 4.0*blurSize, texcoord.y)) * 0.05;
			
			// blur in y (vertical)
		   // take nine samples, with the distance blurSize between them
		   sum += flixel_texture2D(bitmap, vec2(texcoord.x, texcoord.y - 4.0*blurSize)) * 0.05;
		   sum += flixel_texture2D(bitmap, vec2(texcoord.x, texcoord.y - 3.0*blurSize)) * 0.09;
		   sum += flixel_texture2D(bitmap, vec2(texcoord.x, texcoord.y - 2.0*blurSize)) * 0.12;
		   sum += flixel_texture2D(bitmap, vec2(texcoord.x, texcoord.y - blurSize)) * 0.15;
		   sum += flixel_texture2D(bitmap, vec2(texcoord.x, texcoord.y)) * 0.16;
		   sum += flixel_texture2D(bitmap, vec2(texcoord.x, texcoord.y + blurSize)) * 0.15;
		   sum += flixel_texture2D(bitmap, vec2(texcoord.x, texcoord.y + 2.0*blurSize)) * 0.12;
		   sum += flixel_texture2D(bitmap, vec2(texcoord.x, texcoord.y + 3.0*blurSize)) * 0.09;
		   sum += flixel_texture2D(bitmap, vec2(texcoord.x, texcoord.y + 4.0*blurSize)) * 0.05;
		
		   //increase blur with intensity!
		   //fragColor = sum*intensity + texture(iChannel0, texcoord); 
		   
		   gl_FragColor = sum * strength + flixel_texture2D(bitmap, texcoord);
		
		}
    ')
	public function new()
	{
		super();
		strength.value = [0,0];
	}

}

class MosiacShader extends FlxShader //kay so i dont know if theres a convenient way to tween runtimeshader values? so im making the mosaic shader a class /data todo? make class and shit built around runtimer shaders to tween em
{
	@:isVar
	public var pixelSize(get, set):Float = 1;

	function get_pixelSize()
	{
		return (pixel.value[0] + pixel.value[1])/2;
	}
	function set_pixelSize(v:Float)
	{
		pixel.value = [v, v];
		return v;
	}
	
	@:glFragmentSource('
        #pragma header

        uniform vec2 pixel;
		void main()
		{
            vec2 size = openfl_TextureSize.xy / pixel;
            gl_FragColor = flixel_texture2D(bitmap, floor(openfl_TextureCoordv.xy * size) / size);
        }
    ')
	public function new()
	{
		super();
		pixel.value = [1, 1];
	}

}

class GlitchShaderA extends FlxShader //https://www.shadertoy.com/view/MscGzl
{

    @:isVar
	public var glitchEffect(get, set):Float = 0;

	function get_glitchEffect()
	{
		return (glitchAmount.value[0]);
	}

	function set_glitchEffect(v:Float)
	{
		glitchAmount.value = [v, v];
		return v;
	}

	@:glFragmentSource('
    #pragma header

    vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;

    uniform float glitchAmount;
    uniform float iTime;

    vec4 posterize(vec4 color, float numColors)
    {
        return floor(color * numColors - 0.5) / numColors;
    }

    vec2 quantize(vec2 v, float steps)
    {
        return floor(v * steps) / steps;
    }

    float dist(vec2 a, vec2 b)
    {
        return sqrt(pow(b.x - a.x, 2.0) + pow(b.y - a.y, 2.0));
    }

    void main()
    {   
	    vec2 uv = fragCoord.xy / openfl_TextureSize.xy;
        float amount = pow(glitchAmount, 2.0);
        vec2 pixel = 1.0 / openfl_TextureSize.xy;    
        vec4 color = flixel_texture2D(bitmap, uv);
        float t = mod(mod(iTime, amount * 100.0 * (amount - 0.5)) * 109.0, 1.0);
        vec4 postColor = posterize(color, 16.0);
        vec4 a = posterize(flixel_texture2D(bitmap, quantize(uv, 64.0 * t) + pixel * (postColor.rb - vec2(.5)) * 100.0), 5.0).rbga;
        vec4 b = posterize(flixel_texture2D(bitmap, quantize(uv, 32.0 - t) + pixel * (postColor.rg - vec2(.5)) * 1000.0), 4.0).gbra;
        vec4 c = posterize(flixel_texture2D(bitmap, quantize(uv, 16.0 + t) + pixel * (postColor.rg - vec2(.5)) * 20.0), 16.0).bgra;
        gl_FragColor = mix(flixel_texture2D(bitmap, 
        uv + amount * (quantize((a * t - b + c - (t + t / 2.0) / 10.0).rg, 16.0) - vec2(.5)) * pixel * 100.0),
        (a + b + c) / 3.0, (0.5 - (dot(color, postColor) - 1.5)) * amount);
    }
    
    
    ')
	public function new()
	{
		super();
        this.iTime.value = [0.0];
        this.glitchAmount.value = [0,0];
	}
    public function update(elapsed) {
        this.iTime.value[0] += elapsed;
    }
	
}



class RuntimeShaderHelper extends FlxBasic { //tween values and ig itime?


	// public function new() {
	// 	super();
	// }




	// override public function update(elapsed:Float){
	// 	super.update(elapsed);


	// }




}

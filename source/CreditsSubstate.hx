package;

import options.BaseOptionsMenu.OptionFlxText;
import flixel.util.FlxTimer;
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
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import lime.utils.Assets;

using StringTools;

class CreditsSubstate extends MusicBeatSubstate
{
	var curSelected:Int = -1;

	private var grpOptions:FlxTypedGroup<OptionFlxText>;
	private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Array<String>> = [];

	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:Int;
	var colorTween:FlxTween;
	var descBox:AttachedSprite;

	var offsetThing:Float = -75;

	override function create()
	{
		// #if desktop
		// // Updating Discord Rich Presence
		// DiscordClient.changePresence("In the Menus", null);
		// #end
		var b = new FlxSprite().makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
		b.scrollFactor.set();
		add(b);
		b.alpha = 0;
		FlxTween.tween(b, {alpha: 0.7},1);

		persistentUpdate = true;
		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		//add(bg);
		bg.screenCenter();
		
		grpOptions = new FlxTypedGroup<OptionFlxText>();
		add(grpOptions);

		#if MODS_ALLOWED
		var path:String = 'modsList.txt';
		if(FileSystem.exists(path))
		{
			var leMods:Array<String> = CoolUtil.coolTextFile(path);
			for (i in 0...leMods.length)
			{
				if(leMods.length > 1 && leMods[0].length > 0) {
					var modSplit:Array<String> = leMods[i].split('|');
					if(!Paths.ignoreModFolders.contains(modSplit[0].toLowerCase()) && !modsAdded.contains(modSplit[0]))
					{
						if(modSplit[1] == '1')
							pushModCreditsToList(modSplit[0]);
						else
							modsAdded.push(modSplit[0]);
					}
				}
			}
		}

		var arrayOfFolders:Array<String> = Paths.getModDirectories();
		arrayOfFolders.push('');
		for (folder in arrayOfFolders)
		{
			pushModCreditsToList(folder);
		}
		#end


		var pisspoop:Array<Array<String>> = [ //Name - Icon name - Description - Link - BG Color
			['The Ourple Guys'],
			['Kiwiquest',		'lex',		'Director, Musician',								'https://twitter.com/kiwiquestt',	'444444'],
			['Headdzo',		'gab',		'Director, Artist, Musician',								'https://twitter.com/WhoUsedHeaddzo',	'444444'],
			['Blackberri',		'blackberri',		'Director, Musician',								'',	'444444'],
			['Cold_Vee',		'cold',		'Director, Programmer',								'https://twitter.com/cold_vee',	'444444'],

			['Data',		'data',		'Director, Programmer',								'https://twitter.com/FixedData',	'444444'],
			['fabr',		'fabr',		'Programmer',								'https://twitter.com/fabr2088964',	'444444'],
			['funkypop',	'funkypop',	'Programmer, Mac Tester',					'https://twitter.com/funkypoppp',	'444444'],
			['Melyndee ',		'jackie',		'Programmer , Artist',								'https://twitter.com/mellydees',	'444444'],
			['Lossarquo',		'loss',		'Artist',								'https://twitter.com/lossarquo',	'444444'],
			['Snoob',		'smallnoob',		'Artist',								'https://twitter.com/smallnoob11',	'444444'],
			['BinejYeah',		'binejyeah',		'Artist',								'https://twitter.com/binej_yeah',	'444444'],
			['Kazsper',		'kazsper',		'Artist',								'https://twitter.com/emi_r_e_a_l',	'444444'],	
			['jonspeedarts',		'jon',		'Artist',								'https://twitter.com/Jon_SpeedArts',	'444444'],		
			['Mr. DJ',		'mrdj',		'Artist',								'https://twitter.com/Mstr_DJ',	'444444'],		
			['Libur',		'libur',		'Artist',								'https://twitter.com/eatalottafood',	'444444'],
			['stuffy',		'stuffy',		'Artist',								'https://twitter.com/Trollingmaster_',	'444444'],
			['Mr. Luwigi',		'luwigi',		'Artist',								'https://twitter.com/mrluwigi',	'444444'],
			['QuietTomato',		'quiettomato',		'Artist',								'https://twitter.com/QuietTomato',	'444444'],
			['Jaycool',		'jay',		'Artist',								'https://twitter.com/ParadisePNews',	'444444'],
			['Croc',        'croc',		'Artist',									'https://twitter.com/konn_artist',	'444444'],
			['Smokey99k',		'smokey99k',		'Musician',								'https://twitter.com/smokey99k',	'444444'],
			['discoverypages',		'mimi',		'Voice Actor',								'https://twitter.com/discoverypages',	'444444'],
			['MewMarissa',		'marissa',		'Musician',								'https://twitter.com/HSkribble',	'444444'],
			['maddiesmiles',		'maddie',		'Musician',								'https://twitter.com/maddiesmiles_',	'444444'],
			['justisaac',		'isaac',		'Musician',								'https://twitter.com/justisaac15',	'444444'],
			['marstarbro',		'marstarbro',		'Musician',								'https://twitter.com/MarstarMain',	'444444'],		
			['Periodical',		'periodical',		'Musician',								'https://twitter.com/galliumxenon',	'444444'],
			['Xhitest ',		'case',		'Musician',								'https://twitter.com/xhitest',	'444444'],
			['Zeroh',		'zeroh',		'Musician',								'https://twitter.com/catsmirkk',	'444444'],
			['EmiHead',		'emihead',		'Musician',								'https://twitter.com/emihead',	'444444'],
			['Douyhe',		'douyhe',		'Musician',								'https://twitter.com/toolbox64',	'444444'],
			['Punkett',		'punkett',		'Musician',								'https://twitter.com/_punkett',	'444444'],
			['Brooklyn',		'brooklyn',		'Voice Actor, Charter',								'https://twitter.com/Estrogen_Storm1',	'444444'],
			['pointy',		'pointy',		'Charter',								'https://twitter.com/PointyyESM',	'444444'],
			['Rotty',		'rotty',		'Charter',								'https://twitter.com/RottySC2',	'444444'],
			['gibz679',		'gibz',		'Charter',								'https://twitter.com/9766Gibz',	'444444'],
			['salamipaste',		'salamipaste',		'Creator of Fat Jones',								'https://twitter.com/RottySC2',	'444444'],
			['Jeff',		'jeff',		'Fat Jones Voice',								'https://twitter.com/RottySC2',	'444444'],
			

			['Guest Artists'],
			['blini',		'blini',		'Artist',								'https://twitter.com/angelfaIse',	'444444'],
			['yoisabo',		'yoisabo',		'Artist',								'https://twitter.com/abo_bora',	'444444'],
			['DomGom',		'thedomgom',		'Artist',								'https://twitter.com/DomGom1',	'444444'],
			['rekkadraws',		'rekka',		'Artist',								'https://twitter.com/rekkadraws_',	'444444'],
			['Memorizor',		'memorizer',		'Artist',								'',	'444444'],
			['c4horse',		'growl',		'Artist',								'https://twitter.com/c4horse_',	'444444'],
			['k_kila',		'kila',		'Artist',								'https://twitter.com/pk_kila',	'444444'],
			['Gambino',		'gambino',		'Artist',								'https://twitter.com/Gambi_bino',	'444444'],
			['gacktenzo',	'gackt',	'Artist',									'https://twitter.com/gacktenzo',				'444444']




			//['Charters']


			//['Coders']



			
			// ['Psych Engine Team'],
			// ['Shadow Mario',		'shadowmario',		'Main Programmer of Psych Engine',								'https://twitter.com/Shadow_Mario_',	'444444'],
			// ['RiverOaken',			'river',			'Main Artist/Animator of Psych Engine',							'https://twitter.com/RiverOaken',		'B42F71'],
			// //['shubs',				'shubs',			'Additional Programmer of Psych Engine',						'https://twitter.com/yoshubs',			'5E99DF'],
			// [''],
			// ['Former Engine Members'],
			// ['bb-panzu',			'bb',				'Ex-Programmer of Psych Engine',								'https://twitter.com/bbsub3',			'3E813A'],
			// [''],
			// ['Engine Contributors'],
			// ['iFlicky',				'flicky',			'Composer of Psync and Tea Time\nMade the Dialogue Sounds',		'https://twitter.com/flicky_i',			'9E29CF'],
			// ['SqirraRNG',			'sqirra',			'Crash Handler and Base code for\nChart Editor\'s Waveform',	'https://twitter.com/gedehari',			'E1843A'],
			// ['EliteMasterEric',		'mastereric',		'Runtime Shaders support',										'https://twitter.com/EliteMasterEric',	'FFBD40'],
			// ['PolybiusProxy',		'proxy',			'.MP4 Video Loader Library (hxCodec)',							'https://twitter.com/polybiusproxy',	'DCD294'],
			// ['KadeDev',				'kade',				'Fixed some cool stuff on Chart Editor\nand other PRs',			'https://twitter.com/kade0912',			'64A250'],
			// ['Keoiki',				'keoiki',			'Note Splash Animations',										'https://twitter.com/Keoiki_',			'D2D2D2'],
			// ['Nebula the Zorua',	'nebula',			'LUA JIT Fork and some Lua reworks',							'https://twitter.com/Nebula_Zorua',		'7D40B2'],
			// ['Smokey',				'smokey',			'Sprite Atlas Support',											'https://twitter.com/Smokey_5_',		'483D92'],
			// [''],
			// ["Funkin' Crew"],
			// ['ninjamuffin99',		'ninjamuffin99',	"Programmer of Friday Night Funkin'",							'https://twitter.com/ninja_muffin99',	'CF2D2D'],
			// ['PhantomArcade',		'phantomarcade',	"Animator of Friday Night Funkin'",								'https://twitter.com/PhantomArcade3K',	'FADC45'],
			// ['evilsk8r',			'evilsk8r',			"Artist of Friday Night Funkin'",								'https://twitter.com/evilsk8r',			'5ABD4B'],
			// ['kawaisprite',			'kawaisprite',		"Composer of Friday Night Funkin'",								'https://twitter.com/kawaisprite',		'378FC7']
		];
		
		for(i in pisspoop){
			creditsStuff.push(i);
		}
	
		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:OptionFlxText = new OptionFlxText(FlxG.width / 2, 300, creditsStuff[i][0]);
			optionText.isMenuItem = true;
			optionText.scrollFactor.set();
			optionText.targetY = i;
			optionText.changeX = false;
			optionText.snapToPosition();
			grpOptions.add(optionText);

			if(isSelectable) {
				if(creditsStuff[i][5] != null)
				{
					Paths.currentModDirectory = creditsStuff[i][5];
				}

				var icon:AttachedSprite = new AttachedSprite('credits/' + creditsStuff[i][1]);
				icon.xAdd = optionText.width + 10;
				icon.yAdd = -50;
				icon.sprTracker = optionText;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
				Paths.currentModDirectory = '';

				if(curSelected == -1) curSelected = i;
			}
			else {
				optionText.size = optionText.size + 12;
				optionText.fieldWidth = FlxG.width;
				optionText.x = 0;
				//optionText.alignment = CENTER;
			}
		}
		
		descBox = new AttachedSprite();
		descBox.makeGraphic(1, 1, FlxColor.BLACK);
		descBox.xAdd = -10;
		descBox.yAdd = -10;
		descBox.alphaMult = 0.6;
		descBox.alpha = 0.6;
		add(descBox);

		descText = new FlxText(50, FlxG.height + offsetThing - 25, 1180, "", 32);
		descText.setFormat(Paths.font("options.ttf"), 28, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		//descText.borderSize = 2.4;
		descBox.sprTracker = descText;
		add(descText);

		bg.color = getCurrentBGColor();
		intendedColor = bg.color;
		changeSelection();

		new FlxTimer().start(0.1, function (f:FlxTimer){
			quitting=false;
		});
		super.create();
	}

	var quitting:Bool = true;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if(!quitting)
		{
			if(creditsStuff.length > 1)
			{
				var shiftMult:Int = 1;
				if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

				var upP = controls.UI_UP_P;
				var downP = controls.UI_DOWN_P;

				if (upP)
				{
					changeSelection(-shiftMult);
					holdTime = 0;
				}
				if (downP)
				{
					changeSelection(shiftMult);
					holdTime = 0;
				}

				if(controls.UI_DOWN || controls.UI_UP)
				{
					var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
					holdTime += elapsed;
					var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

					if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
					{
						changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					}
				}
			}

			if(controls.ACCEPT && (creditsStuff[curSelected][3] == null || creditsStuff[curSelected][3].length > 4)) {
				CoolUtil.browserLoad(creditsStuff[curSelected][3]);
			}
			if (controls.BACK)
			{
				if(colorTween != null) {
					colorTween.cancel();
				}
				FlxG.sound.play(Paths.sound('cancelMenu'));
				//MusicBeatState.switchState(new MainMenuState());
				close();
				quitting = true;
			}
		}
		
		for (item in grpOptions.members)
		{
			if(!item.bold)
			{
				var lerpVal:Float = CoolUtil.boundTo(elapsed * 12, 0, 1);
				if(item.targetY == 0)
				{
					var lastX:Float = item.x;
					item.screenCenter(X);
					item.x = FlxMath.lerp(lastX, item.x - 70, lerpVal);
				}
				else
				{
					item.x = FlxMath.lerp(item.x, 100 + -40 /* Math.abs(item.targetY)*/, lerpVal);
				}
			}
		}
		super.update(elapsed);
	}

	var moveTween:FlxTween = null;
	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var newColor:Int =  getCurrentBGColor();
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}
		}

		descText.text = creditsStuff[curSelected][2];
		descText.y = FlxG.height - descText.height + offsetThing - 60;

		if(moveTween != null) moveTween.cancel();
		moveTween = FlxTween.tween(descText, {y : descText.y + 75}, 0.25, {ease: FlxEase.sineOut});

		descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
		descBox.updateHitbox();
	}

	#if MODS_ALLOWED
	private var modsAdded:Array<String> = [];
	function pushModCreditsToList(folder:String)
	{
		if(modsAdded.contains(folder)) return;

		var creditsFile:String = null;
		if(folder != null && folder.trim().length > 0) creditsFile = Paths.mods(folder + '/data/credits.txt');
		else creditsFile = Paths.mods('data/credits.txt');

		if (FileSystem.exists(creditsFile))
		{
			var firstarray:Array<String> = File.getContent(creditsFile).split('\n');
			for(i in firstarray)
			{
				var arr:Array<String> = i.replace('\\n', '\n').split("::");
				if(arr.length >= 5) arr.push(folder);
				creditsStuff.push(arr);
			}
			creditsStuff.push(['']);
		}
		modsAdded.push(folder);
	}
	#end

	function getCurrentBGColor() {
		var bgColor:String = creditsStuff[curSelected][4];
		if(!bgColor.startsWith('0x')) {
			bgColor = '0xFF' + bgColor;
		}
		return Std.parseInt(bgColor);
	}

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}
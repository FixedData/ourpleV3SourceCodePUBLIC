dir = 'stage/bite/'
local startingnow = false

local allowedL = true
local allowedR = true
local doorLactive = false
local doorRactive = false
local doorclick = true

--stage coded by jackie 
--ui mouse controls and extras by data
function onCreate()
	--stage stuff
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', '')
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', '')

	makeLuaSprite('lefthall', dir..'llight')
	addLuaSprite('lefthall')
	setProperty('lefthall.alpha',0)

	makeLuaSprite('righthall', dir..'rlight')
	addLuaSprite('righthall')
	setProperty('righthall.alpha',0)

	makeLuaSprite('doorL', dir..'door',0,-1500)
	addLuaSprite('doorL')
	scaleObject('doorL',2,2,true)

	makeLuaSprite('doorR', dir..'door',0,-1500)
	addLuaSprite('doorR')
	scaleObject('doorR',2,2,true)
	setProperty('doorR.flipX',true)



	makeLuaSprite('bg', dir..'stageback', 0, 0)
	scaleObject("bg", 2, 2, true)
	addLuaSprite('bg', false)
	
	makeLuaSprite('fg', dir..'stagefront', 0, 0)
	scaleObject("fg", 2, 2, true)
	addLuaSprite('fg', true)

	makeLuaSprite('button', dir..'button')
	addLuaSprite('button', true)
	setGraphicSize("button", 0, getProperty("bg.height"), true)
	setProperty('button.alpha',0)

	makeLuaSprite('buttonlight', dir..'lightb')
	addLuaSprite('buttonlight', true)
	setGraphicSize("buttonlight", 0, getProperty("bg.height"), true)
	setProperty('buttonlight.alpha',0)

	setProperty('righthall.x', getProperty("bg.width") - getProperty("righthall.width"))

	--hitboxes
	makeLuaSprite('buttonL','',0,750)
	makeGraphic("buttonL", 150, 175, 'FFFF0000')
	setProperty("buttonL.alpha", 0.5)
	--addLuaSprite('buttonL',true)

	makeLuaSprite('buttonR','',0,750)
	makeGraphic("buttonR", 150, 175, 'FFFF0000')
	setProperty('buttonR.x', getProperty("bg.width") - getProperty("buttonR.width"))
	setProperty("buttonR.alpha", 0.5)

	makeLuaSprite('lightL','',0,960)
	makeGraphic("lightL", 150, 200, 'FFFF0000')
	setProperty("lightL.alpha", 0.5)
	--addLuaSprite('lightL',true)

	makeLuaSprite('lightR','',0,960)
	makeGraphic("lightR", 150, 200, 'FFFF0000')
	setProperty("lightR.alpha", 0.5)
	setProperty('lightR.x', getProperty("bg.width") - getProperty("lightR.width"))
	--addLuaSprite('lightR',true)


	makeLuaSprite('noseboop','',1045,585)
	makeGraphic("noseboop", 50, 40, 'FFFF0000')
	setProperty("noseboop.alpha", 0.5)
	--addLuaSprite('noseboop',true)

	makeLuaSprite('pause','',12,720 - 25)
	makeGraphic("pause", 20, 20, 'FFFF0000')
	setObjectCamera('pause','other')
	setProperty("pause.alpha", 0.5)

	makeLuaSprite('skip','',55,720 - 25)
	makeGraphic("skip", 20, 20, 'FFFF0000')
	setObjectCamera('skip','other')
	setProperty("skip.alpha", 0.5)

	makeLuaSprite('sound','',95,720 - 25)
	makeGraphic("sound", 20, 20, 'FFFF0000')
	setObjectCamera('sound','other')
	setProperty("sound.alpha", 0.5)

	makeLuaSprite("blackscreennews")
	makeGraphic("blackscreennews", screenWidth*2, screenHeight*2, '000000')
	addLuaSprite("blackscreennews",true)
	setLuaSpriteScrollFactor("blackscreennews", 0.0, 0.0)
	screenCenter("blackscreennews", 'xy')


	makeLuaText("12am", "12:00 AM\n1st Night",screenWidth)
	setTextFont("12am", "bite.ttf")
	setTextSize('12am',36)
	setTextAlignment("12am", 'center')
	screenCenter('12am','y')
	addLuaText("12am",true)
	setTextBorder("12am", 0, "0x")
	setProperty('12am.alpha',0)


	makeLuaSprite("newspaper", dir..'news', 0, 0)
	setGraphicSize("newspaper", screenWidth*2, screenHeight*2, true)
	addLuaSprite("newspaper",true)
	setLuaSpriteScrollFactor("newspaper", 0.0, 0.0)
	screenCenter("newspaper", 'xy')


	makeLuaSprite("titlescreen", dir..'bitetitle', 0, 0)
	setGraphicSize("titlescreen", screenWidth*2, screenHeight*2, true)
	addLuaSprite("titlescreen",true)
	setLuaSpriteScrollFactor("titlescreen", 0.0, 0.0)
	screenCenter("titlescreen", 'xy')

	makeAnimatedLuaSprite("static", 'stage/terminated/static')
	addAnimationByPrefix("static", "i", "static", 12, true)
	playAnim("static", "i")
	addLuaSprite("static", true)
	setGraphicSize("static", screenWidth*2, screenHeight*2, true)
	setLuaSpriteScrollFactor("static", 0.0, 0.0)
	screenCenter("static", 'xy')
	setBlendMode("static", 'add')
	setProperty('static.alpha',0.6)






end

function onCountdownTick(c)
	if c == 4 then

		runTimer('endintro',3)	
	end
	if c == 2 then
		setProperty('countdownGo.visible',false)
		setProperty('countdownReady.visible',false)
		setProperty('countdownSet.visible',false)
		setProperty('countdownOnyourmarks.visible',false)
		removeLuaSprite("loadingblack", true)
		removeLuaSprite("loadcircle", true)
	end
	if c == 3 then
		setProperty('countdownGo.visible',false)
		setProperty('countdownReady.visible',false)
		setProperty('countdownSet.visible',false)
		setProperty('countdownOnyourmarks.visible',false)
	end
	
end


function onCreatePost()

	setProperty('hudAssets.members[0].visible',true)
	setProperty('hudAssets.members[1].visible',false)
	setProperty('hudAssets.members[2].visible',false)
	setProperty('hudAssets.members[3].visible',false)
	setProperty('hudAssets.members[4].visible',false)
	setProperty('hudAssets.members[5].visible',false)
	setProperty('iconP1.visible',false)
	setProperty('iconP2.visible',false)

	makeLuaSprite('barup', dir..'bdup', 0, 0)
	setGraphicSize("barup", screenWidth*2, 0, true)
	addLuaSprite('barup',true)

	makeLuaSprite('bardown', dir..'bddown', 0, 100)
	setGraphicSize("bardown", screenWidth*2, 0, true)
	addLuaSprite('bardown',true)

    makeAnimatedLuaSprite('fred', dir..'freddyjump', -25, 100)
	addAnimationByPrefix('fred','scare','FredJUMPSCARE')
	addLuaSprite('fred')
	setObjectCamera("fred", 'hud')
	setGraphicSize("fred", screenWidth, screenHeight, true)
	setProperty('fred.visible',false)

	makeAnimatedLuaSprite('cams', dir..'DJcamera',-310,-400)
	addAnimationByPrefix('cams','flip','CamFLIP',24,false)
	addAnimationByPrefix('cams','loop','CamLOOP',24,true)
	scaleObject("cams", 1.3, 1.3)
	updateHitbox("cams")
	addLuaSprite('cams',true)
	setProperty('cams.visible',false)

	makeLuaSprite('fx', dir..'overlay', 0, 0)
	addLuaSprite('fx')
	setProperty('fx.alpha',0)
	setObjectCamera('fx','camHUD')
	setGraphicSize("fx", 1280, 720, true)
	--setObjectOrder('fx',getObjectOrder('cams')+1)
	setObjectOrder('boyfriend',getObjectOrder('cams')+2)
	runHaxeCode("game.setNotePosition('middle');")

	makeLuaText("power", "Power left:", 0, 25, screenHeight - 100)
	setTextSize("power", 22)
	setTextFont("power", "bite.ttf")
	setObjectCamera("power", 'hud')
	setTextBorder("power", 0, "0x")
	setProperty('power.alpha',0)
	addLuaText("power")

	makeLuaText("powerHP", "100", 0, getProperty("power.x") + getProperty("power.width") + 5,screenHeight - 100 - 22)
	setTextSize("powerHP", 36)
	setObjectCamera("powerHP", 'hud')
	setTextFont("powerHP", "bite.ttf")
	setTextBorder("powerHP", 0, "0x")
	setProperty('powerHP.alpha',0)
	addLuaText("powerHP")

	makeLuaText("powerpercent", "%", 0, getProperty("powerHP.x") + getProperty("powerHP.width"), screenHeight - 100)
	setTextSize("powerpercent", 22)
	setObjectCamera("powerpercent", 'hud')
	setTextFont("powerpercent", "bite.ttf")
	setTextBorder("powerpercent", 0, "0x")
	setProperty('powerpercent.alpha',0)
	addLuaText("powerpercent")
	math.randomseed(os.time())

	makeLuaSprite("annotationbox",'',math.random(40,1000),math.random(10,290))
	makeGraphic("annotationbox", 200, 420, 'FF0000')
	addLuaSprite("annotationbox")
	setProperty("annotationbox.alpha", 0.4)
	setObjectCamera("annotationbox", 'other')

	songcredits = 'Bite\nKiwiquest\n\nArtists:\nMr DJ\nBinejYeah\nHeaddzo\n\nCoders:\nJackie\nData\n\nCharters:\nRotty'
		
	makeLuaText("creditsss", songcredits, 0,getProperty('annotationbox.x') + 5,getProperty('annotationbox.y') + 10)
	setTextSize("creditsss", 24)
	setTextAlignment("creditsss", 'left')
	setObjectCamera("creditsss", 'other')
	setTextFont("creditsss", "Roboto-Regular.ttf")
	setTextBorder("creditsss", 0, "0x")
	addLuaText("creditsss")
	setProperty("annotationbox.alpha", 0)
	setProperty("creditsss.alpha", 0)

	setProperty("scoreTxt.visible",false)
	setProperty("stars.y",getProperty("stars.y") + -75)

	runHaxeCode([[
		game.timeBar.alpha = 1;
		game.timeBar.x = 0;
		game.timeBar.barWidth = 1280;
		game.timeBar.barHeight -= 15;
		game.timeBar.createFilledBar(0xFF808080,0xFFFF0000);
		game.timeBar.numDivisions = 1200;
		FlxG.mouse.visible = true;
		FlxG.mouse.useSystemCursor = true;
	]])

	setObjectCamera("timeBar", 'other')
	setProperty('timeBar.y',684)

	makeLuaText("youtubeTime", "0:00 / 4:25", 0,140,getProperty('timeBar.y') + 10)
	setObjectCamera("youtubeTime", 'other')
	setTextFont("youtubeTime", "Roboto-Regular.ttf")
	setTextBorder("youtubeTime", 0, "0x")
	addLuaText("youtubeTime")

	makeLuaText("youtubeScore", "Score: ", 0,1100,getProperty('timeBar.y') + 10)
	setObjectCamera("youtubeScore", 'other')
	setTextFont("youtubeScore", "Roboto-Regular.ttf")
	setTextBorder("youtubeScore", 0, "0x")
	addLuaText("youtubeScore")

	makeLuaSprite("youtubebuttons", dir..'play', 15, getProperty('timeBar.y') + 12)
	setObjectCamera("youtubebuttons", 'other')
	addLuaSprite("youtubebuttons")

	addHaxeLibrary("FlxStringUtil", 'flixel.util')
	addHaxeLibrary("Math")

	
	for i = 1,5 do
		makeLuaSprite("stars"..i, dir..'stars', 910 + (i*30), getProperty('timeBar.y') + 12)
		setObjectCamera("stars"..i, 'other')
		addLuaSprite("stars"..i, true)
	end


	setProperty('stars.visible',false)
	setObjectOrder("blackscreennews", getObjectOrder("boyfriend")-3)
	setObjectOrder("newspaper", getObjectOrder("boyfriend")-2)
	setObjectOrder("titlescreen", getObjectOrder("boyfriend")-2)
	setObjectOrder("static", getObjectOrder("titlescreen")+1)




	makeLuaSprite("loadingblack")
	makeGraphic("loadingblack", screenWidth, screenHeight, '000000')
	setObjectCamera('loadingblack','other')
	addLuaSprite("loadingblack", true)

	makeAnimatedLuaSprite("loadcircle", dir..'load')
	addAnimationByPrefix("loadcircle", "i", "load", 12, true)
	playAnim("loadcircle", "i")
	scaleObject('loadcircle',0.5,0.5,true)
	screenCenter("loadcircle")
	setObjectCamera('loadcircle','other')
	addLuaSprite("loadcircle", true)
	setProperty('introSoundsSuffix','asdasd')
	
end

function onDestroy()
	runHaxeCode([[
		FlxG.mouse.visible = false;
		FlxG.mouse.useSystemCursor = false;
	]])
end

function onSongStart()
	removeLuaSprite("loadingblack", true)
	removeLuaSprite("loadcircle", true)
	startingnow = true
end

function onEvent(name, v1, v2)
	if name == 'bitebutton' then
		if v1 == 'l' then
			if v2 == 'd' then
				doTweenY("doorLdown", "doorL", 0, 0.5, "cubeout")
				--playSound("bDoordown", 1)
			else 
				doTweenY("doorLup", "doorL", -1500, 0.5, "cubeIn")
				--playSound("bDoorup", 1)
			end
			if getProperty("doorL.y") == 0 then
				setProperty('button.alpha',1)
			end

			setProperty('button.flipX',false)
			setProperty('button.x',0)
		else
			if v2 == 'd' then
				doTweenY("doorRdown", "doorR", 0, 0.5, "cubeout")
			else 
				doTweenY("doorRup", "doorR", -1500, 0.5, "cubeIn")
			end
			if getProperty("doorR.y") == 0 then
				setProperty('button.alpha',1)
			end
			setProperty('button.flipX',true)	
			setProperty('button.x',getProperty("bg.width") - getProperty("button.width"))
		end
		doorclick = false
		runTimer("doorclick", 1)

	end
	if name == 'Change Character' then

		if v2 == 'markflipped' or 'mark' then
			setObjectOrder('boyfriend',getObjectOrder('cams')+2)
			if v2 == 'markflipped' then
				doTweenX('tween2','boyfriend',1930,1,'cubeInOut')
			end
		end
		if dadName == 'freddy' then


			if v2 == 'freddy' then
				triggerEvent("Change Character", 'bf', 'mark')
				triggerEvent("Alt Idle Animation", 'BF', '-alt')
				doTweenX('tween5','boyfriend',80,1,'cubeInOut')
			end
		
			setProperty('dad.x',1720)
			setProperty('dad.y',400)
		elseif dadName == 'bonnie' then
			setProperty('dad.y',350)
		elseif dadName == 'foxy' then
			setProperty('dad.x',-800)
			setProperty('dad.y',250)
		elseif dadName == 'goldenfreddy' then
			setProperty('dad.x',450)
			setProperty('dad.y',600)
			setProperty('dad.visible',false)
		end
		if v2 == 'foxy' then
			objectPlayAnimation("dad", "jumpscare", true)
			
		end
	end

	if name == '' then
		if v1 == "lockfreddy" then
			allowedR = false
			triggerEvent("bitebutton", 'r', 'u')
		end
		if v1 == 'annotat' then
			if v2 == 's' then
				setProperty("annotationbox.alpha", 0.2)
				setProperty("creditsss.alpha", 1)

			else
				setProperty("annotationbox.alpha", 0)
				setProperty("creditsss.alpha", 0)

			end
		end
		if v1 == 'sixam' then
			sixAM()
		end
		if v1 == 'spawn' then
			objectPlayAnimation("fred", "scare", true)
			setProperty('fred.visible',true)
			setProperty('dad.visible',false)
			setProperty('camGame.visible',false)	
			setProperty('boyfriend.visible',false)
			setProperty('bg.visible',false)
			setProperty('fg.visible',false)
			if v2 == 'finale' then
				allowedL = true
				allowedR = false
			end

		elseif v1 == 'kill' then
			setProperty('fred.visible',false)
			setProperty('dad.visible',true)
			setProperty('camGame.visible',true)	
			setProperty('boyfriend.visible',true)
			setProperty('bg.visible',true)
			setProperty('fg.visible',true)

		elseif v1 == 'tween' then
			if v2 == 'fred1' then
				allowedR = false
				triggerEvent("bitebutton", 'r', 'u')
				doTweenX('tween','dad',1720,1.5,'cubeInOut')

			elseif v2 == 'fred2' then
				allowedR = true
				doTweenX('tween','dad',2500,0.3,'cubeInOut')
				triggerEvent("bitebutton", 'r', 'd')
			elseif v2 == 'bonnie2' then
				doTweenX('tween','dad',-900,0.3,'cubeInOut')
				triggerEvent("bitebutton", 'l', 'd')
			elseif v2 == 'bonnie' then
				allowedL = false
				triggerEvent("bitebutton", 'l', 'u')
				setProperty('dad.x',-800)
				doTweenX('tween3','dad',0,1,'cubeInOut')		
				--doTweenX('tween2','boyfriend',1930,1,'cubeInOut')
			end
		
		elseif v1 == 'fox' then
			doTweenAlpha('dadd','dad',0,0.7)
			-- setProperty('dad.visible',false)
			-- setProperty('boyfriend.visible',false)
			-- setProperty('bg.visible',false)
			-- setProperty('fg.visible',false)

		elseif v1 == 'foxy' then
			allowedL = false
			triggerEvent("bitebutton", 'l', 'u')
			setProperty('dad.alpha',1)
			setProperty('dad.x',-800)
			doTweenX('tween3','dad',0,0.2,'cubeInOut')	

		elseif v1 == 'screen' then
			if v2 == 'up' then
				allowedL = false
				allowedR = false
				triggerEvent("bitebutton", 'r', 'u')
				triggerEvent("bitebutton", 'l', 'u')
				doTweenAlpha('filtween','fx',1,1,'cubeInOut')
				playAnim('cams', 'flip', true)
				setProperty('cams.visible',true)
			elseif v2 == 'uploop' then
				playAnim('cams','loop',true)
				setProperty('cams.x',-190)
			elseif v2 == 'down' then
				doTweenAlpha('filtween','fx',0,1,'cubeInOut')
				setProperty('cams.x',-310)
				playAnim('cams', 'flip', true,true)
				setProperty('dad.visible',true)
			elseif v2 == 'done' then
				allowedL = true
				allowedR = true
				setProperty('cams.visible',false)
				setProperty('fx.visible',false)
			end
		end
	end
end


function onUpdate(elapsed)
	if getPropertyFromClass("Conductor", "songPosition") < 11000 and keyJustPressed('space') then
		onTimerCompleted('endintrofinally')
		runHaxeCode([[
			game.setSongTime(11000);
            game.clearNotesBefore(Conductor.songPosition);
		]])
	end

	--debugPrint(getProperty("cams.offset.x"))
	if startingnow then
		runHaxeCode([[
		var seconds = Math.floor(Conductor.songPosition / 1000);
		var length = Math.floor(FlxG.sound.music.length / 1000);
        game.getLuaObject("youtubeTime",true).text = FlxStringUtil.formatTime(seconds, false) + ' / ' + FlxStringUtil.formatTime(length, false);
        return;
		]])	
	end
	setTextString("youtubeScore", 'score: '..getProperty("songScore")..'' )

	setTextString("powerHP", getProperty("healthBar.percent"))
	setProperty('powerpercent.x',getProperty("powerHP.x") + getProperty("powerHP.width"))


	if mouseOverlaps('noseboop') and mouseClicked("") then
		playSound("bBoop", 1)
	end

	--left door allowed
	if mouseOverlaps('buttonL','game') and mousePressed("") and allowedL then
		setProperty('button.alpha',1)
		setProperty('button.flipX',false)
		setProperty('button.x',0)
		if mouseClicked() then
			changeDoorState(true)
		end
	elseif mouseOverlaps('buttonR','game') and mousePressed("") and allowedR then
		setProperty('button.alpha',1)
		setProperty('button.flipX',true)
		setProperty('button.x',getProperty('bg.width') - getProperty('button.width'))
		if mouseClicked() then
			changeDoorState(false)
		end
	elseif not allowedL and mouseClicked() and mouseOverlaps('buttonL','game') or (not allowedR and mouseClicked() and mouseOverlaps('buttonR','game')) and doorclick then
		playSound('bBlocked',0.5)
		setProperty('button.alpha',0)
	elseif doorclick then
		setProperty('button.alpha',0)
	end


	if mouseOverlap('pause','other') and mouseClicked() then
		runHaxeCode([[
			game.openPauseMenu();
		]])
	elseif mouseOverlap('skip','other') and mouseClicked() then
		if getPropertyFromClass("Conductor", "songPosition") < 11000 then
			onTimerCompleted('endintrofinally')
			runHaxeCode([[
				game.setSongTime(11000);
				game.clearNotesBefore(Conductor.songPosition);
			]])
		else
			
			runHaxeCode([[
         	   game.setSongTime(Conductor.songPosition + 10000);
        	    game.clearNotesBefore(Conductor.songPosition);
			]])
		end
	elseif mouseOverlap('sound','other') then
		if mouseClicked("") then
			setSoundVolume("", getSoundVolume('') + 0.2)
		elseif mouseClicked("right") then
			setSoundVolume("", getSoundVolume('') - 0.2)
		end

	end

	--lights
	if mouseOverlaps('lightL','game') and mousePressed() and allowedL then
		setProperty('lefthall.alpha',1)
		setProperty('buttonlight.alpha',1)
		setProperty('buttonlight.x',0)
		setProperty('buttonlight.flipX',false)

	elseif mouseOverlaps('lightR','game') and mousePressed() and allowedR then
		setProperty('righthall.alpha',1)
		setProperty('buttonlight.alpha',1)
		setProperty('buttonlight.x',getProperty('bg.width') - getProperty('buttonlight.width'))
		setProperty('buttonlight.flipX',true)




	elseif not allowedL and mouseClicked() and mouseOverlaps('lightL','game') or (not allowedR and mouseClicked() and mouseOverlaps('lightR','game')) then
		playSound('bBlocked',0.5)
	else

		setProperty('righthall.alpha',0)
		setProperty('buttonlight.alpha',0)
		setProperty('lefthall.alpha',0)
	end

	
end

function goodNoteHit(r, r2, r3, sus)
	if not sus then
		checkStars()
	end
end

function noteMissPress()
	checkStars()
end
function checkStars() 
	if rating * 100 > 90 then
		for i = 1,5 do
			setProperty('stars'..i..'.visible',true)
		end
	elseif rating * 100 > 80 then
		for i = 1,5 do
			setProperty('stars'..i..'.visible',true)
		end
		setProperty('stars5.visible',false)
	elseif rating * 100 > 70 then
		for i = 1,5 do
			setProperty('stars'..i..'.visible',true)
		end
		setProperty('stars4.visible',false)
		setProperty('stars5.visible',false)
	elseif rating * 100 > 60 then
		for i = 1,5 do
			setProperty('stars'..i..'.visible',false)
		end
		setProperty('stars1.visible',true)
		setProperty('stars2.visible',true)
	elseif rating * 100 > 50 then
		for i = 1,5 do
			setProperty('stars'..i..'.visible',false)
		end
		setProperty('stars1.visible',true)
	end
end

function changeDoorState(val) 

	if val then
		cancelTween("doorLup")
		cancelTween("doorLdown")
		doorLactive = not doorLactive
		if doorLactive then
			playSound('bDoordown',0.25)
			doTweenY("doorLdown", "doorL", 0, 0.5, "cubeout")
		else
			playSound('bDoorup',0.25)
			doTweenY("doorLup", "doorL", -1500, 0.5, "cubeIn")
		end
		
	else
		cancelTween("doorRup")
		cancelTween("doorRdown")
		doorRactive = not doorRactive
		if doorRactive then
			playSound('bDoordown',0.25)
			doTweenY("doorRdown", "doorR", 0, 0.5, "cubeout")
		else
			playSound('bDoorup',0.25)
			doTweenY("doorRup", "doorR", -1500, 0.5, "cubeIn")
		end


	end
end

function sixAM()
	makeLuaSprite("blacksixam")
	makeGraphic("blacksixam", 3000, 2500, '000000')
	addLuaSprite('blacksixam',true)
	setProperty("blacksixam.alpha", 0)
	setScrollFactor("blacksixam", 0.0, 0.0)
	screenCenter("blacksixam", 'xy')

	makeLuaText("five", "5")
	setTextSize("five", 62)
	setObjectCamera("five", 'other')
	setTextFont("five", "bite.ttf")
	setTextBorder("five", 0, "0x")
	addLuaText("five",true)
	screenCenter("five", 'xy')
	setProperty('five.x', getProperty('five.x') - getProperty('five.width')/2)
	setScrollFactor("five", 0.0, 0.0)

	makeLuaText("six", "6")
	setTextSize("six", 62)
	setObjectCamera("six", 'other')
	setTextFont("six", "bite.ttf")
	setTextBorder("six", 0, "0x")
	addLuaText("six",true)
	screenCenter("six", 'xy')
	setProperty('six.x', getProperty('six.x') - getProperty('six.width')/2)
	setProperty('six.y', getProperty('six.y') + 70)
	setScrollFactor("six", 0.0, 0.0)

	makeLuaText("sixam", "AM")
	setTextSize("sixam", 62)
	setObjectCamera("sixam", 'other')
	setTextFont("sixam", "bite.ttf")
	setTextBorder("sixam", 0, "0x")
	addLuaText("sixam",true)
	screenCenter("sixam", 'xy')
	setProperty('sixam.x', getProperty('sixam.x') + getProperty('sixam.width')/2)
	setScrollFactor("sixam", 0.0, 0.0)

	makeLuaSprite("topsix",'',getProperty('six.x'),getProperty('six.y') - 165)
	makeGraphic("topsix", getProperty('six.width'), getProperty('six.height'), '000000')
	addLuaSprite('topsix',true)
	setObjectCamera("topsix", 'other')
	setScrollFactor("topsix", 0.0, 0.0)

	makeLuaSprite("bottomsix",'',getProperty('six.x'),getProperty('six.y')+30)
	makeGraphic("bottomsix", getProperty('six.width'), getProperty('six.height') -20, '000000')
	addLuaSprite('bottomsix',true)
	setObjectCamera("bottomsix", 'other')
	setScrollFactor("bottomsix", 0.0, 0.0)

	doTweenAlpha('youwin','blacksixam',1,1.5)
	doTweenAlpha('youwin2','five',1,1.5)
	doTweenAlpha('youwin3','sixam',1,1.5)
	doTweenAlpha('youwin4','camHUD',0,1.5)

	setProperty('five.alpha',0)
	setProperty('six.alpha',0)
	setProperty('sixam.alpha',0)
	setProperty('topsix.alpha',0)
	setProperty('bottomsix.alpha',0)

end


function onTweenCompleted(r)

	if r == 'youwin' then
		setProperty('six.alpha',1)
		setProperty('topsix.alpha',1)
		setProperty('bottomsix.alpha',1)
		doTweenY("up6", "six", getProperty('five.y'), 4)
		doTweenY("up5", "five", getProperty('five.y') - 70, 4)
	end
end


function onGameOverStart()
	setProperty("boyfriend.visible",false)
	playSound('bitedeath',1)
	makeAnimatedLuaSprite('freddie', dir..'freddyjump', 0, 100)
	addAnimationByPrefix('freddie','scare','FredJUMPSCARE')
	addAnimationByIndicesLoop("freddie", "wiggle", "FredJUMPSCARE", "47,48,49,50,51,52,53", 24)
	playAnim("freddie", "wiggle", true)
	addLuaSprite('freddie',true)
	setGraphicSize("freddie", 1280, 720, true)
	setScrollFactor("freddie", 0.0, 0.0)
	setProperty('freddie.visible',false)

	setPropertyFromClass('flixel.FlxG', 'camera.x', 0)
	setPropertyFromClass('flixel.FlxG', 'camera.y', 0)
	setPropertyFromClass('flixel.FlxG', 'camera.zoom', 1)
	
	makeAnimatedLuaSprite('static', 'stage/terminated/static', 310, 170);
	setProperty('static.antialiasing', false)
	addAnimationByPrefix('static', 'static', 'static', 30, true)
	objectPlayAnimation('static', 'static', true)
	setScrollFactor('static', 0, 0)
	scaleObject('static', 3, 3)
	updateHitbox('static')
	setProperty('static.alpha', 0)
	setObjectCamera('static', 'camOther')
	screenCenter('static')
	addLuaSprite('static', true);

	runTimer('startGO',1.65)
	runTimer('static', 2.45)
	runTimer('endgameover', 5)
end

function onTimerCompleted(r)
	if r == 'static' then
		setProperty('static.alpha', 1)
	end
	
	if r == 'endgameover' then
		restartSong();
	end
	
	if r == 'endintrofinally' then
		cancelTimer("byebyenews")
		cancelTimer("endintro")
		cancelTimer("byebyenews")
		cancelTween("byebyenews")

		setProperty('blackscreennews.alpha',0)
		setProperty('12am.alpha',0)
		setProperty('newspaper.alpha',0)
		setProperty('titlescreen.alpha',0)
		setProperty('static.alpha',0)

		setProperty('power.alpha',1)	
		setProperty('powerHP.alpha',1)	
		setProperty('powerpercent.alpha',1)	
		cameraFlash("camGame", "ffffff", 0.5)
	end
	if r == 'byebyenews' then
		doTweenAlpha('byebyenews','newspaper',0,2)
		doTweenAlpha('12amfsd','12am',1,2)
		runTimer('endintrofinally',4)
	end
	if r == 'endintro' then
		runHaxeCode([[
			game.getLuaObject("static",false).animation.pause();
		]])
		doTweenAlpha('staticgo','static',0,2)
		doTweenAlpha('titlego','titlescreen',0,2)	
		runTimer('byebyenews',5)
	end
	if r == 'midGO' then
		playAnim('freddie','wiggle')
	end
	if r == 'startGO' then
		--addAnimationByPrefix('freddie','scare','FredJUMPSCARE')
		playAnim('freddie','scare')
		setProperty('freddie.visible',true)
		runTimer('midGO',0.55)
	end
	if r == 'doorclick' then
		doorclick = true
		setProperty('button.alpha',0)
	end
	
end
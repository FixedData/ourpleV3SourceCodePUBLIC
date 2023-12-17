_G.alive = true
spitehp = {}
spitegroup = {}
stunholder = {}
counter = 4
spitealive = {}
spiteOgX = {}
--i love tables
curType = ''
default = true
curFlashbackF = 1
bannedAnims = {'singUP', 'singDOWN', 'singLEFT', 'singRIGHT', 'die', 'idle-dead'}
listHealing = {'dee','peter','steven','gf','blackjack'}
listAttacking = {'dee','peter','steven','gf','boyfriend'}
bjDefY = 0
introDone = false
local timetolose = false;
function onCreate() 
	precacheImage('spite/hit')
	precacheImage('stage/miller/heal')
	precacheImage('stage/miller/flashbacks')
	precacheImage('stage/miller/millerint')
	setProperty('camZooming', true)
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'horn')
	
	setObjectOrder('dadGroup', getObjectOrder('dadGroup') + 2)
	setObjectOrder('gfGroup', getObjectOrder('gfGroup') + 2)
	
	makeLuaSprite('void','stage/miller/flesh', 605, 3881)
	addLuaSprite('void', false)
	
	makeAnimatedLuaSprite('blackjack', 'stage/miller/dogn', 4500.55, 4500.55);
	bjDefY = getProperty('blackjack.y')
	addAnimationByPrefix('blackjack', 'dance', 'i', 30, false);
	addAnimationByPrefix('blackjack', 'die', 'die', 30, false);
	scaleObject('blackjack',4,4)
	updateHitbox('blackjack')
	setProperty('blackjack.antialiasing',false)
	objectPlayAnimation('blackjack', 'dance', true);
	doTweenY('floatUp', 'blackjack', getProperty('blackjack.y') - 150, 2, 'sineInOut')
	
	addLuaSprite('blackjack', true)
	
	makeLuaSprite('spite1', 'spite/spite1', 2436.65, 5212.2); --bottom right
	addLuaSprite('spite1', true)
	spitegroup[1] = getProperty('spite1')
	stunholder[1] = false
	spitealive[1] = true
	spitehp[1] = 100
	spiteOgX[1] = getProperty('spite1.x')
	
	makeLuaSprite('spite2', 'spite/spite2', 2210.05, 4413.45); --upper right
	addLuaSprite('spite2', true)
	spitegroup[2] = getProperty('spite2')
	stunholder[2] = false
	spitealive[2] = true
	spitehp[2] = 100
	spiteOgX[2] = getProperty('spite2.x')
	
	makeLuaSprite('spite3', 'spite/spite3', 1542.55, 5224.85); --bottom left
	addLuaSprite('spite3', true)
	spitegroup[3] = getProperty('spite3')
	stunholder[3] = false
	spitealive[3] = true
	spitehp[3] = 100
	spiteOgX[3] = getProperty('spite3.x')
	
	makeLuaSprite('spite4', 'spite/spite4', 1572.2, 4519.8); --upper left
	addLuaSprite('spite4', true)
	spitegroup[4] = getProperty('spite4')
	stunholder[4] = false
	spitealive[4] = true
	spitehp[4] = 100
	spiteOgX[4] = getProperty('spite4.x')
	
	makeLuaText('WEAKENED', 'WEAKENED!', 305, (getPropertyFromClass('flixel.FlxG', 'width') * 0.39), (getPropertyFromClass('flixel.FlxG', 'height') * 0.75))
	setTextAlignment('WEAKENED', 'center')
	setProperty('WEAKENED.alpha', 0)
	setTextSize('WEAKENED', 50)
	setTextBorder('WEAKENED', 2, 'FFFFFF')
	setTextColor('WEAKENED', 'D60A0A')
	--setTextFont('WEAKENED', 'Arial Narrow')
	setTextItalic('WEAKENED', true)
	addLuaText('WEAKENED')
	
	for i,object in pairs(spitegroup) do
		doTweenY('floatDownS'..i, object, getProperty(object..'.y') + 150, 2 + i/100, 'sineInOut')
	end
	
	makeLuaSprite('barup','',-34.95,-160.95)
	makeGraphic('barup',1348.9,281,'000000')
	addLuaSprite('barup',true)
    setScrollFactor('barup',0,0)
    setObjectCamera('barup','hud')

	makeLuaSprite('bardown','',-26,630.45)
	makeGraphic('bardown',1348.9,281,'000000')
	addLuaSprite('bardown',true)
    setScrollFactor('bardown',0,0)
    setObjectCamera('bardown','hud')
	
	makeLuaSprite('black','', -1500, -1500)
	makeGraphic('black', 5000, 5000, '000000')
	addLuaSprite('black', true)
    setScrollFactor('black',0,0)
    --setObjectCamera('black','other')
	setProperty('camHUD.alpha', 0)
	
	makeAnimatedLuaSprite('flashbacks', 'stage/miller/flashbacks', 0, 0);
	for i=1, 12 do
		addAnimationByPrefix('flashbacks', tostring(i), tostring(i)..'0000', 0, false);
	end
	objectPlayAnimation('flashbacks', '1', true);
	setObjectCamera('flashbacks', 'other')
	scaleObject('flashbacks', 0.8, 0.8)
	screenCenter('flashbacks')
	setProperty('flashbacks.alpha', 0)
	setProperty('flashbacks.antialiasing', false)
	addLuaSprite('flashbacks', true)
	
	makeAnimatedLuaSprite('millerint', 'stage/miller/millerint', 0, 0);
	addAnimationByPrefix('millerint', 'int', 'millerint', 30, false);
	setObjectCamera('millerint', 'hud')
	screenCenter('millerint')
	setProperty('millerint.antialiasing', false)
	setProperty('millerint.visible', false)
	addLuaSprite('millerint', true)
	
	makeLuaSprite('hint','spite/hint', 0, 525)
	setProperty('hint.antialiasing', false)
	scaleObject('hint', 3,3)
	updateHitbox('hint')
	screenCenter('hint','x')
	setObjectCamera('hint', 'other')
	--setProperty('hint.y', getProperty('hint.y')+180)
	setProperty('hint.origin.y', 200)
	setProperty('hint.angle', -120) --194 y
	addLuaSprite('hint', true)
	--debugPrint(getProperty('hint.y'), '', '', '', '')
	
	makeLuaSprite('THX','stage/miller/ty', 0, 0)
	setProperty('THX.antialiasing', false)
	-- scaleObject('THX', 0.49, 0.49)
	setGraphicSize("THX", 1280, 0, true)
	updateHitbox('THX')
	screenCenter('THX')
	setObjectCamera('THX', 'other')
	setProperty('THX.alpha', 0)
	addLuaSprite('THX', true)

	makeAnimatedLuaSprite('goodend','stage/miller/goodend')
	addAnimationByPrefix("goodend", "1", "1")
	addAnimationByPrefix("goodend", "2", "2")
	addAnimationByPrefix("goodend", "3", "3")
	addAnimationByPrefix("goodend", "4", "4")
	addAnimationByPrefix("goodend", "5", "5")
	setObjectCamera('goodend', 'other')
	setProperty('goodend.antialiasing',false)
	setProperty('goodend.alpha', 0)
	setGraphicSize("goodend", 1280, 720, true)
	addLuaSprite('goodend', true)

	makeAnimatedLuaSprite('badend','stage/miller/badend')
	addAnimationByPrefix("badend", "1", "i",10)
	setObjectCamera('badend', 'other')
	setProperty('badend.antialiasing',false)
	setProperty('badend.alpha', 0)
	addLuaSprite('badend', true)
	setGraphicSize("badend", 0, 720, true)
	screenCenter('badend')

	makeLuaSprite('NOTHX','stage/miller/noty', 0, 0)
	setProperty('NOTHX.antialiasing', false)
	scaleObject('NOTHX', 1.8, 1.8)
	updateHitbox('NOTHX')
	screenCenter('NOTHX')
	setObjectCamera('NOTHX', 'other')
	setProperty('NOTHX.alpha', 0)
	addLuaSprite('NOTHX', true)
	setProperty('NOTHX.alpha',0)
	setProperty('NOTHX.y',150)
end

function onCreatePost()
	duration = getPropertyFromClass('Conductor', 'stepCrochet') * 8 / 1000
	setProperty('henrylip.x', getProperty('dad.x')-400)
	setProperty('henrylip.y', getProperty('dad.y')-130)
	--setProperty('playbackRate',0.5)
end

function onGameOverStart()
	setPropertyFromClass('flixel.FlxG', 'camera.x', 0)
	setPropertyFromClass('flixel.FlxG', 'camera.y', 0)
	setProperty('boyfriend.visible', false)
	
	makeLuaSprite('usuck','gameovers/usuck', 0, 0)
	setProperty('usuck.antialiasing', false)
	setScrollFactor('usuck', 0, 0)
	scaleObject('usuck', 5, 5)
	updateHitbox('usuck')
	screenCenter('usuck')
	addLuaSprite('usuck', true)
	return Function_Continue;
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
	if getProperty('health') > 0.2 then
		if counter > 0 then
			damage = counter * 1.7 / 100
			setProperty('health', (getProperty('health')) - damage)
		end
	end
end

function onTweenCompleted(tag)
	if _G.alive == true then
		if tag == 'floatDown' then
			doTweenY('floatUp', 'blackjack', getProperty('blackjack.y') - 150, duration, 'sineInOut')
		end
		
		if tag == 'floatUp' then
			doTweenY('floatDown', 'blackjack', getProperty('blackjack.y') + 150, duration, 'sineInOut')
		end
	end
	for i,object in pairs(spitegroup) do
	
		if stunholder[i] == false and spitehp[i] > 0 and object ~= nil then
			if tag == 'floatDownS'..i then
				doTweenY('floatUpS'..i, object, getProperty(object..'.y') - 150, 2 + i/100, 'sineInOut')
			end
			
			if tag == 'floatUpS'..i then
				doTweenY('floatDownS'..i, object, getProperty(object..'.y') + 150, 2 + i/100, 'sineInOut')
			end
		end
		
		if object ~= nil then
			if tag == 'knockbackS'..i then
				if spitehp[i] < 1 then
					doTweenAlpha('fadeS'..i, object, 0, 0.2, 'sineIn')
				else
					doTweenX('moveBackS'..i, object, spiteOgX[i], 0.2, 'sineIn')
				end
			end
			
			if tag == 'fadeS'..i then
				removeLuaSprite(object)
			end
		end
	end
	
	for i,object in pairs(listHealing) do
		if tag == 'fadeHeal'..i then
			removeLuaSprite('healFX'..i)
		end
	end
	
	if tag == 'raiseHint2' then
		removeLuaSprite('hint')
	end
end

function onEvent(n,v1,v2)
	if n == 'millerEnding' then

		ending = ''
		if (counter == 0) then
		ending = 'goodend'
		else
		ending = 'badend'
		end
		--ending = 'goodend'
		--debugPrint(ending, '', '', '', '')
		if ending == 'badend' then
			setProperty("camHUD.alpha", 0)
			setProperty("camHUD.x", 3000)
			--setProperty(''..ending..'.alpha', v1)
			setProperty('THX.visible',false)	
			runTimer('startlose',0.5)

		end


		if ending == 'goodend' then
			setProperty("camHUD.alpha", 0)
			setProperty(''..ending..'.alpha', 1)	
			cameraFlash("other", "0xFFFFFFFF", 0.25,true)
			objectPlayAnimation(ending, v2, true)
			setProperty('NOTHX.visible',false)
		end
		if tostring(v2) == '5' then
			setProperty("camHUD.alpha", 1)
			doTweenAlpha("goodendbye", "goodend", 0, 0.5, "linear")
		end
			
	end

	if n == 'All Sing' then
		triggerEvent('Play Animation', 'singUP', 'gf')
		triggerEvent('Object Play Animation', 'dee', 'singUP')
		triggerEvent('Object Play Animation', 'peter', 'singUP')
		triggerEvent('Object Play Animation', 'steven', 'singUP')
	end
	if n == 'Object Play Animation' then
		if v2 == 'die' then
			if v1 == 'blackjack' then
				_G.alive = false
			end
		end
	end
	
	if n == 'Object Play Animation' then
		if v2 == 'dance' then
			if v1 == 'blackjack' then
				_G.alive = true
				setProperty('blackjack.y', bjDefY)
				doTweenY('floatDown', 'blackjack', getProperty('blackjack.y') + 150, 2, 'sineInOut')
				for i,object in pairs(listHealing) do
					sprName = 'healFX'..i
					local ofsX = 500
					local ofsY = 400
					if i == 4 then
						ofsX = 700
					elseif i == 1 then
						ofsY = 700
						ofsX = 600
					elseif i == 2 or i == 3 then
						ofsY = 600
						ofsX = 570
					end
					makeAnimatedLuaSprite(sprName, 'stage/miller/heal', getMidpointX(object)-ofsX, getMidpointY(object)-ofsY)
					addAnimationByPrefix(sprName, 'hit', 'heal', 33, false)
					objectPlayAnimation(sprName, 'hit', true)
					scaleObject(sprName, 5, 5)
					updateHitbox(sprName)
					setProperty(sprName..'.antialiasing', false)
					addLuaSprite(sprName, true)
					doTweenAlpha('fadeHeal'..i, sprName, 0, 1.2, 'sineIn')
				end
			end
		end
	end
	
	if n == 'Set Note Type' then
		curType = v1
		if curType == 'bf' or curType == 'BF' then
			curType = ''
		end
		if curType == '' or curType == 'GF Sing' then
			default = true
		else
			default = false
		end
	end
	
	if n == 'Add Alpha' and v1 == 'flashbacks' then
		objectPlayAnimation('flashbacks', tostring(curFlashbackF), true)
		curFlashbackF = curFlashbackF + 1
	end
	
	if n == 'Play Animation' and (v1 == 'singDOWN' or v1 == 'singUP' or v1 == 'singLEFT' or v1 == 'singRIGHT') and v2 == 'gf' then
		setProperty('gf.holdTimer', 0)
	end
	
	if n == 'Alter Visibility' and v1 == 'millerint' and v2 == 'false' then
		removeLuaSprite('millerint')
		removeLuaSprite('flashbacks')
		removeLuaSprite('black')
		introDone = true
		setProperty('camHUD.visible', true)
	end
	
	if n == 'Alter Visibility' and v1 == 'hint' and v2 == 'true' then
		doTweenY('raiseHint', 'hint', 284, 0.7, 'cubeOut')
		doTweenAngle("asd", "hint", 0, 1.5, 'backout') --194 y
		runTimer('flyHint', 2.5)
	end

end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'startlose' then
		timetolose = true;
	end
	if tag == 'yar' then
		--endSong()
	end
	if tag == 'flyHint' then
		doTweenY('raiseHint3', 'hint', 900, 2, 'sineinout')
		doTweenAngle("raiseHint2", "hint", -20, 3, 'backinout') --194 y
		--doTweenY('raiseHint2', 'hint', getProperty('hint.y')-500, 0.75, 'cubeIn')
	end
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
	if noteType == 'Spite Note' then
		repeat
			index = math.random(1,4) 
		until spitealive[index] == true
		
		spitehp[index] = spitehp[index] - 8

		if spitealive[index] == true and spitehp[index] < 1 then
			finalHit(index)
		end
		
		for i,object in pairs(spitegroup) do
			if i == index then
				doTweenX('knockbackS'..i, object, getProperty(object..'.x') - 150, 0.2, 'cubeOut')
				
				makeAnimatedLuaSprite('hitFX'..i, 'spite/hit', getMidpointX(object)-500, getMidpointY(object)-500)
				addAnimationByPrefix('hitFX'..i, 'hit', 'hit', 30, false) 
				objectPlayAnimation('hitFX'..i, 'hit', true)
				scaleObject('hitFX'..i, 5, 5)
				updateHitbox('hitFX'..i)
				setProperty('hitFX'..i..'.antialiasing', false)
				addLuaSprite('hitFX'..i, true)
			end
		end
		playSound('dmg-spite', 0.15)
		--[[local charPick = math.random(1,5)
		local charName = listAttacking[charPick] 
		local animName = getProperty(charName..'.animation.name')
		repeat
			charPick = math.random(1,5) 
			charName = listAttacking[charPick] 
			animName = getProperty(charName..'.animation.name')
		until animName == 'idle' or string.sub(getProperty(animName),1,5) == 'dance'
		
		if animName == 'idle' or string.sub(getProperty(animName),1,5) == 'dance' then
			playHitAnim(charName)
		end--]]
	end
end

function finalHit(index)
	cancelTween('Fall')
	cancelTween('FallX')
	cancelTween('Bounce')
	cancelTween('BounceX')
	setProperty('WEAKENED.y', (getPropertyFromClass('flixel.FlxG', 'height') * 0.75))
	setProperty('WEAKENED.x', (getPropertyFromClass('flixel.FlxG', 'width') * 0.39))
	setProperty('WEAKENED.alpha', 1)
	doTweenY('Bounce', 'WEAKENED', getProperty('WEAKENED.y') - 20, 1, 'sineOut')
	doTweenX('BounceX', 'WEAKENED', getProperty('WEAKENED.x') + 30, 1, 'sineOut')
	spitealive[index] = false
	counter = counter - 1
end

function onUpdate(elapsed)
	if getPropertyFromClass("Conductor", "songPosition") < 34000  and keyJustPressed('space')then
		runHaxeCode([[
			game.setSongTime(34000);
            game.clearNotesBefore(Conductor.songPosition);
		]])
	end

	if timetolose then
		--setPropertyFromClass('flixel.FlxG', 'sound.music.pitch', getPropertyFromClass('flixel.FlxG', 'sound.music.pitch') - 0.005 * (elapsed/(1/60)))
		setProperty('badend.alpha', getProperty("badend.alpha") + 0.002 * (elapsed/(1/60)))
		setProperty('NOTHX.alpha', getProperty("NOTHX.alpha") + 0.002 * (elapsed/(1/60)))
		setProperty('playbackRate', getProperty("playbackRate") - 0.0025 * (elapsed/(1/60)))
		--setProperty('playbackRate', getProperty("playbackRate") - 0.005 * (elapsed/(1/60)))
		setPropertyFromClass('flixel.FlxG', 'sound.music.volume', getPropertyFromClass('flixel.FlxG', 'sound.music.volume') - 0.005 * (elapsed/(1/60)))
	end
	if getPropertyFromClass('flixel.FlxG', 'sound.music.volume') <= 0 and timetolose then
		timetolose = false
		endSong()
	end
	if getProperty('WEAKENED.alpha') > 0 then
		setProperty('WEAKENED.alpha', getProperty('WEAKENED.alpha') - 0.005)
	end
	
	for i=1, 4 do
		if getProperty('hitFX'..i..'.animation.curAnim.finished') then
			removeLuaSprite('hitFX'..i)
		end
	end
	
	for i = 0, getProperty('notes.length')-1 do
		if counter == 0 and 
			getPropertyFromGroup('notes', i, 'noteType') == 'Spite Note' then
				--debugPrint('removed spite note'..tostring(getPropertyFromGroup('notes', i, 'noteData') + 1))
				removeFromGroup('notes', i)
		end
		
		if getPropertyFromGroup('notes', i, 'mustPress') and getPropertyFromGroup('notes', i, 'noteType') ~= 'Spite Note' then
			setPropertyFromGroup('notes', i, 'noteType', curType)
			if curType == 'GF Sing' then
				setPropertyFromGroup('notes', i, 'gfNote', true)
			else
				setPropertyFromGroup('notes', i, 'gfNote', false)
			end
			if not default then
				setPropertyFromGroup('notes', i, 'noAnimation', true)
				setProperty('boyfriend.hasMissAnimations', false)
			else
				setPropertyFromGroup('notes', i, 'noAnimation', false)
				setProperty('boyfriend.hasMissAnimations', true)
			end
		end
	end

	if mustHitSection == false then
		setProperty('defaultCamZoom', 0.45)
	else
		setProperty('defaultCamZoom', 0.3)
	end
	
	if introDone == false then
		if getProperty('flashbacks.alpha') > 0 then
			setProperty('flashbacks.alpha', getProperty('flashbacks.alpha') - 0.6 * elapsed)
			setProperty('flashbacks.scale.x', getProperty('flashbacks.scale.x') + 0.1 * elapsed)
			setProperty('flashbacks.scale.y', getProperty('flashbacks.scale.y') + 0.1 * elapsed)
		else
			setProperty('flashbacks.scale.x', 1.4)
			setProperty('flashbacks.scale.y', 1.4)
		end
	end
	
	if getProperty('THX.alpha') > 0 then
		setProperty('THX.scale.x', getProperty('THX.scale.x') - 0.005 * elapsed)
		setProperty('THX.scale.y', getProperty('THX.scale.y') - 0.005 * elapsed)
	end
end 
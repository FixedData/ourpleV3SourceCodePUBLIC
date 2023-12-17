
function onCreate()
	precacheImage('stage/stage0/gangnam')
	setPropertyFromClass('GameOverSubstate', 'endSoundName', '')
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', '')
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'wind')
	setPropertyFromClass('GameOverSubstate', 'characterName', 'fredbear')
	makeLuaSprite('bg', 'stage/stage0/stage', 0, 0);
	setProperty('bg.antialiasing', false)
	addLuaSprite('bg', false);
	
	makeAnimatedLuaSprite('kid1', 'stage/stage0/kid', 355, 280);
	setProperty('kid1.antialiasing', false)
	addAnimationByPrefix('kid1', 'cheer', 'cheer', 30, true)
	objectPlayAnimation('kid1', 'cheer', true)
	addLuaSprite('kid1', false);
	
	makeAnimatedLuaSprite('kid2', 'stage/stage0/kid', 452, 280);
	setProperty('kid2.antialiasing', false)
	addAnimationByPrefix('kid2', 'cheer', 'cheer', 30, true)
	objectPlayAnimation('kid2', 'cheer', true)
	addLuaSprite('kid2', false);
	
	makeAnimatedLuaSprite('gangnam1', 'stage/stage0/gangnam', 315, 257);
	setProperty('gangnam1.antialiasing', false)
	setProperty('gangnam1.visible', false)
	addAnimationByIndices('gangnam1', 'dL', 'danceLeft', "9, 10, 11, 12, 13, 0, 1, 2, 3, 4, 5, 6, 7, 8", 30)
	addAnimationByIndices('gangnam1', 'dR', 'danceRight', "9, 10, 11, 12, 13, 0, 1, 2, 3, 4, 5, 6, 7, 8", 30)
	addAnimationByIndices('gangnam1', 'adR', 'adanceRight', "9, 10, 11, 12, 13, 0, 1, 2, 3, 4, 5, 6, 7, 8", 30)
	addAnimationByIndices('gangnam1', 'adL', 'adanceLeft', "9, 10, 11, 12, 13, 0, 1, 2, 3, 4, 5, 6, 7, 8", 30)
	addLuaSprite('gangnam1', false);
	
	makeAnimatedLuaSprite('gangnam2', 'stage/stage0/gangnam', 415, 257);
	setProperty('gangnam2.antialiasing', false)
	setProperty('gangnam2.visible', false)
	addAnimationByIndices('gangnam2', 'dL', 'danceLeft', "9, 10, 11, 12, 13, 0, 1, 2, 3, 4, 5, 6, 7, 8", 28)
	addAnimationByIndices('gangnam2', 'dR', 'danceRight', "9, 10, 11, 12, 13, 0, 1, 2, 3, 4, 5, 6, 7, 8", 30)
	addAnimationByIndices('gangnam2', 'adR', 'adanceRight', "9, 10, 11, 12, 13, 0, 1, 2, 3, 4, 5, 6, 7, 8", 27)
	addAnimationByIndices('gangnam2', 'adL', 'adanceLeft', "9, 10, 11, 12, 13, 0, 1, 2, 3, 4, 5, 6, 7, 8", 29)
	objectPlayAnimation('gangnam1', 'dR', true)
	objectPlayAnimation('gangnam2', 'dR', true)
	addLuaSprite('gangnam2', false);
end

function onGameOverStart()
	-- You died! Called every single frame your health is lower (or equal to) zero
	--return Function_Stop
	setScrollFactor(getPropertyFromClass('GameOverSubstate', 'boyfriend'), 0, 0)
	setPropertyFromClass('flixel.FlxG', 'camera.x', 0)
	setPropertyFromClass('flixel.FlxG', 'camera.y', 0)
	setPropertyFromClass('flixel.FlxG', 'camera.zoom', 1.2)
	setProperty('boyfriend.x', 0)
	setProperty('boyfriend.y', 0)
	setProperty('boyfriend.alpha', 0)
	doTweenAlpha('fadeIn', 'boyfriend', 1, 3, 'sineIn')
	--objectPlayAnimation('boyfriend', 'die', true)
	return Function_Continue;
end

index = 0
right = true
prefix = ''
function onBeatHit()
	index = index + 1
	if index > 4 then index = 1 end
	if index > 2 then prefix = 'a' else prefix = '' end
	right = not right
	if right then
		objectPlayAnimation('gangnam1', prefix..'dR', true)
		objectPlayAnimation('gangnam2', prefix..'dR', true)
	else
		objectPlayAnimation('gangnam1', prefix..'dL', true)
		objectPlayAnimation('gangnam2', prefix..'dL', true)
	end
end
function onCreate()
	setPropertyFromClass('GameOverSubstate', 'characterName', 'jka')
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'crushed')
	
	makeLuaSprite('ground', 'stage/ngt/bg', 0, 0);
	setProperty('ground.antialiasing', false)
	addLuaSprite('ground', false);
	scaleObject('ground', 0.8, 0.8)
	
	makeLuaSprite('trees', 'stage/ngt/front', 80, -40);
	setProperty('trees.antialiasing', false)
	setScrollFactor('trees', 1.2, 1.2)
	scaleObject('trees', 0.8, 0.8)
	addLuaSprite('trees', true);
	
	makeAnimatedLuaSprite('val', 'stage/ngt/val', 171, 0);
	setProperty('val.antialiasing', false)
	addAnimationByIndices('val', 'enter', 'val', '1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27', 26)
	addAnimationByIndicesLoop('val', 'loop', 'val', '28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48', 30)
	addAnimationByIndices('val', 'end', 'val', '49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110', 30)
	objectPlayAnimation('val', 'enter', true)
	setProperty('val.visible', false)
	addLuaSprite('val', false);
end

function onEvent(n, v1, v2)
	if n == 'Alter Visibility' and v1 == 'val' and v2 == 'true' then
		setProperty('isCameraOnForcedPos', true)
		doTweenZoom('zoomIn', 'camGame', 2.7, 3.25, 'cubeInOut')
		setProperty('defaultCamZoom', 2.7)
		doTweenX('camFollowPosx', 'camFollowPos', getMidpointX('val') - 35, 3, 'cubeInOut')
		doTweenY('camFollowPosY', 'camFollowPos', getMidpointY('val') + 15, 3, 'cubeInOut')
		setProperty('camFollow.x', getMidpointX('val') - 35)
		setProperty('camFollow.y', getMidpointY('val') + 15)
	end
	
	if n == 'endingngt' then
		setProperty('camGame.zoom', 4)
		doTweenZoom('zoomIn', 'camGame', 3, 2, 'sineInOut')
		setProperty('defaultCamZoom', 3)
	end
end
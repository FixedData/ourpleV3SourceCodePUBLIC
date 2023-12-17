ongoing = false
function onCreate()
	setPropertyFromClass('GameOverSubstate', 'characterName', 'bf_ourple')
	addCharacterToList('prangealt', 'dad')
	addCharacterToList('bfalt', 'boyfriend')
	makeLuaSprite('bg', 'stage/midnight/back', 0, 0);
	setProperty('bg.antialiasing', false)
	scaleObject('bg', 1.25, 1.25);
	updateHitbox('bg')
	setScrollFactor('bg', 0.85, 0.85)
	addLuaSprite('bg', false);
	
	makeLuaSprite('front', 'stage/midnight/front', 0, 0);
	setProperty('front.antialiasing', false)
	scaleObject('front', 1.25, 1.25);
	updateHitbox('front')
	addLuaSprite('front', false);
	
	makeAnimatedLuaSprite('lime', 'stage/midnight/lime', 457, 252);
	setProperty('lime.antialiasing', false)
	addAnimationByPrefix('lime', 'lime', 'lime', 30, false)
	objectPlayAnimation('lime', 'lime', true)
	setProperty('lime.visible', false)
	updateHitbox('lime')
	addLuaSprite('lime', false);
	
	makeAnimatedLuaSprite('sparkle', 'stage/midnight/sparkle', 206 - 50, 273 - 50);
	setProperty('sparkle.antialiasing', false)
	addAnimationByPrefix('sparkle', 'sparkle', 'sparkle', 30, true)
	objectPlayAnimation('sparkle', 'sparkle', true)
	setProperty('sparkle.visible', false)
	addLuaSprite('sparkle', true);
	
	makeAnimatedLuaSprite('rainback', 'stage/midnight/rain', getMidpointX('front')-350, 60);
	setProperty('rainback.antialiasing', false)
	addAnimationByPrefix('rainback', 'rain', 'rain', 30, true)
	objectPlayAnimation('rainback', 'rain', true)
	scaleObject('rainback', 1.25, 1.25);
	setBlendMode('rainback', 'add')
	setProperty('rainback.alpha', 0.15)
	addLuaSprite('rainback', true);
	
	makeLuaSprite('black','', 100,0)
	makeGraphic('black', 900, 900,'0xFF000000')
	addLuaSprite('black',true)
    setScrollFactor('black',0,0)
	
	makeLuaSprite('spotlight1', 'stage/midnight/spotlight', 145, -15);
	setProperty('spotlight1.antialiasing', false)
	setBlendMode('spotlight1', 'add')
	setProperty('spotlight1.alpha', 0)
	addLuaSprite('spotlight1', true);
	
	makeLuaSprite('spotlight2', 'stage/midnight/spotlight', 464, -15);
	setProperty('spotlight2.antialiasing', false)
	setBlendMode('spotlight2', 'add')
	setProperty('spotlight2.alpha', 0)
	addLuaSprite('spotlight2', true);
	
	makeLuaSprite('trees', 'stage/midnight/trees', -100, 0);
	setProperty('trees.antialiasing', false)
	scaleObject('trees', 1.25, 1.25);
	updateHitbox('trees')
	setProperty('trees.alpha', 0)
	setScrollFactor('trees', 1.4, 1.4)
	addLuaSprite('trees', true);
	
	makeAnimatedLuaSprite('rain', 'stage/midnight/rain', getMidpointX('front')-500, 60);
	setProperty('rain.antialiasing', false)
	addAnimationByPrefix('rain', 'rain', 'rain', 40, true)
	objectPlayAnimation('rain', 'rain', true)
	scaleObject('rain', 1.5, 1.5);
	setBlendMode('rain', 'add')
	setProperty('rain.alpha', 0.35)
	setScrollFactor('rain', 1.3, 1.3)
	addLuaSprite('rain', true);
	
	doTweenAlpha('fadeOut', 'black', 0, 3, 'cubeInOut')
	doTweenAlpha('fadeIn', 'trees', 1, 3, 'cubeInOut')
end

function onUpdate(e)
	
	if getProperty('lime.animation.curAnim.finished') and getProperty('lime.visible') == true then
		removeLuaSprite('lime')
	end
end

function onEvent(n, v1, v2)
	if n == 'midnCam' then
		ongoing = true
		setProperty('defaultCamZoom', 1.9)
		doTweenZoom('zoomOut', 'camGame', 1.8, 2.35, 'sineInOut')
		setProperty('isCameraOnForcedPos', true)
		doTweenX('camX', 'camFollowPos', 435, 2.35, 'sineInOut')
		doTweenX('camX2', 'camFollow', 435, 2.35, 'sineInOut')
		doTweenY('camY', 'camFollowPos', 300, 2.35, 'sineInOut')
		doTweenY('camY2', 'camFollow', 300, 2.35, 'sineInOut')
	end
	
	if n == 'end' then
		removeLuaSprite('black')
		removeLuaSprite('spotlight1')
		removeLuaSprite('spotlight2')
	end
	
	if n == 'Change Character' and v2 == 'prangealt' then
		setProperty('sparkle.visible', true)
	end
end

function onUpdatePost(e)
	if ongoing then
		setProperty('defaultCamZoom', getProperty('camGame.zoom'))
	end
end

function onTweenCompleted(t)
	if t == 'zoomOut' then
		setProperty('isCameraOnForcedPos', false)
		ongoing = false
		setProperty('defaultCamZoom', 2.2)
		doTweenAlpha('lightFade', 'black', 0.35, 1, 'sineOut')
		doTweenAlpha('lightFade1', 'spotlight1', 0.3, 1, 'sineOut')
		doTweenAlpha('lightFade2', 'spotlight2', 0.3, 1, 'sineOut')
	end
end
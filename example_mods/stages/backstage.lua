trigger = 1
ongoing = false
pixel = 1
function onCreate()
	initLuaShader('mosaic')
	setPropertyFromClass('GameOverSubstate', 'characterName', 'bf_ourple')
	makeLuaSprite('bg', 'stage/backstage', 0, 0);
	setProperty('bg.antialiasing', false)
	addLuaSprite('bg', false);
end

function onCreatePost()
	setSpriteShader('dad', 'mosaic')
	setShaderFloat('dad', 'pixel', 1)
end

function onEvent(n, v1, v2)
	if n == 'guyCam' and trigger == 1 then
		setProperty('isCameraOnForcedPos', true)
		setProperty('camGame.zoom', 4.5)
		doTweenX('camX', 'camFollowPos', 230, 0.5, 'expoOut')
		doTweenX('camX2', 'camFollow', 230, 0.5, 'expoOut')
		doTweenY('camY', 'camFollowPos', 245, 0.5, 'expoOut')
		doTweenY('camY2', 'camFollow', 245, 0.5, 'expoOut')
		trigger = 2
	end
	
	if n == 'guyCam2'  then
		ongoing = true
		doTweenZoom('zoomOut', 'camGame', 2.5, 2, 'expoInOut')
		setProperty('defaultCamZoom', 2.5)
		doTweenX('camX', 'camFollowPos', (getMidpointX('dad')), 1.85, 'cubeInOut')
		doTweenX('camX2', 'camFollow', (getMidpointX('dad')), 1.85, 'cubeInOut')
		doTweenY('camY', 'camFollowPos', (getMidpointY('dad') - 110), 1.85, 'cubeInOut')
		doTweenY('camY2', 'camFollow', (getMidpointY('dad') - 110), 1.85, 'cubeInOut')
	end
	
	if n == 'guyglitch' then
		pixel = pixel + 0.5
		setShaderFloat('dad', 'pixel', pixel)
	end
end

function onUpdatePost(e)
	if ongoing then
		setProperty('defaultCamZoom', getProperty('camGame.zoom'))
	end
end

function onTweenCompleted(t)
	if t == 'zoomOut' then
		ongoing = false
	end
end
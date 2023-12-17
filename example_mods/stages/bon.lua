set = false
power = 0.0
chromo = 0.0
local shaderName = "fishlens"
function onCreate()
	setPropertyFromClass('GameOverSubstate', 'characterName', 'bf_ourple')
	initLuaShader('vignetteGlitch')

	makeLuaSprite('holder', '', 0, 0);
	
	makeAnimatedLuaSprite('glitch', 'stage/lurking/glitch', 0, 0);
	setProperty('glitch.antialiasing', false)
	addAnimationByPrefix('glitch', 'glitch', 'glitch', 30, true)
	objectPlayAnimation('glitch', 'glitch', true)
	addLuaSprite('glitch', false);
	
	makeLuaSprite('bg', 'stage/lurking/bg', 0, 0);
	setProperty('bg.antialiasing', false)
	addLuaSprite('bg', false);
	
    makeLuaSprite("tempShader0")

    runHaxeCode([[
        var shaderName = "]] .. shaderName .. [[";
        game.initLuaShader(shaderName);
        var shader0 = game.createRuntimeShader(shaderName);
		game.addShader(shader0);
        game.getLuaObject("tempShader0").shader = shader0; // setting it into temporary sprite so luas can set its shader uniforms/properties
        return;
    ]])
end

function onCreatePost()
	setPropertyFromClass('flixel.FlxG.camera', 'target', nil)
	setProperty('isCameraOnForcedPos', true)
	setProperty('camFollowPos.x', getMidpointX('bg') - 4)
	setProperty('camFollowPos.y', getMidpointY('bg') - 1)
	setProperty('camFollow.x', getMidpointX('bg') - 4)
	setProperty('camFollow.y', getMidpointY('bg') - 1)
	setSpriteShader('dad', 'vignetteGlitch')
	setShaderFloat('dad', 'glitchScale', 0.4)
end

function onUpdate(e)
	power = getProperty('holder.x') / 2 + 1
	chromo = getProperty('holder.y')
	setShaderFloat('tempShader0', 'power', power)
	setShaderFloat('tempShader0', 'chromo', chromo)
end

function randomizeShader()
	if not altAnim then
		setShaderFloat('dad', 'time', math.random(0.8, 1))
		setShaderFloat('dad', 'prob', math.random(0.5, 0.7))
		setShaderFloat('dad', 'vignetteIntensity', math.random(1, 1.5))
	else
		setShaderFloat('dad', 'time', math.random(0.8, 1))
		setShaderFloat('dad', 'prob', math.random(0.2, 1))
		setShaderFloat('dad', 'vignetteIntensity', math.random(1, 3))
		setShaderFloat('dad', 'glitchScale', math.random(0.2, 0.5))
	end
end

function onStepHit()
	randomizeShader()
end

function onCountdownTick()
	randomizeShader()
end

function onEvent(n, v1, v2)
	if n == 'Change Character' and v2 == 'shadowbonn' then
		setSpriteShader('dad', 'vignetteGlitch')
	end
	if n == 'VHS' then
		if set == false then
			setProperty('bg.visible', false)
		end
		if set == true then
			setProperty('bg.visible', true)
		end
		set = not set
	end
	
	if n == 'fishlens' then
		doTweenX('power', 'holder', tonumber(v2), tonumber(v1), 'sineIn')
		doTweenY('chromo', 'holder', tonumber(v2), tonumber(v1), 'sineIn')
	end
end

function onTweenCompleted(t)
	if t == 'chromo' then
		setProperty('holder.x', 0)
		setProperty('holder.y', 0)
	end
end
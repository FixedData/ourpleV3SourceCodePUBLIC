shaderName = 'mosaic'
function onCreate()
	makeLuaSprite("tempShader0")
	--makeLuaSprite("tempShader1")
	makeLuaSprite("pixel", 0.0001, 0.0001)
	setPropertyFromClass('GameOverSubstate', 'characterName', 'bf_ourple')
	
	makeLuaSprite('bg4', 'stage/dismantle/bg4', 0, 30);
	setProperty('bg4.antialiasing', false)
	addLuaSprite('bg4', false);

	makeLuaSprite('bg5', 'stage/dismantle/bg5', 0, 0);
	setProperty('bg5.antialiasing', false)
	addLuaSprite('bg5', false);

	makeLuaSprite('cabinets', 'stage/dismantle/cabinets', 0, 30);
	setProperty('cabinets.antialiasing', false)
	addLuaSprite('cabinets', false);
	
	makeLuaSprite('suit', 'stage/dismantle/suit', 0, 30);
	setProperty('suit.antialiasing', false)
	addLuaSprite('suit', false);
	
	makeLuaSprite('table', 'stage/dismantle/table', -70, -10);
	setProperty('table.antialiasing', false)
	setScrollFactor('table', 1.2, 1.2)
	setProperty('table.visible', false)
	addLuaSprite('table', true);
	
	makeLuaSprite('bg3', 'stage/dismantle/bg3', 0, 0);
	setProperty('bg3.antialiasing', false)
	addLuaSprite('bg3', false);
	
	makeLuaSprite('bg2', 'stage/dismantle/bg2', 0, 0);
	setProperty('bg2.antialiasing', false)
	addLuaSprite('bg2', false);
	
	makeLuaSprite('bg1', 'stage/dismantle/bg1', 0, 0);
	setProperty('bg1.antialiasing', false)
	addLuaSprite('bg1', false);

	
	
	makeAnimatedLuaSprite('freddy', 'stage/dismantle/animatronics', -513 - 70, 51);
	setProperty('freddy.antialiasing', false)
	addAnimationByIndices('freddy', 'walk1', 'freddywalk', '0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12', 30)
	addAnimationByIndices('freddy', 'walk2', 'freddywalk', '13, 14, 15, 16, 17, 18, 19, 20, 21, 23, 24, 25', 30)
	addAnimationByPrefix('freddy', 'idle', 'freddyidle', 30, false)
	addAnimationByPrefix('freddy', 'die', 'freddydie', 30, false)
	objectPlayAnimation('freddy', 'walk1', true)
	setObjectOrder('freddy', getObjectOrder('gfGroup') + 1)
	addLuaSprite('freddy', false);
	
	makeAnimatedLuaSprite('bonnie', 'stage/dismantle/animatronics', -520 - 70, 42);
	setProperty('bonnie.antialiasing', false)
	addAnimationByIndices('bonnie', 'walk1', 'bonwalk', '0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12', 30)
	addAnimationByIndices('bonnie', 'walk2', 'bonwalk', '13, 14, 15, 16, 17, 18, 19, 20, 21, 23, 24, 25', 30)
	addAnimationByPrefix('bonnie', 'idle', 'bonidle', 30, false)
	addAnimationByPrefix('bonnie', 'die', 'bondie', 30, false)
	objectPlayAnimation('bonnie', 'walk1', true)
	setObjectOrder('bonnie', getObjectOrder('gfGroup') + 1)
	addLuaSprite('bonnie', false);
	
	makeAnimatedLuaSprite('chica', 'stage/dismantle/animatronics', -513 - 70, 51);
	setProperty('chica.antialiasing', false)
	addAnimationByIndices('chica', 'walk1', 'chicawalk', '0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12', 30)
	addAnimationByIndices('chica', 'walk2', 'chicawalk', '13, 14, 15, 16, 17, 18, 19, 20, 21, 23, 24, 25', 30)
	addAnimationByPrefix('chica', 'idle', 'chicaidle', 30, false)
	addAnimationByPrefix('chica', 'die', 'chicadie', 30, false)
	objectPlayAnimation('chica', 'walk1', true)
	setObjectOrder('chica', getObjectOrder('gfGroup') + 1)
	addLuaSprite('chica', false);
	
	makeAnimatedLuaSprite('foxy', 'stage/dismantle/animatronics', -513 - 70, 44);
	setProperty('foxy.antialiasing', false)
	addAnimationByIndices('foxy', 'walk1', 'foxywalk', '0, 1, 2, 3, 4, 5, 6', 30)
	addAnimationByIndices('foxy', 'walk2', 'foxywalk', '7, 8, 9, 10, 11, 12, 13', 30)
	addAnimationByPrefix('foxy', 'idle', 'foxyidle', 30, false)
	addAnimationByPrefix('foxy', 'die', 'foxydie', 30, false)
	objectPlayAnimation('foxy', 'walk1', true)
	setObjectOrder('foxy', getObjectOrder('gfGroup') + 1)
	addLuaSprite('foxy', false);
	
	makeLuaSprite('black','', 100,0)
	makeGraphic('black', 900, 900,'0xFF000000')
	addLuaSprite('black',true)
    setScrollFactor('black',0,0)
	
	makeAnimatedLuaSprite('kids', 'stage/dismantle/die', 0, 0);
	setProperty('kids.antialiasing', false)
	addAnimationByPrefix('kids', 'die', 'incident', 30, false)
	objectPlayAnimation('kids', 'die', true)
	setProperty('kids.visible', false)
	setScrollFactor('kids', 0, 0)
	scaleObject('kids', 0.7, 0.7)
	updateHitbox('kids')
	screenCenter('kids')
	setProperty('kids.y', getProperty('kids.y')+30)
	addLuaSprite('kids', true);

end

function onCreatePost()
	runHaxeCode([[
        var shaderName = "]] .. shaderName .. [[";
        game.initLuaShader(shaderName);
        game.initLuaShader('crtmatrix');
        var shader0 = game.createRuntimeShader(shaderName);
		game.addShader(shader0);
        game.getLuaObject("tempShader0").shader = shader0; // setting it into temporary sprite so luas can set its shader uniforms/properties
        return;
    ]])
	setProperty('camHUD.alpha', 0)
	setShaderFloat('tempShader0', 'pixel', 0.0001)

	
	makeLuaSprite('liverleak','stage/dismantle/liveleak')
	setProperty('liverleak.alpha','0.5')
	setObjectCamera("liverleak", 'other')
	addLuaSprite("liverleak", true)
	setProperty('liverleak.visible',false)
end

index = '1'
pixelval = 1
active = false
function onEvent(n, v1, v2)
	if n == '' then
		if v1 == 'imcrying' then
			setProperty('bg1.visible', false)
			setProperty('bg2.visible', false)
			setProperty('bg3.visible', false)
			setProperty('bg4.visible', true)
			setProperty('bg5.visible', false)
			setProperty('cabinets.visible', false)
			setProperty('suit.visible', false)	
		end
		if v1 == 'please' then
			setProperty('bg1.visible', false)
			setProperty('bg2.visible', false)
			setProperty('bg3.visible', false)
			setProperty('bg4.visible', false)
			setProperty('cabinets.visible', true)
			setProperty('suit.visible', true)
		end
	end
	if n == 'Play Animation' and v1 == 'springlock' then
		setProperty('liverleak.visible',true)
	end
	if n == 'moveanim' then
		objectPlayAnimation(v1, 'walk'..index, true)
		if index == '1' then
			index = '2'
		else
			index = '1'
		end
		setProperty(v1..'.x', getProperty(v1..'.x') + tonumber(v2))
	end
	
	if n == 'addpixel' then
		easing = 'sineIn'
		pixelval = tonumber(v1)
		if pixelval > getProperty('pixel.x') then
			easing = 'sineIn'
			doTweenZoom('camZoom', 'camGame', 60, tonumber(v2), 'expoIn')
		else
			easing = 'sineOut'
			doTweenZoom('camZoom', 'camGame', 2.5, tonumber(v2), 'cubeOut')
		end
		doTweenX('pixelTwn', 'pixel', pixelval, tonumber(v2), easing)
		ongoing = true
	end
	
	if n == 'asciishader' then
		active = not active
		--setShaderBool('tempShader1', 'active', active)
	end
end

function onSongStart()
	--startVideoSprite('dismantle')
end
ongoing = false
function onUpdatePost(e)
	if ongoing then
		setProperty('defaultCamZoom', getProperty('camGame.zoom'))
	end
	setShaderFloat('tempShader0', 'pixel', getProperty('pixel.x'))
	if getProperty('freddy.animation.curAnim.name') == 'die' then
		if getProperty('freddy.animation.curAnim.finished') then
			removeLuaSprite('freddy')
			index = '1'
		else
			if getProperty('freddy.animation.curAnim.curFrame') < 32 then
				setProperty('dad.visible', false)
			else
				setProperty('dad.visible', true)
			end
		end
	end
	
	if getProperty('bonnie.animation.curAnim.name') == 'die' then
		if getProperty('bonnie.animation.curAnim.finished') then
			removeLuaSprite('bonnie')
			index = '1'
		else
			if getProperty('bonnie.animation.curAnim.curFrame') < 49 then
				setProperty('dad.visible', false)
			else
				setProperty('dad.visible', true)
			end
		end
	end
	
	if getProperty('chica.animation.curAnim.name') == 'die' then
		if getProperty('chica.animation.curAnim.finished') then
			removeLuaSprite('chica')
			index = '1'
		else
			if getProperty('chica.animation.curAnim.curFrame') < 58 then
				setProperty('dad.visible', false)
			else
				setProperty('dad.visible', true)
			end
		end
	end
	
	if getProperty('foxy.animation.curAnim.name') == 'die' then
		if getProperty('foxy.animation.curAnim.finished') then
			removeLuaSprite('foxy')
			index = '1'
		else
			if getProperty('foxy.animation.curAnim.curFrame') < 82 and getProperty('foxy.animation.curAnim.curFrame') > 14 then
				setProperty('dad.visible', false)
			else
				setProperty('dad.visible', true)
			end
		end
	end
end

function onTweenCompleted(t)
	if t == 'pixelTwn' then
		ongoing = false
	end
end
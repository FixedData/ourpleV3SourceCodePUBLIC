intro = true
ongoing = false
pov = 0
function onCreate()
	setProperty('skipCountdown', true)
	addCharacterToList('retrohenry', 'dad')
	addCharacterToList('henry2', 'dad')
	addCharacterToList('henry1', 'dad')
	addCharacterToList('terminatedbf2', 'boyfriend')
	addCharacterToList('retrobf', 'boyfriend')
	addCharacterToList('retrogf', 'gf')
	setPropertyFromClass('GameOverSubstate', 'characterName', 'bf_ourple')
	
	makeAnimatedLuaSprite('firebg', 'stage/terminated/firebg', 0, 0);
	setProperty('firebg.antialiasing', false)
	addAnimationByPrefix('firebg', 'firebg', 'firebg', 30, true)
	objectPlayAnimation('firebg', 'firebg', true)
	addLuaSprite('firebg', false);
	
	makeAnimatedLuaSprite('baby', 'stage/terminated/baby', 600, 440);
	setProperty('baby.antialiasing', false)
	addAnimationByPrefix('baby', 'bounce', 'bounce', 30, true)
	addAnimationByPrefix('baby', 'slapready', 'slapready', 30, false)
	addAnimationByPrefix('baby', 'slap', 'slap0', 30, false)
	addOffset('baby', 'slapready', 26*4, 40*4)
	addOffset('baby', 'slap', 159*1.8, 51*3.2)
	scaleObject('baby', 0.5, 0.5)
	updateHitbox('baby')
	playAnim('baby', 'bounce', true)
	setProperty('baby.visible', false)
	addLuaSprite('baby', true);
	
	makeLuaSprite('bg3', 'stage/terminated/bg3', 0, 0);
	setProperty('bg3.antialiasing', false)
	addLuaSprite('bg3', false);
	
	makeLuaSprite('scanline', 'stage/scanline', -143, -63);
	setProperty('scanline.antialiasing', false)
	setProperty('scanline.visible', false)
	addLuaSprite('scanline', true);
	
	makeAnimatedLuaSprite("evilscary", 'stage/terminated/eviles', 0, 0)
	addAnimationByPrefix("evilscary", "i", "i", 16, true)
	playAnim("evilscary", "i", true)
	setProperty('evilscary.antialiasing', false)
	scaleObject('evilscary', 0.5, 0.5)
	updateHitbox('evilscary')
	setProperty('evilscary.visible', false)
	addLuaSprite('evilscary', true);

	makeLuaSprite('emptytv', 'stage/terminated/tvempty', -143, -63);
	setProperty('emptytv.antialiasing', false)
	scaleObject('emptytv', 0.4, 0.4)
	updateHitbox('emptytv')
	setProperty('emptytv.visible', false)
	addLuaSprite('emptytv', true);

	
	makeLuaSprite('grey','', 0,0)
	makeGraphic('grey', 1500, 900,'A0A0A0')
	addLuaSprite('grey',false)
    setScrollFactor('grey',0,0)
	
	makeLuaSprite('bg2', 'stage/terminated/bg2', 0, 0);
	setProperty('bg2.antialiasing', false)
	addLuaSprite('bg2', false);
	
	makeLuaSprite('bg', 'stage/terminated/bg1', 0, 0);
	setProperty('bg.antialiasing', false)
	addLuaSprite('bg', false);
	initLuaShader('VHS')
	
	makeLuaSprite('black','', 100,0)
	makeGraphic('black', 900, 900,'000000')
	addLuaSprite('black',true)
    setScrollFactor('black',0,0)
	
	makeAnimatedLuaSprite('tv', 'stage/terminated/tv', 0, 0);
	setProperty('tv.antialiasing', false)
	addAnimationByPrefix('tv', 'tv', 'tv', 30, true)
	objectPlayAnimation('tv', 'tv', true)
	setScrollFactor('tv', 0, 0)
	screenCenter('tv')
	scaleObject('tv', 0.5, 0.5)
	setProperty('tv.alpha', 0)
	addLuaSprite('tv', true);
	
	makeAnimatedLuaSprite('fire', 'stage/terminated/fire', -261, 20);
	setProperty('fire.antialiasing', false)
	addAnimationByPrefix('fire', 'fire', 'fire', 30, true)
	objectPlayAnimation('fire', 'fire', true)
	setScrollFactor('fire', 1.15, 1.15)
	scaleObject('fire', 1.5, 1.5)
	updateHitbox('fire')
	setProperty('fire.visible', false)
	addLuaSprite('fire', true);
	
	makeLuaSprite('overlay', 'stage/terminated/overlay', -261, -247*2);
	setProperty('overlay.antialiasing', false)
	setProperty('overlay.alpha', 0)
	setBlendMode('overlay', 'add')
	scaleObject('overlay', 1, 3)
	setProperty('overlay.angle', 90)
	updateHitbox('overlay')
	addLuaSprite('overlay', true);
	
	makeLuaSprite('red','', 0,0)
	makeGraphic('red', 1500, 900,'FF0000')
	addLuaSprite('red',true)
	setObjectCamera('red', 'other')
	--setProperty('red.alpha', 125/255)
	setProperty('red.alpha', 0)
    setScrollFactor('red',0,0)
	
	makeAnimatedLuaSprite('cutscene', 'stage/terminated/cutscene', 361/2 + 80, 202/2 + 40);
	setProperty('cutscene.antialiasing', false)
	addAnimationByPrefix('cutscene', 'cutscene', 'cutscene', 30, false)
	objectPlayAnimation('cutscene', 'cutscene', true)
	setScrollFactor('cutscene', 0, 0)
	setProperty('cutscene.visible', false)
	addLuaSprite('cutscene', true);
	
	makeAnimatedLuaSprite('static', 'stage/terminated/static', 310, 170);
	setProperty('static.antialiasing', false)
	addAnimationByPrefix('static', 'static', 'static', 30, true)
	objectPlayAnimation('static', 'static', true)
	setScrollFactor('static', 0, 0)
	scaleObject('static', 1.2, 1.2)
	updateHitbox('static')
	setProperty('static.alpha', 0)
	addLuaSprite('static', true);
end

function onCreatePost()
	setProperty('gf.visible', false)
	setProperty('camHUD.alpha', 0)
	setProperty('defaultCamZoom', 2)
	setProperty('camGame.zoom', 2)
	screenCenter('tv')
end

function onEvent(n, v1, v2)
	if n == 'terminatedintro' then
		doTweenAlpha('fadein', 'tv', 1, 5, 'sineIn')
		doTweenX('scaleX', 'tv.scale', 0.6, 10, 'sineIn')
		doTweenY('scaleY', 'tv.scale', 0.6, 10, 'sineIn')
	end
	
	if n == 'terminatedend' then
		intro = false
		ongoing = true
		
		setProperty('isCameraOnForcedPos', true)
		setProperty('camFollowPos.x', 507)
		setProperty('camFollow.x', 507)
		setProperty('camFollowPos.y', 134)
		setProperty('camFollow.y', 134)
		
		doTweenAlpha('fadeincamhud', 'camHUD', 1, 1, 'sineOut')
		doTweenAlpha('fadeout', 'tv', 0, 0.7, 'sineOut')
		doTweenAlpha('fadeoutb', 'black', 0, 0.7, 'sineOut')
		doTweenZoom('zoomIn', 'camGame', 5, 0.6, 'sineOut')
		doTweenX('scaleX', 'tv.scale', 1.6, 0.6, 'sineOut')
		doTweenY('scaleY', 'tv.scale', 1.6, 0.6, 'sineOut')
		runTimer('zoomout', 0.4)
	end
	
	if n == 'cameramove' then
		ongoing = true
		setProperty('isCameraOnForcedPos', true)
		doTweenZoom('zoomIn', 'camGame', 60, 3.1, 'expoInOut')
		doTweenX('camFollowPosx', 'camFollowPos', 497, 2, 'sineInOut')
		doTweenY('camFollowPosY', 'camFollowPos', 114, 2, 'sineInOut')
	end
	
	if n == 'pov1' then
		pov = 1
		cancelTween('camFollowPosx')
		cancelTween('camFollowPosY')
		cancelTween('zoomIn')
		doTweenZoom('zoomOut', 'camGame', 3.8, 1.25, 'sineInOut')
		
		setProperty('bg.visible', false)
		triggerEvent('Change Character', 'bf', 'terminatedbf2')
		setProperty('boyfriend.x', 273)
		setProperty('boyfriend.y', 97)
		triggerEvent('Change Character', 'dad', 'henry2')
		setProperty('dad.x', 0)
		setProperty('dad.y', 0)
		setProperty('gf.visible', true)
		setObjectOrder('dadGroup', getObjectOrder('boyfriendGroup') + 1)
		setProperty('isCameraOnForcedPos', false)
		setProperty('camFollowPos.x', getMidpointX('dad'))
		setProperty('camFollow.x', getMidpointX('dad'))
		setProperty('camFollowPos.y', getMidpointY('dad'))
		setProperty('camFollow.y', getMidpointY('dad'))
	end
	
	if n == 'firezoom' then
		ongoing = true
		setProperty('fire.visible', true)
		doTweenZoom('zoomOut', 'camGame', 1.7, 2, 'quartInOut')
		doTweenAlpha('red', 'red', 0.25, 2, 'quartInOut')
		doTweenAlpha('overlay', 'overlay', 1, 2, 'quartInOut')
		setProperty('defaultCamZoom', 1.7)
		pov = 2
		setProperty('isCameraOnForcedPos', true)
		setProperty('camFollow.x', getMidpointX('dad'))
		setProperty('camFollow.y', getMidpointY('dad'))
	end	
	
	if n == 'terminatedcutscene' then
		ongoing = true
		setProperty('isCameraOnForcedPos', true)
		doTweenZoom('zoomOut', 'camGame', 60, 1, 'quartInOut')
		doTweenAlpha('camHUD', 'camHUD', 0, 1, 'quartInOut')
		doTweenAlpha('red', 'red', 0, 1, 'quartInOut')
		doTweenAlpha('fire', 'fire', 0, 1, 'quartInOut')
		doTweenAlpha('overlay', 'overlay', 0, 1, 'quartInOut')
		doTweenX('camFollowPosx', 'camFollowPos', getMidpointX('boyfriend'), 0.6, 'quartInOut')
		doTweenY('camFollowPosY', 'camFollowPos', getMidpointY('boyfriend'), 0.6, 'quartInOut')
		setProperty('camFollow.x', getMidpointX('boyfriend'))
		setProperty('camFollow.y', getMidpointY('boyfriend'))
	end
	
	if n == 'displaycutscene' then
		cancelTween('zoomOut')
		cancelTween('camFollowPosx')
		cancelTween('camFollowPosY')
		setProperty('camFollow.x', getMidpointX('cutscene'))
		setProperty('camFollowPos.x', getMidpointX('cutscene'))
		setProperty('camFollow.y', getMidpointY('cutscene'))
		setProperty('camFollowPos.y', getMidpointY('cutscene'))
		setProperty('camGame.zoom', 2.8)
		doTweenZoom('zoomOut', 'camGame', 2, 0.8, 'quartOut')
		setProperty('camZooming', false)
		objectPlayAnimation('cutscene', 'cutscene', true)
		setProperty('cutscene.visible', true)
	end
	
	if n == 'pov2' then
		triggerEvent('Change Character', 'bf', 'retrobf')
		setProperty('boyfriend.x', 190)
		setProperty('boyfriend.y', 103)
		triggerEvent('Change Character', 'dad', 'retrohenry')
		setProperty('dad.x', 118)
		setProperty('dad.y', 44)
		triggerEvent('Change Character', 'gf', 'retrogf')
		setProperty('gf.x', 50)
		setProperty('gf.y', 103)
		setProperty('bg2.visible', false)
		setProperty('grey.visible', false)
		removeLuaSprite('fire')
		setProperty('isCameraOnForcedPos', true)
		setProperty('camFollowPos.x', getMidpointX('bg3'))
		setProperty('camFollow.x', getMidpointX('bg3'))
		setProperty('camFollowPos.y', getMidpointY('bg3'))
		setProperty('camFollow.y', getMidpointY('bg3'))
		setProperty('emptytv.visible', true)
		setProperty('scanline.visible', true)
		setProperty('static.alpha', 1)
		doTweenAlpha('camHUD', 'camHUD', 1, 1, 'quartInOut')
		removeLuaSprite('cutscene')
		setProperty('defaultCamZoom', 2.25)
	end

	if n == '' and v1 == 'imcrying' then
		doTweenAlpha("asdasdasd", "camHUD", 1, 0.7, "")
	end
	if n == '' and v1 == 'scary' then
		setProperty('isCameraOnForcedPos', true)
		setProperty('camFollowPos.x', getMidpointX('bg3'))
		setProperty('camFollow.x', getMidpointX('bg3'))
		setProperty('camFollowPos.y', getMidpointY('bg3'))
		setProperty('camFollow.y', getMidpointY('bg3'))
		setProperty('evilscary.visible', true)
		setProperty('emptytv.visible', true)
		setProperty('static.alpha', 1)
		setProperty('camHUD.alpha',0)
		--doTweenAlpha('camHUD', 'camHUD', 1, 1, 'quartInOut')
		setProperty('red.alpha', 0.0)
		setProperty('overlay.alpha',0)
		setProperty('camGame.zoom', 2.0)
		setProperty('defaultCamZoom', 2.0)
		triggerEvent("tweenZoom", '2.5,5.5,sdf', 'sinein')
		doTweenAlpha('asdds','fire',1,5.3,'sineinout')
		-- setProperty('fire.visible',true)
		-- setObjectOrder("fire", getObjectOrder("emptytv")+1)
	end
	if n == '' and v1 == 'notscary' then
		triggerEvent('pov3')
		setProperty('evilscary.visible', false)
		setProperty('emptytv.visible', false)
		setProperty('camHUD.alpha',1)
	end
	if n == 'pov3' then
		pov = 3
		triggerEvent('Change Character', 'bf', 'bf_ourple')
		setProperty('boyfriend.x', 495)
		setProperty('boyfriend.y', 225)
		triggerEvent('Change Character', 'dad', 'henry1')
		setProperty('dad.x', -27)
		setProperty('dad.y', 153)
		triggerEvent('Change Character', 'gf', 'gf_ourple')
		setProperty('gf.x', 273)
		setProperty('gf.y', 153)
		setProperty('firebg.visible', true)
		--removeLuaSprite('fire')
		setProperty('fire.visible', false)
		setProperty('isCameraOnForcedPos', false)
		setProperty('camFollowPos.x', getMidpointX('firebg'))
		setProperty('camFollow.x', getMidpointX('firebg'))
		setProperty('camFollowPos.y', getMidpointY('firebg') + 20)
		setProperty('camFollow.y', getMidpointY('firebg') + 20)
		--removeLuaSprite('bg3')
		--removeLuaSprite('emptytv')
		setProperty('emptytv.visible', false)
		setProperty('bg3.visible', false)
		removeLuaSprite('scanline')
		setProperty('static.alpha', 1)
		setProperty('defaultCamZoom', 2.5)
		setProperty('red.alpha', 0.3)
		scaleObject('overlay', 1, 1)
		setProperty('overlay.angle', 0)
		setProperty('overlay.x', 0)
		setProperty('overlay.y', 0)
		setProperty('overlay.alpha', 1)
		setProperty('baby.visible', true)
	end
	
	if n == 'baby' then
		doTweenX('babyX', 'baby', 245, 1, 'sineOut')
		doTweenY('babyY', 'baby', 176, 1, 'sineOut')
	end
	
	if n == 'leave' then
		setProperty('baby.offset.x', 106)
		setProperty('baby.offset.y', 113)
		doTweenX('babyX', 'baby', 600, 1, 'sineOut')
		doTweenY('babyY', 'baby', 440, 1, 'sineOut')
	end
end

function onUpdatePost(e)
	if curBeat == 707 then
		setProperty('isCameraOnForcedPos',true)
		doTweenAlpha('FUCKING1','boyfriend',0,2.83)
		doTweenAlpha('FUCKING2','gf',0,2.83)
		doTweenAlpha('FUCKING3','static',0,2.83)
		doTweenAlpha('FUCKING4','overlay',0,2.83)
		doTweenAlpha('FUCKING5','bg3',0,2.83)
		doTweenAlpha('FUCKING6','firebg',0,2.83)
		doTweenAlpha('FUCKING7','empty',0,2.83)
	end
	if not intro then
		if not ongoing then
			if pov == 0 then
				if mustHitSection then
					setProperty('defaultCamZoom', 2)
				else
					setProperty('defaultCamZoom', 2.5)
				end
			elseif pov == 1 then
				if mustHitSection then
					setProperty('defaultCamZoom', 4.3)
				else
					setProperty('defaultCamZoom', 3.8)
				end
			elseif pov == 3 then
				if mustHitSection then
					setProperty('defaultCamZoom', 3)
				else
					setProperty('defaultCamZoom', 2.5)
				end
			end
		end
	else
		setProperty('defaultCamZoom', 2)
		setProperty('camGame.zoom', 2)
	end
	
	if getProperty('static.alpha') > 0 then
		setProperty('static.alpha', getProperty('static.alpha') - e * 3)
	end
	
	if ongoing then
		setProperty('defaultCamZoom', getProperty('camGame.zoom'))
	end
end

function onTimerCompleted(t, l, ll)
	if t == 'zoomout' then
		doTweenZoom('zoomOut', 'camGame', 2.5, 1.7, 'quartInOut')
		doTweenX('camFollowPosx', 'camFollowPos', getMidpointX('dad') - 270 + 150, 2.3, 'sineOut')
		doTweenY('camFollowPosY', 'camFollowPos', getMidpointY('dad') + 70 - 100, 2.3, 'sineOut')
	end
end

function onTweenCompleted(t)
	if t == 'fadeoutb' then
		removeLuaSprite('tv')
		removeLuaSprite('black')
	end
	
	if t == 'camFollowPosx' then
		setProperty('isCameraOnForcedPos', false)
	end
	
	if t == 'zoomOut' then
		ongoing = false
	end
end
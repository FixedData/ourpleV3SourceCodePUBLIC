vsp = 0
hsp = 0
checkforBye = false
gfanim2 = false
gfanim1 = false
function onCreate()
		setProperty('skipCountdown', true)
	addCharacterToList('nakedbags', 'dad')
   
	makeAnimatedLuaSprite('coat', 'cashmoney/coat', getProperty('dad.x') + 20, getProperty('dad.y') + 86);
	setProperty('coat.antialiasing', false)
	addAnimationByPrefix('coat', 'coat', 'coat', 12, true)
	objectPlayAnimation('coat', 'coat', true)
	setObjectOrder('coat', getObjectOrder('dadGroup') - 1)
	setProperty('coat.visible', false)
	addLuaSprite('coat', false);

	setProperty('isCameraOnForcedPos', true)
	setProperty('camFollowPos.x', 723/2)
	setProperty('camFollow.x', 723/2)
	setProperty('camFollowPos.y', 405/2)
	setProperty('camFollow.y', 405/2)
	setProperty('defaultCamZoom', 10)
	setProperty('camGame.zoom', 10)
	
	makeLuaSprite('black','', 0,0)
	makeGraphic('black', 1280, 900,'000000')
	addLuaSprite('black')
    setScrollFactor('black',0,0)
	setObjectCamera("black", 'hud')
	doTweenAlpha('fadeoutb', 'black', 0, 5, 'sineInOut')
	doTweenZoom('zoomIn', 'camGame', 2.4, 5.5, 'expoInOut')
	
end

function onEvent(n, v1, v2)
	if n == 'Change Character' and v2 == 'nakedbags' then
		vsp = -4
		hsp = -7
		setProperty('coat.visible', true)
		triggerEvent('Play Animation', 'trans', 'dad')
	end
	if n == "Play Animation" and v1 == 'byebye' then
		checkforBye = true
	end
	if n == "Play Animation" and v1 == 'confused' then
		setProperty('beatsPerZoom',1111111)
		doTweenAlpha('byebyeby','camHUD',0,2,'cubeinout')
		setProperty('isCameraOnForcedPos',true)
		doTweenX("camFollowX", "camFollow", 723/2, 2, "quartInOut")
		doTweenY("camFollowY", "camFollow", 405/2, 2, "quartInOut")
		doTweenX("camFollowPosX", "camFollowPos", 723/2, 2, "quartInOut")
		doTweenY("camFollowPosY", "camFollowPos", 405/2, 2, "quartInOut")
		doTweenZoom('gogoo','camGame',2.4,2,'quartinout')
	
	end
	if n == "Play Animation" and v1 == 'cash1' then
		gfanim2 = true
	
	end
	if n == "Play Animation" and v1 == 'cheer' then
		gfanim1 = true	
		doTweenZoom('gogoo1','camGame',2.5,0.1,'cubeout')

		setProperty('camFollowPos.x', 723/2 + 100)
		setProperty('camFollow.x', 723/2 + 100)
		setProperty('camFollowPos.y', 405/2)
		setProperty('camFollow.y', 405/2)
		setObjectCamera("black", 'game')
		setProperty('black.alpha',1)
		--runTimer("eas", 0.5)
	end
end
timer = 1;
function onUpdate(e)

	if getProperty('defaultCamZoom') > 2.4 then
		setProperty('defaultCamZoom', getProperty('camGame.zoom'))
	end
	
	if getProperty('coat.visible') then
		if vsp < 5 then
			vsp = vsp + (e * 10)
		end
		setProperty('coat.x', getProperty('coat.x') + hsp)
		setProperty('coat.y', getProperty('coat.y') + vsp)
	end
	
	if getProperty('coat.y') < -400 then
		removeLuaSprite('coat')
	end
	if checkforBye then
		if getProperty('dad.animation.curAnim.finished') then
			setProperty('dad.visible',false)
			checkforBye=false
		end
	end
	if gfanim1 then
		if getProperty('gf.animation.curAnim.finished') then
			triggerEvent('Play Animation', 'cheerloop', 'gf')
			gfanim1 = false
		end
	end
	if gfanim2 then
		timer = timer - e
		if (timer <= 0) then
			triggerEvent('Play Animation', 'cash', 'gf')
			gfanim2=false
		end
	end
end


function onTweenCompleted(r)
	if r == 'gogoo' then
		setProperty('defaultCamZoom', 2.4)
	end
	
end



function onTimerCompleted(r)
	if r == 'eas' then
		
		--doTweenAlpha('fadeoutb', 'black', 1, 1, 'sineInOut')
	end
	
end
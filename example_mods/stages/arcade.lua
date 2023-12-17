function onCreate()
	setPropertyFromClass('GameOverSubstate', 'characterName', 'bf_ourple')
	
	makeLuaSprite('bg', 'stage/blubber/bg', -55, 0);
	setProperty('bg.antialiasing', false)
	scaleObject('bg', 2.8, 2.8)
	updateHitbox('bg')
	addLuaSprite('bg', false);
	
	makeLuaSprite('cabinet', 'stage/blubber/cabinet', 0, 0);
	setProperty('cabinet.antialiasing', false)
	scaleObject('cabinet', 2.7, 2.7)
	updateHitbox('cabinet')
	addLuaSprite('cabinet', false);
end

function onUpdatePost(e)
	if not mustHitSection then
		setProperty('defaultCamZoom', 0.9)
	else
		setProperty('defaultCamZoom', 1.25)
	end
end
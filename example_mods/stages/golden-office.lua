function onCreate()
	addCharacterToList('golden', 'gf')
	setPropertyFromClass('GameOverSubstate', 'characterName', 'bf_ourple')
	
	makeLuaSprite('bg', 'stage/golden/office', 0, 0);
	setProperty('bg.antialiasing', false)
	scaleObject('bg', 0.6, 0.6)
	updateHitbox('bg')
	addLuaSprite('bg', false);
	
end

function onCreatePost()
	setProperty('cameraSpeed',1000)
end

function onSongStart()
	setProperty('cameraSpeed',1)
end

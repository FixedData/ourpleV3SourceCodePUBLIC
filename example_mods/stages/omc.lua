function onCreate()
	setPropertyFromClass('GameOverSubstate', 'characterName', 'cassidy')
	makeLuaSprite('back', 'stage/gofish/back', 0, 0);
	setProperty('back.antialiasing', false)
	setScrollFactor('back', 0.7, 0.7)
	addLuaSprite('back', false);
	
	makeLuaSprite('ground', 'stage/gofish/ground', 0, 0);
	setProperty('ground.antialiasing', false)
	addLuaSprite('ground', false);
	
	makeLuaSprite('trees', 'stage/gofish/trees', -120, 0);
	setProperty('trees.antialiasing', false)
	setScrollFactor('trees', 1.2, 1.2)
	scaleObject('trees', 1.2, 1.2)
	addLuaSprite('trees', true);
end

function onCreatePost()
	setProperty('camFollowPos.x', getMidpointX('boyfriend'))
	setProperty('camFollowPos.y', getMidpointY('boyfriend'))
end
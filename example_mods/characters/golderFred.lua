


function onEvent(eventName, value1, value2, strumTime)
	if eventName == 'Play Animation' and value1 == 'jump' then
		makeLuaSprite("jump", 'stage/golden/jumpscare')
		setGraphicSize("jump", 1280, 720, true)
		setObjectCamera("jump", 'other')
		addLuaSprite("jump", true)
		runTimer("enditall", 0.1)

		
	end
	
end


function onTimerCompleted(r)
	if r == 'enditall' then
		removeLuaSprite("jump")
	end
end
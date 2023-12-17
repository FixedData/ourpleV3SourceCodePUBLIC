
function onCreatePost()
	preloadImage('bgs/bite-png/freddy-jumpscare')
end

function onEvent(eventName, value1, value2, strumTime)
	if eventName == 'Play Animation' and value1 == 'png-scare' then
		makeAnimatedLuaSprite("jump", 'bgs/bite-png/freddy-jumpscare')
		addAnimationByPrefix('jump', 'pop', 'jumpscare-fred' , 48, false)
		setObjectCamera("jump", 'HUD')
		addLuaSprite("jump", false)
		scaleObject('jump', 1.6, 2)
		playAnim('pop')
		runTimer('enditall', 0.6)
		
	end
	
end


function onTimerCompleted(t)
	if t == 'enditall' then
		removeLuaSprite("jump")
	end
end
kids = {}
right = true
trigger = 1
function onCreate()
	setPropertyFromClass('GameOverSubstate', 'characterName', 'bf_ourple')
	makeAnimatedLuaSprite('cry', 'stage/showtime/cry', 218, 195);
	setProperty('cry.antialiasing', false)
	addAnimationByPrefix('cry', 'cry', 'cry', 30, true)
	objectPlayAnimation('cry', 'cry', true)
	addLuaSprite('cry', false);
	
	makeAnimatedLuaSprite('killer', 'stage/showtime/kill', 188, 169);
	setProperty('killer.antialiasing', false)
	addAnimationByPrefix('killer', 'kill', 'kill', 30, false)
	objectPlayAnimation('killer', 'kill', true)
	setProperty('killer.visible', false)
	addLuaSprite('killer', false);

	makeLuaSprite('bg', 'stage/showtime/room', 0, 0);
	setProperty('bg.antialiasing', false)
	addLuaSprite('bg', false);
	
	makeAnimatedLuaSprite('kid1', 'stage/showtime/kid', 142, 225);
	
	makeAnimatedLuaSprite('kid2', 'stage/showtime/kid', 476, 225);
	
	makeAnimatedLuaSprite('kid3', 'stage/showtime/kid', 14, 287);
	scaleObject('kid3', 1.25, 1.25);
	updateHitbox('kid3')
	
	makeAnimatedLuaSprite('kid4', 'stage/showtime/kid', 589, 292);
	scaleObject('kid4', 1.25, 1.25);
	updateHitbox('kid4')
	
	kids[1] = 'kid1'
	kids[2] = 'kid3'
	kids[3] = 'kid2'
	kids[4] = 'kid4'
	for i,object in pairs(kids) do
		if i % 2 == 0 then
			fps = math.random(10, 40)
		else
			fps = math.random(10, 25)
		end
		setProperty(object..'.antialiasing', false)
		addAnimationByPrefix(object, 'danceLeft', 'danceLeft', fps, false)
		addAnimationByPrefix(object, 'danceRight', 'danceRight', fps, false)
		addAnimationByPrefix(object, 'anger', 'mad', 30 + i * 3, false)
		addOffset(object, 'danceLeft', 0, 0)
		addOffset(object, 'danceRight', 0, 0)
		addOffset(object, 'anger', -15, 0)
		objectPlayAnimation(object, 'danceLeft', true)
		addLuaSprite(object, false);
	end
end


function onUpdate(e)
	if getProperty('killer.visible') == true then
		if getProperty('killer.animation.curAnim.finished') then
			removeLuaSprite('killer')
			removeLuaSprite('cry')
		end
		
		if getProperty('killer.animation.curAnim.curFrame') == 97 and trigger == 1 then
			playSound('GFK', 0.45,'sound1')
			trigger = 2
		end
		
		if getProperty('killer.animation.curAnim.curFrame') == 131 and trigger == 2 then
			playSound('run', 0.9, 'run')
			trigger = 3
		end
		
		if getProperty('killer.animation.curAnim.curFrame') == 158 and trigger == 3 then
			playSound('glass', 0.7,'sound2')
			stopSound('run')
			trigger = 4
		end
	end
end

function kidDance()
	right = not right
	if rating == 0 or rating * 100 > 65 then
		if right then
			for i,object in pairs(kids) do
				if i % 2 == 0 then
					playAnim(object, 'danceRight', true)
				else
					playAnim(object, 'danceLeft', true)
				end
			end
		else
			for i,object in pairs(kids) do
				if i % 2 == 0 then
					playAnim(object, 'danceLeft', true)
				else
					playAnim(object, 'danceRight', true)
				end
			end
		end
	else
		for i,object in pairs(kids) do
				playAnim(object, 'anger', true)
		end
	end
end

function onPause()
	pauseSound("sound1")
	pauseSound("run")
	pauseSound("sound2")
	
end
function onResume()
	resumeSound("sound1")
	resumeSound("run")
	resumeSound("sound2")
end
function onCountdownTick(counter)
	kidDance()
end

function onBeatHit()
	kidDance()
end
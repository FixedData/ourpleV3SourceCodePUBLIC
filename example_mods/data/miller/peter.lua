-- Script by Shadow Mario
-- Customized for Simplicity by Kevin Kuntz
function onCreate()
	makeOffsets();
	
	makeAnimatedLuaSprite('peter', 'characters/miller/petern', 4943.25, 5400.3);
	addAnimationByPrefix('peter', 'idle', 'i', 12, false);
	addAnimationByPrefix('peter', 'singLEFT', 'l0', 12, false);
	addAnimationByPrefix('peter', 'singDOWN', 'd0', 12, false);
	addAnimationByPrefix('peter', 'singUP', 'u', 12, false);
	addAnimationByPrefix('peter', 'singRIGHT', 'r', 12, false);
	
	addAnimationByPrefix('peter', 'singLEFTmiss', 'ml', 12, false);
	addAnimationByPrefix('peter', 'singDOWNmiss', 'md', 12, false);
	addAnimationByPrefix('peter', 'singUPmiss', 'mu', 12, false);
	addAnimationByPrefix('peter', 'singRIGHTmiss', 'mr', 12, false);
	
	addAnimationByPrefix('peter', 'die', 'die', 12, true);
	scaleObject('peter', 4,4)
	updateHitbox('peter')
	setProperty('peter.antialiasing', false)
	setProperty('peter.visible', false)
	addLuaSprite('peter', true);

	playAnimation('peter', 'idle', true);
end
holdTimers = {peter = 15.0};
singAnimations = {'singLEFT', 'singDOWN', 'singUP', 'singRIGHT'};

offsetspeter = {};
function makeOffsets()
	offsetspeter['idle'] = {x = 0, y = 0}; --idle
	offsetspeter['singLEFT'] = {x = 0, y = -0}; --left
	offsetspeter['singDOWN'] = {x = 0, y = -0};
	offsetspeter['singUP'] = {x = 0, y = -0};
	offsetspeter['singRIGHT'] = {x = 0, y = -0};
	offsetspeter['singLEFTmiss'] = {x = 0, y = -0};
	offsetspeter['singDOWNmiss'] = {x = 0, y = -0};
	offsetspeter['singUPmiss'] = {x = 0, y = -0};
	offsetspeter['singRIGHTmiss'] = {x = 0, y = -0};
	offsetspeter['die'] = {x = 0, y = -150};
end

function goodNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'Peter Sing' then
		if not isSustainNote then
			animToPlay = singAnimations[direction+1];
		end	
		characterToPlay = 'peter'
		holdTimers.peter = 0;
				
		playAnimation(characterToPlay, animToPlay, true);
	end
end

function noteMiss(id, direction, noteType, isSustainNote)
	if noteType == 'Peter Sing' then
		if not isSustainNote then
			animToPlay = singAnimations[direction+1]..'miss';
		end	
		characterToPlay = 'peter'
				
		playAnimation(characterToPlay, animToPlay, true);
	end
end

function onUpdate(elapsed)
	holdCap = stepCrochet * 0.004;
	if holdTimers.peter >= 0 then
		holdTimers.peter = holdTimers.peter + elapsed;
		if holdTimers.peter >= holdCap then
			playAnimation('peter', 'idle', false);
			holdTimers.peter = -1;
		end
	end
end

function onCountdownTick(counter)
	beatHitDance(counter);
end

function onBeatHit()
	beatHitDance(curBeat);
end

function beatHitDance(counter)
	if counter % 2 == 0 then
		if holdTimers.peter < 0 and getProperty('peter.animation.curAnim.name') ~= 'die' then
			playAnimation('peter', 'idle', false);
		end
	end
end

function playAnimation(character, animId, forced)
	objectPlayAnimation(character, animId, forced, 0); -- this part is easily broke if you use objectPlayAnim (I have no idea why its like this)
	offsetTable = offsetspeter
	setProperty(character..'.offset.x', offsetTable[animId].x)
	setProperty(character..'.offset.y', offsetTable[animId].y)
end

function onEvent(n,v1,v2)

	if n == 'Object Play Animation' and v1 == 'peter' then
		playAnimation(v1,v2,true)
		if string.sub(getProperty('peter.animation.curAnim.name'),1,4) == 'sing' then
			holdTimers.peter = 0
		end
	end

end
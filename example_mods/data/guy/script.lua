-- Script by Shadow Mario
-- Customized for Simplicity by Kevin Kuntz
function onCreate()
	makeAnimationList();
	makeOffsets();
	makeAnimatedLuaSprite('dee', 'characters/endohead', 112, 166);
	addAnimationByPrefix('dee', 'idle', 'idle', 30, false);
	addAnimationByPrefix('dee', 'singLEFT', 'left0', 30, false);
	addAnimationByPrefix('dee', 'singDOWN', 'down0', 30, false);
	addAnimationByPrefix('dee', 'singUP', 'up0', 30, false);
	addAnimationByPrefix('dee', 'singRIGHT', 'right0', 30, false);
	setProperty('dee.antialiasing', false)
	addLuaSprite('dee', false);

	playAnimation('dee', 'idle', true);
end

animationsList = {}
holdTimers = {dee = 15.0};
singAnimations = {'singLEFT', 'singDOWN', 'singUP', 'singRIGHT'};
function makeAnimationList()
	animationsList['idle'] = 'idle';
	animationsList['singLEFT'] = 'singLEFT';
	animationsList['singDOWN'] = 'singDOWN';
	animationsList['singUP'] = 'singUP';
	animationsList['singRIGHT'] = 'singRIGHT';
	animationsList['die'] = 'die';
end

offsetsdee = {};
function makeOffsets()
	offsetsdee['idle'] = {x = 0, y = 0}; --idle
	offsetsdee['singLEFT'] = {x = 0, y = 0};
	offsetsdee['singDOWN'] = {x = 0, y = 0};
	offsetsdee['singUP'] = {x = 0, y = 0};
	offsetsdee['singRIGHT'] = {x = 0, y = 0};
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'Special Sing' then
		if not isSustainNote then
			animToPlay = singAnimations[direction+1];
		end	
		characterToPlay = 'dee'
		holdTimers.dee = 0;
				
		playAnimation(characterToPlay, animToPlay, true);
	end
end

function onUpdate(elapsed)
	holdCap = stepCrochet * 0.004;
	if holdTimers.dee >= 0 then
		holdTimers.dee = holdTimers.dee + elapsed;
		if holdTimers.dee >= holdCap then
			playAnimation('dee', 'idle', false);
			holdTimers.dee = -1;
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
		if holdTimers.dee < 0 and getProperty('dee.animation.curAnim.name') ~= 'die' then
			playAnimation('dee', 'idle', false);
		end
	end
end

function playAnimation(character, animId, forced)
	objectPlayAnimation(character, animId, forced, 0); -- this part is easily broke if you use objectPlayAnim (I have no idea why its like this)
	offsetTable = offsetsdee
	setProperty(character..'.offset.x', offsetTable[animId].x)
	setProperty(character..'.offset.y', offsetTable[animId].y)
end
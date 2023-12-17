deathStart = false
shitfart = false

function onCreatePost()
	makeAnimatedLuaSprite('firesdf', 'stage/terminated/fire', 0, 1125);
	--screenCenter('fire', 'x')
	setProperty('firesdf.antialiasing', false)
	addAnimationByPrefix('firesdf', 'fire', 'fire', 30, true)
	objectPlayAnimation('firesdf', 'fire', true)
	setScrollFactor('firesdf', 1.15, 1.15)
	scaleObject('firesdf', 3, 5)
	updateHitbox('firesdf')
	setProperty('firesdf.visible', true)
	setObjectCamera('firesdf', 'other')
	addLuaSprite('firesdf', true);

	makeAnimatedLuaSprite('fire2', 'stage/terminated/fire', 0, 2208);
	--screenCenter('fire2', 'x')
	setProperty('fire2.antialiasing', false)
	addAnimationByPrefix('fire2', 'fire', 'fire', 30, true)
	objectPlayAnimation('fire2', 'fire', true)
	setScrollFactor('fire2', 1.15, 1.15)
	scaleObject('fire2', 3, 5)
	updateHitbox('fire2')
	setProperty('fire2.visible', true)
	setObjectCamera('fire2', 'other')
	setProperty('fire2.flipY', true)
	addLuaSprite('fire2', true);

	setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'empty')
end

function fakeOver()
	if deathStart == false then
		deathStart = true
		playSound("termingameover", 0.7)
		doTweenY('fireJump', 'firesdf', -2208, 1, 'linear')
		doTweenY('fireJump2', 'fire2', -1125, 1, 'linear')
		setProperty('boyfriend.stunned', true)
		setProperty('dad.stunned', true)
		setProperty('camZooming', false)
		setProperty('camZoomingMult', 0)
		setProperty('camZoomingDecay', 0)
		setProperty('camFollow.x', 1300)
		setProperty('camFollow.y', 1200)
		for i = 0, getProperty('notes.length') - 1 do
			setPropertyFromGroup('notes', i, 'ignoreNote', true)
			setPropertyFromGroup('notes', i, 'canBeHit', true)
		end
		doTweenAlpha('hudalpha','camHUD',0,0.4,'circOut')
		doTweenAlpha('gamealpha','camGame',0,0.4,'circOut')
		runTimer('dieTime',1)
		runTimer('chazTime',2)
		runHaxeCode([[
		
		FlxG.sound.music.volume = 0;
		game.vocals.volume = 0;
		game.introSoundsSuffix = 'empty';
		isCameraOnForcedPos = true;

		
				]])
		setProperty('vocals.volume',0)

	end

end

function onGameOver()
		if shitfart == true then
			return Function_Continue
		elseif shitfart == false then 
			fakeOver()
			return Function_Stop
		end
	end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'dieTime' then
		shitfart = true
	end

end
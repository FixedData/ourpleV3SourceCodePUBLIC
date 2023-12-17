function onCreate()
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'ourple_death')
	setPropertyFromClass('GameOverSubstate', 'endSoundName', '')
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'wind')
end

function onGameOverStart()
	-- You died! Called every single frame your health is lower (or equal to) zero
	--return Function_Stop
	setScrollFactor(getPropertyFromClass('GameOverSubstate', 'boyfriend'), 0, 0)
	setProperty('boyfriend.x', 850)
	setProperty('boyfriend.y', 500)
	--objectPlayAnimation('boyfriend', 'die', true)
	return Function_Continue;
end

flipped = true
flippedIdle = false
defaultY = 0
function onCreatePost()
	defaultY = getProperty('boyfriend.y')
end
function onBeatHit() 
	if getProperty('healthBar.percent') > 20 then
		flipped = not flipped
		setProperty('iconP1.flipX', flipped)
	end
	

end

function goodNoteHit(id, direction, noteType, isSustainNote)
	if not getPropertyFromGroup('notes', id, 'gfNote') then
	cancelTween('raise')
	setProperty('boyfriend.y', defaultY)
	setProperty('boyfriend.flipX', true)
	end
end

function noteMiss(id, direction, noteType, isSustainNote)
	if not getPropertyFromGroup('notes', id, 'gfNote') then
	cancelTween('raise')
	setProperty('boyfriend.y', defaultY)
	setProperty('boyfriend.flipX', true)
	end
end

function onStepHit() 
	if getProperty('healthBar.percent') < 20 and curStep % 2 == 0 then
		flipped = not flipped
		setProperty('iconP1.flipX', flipped)
	end
	if (curStep % 4 == 0) and getProperty('boyfriend.animation.curAnim.name') == 'idle' then
		flippedIdle = not flippedIdle
		setProperty('boyfriend.flipX', flippedIdle)
		playAnim("boyfriend", "idle", true)
		setProperty('boyfriend.y', getProperty('boyfriend.y') + 20)
		doTweenY('raise', 'boyfriend', getProperty('boyfriend.y') - 20, 0.15, 'cubeOut')
	end
end

function onUpdate(e)
	local angleOfs = math.random(-5, 5)
	if getProperty('healthBar.percent') < 20 then
		setProperty('iconP1.angle', angleOfs)
	else
		setProperty('iconP1.angle', 0)
	end
end

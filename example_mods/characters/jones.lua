function onCreatePost()
	precacheImage('spite/hit')
	setObjectOrder('dadGroup', getObjectOrder('dadGroup')+1)
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
	if not getPropertyFromGroup('notes', id, 'gfNote') and direction == 3 then
		characterPlayAnim('boyfriend', 'hit', true)
		playSound('blubberPunch', 0.5)
		if getProperty('health')>0.08 then
		setProperty('health', getProperty('health')-0.06)
		end
		
		makeAnimatedLuaSprite('hitFX', 'spite/hit', getMidpointX('boyfriend')-500, getMidpointY('boyfriend')-560)
		addAnimationByPrefix('hitFX', 'hit', 'hit', 45, false) 
		objectPlayAnimation('hitFX', 'hit', true)
		scaleObject('hitFX', 4, 4)
		updateHitbox('hitFX')
		setProperty('hitFX'..'.antialiasing', false)
		addLuaSprite('hitFX', true)
		setProperty('iconP1.scale.x', getProperty('iconP1.scale.x')+1.25)
		setProperty('iconP1.scale.x', getProperty('iconP1.scale.y')+1.25)
		doTweenAngle('twistIcon', 'iconP1', 70, 0.2, 'cubeOut')
		cancelTween('twistBack')
	end
end

function onUpdatePost(e)
	if getProperty('hitFX.animation.curAnim.finished') then
		removeLuaSprite('hitFX')
	else
		setProperty('iconP1.animation.curAnim.curFrame', 1)
	end
end

function onTweenCompleted(t)
	if t == 'twistIcon' then
		doTweenAngle('twistBack', 'iconP1', 0, 0.4, 'sineIn')
	end
end
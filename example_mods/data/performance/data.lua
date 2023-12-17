flipped = true
duration = 0
ogY = 0
function onCreatePost()
	duration = getPropertyFromClass('Conductor', 'stepCrochet') * 2 / 1100
	ogY = getProperty('iconP2.y')

end
function onBeatHit() 
		flipped = not flipped
		setProperty('iconP2.flipX', flipped)
		doTweenY('jumpUp', 'iconP2', getProperty('iconP2.y') - 60, duration, 'cubeOut')
		if flipped then
			doTweenAngle('tiltUp', 'iconP2', getProperty('iconP2.angle') + 30, duration, 'sineOut')
		else
			doTweenAngle('tiltUp', 'iconP2', getProperty('iconP2.angle') - 30, duration, 'sineOut')
		end
end

function onTweenCompleted(tag)
		if tag == 'jumpUp' then
			doTweenY('fallDown', 'iconP2', ogY, duration, 'cubeIn')
			if flipped then
				doTweenAngle('tiltUp', 'iconP2', getProperty('iconP2.angle') - 30, duration, 'sineIn')
			else
				doTweenAngle('tiltUp', 'iconP2', getProperty('iconP2.angle') + 30, duration, 'sineIn')
			end
		end
end
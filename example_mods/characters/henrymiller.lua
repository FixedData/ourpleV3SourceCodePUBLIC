flipped = false
function onCreatePost()
	defaultY = getProperty('iconP2.y')
end

function onStepHit()
	if getProperty('healthBar.percent') > 80 then
		flipped = not flipped
		setProperty('iconP2.flipX', flipped)
	end
end

function onUpdatePost()
	local angleOfs = math.random(-2, 2)
	local posXOfs = math.random(-4, 4)
	local posYOfs = math.random(-2, 2)
	if getProperty('healthBar.percent') > 80 then
		angleOfs = math.random(-18, 18)
		posXOfs = math.random(-12, 12)
		posYOfs = math.random(-17, 17)
	else
		setProperty('iconP2.flipX', false)
	end
	setProperty('iconP2.angle', angleOfs)
	setProperty('iconP2.x', getProperty('iconP2.x') + posXOfs)
	setProperty('iconP2.y', defaultY + posYOfs)
end
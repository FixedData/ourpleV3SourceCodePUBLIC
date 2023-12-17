function onEvent(n,v1,v2)


	if n == 'Alarm' then
		makeLuaSprite('vignette','vignette',0, 0)
		scaleObject('vignette', 0.7, 0.7)
		setScrollFactor('vignette', 0, 0)
		setObjectCamera('vignette', 'other')
		setObjectOrder('vignette', getObjectOrder('scanline') - 1)
		addLuaSprite('vignette', true)
		
		if getProperty('memories.visible') == true then
			local curFrame = getProperty('memories.animation.curAnim.curFrame')
			setProperty('memories.animation.curAnim.curFrame', curFrame - 1)
		end
	end



end

function onUpdate()
	if getProperty('vignette.alpha') ~= 0 then 
		setProperty('vignette.alpha', getProperty('vignette.alpha') - 0.04)
	else
		removeLuaSprite('vignette')
	end
end
local dissipate = false
function onEvent(n,v1,v2)


	if n == 'Alter Visibility' then
			if v2 == 'true' then
				setProperty(v1..'.visible', true)
			elseif v2 == 'false' and v1 ~= 'memories' then
				setProperty(v1..'.visible', false)
			end
			
			if v2 == 'false' and v1 == 'memories' then
				dissipate = true
			end
	end



end

function onUpdate()
	if dissipate == true and getProperty('memories.alpha') ~= 0 then
		setProperty('memories.alpha', getProperty('memories.alpha') - 0.02)
	end
end
function onEvent(n,v1,v2)

	if n == 'Add Alpha' then
		alpha = tonumber(v2)
		setProperty(v1..'.alpha', getProperty(v1..'.alpha') + alpha)
		if v1 == 'bg' then
			setProperty('dad.alpha', getProperty(v1..'.alpha'))
		end
	end

end
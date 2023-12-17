function onEvent(n,v1,v2)

	if n == 'Decrease Alpha' then
		alpha = tonumber(v2)
		setProperty(v1..'.alpha', getProperty(v1..'.alpha') - alpha)
	end

end
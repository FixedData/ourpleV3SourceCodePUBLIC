function onEvent(n,v1,v2)

	if n == 'play sound' then
		
		playSound(v1, tonumber(v2))
	end

end
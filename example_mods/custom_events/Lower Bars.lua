function onEvent(n,v1,v2)

	if n == 'Lower Bars' then
		doTweenY('lowerBar', 'barup', getProperty('barup.y') + tonumber(v1), 0.4, 'sineInOut')
		doTweenY('raiseBar', 'bardown', getProperty('bardown.y') - tonumber(v1), 0.4, 'sineInOut')
	end

end
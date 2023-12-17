function onEvent(n,v1,v2)

	if n == 'Object Play Animation' then
		
		if v1 ~= 'dee' and v1 ~= 'peter' and v1 ~= 'steven' then
			playAnim(v1,v2,true)
		end
	end

end
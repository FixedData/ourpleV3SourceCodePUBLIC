visible = false
function onCreate()
	makeLuaSprite('freddy', 'cashmoney/freddy', 0, 0);
	setProperty('freddy.antialiasing', false)
	setScrollFactor('freddy', 0, 0)
	screenCenter('freddy')
	setProperty('freddy.visible', false)
	setObjectCamera('freddy', 'hud')
	addLuaSprite('freddy', true);
end
function onEvent(n,v1,v2)

	if n == 'freddy' then
		visible = not visible
		setProperty('freddy.visible', visible)
	end

end
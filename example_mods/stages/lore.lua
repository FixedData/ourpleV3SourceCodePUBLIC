ringing = false
function onCreate()
	setPropertyFromClass('GameOverSubstate', 'characterName', 'playguy')
	
	makeLuaSprite('wall', 'stage/lore/wall', 0, 0);
	addLuaSprite('wall', false);
	
	makeLuaSprite('floor', 'stage/lore/floor', 0, 1000);
	addLuaSprite('floor', false);
	
	makeLuaSprite('curtains', 'stage/lore/curtain', 0, 220);
	setScrollFactor('curtains', 1.2, 1.2)
	addLuaSprite('curtains', true);
end

function onEvent(n, v1, v2)
	if n == 'ring' then
		if ringing == false then
			playAnim('gf', 'ringstart')
		else
			playAnim('gf', 'ringend')
		end
		ringing = not ringing
	end
end

function onUpdate(e)
	if getProperty('gf.animation.curAnim.name') == 'ringstart' and getProperty('gf.animation.curAnim.finished') then
		playAnim('gf', 'ringloop')
	end
end

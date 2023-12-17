function onCreate()
	setProperty('skipCountdown',true)
	addCharacterToList('altsalvage', 'dad')
	setPropertyFromClass('GameOverSubstate', 'characterName', 'brooketrapped')
	makeLuaSprite('stage', 'stage/trapped/stage', 0, 0);
	addLuaSprite('stage', false);
	
	makeLuaSprite('gradient', 'stage/trapped/gradient', 0, 0);
	addLuaSprite('gradient', true);
	
	makeLuaSprite('wires', 'stage/trapped/wires', 0, 0);
	setScrollFactor('wires', 1.3, 1.3)
	addLuaSprite('wires', true);

	makeLuaSprite("blackbg")
	makeGraphic("blackbg", screenWidth, screenHeight, '000000')
	addLuaSprite("blackbg",true);
	setObjectCamera("blackbg", 'other')
end

function onCreatePost()
	setProperty('camFollowPos.x', getMidpointX('boyfriend'))
	setProperty('camFollowPos.y', getMidpointY('boyfriend'))
	setProperty('camZooming', true)
	setProperty('hudAssets.alpha',0);
	setProperty('iconP1.alpha',0);
	setProperty('iconP2.alpha',0);
	setProperty('stars.alpha',0);
	setProperty('timeBarBG.visible',false);
	setProperty('timeBar.visible',false);
	setProperty('timeTxt.visible',false);
end

function onEvent(n, v1, v2)
	if (n == 'trappedend') then
		doTweenAlpha('fade1', 'stage', 0, 10, 'sineInOut')
		doTweenAlpha('fade2', 'wires', 0, 10, 'sineInOut')
		doTweenAlpha('fade3', 'dad', 0, 10, 'sineInOut')
	end
	if (n == 'Set Property') then
		if (v1 == 'camOffset') then
			setProperty('timeBar.visible',true);
			setProperty('timeBarBG.visible',true);
			setProperty('timeTxt.visible',true );
		end
	end
end
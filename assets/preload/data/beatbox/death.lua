
function onCreate()
    precacheImage("gameovers/beatboxgameover", true)
	setPropertyFromClass('GameOverSubstate', 'endSoundName', '')
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', '')
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', '')
end

function onGameOverStart()
    playSound("bbdeath", 1)
    setProperty("boyfriend.visible", false)
    makeAnimatedLuaSprite("death", 'gameovers/beatboxgameover', 0, 0, "sparrow")
    addAnimationByPrefix("death", "i", "i", 10, false)
    setGraphicSize("death", screenWidth, screenHeight, true)
    playAnim("death", "i")
    setScrollFactor("death", 0.0, 0.0)
    setPropertyFromClass('flixel.FlxG', 'camera.x', 0)
	setPropertyFromClass('flixel.FlxG', 'camera.y', 0)
	setPropertyFromClass('flixel.FlxG', 'camera.zoom', 1)
    runTimer("start", 0.7)
   
    addLuaSprite("death", true)
end

function onTimerCompleted(r)
    if r == 'start' then
        runHaxeCode([[
            FlxG.resetState();
        ]])
    end
    
end
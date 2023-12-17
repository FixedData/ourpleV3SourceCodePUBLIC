
function onCreate()
    precacheImage("gameovers/faznewsgameover", true)
	setPropertyFromClass('GameOverSubstate', 'endSoundName', '')
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', '')
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', '')
end

function onGameOverStart()
    playSound("bbdeath", 1,'explode')
    setProperty("boyfriend.visible", false)
    makeLuaSprite("death", 'gameovers/faznewsgameover', 0, 0)
    setGraphicSize("death", screenWidth + 2, screenHeight, true)
    setScrollFactor("death", 0.0, 0.0)
    setPropertyFromClass('flixel.FlxG', 'camera.x', 0)
	setPropertyFromClass('flixel.FlxG', 'camera.y', 0)
	setPropertyFromClass('flixel.FlxG', 'camera.zoom', 1)
    addLuaSprite("death", true)
    runTimer("yes", 0.2)
end


function onTimerCompleted(r)
    if r == 'yes'then
        stopSound("explode")
    end
end
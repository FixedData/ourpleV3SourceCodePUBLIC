local counter = 0
local followed = false
function onPause()
    if songName == 'followed' then
        followed = true
    end
    if getRandomBool(1) and not followed then
        makeAnimatedLuaSprite('horse'..counter,'veryimportant/horseguy',-500,getRandomInt(0,600))
        addAnimationByPrefix('horse'..counter,'walk','horseWALK',1000)
        addLuaSprite('horse'..counter,true)
        setObjectCamera("horse"..counter, 'other')
        scale = getRandomFloat(0.3, 1)
        scaleObject("horse"..counter, getRandomFloat(0.1, 2.2),getRandomFloat(0.1, 1.5), true)
        doTweenX('horsewalk'..counter, 'horse'..counter, 1800, 20)
        counter = counter + 1     
    end

end

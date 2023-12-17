local HP = 15
local counter = 1

function onCreatePost()
    setProperty('healthBarBG.alpha', 0);
    setProperty('scoreTxt.alpha', 0);
    setProperty('healthBar.alpha', 0);
    setProperty('iconP1.alpha', 0);
    setProperty('iconP2.alpha', 0);

    makeAnimatedLuaSprite('bar', 'barFuck', getProperty('healthBar.x') + 25, getProperty('healthBar.y') - 50);
    makeAnimatedLuaSprite('gauge', 'barFuck', getProperty('healthBar.x') + 25, getProperty('healthBar.y') - 50);
    makeAnimatedLuaSprite('FollowedIcon', 'FollowedIcon', getProperty('healthBar.x') - 75, getProperty('healthBar.y') - 125)
    

    addAnimationByPrefix('FollowedIcon', 'Normal', 'SinnohIcon', 24, true);
    addAnimationByPrefix('FollowedIcon', 'Losing', 'LoseIcon', 24, true);

    for i = 1, 15 do
        opposite = 16 - i
        addAnimationByPrefix('bar', i .. 'Bar', opposite .. 'Bar', 24, true)
    end

    for i = 1, 19 do
        addAnimationByPrefix('gauge', i .. 'Gauge', i .. 'Gauge', 24, true)
    end

    setObjectCamera('bar', 'HUD');
    setObjectCamera('gauge', 'HUD');
    setObjectCamera('FollowedIcon', 'HUD');

    scaleObject('FollowedIcon', 1.25, 1.25);
    scaleObject('bar', 1.5, 1.5);
    scaleObject('gauge', 1.5, 1.5);

    addLuaSprite('bar');
    addLuaSprite('gauge');
    addLuaSprite('FollowedIcon');
    setProperty('bar.antialiasing', false)
    setProperty('gauge.antialiasing', false)
    setProperty('FollowedIcon.antialiasing', false)

    playAnim('bar', HP .. 'Bar', true);

end

function onBeatHit()
    if curBeat % 2 == 0 then
        cancelTween("FollowedIconX")
        cancelTween("FollowedIconY")
        scaleObject('FollowedIcon', 1.4, 1.4)
        doTweenX("FollowedIconX", "FollowedIcon.scale", 1.25, 0.5, "sineout")
        doTweenY("FollowedIconY", "FollowedIcon.scale", 1.25, 0.5, "sineout")
    end

end

function goodNoteHit(a, b, c, isSustain)
    if not isSustain then
        counter = counter + 1
    end

    if counter == 21 and HP ~= 15 and not isSustain then
        counter = 0
        HP = HP + 1
    end

    if counter >= 20 then
        counter = 20
    end

    if HP >= 15 then
        HP = 15
    end

    if HP <= 3 then
        playAnim('FollowedIcon', 'Losing', true)
    else
        playAnim('FollowedIcon', 'Normal', true)
    end

    playAnim('gauge', counter .. 'Gauge', true)
    playAnim('bar', HP .. 'Bar', true)
end

function noteMiss(a,b,c, sus)
    --debugPrint('missedNote HP: ' .. HP)
    HP = HP - 1
    counter = 0
    --debugPrint('missedNote Post HP: ' .. HP)
    playAnim('gauge', counter .. 'Gauge', true)
    playAnim('bar', HP .. 'Bar', true)
    if HP <= 3 then
        playAnim('FollowedIcon', 'Losing', true)
    else
        playAnim('FollowedIcon', 'Normal', true)
    end
    if HP <= 0 then
        setProperty('health', 0)
    end
end

function noteMissPress()
   -- debugPrint('missedNotePress HP: ' + HP)
    HP = HP - 1
    counter = 0
   -- debugPrint('missedNotePress Post HP: ' + HP)
    playAnim('gauge', counter .. 'Gauge', true)
    playAnim('bar', HP .. 'Bar', true)
    if HP <= 3 then
        playAnim('FollowedIcon', 'Losing', true)
    else
        playAnim('FollowedIcon', 'Normal', true)
    end

    if HP <= 0 then
        setProperty('health', 0)
    end
end

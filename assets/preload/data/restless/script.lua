vsp = 0
hsp = 0
function onCreatePost()
	setPropertyFromClass('GameOverSubstate', 'characterName', 'cryingchild')
	setPropertyFromClass('GameOverSubstate', 'endSoundName', '')
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', '')
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'wind')
end
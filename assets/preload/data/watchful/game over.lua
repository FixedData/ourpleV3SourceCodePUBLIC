
function onCreate()
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', '')
end




function onGameOverStart()
	
	setPropertyFromClass('GameOverSubstate', 'char.alpha', 0);
	restartSong();
	return Function_Stop
  end


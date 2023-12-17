function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		--Check if the note is an Spite Note
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Spite Note' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'spite/spitenote_Assets'); --Change texture
			setPropertyFromGroup('unspawnNotes', i, 'hitHealth', 0); --Default value is: 0.023, health gained on hit
			setPropertyFromGroup('unspawnNotes', i, 'missHealth', 0); --Default value is: 0.0475, health lost on miss
			setPropertyFromGroup('unspawnNotes', i, 'hitCausesMiss', false);
			setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true)

			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then --Doesn't let Dad/Opponent notes get ignored
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', false); --Miss has no penalties
			end
		end
	end
	--debugPrint('Script started!')
end
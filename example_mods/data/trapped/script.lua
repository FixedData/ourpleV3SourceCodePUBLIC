spamperc = false
spamzoom = false;
function onEvent(n, v1, v2)
	if (n == 'Set Property') then
		if (v1 == 'camOffset') then
			setProperty('timeBar.visible',true);
			setProperty('timeBarBG.visible',true);
			setProperty('timeTxt.visible',true );
		end
	end
	if (n == '') then
		if (v1 == 'percs') then
			spamperc = true;
			setProperty("boyfriend.stunned",true)
			playAnim("altBoyfriend", "perc", true)
		end
	end
	if (n == '') then
		if (v1 == 'hesfading') then
			setProperty('isCameraOnForcedPos',true)
			doTweenX("camFollowX", "camFollow", getGraphicMidpointX('dad') + 20, 5, "sineinout")
			doTweenY("camFollowY", "camFollow", getGraphicMidpointY('dad') - 100, 5, "sineinout")
			doTweenY("camFollowPosY", "camFollowPos", getGraphicMidpointY('dad') - 100, 5, "sineinout")
			doTweenX("camFollowPosX", "camFollowPos", getGraphicMidpointX('dad') + 20, 5, "sineinout")
		end

		if (v1 == 'trappedend') then
			setProperty('isCameraOnForcedPos',true)

			doTweenX("camFollowX", "camFollow", 2000/2, 3, "sineinout")
			doTweenX("camFollowPosX", "camFollowPos", 2000/2, 3, "sineinout")

			doTweenY("camFollowY", "camFollow", 1120/2, 3, "sineinout")
			doTweenY("camFollowPosY", "camFollowPos", 1120/2, 3, "sineinout")

			setProperty('defaultCamZoom',0.8)
			doTweenZoom("zoomcompl", "camGame", 0.8, 3, "sineinout")

			doTweenAlpha("byehud", "camHUD", 0, 3, "sineinout")
			cameraFade("game", "0x000000", 6, true)
			setProperty('beatsPerZoom',111111111)

		end

	end
end



function onUpdatePost(elapsed)
	if spamperc then
		playAnim("altBoyfriend", "perc", true)
	end
end



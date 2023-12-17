-- Event notes hooks
function onEvent(name, value1, value2)
	if name == 'Camera Zoom Speed' then
		camSpeed = value1
		camInt = value2
	end
end
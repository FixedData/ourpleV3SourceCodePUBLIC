function onEvent(name,value1,value2)

    if name == "Set CamZoom" then
        
        setProperty("defaultCamZoom",value1) 
        if not value2 == '' then
            setProperty("camGame.zoom",value1) 
	end
            
    end


end
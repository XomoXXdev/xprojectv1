local nextLevel = 0
addEventHandler("onClientElementDataChange",root,function(theKey,oValue,nValue)
    if (theKey == "player:minutes") then 
        if getElementData(localPlayer,"player:loggedIn") then 
            level = getElementData(localPlayer,"player:level") 
            minutes = getElementData(localPlayer,"player:minutes")

            nextLevel = level + 1

            if level ~=  100 then 
                if levels[nextLevel][1] == minutes then 
                    --outputChatBox("fosfos")
                triggerServerEvent("setLevel",localPlayer,localPlayer,nextLevel,levels[nextLevel][2])
                end 
            end
        end 
    end 
end)
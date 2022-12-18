addEvent("givelicenses",true)
function givelicense(player,item,value,count,dutyitem,state)

    if item ~= 130 then exports["inventory"]:giveItem(player,item,value,1,0,1)
        outputChatBox("#8163bf[xProject]:#ffffff Sikeresen igényeltél egy #8163bf'"..exports.inventory:getItemName(item).."-t'#ffffff.",player,255,255,255,true)
        local money = getElementData(player,"player:money")
        setElementData(player,"player:money",money-100)
    elseif item == 130  then
            if exports.inventory:hasItem(player,136,1) then
                exports.inventory:takeItem(player,136,1)
              exports["inventory"]:giveItem(player,item,value,1,0,1)

                outputChatBox("#8163bf[xProject]:#ffffff Sikeresen igényeltél egy #8163bf'"..exports.inventory:getItemName(item).."-t'#ffffff.",player,255,255,255,true)
                local money = getElementData(player,"player:money")
                setElementData(player,"player:money",money-100)
              
            end
        end
    end

addEventHandler("givelicenses",root,givelicense)
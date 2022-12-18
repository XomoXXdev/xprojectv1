func.setPlayerInDuty = function(playerSource,state,groupid)
    local playerDbid = getElementData(playerSource,"player:dbid");
    local memberData = exports.Pdash:getPlayerGroupData(groupid,playerDbid);
    if state then
        setElementModel(playerSource,memberData.skin)
        local playerItems = exports.Pdash:getPlayerDutyItems(playerSource,groupid);
        for k,v in pairs(playerItems) do
            if v.equip then
                exports.inventory:giveItem(playerSource,v.item,1,v.count,1)
            end
        end
    else
        setElementModel(playerSource,getElementData(playerSource,"player:skin"))
        exports.inventory:takeDutyItems(playerSource)
        
    end
end
addEvent("setPlayerInDuty",true)
addEventHandler("setPlayerInDuty",getRootElement(),func.setPlayerInDuty)
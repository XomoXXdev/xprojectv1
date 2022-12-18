local carLicense = {};


addEvent("jogsi.givecar",true);
addEventHandler("jogsi.givecar",root,function(player)
    local x,y,z = getElementPosition(player);
    local veh = createVehicle(405,x,y,z);
    setElementData(player,"jogsi.veh",veh)
    setVehicleEngineState(veh,true);
    warpPedIntoVehicle(player,veh)
end);

addEvent("jogsi.end",true);
addEventHandler("jogsi.end",root,function(player)
    local veh = getPedOccupiedVehicle(player);
    if veh then 
        destroyElement(veh);
     local item =   exports["inventory"]:giveItem(player,136,1,1,0,0)

                if item then 
                    outputChatBox("#8163bf[xProject]:#ffffff Sikeres gyakorlati vizsga.",player,255,255,255,true)
                end
            end
end);

addEvent("jogsi.getData",true);
addEventHandler("jogsi.getData",root,function(player,id)
    if carLicense[id] then 
        local temp = carLicense[id];
        local datas = {};
        local x = fromJSON(temp["adatok"]);
        datas[1] = x[1];
        datas[2] = x[2];
        datas[3] = temp["date"];
        datas[4] = temp["exdate"];
        datas[5] = temp["id"];
        triggerClientEvent(player,"jogsi.returnDatas",player,datas);
    end
end);


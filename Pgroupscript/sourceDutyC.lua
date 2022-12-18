fileDelete ("sourceDutyC.lua") 
local func = {};
local cache = {
    duty = {
        hit = {
            group = -1;
        };
    };
};

local duty = {
    { --LVPD[rendor]
        position = {2180.59375, 2586.5205078125, 6.765625};
        interior = 0;
        dimension = 0;
        group = 1;
    };
    {--LVTS[szerelo]
        position = { -780.9208984375, 488.9912109375, 1376.1953125};
        interior = 1;
        dimension = 383;
        group = 2;

    };
    {
        position = {1573.560546875, -1683.05078125, 16.191499710083};
        interior = 0;
        dimension = 0;
        group = 2;
    };
	{
        position = {1168.787109375, -1344.337890625, 15.4140625};
        interior = 0;
        dimension = 0;
        group = 11;
    };
	{
        position = {1766.169921875, -1141.3583984375, 24.155765533447};
        interior = 0;
        dimension = 0;
        group = 4;
    };
};

func.start = function()
    for k,v in ipairs(duty) do
        local pickup = createPickup (v.position[1],v.position[2],v.position[3],3,1275)
        setElementInterior(pickup,v.interior)
        setElementDimension(pickup,v.dimension)
        setElementData(pickup,"duty:pickup",true)
        setElementData(pickup,"duty:pickup:group",v.group)
    end
end
addEventHandler("onClientResourceStart",resourceRoot,func.start)

func.pickupHit = function(hitPlayer, matchingDimension)
    if getElementData(source,"duty:pickup") and hitPlayer == localPlayer then
		outputChatBox( "#8163bf[xProject] #ffffffA szolgálatba lépéshez nyomj #8163bf'e' #ffffffbetüt.", 255, 255, 255, true )
		exports.Pinfobox:addNotification( "A szolgálatba lépéshez nyomj 'e' betüt!", "info" )
		if cache.duty.hit.group == -1 then
            cache.duty.hit.group = getElementData(source,"duty:pickup:group");
            bindKey("e","down",func.dutyKey)
		end
	end
end
addEventHandler("onClientPickupHit", getRootElement(),func.pickupHit)

func.pickupLeave = function(hitPlayer, matchingDimension)
    if getElementData(source,"duty:pickup") and hitPlayer == localPlayer then
		if cache.duty.hit.group ~= -1 then
            cache.duty.hit.group = -1;
            unbindKey("e","down",func.dutyKey)
		end
	end
end
addEventHandler("onClientPickupLeave", getRootElement(), func.pickupLeave)

func.dutyKey = function()
    local isGroup,data = exports.Pdash:isPlayerInGroup(cache.duty.hit.group,getElementData(localPlayer,"player:dbid"));
    if isGroup then
        if data.skin > 0 then
            if not isTimer(dutyTimer) then
                if not getElementData(localPlayer,"player:inDuty") then
                    setElementData(localPlayer,"player:inDuty",true);
                    exports.Pinfobox:addNotification("Sikeresen szolgálatba léptél.","success")
                else
                    setElementData(localPlayer,"player:inDuty",false);
                    exports.Pinfobox:addNotification("Sikeresen leadtad a szolgálatot.","success")
                end
                triggerServerEvent("setPlayerInDuty",localPlayer,localPlayer,getElementData(localPlayer,"player:inDuty"),cache.duty.hit.group)
                dutyTimer = setTimer(function() killTimer(dutyTimer) end,30000,1)
            else
                exports.Pinfobox:addNotification("Félpercenként csak egyszer dutyzhatsz.","error")
            end
        else
            exports.Pinfobox:addNotification("Nincs beállítva dutyskin.","error")
        end
    else
        exports.Pinfobox:addNotification("Nem vagy tagja ennek a szervezetnek.","error")
    end
end
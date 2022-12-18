fileDelete ("sourceC.lua") 
local func = {};
local cache = {
    cuplung = false;
    inject = 0;
    vehicle = nil;
};
local screenSize = {guiGetScreenSize()}
local screenSize = {guiGetScreenSize()}
screenSize.x, screenSize.y = screenSize[1], screenSize[2]
local timer = nil;
local blocker = false 
local width, height = 800, 450
local startX, startY = (screenSize.x - width) / 2, (screenSize.y - height) / 2
local nonSeatbeltableCars = {
    ["472"] = true,
    ["473"] = true,
    ["493"] = true,
    ["595"] = true,
    ["484"] = true,
    ["430"] = true,
    ["453"] = true,
    ["452"] = true,
    ["446"] = true,
    ["453"] = true,
    ["581"] = true,
    ["509"] = true,
    ["481"] = true,
    ["462"] = true,
    ["521"] = true,
    ["463"] = true,
    ["510"] = true,
    ["522"] = true,
    ["461"] = true,
    ["448"] = true,
    ["468"] = true,
    ["586"] = true,
    ["510"] = true,
}

func.vehicleEnter = function(thePlayer, seat)
    if thePlayer == getLocalPlayer() then
        if seat == 0 then
            if getElementData(source,"vehicle:engine") == 0 then 
            outputChatBox("#8163bf[xProject]:#ffffff A jármű beindításához használd  #8163bf'J'#ffffff betűt, majd kétszer nyomd le a #8163bfjobbra nyilat#ffffff miközbe nyomva tartod a #8163bf'J'#ffffff betűt.",255,255,255,true)
            end
        end
    end
end
addEventHandler("onClientVehicleEnter", getRootElement(), func.vehicleEnter)

func.onClientKey = function(button,state)   
if not isChatBoxInputActive() then 
    local vehicle = getPedOccupiedVehicle(localPlayer);
    
    if button == "j" then
        if state then
            local vehicle = getPedOccupiedVehicle(localPlayer);
            local seat = getPedOccupiedVehicleSeat(localPlayer);
            if vehicle and seat == 0 then
                local model = getElementModel(vehicle);
                if not (enginelessVehicle[model]) then
                    if getVehicleEngineState(vehicle) then
                        triggerServerEvent("setVehicleEngine",localPlayer,localPlayer,vehicle,false)
                        exports.Pchat:takeMessage("me","leállítja a jármű motorját.");
                        toggleControl('brake_reverse', false)
                    else
                        local dbid = getElementData(vehicle,"vehicle:dbid") or -1;
                        if (exports.inventory:hasItem(105,dbid) or getElementData(localPlayer,"player:adminduty")) or not getElementData(vehicle,"vehicle:dbid") then
                            cache.cuplung = true;
                            cache.vehicle = vehicle;
                        else
                            exports.Pinfobox:addNotification("Nincs kulcsod ehhez a járműhöz.","error")
                        end
                    end
                end
            end
        else
            cache.inject = 0;
            cache.cuplung = false;
            cache.vehicle = nil;
            if isTimer(timer) then
                killTimer(timer);
            end
        end
    end
    if button == "space" then
        if state then
            if cache.cuplung then
                if cache.inject < 2 then
                    cache.inject = cache.inject+1;
                    if cache.inject == 1 then
                        exports.Pchat:takeMessage("me","ráadja a gyújtást a járműre.")
                        triggerServerEvent("setVehicleLight",localPlayer,localPlayer,cache.vehicle,1)
                    elseif cache.inject == 2 then
                        triggerServerEvent("setVehicleLight",localPlayer,localPlayer,cache.vehicle,0)
                        if getElementHealth(cache.vehicle) <= 321 then
                            playSound("files/nemindul.mp3")
                        else
                            playSound("files/indul.mp3")
                        end
                        if isTimer(timer) then
                            killTimer(timer);
                        end
                        toggleControl('brake_reverse', true)
                        timer = setTimer(function()
                            if getKeyState("space") then
                                if getElementHealth(cache.vehicle) <= 321 or getElementData(cache.vehicle,"vehicle:fuel") == 0 then
                                    exports.Pchat:takeMessage("me","megpróbálja beindítani a jármű motorját, de nem sikerül neki.")
                                else
                                    triggerServerEvent("setVehicleEngine",localPlayer,localPlayer,cache.vehicle,true)
                                    exports.Pchat:takeMessage("me","beindítja a jármű motorját.");
                                end
                            end
                            killTimer(timer);
                        end,1000,1)
                    end
                end
            else

            end
        end
    end
    if button == "F5" then 
        if state then 
            local vehicle = getPedOccupiedVehicle(localPlayer);
            local seat = getPedOccupiedVehicleSeat(localPlayer);
            if vehicle then 
                local model = getElementModel(vehicle)

                    if not blocker then 
                        if not getElementData(localPlayer,"player:seatbelt") then 
                            setElementData(localPlayer,"player:seatbelt",true)
                            exports.Pchat:takeMessage("me","bekötötte a biztonsági övét.");
                            playSound("files/fastenseatbelt.mp3")
                            blocker = true  

                            setTimer(function()
                                blocker = false 
                            end,1500,1)

                        else 
                            setElementData(localPlayer,"player:seatbelt",false)
                            exports.Pchat:takeMessage("me","kikötötte a biztonsági övét.");
                            playSound("files/fastenseatbelt.mp3")
                            blocker = true 

                            setTimer(function()
                                blocker = false 
                            end,1500,1)
                        end 
                    else 
                        cancelEvent()
                    end

            end 
        end 
    end 
    if button == "f" or button == "g" then 
        if state then 
            local vehicle = getPedOccupiedVehicle(localPlayer);

            if vehicle then 
                if getElementData(localPlayer,"player:seatbelt") then 
                    exports["Pinfobox"]:addNotification("Először kösd ki az övet. (F5)","error")
                    cancelEvent()
                end 
            end 
        end 
    end 
    if button == "l" then 
        if state then 
            local vehicle = getPedOccupiedVehicle(localPlayer);
            local seat = getPedOccupiedVehicleSeat(localPlayer);

            if vehicle and seat == 0 then 
                if not blocker then 
                    if getElementData(vehicle,"vehicle:lights") == 0 then 
                    triggerServerEvent("setVehicleLight",localPlayer,localPlayer,vehicle,1)
                    exports.Pchat:takeMessage("me","felkapcsolta az autó lámpáit.");
                    else 
                    triggerServerEvent("setVehicleLight",localPlayer,localPlayer,vehicle,0)
                    exports.Pchat:takeMessage("me","lekapcsolta az autó lámpáit.");
                    end 

                    blocker = true  

                    setTimer(function()
                        blocker = false 
                    end,1500,1)
                else 
                    cancelEvent()
                end 
            end 
        end 
    end 

    if button == "lalt" then 
        
        if state then 
            local vehicle = getPedOccupiedVehicle(localPlayer);
            local seat = getPedOccupiedVehicleSeat(localPlayer);

            setTimer(function()

            if vehicle and seat == 0 then 
                if not blocker then
                   if not getElementData(localPlayer,"player:afk") then  

                    if getElementData(vehicle,"vehicle:handbrake") == 0 then 
                        if getElementSpeed(vehicle,"kmh") < 1 then 
                        triggerServerEvent("setVehicleHandbrake",localPlayer,localPlayer,vehicle,1)
                        exports.Pchat:takeMessage("me","behúzza a kéziféket.");
                        playSound("files/handbrake.mp3")
                        end 
                    else 
                        triggerServerEvent("setVehicleHandbrake",localPlayer,localPlayer,vehicle,0)
                        exports.Pchat:takeMessage("me","kiengedi a kéziféket.");
                    end 

                    blocker = true  

                    setTimer(function()
                       blocker = false 
                    end,1500,1)
                
                    end 
                else 
                    cancelEvent()
                end

            end 

        end,300,1)
        end

    end 
end 
end
addEventHandler("onClientKey",getRootElement(),func.onClientKey)

local maxDistanceToOpen = 2

local components = {
    {"bonnet_dummy", 0, "motorháztető"},
    {"boot_dummy", 1, "csomagtartó"},
    {"door_lf_dummy", 2, "bal első"},
    {"door_rf_dummy", 3, "jobb első"},
    {"door_lr_dummy", 4, "bal hátsó"},
    {"door_rr_dummy", 5, "jobb hátsó"},
}

function getNearbyVehicle(e)
    if e == localPlayer then
        local shortest = {5000, nil, nil}
        local px,py,pz = getElementPosition(localPlayer)
        for k,v in pairs(getElementsByType("vehicle", root, true)) do
            local locked = getElementData(v, "vehicle:locked") == 1
            local x,y,z = getElementPosition(v)
            local firstDist = getDistanceBetweenPoints3D(x,y,z,px,py,pz)
            if firstDist < 4 then
                for k2,v2 in pairs(components) do
                    local x,y,z = getVehicleComponentPosition(v, v2[1], "world")
                    if x and y and z then
                        local dist = getDistanceBetweenPoints3D(x,y,z,px,py,pz)
                        if v2[1] == "bonnet_dummy" then
                            if dist < shortest[1] and dist < 3 and not locked then
                                shortest = {dist, v, v2}
                            end
                        else
                            if dist < shortest[1] and dist < maxDistanceToOpen and not locked then
                                shortest = {dist, v, v2}
                            end
                        end
                    end
                end
            end
        end
        if not shortest[2] or shortest[2] and not isElement(shortest[2]) then
            return false
        else
            return shortest
        end
    end
end

function interactVeh()
    if isTimer(spamTimer) then return end
    spamTimer = setTimer(function() end, 600, 1)
	if isCursorShowing() then return end
    if getPedWeapon(localPlayer) ~= 0 then return end
    if not getPedOccupiedVehicle(localPlayer) then
        local veh = getNearbyVehicle(localPlayer)
        if veh then
            local dist, element, componentDetails = unpack(veh)
            local newState = getVehicleDoorOpenRatio(element, componentDetails[2]) == 1
            triggerServerEvent("changeDoorState2", localPlayer, element, componentDetails[2], newState)
            if not newState then
                if componentDetails[2] >= 2 then
                    playSound("files/dooropen.mp3")
                else
                    playSound("files/dooropen.mp3")
                end
            else
                if componentDetails[2] >= 2 then
                    playSound("files/doorclose.mp3")
                else
                    playSound("files/doorclose.mp3")
                end
            end
        end
    end
end
bindKey("mouse2", "down", interactVeh)

function getElementSpeed(element,unit)
	if (unit == nil) then unit = 0 end
	if (isElement(element)) then
		local x,y,z = getElementVelocity(element)
		if (unit=="mph" or unit==1 or unit =='1') then
			return (x^2 + y^2 + z^2) ^ 0.5 * 100
		else
			return (x^2 + y^2 + z^2) ^ 0.5 * 161
		end
	else
		return false
	end
end

func.render = function()
    local pX,pY,pZ,_,_,_ = getCameraMatrix()
    for k,v in pairs(getElementsByType("vehicle")) do 
        if isElementStreamedIn(v) then 
                local vehX,vehY,vehZ = getElementPosition(v)
                local x,y = getScreenFromWorldPosition(vehX,vehY,vehZ + 1)
                local distance = getDistanceBetweenPoints3D(vehX,vehY,vehZ,pX,pY,pZ)
                    if distance <= 30 then 
                        local line = isLineOfSightClear(vehX,vehY,vehZ + 1,pX,pY,pZ, true, true, false, true, false, false, false, localPlayer)

                        if line then 
                            if x and y then 

                                local model = getElementModel(v)
                                local hp = getElementHealth(v)
                                hp = math.floor(hp)



                                if getElementData(v,"vehicle:dbid") then 
                                dxDrawText("ID: "..getElementData(v,"vehicle:dbid").." Model: "..model.." HP:"..hp,x - 1,y + 1,x,y,tocolor(0,0,0,255),1,"default","center","center",false,false,false,true)
                                dxDrawText("ID: "..getElementData(v,"vehicle:dbid").." Model: "..model.." HP:"..hp,x,y,x,y,tocolor(255,255,255,255),1,"default","center","center",false,false,false,true)
                                else 
                                dxDrawText("ID: Ideiglenes jármű".." Model: "..model.." HP:"..hp,x - 1,y + 1,x,y,tocolor(0,0,0,255),1,"default","center","center",false,false,false,true)
                                dxDrawText("ID: Ideiglenes jármű".." Model: "..model.." HP:"..hp,x,y,x,y,tocolor(255,255,255,255),1,"default","center","center",false,false,false,true)
                                end
                            end 
                        end 
                    end    
        end 
    end 
end 

func.nearby = function()
    if getElementData(localPlayer,"player:admin") >= 1 then
        if not cache.nearby then
            cache.nearby = true 
            addEventHandler("onClientRender",getRootElement(),func.render)
            outputChatBox("[xProject]:#ffffff Jármű információ megjelenítve.",246,137,52,true)
        else
            cache.nearby = false
            removeEventHandler("onClientRender",getRootElement(),func.render)
            outputChatBox("[xProject]:#ffffff Jármű információ eltüntetve.",246,137,52,true)
        end
    end
end
addCommandHandler("nearbyvehicle",func.nearby)

local sx,sy = guiGetScreenSize()

local plate = dxCreateFont("files/LicensePlate.ttf",20)

func.licenseplate = function()
    local pX,pY,pZ,_,_,_ = getCameraMatrix()
    for k,v in pairs(getElementsByType("vehicle")) do 
        if isElementStreamedIn(v) then 
                local vehX,vehY,vehZ = getElementPosition(v)
                local x,y = getScreenFromWorldPosition(vehX,vehY,vehZ + 1)
                local distance = getDistanceBetweenPoints3D(vehX,vehY,vehZ,pX,pY,pZ)
                    if distance <= 20 then 
                        local line = isLineOfSightClear(vehX,vehY,vehZ + 1,pX,pY,pZ, true, true, false, true, false, false, false, localPlayer)

                        if line then 
                            if x and y then 

                                if not getPedOccupiedVehicle(localPlayer) then 
                                
                                    text = getVehiclePlateText(v)

                                    dxDrawImage(x - 50,y - 70,sx*0.05,sy*0.05,"files/plate.png")
                                    dxDrawText(text,x - 5 - 1,y - 45 + 1,x,y,tocolor(0, 0, 0,255),0.00035*sx,plate,"center","top")
                                    dxDrawText(text,x - 5,y - 45,x,y,tocolor(12, 90, 213,255),0.00035*sx,plate,"center","top")
                                    
                                    else 
                                        if getPedOccupiedVehicle(localPlayer) ~= v then 
                                        text = getVehiclePlateText(v)

                                        dxDrawImage(x - 50,y - 70,sx*0.05,sy*0.05,"files/plate.png")
                                        dxDrawText(text,x - 5 - 1,y - 45 + 1,x,y,tocolor(0, 0, 0,255),0.00035*sx,plate,"center","top")
                                        dxDrawText(text,x - 5,y - 45,x,y,tocolor(12, 90, 213,255),0.00035*sx,plate,"center","top")
                                        end
                                    end
                                
                            end 
                        end 
                    end    
        end 
    end 
end 

func.showplate = function()
    if getElementData(localPlayer,"player:admin") >= 1 then
        if not cache.showplate then
            cache.showplate = true 
            addEventHandler("onClientRender",getRootElement(),func.licenseplate)
            outputChatBox("[xProject]:#ffffff Rendszámok megjelenítve.",246,137,52,true)
        else
            cache.showplate = false
            removeEventHandler("onClientRender",getRootElement(),func.licenseplate)
            outputChatBox("[xProject]:#ffffff Rendszámok eltüntetve.",246,137,52,true)
        end
    end
end

bindKey("F10","down",func.showplate)

local sx,sy = guiGetScreenSize()
local x,y = sx*0.89,sy*0.59
local click = false
local showcveh = false

local comp = {}
comp.boot_dummy = false 
comp.bonnet_dummy = false 
comp.door_rf_dummy = false 
comp.door_rb_dummy = false 
comp.door_lf_dummy = false 
comp.door_lb_dummy = false

addEventHandler("onClientPlayerVehicleExit",root,function()
    if showcveh then 
        showcveh = false 
        removeEventHandler("onClientRender",root,drawCveh)
        comp.boot_dummy = false 
        comp.bonnet_dummy = false 
        comp.door_rf_dummy = false 
        comp.door_rb_dummy = false 
        comp.door_lf_dummy = false 
        comp.door_lb_dummy = false
    end 
end)

addEventHandler("onClientPlayerVehicleEnter",root,function(veh)
    if getVehicleDoorOpenRatio(veh,0) == 1 then 
        comp.bonnet_dummy = true 
    end 
    if getVehicleDoorOpenRatio(veh,1) == 1 then 
        comp.boot_dummy = true 
    end 
    if getVehicleDoorOpenRatio(veh,2) == 1 then 
        comp.door_lf_dummy = true 
    end 
    if getVehicleDoorOpenRatio(veh,3) == 1 then 
        comp.door_rf_dummy = true 
    end 
    if getVehicleDoorOpenRatio(veh,4) == 1 then 
        comp.door_lb_dummy = true 
    end 
    if getVehicleDoorOpenRatio(veh,5) == 1 then 
        comp.door_rb_dummy = true 
    end 
end)

addCommandHandler("cveh",function()
    if not getPedOccupiedVehicle(localPlayer) then return end
    if getPedOccupiedVehicleSeat(localPlayer) == 0 then 
        if not showcveh then 
            showcveh = true 
            addEventHandler("onClientRender",root,drawCveh)
        else 
            showcveh = false 
            removeEventHandler("onClientRender",root,drawCveh)
        end 
    end 
end)

function drawCveh()
    if isCursorShowing(localPayer) then 
        cursorX, cursorY = getCursorPosition()
        cursorX, cursorY = cursorX * sx, cursorY * sy	
    
        if click then 
          x,y = cursorX + windowOffsetX, cursorY + windowOffsetY
        end 
    end 

    dxDrawImage(x,y,sx*0.1,sy*0.11,"files/cveh.png",0,0,0,tocolor(255,255,255,255))

    if not comp.boot_dummy then 
    dxDrawImage(x,y,sx*0.1,sy*0.11,"files/track.png",0,0,0,tocolor(255,255,255,255)) --x + sx*0.0395,y + sy*0.076,sx*0.02,sy*0.03
    else 
    dxDrawImage(x,y,sx*0.1,sy*0.11,"files/track.png",0,0,0,tocolor(246, 137, 52,255))
    end

    if not comp.bonnet_dummy then 
    dxDrawImage(x,y,sx*0.1,sy*0.11,"files/hood.png",0,0,0,tocolor(255,255,255,255)) --x + sx*0.0395,y + sy*0.005,sx*0.02,sy*0.03
    else 
    dxDrawImage(x,y,sx*0.1,sy*0.11,"files/hood.png",0,0,0,tocolor(246, 137, 52,255))
    end 

    if not comp.door_rf_dummy then 
    dxDrawImage(x,y,sx*0.1,sy*0.11,"files/rfdoor.png",0,0,0,tocolor(255,255,255,255)) --x + sx*0.067,y + sy*0.02,sx*0.02,sy*0.03
    else 
    dxDrawImage(x,y,sx*0.1,sy*0.11,"files/rfdoor.png",0,0,0,tocolor(246, 137, 52,255)) 
    end

    if not comp.door_rb_dummy then 
    dxDrawImage(x,y,sx*0.1,sy*0.11,"files/rbdoor.png",0,0,0,tocolor(255,255,255,255)) --x + sx*0.067,y + sy*0.065,sx*0.02,sy*0.03
    else 
    dxDrawImage(x,y,sx*0.1,sy*0.11,"files/rbdoor.png",0,0,0,tocolor(246, 137, 52,255))
    end
 
    if not comp.door_lf_dummy then 
    dxDrawImage(x,y,sx*0.1,sy*0.11,"files/lfdoor.png",0,0,0,tocolor(255,255,255,255)) --x + sx*0.01,y + sy*0.02,sx*0.02,sy*0.03
    else 
    dxDrawImage(x,y,sx*0.1,sy*0.11,"files/lfdoor.png",0,0,0,tocolor(246, 137, 52,255))
    end 

    if not comp.door_lb_dummy then 
    dxDrawImage(x,y,sx*0.1,sy*0.11,"files/lbdoor.png",0,0,0,tocolor(255,255,255,255)) --x + sx*0.01,y + sy*0.065,sx*0.02,sy*0.03
    else 
    dxDrawImage(x,y,sx*0.1,sy*0.11,"files/lbdoor.png",0,0,0,tocolor(246, 137, 52,255))
    end 

end

function movePanel(button, state, absoluteX, absoluteY, worldX, worldY, worldZ)
    if (button == "left") and showcveh then 

      if state == "down"  then 
        if isInSlot(x,y,sx*0.1,sy*0.11) then 
          click = true
          windowOffsetX, windowOffsetY = x - absoluteX, y - absoluteY
        end
      else 
        click = false
      end

      if (state == "down") then 
        if isInSlot(x + sx*0.0395,y + sy*0.076,sx*0.02,sy*0.03) then 
            if not comp.boot_dummy then 
                comp.boot_dummy = true 
                local veh = getPedOccupiedVehicle(localPlayer)
                triggerServerEvent("syncServerComponent",localPlayer,veh,1,1)
            else 
                comp.boot_dummy = false 
                local veh = getPedOccupiedVehicle(localPlayer)
                triggerServerEvent("syncServerComponent",localPlayer,veh,1,0)
            end 
        elseif isInSlot(x + sx*0.0395,y + sy*0.005,sx*0.02,sy*0.03) then 
            if not comp.bonnet_dummy then 
                comp.bonnet_dummy = true 
                local veh = getPedOccupiedVehicle(localPlayer)
                triggerServerEvent("syncServerComponent",localPlayer,veh,0,1)
            else 
                comp.bonnet_dummy  = false 
                local veh = getPedOccupiedVehicle(localPlayer)
                triggerServerEvent("syncServerComponent",localPlayer,veh,0,0)
            end 
        elseif isInSlot(x + sx*0.067,y + sy*0.02,sx*0.02,sy*0.03) then 
            if not comp.door_rf_dummy then 
                comp.door_rf_dummy = true 
                local veh = getPedOccupiedVehicle(localPlayer)
                triggerServerEvent("syncServerComponent",localPlayer,veh,3,1)
            else 
                comp.door_rf_dummy  = false 
                local veh = getPedOccupiedVehicle(localPlayer)
                triggerServerEvent("syncServerComponent",localPlayer,veh,3,0)
            end 
        elseif isInSlot(x + sx*0.067,y + sy*0.065,sx*0.02,sy*0.03) then 
            if not comp.door_rb_dummy then 
                comp.door_rb_dummy = true 
                local veh = getPedOccupiedVehicle(localPlayer)
                triggerServerEvent("syncServerComponent",localPlayer,veh,5,1)
            else 
                comp.door_rb_dummy  = false 
                local veh = getPedOccupiedVehicle(localPlayer)
                triggerServerEvent("syncServerComponent",localPlayer,veh,5,0)
            end 
        elseif isInSlot(x + sx*0.01,y + sy*0.02,sx*0.02,sy*0.03) then 
            if not comp.door_lf_dummy then 
                comp.door_lf_dummy = true 
                local veh = getPedOccupiedVehicle(localPlayer)
                triggerServerEvent("syncServerComponent",localPlayer,veh,2,1)
            else 
                comp.door_lf_dummy  = false 
                local veh = getPedOccupiedVehicle(localPlayer)
                triggerServerEvent("syncServerComponent",localPlayer,veh,2,0)
            end 
        elseif isInSlot(x + sx*0.01,y + sy*0.065,sx*0.02,sy*0.03) then 
            if not comp.door_lb_dummy then 
                comp.door_lb_dummy = true 
                local veh = getPedOccupiedVehicle(localPlayer)
                triggerServerEvent("syncServerComponent",localPlayer,veh,4,1)
            else 
                comp.door_lb_dummy  = false 
                local veh = getPedOccupiedVehicle(localPlayer)
                triggerServerEvent("syncServerComponent",localPlayer,veh,4,0)
            end 
        end 
      end 

    end 
   end 
addEventHandler("onClientClick",root,movePanel)

function isInSlot(xS,yS,wS,hS)
    if(isCursorShowing()) then
        XY = {guiGetScreenSize()}
        local cursorX, cursorY = getCursorPosition()
        cursorX, cursorY = cursorX*XY[1], cursorY*XY[2]
        if(isInBox(xS,yS,wS,hS, cursorX, cursorY)) then
            return true
        else
            return false
        end
    end	
end

function isInBox(dX, dY, dSZ, dM, eX, eY)
    if(eX >= dX and eX <= dX+dSZ and eY >= dY and eY <= dY+dM) then
        return true
    else
        return false
    end
end
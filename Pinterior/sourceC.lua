fileDelete ("sourceC.lua") 
local screen = {guiGetScreenSize()};
local width = 280;
local height = 58;
local screenX,screenY = screen[1]/2 - width/2, screen[2] - 180;
local func = {};
local cache = {
	changeGarage = true;
    sansheavy = dxCreateFont("files/sansheavy.otf",20);
    sfpro = dxCreateFont("files/sfpro.ttf",20);
	roboto = dxCreateFont("files/roboto.ttf",20);
	roboto2 = dxCreateFont("files/roboto.ttf",12.5);
    interior = {
        show = false;
        element = nil;
        name = "Kis házikó";
    };
};
local pickupCache = {};

func.start = function()
	setElementData(localPlayer,"player:intmarker",nil)
    for k,marker in ipairs(getElementsByType("pickup")) do
        if getElementData(marker,"int:dbid") then
            if not pickupCache[marker] then
                pickupCache[marker] = true;
            end
        end
    end
end
addEventHandler("onClientResourceStart",resourceRoot,func.start)

addCommandHandler("fixicons",function()
    for k,marker in ipairs(getElementsByType("pickup")) do
        if getElementData(marker,"int:dbid") and isElementStreamedIn(marker) and getElementDimension(localPlayer) == getElementDimension(marker) and getElementInterior(localPlayer) == getElementInterior(marker) then
            pickupCache[marker] = true;
        end
    end
end)

func.streamIn = function()
    if getElementType(source) == "pickup" then
        if getElementData(source,"int:dbid") and getElementDimension(localPlayer) == getElementDimension(source) and getElementInterior(localPlayer) == getElementInterior(source) then
            if not pickupCache[source] then
                pickupCache[source] = true;
            end
        end
    end
end
addEventHandler("onClientElementStreamIn",root,func.streamIn)

func.streamOut = function()
    if getElementType(source) == "pickup" then
        if getElementData(source,"int:dbid") and getElementDimension(localPlayer) == getElementDimension(source) and getElementInterior(localPlayer) == getElementInterior(source) then
            if pickupCache[source] then
                pickupCache[source] = nil;
            end
        end
    end
end
addEventHandler( "onClientElementStreamOut",root,func.streamOut)

func.onDestroy = function()
	if getElementType(source) == "pickup" then
        if getElementData(source,"int:dbid") then
			if pickupCache[source] and getElementDimension(localPlayer) == getElementDimension(source) and getElementInterior(localPlayer) == getElementInterior(source) then
				pickupCache[source] = nil;
				if localPlayer == getLocalPlayer() then
					if cache.interior.show then
						cache.interior.element = nil;
						setElementData(localPlayer,"player:intmarker",nil)
						cache.interior.show = false;
					end
				end
			end
		end
	end
end
addEventHandler("onClientElementDestroy",getRootElement(),func.onDestroy)

func.render = function()

    if cache.interior.show and cache.interior.element then
        local name = "["..getElementData(cache.interior.element,"int:dbid").."] "..getElementData(cache.interior.element,"int:name");
        local info = "Nyomd meg az #7cc576'E'#ffffff betűt.";

        width = dxGetTextWidth(name,0.75,cache.sansheavy);
        infowidth = dxGetTextWidth(removeHex(info),0.6,cache.roboto);

        if infowidth > width then
            actualwidth = infowidth;
        else
            actualwidth = width
        end

        screenX = screen[1]/2 - actualwidth/2
        func.rounded(screenX-16,screenY,actualwidth+34,height,tocolor(25,25,25,255))
        dxDrawText(name,screenX+actualwidth/2,screenY+20,screenX+actualwidth/2,screenY+20,tocolor(255,255,255,255),0.75,cache.sansheavy,"center","center");
        dxDrawImage(screenX+actualwidth,screenY+4,16,16,"files/"..getElementData(cache.interior.element,"int:locked")..".png")
        dxDrawText(info,screenX+actualwidth/2,screenY+42,screenX+actualwidth/2,screenY+42,tocolor(255,255,255,255),0.6,cache.roboto,"center","center",false,false,false,true);
    end

    local pX,pY,pZ = getElementPosition(localPlayer);
	for marker,v in pairs(pickupCache) do
		if isElement(marker) then
			if getElementDimension(localPlayer) == getElementDimension(marker) and getElementInterior(localPlayer) == getElementInterior(marker) then
				local markX, markY, markZ = getElementPosition(marker);
				local x, y = getScreenFromWorldPosition(markX, markY, markZ+0.5);
				local distance = getDistanceBetweenPoints3D(markX, markY, markZ, pX, pY, pZ);
				if distance <= 10 then
					if isLineOfSightClear(pX,pY,pZ,markX, markY, markZ, true, false, false, true, true, true, false) then
						if (x) and (y) then
							local size = interpolateBetween(36,0,0, 36 - distance/1.4,0,0, distance, "Linear")
							local owner = getElementData(marker,"int:owner");
							local type = getElementData(marker,"int:type");
							local name = getElementData(marker,"int:name");
							
							local iconimg,iconcolor = getIcon(owner,type);
							--dxDrawBorderedText(1,name,x,y,x,y,tocolor(255,255,255,255),1.1,"default-bold","center","center")
						end
					end
				end
			end
		end
	end
end
addEventHandler("onClientRender",getRootElement(),func.render)

func.markerHit = function(thePlayer,matchingDimension)
	if thePlayer == localPlayer then
		if getElementDimension(source) == getElementDimension(thePlayer) then
			if getElementData(source,"int:out") or getElementData(source,"int:in") then
				local playerX,playerY,playerZ = getElementPosition(localPlayer);
				local elementX,elementY,elementZ = getElementPosition(source);
				if getDistanceBetweenPoints3D(playerX,playerY,playerZ,elementX,elementY,elementZ) <= 1.8 then
					cache.interior.show = true;

					if getElementData(source,"int:type") ~= 2 and getElementData(source,"int:type") ~= 1 and getElementData(source,"int:owner") == -1 then
						exports.Pinfobox:addNotification("Ez egy megvásárolható ingatlan. Részletek a chatboxon.","info")
						outputChatBox("#8163bf[Interior]:#ffffff A megvételhez használd a #7cc576/buy#ffffff parancsot.",0,0,0,true)
						outputChatBox("#8163bf[Interior]:#ffffff Az ingatlan ára: #7cc576"..thousandsStepper(getElementData(source,"int:price")).."#ffffff $.",0,0,0,true)
					end

					if getElementData(source,"int:type") == 1 and getElementData(source,"int:owner") == -1 then
						local caution = getElementData(source,"int:price")*2;
                        exports.Pinfobox:addNotification("Ez egy kiadó ingatlan. Részletek a chatboxon.","info")
						outputChatBox("#8163bf[Interior]:#ffffff A bérléshez használd a #7cc576/rent#ffffff parancsot.",0,0,0,true)
						outputChatBox("#8163bf[Interior]:#ffffff Az ingatlan bérleti díja: #7cc576"..thousandsStepper(getElementData(source,"int:price")).."#ffffff $ /hét.\n#8163bf[Interior]:#ffffff Kaukció: #7cc576"..thousandsStepper(caution).."#ffffff $",0,0,0,true)
                    end

					cache.interior.element = nil;
					cache.interior.element = source;
					setElementData(localPlayer,"player:intmarker",source)
					bindKey("e", "up", func.interiorKeyBinds)
					bindKey("k", "up", func.interiorLock)
				end
			end
		end
	end
end
addEventHandler("onClientPickupHit", resourceRoot, func.markerHit)

func.markerLeave = function(thePlayer,matchingDimension)
	if thePlayer == localPlayer then
		if getElementDimension(source) == getElementDimension(thePlayer) then
			if getElementData(source,"int:out") or getElementData(source,"int:in") then
				if cache.interior.show then
					cache.interior.element = nil;
					cache.interior.show = false;
					setElementData(localPlayer,"player:intmarker",nil)
					unbindKey("e", "up", func.interiorKeyBinds)
					unbindKey("k", "up", func.interiorLock)
				end
			end
		end
	end
end
addEventHandler("onClientPickupLeave", resourceRoot, func.markerLeave)

func.startEnter =  function(player,seat,door)
	if (player == localPlayer and seat == 0)then
		cache.changeGarage = false;
	end
end
addEventHandler("onClientVehicleStartEnter", getRootElement(), func.startEnter)

func.enterVehicle = function(thePlayer, seat)
    if thePlayer == getLocalPlayer() then
        cache.changeGarage = true;
    end
end
addEventHandler("onClientVehicleEnter", getRootElement(), func.enterVehicle)

func.startExit = function(player, seat, door)
	if (seat==0) and (door==0) then
		cache.changeGarage = false;
	end
end
addEventHandler("onClientVehicleStartExit", getRootElement(), func.startExit)

func.exitVehicle = function(thePlayer, seat)
    if thePlayer == getLocalPlayer() then
        cache.changeGarage = false;
    end
end
addEventHandler("onClientVehicleExit", getRootElement(), func.exitVehicle)

func.interiorKeyBinds = function()
    if isElement(cache.interior.element) then
		local otherElement = getElementData(cache.interior.element, "int:other");
		if otherElement then
			local owner = getElementData(cache.interior.element,"int:owner");
			local type = getElementData(cache.interior.element,"int:type");
			local locked = getElementData(cache.interior.element,"int:locked");
			if locked == 0 then
				local x,y,z = getElementPosition(otherElement);
				local interior = getElementInterior(otherElement);
				local dimension = getElementDimension(otherElement);
				if type == 3 then
					local vehicle = getPedOccupiedVehicle(localPlayer);
					if vehicle and isPedInVehicle(localPlayer) then
						if getPedOccupiedVehicleSeat(localPlayer) == 0 then
							if cache.changeGarage then
								triggerServerEvent("changeVehicleInterior",localPlayer,localPlayer,x,y,z,interior,dimension,otherElement,vehicle)
								setElementFrozen(localPlayer,true);
								setElementFrozen(vehicle,true);
							end
						end
					else
						triggerServerEvent("changePlayerInterior",localPlayer,localPlayer,x,y,z,interior,dimension,otherElement)
						setElementFrozen(localPlayer,true);
					end
				else
					if not isPedInVehicle(localPlayer) then
						triggerServerEvent("changePlayerInterior",localPlayer,localPlayer,x,y,z,interior,dimension,otherElement)
						setElementFrozen(localPlayer,true);
					else
						outputChatBox("#8163bf[Interior]:#ffffff Járműben ülve ez nem fog menni.",0,0,0,true)
					end
				end
			else
				outputChatBox("#8163bf[Interior]:#ffffff Ez az ingatlan zárva van.",0,0,0,true)
			end
		end
	end
end

func.interiorLock = function()
    if isElement(cache.interior.element) then
		local otherElement = getElementData(cache.interior.element, "int:other");
		if otherElement then
			if getElementData(localPlayer, "player:adminduty") or exports.inventory:hasItem(108,getElementData(cache.interior.element,"int:dbid")) then
				if not isTimer(lockspam) then
					local locked = getElementData(cache.interior.element,"int:locked");
					if locked == 0 then
						locked = 1;
						outputChatBox("#8163bf[Interior]:#ffffff Sikeresen #D23131bezártad#ffffff az ingatlant.",0,0,0,true)
					else
						locked = 0;
						outputChatBox("#8163bf[Interior]:#ffffff Sikeresen #7cc576kinyitottad#ffffff az ingatlant.",0,0,0,true)
					end
					setElementData(cache.interior.element,"int:locked",locked);
					setElementData(otherElement,"int:locked",locked);
					triggerServerEvent("setInteriorLockstate",localPlayer,locked,getElementData(cache.interior.element,"int:dbid"))
					lockspam = setTimer(function() end, 4000,1)
				else
					outputChatBox("#8163bf[Interior]:#ffffff Nem használhatod a zárat, még pár másodpercig.",0,0,0,true)
				end
			else
				outputChatBox("#8163bf[Interior]:#ffffff Nincs kulcsod az ingatlanhoz.",0,0,0,true)
			end
		end
	end
end

func.buyInterior = function()
	if getElementData(localPlayer,"player:loggedIn") then
		if cache.interior.show and cache.interior.element then
			if getElementData(cache.interior.element,"int:type") ~= 2 and getElementData(cache.interior.element,"int:type") ~= 1 and getElementData(cache.interior.element,"int:owner") == -1 then
				local price = getElementData(cache.interior.element,"int:price");
				if getElementData(localPlayer,"player:money") >= price then
					triggerServerEvent("buyInteriorServer",localPlayer,localPlayer,cache.interior.element)
					cache.interior.element = nil;
					cache.interior.show = false;
					setElementData(localPlayer,"player:intmarker",nil)
					unbindKey("e", "up", func.interiorKeyBinds)
					unbindKey("k", "up", func.interiorLock)
				else
					exports.Pinfobox:addNotification("Nincs elegendő pénzed az ingatlan megvásárlásához.","error")
				end
			end
		end
	end
end
addCommandHandler("buy",func.buyInterior)

func.rentInterior = function()
	if getElementData(localPlayer,"player:loggedIn") then
		if cache.interior.show and cache.interior.element then
			if getElementData(cache.interior.element,"int:type") == 1 then
				if getElementData(cache.interior.element,"int:owner") == -1 then
					local price = getElementData(cache.interior.element,"int:price");
					local caution = getElementData(cache.interior.element,"int:price")*2;
					local isRent = getPlayerRentedInteriorsByDbid(getElementData(localPlayer,"player:dbid"));
					if not isRent then
						if getElementData(localPlayer,"player:money") >= price+caution then
							triggerServerEvent("rentInteriorServer",localPlayer,localPlayer,cache.interior.element)
							cache.interior.element = nil;
							cache.interior.show = false;
							setElementData(localPlayer,"player:intmarker",nil)
							unbindKey("e", "up", func.interiorKeyBinds)
							unbindKey("k", "up", func.interiorLock)
						else
							exports.Pinfobox:addNotification("Nincs elegendő pénzed az ingatlan kibérléséhez.","error")
						end
					else
						exports.Pinfobox:addNotification("Te már bérelsz egy ingatlant.","error")
					end
				else
					if getElementData(cache.interior.element,"int:owner") == getElementData(localPlayer,"player:dbid") then
						local time = getElementData(cache.interior.element,"int:renttime");
						local serverTimestamp = getRealTime()["timestamp"];
						local lasttime = math.floor(((time-serverTimestamp)/60)/60);
						if lasttime <= 24 then
							local price = getElementData(cache.interior.element,"int:price");
							if getElementData(localPlayer,"player:money") >= price then
								triggerServerEvent("extendRentInteriorServer",localPlayer,localPlayer,cache.interior.element)
								cache.interior.element = nil;
								cache.interior.show = false;
								setElementData(localPlayer,"player:intmarker",nil)
								unbindKey("e", "up", func.interiorKeyBinds)
								unbindKey("k", "up", func.interiorLock)
							else
								exports.Pinfobox:addNotification("Nincs elegendő pénzed az ingatlan meghosszabbításához.","error")
							end
						end
					end
				end
			end
		end
	end
end
addCommandHandler("rent",func.rentInterior)

func.unrentInterior = function()
	if getElementData(localPlayer,"player:loggedIn") then
		if cache.interior.show and cache.interior.element then
			if getElementData(cache.interior.element,"int:type") == 1 and getElementData(cache.interior.element,"int:owner") == getElementData(localPlayer,"player:dbid") then
				triggerServerEvent("unrentInteriorServer",localPlayer,localPlayer,cache.interior.element)
				cache.interior.element = nil;
				cache.interior.show = false;
				setElementData(localPlayer,"player:intmarker",nil)
				unbindKey("e", "up", func.interiorKeyBinds)
				unbindKey("k", "up", func.interiorLock)
			end
		end
	end
end
addCommandHandler("unrent",func.unrentInterior)

function getPlayerRentedInteriorsByDbid(dbid)
	for k,marker in ipairs(getElementsByType("pickup")) do
		if getElementData(marker,"int:in") and getElementData(marker,"int:type") == 1 and getElementData(marker,"int:owner") == dbid then
			return true;
		end
	end
	return false;
end

func.rounded = function(x, y, w, h, borderColor, bgColor, postGUI)
	if (x and y and w and h) then
		if (not borderColor) then
			borderColor = tocolor(0, 0, 0, 200);
		end
		
		if (not bgColor) then
			bgColor = borderColor;
		end
		
		--> Background
		dxDrawRectangle(x, y, w, h, bgColor, postGUI);
		
		--> Border
		dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor, postGUI); -- top
		dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor, postGUI); -- bottom
		dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor, postGUI); -- left
		dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor, postGUI); -- right
	end
end

function removeHex (s)
    return s:gsub ("#%x%x%x%x%x%x", "") or false
end


----INTERIOR FELET EZ íRJA KI AZ INTERIOR NEVÉT--- #ROLIVETTEKI
--function dxDrawBorderedText (outline, text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
--    local outline = (scale or 1) * (1.333333333333334 * (outline or 1))
--    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left - outline, top - outline, right - outline, bottom - outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
--    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left + outline, top - outline, right + outline, bottom - outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
--    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left - outline, top + outline, right - outline, bottom + outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
--    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left + outline, top + outline, right + outline, bottom + outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
--    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left - outline, top, right - outline, bottom, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
--    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left + outline, top, right + outline, bottom, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
--    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left, top - outline, right, bottom - outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
--    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left, top + outline, right, bottom + outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
--    dxDrawText (text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
--end

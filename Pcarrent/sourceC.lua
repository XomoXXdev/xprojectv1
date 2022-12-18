local s = {guiGetScreenSize()}
local box = {600,400}
local panel = {s[1]/2 -box[1]/2,s[2]/2 - box[2]/2}
local rentShow = false
local font1 = dxCreateFont("files/Roboto.ttf",12)
local font = dxCreateFont("files/RobotoB.ttf",13)

local data = {}
local maxDist = 15

local vehList = {
	-- {ID, ÁR, "NÉV"}
	{462,200, "Honda Click"},
	{542,400, "Seat Leon"},
	{589,800, "Volkswagen Golf l"},
}

addEventHandler("onClientRender",getRootElement(),function()
	if rentShow and not getPedOccupiedVehicle(localPlayer) then
		dxDrawRectangle(panel[1],panel[2],box[1],35,tocolor(0, 0, 0,255))
		dxDrawText("#8163bfxProject #ffffff- Járműbérlő", panel[1]+5,panel[2], panel[1],panel[2]+35,tocolor(255,255,255,255), 1,font1, "left","center", false,false,false,true)
		dxDrawRectangle(panel[1],panel[2]+35,box[1],120,tocolor(35 ,35, 35,255))
		dxDrawRectangle(panel[1],panel[2]+35+120,box[1],120,tocolor(35, 35, 35,255))
		dxDrawRectangle(panel[1],panel[2]+35+120+120,box[1],120,tocolor(35, 35, 35,255))

		local vehCount = 0
		local r,g,b = 129, 99, 191

		dxDrawRectangle(panel[1]+600-150-20, panel[2]+35+20-5+120+120, 150, 90, tocolor(r,g,b,255))

		if isInSlot(panel[1]+600-150-20, panel[2]+35+20-5, 150, 90) then
			dxDrawRectangle(panel[1]+600-150-20, panel[2]+35+20-5, 150, 90, tocolor(165, 138, 222,255))
		else
			dxDrawRectangle(panel[1]+600-150-20, panel[2]+35+20-5, 150, 90, tocolor(r,g,b,255))
		end

		if isInSlot(panel[1]+600-150-20, panel[2]+35+20-5+120, 150, 90) then
			dxDrawRectangle(panel[1]+600-150-20, panel[2]+35+20-5+120, 150, 90, tocolor(165, 138, 222,255))
		else
			dxDrawRectangle(panel[1]+600-150-20, panel[2]+35+20-5+120, 150, 90, tocolor(r,g,b,255))
		end

		if isInSlot(panel[1]+600-150-20, panel[2]+35+20-5+120+120, 150, 90) then
			dxDrawRectangle(panel[1]+600-150-20, panel[2]+35+20-5+120+120, 150, 90, tocolor(165, 138, 222,255))
		else
			dxDrawRectangle(panel[1]+600-150-20, panel[2]+35+20-5+120+120, 150, 90, tocolor(r,g,b,255))
		end

		if isInSlot(panel[1]+570, panel[2]+7,12,18) then
			dxDrawText("X", panel[1]+570, panel[2]+7,0,0, tocolor(217, 83, 79,255),1, font) --
		else
			dxDrawText("X", panel[1]+570, panel[2]+7,0,0, tocolor(255,255,255,255),1, font) --
		end
		
		for k,v in ipairs(vehList) do
			if vehCount < 10 then
				vehCount = vehCount+1
				dxDrawText(v[3], panel[1]+9, panel[2]+15-50 + (vehCount * 120),0,0, tocolor(0,0,0,255),1, font1)
				dxDrawText(v[3], panel[1]+10, panel[2]+14-50 + (vehCount * 120),0,0, tocolor(255,255,255,255),1, font1)
				dxDrawText("Ára: "..tostring(v[2]).. " $",panel[1]+210,panel[2]+15-50 + (vehCount * 120),panel[1]+410,0,tocolor(0,0,0,255),1,font1,"right","top",true,true,true,true)
				dxDrawText("Ára: "..tostring(v[2]).. " $",panel[1]+211,panel[2]+15-50 + (vehCount * 120),panel[1]+411,0,tocolor(255,255,255,255),1,font1,"right","top",true,true,true,true)
				dxDrawText("Kibérlés",panel[1]+600-150-20, panel[2]+35+20-5-120+(vehCount*120),panel[1]+600-150-20+150, panel[2]+35+20-5-120+(vehCount*120)+90,tocolor(255, 255,255,255),1,font1,"center","center",true,true,true,true)
			end
		end
	end
end)

function rentVehicle(i)
	if getElementData(localPlayer, "player:money") >= vehList[i][2] then
		local x,y,z = getElementPosition(localPlayer)
		triggerServerEvent("createRentVeh",localPlayer,x,y,z,vehList[i][1],vehList[i][2])
		rentShow = false
		setElementFrozen(localPlayer,false)
	else
		exports.Pinfobox:addNotification("Nincs elég pénzed. ("..vehList[i][2].." $.)","error")
	end
end

addEventHandler("onClientClick", getRootElement(), function(button, state)
	if not rentShow or not getNetworkConnection() then return end
    if button == "left" and state == "down" then
        if isInSlot(panel[1]+570, panel[2]+7,12,18) then
			closeWindow()
		elseif isInSlot(panel[1]+600-150-20, panel[2]+35+20-5, 150, 90) then
			rentVehicle(1)
		elseif isInSlot(panel[1]+600-150-20, panel[2]+35+20-5+120, 150, 90) then
			rentVehicle(2)
		elseif isInSlot(panel[1]+600-150-20, panel[2]+35+20-5+120+120, 150, 90) then
			rentVehicle(3)
        end
    end
end)

addEventHandler("onClientMarkerHit", getRootElement(), function (hitElement)
	if hitElement == localPlayer then
		if getElementData(source,"isRentMark") and not isPedInVehicle(localPlayer) then
			local pX,pY,pZ = getElementPosition(localPlayer)
			local eX,eY,eZ = getElementPosition(source)
			if getDistanceBetweenPoints3D(pX,pY,pZ,eX,eY,eZ) <= 3 then
				if not getElementData(localPlayer, "onRentCar") then
					rentShow = true
				else
					exports.Pinfobox:addNotification("Te már bérelsz járművet.","error")
				end
			end
		elseif getElementData(source,"isRentMark") and isPedInVehicle(localPlayer) then
			local pX,pY,pZ = getElementPosition(localPlayer)
			local eX,eY,eZ = getElementPosition(source)
			if getDistanceBetweenPoints3D(pX,pY,pZ,eX,eY,eZ) <= 3 then
				local vehicleElement = getPedOccupiedVehicle(localPlayer) or false
				if isElement(vehicleElement) then
					if getElementData(localPlayer, "onRentCar") then
						if getElementData(vehicleElement,"rentVeh") then
							triggerServerEvent("destroyRentVeh",localPlayer,vehicleElement)
						end
					end
				end
			end
		end
	end
end)

addEventHandler("onClientMarkerLeave", getRootElement(), function(hitElement)
	if hitElement == localPlayer then
		if getElementData(source,"isRentMark") and not isPedInVehicle(localPlayer) then
			closeWindow()
		end
	end
end)

function closeWindow(element)
    if rentShow then
        rentShow = false
        showCursor(false)
    end
end

addEventHandler("onClientPlayerVehicleExit", getRootElement(), function(vehicle, seat)
	if source == localPlayer and seat == 0 then
		if getElementData(vehicle,"rentVeh") then
			if getElementData(vehicle,"dbid") <= 0 then
				exports.Pinfobox:addNotification("Kiszálltál a bérelt járművedből, 10 perced van hogy vissza szálj különben törlődni fog!", "warning")
				destroyTimer = setTimer(function()
					exports.Pinfobox:addNotification("A bérelt járműved törlődött, mert nem száltál vissza 10 percen belül.", "warning")
					setElementData(localPlayer,"onRentCar",false)
				end,(1000*60)*10, 1)
			end
		end
	end
end)

addEventHandler("onClientPlayerVehicleEnter", getRootElement(), function(vehicle, seat)
	if vehicle and seat == 0 then
		if getElementData(vehicle,"rentVeh") then
			if getElementData(vehicle,"dbid") <= 0 then
				if isTimer(destroyTimer) then killTimer(destroyTimer) end
			end
		end
	end
end)

function getNetworkConnection()
	if getNetworkStats().packetlossLastSecond < 5 then
        return true
	end
	return false
end

function dxDrawBorder(x, y, w, h, radius, color)
	dxDrawRectangle(x - radius, y, radius, h, color)
	dxDrawRectangle(x + w, y, radius, h, color)
	dxDrawRectangle(x - radius, y - radius, w + (radius * 2), radius, color)
	dxDrawRectangle(x - radius, y + h, w + (radius * 2), radius, color)
end

function inBox(dX, dY, dSZ, dM, eX, eY)
	if(eX >= dX and eX <= dX+dSZ and eY >= dY and eY <= dY+dM) then
		return true
	else
		return false
	end
end

function isInSlot(xS,yS,wS,hS)
	if(isCursorShowing()) then
		XY = {guiGetScreenSize()}
		local cursorX, cursorY = getCursorPosition()
		cursorX, cursorY = cursorX*XY[1], cursorY*XY[2]
		if(inBox(xS,yS,wS,hS, cursorX, cursorY)) then
			return true
		else
			return false
		end
	end
end
	
local monitorSize = {guiGetScreenSize()}
local panelSize = {500, 400}
local panelX, panelY = monitorSize[1]/2-panelSize[1]/2, monitorSize[2]/2-panelSize[2]/2

local font = dxCreateFont("files/myriadproregular.ttf",9) --<[ Font ]>--
local showmodpanel = false
local Max = 14
local current = 0
local alpha = 0
local enabledVehicleMod = {}
local color = "#7cc576"

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), function ()
	for index, value in ipairs (elements) do
		if tostring(index) ~= tostring(value) then 
			changeVehicleMod (value[1], value[2])
		end
	end
	for i=1 , 10000 do
		if not enabledVehicleMod[i] then
			enabledVehicleMod[i] = 1
		end
	end
end)

function changeVehicleMod (filename,id)
	if id and filename then
		if getVehicleNameFromModel(id) then
			if fileExists("vehicle/"..filename..".txd") then
				txd = engineLoadTXD("vehicle/"..filename..".txd", id )
				engineImportTXD(txd, id)
			end			
			if fileExists("vehicle/"..filename..".dff") then
			  dff = engineLoadDFF("vehicle/"..filename..".dff", id )
			  engineReplaceModel(dff, id)
			end		
		else
			outputChatBox("Hiba a jármű betöltése során [ID:"..id.." >> Nem létezik ez a jármű!]")
		end
	end
end

function showPanel() 
	if not isPedInVehicle(localPlayer) then 
		if (showmodpanel) then 
			showmodpanel = false
			removeEventHandler("onClientRender", root, createPanel)
		else
			showmodpanel = true
			removeEventHandler("onClientRender", root, createPanel)
			addEventHandler("onClientRender", root, createPanel)
			
			removeEventHandler("onClientClick", root, vehiclePanel)
			addEventHandler("onClientClick", root, vehiclePanel)
			current = 0
			alpha = 0
		end
	end
end
addCommandHandler("modpanel", showPanel)
bindKey("F1", "down", showPanel)

function createPanel()
	if showmodpanel and not isPedInVehicle(localPlayer) then 
		dxDrawRectangle(panelX, panelY, panelSize[1], panelSize[2], tocolor(0, 0, 0, 170))
		dxDrawRectangle(panelX, panelY, panelSize[1], 25, tocolor(0, 0, 0, 170))
		dxDrawRectangle(panelX+panelSize[1]-140, panelY+2, 120, 21, tocolor(0, 0, 0, 230))
		for index, value in ipairs (elements) do 
			if enabledVehicleMod[index] == 0 then 
				if isInSlot (panelX+panelSize[1]-140, panelY+2, 120, 21) then 
					dxDrawRectangle(panelX+panelSize[1]-140, panelY+2, 120, 21, tocolor(124, 197, 118, 230))
					dxDrawText("Összes bekapcsolás", panelX+panelSize[1]-140+120/2, panelY+2+21/2, panelX+panelSize[1]-140+120/2, panelY+2+21/2, tocolor(0, 0, 0, 255), 1, font, "center", "center", false, false, false, true)					
				else
					dxDrawRectangle(panelX+panelSize[1]-140, panelY+2, 120, 21, tocolor(0, 0, 0, 230))
					dxDrawText("Összes bekapcsolás", panelX+panelSize[1]-140+120/2, panelY+2+21/2, panelX+panelSize[1]-140+120/2, panelY+2+21/2, tocolor(255, 255, 255, 255), 1, font, "center", "center", false, false, false, true)
				end
			else
				if isInSlot (panelX+panelSize[1]-140, panelY+2, 120, 21) then 
					dxDrawRectangle(panelX+panelSize[1]-140, panelY+2, 120, 21, tocolor(210, 77, 87, 230))
					dxDrawText("Összes kikapcsolás", panelX+panelSize[1]-140+120/2, panelY+2+21/2, panelX+panelSize[1]-140+120/2, panelY+2+21/2, tocolor(0, 0, 0, 255), 1, font, "center", "center", false, false, false, true)					
				else
					dxDrawRectangle(panelX+panelSize[1]-140, panelY+2, 120, 21, tocolor(0, 0, 0, 230))
					dxDrawText("Összes kikapcsolás", panelX+panelSize[1]-140+120/2, panelY+2+21/2, panelX+panelSize[1]-140+120/2, panelY+2+21/2, tocolor(255, 255, 255, 255), 1, font, "center", "center", false, false, false, true)
				end
			
			end
		end
		dxDrawText("ExternalGaming - #7cc576Modpanel", panelX+5, panelY+5, panelSize[1], panelSize[2], tocolor(255, 255, 255, 255), 1, font, "left", "top", false, false, false, true)
		alpha = alpha + 2.5
		if alpha >= 255 then 
			alpha = 0
		end
		dxDrawImage(panelX+panelSize[1]/2-100, panelY-50, 200, 50, "files/logo.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
		local elem = 0
		for index, value in ipairs (elements) do 
			if (index > current and elem < Max) then
				elem = elem + 1
				dxDrawRectangle(panelX, panelY-25+30+elem*25, panelSize[1], 20, tocolor(0, 0, 0, 170))
				dxDrawText("Jármű neve: ".. color .. exports.exg_carshop:getVehicleRealName(value[2]) or "Ismeretlen", panelX+5, panelY-23+30+elem*25, panelSize[1], panelSize[2], tocolor(255, 255, 255, 255), 1, font, "left", "top", false, false, false, true)
				if enabledVehicleMod[index] == 0 then 
					if isInSlot (panelX+panelSize[1]-120, panelY-25+30+elem*25+2, 100, 16) then 
						dxDrawRectangle(panelX+panelSize[1]-120, panelY-25+30+elem*25+2, 100, 16, tocolor(124, 197, 118, 230))
						dxDrawText("Bekapcsolás", panelX+panelSize[1]-120+100/2, panelY-25+30+elem*25+2+16/2, panelX+panelSize[1]-120+100/2, panelY-25+30+elem*25+2+16/2, tocolor(0, 0, 0, 255), 1, font, "center", "center", false, false, false, true)					
					else
						dxDrawRectangle(panelX+panelSize[1]-120, panelY-25+30+elem*25+2, 100, 16, tocolor(0, 0, 0, 230))
						dxDrawText("Bekapcsolás", panelX+panelSize[1]-120+100/2, panelY-25+30+elem*25+2+16/2, panelX+panelSize[1]-120+100/2, panelY-25+30+elem*25+2+16/2, tocolor(255, 255, 255, 255), 1, font, "center", "center", false, false, false, true)
					end
				else
					if isInSlot (panelX+panelSize[1]-120, panelY-25+30+elem*25+2, 100, 16) then 
						dxDrawRectangle(panelX+panelSize[1]-120, panelY-25+30+elem*25+2, 100, 16, tocolor(210, 77, 87, 230))
						dxDrawText("Kikapcsolás", panelX+panelSize[1]-120+100/2, panelY-25+30+elem*25+2+16/2, panelX+panelSize[1]-120+100/2, panelY-25+30+elem*25+2+16/2, tocolor(0, 0, 0, 255), 1, font, "center", "center", false, false, false, true)					
					else
						dxDrawRectangle(panelX+panelSize[1]-120, panelY-25+30+elem*25+2, 100, 16, tocolor(0, 0, 0, 230))
						dxDrawText("Kikapcsolás", panelX+panelSize[1]-120+100/2, panelY-25+30+elem*25+2+16/2, panelX+panelSize[1]-120+100/2, panelY-25+30+elem*25+2+16/2, tocolor(255, 255, 255, 255), 1, font, "center", "center", false, false, false, true)
					end
				
				end
			end
		end
	end
end

function vehiclePanel(button , state, x, y)
	if button == "left" and state == "down" and showmodpanel then 
		elem = 0
		for index, value in ipairs (elements) do 
			if (index > current and elem < Max) then
				elem = elem + 1
				if dobozbaVan (panelX+panelSize[1]-120, panelY-25+30+elem*25+2, 100, 16, x, y) then 
					if enabledVehicleMod[index] == 1 then 
						enabledVehicleMod[index] = 0
						engineRestoreModel(value[2])
					else
						enabledVehicleMod[index] = 1
						engineReplaceModel(engineLoadDFF("vehicle/"..value[1]..".dff", value[2]), value[2])
						txd = engineLoadTXD("vehicle/"..value[1]..".txd", value[2] )
						engineImportTXD(txd, value[2])
					end
				end
			end
		end
		for index, value in ipairs (elements) do 
			if dobozbaVan (panelX+panelSize[1]-120, panelY+2, 100, 21, x, y) then 
				if enabledVehicleMod[index] == 1 then 
					enabledVehicleMod[index] = 0
					engineRestoreModel(value[2])
				else
					enabledVehicleMod[index] = 1
					engineReplaceModel(engineLoadDFF("vehicle/"..value[1]..".dff", value[2]), value[2])
					txd = engineLoadTXD("vehicle/"..value[1]..".txd", value[2] )
					engineImportTXD(txd, value[2])
				end
			end
		end
	end
end

--<[ Görgetés ]>--
bindKey("mouse_wheel_down", "down", 
	function() 
		if showmodpanel then
			if current < #elements - Max then
				current = current + 1	
			end
		end
	end
)

bindKey("mouse_wheel_up", "down", 
	function() 
		if showmodpanel then
			if current > 0 then
				current = current - 1		
			end
		end
	end
)
--<[ Görgetés vége ]>--


function isInSlot(xS,yS,wS,hS)
	if(isCursorShowing()) then
		XY = {guiGetScreenSize()}
		local cursorX, cursorY = getCursorPosition()
		cursorX, cursorY = cursorX*XY[1], cursorY*XY[2]
		if(dobozbaVan(xS,yS,wS,hS, cursorX, cursorY)) then
			return true
		else
			return false
		end
	end	
end


function dobozbaVan(dX, dY, dSZ, dM, eX, eY)
	if(eX >= dX and eX <= dX+dSZ and eY >= dY and eY <= dY+dM) then
		return true
	else
		return false
	end
end
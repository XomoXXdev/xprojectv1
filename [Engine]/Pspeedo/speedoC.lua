fileDelete ("speedoC.lua") 
local sx, sy = guiGetScreenSize()
local speedo = {}

local speedoX = getElementData(localPlayer,"player:interface:speedox")
local speedoY = getElementData(localPlayer,"player:interface:speedoy")

local inVehicle = false

local showing = false

local isDraggingWindow = false
local windowOffsetX, windowOffsetY = 0, 0

local font = dxCreateFont("files/roboto.ttf",14)
local awesomeFont = dxCreateFont("files/fontawsome.ttf",10)


addEventHandler('onClientPreRender', root, function()

	if getPedOccupiedVehicle(localPlayer) and not getElementData(localPlayer,"player:toghud") then 

		postGUI = true
		vehicle = getPedOccupiedVehicle(localPlayer)

		if getElementData(localPlayer,"player:interface:speedoavalible") then 

				speedoX = getElementData(localPlayer,"player:interface:speedox")
				speedoY = getElementData(localPlayer,"player:interface:speedoy")

			if getElementModel(getPedOccupiedVehicle(localPlayer)) == 510 or getElementModel(getPedOccupiedVehicle(localPlayer)) == 509  or getElementModel(getPedOccupiedVehicle(localPlayer)) == 481 then return end

				local speed = math.floor(getElementSpeed(vehicle, 1))
				local speedtext = math.floor(getElementSpeed(vehicle, 1))
				   --speed = 400
		   		local sr, sg, sb 
				local fuel = tonumber(getElementData(vehicle, 'vehicle:fuel') or 100)

				if speedtext >= 260 then 
					speed = 260
				end 

		   		if fuel/2 < 50 then
					sr, sg, sb = 255, 51, 51
		   		else
					sr, sg, sb = 117, 255, 110
				end
				
				local cr, cg, cb 

				nitro = 100

		   		if speed > 200 then
				    cr, cg, cb = interpolateBetween(255, 255, 255, 255, 51, 51, getTickCount() / 2000, "CosineCurve");
		   		else
		   			cr, cg, cb = 255, 255, 255
				end

				dxDrawImage(speedoX, speedoY, 310, 310, '/files/speedobg.png', 0 ,0, 0, tocolor(cr, cg, cb, 255), postGUI)				

				dxDrawText(tostring(speedtext).." mph", speedoX + 155 - 1, speedoY + 220 + 1,_,_, tocolor(0, 0, 0, 255), 0.0005*sx, font, 'center', 'center', _, _, postGUI, true)
				dxDrawText(tostring(speedtext).." mph", speedoX + 155, speedoY + 220,_,_, tocolor(cr, cg, cb, 255), 1, font, 'center', 'center', _, _, postGUI, true)

				if getElementData(localPlayer, 'player:seatbelt') == true then
					dxDrawImage(speedoX + 28, speedoY + 20, 260, 260, '/files/seatbelt0.png', 0, 0, 0, tocolor(255, 255, 255, 255), postGUI)
				else
					dxDrawImage(speedoX + 28, speedoY + 20, 260, 260, '/files/seatbelt1.png', 0, 0, 0, tocolor(255, 255, 255, 255), postGUI)
				end

				if isVehicleLocked(getPedOccupiedVehicle(localPlayer)) then
					dxDrawImage(speedoX - 49, speedoY + 28, 256, 256, '/files/door1.png', 0, 0, 0, tocolor(255, 255, 255, 255), postGUI)
				else
					dxDrawImage(speedoX - 49, speedoY + 28, 256, 256, '/files/door.png', 0, 0, 0, tocolor(255, 255, 255, 255), postGUI)
				end

				if getElementData(getPedOccupiedVehicle(localPlayer), 'vehicle:index-r') == true then
					dxDrawImage(speedoX + 40, speedoY + 28, 256, 256, '/files/blinkerRightOn.png', 0, 0, 0, tocolor(255, 255, 255, 255), postGUI)
				else
					dxDrawImage(speedoX + 40, speedoY + 28, 256, 256, '/files/blinkerRightOff.png', 0, 0, 0, tocolor(255, 255, 255, 255), postGUI)
				end

				if getElementData(getPedOccupiedVehicle(localPlayer), 'vehicle:index-l') == true then
					dxDrawImage(speedoX + 18, speedoY + 28, 256, 256, '/files/blinkerLeftOn.png', 0, 0, 0, tocolor(255, 255, 255, 255), postGUI)
				else
					dxDrawImage(speedoX + 18, speedoY + 28, 256, 256, '/files/blinkerLeftOff.png', 0, 0, 0, tocolor(255, 255, 255, 255), postGUI)
				end

				if getElementData(getPedOccupiedVehicle(localPlayer), 'vehicle:engine') == 1 then
					dxDrawImage(speedoX + 93, speedoY + 45, 256, 256, '/files/engine.png', 0, 0, 0, tocolor(255, 255, 255, 255), postGUI)
				else
					dxDrawImage(speedoX + 93, speedoY + 45, 256, 256, '/files/engine2.png', 0, 0, 0, tocolor(255, 255, 255, 255), postGUI)
				end

				if getElementData(vehicle, 'vehicle:handbrake') == 1 then
					dxDrawImage(speedoX , speedoY + 46, 256, 256, '/files/handbrake1.png', 0, 0, 0, tocolor(255, 255, 255, 255), postGUI)
				else
					dxDrawImage(speedoX , speedoY + 46, 256, 256, '/files/handbrake.png', 0, 0, 0, tocolor(255, 255, 255, 255), postGUI)
				end

				number = 4

				dxDrawImage(speedoX + 140, speedoY + 30, 34, 145, '/files/needle.png', -135+(speed/0.975)+number, 0,53, tocolor(255,255,255,255), postGUI)

				fuel = -fuel

				dxDrawImage(speedoX + 90, speedoY + 240, 22, 23,"/files/fuel0.png")
				dxDrawImageSection(speedoX + 90, speedoY + 263,22, 23/100*fuel,0,0,22, 23/100*fuel,"/files/fuel1.png",0,0,0,tocolor(246,137,52,255),postGUI)

				nitro = 45
				nitro = -nitro 

				dxDrawImage(speedoX + 195, speedoY + 240, 22, 23,"/files/bottle0.png",0,0,0,_,postGUI)
				dxDrawImageSection(speedoX + 195, speedoY + 263,22, 23/100*nitro,0,0,22, 23/100*nitro,"/files/bottle1.png",0,0,0,tocolor(12, 97, 196,255),postGUI)

			
		end

	end
end)

function getElementSpeed(theElement, unit)
    -- Check arguments for errors
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    local elementType = getElementType(theElement)
    assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    -- Default to m/s if no unit specified and 'ignore' argument type if the string contains a number
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    -- Setup our multiplier to convert the velocity to the specified unit
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    -- Return the speed by calculating the length of the velocity vector, after converting the velocity to the specified unit
    return (Vector3(getElementVelocity(theElement)) * mult).length
end
fileDelete ("sourceC.lua") 
local sx,sy = guiGetScreenSize();
local width = 441;
local height = 347;
local posX = sx/2 -width/2;
local posY = sy/2 -height/2;

local cache = {}
cache.roboto = dxCreateFont("files/roboto.ttf",20)
cache.fontawsome = dxCreateFont("files/fontawsome.ttf",20)
cache.bold = dxCreateFont("files/font_bold.ttf",20)
local rpmTemp = 0
cache.speedobg = dxCreateTexture("files/speedobg.png")

local bg = dxCreateTexture("files/speedobg.png","argb")
local speedmeter = dxCreateTexture("files/speedmeter.png","argb")
local fuelmeter = dxCreateTexture("files/fuelmeter.png", "argb")

local lock = dxCreateTexture("files/lock.png", "argb")
local unlock = dxCreateTexture("files/unlock.png", "argb")
local handbrake = dxCreateTexture("files/handbrake.png", "argb")
local light = dxCreateTexture("files/light.png", "argb")
local lindex = dxCreateTexture("files/lindex.png", "argb")
local rindex = dxCreateTexture("files/rindex.png", "argb")
local checkengine = dxCreateTexture("files/checkengine.png", "argb")
local seatbelt = dxCreateTexture("files/seatbelt.png", "argb")

local seatbeltState = false

function drawSpeedo()
    if getPedOccupiedVehicle(localPlayer) and getElementData(localPlayer,"player:interface:speedoavalible") then 
        local veh = getPedOccupiedVehicle(localPlayer)
        local t = getVehicleType(veh)
        if t == "Automobile" or t == "Monster Truck" or t == "Quad" or t == "Boat" then
        local seat = getPedOccupiedVehicleSeat(localPlayer)

        if seat == 0 or seat == 1 then 
            local speed = getElementSpeed(veh,"mph")
            speed = math.floor(speed)
            --local speed = 300
            local miles = getElementData(veh,"vehicle:miles").."ms"
            local rpm = getVehicleRPM(veh)

            actualspeed = speed
            --outputChatBox(rpm)

            if speed > 220 then
                actualspeed = 220;
            end

            if rpm > 9000 then 
                rpm = 9000 
            end

            local gaugeAngle = math.min(120, (actualspeed / 300) * 120)

            local fuel = tonumber(getElementData(veh,"vehicle:fuel"));
            
            local postGUI = getElementData(localPlayer,"player:interface")
            local posX,posY = getElementData(localPlayer,"player:interface:speedox"),getElementData(localPlayer,"player:interface:speedoy")

            dxDrawImage(posX ,posY ,width,height,bg,0,0,0,_,postGUI)

            for i = 1, math.floor(gaugeAngle * 1.62) do
                dxDrawImageSection(posX + 98, posY + 38,300,300, 0, 0, 318, 318, "files/speedmeter.png", (i+3)*2, 0,0,_,postGUI)
            end

            local rpmAngle = math.min(120, (rpm / 300) * 120)

            for i = 1, (rpm)/2 /31 do
                dxDrawImageSection(posX + 116, posY + 56,263,263, 0, 0, 318, 318, "files/rpmmeter.png", (i+2)*2, 0,0,_,postGUI)
            end

            for i = 1, fuel do
                dxDrawImageSection(posX + 31,posY + 207,85,85, 0, 0, 300,300, fuelmeter, (i*2.32)-65, 0,0,_,postGUI)
            end

            if getElementData(veh,"vehicle:engine") == 1 then 
                if getElementData(veh,"vehicle:locked") == 1 then 
                dxDrawImage(posX ,posY ,width,height,lock,0,0,0,_,postGUI)
                else
                dxDrawImage(posX ,posY,width,height,unlock,0,0,0,_,postGUI)
                end 
            
                if getElementData(veh,"vehicle:handbrake") == 1 then 
                dxDrawImage(posX ,posY ,width,height,handbrake,0,0,0,_,postGUI)
                end 
            
                if getElementData(veh,"vehicle:lights") == 1 then 
                dxDrawImage(posX ,posY ,width,height,light,0,0,0,_,postGUI)
                end 
            
                if getElementData(veh,"vehicle:left:signal") then 
                dxDrawImage(posX,posY,width,height,lindex,0,0,0,_,postGUI)
                end 

                if getElementData(veh,"vehicle:right:signal") then 
                dxDrawImage(posX,posY,width,height,rindex,0,0,0,_,postGUI)
                end 

                if not getElementData(localPlayer,"player:seatbelt") then 
                    if seatbeltState then 
                    dxDrawImage(posX ,posY ,width,height,seatbelt,0,0,0,_,postGUI)
                    end 
                end 

                if getElementHealth(veh) < 400 then 
                dxDrawImage(posX ,posY ,width,height,checkengine,0,0,0,_,postGUI)
                end 
            end

            dxDrawText(speed,posX + 250 - dxGetTextWidth(speed,0.00045*sx,cache.bold)/2,posY + 100,_,_,tocolor(246,137,52,255),0.00045*sx,cache.bold,"left","top",false,false,postGUI)
            dxDrawText("MPH",posX + 225,posY + 130,_,_,tocolor(255,255,255,255),0.00045*sx,cache.roboto,"left","top",false,false,postGUI)
            dxDrawText("Futott mérföld",posX + 200,posY + 200,_,_,tocolor(200,200,200,255),0.0003*sx,cache.roboto,"left","top",false,false,postGUI)
            dxDrawText(miles,posX + 250 - dxGetTextWidth(miles,0.0003*sx,cache.bold)/2,posY + 225,_,_,tocolor(246,137,52,255),0.0003*sx,cache.bold,"left","top",false,false,postGUI)
            dxDrawText("",posX + 60,posY + 240,_,_,tocolor(246,137,52,255),0.00032*sx,cache.fontawsome,"left","top",false,false,postGUI)
        end 
        end
    end 
end 
addEventHandler("onClientRender",root,drawSpeedo)

setTimer(function()
    if getPedOccupiedVehicle(localPlayer) then 
        if not getElementData(localPlayer,"player:seatbelt") then 
            if not seatbeltState then 
                seatbeltState = true 
            else 
                seatbeltState = false 
            end 
        end 
    end 
end,600,0)

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

function getVehicleSpeed()
    if getPedOccupiedVehicle(localPlayer) then
        local vx, vy, vz = getElementVelocity(getPedOccupiedVehicle(localPlayer))
        return math.sqrt(vx^2 + vy^2 + vz^2) * 187.5
    end
    return 0
end


function getRPM(maxW)
	local gear = tonumber(getVehicleCurrentGear(getPedOccupiedVehicle(localPlayer)))
	local speed = getVehicleSpeed()
	if gear == 0 then
		gear = 1
		maxW = maxW/2
	end
	local rpm = math.floor((speed/gear)*1.1)
	if rpm > maxW then
		rpm = maxW
	end
	return rpm, math.floor(speed)
end

function getVehicleRPM(vehicle)
    local vehicleRPM = 0
        if (vehicle) then  
            if (getVehicleEngineState(vehicle) == true) then
                if getVehicleCurrentGear(vehicle) > 0 then             
                    vehicleRPM = math.floor(((getElementSpeed(vehicle, "mph") / getVehicleCurrentGear(vehicle)) * 160) + 0.5) 
                    if (vehicleRPM < 650) then
                        vehicleRPM = math.random(650, 750)
                    elseif (vehicleRPM >= 9000) then
                        vehicleRPM = math.random(9000, 9900)
                    end
                else
                    vehicleRPM = math.floor((getElementSpeed(vehicle, "mph") * 160) + 0.5)
                    if (vehicleRPM < 650) then
                        vehicleRPM = math.random(650, 750)
                    elseif (vehicleRPM >= 9000) then
                        vehicleRPM = math.random(9000, 9900)
                    end
                end
            else
                vehicleRPM = 0
            end
    
            return tonumber(vehicleRPM)
        else
            return 0
        end
    end
fileDelete ("sourceC.lua") 
local sx,sy = guiGetScreenSize()
local cache = {}
local cPos = {}
cache.roboto = dxCreateFont("files/roboto.ttf",20)
cache.fontawsome = dxCreateFont("files/fontawsome.ttf",20)
cache.showInterface = false 
local widgets = {}
--csak a hud miatt:: 
local width = 399;
local height = 80;

local posX = sx/2 -width/2;
local posY = sy/2 -height/2;
--
local click = false
--
local myX, myY = 1600,900

local size = 0.9 -- NE ÁLLÍTSD ÁT!!!!!!
local phoneX, phoneY = sx*0.87,sy*0.25
local phoneW, phoneH = 259/myX*sx*size, 512/myY*sy*size

--
local defaultPositions = {

	["radar"] = {"Térkép",sx*0.01,sy*0.75,sx*0.21,sy*0.25,true},
	["speedo"] = {"Kilóméteróra",sx*0.835,sy*0.7,310,310,true},
	["hud"] = {"Játékos Statisztikák",sx*0.8,sy*0.005,sx*0.19,sy*0.081,true},

	["money"] = {"Pénz",sx*0.845,sy*0.09,sx*0.1,sy*0.03,true},
	["time"] = {"Idő",sx*0.92,sy*0.09,sx*0.04,sy*0.03,true},
	["fps"] = {"Frame Per Secound",sx*0.97,sy*0.09,sx*0.04,sy*0.03,true},

	["actionbar"] = {"Actionbar",sx*0.435,sy*0.926,266,57,true},
	["ooc"] = {"OOC Chat",sx*0.012,sy*0.5,300,200,true},
	["phone"] = {"Telefon",phoneX,phoneY,phoneW,phoneH,true},
}

local widgetPositions = { -- NOWavalible

	["radar"] = {"Térkép",sx*0.01,sy*0.75,sx*0.21,sy*0.25,true},
	["speedo"] = {"Kilóméteróra",sx*0.835,sy*0.7,310,310,true},
	["hud"] = {"Játékos Statisztikák",sx*0.8,sy*0.005,sx*0.19,sy*0.081,true},

	["money"] = {"Pénz",sx*0.845,sy*0.09,sx*0.1,sy*0.03,true},
	["time"] = {"Idő",sx*0.92,sy*0.09,sx*0.04,sy*0.03,true},
	["fps"] = {"Frame Per Secound",sx*0.97,sy*0.09,sx*0.04,sy*0.03,true},

	["actionbar"] = {"Actionbar",sx*0.435,sy*0.926,266,57,true},
	["ooc"] = {"OOC Chat",sx*0.012,sy*0.5,300,200,true},
	["phone"] = {"Telefon",phoneX,phoneY,phoneW,phoneH,true},
} 

function toggleCursor()
	if isCursorShowing( localPlayer ) then 
		showCursor( false ) else 
		showCursor( true )
	end
end

bindKey( "m", "down", toggleCursor )

--[[function jsonGET(file)
	local fileHandle
	local jsonDATA = {}
	if not fileExists(file) then
		fileHandle = fileCreate(file)
		fileWrite(fileHandle, toJSON({["WidgetDatas"] = widgetPositions}))
		fileClose(fileHandle)
		fileHandle = fileOpen(file)
	else
		fileHandle = fileOpen(file)
	end
	if fileHandle then
		local buffer
		local allBuffer = ""
		while not fileIsEOF(fileHandle) do
			buffer = fileRead(fileHandle, 500)
			allBuffer = allBuffer..buffer
		end
		jsonDATA = fromJSON(allBuffer)
		fileClose(fileHandle)
	end
	return jsonDATA
end
  
function jsonSAVE(file, data)
	if fileExists(file) then
		fileDelete(file)
	end
	local fileHandle = fileCreate(file)
	fileWrite(fileHandle, toJSON(data))
	fileFlush(fileHandle)
	fileClose(fileHandle)
	return true
end

local widgetPos = {}

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        local table = jsonGET("widgetDatas.json")
        widgetPos = table["WidgetDatas"]
        for k,v in pairs(widgetPos) do
            local name,x,y,w,h,avalible = unpack(v)
            setElementData(localPlayer,"player:interface:"..k.."x",x)
            setElementData(localPlayer,"player:interface:"..k.."y",y)
            setElementData(localPlayer,"player:interface:"..k.."w",w)
            setElementData(localPlayer,"player:interface:"..k.."h",h)
            setElementData(localPlayer,"player:interface:"..k.."avalible",avalible)


            widgetPositions[k][2] = x
            widgetPositions[k][3] = y
            widgetPositions[k][4] = w
            widgetPositions[k][5] = h
            widgetPositions[k][6] = avalible
        end
    end
)

function onClientResourceStop()
	if getElementData(localPlayer, "player:loggedIn") then
	  jsonSAVE("widgetDatas.json", {["WidgetDatas"] = widgetPositions})
	end
end 
addEventHandler("onClientResourceStop",resourceRoot,onClientResourceStop)]]

function drawInterface() --cache.showInterface and
    if cache.showInterface and getElementData(localPlayer,"player:loggedIn") then 
        local r, g, b = interpolateBetween(240,240,240, 96, 152, 230, getTickCount() / 2000, "CosineCurve");
        nameColor = string.format("#%.2X%.2X%.2X", r, g, b);

        dxDrawRectangle(0,0,sx*0.9999,sy*0.9999,tocolor(129, 99, 191,50))
        dxDrawText("Interface Szerkesztés",sx*0.47 - 1,sy*0.45 + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.roboto)
        dxDrawText("Interface Szerkesztés",sx*0.47,sy*0.45,_,_,tocolor(r, g, b,255),0.0003*sx,cache.roboto)

		local money = getElementData(localPlayer,"player:money")
		local finalmoney = getFinalConvert(10,money)
		local realmoney = formatMoney(money)

		local time = getRealTime()
		local h = time.hour
		local m = time.minute
	  
		if h < 10 then h = "0"..h end
		if m < 10 then m = "0"..m end

		for k,v in pairs(widgetPositions) do 
		

			if k == "hud" then 
				if v[6] == true then
					roundedRectangle(v[2] ,v[3] ,v[4],v[5],tocolor(96, 152, 230,150))
	
					dxDrawText("",v[2] + sx*0.181 - 1 ,v[3] - sy*0.002 + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.fontawsome,"left","top",false,false,true)
					dxDrawText("",v[2] + sx*0.181 ,v[3] - sy*0.002,_,_,tocolor(129, 99, 191,255),0.0003*sx,cache.fontawsome,"left","top",false,false,true)
	
					dxDrawText("",v[2] + sx*0.17 - 1 ,v[3] + 1,_,_,tocolor(0,0,0,255),0.00025*sx,cache.fontawsome,"left","top",false,false,true)
					dxDrawText("",v[2] + sx*0.17 ,v[3],_,_,tocolor(129, 99, 191,255),0.00025*sx,cache.fontawsome,"left","top",false,false,true)
	
				else 
						roundedRectangle(v[2],v[3] ,v[4],v[5],tocolor(96, 152, 230,150))

						dxDrawText("Törölt Widget",v[2] + sx*0.07 - 1,v[3] + sy*0.015 + 1,_,_,tocolor(0,0,0,255),0.00032*sx,cache.roboto,"left","top",false,false,false)
						dxDrawText("Törölt Widget",v[2] + sx*0.07,v[3] + sy*0.015,_,_,tocolor(255,255,255,255),0.00032*sx,cache.roboto,"left","top",false,false,false)

						dxDrawText("",v[2] + sx*0.09 - 1,v[3] + sy*0.04 + 1,_,_,tocolor(0,0,0,255),0.00025*sx,cache.fontawsome,"left","top",false,false,false)
						dxDrawText("",v[2] + sx*0.09 ,v[3] + sy*0.04,_,_,tocolor(129, 99, 191,255),0.00025*sx,cache.fontawsome,"left","top",false,false,false)
				end 
			elseif k == "time" then 
				if v[6] == true then 
				roundedRectangle(v[2] - sx*0.02,v[3] + sy*0.001,v[4]  ,v[5],tocolor(96, 152, 230,150))

				dxDrawText("",v[2] + sx*0.013 - 1,v[3] - sy*0.002 + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.fontawsome,"left","top",false,false,true)
				dxDrawText("",v[2] + sx*0.013,v[3] - sy*0.002,_,_,tocolor(129, 99, 191,255),0.0003*sx,cache.fontawsome,"left","top",false,false,true)

				dxDrawText("",v[2] + sx*0.002 - 1 ,v[3] + 1,_,_,tocolor(0,0,0,255),0.00025*sx,cache.fontawsome,"left","top",false,false,true)
				dxDrawText("",v[2] + sx*0.002 ,v[3] ,_,_,tocolor(129, 99, 191,255),0.00025*sx,cache.fontawsome,"left","top",false,false,true)
				else 
					roundedRectangle(v[2] - sx*0.02,v[3] + sy*0.001,v[4]  ,v[5],tocolor(96, 152, 230,150))

					dxDrawText("",v[2] - sx*0.004 - 1,v[3] + sy*0.007 + 1,_,_,tocolor(0,0,0,255),0.00025*sx,cache.fontawsome,"left","top",false,false,true)
					dxDrawText("",v[2] - sx*0.004,v[3] + sy*0.007,_,_,tocolor(129, 99, 191,255),0.00025*sx,cache.fontawsome,"left","top",false,false,true)
				end 
			elseif k == "money" then 
				if v[6] == true then 
				roundedRectangle(v[2] - sx*0.05,v[3] + sy*0.001 ,v[4]  ,v[5],tocolor(96, 152, 230,150))

				dxDrawText("",v[2] + sx*0.043 - 1,v[3] - sy*0.002 + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.fontawsome,"left","top",false,false,true)
				dxDrawText("",v[2] + sx*0.043,v[3] - sy*0.002,_,_,tocolor(129, 99, 191,255),0.0003*sx,cache.fontawsome,"left","top",false,false,true)

				dxDrawText("",v[2] + sx*0.032 - 1,v[3] + 1,_,_,tocolor(0,0,0,255),0.00025*sx,cache.fontawsome,"left","top",false,false,true)
				dxDrawText("",v[2] + sx*0.032,v[3],_,_,tocolor(129, 99, 191,255),0.00025*sx,cache.fontawsome,"left","top",false,false,true)

				else 
					roundedRectangle(v[2] - sx*0.05,v[3] + sy*0.001 ,v[4]  ,v[5],tocolor(96, 152, 230,150))

					dxDrawText("Törölt Widget",v[2] - sx*0.048 - 1,v[3] + sy*0.004 + 1,_,_,tocolor(0,0,0,255),0.00032*sx,cache.roboto,"left","top",false,false,false)
					dxDrawText("Törölt Widget",v[2] - sx*0.048,v[3] + sy*0.004,_,_,tocolor(255,255,255,255),0.00032*sx,cache.roboto,"left","top",false,false,false)

					dxDrawText("",v[2] + sx*0.038 - 1,v[3] + sy*0.007 + 1,_,_,tocolor(0,0,0,255),0.00025*sx,cache.fontawsome,"left","top",false,false,true)
					dxDrawText("",v[2] + sx*0.038,v[3] + sy*0.007,_,_,tocolor(129, 99, 191,255),0.00025*sx,cache.fontawsome,"left","top",false,false,true)
				end 	
			elseif k == "actionbar" then 
				if v[6] == true then 
				roundedRectangle(v[2],v[3],v[4],v[5],tocolor(96, 152, 230,150))
				dxDrawText("",v[2] + v[4]/1.06 - 1,v[3] + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.fontawsome,"left","top",false,false,true)
				dxDrawText("",v[2] + v[4]/1.06,v[3],_,_,tocolor(255,255,255,255),0.0003*sx,cache.fontawsome,"left","top",false,false,true)
				dxDrawText("",v[2] + v[4]/1.16 - 1,v[3] + 2 + 1,_,_,tocolor(0,0,0,255),0.00025*sx,cache.fontawsome,"left","top",false,false,true)
				dxDrawText("",v[2] + v[4]/1.16,v[3] + 2,_,_,tocolor(255,255,255,255),0.00025*sx,cache.fontawsome,"left","top",false,false,true)
				else 
					roundedRectangle(v[2],v[3],v[4],v[5],tocolor(96, 152, 230,150))
					dxDrawText("Törölt Widget",v[2] + 83 - 1,v[3] + 10 + 1,_,_,tocolor(0,0,0,255),0.00032*sx,cache.roboto,"left","top",false,false,false)
					dxDrawText("Törölt Widget",v[2] + 83 ,v[3] + 10,_,_,tocolor(255,255,255,255),0.00032*sx,cache.roboto,"left","top",false,false,false)

					dxDrawText("",v[2] + 123 - 1,v[3] + 35 + 1,_,_,tocolor(0,0,0,255),0.00025*sx,cache.fontawsome,"left","top",false,false,false)
					dxDrawText("",v[2] + 123 ,v[3] + 35,_,_,tocolor(255,255,255,255),0.00025*sx,cache.fontawsome,"left","top",false,false,false)	
				end 
			elseif k == "fps" then 
				if v[6] == true then 
					roundedRectangle(v[2] - sx*0.02,v[3] + sy*0.001,v[4]  ,v[5],tocolor(96, 152, 230,150))
	
					dxDrawText("",v[2] + sx*0.013 - 1,v[3] - sy*0.002 + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.fontawsome,"left","top",false,false,true)
					dxDrawText("",v[2] + sx*0.013,v[3] - sy*0.002,_,_,tocolor(129, 99, 191,255),0.0003*sx,cache.fontawsome,"left","top",false,false,true)
	
					dxDrawText("",v[2] + sx*0.002 - 1 ,v[3] + 1,_,_,tocolor(0,0,0,255),0.00025*sx,cache.fontawsome,"left","top",false,false,true)
					dxDrawText("",v[2] + sx*0.002 ,v[3] ,_,_,tocolor(129, 99, 191,255),0.00025*sx,cache.fontawsome,"left","top",false,false,true)
				else 
					roundedRectangle(v[2] - sx*0.02,v[3] + sy*0.001,v[4]  ,v[5],tocolor(96, 152, 230,150))
	
						dxDrawText("",v[2] - sx*0.004 - 1,v[3] + sy*0.007 + 1,_,_,tocolor(0,0,0,255),0.00025*sx,cache.fontawsome,"left","top",false,false,true)
						dxDrawText("",v[2] - sx*0.004,v[3] + sy*0.007,_,_,tocolor(129, 99, 191,255),0.00025*sx,cache.fontawsome,"left","top",false,false,true)
				end 
			elseif k == "radar" then 
				if v[6] == true then 
					roundedRectangle(v[2] - 9,v[3] - 10,v[4]  ,v[5],tocolor(96, 152, 230,150))
	
					dxDrawText("",v[2] + sx*0.197 - 1,v[3] - sy*0.01 + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.fontawsome,"left","top",false,false,true)
					dxDrawText("",v[2] + sx*0.197,v[3] - sy*0.01,_,_,tocolor(129, 99, 191,255),0.0003*sx,cache.fontawsome,"left","top",false,false,true)
	
					dxDrawText("",v[2] + sx*0.185 - 1,v[3] - sy*0.008 + 1,_,_,tocolor(0,0,0,255),0.00025*sx,cache.fontawsome,"left","top",false,false,true)
					dxDrawText("",v[2] + sx*0.185,v[3] - sy*0.008,_,_,tocolor(129, 99, 191,255),0.00025*sx,cache.fontawsome,"left","top",false,false,true)
					else 
						roundedRectangle(v[2] - 9,v[3] - 10,v[4]  ,v[5],tocolor(96, 152, 230,150))
	
						dxDrawText("Törölt Widget",v[2] + sx*0.075 - 1,v[3] + sy*0.08 + 1,_,_,tocolor(0,0,0,255),0.00032*sx,cache.roboto,"left","top",false,false,false)
						dxDrawText("Törölt Widget",v[2] + sx*0.075 ,v[3] + sy*0.08,_,_,tocolor(255,255,255,255),0.00032*sx,cache.roboto,"left","top",false,false,false)
	
						dxDrawText("",v[2]  + sx*0.095 - 1,v[3] + sy*0.11 + 1,_,_,tocolor(0,0,0,255),0.00025*sx,cache.fontawsome,"left","top",false,false,true)
						dxDrawText("",v[2]  + sx*0.095,v[3] + sy*0.11,_,_,tocolor(129, 99, 191,255),0.00025*sx,cache.fontawsome,"left","top",false,false,true)
					end 	
			elseif k == "ooc" then 
				if v[6] == true then 
					roundedRectangle(v[2],v[3],v[4],v[5],tocolor(96, 152, 230,150))
					dxDrawText("",v[2] + 285 - 1,v[3] + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.fontawsome,"left","top",false,false,true)
					dxDrawText("",v[2] + 285,v[3],_,_,tocolor(255,255,255,255),0.0003*sx,cache.fontawsome,"left","top",false,false,true)

					dxDrawText("",v[2] + 265 - 1,v[3] + 2 + 1,_,_,tocolor(0,0,0,255),0.00025*sx,cache.fontawsome,"left","top",false,false,true)
					dxDrawText("",v[2] + 265 ,v[3] + 2,_,_,tocolor(255,255,255,255),0.00025*sx,cache.fontawsome,"left","top",false,false,true)
				else 
					roundedRectangle(v[2],v[3],v[4],v[5],tocolor(96, 152, 230,150))
					dxDrawText("Törölt Widget",v[2] + 100 - 1 ,v[3] + 70 + 1,_,_,tocolor(0,0,0,255),0.00032*sx,cache.roboto,"left","top",false,false,false)
					dxDrawText("Törölt Widget",v[2] + 100,v[3] + 70 ,_,_,tocolor(255,255,255,255),0.00032*sx,cache.roboto,"left","top",false,false,false)

					dxDrawText("",v[2] + 140 - 1 ,v[3] + 100 + 1,_,_,tocolor(0,0,0,255),0.00025*sx,cache.fontawsome,"left","top",false,false,false)
					dxDrawText("",v[2] + 140 ,v[3] + 100,_,_,tocolor(255,255,255,255),0.00025*sx,cache.fontawsome,"left","top",false,false,false)
				end 
			elseif k == "speedo" then 
					if getPedOccupiedVehicle(localPlayer) then 
						if v[6] == true then 
						roundedRectangle(v[2],v[3],v[4]  ,v[5],tocolor(96, 152, 230,150))
						
						dxDrawText("",v[2] + 295 - 1,v[3] + 1 ,_,_,tocolor(0,0,0,255),0.0003*sx,cache.fontawsome,"left","top",false,false,true)
						dxDrawText("",v[2] + 295,v[3] ,_,_,tocolor(129, 99, 191,255),0.0003*sx,cache.fontawsome,"left","top",false,false,true)
						
						dxDrawText("",v[2] + 270 - 1,v[3] + 2 + 1,_,_,tocolor(0,0,0,255),0.00025*sx,cache.fontawsome,"left","top",false,false,true)
						dxDrawText("",v[2] + 270,v[3] + 2,_,_,tocolor(129, 99, 191,255),0.00025*sx,cache.fontawsome,"left","top",false,false,true)
						else 
							roundedRectangle(v[2],v[3],v[4]  ,v[5],tocolor(96, 152, 230,150))
						
							dxDrawText("Törölt Widget",v[2] + 110 - 1,v[3] + 100 + 1,_,_,tocolor(0,0,0,255),0.00032*sx,cache.roboto,"left","top",false,false,false)
							dxDrawText("Törölt Widget",v[2] + 110 ,v[3] + 100,_,_,tocolor(255,255,255,255),0.00032*sx,cache.roboto,"left","top",false,false,false)
						
							dxDrawText("",v[2]  + 150 - 1,v[3] + 130 + 1,_,_,tocolor(0,0,0,255),0.00025*sx,cache.fontawsome,"left","top",false,false,true)
							dxDrawText("",v[2] + 150 ,v[3] + 130,_,_,tocolor(129, 99, 191,255),0.00025*sx,cache.fontawsome,"left","top",false,false,true)
						end 	
					else 
						roundedRectangle(v[2],v[3],v[4]  ,v[5],tocolor(96, 152, 230,150))

						dxDrawText("Speedo (Járműben elérhető)",v[2] + 60 ,v[3] + 130,_,_,tocolor(255,255,255,255),0.00032*sx,cache.roboto,"left","top",false,false,false)
					end
			else
				if v[6] == true then 
				roundedRectangle(v[2],v[3],v[4],v[5],tocolor(96, 152, 230,150))
				dxDrawText("",v[2] + v[4]/1.04 - 1,v[3] + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.fontawsome,"left","top",false,false,true)
				dxDrawText("",v[2] + v[4]/1.04,v[3],_,_,tocolor(255,255,255,255),0.0003*sx,cache.fontawsome,"left","top",false,false,true)
				dxDrawText("",v[2] + v[4]/1.11 - 1,v[3] + 2 + 1,_,_,tocolor(0,0,0,255),0.00025*sx,cache.fontawsome,"left","top",false,false,true)
				dxDrawText("",v[2] + v[4]/1.11,v[3] + 2,_,_,tocolor(255,255,255,255),0.00025*sx,cache.fontawsome,"left","top",false,false,true)
				end 
			end

			if isCursorShowing(localPayer) then 
				cursorX, cursorY = getCursorPosition()
				cursorX, cursorY = cursorX * sx, cursorY * sy	
				if click then 
			
				 if click then 
				   left, top = cursorX + windowOffsetX, cursorY + windowOffsetY
				 end
			
				 setElementData(localPlayer,"player:interface:"..widgetID.."x",left)
				 setElementData(localPlayer,"player:interface:"..widgetID.."y",top)
				 widgetPositions[widgetID][2] = left
				 widgetPositions[widgetID][3] = top
			
			
				end
			end
        end 

    end 
end 
addEventHandler("onClientRender",root,drawInterface)

bindKey("lctrl","down",function() if isCursorShowing() then  cache.showInterface = true setElementData(localPlayer,"player:interface",true) end end)
bindKey("lctrl","up",function() cache.showInterface = false setElementData(localPlayer,"player:interface",false) end)

function widgetMove(button, state, absoluteX, absoluteY, worldX, worldY, worldZ)
	if (button == "left") and cache.showInterface then 
   
	 for k,v in pairs(widgetPositions) do 
		if k == "hud" then
		  if isInSlot(widgetPositions[k][2],widgetPositions[k][3],widgetPositions[k][4],widgetPositions[k][5]) then 
				widgetID = k
		  	if state == "down" then 
				windowOffsetX, windowOffsetY = (v[2]) - absoluteX, (v[3]) - absoluteY
				click = true
		  	elseif state == "up" then
				windowOffsetX, windowOffsetY = (v[2]) - absoluteX, (v[3]) - absoluteY
				click = false
		  	end
		  end
	   elseif k == "speedo" then
		if isInSlot(widgetPositions[k][2] + 15,widgetPositions[k][3] + 15,widgetPositions[k][4],widgetPositions[k][5]) then 
			widgetID = k
			if state == "down" then 
			 windowOffsetX, windowOffsetY = (v[2]) - absoluteX, (v[3]) - absoluteY
			 click = true
			elseif state == "up" then
			 windowOffsetX, windowOffsetY = (v[2]) - absoluteX, (v[3]) - absoluteY
			 click = false
			end
		end 
	   elseif k == "time" then 
		if isInSlot(widgetPositions[k][2] - sx*0.02,widgetPositions[k][3] + sy*0.001,widgetPositions[k][4],widgetPositions[k][5]) then 
			widgetID = k
			if state == "down" then 
			 windowOffsetX, windowOffsetY = (v[2]) - absoluteX, (v[3]) - absoluteY
			 click = true
			elseif state == "up" then
			 windowOffsetX, windowOffsetY = (v[2]) - absoluteX, (v[3]) - absoluteY
			 click = false
			end
		end
	   elseif k == "fps" then 
		if isInSlot(widgetPositions[k][2] - sx*0.02,widgetPositions[k][3] + sy*0.001,widgetPositions[k][4],widgetPositions[k][5]) then 
			widgetID = k
			if state == "down" then 
			 windowOffsetX, windowOffsetY = (v[2]) - absoluteX, (v[3]) - absoluteY
			 click = true
			elseif state == "up" then
			 windowOffsetX, windowOffsetY = (v[2]) - absoluteX, (v[3]) - absoluteY
			 click = false
			end
		end
	   elseif k == "money" then 
		if isInSlot(widgetPositions[k][2] - sx*0.05,widgetPositions[k][3] + sy*0.001,widgetPositions[k][4],widgetPositions[k][5]) then 
			widgetID = k
			if state == "down" then 
			 windowOffsetX, windowOffsetY = (v[2]) - absoluteX, (v[3]) - absoluteY
			 click = true
			elseif state == "up" then
			 windowOffsetX, windowOffsetY = (v[2]) - absoluteX, (v[3]) - absoluteY
			 click = false
			end
		end
	   elseif k == "radar" then 
		if isInSlot(widgetPositions[k][2] - 9,widgetPositions[k][3] -10,widgetPositions[k][4],widgetPositions[k][5]) then 
			widgetID = k
			if state == "down" then 
			 windowOffsetX, windowOffsetY = (v[2]) - absoluteX, (v[3]) - absoluteY
			 click = true
			elseif state == "up" then
			 windowOffsetX, windowOffsetY = (v[2]) - absoluteX, (v[3]) - absoluteY
			 click = false
			end
		end
	   else 
		if isInSlot(widgetPositions[k][2],widgetPositions[k][3],widgetPositions[k][4],widgetPositions[k][5]) then 
			widgetID = k
			if state == "down" then 
			 windowOffsetX, windowOffsetY = (v[2]) - absoluteX, (v[3]) - absoluteY
			 click = true
			elseif state == "up" then
			 windowOffsetX, windowOffsetY = (v[2]) - absoluteX, (v[3]) - absoluteY
			 click = false
			end
		end
	   end 

	 end
	end
end 
addEventHandler("onClientClick",root,widgetMove)

function deleteWidget(button, state, absoluteX, absoluteY, worldX, worldY, worldZ)
	if button == "left" and state == "down" and cache.showInterface then 
		for k,v in pairs(widgetPositions) do 
			if k == "hud" then 
				if isInSlot(v[2] + sx*0.181 ,v[3] - sy*0.002,sx*0.008,sy*0.02) then 
					if v[6] == true then 
						v[6] = false 
						setElementData(localPlayer,"player:interface:"..k.."avalible",false)
					end 
				end 
			elseif k == "time" then 
				if isInSlot(v[2] + sx*0.013,v[3] - sy*0.002,sx*0.008,sy*0.02) then 
					if v[6] == true then 
						v[6] = false 
						setElementData(localPlayer,"player:interface:"..k.."avalible",false)
					end 
				end 
			elseif k == "money" then 
				if isInSlot(v[2] + sx*0.043,v[3] - sy*0.002,sx*0.008,sy*0.02) then 
					if v[6] == true then 
						v[6] = false 
						setElementData(localPlayer,"player:interface:"..k.."avalible",false)
					end 
				end 
			elseif k == "fps" then 
				if isInSlot(v[2] + sx*0.013,v[3] - sy*0.002,sx*0.008,sy*0.02) then 
					if v[6] == true then 
						v[6] = false 
						setElementData(localPlayer,"player:interface:"..k.."avalible",false)
					end 
				end 
			elseif k == "radar" then 
				if isInSlot(v[2] + sx*0.197,v[3] - sy*0.01,sx*0.008,sy*0.02) then 
					if v[6] == true then 
						v[6] = false 
						setElementData(localPlayer,"player:interface:"..k.."avalible",false) 
					end 
				end 	
			elseif k == "ooc" then 
				if isInSlot(v[2] + sx*0.148,v[3],sx*0.008,sy*0.02) then 
					if v[6] == true then 
						v[6] = false 
						setElementData(localPlayer,"player:interface:"..k.."avalible",false)
					end 
				end 
			elseif k == "actionbar" then 
				if isInSlot(v[2] + v[4]/1.06,v[3],sx*0.008,sy*0.02) then 
					if v[6] == true then 
						v[6] = false 
						setElementData(localPlayer,"player:interface:"..k.."avalible",false)
					end 
				end 
			elseif k == "speedo" then 
				if isInSlot(v[2] + 295,v[3],sx*0.008,sy*0.02) then 
					if v[6] == true then 
						v[6] = false 
						setElementData(localPlayer,"player:interface:"..k.."avalible",false)
					end 
				end 
			end 
		end 
	end 
end 
addEventHandler("onClientClick",root,deleteWidget)

function refreshWidget(button, state, absoluteX, absoluteY, worldX, worldY, worldZ)
	if button == "left" and cache.showInterface then 
		for k,v in pairs(widgetPositions) do 
			if not click then 
				if k == "hud" then 
					if isInSlot(v[2] + sx*0.17 ,v[3],sx*0.008,sy*0.02) then 
						if v[6] == true then 
							setElementData(localPlayer,"player:interface:"..k.."x",defaultPositions[k][2])
							setElementData(localPlayer,"player:interface:"..k.."y",defaultPositions[k][3])
							widgetPositions[k][2] = defaultPositions[k][2]
							widgetPositions[k][3] = defaultPositions[k][3]
						end 
					end 
				elseif k == "time" then 
					if isInSlot(v[2] + sx*0.002 ,v[3],sx*0.008,sy*0.02) then 
						if v[6] == true then 
							setElementData(localPlayer,"player:interface:"..k.."x",defaultPositions[k][2])
							setElementData(localPlayer,"player:interface:"..k.."y",defaultPositions[k][3])
							widgetPositions[k][2] = defaultPositions[k][2]
							widgetPositions[k][3] = defaultPositions[k][3]
						end 
					end 
				elseif k == "fps" then 
					if isInSlot(v[2] + sx*0.002 ,v[3],sx*0.008,sy*0.02) then 
						if v[6] == true then 
							setElementData(localPlayer,"player:interface:"..k.."x",defaultPositions[k][2])
							setElementData(localPlayer,"player:interface:"..k.."y",defaultPositions[k][3])
							widgetPositions[k][2] = defaultPositions[k][2]
							widgetPositions[k][3] = defaultPositions[k][3]
						end 
					end 	
				elseif k == "money" then 
					if isInSlot(v[2] + sx*0.032,v[3],sx*0.008,sy*0.02) then 
						if v[6] == true then 
							setElementData(localPlayer,"player:interface:"..k.."x",defaultPositions[k][2])
							setElementData(localPlayer,"player:interface:"..k.."y",defaultPositions[k][3])
							widgetPositions[k][2] = defaultPositions[k][2]
							widgetPositions[k][3] = defaultPositions[k][3]
						end 
					end 
				elseif k == "radar" then 
					if isInSlot(v[2] + sx*0.185,v[3] - sy*0.008,sx*0.008,sy*0.02) then 
						if v[6] == true then 
							setElementData(localPlayer,"player:interface:"..k.."x",defaultPositions[k][2])
							setElementData(localPlayer,"player:interface:"..k.."y",defaultPositions[k][3])
							widgetPositions[k][2] = defaultPositions[k][2]
							widgetPositions[k][3] = defaultPositions[k][3]
						end 
					end
				elseif k == "ooc" then 
					if isInSlot(v[2] + sx*0.135 ,v[3] + 2,sx*0.008,sy*0.02) then 
						if v[6] == true then 
							setElementData(localPlayer,"player:interface:"..k.."x",defaultPositions[k][2])
							setElementData(localPlayer,"player:interface:"..k.."y",defaultPositions[k][3])
							widgetPositions[k][2] = defaultPositions[k][2]
							widgetPositions[k][3] = defaultPositions[k][3]
						end 
					end 
				elseif k == "actionbar" then 
					if isInSlot(v[2] + v[4]/1.16,v[3] + 2,sx*0.008,sy*0.02) then 
						if v[6] == true then 
							setElementData(localPlayer,"player:interface:"..k.."x",defaultPositions[k][2])
							setElementData(localPlayer,"player:interface:"..k.."y",defaultPositions[k][3])
							widgetPositions[k][2] = defaultPositions[k][2]
							widgetPositions[k][3] = defaultPositions[k][3]
						end 
					end 
				elseif k == "speedo" then
					if isInSlot(v[2] + 270,v[3] + 2,sx*0.008,sy*0.02) then 
						if v[6] == true then 
							setElementData(localPlayer,"player:interface:"..k.."x",defaultPositions[k][2])
							setElementData(localPlayer,"player:interface:"..k.."y",defaultPositions[k][3])
							widgetPositions[k][2] = defaultPositions[k][2]
							widgetPositions[k][3] = defaultPositions[k][3]
						end 
					end 
				end 
			end 
		end 
	end 
end 
addEventHandler("onClientClick",root,refreshWidget)

function restartWidget(button, state, absoluteX, absoluteY, worldX, worldY, worldZ)
	if button == "left" and state == "down" and cache.showInterface then 
		for k,v in pairs(widgetPositions) do 
			if k == "hud" then 
				if isInSlot(v[2] + sx*0.09 ,v[3] + sy*0.04,sx*0.008,sy*0.02) then 
					if v[6] == false then 
						v[6] = true 
						setElementData(localPlayer,"player:interface:"..k.."avalible",true)
					end 
				end 
			elseif k == "time" then 
				if isInSlot(v[2] - sx*0.004,v[3] + sy*0.007,sx*0.008,sy*0.02) then 
					if v[6] == false then 
						v[6] = true 
						setElementData(localPlayer,"player:interface:"..k.."avalible",true)
					end 
				end 
			elseif k == "fps" then 
				if isInSlot(v[2] - sx*0.004,v[3] + sy*0.007,sx*0.008,sy*0.02) then 
					if v[6] == false then 
						v[6] = true 
						setElementData(localPlayer,"player:interface:"..k.."avalible",true)
					end 
				end 
			elseif k == "money" then 
				if isInSlot(v[2] + sx*0.038,v[3] + sy*0.007,sx*0.008,sy*0.02) then 
					if v[6] == false then 
						v[6] = true 
						setElementData(localPlayer,"player:interface:"..k.."avalible",true)
					end 
				end 
			elseif k == "radar" then 
				if isInSlot(v[2]  + sx*0.095,v[3] + sy*0.11,sx*0.008,sy*0.02) then
					if v[6] == false then 
						v[6] = true 
						setElementData(localPlayer,"player:interface:"..k.."avalible",true)
					end 
				end
			elseif k == "ooc" then 
				if isInSlot(v[2] + 140 ,v[3] + 100,sx*0.008,sy*0.02) then 
					if v[6] == false then 
						v[6] = true 
						setElementData(localPlayer,"player:interface:"..k.."avalible",true)
					end 
				end
			elseif k == "actionbar" then 
				if isInSlot(v[2] + 123 ,v[3] + 35,sx*0.008,sy*0.02) then 
					if v[6] == false then 
						v[6] = true 
						setElementData(localPlayer,"player:interface:"..k.."avalible",true)
					end 
				end
			elseif k == "speedo" then 
				if isInSlot(v[2] + 150 ,v[3] + 130,sx*0.008,sy*0.02) then 
					if v[6] == false then 
						v[6] = true 
						setElementData(localPlayer,"player:interface:"..k.."avalible",true)
					end 
				end
			end 
		end 
	end 
end 
addEventHandler("onClientClick",root,restartWidget)

addCommandHandler("resethud",function()
	outputChatBox("#f68934Interface: #ffffffWidgetek alaphelyzetbe állítva.",255,255,255,true)
	for k ,v in pairs(defaultPositions) do 
		setElementData(localPlayer,"player:interface:"..k.."x",v[2])
		setElementData(localPlayer,"player:interface:"..k.."y",v[3])
		setElementData(localPlayer,"player:interface:"..k.."w",v[4])
		setElementData(localPlayer,"player:interface:"..k.."h",v[5])
		setElementData(localPlayer,"player:interface:"..k.."avalible",true)
	
		widgetPositions[k][1] = v[1]
		widgetPositions[k][2] = v[2]
		widgetPositions[k][3] = v[3]
		widgetPositions[k][4] = v[4]
		widgetPositions[k][5] = v[5]
		widgetPositions[k][6] = v[6]
	end 
end)

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

function roundedRectangle(x, y, w, h, borderColor, bgColor, postGUI)
	if (x and y and w and h) then
		if (not borderColor) then
			borderColor = tocolor(0, 0, 0, 200);
		end
		if (not bgColor) then
			bgColor = borderColor;
		end
		dxDrawRectangle(x, y, w, h, bgColor, postGUI);
		dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor, postGUI);
		dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor, postGUI);
		dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor, postGUI);
		dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor, postGUI);
	end
end

function getFinalConvert(maxNulls, text)
	local maxNull = maxNulls
	local actualChar = maxNull - tostring(text):len()
	local finalConvert = ""
	for index = 0, actualChar do
		finalConvert = finalConvert .. "0"
	end
	return finalConvert
end

function formatMoney(amount)
  local formatted = amount
  while true do
      formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')
      if (k==0) then
          break
      end
  end
  return formatted
end

addCommandHandler("toghud",function()
	if getElementData(localPlayer,"player:toghud") then 
		setElementData(localPlayer,"player:toghud",false)
		showChat(true)
	else 
		setElementData(localPlayer,"player:toghud",true)
		showChat(false)
	end
end)
function saveWidgets()

	if fileExists("widgets.xml") then

		fileDelete("widgets.xml");

	end

	local xmlNode = xmlCreateFile("widgets.xml","root");
	if not fileExists("widgets.xml") then
	for k,v in pairs(widgetPositions) do 

		local w = xmlCreateChild(xmlNode,k);

		xmlNodeSetValue(xmlCreateChild(w,"x"),v[2]);

		xmlNodeSetValue(xmlCreateChild(w,"y"),v[3]);

		xmlNodeSetValue(xmlCreateChild(w,"w"),v[4]);
		
		xmlNodeSetValue(xmlCreateChild(w,"h"),v[5]);

		xmlNodeSetValue(xmlCreateChild(w,"show"),tostring(v[6]));
	end

	outputDebugString("widgets position saved!",0,100,100,100);

	xmlSaveFile(xmlNode);
end
end

addEventHandler("onClientResourceStop",resourceRoot,saveWidgets)

function savespeedo()


	local xmlNode = xmlCreateFile("widgets.xml","root");
	if not fileExists("widgets.xml") then


		local w = xmlCreateChild(xmlNode,k);
		local x =getElementData(localPlayer,"player:interface:speedox")
		local y =getElementData(localPlayer,"player:interface:speedoy")
		local ww =getElementData(localPlayer,"player:interface:speedow")
		local h =getElementData(localPlayer,"player:interface:speedoh")
		xmlNodeSetValue(xmlCreateChild(speedo,"x"),x);

		xmlNodeSetValue(xmlCreateChild(speedo,"y"),y);

		xmlNodeSetValue(xmlCreateChild(speedo,"w"),ww);
		
		xmlNodeSetValue(xmlCreateChild(speedo,"h"),h);

		xmlNodeSetValue(xmlCreateChild(speedo,"show"),true);
	

	outputDebugString("widgets position saved!",0,100,100,100);

	xmlSaveFile(xmlNode);
end
end
addCommandHandler("load2",savespeedo)

function loadha()


	if not fileExists("widgets.xml") then
		for k ,v in pairs(defaultPositions) do 
			setElementData(localPlayer,"player:interface:"..k.."x",v[2])
			setElementData(localPlayer,"player:interface:"..k.."y",v[3])
			setElementData(localPlayer,"player:interface:"..k.."w",v[4])
			setElementData(localPlayer,"player:interface:"..k.."h",v[5])
			setElementData(localPlayer,"player:interface:"..k.."avalible",true)
		
			widgetPositions[k][1] = v[1]
			widgetPositions[k][2] = v[2]
			widgetPositions[k][3] = v[3]
			widgetPositions[k][4] = v[4]
			widgetPositions[k][5] = v[5]
			widgetPositions[k][6] = v[6]
		end
end
end
addEventHandler("onClientPlayerSpawn",getLocalPlayer(),loadha)


function loadradar()
	local rootNode = xmlLoadFile ( "widgets.xml" )
	local radar = xmlFindChild ( rootNode, "radar", 0 )
	local rx = xmlFindChild ( radar, "x", 0 )
	local ry = xmlFindChild ( radar, "y", 0 )
	local rw = xmlFindChild ( radar, "w", 0 )
	local rh = xmlFindChild ( radar, "h", 0 )
	local show = xmlFindChild ( radar, "show", 0 )
	local rxc = xmlNodeGetValue ( rx )
	local ryc = xmlNodeGetValue ( ry )
	local rwc = xmlNodeGetValue ( rw )
	local rhc = xmlNodeGetValue ( rh )
	local ishow = xmlNodeGetValue ( show )


	setElementData(localPlayer,"player:interface:radarx",rxc)
	setElementData(localPlayer,"player:interface:radary",ryc)
	setElementData(localPlayer,"player:interface:radarw",rwc)
	setElementData(localPlayer,"player:interface:radarh",rhc)
	setElementData(localPlayer,"player:interface:radaravalible",ishow)
end
addEventHandler("onClientResourceStart",resourceRoot,loadradar)
function loadphone()
	local rootNode = xmlLoadFile ( "widgets.xml" )
	local radar = xmlFindChild ( rootNode, "phone", 0 )
	local rx = xmlFindChild ( radar, "x", 0 )
	local ry = xmlFindChild ( radar, "y", 0 )
	local rw = xmlFindChild ( radar, "w", 0 )
	local rh = xmlFindChild ( radar, "h", 0 )
	local show = xmlFindChild ( radar, "show", 0 )
	local rxc = xmlNodeGetValue ( rx )
	local ryc = xmlNodeGetValue ( ry )
	local rwc = xmlNodeGetValue ( rw )
	local rhc = xmlNodeGetValue ( rh )
	local ishow = xmlNodeGetValue ( show )


	setElementData(localPlayer,"player:interface:phonex",rxc)
	setElementData(localPlayer,"player:interface:phoney",ryc)
	setElementData(localPlayer,"player:interface:phonew",rwc)
	setElementData(localPlayer,"player:interface:phoneh",rhc)
	setElementData(localPlayer,"player:interface:phoneavalible",ishow)
end
addEventHandler("onClientResourceStart",resourceRoot,loadphone)

function loadhud()
	local rootNode = xmlLoadFile ( "widgets.xml" )
	local radar = xmlFindChild ( rootNode, "hud", 0 )
	local rx = xmlFindChild ( radar, "x", 0 )
	local ry = xmlFindChild ( radar, "y", 0 )
	local rw = xmlFindChild ( radar, "w", 0 )
	local rh = xmlFindChild ( radar, "h", 0 )
	local show = xmlFindChild ( radar, "show", 0 )
	local rxc = xmlNodeGetValue ( rx )
	local ryc = xmlNodeGetValue ( ry )
	local rwc = xmlNodeGetValue ( rw )
	local rhc = xmlNodeGetValue ( rh )
	local ishow = xmlNodeGetValue ( show )


	setElementData(localPlayer,"player:interface:hudx",rxc)
	setElementData(localPlayer,"player:interface:hudy",ryc)
	setElementData(localPlayer,"player:interface:hudw",rwc)
	setElementData(localPlayer,"player:interface:hudh",rhc)
	setElementData(localPlayer,"player:interface:hudavalible",ishow)
end
addEventHandler("onClientResourceStart",resourceRoot,loadhud)

function loadspeedo()
	local rootNode = xmlLoadFile ( "widgets.xml" )
	local radar = xmlFindChild ( rootNode, "speedo", 0 )
	local rx = xmlFindChild ( radar, "x", 0 )
	local ry = xmlFindChild ( radar, "y", 0 )
	local rw = xmlFindChild ( radar, "w", 0 )
	local rh = xmlFindChild ( radar, "h", 0 )
	local show = xmlFindChild ( radar, "show", 0 )
	local rxc = xmlNodeGetValue ( rx )
	local ryc = xmlNodeGetValue ( ry )
	local rwc = xmlNodeGetValue ( rw )
	local rhc = xmlNodeGetValue ( rh )
	local ishow = xmlNodeGetValue ( show )


	setElementData(localPlayer,"player:interface:speedox",rxc)
	setElementData(localPlayer,"player:interface:speedoy",ryc)
	setElementData(localPlayer,"player:interface:speedow",rwc)
	setElementData(localPlayer,"player:interface:speedoh",rhc)
	setElementData(localPlayer,"player:interface:speedoavalible",ishow)
end
addEventHandler("onClientResourceStart",resourceRoot,loadspeedo)

function loadactionbar()
	local rootNode = xmlLoadFile ( "widgets.xml" )
	local radar = xmlFindChild ( rootNode, "actionbar", 0 )
	local rx = xmlFindChild ( radar, "x", 0 )
	local ry = xmlFindChild ( radar, "y", 0 )
	local rw = xmlFindChild ( radar, "w", 0 )
	local rh = xmlFindChild ( radar, "h", 0 )
	local show = xmlFindChild ( radar, "show", 0 )
	local rxc = xmlNodeGetValue ( rx )
	local ryc = xmlNodeGetValue ( ry )
	local rwc = xmlNodeGetValue ( rw )
	local rhc = xmlNodeGetValue ( rh )
	local ishow = xmlNodeGetValue ( show )


	setElementData(localPlayer,"player:interface:actionbarx",rxc)
	setElementData(localPlayer,"player:interface:actionbary",ryc)
	setElementData(localPlayer,"player:interface:actionbarw",rwc)
	setElementData(localPlayer,"player:interface:actionbarh",rhc)
	setElementData(localPlayer,"player:interface:actionbaravalible",ishow)
end
addEventHandler("onClientResourceStart",resourceRoot,loadactionbar)

function loadmoney()
	local rootNode = xmlLoadFile ( "widgets.xml" )
	local radar = xmlFindChild ( rootNode, "money", 0 )
	local rx = xmlFindChild ( radar, "x", 0 )
	local ry = xmlFindChild ( radar, "y", 0 )
	local rw = xmlFindChild ( radar, "w", 0 )
	local rh = xmlFindChild ( radar, "h", 0 )
	local show = xmlFindChild ( radar, "show", 0 )
	local rxc = xmlNodeGetValue ( rx )
	local ryc = xmlNodeGetValue ( ry )
	local rwc = xmlNodeGetValue ( rw )
	local rhc = xmlNodeGetValue ( rh )
	local ishow = xmlNodeGetValue ( show )


	setElementData(localPlayer,"player:interface:moneyx",rxc)
	setElementData(localPlayer,"player:interface:moneyy",ryc)
	setElementData(localPlayer,"player:interface:moneyw",rwc)
	setElementData(localPlayer,"player:interface:moneyh",rhc)
	setElementData(localPlayer,"player:interface:moneyavalible",ishow)
end
addEventHandler("onClientResourceStart",resourceRoot,loadmoney)

function loadooc()
	local rootNode = xmlLoadFile ( "widgets.xml" )
	local radar = xmlFindChild ( rootNode, "ooc", 0 )
	local rx = xmlFindChild ( radar, "x", 0 )
	local ry = xmlFindChild ( radar, "y", 0 )
	local rw = xmlFindChild ( radar, "w", 0 )
	local rh = xmlFindChild ( radar, "h", 0 )
	local show = xmlFindChild ( radar, "show", 0 )
	local rxc = xmlNodeGetValue ( rx )
	local ryc = xmlNodeGetValue ( ry )
	local rwc = xmlNodeGetValue ( rw )
	local rhc = xmlNodeGetValue ( rh )
	local ishow = xmlNodeGetValue ( show )


	setElementData(localPlayer,"player:interface:oocx",rxc)
	setElementData(localPlayer,"player:interface:oocy",ryc)
	setElementData(localPlayer,"player:interface:oocw",rwc)
	setElementData(localPlayer,"player:interface:ooch",rhc)
	setElementData(localPlayer,"player:interface:oocavalible",ishow)
end
addEventHandler("onClientResourceStart",resourceRoot,loadooc)

function loadtime()
	local rootNode = xmlLoadFile ( "widgets.xml" )
	local radar = xmlFindChild ( rootNode, "time", 0 )
	local rx = xmlFindChild ( radar, "x", 0 )
	local ry = xmlFindChild ( radar, "y", 0 )
	local rw = xmlFindChild ( radar, "w", 0 )
	local rh = xmlFindChild ( radar, "h", 0 )
	local show = xmlFindChild ( radar, "show", 0 )
	local rxc = xmlNodeGetValue ( rx )
	local ryc = xmlNodeGetValue ( ry )
	local rwc = xmlNodeGetValue ( rw )
	local rhc = xmlNodeGetValue ( rh )
	local ishow = xmlNodeGetValue ( show )


	setElementData(localPlayer,"player:interface:timex",rxc)
	setElementData(localPlayer,"player:interface:timey",ryc)
	setElementData(localPlayer,"player:interface:timew",rwc)
	setElementData(localPlayer,"player:interface:timeh",rhc)
	setElementData(localPlayer,"player:interface:timeavalible",ishow)
end
addEventHandler("onClientResourceStart",resourceRoot,loadtime)

function loadphone()
	local rootNode = xmlLoadFile ( "widgets.xml" )
	local radar = xmlFindChild ( rootNode, "phone", 0 )
	local rx = xmlFindChild ( radar, "x", 0 )
	local ry = xmlFindChild ( radar, "y", 0 )
	local rw = xmlFindChild ( radar, "w", 0 )
	local rh = xmlFindChild ( radar, "h", 0 )
	local show = xmlFindChild ( radar, "show", 0 )
	local rxc = xmlNodeGetValue ( rx )
	local ryc = xmlNodeGetValue ( ry )
	local rwc = xmlNodeGetValue ( rw )
	local rhc = xmlNodeGetValue ( rh )
	local ishow = xmlNodeGetValue ( show )


	setElementData(localPlayer,"player:interface:phonex",rxc)
	setElementData(localPlayer,"player:interface:phoney",ryc)
	setElementData(localPlayer,"player:interface:phonew",rwc)
	setElementData(localPlayer,"player:interface:phoneh",rhc)
	setElementData(localPlayer,"player:interface:phoneavalible",ishow)
end
addEventHandler("onClientResourceStart",resourceRoot,loadphone)

function loadfps()
	local rootNode = xmlLoadFile ( "widgets.xml" )
	local radar = xmlFindChild ( rootNode, "fps", 0 )
	local rx = xmlFindChild ( radar, "x", 0 )
	local ry = xmlFindChild ( radar, "y", 0 )
	local rw = xmlFindChild ( radar, "w", 0 )
	local rh = xmlFindChild ( radar, "h", 0 )
	local show = xmlFindChild ( radar, "show", 0 )
	local rxc = xmlNodeGetValue ( rx )
	local ryc = xmlNodeGetValue ( ry )
	local rwc = xmlNodeGetValue ( rw )
	local rhc = xmlNodeGetValue ( rh )
	local ishow = xmlNodeGetValue ( show )


	setElementData(localPlayer,"player:interface:fpsx",rxc)
	setElementData(localPlayer,"player:interface:fpsy",ryc)
	setElementData(localPlayer,"player:interface:fpsw",rwc)
	setElementData(localPlayer,"player:interface:fpsh",rhc)
	setElementData(localPlayer,"player:interface:fpsavalible",ishow)
end
addEventHandler("onClientResourceStart",resourceRoot,loadfps)
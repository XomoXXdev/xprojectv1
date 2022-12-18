fileDelete ("sourceC.lua") 
local usespam = nil;
local colshape = createColSphere(2560.1533203125, -1303.5322265625, 1044.125,2)
setElementInterior(colshape,2)
setElementDimension(colshape,3)
local logo = dxCreateTexture("files/images/downlogo.png")
addEventHandler( 'onClientRender', root, function() 
    x,y,z = 2560.1533203125, -1303.5322265625, 1044.125
    size = 0.5
    dxDrawMaterialLine3D(x+0.3, y+size, z-0.95, x-0.3, y-size, z-0.95, logo, size*2,tocolor(129, 99, 191,255), x, y, z)
end)
addEvent("takethat",true)
function takethat()
	--cache.inventory.active.weapon = -1
end
addEventHandler("takethat",root,takethat)
func.useItem = function(slot,data)
	if cache.inventory.itemMove then
		cache.inventory.itemMove = false
		cache.inventory.movedSlot = -1
	end
	
	if availableItems[data.item].eat then
		if not isTimer(usespam) then
			exports["Pchat"]:takeMessage("me","eszik egy "..getItemName(data.item).." -t.")
			triggerServerEvent("eatingAnimation",localPlayer,localPlayer,"food")
			func.setItemCount(slot,data.count-1)
			setElementData(localPlayer,"player:hunger",getElementData(localPlayer,"player:hunger")+math.random(4,8))
			if getElementData(localPlayer,"player:hunger") >= 100 then
				setElementData(localPlayer,"player:hunger",100)
			end
			usespam = setTimer(function()
				killTimer(usespam)
			end,math.random(1500,3000),1)
		else
			outputChatBox("[Inventory]:#ffffff Várj pár másodpercet.",129, 99, 191,true)
		end
	elseif availableItems[data.item].drink then
		if not isTimer(usespam) then
			exports["Pchat"]:takeMessage("me","iszik egy "..getItemName(data.item).." -t.")
			triggerServerEvent("eatingAnimation",localPlayer,localPlayer,"drink")
			func.setItemCount(slot,data.count-1)
			setElementData(localPlayer,"player:thirsty",getElementData(localPlayer,"player:thirsty")+math.random(2,6))
			if getElementData(localPlayer,"player:thirsty") >= 100 then
				setElementData(localPlayer,"player:thirsty",100)
			end
			usespam = setTimer(function()
				killTimer(usespam)
			end,math.random(1500,3000),1)
		else
			outputChatBox("[Inventory]:#ffffff Várj pár másodpercet.",129, 99, 191,true)
		end
	elseif availableItems[data.item].alcohol then
		if not isTimer(usespam) then
			exports["Pchat"]:takeMessage("me","iszik egy "..getItemName(data.item).." -t.")
			triggerServerEvent("eatingAnimation",localPlayer,localPlayer,"drink")
			func.setItemCount(slot,data.count-1)
			usespam = setTimer(function()
				killTimer(usespam)
			end,math.random(1500,3000),1)
		else
			outputChatBox("[Inventory]:#ffffff Várj pár másodpercet.",129, 99, 191,true)
		end
	elseif availableItems[data.item].skill then
		triggerServerEvent("setPlayerStat",localPlayer,localPlayer,availableItems[data.item].skill)
		exports["Pchat"]:takeMessage("me","kiolvasott egy könyvet.")
		outputChatBox("#8163bf[xProject]:#ffffff Sikeresen megtanultad a következőt: #8163bf"..getItemName(data.item).."#ffffff.",220,20,60,true)
		func.setItemCount(slot,data.count-1)
	elseif data.item == 127 then
		if cache.inventory.active.badge == slot then
			setElementData(localPlayer,"player:badge",nil)
			cache.inventory.active.badge = -1
			exports.Pchat:takeMessage("me","leveszi a jelvényét.")
		elseif cache.inventory.active.badge == -1 then
			setElementData(localPlayer,"player:badge",{tostring(data.value),tostring(data.weaponserial)})
			cache.inventory.active.badge = slot
			exports.Pchat:takeMessage("me","felrakja a jelvényét.")
		end
	elseif data.item == 156 then
		if 	cache.inventory.active.weapon == slot then
			cache.inventory.active.weapon = -1
		--	exports["fishing"]:createStick()
			triggerServerEvent("createandattachStick", localPlayer, localPlayer)
		elseif cache.inventory.active.weapon == -1 then
			exports["fishing"]:createStick()
			
			cache.inventory.active.weapon = slot
		end
	elseif data.item == 133 then
 number = data.value
 if number-1 == 0 then
	func.setItemCount(slot,data.count-1)
			triggerServerEvent("addphonetoworld",localPlayer,localPlayer,number)
 else
	--outputChatBox(number)
	exports.Pphone:setPhoneVisible(number)
 end
	elseif data.item == 125 then
		if cache.inventory.active.identity == slot then
			cache.inventory.active.identity = -1;
			cache.ticketData = {};
		elseif cache.inventory.active.identity == -1 then
			cache.inventory.active.identity = slot;
			cache.ticketData = fromJSON(data.value);
		end
	elseif data.item == 131 then
		triggerEvent("licenses:showDocument", localPlayer, "Identity", fromJSON(data.value))
		setElementData(localPlayer,"szemelyiactive",true)
	elseif data.item == 130 then
		triggerEvent("licenses:showDocument", localPlayer, "Driverlicense", fromJSON(data.value))
		setElementData(localPlayer,"driveractive",true)
	elseif data.item == 137 then
				local vehicle = getPedOccupiedVehicle(localPlayer)
				if isElement(vehicle) then
					if taxiPos[getElementModel(vehicle)] then
						local seat = getPedOccupiedVehicleSeat(localPlayer)
						if seat == 0 or seat == 1 then
							if activeSiren == itemSlot then
								activeSiren = -1
								--outputMeMessage("levett a járműről egy taxilámpát.")
								triggerServerEvent("taxiLampToServer",localPlayer,localPlayer,vehicle,"destroy")
							elseif activeSiren == -1 then
								if not getElementData(vehicle,"isVehicleInObject") then
									activeSiren = itemSlot
									--outputMeMessage("felrakott a járműre egy taxilámpát.")
									triggerServerEvent("taxiLampToServer",localPlayer,localPlayer,vehicle,"create")
								end
							end
						end
					end
				end
			elseif data.item == 143 then
if isElementWithinColShape(localPlayer,colshape) then
	minigameStarted = false
	inMinigame = false
	startMinigame()
	toggleAllControls(false)
end
	elseif data.item == 126 then
				local vehicle = getPedOccupiedVehicle(localPlayer)
				if isElement(vehicle) then
					if sirenPos[getElementModel(vehicle)] then
						local seat = getPedOccupiedVehicleSeat(localPlayer)
						if seat == 0 or seat == 1 then
							if activeSiren == itemSlot then
								activeSiren = -1
								--outputMeMessage("levett a járműről egy szirénát.")
								triggerServerEvent("sirenToServer",localPlayer,localPlayer,vehicle,"destroy")
							elseif activeSiren == -1 then
								activeSiren = itemSlot
								--outputMeMessage("felrakott a járműre egy szirénát.")
								triggerServerEvent("sirenToServer",localPlayer,localPlayer,vehicle,"create")
							end
						end
					end
				end
	elseif data.item == 157 then
		if isTimer(drugTimer) then outputChatBox("#8163bf[xProject]: #ffffffCsak 3 percenként használhatsz drogot.", 220,20,60, true) return end
		giveArmor(localPlayer, math.random(40, 50))
	    func.setItemCount(slot,data.count-1)       
	    exports["Pchat"]:takeMessage("me","felszív egy csík kokaint.")		
		setHeroinScreen(true)
		drugTimer = setTimer(function() end, 1000*60*3, 1)
	elseif data.item == 158 then
		if isTimer(drugTimer) then outputChatBox("#8163bf[xProject]: #ffffffCsak 3 percenként használhatsz drogot.", 220,20,60, true) return end
		giveArmor(localPlayer, math.random(30, 50))
	    func.setItemCount(slot,data.count-1)       
		setHeroinScreen(true)
	    exports["Pchat"]:takeMessage("me","belő egy heroinos fecskendőt magába.")		
		drugTimer = setTimer(function() end, 1000*60*3, 1)
	elseif data.item == 159 then
		if isTimer(drugTimer) then outputChatBox("#8163bf[xProject]: #ffffffCsak 3 percenként használhatsz drogot.", 220,20,60, true) return end
		giveArmor(localPlayer, math.random(10, 22))
	    func.setItemCount(slot,data.count-1)       
	    exports["Pchat"]:takeMessage("me","elszív egy füves cigarettát.")
		setMarijuanaScreen(true)		
		drugTimer = setTimer(function() end, 1000*60*3, 1)
	elseif data.item == 160 then
		if isTimer(drugTimer) then outputChatBox("#8163bf[xProject]: #ffffffCsak 3 percenként használhatsz drogot.", 220,20,60, true) return end
		giveArmor(localPlayer, math.random(10, 40))
	    func.setItemCount(slot,data.count-1)       
	    exports["Pchat"]:takeMessage("me","felszív egy kis speedet.")	
		setSpeedScreen(true)		
		drugTimer = setTimer(function() end, 1000*60*3, 1)
	elseif data.item == 161 then
		if isTimer(drugTimer) then outputChatBox("#8163bf[xProject]: #ffffffCsak 3 percenként használhatsz drogot.", 220,20,60, true) return end
		giveArmor(localPlayer, math.random(30, 35))
	    func.setItemCount(slot,data.count-1)       
	    exports["Pchat"]:takeMessage("me","megnyal egy bélyeget.")		
		setLsdScreen(true)
		drugTimer = setTimer(function() end, 1000*60*3, 1)
	elseif data.item == 162 then
		if isTimer(drugTimer) then outputChatBox("#8163bf[xProject]: #ffffffCsak 3 percenként használhatsz drogot.", 220,20,60, true) return end
		giveArmor(localPlayer, math.random(50, 70))
	    func.setItemCount(slot,data.count-1)       
	    exports["Pchat"]:takeMessage("me","felszív egy kis morfint.")		
		setSpeedScreen(true)
		drugTimer = setTimer(function() end, 1000*60*3, 1)
	elseif data.item == 163 then
		if isTimer(drugTimer) then outputChatBox("#8163bf[xProject]: #ffffffCsak 3 percenként használhatsz drogot.", 220,20,60, true) return end
		giveArmor(localPlayer, math.random(50, 70))
	    func.setItemCount(slot,data.count-1)       
	    exports["Pchat"]:takeMessage("me","felszív egy kis amfetamint.")	
		setSpeedScreen(true)		
		drugTimer = setTimer(function() end, 1000*60*3, 1)
	elseif weaponCache[data.item] then
		--outputChatBox("nem használhatod a fegyvert mert a kurva anyád")
		if data.state <= 0 then
			outputChatBox("[xProject]:#ffffff A kiválasztott fegyver használhatatlan.",220,20,60,true)		
		else
			if cache.inventory.active.weapon == slot then
				cache.inventory.active.weapon = -1
				cache.inventory.active.ammo = -1
				cache.inventory.active.dbid = -1
				local value = tonumber(data.value)
			    exports["Pchat"]:takeMessage("me","elrakott egy fegyvert. ("..getItemName(data.item,data.value)..")")
				triggerServerEvent("takeWeaponServer",localPlayer,localPlayer,data.item,data.id,value)
			elseif cache.inventory.active.weapon == -1 then
				local currentslot = false
				if weaponCache[data.item].ammo == data.item then
					currentslot = slot
				end
				local state,ammoData = hasItem(weaponCache[data.item].ammo,false,currentslot)
				if state then
					cache.inventory.active.weapon = slot
					cache.inventory.active.dbid = data.id
			        exports["Pchat"]:takeMessage("me","elővett egy fegyvert. ("..getItemName(data.item,data.value)..")")
					if not weaponProgress[cache.inventory.active.weapon] then weaponProgress[cache.inventory.active.weapon] = 0 end
					if weaponProgress[cache.inventory.active.weapon] > 15 and toggleControlSlot[cache.inventory.active.weapon] then
						toggleControl("fire",false)
						toggleControl("action",false)
					end
					cache.inventory.active.ammo = ammoData.slot
					triggerServerEvent("giveWeaponServer",localPlayer,localPlayer,weaponCache[data.item].weapon,ammoData.count,data.item,data.id,data.value)
				else
					cache.inventory.active.weapon = slot
					cache.inventory.active.dbid = data.id
					if not weaponProgress[cache.inventory.active.weapon] then weaponProgress[cache.inventory.active.weapon] = 0 end
					if weaponCache[data.item].hotTable then
						weaponProgress[cache.inventory.active.weapon] = 0
						toggleControl("fire",false)
						toggleControl("action",false)
					end
					local defaultammo = 1;
					if data.item == 42 or data.item == 43 or data.item == 44 then
						defaultammo = 9999;
					end
			        exports["Pchat"]:takeMessage("me","elővett egy fegyvert. ("..getItemName(data.item,data.value)..")")
					local value = tonumber(data.value)
					triggerServerEvent("giveWeaponServer",localPlayer,localPlayer,weaponCache[data.item].weapon,defaultammo,data.item,data.id,data.value)
				end
			end
		end
	end
end

func.renderIdentity = function()
	if cache.inventory.active.identity > 0 and cache.ticketData then
		if playerCache[localPlayer]["licens"][cache.inventory.active.identity].item == 125 then
			dxDrawImage(sx*0.396,sy*0.233,sx*0.208,sy*0.534,"files/images/ticket.png")
			dxDrawText(cache.ticketData.name,sx*0.405,sy*0.341,0,0,tocolor(116,116,116),0.00022*sx,cache.font.sfcDisplaybold)
			dxDrawText(cache.ticketData.date,sx*0.489,sy*0.341,0,0,tocolor(116,116,116),0.00022*sx,cache.font.sfcDisplaybold)
			dxDrawText(cache.ticketData.location,sx*0.539,sy*0.341,0,0,tocolor(116,116,116),0.00022*sx,cache.font.sfcDisplaybold)
			dxDrawText(cache.ticketData.offender,sx*0.405,sy*0.3695,0,0,tocolor(116,116,116),0.00022*sx,cache.font.sfcDisplaybold)
			dxDrawText(cache.ticketData.vehiclename,sx*0.406,sy*0.427,0,0,tocolor(116,116,116),0.00022*sx,cache.font.sfcDisplaybold)
			dxDrawText(cache.ticketData.plate,sx*0.49,sy*0.427,0,0,tocolor(116,116,116),0.00022*sx,cache.font.sfcDisplaybold)
			dxDrawText(cache.ticketData.color,sx*0.539,sy*0.427,0,0,tocolor(116,116,116),0.00022*sx,cache.font.sfcDisplaybold)
			dxDrawText(cache.ticketData.reason,sx*0.405,sy*0.487,0,0,tocolor(116,116,116),0.00022*sx,cache.font.sfcDisplaybold)
			dxDrawText(formatMoney(cache.ticketData.amount).. " $",sx*0.591,sy*0.5717,sx*0.591,sy*0.5717,tocolor(116,116,116),0.000235*sx,cache.font.sfcDisplaybold2,"right")

			dxDrawText(cache.ticketData.offender,sx*0.45,sy*0.723,sx*0.45,sy*0.723,tocolor(111,150,221),0.00045*sx,cache.font.freeAdelaide,"center","center")
			dxDrawText(cache.ticketData.name,sx*0.55,sy*0.723,sx*0.55,sy*0.723,tocolor(111,150,221),0.00045*sx,cache.font.freeAdelaide,"center","center")
		end
	end
end
addEventHandler("onClientRender",getRootElement(),func.renderIdentity)

local sx,sy = guiGetScreenSize()
local cache = {}
local randomPos = {
    {sx*0.46,6000,116,78},{sx*0.455,7000,107,67},{sx*0.48,6500,155,116},{sx*0.50,8000,194,153},{sx*0.53,8500,251,212},
  }

local spaceState = false
local randomNum = math.random(1,#randomPos)
local minigameStarted = false
start2 = 0
local startP = 0 
local stopP = 308
start2 = 0
local inMinigame = false
cache.roboto2 = dxCreateFont("files/fonts/roboto.ttf",37)  
function startMinigame()
    inMinigame = true 
    addEventHandler("onClientRender",root,drawMinigame)
end 
addEvent("startMinigame",true)
addEventHandler("startMinigame",root,startMinigame)
  
bindKey("space","down",function() if inMinigame then  spaceState = true if math.floor(tostring(dxWeight)) < 290 then  start2 = start2 + 300 end end end)
bindKey("space","up",function() if inMinigame then spaceState = false end end)
bindKey("enter","down",function()
    if not minigameStarted and inMinigame then
        start2 = getTickCount()
        minigameStarted = true 
        setTimer(function() 
         if math.floor(tostring(dxWeight)) < randomPos[randomNum][3] and math.floor(tostring(dxWeight)) > randomPos[randomNum][4] then 
            removeEventHandler("onClientRender",root,drawMinigame)
            exports["inventory"]:takeItem(143)
            inMinigame = false
            minigameStarted = false
			local money = getElementData(localPlayer,"player:money")
			local random = math.random(5000,10000)
			outputChatBox("#8163bf[xProject]:#ffffff Sikeresen felfeszítetted a pénzkazettát és találtál benne: "..random.."$-t.",220,20,60,true)  
            setElementData(localPlayer,"player:money",money+random)
            toggleAllControls(true)
         else 
            minigameStarted = false
            inMinigame = false
			exports["inventory"]:takeItem(143)
			
			outputChatBox("#8163bf[xProject]:#ffffff Nem sikerült a minigame ezért nem kaptál semmit.",220,20,60,true)  
          removeEventHandler("onClientRender",root,drawMinigame)
            toggleAllControls(true)
          end
        end,randomPos[randomNum][2],1)
    end
end)

function giveArmor(thePlayer, give)
	if give then
		if getPedArmor(thePlayer) + give <= 100 then
			triggerServerEvent("giveArmor", thePlayer, getPedArmor(thePlayer) + give)
			return true
		elseif getPedArmor(thePlayer) + give > 100 then
			triggerServerEvent("giveArmor", thePlayer, 100)
			return true
		end 
	end 
end

function drawMinigame()

    local now = getTickCount()
    local endTime = start2 + 2000
    local elapsedTime = now - start2
    local duration = endTime - start2
    local progress = elapsedTime / duration/2
    dxWeight = interpolateBetween(308,0,0,0,0,0, progress, "Linear")
  
  
    dxDrawRectangle(sx*0.42,sy*0.25,308,sy*0.014,tocolor(0,0,0,150))
    dxDrawRectangle(sx*0.42,sy*0.25,dxWeight,sy*0.014,tocolor(255,255,255,200))
    dxDrawRectangle(randomPos[randomNum][1],sy*0.25,40,sy*0.014,tocolor(120,120,120,200))
    dxDrawText("Felfeszíted a kazettát...",sx*0.455 - 1,sy*0.21 + 1,_,_,tocolor(250,250,250,255),0.3,cache.roboto2)

    dxDrawText("Tartsd a csúszkát a megadott tartományon belűl.",sx*0.415,sy*0.27,_,_,tocolor(255,255,255,255),0.3,cache.roboto2)
    dxDrawText("A kezdéshez az #000000enter-t #000000, a mozgatáshoz használd a #000000spacet#000000.",sx*0.397 - 1,sy*0.285 + 1,_,_,tocolor(0,0,0,255),0.3,cache.roboto2,"left","top",false,false,false,true)
    dxDrawText("A kezdéshez az #e34058enter-t #ffffff, a mozgatáshoz használd a #e34058spacet#ffffff.",sx*0.397,sy*0.285,_,_,tocolor(255,255,255,255),0.3,cache.roboto2,"left","top",false,false,false,true)
  
    
end 

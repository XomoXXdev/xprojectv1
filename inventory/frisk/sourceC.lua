--local func = {}
local showFrisk = false
local friskCategory = "bag"
local friskMenu = 1
local friskItems = {}
local targetElement = nil
local screen = {guiGetScreenSize()}
width = column*(itemSize+margin)+margin;
height = row*(itemSize+margin)+margin;
local posW, posH = itemSize*column + margin*(column+1) , itemSize * row + (1+row)*margin
local pos = {screen[1]/2 -posW/2,screen[2]/2 - posH/2}
local friskTable = {
	{"backpack","Tárgyak","bag"},
	{"key","Kulcsok","key"},
	{"licens","Iratok","licens"},
}

local friskMove = false
local friskDefX,friskDefY = 0,0

func.setFriskItems = function(items,data)
    if items then
        friskItems = items
	else
        friskItems = {}	
	end
end
addEvent("setFriskItems",true)
addEventHandler("setFriskItems",getRootElement(),func.setFriskItems)

function openFrisk(targ)
	showFrisk = true
	triggerServerEvent("requestFriskItems",localPlayer,targ)
	addEventHandler("onClientRender",getRootElement(),func["friskRender"])
	addEventHandler("onClientClick",getRootElement(),func["friskClick"])
end

function closeFrisk()
	showFrisk = false
	removeEventHandler("onClientRender",getRootElement(),func["friskRender"])
	removeEventHandler("onClientClick",getRootElement(),func["friskClick"])
end

local isAdminFrisk = false

func["friskAdmin"] = function(cmd, id)

		if not (id) then
		      outputChatBox("#8163bf[xProject]#ffffff /"..cmd.." [ID/Név]",255,255,255,true)
			--outputChatBox(Pcore:getServerPrefix("server", "Használat", 3).."#ffffff/"..cmd.." [ID]", 255, 255, 255, true)
		else
			local targetPlayer, targetPlayerName = exports["Pcore"]:findPlayerByPartialNick(getLocalPlayer(), id)
			if targetPlayer then
				if getElementData(targetPlayer, "player:loggedIn") then
					if localPlayer ~= targetPlayer then
					  playerX,playerY,playerZ = getElementPosition(localPlayer)
					  targetX,targetY,targetZ = getElementPosition(targetPlayer)
					  if getDistanceBetweenPoints3D(playerX,playerY,playerZ,targetX,targetY,targetZ) <= 3 then
						if not showFrisk then
							openFrisk(targetPlayer)
							isAdminFrisk = true
							targetElement = targetPlayer
							exports.Pchat:takeMessage("me","megmotozza "..getElementData(targetPlayer,"player:charname"):gsub("_"," ").." -t.")
							--exports.Pchat:takeMessage("me","megmotozza "..getPlayerName(targetPlayer):gsub("_"," ").." -t.")
						else
							closeFrisk()
						end
					  else
					  outputChatBox("#8163bf[xProject]#ffffff A kiválasztott játékos túl messze van tőled.",255,255,255,true)
					  end
					else
					outputChatBox("#8163bf[xProject]#ffffff Magadat nem tudod megmotozni.",255,255,255,true)
					end
				else
					outputChatBox("#8163bf[xProject]#ffffff A kiválasztott játékos jelenleg nincs bejelentkezve.",255,255,255,true)
				end
			end
		end
	
end
addCommandHandler("frisk",func["friskAdmin"])
addCommandHandler("motozas",func["friskAdmin"])

func["adminmotozas"] = function(cmd, id)

		if not (id) then
		      outputChatBox("#8163bf[xProject]#ffffff /"..cmd.." [ID/Név]",255,255,255,true)
			--outputChatBox(Pcore:getServerPrefix("server", "Használat", 3).."#ffffff/"..cmd.." [ID]", 255, 255, 255, true)
		else
			local targetPlayer, targetPlayerName = exports["Pcore"]:findPlayerByPartialNick(getLocalPlayer(), id)
			if targetPlayer then
				if getElementData(targetPlayer, "player:loggedIn") then
					--if localPlayer ~= targetPlayer then
					  playerX,playerY,playerZ = getElementPosition(localPlayer)
					  targetX,targetY,targetZ = getElementPosition(targetPlayer)
						if not showFrisk then
							openFrisk(targetPlayer)
							isadminmotozas = true
							targetElement = targetPlayer
							--if getElementData(localPlayer,"player:admin") >= getElementData(targetPlayer,"player:admin") then
							--    triggerServerEvent("outputChatBoxToPlayer",localPlayer,targetPlayer,Fasz)
							--end
							exports["Padmin"]:outputAdminMessage(""..getElementData(localPlayer,"player:adminname").." #ffffffellenőrizte #8163bf" ..getElementData(targetPlayer,"player:charname"):gsub("_", " ").. " #ffffffitemeit.")
							--triggerServerEvent("outPutAdminMessage1",localPlayer,localPlayer,"kurvaanyad")
							--outputAdminMessage(""..getElementData(localPlayer,"player:adminname").." #ffffffellenőrizte #8163bf" ..getElementData(targetPlayer,"player:charname"):gsub("_", " ").. " #ffffffitemeit.")
						else
							closeFrisk()
						end
					--end
				end
			end
		end
end
addCommandHandler("amotozas",func["adminmotozas"])

func["friskRender"] = function()
	hoverFrisk = 0


	
	if showFrisk then
		if isElement(targetElement) then
			if friskMove then
				if isCursorShowing() then
					local x, y = getCursorFuck()
					pos[1],pos[2] = x - friskDefX,y - friskDefY
				end
			end
			
            --dxDrawRectangle(pos[1], pos[2]-60,width,height+60,tocolor(25,25,25,255))
			dxDrawRectangle(pos[1], pos[2] , posW, posH + 60-50,tocolor(25,25,25,255)) -- háttér
			dxDrawRectangle(pos[1] -70, pos[2] , posW - 367, posH + 60-50,tocolor(23,23,23,255)) --bal bg gecis fasz
			
			dxDrawImage(pos[1]-60,pos[2]+ 5 +(0*50),50,50,"files/images/logo.png",0,0,0,tocolor(129, 99, 191));
			--dxDrawImage(pos[1]+14,pos[2]-40,40,42,pages[cache.inventory.currentpage].img,0,0,0,tocolor(129, 99, 191));
			--dxDrawText(pages[cache.inventory.currentpage].name,pos[1]+210-1,pos[2]-35+1,pos[1]+210-1,pos[2]-36+1,tocolor(0,0,0,255),0.6,cache.font.sansheavy,"center","center");
            --dxDrawText(pages[cache.inventory.currentpage].name,pos[1]+210,pos[2]-35,pos[1]+210,pos[2]-36,tocolor(255,255,255,255),0.6,cache.font.sansheavy,"center","center");
			
			

		--dxDrawRectangle(pos[1]+94,pos[2]-24,224,16,tocolor(34,34,34,255))
		--if cache.inventory.page == "bag" or cache.inventory.page == "craft" then
		--	dxDrawImage(pos[1]+76,pos[2]-26,16,19,pages[cache.inventory.currentpage].miniImg,0,0,0);
		--end

		--local itemWeight = getAllItemWeight()
		--if itemWeight > 0 then
		--	local actualweight = math.ceil(itemWeight)/getTypeElement(cache.inventory.element)[3]*224;
		--	if actualweight > 224 then
		--		actualweight = 224;
		--	end
		--	dxDrawRectangle(pos[1]+94+2,pos[2]-24+2,actualweight,16-4,tocolor(129, 99, 191,255))
		--end
		--dxDrawText(math.ceil(itemWeight).."/"..getTypeElement(cache.inventory.element)[3].." kg",pos[1]+213,pos[2]-16,pos[1]+213,pos[2]-16,tocolor(55,55,55,255),0.48,cache.font.sansheavy,"center","center");

		--	dxDrawText("Készpénz: "..color..convertNumber(getElementData(targetElement,"player:money")).."#ffffff $", pos[1], pos[2], pos[1]+posW-5, pos[2]+235, tocolor(255,255,255,255), 1, font:getFont("condensed", 13), "right", "bottom", true, true, true, true)
			
			for k,v in ipairs(friskTable) do
				if v[1] == "licens" then
					v[1] = "pocket"
				end
				if isInSlot(pos[1]-50,pos[2]+(k*55), 50, 50) then
					dxDrawImage (pos[1]-60,pos[2]+(k*55), 50, 50, "files/images/normalicons/"..v[1]..".png", 0, 0, 0, tocolor(129, 99, 191,255))
					hoverFrisk = k
				else
					if friskMenu == k then 
						dxDrawImage (pos[1]-60,pos[2]+(k*55), 50, 50, "files/images/normalicons/"..v[1]..".png", 0, 0, 0, tocolor(129, 99, 191,255))
					else
						dxDrawImage (pos[1]-60,pos[2]+(k*55), 50, 50,"files/images/normalicons/"..v[1]..".png", 0, 0, 0, tocolor(35,35,35,255))
					end
				end
			end
			
			local drawRow = 0
			local drawColumn = 0
			if friskCategory == "bag" or friskCategory == "licens" or friskCategory == "key" then
				if friskItems[friskCategory] then
					for i = 1, row * column do
						if isInSlot(pos[1] + drawColumn * (itemSize + margin) + margin * 1, pos[2] + drawRow * (itemSize + margin) + margin * 1.6, itemSize, itemSize) then
							inSlotBox = true
							dxDrawRectangle(pos[1] + drawColumn * (itemSize + margin) + margin * 1, pos[2] + drawRow * (itemSize + margin) + margin * 1.6, itemSize, itemSize,tocolor(129, 99, 191,255))  --kocka ha ráhúzod
							--
							hoverSlot = i
							if (friskItems[friskCategory][i]) then
								if selectedSound ~= i then
									playSound("files/sounds/hover.mp3")
								end
								selectedSound = i
								hoverItem = (friskItems[friskCategory][i])
								local itemName = ""
								
								--if #friskItems[friskCategory][i].name <= 0 then 
									itemName = getItemName(friskItems[friskCategory][i].item,tonumber(friskItems[friskCategory][i].value))
								--else
								--	itemName = friskItems[friskCategory][i].name
								--end

								if getElementData(localPlayer,"user:aduty") and getElementData(localPlayer, "user:admin") >= 5 then
									func.toolTip(itemName..color, " [sql id: "..friskItems[friskCategory][i].id.." itemid: "..friskItems[friskCategory][i].item.."]","#ffffff"..tostring(friskItems[friskCategory][i].value));
								else
									func.toolTip(unpack(getItemTooltip(friskItems[friskCategory][i].id,friskItems[friskCategory][i].item,friskItems[friskCategory][i].value,friskItems[friskCategory][i].count,friskItems[friskCategory][i].state,friskItems[friskCategory][i].weaponserial)));
								end
							else
								hoverItem = nil
							end
						else
							dxDrawRectangle(pos[1] + drawColumn * (itemSize + margin) + margin * 1, pos[2] + drawRow * (itemSize + margin) + margin * 1.6, itemSize, itemSize,tocolor(29,29,29,255)) --kocka gecis
							inSlotBox = false
						end
						local itemData = friskItems[friskCategory][i]
						if (itemData) then
							local itemDbid = itemData["dbid"]
							local itemID = itemData["id"]
							local itemCount = itemData["count"]
							local itemHeath = itemData["health"]
							dxDrawImage(pos[1] + drawColumn * (itemSize + margin) + margin * 1, pos[2] + drawRow * (itemSize + margin) + margin * 1.6, itemSize, itemSize, getItemImage(itemData.item), 0, 0, 0, tocolor(255, 255, 255, 255))
							dxDrawText(itemData.count, pos[1] + drawColumn * (itemSize + margin) + margin * 1, pos[2] + drawRow * (itemSize + margin) + margin * 1.6, pos[1] + drawColumn * (itemSize + margin) + margin * 1 + itemSize - 2, pos[2] + drawRow * (itemSize + margin) + margin * 1.6+itemSize, tocolor(255, 255, 255, 255), 1, "default-bold", "right", "bottom")
						end
						drawColumn = drawColumn + 1
						if (drawColumn == column) then
							drawColumn = 0
							drawRow = drawRow + 1
						end
					end
				end
			end
		else
			showFrisk = false
		end
	end
end

func["friskClick"] = function(button,state)
	if showFrisk then
		if button == "left" and state == "down" then
			if isInSlot(pos[1]-50,pos[2]+(hoverFrisk*55), 50, 50) then
				friskMenu = hoverFrisk
				friskCategory = friskTable[hoverFrisk][3]
			end	
		end
	end
end

func.deleteItemKey = function()
	if getElementData(localPlayer,"player:admin") >= 7 then
		if (showFrisk) then
			triggerServerEvent("deleteItemfrisk",localPlayer,targetElement,friskItems[friskCategory][hoverSlot],true,localPlayer)
			closeFrisk()
			openFrisk(targetElement)
			isAdminFrisk = true
		end
	end
end
bindKey("delete","down",func.deleteItemKey)
function isInSlot(xS,yS,wS,hS)
	if(isCursorShowing()) then
		XY = {guiGetScreenSize()}
		local cursorX, cursorY = getCursorPosition()
		cursorX, cursorY = cursorX*XY[1], cursorY*XY[2]
		if(cursorX >= xS and cursorX <= xS+wS and cursorY >= yS and cursorY <= yS+hS) then
			return true
		else
			return false
		end
	end
end

function convertNumber(number)  
	local formatted = number  
	while true do      
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')    
		if ( k==0 ) then      
			break   
		end  
	end  
	return formatted
end
function szar()
	if showFrisk then
		closeFrisk()
	end
end
bindKey("backspace","down",szar)
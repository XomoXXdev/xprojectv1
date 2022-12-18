sx,sy = guiGetScreenSize();
func = {};
func.actionbar = {};
func.eating = {};
func.weapon = {};
func.trash = {};
func.frisk = {};
func.safe = {};
func.player = {};
func.drug = {};
func.identity = {};
func.identityPed = {};
func.craft = {};
screen = {guiGetScreenSize()};
width = column*(itemSize+margin)+margin;
height = row*(itemSize+margin)+margin;
pos = {screen[1]/2,screen[2]/2};
screenSource = dxCreateScreenSource(screen[1], screen[2])
cache = {
	ticketData = {};
	font = {
        sansheavy = dxCreateFont("files/fonts/sansheavy.otf",20);
        sfpro = dxCreateFont("files/fonts/sfpro.ttf",20);
		roboto = dxCreateFont("files/fonts/sfpro.ttf",20);
		awesome = dxCreateFont("files/fonts/icons.ttf",12);
		freeAdelaide = dxCreateFont("files/fonts/freeAdelaide.ttf",20);
    	sfcDisplaybold = dxCreateFont("files/fonts/sfcDisplaybold.ttf",20);
    	sfcDisplaybold2 = dxCreateFont("files/fonts/sfcDisplaybold.ttf",20,true);
    };
	player = {
		show = true,
	},
	drunk = {},
	drug = {};
	identityPed = {
		box = {300,180};
		pos = {screen[1]/2 -256/2,screen[2]/2 -147/2};
	};
	identity = {
		item = 0;
		["personal"] = {
			pos = {screen[1]/2 - 450/2,screen[2]/2 -257/2};
			box = {450,257};
		};
		["passport"] = {
			pos = {screen[1]/2 - 354/2,screen[2]/2 -370/2};
			box = {354,370};
		};
		["adr"] = {
			pos = {screen[1]/2 - 354/2,screen[2]/2 -488/2};
			box = {354,488};
		};
		["driving1"] = {
			pos = {screen[1]/2 - 450/2,screen[2]/2 -257/2};
			box = {450,257};
		};
		["driving2"] = {
			pos = {screen[1]/2 - 450/2,screen[2]/2 -257/2};
			box = {450,257};
		};
		["fishing"] = {
			pos = {screen[1]/2 - 354/2,screen[2]/2 -488/2};
			box = {354,488};
		};
		["hunting"] = {
			pos = {screen[1]/2 - 450/2,screen[2]/2 -257/2};
			box = {450,257};
		};
		["weapon"] = {
			pos = {screen[1]/2 - 450/2,screen[2]/2 -257/2};
			box = {450,257};
		};
		["traffic"] = {
			pos = {screen[1]/2 - 525/2,screen[2]/2 -300/2};
			box = {525,300};
		};
	};
	frisk = {
		show = false,
		data = {},
		items = {},
		page = "bag",
		categories = {
			{"bag","Tárgyak"},
			{"key","Kulcsok"},
			{"licens","Iratok"},
		},
	},
	inventory = {
		dummyTimer = {},
		show = false,
		textures = {
			item = {},
		},
		usedSlots = 0,
		page = "bag",
		currentpage = 1,
		defY = 0,
		defX = 0,
		moving = false,
		element = nil,
		cursorInSlot = false,
		hoverSlot = -1,
		hoverItem = nil,
		movedSlot = -1,
		movedItem = nil,
		moveX = 0,
		moveY = 0,
		itemMove = false,
		gui = nil,
		editing = false,
		alpha = 255,
		itemlist = {
			show = false,
			box = {300,386},
			pos = {screen[1]/2 - 300/2,screen[2]/2 - 386/2},
			gui = nil,
			wheel = 0,
			text = "",
			edit = false,
		};
		active = {
			weapon = -1,
			ammo = -1,
			dbid = -1,
			card = -1,
			identity = -1,
			badge = -1,
		};
		slot = {
			img = nil,
		};
		sound = {
			selected = 0,
		};
		eyed = {
			tooltip = {},
			data = {},
			tick = {},
			anim = {},
			pos = {},
			alpha = {},
			alpha2 = {},
		};
	};
	actionbar = {
		show = false;
		defX = 0;
		defY = 0;
		moveX = 0;
		moveY = 0;
		slot = {};
		hover = {
			slot = -1,
			movedimg = -1,
		};
		itemMove = false;
		hoverInventoryItem = nil;
		hoverItem = nil;
		movedInventoryItem = nil;
		movedItem = nil;
		movedSlot = -1;
		cursorInSlot = false;
	};
	eating = {
		pos = {screen[1]/2 -itemSize/2,screen[2] -190},
	};
	weapon = {
		posX = screen[1]/2,
		posY = screen[2]/2,
		img = {};
	};
	trash = {
		
	};
	safe = {
		
	};
	craft = {
		defY = 0,
		defX = 0,
		moving = false,
		moveX = 0;
		moveY = 0;
		show = false;
		hoverSlot = -1;
		cursorInSlot = false;
		hoverItem = nil;
		movedItem = nil;
		movedSlot = -1;
		itemMove = false;
		cursorInCraftbox = false;
		craftedItem = -1;
		progress = 208;
	};
};
inventoryCache = {};
playerCache = {};
actionBarCache = {};
weaponProgress = {};
toggleControlSlot = {};
craftItems = {};

setTimer(function()
	if cache.craft.progress ~= 208 then
		cache.craft.progress = cache.craft.progress+1;
		if cache.craft.progress == 208 then
			outputChatBox("[xProject]:#ffffff Sikeresen összeraktál egy tárgyat, vedd ki a panelből. #8163bf(bal klikk)",129, 99, 191,true)
		end
	end
end,50,0)

local players = {};

--func.mouseShow = function()
  --  showCursor(not isCursorShowing())
--end
--bindKey("m","down",func.mouseShow)

func.start = function()
	if getElementData(localPlayer,"player:badge") then
		setElementData(localPlayer,"player:badge",nil);
	end
	cache.inventory.element = localPlayer
	inventoryCache[localPlayer] = {};
	
	guiSetInputMode("no_binds_when_editing")
	setElementData(localPlayer,"tazerState",false)
	setCameraShakeLevel(0)
	for i, v in pairs(availableItems) do
        cache.inventory.textures.item[i] = dxCreateTexture(getItemImage(i), "argb");
	end
	
	if getElementData(localPlayer,"player:loggedIn") then
		setPlayerHudComponentVisible("crosshair",true)
		--triggerServerEvent("getItems",localPlayer,localPlayer,2)
	end
	engineImportTXD(engineLoadTXD("files/taxi.txd",1313),1313)
	engineReplaceModel(engineLoadDFF("files/taxi.dff",1313),1313)
	engineImportTXD(engineLoadTXD("files/siren.txd",1253),1253)
	engineReplaceModel(engineLoadDFF("files/siren.dff",1253),1253)
	engineReplaceCOL(engineLoadCOL ("files/siren.col" ), 1253)
end
addEventHandler("onClientResourceStart",resourceRoot,func.start)

func.dataChange = function(dataName)
	if dataName == "player:loggedIn" then
		if getElementData(localPlayer,dataName) then
			setPlayerHudComponentVisible("crosshair",true)
			triggerServerEvent("getItems",localPlayer,localPlayer,2)
			triggerServerEvent("checkBuggedItems",localPlayer,localPlayer)
		end
	end
end
addEventHandler("onClientElementDataChange",getLocalPlayer(),func.dataChange)

func.setItems = function(element,value,table)
	cache.inventory.element = element
	if value == 2 then
		playerCache[cache.inventory.element] = table
	end
	inventoryCache[cache.inventory.element] = table
end
addEvent("setItems",true)
addEventHandler("setItems",getRootElement(),func.setItems)

func.showInventory = function()
	if getElementData(localPlayer,"player:loggedIn") then
		cache.inventory.show = not cache.inventory.show
		if cache.inventory.show then
			addEventHandler("onClientRender",getRootElement(),func.render)
			cache.inventory.gui = guiCreateEdit(-1000,-1000,0,0,"",false)
			guiEditSetMaxLength(cache.inventory.gui,4)
			addEventHandler("onClientGUIChanged", cache.inventory.gui, function(element)
				if element == cache.inventory.gui then
					editText = guiGetText(cache.inventory.gui);
					editText = editText:gsub("[^0-9]", "");
					
					guiSetText(cache.inventory.gui,editText);
				end
			end, true);
		else
			if cache.inventory.page == "object" or cache.inventory.page == "vehicle" then
				if cache.inventory.page == "vehicle" then
					setElementData(cache.inventory.element, "veh:player", nil)
					setElementData(cache.inventory.element, "veh:use", false)
					triggerServerEvent("doorState", localPlayer, cache.inventory.element, 0)
				end
				if cache.inventory.page == "object" then
					if getElementModel(cache.inventory.element) == 2332 then
						setElementData(cache.inventory.element,"safe:use",false)
						setElementData(cache.inventory.element,"safe:player",nil)
					end
				end
				inventoryCache[localPlayer] = playerCache[localPlayer]
				cache.inventory.element = localPlayer
				--triggerServerEvent("getItems",localPlayer,localPlayer,2)
				
				cache.inventory.page = "bag";
				cache.inventory.currentpage = 1;
			end
			removeEventHandler("onClientRender",getRootElement(),func.render)
			destroyElement(cache.inventory.gui)
			
			setElementData(localPlayer,"show:inv",nil)
			
			if cache.inventory.itemMove then
				cache.inventory.itemMove = false
				cache.inventory.movedSlot = -1
			end
		end
	end
end
bindKey("i","down",func.showInventory)

func.deleteItemKey = function()
	if getElementData(localPlayer,"player:admin") >= 7 then
		if cache.inventory.element == localPlayer and cache.inventory.hoverSlot > 0 and inventoryCache[cache.inventory.element] and inventoryCache[cache.inventory.element][cache.inventory.page] and inventoryCache[cache.inventory.element][cache.inventory.page][cache.inventory.hoverSlot] then
			func.deleteItem(cache.inventory.hoverSlot)
		end
	end
end
bindKey("delete","down",func.deleteItemKey)

func.weapon.render = function()
		
		if getPedWeapon(localPlayer) > 0 and cache.inventory.active.weapon > 0 and not getElementData(localPlayer,"player:toghud") then
			local ammo = tostring(getPedTotalAmmo(localPlayer)-getPedAmmoInClip(localPlayer)).."|#7cc576"..tostring(getPedAmmoInClip(localPlayer))
			if ammo == "1|#7cc5760" then
				ammoText = ""
			else
				ammoText = ammo
			end
			local borderAmmo = tostring(getPedTotalAmmo(localPlayer)-getPedAmmoInClip(localPlayer)).."|"..tostring(getPedAmmoInClip(localPlayer))
			if borderAmmo == "1|0" then
				borderText = ""
			else
				borderText = borderAmmo
			end

			dxDrawText(borderText,cache.weapon.posX+155-1,cache.weapon.posY-148+1,cache.weapon.posX+605-1,cache.weapon.posY+348+1,tocolor(0,0,0,255),1,cache.font.roboto,"right","top",false,false,false,true)
			dxDrawText(ammoText,cache.weapon.posX+155,cache.weapon.posY-148,cache.weapon.posX+605,cache.weapon.posY+348,tocolor(255,255,255,255),1,cache.font.roboto,"right","top",false,false,false,true)
			if weaponCache[playerCache[localPlayer]["bag"][cache.inventory.active.weapon]["item"]] and weaponCache[playerCache[localPlayer]["bag"][cache.inventory.active.weapon]["item"]].hotTable then
				dxDrawRectangle(cache.weapon.posX+6,cache.weapon.posY+53,82,10,tocolor(0,0,0,120))
				if weaponProgress[cache.inventory.active.weapon] and weaponProgress[cache.inventory.active.weapon] >= 0 then
					local acitveState = playerCache[localPlayer]["bag"][cache.inventory.active.weapon]["state"] or -1
					weaponProgress[cache.inventory.active.weapon] = weaponProgress[cache.inventory.active.weapon]-(acitveState/200)
					if weaponProgress[cache.inventory.active.weapon] >= 80 then
						weaponProgress[cache.inventory.active.weapon] = 80
						if playerCache[localPlayer]["bag"][cache.inventory.active.weapon]["state"]-math.random(1,8) > 0 then
							exports["Pinfobox"]:addNotification("Fegyvered túlmelegedett.","error")
							func.setItemState(cache.inventory.active.weapon,playerCache[localPlayer]["bag"][cache.inventory.active.weapon]["state"]-math.random(1,8),"bag")
							toggleControl("fire",false)
							toggleControl("action",false)
							toggleControlSlot[cache.inventory.active.weapon] = true
						else
							exports["Pinfobox"]:addNotification("Fegyvered annyira túlmelegedett, hogy már használhatatlanná vált.","error")
							func.setItemState(cache.inventory.active.weapon,0,"bag",true)
							cache.inventory.active.weapon = -1
							cache.inventory.active.ammo = -1
							cache.inventory.active.dbid = -1
							toggleControl("fire",true)
							toggleControl("action",true)
							triggerServerEvent("takeWeaponServer",localPlayer,localPlayer)
						end
					end
					if weaponProgress[cache.inventory.active.weapon] and weaponProgress[cache.inventory.active.weapon] <= 15 and toggleControlSlot[cache.inventory.active.weapon] then
						toggleControl("fire",true)
						toggleControl("action",true)
						toggleControlSlot[cache.inventory.active.weapon] = false
					end
					if weaponProgress[cache.inventory.active.weapon] then
						dxDrawRectangle(cache.weapon.posX+7,cache.weapon.posY+54,weaponProgress[cache.inventory.active.weapon],8,tocolor(244,115,33,255))
					end
				end
			end
		
	
	end
end
addEventHandler("onClientRender",getRootElement(),func.weapon.render)

setTimer(function()
	if cache.inventory.show and (cache.inventory.page == "vehicle" or cache.inventory.page == "object") then
		if cache.inventory.element then
			local playerX,playerY,playerZ = getElementPosition(localPlayer)
			local targetX,targetY,targetZ = getElementPosition(cache.inventory.element)
			local playerDimension = getElementDimension(localPlayer)
			local targetDimension = getElementDimension(cache.inventory.element)
			local playerInterior = getElementInterior(localPlayer)
			local targetInterior = getElementInterior(cache.inventory.element)
			if playerDimension == targetDimension and playerInterior == targetInterior then
				if getDistanceBetweenPoints3D(playerX,playerY,playerZ,targetX,targetY,targetZ) >= 4 then
					if getElementType(cache.inventory.element) == "vehicle" then
						setElementData(cache.inventory.element, "veh:player", nil)
						setElementData(cache.inventory.element, "veh:use", false)
						triggerServerEvent("doorState", localPlayer, cache.inventory.element, 0)
					end
					if (tostring(getElementType(cache.inventory.element))=="object") then
						if getElementModel(cache.inventory.element) == 2332 then
							setElementData(cache.inventory.element,"safe:use",false)
							setElementData(cache.inventory.element,"safe:player",nil)
						end
					end

					--triggerServerEvent("getItems",localPlayer,localPlayer,2)
					inventoryCache[localPlayer] = playerCache[localPlayer]
					cache.inventory.element = localPlayer
					cache.inventory.show = false;
					cache.inventory.page = "bag";
					cache.inventory.currentpage = 1;
					removeEventHandler("onClientRender",getRootElement(),func.render);

					setElementData(localPlayer,"show:inv",nil)
					destroyElement(cache.inventory.gui);
					if cache.inventory.itemMove then
						cache.inventory.itemMove = false;
						cache.inventory.movedSlot = -1;
					end
				end
			end
		end
	end
end,200,0) 

func.render = function()
	cache.inventory.cursorInSlot = false
	cache.inventory.hoverSlot = -1
	cache.inventory.hoverItem = nil
	--
	if cache.inventory.show then
		local drawRow = 0
		local drawColumn = 0
		
		if cache.inventory.moving then
			if isCursorShowing() then
				local cursorX,cursorY = func.getCursorPosition()
				pos[1] = cursorX - cache.inventory.defX
				pos[2] = cursorY - cache.inventory.defY
			else
				cache.inventory.moving = false
			end
		end

		--háttér
		dxDrawRectangle(pos[1],pos[2]-60,width,height+60,tocolor(25,25,25,255))
		dxDrawRectangle(pos[1]-70,pos[2]-60,70,height+60,tocolor(23,23,23,255))
		dxDrawImage(pos[1]-60,pos[2]-50 +(0*50),50,50,"files/images/logo.png",0,0,0);
		
		dxDrawImage(pos[1]+14,pos[2]-46,40,42,pages[cache.inventory.currentpage].img,0,0,0,tocolor(129, 99, 191));
        dxDrawText(pages[cache.inventory.currentpage].name,pos[1]+210-1,pos[2]-36+1,pos[1]+210-1,pos[2]-36+1,tocolor(0,0,0,255),0.6,cache.font.sansheavy,"center","center");
        dxDrawText(pages[cache.inventory.currentpage].name,pos[1]+210,pos[2]-36,pos[1]+210,pos[2]-36,tocolor(255,255,255,255),0.6,cache.font.sansheavy,"center","center");

		if cache.inventory.page == "bag" or cache.inventory.page == "key" or cache.inventory.page == "licens" then
			for i = 1, 4 do
				if func.inBox(pos[1]-55,pos[2]-34 +(i*50),40,42) or pages[i].page == cache.inventory.page then
					dxDrawImage(pos[1]-55,pos[2]-34 +(i*50),40,42,pages[i].img,0,0,0,tocolor(129, 99, 191));
				else
					dxDrawImage(pos[1]-55,pos[2]-34 +(i*50),40,42,pages[i].img,0,0,0,tocolor(34,34,34));
				end
			end
		end

		dxDrawRectangle(pos[1]+94,pos[2]-24,224,16,tocolor(34,34,34,255))
		if cache.inventory.page == "bag" or cache.inventory.page == "craft" then
			dxDrawImage(pos[1]+76,pos[2]-26,16,19,pages[cache.inventory.currentpage].miniImg,0,0,0);
		end

		local itemWeight = getAllItemWeight()
		if itemWeight > 0 then
			local actualweight = math.ceil(itemWeight)/getTypeElement(cache.inventory.element)[3]*224;
			if actualweight > 224 then
				actualweight = 224;
			end
			dxDrawRectangle(pos[1]+94+2,pos[2]-24+2,actualweight,16-4,tocolor(129, 99, 191,255))
		end
		dxDrawText(math.ceil(itemWeight).."/"..getTypeElement(cache.inventory.element)[3].." kg",pos[1]+213,pos[2]-16,pos[1]+213,pos[2]-16,tocolor(55,55,55,255),0.48,cache.font.sansheavy,"center","center");

		if cache.inventory.page ~= "craft" then
			if cache.inventory.itemMove then
				if func.inBox(pos[1]+170,pos[2]-120,80,38) then
					dxDrawImage(pos[1]+170,pos[2]-120,80,38,"files/images/eye.png",0,0,0,tocolor(129, 99, 191))
				else
					dxDrawImage(pos[1]+170,pos[2]-120,80,38,"files/images/eye.png",0,0,0)
				end
			end


			dxDrawRectangle(pos[1]+width-102,pos[2]-42,86,30,tocolor(29,29,29,255))
			if #guiGetText(cache.inventory.gui) > 0 then
				dxDrawText(guiGetText(cache.inventory.gui),pos[1]+width-90,pos[2]-36,0,0,tocolor(255,255,255,255),0.5,cache.font.sfpro);
				if cache.inventory.editing then
					dxDrawRectangle(pos[1]+width-90+2 +dxGetTextWidth(guiGetText(cache.inventory.gui),0.5,cache.font.sfpro),pos[2]-34,2,14,tocolor(230,230,230,cache.inventory.alpha))
				end
			else
				if not cache.inventory.editing then
					dxDrawText("Stack",pos[1]+width-82,pos[2]-39,0,0,tocolor(55,55,55,255),0.6,cache.font.sfpro);
				end
			end

			cache.inventory.usedSlots = 0
			for i = 1, row * column do
				local left = pos[1] + drawColumn * (itemSize + margin) + margin;
				local top = pos[2] + drawRow * (itemSize + margin) + margin;
				local hover = func.inBox(left,top,itemSize,itemSize)
				if hover then
					cache.inventory.cursorInSlot = true
					cache.inventory.hoverSlot = i
				end

				if hover then
					dxDrawRectangle(left,top,itemSize,itemSize,tocolor(129, 99, 191,255))
				else
					dxDrawRectangle(left,top,itemSize,itemSize,tocolor(29,29,29,255))
				end

				if inventoryCache[cache.inventory.element] and inventoryCache[cache.inventory.element][cache.inventory.page] and inventoryCache[cache.inventory.element][cache.inventory.page][i] then
					cache.inventory.usedSlots = cache.inventory.usedSlots+1
					local id = inventoryCache[cache.inventory.element][cache.inventory.page][i]["id"]
					local item = inventoryCache[cache.inventory.element][cache.inventory.page][i]["item"]
					local value = inventoryCache[cache.inventory.element][cache.inventory.page][i]["value"]
					local count = inventoryCache[cache.inventory.element][cache.inventory.page][i]["count"]
					local state = inventoryCache[cache.inventory.element][cache.inventory.page][i]["state"]
					local weaponserial = inventoryCache[cache.inventory.element][cache.inventory.page][i]["weaponserial"]
					if hover then
						cache.inventory.sound.selected = i
						cache.inventory.hoverItem = inventoryCache[cache.inventory.element][cache.inventory.page][i]
						cache.inventory.moveX = left
						cache.inventory.moveY = top
						if cache.inventory.movedSlot ~= i then
							if (getElementData(localPlayer,"player:adminduty") and getElementData(localPlayer,"player:admin") >= 4) then
								func.toolTip(getItemName(item,value).." [sql id: "..id.." itemid: "..item.."]",tostring(value));
							else
								func.toolTip(unpack(getItemTooltip(id,item,value,count,state,weaponserial)));
							end
						end
					end
					
					if cache.inventory.movedSlot ~= i then
						dxDrawImage(left,top,itemSize,itemSize,getItemImage(item,value));
						local cleft,ctop = left+itemSize-margin/2+2,top;
                    	dxDrawText(count,cleft-1,ctop+1,cleft-1,ctop+1,tocolor(0,0,0,255),0.42,cache.font.roboto,"right","top")
						dxDrawText(count,cleft,ctop,cleft,ctop,tocolor(255,255,255,255),0.42,cache.font.roboto,"right","top")
						if hover then
							dxDrawRectangle(left,top,itemSize,itemSize,tocolor(0,0,0,120))
						end
						if (getTypeElement(cache.inventory.element,tonumber(item))[1] == "bag" and (cache.inventory.active.weapon == i or cache.inventory.active.ammo == i or cache.inventory.active.badge == i)) or (getTypeElement(cache.inventory.element,tonumber(item))[1] == "licens" and (cache.inventory.active.card == i or cache.inventory.active.identity == i)) then
							--dxDrawImage(left,top,itemSize,itemSize,"files/images/used.png",0,0,0,tocolor(255,255,255,120))
							func.border(left,top,itemSize,itemSize, 1, tocolor(129, 99, 191,255))
						end
					end
				end
				
				
				drawColumn = drawColumn + 1;
				if (drawColumn == column) then
					drawColumn = 0;
					drawRow = drawRow + 1;
				end
			end
		end
		
		if cache.inventory.itemMove then
			if isCursorShowing() then    
				local x, y = func.getCursorPosition()
				moveX,moveY = x - cache.inventory.defX,y - cache.inventory.defY
			else
				moveX,moveY = 0,0
				if cache.inventory.itemMove then
					cache.inventory.itemMove = false
					cache.inventory.movedSlot = -1
				end
			end
			dxDrawImage(moveX,moveY,itemSize,itemSize,getItemImage(cache.inventory.movedItem["item"],cache.inventory.movedItem["value"]),0,0,0,tocolor(255,255,255,255),true);
			local count = cache.inventory.movedItem["count"];

			local cleft,ctop = moveX+itemSize-margin/2+2,moveY;
    	    dxDrawText(count,cleft-1,ctop+1,cleft-1,ctop+1,tocolor(0,0,0,255),0.42,cache.font.roboto,"right","top",false,false,true)
        	dxDrawText(count,cleft,ctop,cleft,ctop,tocolor(255,255,255,255),0.42,cache.font.roboto,"right","top",false,false,true)
		end
	else
		if cache.inventory.itemMove then
			cache.inventory.itemMove = false
			cache.inventory.movedSlot = -1
		end
	end
end


func.click = function(button,state,absoluteX,absoluteY,worldX,worldY,worldZ,clickedElement)
	if getElementData(localPlayer,"hudVisible") or cache.actionbar.show then
		if button == "left" and state == "down" then
			if cache.actionbar.hover.slot > 0 then
				if not cache.actionbar.itemMove and actionBarCache[cache.actionbar.hover.slot] then
					cache.actionbar.movedSlot = cache.actionbar.hover.slot
					cache.actionbar.movedItem = cache.actionbar.hoverItem
					cache.actionbar.movedInventoryItem = cache.actionbar.hoverInventoryItem
					cache.actionbar.itemMove = true
					local img = cache.actionbar.slot.noitem
					if cache.actionbar.hoverItem then
						img = getItemImage(cache.actionbar.movedInventoryItem["item"],cache.actionbar.movedInventoryItem["value"])
					end
					cache.actionbar.slot.movedimg = img
					local curX, curY = func.getCursorPosition()
					local x,y = cache.actionbar.moveX,cache.actionbar.moveY
					cache.actionbar.defX, cache.actionbar.defY = curX - x, curY - y
				end
			end
		elseif button == "left" and state == "up" then
			if cache.actionbar.itemMove then
				
				if cache.actionbar.hover.slot > 0 then
					if cache.actionbar.movedSlot ~= cache.actionbar.hover.slot and not actionBarCache[cache.actionbar.hover.slot] then
						triggerServerEvent("updateActionBarItemSlot",localPlayer,localPlayer,cache.actionbar.movedSlot,cache.actionbar.hover.slot)
						actionBarCache[cache.actionbar.hover.slot] = actionBarCache[cache.actionbar.movedSlot]
						actionBarCache[cache.actionbar.movedSlot] = nil
					end
				else
					if not cache.actionbar.cursorInSlot then
						triggerServerEvent("deleteActionBarItem",localPlayer,localPlayer,cache.actionbar.movedSlot)
						actionBarCache[cache.actionbar.movedSlot] = nil
					end
				end
			
				cache.actionbar.itemMove = false
				cache.actionbar.movedSlot = -1
			end
		end
	end
	
	if cache.inventory.show then
		if button == "left" and state == "down" then
			if getElementType(cache.inventory.element) == "player" then
				if cache.inventory.page == "bag" or cache.inventory.page == "key" or cache.inventory.page == "licens" then
					for i = 1, 4 do
						if func.inBox(pos[1]-55,pos[2]-34 +(i*50),40,42) then
							if pages[i].page ~= cache.inventory.page then
								if pages[i].page == "craft" then
									if cache.craft.show then
										cache.craft.show = false;
										removeEventHandler("onClientRender",getRootElement(),func.craft.render)
										removeEventHandler("onClientClick",getRootElement(),func.craft.click)
									else
										cache.craft.show = true;
										addEventHandler("onClientRender",getRootElement(),func.craft.render)
										addEventHandler("onClientClick",getRootElement(),func.craft.click)
									end
								else
									cache.inventory.page = pages[i].page;
									cache.inventory.currentpage = i;
								end
							end
						end
					end
					if cache.inventory.itemMove then
						cache.inventory.itemMove = false
						cache.inventory.movedSlot = -1
					end
				end
			end
			
			if func.inBox(pos[1],pos[2]-60,width,56) and not cache.inventory.moving and not func.inBox(pos[1]+width-102,pos[2]-42,86,30) then
				cache.inventory.moving = true
				local cursorX, cursorY = func.getCursorPosition()
				local x,y = pos[1],pos[2]
				cache.inventory.defX, cache.inventory.defY = cursorX - x, cursorY - y
			end
			
			if cache.inventory.page ~= "craft" then
				if func.inBox(pos[1]+width-102,pos[2]-42,86,30) then
					if guiEditSetCaretIndex(cache.inventory.gui, string.len(guiGetText(cache.inventory.gui))) then
						guiBringToFront(cache.inventory.gui)
						if not cache.inventory.editing then
							cache.inventory.editing = true
						end
					end
				else
					if cache.inventory.editing then
						cache.inventory.editing = false
					end
				end
			end
			
			if cache.inventory.hoverSlot > 0 and cache.inventory.hoverItem and not cache.inventory.itemMove then
				if cache.inventory.hoverItem["item"] == 125 then
					outputChatBox("#8163bf[xProject]:#ffffff Ezt a tárgyat nem mozgathatod.",220,20,60,true)
				else
					if (getTypeElement(cache.inventory.element,cache.inventory.hoverItem["item"])[1] == "bag" and (cache.inventory.active.weapon == cache.inventory.hoverSlot or cache.inventory.active.ammo == cache.inventory.hoverSlot or cache.inventory.active.badge == cache.inventory.hoverSlot)) or (getTypeElement(cache.inventory.element,cache.inventory.hoverItem["item"])[1] == "licens" and (cache.inventory.active.card == cache.inventory.hoverSlot or cache.inventory.active.identity == cache.inventory.hoverSlot)) then
						outputChatBox("#8163bf[xProject]:#ffffff A kiválasztott tárgy használatban van.",220,20,60,true)
					else
						cache.inventory.movedSlot = cache.inventory.hoverSlot
						cache.inventory.movedItem = cache.inventory.hoverItem
						cache.inventory.itemMove = true
						local cursorX,cursorY = func.getCursorPosition()
						local x,y = cache.inventory.moveX,cache.inventory.moveY
						cache.inventory.defX,cache.inventory.defY = cursorX - x, cursorY - y
					end
				end
			end
			
		elseif button == "left" and state == "up" then
			if cache.inventory.moving then
				cache.inventory.moving = false;
			end

			if cache.inventory.itemMove then
				if cache.craft.hoverSlot > 0 then
					if not craftItems[cache.craft.hoverSlot] then
						craftItems[cache.craft.hoverSlot] = {
							item = cache.inventory.movedItem.item,
							slot = cache.craft.hoverSlot,
							count = 1,
							itemdbid = cache.inventory.movedItem.id,
						};
					end
				elseif cache.actionbar.hover.slot > 0 then
					if cache.inventory.page == "bag" or cache.inventory.page == "key" or cache.inventory.page == "licens" then
						if not actionBarCache[cache.actionbar.hover.slot] then
							actionBarCache[cache.actionbar.hover.slot] = {cache.inventory.movedItem["id"],cache.inventory.movedItem["item"],cache.inventory.page}
							triggerServerEvent("moveItemToActionBar",localPlayer,localPlayer,cache.actionbar.hover.slot,actionBarCache[cache.actionbar.hover.slot])
						end
					end
				else
					if cache.inventory.hoverSlot > 0 then
						if not cache.inventory.hoverItem then
							local amount = guiGetText(cache.inventory.gui)
							if amount == "" then
								func.updateSlot(cache.inventory.movedSlot,cache.inventory.hoverSlot,cache.inventory.movedItem)
							else
								amount = tonumber(amount) or 0;
								if amount > 0 then
									if cache.inventory.movedItem["count"] == amount then
										func.updateSlot(cache.inventory.movedSlot,cache.inventory.hoverSlot,cache.inventory.movedItem)
									else
										if cache.inventory.movedItem["count"] >= amount then
											func.createStackedItem(cache.inventory.hoverSlot, cache.inventory.movedItem, amount);
											func.setItemCount(cache.inventory.movedSlot,cache.inventory.movedItem["count"] - amount);
										end
									end
								end
							end
						else
							if cache.inventory.hoverSlot ~= cache.inventory.movedSlot and cache.inventory.movedItem["item"] == cache.inventory.hoverItem["item"] and cache.inventory.movedItem["duty"] == cache.inventory.hoverItem["duty"] and getItemStackable(cache.inventory.hoverItem["item"]) then
								local amount = guiGetText(cache.inventory.gui)
								if amount == "" then
									func.setItemCount(cache.inventory.hoverSlot,cache.inventory.hoverItem["count"]+cache.inventory.movedItem["count"])
									func.deleteItem(cache.inventory.movedSlot)
								else
									amount = tonumber(amount) or 0;
									if cache.inventory.movedItem["count"] >= amount then
										func.setItemCount(cache.inventory.hoverSlot,cache.inventory.hoverItem["count"]+amount)
										func.setItemCount(cache.inventory.movedSlot,cache.inventory.movedItem["count"]-amount)
									end
								end
							end
						end
					else
						if func.inBox(pos[1]+170,pos[2]-120,80,38) then


							if cache.inventory.itemMove and cache.inventory.page ~= "craft" then
								if not getElementData(localPlayer,"showitem") then
									local item = cache.inventory.movedItem["item"];
									local value = cache.inventory.movedItem["value"];
									exports["Pchat"]:takeMessage("me","felmutat egy tárgyat: "..getItemName(item,value)..".");
									exports["Pnametag"]:showItem(localPlayer,cache.inventory.movedItem);
								end
							end
						else
							if exports.Pbank:getCardPosition() and cache.inventory.active.card == -1 and cache.inventory.movedItem.item == 120 then
								exports.Pbank:setCardDataByItem(cache.inventory.movedItem,cache.inventory.movedSlot);
								---cache.inventory.active.card = cache.inventory.movedSlot;
								setActiveSlot(cache.inventory.movedSlot,120,"card")
							else
								if clickedElement then
									if getElementType(clickedElement) == "player" then
										if getElementData(clickedElement,"player:loggedIn") and clickedElement ~= cache.inventory.element then
											local playerX,playerY,playerZ = getElementPosition(localPlayer)
											local targetX,targetY,targetZ = getElementPosition(clickedElement)
											local playerDimension = getElementDimension(localPlayer)
											local targetDimension = getElementDimension(cache.inventory.element)
											local playerInterior = getElementInterior(localPlayer)
											local targetInterior = getElementInterior(clickedElement)
											if playerDimension == targetDimension and playerInterior == targetInterior then
												if getDistanceBetweenPoints3D(playerX,playerY,playerZ,targetX,targetY,targetZ) < 4 then
													if cache.inventory.movedItem["duty"] == 0 then
														triggerServerEvent("itemTransfer",localPlayer,cache.inventory.element,clickedElement,cache.inventory.movedItem,weaponProgress[cache.inventory.movedSlot] or 0)
														if cache.inventory.movedItem then
															deleteCraftitem(cache.inventory.movedItem.id)
														end
													else
														outputChatBox("#8163bf[xProject]:#ffffff Szolgálati eszközzel ezt nem teheted meg.",220,20,60,true)
													end
												end
											end
										end
									elseif getElementType(clickedElement) == "vehicle" then
										if getElementData(clickedElement,"vehicle:dbid") and getElementData(clickedElement,"vehicle:dbid") > 0 and cache.inventory.element == localPlayer then
											local playerX,playerY,playerZ = getElementPosition(localPlayer)
											local targetX,targetY,targetZ = getElementPosition(clickedElement)
											local playerDimension = getElementDimension(localPlayer)
											local targetDimension = getElementDimension(clickedElement)
											local playerInterior = getElementInterior(localPlayer)
											local targetInterior = getElementInterior(clickedElement)
											if playerDimension == targetDimension and playerInterior == targetInterior then
												if getDistanceBetweenPoints3D(playerX,playerY,playerZ,targetX,targetY,targetZ) < 4 then
													if not isVehicleLocked(clickedElement) then
														if cache.inventory.movedItem["duty"] == 0 then
															if cache.inventory.movedItem.item ~= 120 then
																triggerServerEvent("itemTransfer",localPlayer,cache.inventory.element,clickedElement,cache.inventory.movedItem)
																if cache.inventory.movedItem then
																	deleteCraftitem(cache.inventory.movedItem.id)
																end
															else
																outputChatBox("#8163bf[xProject]:#ffffff A kiválasztott tárgyat csak és kizárólag egy másik játékosnak tudod átadni.",220,20,60,true)
															end
														else
															outputChatBox("#8163bf[xProject]:#ffffff Szolgálati eszközzel ezt nem teheted meg.",220,20,60,true)
														end
													else
														outputChatBox("#8163bf[xProject]:#ffffff A kiválasztott jármű csomagtartója zárva van.",220,20,60,true)
													end
												end
											end
										end
									elseif getElementType(clickedElement) == "object" then
										if getElementData(clickedElement,"object:dbid") and getElementData(clickedElement,"object:dbid") > 0 then
											local playerX,playerY,playerZ = getElementPosition(localPlayer)
											local targetX,targetY,targetZ = getElementPosition(clickedElement)
											local playerDimension = getElementDimension(localPlayer)
											local targetDimension = getElementDimension(clickedElement)
											local playerInterior = getElementInterior(localPlayer)
											local targetInterior = getElementInterior(clickedElement)
											if playerDimension == targetDimension and playerInterior == targetInterior then
												if getDistanceBetweenPoints3D(playerX,playerY,playerZ,targetX,targetY,targetZ) < 4 then
													if getElementModel(clickedElement) == 1359 then
														if cache.inventory.element == localPlayer then
															func.deleteItem(cache.inventory.movedSlot)
															exports["Pchat"]:takeMessage("me","kidobott egy tárgyat a szemetesbe.")
														end
													elseif getElementModel(clickedElement) == 2332 then
														if hasItem(107,getElementData(clickedElement,"object:dbid")) then
															if cache.inventory.movedItem["item"] == 107 and tonumber(cache.inventory.movedItem["value"]) == tonumber(getElementData(clickedElement,"object:dbid")) then
																outputChatBox("#8163bf[xProject]:#ffffff A széfbe nem rakhatod bele a kulcsát.",220,20,60,true)
															else
																if cache.inventory.movedItem["duty"] == 0 then
																	if cache.inventory.movedItem.item ~= 120 then
																		triggerServerEvent("itemTransfer",localPlayer,cache.inventory.element,clickedElement,cache.inventory.movedItem)
																		if cache.inventory.movedItem then
																			deleteCraftitem(cache.inventory.movedItem.id)
																		end
																	else
																		outputChatBox("#8163bf[xProject]:#ffffff A kiválasztott tárgyat csak és kizárólag egy másik játékosnak tudod átadni.",220,20,60,true)
																	end
																else
																	outputChatBox("#8163bf[xProject]:#ffffff Szolgálati eszközzel ezt nem teheted meg.",220,20,60,true)
																end
															end
														else
															outputChatBox("#8163bf[xProject]:#ffffff Nincs kulcsod ehhez a széfhez.",220,20,60,true)
														end
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
				cache.inventory.itemMove = false
				cache.inventory.movedSlot = -1
			end
		end
	end
	if button == "right" and state == "down" then
		if cache.inventory.show and cache.inventory.hoverSlot > 0 and cache.inventory.hoverItem and cache.inventory.element == localPlayer then
			if cache.inventory.itemMove and cache.inventory.movedSlot ~= cache.inventory.hoverSlot then return end
			func.useItem(cache.inventory.hoverSlot,cache.inventory.hoverItem)
		end
		if clickedElement and cache.actionbar.hover.slot == -1 then
			if getElementType(clickedElement) == "vehicle" then
				if getElementData(clickedElement,"vehicle:dbid") and getElementData(clickedElement,"vehicle:dbid") > 0 then
					local playerX,playerY,playerZ = getElementPosition(localPlayer)
					local targetX,targetY,targetZ = getElementPosition(clickedElement)
					local playerDimension = getElementDimension(localPlayer)
					local targetDimension = getElementDimension(clickedElement)
					local playerInterior = getElementInterior(localPlayer)
					local targetInterior = getElementInterior(clickedElement)
					if playerDimension == targetDimension and playerInterior == targetInterior then
						if getDistanceBetweenPoints3D(playerX,playerY,playerZ,targetX,targetY,targetZ) < 4 then
							if cache.inventory.page ~= getElementType(clickedElement) then
								if cache.inventory.show then
									if func.inBox(pos[1],pos[2]-25,404,252) then
										return
									end
								end
								if not isVehicleLocked(clickedElement) then
									if not isPedInVehicle(localPlayer) then
										if not getElementData(clickedElement,"veh:use") then
											if cache.inventory.page ~= "object" then
												if not isTimer(cache.inventory.dummyTimer) then
													cache.inventory.dummyTimer = setTimer(function() killTimer(cache.inventory.dummyTimer) end,2000,1)
													exports["Pchat"]:takeMessage("me","belenézett egy jármű csomagtartójába.");
													if not cache.inventory.show then
														cache.inventory.gui = guiCreateEdit(-1000,-1000,0,0,"",false)
														guiEditSetMaxLength(cache.inventory.gui,4)
														addEventHandler("onClientGUIChanged", cache.inventory.gui, function(element)
															if element == cache.inventory.gui then
																editText = guiGetText(cache.inventory.gui);
																editText = editText:gsub("[^0-9]", "");
																
																guiSetText(cache.inventory.gui,editText);
															end
														end, true);
														addEventHandler("onClientRender",getRootElement(),func.render)
													end
													cache.inventory.show = true
													cache.inventory.page = "vehicle"
													cache.inventory.currentpage = 6;
													cache.inventory.element = clickedElement
													setElementData(clickedElement, "veh:player", localPlayer)
													setElementData(clickedElement, "veh:use", true)
													setElementData(localPlayer,"show:inv",clickedElement)
													triggerServerEvent("doorState",localPlayer,clickedElement,1)
													--triggerServerEvent("getItems",localPlayer,clickedElement,1)
													inventoryCache[clickedElement] = getElementData(clickedElement,"inventory:items");
												end
											end
										else
											outputChatBox("#8163bf[xProject]:#ffffff A kiválasztott jármű csomagtartója használatban van.",220,20,60,true)
										end
									end
								else
									outputChatBox("#8163bf[xProject]:#ffffff A kiválasztott jármű csomagtartója zárva van.",220,20,60,true)
								end
							end
						end
					end
				end
			elseif getElementType(clickedElement) == "object" then
				if getElementData(clickedElement,"object:dbid") and getElementData(clickedElement,"object:dbid") > 0 and getElementModel(clickedElement) == 2332 then
					local playerX,playerY,playerZ = getElementPosition(localPlayer)
					local targetX,targetY,targetZ = getElementPosition(clickedElement)
					local playerDimension = getElementDimension(localPlayer)
					local targetDimension = getElementDimension(clickedElement)
					local playerInterior = getElementInterior(localPlayer)
					local targetInterior = getElementInterior(clickedElement)
					if playerDimension == targetDimension and playerInterior == targetInterior then
						if getDistanceBetweenPoints3D(playerX,playerY,playerZ,targetX,targetY,targetZ) < 4 then
							if cache.inventory.page ~= getElementType(clickedElement) then
								if cache.inventory.show then
									if func.inBox(pos[1],pos[2]-25,404,252) then
										return
									end
								end
								if cache.inventory.page ~= "object" then
									if hasItem(107,getElementData(clickedElement,"object:dbid")) then
										if not getElementData(clickedElement,"safe:use") then
											if cache.inventory.page ~= "vehicle" then
												if not isTimer(cache.inventory.dummyTimer) then
													cache.inventory.dummyTimer = setTimer(function() killTimer(cache.inventory.dummyTimer) end,2000,1)
													exports["Pchat"]:takeMessage("me","belenézett egy széfbe.");
													if not cache.inventory.show then
														cache.inventory.gui = guiCreateEdit(-1000,-1000,0,0,"",false)
														guiEditSetMaxLength(cache.inventory.gui,4)
														addEventHandler("onClientGUIChanged", cache.inventory.gui, function(element)
															if element == cache.inventory.gui then
																editText = guiGetText(cache.inventory.gui);
																editText = editText:gsub("[^0-9]", "");
																
																guiSetText(cache.inventory.gui,editText);
															end
														end, true);
														addEventHandler("onClientRender",getRootElement(),func.render)
													end
													cache.inventory.show = true
													cache.inventory.page = "object"
													cache.inventory.currentpage = 5;
													cache.inventory.element = clickedElement
													setElementData(clickedElement, "safe:player", localPlayer)
													setElementData(clickedElement, "safe:use", true)
													setElementData(localPlayer,"show:inv",clickedElement)
													--triggerServerEvent("getItems",localPlayer,clickedElement,1)
													inventoryCache[clickedElement] = getElementData(clickedElement,"inventory:items");
												end
											end
										else
											outputChatBox("#8163bf[xProject]:#ffffff A kiválasztott széf használatban van.",220,20,60,true)
										end
									else
										outputChatBox("#8163bf[xProject]:#ffffff Nincs kulcsod ehhez a széfhez.",220,20,60,true)
									end
								end
							end
						end
					end
				end
			end
		end
	end
	if cache.inventory.itemlist.show then
		if button == "left" and state == "down" then
			if func.inBox(cache.inventory.itemlist.pos[1]+276,cache.inventory.itemlist.pos[2]+6,16,16) then
				cache.inventory.itemlist.show = false
				removeEventHandler("onClientRender",getRootElement(),func.renderItemlist)
				cache.inventory.itemlist.text = ""
				destroyElement(cache.inventory.itemlist.gui)
			elseif func.inBox(cache.inventory.itemlist.pos[1]+165,cache.inventory.itemlist.pos[2]+cache.inventory.itemlist.box[2]-25,14,14) then
				cache.inventory.itemlist.text = guiGetText(cache.inventory.itemlist.gui)
			elseif func.inBox(cache.inventory.itemlist.pos[1]+75,cache.inventory.itemlist.pos[2]+cache.inventory.itemlist.box[2]-27,217,20) then
				if guiEditSetCaretIndex(cache.inventory.itemlist.gui, string.len(guiGetText(cache.inventory.itemlist.gui))) then
					guiBringToFront(cache.inventory.itemlist.gui)
					cache.inventory.itemlist.edit = true;
				end
			else
				cache.inventory.itemlist.edit = false;
			end
		end
	end
end
addEventHandler("onClientClick",getRootElement(),func.click)

func.vehicleEnter = function(thePlayer, seat)
    if thePlayer == getLocalPlayer() then
        if cache.inventory.show and cache.inventory.page == "vehicle" then
			--triggerServerEvent("getItems",localPlayer,localPlayer,2)
			inventoryCache[localPlayer] = playerCache[localPlayer]
			cache.inventory.element = localPlayer
			cache.inventory.show = false;
			cache.inventory.page = "bag";
			cache.inventory.currentpage = 1;
			removeEventHandler("onClientRender",getRootElement(),func.render);
			setElementData(source, "veh:player", nil)
			setElementData(source, "veh:use", false)
			triggerServerEvent("doorState", localPlayer, source, 0)
			destroyElement(cache.inventory.gui);
			if cache.inventory.itemMove then
				cache.inventory.itemMove = false;
				cache.inventory.movedSlot = -1;
			end
		end
    end
end
addEventHandler("onClientVehicleEnter", getRootElement(),func.vehicleEnter)



function getAllItemWeight()
	local bagWeight = 0
	local keyWeight = 0
	local licensWeight = 0
	local vehWeight = 0
	local objectWeight = 0
	if isElement(cache.inventory.element) then
		if getElementType(cache.inventory.element) == "player" then
			if not inventoryCache[cache.inventory.element] then
				inventoryCache[cache.inventory.element] = {};
			end
			if inventoryCache[cache.inventory.element]["bag"] then
				for i = 1, row * column do
					if (inventoryCache[cache.inventory.element]["bag"][i]) then
						bagWeight = bagWeight + (getItemWeight(inventoryCache[cache.inventory.element]["bag"][i]["item"]) * inventoryCache[cache.inventory.element]["bag"][i]["count"])
					end
				end
			end
			if inventoryCache[cache.inventory.element]["key"] then
				for i = 1, row * column do
					if (inventoryCache[cache.inventory.element]["key"][i]) then
						keyWeight = keyWeight + (getItemWeight(inventoryCache[cache.inventory.element]["key"][i]["item"]) * inventoryCache[cache.inventory.element]["key"][i]["count"])
					end
				end
			end
			if inventoryCache[cache.inventory.element]["licens"] then
				for i = 1, row * column do
					if (inventoryCache[cache.inventory.element]["licens"][i]) then
						licensWeight = licensWeight + (getItemWeight(inventoryCache[cache.inventory.element]["licens"][i]["item"]) * inventoryCache[cache.inventory.element]["licens"][i]["count"])
					end	
				end
			end
		end
		if getElementType(cache.inventory.element) == "vehicle" then
			if inventoryCache[cache.inventory.element] then
				if inventoryCache[cache.inventory.element]["vehicle"] then
					for i = 1, row * column do
						if (inventoryCache[cache.inventory.element]["vehicle"][i]) then
							vehWeight = vehWeight + (getItemWeight(inventoryCache[cache.inventory.element]["vehicle"][i]["item"]) * inventoryCache[cache.inventory.element]["vehicle"][i]["count"])
						end	
					end
				end
			end
		end
		if getElementType(cache.inventory.element) == "object" then
			if inventoryCache[cache.inventory.element] then
				if inventoryCache[cache.inventory.element]["object"] then
					for i = 1, row * column do
						if (inventoryCache[cache.inventory.element]["object"][i]) then
							objectWeight = objectWeight + (getItemWeight(inventoryCache[cache.inventory.element]["object"][i]["item"]) * inventoryCache[cache.inventory.element]["object"][i]["count"])
						end	
					end
				end
			end
		end
	end
	return bagWeight + licensWeight + keyWeight + vehWeight + objectWeight
end

function takeItem(item)
	local elem = 0
	local thisElement = cache.inventory.element
	if getElementData(localPlayer,"show:inv") and getElementType(getElementData(localPlayer,"show:inv")) ~= "player" then
		thisElement = localPlayer
	end
	if cache.inventory.page == "craft" then
		thisMenu = "bag"
	else
		thisMenu = getTypeElement(thisElement,tonumber(item))[1] or cache.inventory.page;
	end	
	
	--outputChatBox(thisMenu.." - "..getElementType(thisElement))
	
	for i = 1, row * column do
		if (inventoryCache[thisElement][thisMenu][i]) then
			if item == inventoryCache[thisElement][thisMenu][i]["item"] then
				elem = elem+1
				if elem == 1 then
					if inventoryCache[thisElement][thisMenu][i]["count"] > 1 then
						triggerServerEvent("setItemCount", localPlayer, thisElement, inventoryCache[thisElement][thisMenu][i], inventoryCache[thisElement][thisMenu][i]["count"]-1);
						inventoryCache[thisElement][thisMenu][i]["count"] = inventoryCache[thisElement][thisMenu][i]["count"]-1;
					else
						triggerServerEvent("deleteItem", localPlayer, thisElement, inventoryCache[thisElement][thisMenu][i],false);
						inventoryCache[thisElement][thisMenu][i] = nil;
					end
				end
			end
		end
	end
	
	if thisElement == localPlayer then
		for i = 1, row * column do
			if (playerCache[thisElement][thisMenu][i]) then
				if item == playerCache[thisElement][thisMenu][i]["item"] then
					elem = elem+1
					if elem == 1 then
						if playerCache[thisElement][thisMenu][i]["count"] > 1 then
							triggerServerEvent("setItemCount", localPlayer, thisElement, playerCache[thisElement][thisMenu][i], playerCache[thisElement][thisMenu][i]["count"]-1);
							playerCache[thisElement][thisMenu][i]["count"] = playerCache[thisElement][thisMenu][i]["count"]-1;
						else
							func.deleteItem(i,false,thisMenu)
							triggerServerEvent("deleteItem", localPlayer, thisElement, playerCache[thisElement][thisMenu][i],false);
							playerCache[thisElement][thisMenu][i] = nil;
						end
					end
				end
			end
		end
	end
end

func.editAlpha = function()
	if cache.inventory.alpha == 255 then
		cache.inventory.alpha = 0
	elseif cache.inventory.alpha == 0 then
		cache.inventory.alpha = 255
	end
end
setTimer(func.editAlpha,700,0)

func.updateSlot = function(oldSlot,newSlot,data)
	triggerServerEvent("updateSlot",localPlayer,cache.inventory.element,oldSlot,newSlot,data)
	if inventoryCache[cache.inventory.element][cache.inventory.page][oldSlot] then
		inventoryCache[cache.inventory.element][cache.inventory.page][newSlot] = {
			["id"] = data["id"],
			["slot"] = newSlot,
			["item"] = data["item"],
			["value"] = data["value"],
			["count"] = data["count"],
			["duty"] = data["duty"],
			["state"] = data["state"],
			["weaponserial"] = data["weaponserial"],	
		}
		inventoryCache[cache.inventory.element][cache.inventory.page][oldSlot] = nil
	end
	if cache.inventory.element == localPlayer then
		if weaponProgress[oldSlot] then
			weaponProgress[newSlot] = weaponProgress[oldSlot];
		end
		if playerCache[cache.inventory.element][cache.inventory.page][oldSlot] then
			playerCache[cache.inventory.element][cache.inventory.page][newSlot] = {
				["id"] = data["id"],
				["slot"] = newSlot,
				["item"] = data["item"],
				["value"] = data["value"],
				["count"] = data["count"],
				["duty"] = data["duty"],
				["state"] = data["state"],
				["weaponserial"] = data["weaponserial"],
			}
			playerCache[cache.inventory.element][cache.inventory.page][oldSlot] = nil
		end
	end
end

func.deleteItem = function(slot,state,category,element)
	if not element then
		element = cache.inventory.element;
	end
	if not category then
		category = getTypeElement(cache.inventory.element,tonumber(inventoryCache[cache.inventory.element][cache.inventory.page][slot]["item"]))[1]
	end
	if inventoryCache[element][category][slot] then
		if (getTypeElement(element,tonumber(inventoryCache[element][category][slot]["item"]))[1] == "bag" and (cache.inventory.active.weapon == slot or cache.inventory.active.ammo == slot)) then
			if weaponProgress[cache.inventory.active.weapon] then
				weaponProgress[cache.inventory.active.weapon] = 0
			end
			cache.inventory.active.weapon = -1
			cache.inventory.active.ammo = -1
			cache.inventory.active.dbid = -1
			toggleControl("fire",true)
			toggleControl("action",true)
			triggerServerEvent("takeWeaponServer",localPlayer,localPlayer)
		end

		if cache.inventory.active.identity > 0 then
			cache.inventory.active.identity = -1;
		end

		triggerServerEvent("deleteItem", localPlayer, element, inventoryCache[element][category][slot],state);
		inventoryCache[element][category][slot] = nil;
		if element == localPlayer then
			
			if playerCache[element][category][slot] then
				deleteCraftitem(playerCache[element][category][slot].id)
			end
			playerCache[element][category][slot] = nil;
		end
	end
end

func.setItemCount = function(slot,count,category,state,element)
	if not element then
		element = cache.inventory.element;
	end
	if not category then
		if inventoryCache[cache.inventory.element][cache.inventory.page][slot] then
			category = getTypeElement(cache.inventory.element,tonumber(inventoryCache[cache.inventory.element][cache.inventory.page][slot]["item"]))[1]
		else
			if inventoryCache[cache.inventory.element] then
				for type,_ in pairs(inventoryCache[cache.inventory.element]) do
					for i = 1, row * column do
						if inventoryCache[cache.inventory.element][type][i] then
							if count == inventoryCache[cache.inventory.element][type][i].count-1 and slot == i then
								category = type
							end
						end
					end
				end
			end
		end
	end
	if inventoryCache[element][category][slot] then
        if count > 0 then
            triggerServerEvent("setItemCount", localPlayer, element, inventoryCache[element][category][slot], count);
            inventoryCache[element][category][slot]["count"] = count;
			if cache.inventory.element == localPlayer then
				playerCache[element][category][slot]["count"] = count;
			end
        else
            func.deleteItem(slot,state,category,element);
        end
	end
end

func.setItemState = function(slot,state,category,hot)
	if not category then
		category = getTypeElement(cache.inventory.element,tonumber(inventoryCache[cache.inventory.element][cache.inventory.page][slot]["item"]))[1];
	end
	if inventoryCache[cache.inventory.element][category][slot] then
        if state > 0 or hot then
            triggerServerEvent("setItemState", localPlayer, cache.inventory.element, inventoryCache[cache.inventory.element][category][slot], state);
            inventoryCache[cache.inventory.element][category][slot]["state"] = state;
			if cache.inventory.element == localPlayer then
				playerCache[cache.inventory.element][category][slot]["state"] = state;
			end
        else
            func.deleteItem(slot,false,category);
        end
	end
end

func.createStackedItem = function(slot,data,count)
	triggerServerEvent("createStackedItem",localPlayer,cache.inventory.element,slot,data,count);
end

func.refreshItem = function(element,data,type,extras)
	if not inventoryCache[element] then
		inventoryCache[element] = {
			["bag"] = {},
			["key"] = {},
			["wallet"] = {},
			["vehicle"] = {},
			["object"] = {},
		}
	end
	if element == localPlayer then
		if not playerCache[element] then
			playerCache[element] = {
				["bag"] = {},
				["key"] = {},
				["wallet"] = {},
				["vehicle"] = {},
				["object"] = {},
			}
		end
	end
	if type == "delete" then
		inventoryCache[element][getTypeElement(element,data["item"])[1]][data["slot"]] = nil;
		if element == localPlayer then
			playerCache[element][getTypeElement(element,data["item"])[1]][data["slot"]] = nil;
		end
		if extras then
			func.checkDuplicated(element,data,extras)
		end
		if cache.inventory.itemMove then
			cache.inventory.itemMove = false
			cache.inventory.movedSlot = -1
		end
	elseif type == "create" then
		if not inventoryCache[element][getTypeElement(element,data["item"])[1]] then
			inventoryCache[element][getTypeElement(element,data["item"])[1]] = {};
		end
		inventoryCache[element][getTypeElement(element,data["item"])[1]][data["slot"]] = data;
		if element == localPlayer then
			weaponProgress[data.slot] = extras;
			if not playerCache[element][getTypeElement(element,data["item"])[1]] then
				playerCache[element][getTypeElement(element,data["item"])[1]] = {};
			end
			playerCache[element][getTypeElement(element,data["item"])[1]][data["slot"]] = data;
		end
		
	end
end
addEvent("refreshItem",true)
addEventHandler("refreshItem",getRootElement(),func.refreshItem)
function hasItem(item,value,slot)
	if not playerCache[localPlayer] then
		playerCache[localPlayer] = {};
	end
	if slot then
		if playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][slot] then
			if item == playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][slot]["item"] then
				return true,playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][slot],slot
			end
		end
		return false
	else
		if not value then
			if item ~= -1 and playerCache[localPlayer][getTypeElement(localPlayer,item)[1]] then
				for i = 1, row * column do
					if playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][i] then
						if item == playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][i]["item"] then
							return true,playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][i],i
						end
					end
				end
				return false
			end
			return false
		else
			if item ~= -1 and playerCache[localPlayer][getTypeElement(localPlayer,item)[1]] then
				for i = 1, row * column do
					if playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][i] then
						if item == playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][i]["item"] and tonumber(value) == tonumber(playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][i]["value"]) then
							return true,playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][i],i
						end
					end
				end
				return false
			end
			return false
		end
	end
end

function giveCardMoneyByCardnumber(cardnumber,amount)
	for i = 1, row * column do
		if playerCache[localPlayer]["licens"][i] and playerCache[localPlayer]["licens"][i].item == 120 then
			local data = fromJSON(playerCache[localPlayer]["licens"][i].value);
			local valuenumber = data.num1.."-"..data.num2;
			if playerCache[localPlayer]["licens"][i].item == 120 and valuenumber == cardnumber then
				local newAmount = data.money+amount;
				triggerServerEvent("setCardMoneyS",localPlayer,localPlayer,i,newAmount)
				if cache.inventory.active.card == i then
					exports.Pbank:setCardAmount(newAmount)
				end
				return true;
			end
		end
	end
	return false;
end

function deleteCraftitem(dbid)
	for i = 1, craftSlots * craftSlots do
        if craftItems and craftItems[i] and craftItems[i].itemdbid == dbid then
			craftItems[i] = nil;
		end
	end
end

function setActiveSlot(slot,item,type)
	if type == "card" then
		if slot == -1 then
			if playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][cache.inventory.active.card] then
				local jsonData = fromJSON(playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][cache.inventory.active.card].value);
				jsonData.used = false;
				local newValue = toJSON(jsonData);
				playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][cache.inventory.active.card].value = newValue;
				triggerServerEvent("setItemValue",localPlayer,localPlayer,playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][cache.inventory.active.card],newValue)
			end
			cache.inventory.active.card = -1
		end
		if playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][slot] and cache.inventory.active.card ~= slot then
			cache.inventory.active.card = slot;
			local jsonData = fromJSON(playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][slot].value);
			jsonData.used = true;
			local newValue = toJSON(jsonData);
			playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][slot].value = newValue;
			triggerServerEvent("setItemValue",localPlayer,localPlayer,playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][slot],newValue)
		end
	end
end

func.weaponFire = function(_,_,ammoInClip)
	if cache.inventory.active.weapon > 0 and cache.inventory.active.ammo > 0 then
		if weaponCache[playerCache[localPlayer]["bag"][cache.inventory.active.weapon]["item"]] then
			if playerCache[localPlayer]["bag"][cache.inventory.active.ammo]["count"] <= 1 then
				triggerServerEvent("deleteItem", localPlayer, localPlayer, playerCache[localPlayer]["bag"][cache.inventory.active.ammo]);
				playerCache[localPlayer]["bag"][cache.inventory.active.ammo] = nil;
				inventoryCache[localPlayer]["bag"][cache.inventory.active.ammo] = nil;
				cache.inventory.active.weapon = -1;
				cache.inventory.active.ammo = -1;
				cache.inventory.active.dbid = -1;
			else
				playerCache[localPlayer]["bag"][cache.inventory.active.ammo]["count"] = playerCache[localPlayer]["bag"][cache.inventory.active.ammo]["count"]-1;
				inventoryCache[localPlayer]["bag"][cache.inventory.active.ammo]["count"] = playerCache[localPlayer]["bag"][cache.inventory.active.ammo]["count"];
				triggerServerEvent("setItemCount", localPlayer, localPlayer, playerCache[localPlayer]["bag"][cache.inventory.active.ammo], playerCache[localPlayer]["bag"][cache.inventory.active.ammo]["count"]);
				if weaponCache[playerCache[localPlayer]["bag"][cache.inventory.active.weapon]["item"]].hotTable then
					weaponProgress[cache.inventory.active.weapon] = weaponProgress[cache.inventory.active.weapon]+weaponCache[playerCache[localPlayer]["bag"][cache.inventory.active.weapon]["item"]].hotTable
				end
			end
		end
	end
end
addEventHandler("onClientPlayerWeaponFire", getLocalPlayer(),func.weaponFire)

func.checkDuplicated = function(element,data,dbid)
	if inventoryCache[element] and inventoryCache[element][getTypeElement(element,tonumber(data.item))[1]] then
		for i = 1, row * column do
			if inventoryCache[element][getTypeElement(element,tonumber(data.item))[1]][i] and (inventoryCache[element][getTypeElement(element,tonumber(data.item))[1]][i]["id"] == dbid) then
				inventoryCache[element][getTypeElement(element,tonumber(data.item))[1]][i] = nil
				if element == localPlayer then
					playerCache[element][getTypeElement(element,tonumber(data.item))[1]][i] = nil
				end
			end
		end
	end
end

setTimer(function()
	if getElementData(localPlayer,"player:loggedIn") and playerCache[localPlayer] and playerCache[localPlayer]["licens"] then
		for i = 1, row * column do
			if playerCache[localPlayer]["licens"][i] and playerCache[localPlayer]["licens"][i].item == 125 then
				if playerCache[localPlayer]["licens"][i].state > 0 then
					playerCache[localPlayer]["licens"][i].state = playerCache[localPlayer]["licens"][i].state - 1;
					triggerServerEvent("setItemState", localPlayer,localPlayer, playerCache[localPlayer]["licens"][i], playerCache[localPlayer]["licens"][i].state);

					if playerCache[localPlayer]["licens"][i].state == 0 then
						local data = fromJSON(playerCache[localPlayer]["licens"][i].value);
						local amount = data.amount + data.amount/2;
						outputChatBox("[xProject]#ffffff Mivel nem fizetted be a bírságot, ezért a 150 %-át vette el tőled a rendszer ami #7cc576"..func.formatMoney(amount).."#ffffff dollár.",129, 99, 191,true)
						setElementData(localPlayer,"player:money",getElementData(localPlayer,"player:money") - amount)
						func.deleteItem(i,false,"licens");
					end
				end
				
			end
		end
	end
end,500,0)

func.renderItemlist = function()
	if cache.inventory.itemlist.show then
		func.rounded(cache.inventory.itemlist.pos[1],cache.inventory.itemlist.pos[2],cache.inventory.itemlist.box[1],cache.inventory.itemlist.box[2],tocolor(30,30,30,210))
		if func.inBox(cache.inventory.itemlist.pos[1]+276,cache.inventory.itemlist.pos[2]+6,16,16) then
			dxDrawText("",cache.inventory.itemlist.pos[1]+276,cache.inventory.itemlist.pos[2]+4,0,0,tocolor(210,49,49,255),1,cache.font.awesome)
		else
			dxDrawText("",cache.inventory.itemlist.pos[1]+276,cache.inventory.itemlist.pos[2]+4,0,0,tocolor(255,255,255,255),1,cache.font.awesome)
		end
		
		dxDrawText("Keresés:",cache.inventory.itemlist.pos[1]+9,cache.inventory.itemlist.pos[2]+cache.inventory.itemlist.box[2]-27,0,0,tocolor(255,255,255,255),0.55,cache.font.roboto)
		
		dxDrawRectangle(cache.inventory.itemlist.pos[1]+75,cache.inventory.itemlist.pos[2]+cache.inventory.itemlist.box[2]-27,217,20,tocolor(22,22,22,190))
		--func.bgborder(cache.inventory.itemlist.pos[1]+75,cache.inventory.itemlist.pos[2]+cache.inventory.itemlist.box[2]-27,217,20,2, tocolor(28,28,28,140))
		dxDrawImage(cache.inventory.itemlist.pos[1]+274,cache.inventory.itemlist.pos[2]+cache.inventory.itemlist.box[2]-24,14,14,"files/search.png")
		
		dxDrawText("Tárgynév",cache.inventory.itemlist.pos[1]+52,cache.inventory.itemlist.pos[2]+6,0,0,tocolor(255,255,255,255),0.65,cache.font.roboto)
		dxDrawRectangle(cache.inventory.itemlist.pos[1]+52,cache.inventory.itemlist.pos[2]+29,dxGetTextWidth("Tárgynév",1,cache.font.roboto),0.6)
		
		dxDrawText(guiGetText(cache.inventory.itemlist.gui),cache.inventory.itemlist.pos[1]+77,cache.inventory.itemlist.pos[2]+cache.inventory.itemlist.box[2]-26,0,0,tocolor(255,255,255,255),0.5,cache.font.roboto)
		if cache.inventory.itemlist.edit then
			dxDrawRectangle((cache.inventory.itemlist.pos[1]+79) + dxGetTextWidth(guiGetText(cache.inventory.itemlist.gui),0.5,cache.font.roboto),cache.inventory.itemlist.pos[2]+cache.inventory.itemlist.box[2]-24,1,14,tocolor(255,255,255,cache.inventory.alpha))
		end

		local newText = string.lower(string.gsub(guiGetText(cache.inventory.itemlist.gui), "_", " "));
		local count = 0;
		for k,v in ipairs(availableItems) do
			local name = string.lower(getItemName(k):gsub("_", " "))
			if k == tonumber(newText) or string.find(name, newText) then
				if k > cache.inventory.itemlist.wheel and count < 7 then
					count = count+1
					
					dxDrawImage(cache.inventory.itemlist.pos[1]+margin,cache.inventory.itemlist.pos[2]-margin +(count*(itemSize+margin)),itemSize,itemSize,cache.inventory.textures.item[k])
					local name = getItemName(k);
					if availableItems[k].description then
						name = name.. " - "..availableItems[k].description;
					end
					dxDrawText("#e5a00c(" .. k .. ")#ffffff "..name,cache.inventory.itemlist.pos[1]+margin+itemSize+10,cache.inventory.itemlist.pos[2]-margin+7 +(count*(itemSize+margin)),0,0,tocolor(255,255,255,255),0.6,cache.font.roboto,"left","top",false,false,false,true)
				end
			end
		end
	end
end

func.showItemlist = function()
	if getElementData(localPlayer,"player:admin") >= 3 then
		cache.inventory.itemlist.show = not cache.inventory.itemlist.show
		if cache.inventory.itemlist.show then
			addEventHandler("onClientRender",getRootElement(),func.renderItemlist)
			cache.inventory.itemlist.gui = guiCreateEdit(-1000,-1000,0,0,"",false)
			guiEditSetMaxLength(cache.inventory.itemlist.gui,16)
		else
			removeEventHandler("onClientRender",getRootElement(),func.renderItemlist)
			destroyElement(cache.inventory.itemlist.gui)
		end
	end
end
addCommandHandler("itemlist",func.showItemlist)

func.wheelUp = function()
	if cache.inventory.itemlist.show then
		if guiGetText(cache.inventory.itemlist.gui) == "" then
			cache.inventory.itemlist.wheel = cache.inventory.itemlist.wheel - 1
			if cache.inventory.itemlist.wheel < 1 then
				cache.inventory.itemlist.wheel = 0
			end
		end
	end
end
bindKey("mouse_wheel_up", "down",func.wheelUp)

func.wheelDown = function()
	if cache.inventory.itemlist.show then
		if guiGetText(cache.inventory.itemlist.gui) == "" then
			cache.inventory.itemlist.wheel = cache.inventory.itemlist.wheel + 1
			if cache.inventory.itemlist.wheel > #availableItems - 7 then
				cache.inventory.itemlist.wheel = #availableItems - 7
			end
		end
	end
end
bindKey("mouse_wheel_down", "down",func.wheelDown)

func.closeItemList = function()
	if cache.inventory.itemlist.show then
		cache.inventory.itemlist.show = false
	end
end
bindKey("backspace","down",func.closeItemList)

func.border = function(x, y, w, h, radius, color)
    dxDrawRectangle(x - radius, y, radius, h, color)
    dxDrawRectangle(x + w, y, radius, h, color)
    dxDrawRectangle(x - radius, y - radius, w + (radius * 2), radius, color)
    dxDrawRectangle(x - radius, y + h, w + (radius * 2), radius, color)
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

func.getCursorPosition = function()
	local cursorX,cursorY = getCursorPosition();
	cursorX,cursorY = cursorX*screen[1], cursorY*screen[2];
	return cursorX,cursorY;
end

func.toolTip = function(...)
	if isCursorShowing() then
		local x,y = func.getCursorPosition()
		local args = {...};
		local width = 0;

		for i, v in ipairs(args) do
			local thisWidth = dxGetTextWidth( v, 0.4, cache.font.roboto, true) + 20;
			if thisWidth > width then
				width = thisWidth;
			end
		end
		
		text = table.concat(args, "\n");
		
		local height = dxGetFontHeight(0.4, cache.font.roboto) * #args + 10;
		x = math.max( 10, math.min( x, screen[1] - width - 10 ) )
		y = math.max( 10, math.min( y, screen[2] - height - 10 ) )
		
		dxDrawRectangle( x, y, width, height, tocolor( 0, 0, 0, 180 ), true )
		dxDrawText( text, x, y, x + width, y + height, tocolor( 255, 255, 255, 230 ), 0.4, cache.font.roboto, "center", "center", false, false, true, true )
	end
end

func.inBox = function(x,y,w,h)
	if(isCursorShowing()) then
		local cursorX, cursorY = getCursorPosition();
		cursorX, cursorY = cursorX*screen[1], cursorY*screen[2];
		if(cursorX >= x and cursorX <= x+w and cursorY >= y and cursorY <= y+h) then
			return true;
		else
			return false;
		end
	end	
end

func.formatMoney = function(amount)
    local formatted = amount
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1 %2')
        if (k==0) then
            break
        end
    end
    return formatted
end

if not xmlLoadFile("inventory.xml") then
	local posF = xmlCreateFile("inventory.xml", "root")
	local mainC2 = xmlCreateChild(posF, "position")
	xmlNodeSetValue(xmlCreateChild(mainC2, "x"), pos[1]) 
	xmlNodeSetValue(xmlCreateChild(mainC2, "y"), pos[2]) 
	xmlSaveFile(posF)
	--outputChatBox("Mivel neked nem volt xml file-od ahova menthetné most le kreáltam neked egyet.")
else
	local posF = xmlLoadFile("inventory.xml")
	local mainC2 = xmlFindChild(posF, "position", 0)
	setElementData(localPlayer, "inv:x", tonumber(xmlNodeGetValue(xmlFindChild(mainC2, "x", 0))))
	setElementData(localPlayer, "inv:y", tonumber(xmlNodeGetValue(xmlFindChild(mainC2, "y", 0))))	

	pos[1] = getElementData(localPlayer, "inv:x")
	pos[2] = getElementData(localPlayer, "inv:y")
end


function savePos()
	local posF = xmlLoadFile("inventory.xml")
	if posF then
		local mainC2 = xmlFindChild(posF, "position", 0)
		xmlNodeSetValue(xmlFindChild(mainC2, "x", 0), pos[1])
		xmlNodeSetValue(xmlFindChild(mainC2, "y", 0), pos[2])
		xmlSaveFile(posF)
	end
end
addEventHandler("onClientResourceStop", getResourceRootElement(getThisResource()), savePos)
addEventHandler("onClientPlayerQuit", getRootElement(), savePos)

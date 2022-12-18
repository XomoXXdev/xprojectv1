fileDelete ("sourceC.lua") 
local screen = {guiGetScreenSize()};
local box = {actionSlots*(itemSize+actionMargin)+actionMargin,itemSize+(actionMargin*2)};
local pos = {screen[1]/2 -box[1]/2+actionMargin,screen[2] -box[2]-30};
cache.actionbar.show = false;

func.actionbar.start = function()
--	cache.actionbar.slot.used = dxCreateTexture("files/used.png", "argb");
--	cache.actionbar.slot.usedgreen = dxCreateTexture("files/used_green.png", "argb");
--	cache.actionbar.slot.usedyellow = dxCreateTexture("files/used_yellow.png", "argb");
--	cache.actionbar.slot.usedblue = dxCreateTexture("files/used_blue.png", "argb");
	cache.actionbar.slot.noitem = dxCreateTexture("files/items/-1.png", "argb");
	if getElementData(localPlayer,"player:loggedIn") then
		addEventHandler("onClientRender",getRootElement(),func.actionbar.render);
		cache.actionbar.show = true;
	end
	
end
addEventHandler("onClientResourceStart",resourceRoot,func.actionbar.start)

func.actionbar.dataChange = function(dataName,value)
	if dataName == "player:loggedIn" then
		if getElementData(localPlayer,dataName) then
			addEventHandler("onClientRender",getRootElement(),func.actionbar.render);
			cache.actionbar.show = true;
			triggerServerEvent("getActionbarItems",localPlayer,localPlayer,1);
		end
	end
end
addEventHandler("onClientElementDataChange",getLocalPlayer(),func.actionbar.dataChange)

func.actionbar.setItems = function(cache)
    actionBarCache = cache
end
addEvent("setActionbarItems", true)
addEventHandler("setActionbarItems", getRootElement(),func.actionbar.setItems)

for i=1, actionSlots do
	bindKey(i, "down", function()
		if actionBarCache[i] then
			for k = 1, row * column do
				if (playerCache[localPlayer][getTypeElement(localPlayer,actionBarCache[i][2])[1]][k]) then
					if playerCache[localPlayer][getTypeElement(localPlayer,actionBarCache[i][2])[1]][k]["id"] == actionBarCache[i][1] then
						func.useItem(k,playerCache[localPlayer][getTypeElement(localPlayer,actionBarCache[i][2])[1]][k])
					end
				end
			end
		end
	end)
end

func.actionbar.render = function()
	if cache.actionbar.show and not getElementData(localPlayer,"player:toghud") and getElementData(localPlayer,"player:interface:actionbaravalible") then
		cache.actionbar.cursorInSlot = false
		cache.actionbar.hover.slot = -1
		cache.actionbar.hoverItem = nil
		cache.actionbar.hoverInventoryItem = nil
		if cache.actionbar.show then
			local postGUI = getElementData(localPlayer,"player:interface")
			pos[1],pos[2] = getElementData(localPlayer,"player:interface:actionbarx"),getElementData(localPlayer,"player:interface:actionbary")

			if func.inBox(pos[1]+10-actionMargin,pos[2]+10-actionMargin,box[1],box[2]) then
				cache.actionbar.cursorInSlot = true
			end

			dxDrawRectangle(pos[1]+10-actionMargin,pos[2]+10-actionMargin,box[1],box[2],tocolor(25,25,25,255),postGUI)
			dxDrawRectangle(pos[1]+10-actionMargin,pos[2]+10-actionMargin +box[2],box[1],1,tocolor(129, 99, 191,255),postGUI)
			
			for i = 1,actionSlots do
				local left = pos[1]+10-itemSize-actionMargin +(i*(itemSize+actionMargin));
				local hover = func.inBox(left+1, pos[2]+10+1, itemSize-2, itemSize-2);
				if hover then cache.actionbar.hover.slot = i end
				if ((not isCursorShowing() and getKeyState(i)) or hover) then
					dxDrawRectangle(left,pos[2]+10,itemSize,itemSize,tocolor(129, 99, 191,255),postGUI);
				else
					dxDrawRectangle(left,pos[2]+10,itemSize,itemSize,tocolor(29,29,29,255),postGUI);
				end
				if actionBarCache[i] then
					if cache.actionbar.movedSlot ~= i then
						dxDrawImage(left+1, pos[2]+10+1, itemSize-2, itemSize-2,cache.actionbar.slot.noitem, 0, 0, 0, tocolor(255, 255, 255, 255),postGUI);
						
						if hover then
							cache.actionbar.moveX = pos[1]+10-itemSize-actionMargin +(i*(itemSize+actionMargin))
							cache.actionbar.moveY = pos[2]+10
						end
						
					end
					if playerCache[localPlayer] and playerCache[localPlayer][getTypeElement(localPlayer,actionBarCache[i][2])[1]] then
						for k = 1, row * column do
							if (playerCache[localPlayer][getTypeElement(localPlayer,actionBarCache[i][2])[1]][k]) and playerCache[localPlayer][getTypeElement(localPlayer,actionBarCache[i][2])[1]][k]["id"] == actionBarCache[i][1] then
								local id = playerCache[localPlayer][getTypeElement(localPlayer,actionBarCache[i][2])[1]][k]["id"];
								local item = playerCache[localPlayer][getTypeElement(localPlayer,actionBarCache[i][2])[1]][k]["item"];
								local value = tostring(playerCache[localPlayer][getTypeElement(localPlayer,actionBarCache[i][2])[1]][k]["value"]);
								local count = playerCache[localPlayer][getTypeElement(localPlayer,actionBarCache[i][2])[1]][k]["count"];
								local state = playerCache[localPlayer][getTypeElement(localPlayer,actionBarCache[i][2])[1]][k]["state"];
								local weaponserial = playerCache[localPlayer][getTypeElement(localPlayer,actionBarCache[i][2])[1]][k]["weaponserial"];
								if cache.actionbar.movedSlot ~= i then
									if getTypeElement(localPlayer,actionBarCache[i][2])[1] == "bag" and (cache.inventory.active.weapon == k or cache.inventory.active.ammo == k) then
										--dxDrawImage(left-4,pos[2]+10-4,itemSize+8,itemSize+8,"files/used_green.png",0,0,0,tocolor(255,255,255,200));
									end
									if hover then
										if not cache.actionbar.itemMove then
											cache.actionbar.moveX = pos[1]+10-itemSize-actionMargin +(i*(itemSize+actionMargin))
											cache.actionbar.moveY = pos[2]+10
										end
										cache.actionbar.hoverItem = actionBarCache[i];
										cache.actionbar.hoverInventoryItem = playerCache[localPlayer][getTypeElement(localPlayer,actionBarCache[i][2])[1]][k];
										func.toolTip(unpack(getItemTooltip(id,item,value,count,state,weaponserial)));
									end
									dxDrawImage(left, pos[2]+10, itemSize, itemSize, getItemImage(item,value), 0, 0, 0, tocolor(255, 255, 255, 255),postGUI);
									----------------- AZ ACTIONBARON LÉVŐ DARAB SZÁM MEGJELENÍTÉSÉRE SZOLGÁL----
									dxDrawText(count,left+itemSize-2-1,pos[2]+11-1,left+itemSize-2-1,pos[2]+11-1,tocolor(0,0,0,255),0.42,cache.font.roboto,"right","top",false,false,postGUI);
									dxDrawText(count,left+itemSize-2,pos[2]+11,left+itemSize-2,pos[2]+11,tocolor(255,255,255,255),0.42,cache.font.roboto,"right","top",false,false,postGUI);
									if hover then
										dxDrawRectangle(left, pos[2]+10, itemSize, itemSize,tocolor(0,0,0,120),postGUI);
									end
								end
							end
						end
					end
				end 
			end
			
			if cache.actionbar.itemMove then
				if isCursorShowing() then    
					local x, y = func.getCursorPosition()
					cache.actionbar.moveX,cache.actionbar.moveY = x - cache.actionbar.defX,y - cache.actionbar.defY
				else
					cache.actionbar.moveX,cache.actionbar.moveY = 0,0
				end
				dxDrawImage(cache.actionbar.moveX,cache.actionbar.moveY,itemSize,itemSize,cache.actionbar.slot.movedimg);
			end
			
		end
	end
end
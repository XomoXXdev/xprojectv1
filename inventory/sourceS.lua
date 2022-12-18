func = {};
func.dbConnect = exports["Pcore"];
func.actionbar = {};
func.trash = {};
func.frisk = {};
func.safe = {};
itemCache = {};
actionBarCache = {};
weapons = {};
trashCache = {};
safeCache = {};
ThreadClass = {
	name = "thread";
	perElements = 5000;
	perElementsTick = 50;
	threadCount = 1;
	threadElements = {};
	callback = nil;
	funcArgs = {};
	state = false;
}

function ThreadClass:new(o)
	o = o or {};
	o.threadCount = 1;
	o.threadElements = {};
	setmetatable(o, self);
	self.__index = self;
	return o;
end

function ThreadClass:setMaxElement(m)
	self.perElements = m;
end

function ThreadClass:foreach(elements, func, callback, ...)
	if self.state and #elements > 0 then
		outputDebugString("New thread for " .. self.name);
		return ThreadClass:new({name = self.name, perElements = self.perElements, perElementsTick = self.perElementsTick}):foreach(elements, func, callback, ...);
	end
	self.state = true;
	self.callback = callback;
	self.funcArgs = {...};
	for i, v in ipairs(elements) do
		if not self.threadElements[self.threadCount] then
			self.threadElements[self.threadCount] = {};
		end
		table.insert(self.threadElements[self.threadCount], function()
			if(#self.funcArgs > 0)then
				func(v, unpack(self.funcArgs));
			else
				func(v);
			end
		end);
		
		if (#self.threadElements[self.threadCount] >= self.perElements or i == #elements) then
			self.threadCount = self.threadCount + 1;
		end
	end
	
	return self:resume();
end

function ThreadClass:resume()
	if(self.threadCount>0) then
		local state, result = coroutine.resume(coroutine.create(function()
			if self.threadElements[self.threadCount] then
				for j, k in ipairs(self.threadElements[self.threadCount]) do
					k();
				end
			end
		end));
		self.threadCount = self.threadCount - 1;
		if not state then
			outputDebugString("[Thread - " .. self.name .. "] Error: " .. result, 0, 255, 0, 0);
		end
		if self.perElementsTick >= 50 then
			setTimer(function()
				self:resume();
			end, self.perElementsTick, 1);
		else
			self:resume();
		end
	else
		if(self.callback)then
			if(#self.funcArgs > 0)then
				self.callback(v, unpack(self.funcArgs));
			else
				self.callback(v);
			end
		end
		self.state = false;
	end
	
	return self;
end

function newThread(n, per, tick)
	return ThreadClass:new({name = n or "threading", perElements = per or 5000, perElementsTick = tick or 50});
end

func.getElementID = function(element)
	return getElementData(element,getElementType(element)..":dbid");
end

func.start = function()
	setWeaponProperty("deagle", "pro", "maximum_clip_ammo", 17)
	setWeaponProperty("deagle", "std", "maximum_clip_ammo", 17)
	setWeaponProperty("deagle", "poor", "maximum_clip_ammo", 17)

	setWeaponProperty("deagle", "pro", "accuracy", 2)
	setWeaponProperty("deagle", "std", "accuracy", 2)
	setWeaponProperty("deagle", "poor", "accuracy", 2)

	takeAllWeapons(getRootElement())
	
	local Thread = newThread("items", 3000, 50);
    dbQuery(function(qh)
        local loadedItems = 0
		local res, rows, err = dbPoll(qh, 0);
        if rows > 0 then
            local tick = getTickCount();
            Thread:foreach(res, function(row)
                local owner = tonumber(row["owner"]);
                if not itemCache[owner] then
                    itemCache[owner] = {
						["bag"] = {},
						["key"] = {},
						["licens"] = {},
						["vehicle"] = {},
						["object"] = {},
					};
                end
                itemCache[owner][tostring(row["type"])][tonumber(row["slot"])] = {
                    ["id"] = tonumber(row["id"]),
					["slot"] = tonumber(row["slot"]),
                    ["item"] = tonumber(row["item"]),
                    ["value"] = tostring(row["value"]),
                    ["count"] = tonumber(row["count"]),
					["duty"] = tonumber(row["dutyitem"]),
                    ["state"] = tonumber(row["state"]),
					["weaponserial"] = tostring(row["weaponserial"]),
				}
				
				if itemCache[owner][tostring(row["type"])][tonumber(row["slot"])] then
					local player = func.getPlayerElementById(owner);
					if player then
						if weaponCache[itemCache[owner][tostring(row["type"])][tonumber(row["slot"])]["item"]] and weaponCache[itemCache[owner][tostring(row["type"])][tonumber(row["slot"])]["item"]].isBack then
							attachWeapon(player,itemCache[owner][tostring(row["type"])][tonumber(row["slot"])]["item"],itemCache[owner][tostring(row["type"])][tonumber(row["slot"])]["id"],itemCache[owner][tostring(row["type"])][tonumber(row["slot"])]["value"])
						end
						triggerClientEvent(player,"refreshItem",player,player,itemCache[owner][tostring(row["type"])][tonumber(row["slot"])],"create")
					end
					loadedItems = loadedItems+1
				end
            end, function()
                if rows > 0 then
					outputDebugString("[ITEMS] "..loadedItems.." item in "..(getTickCount()-tick).."ms!");
					
					for k,safe in ipairs(getElementsByType("object")) do
						if getElementData(safe,"object:dbid") then
							setElementData(safe,"inventory:items",func.getItems(safe));
						end
					end

					for k,vehicle in ipairs(getElementsByType("vehicle")) do
						if getElementData(vehicle,"object:dbid") then
							setElementData(vehicle,"inventory:items",func.getItems(vehicle));
						end
					end

                end
            end)
        end
    end,func.dbConnect:getConnection(), "SELECT * FROM `items`"); 
	
end
addEventHandler("onResourceStart",resourceRoot,func.start)

func.getPlayerElementById = function(dbid)
	for k,v in pairs(getElementsByType("player")) do
		local id = func.getElementID(v);
		if id and id == dbid then
			return v;
		end
	end
	return nil;
end

func.getElementById = function(element,dbid)
	for k,v in pairs(getElementsByType(element)) do
		local id = func.getElementID(v);
		if id and id == dbid then
			return v;
		end
	end
	return nil;
end

function syncItems(element)
	if getElementData(element,"vehicle:dbid") or (getElementData(element,"object:dbid") and getElementModel(element) == 2332) then
		local id = func.getElementID(element);
		setElementData(element,"inventory:items",itemCache[id]);
	end
end



func.generateDate = function()
	local realTime = getRealTime() 

    local date = {(realTime.year)+1900,(realTime.month)+1,realTime.monthday,realTime.hour,realTime.minute,realTime.second} 
	
	if date[2] < 10 then
		date[2] = "0"..date[2]
	end
	if date[3] < 10 then
		date[3] = "0"..date[3]
	end
	
	return date[1].."."..date[2].."."..date[3].."."
end

local monthDays = {
	[1] = 31, -- jan
	[2] = 28, -- feb
	[3] = 31, -- márc
	[4] = 30, -- ápr
	[5] = 31, -- máj
	[6] = 30, -- jún
	[7] = 31, -- júl
	[8] = 31, -- aug
	[9] = 30, -- szept
	[10] = 31, -- okt
	[11] = 30, -- nov
	[12] = 31, -- dec
}

func.generateLastday = function()
	local realTime = getRealTime()
	local year, month, day = realTime.year + 1900, realTime.month + 1, realTime.monthday
	if day+28 > monthDays[month] then
		if month+1 > 12 then
			year = year + 1
			month = month - 11
		else
			month = month + 1
		end
	else
		day = day + 28
	end
	if day > monthDays[month] then
		day = monthDays[month]
	elseif month > 12 then
		month = 12
	end
	if month < 10 then
		month = "0"..month
	end
	if day < 10 then
		day = "0"..day
	end
	return year.."."..month.."."..day.."."
end

func.checkBuggedItems = function(playerSource)
	local owner = func.getElementID(playerSource);
	dbQuery(function(qh,playerSource)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			local bugged = 0;
			local fixed = 0;
			for k, row in pairs(res) do
				if row.type == "vehicle" or row.type == "object" then
					-- ide majd valami extra megoldás kell
				else
					if (not itemCache[owner][row.type][row.slot]) or (itemCache[owner][row.type][row.slot] and itemCache[owner][row.type][row.slot].item ~= row.item) then
						bugged = bugged+1
						local _,newSlot = getFreeSlot(playerSource,tonumber(row.item))
						itemCache[owner][row.type][newSlot] = {
							["id"] = tonumber(row.id), 
							["slot"] = newSlot,
							["item"] = tonumber(row.item),
							["value"] = tostring(row.value),
							["count"] = tonumber(row.count),
							["duty"] = tonumber(row.dutyitem),
							["state"] = tonumber(row.state),
							["weaponserial"] = tostring(row.weaponserial),
						}
						if itemCache[owner][row.type][newSlot] then
							fixed = fixed+1;
						end
						dbExec(func.dbConnect:getConnection(),"UPDATE `items` SET `slot` = ? WHERE `id` = ?",newSlot,tonumber(row.id))
						if weaponCache[tonumber(row.item)] and weaponCache[tonumber(row.item)].isBack then
							attachWeapon(playerSource,tonumber(row.item),tonumber(row.id),tonumber(row.value))
						end
						triggerClientEvent(playerSource,"refreshItem",playerSource,playerSource,itemCache[owner][row.type][newSlot],"create")
					end
				end
			end
			if bugged > 0 then
				outputChatBox("#8163bf[xProject]:#ffffff Neked #8163bf"..bugged.."#ffffff hibás tárgyad volt. Ebből #8163bf"..fixed.."#ffffff lett visszaállítva.",playerSource,220,20,60,true);
			end
		end
	end,{playerSource},func.dbConnect:getConnection(), "SELECT * FROM `items` WHERE `owner` = ?",owner);
end
addEvent("checkBuggedItems",true)
addEventHandler("checkBuggedItems",getRootElement(),func.checkBuggedItems)

func.checkPlayerInventory = function(playerSource,cmd,target)
	if getElementData(playerSource,"player:admin") >= 7 then
		if target then
			local targetPlayer,targetPlayerName = exports["Pcore"]:findPlayerByPartialNick(playerSource,target);
			if targetPlayer then
				if getElementData(targetPlayer,"player:loggedIn") then
					outputChatBox("#8163bf[xProject]:#ffffff Sikeresen lecsekkoltattad az elbuggolt itemjeit #8163bf"..getElementData(targetPlayer,"player:charname").."#ffffff -nak/nek.",playerSource,220,20,60,true)
					func.checkBuggedItems(targetPlayer);
				else
					outputChatBox("#8163bf[xProject]:#ffffff A kiválaszott játékos nincs bejelentkezve.",playerSource,220,20,60,true)
				end
			end
		else
			outputChatBox("Használat:#e7d9b0 /"..cmd.." [ID/Név]",playerSource,0,206,209,true)
		end
	end
end
addCommandHandler("checkinventory",func.checkPlayerInventory)

func.stop = function()
	for k,v in ipairs(getElementsByType("vehicle")) do
		if getElementData(v,"veh:use") then
			setElementData(v,"veh:use",false)
			setElementData(v,"veh:player",nil)
			func.doorState(v,0)
		end
	end
end
addEventHandler("onResourceStop",resourceRoot,func.stop)

func.getItems = function(element,value)
	local owner = func.getElementID(element);
	if value == 1 or value == 2 then
		triggerClientEvent(source,"setItems",source,element,value,itemCache[owner])
	else
		return itemCache[owner]
	end
end
addEvent("getItems",true)
addEventHandler("getItems",getRootElement(),func.getItems)

func.setItemCache = function(playerSource)
	local owner = func.getElementID(playerSource);
	if not getElementData(playerSource,"show:inv") then
		triggerClientEvent(playerSource,"setItems",playerSource,playerSource,2,itemCache[owner])
	end
end

func.updateSlot = function(element,oldSlot,newSlot,data)
	local owner = func.getElementID(element);
	if itemCache[owner][getTypeElement(element,data["item"])[1]][oldSlot] then
		dbExec(func.dbConnect:getConnection(),"UPDATE `items` SET `slot` = ? WHERE `id` = ?",newSlot,data["id"])
		itemCache[owner][getTypeElement(element,data["item"])[1]][newSlot] = {
			["id"] = data["id"],
			["slot"] = newSlot,
			["item"] = data["item"],
			["value"] = data["value"],
			["count"] = data["count"],
			["duty"] = data["duty"],
			["state"] = data["state"],
			["weaponserial"] = data["weaponserial"],
		}
		itemCache[owner][getTypeElement(element,data["item"])[1]][oldSlot] = nil
		syncItems(element);
	end
end
addEvent("updateSlot",true)
addEventHandler("updateSlot",getRootElement(),func.updateSlot)

function setItemCount(element,data,count,state,playerSource)
	local owner = func.getElementID(element);
	if itemCache[owner][getTypeElement(element, data["item"])[1]][data["slot"]] then
		dbExec(func.dbConnect:getConnection(),"UPDATE `items` SET `count` = ? WHERE `id` = ?",count,data["id"]);
		itemCache[owner][getTypeElement(element, data["item"])[1]][data["slot"]]["count"] = count;
		if state then
			if playerSource then
				triggerClientEvent(playerSource,"refreshItem",playerSource,element,itemCache[owner][getTypeElement(element, data["item"])[1]][data["slot"]],"create")
			else
				triggerClientEvent(element,"refreshItem",element,element,itemCache[owner][getTypeElement(element, data["item"])[1]][data["slot"]],"create")
			end
		end
		syncItems(element);
	end
end
addEvent("setItemCount",true)
addEventHandler("setItemCount",getRootElement(),setItemCount)

function setItemValue(element,data,value,state,playerSource)
	local owner = func.getElementID(element);
	if itemCache[owner][getTypeElement(element, data["item"])[1]][data["slot"]] then
		dbExec(func.dbConnect:getConnection(),"UPDATE `items` SET `value` = ? WHERE `id` = ?",value,data["id"]);
		itemCache[owner][getTypeElement(element, data["item"])[1]][data["slot"]]["value"] = value;
		if state then
			if playerSource then
				triggerClientEvent(playerSource,"refreshItem",playerSource,element,itemCache[owner][getTypeElement(element, data["item"])[1]][data["slot"]],"create")
			else
				triggerClientEvent(element,"refreshItem",element,element,itemCache[owner][getTypeElement(element, data["item"])[1]][data["slot"]],"create")
			end
		end
		syncItems(element);
	end
end
addEvent("setItemValue",true)
addEventHandler("setItemValue",getRootElement(),setItemValue)

function setItemState(element,data,state)
	local owner = func.getElementID(element);
	if itemCache[owner][getTypeElement(element, data["item"])[1]][data["slot"]] then
		dbExec(func.dbConnect:getConnection(),"UPDATE `items` SET `state` = ? WHERE `id` = ?",state,data["id"]);
		itemCache[owner][getTypeElement(element, data["item"])[1]][data["slot"]]["state"] = state;
		syncItems(element);
	end
end
addEvent("setItemState",true)
addEventHandler("setItemState",getRootElement(),setItemState)

function createStackedItem(element, slot, data, count)
    giveItem(source, tonumber(data["item"]),tostring(data["value"]),tonumber(count),tonumber(data["duty"]),tonumber(data["state"]),slot,tostring(data["weaponserial"]),element);
end
addEvent("createStackedItem",true)
addEventHandler("createStackedItem",getRootElement(),createStackedItem)

func.itemTransfer = function(element,movedElement,data,weaponProgress)
	local playerOwner = func.getElementID(source);
	local elementOwner = func.getElementID(element);
	local movedOwner = func.getElementID(movedElement);
	if source ~= element and source ~= movedElement then
		return
	end
	if itemCache[elementOwner][getTypeElement(element,tonumber(data.item))[1]][tonumber(data["slot"])] then
		local weight = getElementItemsWeight(movedElement)
		if weight + (getItemWeight(data.item) * data.count) > getTypeElement(movedElement,data.item)[3] then
			outputChatBox("#8163bf[xProject]:#ffffff A kiválaszott elem inventoryja nem bír el több tárgyat.", source,220,20,60, true)
			return
		end
		
		local state,slot = getFreeSlot(movedElement,data.item);
		if state then
			dbExec(func.dbConnect:getConnection(),"UPDATE `items` SET `slot` = ?, `type` = ?, `owner` = ? WHERE `id` = ?",tonumber(slot),getTypeElement(movedElement,tonumber(data.item))[1],movedOwner,tonumber(data["id"]));
			itemCache[movedOwner][getTypeElement(movedElement,tonumber(data.item))[1]][tonumber(slot)] = {
				["id"] = tonumber(data["id"]),
				["slot"] = tonumber(slot),
				["item"] = tonumber(data.item),
				["value"] = tostring(data["value"]),
				["count"] = tonumber(data["count"]),
				["duty"] = tonumber(data["duty"]),
				["state"] = tonumber(data["state"]),
				["weaponserial"] = tostring(data["weaponserial"]),
			};
			itemCache[elementOwner][getTypeElement(element,tonumber(data.item))[1]][tonumber(data["slot"])] = nil;
			if getElementType(movedElement) == "player" and movedElement ~= source then
				if weaponCache[data.item] and weaponCache[data.item].isBack then
					detachWeapon(source,data.item,data.id)
					attachWeapon(movedElement,data.item,data.id,data.value)
				end

				exports["Pchat"]:takeMessage(source,"me","átadott egy tárgyat "..getElementData(movedElement,"player:charname").." -nak/nek. ("..getItemName(data.item)..")")
				setPedAnimation(source,"DEALER","DEALER_DEAL",3000,false,false,false,false)
				setPedAnimation(movedElement,"DEALER","DEALER_DEAL",3000,false,false,false,false)
				triggerClientEvent(movedElement,"refreshItem",movedElement,movedElement,itemCache[movedOwner][getTypeElement(movedElement,tonumber(data.item))[1]][tonumber(slot)],"create",weaponProgress)
			elseif getElementType(movedElement) == "vehicle" and movedElement ~= source then
				exports["Pchat"]:takeMessage(source,"me","berakott egy tárgyat a jármű csomagtartójába. ("..getItemName(data.item)..")")
				if weaponCache[data.item] and weaponCache[data.item].isBack then
					detachWeapon(source,data.item,data.id)
				end
				setElementData(movedElement,"inventory:items",itemCache[movedOwner]);
			elseif getElementType(element) == "vehicle" and movedElement == source then
				exports["Pchat"]:takeMessage(source,"me","kivett egy tárgyat a jármű csomagtartójából. ("..getItemName(data.item)..")")
				triggerClientEvent(source,"refreshItem",source,source,itemCache[movedOwner][getTypeElement(source,tonumber(data.item))[1]][tonumber(slot)],"create")
				if weaponCache[data.item] and weaponCache[data.item].isBack then
					attachWeapon(movedElement,data.item,data.id,data.value)
				end
				setElementData(element,"inventory:items",itemCache[elementOwner]);
			elseif getElementType(movedElement) == "object" and movedElement ~= source then
				exports["Pchat"]:takeMessage(source,"me","berakott egy tárgyat a széfbe. ("..getItemName(data.item)..")")
				if weaponCache[data.item] and weaponCache[data.item].isBack then
					detachWeapon(source,data.item,data.id)
				end
				setElementData(movedElement,"inventory:items",itemCache[movedOwner]);
			elseif getElementType(element) == "object" and movedElement == source then
				exports["Pchat"]:takeMessage(source,"me","kivett egy tárgyat a széfből. ("..getItemName(data.item)..")")
				triggerClientEvent(source,"refreshItem",source,source,itemCache[movedOwner][getTypeElement(source,tonumber(data.item))[1]][tonumber(slot)],"create")
				if weaponCache[data.item] and weaponCache[data.item].isBack then
					attachWeapon(movedElement,data.item,data.id,data.value)
				end
				setElementData(element,"inventory:items",itemCache[elementOwner]);
			end
			triggerClientEvent(source,"refreshItem",source,element,data,"delete",data["id"])
		else
			outputChatBox("#8163bf[xProject]:#ffffff A kiválasztott elem inventoryjában nincs több szabad slot.",source,220,20,60,true);
		end
	end
end
addEvent("itemTransfer",true)
addEventHandler("itemTransfer",getRootElement(),func.itemTransfer)

function deleteItem(element,data,state,playerSource)
	local owner = func.getElementID(element);
	dbExec(func.dbConnect:getConnection(),"DELETE FROM `items` WHERE `id` = ?",data["id"])
	if getElementType(element) == "player" and weaponCache[data.item] and weaponCache[data.item].isBack then
		detachWeapon(element,data.item,data.id)
	end
	itemCache[owner][getTypeElement(element,tonumber(data["item"]))[1]][tonumber(data["slot"])] = nil;
	syncItems(element);
	if state then
		if playerSource then
			triggerClientEvent(playerSource,"refreshItem",playerSource,element,data,"delete")
		else
			triggerClientEvent(element,"refreshItem",element,element,data,"delete")
		end
	end
end
addEvent("deleteItem",true)
addEventHandler("deleteItem",getRootElement(),deleteItem)

function hasItem(element,item,value)
	local owner = func.getElementID(element);
	if not itemCache[owner] then
		itemCache[owner] = {
			["bag"] = {},
			["key"] = {},
			["licens"] = {},
			["vehicle"] = {},
			["object"] = {},
		}
	end
	
	for i=1, row*column do
		if itemCache[owner][getTypeElement(element,item)[1]][i] then
			if not value then
				if itemCache[owner][getTypeElement(element,item)[1]][i]["item"] == item then
					return true,i,itemCache[owner][getTypeElement(element,item)[1]][i];
				end
			else
				if itemCache[owner][getTypeElement(element,item)[1]][i]["item"] == item and tonumber(itemCache[owner][getTypeElement(element,item)[1]][i]["value"]) == tonumber(value) then
					return true,i,itemCache[owner][getTypeElement(element,item)[1]][i];
				end
			end
		end
	end
	return false,-1,nil
end

function takeItem(element,item)
	local owner = func.getElementID(element);
	local showElement = getElementData(element,"veh:player") or getElementData(element,"safe:player")
	if not itemCache[owner] then
		itemCache[owner] = {
			["bag"] = {},
			["key"] = {},
			["licens"] = {},
			["vehicle"] = {},
			["object"] = {},
		}
	end
	local count = 0
	if itemCache[owner][getTypeElement(element,item)[1]] then
		for i = 1, row * column do
			if itemCache[owner][getTypeElement(element,item)[1]][i] then
				if itemCache[owner][getTypeElement(element,item)[1]][i]["item"] == item then
					count = count+1
					if count == 1 then
						if itemCache[owner][getTypeElement(element,item)[1]][i]["count"] > 1 then
							setItemCount(element,itemCache[owner][getTypeElement(element,item)[1]][i],itemCache[owner][getTypeElement(element,item)[1]][i]["count"]-1,true,showElement);
						else
							deleteItem(element,itemCache[owner][getTypeElement(element,item)[1]][i],true,showElement);
						end
					end
				end
			end
		end
		syncItems(element);
	end
end

function takeAllItem(item,value)
	value = tonumber(value)

	for owner,k in pairs(itemCache) do
		for category,k2 in pairs(itemCache[owner]) do
			for slot,itemData in pairs(itemCache[owner][category]) do
				if itemData.item == item and tonumber(itemData.value) == value then
					if itemCache[owner][category][slot] then
						dbExec(func.dbConnect:getConnection(),"DELETE FROM `items` WHERE `id` = ?",itemData.id)
						local selectedtype = category;
						if category == "bag" or category == "key" or category == "licens" then
							selectedtype = "player";
						end
						local founded,element = func.getTypeByOwner(selectedtype,owner);
						if founded then
							local selectedElement = element;
							if selectedtype == "vehicle" or selectedtype == "object" then
								selectedElement = getElementData(element,"veh:player") or getElementData(element,"safe:player");
								if not selectedElement then selectedElement = element end
							end
							triggerClientEvent(selectedElement,"refreshItem",selectedElement,element,itemCache[owner][category][slot],"delete")
							itemCache[owner][category][slot] = nil;
							syncItems(element);
						else
							itemCache[owner][category][slot] = nil;
						end
					end
				end
			end
		end
	end
end

func.getTypeByOwner = function(typ,dbid)
	for k,v in ipairs(getElementsByType(typ)) do
		if func.getElementID(v) == dbid then
			return true,v;
		end
	end
	return false,nil;
end

func.findElementByDbid = function(dbid)
	for k,v in ipairs(getElementsByType("player")) do
		if func.getElementID(v) == dbid then
			return v;
		end
	end
	return nil;
end

func.takePlayerItem = function(playerSource,cmd,target,item)
	if getElementData(playerSource,"player:admin") >= 7 then
		item = tonumber(item);
		if type(item) == "number" and target then
			if getElementData(playerSource,"player:loggedIn") then
				local targetPlayer,targetPlayerName = exports["Pcore"]:findPlayerByPartialNick(playerSource,target)
				if targetPlayer then
					if hasItem(targetPlayer,tonumber(item)) then
						takeItem(targetPlayer,tonumber(item))
						outputChatBox("#8163bf[xProject]:#ffffff Sikeresen elvettél #8163bf"..getElementData(targetPlayer,"player:charname").."#ffffff -tól/től egy #8163bf"..getItemName(item).."#ffffff -t.",playerSource,220,20,60,true)
						outputChatBox("#8163bf[xProject]:#ffffff #8163bf"..getElementData(playerSource,"player:adminname").."#ffffff elvett tőled egy #8163bf"..getItemName(item).."#ffffff -t.",targetPlayer,220,20,60,true)
					else
						outputChatBox("#8163bf[xProject]:#ffffff A kiválaszott játékosnál nincs ilyen item.",playerSource,220,20,60,true)
					end
				end
			else
				outputChatBox("#8163bf[xProject]:#ffffff A kiválasztott játékos nincs bejelentkezve.",playerSource,220,20,60,true)
			end
		else
			outputChatBox("Használat:#e7d9b0 /"..cmd.." [ID/Név] [item]",playerSource,0,206,209,true)
		end
	end
end
addCommandHandler("takeitem",func.takePlayerItem)

--[[addCommandHandler("asdasd2",function(playerSource)
	for k,v in ipairs(getElementsByType("vehicle")) do
		if func.getElementID(v)and func.getElementID(v) == 1 then
			takeItem(v,32)
		end
	end
end)]]

function getFreeSlot(element,item)
    local owner = func.getElementID(element);
	if not itemCache[owner] then
		itemCache[owner] = {
			["bag"] = {},
			["key"] = {},
			["licens"] = {},
			["vehicle"] = {},
			["object"] = {},
		}
	end

	for i=1, row*column do
		if(not itemCache[owner][getTypeElement(element,item)[1]][i])then
			return true, i
		end
	end
	return false, -1
end

function getElementItemsWeight(element)
	local owner = func.getElementID(element);
	if not itemCache[owner] then
		itemCache[owner] = {
			["bag"] = {},
			["key"] = {},
			["licens"] = {},
			["vehicle"] = {},
			["object"] = {},
		}
	end
	local bagWeight = 0
	local keyWeight = 0
	local licensWeight = 0
	local vehWeight = 0
	local objectWeight = 0
	if getElementType(element) == "player" then
		for i = 1, row * column do
			if (itemCache[owner]["bag"][i]) then
				bagWeight = bagWeight + (getItemWeight(itemCache[owner]["bag"][i]["item"]) * itemCache[owner]["bag"][i]["count"])
			end
		end
		for i = 1, row * column do
			if (itemCache[owner]["key"][i]) then
				keyWeight = keyWeight + (getItemWeight(itemCache[owner]["key"][i]["item"]) * itemCache[owner]["key"][i]["count"])
			end													
		end
		for i = 1, row * column do
			if (itemCache[owner]["licens"][i]) then
				licensWeight = licensWeight + (getItemWeight(itemCache[owner]["licens"][i]["item"]) * itemCache[owner]["licens"][i]["count"])
			end	
		end
	end
	if getElementType(element) == "vehicle" then
		for i = 1, row * column do
			if (itemCache[owner]["vehicle"][i]) then
				vehWeight = vehWeight + (getItemWeight(itemCache[owner]["vehicle"][i]["item"]) * itemCache[owner]["vehicle"][i]["count"])
			end	
		end
	end
	if getElementType(element) == "object" then
		for i = 1, row * column do
			if (itemCache[owner]["object"][i]) then
				objectWeight = objectWeight + (getItemWeight(itemCache[owner]["object"][i]["item"]) * itemCache[owner]["object"][i]["count"])
			end	
		end
	end
	return math.ceil(bagWeight + licensWeight + keyWeight + vehWeight + objectWeight)
end

function giveItem(playerSource,item,value,count,dutyitem,state,slot,weaponserial,element)
	if not dutyitem then
		dutyitem = 0;
	end
	local newSlot = -1;
	if weaponCache[item] then
		weaponserial = weaponserial or generateSerial();
	else
		if item == 127 then
			weaponserial = weaponserial;
		else
			weaponserial = "Unknown";
		end
	end
	element = element or playerSource
	
	if not state then
		state = 100;
	end
	
	if not slot then
		_,newSlot = getFreeSlot(element,item)
	else
		newSlot = slot
	end
	
	
	
	
	dbQuery(function(query,playerSource,element)
        local _, _, id = dbPoll(query, 0);
        if id > 0 then
            local owner = func.getElementID(element);
			if not itemCache[owner] then
				itemCache[owner] = {
					["bag"] = {},
					["key"] = {},
					["licens"] = {},
					["vehicle"] = {},
					["object"] = {},
				}
			end
			
			if not slot then
				_,newSlot = getFreeSlot(element,item)
			else
				newSlot = slot
			end

			if item == 120 then
				local data = {
					num1 = 127056;
					num2 = id;
					charid = owner;
					money = 0;
					pincode = 1234;
					used = false;
				};

				value = toJSON(data);
			else
				value = value;
			end

			
			itemCache[owner][getTypeElement(element,item)[1]][newSlot] = {
				["id"] = id,
				["slot"] = newSlot,
				["item"] = item,
				["value"] = value,
				["count"] = count,
				["duty"] = dutyitem,
				["state"] = state,
				["weaponserial"] = weaponserial,
			}
			syncItems(element);
			dbExec(func.dbConnect:getConnection(),"UPDATE `items` SET `slot` = ?, `value` = ? WHERE `id` = ?",newSlot,value,id)
			if playerSource == element then
				if weaponCache[item] and weaponCache[item].isBack then
					attachWeapon(element,item,id,value)
				end
			end
			triggerClientEvent(playerSource,"refreshItem",playerSource,element,itemCache[owner][getTypeElement(element,item)[1]][newSlot],"create")
		end
    end,{playerSource,element},func.dbConnect:getConnection(), "INSERT INTO items SET `item` = ?, `slot` = ?, `value` = ?, `count` = ?, `dutyitem` = ?, `type` = ?, `state` = ?, `weaponserial` = ?, `owner` = ?",item,newSlot,value,count,dutyitem,getTypeElement(element,item)[1],state,weaponserial,func.getElementID(element));
	
end
addEvent("giveItem",true)
addEventHandler("giveItem",getRootElement(),giveItem)

function setCardMoney(playerSource,slot,newMoney)
	local owner = func.getElementID(playerSource);
	if itemCache[owner]["licens"][slot] then
		local jsonData = fromJSON(itemCache[owner]["licens"][slot].value);
		if jsonData.money ~= newMoney then
			jsonData.money = newMoney;
			local newValue = toJSON(jsonData);
			setItemValue(playerSource,itemCache[owner]["licens"][slot],newValue,true);
		end
	end
end
addEvent("setCardMoneyS",true)
addEventHandler("setCardMoneyS",getRootElement(),setCardMoney)

function transferCardMoney(owner,slot,amount)
	if itemCache[owner]["licens"][slot] then
		local jsonData = fromJSON(itemCache[owner]["licens"][slot].value);
		jsonData.money = jsonData.money + amount;
		local newValue = toJSON(jsonData);
		itemCache[owner]["licens"][slot].value = newValue;
		dbExec(func.dbConnect:getConnection(),"UPDATE `items` SET `value` = ? WHERE `id` = ?",newValue,itemCache[owner]["licens"][slot].id)
		local element = func.findElementByDbid(owner);
		if element then
			triggerClientEvent(element,"refreshItem",element,element,itemCache[owner]["licens"][slot],"create")
		end
	end
end

function setCardPinCode(playerSource,slot,newPin)
	local owner = func.getElementID(playerSource);
	if itemCache[owner]["licens"][slot] then
		local jsonData = fromJSON(itemCache[owner]["licens"][slot].value);
		if jsonData.pincode ~= newPin then
			jsonData.pincode = newPin;
			local newValue = toJSON(jsonData);
			setItemValue(playerSource,itemCache[owner]["licens"][slot],newValue,true);
		end
	end
end

function findCard(cardnumber)
	for owner,k in pairs(itemCache) do
		for category,k2 in pairs(itemCache[owner]) do
			for slot,itemData in pairs(itemCache[owner]["licens"]) do
				if itemData.item == 120 and itemCache[owner]["licens"][slot] then
					local cardData = fromJSON(itemCache[owner]["licens"][slot].value);
					local number = cardData.num1.."-"..cardData.num2;
					if number == cardnumber then
						return true,cardData,slot,owner;
					end
				end
			end
		end
	end
	return false,nil,owner;
end

function findPlayerCardsByDbid(dbid)
	local count = 0;
	for owner,k in pairs(itemCache) do
		for slot,itemData in pairs(itemCache[owner]["licens"]) do
			if itemData.item == 120 and itemCache[owner]["licens"][slot] then
				local cardData = fromJSON(itemData.value);
				if cardData.charid == dbid then
					count = count + 1;
				end
			end
		end
	end
	return count;
end

func.setIdentityNewDate = function(playerSource,type,price,itemData)
	local newDate = func.generateLastday();
	setElementData(playerSource,"money",getElementData(playerSource,"money")-price);
	local jsonData = fromJSON(itemData.value)
	if itemData.item == 71 or itemData.item == 262 or itemData.item == 261 then
		jsonData[1] = getElementData(playerSource,"player:charname");
	end
	jsonData[6] = newDate;
	local newValue = toJSON(jsonData)
	setItemValue(playerSource,itemData,newValue,true);
end
addEvent("setIdentityNewDate",true)
addEventHandler("setIdentityNewDate",getRootElement(),func.setIdentityNewDate)

func.givePlayerItem = function(playerSource,cmd,target,item,value,count,dutyitem,itemstate,wserial)
	if getElementData(playerSource,"player:admin") >= 7 then
		if target and item and value and count and dutyitem then
			item = tonumber(item);
			value = tostring(value);
			count = tonumber(count);
			dutyitem = tonumber(dutyitem);
			itemstate = tonumber(itemstate);
			if not itemstate then itemstate = 100 end
			if not wserial then wserial = "Unknown" end
			local targetPlayer,targetPlayerName = exports["Pcore"]:findPlayerByPartialNick(playerSource,target)
			if targetPlayer then
				if getElementData(targetPlayer,"player:loggedIn") then
					if availableItems[item] then
						local state,slot = getFreeSlot(targetPlayer,item)
						if state then
						--	local weight = getElementItemsWeight(targetPlayer)
						--	if weight + (getItemWeight(item) * count) > getTypeElement(targetPlayer,item)[3] then
						--		outputChatBox("#8163bf[xProject]:#ffffff A kiválaszott játékos nem bír el több tárgyat.", playerSource,220,20,60, true)
						--		return
						--	end
							
							if item == 120 then
								--exports["vice_bank"]:createCard(targetPlayer);
							else
							--	if identityItems[item] then
							--		if item == 71 then
							--			value = toJSON({getElementData(targetPlayer,"player:charname"),getElementData(targetPlayer,"age"),weapontype,getElementData(targetPlayer,"height"),func.generateDate(),func.generateLastday()})
							--		else
							--			value = toJSON({getEElementData(targetPlayer,"player:charname"),getElementData(targetPlayer,"age"),getElementData(targetPlayer,"weight"),getElementData(targetPlayer,"height"),func.generateDate(),func.generateLastday()})
							--		end
							--	end
							end
							giveItem(targetPlayer,item,value,count,dutyitem,itemstate,slot,wserial);
							outputChatBox("#8163bf[xProject]:#ffffff Sikeresen adtál #8163bf"..getElementData(targetPlayer,"player:charname").."#ffffff -nak/nek #8163bf"..count.."#ffffff darab #8163bf"..getItemName(item).."#ffffff-t.",playerSource,220,20,60,true)
							outputChatBox("#8163bf[xProject]:#ffffff Sikeresen kaptál #8163bf"..getElementData(playerSource,"player:charname").."#ffffff -től/től #8163bf"..count.."#ffffff darab #8163bf"..getItemName(item).."#ffffff-t.",targetPlayer,220,20,60,true)
						else
							outputChatBox("#8163bf[xProject]:#ffffff A kiválasztott játékosnak nincs több szabad slotja.",playerSource,220,20,60,true)
						end
					else
						outputChatBox("#8163bf[xProject]:#ffffff Hibás item id.",playerSource,220,20,60,true)
					end
				else
					outputChatBox("#8163bf[xProject]:#ffffff A kiválasztott játékos nincs bejelentkezve.",playerSource,220,20,60,true)
				end
			end
		else
			outputChatBox("Használat:#e7d9b0 /"..cmd.." [ID/Név] [item] [értek] [darab] [duty: 0 - nem, 1 - igen]",playerSource,0,206,209,true)
		end
	end
end
addCommandHandler("giveitem",func.givePlayerItem)

func.giveItemSpecial = function(playerSource,cmd,start,over,count,target)
	if getElementData(playerSource,"player:admin") >= 7 then
		if start and over then
			start = tonumber(start);
			over = tonumber(over);
			if not count then
				count = 1;
			end
			count = tonumber(count);

			if not target then
				for k,v in ipairs(getElementsByType("player")) do
					if getElementData(v,"player:loggedIn") then
						for i = start,over do
							giveItem(v,i,1,count,0)
						end
					end
				end
			else
				local targetPlayer,targetPlayerName = exports["Pcore"]:findPlayerByPartialNick(playerSource,target)
				if getElementData(targetPlayer,"player:loggedIn") then
					for i = start,over do
						giveItem(targetPlayer,i,1,count,0)
					end
				end
			end
		else
			outputChatBox("Használat:#e7d9b0 /"..cmd.." [Ciklus start] [Ciklus vége] [darab] [ID/Név]",playerSource,0,206,209,true)
		end
	end
end
addCommandHandler("giveitemspecial",func.giveItemSpecial)

func.achangeLock = function(playerSource,cmd,typ,arg)
	if getElementData(playerSource,"player:admin") >= 7 then
		typ = tostring(typ)
		if typ and typ == "vehicle" or typ == "interior" then
			local item = -1
			local value = -1
			if typ == "vehicle" then
				local vehicle = getPedOccupiedVehicle(playerSource);
				if vehicle then
					local dbid = func.getElementID(vehicle)
					if dbid and dbid > 0 then
						item = 40;
						value = tonumber(dbid);
						outputChatBox("#8163bf[xProject]:#ffffff Sikeresen changelock-oltál egy járművet. #8163bf("..dbid..")",playerSource,220,20,60,true)
					else
						outputChatBox("#8163bf[xProject]:#ffffff Ezt a járművet nem changelock-olhatod.",playerSource,220,20,60,true)
					end
				else
					outputChatBox("#8163bf[xProject]:#ffffff Nem ülsz járműben.",playerSource,220,20,60,true)
				end
			elseif typ == "interior" then
				if getElementData(playerSource, "isInIntMarker") then
					local interior = getElementData(playerSource,"int:Marker")
					if getElementData(interior,"isIntMarker") then
						item = 41;
						value = tonumber(func.getElementID(interior));   
						outputChatBox("#8163bf[xProject]:#ffffff Sikeresen changelock-oltál egy interiort. #8163bf("..func.getElementID(interior)..")", playerSource,220,20,60, true)
					end
				else
					outputChatBox("#8163bf[xProject]:#ffffff Nem állsz interior markerben.",playerSource,220,20,60,true)
				end
			end
			if item > 0 then
				if arg == "all" then
					takeAllItem(item,value)
				end
				giveItem(playerSource,item,value,1,0)
			end
		else
			outputChatBox("Használat:#e7d9b0 /"..cmd.." [tipus: vehicle,interior] [ha mindenkitől elvegye: all]",playerSource,0,206,209,true)
		end
	end
end
addCommandHandler("achangelock",func.achangeLock)

function takeDutyItems(playerSource)
	local categories = {
		["bag"] = true,
		["key"] = true,
		["licens"] = true,
	}
	
	for k,v in pairs(categories) do
		local owner = func.getElementID(playerSource);
		if (itemCache[owner][k]) then
			for i = 1, row * column do
				if itemCache[owner][k][i] and itemCache[owner][k][i].duty == 1 then
					deleteItem(playerSource,itemCache[owner][k][i],true,playerSource);
				end
			end
		end
	end
end

func.dataChange = function(dataName)
	if getElementType(source) == "player" then
		if dataName == "player:loggedIn" then
			if getElementData(source,dataName) then
				local owner = func.getElementID(source);
				if itemCache[owner] and (itemCache[owner]["bag"]) then
					for i = 1, row * column do
						if itemCache[owner]["bag"][i] then
							if weaponCache[itemCache[owner]["bag"][i]["item"]] and weaponCache[itemCache[owner]["bag"][i]["item"]].isBack then
								attachWeapon(source,itemCache[owner]["bag"][i]["item"],itemCache[owner]["bag"][i]["id"],itemCache[owner]["bag"][i]["value"])
							end
						end
					end
				end
			end
		end
	end
end
addEventHandler("onElementDataChange",getRootElement(),func.dataChange)

function attachWeapon(playerSource,item,dbid,value)
	if not weapons[playerSource] then
		weapons[playerSource] = {}
	end
	if not isElement(weapons[playerSource][dbid]) or not weapons[playerSource][dbid] then
		local x,y,z = getElementPosition(playerSource)
		if weaponModels[item] then
			weapons[playerSource][dbid] = createObject(weaponModels[item][1],x,y,z)
			setElementAlpha(weapons[playerSource][dbid],getElementAlpha(playerSource))
			setElementInterior(weapons[playerSource][dbid],getElementInterior(playerSource))
			setElementDimension(weapons[playerSource][dbid],getElementDimension(playerSource))
			setElementData(weapons[playerSource][dbid],"attachedObject",true)

			if tonumber(weaponIndexByID[item]) == 30 and tonumber(value) == 20 then
				exports["weapontuning"]:setObjectPaintjob(weapons[playerSource][dbid],"ak", "ak1")
			elseif tonumber(weaponIndexByID[item]) == 30 and tonumber(value) == 21 then
				exports["weapontuning"]:setObjectPaintjob(weapons[playerSource][dbid],"ak", "ak2")
			elseif tonumber(weaponIndexByID[item]) == 30 and tonumber(value) == 22 then
				exports["weapontuning"]:setObjectPaintjob(weapons[playerSource][dbid],"ak", "ak3")
			elseif tonumber(weaponIndexByID[item]) == 30 and tonumber(value) == 23 then
				exports["weapontuning"]:setObjectPaintjob(weapons[playerSource][dbid],"ak", "ak4")
			elseif tonumber(weaponIndexByID[item]) == 30 and tonumber(value) == 24 then
				exports["weapontuning"]:setObjectPaintjob(weapons[playerSource][dbid],"ak", "ak5")
			elseif tonumber(weaponIndexByID[item]) == 30 and tonumber(value) == 25 then
				exports["weapontuning"]:setObjectPaintjob(weapons[playerSource][dbid],"ak", "ak6")
			elseif tonumber(weaponIndexByID[item]) == 30 and tonumber(value) == 26 then
				exports["weapontuning"]:setObjectPaintjob(weapons[playerSource][dbid],"ak", "ak7")
			end
			if tonumber(weaponIndexByID[item]) == 31 and tonumber(value) == 20 then
				exports["weapontuning"]:setObjectPaintjob(weapons[playerSource][dbid],"m4_v3_d", "m41")
			elseif tonumber(weaponIndexByID[item]) == 31 and tonumber(value) == 21 then
				exports["weapontuning"]:setObjectPaintjob(weapons[playerSource][dbid],"m4_v3_d", "m42")
			elseif tonumber(weaponIndexByID[item]) == 31 and tonumber(value) == 22 then
				exports["weapontuning"]:setObjectPaintjob(weapons[playerSource][dbid],"m4_v3_d", "m43")
			end
			if tonumber(weaponIndexByID[item]) == 24 and tonumber(value) == 20 then
				exports["weapontuning"]:setObjectPaintjob(weapons[playerSource][dbid],"deagle", "deagle1")
			elseif tonumber(weaponIndexByID[item]) == 24 and tonumber(value) == 21 then
				exports["weapontuning"]:setObjectPaintjob(weapons[playerSource][dbid],"deagle", "deagle2")
            elseif tonumber(weaponIndexByID[item]) == 24 and tonumber(value) == 22 then
				exports["weapontuning"]:setObjectPaintjob(weapons[playerSource][dbid],"deagle", "deagle3")
			end
			if tonumber(weaponIndexByID[item]) == 4 and tonumber(value) == 20 then
				exports["weapontuning"]:setObjectPaintjob(weapons[playerSource][dbid],"kabar", "knife1")
			elseif tonumber(weaponIndexByID[item]) == 4 and tonumber(value) == 21 then
				exports["weapontuning"]:setObjectPaintjob(weapons[playerSource][dbid],"kabar", "knife2")
			elseif tonumber(weaponIndexByID[item]) == 4 and tonumber(value) == 22 then
				exports["weapontuning"]:setObjectPaintjob(weapons[playerSource][dbid],"kabar", "knife3")
			end
			if tonumber(weaponIndexByID[item]) == 28 and tonumber(value) == 20 then
				exports["weapontuning"]:setObjectPaintjob(weapons[playerSource][dbid],"9MM_C", "tec1")
			elseif tonumber(weaponIndexByID[item]) == 28 and tonumber(value) == 21 then
				exports["weapontuning"]:setObjectPaintjob(weapons[playerSource][dbid],"9MM_C", "tec2")
			elseif tonumber(weaponIndexByID[item]) == 28 and tonumber(value) == 22 then
				exports["weapontuning"]:setObjectPaintjob(weapons[playerSource][dbid],"9MM_C", "tec3")
			elseif tonumber(weaponIndexByID[item]) == 28 and tonumber(value) == 23 then
				exports["weapontuning"]:setObjectPaintjob(weapons[playerSource][dbid],"9MM_C", "tec4")
			end
			if tonumber(weaponIndexByID[item]) == 23 and tonumber(value) == 20 then
				exports["weapontuning"]:setObjectPaintjob(weapons[playerSource][dbid],"1911", "silenced1")
			end


			
			exports.Pattach:attachElementToBone(weapons[playerSource][dbid], playerSource,weaponPositions[tonumber(weaponIndexByID[item])][1],weaponPositions[tonumber(weaponIndexByID[item])][2],weaponPositions[tonumber(weaponIndexByID[item])][3],weaponPositions[tonumber(weaponIndexByID[item])][4],weaponPositions[tonumber(weaponIndexByID[item])][5],weaponPositions[tonumber(weaponIndexByID[item])][6],weaponPositions[tonumber(weaponIndexByID[item])][7])
		end
	end
end
addEvent("addAttachWeapon",true)
addEventHandler("addAttachWeapon",getRootElement(),addAttachWeapon)

--[[function attachWeapon(playerSource,item,dbid)
	if not weapons[playerSource] then
		weapons[playerSource] = {}
	end
	if not isElement(weapons[playerSource][dbid]) or not weapons[playerSource][dbid] then
		local x,y,z = getElementPosition(playerSource)
		if weaponCache[item] and weaponCache[item].isBack then
			weapons[playerSource][dbid] = createObject(weaponCache[item].model,x,y,z)
			setElementAlpha(weapons[playerSource][dbid],getElementAlpha(playerSource))
			setElementInterior(weapons[playerSource][dbid],getElementInterior(playerSource))
			setElementDimension(weapons[playerSource][dbid],getElementDimension(playerSource))
			setElementData(weapons[playerSource][dbid],"attachedObject",true)
			exports.Pattach:attachElementToBone(weapons[playerSource][dbid],playerSource,weaponCache[item].position[1],weaponCache[item].position[2],weaponCache[item].position[3],weaponCache[item].position[4],weaponCache[item].position[5],weaponCache[item].position[6],weaponCache[item].position[7])
		end
	end
end
addEvent("attachWeapon",true)
addEventHandler("attachWeapon",getRootElement(),attachWeapon)]]--

function detachWeapon(playerSource,item,dbid)
	if weapons[playerSource] then
		if isElement(weapons[playerSource][dbid]) then
			exports.Pattach:detachElementFromBone(weapons[playerSource][dbid])
			destroyElement(weapons[playerSource][dbid])
			weapons[playerSource][dbid] = {}
		end
	end
end
addEvent("detachWeapon",true)
addEventHandler("detachWeapon",getRootElement(), detachWeapon)

func.quitPlayer = function()
	if getElementData(source,"player:loggedIn") then
		local showElement = getElementData(source,"show:inv")
		if isElement(showElement) then
			if getElementType(showElement) == "vehicle" then
				if getElementData(showElement, "veh:use") then
					if getElementData(showElement, "veh:player") == source then
						setElementData(showElement, "veh:player", nil)
						setElementData(showElement, "veh:use", false)
						func.doorState(showElement,0)
					end
				end
			end
			if getElementType(showElement) == "object" then
				if getElementModel(showElement) == 2332 then
					if getElementData(showElement, "safe:use") then
						if getElementData(showElement, "safe:player") == source then
							setElementData(showElement, "safe:player", nil)
							setElementData(showElement, "safe:use", false)
						end
					end
				end
			end
		end
		
		local owner = func.getElementID(source);
		if not itemCache[owner] then
			itemCache[owner] = {
				["bag"] = {},
				["key"] = {},
				["licens"] = {},
				["vehicle"] = {},
				["object"] = {},
			}
		end
		for i = 1, row * column do
			if itemCache[owner]["bag"][i] then
				if weapons[source] then
					if isElement(weapons[source][itemCache[owner]["bag"][i]["id"]]) then
						exports.Pattach:detachElementFromBone(weapons[source][itemCache[owner]["bag"][i]["id"]])
						destroyElement(weapons[source][itemCache[owner]["bag"][i]["id"]])
					end
				end
			end
		end
		weapons[source] = nil;
	end
end
addEventHandler("onPlayerQuit",getRootElement(), func.quitPlayer)

func.doorState = function(vehicle,typ)
	if typ == 1 then
		setVehicleDoorOpenRatio(vehicle,1,1,1200)
	else
		setVehicleDoorOpenRatio(vehicle,1,0,1200)
	end
end
addEvent("doorState", true)
addEventHandler("doorState", getRootElement(), func.doorState)

function getElementItems(playerSource, element, playerValue)
	if (element) then
		if not itemCache[element] then
			itemCache[element] = {
				["bag"] = {},
				["key"] = {},
				["licens"] = {},
				["vehicle"] = {},
				["object"] = {},
			}
		end
		if (tonumber(playerValue) == 1 or tonumber(playerValue) == 2) then
			triggerClientEvent(playerSource, "setElementItems", playerSource, itemCache[element], playerValue, element)		
		else
			return itemCache[element]
		end		
	end
end
addEvent("getElementItems", true)
addEventHandler("getElementItems", getRootElement(), getElementItems)
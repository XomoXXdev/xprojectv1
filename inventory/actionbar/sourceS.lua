func.actionbar.start = function()
	
	local Thread2 = newThread("items_actionbar", 500, 50);
    dbQuery(function(qh)
        local loadedItems = 0
		local res, rows, err = dbPoll(qh, 0);
        if rows > 0 then
            local tick = getTickCount();
            Thread2:foreach(res, function(row)
                local owner = tonumber(row["owner"]);    
				if not actionBarCache[owner] then
					actionBarCache[owner] = {}
				end
				actionBarCache[owner][tonumber(row["slot"])] = {tonumber(row["itemdbid"]),tonumber(row["item"]),tostring(row["category"])}  
				if actionBarCache[owner][tonumber(row["slot"])] then
					loadedItems = loadedItems+1;
				end
            end, function()
                if rows > 0 then
					for k,v in ipairs(getElementsByType("player")) do
						if getElementData(v,"player:loggedIn") then
							func.actionbar.getActionbarItems(v,1)
						end
					end
                    outputDebugString("[ACTIONBAR] Loaded "..loadedItems.." item in "..(getTickCount()-tick).."ms!");
                end
            end)
        end
    end,func.dbConnect:getConnection(), "SELECT * FROM `items_actionbar`"); 
end
addEventHandler("onResourceStart",resourceRoot,func.actionbar.start)

func.actionbar.getActionbarItems = function(playerSource,value)
    local owner = func.getElementID(playerSource);
    if value == 1 then
		if not actionBarCache[owner] then
			actionBarCache[owner] = {};
		end
        triggerClientEvent(playerSource, "setActionbarItems",playerSource,actionBarCache[owner]);
    else 
       return actionBarCache[owner];
    end    
end
addEvent("getActionbarItems", true)
addEventHandler("getActionbarItems", getRootElement(),func.actionbar.getActionbarItems)

func.actionbar.moveItemToActionBar = function(playerSource,slot,data)
	local owner = func.getElementID(playerSource);
	if not actionBarCache[owner] then
		actionBarCache[owner] = {};
	end
	actionBarCache[owner][slot] = {data[1],data[2],data[3]};
	dbExec(func.dbConnect:getConnection(),"INSERT INTO `items_actionbar` SET `owner` = ?, `slot` = ?, `itemdbid` = ?, `item` = ?, `category` = ?",owner,slot,data[1],data[2],data[3])
end
addEvent("moveItemToActionBar",true)
addEventHandler("moveItemToActionBar",getRootElement(),func.actionbar.moveItemToActionBar)

func.actionbar.deleteActionBarItem = function(playerSource,slot)
	local owner = func.getElementID(playerSource);
	dbExec(func.dbConnect:getConnection(),"DELETE FROM `items_actionbar` WHERE `owner` = ? AND `slot` = ? AND `itemdbid` = ?",owner,slot,actionBarCache[owner][slot][1])
	actionBarCache[owner][slot] = nil
end
addEvent("deleteActionBarItem",true)
addEventHandler("deleteActionBarItem",getRootElement(),func.actionbar.deleteActionBarItem)

func.actionbar.updateActionBarItemSlot = function(playerSource,oldSlot,newSlot)
	local owner = func.getElementID(playerSource);
	dbExec(func.dbConnect:getConnection(),"UPDATE `items_actionbar` SET `slot` = ? WHERE `owner` = ? AND `itemdbid` = ?",newSlot,owner,actionBarCache[owner][oldSlot][1])
	actionBarCache[owner][newSlot] = actionBarCache[owner][oldSlot]
	actionBarCache[owner][oldSlot] = nil
end
addEvent("updateActionBarItemSlot",true)
addEventHandler("updateActionBarItemSlot",getRootElement(),func.actionbar.updateActionBarItemSlot)
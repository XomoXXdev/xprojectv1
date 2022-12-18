local func = {};
func.dbConnect = exports["Pcore"];
local pedCache = {};
local pedItems = {};

func.start = function()
	dbQuery(function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
            for k, row in pairs(res) do
                local skin = row.skin;
                local x = row.x;
                local y = row.y;
                local z = row.z;
                local rotation = row.rotation;
                local interior = row.interior;
                local dimension = row.dimension;
				local ped = createPed(skin,x,y,z);
				if isElement(ped) then
					setElementInterior(ped,interior);
                    setElementDimension(ped,dimension);
                    setPedRotation(ped,rotation)
                    setElementData(ped,"ped:money",row.money)
                    setElementData(ped,"ped:owner",row.owner)
                    setElementData(ped,"ped:shop",true);
                    setElementData(ped,"ped:dbid",row.id);
                    setElementData(ped,"ped:shoptype",tostring(row.shoptype));
                    setElementData(ped,"ped:type",tostring(row.typename));
                    setElementData(ped,"ped:items",fromJSON(row.items))
                    setElementData(ped,"ped:name",tostring(row.name))
					pedCache[ped] = true;
				end
			end
		end
	end,func.dbConnect:getConnection(), "SELECT * FROM `shop_peds`");
end
addEventHandler("onResourceStart",resourceRoot,func.start)

func.createShop = function(playerSource,cmd,targetPlayer,skin,...)
    if getElementData(playerSource,"player:admin") >= 3 then
        if targetPlayer and skin and (...) and type(tonumber(skin)) == "number" and type(tonumber(targetPlayer)) == "number" then

            local target = exports["Pcore"]:findPlayerByPartialNick(playerSource,targetPlayer)
            local owner = getElementData(target,"player:dbid")
            local name = table.concat({...}, " ");
            local x,y,z = getElementPosition(playerSource)
            local interior = getElementInterior(playerSource)
            local dimension = getElementDimension(playerSource)
            local rotation = getPedRotation(playerSource)

            dbQuery(function(qh)
                local query, query_lines,id = dbPoll(qh, 0)
                local id = tonumber(id)
                if id > 0 then
                    outputChatBox("[xProject]:#ffffff Sikeresen leraktál egy shopot. ##8163bf("..id..")",playerSource,129, 99, 191,true)
                    local ped = createPed(skin,x,y,z);
                    if isElement(ped) then
                        setElementInterior(ped,interior);
                        setElementDimension(ped,dimension);
                        setPedRotation(ped,rotation)
                        setElementData(ped,"ped:money",0)
                        setElementData(ped,"ped:owner",owner)
                        setElementData(ped,"ped:shop",true);
                        setElementData(ped,"ped:name",name)
                        setElementData(ped,"ped:dbid",id);
                        setElementData(ped,"ped:shoptype","");
                        setElementFrozen(ped,true)
                        setElementData(ped,"ped:items",fromJSON("{}"))
                        pedCache[ped] = true;
                    end
                end
            end,func.dbConnect:getConnection(),"INSERT INTO `shop_peds` SET `owner` = ?, `x` = ?, `y` = ?, `z` = ?, `rotation` = ?, `interior` = ?, `dimension` = ?, `skin` = ?, `name` = ?",owner,x,y,z,rotation,interior,dimension,skin,name)
        else
            outputChatBox("Használat:#ffffff /"..cmd.." [owner] [skin] [név].",playerSource,129, 99, 191,true)
        end
    end
end
addCommandHandler("createshop",func.createShop)

func.deleteShop = function(playerSource,cmd,id)
	if getElementData(playerSource,"player:admin") >= 3 then
		if id and type(tonumber(id)) == "number" then
			id = tonumber(id)
			local count = 0
			local x,y,z = getElementPosition(playerSource)
			for v,k in pairs(pedCache) do
				if getElementData(v,"ped:dbid") and getElementData(v,"ped:dbid") == id then
					count=count+1
					dbExec(func.dbConnect:getConnection(),"DELETE FROM `shop_peds` WHERE `id` = ?",id)
					outputChatBox("[xProject]:#ffffff Sikeresen töröltél egy shopot.", playerSource,129, 99, 191,true)
					destroyElement(v);
				end
			end
			if count == 0 then
				outputChatBox("[xProject]:#ffffff Hibás id.", playerSource,129, 99, 191,true)
			end
		else
			outputChatBox("Használat:#ffffff /"..cmd.." [id]", playerSource,129, 99, 191,true)
		end
	end
end
addCommandHandler("delshop",func.deleteShop)

func.destroy = function()
	if getElementType(source) == "ped" and getElementData(source,"ped:dbid") then
		if pedCache[source] then
			pedCache[source] = nil;
		end
	end
end
addEventHandler("onElementDestroy",getRootElement(),func.destroy) 

func.insertSave = function(playerSource,peddbid,data,typename)
    local items = toJSON(data);
    dbExec(func.dbConnect:getConnection(),"UPDATE `shop_peds` SET `items` = ?, `typename` = ? WHERE `id` = ?",items,tostring(typename),peddbid)
end
addEvent("insertSave",true)
addEventHandler("insertSave",getRootElement(),func.insertSave)

func.saveItems = function(playerSource,peddbid,data)
    local items = toJSON(data);
    dbExec(func.dbConnect:getConnection(),"UPDATE `shop_peds` SET `items` = ? WHERE `id` = ?",items,peddbid)
end
addEvent("saveItems",true)
addEventHandler("saveItems",getRootElement(),func.saveItems)

func.buyItem = function(playerSource,data,price,allweight,peddbid)
if getElementData(playerSource,"player:money") >= price then 

    local buyed = false
    local stack = false
    local itemname = ""
    local itemCache = {};
    local itemname2 = ""
    local itemsweight = 0;
    for k,v in pairs(data) do
        itemsweight = itemsweight + exports["inventory"]:getItemWeight(v[1]) * v[3];
    end

    local freeweight = exports["inventory"]:getTypeElement(playerSource)[3] - allweight
    local profit = 0

        for k,v in pairs(data) do
            local itemweigt = exports["inventory"]:getItemWeight(v[1])
            local state,slot = exports["inventory"]:getFreeSlot(playerSource,v[1])
        
            if itemsweight < freeweight then 
                if state then
                    if v[4] >= v[3] then 
                    setElementData(playerSource,"player:money",getElementData(playerSource,"player:money") - v[5]*v[3])
                    exports["inventory"]:giveItem(playerSource,v[1],1,v[3],0)
                    buyed = true 
                    itemname = itemname.."#7cc576"..exports["inventory"]:getItemName(v[1]).." ##8163bf("..v[3]..") , "
                    profit = profit + v[5]*v[3]

                    itemCache[v[1]] = {v[3]};

                    data[1][4] = data[1][4] - v[3]
                    else 
                        stack = true 
                        itemname2 = itemname2.."#7cc576"..exports["inventory"]:getItemName(v[1]).." ##8163bf("..v[3]..") , "
                    end 
                end
            else 
                exports["Pinfobox"]:addNotification(playerSource,"Nem bírod el a vásárolni kívánt itemeket.","error")
                return
            end 
        end

        if stack then 
            outputChatBox("##8163bf[Bolt] #ffffffAz alábbi tárgyakat nem tudtad megvásárolni mert nem voltak készleten : "..itemname2,playerSource,255,255,255,true) 
        end 

        if buyed then
            for v,k in pairs(pedCache) do
                if getElementData(v,"ped:dbid") and getElementData(v,"ped:dbid") == peddbid then
                    local tablePed = getElementData(v,"ped:items");
                    for k,data in pairs(tablePed) do
                        if itemCache[data[1]] then
                            tablePed[k][4] = tablePed[k][4] - itemCache[data[1]][1];
                        end
                    end

                    setElementData(v,"ped:money",getElementData(v,"ped:money") + profit)
                    setElementData(v,"ped:items",tablePed)
                    local pedMoney = getElementData(v,"ped:money")

                    dbExec(func.dbConnect:getConnection(),"UPDATE `shop_peds` SET `items` = ? , `money` = ? WHERE `id` = ?",toJSON(tablePed),tonumber(pedMoney),peddbid)
                end
            end
            outputChatBox("##8163bf[Bolt] #ffffffSikeresen vásroltál: "..itemname,playerSource,255,255,255,true) 
            exports["Pinfobox"]:addNotification(playerSource,"Sikeres vásárlás, részletek a chatboxban.","success")
        end
else 
    exports["Pinfobox"]:addNotification(playerSource,"Nincs elég pénzed.","error")
end 

end
addEvent("buyItem",true)
addEventHandler("buyItem",getRootElement(),func.buyItem)

func.restockItem = function(playerSource,price,peddbid)


    for v,k in pairs(pedCache) do
        if getElementData(v,"ped:dbid") and getElementData(v,"ped:dbid") == peddbid then

            if getElementData(v,"ped:money") >= price then 

                setElementData(v,"ped:money",getElementData(v,"ped:money") - price)
                exports["Pinfobox"]:addNotification(playerSource,"Sikeresen megvásároltad a boltodnak a kíválasztott itemeket.","success")
                triggerClientEvent(playerSource,"restockItems",playerSource)

            else 
                exports["Pinfobox"]:addNotification(playerSource,"Nincs elég pénz a kasszában hogy bevásárolj a kívánt itemekből.","error")
            end 

        end
    end



end 
addEvent("restockItem",true)
addEventHandler("restockItem",getRootElement(),func.restockItem)

func.giveMoneyForShop = function(playerSource,money,peddbid)
    if getElementData(playerSource,"player:money") >= money then 
        for v,k in pairs(pedCache) do
            if getElementData(v,"ped:dbid") and getElementData(v,"ped:dbid") == peddbid then

                setElementData(v,"ped:money",getElementData(v,"ped:money") + money)
                local pedMoney = getElementData(v,"ped:money")
                dbExec(func.dbConnect:getConnection(),"UPDATE `shop_peds` SET `money` = ? WHERE `id` = ?",pedMoney,peddbid)
                setElementData(playerSource,"player:money",getElementData(playerSource,"player:money") - money)
                exports["Pinfobox"]:addNotification(playerSource,"Sikeresen betetted a pénzt a kasszába.","success")

            end
        end
    else 
        exports["Pinfobox"]:addNotification(playerSource,"Nincs nálad ennyi pénz.","error")
    end 
end 
addEvent("giveMoneyForShop",true)
addEventHandler("giveMoneyForShop",getRootElement(),func.giveMoneyForShop)

func.takeMoneyFromShop = function(playerSource,money,peddbid)
        for v,k in pairs(pedCache) do
            if getElementData(v,"ped:dbid") and getElementData(v,"ped:dbid") == peddbid then

                if getElementData(v,"ped:money") >= money then 

                    setElementData(v,"ped:money",getElementData(v,"ped:money") - money)
                    local pedMoney = getElementData(v,"ped:money")
                    dbExec(func.dbConnect:getConnection(),"UPDATE `shop_peds` SET `money` = ? WHERE `id` = ?",pedMoney,peddbid)
                    setElementData(playerSource,"player:money",getElementData(playerSource,"player:money") + money)

                    exports["Pinfobox"]:addNotification(playerSource,"Sikeresen kivetted a pénzt a kasszából.","success")
                else 
                    exports["Pinfobox"]:addNotification(playerSource,"Nincs ennyi pénz a kasszában.","error") 
                end 

            end
        end
end 
addEvent("takeMoneyFromShop",true)
addEventHandler("takeMoneyFromShop",getRootElement(),func.takeMoneyFromShop)
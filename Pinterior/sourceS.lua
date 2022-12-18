local func = {};
func.dbConnect = exports["Pcore"];
local markerCache = {};

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

func.start = function()
	
	local Thread = newThread("interiors", 2000, 500);
    dbQuery(function(qh)
        local loaded = 0
		local res, rows, err = dbPoll(qh, 0);
        if rows > 0 then
            local tick = getTickCount();
			Thread:foreach(res, function(row)
				func.createMarker(row);
                loaded = loaded+1;
            end, function()
                if rows > 0 then
                    outputDebugString("[INTERIORS] "..loaded.." interior in "..(getTickCount()-tick).."ms!");
                end
            end)
        end
	end,func.dbConnect:getConnection(), "SELECT * FROM `interiors`");

	
end
addEventHandler("onResourceStart",resourceRoot,func.start)

func.createInterior = function(playerSource,cmd,interiorid,typ,cost, ...)
	if getElementData(playerSource,"player:admin") >= 3 then
		if interiorid and typ and cost and (...) then
			interiorid = tonumber(interiorid);
			typ = tonumber(typ);
			cost = tonumber(cost);
			intname = table.concat({...}, " ");
			local px,py,pz = getElementPosition(playerSource);
			local int = getElementInterior(playerSource);
			local dim = getElementDimension(playerSource);
			if interiors[interiorid] then
				local intInt = interiors[interiorid][1];
				local interiorX,interiorY,interiorZ = interiors[interiorid][2],interiors[interiorid][3],interiors[interiorid][4];
				dbQuery(function(qh)
					local query, query_lines,insertid = dbPoll(qh, 0);
					local insertid = tonumber(insertid);
					if insertid > 0 then
						local data = {
							x = px;
							y = py;
							z = pz;
							intx = interiorX;
							inty = interiorY;
							intz = interiorZ;
							dimension = dim;
							interior = int;
							price = cost;
							intinterior = intInt;
							owner = -1;
							type = typ;
							name = intname;
							locked = 0;
							id = insertid;
							garagesize = -1;
							renttime = 0;
						};
						func.createMarker(data);
						outputChatBox("[xProject]:#ffffff Sikeresen leraktál egy interiort. #8163bf("..insertid..")",playerSource,129, 99, 191,true);
					end
				end,func.dbConnect:getConnection(),"INSERT INTO `interiors` SET `x` = ?, `y` = ?, `z` = ?, `interior` = ?, `dimension` = ?, `intx` = ?, `inty` = ?, `intz` = ?, `intinterior` = ?, `type` = ?, `name` = ?, `price` = ?",px,py,pz,int,dim,interiorX,interiorY,interiorZ,intInt,typ,intname,cost)
			else
				outputChatBox("[xProject]:#ffffff Hibás interior id.",playerSource,129, 99, 191,true);
			end
		else
			outputChatBox("Használat:#ffffff /"..cmd.." [interiorid] [tipus] [ár] [név]",playerSource,129, 99, 191,true);
			outputChatBox("[Tipusok]:#ffffff Ház: 0, Bérház: 1, Önkormányzati: 2, Garázs: 3, Biznisz: 4]",playerSource,129, 99, 191,true);
		end
	end
end
addCommandHandler("createinterior",func.createInterior)

func.createMarker = function(row)

	local icon = getPickupIconByType(row.owner,row.type)
	if icon then
		markerElement = createPickup (row.x, row.y, row.z,3,icon)
		intmarkerElement = createPickup (row.intx, row.inty, row.intz,3,icon)

		setElementDimension(markerElement,row.dimension)
		setElementInterior(markerElement,row.interior)

		setElementDimension(intmarkerElement,row.id)
		setElementInterior(intmarkerElement,row.intinterior)

		setElementData(markerElement,"int:other",intmarkerElement)
		setElementData(intmarkerElement,"int:other",markerElement)
		setElementData(markerElement,"int:dbid",row.id);
		setElementData(intmarkerElement,"int:dbid",row.id);
		setElementData(markerElement,"int:name",row.name);
		setElementData(intmarkerElement,"int:name",row.name);
		setElementData(markerElement,"int:locked",row.locked);
		setElementData(intmarkerElement,"int:locked",row.locked);
		setElementData(markerElement,"int:type",row.type);
		setElementData(intmarkerElement,"int:type",row.type);
		setElementData(markerElement,"int:owner",row.owner);
		setElementData(intmarkerElement,"int:owner",row.owner);
		setElementData(markerElement,"int:price",row.price);
		setElementData(intmarkerElement,"int:price",row.price);
		setElementData(markerElement,"int:renttime",row.renttime);
		setElementData(intmarkerElement,"int:renttime",row.renttime);

		setElementData(markerElement,"int:garagesize",row.garagesize);
		setElementData(intmarkerElement,"int:garagesize",row.garagesize);

		markerCache[markerElement] = true;
		markerCache[intmarkerElement] = true;
		setElementData(markerElement,"int:in",true);
		setElementData(intmarkerElement,"int:out",true);
	end
end

function hitInteriorPickup(thePlayer)
	cancelEvent()
end
addEventHandler("onPickupHit", getResourceRootElement(), hitInteriorPickup)

func.onDestroy = function()
	if getElementType(source) == "pickup" then
		if markerCache[source] then
			markerCache[source] = nil;
		end
	end
end
addEventHandler("onElementDestroy",getRootElement(),func.onDestroy)

func.changePlayerInterior = function(playerSource,x,y,z,interior,dimension,marker)
	setElementPosition(playerSource, x, y, z + 0.7)
	setElementDimension(playerSource, dimension)
	setElementInterior(playerSource, interior)
	setElementFrozen(playerSource,false);
end
addEvent("changePlayerInterior",true)
addEventHandler("changePlayerInterior",getRootElement(),func.changePlayerInterior)

func.changeVehicleInterior = function(playerSource,x,y,z,interior,dimension,marker,vehicle)

	setElementPosition(vehicle, x, y, z + 1.15)
	setElementDimension(vehicle, dimension)
	setElementInterior(vehicle, interior)

	setElementFrozen(playerSource,false);
	setElementFrozen(vehicle,false);
	for k,v in pairs(getVehicleOccupants(vehicle)) do
		setElementDimension(v, dimension)
		setElementInterior(v, interior)
	end
end
addEvent("changeVehicleInterior",true)
addEventHandler("changeVehicleInterior",getRootElement(),func.changeVehicleInterior)

func.setInteriorLockstate = function(locked,dbid)
	dbExec(func.dbConnect:getConnection(), "UPDATE `interiors` SET `locked` = ? WHERE id = ?",locked,dbid)
end
addEvent("setInteriorLockstate",true)
addEventHandler("setInteriorLockstate",getRootElement(),func.setInteriorLockstate)

func.setinteriorid = function(playerSource,cmd,id)
	if getElementData(playerSource,"player:admin") >= 3 then
		if id then
			id = tonumber(id);
			if interiors[id] then
				local inMarker = getElementData(playerSource,"player:intmarker");
				if isElement(inMarker) then
					if getElementData(inMarker,"int:out") then
						local intInterior = interiors[id][1];
						local intX,intY,intZ = interiors[id][2],interiors[id][3],interiors[id][4];
						setElementPosition(inMarker,intX,intY,intZ);
						setElementInterior(inMarker,intInterior);
						dbExec(func.dbConnect:getConnection(), "UPDATE `interiors` SET `intx` = ?, `inty` = ?, `intz` = ?, `intinterior` = ? WHERE `id` = ?",intX,intY,intZ,intInterior,getElementData(inMarker,"int:dbid"))
						for k,v in ipairs(getElementsByType("player")) do
							if getElementDimension(playerSource) == getElementDimension(v) then
								setElementPosition(v,intX,intY,intZ);
								setElementInterior(v,intInterior);
							end
						end
						outputChatBox("#8163bf[xProject]:#ffffff Sikeresen megváltoztattad az interior belsejét.", playerSource,0,0,0,true);
					else
						outputChatBox("#8163bf[xProject]:#ffffff Ez egy külső marker.", playerSource,0,0,0,true);
					end
				else
					outputChatBox("#8163bf[xProject]:#ffffff Nem állsz interior markerben.", playerSource,0,0,0,true);
				end
			else
				outputChatBox("#8163bf[xProject]:#ffffff Hibás interior id.", playerSource,0,0,0,true);
			end
		else
			outputChatBox("#8163bfHasználat:#ffffff /"..cmd.." [ID]",playerSource,0,0,0,true);
		end
	end
end
addCommandHandler("setinteriorid",func.setinteriorid)

func.gotoInterior = function(playerSource,cmd,interiordbid)
	if getElementData(playerSource,"player:admin") >= 2 then
		if interiordbid and type(tonumber(interiordbid)) == "number" then
			interiordbid = tonumber(interiordbid);
			local marker = func.findInteriorInElementByDbid(interiordbid);
			if marker then
				local x,y,z = getElementPosition(marker);
				local interior = getElementInterior(marker);
				local dimension = getElementDimension(marker);
				setElementPosition(playerSource,x,y,z+0.7);
				setElementInterior(playerSource,interior);
				setElementDimension(playerSource,dimension);
				outputChatBox("#8163bf[xProject]:#ffffff Sikeresen elteleportáltál az interiorhoz.",playerSource,0,0,0,true)
			else
				outputChatBox("#8163bf[xProject]:#ffffff Hibás interiorid.",playerSource,0,0,0,true)
			end
		else
			outputChatBox("#8163bfHasználat: #ffffff/"..cmd.." [interiorid]",playerSource,0,0,0,true)
		end
	end
end
addCommandHandler("gotointerior",func.gotoInterior)

func.setInteriorName = function(playerSource,cmd,interiordbid,...)
	if getElementData(playerSource,"player:admin") >= 3 then
		if interiordbid and type(tonumber(interiordbid)) == "number" and (...) then
			interiordbid = tonumber(interiordbid);
			local newName = table.concat({...}, " ");
			local marker = func.findInteriorInElementByDbid(interiordbid);
			if marker then
				local other = getElementData(marker,"int:other");
				setElementData(marker,"int:name",newName);
				setElementData(other,"int:name",newName);
				dbExec(func.dbConnect:getConnection(), "UPDATE `interiors` SET `name` = ? WHERE id = ?",newName,interiordbid)
				outputChatBox("#8163bf[xProject]:#ffffff Sikeresen átnevezted az interiort.",playerSource,0,0,0,true)
			else
				outputChatBox("#8163bf[xProject]:#ffffff Hibás interiorid.",playerSource,0,0,0,true)
			end
		else
			outputChatBox("#8163bfHasználat: #ffffff/"..cmd.." [interiorid] [név]",playerSource,0,0,0,true)
		end
	end
end
addCommandHandler("setinteriorname",func.setInteriorName)

func.setInteriorPrice = function(playerSource,cmd,interiordbid,newPrice)
	if getElementData(playerSource,"player:admin") >= 3 then
		if interiordbid and type(tonumber(interiordbid)) == "number" and newPrice and type(tonumber(newPrice)) == "number" then
			interiordbid = tonumber(interiordbid);
			newPrice = tonumber(newPrice);
			local marker = func.findInteriorInElementByDbid(interiordbid);
			if marker then
				local other = getElementData(marker,"int:other");
				setElementData(marker,"int:price",newPrice);
				setElementData(other,"int:price",newPrice);
				dbExec(func.dbConnect:getConnection(), "UPDATE `interiors` SET `price` = ? WHERE id = ?",newPrice,interiordbid)
				outputChatBox("#8163bf[xProject]:#ffffff Sikeresen átírtad az interior árát #8163bf"..thousandsStepper(newPrice).."#ffffff dollárra.",playerSource,0,0,0,true)
			else
				outputChatBox("#8163bf[xProject]:#ffffff Hibás interiorid.",playerSource,0,0,0,true)
			end
		else
			outputChatBox("#8163bfHasználat: #ffffff/"..cmd.." [interiorid] [új ár]",playerSource,0,0,0,true)
		end
	end
end
addCommandHandler("setinteriorprice",func.setInteriorPrice)

func.deleteInterior = function(playerSource,cmd,interiordbid)
	if getElementData(playerSource,"player:admin") >= 3 then
		if interiordbid and type(tonumber(interiordbid)) == "number" then
			interiordbid = tonumber(interiordbid);
			local marker = func.findInteriorInElementByDbid(interiordbid);
			if marker then
				outputChatBox("#8163bf[xProject]:#ffffff Sikeresen töröltél egy interiort. #8163bf("..interiordbid..")",playerSource,0,0,0,true)
				local other = getElementData(marker,"int:other");
				dbExec(func.dbConnect:getConnection(),"DELETE FROM `interiors` WHERE `id` = ?",interiordbid)
				exports.inventory:takeAllItem(108,interiordbid)
				markerCache[other] = nil;
				markerCache[marker] = nil;
				destroyElement(other);
				destroyElement(marker);
			else
				outputChatBox("#8163bf[xProject]:#ffffff Hibás interiorid.",playerSource,0,0,0,true)
			end
		else
			outputChatBox("#8163bf[xProject]: #ffffff/"..cmd.." [interiorid]",playerSource,0,0,0,true)
		end
	end
end
addCommandHandler("delinterior",func.deleteInterior)

func.buyInteriorServer = function(playerSource,element)
	local price = getElementData(element,"int:price");
	if getElementData(playerSource,"player:money") >= price then
		local dbid = getElementData(element,"int:dbid");
		local owner = getElementData(playerSource,"player:dbid");
		local type = getElementData(element,"int:type");
		local other = getElementData(element,"int:other");
		local icon = getPickupIconByType(owner,type);
		setElementData(element,"int:owner",owner);
		setElementData(other,"int:owner",owner);
		setPickupType ( element, 3, icon ) 
		setPickupType ( other, 3, icon ) 
		setElementData(playerSource,"player:money",getElementData(playerSource,"player:money")-price)
		dbExec(func.dbConnect:getConnection(),"UPDATE `interiors` SET `owner` = ? WHERE `id` = ?",owner,dbid);
		exports.inventory:giveItem(playerSource,108,dbid,1,0);
		exports.Pinfobox:addNotification(playerSource,"Sikeresen vásároltál egy ingatlant, részletek a chatboxban.","success")
		outputChatBox("#8163bf[xProject]:#ffffff Sikeresen vásároltál egy ingatlant #8163bf"..thousandsStepper(price).."#ffffff dollárért.",playerSource,0,0,0,true)
	end
end
addEvent("buyInteriorServer",true)
addEventHandler("buyInteriorServer",getRootElement(),func.buyInteriorServer)

--outputChatBox(((24*60)*60).." - "..((168*60)*60))

setTimer(function()
	for marker,k in pairs(markerCache) do
		if getElementData(marker,"int:type") == 1 and getElementData(marker,"int:in") and getElementData(marker,"int:owner") > 0 then
			local owner = getElementData(marker,"int:owner");
			local type = getElementData(marker,"int:type");
			local dbid = getElementData(marker,"int:dbid");
			local other = getElementData(marker,"int:other");
			local time = getElementData(marker,"int:renttime");
			local serverTimestamp = getRealTime()["timestamp"];
			if serverTimestamp >= time then

				dbExec(func.dbConnect:getConnection(),"UPDATE `interiors` SET `owner` = ?, `renttime` = ? WHERE `id` = ?",-1,0,dbid);
				local icon = getPickupIconByType(-1,type);
				setElementData(marker,"int:owner",-1);
				setElementData(other,"int:owner",-1);
				setElementData(marker,"int:renttime",0);
				setElementData(other,"int:renttime",0);
				setPickupType(marker, 3, icon) 
				setPickupType(other, 3, icon) 
				exports.inventory:takeAllItem(108,dbid)
				local playerElement = func.findPlayerByDbid(owner);
				if playerElement then
					exports.Pinfobox:addNotification(playerElement,"Az ingatlan bérleted lejárt.","error")
					outputChatBox("#8163bf[xProject]:#ffffff Az ingatlan bérleted lejárt, mert nem hosszabbítottad meg.",playerElement,0,0,0,true)
				end
			else
				local lasttime = math.floor(((time-serverTimestamp)/60)/60);
				local playerElement = func.findPlayerByDbid(owner);
				if playerElement then
					if lasttime <= 24 then
						outputChatBox("#8163bf[xProject]:#ffffff Az ingatlan bérleted #8163bf"..lasttime.."#ffffff óra múlva le fog járni. Kibérelheted újra a #8163bf/rent#ffffff paranccsal.",playerElement,0,0,0,true)
					end
				end
			end
		end
	end
end,((1000*60)*60)*2,0)

func.findPlayerByDbid = function(dbid)
	for k,player in ipairs(getElementsByType("player")) do
		if getElementData(player,"player:dbid") == dbid then
			return player;
		end
	end
	return nil;
end

func.rentInteriorServer = function(playerSource,element)
	local price = getElementData(element,"int:price");
	local caution = getElementData(element,"int:price")*2;
	if getElementData(playerSource,"player:money") >= price+caution then
		local dbid = getElementData(element,"int:dbid");
		local owner = getElementData(playerSource,"player:dbid");
		local type = getElementData(element,"int:type");
		local other = getElementData(element,"int:other");
		local icon = getPickupIconByType(owner,type);
		setElementData(element,"int:owner",owner);
		setElementData(other,"int:owner",owner);
		setPickupType(element, 3, icon) 
		setPickupType(other, 3, icon) 
		setElementData(playerSource,"player:money",getElementData(playerSource,"player:money")-(price+caution))
		local duration = (168*60)*60;
		local timestamp = getRealTime()["timestamp"]+duration;
		setElementData(element,"int:renttime",timestamp);
		setElementData(other,"int:renttime",timestamp);
		dbExec(func.dbConnect:getConnection(),"UPDATE `interiors` SET `owner` = ?, `renttime` = ? WHERE `id` = ?",owner,timestamp,dbid);
		exports.inventory:giveItem(playerSource,108,dbid,1,0);
		exports.Pinfobox:addNotification(playerSource,"Sikeresen kibéreltél egy ingatlant, részletek a chatboxban.","success")
		outputChatBox("#8163bf[xProject]:#ffffff Sikeresen kibéreltél egy ingatlant #8163bf"..thousandsStepper(price).."#ffffff dollárért egy hétre.",playerSource,0,0,0,true)
	end
end
addEvent("rentInteriorServer",true)
addEventHandler("rentInteriorServer",getRootElement(),func.rentInteriorServer)

func.unrentInteriorServer = function(playerSource,element)
	local dbid = getElementData(element,"int:dbid");
	local owner = getElementData(playerSource,"player:dbid");
	if getElementData(element,"int:owner") == owner then
		local caution = getElementData(element,"int:price")*2;
		setElementData(playerSource,"player:money",getElementData(playerSource,"player:money")+caution)
		outputChatBox("#8163bf[xProject]:#ffffff Sikeresen felmondtad az ingatlan bérlést ezért vissza kaptad a kaukció árát ami #8163bf"..thousandsStepper(caution).."#ffffff dollár.",playerSource,0,0,0,true)
		local other = getElementData(element,"int:other");
		local type = getElementData(element,"int:type");
		local icon = getPickupIconByType(-1,type);
		setElementData(element,"int:owner",-1);
		setElementData(other,"int:owner",-1);
		setElementData(element,"int:renttime",0);
		setElementData(other,"int:renttime",0);
		setPickupType(element, 3, icon) 
		setPickupType(other, 3, icon) 
		exports.inventory:takeAllItem(108,dbid)
		dbExec(func.dbConnect:getConnection(),"UPDATE `interiors` SET `owner` = ?, `renttime` = ? WHERE `id` = ?",-1,0,dbid);
	end
end
addEvent("unrentInteriorServer",true)
addEventHandler("unrentInteriorServer",getRootElement(),func.unrentInteriorServer)

func.extendRentInteriorServer = function(playerSource,element)
	local dbid = getElementData(element,"int:dbid");
	local price = getElementData(element,"int:price");
	if getElementData(playerSource,"player:money") >= price then
		local other = getElementData(element,"int:other");
		outputChatBox("#8163bf[xProject]:#ffffff Sikeresen meghosszabbítotted az ingatlan bérletét egy héttel ami #8163bf"..thousandsStepper(price).."#ffffff dollárba került.",playerSource,0,0,0,true)
		setElementData(playerSource,"player:money",getElementData(playerSource,"player:money")-price);

		local duration = (168*60)*60;
		local timestamp = getRealTime()["timestamp"]+duration;
		setElementData(element,"int:renttime",timestamp);
		setElementData(other,"int:renttime",timestamp);
		dbExec(func.dbConnect:getConnection(),"UPDATE `interiors` SET `renttime` = ? WHERE `id` = ?",timestamp,dbid);
	end
end
addEvent("extendRentInteriorServer",true)
addEventHandler("extendRentInteriorServer",getRootElement(),func.extendRentInteriorServer)

func.findInteriorInElementByDbid = function(interiordbid)
	local element = nil;
	for marker,value in pairs(markerCache) do
		if getElementData(marker,"int:in") and getElementData(marker,"int:dbid") == interiordbid then
			element = marker;
		end
	end
	return element;
end
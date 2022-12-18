func = {};
func.dbConnect = exports["Pcore"];
local connection = exports.pcore:getConnection()
vehicleCache = {};

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

--addCommandHandler("asdd",function(playerSource)
--	local asd = toJSON({{"rank1",0},{"rank2",0},{"rank3",0},{"rank3",0},{"rank6",0},{"rank5",0},{"rank7",0},{"rank8",0},{"rank9",0},{"rank10",0},{"rank11",0},{"rank12",0},{"rank13",0},{"rank14",0},{"rank15",0}})
--	outputChatBox(asd,playerSource)
--end)

func.start = function()
	for k,player in pairs(getElementsByType("player")) do
        bindKey(player, "k", "down", func.lockVehicle)
    end
    local Thread = newThread("vehicles", 3000, 50);
    dbQuery(function(qh)
        local loadedVehicles = 0
		local res, rows, err = dbPoll(qh, 0);
        if rows > 0 then
            local tick = getTickCount();
			Thread:foreach(res, function(row)
				local findedowner = findVehicleOwner(tonumber(row.owner),tonumber(row.group));
				if findedowner then
					vehicleLoad(row);
				end

				if tonumber(row.group) > 0 then
					vehicleLoad(row)
				end
				loadedVehicles = loadedVehicles + 1;
            end, function()
                if rows > 0 then
                    outputDebugString("[VEHICLES] "..loadedVehicles.." vehicle in "..(getTickCount()-tick).."ms!");
                end
            end)
        end
    end,func.dbConnect:getConnection(), "SELECT * FROM `vehicles`"); 
end
addEventHandler("onResourceStart",resourceRoot,func.start)

func.onJoin = function()
    bindKey(source, "k", "down", func.lockVehicle);
end
addEventHandler("onPlayerJoin",root,func.onJoin)

func.stop = function()
	for vehicle,k in pairs(vehicleCache) do
		func.saveVehicle(vehicle)
	end
end
addEventHandler("onResourceStop",resourceRoot,func.stop)
func.stop2 = function(resource)
	if resource == getResourceFromName ( "Paccount" ) then
	for vehicle,k in pairs(vehicleCache) do
		func.saveVehicle(vehicle)
	end
	end
end
addEventHandler("onResourceStop",root,func.stop2)
function vehicleLoad(row)
	local id = tonumber(row.id);
	local model = tonumber(row.model);
    local x = tonumber(row.x);
    local y = tonumber(row.y);
    local z = tonumber(row.z);
    local rx = tonumber(row.rx);
    local ry = tonumber(row.ry);
    local rz = tonumber(row.rz);
    local interior = tonumber(row.interior);
    local dimension = tonumber(row.dimension);
    local owner = tonumber(row.owner);
    local group = tonumber(row.group);
    local locked = tonumber(row.locked) or 0;
    local engine = tonumber(row.engine) or 0;
	local health = tonumber(row.health) or 1000;
	local fuel = tonumber(row.fuel) or 100
	local miles = tonumber(row.miles) or 0
	local panels = fromJSON(tostring(row.panels)) or {0, 0, 0, 0, 0, 0, 0};
	local doors = fromJSON(tostring(row.doors)) or {0, 0, 0, 0, 0, 0};
	local wheels = fromJSON(tostring(row.wheels)) or {0,0,0,0};
	local color = fromJSON(tostring(row.color))
	local paintjob = tonumber(row.paintjob) or 0

    local element = createVehicle(model,x,y,z,rx,ry,rz)
	local turbo = tonumber(row.turbo)
	local motor = tonumber(row.motor)
	local tires = tonumber(row.tires)
	local brakes = tonumber(row.brakes)
	local weightreduction = tonumber(row.weightreduction)
	local ecu = tonumber(row.ecu)
	local pj = tonumber(row.pj)
	local front = tonumber(row.frontwheel)
	local back = tonumber(row.backwheel)
	local plate = (row.plate)
	local optical = (row.OpticalUpgrade)
	local steeringlock = (row.steeringlock)
	local drivetype = row.drivetype
	local LSDDoor = row.lsdoor
	local airride = row.airride
	local headlightcolor= fromJSON(row.headlightcolor)
    if isElement(element) then
        setElementHealth(element,health) 
        setElementInterior(element,interior)
		setElementDimension(element,dimension)
		setVehicleWheelStates(element, wheels[1], wheels[2], wheels[3], wheels[4])
		for i = 0, 5 do
			setVehicleDoorState(element, i, doors[i + 1])
		end
		for i = 0, 6 do
			setVehiclePanelState(element, i, panels[i + 1])
		end

		setElementData(element,"vehicle:dbid",id)
		setElementData(element,"vehicle:owner",owner)
        setElementData(element,"vehicle:group",group)
		setElementData(element,"vehicle:locked",locked)
		setElementData(element,"vehicle:fuel",fuel)
		setElementData(element,"vehicle:miles",miles)
		setElementData(element,"vehicle:lights",0);
		setElementData(element,"vehicle:handbrake",0)
		if headlightcolor then
		setVehicleHeadLightColor(element,headlightcolor[1],headlightcolor[2],headlightcolor[3])
		end
		if airride == 1 then 
			setElementData(element,"tuning.airRide", true)
		else
			setElementData(element,"tuning.airRide", false)
		end	
		if LSDDoor == 1 then 
			setElementData(element,"tuning.lsdDoor", true)

		else
			setElementData(element,"tuning.lsdDoor", false)

		end
setElementData(element,"drivetype",drivetype)
        setElementData(element,"tuning.turbo", turbo or 0)
		setElementData(element,"tuning.engine", motor or 0)
		setElementData(element,"tuning.ecu", ecu or 0)
		setElementData(element,"tuning.weightreduction", weightreduction or 0)
		setElementData(element,"tuning.tires", tires or 0)
		setElementData(element,"tuning.brakes", brakes or 0)
		setElementData(element,"tuning.paintjob", paintjob or 0)

		setElementData(element,"steeringlock",steeringlock or 30)
		setElementData(element,"vehicle.tuning.engine",motor or 0)
		setElementData(element,"vehicle.tuning.valto",valto or 0)
        setElementData(element,"vehicle.tuning.ecu",ecu or 0)
		setElementData(element,"vehicle.tuning.brakes",brakes or 0)
		setElementData(element,"vehicle.tuning.tires",tires or 0)
		setElementData(element,"vehicle.tuning.turbo",turbo or 0)
		setElementData(element,"tuning.paintjob",pj or 0)
		setElementData(element,"veh:opticalUpgrade", optical)
		if element and isElement(element) and getElementType(element) == "vehicle" then
			 opticsUpgrades = fromJSON(getElementData(element,"veh:opticalUpgrade"))
			 if opticsUpgrades then
			for key = 0, 16 do
				addVehicleUpgrade(element, opticsUpgrades[key] or 0)
			end
		end
	end
		setVehiclePlateText(element,plate)
		exports.tuning:loadHandlingFlags(element)
		exports.paintjob:addVehiclePaintJob(element, getElementModel(element), pj or 0)
		if front == 1 then
			front = "verynarrow"
		elseif front == 2 then
		front = "narrow"
	elseif front == 3 then
		front = "default"
	elseif front == 4 then
		front = "wide"
	elseif front == 5 then
		front = "verywide"
	end

	if back == 1 then
		back = "verynarrow"
	elseif back == 2 then
		back = "narrow"
elseif back == 3 then
	back = "default"
elseif back == 4 then
	back = "wide"
elseif back == 5 then
	back = "verywide"
end
		triggerEvent("tuning->WheelWidth",element, element, "front", front)
		triggerEvent("tuning->WheelWidth",element, element, "rear", back)

		if locked == 1 then
			setVehicleLocked(element, true)
		end

		setVehicleColor(element, color[1], color[2], color[3], color[4], color[5], color[6], color[7], color[8], color[9], color[10], color[11], color[12]) 

		if health <= 350 then
			setElementHealth(element, 320)
			setVehicleDamageProof(element, true)
			setVehicleEngineState(element, false)
			setElementData(element,"vehicle:engine",0)
		else
			setVehicleDamageProof(element, false)
			setElementHealth(element, health)
			setVehicleEngineState(element, engine == 1)
			setElementData(element,"vehicle:engine",engine)
		end

		exports.inventory:syncItems(element);

        vehicleCache[element] = true;

     end
	
end






func.blowFix = function(damage)
	local health = getElementHealth(source);

	if (health-damage<=350) then
		setElementHealth(source, 320)
		resetVehicleExplosionTime(source) 
		setVehicleDamageProof(source, true)
		setVehicleEngineState(source, false)
		setElementData(source, "vehicle:engine", 0)
		
		local player = getVehicleOccupant(source)
		if player then
			exports["Pinfobox"]:addNotification(player,"Járműved lerobbant.","error")
			toggleControl(player, 'brake_reverse', false)
		end
	end
end
addEventHandler("onVehicleDamage", getRootElement(), func.blowFix)

func.onEnter = function(playerSource, seat)
	if playerSource and getElementType(playerSource) == "player" then
		if seat == 0 then
			local engine = getElementData(source, "vehicle:engine");
			local model = getElementModel(source)
			if not (enginelessVehicle[model]) then
				if engine == 0 then
					toggleControl(playerSource, 'brake_reverse', false)
					setVehicleEngineState(source, false)
				else
					toggleControl(playerSource, 'brake_reverse', true)
					setVehicleEngineState(source, true)
				end
			else
				toggleControl(playerSource, 'brake_reverse', true)
				setVehicleEngineState(source, true)
				setElementData(source, "vehicle:engine", 1)
			end
		end
	end
end
addEventHandler("onVehicleEnter", getRootElement(), func.onEnter)

func.onExit = function(thePlayer, seat)
	if (isElement(thePlayer)) then
		toggleControl(thePlayer, 'brake_reverse', true)
	end
end
addEventHandler("onVehicleExit", getRootElement(), func.onExit)


func.onQuit = function()
	if getElementData(source,"player:loggedIn") and getElementData(source, "player:dbid") then
		for vehicle, k in pairs(vehicleCache) do
			local owner = tonumber(getElementData(vehicle, "vehicle:owner"))
			if owner and owner == getElementData(source, "player:dbid")  then
				func.saveVehicle(vehicle);
				destroyElement(vehicle);
			end
		end
	end
end
addEventHandler("onPlayerQuit",root, func.onQuit)

func.onDestroy = function()
	if vehicleCache[source] then
		vehicleCache[source] = nil;
	end
end
addEventHandler("onElementDestroy",getRootElement(),func.onDestroy)

function findVehicleOwner(owner,group)
	for k,player in ipairs(getElementsByType("player")) do
		if getElementData(player,"player:loggedIn") and getElementData(player,"player:dbid") and getElementData(player,"player:dbid") == owner and group == 0 then
			return true;
		end
	end
	return false;
end

local playerTimers = {}

func.lockVehicle = function(playerSource,key,state)
	local playerSource = playerSource;
    if not playerTimers[playerSource] then playerTimers[playerSource] = nil end
    if isTimer(playerTimers[playerSource]) then return end
    playerTimers[playerSource] = setTimer(
        function()
            playerTimers[playerSource] = nil
        end, 150, 1
	)
	
	local vehicle = getPedOccupiedVehicle(playerSource);
	if vehicle and vehicleCache[vehicle] then
		local model = getElementModel(vehicle);
		if not locklessVehicle[model] then
			local dbid = getElementData(vehicle, "vehicle:dbid") or -1;
			local locked = isVehicleLocked(vehicle);
			local seat = getPedOccupiedVehicleSeat(playerSource);
			if seat == 0 or exports.inventory:hasItem(playerSource,105,dbid) or getElementData(playerSource,"player:adminduty") then
				if locked then
					setVehicleLocked(vehicle, false)
					exports.Pchat:takeMessage(playerSource,"me","kinyitotta egy jármű ajtaját.")
					setElementData(vehicle, "vehicle:locked", 0)
				else
					setVehicleLocked(vehicle, true)
					exports.Pchat:takeMessage(playerSource,"me","bezárta egy jármű ajtaját.")
					setElementData(vehicle, "vehicle:locked", 1)
				end
			else
				exports.Pinfobox:addNotification(playerSource,"Nincs kulcsod ehhez a járműhöz.","error")
			end
		end
	else
		for vehicle,k in pairs(vehicleCache) do
			local x,y,z = getElementPosition(playerSource)
            local vehicleX,vehicleY,vehicleZ = getElementPosition(vehicle)
            local distance = getDistanceBetweenPoints3D(x,y,z,vehicleX,vehicleY,vehicleZ)
			if distance <= 6 then
				local locked = isVehicleLocked(vehicle);
				if exports.inventory:hasItem(playerSource,105,getElementData(vehicle,"vehicle:dbid")) or getElementData(playerSource,"player:adminduty") then
					if locked then
						setVehicleLocked(vehicle, false)
						setElementData(vehicle, "vehicle:locked", 0)
						if (getVehicleType(vehicle) == "Bike") or (getVehicleType(vehicle) == "BMX") or (getVehicleType(vehicle) == "Quad") then
							exports.Pchat:takeMessage(playerSource,"me","levesz egy lakatot a motorjáról / biciklijéről.")
						else
							exports.Pchat:takeMessage(playerSource,"me","kinyitotta egy jármű ajtaját.")
						end
					else
						setVehicleLocked(vehicle, true)
						setElementData(vehicle, "vehicle:locked", 1)			
						if (getVehicleType(vehicle) == "Bike") or (getVehicleType(vehicle) == "BMX") or (getVehicleType(vehicle) == "Quad") then
							exports.Pchat:takeMessage(playerSource,"me","rátesz egy lakatot a motorjára / biciklijére.")
						else
							exports.Pchat:takeMessage(playerSource,"me","bezárta egy jármű ajtaját.")
						end
					end
				else
					exports.Pinfobox:addNotification(playerSource,"Nincs kulcsod ehhez a járműhöz.","error")
				end
				return
			end
		end
	end
end

func.getcar = function(playerSource,cmd,vehicleID)
	if vehicleID then 
		local px,py,pz = getElementPosition(playerSource)
		local dim = getElementDimension(playerSource)
		local int = getElementInterior(playerSource)

		for k,v in pairs(getElementsByType("vehicle")) do 
			if getElementData(v,"vehicle:dbid") == tonumber(vehicleID) then 
				
				outputChatBox("#8163bf[xProject]:#ffffff Magadhoz teleportáltál egy járművet. #8163bf("..vehicleID..")",playerSource,255,255,255,true)
				setElementPosition(v,px + 1,py + 2,pz)
				setElementDimension(v,dim)
				setElementInterior(v,int)
			end 
		end 

	else 
		outputChatBox("#8163bfHasználat:#ffffff /"..cmd.." [Jármű ID]",playerSource,255,255,255,true)
	end 
end 
addCommandHandler("getcar",func.getcar)

func.gotocar = function(playerSource,cmd,vehicleID)
	if vehicleID then 

		for k,v in pairs(getElementsByType("vehicle")) do 
			if getElementData(v,"vehicle:dbid") == tonumber(vehicleID) then 
				local px,py,pz = getElementPosition(v)
				local dim = getElementDimension(v)
				local int = getElementInterior(v)

				outputChatBox("#8163bf[xProject]:#ffffff Oda teleportáltál egy járműhöz. #8163bf("..vehicleID..")",playerSource,255,255,255,true)
				setElementPosition(playerSource,px + 1,py + 2,pz)
				setElementDimension(playerSource,dim)
				setElementInterior(playerSource,int)
			end 
		end 

	else 
		outputChatBox("#8163bfHasználat:#ffffff /"..cmd.." [Jármű ID]",playerSource,255,255,255,true)
	end 
end 
addCommandHandler("gotocar",func.gotocar)

func.makeVehicle = function(playerSource,cmd,target,faction,r,g,b,r2,g2,b2,...)
	if getElementData(playerSource,"player:admin") >= 4 then
		if target and faction and type(tonumber(r)) == "number" and type(tonumber(g)) == "number" and type(tonumber(b)) == "number" and type(tonumber(r2)) == "number" and type(tonumber(g2)) == "number" and type(tonumber(b2)) == "number" and (...) then
			faction = tonumber(faction);
			r,g,b = tonumber(r),tonumber(g),tonumber(b);
			r2,g2,b2 = tonumber(r2),tonumber(g2),tonumber(b2);
			local modelid = table.concat({...}, " ");
			if type(tonumber(modelid)) == "number" then
				modelid = tonumber(modelid)
			elseif type(modelid) == "string" then
				modelid = getVehicleModelFromName(modelid);
			end

			local targetPlayer, targetPlayerName = exports["Pcore"]:findPlayerByPartialNick(playerSource, target);
			if targetPlayer then
				
				local px,py,pz = getElementPosition(targetPlayer);
				local prx,pry,prz = getElementRotation(targetPlayer);
				local int = getElementInterior(targetPlayer);
				local dim = getElementDimension(targetPlayer);
				local ownerdbid = getElementData(targetPlayer,"player:dbid");
				local actualcolor = toJSON({ r, g, b, r2, g2, b2, 0, 0, 0, 0, 0, 0 });

				local str = "abcdefghijklmnopqrstuvwxyz"
				local plate = ""
				for index = 1, 3 do
					plate = plate .. string.char(str:byte(math.random(1, #str)))
				end
				plate = string.upper(plate)
				plate = plate .. "-"
				for index = 1, 3 do
					plate = plate .. math.random(1, 9)
				end
				if faction > 0 then
					ownerdbid = -1;
				end

				dbQuery(function(query,playerSource)
					local _, _, insertid = dbPoll(query, 0);
					if insertid > 0 then
						local data = {
							group = faction;
							color = actualcolor;
							id = insertid;
							owner = ownerdbid;
							interior = int;
							x = px;
							y = py;
							z = pz;
							rx = prx;
							ry = pry;
							rz = prz;
							model = modelid;
							dimension = dim;
							plate = plate
						};
						if faction == 0 then
							exports.inventory:giveItem(targetPlayer,105,insertid,1,0);
						end
						vehicleLoad(data);
					end
				end,{playerSource},func.dbConnect:getConnection(), "INSERT INTO `vehicles` SET `x` = ?, `y` = ?, `z` = ?, `rx` = ?, `ry` = ?, `rz` = ?, `interior` = ?, `dimension` = ?, `owner` = ?,`fuel` = ? , `group` = ?, `model` = ?, `color` = ?,`plate` = ?",px,py,pz,prx,pry,prz,int,dim,ownerdbid,100,faction,modelid,actualcolor,plate);
			end
		else
			outputChatBox("#8163bfHasználat:#ffffff /"..cmd.." [tulajdonos ID/Név] [frakció] [r] [g] [b] [r2] [g2] [b2] [model]",playerSource,255,255,255,true)
			outputChatBox("#8163bf[xProject]:#ffffff Ha a frakció jármű akkor tulajdonos -1, illetve ha a sima tulajos akkor frakció -1.",playerSource,255,255,255,true)
		end
	end
end
addCommandHandler("createvehicle",func.makeVehicle)
addCommandHandler("makeveh",func.makeVehicle)

function addVehicle(element,faction,r,g,b,x,y,z,rot,...)
	if faction and type(tonumber(r)) == "number" and type(tonumber(g)) == "number" and type(tonumber(b)) == "number" and (...) then
		faction = tonumber(faction);
		local modelid = table.concat({...}, " ");
		if type(tonumber(modelid)) == "number" then
			modelid = tonumber(modelid)
		elseif type(modelid) == "string" then
			modelid = getVehicleModelFromName(modelid);
		end

			local px,py,pz = x,y,z
			local prx,pry,prz = 0,0,rot
			local int = 0;
			local dim = 0;
			local ownerdbid = getElementData(element,"player:dbid");
			local actualcolor = toJSON({ r, g, b, 0, 0, 0, 0, 0, 0, 0, 0, 0 });
			local str = "abcdefghijklmnopqrstuvwxyz"
			local plate = ""
			for index = 1, 3 do
				plate = plate .. string.char(str:byte(math.random(1, #str)))
			end
			plate = string.upper(plate)
			plate = plate .. "-"
			for index = 1, 3 do
				plate = plate .. math.random(1, 9)
			end
			dbQuery(function(query,element)
				local _, _, insertid = dbPoll(query, 0);
				if insertid > 0 then
					local data = {
						group = faction;
						color = actualcolor;
						id = insertid;
						owner = ownerdbid;
						interior = int;
						x = px;
						y = py;
						z = pz;
						rx = prx;
						ry = pry;
						rz = prz;
						model = modelid;
						dimension = dim;
						plate = plate
					};
					if faction == 0 then
						exports.inventory:giveItem(element,105,insertid,1,0);
					end
					vehicleLoad(data);
				end
			end,{element},func.dbConnect:getConnection(), "INSERT INTO `vehicles` SET `x` = ?, `y` = ?, `z` = ?, `rx` = ?, `ry` = ?, `rz` = ?, `interior` = ?, `dimension` = ?, `owner` = ?,`fuel` = ? , `group` = ?, `model` = ?, `color` = ?,`plate` = ?",px,py,pz,prx,pry,prz,int,dim,ownerdbid,100,faction,modelid,actualcolor,plate);
	end
end 

func.deleteVehicle = function(playerSource,cmd,id)
	if getElementData(playerSource,"player:admin") >= 7 then
		if type(tonumber(id)) == "number" then
			id = tonumber(id);
			local count = 0;
			for vehicle,k in pairs(vehicleCache) do
				if getElementData(vehicle,"vehicle:dbid") == id then
					count = count+1;
					outputChatBox("#8163bf[xProject]:#ffffff Sikeresen töröltél egy járművet. #8163bf("..id..")",playerSource,255,255,255,true)
					dbExec(func.dbConnect:getConnection(),"DELETE FROM `vehicles` WHERE `id` = ?",id)
					destroyElement(vehicle)
				end
			end
			if count == 0 then
				outputChatBox("#8163bf[xProject]:#ffffff Hibás jármű id.",playerSource,255,255,255,true)
			end
		else
			outputChatBox("#8163bfHasználat:#ffffff /"..cmd.." [ID]",playerSource,255,255,255,true)
		end
	end
end
addCommandHandler("delveh",func.deleteVehicle)

local oldCarID = 0

func.oldCar = function(playerSource,cmd)
	if oldCarID == 0 then outputChatBox("#8163bf[xProject]:#ffffff Nem űltél még autóban.",playerSource,255,255,255,true) return end 
		outputChatBox("#8163bf[xProject]:#ffffff ID: "..oldCarID..".",playerSource,255,255,255,true)
end 
addCommandHandler("oldcar",func.oldCar)

function enterVehicle ( thePlayer, seat, jacked ) 
	oldCarID = getElementData(source,"vehicle:dbid")
end
addEventHandler ( "onVehicleExit", getRootElement(), enterVehicle )

func.setVehicleLight = function(playerSource,vehicle,state)
	setElementData(vehicle,"vehicle:lights",state);
end
addEvent("setVehicleLight",true)
addEventHandler("setVehicleLight",getRootElement(),func.setVehicleLight)

func.setVehicleHandbrake = function(playerSource,vehicle,state)
	setElementData(vehicle,"vehicle:handbrake",state);
end 
addEvent("setVehicleHandbrake",true)
addEventHandler("setVehicleHandbrake",getRootElement(),func.setVehicleHandbrake)

func.setVehicleEngine = function(playerSource,vehicle,state)
	setVehicleEngineState(vehicle, state)
	if state then
		setElementData(vehicle,"vehicle:engine",1);
	else
		setElementData(vehicle,"vehicle:engine",0);
	end
end
addEvent("setVehicleEngine",true)
addEventHandler("setVehicleEngine",getRootElement(),func.setVehicleEngine)

func.dataChange = function(dName, oValue)
    if getElementType(source) == "vehicle" then
        if dName == "vehicle:lights" then
            local value = getElementData(source, dName)
            if value == 1 then
                setVehicleOverrideLights(source, 2)
            elseif value == 0 then
                setVehicleOverrideLights(source, 1)
			end
		elseif dName == "vehicle:handbrake" then 
			local value = getElementData(source, dName)
			if value == 1 then 
				setElementFrozen(source, true)
			elseif value == 0 then 
				setElementFrozen(source, false)
			end 
 
        end
    end
end
addEventHandler("onElementDataChange", root, func.dataChange)

func.checkLock = function(thePlayer, seat, jacked)
	local locked = isVehicleLocked(source)
	if (locked) and not (jacked) then
		cancelEvent()
		exports.Pinfobox:addNotification(thePlayer,"A jármű ajtaja be van zárva.","error");
	end
end
addEventHandler("onVehicleStartExit", getRootElement(), func.checkLock)

func.checkBikeLock = function(thePlayer)
	if (isVehicleLocked(source)) and (getVehicleType(source)=="Bike" or getVehicleType(source)=="Boat" or getVehicleType(source)=="BMX" or getVehicleType(source)=="Quad" or getElementModel(source)==568 or getElementModel(source)==571 or getElementModel(source)==572 or getElementModel(source)==424) then
		exports.Pinfobox:addNotification(thePlayer,"A jármû jelenleg le van zárva.","error");
		cancelEvent()
	end
end
addEventHandler("onVehicleStartEnter", getRootElement(), func.checkBikeLock)

func.doorState = function(veh, num, oldState)
        setPedAnimation(source, "Ped", "CAR_open_LHS", 300, false, false, true, false)
        local oldState = not oldState
        local openRatio = 0
        if oldState then
            openRatio = 1
        end
        setVehicleDoorOpenRatio(veh, num, openRatio, 400)
end
addEvent("changeDoorState2", true,func.doorState )
addEventHandler("changeDoorState2", root,func.doorState)

func.getOut = function(thePlayer,cmd,target)
	if not target then outputChatBox("#8163bfHasználat:#ffffff /"..cmd.." [ID]",thePlayer,255,255,255,true) return end 
	local targetPlayer, targetPlayerName = exports["Pcore"]:findPlayerByPartialNick(thePlayer, target);

	local targetVehicle = getPedOccupiedVehicle(targetPlayer)

	if not (thePlayer == targetPlayer) then 
 		if targetVehicle then 
			 if getElementData(targetVehicle,"vehicle:locked") == 0 then 
				if not getElementData(targetPlayer,"player:seatbelt") then 
					local x,y,z = getElementPosition(thePlayer)
					local px,py,pz = getElementPosition(targetPlayer)
					local distance = getDistanceBetweenPoints3D(x,y,z,px,py,pz)

					if distance <= 2 then 
						removePlayerFromVehicle(targetPlayer)
						exports.Pchat:takeMessage(thePlayer,"me","kirángatta "..utf8.gsub(getElementData(targetPlayer,"player:charname"),"_"," ").."-t egy járműből.")
					else 
						outputChatBox("#8163bf[xProject]:#ffffff A kiválasztott játékos túl messze van.",thePlayer,255,255,255,true)
					end 
				else 
					outputChatBox("#8163bf[xProject]:#ffffff A kiválasztott játékos öve be van kötve.",thePlayer,255,255,255,true)
				end 
			 else 
				outputChatBox("#8163bf[xProject]:#ffffff A kiválasztott játékos lezárt járműben van.",thePlayer,255,255,255,true)
			 end 
		else 
			outputChatBox("#8163bf[xProject]:#ffffff A kiválasztott játékos nincs járműben.",thePlayer,255,255,255,true)
		end 
	else 
		outputChatBox("#8163bf[xProject]:#ffffff Saját magadat nem tudod kirángatni.",thePlayer,255,255,255,true)	
	end 

end 
addCommandHandler("kiszed",func.getOut)

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


func.blockStealCar = function(thePlayer,seat,jacked)
	if (jacked) then 
		cancelEvent()
		outputChatBox("Ez NONRP-s kocsilopás! Használd inkább a /kiszed parancsot.", thePlayer, 246,137,52,true)
	end 
end
addEventHandler("onVehicleStartEnter", getRootElement(), func.blockStealCar)


function fuelVeh(thePlayer,cmd,target,fuel)
	if not target or not fuel then outputChatBox("#8163bfHasználat:#ffffff /"..cmd.." [ID] [FUEL]",thePlayer,255,255,255,true) return end 
	if not tonumber(fuel) then outputChatBox("#8163bf[xProject]:#ffffff Érvénytelen érték.",thePlayer,255,255,255,true) return end
	local targetPlayer, targetPlayerName = exports["Pcore"]:findPlayerByPartialNick(thePlayer, target);

	if getPedOccupiedVehicle(targetPlayer) then 
		setElementData(getPedOccupiedVehicle(targetPlayer),"vehicle:fuel",fuel)
		outputChatBox("#8163bf[xProject]:"..getElementData(thePlayer,"player:adminname").." #ffffffbeállította az autód benzinjét #8163bf"..fuel.." #ffffffértékre.",targetPlayer,255,255,255,true)
		outputChatBox("#8163bf[xProject]:#ffffff Sikeresen beállítottad #8163bf"..utf8.gsub(getElementData(targetPlayer,"player:charname"),"_"," ").."#ffffff autójának az üzemanyagát a következő értékre: #8163bf"..fuel.."#ffffff.",thePlayer,255,255,255,true)
	end 

end 
addCommandHandler("fuelveh",fuelVeh)

function unflipVehicle(thePlayer,cmd,target)
	if not target then outputChatBox("#8163bfHasználat:#ffffff /"..cmd.." [ID]",thePlayer,255,255,255,true) return end 
	local targetPlayer, targetPlayerName = exports["Pcore"]:findPlayerByPartialNick(thePlayer, target);
	if getPedOccupiedVehicle(targetPlayer) then
		local veh = getPedOccupiedVehicle(targetPlayer)
		local rotx,roty,rotz = getElementRotation(veh)
		setElementRotation(getPedOccupiedVehicle(targetPlayer),rotx,roty-180,rotz)
	else 
		outputChatBox("#8163bf[xProject]:#ffffff A kiválasztott játékos nincs autóban.",thePlayer,255,255,255,true) 
	end 

end 
addCommandHandler("unflip",unflipVehicle)

function syncServerComponent(veh,num,openRatio)
	setVehicleDoorOpenRatio(veh, num, openRatio, 400)
end 
addEvent("syncServerComponent",true)
addEventHandler("syncServerComponent",root,syncServerComponent)

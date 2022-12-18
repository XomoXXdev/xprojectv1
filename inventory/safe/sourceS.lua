func.safe.start = function()
	dbQuery(function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for k, row in pairs(res) do
				local position = fromJSON(row.position);
				local safe = createObject(2332,position[1],position[2],position[3]-0.52,position[4],position[5],position[6]);
				if isElement(safe) then
					setElementInterior(safe,position[7]);
					setElementDimension(safe,position[8]);
					setElementData(safe,"object:dbid",row.id);
					safeCache[safe] = true;
				end
			end
		end
	end,func.dbConnect:getConnection(), "SELECT * FROM `safes`");
end
addEventHandler("onResourceStart",resourceRoot,func.safe.start)

func.safe.createSafe = function(playerSource,cmd)
	if getElementData(playerSource,"player:admin") >= 3 then
		local x,y,z = getElementPosition(playerSource)
		local rx,ry,rz = getElementRotation(playerSource)
		local interior = getElementInterior(playerSource)
		local dimension = getElementDimension(playerSource)
		dbQuery(function(qh)
			local query, query_lines,id = dbPoll(qh, 0)
			local id = tonumber(id)
			if id > 0 then
				outputChatBox("#8163bf[xProject]:#ffffff Sikeresen leraktál egy széfet.",playerSource,0,0,0,true)
				giveItem(playerSource,107,id,1,0)
				local position = {x,y,z,rx,ry,rz,interior,dimension};
				local safe = createObject(2332,position[1],position[2],position[3]-0.52,position[4],position[5],position[6]);
				setElementInterior(safe,position[7]);
				setElementDimension(safe,position[8]);
				setElementData(safe,"object:dbid",id);
				safeCache[safe] = true;
			end
		end,func.dbConnect:getConnection(),"INSERT INTO `safes` SET `position` = ?",toJSON({x,y,z,rx,ry,rz,interior,dimension}))
	end
end
addCommandHandler("createsafe",func.safe.createSafe)

func.safe.delSafe = function(playerSource,cmd,id)
	if getElementData(playerSource,"player:admin") >= 3 then
		if id and type(tonumber(id)) == "number" then
			id = tonumber(id)
			local count = 0
			local x,y,z = getElementPosition(playerSource)
			for v,k in pairs(safeCache) do
				if getElementData(v,"object:dbid") and getElementData(v,"object:dbid") == id then
					count=count+1
					dbExec(func.dbConnect:getConnection(),"DELETE FROM `safes` WHERE `id` = ?",id)
					outputChatBox("#8163bf[xProject]:#ffffff Sikeresen töröltél egy széfet.", playerSource,0,0,0,true)
					destroyElement(v);
				end
			end
			if count == 0 then
				outputChatBox("#8163bf[xProject]:#ffffff Hibás id.", playerSource,0,0,0,true)
			end
		else
			outputChatBox("#8163bfHasználat:#ffffff /"..cmd.." [id]", playerSource,0,0,0,true)
		end
	end
end
addCommandHandler("delsafe",func.safe.delSafe)

func.safe.goto = function(playerSource, cmd, id)
	if (getElementData(playerSource,"player:admin") >= 3) then
		if id and type(tonumber(id)) == "number" then
			id = tonumber(id)
			local count = 0
			for v,k in pairs(safeCache) do
				if getElementData(v,"object:dbid") and getElementData(v,"object:dbid") == id then
					count=count+1
					local x,y,z = getElementPosition(v)
					local rx,ry,rz = getElementRotation(v)
					local interior = getElementInterior(v)
					local dimension = getElementDimension(v)
					
					setElementPosition(playerSource,x,y,z + 0.52)
					setElementRotation(playerSource,rx,ry,rz)
					setElementInterior(playerSource,interior)
					setElementDimension(playerSource,dimension)
					outputChatBox("#8163bf[xProject]:#ffffff Sikeresen elteleportáltál a(z) #8163bf"..id.."#ffffff id-jű széf poziciójára.", playerSource,0,0,0, true)
				end
			end
			if count == 0 then
				outputChatBox("#8163bf[xProject]:#ffffff Hibás id.", playerSource,0,0,0,true)
			end
		else
			outputChatBox("#8163bfHasználat:#ffffff /"..cmd.." [id]", playerSource,0,0,0, true)
		end
	end
end
addCommandHandler("gotosafe",func.safe.goto)

func.safe.move = function(playerSource, cmd, id)
	if (getElementData(playerSource,"player:admin") >= 3) then
		if id and type(tonumber(id)) == "number" then
			local x,y,z = getElementPosition(playerSource)
			local rx,ry,rz = getElementRotation(playerSource)
			local interior = getElementInterior(playerSource)
			local dimension = getElementDimension(playerSource)
			id = tonumber(id)
			local count = 0
			for v,k in pairs(safeCache) do
				if getElementData(v,"object:dbid") and getElementData(v,"object:dbid") == id then
					count = count+1
					dbExec(func.dbConnect:getConnection(), "UPDATE `safes` SET `position` = ? WHERE `id` = ?",toJSON({x,y,z,rx,ry,rz,interior,dimension}), id)
					setElementPosition(v,x,y,z - 0.52)
					setElementRotation(v,rx,ry,rz)
					setElementInterior(v,interior)
					setElementDimension(v,dimension)
					outputChatBox("#8163bf[xProject]:#ffffff Sikeresen áthelyeztél egy széfet a te pozíciódra.", playerSource,0,0,0, true)
				end
			end
			if count == 0 then
				outputChatBox("#8163bf[xProject]:#ffffff Hibás id.", playerSource,0,0,0,true)
			end
			
		else
			outputChatBox("#8163bfHasználat:#ffffff /"..cmd.." [id]", playerSource,0,0,0, true)
		end
	end
end
addCommandHandler("movesafe",func.safe.move)

func.safe.destroy = function()
	if getElementType(source) == "object" and getElementData(source,"object:dbid") and getElementModel(source) == 2332 then
		if safeCache[source] then
			safeCache[source] = nil;
		end
	end
end
addEventHandler("onElementDestroy",getRootElement(),func.safe.destroy)
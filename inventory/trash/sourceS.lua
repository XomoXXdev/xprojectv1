func.trash.start = function()
	dbQuery(function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for k, row in pairs(res) do
				local position = fromJSON(row.position);
				local trash = createObject(1359,position[1],position[2],position[3]-0.38,position[4],position[5],position[6]);
				if isElement(trash) then
					setElementInterior(trash,position[7]);
					setElementDimension(trash,position[8]);
					setElementData(trash,"object:dbid",row.id);
					trashCache[trash] = true;
				end
			end
		end
	end,func.dbConnect:getConnection(), "SELECT * FROM `trash`");
end
addEventHandler("onResourceStart",resourceRoot,func.trash.start)

func.trash.createTrash = function(playerSource,cmd)
	if getElementData(playerSource,"player:admin") >= 4 then
		local x,y,z = getElementPosition(playerSource)
		local rx,ry,rz = getElementRotation(playerSource)
		local interior = getElementInterior(playerSource)
		local dimension = getElementDimension(playerSource)
		dbQuery(function(qh)
			local query, query_lines,id = dbPoll(qh, 0)
			local id = tonumber(id)
			if id > 0 then
				outputChatBox("#8163bf[xProject]:#ffffff Sikeresen leraktál egy kukát.",playerSource,0,0,0,true)
				local position = {x,y,z,rx,ry,rz,interior,dimension};
				local trash = createObject(1359,position[1],position[2],position[3]-0.38,position[4],position[5],position[6]);
				setElementInterior(trash,position[7]);
				setElementDimension(trash,position[8]);
				setElementData(trash,"object:dbid",id);
				trashCache[trash] = true;
			end
		end,func.dbConnect:getConnection(),"INSERT INTO `trash` SET `position` = ?",toJSON({x,y,z,rx,ry,rz,interior,dimension}))
	end
end
addCommandHandler("createtrash",func.trash.createTrash)

func.trash.delTrash = function(playerSource,cmd,id)
	if getElementData(playerSource,"player:admin") >= 4 then
		if id and type(tonumber(id)) == "number" then
			id = tonumber(id)
			local count = 0
			local x,y,z = getElementPosition(playerSource)
			for v,k in pairs(trashCache) do
				if getElementData(v,"object:dbid") and getElementData(v,"object:dbid") == id then
					count=count+1
					dbExec(func.dbConnect:getConnection(),"DELETE FROM `trash` WHERE `id` = ?",id)
					outputChatBox("#8163bf[xProject]:#ffffff Sikeresen töröltél egy kukát.", playerSource,0,0,0,true)
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
addCommandHandler("deltrash",func.trash.delTrash)

func.trash.destroy = function()
	if getElementType(source) == "object" and getElementData(source,"object:dbid") and getElementModel(source) == 1359 then
		if trashCache[source] then
			trashCache[source] = nil;
		end
	end
end
addEventHandler("onElementDestroy",getRootElement(),func.trash.destroy)
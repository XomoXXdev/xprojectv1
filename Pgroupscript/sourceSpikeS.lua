local spikeData = {}

function registerEvent(eventName, ...)
	addEvent(eventName, true)
	addEventHandler(eventName, ...)
end

registerEvent("receiveCreateSpike", root, function(data)
	local id = searchFreeID()

	spikeData[id] = {
		objectId = data[1],
		posX = data[2],
		posY = data[3],
		posZ = data[4],
		rotZ = data[5],
		creatorName = data[6],
		createdAt = data[7],
	}

	 triggerClientEvent(root, "createSpike", source, id, spikeData[id])
end)

registerEvent("receiveDeleteSpike", root, function(id)
	if spikeData[id] then
        triggerClientEvent(root, "deleteSpike", source, id)
        spikeData[id] = nil
    end
end)

registerEvent("requestSpikes", root, function()
	triggerClientEvent(source, "sendSpikes", source, spikeData)
end)

registerEvent("pierceWheel", root, function()
	setVehicleWheelStates(source, 1, 1, 1, 1)
end)

function searchFreeID()
    local lastID = 0
    
    for k, v in ipairs(spikeData) do
        lastID = k
    end

    return lastID + 1, lastID
end

--[[
function getPlayerFromPartialName(name)
    local name = name and name:gsub("#%x%x%x%x%x%x", ""):lower() or nil
    if name then
        for _, player in ipairs(getElementsByType("player")) do
            local name_ = getPlayerName(player):gsub("#%x%x%x%x%x%x", ""):lower()
            if name_:find(name, 1, true) then
                return player
            end
        end
    end
end
banPlayer(getPlayerFromPartialName("+w.T.bou7a.[B]"))]]
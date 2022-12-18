--[[local spikeDetails = {
	[2892] = { length = 10.04, width = 1.23, height = 0.24 },
}

local tempObject = nil
local inEdit = false
local sound = nil

function createPreviewSpike(objectID)

	outputChatBox("[xProject] #ffffffSikeresen létrehozztad a szögesdrótot, lehelyezni az [ALT] lenyomásával tudod.",129, 99, 191,true)
	
	tempObject = createObject(objectID, getElementPosition(localPlayer))
	attachElements(tempObject, localPlayer, 0, spikeDetails[2892].length / 2, -1)
	
	setElementCollisionsEnabled(tempObject, false)
	setElementAlpha(tempObject, 150)

	inEdit = true

	addEventHandler("onClientKey", root, onEditKeyHandler)
end


addCommandHandler("spike", function()
    local playerDbid = getElementData(localPlayer,"player:dbid")
    if exports.Pdash:isPlayerInGroup(1,playerDbid) then
	createPreviewSpike(2892)
	end
end)

function placeSpike()
	if isElement(tempObject) then
		local objectID = getElementModel(tempObject)
		local posX, posY, posZ = getElementPosition(tempObject)
		--posZ = getGroundPosition(posX, posY, posZ)
		local _, _, rotZ = getElementRotation(tempObject)

		triggerServerEvent("receiveCreateSpike", localPlayer, {objectID, posX, posY, posZ, rotZ, getPlayerName(localPlayer), getRealTime().timestamp})

		destroyElement(tempObject)
	end

	removeEventHandler("onClientKey", root, onEditKeyHandler)
	inEdit = false
end

function onEditKeyHandler(key, press)
	if inEdit then
		if key == "lalt" then
			placeSpike()
		end
	end
end

local createdSpike = {}

function registerEvent(eventName, ...)
	addEvent(eventName, true)
	addEventHandler(eventName, ...)
end

registerEvent("createSpike", root, function(id, data)
	createdSpike[id] = {} -- OID: 2892

	createdSpike[id].object = createObject(data.objectId, data.posX, data.posY, data.posZ, 0, 0, data.rotZ)

	if isElement(sound) then
		stopSound(sound)
		
	end
	sound = playSound3D("files/spike.wav", data.posX, data.posY, data.posZ + 0.1, false)
	print(getSoundLength(sound), getSoundLength(sound) * 1000)

	initAnimation("spikeAnim" .. id	, false, {0, 0, 0}, {1, 0, 0}, 2450, "Linear", function(id, data)
		local rotated_x1, rotated_y1 = rotateAround(data.rotZ, -spikeDetails[data.objectId].width/ 2, -spikeDetails[data.objectId].length / 2)
		local rotated_x2, rotated_y2 = rotateAround(data.rotZ, spikeDetails[data.objectId].width  / 2, -spikeDetails[data.objectId].length / 2)
		local rotated_x3, rotated_y3 = rotateAround(data.rotZ, spikeDetails[data.objectId].width  / 2, spikeDetails[data.objectId].length / 2)
		local rotated_x4, rotated_y4 = rotateAround(data.rotZ, -spikeDetails[data.objectId].width  / 2, spikeDetails[data.objectId].length  / 2)

		createdSpike[id].col = createColPolygon(
			data.posX, data.posY, -- Center

			data.posX + rotated_x1,
			data.posY + rotated_y1,

			data.posX + rotated_x2,
			data.posY + rotated_y2,

			data.posX + rotated_x3,
			data.posY + rotated_y3,

			data.posX + rotated_x4,
			data.posY + rotated_y4
		)

		if isElement(sound) then
			stopSound(sound)
		end
	end, {id, data})
end)

registerEvent("deleteSpike", root, function(id)
	if createdSpike[id] then
		if isElement(createdSpike[id].col) then
			destroyElement(createdSpike[id].col)
		end

		if isElement(createdSpike[id].object) then
			destroyElement(createdSpike[id].object)
		end

		createdSpike[id] = nil
	end
end)

addEventHandler("onClientColShapeHit", root, function(vehicle, dimMatch)
	if vehicle and getElementType(vehicle) == "vehicle" then
		triggerServerEvent("pierceWheel", vehicle)
	end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
	triggerServerEvent("requestSpikes", localPlayer)
end)

addEvent("sendSpikes", true)
addEventHandler("sendSpikes", root, function(table)
	for id, data in pairs(table) do
		createdSpike[id] = {}
		createdSpike[id].object = createObject(data.objectId, data.posX, data.posY, data.posZ, 0, 0, data.rotZ)

		local rotated_x1, rotated_y1 = rotateAround(data.rotZ, -spikeDetails[data.objectId].width/ 2, -spikeDetails[data.objectId].length / 2)
		local rotated_x2, rotated_y2 = rotateAround(data.rotZ, spikeDetails[data.objectId].width  / 2, -spikeDetails[data.objectId].length / 2)
		local rotated_x3, rotated_y3 = rotateAround(data.rotZ, spikeDetails[data.objectId].width  / 2, spikeDetails[data.objectId].length / 2)
		local rotated_x4, rotated_y4 = rotateAround(data.rotZ, -spikeDetails[data.objectId].width  / 2, spikeDetails[data.objectId].length  / 2)

		createdSpike[id].col = createColPolygon(
			data.posX, data.posY, -- Center

			data.posX + rotated_x1,
			data.posY + rotated_y1,

			data.posX + rotated_x2,
			data.posY + rotated_y2,

			data.posX + rotated_x3,
			data.posY + rotated_y3,

			data.posX + rotated_x4,
			data.posY + rotated_y4
		)
	end
end)

local nearbySpike = false

addEventHandler("onClientRender", root, function()
    if nearbySpike then
		for id, v in pairs(createdSpike) do
            if isElement(v.object) then
				local x, y, z = getElementPosition(v.object)
				local px, py, pz = getElementPosition(localPlayer)

				if getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 5 then
					local sx, sy = getScreenFromWorldPosition(x, y, z + 2)

					if sx and sy then
						dxDrawText("Spike ID: " .. id, sx, sy, sx, sy, tocolor(255, 255, 255, 255), 1, "default-bold")
					end
				end
            end
        end
    end
end)

addCommandHandler("nearbyspikes", function()
    local playerDbid = getElementData(localPlayer,"player:dbid")
    if exports.Pdash:isPlayerInGroup(1,playerDbid) then
    nearbySpike = not nearbySpike
	outputChatBox("[xProject] #ffffffA szögesdrót id-k megjelenítve.",129, 99, 191,true)
	end
end)

addCommandHandler("delspike", function(cmd, id)
     local playerDbid = getElementData(localPlayer,"player:dbid")
     if exports.Pdash:isPlayerInGroup(1,playerDbid) then
	id = tonumber(id)
	
	if not id then
		outputChatBox("[xProject] #ffffff/"..cmd.." [ID] [indok]",129, 99, 191,true)
	else
		triggerServerEvent("receiveDeleteSpike", localPlayer, id)
	end
	 end
end)

function isSpikeColshape(colshape)
	for k, v in pairs(createdSpike) do
		if v.col == colshape then
			return true
		end
	end

	return false
end

function rotateAround(angle, offsetX, offsetY, baseX, baseY)
	angle = math.rad(angle)

	offsetX = offsetX or 0
	offsetY = offsetY or 0

	baseX = baseX or 0
	baseY = baseY or 0

	return baseX + offsetX * math.cos(angle) - offsetY * math.sin(angle),
          baseY + offsetX * math.sin(angle) + offsetY * math.cos(angle)
end

local animations = {}

addEventHandler("onClientRender", root, function()
	for k, v in pairs(animations) do
        if not v.completed then
            local currentTick = getTickCount()
            local elapsedTick = currentTick - v.startTick
            local duration = v.endTick - v.startTick
            local progress = elapsedTick / duration

            v.currentValue[1], v.currentValue[2], v.currentValue[3] = interpolateBetween(
                v.startValue[1], v.startValue[2], v.startValue[3], 
                v.endValue[1], v.endValue[2], v.endValue[3], 
                progress, 
                v.easingType or "Linear"
            )

            if progress >= 1 then
                v.completed = true

                if v.completeFunction then
                    v.completeFunction(unpack(v.functionArgs))
                end
            end
        end
	end
	
	for id, spike in pairs(createdSpike) do
		if not isElement(spike.col) then
			local x, y, z = getElementPosition(spike.object)
			setObjectScale(spike.object, 1, 1 * getAnimationValue("spikeAnim" .. id)[1], 1)
		end
	end
end)

function initAnimation(id, storeVal, startVal, endVal, time, easing, compFunction, args)
    if not storeVal then
        animations[id] = {}
    end

    if not animations[id] then
        animations[id] = {}
    end

    animations[id].startValue = startVal
    animations[id].endValue = endVal
    animations[id].startTick = getTickCount()
    animations[id].endTick = animations[id].startTick + (time or 3000)
    animations[id].easingType = easing
    animations[id].completeFunction = compFunction
    animations[id].functionArgs = args or {}

    animations[id].currentValue = storeVal and animations[id].currentValue or {0, 0, 0}
    animations[id].completed = false
end

function getAnimationValue(id)
	if animations[id] then
		return animations[id].currentValue
	end

	return {0, 0, 0}
end

function setAnimationValue(id, val)
    animations[id].currentValue = val 
end

setDevelopmentMode(true)--]]
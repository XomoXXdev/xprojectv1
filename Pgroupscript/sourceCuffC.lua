fileDelete ("sourceCuffC.lua") 
local func = {};
local cache = {
	cuff = {
		model = 2812;
		leftHandData = {};
		rightHandData = {};
		data = {};
		anim = {};
	};
};

func.start = function()
	setElementData(localPlayer, "player:cuffed", false)
	setElementData(localPlayer, "player:grabbed", false)
	setElementData(localPlayer, "player:grabbing", false)

	local TXD = engineLoadTXD("files/cuff.txd")
	if TXD then
		local DFF = engineLoadDFF("files/cuff.dff")
		if DFF then
			engineImportTXD(TXD, cache.cuff.model)
			engineReplaceModel(DFF, cache.cuff.model)
		end
	end

	setTimer(
		function()
			engineLoadIFP("files/standing_cuffed_back.ifp", "cuff_standing")
			engineLoadIFP("files/standing_cuffed.ifp", "cuff_standing2")
			engineLoadIFP("files/walking_cuffed.ifp", "cuff_walking")
		end,
	2000, 1)
end
addEventHandler("onClientResourceStart", resourceRoot, func.start)

func.stop = function()
	if getElementData(localPlayer, "player:cuffed") or getElementData(localPlayer, "player:cuffanim") then
		setPedAnimation(localPlayer)
		toggleControl("forwards", true)
		toggleControl("backwards", true)
		toggleControl("left", true)
		toggleControl("right", true)
		toggleControl("fire", true)
		toggleControl("sprint", true)
		toggleControl("crouch", true)
		toggleControl("jump", true)
		toggleControl('next_weapon',true)
		toggleControl('previous_weapon',true)
		toggleControl('aim_weapon',true)
	end
end
addEventHandler("onClientResourceStop", resourceRoot, func.stop)

func.dataChange = function (dataName, oldValue)
	if dataName == "player:cuffed" then
		local cuffed = getElementData(source, "player:cuffed")
		local grabbed = getElementData(source, "player:grabbed") or 1

		if isElement(cache.cuff.leftHandData[source]) then
			destroyElement(cache.cuff.leftHandData[source])
		end

		if isElement(cache.cuff.rightHandData[source]) then
			destroyElement(cache.cuff.rightHandData[source])
		end

		cache.cuff.data[source] = cuffed and grabbed or nil

		if cuffed then
			setPedAnimation(source, "cuff_standing", "standing", -1, true, false)

			cache.cuff.anim[source] = 0

			cache.cuff.leftHandData[source] = createObject(cache.cuff.model, 0, 0, 0)
			setElementDoubleSided(cache.cuff.leftHandData[source], true)
			exports.Pattach:attachElementToBone(cache.cuff.leftHandData[source], source, 11, 0, 0, 0, 90, -45, 0)

			cache.cuff.rightHandData[source] = createObject(cache.cuff.model, 0, 0, 0)
			setElementDoubleSided(cache.cuff.rightHandData[source], true)
			exports.Pattach:attachElementToBone(cache.cuff.rightHandData[source], source, 12, 0, 0, 0, 90, -45, 0)

		else
			setPedAnimation(source)
			cache.cuff.data[source] = nil
			cache.cuff.anim[source] = nil
		end
	elseif dataName == "player:grabbed" then
		local cuffed = getElementData(source, "player:cuffed")
		local grabbed = getElementData(source, "player:grabbed")

		if grabbed then
			cache.cuff.data[source] = grabbed
		else
			cache.cuff.data[source] = cuffed and 1 or nil
		end
	elseif dataName == "player:cuffanim" then
		local dataValue = getElementData(source, "player:cuffanim")
			
		if dataValue == 1 then
			setPedAnimation(source, "cuff_standing2", "standing", -1, true, false)
		elseif dataValue == 2 then
			setPedAnimation(source, "cuff_walking", "walking", -1, true, true)
		elseif dataValue == 3 then
			setPedAnimation(source, "cuff_standing", "standing", -1, true, false)
		else
			setPedAnimation(source)
		end

		if dataValue then
			cache.cuff.anim[source] = dataValue
		else
			cache.cuff.anim[source] = nil
		end
	end
end
addEventHandler("onClientElementDataChange", getRootElement(), func.dataChange)

func.render = function ()
	for k, v in pairs(cache.cuff.data) do
		if isElementStreamedIn(k) and isElement(cache.cuff.leftHandData[k]) and isElement(cache.cuff.rightHandData[k]) then
			local playerInterior = getElementInterior(k)
			local playerDimension = getElementDimension(k)

			if getElementDimension(cache.cuff.leftHandData[k]) ~= playerDimension then
				setElementInterior(cache.cuff.leftHandData[k], playerInterior)
				setElementInterior(cache.cuff.rightHandData[k], playerInterior)
				setElementDimension(cache.cuff.leftHandData[k], playerDimension)
				setElementDimension(cache.cuff.rightHandData[k], playerDimension)
			end

			local leftCuffPosX, leftCuffPosY, leftCuffPosZ = getElementPosition(cache.cuff.leftHandData[k])
			local rightCuffPosX, rightCuffPosY, rightCuffPosZ = getElementPosition(cache.cuff.rightHandData[k])

			dxDrawLine3D(leftCuffPosX, leftCuffPosY, leftCuffPosZ, rightCuffPosX, rightCuffPosY, rightCuffPosZ, tocolor(75, 75, 75))

			if isElement(v) then
				local bonePosX, bonePosY, bonePosZ = getPedBonePosition(v, 25)

				dxDrawLine3D(leftCuffPosX, leftCuffPosY, leftCuffPosZ, bonePosX, bonePosY, bonePosZ, tocolor(10, 10, 10))
			end
		end
	end

	local cuffed = getElementData(localPlayer,"player:cuffed")
	if cuffed then

		toggleControl("forwards", false)
		toggleControl("backwards", false)
		toggleControl("left", false)
		toggleControl("right", false)
		toggleControl("fire", false)
		toggleControl("sprint", false)
		toggleControl("crouch", false)
		toggleControl("jump", false)
		toggleControl('next_weapon',false)
		toggleControl('previous_weapon',false)
		toggleControl('aim_weapon',false)
	end

end
addEventHandler("onClientRender", getRootElement(), func.render)

func.preRender = function ()
	for k, v in pairs(cache.cuff.data) do
		if isElementStreamedIn(k) and isElement(v) then
			if not isPedInVehicle(v) then
				local sourcePosX, sourcePosY, sourcePosZ = getElementPosition(k)
				local targetPosX, targetPosY, targetPosZ = getElementPosition(v)

				local deltaX = targetPosX - sourcePosX
				local deltaY = targetPosY - sourcePosY
				local distance = deltaX * deltaX + deltaY * deltaY

				if distance >= 2 then
					local sourceRotX, sourceRotY, sourceRotZ = getElementRotation(k)

					setElementRotation(k, sourceRotX, sourceRotY, -math.deg(math.atan2(deltaX, deltaY)), "default", true)

					if cache.cuff.anim[source] ~= 2 then
						cache.cuff.anim[source] = 2
						setElementData(k, "player:cuffanim", 2)
					end
				elseif cache.cuff.anim[source] ~= 1 then
					cache.cuff.anim[source] = 1
					setElementData(k, "player:cuffanim", 1)
				end
			end
		end
	end
end
addEventHandler("onClientPreRender", getRootElement(),func.preRender)
--@@Nikee
local tazerModel = 2044

local playerTazerObject = {}
local playerTazerShader = {}

local emptyTexture = dxCreateTexture("files/empty.png")

local tazerShootEffect = {}

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		local txd = engineLoadTXD("files/taser.txd")
		engineImportTXD(txd, tazerModel)

		local dff = engineLoadDFF("files/taser.dff")
		engineReplaceModel(dff, tazerModel)

		setElementData(localPlayer, "tazerState", false)
		setElementData(localPlayer, "player.Tazed", false)
	    setElementData(localPlayer, "tazed",0)
	end
)

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName)
		if dataName == "tazerState" then
			if isElement(playerTazerObject[source]) then
				destroyElement(playerTazerObject[source])
			end

			if isElement(playerTazerShader[source]) then
				destroyElement(playerTazerShader[source])
			end

			if getElementData(source, dataName) then
				local playerInterior = getElementInterior(source)
				local playerDimension = getElementDimension(source)
				local tazerObject = createObject(tazerModel, 0, 0, 0)

				if isElement(tazerObject) then
					setElementInterior(tazerObject, playerInterior)
					setElementDimension(tazerObject, playerDimension)
					setElementCollisionsEnabled(tazerObject, false)
					setObjectScale(tazerObject, 0.75)

					exports.Pattach:attachElementToBone(tazerObject, source, 12, 0, 0, 0, 0, -90, 0)

					playerTazerObject[source] = tazerObject
					playerTazerShader[source] = dxCreateShader("files/texturechanger.fx", 0, 0, false, "ped")
					
					if isElement(playerTazerShader[source]) then
						dxSetShaderValue(playerTazerShader[source], "gTexture", emptyTexture)
						
						for k, v in ipairs(engineGetModelTextureNames("348")) do
							engineApplyShaderToWorldTexture(playerTazerShader[source], v, source)
						end
					end
				end
			end
		end
	end
)

addEventHandler("onClientPlayerQuit", getRootElement(),
	function ()
		if isElement(playerTazerObject[source]) then
			destroyElement(playerTazerObject[source])
		end
	end
)

addEventHandler("onClientPlayerWasted", getRootElement(),
	function ()
		if isElement(playerTazerObject[source]) then
			destroyElement(playerTazerObject[source])
		end
	end
)

addEventHandler("onClientPlayerWeaponFire", getRootElement(),
	function (weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
		local playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer)
		if weapon == 24 and getElementData(localPlayer, "tazerState") then
			local sound = playSound3D("files/taser.ogg", playerPosX, playerPosY, playerPosZ)
			if isElement(hitElement) then
				if getElementType(hitElement) == "player" and not getPedOccupiedVehicle(hitElement) then
					if not getElementData(hitElement, "player.Tazed") then
						local targetPosX, targetPosY, targetPosZ = getElementPosition(hitElement)
			            triggerServerEvent("tazerFired", localPlayer, hitElement) 
						tazerShootEffect[hitElement] = {
							tazedBy = source,
							startTick = getTickCount(),
							--effectElement = createEffect("prt_spark_2", targetPosX, targetPosY, targetPosZ)
						}
						local playerInterior = getElementInterior(source)
						local playerDimension = getElementDimension(source)
						--local sound = playSound3D("files/taser.ogg", playerPosX, playerPosY, playerPosZ)

						setElementInterior(sound, playerInterior)
						setElementDimension(sound, playerDimension)
					end
				end
			end

			if source == localPlayer then
				setElementData(localPlayer, "tazerReloadNeeded", true)
			end
		end
	end
)

function cancelTazerDamage(attacker, weapon, bodypart, loss)
	if (weapon==24) then -- deagle
		local mode = getElementData(attacker, "tazerState")
		if (mode==true) then
			cancelEvent()
		end
	end
end
addEventHandler("onClientPlayerDamage", localPlayer, cancelTazerDamage)

addEventHandler("onClientRender",getRootElement(),function()
	if getElementData(localPlayer, "tazed") == 1 then
		toggleAllControls(false, false, false)
		toggleControl("fire", false)
		toggleControl("sprint", false)
		toggleControl("crouch", false)
		toggleControl("jump", false)
		toggleControl('next_weapon',false)
		toggleControl('previous_weapon',false)
		toggleControl('aim_weapon',false)
	end
end)


addEventHandler("onClientRender", getRootElement(),
	function ()
		local currentTick = getTickCount()

		for k, v in pairs(tazerShootEffect) do
			if isElement(v.tazedBy) and isElement(k) then
				local officerPosX, officerPosY, officerPosZ = getPedBonePosition(v.tazedBy, 26)
				local targetPosX, targetPosY, targetPosZ = getPedBonePosition(k, 3)

				local elapsedTime = currentTick - v.startTick
				local progress = elapsedTime / 750

				local linePosX, linePosY, linePosZ = interpolateBetween(
					officerPosX, officerPosY, officerPosZ,
					targetPosX, targetPosY, targetPosZ,
					progress, "Linear"
				)

				dxDrawLine3D(officerPosX, officerPosY, officerPosZ, linePosX, linePosY, linePosZ, tocolor(100, 100, 100, 100), 0.5, false)
				dxDrawLine3D(officerPosX, officerPosY + 0.02, officerPosZ, linePosX, linePosY + 0.02, linePosZ, tocolor(100, 100, 100, 100), 0.5, false)

				if elapsedTime >= 300 and isElement(v.effectElement) then
					destroyElement(v.effectElement)
				end

				if elapsedTime >= 2390 then
					tazerShootEffect[k] = nil
				end
			else
				tazerShootEffect[k] = nil
			end
		end
	end
)
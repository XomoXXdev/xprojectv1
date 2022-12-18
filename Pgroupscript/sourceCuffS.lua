local checkForWarpTimer = {}

function endGrab()
	if checkForWarpTimer[source] then
		if isTimer(checkForWarpTimer[source]) then
			killTimer(checkForWarpTimer[source])
		end

		checkForWarpTimer[source] = nil
	end

	local theGrabber = getElementData(source, "player:grabbed")

	if isElement(theGrabber) then
		setElementData(theGrabber, "player:grabbing", false)
		setElementData(source, "player:cuffanim", false)
	end

	local grabbingPlayer = getElementData(source, "player:grabbing")

	if isElement(grabbingPlayer) then
		setElementData(grabbingPlayer, "player:grabbed", false)

		if getElementData(grabbingPlayer, "player:cuffed") then
			setElementData(grabbingPlayer, "player:cuffanim", 3)
		else
			setElementData(grabbingPlayer, "player:cuffanim", false)
		end
	end
end
addEventHandler("onPlayerQuit", getRootElement(), endGrab)
addEventHandler("onPlayerWasted", getRootElement(), endGrab)

func.grabFunction = function(playerSource, commandName, targetPlayer)
	if not targetPlayer then
		outputChatBox("[xProject] #ffffff/" .. commandName .. " [ID/Név]", playerSource,129, 99, 191, true)
	else
		targetPlayer, targetName = exports.Pcore:findPlayerByPartialNick(playerSource, targetPlayer)

		if targetPlayer then
			if not getElementData(playerSource, "player:cuffed") then
				grabPlayer(playerSource, targetPlayer)
			else
				outputChatBox("[xProject]#ffffff Megbilincselve nehéz lesz.", playerSource,129, 99, 191, true)
			end

		end
		
	end
end
addCommandHandler("visz", func.grabFunction)

function warpPlayerToGrabber(player, grabber)
	if isElement(player) and isElement(grabber) then
		local playerInterior = getElementInterior(player)
		local grabberInterior = getElementInterior(grabber)

		local playerDimension = getElementDimension(player)
		local grabberDimension = getElementDimension(grabber)

		local playerPosX, playerPosY, playerPosZ = getElementPosition(player)
		local grabberPosX, grabberPosY, grabberPosZ = getElementPosition(grabber)

		local _, _, playerRotZ = getElementRotation(player)
		local _, _, grabberRotZ = getElementRotation(grabber)

		local deltaX = grabberPosX - playerPosX
		local deltaY = grabberPosY - playerPosY

		local dist = deltaX * deltaX + deltaY * deltaY

		if playerInterior ~= grabberInterior or playerDimension ~= grabberDimension or dist > 10 then

			local angle = math.rad(grabberRotZ + 180 - playerRotZ)

			setElementPosition(player, grabberPosX + math.cos(angle) / 2, grabberPosY + math.sin(angle) / 2, grabberPosZ)
			setElementInterior(player, grabberInterior)
			setElementDimension(player, grabberDimension)
		end
	elseif isTimer(checkForWarpTimer[player]) then
		killTimer(checkForWarpTimer[player])
		checkForWarpTimer[player] = nil
	end
end

function grabPlayer(playerSource,targetPlayer)
	if isElement(playerSource) then
		if isElement(targetPlayer) then
			local playerPosX, playerPosY, playerPosZ = getElementPosition(playerSource)
			local targetPosX, targetPosY, targetPosZ = getElementPosition(targetPlayer)

			local sourceInterior = getElementInterior(playerSource)
			local targetInterior = getElementInterior(targetPlayer)

			local sourceDimension = getElementDimension(playerSource)
			local targetDimension = getElementDimension(targetPlayer)

			local distance = getDistanceBetweenPoints3D(playerPosX, playerPosY, playerPosZ, targetPosX, targetPosY, targetPosZ)

			if distance <= 5 then
				if sourceInterior == targetInterior and sourceDimension == targetDimension then
					if getElementData(targetPlayer, "player:cuffed") then
						if not getElementData(targetPlayer, "player:grabbed") then
							local grabbingPlayer = getElementData(playerSource, "player:grabbing")

							if not isElement(grabbingPlayer) then
								local playerVehicle = getPedOccupiedVehicle(targetPlayer);
								if playerVehicle and isElement(playerVehicle) then
									removePedFromVehicle(targetPlayer)
								end

								setElementData(playerSource, "player:grabbing", targetPlayer)
								setElementData(targetPlayer, "player:grabbed", playerSource)
								setElementData(targetPlayer, "player:cuffanim", 1)
								exports.Pchat:takeMessage(playerSource,"me","megfogta ".. string.gsub(getElementData(targetPlayer,"player:charname"), "_", " ") .. " -t és elkezdi vinni magával a vezetőszár segítségével.")

								if isTimer(checkForWarpTimer[targetPlayer]) then
									killTimer(checkForWarpTimer[targetPlayer])
								end

								checkForWarpTimer[targetPlayer] = setTimer(warpPlayerToGrabber, 1000, 0, targetPlayer, playerSource)
							else
								outputChatBox("[xProject]#ffffff Egyszerre csak egy embert tudsz vezetni.", playerSource,129, 99, 191, true)
							end
						else
							if getElementData(playerSource, "player:grabbing") and isElement(getElementData(playerSource, "player:grabbing")) and getElementData(playerSource, "player:grabbing") == targetPlayer then
								setElementData(playerSource, "player:grabbing", false)
								setElementData(targetPlayer, "player:grabbed", false)
								if getElementData(targetPlayer, "player:cuffed") then
									setElementData(targetPlayer, "player:cuffanim", 3)
								else
									setElementData(targetPlayer, "player:cuffanim", false)
								end

								exports.Pchat:takeMessage(playerSource,"me","leveszi ".. string.gsub(getElementData(targetPlayer,"player:charname"), "_", " ") .. " -ról/ről a vezetőszárat.")
	
								if isTimer(checkForWarpTimer[targetPlayer]) then
									killTimer(checkForWarpTimer[targetPlayer])
								end
								checkForWarpTimer[targetPlayer] = nil
							else
								outputChatBox("[xProject]#ffffff Csak az tudja levenni aki rárakta a vezetőszárat.", playerSource,129, 99, 191, true)
							end
						end
					else
						outputChatBox("[xProject]#ffffff A kiválasztott játékos nincs megbilincselve.", playerSource,129, 99, 191, true)
					end
				end
			else
				outputChatBox("[xProject]#ffffff A kiválasztott játékos túl messze van tőled.", playerSource,129, 99, 191, true)
			end
		end
	end
end

func.cuffCommand = function(playerSource, commandName, targetPlayer)
	if not targetPlayer then
		outputChatBox("[xProject]#ffffff /" .. commandName .. " [ID/Név]", playerSource,129, 99, 191, true)
	else
		targetPlayer, targetName = exports.Pcore:findPlayerByPartialNick(playerSource, targetPlayer)

		if targetPlayer then
			if not getElementData(playerSource, "player:cuffed") then
				cuffPlayer(playerSource, targetPlayer)
			else
				outputChatBox("[xProject]#ffffff Megbilincselve nehéz lesz.", playerSource,129, 99, 191, true)
			end
		end
	end
end
addCommandHandler("cuff", func.cuffCommand)

function cuffPlayer(playerSource,targetPlayer)
	if isElement(playerSource) then
		if isElement(targetPlayer) then
			if getElementData(targetPlayer,"player:loggedIn") then
				if playerSource ~= targetPlayer then
					local playerPosX, playerPosY, playerPosZ = getElementPosition(playerSource)
					local targetPosX, targetPosY, targetPosZ = getElementPosition(targetPlayer)

					local sourceInterior = getElementInterior(playerSource)
					local targetInterior = getElementInterior(targetPlayer)

					local sourceDimension = getElementDimension(playerSource)
					local targetDimension = getElementDimension(targetPlayer)

					local distance = getDistanceBetweenPoints3D(playerPosX, playerPosY, playerPosZ, targetPosX, targetPosY, targetPosZ)

					if distance < 2.5 then
						if sourceInterior == targetInterior and sourceDimension == targetDimension then
							if not getElementData(targetPlayer, "player:cuffed") then
								if exports.inventory:hasItem(playerSource, 122) then
									exports.inventory:takeItem(playerSource,122)
									exports.inventory:giveItem(playerSource,123,1,1,0)
									setElementData(targetPlayer,"player:cuffed",true)
									exports.Pchat:takeMessage(playerSource,"me","megbilincseli "..getElementData(targetPlayer,"player:charname"):gsub("_", " ").." -t.")
									outputChatBox("[xProject]#ffffff Sikeresen megbilincselt téged: #8163bf"..getElementData(playerSource,"player:charname"):gsub("_", " ").."#ffffff.",targetPlayer,129, 99, 191,true)
									outputChatBox("[xProject]#ffffff Megbilincselted #8163bf"..getElementData(targetPlayer,"player:charname"):gsub("_", " ").."#ffffff -t.",playerSource,129, 99, 191,true)
								else
									outputChatBox("[xProject]#ffffff Nincs nálad bilincs.",playerSource,129, 99, 191,true)
								end
							else
								if exports.inventory:hasItem(playerSource, 123) then
									if getElementData(targetPlayer, "player:grabbed") and isElement(getElementData(targetPlayer, "player:grabbed")) then
										outputChatBox("[xProject]#ffffff Elöbb le kell venni róla a vezetőszárat.",playerSource,129, 99, 191,true)
									else
										exports.inventory:takeItem(playerSource,123)
										exports.inventory:giveItem(playerSource,122,1,1,0)
										setElementData(targetPlayer,"player:cuffed",false)
										toggleControl(targetPlayer,"forwards", true)
										toggleControl(targetPlayer,"backwards", true)
										toggleControl(targetPlayer,"left", true)
										toggleControl(targetPlayer,"right", true)
										toggleControl(targetPlayer,"fire", true)
										toggleControl(targetPlayer,"sprint", true)
										toggleControl(targetPlayer,"crouch", true)
										toggleControl(targetPlayer,"jump", true)
										toggleControl(targetPlayer,'next_weapon',true)
										toggleControl(targetPlayer,'previous_weapon',true)
										toggleControl(targetPlayer,'aim_weapon',true)
										exports.Pchat:takeMessage(playerSource,"me","leveszi a bilincset "..getElementData(targetPlayer,"player:charname"):gsub("_", " ").." -ról/ről.")
										outputChatBox("[xProject]#ffffff Sikeresen levette rólad #8163bf"..getElementData(playerSource,"player:charname"):gsub("_", " ").."#ffffff a bilincset.",targetPlayer,129, 99, 191,true)
										outputChatBox("[xProject]#ffffff Levetted #8163bf"..getElementData(targetPlayer,"player:charname"):gsub("_", " ").."#ffffff -ról/ről a bilincset.",playerSource,129, 99, 191,true)
									end
								else
									outputChatBox("[xProject]#ffffff Nincs nálad bilincskulcs.",playerSource,129, 99, 191,true)
								end
							end
						end
					else
						outputChatBox("[xProject]#ffffff A kiválasztott játékos nincs a közeledben.", playerSource,129, 99, 191, true)
					end
				else
					outputChatBox("[xProject]#ffffff Magadat nem bilincselheted meg.", playerSource,129, 99, 191, true)
				end
			else
				outputChatBox("[xProject]#ffffff A kiválasztott játékos nincs bejelentkezve.", playerSource,129, 99, 191, true)
			end
		end
	end
end

function takePlayerCuff(playerSource)
	setElementData(playerSource,"player:cuffed",false)
	toggleControl(playerSource,"forwards", true)
	toggleControl(playerSource,"backwards", true)
	toggleControl(playerSource,"left", true)
	toggleControl(playerSource,"right", true)
	toggleControl(playerSource,"fire", true)
	toggleControl(playerSource,"sprint", true)
	toggleControl(playerSource,"crouch", true)
	toggleControl(playerSource,"jump", true)
	toggleControl(playerSource,'next_weapon',true)
	toggleControl(playerSource,'previous_weapon',true)
	toggleControl(playerSource,'aim_weapon',true)
end

func.vehicleStartEnter = function(playerSource)
	if not (isVehicleLocked(source)) then
		if getElementData(playerSource,"player:grabbing") and isElement(getElementData(playerSource,"player:grabbing")) then
			local targetPlayer = getElementData(playerSource,"player:grabbing");
			if getElementData(targetPlayer, "player:grabbed") then

				if not getVehicleOccupant ( source, 1 ) then
					warpPedIntoVehicle ( targetPlayer, source, 1)
				elseif not getVehicleOccupant ( source, 2 ) then
					warpPedIntoVehicle ( targetPlayer, source, 2)
				elseif not getVehicleOccupant ( source, 3 ) then
					warpPedIntoVehicle ( targetPlayer, source, 3)
				end

				setElementData(targetPlayer, "player:grabbed", false)
				setElementData(targetPlayer, "player:cuffanim", false)
				if isTimer(checkForWarpTimer[targetPlayer]) then
					killTimer(checkForWarpTimer[targetPlayer])
				end

				checkForWarpTimer[targetPlayer] = nil

				setElementData(playerSource, "player:grabbing", false)
			end
		end
	end
end
addEventHandler("onVehicleStartEnter", getRootElement(), func.vehicleStartEnter)
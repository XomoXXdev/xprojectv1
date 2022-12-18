local vissz = {}
local viszben = {}

function followPlayer(playerSource,target)
	if (vissz[playerSource]) then
		offVisz(playerSource)
	else
		if getElementData(target, "player:cuffed") then
			if not (vissz[playerSource]) and not (viszben[playerSource]) then
				if not (vissz[target]) and not (viszben[target]) then
					local x,y,z = getElementPosition(playerSource)
					viszben[target] = playerSource
					vissz[playerSource] = target
					local dim = getElementDimension(playerSource)
					local int = getElementInterior(playerSource)
					local rot = getPedRotation(playerSource)
					exports.Pchat:takeMessage(playerSource,"me","megfogta ".. string.gsub(getElementData(target,"player:charname"), "_", " ") .. " -t és elkezdi vinni magával.")
					setElementPosition(target, x, y, z)
					setElementDimension(target, dim)
					setElementInterior(target, int)
					setPedRotation(target, tonumber(rot))
					setElementFrozen(target, true)
					triggerClientEvent(playerSource, "togVisz", playerSource, target)
				end
			end
		else
			outputChatBox("[xProject]#ffffff A játékos nincs megbilincselve.", thePlayer,129, 99, 191, true)
		end
	end
end
addEvent("followPlayerServer",true)
addEventHandler("followPlayerServer",getRootElement(),followPlayer)

function toggleFollow(playerSource)
	if (vissz[playerSource]) then
		offVisz(playerSource)
	end
end

function visz(thePlayer, commandName, target)
	if (vissz[thePlayer]) then
		offVisz(thePlayer)
	else
		if not (target) then
			outputChatBox("[xProject]#ffffff /" .. commandName .. " [ID]", thePlayer,129, 99, 191, true)
		else
			local targetPlayer, targetPlayerName = exports.Pcore:findPlayerByPartialNick(thePlayer, target)
			if (targetPlayer) then
				local restrainedObj = getElementData(targetPlayer, "player:cuffed");
				local x, y, z = getElementPosition(thePlayer)
				local tx, ty, tz = getElementPosition(targetPlayer)
				local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
				if (distance<=2) then
					if restrainedObj then
						if not (vissz[thePlayer]) and not (viszben[thePlayer]) then
							if not (vissz[targetPlayer]) and not (viszben[targetPlayer]) then
								viszben[targetPlayer] = thePlayer
								vissz[thePlayer] = targetPlayer
								local dim = getElementDimension(thePlayer)
								local int = getElementInterior(thePlayer)
								local rot = getPedRotation(thePlayer)
								exports.Pchat:takeMessage(thePlayer,"me", "megfogta ".. string.gsub(getElementData(targetPlayer,"player:charname"), "_", " ") .. " -t és elkezdi vinni magával.")
								setElementPosition(targetPlayer, x, y, z)
								setElementDimension(targetPlayer, dim)
								setElementInterior(targetPlayer, int)
								setPedRotation(targetPlayer, tonumber(rot))
								setElementFrozen(targetPlayer, true)
								triggerClientEvent(thePlayer, "togVisz", thePlayer, targetPlayer)
							end
						end
					else
						outputChatBox("[xProject]#ffffff A játékos nincs megbilincselve.", thePlayer,129, 99, 191, true)
					end
				else
					outputChatBox("[xProject]#ffffff A kiválasztott játékos túl messze van tőled.", thePlayer,129, 99, 191, true)
				end
			end
		end
	end
end
addCommandHandler("visz", visz, false, false)

function beKocsiba(player)
	if (vissz[player]) then
		if not (isVehicleLocked(source)) then
			local delikvens = vissz[player]
			offVisz(player)
			setElementFrozen(delikvens, false)
			if not getVehicleOccupant ( source, 1 ) then
				warpPedIntoVehicle ( delikvens, source, 1)
			elseif not getVehicleOccupant ( source, 2 ) then
				warpPedIntoVehicle ( delikvens, source, 2)
			elseif not getVehicleOccupant ( source, 3 ) then
				warpPedIntoVehicle ( delikvens, source, 3)
			end
		end
	end
end
addEventHandler("onVehicleStartEnter", getRootElement(), beKocsiba)

function viszTP(thePlayer, targetPlayer)
	local x, y, z = getElementPosition(thePlayer)
	local dim = getElementDimension(thePlayer)
	local int = getElementInterior(thePlayer)
	local rot = getPedRotation(thePlayer)
	setElementPosition(targetPlayer, x, y, z)
	setElementDimension(targetPlayer, dim)
	setElementInterior(targetPlayer, int)
	setPedRotation(targetPlayer, tonumber(rot))
end
addEvent("viszTP", true)
addEventHandler("viszTP", getRootElement(), viszTP)

function offVisz(player)
	if (vissz[player]) then
		triggerClientEvent(player, "viszOff", player)
		local nev = getElementData(vissz[player],"player:charname"):gsub("_", " ")
		exports.Pchat:takeMessage(player,"me", "elengedte ".. nev .. " -t.")
		setElementFrozen(vissz[player], false)
		setPedAnimation(vissz[player], false)
		viszben[vissz[player]] = nil
		vissz[player] = nil
	elseif (viszben[player]) then
		triggerClientEvent(viszben[player], "viszOff", viszben[player])
		setElementFrozen(player, false)
		vissz[viszben[player]] = nil
		viszben[player] = nil
	end
end
addEvent("offVisz", true)
addEventHandler("offVisz", getRootElement(), offVisz)

function kilepFixVisz(quitType)
	if (vissz[source]) or (viszben[source]) then
		offVisz(viszben[source])
	end
end
addEventHandler("onPlayerQuit", getRootElement(), kilepFixVisz)
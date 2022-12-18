function jailPlayer(thePlayer, commandName, who, minutes, ...)
	if getElementData(thePlayer,"player:admin") >= 1 then
		local minutes = tonumber(minutes)
		if not (who) or not (minutes) or not (...) or (minutes<1) then
			outputChatBox("#8163bf[xProject] #FFFFFF/" .. commandName .. " [ID/Név] [Perc(>=1) 999=Végtelen] [Indok]", thePlayer, 255, 194, 14, true)
		else
			local targetPlayer, targetPlayerName = exports.Pcore:findPlayerByPartialNick(thePlayer, who)
			local reason = table.concat({...}, " ")

			if (targetPlayer) then
				local playerName = getPlayerName(thePlayer)
				local jailTimer = getElementData(targetPlayer, "jailtimer")
				local accountID = getElementData(targetPlayer, "player:dbid")

				if isTimer(jailTimer) then
					killTimer(jailTimer)
				end

				if (isPedInVehicle(targetPlayer)) then
					setElementData(targetPlayer, "realinvehicle", 0, false)
					removePedFromVehicle(targetPlayer)
				end

				if (minutes>=999) then
					dbPoll ( dbQuery( connection, "UPDATE accounts SET adminjail='1', adminjail_time='?', adminjail_permanent='1', adminjail_by=?, adminjail_reason=? WHERE id='?'", minutes, playerName, reason, accountID), -1 )
					minutes = "Végtelen"
					setElementData(targetPlayer, "jailtimer", true, false)
				else
					dbPoll ( dbQuery( connection, "UPDATE accounts SET adminjail='1', adminjail_time='?', adminjail_permanent='0', adminjail_by=?, adminjail_reason=? WHERE id='?'", minutes, playerName, reason, accountID), -1 )
					local theTimer = setTimer(timerUnjailPlayer, 60000, minutes, targetPlayer)
					setElementData(targetPlayer, "jailserved", 0, false)
					setElementData(targetPlayer, "jailtimer", theTimer, false)
				end
				setElementData(targetPlayer, "adminjailed", true)
				setElementData(targetPlayer, "jailreason", reason, false)
				setElementData(targetPlayer, "jailtime", minutes, false)
				setElementData(targetPlayer, "jailadmin", getPlayerName(thePlayer), false)

				outputChatBox("#8163bf[xProject] #FFFFFFBebörtönözted #8163bf" .. targetPlayerName .. "#ffffff-t #8163bf" .. minutes .. "#ffffff percre.", thePlayer, 255, 0, 0, true)

				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
				dbPoll ( dbQuery( connection, "INSERT INTO adminhistory (user_char, user, admin_char, admin, hiddenadmin, action, duration, reason) VALUES (?, ?, ?, ?, ?, 0, ?, ?)", getPlayerName(targetPlayer), tostring(getElementData(targetPlayer, "gameaccountid") or 0), getPlayerName(thePlayer), tostring(getElementData(thePlayer, "gameaccountid") or 0), hiddenAdmin, ( minutes == 999 and 0 or minutes ), reason), -1 )

				if (not hiddenAdmin) then
					outputChatBox("#d75959[AdminJail]: " .. playerName .. " bebörtönözte " .. targetPlayerName .. "-t " .. minutes .. " percre.", getRootElement(), 255, 0, 0, true)
					outputChatBox("#d75959[AdminJail]: Indok: " .. reason, getRootElement(), 255, 0, 0, true)
				else
					outputChatBox("#d75959[AdminJail]: Rejtett Admin bebörtönözte " .. targetPlayerName .. "-t " .. minutes .. " percre.", getRootElement(), 255, 0, 0, true)
					outputChatBox("#d75959[AdminJail]: Indok: " .. reason, getRootElement(), 255, 0, 0, true)
				end
				setElementDimension(targetPlayer, 65400+getElementData(targetPlayer, "playerid"))
				setElementInterior(targetPlayer, 6)
				setCameraInterior(targetPlayer, 6)
				setElementPosition(targetPlayer, 263.821807, 77.848365, 1001.0390625)
				setPedRotation(targetPlayer, 267.438446)

				toggleControl(targetPlayer,'next_weapon',false)
				toggleControl(targetPlayer,'previous_weapon',false)
				toggleControl(targetPlayer,'fire',false)
				toggleControl(targetPlayer,'aim_weapon',false)
				setPedWeaponSlot(targetPlayer,0)
			end
		end
	end
end
addCommandHandler("jail", jailPlayer, false, false)
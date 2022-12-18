function onspawn(theKey, oldValue, newValue)
	if theKey == "player:loggedIn" then 
	local time = getElementData(source,"jailtime")
	local theTimer = setTimer(timerUnjailPlayer, 60000, time, source)
	end
end
addEventHandler("onElementDataChange",root,onspawn)

fileDelete ("sourceArrestC.lua")
local func = {};
local cache = {
    cells = {
        {
            x = 262.4;
            y = 75.85;
            z = 1000.05;
            fW = 5;
            fD = 3.45;
            fH = 2.5;
            dimension = 4;
            interior = 6;
            group = 1;
        };
        {
            x = 262.4;
            y = 80.35;
            z = 1000.05;
            fW = 5;
            fD = 3.45;
            fH = 2.5;
            dimension = 57;
            interior = 6;
            group = 2;
        };
        {
            x = 262.4;
            y = 84.85;
            z = 1000.05;
            fW = 5;
            fD = 3.45;
            fH = 2.5;
            dimension = 57;
            interior = 6;
            group = 3;
        };
    };
};
local cellElements = {};

func.start = function()
    removeWorldModel(14843,6.1740093231201,266.3515625, 81.1953125, 1001.28125)

    for k,v in ipairs(cache.cells) do
     col = createColCuboid(v.x,v.y,v.z,v.fW+3,v.fD,v.fH);
        cellElements[k] = col;
        setElementData(col,"cell:group",v.group)
        setElementDimension(col,v.dimension);
        setElementInterior(col,v.interior);
        setElementData(col,"cellcol",true)
    end
end
addEventHandler("onResourceStart",resourceRoot,func.start)


function jailPlayer(thePlayer, commandName, who, minutes, ...)
    local dbid = getElementData(thePlayer,"player:dbid")
	if not isElementWithinColShape(thePlayer,col) then return end
   if exports.pdash:isPlayerInGroup(1,dbid) or exports.pdash:isPlayerInGroup(2,dbid) then
		local minutes = tonumber(minutes)
		if not (who) or not (minutes) or not (...) or (minutes<1) then
			outputChatBox("#8163bf[xProject] #FFFFFF/" .. commandName .. " [ID/Név] [Perc(>=1) [Indok]", thePlayer, 255, 194, 14, true)
		else
			local targetPlayer, targetPlayerName = exports.Pcore:findPlayerByPartialNick(thePlayer, who)
			local reason = table.concat({...}, " ")
            local jails = getElementData(thePlayer,"admin:jails")
			if (targetPlayer) then
				local playerName = getPlayerName(thePlayer)
				local jailTimer = getElementData(targetPlayer, "jailtimer")
				local accountID = getElementData(targetPlayer, "player:dbid")
                if tonumber(minutes) > 300 then 
                    outputChatBox("#8163bf[xProject] #FFFFFFMaximum 300 perc!", thePlayer, 255, 194, 14, true)
                    return end

				if isTimer(jailTimer) then
					killTimer(jailTimer)
				end

				if (isPedInVehicle(targetPlayer)) then
					setElementData(targetPlayer, "realinvehicle", 0, false)
					removePedFromVehicle(targetPlayer)
				end

				if (minutes>=999) then
					dbPoll ( dbQuery( connection, "UPDATE users SET adminjail='1', adminjail_time='?', adminjail_permanent='1', adminjail_by=?, adminjail_reason=? WHERE id='?'", minutes, playerName, reason, accountID), -1 )
					minutes = "Végtelen"
					setElementData(targetPlayer, "jailtimer", true)
				else
					dbPoll ( dbQuery( connection, "UPDATE users SET adminjail='1', adminjail_time='?', adminjail_permanent='0', adminjail_by=?, adminjail_reason=? WHERE id='?'", minutes, playerName, reason, accountID), -1 )
					local theTimer = setTimer(timerUnjailPlayer, 60000, minutes, targetPlayer)
					setElementData(targetPlayer, "jailserved", 0)
					setElementData(targetPlayer, "jailtimer", theTimer)
				end
				setElementData(targetPlayer, "adminjailed", true)
				setElementData(targetPlayer, "jailreason", reason)
				setElementData(targetPlayer, "jailtime", minutes)
				setElementData(targetPlayer, "jailadmin", getPlayerName(thePlayer))

				outputChatBox("#8163bf[xProject] #FFFFFFBebörtönözted #8163bf" .. getElementData(targetPlayer,"player:charname") .. "#ffffff-t #8163bf" .. minutes .. "#ffffff percre.", thePlayer, 255, 0, 0, true)

				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
			--	dbPoll ( dbQuery( connection, "INSERT INTO adminhistory (user_char, user, admin_char, admin, hiddenadmin, action, duration, reason) VALUES (?, ?, ?, ?, ?, 0, ?, ?)", getPlayerName(targetPlayer), tostring(getElementData(targetPlayer, "gameaccountid") or 0), getPlayerName(thePlayer), tostring(getElementData(thePlayer, "gameaccountid") or 0), hiddenAdmin, ( minutes == 999 and 0 or minutes ), reason), -1 )

				if (not hiddenAdmin) then
		--			outputChatBox("#d75959[AdminJail] #8163bf" .. func.getName(thePlayer) .. "#ffffff bebörtönözte #8163bf" .. func.getName(targetPlayer) .. "#ffffff-t #8163bf" .. minutes .. "#ffffff percre.", getRootElement(), 255, 0, 0, true)
		--			outputChatBox("#d75959[AdminJail] #8163bfIndok: #ffffff" .. reason, getRootElement(), 255, 0, 0, true)
				else
		--			outputChatBox("#d75959[AdminJail] Rejtett Admin bebörtönözte " .. targetPlayerName .. "-t " .. minutes .. " percre.", getRootElement(), 255, 0, 0, true)
		--			outputChatBox("#d75959[AdminJail] Indok: " .. reason, getRootElement(), 255, 0, 0, true)
				end
				setElementDimension(targetPlayer,getElementData(targetPlayer, "player:dbid")+1423)
				setElementInterior(targetPlayer, 0)
				setCameraInterior(targetPlayer, 0)
				setElementPosition(targetPlayer, -18.5732421875, 2322.1162109375, 24.303373336792)
				setPedRotation(targetPlayer, 267.438446)
                setElementData(thePlayer,"admin:jails",jails+1)

				setPedWeaponSlot(targetPlayer,0)
			end
		end
	end
end
addCommandHandler("ijail", jailPlayer, false, false)

function timerUnjailPlayer(jailedPlayer)
	if(isElement(jailedPlayer)) then
		local timeLeft = getElementData(jailedPlayer, "jailtime")
		local accountID = getElementData(jailedPlayer, "player:dbid")
		if (timeLeft) > 0 then
			local timeLeft = timeLeft - 1
			setElementData(jailedPlayer, "jailtime", timeLeft)
			if (timeLeft<=0) then
				dbPoll ( dbQuery( connection, "UPDATE users SET adminjail_time='0', adminjail='0' WHERE id='?'", accountID), -1 )
				setElementData(jailedPlayer, "jailtimer",false)
				setElementData(jailedPlayer, "adminjailed",false)
				setElementData(jailedPlayer, "jailreason",false)
				setElementData(jailedPlayer, "jailtime",false)
				setElementData(jailedPlayer, "jailadmin",false)
				setElementPosition(jailedPlayer, 2291.01953125, 2428.330078125, 10.8203125)
				setPedRotation(jailedPlayer, 272.18768310547)
				setElementDimension(jailedPlayer, 0)
				setElementInterior(jailedPlayer, 0)
				setCameraInterior(jailedPlayer, 0)
				outputChatBox("#8163bf[xProject] #FFFFFFLejárt az adminjailed!", jailedPlayer, 0, 255, 0, true)


				--exports.sas_global:sendMessageToAdmins("AdmJail: " .. getPlayerName(jailedPlayer) .. " Admin börtön ideje lenullázva.")
		--		outputAdminMessage("#d75959AdminJail: " .. func.getName(targetPlayer) .. "#ffffff Admin börtön ideje lenullázva." )
			else
				dbPoll ( dbQuery( connection, "UPDATE users SET adminjail_time='?' WHERE id='?'", timeLeft, accountID), -1 )
			end
		end
	end
end
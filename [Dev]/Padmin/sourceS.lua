local func = {};
func.dbConnect = exports["Pcore"];
local connection = exports.pcore:getConnection()
local cache = {};
cache.players = {};
cache.serials = {}; 
local vehtable = {
    {"vehicle_left"},
    {"vehicle_right"},
    {"steer_forward"},
    {"steer_back"},
    {"accelerate"},
    {"horn"},
    {"enter_exit"},
    {"brake_reverse"},
  }

local parancsok = {
    ["shutdown"]=true,
    ["register"]=true,
    ["msg"]=true,
    ["login"]=true,
    ["restart"]=true,
    ["start"]=true,
    ["stop"]=true,
    ["refresh"]=true,
    ["aexec"]=true,
    ["refreshall"]=true,
    ["debugscript"]=true,
}
local devSerials = {};
devSerials["7B6A1D6A9803DFA75530E7520C712E71"] = true



local devCommands = {
	["restart"] = true,
	["start"] = true,
	["refresh"] = true,
	["debugscript"] = true,
	["stop"] = true,
	["crun"] = true,
	["srun"] = true,
};
addEventHandler ("onPlayerCommand", getRootElement(), function (cmd )
	local serial = getPlayerSerial ( source )
	if not (devSerials[serial] ) then
		if (devCommands[cmd]) then
			cancelEvent();
		end
	end
end)


func.start = function()
	dbQuery(function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			local count = 0;
			for k, row in pairs(res) do
				cache.serials[row.serial] = true;
				count = count+1;
			end
			outputDebugString("Loaded "..count.." developer member serial.")
		end
	end,func.dbConnect:getConnection(), "SELECT * FROM `serials`");

	for k,v in ipairs(getElementsByType("player")) do
		cache.players[v] = true;
	end
end
addEventHandler("onResourceStart", resourceRoot,func.start)

func.dataChange = function(dataName)
    if getElementType(source) == "player" then
        if dataName == "player:admin" then
			local value = getElementData(source, dataName)
			if not cache.serials[getPlayerSerial(source)] and value > 7 then
				outputChatBox("#8163bf[xProject]#ffffff Serial hiba, adminszinisztrátori szinted nullázva.",source,220,20,60,true)
				setElementData(source,"player:admin",0);
			end
		end

		if dataName == "player:loggedIn" then
			local value = getElementData(source, dataName)
			if value then
				if not cache.players[source] then
					cache.players[source] = true;
				end
			end
		end
	end
end
addEventHandler("onElementDataChange",root,func.dataChange)

func.quit = function()
	if cache.players[source] then
		cache.players[source] = nil
	end
end
addEventHandler("onPlayerQuit",getRootElement(),func.quit)

func.getName = function(playerSource)
	local name = getElementData(playerSource,"player:charname"):gsub("_", " ");
	local adminName = getElementData(playerSource,"player:adminname");
	if adminName ~= "Admin" then
		name = adminName;
	end
	return name;
end

func.formatMoney = function(amount)
    local formatted = amount
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')
        if (k==0) then
            break
        end
    end
    return formatted
end

--PM INNEN

function togPm(playerSource)
	if getElementData(playerSource, "player:admin") >= 7 then
		local valtozo = getElementData(playerSource, "pmBlocked")
		setElementData(playerSource, "pmBlocked", valtozo == 0 and 1 or 0)
		outputChatBox("#8163bf[xProject]:#FFFFFF A PMek " .. (valtozo == 0 and "levannak tiltva" or "engedélyezve vannak") .. ".", playerSource, 255, 255, 255, true)
	end
end
addCommandHandler("togpm", togPm)

function pmTo(thePlayer, commandName, targetPlayer, ...)
  if getElementData(thePlayer,"player:loggedIn" ) then	
	if not (targetPlayer) or not (...) then
		outputChatBox("#8163bf[xProject]: #FFFFFF/" .. commandName .. " [Névrészlet] [szöveg]", thePlayer,255,255,255,true)
	else
		local targetPlayer, targetPlayerName = exports.Pcore:findPlayerByPartialNick(thePlayer, targetPlayer)
		
		if targetPlayer then
			local blokkolva = getElementData(targetPlayer, "pmBlocked")
			local recived = getElementData(targetPlayer,"admin:recived")
			if blokkolva ~= 1 then
				szoveg = table.concat({...}, " ")
				if getElementData(targetPlayer, "player:admin") >= 1 and getElementData(targetPlayer, "player:adminduty") or getElementData(targetPlayer,"player:helper") >= 1 then
					local playerName = getElementData(thePlayer,"player:charname");
					local targetName = getElementData(targetPlayer,"player:adminname");
					local idje = tonumber(getElementData(thePlayer, "player:id"))
					local idje2 = tonumber(getElementData(targetPlayer, "player:id"))
						
					outputChatBox("#8163bf[Fogadott PM | ID: "..idje.."]: #ffffff" .. playerName .. ": " .. szoveg, targetPlayer, 255, 255, 255,true)
					setElementData(targetPlayer,"admin:recived",recived+1)
					if getElementData(targetPlayer, "player:helper") >= 1 then
					    outputChatBox("#8163bf[Segítség | ID: "..idje2.."]:#ffffff " .. getElementData(targetPlayer,"player:charname"):gsub("_", " ") .. ": " .. szoveg, thePlayer, 255, 255, 255,true)
					else
					    outputChatBox("#8163bf[Segítség | ID: "..idje2.."]:#ffffff " .. targetName .. ": " .. szoveg, thePlayer, 255, 255, 255,true)					
					end
				else
					outputChatBox("#8163bf[xProject]:#ffffff A kiválasztott játékosnak nem írhatsz PM-et.", thePlayer,255,255,255,true)     
				end
			else
				outputChatBox("#8163bf[xProject]: #FFFFFFA kiválasztott adminisztrátor letiltotta a PM-eket.", thePlayer, 255,255,255,true)
			end
		end
	end
  end		
end
addCommandHandler("pm", pmTo, false, false)

function replyPM(playerSource, commandName, targetPlayer, ...)
	if getElementData(playerSource,"player:admin") >= 1 or getElementData(playerSource,"player:helper") >= 1 then
		if not (targetPlayer) or not (...) then
			outputChatBox("#8163bf[xProject]:#ffffff /" .. commandName .. " [Névrészlet] [szöveg]", playerSource,255,255,255,true)
		else
			local targetPlayer, targetPlayerName = exports.Pcore:findPlayerByPartialNick(playerSource, targetPlayer)
			
			if targetPlayer then
				text = table.concat({...}, " ")
				local replyed = getElementData(playerSource,"admin:replyed")
				local anick = getElementData(playerSource,"player:adminname");
				if getElementData(playerSource,"player:helper") >= 1 then
					anick = getElementData(playerSource,"player:charname"):gsub("_", " ");
				else
					anick = getElementData(playerSource,"player:adminname");
				end
                setElementData(playerSource,"admin:replyed",replyed+1)
				outputChatBox("#8163bf[Segítség]:#FFFFFF " .. anick .. ": " .. text, targetPlayer, 255, 255, 255, true)
				outputChatBox("#8163bf[PM Tőled]:#FFFFFF " .. getElementData(targetPlayer,"player:charname"):gsub("_", " ") .. ": " .. text, playerSource, 255, 255, 255, true)
			end
		end
	end
end
addCommandHandler("vá", replyPM, false, false)
addCommandHandler("va", replyPM, false, false)
addCommandHandler("replypm", replyPM, false, false)
addCommandHandler("reply", replyPM, false, false)


-- PM EDDIG

func.adminDuty = function(playerSource,cmd,target)
 if not target then 
	if getElementData(playerSource,"player:admin") >= 1 then
		local realName = getElementData(playerSource,"player:charname");
		local anick = getElementData(playerSource,"player:adminname");
		if not getElementData(playerSource,"player:adminduty") then
			setElementData(playerSource,"player:adminduty",true);
			exports["Pinfobox"]:addNotification(root,anick.." adminszolgálatba lépett.","info")
			outputAdminMessage("#8163bf"..getElementData(playerSource, "player:adminname").."#ffffff adminszolgálatba lépett!")
		else

			setElementData(playerSource,"player:adminduty",false);
			exports["Pinfobox"]:addNotification(root,anick.." kilépett az adminszolgálatból.","info")
			outputAdminMessage("#8163bf"..getElementData(playerSource, "player:adminname").."#ffffff kilépett az adminszolgálatból!")
		   
		end
	end
 else
	local targetPlayer,targetPlayerName = exports["Pcore"]:findPlayerByPartialNick(playerSource,target)
	if getElementData(playerSource,"player:admin") >= 3 then 
		local realName = getElementData(targetPlayer,"player:charname");
		local anick = getElementData(targetPlayer,"player:adminname");
		if not getElementData(targetPlayer,"player:adminduty") then
		setElementData(targetPlayer,"player:adminduty",true);
		exports["Pinfobox"]:addNotification(root,anick.." adminszolgálatba lépett.","info")
		outputAdminMessage("#8163bf"..getElementData(targetPlayer, "player:adminname").."#ffffff adminszolgálatba lépett!")
		else 
		setElementData(targetPlayer,"player:adminduty",false);
		exports["Pinfobox"]:addNotification(root,anick.." kilépett az adminszolgálatból.","info")
		outputAdminMessage("#8163bf"..getElementData(targetPlayer, "player:adminname").."#ffffff kilépett az adminszolgálatból!")
		end
	end 
 end
end
addCommandHandler("aduty",func.adminDuty)
addCommandHandler("adminduty",func.adminDuty)

function giveadmintime()
	for k,v in pairs(getElementsByType("player")) do 
		if getElementData(v,"player:admin") >= 1 then 
			if getElementData(v,"player:adminduty") then 
				setElementData(v,"admin:time",getElementData(v,"admin:time")+1)
			end
		end
	end
end
setTimer(giveadmintime,1000*60,0)

func.setAdminName = function(playerSource,cmd,target,...)
	if getElementData(playerSource,"player:admin") >= 6 or cache.serials[getPlayerSerial(playerSource)] then
		if target and (...) then
			local targetPlayer,targetPlayerName = exports["Pcore"]:findPlayerByPartialNick(playerSource,target)
			if targetPlayer then
				if getElementData(targetPlayer,"player:loggedIn") then
					local name = table.concat({...}, " ");
					outputChatBox("#8163bf[xProject] "..func.getName(playerSource).."#ffffff megváltoztatta #8163bf"..func.getName(targetPlayer).."#ffffff adminisztrátori nevét. #8163bf("..name..")",getRootElement(),0,206,209,true)
					setElementData(targetPlayer,"player:adminname",name);
				else
					outputChatBox("#8163bf[xProject]#ffffff A kiválasztott játékos nincs bejelentkezve.",playerSource,220,20,60,true)
				end
			end
		else
			outputChatBox("#8163bf[xProject] #ffffff/"..cmd.." [ID/Név] [adminnév]",playerSource,0,206,209,true)
		end
	end
end
addCommandHandler("setanick",func.setAdminName)

func.makeHelperLevel = function(playerSource,cmd,target,level)
	if getElementData(playerSource,"player:admin") >= 7 or cache.serials[getPlayerSerial(playerSource)] then
		if target and level then
			local targetPlayer,targetPlayerName = exports["Pcore"]:findPlayerByPartialNick(playerSource,target);
			if targetPlayer then
				if getElementData(targetPlayer,"player:loggedIn") then
					level = tonumber(level);
					if type(level) == "number" and level >= 0 and level <= 2 then
					    if getElementData(targetPlayer,"player:admin") >= 1 then
						    setElementData(targetPlayer,"player:admin",0)
						end
						local targetLevel = getElementData(targetPlayer,"player:helper");
						outputChatBox("#8163bf[xProject] "..func.getName(playerSource).."#ffffff megváltoztatta #8163bf"..getElementData(targetPlayer,"player:charname"):gsub("_", " ").."#ffffff adminsegéd szintjét. #8163bf("..targetLevel.." -> "..level..")",getRootElement(),0,206,209,true);
						setElementData(targetPlayer,"player:helper",level);
					else
						outputChatBox("#8163bf[xProject]#ffffff Helytelen szint.",playerSource,220,20,60,true);
					end
				else
					outputChatBox("#8163bf[xProject]#ffffff A kiválasztott játékos nincs bejelentkezve.",playerSource,220,20,60,true);
				end
			end
		else
			outputChatBox("#8163bf[xProject]#ffffff /"..cmd.." [ID/Név] [szint]",playerSource,0,206,209,true);
		end
	end
end
addCommandHandler("sethelperlevel",func.makeHelperLevel)

func.makeAdminLevel = function(playerSource,cmd,target,level)
	if getElementData(playerSource,"player:admin") >= 7 or cache.serials[getPlayerSerial(playerSource)] then
		if target and level then
			local targetPlayer,targetPlayerName = exports["Pcore"]:findPlayerByPartialNick(playerSource,target);
			if targetPlayer then
				if getElementData(targetPlayer,"player:loggedIn") then
					level = tonumber(level);
					if type(level) == "number" and level >= 0 and level <= 11 then
						if not cache.serials[getPlayerSerial(playerSource)] and level >= getElementData(playerSource,"player:admin") then
							return
						end
						local targetLevel = getElementData(targetPlayer,"player:admin");
						if getElementData(targetPlayer,"player:helper") >= 1 then
						    setElementData(targetPlayer,"player:helper",0)
						end
						outputChatBox("#8163bf[xProject] "..func.getName(playerSource).."#ffffff megváltoztatta #8163bf"..func.getName(targetPlayer).."#ffffff adminisztrátori szintjét. #8163bf("..targetLevel.." -> "..level..")",getRootElement(),0,206,209,true);
						setElementData(targetPlayer,"player:admin",level);
					else
						outputChatBox("#8163bf[xProject]#ffffff Helytelen szint.",playerSource,220,20,60,true);
					end
				else
					outputChatBox("#8163bf[xProject]#ffffff A kiválasztott játékos nincs bejelentkezve.",playerSource,220,20,60,true);
				end
			end
		else
			outputChatBox("#8163bf[xProject]#ffffff /"..cmd.." [ID/Név] [szint]",playerSource,0,206,209,true);
		end
	end
end
addCommandHandler("setalevel",func.makeAdminLevel)

func.gotoPlayer = function(playerSource,cmd,target)
	if getElementData(playerSource,"player:admin") >= 1 then
		if target then
			local targetPlayer, targetPlayerName = exports["Pcore"]:findPlayerByPartialNick(playerSource, target);
			if targetPlayer then
				if getElementData(targetPlayer, "player:loggedIn") then
					local x, y, z = getElementPosition(targetPlayer);
					local interior = getElementInterior(targetPlayer);
					local dimension = getElementDimension(targetPlayer);
					local r = getPedRotation(targetPlayer);

					x = x + ((math.cos(math.rad(r))) * 2);
					y = y + ((math.sin(math.rad(r))) * 2);
					
					setCameraInterior(playerSource, interior);
					
					if (isPedInVehicle(playerSource)) then
						local veh = getPedOccupiedVehicle(playerSource);
						setVehicleTurnVelocity(veh,0,0,0);
						setElementInterior(playerSource,interior);
						setElementDimension(playerSource,dimension);
						setElementInterior(veh,interior);
						setElementDimension(veh,dimension);
						setElementPosition(veh,x,y,z+1);
						warpPedIntoVehicle(playerSource,veh);
						setTimer(setVehicleTurnVelocity,50,20,veh,0,0,0);
					else
						setElementPosition(playerSource, x, y, z);
						setElementInterior(playerSource, interior);
						setElementDimension(playerSource, dimension);
					end
					outputChatBox("#8163bf[xProject] #ffffffElteleportáltál a játékoshoz. #8163bf(" .. func.getName(targetPlayer) .. ")",playerSource,255,255,255,true);
					outputChatBox("#8163bf[xProject] #8163bf"..getElementData(playerSource,"player:adminname").."#ffffff hozzád teleportált.",targetPlayer,0,206,209,true);
				else
					outputChatBox("#8163bf[xProject] #ffffffA kiválasztott játékos nincs bejelentkezve.",playerSource,220,20,60,true);
				end
			end
		else
			outputChatBox("#8163bf[xProject] #ffffff/"..cmd.." [ID/Név]",playerSource,0,206,209,true);
		end
	end
end
addCommandHandler("goto",func.gotoPlayer)

func.SgotoPlayer = function(playerSource,cmd,target)
	if getElementData(playerSource,"player:admin") >= 2 then
		if target then
			local targetPlayer, targetPlayerName = exports["Pcore"]:findPlayerByPartialNick(playerSource, target);
			if targetPlayer then
				if getElementData(targetPlayer, "player:loggedIn") then
					local x, y, z = getElementPosition(targetPlayer);
					local interior = getElementInterior(targetPlayer);
					local dimension = getElementDimension(targetPlayer);
					local r = getPedRotation(targetPlayer);

					x = x + ((math.cos(math.rad(r))) * 2);
					y = y + ((math.sin(math.rad(r))) * 2);
					
					setCameraInterior(playerSource, interior);
					
					if (isPedInVehicle(playerSource)) then
						local veh = getPedOccupiedVehicle(playerSource);
						setVehicleTurnVelocity(veh,0,0,0);
						setElementInterior(playerSource,interior);
						setElementDimension(playerSource,dimension);
						setElementInterior(veh,interior);
						setElementDimension(veh,dimension);
						setElementPosition(veh,x,y,z+1);
						warpPedIntoVehicle(playerSource,veh);
						setTimer(setVehicleTurnVelocity,50,20,veh,0,0,0);
					else
						setElementPosition(playerSource, x, y, z);
						setElementInterior(playerSource, interior);
						setElementDimension(playerSource, dimension);
					end
					outputChatBox("#8163bf[xProject] #ffffffTitokban elteleportáltál a játékoshoz. #8163bf(" .. func.getName(targetPlayer) .. ")",playerSource,255,255,255,true);
				else
					outputChatBox("#8163bf[xProject] #ffffffA kiválasztott játékos nincs bejelentkezve.",playerSource,220,20,60,true);
				end
			end
		else
			outputChatBox("#8163bf[xProject] #ffffff/"..cmd.." [ID/Név]",playerSource,0,206,209,true);
		end
	end
end
addCommandHandler("sgoto",func.SgotoPlayer)

func.getHere = function(playerSource,cmd,target)
	if getElementData(playerSource,"player:admin") >= 1 then	
		if target then
			local targetPlayer, targetPlayerName = exports["Pcore"]:findPlayerByPartialNick(playerSource, target);
			if targetPlayer then
				if getElementData(targetPlayer, "player:loggedIn") then
					local x, y, z = getElementPosition(playerSource)
					local interior = getElementInterior(playerSource)
					local dimension = getElementDimension(playerSource)
					local r = getPedRotation(playerSource)
					setCameraInterior(targetPlayer, interior)
					x = x + ( ( math.cos ( math.rad ( r ) ) ) * 2 )
					y = y + ( ( math.sin ( math.rad ( r ) ) ) * 2 )
				
					if (isPedInVehicle(targetPlayer)) then
						local veh = getPedOccupiedVehicle(targetPlayer)
						setVehicleTurnVelocity(veh, 0, 0, 0)
						setElementPosition(veh, x, y, z + 1)
						setTimer(setVehicleTurnVelocity, 50, 20, veh, 0, 0, 0)
						setElementInterior(veh, interior)
						setElementDimension(veh, dimension)
					else
						setElementPosition(targetPlayer, x, y, z)
						setElementInterior(targetPlayer, interior)
						setElementDimension(targetPlayer, dimension)
					end
					outputChatBox("#8163bf[xProject] #FFFFFFMagadhoz teleportáltál egy játékost. #8163bf("..func.getName(targetPlayer)..")", playerSource,255,255,255,true);
					outputChatBox("#8163bf[xProject] #8163bf"..getElementData(playerSource,"player:adminname").."#ffffff magához teleportált téged. ",targetPlayer,0,206,209,true);
				else
					outputChatBox("#8163bf[xProject] #ffffffA kiválasztott játékos nincs bejelentkezve.",playerSource,220,20,60,true);
				end
			end
		else
			outputChatBox("#8163bf[xProject] #ffffff/"..cmd.." [ID/Név]",playerSource,0,206,209,true);
		end
	end
end
addCommandHandler("gethere",func.getHere)

func.setMoney = function(playerSource,cmd,target,typ,amount)
	if getElementData(playerSource,"player:admin") >= 7 then
		if target and typ and amount then
			typ = tonumber(typ)
			amount = tonumber(amount)
			if type(typ) == "number" and (typ >= 1 and typ <= 3) and type(amount) == "number" then
				local targetPlayer, targetPlayerName = exports["Pcore"]:findPlayerByPartialNick(playerSource, target);
				if targetPlayer then
					if getElementData(targetPlayer, "player:loggedIn") then
						if typ == 1 then
							outputChatBox("#8163bf[xProject]#ffffff Sikeresen beállítottad #8163bf"..func.getName(targetPlayer).."#ffffff pénzét #8163bf"..func.formatMoney(amount).."#ffffff dollára.",playerSource,220,20,60,true);
							outputChatBox("#8163bf[xProject]#ffffff Sikeresen beállította #8163bf"..getElementData(playerSource,"player:adminname").."#ffffff a pénzedet #8163bf"..func.formatMoney(amount).."#ffffff dollára.",targetPlayer,220,20,60,true);
							setElementData(targetPlayer,"player:money",amount)
						elseif typ == 2 then
							outputChatBox("#8163bf[xProject]#ffffff Sikeresen hozzáadtál #8163bf"..func.getName(targetPlayer).."#ffffff pénzéhez #8163bf"..func.formatMoney(amount).."#ffffff dollárt.",playerSource,220,20,60,true);
							outputChatBox("#8163bf[xProject]#ffffff Sikeresen hozzáadott #8163bf"..getElementData(playerSource,"player:adminname").."#ffffff a pénzedhez #8163bf"..func.formatMoney(amount).."#ffffff dollárt.",targetPlayer,220,20,60,true);
							setElementData(targetPlayer,"player:money",getElementData(targetPlayer,"player:money")+amount)
						elseif typ == 3 then
							outputChatBox("#8163bf[xProject]#ffffff Sikeresen elvettél #8163bf"..func.getName(targetPlayer).."#ffffff pénzéből #8163bf"..func.formatMoney(amount).."#ffffff dollárt.",playerSource,220,20,60,true);
							outputChatBox("#8163bf[xProject]#ffffff Sikeresen elvett #8163bf"..getElementData(playerSource,"player:adminname").."#ffffff a pénzedből #8163bf"..func.formatMoney(amount).."#ffffff dollárt.",targetPlayer,220,20,60,true);
							setElementData(targetPlayer,"player:money",getElementData(targetPlayer,"player:money")-amount)
						end
					else
						outputChatBox("#8163bf[xProject]#ffffff A kiválasztott játékos nincs bejelentkezve.",playerSource,220,20,60,true);
					end
				end
			else
				outputChatBox("#8163bf[xProject]#ffffff Helytelen tipus vagy összeg.",playerSource,220,20,60,true);
			end
		else
			outputChatBox("#8163bf[xProject] #ffffff /"..cmd.." [ID/Név] [tipus: 1 = beállítás, 2 = hozzáadás, 3 = elvétel] [összeg]",playerSource,0,206,209,true);
		end
	end
end
addCommandHandler("setmoney",func.setMoney)

func.setPP2 = function(playerSource,cmd,target,type,amount)
	if getElementData(playerSource,"player:admin") >= 10 then 
            if not target or not type or not amount then outputChatBox("#8163bf[xProject] #ffffff/"..cmd.." [ID/Név] [tipus: 1 = beállítás, 2 = hozzáadás, 3 = elvétel] [összeg]",playerSource,0,206,209,true) return end
			if not tonumber(type) or not tonumber(amount) then outputChatBox("#8163bf[xProject]#ffffff Helytelen tipus vagy összeg",playerSource,255,255,255,true) return end
			local targetPlayer, targetPlayerName = exports["Pcore"]:findPlayerByPartialNick(playerSource, target)
			if getElementData(targetPlayer,"player:loggedIn") then 
				if tonumber(type) == 1 then 
					outputChatBox("#8163bf[xProject]#ffffff Sikeresen beállítottad #8163bf"..func.getName(targetPlayer).."#ffffff pénzét #8163bf"..func.formatMoney(amount).."#ffffff $-ra.",playerSource,220,20,60,true);
					outputChatBox("#8163bf[xProject]#ffffff Sikeresen beállította #8163bf"..getElementData(playerSource,"player:adminname").."#ffffff a pénzed #8163bf"..func.formatMoney(amount).."#ffffff $-ra.",targetPlayer,220,20,60,true);
					setElementData(targetPlayer,"player:money",tonumber(amount))
				elseif tonumber(type) == 2 then 
					outputChatBox("#8163bf[xProject]#ffffff Sikeresen hozzáadtál #8163bf"..func.getName(targetPlayer).."#ffffff pénzéhez #8163bf"..func.formatMoney(amount).."#ffffff $-t.",playerSource,220,20,60,true);
					outputChatBox("#8163bf[xProject]#ffffff Sikeresen hozzáadott #8163bf"..getElementData(playerSource,"player:adminname").."#ffffff a pénzedhez #8163bf"..func.formatMoney(amount).."#ffffff $-t.",targetPlayer,220,20,60,true);
					setElementData(targetPlayer,"player:money",getElementData(targetPlayer,"player:money")+tonumber(amount))
				elseif tonumber(type) == 3 then
					outputChatBox("#8163bf[xProject]#ffffff Sikeresen elvettél #8163bf"..func.getName(targetPlayer).."#ffffff pénzéből #8163bf"..func.formatMoney(amount).."#ffffff $-t.",playerSource,220,20,60,true);
					outputChatBox("#8163bf[xProject]#ffffff Sikeresen elvett #8163bf"..getElementData(playerSource,"player:adminname").."#ffffff a pénzedből #8163bf"..func.formatMoney(amount).."#ffffff $-t.",targetPlayer,220,20,60,true);
					setElementData(targetPlayer,"player:money",getElementData(targetPlayer,"player:money")-tonumber(amount))
				end
		    end
	end 
end 
addCommandHandler("setplayermoney",func.setPP2)

func.setPP = function(playerSource,cmd,target,type,amount)
	if getElementData(playerSource,"player:admin") >= 10 then 
            if not target or not type or not amount then outputChatBox("#8163bf[xProject] #ffffff/"..cmd.." [ID/Név] [tipus: 1 = beállítás, 2 = hozzáadás, 3 = elvétel] [összeg]",playerSource,0,206,209,true) return end
			if not tonumber(type) or not tonumber(amount) then outputChatBox("#8163bf[xProject]#ffffff Helytelen tipus vagy összeg",playerSource,255,255,255,true) return end
			local targetPlayer, targetPlayerName = exports["Pcore"]:findPlayerByPartialNick(playerSource, target)
			if getElementData(targetPlayer,"player:loggedIn") then 
				if tonumber(type) == 1 then 
					outputChatBox("#8163bf[xProject]#ffffff Sikeresen beállítottad #8163bf"..func.getName(targetPlayer).."#ffffff prémium pontjait #8163bf"..func.formatMoney(amount).."#ffffff ppre.",playerSource,220,20,60,true);
					outputChatBox("#8163bf[xProject]#ffffff Sikeresen beállította #8163bf"..getElementData(playerSource,"player:adminname").."#ffffff a prémium pontjaid #8163bf"..func.formatMoney(amount).."#ffffff ppre.",targetPlayer,220,20,60,true);
					setElementData(targetPlayer,"player:pp",tonumber(amount))
				elseif tonumber(type) == 2 then 
					outputChatBox("#8163bf[xProject]#ffffff Sikeresen hozzáadtál #8163bf"..func.getName(targetPlayer).."#ffffff prémium pontjaihoz #8163bf"..func.formatMoney(amount).."#ffffff ppt.",playerSource,220,20,60,true);
					outputChatBox("#8163bf[xProject]#ffffff Sikeresen hozzáadott #8163bf"..getElementData(playerSource,"player:adminname").."#ffffff a prémium pontjaidhoz #8163bf"..func.formatMoney(amount).."#ffffff ppt.",targetPlayer,220,20,60,true);
					setElementData(targetPlayer,"player:pp",getElementData(targetPlayer,"player:pp")+tonumber(amount))
				elseif tonumber(type) == 3 then
					outputChatBox("#8163bf[xProject]#ffffff Sikeresen elvettél #8163bf"..func.getName(targetPlayer).."#ffffff prémium pontjaiból #8163bf"..func.formatMoney(amount).."#ffffff ppt.",playerSource,220,20,60,true);
					outputChatBox("#8163bf[xProject]#ffffff Sikeresen elvett #8163bf"..getElementData(playerSource,"player:adminname").."#ffffff a prémium pontjaidból #8163bf"..func.formatMoney(amount).."#ffffff ppt.",targetPlayer,220,20,60,true);
					setElementData(targetPlayer,"player:pp",getElementData(targetPlayer,"player:pp")-tonumber(amount))
				end
		    end
	end 
end 
addCommandHandler("setpp",func.setPP)

func.respawnPlayer = function(playerSource,cmd,target)
	if getElementData(playerSource,"player:admin") >= 1 then
		if target then
			local targetPlayer, targetPlayerName = exports["Pcore"]:findPlayerByPartialNick(playerSource, target);
			if targetPlayer then
				if getElementData(targetPlayer, "player:loggedIn") then
					if not isPlayerDead(targetPlayer) then return outputChatBox("#8163bf[xProject] #ffffffA játékos nem halott.",playerSource,255,255,255,true); end
					local px,py,pz = getElementPosition(playerSource);
					local x,y,z = getElementData(targetPlayer,"deadX"),getElementData(targetPlayer,"deadY"),getElementData(targetPlayer,"deadZ")
					local rotation = getPedRotation(targetPlayer);
					local skin = getElementModel(targetPlayer);
					local interior,dimension = getElementInterior(targetPlayer),getElementDimension(targetPlayer);

					setTimer(function()
					exports["Pdead"]:toRespawnCommand(targetPlayer)
					end,200,1)

					toggleControl(targetPlayer,"vehicle_left",true);
					toggleControl(targetPlayer,"vehicle_right",true);
					toggleControl(targetPlayer,"steer_forward",true);
					toggleControl(targetPlayer,"steer_back",true);
					toggleControl(targetPlayer,"accelerate",true);
					toggleControl(targetPlayer,"horn",true);
					toggleControl(targetPlayer,"enter_exit",true);
					toggleControl(targetPlayer,"brake_reverse",true);

					setElementData(targetPlayer,"player:hunger",100)
					setElementData(targetPlayer,"player:thirsty",100)

					if getElementData(targetPlayer,"player:cuffed") then
						exports.Pgroupscript:takePlayerCuff(targetPlayer);
					end

					setCameraTarget(targetPlayer,targetPlayer)
					spawnPlayer(targetPlayer,x,y,z,rotation,skin,interior,dimension);
					outputChatBox("#8163bf[xProject] #FFFFFFSikeresen újraélesztetted #8163bf"..func.getName(targetPlayer).."#ffffff -t.",playerSource,255,255,255,true);
					outputAdminMessage("#8163bf"..getElementData(playerSource, "player:adminname").."#ffffff újraélesztette #8163bf"..func.getName(targetPlayer).."#ffffff játékost.")
					outputChatBox("#8163bf[xProject] #8163bf"..getElementData(playerSource,"player:adminname") .. "#ffffff újraélesztett.", targetPlayer,0,206,209,true);
				else
					outputChatBox("#8163bf[xProject]#ffffff A kiválasztott játékos nincs bejelentkezve.",playerSource,220,20,60,true);
				end
			end
		else
			outputChatBox("#8163bf[xProject] #ffffff/"..cmd.." [ID/Név]",playerSource,220,20,60,true);
		end
	end
end
addCommandHandler("respawn",func.respawnPlayer)
addCommandHandler("asegit",func.respawnPlayer)

function nullAstats(player,cmd,target)
    if getElementData(player,"player:admin") >= 6 then
	    if target then
			local targetPlayer, targetPlayerName = exports["Pcore"]:findPlayerByPartialNick(playerSource, target);
            if targetPlayer then
                if getElementData(targetPlayer,"player:loggedIn") then
				    setElementData(targetPlayer,"admin:time",0)
				    setElementData(targetPlayer,"admin:recived",0)
				    setElementData(targetPlayer,"admin:replyed",0)
				    setElementData(targetPlayer,"admin:bans",0)
				    setElementData(targetPlayer,"admin:jails",0)
				    setElementData(targetPlayer,"admin:fixs",0)		
					outputAdminMessage("#8163bf"..getElementData(player, "player:adminname").."#ffffff nullázta #8163bf"..func.getName(targetPlayer).."#ffffff játékos adminstatjait.")
				end
            end		    
		else
		    outputChatBox("#8163bf[xProject] #ffffff/"..cmd.." [ID/Név]",player,255,255,255,true)
		end
	end
end
addCommandHandler("nullastats",nullAstats)

func.setPlayerSkin = function(playerSource,cmd,target,amount)
	if getElementData(playerSource,"player:admin") >= 1 then
		if target and amount then
			amount = tonumber(amount);
			if type(amount) == "number" then
				local targetPlayer, targetPlayerName = exports["Pcore"]:findPlayerByPartialNick(playerSource, target);
				if targetPlayer then
					if getElementData(targetPlayer, "player:loggedIn") then
						setElementModel(targetPlayer,amount);
						setElementData(targetPlayer,"player:skin",amount);
						outputChatBox("#8163bf[xProject] #ffffffBeállítottad #8163bf"..func.getName(targetPlayer).."#ffffff -nak/nek az skinjét. #8163bf("..amount..")",playerSource,231,217,176,true);
						outputAdminMessage("#8163bf"..getElementData(playerSource, "player:adminname").."#ffffff beállította #8163bf"..func.getName(targetPlayer).."#ffffff játékos kinézetét. #8163bf("..amount..")", targetPlayer)
						outputChatBox("#8163bf[xProject] #8163bf"..getElementData(playerSource,"player:adminname") .. "#ffffff beállította a skined. #8163bf("..amount..")", targetPlayer,0,206,209,true);
					else
						outputChatBox("#8163bf[xProject] #ffffffA kiválasztott játékos nincs bejelentkezve.",playerSource,220,20,60,true);
					end
				end
			else
				outputChatBox("#8163bf[xProject] #ffffffHelytelen skin id.",playerSource,220,20,60,true);
			end
		else
			outputChatBox("#8163bf[xProject] #ffffff /"..cmd.." [ID/Név] [érték]",playerSource,0,206,209,true);
		end
	end
end
addCommandHandler("setskin",func.setPlayerSkin)

func.setHealth = function(playerSource,cmd,target,amount)
	if getElementData(playerSource,"player:admin") >= 1 then
		if target and amount then
			amount = tonumber(amount);
			if type(amount) == "number" then
				local targetPlayer, targetPlayerName = exports["Pcore"]:findPlayerByPartialNick(playerSource, target);
				if targetPlayer then
					if getElementData(targetPlayer, "player:loggedIn") then
					--	if getElementData(targetPlayer,"toGetUp") then return outputChatBox("#8163bf[xProject] #ffffffA játékost jelenleg felsegítik.",playerSource,255,255,255,true); end
						if isPlayerDead(targetPlayer) then return outputChatBox("#8163bf[xProject] #ffffffA játékos halott, először szedd fel.",playerSource,255,255,255,true); end
						setElementHealth(targetPlayer,amount);
						outputChatBox("#8163bf[xProject] #ffffffBeállítottad #8163bf"..func.getName(targetPlayer).."#ffffff -nak/nek az életerejét. #8163bf("..amount..")",playerSource,231,217,176,true);
						outputAdminMessage("#8163bf"..getElementData(playerSource, "player:adminname").."#ffffff beállította #8163bf"..func.getName(targetPlayer).."#ffffff játékos életerejét. #8163bf("..amount..")")
						outputChatBox("#8163bf[xProject] #8163bf"..getElementData(playerSource,"player:adminname") .. "#ffffff beállította az életerőd. #8163bf("..amount..")", targetPlayer,0,206,209,true);
					else
						outputChatBox("#8163bf[xProject] #ffffffA kiválasztott játékos nincs bejelentkezve.",playerSource,220,20,60,true);
					end
				end
			else
				outputChatBox("#8163bf[xProject] #ffffffHelytelen hp érték.",playerSource,220,20,60,true);
			end
		else
			outputChatBox("#8163bf[xProject] #ffffff/"..cmd.." [ID/Név] [érték]",playerSource,0,206,209,true);
		end
	end
end
addCommandHandler("sethp",func.setHealth)

func.setHunger = function(playerSource,cmd,target,amount)
	if getElementData(playerSource,"player:admin") >= 1 then
		if target and amount then
			amount = tonumber(amount);
			if type(amount) == "number" then
				local targetPlayer, targetPlayerName = exports["Pcore"]:findPlayerByPartialNick(playerSource, target);
				if targetPlayer then
					if getElementData(targetPlayer, "player:loggedIn") then
						setElementData(targetPlayer,"player:hunger",amount);
						outputChatBox("Beállítottad #00CED1"..func.getName(targetPlayer).."#e7d9b0 -nak/nek az ételszintjét. ("..amount..")",playerSource,231,217,176,true);
						outputChatBox(getElementData(playerSource,"player:adminname") .. "#e7d9b0 beállította az ételszinted. ("..amount..")", targetPlayer,0,206,209,true);
					else
						outputChatBox("[ViceCity]:#ffffff A kiválasztott játékos nincs bejelentkezve.",playerSource,220,20,60,true);
					end
				end
			else
				outputChatBox("[ViceCity]:#ffffff Helytelen érték.",playerSource,220,20,60,true);
			end
		else
			outputChatBox("Használat:#e7d9b0 /"..cmd.." [ID/Név] [érték]",playerSource,0,206,209,true);
		end
	end
end
addCommandHandler("sethunger",func.setHunger)

func.setThirsty = function(playerSource,cmd,target,amount)
	if getElementData(playerSource,"player:admin") >= 1 then
		if target and amount then
			amount = tonumber(amount);
			if type(amount) == "number" then
				local targetPlayer, targetPlayerName = exports["Pcore"]:findPlayerByPartialNick(playerSource, target);
				if targetPlayer then
					if getElementData(targetPlayer, "player:loggedIn") then
						setElementData(targetPlayer,"player:thirsty",amount);
						outputChatBox("Beállítottad #00CED1"..func.getName(targetPlayer).."#e7d9b0 -nak/nek az szomjúság szintjét. ("..amount..")",playerSource,231,217,176,true);
						outputChatBox(getElementData(playerSource,"player:adminname") .. "#e7d9b0 beállította az szomjúság szinted. ("..amount..")", targetPlayer,0,206,209,true);
					else
						outputChatBox("[ViceCity]:#ffffff A kiválasztott játékos nincs bejelentkezve.",playerSource,220,20,60,true);
					end
				end
			else
				outputChatBox("[ViceCity]:#ffffff Helytelen érték.",playerSource,220,20,60,true);
			end
		else
			outputChatBox("Használat:#e7d9b0 /"..cmd.." [ID/Név] [érték]",playerSource,0,206,209,true);
		end
	end
end
addCommandHandler("setthirsty",func.setThirsty)

func.setArmor = function(playerSource,cmd,target,amount)
	if getElementData(playerSource,"player:admin") >= 1 then
		if target and amount then
			amount = tonumber(amount);
			if type(amount) == "number" then
				local targetPlayer, targetPlayerName = exports["Pcore"]:findPlayerByPartialNick(playerSource, target);
				if targetPlayer then
					if getElementData(targetPlayer, "player:loggedIn") then
						setPlayerArmor(targetPlayer,amount);
						outputChatBox("#8163bf[xProject] #ffffffBeállítottad #8163bf"..func.getName(targetPlayer).."#ffffff -nak/nek a páncélját. #8163bf("..amount..")",playerSource,220,20,60,true);
						outputAdminMessage("#8163bf"..getElementData(playerSource, "player:adminname").."#ffffff beállította #8163bf"..func.getName(targetPlayer).."#ffffff játékos páncélját. #8163bf("..amount..")")
						outputChatBox("#8163bf[xProject] #8163bf"..getElementData(playerSource,"player:adminname") .. "#ffffff beállította a páncélod. #8163bf("..amount..")", targetPlayer,220,20,60,true);
					else
						outputChatBox("#8163bf[xProject] #ffffffA kiválasztott játékos nincs bejelentkezve.",playerSource,220,20,60,true);
					end
				end
			else
				outputChatBox("#8163bf[xProject] #ffffffHelytelen érték.",playerSource,220,20,60,true);
			end
		else
			outputChatBox("#8163bf[xProject] #ffffff/"..cmd.." [ID/Név] [érték]",playerSource,0,206,209,true);
		end
	end
end
addCommandHandler("setarmor",func.setArmor)

func.fly = function(playerSource, cmd)
	if getElementData(playerSource,"player:admin") >= 1 then
		triggerClientEvent(playerSource, "onClientFlyToggle", playerSource)
	end
end
addCommandHandler("fly",func.fly)

func.reloadAcl = function(playerSource,command)
	if getElementData(playerSource, "player:admin") >= 7 then
		local isReload = aclReload()
		if isReload then
			outputChatBox("#e43058[xProject- ACL] #ffffffReloaded.",playerSource,220,20,60,true)
			local isSaved = aclSave()
			if isSaved then
				outputChatBox("#e43058[xProject- ACL] #ffffffSaved.",playerSource,220,20,60,true)
			end
		else
			outputChatBox("#e43058[xProject- ACL] #ffffffHiba a kommunikációval.",playerSource,220,20,60,true)
		end
	end
end
addCommandHandler("reloadacl",func.reloadAcl)

func.addSerial = function(playerSource,cmd,target,serial)
	if cache.serials[getPlayerSerial(playerSource)] then
		if target and serial then
			local targetPlayer, targetPlayerName = exports["Pcore"]:findPlayerByPartialNick(playerSource, target);
			if targetPlayer then
				if getElementData(targetPlayer, "player:loggedIn") then
					local targetSerial = getPlayerSerial(targetPlayer);
					local targetDbid = getElementData(targetPlayer,"player:dbid")
					if targetSerial == serial then
						if not cache.serials[targetSerial] then
							dbQuery(function(query,playerSource,target)
					        	local _, _, id = dbPoll(query, 0);
					        	if id > 0 then
					        		cache.serials[serial] = true;
					           		outputChatBox("#8163bf[xProject] #ffffffSikeresen hozzáadtad #8163bf"..getElementData(targetPlayer,"player:adminname").."#ffffff serialját.",playerSource,220,20,60,true)
					           		outputChatBox("#8163bf[xProject] #ffffffSikeresen hozzáadta #8163bf"..getElementData(playerSource,"player:adminname").."#ffffff a serialodat.",targetPlayer,220,20,60,true)
								end
					    	end,{playerSource,target},func.dbConnect:getConnection(), "INSERT INTO `serials` SET `serial` = ?, `charid` = ?",serial,targetDbid);
					    else
					    	outputChatBox("#8163bf[xProject] #ffffffA megadott serial már benne van a rendszerben.",playerSource,220,20,60,true);
					    end
					else
						outputChatBox("#8163bf[xProject] #ffffffA kiválasztott játékos serialja nem azonos a beírt seriallal.",playerSource,220,20,60,true);
					end
				else
					outputChatBox("#8163bf[xProject] #ffffffA kiválasztott játékos nincs bejelentkezve.",playerSource,220,20,60,true);
				end
			end
		else
			outputChatBox("#8163bf[xProject] #ffffff/"..cmd.." [ID/Név] [serial]",playerSource,0,206,209,true);
		end
	end
end
addCommandHandler("addserial",func.addSerial)

func.getSerials = function(playerSource)
	if cache.serials[getPlayerSerial(playerSource)] then
		outputChatBox("#8163bf[xProject]#ffffff Developer serials:",playerSource,220,20,60,true);
		for v,k in pairs(cache.serials) do
			local onlinetext = "OFFLINE";
			if func.getOnlinePlayer(v) then
				onlinetext = "ONLINE";
			end
			outputChatBox("		"..v.." - "..onlinetext,playerSource)
		end
	end
end
addCommandHandler("serials",func.getSerials)

func.deleteSerial = function(playerSource,cmd,target,serial)
	if cache.serials[getPlayerSerial(playerSource)] then
		if target and serial then
			local targetPlayer, targetPlayerName = exports["Pcore"]:findPlayerByPartialNick(playerSource, target);
			if targetPlayer then
				if getElementData(targetPlayer, "player:loggedIn") then
					local targetSerial = getPlayerSerial(targetPlayer);
					if targetSerial == serial then
						if cache.serials[targetSerial] then
							dbExec(func.dbConnect:getConnection(),"DELETE FROM `serials` WHERE `serial` = ?",targetSerial)
							outputChatBox("#8163bf[xProject] #ffffffSikeresen töröltél egy serialt.", playerSource,220,20,60,true)
							outputChatBox("#8163bf[xProject]#ffffff #8163bf"..getElementData(playerSource,"player:adminname").."#ffffff törölte a serialod a rendszerből.", targetPlayer,220,20,60,true)
							cache.serials[targetSerial] = nil;
						else
							outputChatBox("#8163bf[xProject] #ffffffA megadott serial nincs benne a rendszerben.",playerSource,220,20,60,true);
						end
					else
						outputChatBox("#8163bf[xProject] #ffffffA kiválasztott játékos serialja nem azonos a beírt seriallal.",playerSource,220,20,60,true);
					end
				else
					outputChatBox("#8163bf[xProject] #ffffffA kiválasztott játékos nincs bejelentkezve.",playerSource,220,20,60,true);
				end
			end
		else
			outputChatBox("#8163bf[xProject] #ffffff/"..cmd.." [ID/Név] [serial]", playerSource,0,206,209,true)
		end
	end
end
addCommandHandler("delserial",func.deleteSerial)

func.banPlayer = function(playerSource,cmd,target,time,...)
	if getElementData(playerSource,"player:admin") >= 4 or cache.serials[getPlayerSerial(playerSource)] then
		local reason = table.concat({...}, " ");
		if target and time and reason then
			time = tonumber(time);
			if getElementData(playerSource,"player:admin") == 3 and time == 0 then
				outputChatBox("#8163bf[xProject] #ffffffTe örökre nem tudsz bannolni.",playerSource,220,20,60,true)
			else
				if getElementData(playerSource,"player:admin") == 3 and time > 168 then
					outputChatBox("#8163bf[xProject] #ffffffTe csak maximum csak 168 órára bannolhatsz.",playerSource,220,20,60,true)
				else
					local targetPlayer, targetPlayerName = exports["Pcore"]:findPlayerByPartialNick(playerSource, target);
					if targetPlayer then
					    local bans = getElementData(playerSource,"admin:bans")
						dbQuery(function(qh)
							local res, rows, err = dbPoll(qh, 0)
							if rows > 0 then
								--for k, row in pairs(res) do
									
								--end
								outputChatBox("#8163bf[xProject] #ffffffA kiválasztott játékosnak már van egy aktív kitíltása.",playerSource,220,20,60,true)
							else
								local targetSerial = getPlayerSerial(targetPlayer);
								local duration = (time*60)*60;
								local anick = getElementData(playerSource,"player:adminname");
								local targetName = getElementData(targetPlayer,"player:username");
								if not getElementData(targetPlayer,"player:loggedIn") then
									targetName = "Serial ban";
								end
								local timestamp = getRealTime()["timestamp"]+duration;
								local text = time.. " óra#ffffff";
								if time == 0 then
									timestamp = 23414590357;
									text = "Örök#ffffff";
								end
								setElementData(playerSource,"admin:bans",bans+1)
								dbExec(func.dbConnect:getConnection(),"UPDATE `users` SET `banned` = ? WHERE `serial` = ?",1,tostring(targetSerial));
								dbExec(func.dbConnect:getConnection() ,"INSERT INTO `bans` SET `name` = ?, `time` = ?, `serial` = ?, `admin` = ?, `reason` = ?, `defaulthours` = ?",targetName,timestamp,targetSerial,anick,reason,time)
								outputChatBox("[BAN]#ffffff #8163bf"..anick.."#ffffff kitíltotta #8163bf"..string.gsub(getElementData(targetPlayer,"player:charname"), "_", " ").."-t#ffffff a szerverről.",getRootElement(),220,20,60,true)
								outputChatBox("[BAN]#ffffff Idő: #8163bf"..text..". Indok: #8163bf"..reason,getRootElement(),220,20,60,true)
								kickPlayer(targetPlayer,anick,reason)
							end
						end,func.dbConnect:getConnection(),"SELECT * FROM `bans` WHERE `serial` = ?",getPlayerSerial(targetPlayer))

					end
				end
			end
		else
			outputChatBox("#8163bf[xProject] #ffffff/"..cmd.." [ID/Név] [óra, 0 = örök] [indok]", playerSource,0,206,209,true)
		end
	end
end
addCommandHandler("ban",func.banPlayer)

func.unbanPlayer = function(playerSource,cmd,serial)
	if getElementData(playerSource,"player:admin") >= 3 or cache.serials[getPlayerSerial(playerSource)] then
		if serial and #serial == 32 then
			dbQuery(function(qh)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					for k, row in pairs(res) do
						if getElementData(playerSource,"player:admin") < 6 and getElementData(playerSource,"player:adminname") ~= row.admin then
							outputChatBox("#8163bf[xProject] #ffffffTe nem unbannolhatod, ezt a serialt, mert nem te bannoltad ki.",playerSource,220,20,60,true)
						else
							dbExec(func.dbConnect:getConnection(),"UPDATE `users` SET `banned` = ? WHERE `serial` = ?",0,row.serial);
							dbExec(func.dbConnect:getConnection(),"DELETE FROM `bans` WHERE `serial` = ?",row.serial)
							outputChatBox("#8163bf[xProject] #ffffffSikeresen unbanoltad a megadott serialt.",playerSource,220,20,60,true)							
						end
					end
				else
					outputChatBox("#8163bf[xProject] #ffffffNincs találat a megadott serialra, lehetséges hogy elírtad vagy nem található ilyen kitiltás.",playerSource,220,20,60,true)
				end
			end,func.dbConnect:getConnection(),"SELECT * FROM `bans` WHERE `serial` = ?",serial)
		else
			outputChatBox("#8163bf[xProject] #ffffff/"..cmd.." [serial]", playerSource,0,206,209,true)
		end
	end
end
addCommandHandler("unban",func.unbanPlayer)

func.offlineBan = function(playerSource,cmd,name,time,...)
	if getElementData(playerSource,"player:admin") >= 4 or cache.serials[getPlayerSerial(playerSource)] then
		name = tostring(name):gsub("_", " ");
		time = tonumber(time);
		local reason = table.concat({...}, " ");
		if name and #name > 0 and time and time > 0 and reason then
			
			dbQuery(function(qh)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					for k, row in pairs(res) do
						local username = tostring(row.username);
						local serial = tostring(row.serial);
						local banned = tonumber(row.banned);
						local duration = (time*60)*60;
						local timestamp = getRealTime()["timestamp"]+duration;
						local anick = getElementData(playerSource,"player:adminname");
						if not func.getOnlinePlayer(serial) then
							if banned == 0 then
								local text = time.. " óra#ffffff";
								if time == 0 then
									timestamp = 23414590357;
									text = "Örök#ffffff";
								end
								dbExec(func.dbConnect:getConnection(),"UPDATE `users` SET `banned` = ? WHERE `serial` = ?",1,tostring(row.serial));
								dbExec(func.dbConnect:getConnection() ,"INSERT INTO `bans` SET `name` = ?, `time` = ?, `serial` = ?, `admin` = ?, `reason` = ?, `defaulthours` = ?",username,timestamp,serial,anick,reason,time)
								outputChatBox("[Offline-BAN]#ffffff #8163bf"..anick.."#ffffff kitíltotta #8163bf"..string.gsub(name, "_", " ").."-t#ffffff a szerverről.",getRootElement(),220,20,60,true)
								outputChatBox("[Offline-BAN]#ffffff Idő: #8163bf"..text..". Indok: #8163bf"..reason,getRootElement(),220,20,60,true)
							else
								outputChatBox("#8163bf[xProject] #ffffffA kiválasztott játékosnak már van egy aktív kitíltása.",playerSource,220,20,60,true)
							end
						else
							outputChatBox("#8163bf[xProject] #ffffffA kiválasztott játékos fennt van a szerveren.",playerSource,220,20,60,true)
						end
					end
				else
					outputChatBox("#8163bf[xProject] #ffffffNincs találat a megadott karakternévre.",playerSource,220,20,60,true)
				end
			end,func.dbConnect:getConnection(),"SELECT * FROM `users` WHERE `charname` = ?",name)
		else
			outputChatBox("#8163bf[xProject] #ffffff/"..cmd.." [Karakternév] [idő] [indok]", playerSource,0,206,209,true)
		end
	end
end
addCommandHandler("oban",func.offlineBan)

func.getOnlinePlayer = function(serial)
	for v,k in pairs(cache.players) do
		if getPlayerSerial(v) == serial then
			return true
		end
	end
end

func.adminChat = function(playerSource, commandName, ...)
 if getElementData(playerSource,"player:admin") >= 1 then 
	if not ... then outputChatBox("#8163bf[xProject] #ffffff/"..commandName.." [Üzenet]",playerSource,255,255,255,true) return end 
	local text = table.concat({...}, " ")
	for k,v in pairs(getElementsByType("player")) do 
		if getElementData(v,"player:admin") >= 1 then
		if getElementData(v,"toggleadminchat") then  
			local id;
			if getElementData(playerSource,"hiddenadmin") == 1 then 
				id = ""
			else 
				id = "["..getElementData(playerSource,"player:admin").."]"
			end 
			outputChatBox("[AdminChat] #ACD373"..id.." #f44842"..getElementData(playerSource,"player:adminname").." #ACD373("..getAdminTitle(getElementData(playerSource,"player:admin" )).."): #ffffff"..text, v, 227,64,88, true)
		end 
		end 
	end 
 end 
end
addCommandHandler("a",func.adminChat)

func.helperChat = function(playerSource, commandName, ...)
 if getElementData(playerSource,"player:admin") >= 1 or getElementData(playerSource,"player:helper") >= 1 then 
	if not ... then outputChatBox("#8163bf[xProject] #ffffff/"..commandName.." [Üzenet]",playerSource,255,255,255,true) return end 
	local text = table.concat({...}, " ")
	for k,v in pairs(getElementsByType("player")) do 
		if getElementData(v,"player:admin") >= 1 or getElementData(v,"player:helper") >= 1 then
		if getElementData(v,"toggleadminchat") then  
			local id;
			if getElementData(playerSource,"hiddenadmin") == 1 then 
				id = ""
			else 
				id = "[ID: "..getElementData(playerSource,"player:id").."]"
			end 
			if getElementData(playerSource,"player:admin") >= 1 then
			    title = getAdminTitle(getElementData(playerSource,"player:admin" ))
				nick = getElementData(playerSource,"player:adminname")
			else
			    if getElementData(playerSource,"player:helper") == 1 then
				    title = "Idg.Adminsegéd"
					nick = getElementData(playerSource,"player:charname"):gsub("_", " ")
				else
				    title = "Adminsegéd"
					nick = getElementData(playerSource,"player:charname"):gsub("_", " ")
				end
			end
			outputChatBox("[HelperChat] #ACD373"..id.." #f44842"..nick.." #ACD373("..title.."): #ffffff"..text, v, 227,64,88, true)
		end 
		end 
	end 
 end 
end
addCommandHandler("as",func.helperChat)

func.hiddenAdmin = function(playerSource)
if getElementData(playerSource,"player:admin") >= 3 then 
 if not getElementData(playerSource,"hiddenadmin") then 
  setElementData(playerSource,"hiddenadmin",true)
  outputChatBox("#8163bf[xProject] #ffffffMostantól rejtett admin vagy.",playerSource,255,255,255,true)
 else 
 setElementData(playerSource,"hiddenadmin",false)
 outputChatBox("#8163bf[xProject] #ffffffRejtett admin mód kikapcsolva.",playerSource,255,255,255,true)
 end 
end
end 
addCommandHandler("hideadmin",func.hiddenAdmin)

func.staffChat = function(playerSource, commandName, ...)
	if not (tonumber(getElementData(playerSource, "player:admin") or 0) >= 2) and not (tonumber(getElementData(playerSource, "player:admin") or 0) == -1) then 
	return 
end
  if ... then 
	local text = table.concat({...}, " ")
	for k, v in pairs(getElementsByType("player")) do
		if tonumber(getElementData(v, "player:admin") or 0) >= 8 then
			local id
			if getElementData(playerSource, "hiddenadmin") == 1 then
				id = ""
			else
				id = "["..getElementData(playerSource, "player:id") .."]"
			end
			outputChatBox("[StaffChat] #ACD373"..id.." #f44842"..getElementData(playerSource,"player:adminname").." #ACD373("..getAdminTitle(getElementData(playerSource,"player:admin" )).."): #ffffff"..text, v, 189,49,70, true)
		end
	end
  end
end
addCommandHandler("v",func.staffChat)

func.togachat = function(playerSource,commandName) 
	if getElementData(playerSource,"player:admin") >= 1 then 
		if not getElementData(playerSource,"toggleadminchat") then 
			setElementData(playerSource,"toggleadminchat",true)
			outputChatBox("#8163bf[xProject] #FFFFFFAdminChat bekapcsolva.",playerSource,255,255,255,true)
		else 
			setElementData(playerSource,"toggleadminchat",false)
			outputChatBox("#8163bf[xProject] #FFFFFFAdminChat kikapcsolva.",playerSource,255,255,255,true)
		end 
	end 
end 
addCommandHandler("togadminchat",func.togachat)
addCommandHandler("togachat",func.togachat)
addCommandHandler("toga",func.togachat)

func.vhSpawn = function(playerSource,commandName,target)
    if getElementData(playerSource, "player:admin") >= 1 then
        
        
        if not (target) then
            outputChatBox("#8163bf[xProject] #ffffff/"..commandName.." [ID/Név]", playerSource,220,20,60,true)
        else
            local targetPlayer, targetPlayerName = exports['Pcore']:findPlayerByPartialNick(playerSource, target)
            if targetPlayer then
                setElementPosition(targetPlayer, 1042.8876953125, 1031.326171875, 11)
                setElementInterior(targetPlayer, 0)
                setElementDimension(targetPlayer, 0)
                setCameraTarget(targetPlayer)
                
                
                
                outputChatBox("#8163bf[xProject] #FFFFFFElteleportáltad #8163bf" ..func.getName(targetPlayer).. " #ffffffjátékost a városházára.", playerSource,255,255,255,true)
                outputAdminMessage("#8163bf"..getElementData(playerSource, "player:adminname").."#ffffff elteleportálta #8163bf"..func.getName(targetPlayer).."#ffffff játékost a városházára.")
                outputChatBox("#8163bf[xProject] #8163bf" ..getElementData(playerSource,"player:adminname").."#ffffff városházára teleportált. ", targetPlayer,220,20,60,true)
            end
        end
    end
end
addCommandHandler("vhspawn",func.vhSpawn)

func.setDim = function( playerSource, commandName, target, dim )
	if getElementData(playerSource, "player:admin") >= 3 then
        if not ( target ) or not ( dim ) then
            outputChatBox ( "#8163bf[xProject] #ffffff/" .. commandName .. " [ID/Név] [Dimenzió]", playerSource, 220,20,60, true )
        else
            local username = getPlayerName ( playerSource )
            local targetPlayer, targetPlayerName = exports.Pcore:findPlayerByPartialNick ( playerSource, target )
                
            if ( targetPlayer ) then
                setElementDimension ( targetPlayer, dim )
				outputChatBox("#8163bf[xProject]#8163bf "..func.getName(targetPlayer).. "#ffffff dimenziója átírva: #8163bf" .. dim .. "#ffffff.", playerSource, 220,20,60, true)
				outputAdminMessage("#8163bf"..getElementData(playerSource, "player:adminname").."#ffffff megváltoztatta #8163bf"..func.getName(targetPlayer).."#ffffff dimenziójának számát. #8163bf("..dim..")",getRootElement(),0,206,209,true)
				outputChatBox("#8163bf[xProject]#8163bf "..getElementData(playerSource, "player:adminname").."#ffffff megváltoztatta a dimenziódnak a számát. #8163bf("..dim..")",targetPlayer,0,206,209,true)
			end
		end
    end
end
addCommandHandler ( "setdim", func.setDim )

func.fixVehicle = function(playerSource, commandName, targetPlayer)
	if getElementData(playerSource, "player:admin") >= 1 then
	    local fixs = getElementData(playerSource,"admin:fixs")
		if targetPlayer then
			local targetPlayer, targetPlayerName = exports.Pcore:findPlayerByPartialNick(playerSource, targetPlayer)

			local vehicleSource = getPedOccupiedVehicle(targetPlayer)

			if vehicleSource then
				fixVehicle(vehicleSource)
				setVehicleDamageProof(vehicleSource, false)
				outputChatBox("#8163bf" .. getElementData(playerSource, "player:adminname") .. "#ffffff megjavította a járműved.", targetPlayer, 205, 55, 55, true)
				outputChatBox("#8163bf" .. getElementData(targetPlayer,"player:charname") .. "#ffffff járműve megjavítva.", playerSource, 255, 255, 255, true)
				setElementData(playerSource,"admin:fixs",fixs+1)
			else
				outputChatBox("#8163bf[xProject]#ffffff Játékos nem tartózkodik járműben.", playerSource, 255, 255, 255, true)
			end
		elseif not targetPlayer then
			local sourceVehicle = getPedOccupiedVehicle(playerSource)
					
			if not sourceVehicle then
				for k,allVehicles in ipairs(getElementsByType("vehicle")) do
					local x,y,z = getElementPosition(playerSource)
					local targetX,targetY,targetZ = getElementPosition(allVehicles)
					if getDistanceBetweenPoints3D(x,y,z,targetX,targetY,targetZ) <= 4 then
						fixVehicle(allVehicles)
						setVehicleDamageProof(allVehicles, false)
						outputChatBox("#8163bf[xProject]#ffffff Jármű megjavítva.", playerSource, 255, 255, 255, true)
				        setElementData(playerSource,"admin:fixs",fixs+1)
					end
				end
			elseif sourceVehicle then
				fixVehicle(sourceVehicle)
				setVehicleDamageProof(sourceVehicle, false)
				outputChatBox("#8163bf[xProject]#ffffff Jármű megjavítva.", playerSource, 255, 255, 255, true)
				setElementData(playerSource,"admin:fixs",fixs+1)
			else
				outputChatBox("#8163bf[xProject]#ffffff Nem vagy járműben.", playerSource, 255, 255, 255, true)
			end
		else
			outputChatBox("#8163bfHasználat:#efeeed /" .. commandName .. " [ID]", playerSource, 205, 55, 55, true)
		end
	else
		outputChatBox("#8163bf[xProject]#ffffff Parancs használatához nincs elég jogosultságod.", playerSource, 255, 255, 255, true)
	end
end
addCommandHandler("fix", func.fixVehicle)

func.changeName = function(playerSource, commandName, target, ...)
    if getElementData(playerSource, "player:admin") >= 3 then
        if not (...) or not target then
            outputChatBox("#8163bf[xProject] #ffffff/" .. commandName .. " [ID/Név] [változónév]",playerSource,220,20,60,true)
        else
            local newName = table.concat({...}, "_")
            local targetPlayer, targetPlayerName = exports['Pcore']:findPlayerByPartialNick(playerSource, target)
            if targetPlayer then
                if getElementData(targetPlayer, "player:loggedIn") then
                    if newName ~= getElementData(targetPlayer,"player:charname") then
                        local founded = false
                        dbQuery(function(qh)
                            local res, rows, err = dbPoll(qh, 0)
                            local count = 0
                            if rows > 0 then
                                for k, row in pairs(res) do
                                    if row["charname"] == newName then
                                        founded = true
                                    end
                                end
                            end
                            if not founded then
                                outputChatBox("#8163bf[xProject] #ffffffMegváltoztattad egy játékos nevét. #8163bf("..string.gsub(getElementData(targetPlayer,"player:charname"), "_", " ").." -> "..string.gsub(newName, "_", " ")..")",playerSource,220,20,60,true)
								outputAdminMessage("#8163bf"..getElementData(playerSource, "player:adminname").."#ffffff megváltoztatta #8163bf"..func.getName(targetPlayer).."#ffffff nevét.#8163bf ("..string.gsub(getElementData(targetPlayer,"player:charname"), "_", " ").." -> "..string.gsub(newName, "_", " ")..")",playerSource,220,20,60,true)
								--newName = utf8.gsub(newName, "_", " ")
								setElementData(targetPlayer,"player:charname",newName)
                                dbExec(func.dbConnect:getConnection(),"UPDATE `users` SET `charname` = ? WHERE `id` = ?",newName,getElementData(targetPlayer,"player:dbid"));
                            else
                                outputChatBox ( "#8163bf[xProject] #ffffffEz a név már foglalt.", playerSource, 220,20,60, true )
                            end
                        end,func.dbConnect:getConnection(),"SELECT * FROM `users`")

                    else
                        outputChatBox ( "#8163bf[xProject] #ffffffA kiválasztott játékos neve már az.", playerSource, 220,20,60, true )
                    end
                else
                    outputChatBox("#8163bf[xProject] #ffffffA kiválasztott játékos nincs bejelentkezve.",playerSource,220,20,60,true);
                end
            end
        end
    end
end
addCommandHandler("changename", func.changeName )

function gotomark(element,x,y,z,int,dim,name)
if getElementData(element,"player:admin") >= 1 then 
	if getElementData(element,"player:loggedIn") then 

		setElementPosition(element,x,y,z)
		setElementInterior(element,int)
		setElementDimension(element,dim)

		if getPedOccupiedVehicle(element) then 
         removePlayerFromVehicle(element)
		end 

		outputChatBox("#8163bf[Teleport] #ffffffSikeresen elteleportáltál a #8163bf"..name.."#ffffff nevű markhoz.",element,255,255,255,true)
		
	end 
end
end 
addEvent("gotoMark",true)
addEventHandler("gotoMark",root,gotomark)

function getPosition(thePlayer, commandName)
	local x, y, z = getElementPosition(thePlayer)
	local rotation = getPedRotation(thePlayer)
	local dimension = getElementDimension(thePlayer)
	local interior = getElementInterior(thePlayer)

	outputChatBox("#8163bf[xProject] #FFFFFFPozíció: #FFFFFF" .. x .. ", " .. y .. ", " .. z, thePlayer, 209,156,50, true )
	outputChatBox("#8163bf[xProject] #FFFFFFRotáció: #FFFFFF" .. rotation, thePlayer, 209,156,50, true )
	outputChatBox("#8163bf[xProject] #FFFFFFDimenzió: #FFFFFF" .. dimension, thePlayer, 209,156,50, true )
	outputChatBox("#8163bf[xProject] #FFFFFFInterior: #FFFFFF" .. interior, thePlayer, 209,156,50, true )
end
addCommandHandler("getpos", getPosition, false, false)

function toggleInvisibility(thePlayer)
	if getElementData(thePlayer, "player:admin") >= 1 then
		local enabled = getElementData(thePlayer, "invisible")
		if (enabled == true) then
			setElementAlpha(thePlayer, 255)
			setElementData(thePlayer, "reconx", false)
			setElementData(thePlayer, "invisible", false)
		elseif (enabled == false or enabled == nil) then
			setElementAlpha(thePlayer, 0)
			setElementData(thePlayer, "reconx", true)
			setElementData(thePlayer, "invisible", true)
		else
			outputChatBox("#8163bf[xProject] #FFFFFFElőbb kapcsold ki az Admin TV-t.", thePlayer, 255, 0, 0, true)
		end
	end
end
addCommandHandler("disappear", toggleInvisibility)
addCommandHandler("vanish", toggleInvisibility)

function asay(thePlayer, commandName, ...)
	local anev = getElementData ( thePlayer, "player:adminname" )
	local username = getElementData(thePlayer, "player:adminname") or utf8.gsub(getElementData(thePlayer,"player:charname"),"_"," ")
	if getElementData(thePlayer, "player:admin") >= 1 then
			if not (...) then
				outputChatBox("#8163bf[xProject] #ffffff/".. commandName .." [Közlemény]", thePlayer,229,160,12,true)
			else
				
				message = table.concat({...}, " ")
				local playerName = getElementData(thePlayer, "player:adminname") or tf8.gsub(getElementData(thePlayer,"player:charname"),"_"," ")
				
				outputChatBox("#8163bf[Admin felhívás] #ffffff"  .. message .. " #8163bf(Írta: " .. username .. ")", getRootElement(), 255, 128, 0,true)
				exports["Pinfobox"]:addNotification(thePlayer,"Egy adminisztrátor felhívást hozott létre. Részletek a chatboxban.","info")
			end
		end
	end
addCommandHandler("asay", asay, false, false)

function dsayn(thePlayer, commandName, ...)
    local anev = getElementData ( thePlayer, "player:adminname" )
    local username = getElementData(thePlayer, "player:adminname") or tf8.gsub(getElementData(thePlayer,"player:charname"),"_"," ")
    if getElementData(thePlayer, "player:admin") >= 8 then
            if not (...) then
                outputChatBox("#8163bf[xProject] #ffffff/".. commandName .." [Közlemény]", thePlayer,229,160,12,true)
            else
                
                message = table.concat({...}, " ")
                local playerName = getElementData(thePlayer, "player:adminname") or tf8.gsub(getElementData(thePlayer,"player:charname"),"_"," ")
                
                outputChatBox("#ff0000[FIGYELEM FEJLESZTŐI FELHÍVÁS] #ffffff"  .. message .. " #ff0000(Írta: " .. username .. ")", getRootElement(), 255, 128, 0,true)
                exports["Pinfobox"]:addNotification(thePlayer,"Egy fejlesztő felhívást hozott létre. Részletek a chatboxban.","info")
            end
        end
    end
addCommandHandler("dsay", dsayn, false, false)

function freezePlayer(thePlayer, commandName, target)
	if getElementData(thePlayer, "player:admin") >= 1 then
		if not (target) then
			outputChatBox("#8163bf[xProject] #FFFFFF/" .. commandName .. " [NévRészlet]", thePlayer, 255, 194, 14, true)
		else
			local targetPlayer, targetPlayerName = exports.Pcore:findPlayerByPartialNick(thePlayer, target)
			if targetPlayer then
				local veh = getPedOccupiedVehicle( targetPlayer )
				if (veh) then
					setElementFrozen(veh, true)
					toggleAllControls(targetPlayer, false, true, false)
					outputChatBox("#8163bf[xProject] "..func.getName(thePlayer).." #FFFFFFLefagyasztott!", targetPlayer,0,0,0,true)
				else
					toggleAllControls(targetPlayer, false, true, false)
					setPedWeaponSlot(targetPlayer, 0)
					outputChatBox("#8163bf[xProject] "..func.getName(thePlayer).." #FFFFFFLefagyasztott!", targetPlayer,0,0,0,true)
				end
				outputAdminMessage("#8163bf" ..func.getName(thePlayer).. " #FFFFFFlefagyasztotta #8163bf" ..func.getName(targetPlayer).. "#FFFFFF-t.")
			end
		end
	end
end
addCommandHandler("freeze", freezePlayer, false, false)

function unfreezePlayer(thePlayer, commandName, target)
	if getElementData(thePlayer, "player:admin") >= 1 then
		if not (target) then
			outputChatBox("#8163bf[xProject] #FFFFFF/" .. commandName .. " [ID/Névrészlet]", thePlayer, 255, 194, 14, true)
		else
			local targetPlayer, targetPlayerName = exports.Pcore:findPlayerByPartialNick(thePlayer, target)
			if targetPlayer then
				local veh = getPedOccupiedVehicle( targetPlayer )
				if (veh) then
					setElementFrozen(veh, false)
					--toggleAllControls(targetPlayer, true, true, true)
				end
				--else
					toggleAllControls(targetPlayer, true, true, true)
					setElementFrozen(targetPlayer, false)
					-- Disable weapon scrolling if restrained
					if getElementData(targetPlayer, "restrain") == 1 then
						setPedWeaponSlot(targetPlayer, 0)
						toggleControl(targetPlayer, "next_weapon", false)
						toggleControl(targetPlayer, "previous_weapon", false)
					end
					outputChatBox("#8163bf[xProject] "..func.getName(thePlayer).." #FFFFFFKiolvasztott.", targetPlayer,200,200,200,true)
				outputAdminMessage("#8163bf"  ..func.getName(thePlayer).. " #FFFFFFkiolvasztotta #8163bf" ..func.getName(targetPlayer).. "#FFFFFF-t.")
			end
		end
	end
end
addCommandHandler("unfreeze", unfreezePlayer, false, false)

function outputAdminMessage(msg)
	for k,v in ipairs(getElementsByType("player")) do
		if (msg) and isElement(v) and tonumber(getElementData(v,"player:admin") or 0) >= 1 then
			outputChatBox("#8163bf[AdminNapló] ".. msg,v,255,255,255,true)
		end
	end
end
addEvent("outputAdminMessage",true)
addEventHandler("outputAdminMessage",root,outputAdminMessage)

addCommandHandler("kick",
	function(playerSource,cmd,targetPlayer,...)
		if getElementData(playerSource, "player:admin") >= 1 then
			
			if not (targetPlayer) or not (...) then
				outputChatBox("#8163bf[xProject] #ffffff/"..cmd.." [ID/Név] [Indok]", playerSource,229,160,12,true)
			else
				local targetPlayer, targetPlayerName = exports['Pcore']:findPlayerByPartialNick(playerSource, targetPlayer)
				if targetPlayer then
					reason = table.concat({...}, " ")
					if getElementData(targetPlayer, "player:loggedIn") then
						for k, v in ipairs(getElementsByType("player")) do
							
							if getElementData(v, "player:loggedIn") then
								outputChatBox("#8163bf[Kick] #8163bf" ..func.getName(playerSource).. "#ffffff kickelte #8163bf" ..func.getName(targetPlayer).. "#ffffff játékost.", v, 229,160,12,true)
								outputChatBox("#8163bf[Kick] #ffffffIndok: #8163bf" .. reason, v, 229,160,12,true)
							end

						end
						kickPlayer(targetPlayer, playerSource, reason)
					else
						kickPlayer(targetPlayer, playerSource, reason)
					end
				end
			end
		end
	end)

addCommandHandler("hospitalspawn",
	function(playerSource,commandName,target)
		if getElementData(playerSource, "player:admin") >= 1 then
			
			
			if not (target) then
				outputChatBox("#8163bf[xProject] #ffffff/"..commandName.." [ID/Név]", playerSource,229,160,12,true)
			else
				local targetPlayer, targetPlayerName = exports['Pcore']:findPlayerByPartialNick(playerSource, target)
				if targetPlayer then
					setElementPosition(targetPlayer, 1609.154296875, 1824.4970703125, 10.8203125)
					
					
				    outputAdminMessage("#8163bf"..getElementData(playerSource, "player:adminname").."#ffffff elteleportálta #8163bf"..func.getName(targetPlayer).."#ffffff játékost a kórházhoz.")
					outputChatBox("#8163bf[xProject] "..getElementData(playerSource, "player:adminname").."#ffffff kórházhoz teleportált téged. ",targetPlayer,229,160,12,true)
				end
			end
		end
	end
)

function SpecPlayer(thePlayer, commandName, targetPlayer)
	if getElementData(thePlayer, "player:admin") >= 1 then
		if not (targetPlayer) then
			local rx = getElementData(thePlayer, "reconx")
			local ry = getElementData(thePlayer, "recony")
			local rz = getElementData(thePlayer, "reconz")
			local reconrot = getElementData(thePlayer, "reconrot")
			local recondimension = getElementData(thePlayer, "recondimension")
			local reconinterior = getElementData(thePlayer, "reconinterior")

			if not (rx) or not (ry) or not (rz) or not (reconrot) or not (recondimension) or not (reconinterior) then
				outputChatBox("#8163bf[xProject] #ffffff/" .. commandName .. "#ffffff [ID/Név]", thePlayer, 255, 255, 255,true)
			else
				detachElements(thePlayer)

				setElementPosition(thePlayer, rx, ry, rz)
				setPedRotation(thePlayer, reconrot)
				setElementDimension(thePlayer, recondimension)
				setElementInterior(thePlayer, reconinterior)
				setCameraInterior(thePlayer, reconinterior)

				setElementData(thePlayer, "reconx", nil)
				setElementData(thePlayer, "recony", nil, false)
				setElementData(thePlayer, "reconz", nil, false)
				setElementData(thePlayer, "reconrot", nil, false)
				setCameraTarget(thePlayer, thePlayer)
				setElementAlpha(thePlayer, 255)
				outputChatBox("#8163bf[xProject] #FFFFFFAdmin TV: kikapcsolva.", thePlayer, 0, 206, 209, true)
				outputAdminMessage("#8163bf"..getElementData(thePlayer, "player:adminname").." #FFFFFFkikapcsolta a tévézést.")
			end
		else
			local targetPlayer, targetPlayerName = exports.Pcore:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local logged = getElementData(targetPlayer, "player:loggedIn")

				if (logged==0) then
					outputChatBox("#8163bf[xProject] #ffffffA játékos nincs bejelentkezve.", thePlayer, 255, 0, 0, true)
				else
					setElementAlpha(thePlayer, 0)

					if ( not getElementData(thePlayer, "reconx") or getElementData(thePlayer, "reconx") == true ) and not getElementData(thePlayer, "recony") then
						local x, y, z = getElementPosition(thePlayer)
						local rot = getPedRotation(thePlayer)
						local dimension = getElementDimension(thePlayer)
						local interior = getElementInterior(thePlayer)
						setElementData(thePlayer, "reconx", x)
						setElementData(thePlayer, "recony", y, false)
						setElementData(thePlayer, "reconz", z, false)
						setElementData(thePlayer, "reconrot", rot, false)
						setElementData(thePlayer, "recondimension", dimension, false)
						setElementData(thePlayer, "reconinterior", interior, false)
					end
					setPedWeaponSlot(thePlayer, 0)

					local playerdimension = getElementDimension(targetPlayer)
					local playerinterior = getElementInterior(targetPlayer)

					setElementDimension(thePlayer, playerdimension)
					setElementInterior(thePlayer, playerinterior)
					setCameraInterior(thePlayer, playerinterior)

					local x, y, z = getElementPosition(targetPlayer)
					setElementPosition(thePlayer, x - 10, y - 10, z - 5)
					local success = attachElements(thePlayer, targetPlayer, -10, -10, -5)
					if not (success) then
						success = attachElements(thePlayer, targetPlayer, -5, -5, -5)
						if not (success) then
							success = attachElements(thePlayer, targetPlayer, 5, 5, -5)
						end
					end

					if not (success) then
						outputChatBox("#8163bf[xProject] #ffffffNem sikerült kapcsolódni a játékoshoz.", thePlayer, 0, 255, 0, true)
					else
						setCameraTarget(thePlayer, targetPlayer)
						outputChatBox("#8163bf[xProject] #ffffffAdmin TV: Most #8163bf" ..func.getName(targetPlayer).. "#ffffff-t figyeled.", thePlayer, 255, 255, 255,true)
						outputAdminMessage("#8163bf"..getElementData(thePlayer, "player:adminname").."#ffffff elkezdte tévézni #8163bf"..func.getName(targetPlayer).." #FFFFFFjátékost.")

						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")

					end
				end
			end
		end
	end
end
addCommandHandler("spec", SpecPlayer, false, false)

function SspecPlayer(thePlayer, commandName, targetPlayer)
	if getElementData(thePlayer, "player:admin") >= 7 then
		if not (targetPlayer) then
			local rx = getElementData(thePlayer, "reconx")
			local ry = getElementData(thePlayer, "recony")
			local rz = getElementData(thePlayer, "reconz")
			local reconrot = getElementData(thePlayer, "reconrot")
			local recondimension = getElementData(thePlayer, "recondimension")
			local reconinterior = getElementData(thePlayer, "reconinterior")

			if not (rx) or not (ry) or not (rz) or not (reconrot) or not (recondimension) or not (reconinterior) then
				outputChatBox("#8163bf[xProject] #ffffff/" .. commandName .. "#ffffff [ID/Név]", thePlayer, 255, 255, 255,true)
			else
				detachElements(thePlayer)

				setElementPosition(thePlayer, rx, ry, rz)
				setPedRotation(thePlayer, reconrot)
				setElementDimension(thePlayer, recondimension)
				setElementInterior(thePlayer, reconinterior)
				setCameraInterior(thePlayer, reconinterior)

				setElementData(thePlayer, "reconx", nil)
				setElementData(thePlayer, "recony", nil, false)
				setElementData(thePlayer, "reconz", nil, false)
				setElementData(thePlayer, "reconrot", nil, false)
				setCameraTarget(thePlayer, thePlayer)
				setElementAlpha(thePlayer, 255)
				outputChatBox("#8163bf[xProject] #ffffff #FFFFFFAdmin TV: kikapcsolva.", thePlayer, 0, 206, 209, true)
			end
		else
			local targetPlayer, targetPlayerName = exports.Pcore:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local logged = getElementData(targetPlayer, "player:loggedIn")

				if (logged==0) then
					outputChatBox("#8163bf[xProject] #ffffffA játékos nincs bejelentkezve.", thePlayer, 255, 0, 0, true)
				else
					setElementAlpha(thePlayer, 0)

					if ( not getElementData(thePlayer, "reconx") or getElementData(thePlayer, "reconx") == true ) and not getElementData(thePlayer, "recony") then
						local x, y, z = getElementPosition(thePlayer)
						local rot = getPedRotation(thePlayer)
						local dimension = getElementDimension(thePlayer)
						local interior = getElementInterior(thePlayer)
						setElementData(thePlayer, "reconx", x)
						setElementData(thePlayer, "recony", y, false)
						setElementData(thePlayer, "reconz", z, false)
						setElementData(thePlayer, "reconrot", rot, false)
						setElementData(thePlayer, "recondimension", dimension, false)
						setElementData(thePlayer, "reconinterior", interior, false)
					end
					setPedWeaponSlot(thePlayer, 0)

					local playerdimension = getElementDimension(targetPlayer)
					local playerinterior = getElementInterior(targetPlayer)

					setElementDimension(thePlayer, playerdimension)
					setElementInterior(thePlayer, playerinterior)
					setCameraInterior(thePlayer, playerinterior)

					local x, y, z = getElementPosition(targetPlayer)
					setElementPosition(thePlayer, x - 10, y - 10, z - 5)
					local success = attachElements(thePlayer, targetPlayer, -10, -10, -5)
					if not (success) then
						success = attachElements(thePlayer, targetPlayer, -5, -5, -5)
						if not (success) then
							success = attachElements(thePlayer, targetPlayer, 5, 5, -5)
						end
					end

					if not (success) then
						outputChatBox("#8163bf[xProject] #ffffffNem sikerült kapcsolódni a játékoshoz.", thePlayer, 0, 255, 0, true)
					else
						setCameraTarget(thePlayer, targetPlayer)
						outputChatBox("#8163bf[xProject] #ffffffAdmin TV: Jelenleg titokban #8163bf" ..func.getName(targetPlayer).. "#ffffff-t figyeled.", thePlayer, 255, 255, 255,true)

						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")

					end
				end
			end
		end
	end
end
addCommandHandler("sspec", SspecPlayer, false, false)



function interiorChanged()
	for key, value in ipairs(getElementsByType("player")) do
		if isElement(value) then
			local cameraTarget = getCameraTarget(value)
			if (cameraTarget) then
				if (cameraTarget==source) then
					local interior = getElementInterior(source)
					local dimension = getElementDimension(source)
					setCameraInterior(value, interior)
					setElementInterior(value, interior)
					setElementDimension(value, dimension)
				end
			end
		end
	end
end
addEventHandler("onPlayerInteriorChange", getRootElement(), interiorChanged)

local vehs = {}
local counter = 0 

function veh(playerSource,cmd,model)
  if getElementData(playerSource, "player:admin") >= 7 then
	if not model then outputChatBox ("#8163bf[xProject] #ffffff/"..cmd.." [ID]", playerSource, 255, 255, 255, true) return end
		model = tonumber(model)
	local px,py,pz = getElementPosition(playerSource)
	counter = counter + 1
	vehs[counter] = createVehicle(model,px+1,py,pz)
    local int = getElementInterior(playerSource)
    local dim = getElementDimension(playerSource)

	setElementInterior(vehs[counter],int)
	setElementDimension(vehs[counter],dim)

	if vehs[counter] then 
	outputChatBox ("#8163bf[xProject] #ffffffLétrehoztál egy ideiglenes járművet. ID:"..counter, playerSource, 255, 255, 255, true)
	else 
	outputChatBox ("#8163bf[xProject] #ffffffHiba.", playerSource, 255, 255, 255, true)
	end
  end
end 
addCommandHandler("veh",veh)

function delallveh(playerSource,cmd)
  if getElementData(playerSource, "player:admin") >= 7 then
	if counter == 0 then outputChatBox ("#8163bf[xProject] #ffffffNincs létrehozva ideiglenes jármű.", playerSource, 255, 255, 255, true) return end

	for i = 1,counter do 
		destroyElement(vehs[i])
	end 

	outputChatBox ("#8163bf[xProject] #ffffffTöröltél "..counter.." ideiglenes járművet.", playerSource, 255, 255, 255, true)

	vehs = {}
	counter = 0
  end
end 
addCommandHandler("delallveh",delallveh)

addCommandHandler("setvcolor",
	function(playerSource,cmd,r,g,b,r2,g2,b2)
		if getElementData(playerSource, "player:admin") >= 7 then
			local veh = getPedOccupiedVehicle(playerSource)
			if not veh then
				outputChatBox ("#8163bf[xProject] #ffffffNem ülsz járműben.", playerSource, 124, 9, 9, true)
				return
			end
			if veh and r and g and b then
				r2 = r2 or 0 
				g2 = g2 or 0 
				b2 = b2 or 0
				setVehicleColor( veh, r, g, b, r2, g2, b2)
			else
				outputChatBox("#8163bf[xProject] #ffffff/"..cmd.." [R] [G] [B] [R2] [G2] [R2]", playerSource, 229,160,12, true)
				return
			end
		end
	end
)

addCommandHandler("eco",
function(thePlayer, cmd, target)
	if getElementData(thePlayer,"player:admin") >= 1 then
		if target then
			local targetPlayer = exports["Pcore"]:findPlayerByPartialNick(thePlayer,target)
			if targetPlayer then
				if getElementData(targetPlayer,"player:loggedIn") then
					outputChatBox("#8163bf[xProject] #ffffffKarakter név: #8163bf"..getElementData(targetPlayer,"player:charname"):gsub("_", " ").."", thePlayer, 255,255,255, true)
					outputChatBox("#8163bf[xProject] #ffffffKészpénz: #8163bf" ..getElementData(targetPlayer, "player:money").. " $", thePlayer, 255,255,255, true)
					--outputChatBox("#8163bf[xProject] #ffffffBanki egyenleg: #8163bf" ..getElementData(targetPlayer, "player:bankmoney").. " $", thePlayer, 255,255,255, true)
					--outputChatBox("#8163bf[xProject] #ffffffCoin: #8163bf" ..getElementData(targetPlayer, "player:coin").. "", thePlayer, 255,255,255, true)
				else
					outputChatBox("#8163bf[xProject] #ffffffNem található a megadott játékos.", thePlayer, 255,255,255, true)
				end
			end
		else
			outputChatBox("#8163bf[xProject] #ffffff/".. cmd .." [ID/Név]", thePlayer, 255,255,255, true)
		end
	end
end)

addCommandHandler("stats",
function(thePlayer, cmd, target)
	if getElementData(thePlayer,"player:admin") >= 1 then
		if target then
			local targetPlayer = exports["Pcore"]:findPlayerByPartialNick(thePlayer,target)
			if targetPlayer then
				if getElementData(targetPlayer,"player:loggedIn") then
					outputChatBox("#8163bf[xProject] #ffffffKarakter név: #8163bf"..getPlayerName(targetPlayer):gsub("_", " ").."", thePlayer, 255,255,255, true)
					outputChatBox("#8163bf[xProject] #ffffffÉhség: #ff9600"..getElementData(targetPlayer,"player:hunger").." #ffffff│ Szomjúság: #32b3ef"..getElementData(targetPlayer,"player:thirsty").."", thePlayer, 255,255,255, true)
					outputChatBox("#8163bf[xProject] #ffffffMunka: #8163bf"..getElementData(targetPlayer,"player:job").."", thePlayer, 255,255,255, true)
					outputChatBox("#8163bf[xProject] #ffffffJátszott perc: #8163bf"..getElementData(targetPlayer,"playedminutes").."", thePlayer, 255,255,255, true)
					outputChatBox("#8163bf[xProject] #ffffffRuházat: #8163bf"..getElementData(targetPlayer,"player:skin").."", thePlayer, 255,255,255, true)
					outputChatBox("#8163bf[xProject] #ffffffMásodlagos nyelvtípus: #8163bf"..getElementData(targetPlayer,"player:language").."", thePlayer, 255,255,255, true)
					outputChatBox("#8163bf[xProject] #ffffffAccount ID: #8163bf"..getElementData(targetPlayer,"player:dbid").."", thePlayer, 255,255,255, true)
					outputChatBox("#8163bf[xProject] #ffffffKarakter ID: #8163bf"..getElementData(targetPlayer,"player:dbid").."", thePlayer, 255,255,255, true)
					outputChatBox("#8163bf[xProject] #ffffffAdminisztrátor név: #8163bf"..getElementData(targetPlayer,"player:adminname").."", thePlayer, 255,255,255, true)
					outputChatBox("#8163bf[xProject] #ffffffAdminisztrátor szint: #8163bf"..getElementData(targetPlayer,"player:admin").."", thePlayer, 255,255,255, true)
					outputChatBox("#8163bf[xProject] #ffffffAdminSegéd szint: #8163bf"..getElementData(targetPlayer,"player:helper").."", thePlayer, 255,255,255, true)
					outputChatBox("#8163bf[xProject] #ffffffSzint: #8163bf"..getElementData(targetPlayer,"player:level").."", thePlayer, 255,255,255, true)
					outputChatBox("#8163bf[xProject] #ffffffKészpénz: #8163bf"..getElementData(targetPlayer,"player:money").." $", thePlayer, 255,255,255, true)
					--outputChatBox("#8163bf[xProject] #ffffffBanki egyenleg: #8163bf"..getElementData(targetPlayer,"player:bankmoney").." $", thePlayer, 255,255,255, true)
					outputChatBox("#8163bf[xProject] #ffffffPrémium egyenleg: #8163bf"..getElementData(targetPlayer,"player:pp").." PP", thePlayer, 255,255,255, true)
					--outputChatBox("#8163bf[xProject] #ffffffSzervezet: #8163bf"..getElementData(targetPlayer,"groups:id").."", thePlayer, 255,255,255, true)
					outputAdminMessage(""..getElementData(thePlayer,"player:adminname").." #ffffffellenőrizte #8163bf" ..getPlayerName(targetPlayer):gsub("_", " ").. " #ffffffadatait.")
				else
					outputChatBox("#8163bf[xProject] #ffffffNem található a megadott játékos.", thePlayer, 255,255,255, true)
				end
			end
		else
			outputChatBox("#8163bf[xProject] #ffffff/".. cmd .." [ID/Név]", thePlayer, 255,255,255, true)
		end
	end
end)

local damageTypes = {
	[19] = "Rakétalövés",
	[37] = "Elégett",
	[50] = "Bedarálta egy helikopter",
	[51] = "Robbanás",
	[52] = "Elütötte egy jármű",
	[53] = "Megfulladt",
	[54] = "Leesett valahonnan",
	[55] = "Ismeretlen",
	[56] = "Leütötték",
	[57] = "Fegyver",
}

local bodyparts = {
	[3] = "Melkas",
	[4] = "Hátsó",
	[5] = "Jobbkéz",
	[6] = "Balkéz",
	[7] = "Jobbláb",
	[8] = "Balláb",
	[9] = "Fejlövés",
  }

function logWasted(ammo, attacker, weapon, bodypart)

   local time = getRealTime()
   local hours = time.hour
   local minutes = time.minute
   local name = utf8.gsub(getElementData(source,"player:charname"),"_"," ")
   local attackerName = " "
   local text = " "
   local body = bodyparts[bodypart]
   local reason = getWeaponNameFromID(weapon)


    if attacker then 
     if not getElementData(source,"player:injured") then 
   		if (getElementType(attacker) == "player") then 
   		text = "["..hours..":"..minutes.."] "..utf8.gsub(getElementData(attacker,"player:charname"),"_"," ").." megölte "..name.."-t. ["..reason..", "..body.."]"
   		elseif (getElementType(attacker) == "vehicle") then 
   		text = "["..hours..":"..minutes.."] "..name.." meghalt. [Jármű]"
   		elseif (getElementType(attacker) == "object") then 
		text = "["..hours..":"..minutes.."] "..name.." meghalt. [Zuhanás]"
		end 
	 else
		text = "["..hours..":"..minutes.."] "..name.." meghalt. [Lejárt anim idő]"
	 end
	else 
		text = "["..hours..":"..minutes.."] "..name.." meghalt. [Ismeretlen]"
	end 
	
	for k,v in ipairs(getElementsByType("player")) do
		if getElementData(v,"player:admin") >= 1 then 
		outputChatBox(text,v,105, 105, 105,true)
        end 
	end 
	
end 
addEventHandler("onPlayerWasted",root,logWasted)

function gotoPosition ( player, cmd, x,y,z )
		if getElementData(player,"player:admin") >= 1 then 
			if x and y and z then
				setElementPosition(player, x, y, z)
			else
				outputChatBox("[Gotopos] x, y, z",player)
			end
		end
end
addCommandHandler( "gotopos", gotoPosition, false, false )

addEventHandler("onElementDataChange",root,function(theKey, oldValue, newValue)
if getElementData(source,"player:loggedIn") then 
	if theKey == "player:money" then 
		if newValue >= 1000000 then 
			for k,player in pairs(getElementsByType("player")) do 
				if getElementData(player,"player:admin") and getElementData(player,"player:admin") >= 1 then
					    outputChatBox("#d42f2fVeszély: Magas pénzösszeg érzékelve!! #ffffff"..getElementData(source,"player:charname").." szintje: "..getElementData(source,"player:level")..", pénze: "..getElementData(source,"player:money").."$",player,255,255,255,true)
				end 
			end 
		end
	end
end
end)


--JAIL--
function onspawn(theKey, oldValue, newValue)
	if theKey == "player:loggedIn" then 
	local time = getElementData(source,"jailtime")
	local theTimer = setTimer(timerUnjailPlayer, 60000, time, source)
	end
end
addEventHandler("onElementDataChange",root,onspawn)

function jailPlayer(thePlayer, commandName, who, minutes, ...)
	if getElementData(thePlayer,"player:admin") >= 1 then
		local minutes = tonumber(minutes)
		if not (who) or not (minutes) or not (...) or (minutes<1) then
			outputChatBox("#8163bf[xProject] #FFFFFF/" .. commandName .. " [ID/Név] [Perc(>=1) 999=Végtelen] [Indok]", thePlayer, 255, 194, 14, true)
		else
			local targetPlayer, targetPlayerName = exports.Pcore:findPlayerByPartialNick(thePlayer, who)
			local reason = table.concat({...}, " ")
            local jails = getElementData(thePlayer,"admin:jails")
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

				outputChatBox("#8163bf[xProject] #FFFFFFBebörtönözted #8163bf" .. func.getName(targetPlayer) .. "#ffffff-t #8163bf" .. minutes .. "#ffffff percre.", thePlayer, 255, 0, 0, true)

				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
			--	dbPoll ( dbQuery( connection, "INSERT INTO adminhistory (user_char, user, admin_char, admin, hiddenadmin, action, duration, reason) VALUES (?, ?, ?, ?, ?, 0, ?, ?)", getPlayerName(targetPlayer), tostring(getElementData(targetPlayer, "gameaccountid") or 0), getPlayerName(thePlayer), tostring(getElementData(thePlayer, "gameaccountid") or 0), hiddenAdmin, ( minutes == 999 and 0 or minutes ), reason), -1 )

				if (not hiddenAdmin) then
					outputChatBox("#d75959[AdminJail] #8163bf" .. func.getName(thePlayer) .. "#ffffff bebörtönözte #8163bf" .. func.getName(targetPlayer) .. "#ffffff-t #8163bf" .. minutes .. "#ffffff percre.", getRootElement(), 255, 0, 0, true)
					outputChatBox("#d75959[AdminJail] #8163bfIndok: #ffffff" .. reason, getRootElement(), 255, 0, 0, true)
				else
					outputChatBox("#d75959[AdminJail] Rejtett Admin bebörtönözte " .. targetPlayerName .. "-t " .. minutes .. " percre.", getRootElement(), 255, 0, 0, true)
					outputChatBox("#d75959[AdminJail] Indok: " .. reason, getRootElement(), 255, 0, 0, true)
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
addCommandHandler("ajail", jailPlayer, false, false)

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
				outputAdminMessage("#d75959AdminJail: " .. func.getName(targetPlayer) .. "#ffffff Admin börtön ideje lenullázva." )
			else
				dbPoll ( dbQuery( connection, "UPDATE users SET adminjail_time='?' WHERE id='?'", timeLeft, accountID), -1 )
			end
		end
	end
end

function unjailPlayer(thePlayer, commandName, who)
	if getElementData(thePlayer,"player:admin") >= 1 then
		if not (who) then
			outputChatBox("#8163bf[xProject] #FFFFFF/" .. commandName .. " [ID/Név]", thePlayer, 255, 194, 14, true)
		else
			local targetPlayer, targetPlayerName = exports.Pcore:findPlayerByPartialNick(thePlayer, who)

			if (targetPlayer) then
				local jailed = getElementData(targetPlayer, "jailtimer", nil)
				local username = getPlayerName(thePlayer)
				local accountID = getElementData(targetPlayer, "player:dbid")

				if not (jailed) then
					outputChatBox("#8163bf[xProject] ".. func.getName(targetPlayer) .. "#ffffff nincs bebörtönözve.", thePlayer, 255, 0, 0, true)
				else
					dbPoll ( dbQuery( connection, "UPDATE users SET adminjail_time='0', adminjail='0' WHERE id='?'", accountID), -1 )

					if isTimer(jailed) then
						killTimer(jailed)
					end
					setElementData(targetPlayer, "jailtimer",false)
					setElementData(targetPlayer, "adminjailed",false)
					setElementData(targetPlayer, "jailreason",false)
					setElementData(targetPlayer, "jailtime",false)
					setElementData(targetPlayer, "jailadmin",false)
					setElementPosition(targetPlayer, 1078.701171875, 1085.98046875, 10.8359375)
					setPedRotation(targetPlayer, 272.18768310547)
					setElementDimension(targetPlayer, 0)
					setCameraInterior(targetPlayer, 0)
					setElementInterior(targetPlayer, 0)
					outputChatBox("#d75959[AdminJail] #8163bf" .. func.getName(thePlayer) .. "#ffffff kivett a börtönbõl.", targetPlayer, 0, 255, 0, true)
					outputAdminMessage("#8163bf".. func.getName(targetPlayer) .. "#ffffff-t kivette a börtöbõl: #8163bf" .. func.getName(thePlayer) .. "#ffffff.")
				end
			end
		end
	end
end
addCommandHandler("unjail", unjailPlayer, false, false)
 
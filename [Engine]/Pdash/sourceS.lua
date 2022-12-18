func = {};
func.dbConnect = exports.Pcore;
groupCache = {};
groupMembers = {};
playerCache = {};
transactionCache = {};

local connection = exports.Pcore:getConnection()
local sellVehTable = {}
local ticks = {}
function fasz(player,cmd,target,value)
    if getElementData(player,"player:loggedIn") then	
	    if target and value then
		    if isPedInVehicle(player) then
			    local targetPlayer, targetName = exports.Pcore:findPlayerByPartialNick(player, target)
				if targetPlayer then
				    if player ~= targetPlayer then
				        local veh = getPedOccupiedVehicle(player)
					    local px,py,pz = getElementPosition(player)
					    local tx,ty,tz = getElementPosition(targetPlayer)
					    local ownerDBID = getElementData(player,"player:dbid")
					    local vehOwner = getElementData(veh,"vehicle:owner")
					    local money = getElementData(targetPlayer,"player:money")
					    local vehDBID = tonumber(getElementData(veh,"vehicle:dbid") or 0)
					    if ownerDBID == vehOwner then
					        if getDistanceBetweenPoints3D(px,py,pz,tx,ty,tz) <= 5 then
						        if money >= tonumber(value) then

								    if not ticks[player] then
									    ticks[player] = -500
								    end    
											
								    if getTickCount() <= ticks[player] + 5000 then
									    return
								    end
								    ticks[player] = getTickCount()
								
								    if not sellVehTable[targetPlayer] then
									    sellVehTable[targetPlayer] = {}
								    end
								    sellVehTable[targetPlayer][(#sellVehTable[targetPlayer]) + 1] = {vehDBID, value, true, player, veh}
					                outputChatBox("#8163bf[xProject]: "..getElementData(player,"player:charname").." #FFFFFFadásvételi ajánlatot küldött neked. ("..value..") /elfogad "..#sellVehTable[targetPlayer].." || /elutasít " .. #sellVehTable[targetPlayer].."",targetPlayer,255,255,255,true)
								    outputChatBox("#8163bf[xProject]: #FFFFFFSikeresen elküldtél egy adásvételi ajánlatot#8163bf "..getElementData(targetPlayer,"player:charname").."#ffffff -nak/nek.",player,255,255,255,true)
							    else
							        outputChatBox("#8163bf[xProject]: #FFFFFF Nincs elég pénz a játékosnál.",player,255,255,255,true)
							    end
					        else
					            outputChatBox("#8163bf[xProject]: #FFFFFF Túl messze van tőled a játékos.",player,255,255,255,true)
					        end
					    else
					        outputChatBox("#8163bf[xProject]: #FFFFFF Ez nem a te járműved!",player,255,255,255,true)
					    end
					end
				else
                    outputChatBox("#8163bf[xProject]: #FFFFFF Nincs ilyen játékos.",player,255,255,255,true)
				end
			else
			    outputChatBox("#8163bf[xProject]: #FFFFFF Nem ülsz járműben.",player,255,255,255,true)
			end
	    else
            outputChatBox("#8163bf[xProject]: #FFFFFF /sell [ID] [ár].",player,255,255,255,true)
		end
    end
end
addCommandHandler("sell",fasz)

addCommandHandler("elfogad",function(player, cmd, number)
	if number then
		number = tonumber(number)
		if sellVehTable[player] then
			if sellVehTable[player][number] then 
				if sellVehTable[player][number][3] then
					sellVehTable[player][number][3] = false

					--outputChatBox("#8163bf[xProject]:#ffffff Elfogadtad basszam ki a szád", playerSource,255,255,255,true)
					--outputChatBox("#8163bf[xProject]:#ffffff El lett fogadva legyél boldog", sellVehTable[playerSource][number][4],255,255,255,true)
					setElementData(player, "player:money", getElementData(player, "player:money") - sellVehTable[player][number][2])
					setElementData(sellVehTable[player][number][4], "player:money", getElementData(sellVehTable[player][number][4], "player:money") + sellVehTable[player][number][2])
					setElementData(sellVehTable[player][number][5], "vehicle:owner", getElementData(player, "player:dbid"))
					--local query = dbPoll(dbQuery(connection,"UPDATE vehicles SET owner = ? WHERE id = ?", getElementData(sellVehTable[player][number][4],"player:dbid") ,getElementData(sellVehTable[player][number][5],"vehicle:dbid")), -1)
					dbExec(connection, "UPDATE vehicles SET owner = ? WHERE id = ?",getElementData(player, "player:dbid"),sellVehTable[player][number][1])
				end
			end
		end
	else
		outputChatBox("#8163bf[xProject]: #FFFFFF Nincs ID")
	end
end)

addCommandHandler("elutasít",function(player, cmd, number)
	if number then
		number = tonumber(number)
		if sellVehTable[player] then
			if sellVehTable[player][number] then
				if sellVehTable[player][number][3] then
					sellVehTable[player][number][3] = false					
				end
			end
		end
	else
		outputChatBox("#8163bf[xProject]: #FFFFFF /elutasít [ID].")
	end
end)

func.start = function()
    dbQuery(function(qh)
		local res, rows, err = dbPoll(qh, 0)
        if rows > 0 then
            for k, row in pairs(res) do
				func.loadGroup(row)
            end
            outputDebugString("[Frakcó] Sikeresen betöltödött "..rows.." frakció.");
		end
    end,func.dbConnect:getConnection(), "SELECT * FROM `groups`");
    
    dbQuery(function(qh)
		local res, rows, err = dbPoll(qh, 0)
        if rows > 0 then
            for k, row in pairs(res) do
                func.loadMembers(row)
            end
		end
    end,func.dbConnect:getConnection(), "SELECT * FROM `groups_players`");
    
    dbQuery(function(qh)
		local res, rows, err = dbPoll(qh, 0)
        if rows > 0 then
            for k, row in pairs(res) do
                
                if not transactionCache[row.groupid] then
                    transactionCache[row.groupid] = {};
                end

                transactionCache[row.groupid][#transactionCache[row.groupid]+1] = {row.name,row.type,row.amount,row.date};

            end
		end
	end,func.dbConnect:getConnection(), "SELECT * FROM `groups_transactions`");

    for k,player in ipairs(getElementsByType("player")) do
        if not playerCache[player] then
            playerCache[player] = true;
        end
    end

end
addEventHandler("onResourceStart",resourceRoot,func.start)

func.dataChange = function(dataName)
	if getElementType(source) == "player" then
		if dataName == "player:loggedIn" then
            if getElementData(source,dataName) then
                if not playerCache[source] then
                    playerCache[source] = true;
                end
			end
		end
	end
end
addEventHandler("onElementDataChange",getRootElement(),func.dataChange)

func.loadGroup = function(row)
    groupCache[row.id] = {
        dbid = row.id;
        name = row.name;
        type = row.type;
        ranks = fromJSON(row.ranks);
        items = fromJSON(row.items);
        money = row.money;
    };
end

func.loadMembers = function(row)
    if not groupMembers[row.groupid] then
        groupMembers[row.groupid] = {};
    end
    if not groupMembers[row.groupid][row.uid] then
        groupMembers[row.groupid][row.uid] = {};
    end
    groupMembers[row.groupid][row.uid].id = row.id;
    groupMembers[row.groupid][row.uid].rank = row.rank;
    groupMembers[row.groupid][row.uid].leader = row.leader;
    groupMembers[row.groupid][row.uid].skin = row.skin;
    groupMembers[row.groupid][row.uid].charid = row.uid;
    groupMembers[row.groupid][row.uid].name = exports.Paccount:getPlayerCacheName(row.uid) or "Kreált név"..row.uid;
    groupMembers[row.groupid][row.uid].lastOnline = row.lastonline;
    groupMembers[row.groupid][row.uid].cardNumber = row.cardnumber;
end

func.loadPlayerGroups = function(playerSource,state,membersload)
    local playerdbid = getElementData(playerSource,"player:dbid");
    local load = {};
    local loaditems = {};
    local members = {};
    local loadtransactions = {};

    for groupid,v in pairs(groupMembers) do
        for k,data in pairs(groupMembers[groupid]) do
            if membersload then
                if not members[groupid] then
                    members[groupid] = {}
                end
                members[groupid][k] = groupMembers[groupid][k];
            end
            if playerdbid == k then
                if not transactionCache[groupid] then
                    transactionCache[groupid] = {}
                end
                load[#load+1] = groupCache[groupid];
                loaditems[#loaditems+1] = groupCache[groupid].items;
                loadtransactions[#loadtransactions+1] = transactionCache[groupid];
            end
        end
    end

    triggerClientEvent(playerSource,"syncPlayerGroups",playerSource,load,members,state,membersload,loaditems,loadtransactions)
end
addEvent("loadPlayerGroups",true)
addEventHandler("loadPlayerGroups",getRootElement(),func.loadPlayerGroups)

func.quitPlayer = function()

    if playerCache[source] then
        playerCache[source] = nil;
    end

    local playerdbid = getElementData(source,"player:dbid");
    for groupid,v in pairs(groupCache) do
        if groupMembers[groupid][playerdbid] then
            dbExec(func.dbConnect:getConnection(),"UPDATE `groups_players` SET `lastonline` = NOW() WHERE `id` = ?",groupMembers[groupid][playerdbid].id)
            groupMembers[groupid][playerdbid].lastOnline = generateDate();
            func.refreshGroupMembersData(groupid)
        end
    end
end
addEventHandler("onPlayerQuit",getRootElement(),func.quitPlayer)

func.refreshGroupMembersData = function(groupid,playerSource)
    if playerSource then
        triggerClientEvent(playerSource,"syncGroupMemberData",playerSource,groupid,groupMembers[groupid])
    else
        for k,data in pairs(groupMembers[groupid]) do
            local player = func.getOnline(groupMembers[groupid][k].charid);
            if player then
                triggerClientEvent(player,"syncGroupMemberData",player,groupid,groupMembers[groupid])
            end
        end
    end
end
addEvent("refreshGroupMembersData",true)
addEventHandler("refreshGroupMembersData",getRootElement(),func.refreshGroupMembersData)

func.refreshGroupMembersData2 = function(groupid,player)
        for k,data in pairs(groupMembers[groupid]) do
            local groupMember = getElementData(player,"player:dbid")
            local player = func.getOnline(groupMembers[groupid][k].charid);
            if player then
                if groupMember == groupMembers[groupid][k].charid then
                    return true
                end
            end
        end
    end
addEvent("refreshGroupMembersData2",true)
addEventHandler("refreshGroupMembersData2",getRootElement(),func.refreshGroupMembersData2)
function isinfaction(groupid,player)
    for k,data in pairs(groupMembers[groupid]) do
        local groupMember = getElementData(player,"player:dbid")
        local player = func.getOnline(groupMembers[groupid][k].charid);
        if player then
            if groupMember == groupMembers[groupid][k].charid then
                return true
            else
                return false
            end
        end
    end
end


func.refreshMembersGroupData = function(groupid)
    for k,data in pairs(groupMembers[groupid]) do
        local player = func.getOnline(groupMembers[groupid][k].charid);
        if player then
            func.loadPlayerGroups(player,false,false)
        end
    end
end
addEvent("refreshMembersGroupData",true)
addEventHandler("refreshMembersGroupData",getRootElement(),func.refreshMembersGroupData)

local timer = {};
function isPlayerInGroup(groupid,dbid)
    if groupMembers[groupid] then
        for k,data in pairs(groupMembers[groupid]) do
            if data.charid == dbid then
                return true,data;
            end
        end
    end
    return false,nil;
end
func.updateMemberRank = function(groupid,data)
    groupMembers[groupid][data.charid].rank = data.rank;
    dbExec(func.dbConnect:getConnection(),"UPDATE `groups_players` SET `rank` = ? WHERE `id` = ?",data.rank,data.id)
    if not timer[groupid] then
        timer[groupid] = {};
    end

    if not timer[groupid][data.charid] then
        timer[groupid][data.charid] = {};
    end

    if not isTimer(timer[groupid][data.charid]) then
        timer[groupid][data.charid] = setTimer(function()
            
            func.refreshGroupMembersData(groupid)

            killTimer(timer[groupid][data.charid])
        end,4000,1)
    end
end
addEvent("updateMemberRank",true)
addEventHandler("updateMemberRank",getRootElement(),func.updateMemberRank)

func.setGroupLeader = function(playerSource,cmd,target,groupid,leader)
	if getElementData(playerSource,"player:admin") >= 3 then
        if target and groupid and leader then
            groupid = tonumber(groupid);
            leader = tonumber(leader);
            if type(groupid) == "number" then
                if type(leader) == "number" and leader == 0 or leader == 1 then
                    local targetPlayer,targetPlayerName = exports["Pcore"]:findPlayerByPartialNick(playerSource,target)
                    if targetPlayer then
                        if getElementData(targetPlayer,"player:loggedIn") then
                            local charid = getElementData(targetPlayer,"player:dbid");
                            if groupCache[groupid] then
                                if groupMembers[groupid] then
                                    if groupMembers[groupid][charid] then
                                        if groupMembers[groupid][charid].leader ~= leader then
                                            groupMembers[groupid][charid].leader = leader;
                                            dbExec(func.dbConnect:getConnection(),"UPDATE `groups_players` SET `leader` = ? WHERE `id` = ?",leader,groupMembers[groupid][charid].id)
                                            func.refreshGroupMembersData(groupid)
                                            outputChatBox("#8163bf[xProject]:#ffffff Sikeresen beállítottad #8163bf"..getElementData(targetPlayer,"player:charname"):gsub("_", " ").."#ffffff -nak/nek a leader jogosultságát #8163bf"..leader.."#ffffff-ra.",playerSource,220,20,60,true)
                                        else
                                            outputChatBox("#8163bf[xProject]:#ffffff A kiválasztott játékosnak már az a leader értéke mint amit megadtál.",playerSource,220,20,60,true)
                                        end
                                    else
                                        outputChatBox("#8163bf[xProject]:#ffffff A kiválasztott játékos nem tagja a megadott szervezetnek.",playerSource,220,20,60,true)
                                    end
                                end
                            else
                                outputChatBox("#8163bf[xProject]:#ffffff A megadott frakció nem létezik. #8163bf("..groupid..")",playerSource,220,20,60,true)
                            end
                        else
                            outputChatBox("#8163bf[xProject]:#ffffff A kiválasztott játékos nincs bejelentkezve.",playerSource,220,20,60,true)
                        end
                    end
                else
                    outputChatBox("#8163bf[xProject]:#ffffff Helytelen leader érték.",playerSource,220,20,60,true)
                end
            else
                outputChatBox("#8163bf[xProject]:#ffffff Helytelen groupid érték.",playerSource,220,20,60,true)
            end
		else
			outputChatBox("Használat:#e7d9b0 /"..cmd.." [ID/Név] [groupid] [leader: 0 - nem, 1 - igen]",playerSource,0,206,209,true)
		end
	end
end
addCommandHandler("setgroupleader",func.setGroupLeader)

func.delPlayerGroup = function(playerSource,cmd,target,groupid)
	if getElementData(playerSource,"player:admin") >= 3 then
        if target and groupid then
            groupid = tonumber(groupid);
            if type(groupid) == "number" then
                    local targetPlayer,targetPlayerName = exports["Pcore"]:findPlayerByPartialNick(playerSource,target)
                    if targetPlayer then
                        if getElementData(targetPlayer,"player:loggedIn") then
                            local charid = getElementData(targetPlayer,"player:dbid");
                            if groupCache[groupid] then
                                if groupMembers[groupid] then
                                    if groupMembers[groupid][charid] then
                                        dbExec(func.dbConnect:getConnection(),"DELETE FROM `groups_players` WHERE `id` = ?",groupMembers[groupid][charid].id)
                                        groupMembers[groupid][charid] = nil;
                                        func.loadPlayerGroups(targetPlayer,true,true);
                                        func.refreshGroupMembersData(groupid);
                                        outputChatBox("#8163bf[xProject]:#ffffff Sikeresen eltávolítottad #8163bf"..getElementData(targetPlayer,"player:charname"):gsub("_", " ").."#ffffff -t a #8163bf"..groupCache[groupid].name.."#ffffff-ból/ből.",playerSource,220,20,60,true)
                                    
                                    else
                                        outputChatBox("#8163bf[xProject]:#ffffff A kiválasztott játékos nem tagja a megadott szervezetnek.",playerSource,220,20,60,true)
                                    end
                                end
                            else
                                outputChatBox("#8163bf[xProject]:#ffffff A megadott frakció nem létezik. #8163bf("..groupid..")",playerSource,220,20,60,true)
                            end
                        else
                            outputChatBox("#8163bf[xProject]:#ffffff A kiválasztott játékos nincs bejelentkezve.",playerSource,220,20,60,true)
                        end
                    end
            else
                outputChatBox("#8163bf[xProject]:#ffffff Helytelen groupid érték.",playerSource,220,20,60,true)
            end
		else
			outputChatBox("Használat:#e7d9b0 /"..cmd.." [ID/Név] [groupid]",playerSource,0,206,209,true)
		end
	end
end
addCommandHandler("delplayergroup",func.delPlayerGroup)

func.setPlayerGroup = function(playerSource,cmd,target,groupid)
	if getElementData(playerSource,"player:admin") >= 3 then
        if target and groupid then
            groupid = tonumber(groupid);
            if type(groupid) == "number" then
                    local targetPlayer,targetPlayerName = exports["Pcore"]:findPlayerByPartialNick(playerSource,target)
                    if targetPlayer then
                        if getElementData(targetPlayer,"player:loggedIn") then
                            local charid = getElementData(targetPlayer,"player:dbid");
                            if groupCache[groupid] then
                                if not groupMembers[groupid] then
                                    groupMembers[groupid] = {};
                                end
                                if not groupMembers[groupid][charid] then
                                    dbQuery(function(query,targetPlayer,groupid)
                                        local _, _, id = dbPoll(query, 0);
                                        if id > 0 then
                                            local data = {};
                                            data.groupid = groupid
                                            data.id = id;
                                            data.rank = 1;
                                            data.leader = 0;
                                            data.skin = 0;
                                            data.uid = charid;
                                            data.lastonline = generateDate();
                                            data.cardnumber = "";
                                            func.loadMembers(data);

                                            func.loadPlayerGroups(targetPlayer,true,true);
                                            func.refreshGroupMembersData(groupid);
                                            outputChatBox("#8163bf[xProject]:#ffffff Sikeresen felvetted #8163bf"..getElementData(targetPlayer,"player:charname"):gsub("_", " ").."#ffffff -t a #8163bf"..groupCache[groupid].name.."#ffffff-ba/be.",playerSource,220,20,60,true)
                                        end
                                    end,{targetPlayer,groupid},func.dbConnect:getConnection(), "INSERT INTO `groups_players` SET `uid` = ?, `groupid` = ?",charid,groupid);
                                else
                                    outputChatBox("#8163bf[xProject]:#ffffff A kiválasztott játékos már tagja a megadott szervezetnek.",playerSource,220,20,60,true)
                                end

                            else
                                outputChatBox("#8163bf[xProject]:#ffffff A megadott frakció nem létezik. #8163bf("..groupid..")",playerSource,220,20,60,true)
                            end
                        else
                            outputChatBox("#8163bf[xProject]:#ffffff A kiválasztott játékos nincs bejelentkezve.",playerSource,220,20,60,true)
                        end
                    end
            else
                outputChatBox("#8163bf[xProject]:#ffffff Helytelen groupid érték.",playerSource,220,20,60,true)
            end
		else
			outputChatBox("Használat:#e7d9b0 /"..cmd.." [ID/Név] [groupid]",playerSource,0,206,209,true)
		end
	end
end
addCommandHandler("setplayergroup",func.setPlayerGroup)

func.deleteGroupMember = function(playerSource,groupid,charid,state,targetElement)
    if groupMembers[groupid][charid] then
        dbExec(func.dbConnect:getConnection(),"DELETE FROM `groups_players` WHERE `id` = ?",groupMembers[groupid][charid].id)
        groupMembers[groupid][charid] = nil;
        func.refreshGroupMembersData(groupid);
        if state then
            func.loadPlayerGroups(targetElement,true,true);
        end
    end
end
addEvent("deleteGroupMember",true)
addEventHandler("deleteGroupMember",getRootElement(),func.deleteGroupMember)

func.addMemberToGroup = function(groupid,charid,playerElement)
    
    if not groupMembers[groupid][charid] then
        dbQuery(function(query,playerElement,groupid)
            local _, _, id = dbPoll(query, 0);
            if id > 0 then
                local data = {};
                data.groupid = groupid
                data.id = id;
                data.rank = 1;
                data.leader = 0;
                data.skin = 0;
                data.uid = charid;
                data.lastonline = generateDate();
                data.cardnumber = "";
                func.loadMembers(data);

                func.loadPlayerGroups(playerElement,true,true);
                func.refreshGroupMembersData(groupid);
            end
        end,{playerElement,groupid},func.dbConnect:getConnection(), "INSERT INTO `groups_players` SET `uid` = ?, `groupid` = ?",charid,groupid);
    end
end
addEvent("addMemberToGroup",true)
addEventHandler("addMemberToGroup",getRootElement(),func.addMemberToGroup)

func.changeMemberCardNumber = function(groupid,charid,newnumber)
    if groupMembers[groupid][charid] then
        if groupMembers[groupid][charid].cardNumber ~= newnumber then
            groupMembers[groupid][charid].cardNumber = newnumber;

            dbExec(func.dbConnect:getConnection(),"UPDATE `groups_players` SET `cardnumber` = ? WHERE `id` = ?", newnumber,groupMembers[groupid][charid].id)
            func.refreshGroupMembersData(groupid)

        end
    end
end
addEvent("changeMemberCardNumber",true)
addEventHandler("changeMemberCardNumber",getRootElement(),func.changeMemberCardNumber)

func.updateGroupData = function(groupid,typ,rank,newdata)
    if typ == "rank" then
        if groupCache[groupid].ranks[rank][1] ~= newdata then
            groupCache[groupid].ranks[rank][1] = newdata;
        end
    elseif typ == "wage" then
        if groupCache[groupid].ranks[rank][2] ~= newdata then
            groupCache[groupid].ranks[rank][2] = newdata;
        end
    end
    func.refreshMembersGroupData(groupid)
    dbExec(func.dbConnect:getConnection(),"UPDATE `groups` SET `ranks` = ? WHERE `id` = ?",toJSON(groupCache[groupid].ranks),groupid)
end
addEvent("updateGroupData",true)
addEventHandler("updateGroupData",getRootElement(),func.updateGroupData)

func.saveGroupItems = function(groupid,data)
    --if tostring(groupCache[groupid].items) ~= tostring(data) then
        exports.Pinfobox:addNotification(source,"Sikeresen elmentetted a szervezet tárgyait.","success")
        groupCache[groupid].items = data;
        func.refreshMembersGroupData(groupid)
        dbExec(func.dbConnect:getConnection(),"UPDATE `groups` SET `items` = ? WHERE `id` = ?",toJSON(groupCache[groupid].items),groupid)
        --[ [ [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ] ] ]
    --end
end
addEvent("saveGroupItems",true)
addEventHandler("saveGroupItems",getRootElement(),func.saveGroupItems)

func.setGroupMoney = function(groupid,newAmount)
    if groupCache[groupid].money ~= newAmount then
        groupCache[groupid].money = newAmount;
        func.refreshMembersGroupData(groupid)
        dbExec(func.dbConnect:getConnection(),"UPDATE `groups` SET `money` = ? WHERE `id` = ?",newAmount,groupid)
    end
end
addEvent("setGroupMoney",true)
addEventHandler("setGroupMoney",getRootElement(),func.setGroupMoney)

func.updateGroupMoneyByLeader = function(playerSource,groupid,amount,k)
    local playerMoney = getElementData(playerSource,"player:money");
    if k == 1 then
        if getElementData(playerSource,"player:money") >= amount then
            setElementData(playerSource,"player:money",getElementData(playerSource,"player:money")-amount)
            groupCache[groupid].money = groupCache[groupid].money + amount;
            func.refreshMembersGroupData(groupid)
            dbExec(func.dbConnect:getConnection(),"UPDATE `groups` SET `money` = ? WHERE `id` = ?",groupCache[groupid].money,groupid)
            outputChatBox("[xProject]:#ffffff Sikeresen beraktál #7cc576"..formatMoney(amount).."#ffffff dollárt.\nA #8163bf"..groupCache[groupid].name.."#ffffff kasszájában #7cc576"..groupCache[groupid].money.."#ffffff dollár van.",playerSource,129, 99, 191,true)
            exports.Pinfobox:addNotification(playerSource,"Sikeresen beraktál . "..formatMoney(amount).." dollárt. Részletek a chatboxban.","success")

            dbExec(func.dbConnect:getConnection(),"INSERT INTO `groups_transactions` SET `groupid` = ?, `amount` = ?, `name` = ?, `type` = ?",groupid,amount,getElementData(playerSource,"player:charname"):gsub("_", " "),"berakott")
            transactionCache[groupid][#transactionCache[groupid]+1] = {getElementData(playerSource,"player:charname"):gsub("_", " "),"berakott",amount,generateDate()};
            func.refreshMembersGroupData(groupid);
        else
            exports.Pinfobox:addNotification(playerSource,"Nincs nálad elegendő pénz. ("..formatMoney(amount).." $)","error")
        end
    elseif k == 2 then
        if groupCache[groupid].money >= amount then
            setElementData(playerSource,"player:money",getElementData(playerSource,"player:money")+amount)
            groupCache[groupid].money = groupCache[groupid].money - amount;
            func.refreshMembersGroupData(groupid)
            dbExec(func.dbConnect:getConnection(),"UPDATE `groups` SET `money` = ? WHERE `id` = ?",groupCache[groupid].money,groupid)
            outputChatBox("[xProject]:#ffffff Sikeresen beraktál #7cc576"..formatMoney(amount).."#ffffff dollárt.\nA #8163bf"..groupCache[groupid].name.."#ffffff kasszájában #7cc576"..groupCache[groupid].money.."#ffffff dollár van.",playerSource,129, 99, 191,true)
            exports.Pinfobox:addNotification(playerSource,"Sikeresen kivettél . "..formatMoney(amount).." dollárt. Részletek a chatboxban.","success")

            dbExec(func.dbConnect:getConnection(),"INSERT INTO `groups_transactions` SET `groupid` = ?, `amount` = ?, `name` = ?, `type` = ?",groupid,amount,getElementData(playerSource,"player:charname"):gsub("_", " "),"kivett")
            transactionCache[groupid][#transactionCache[groupid]+1] = {getElementData(playerSource,"player:charname"):gsub("_", " "),"kivett",amount,generateDate()};
            func.refreshMembersGroupData(groupid);
        else
            exports.Pinfobox:addNotification(playerSource,"Nincs a szervezet kasszájában elegendő pénz. ("..formatMoney(amount).." $)","error")
        end
    end
end
addEvent("updateGroupMoneyByLeader",true)
addEventHandler("updateGroupMoneyByLeader",getRootElement(),func.updateGroupMoneyByLeader)

func.setPlayerGroupDutySkin = function(playerSource,groupid,charid,skin,type)
    if groupMembers[groupid][charid].skin ~= skin then
        dbExec(func.dbConnect:getConnection(),"UPDATE `groups_players` SET `skin` = ? WHERE `id` = ?",skin,groupMembers[groupid][charid].id)
        groupMembers[groupid][charid].skin = skin;
        func.refreshGroupMembersData(groupid)
        if type == "duty" then
            local playerInDuty = getElementData(playerSource,"player:inDuty");
            if playerInDuty then
                setElementModel(playerSource,skin)
            end
        else
            setElementData(playerSource,"player:skin",skin)
            setElementModel(playerSource,skin)
        end
        setElementData(playerSource,"player:dutySkin",skin)
    end
end
addEvent("setPlayerGroupDutySkin",true)
addEventHandler("setPlayerGroupDutySkin",getRootElement(),func.setPlayerGroupDutySkin)

function getPlayerDutyItems(playerSource,groupid)
    local playerDbid = getElementData(playerSource,"player:dbid");
    if groupMembers[groupid] and groupMembers[groupid][playerDbid] then
        local rank = groupMembers[groupid][playerDbid].rank;
        return groupCache[groupid].items[rank];
    end
    return nil;
end

function getPlayerGroupData(groupid,dbid)
    if groupMembers[groupid] then
        if groupMembers[groupid][dbid] then
            return groupMembers[groupid][dbid];
        end
    end
    return nil;
end

func.getOnline = function(dbid)
    for player,k in pairs(playerCache) do
        if getElementData(player,"player:dbid") and getElementData(player,"player:dbid") == dbid and getElementData(player,"player:loggedIn") then
            return player;
        end
    end
    return nil;
end

local monthDays = {
	[1] = 31, -- jan
	[2] = 28, -- feb
	[3] = 31, -- márc
	[4] = 30, -- ápr
	[5] = 31, -- máj
	[6] = 30, -- jún
	[7] = 31, -- júl
	[8] = 31, -- aug
	[9] = 30, -- szept
	[10] = 31, -- okt
	[11] = 30, -- nov
	[12] = 31, -- dec
}

function setFightStyle(player,number)
    setPedFightingStyle(player,number)
end 
addEvent("setFightStyle",true)
addEventHandler("setFightStyle",root,setFightStyle)

function setWalkStyle(player,number)
    setPedWalkingStyle(player,number)
end 
addEvent("setWalkStyle",true)
addEventHandler("setWalkStyle",root,setWalkStyle)


local allowFactions = {
    [1] = {"LSRD","Los Santos Rendőrség","blue"},
    [2] = {"LVSD","Los Venturas Sheriff's Departments","blue"},
    [11] = {"LVMS","Los Venturas Medical Services","blue"},
    [3] = {"FBI","Federal Bureau of Investigation","blue"},
};

function govCommand(player,command,...)

        local faction = isAllowedFaction(player);
        if faction then 
            if not (...) then 
                outputChatBox("#8163bf [xProject] /" .. command .. " [szöveg]", player, 255, 255, 255, true);
                return;
            end
            local message = table.concat({...}," ");
            local color = 255,0,0
            local sColor = 129, 99, 191
            for k,v in pairs(getElementsByType("player")) do 

                    outputChatBox("#8163bf["..faction[2].." - Felhívás]",v,255,255,255,true);
                    outputChatBox(message,v,255,255,255,true);
                
            end
        end
    end

addCommandHandler("gov",govCommand,false,false);

addEvent("giveKey",true)
addEventHandler("giveKey",getRootElement(),function(player,item,count,value)
	exports["inventory"]:giveItem(player,item,value,count,0)
	exports.Pinfobox:addNotification(player,"Sikeres kulcs adás.", "success")
end)


function isAllowedFaction(player)
    local value = false;
    local fid = false;
    for k,v in pairs(allowFactions) do 
        local dbid = getElementData(player,"player:dbid")
        if isPlayerInGroup(k,dbid) then 
            value = v;
            fid = k;
            break;
        end
    end
    return value,fid;
end

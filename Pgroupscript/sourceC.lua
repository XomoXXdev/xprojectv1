fileDelete ("sourceC.lua") 
local func = {};
func.badge = {};
local availableGroups = {
    --[groupid] = true;
    [1] = true;
    [2] = true;
	[11] = true;
};

func.start = function()
    engineImportTXD (engineLoadTXD("files/taser.txd"), 2034)
	engineReplaceModel(engineLoadDFF("files/taser.dff", 2034), 2034)
end
addEventHandler("onClientResourceStart",resourceRoot,func.start)

func.badge.give = function(cmd,target,prefix,...)
    if getElementData(localPlayer,"player:loggedIn") then
        local playerDbid = getElementData(localPlayer,"player:dbid");
        for groupid,value in pairs(availableGroups) do
            local isInGroup,memberData = exports.Pdash:isPlayerInGroup(groupid,playerDbid);
            if isInGroup and memberData.leader == 1 then
                if target and prefix and (...) then
                    msg = table.concat({...}, " ")
                    if #prefix > 0 and #msg > 0 then
                        local targetPlayer, targetPlayerName = exports.Pcore:findPlayerByPartialNick(localPlayer,target)
                        if targetPlayer then
                            if getElementData(targetPlayer,"player:loggedIn") then
                                local playerX,playerY,playerZ = getElementPosition(localPlayer)
                                local targetX,targetY,targetZ = getElementPosition(targetPlayer)
                                if getDistanceBetweenPoints3D(playerX,playerY,playerZ,targetX,targetY,targetZ) <= 2 then
                                    triggerServerEvent("giveBadge",localPlayer,localPlayer,targetPlayer,msg,prefix)
                                else
                                    outputChatBox("#8163bf[xProject]:#ffffff A kiválasztott túl messze van tőled.",0,0,0,true)
                                end
                            else
                                outputChatBox("#8163bf[xProject]:#ffffff A kiválasztott játékos nincs bejelentkezve.",0,0,0,true)
                            end
                        end
                    end
                else
                    outputChatBox("#8163bf[xProject]:#ffffff /"..cmd.." [ID/Név] [előtag] [kiterjesztés]",0,0,0,true)
                end
                return
            end
        end
    end
end
addCommandHandler("jelvényad",func.badge.give)
addCommandHandler("jelvenyad",func.badge.give)
addCommandHandler("givebadge",func.badge.give)
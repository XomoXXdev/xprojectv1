addEvent("score:getMaxPlayers", true)
addEventHandler("score:getMaxPlayers",root,function(e)
    triggerClientEvent(e, "score:receiveMaxPlayers", e, getMaxPlayers())
end)
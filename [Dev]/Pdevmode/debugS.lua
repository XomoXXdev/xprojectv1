addEventHandler("onDebugMessage", root, function(dbMsg, dbLevel, dbFile, dbLine)
	triggerClientEvent(root, "debug->Add", root, dbMsg or "", dbLevel or 0, dbFile or 0, dbLine or 0)
end)

addEventHandler("onPlayerCommand", root, function(commandName)
	if commandName == "dev" or commandName == "devmode" then
		if getElementData(source, "player:admin") >= 8 then
			triggerClientEvent(source, "debug->ChangeState", source)
		--	outputChatBox( "[Legion - Developer]: Fejlesztő mód bekapcsolva!", player, 255, 255, 255, true )
		end
		cancelEvent()
	end
end)
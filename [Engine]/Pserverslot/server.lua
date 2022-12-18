setGameType("xProject:Las Venturas[dev]")
addCommandHandler("setserverslot", function(playerSource, cmd, number)
	if getElementData(playerSource, "player:admin") >= 10 then
		if number then
			outputChatBox("#ffffff Sikeresen megváltoztattad a szerver slotját. #299dff("..getMaxPlayers().." => "..number..")",playerSource,41,157,255,true)
			setMaxPlayers(number)
		else
			outputChatBox("Használat:#ffffff /"..cmd.." [slot]",playerSource,41,157,255,true)
		end
	end
end)
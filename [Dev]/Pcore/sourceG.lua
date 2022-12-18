function findPlayerByPartialNick(thePlayer, nick, msg, tipus)
	if not tipus then tipus = 1 end
	local byID = false
	if not nick and not thePlayer and type( thePlayer ) == "string" then
		return
	end
	
	if tonumber(nick) ~= nil then
		byID = true
	else
		byID = false
	end
	
	local tempTable = {}
	if not byID then
		if nick == "me" or nick == "*" then
			return thePlayer, getPlayerName(thePlayer)
		end
		nick = string.gsub(nick, " ", "_")
		nick = string.lower(nick)
		for key, value in ipairs(getElementsByType("player")) do
			local name = getPlayerName(value)
			local playerName = tostring(string.lower(name))
			
			if string.find(playerName, tostring(nick)) then
				local playerID = tonumber(getElementData(value, "player:id")) or 0
				local stringStart, stringEnd = string.find(playerName, tostring(nick))
				if tonumber(stringStart) > 0 and tonumber(stringEnd) > 0 then
					table.insert(tempTable, {value, name, playerID})
				end
			end
		end
	else
		nick = tonumber(nick) or 0
		for key, value in ipairs(getElementsByType("player")) do
			local playerID = tonumber(getElementData(value, "player:id")) or 0
			if playerID == nick then
				table.insert(tempTable, {value, getPlayerName(value), playerID})
			end
		end
	end
	
	if #tempTable == 1 then
		return tempTable[1][1], tempTable[1][2]
	elseif #tempTable == 0 then
		if not msg then
			if tipus == 1 then
				outputChatBox("#8163bf[xProject]:#ffffff Nem található a játékos.", thePlayer,255,255,255, true)
			else
			--	outputChatBox("#8163bf[xProject]:#ffffff Nem található a játékos.",255,255,255, true)
			end
		end
		return false
	else
		if not msg then
			if tipus == 1 then
				for k,v in ipairs(tempTable) do
					outputChatBox(v[2] .. " - [" .. v[3] .. "]", thePlayer, 220,20,60,true)
				end
			else
				for k,v in ipairs(tempTable) do
					outputChatBox("#8163bf[xProject] #ffffff" .. v[2] .. " - [" .. v[3] .. "]", 255,255,255, true)
				end
			end
		end
		return false
	end
	return false
end

function formatMoney(amount, spacer)
	if not spacer then spacer = "," end
	amount = math.floor(amount)
	local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1'..spacer):reverse())..right
end

specialCharacter = {
	"Á","Ä","Č","Ď","É","Í","Ĺ","Ľ","Ň","Ó","Ô","Ŕ","Š","Ť","Ú","Ý","Ž","á","ä","č","ď","é","í","ĺ","ľ","ň","ó","ô","ŕ","š","ť","ú","ý","ž",
	"Á","Č","Ď","É","Ě","Í","Ň","Ó","Ř","Š","Ť","Ú","Ů","Ý","Ž","á","č","ď","é","ě","í","ň","ó","ř","š","ť","ú","ů","ý","ž",
	"Ą","Ć","Ę","Ł","Ń","Ó","Ś","Ź","Ż","ą","ć","ę","ł","ń","ó","ś","ź","ż","Č","Ć","ǅ","Đ","ǈ","ǋ","Š","Ž","č","ć","ǆ","đ","ǉ","ǌ","š","ž",
	"Ă","Â","Î","Ș","Ț","ă","â","î","ș","țÀ","È","É","Ì","Ò","Ó","Ùà","è","é","ì","ò","ó","ù","À","Â","Ç","È","É","Ê","Ë","Î","Ï","Ô","Ù","Û","Ü","Ÿ","Æ","Œ",
	"à","â","ç","è","é","ê","ë","î","ï","ô","ù","û","ü","ÿ","æ","œ","Ñ","ñ","À","Á","Â","Ã","Ç","É","Ê","Í","Ó","Ô","Õ","Ú","Ü","à","á","â","ã","ç","é",
	"ê","í","ó","ô","õ","ú","ü","Ä","Ö","Üä","ö","ü","ßÅ","Ä","Öå","ä","öÅ","Æ","Øå","æ","øÁ","Ð","É","Í","Ó","Ú",
	"Ý","Þ","Æ","Ö","á","ð","é","í","ó","ú","ý","þ","æ","ö","Ç","Ğ","I","İ","Ö","Ş","Ü","ç","ğ","ı","i","ö","ş","ü","ē","ō","ū","Ē","Ō","Ū","Ā","Ī","Ū","Ṛ",
	"Ṝ","Ḷ","Ḹ","ā","ī","ū","ṛ","ṝ","ḷ","ḹ","Ŝ","ŝ","Á","É","Í","Ó","Ö","Ő","Ú","Ü","Ű","Ô","Õ","Û","Ũ","á","é","í","ó","ö","ő","ú","ü","ű","ô","õ","û","ũ","–","„"
};

local cache = {};
for v,k in pairs(specialCharacter) do
	cache[k] = true;
end

function getspecialCharacters()
	return cache;
end
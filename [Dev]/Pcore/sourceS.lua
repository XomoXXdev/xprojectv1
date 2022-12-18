local func = {}
local datas = {
	host = "host",
	username = "felhasznalo",
	password = "jelszo",
	database = "adatbazisneve",
}
local cache = {
	connection = nil,
	players = {},
}

func.join = function()
	local slot = nil
	for i = 1, getMaxPlayers() do
		if not cache.players[i] then
			slot = i
			break
		end
	end
	cache.players[slot] = source
	setElementData(source, "player:id", slot)
end
addEventHandler("onPlayerJoin",getRootElement(),func.join)

func.quit = function()
	local slot = getElementData(source, "player:id")
	if slot then
		cache.players[slot] = nil
	end
end
addEventHandler("onPlayerQuit",getRootElement(),func.quit)

func.start = function()
	cache.connection = dbConnect( "mysql", "dbname="..datas.database..";host="..datas.host, datas.username, datas.password, "charset=utf8" )
	if cache.connection  then
		outputDebugString("Mysql kapcsolat létrehozva.")
	else
		outputDebugString("Mysql kapcsolódás nem sikerült.")
		cancelEvent(true)
	end
	
	for k,v in ipairs(getElementsByType("player")) do
		cache.players[k] = v
		setElementData(v, "player:id", k)
	end
end
addEventHandler("onResourceStart",resourceRoot,func.start)

function getConnection()
	return cache.connection
end

setFPSLimit(60)
local func = {};
local cache = {};
func.dbConnect = exports["Pcore"];
cache.salt = "dbnew";
local playerCache = {};

func.onStart = function()
	dbQuery(function(qh,playerSource,id)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for k, row in pairs(res) do
				playerCache[tonumber(row.id)] = row;
			end
		end
	end,{playerSource,id},func.dbConnect:getConnection(),"SELECT * FROM `users`")
end
addEventHandler("onResourceStart",resourceRoot,func.onStart)

func.checkbanned = function(playerSource)
	local serial = getPlayerSerial(playerSource);
	dbQuery(function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for k, row in pairs(res) do
				local time = tonumber(row.time);
				local serverTimestamp = getRealTime()["timestamp"];
				if serverTimestamp >= time then
					dbExec(func.dbConnect:getConnection(),"DELETE FROM `bans` WHERE `serial` = ?",row.serial)
					func.requestAccount(playerSource);
				else
					triggerClientEvent(playerSource,"checkedPlayer",playerSource,"ban",{
							username = tostring(row.name);
							serial = tostring(row.serial);
							admin = tostring(row.admin);
							reason = tostring(row.reason);
							created = tostring(row.created);
							defaulthours = tonumber(row.defaulthours);
						}
					)
				end
			end
		else
			func.requestAccount(playerSource);
		end
	end,func.dbConnect:getConnection(),"SELECT * FROM `bans` WHERE `serial` = ?",serial)
end
addEvent("checkbanned",true)
addEventHandler("checkbanned",getRootElement(),func.checkbanned)

func.requestAccount = function(playerSource)
	local serial = getPlayerSerial(playerSource);
	dbQuery(function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for k, row in pairs(res) do
				local banned = tonumber(row.banned);
				if banned == 0 then
					triggerClientEvent(playerSource,"checkedPlayer",playerSource,"login")
				end
			end
		else
			triggerClientEvent(playerSource,"checkedPlayer",playerSource,"register")
		end
	end,func.dbConnect:getConnection(),"SELECT * FROM `users` WHERE `serial` = ?",serial)
end
addEvent("requestPlayerAccount",true)
addEventHandler("requestPlayerAccount",getRootElement(),func.requestAccount)

func.loginRequest = function(playerSource,username,password)
	if (string.len(password)~=64) then
		password = md5(cache.salt .. password);
	end
	dbQuery(function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for k, row in pairs(res) do
				if tonumber(row["banned"]) == 0 then
					if tostring(row["serial"]) == "" then
						if tostring(row["charname"]) == "notreg" then
							triggerClientEvent(playerSource,"onClientRequestLogin",playerSource,"create");
						else
							triggerClientEvent(playerSource,"onClientRequestLogin",playerSource,"login",row);
						end
						setElementData(playerSource,"player:dbid",tonumber(row["id"]));
						setElementData(playerSource,"player:admin",tonumber(row["admin"]));
						setElementData(playerSource,"player:adminname",tostring(row["adminname"]));
						setElementData(playerSource,"player:username",tostring(row["username"]));
						setElementData(playerSource,"player:helper",tonumber(row["helper"]));
						setElementData(playerSource,"player:regdate",tostring(row["created"]));
						dbExec(func.dbConnect:getConnection(),"UPDATE `users` SET `serial` = ?,`ip` = ? WHERE `id` = ?",getPlayerSerial(playerSource),getPlayerIP(playerSource),row["id"])
					else
						if tostring(row["serial"]) == getPlayerSerial(playerSource) then
							if tostring(row["charname"]) == "notreg" then
								triggerClientEvent(playerSource,"onClientRequestLogin",playerSource,"create");
							else
								triggerClientEvent(playerSource,"onClientRequestLogin",playerSource,"login",row);
							end
							setElementData(playerSource,"player:dbid",tonumber(row["id"]));
							setElementData(playerSource,"player:admin",tonumber(row["admin"]));
							setElementData(playerSource,"player:adminname",tostring(row["adminname"]));
							setElementData(playerSource,"player:username",tostring(row["username"]));
							setElementData(playerSource,"player:helper",tonumber(row["helper"]));
							setElementData(playerSource,"player:regdate",tostring(row["created"]));
							dbExec(func.dbConnect:getConnection(),"UPDATE `users` SET `serial` = ?, `ip` = ? WHERE `id` = ?",getPlayerSerial(playerSource),getPlayerIP(playerSource),row["id"])
						else
							exports["Pinfobox"]:addNotification(playerSource,"Ez a serial egy másik felhasználóhoz van társítva.","error");
						end
					end
				else
					exports["Pinfobox"]:addNotification(playerSource,"Ez a felhasználó ki van bannolva. (Értesítés küldve az adminoknak)","error");
				end
			end
		end
	end,func.dbConnect:getConnection(),"SELECT * FROM `users` WHERE `username` = ? AND `password` = ?",username,password)
end
addEvent("loginRequest",true)
addEventHandler("loginRequest",getRootElement(),func.loginRequest)

func.createAccount = function(playerSource,username,password,email)
	local defaultpassword = password
	if (string.len(password)~=64) then
		password = md5(cache.salt .. password)
	end
	dbQuery(function(qh,playerSource)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for k, row in pairs(res) do
				if row["username"] ~= username then
					if row["email"] ~= email then
						if row["serial"] ~= getPlayerSerial(playerSource) then
							func.registerFinish(playerSource,username,password,defaultpassword,email)
							return
						else
							exports["Pinfobox"]:addNotification(playerSource,"A te serialod egy másik felhasználóhoz van társítva.","error")
							return
						end
					else
						exports["Pinfobox"]:addNotification(playerSource,"A kiválasztott email már használatban van.","error")
						return
					end
				else
					exports["Pinfobox"]:addNotification(playerSource,"A kiválasztott felhasználónév már használatban van.","error")
					return
				end
			end
		else
			func.registerFinish(playerSource,username,password,defaultpassword,email)
		end
	end,{playerSource},func.dbConnect:getConnection(),"SELECT * FROM `users`")
end
addEvent("createAccountToServer",true)
addEventHandler("createAccountToServer",getRootElement(),func.createAccount)

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

func.generateDate = function()
	local realTime = getRealTime() 

    local date = {(realTime.year)+1900,(realTime.month)+1,realTime.monthday,realTime.hour,realTime.minute,realTime.second} 
	
	if date[2] < 10 then
		date[2] = "0"..date[2]
	end
	if date[3] < 10 then
		date[3] = "0"..date[3]
	end
	
	return date[1].."."..date[2].."."..date[3]
end

func.registerFinish = function(playerSource,username,password,defaultpassword,email)
	local date = func.generateDate()
	dbExec(func.dbConnect:getConnection(),"INSERT INTO `users` SET `username` = ?, `password` = ?, `email` = ?, `serial` = ?, `created` = ? , `ip` = ?",username,password,email,getPlayerSerial(playerSource),date,getPlayerIP(playerSource))
	exports["Pinfobox"]:addNotification(playerSource,"Sikeresen regisztráció.","success")
	triggerClientEvent(playerSource,"onRegisterFinish",playerSource,username,defaultpassword)
end

func.loginSpawnPlayer = function(playerSource,id)
	dbQuery(function(qh,playerSource,id)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for k, row in pairs(res) do
				local charname = row["charname"]
				local playedMinutes = tonumber(row["playedminutes"]);
				local x = tonumber(row["x"]);
				local y = tonumber(row["y"]);
				local z = tonumber(row["z"]);
				local rotation = tonumber(row["rotation"]);
				local interior = tonumber(row["interior"]);
				local dimension = tonumber(row["dimension"]);
				local height = tonumber(row["height"]);
				local weight = tonumber(row["weight"]);
				local age = tonumber(row["age"]);
				local money = tonumber(row["money"]);
				local premium = tonumber(row["premium"]);
				local health = tonumber(row["health"]);
				local armor = tonumber(row["armor"]);
				local hunger = tonumber(row["hunger"]);
				local thirsty = tonumber(row["thirsty"]);
				local skin = tonumber(row["skin"]);
				local dutySkin = tonumber(row["dutyskin"]);
				local inDuty = tostring(row["induty"]);
				local description = tostring(row["description"]);
				local level = tonumber(row["level"]);
				local payTime = tonumber(row["paytime"]);
				local job = tonumber(row["job"]);
				local valid = tonumber(row["valid"]);				
				local skills = fromJSON(tostring(row["skills"]));
				local jailtime = tonumber(row["adminjail_time"])
				local replyedPM = tonumber(row["replyedPM"]);
				local recivedPM = tonumber(row["recivedPM"]);
				local jails = tonumber(row["jails"]);
				local ban = tonumber(row["ban"]);
				local fix = tonumber(row["fix"]);
				local adutyTime = tonumber(row["adutyTime"]);
				local saystyle = row["talkstyle"] or 0
				local sayanim = row["talkanim"] or 0

				playerCache[tonumber(row.id)] = row;
				setPedStat(playerSource,77,skills[1]) -- AK-47
				setPedStat(playerSource,69,skills[2]) -- Colt-45
				setPedStat(playerSource,71,skills[3]) -- Desert Eagle
				setPedStat(playerSource,78,skills[4]) -- M4
				setPedStat(playerSource,76,skills[5]) -- MP5
				setPedStat(playerSource,79,skills[6]) -- Mesterlövész
				setPedStat(playerSource,73,skills[7]) -- Sawed-off
				setPedStat(playerSource,72,skills[8]) -- Sörétes
				setPedStat(playerSource,70,skills[9]) -- Silenced
				setPedStat(playerSource,74,skills[10]) -- Spaz 12
				setPedStat(playerSource,75,skills[11]) -- Uzi & Tec9
				setElementData(playerSource,"player:charname",tostring(charname))
				spawnPlayer(playerSource,x,y,z,rotation);
				setElementInterior(playerSource,interior)
				setElementDimension(playerSource,dimension)
				setElementHealth(playerSource,health);
				setPedArmor(playerSource,armor);
				setElementData(playerSource,"player:description",description)
				setElementData(playerSource,"player:money",money);
				setElementData(playerSource,"player:pp",premium)
				setElementData(playerSource,"player:hunger",hunger);
				setElementData(playerSource,"player:thirsty",thirsty);
				setElementData(playerSource,"player:skin",skin);
				setElementData(playerSource,"player:level",level);
				setElementData(playerSource,"player:paytime",payTime);
				setElementData(playerSource,"player:dutySkin",dutySkin);
				setElementData(playerSource,"job",job);
				setElementData(playerSource,"player:valid",valid);
				setElementData(playerSource,"jailtime",jailtime)
				setElementData(playerSource,"admin:jails",jails);
				setElementData(playerSource,"admin:bans",ban);
				setElementData(playerSource,"admin:time",adutyTime);
				setElementData(playerSource,"admin:recived",recivedPM);
				setElementData(playerSource,"admin:replyed",replyedPM);
				setElementData(playerSource,"admin:fixs",fix);
				setElementData(playerSource,"sayAnim",sayanim)
				setElementData(playerSource,"sayStyle",saystyle)
				setPlayerName(playerSource,charname:gsub(" ","_"))
				if inDuty == "true" then
					inDuty = true
					setElementModel(playerSource,dutySkin);
				elseif inDuty == "false" then
					inDuty = false
					setElementModel(playerSource,skin);
				end
				setElementData(playerSource,"player:inDuty",inDuty);
				setElementData(playerSource,"player:minutes",playedMinutes);
				setElementData(playerSource,"player:height",height);
				setElementData(playerSource,"player:weight",weight);
				setElementData(playerSource,"player:age",age);

				dbQuery(function(query)
                    local query, query_lines = dbPoll(query, 0)
                    if query_lines > 0 then
                        for i, row in pairs(query) do
                            exports.Pvehicle:vehicleLoad(row)
                        end
                    end
                end, func.dbConnect:getConnection(), "SELECT * FROM `vehicles` WHERE `owner` = ?", tonumber(getElementData(playerSource,"player:dbid")))

				triggerClientEvent(playerSource,"loginFinish",playerSource);
			end
		end
	end,{playerSource,id},func.dbConnect:getConnection(),"SELECT * FROM `users` WHERE `id` = ?",id)
end
addEvent("loginSpawnPlayer",true)
addEventHandler("loginSpawnPlayer",getRootElement(),func.loginSpawnPlayer)


func.createCharacter = function(playerSource,charname,age,weight,height,skin,descr,id)
	dbExec(func.dbConnect:getConnection(),"UPDATE `users` SET `charname` = ?, `age` = ?, `weight` = ?, `height` = ?, `skin` = ?, `description` = ?, `level` = ? WHERE `id` = ?",charname,age,weight,height,skin,descr,1,id)
	triggerClientEvent(playerSource,"createCharacterToClient",playerSource,{["charname"] = charname,["age"] = age,["weight"] = weight,["height"] = height,["skin"] = skin})
end
addEvent("createCharacter",true)
addEventHandler("createCharacter",getRootElement(),func.createCharacter)

func.saveCharacter = function()
	if getElementData(source,"player:loggedIn") then
		local id = getElementData(source,"player:dbid");
		local x,y,z = getElementPosition(source);
		local rotation = getPedRotation(source);
		local interior = getElementInterior(source);
		local dimension = getElementDimension(source);
		local health = getElementHealth(source);
		local armor = getPedArmor(source);
		local admin = getElementData(source,"player:admin");
		local adminname = getElementData(source,"player:adminname");
		local helper = getElementData(source,"player:helper");
		if helper == 1 then
		    helper = 0
		end
		local skin = getElementData(source,"player:skin");
		local dutySkin = getElementData(source,"player:dutySkin");
		local inDuty = getElementData(source,"player:inDuty");
		local description = getElementData(source,"player:description");
		local level = getElementData(source,"player:level");
		local job = getElementData(source,"job");
		local payTime = getElementData(source,"player:paytime") or 120;
		local valid = getElementData(source,"player:valid") or 0;

		local adutyTime = getElementData(source,"admin:time") or 0;
		local recived = getElementData(source,"admin:recived") or 0;
		local replyed = getElementData(source,"admin:replyed") or 0;
		local bans = getElementData(source,"admin:bans") or 0;
		local jails = getElementData(source,"admin:jails") or 0;
		local fixs = getElementData(source,"admin:fixs") or 0;
		local jailtime = getElementData(source,"jailtime") or 0
		local talkanim = getElementData(source,"sayAnim") or 0
		local talkstyle = getElementData(source,"sayStyle") or 0
		if inDuty then
			inDuty = "true"
		else
			inDuty = "false"
		end
		local playedMinutes = getElementData(source,"player:minutes");
		local money = getElementData(source,"player:money");
		local premium = getElementData(source,"player:pp");
		local hunger = getElementData(source,"player:hunger");
		local thirsty = getElementData(source,"player:thirsty");
		if playerCache[id] then
			playerCache[id].charname = getElementData(source,"player:charname");
		end
		local stats = toJSON({getPedStat(source,77),getPedStat(source,69),getPedStat(source,71),getPedStat(source,78),getPedStat(source,76),getPedStat(source,79),getPedStat(source,73),getPedStat(source,72),getPedStat(source,70),getPedStat(source,74),getPedStat(source,75)});

		dbExec(func.dbConnect:getConnection(),"UPDATE `users` SET `x` = ?, `y` = ?, `z` = ?, `rotation` = ?,`adminjail_time` = ?, `interior` = ?, `dimension` = ?, `description` = ? , `admin` = ?, `adminname` = ?, `helper` = ?, `skin` = ?, `dutyskin` = ?, `induty` = ?, `playedminutes` = ?, `money` = ?, `premium` = ? , `health` = ?, `armor` = ?, `hunger` = ?, `thirsty` = ?, `skills` = ?, `level` = ?, `paytime` = ?, `job` = ?, `valid` = ?, `adutyTime` = ?, `recivedPM` = ?, `replyedPM` = ?, `fix` = ?, `ban` = ?, `talkanim` = ?,`talkstyle` = ?, `jails` = ? WHERE `id` = ?",x,y,z,rotation,jailtime,interior,dimension,description,admin,adminname,helper,skin,dutySkin,inDuty,playedMinutes,money,premium,health,armor,hunger,thirsty,stats,level,payTime,job,valid,adutyTime,recived,replyed,fixs,bans,talkanim,talkstyle,jails,id)
	end
end
addEvent("saveCharacter",true)
addEventHandler("saveCharacter",getRootElement(),func.saveCharacter)
addEventHandler("onPlayerQuit",getRootElement(),func.saveCharacter)
addEventHandler("onResourceStop",getRootElement(),func.saveCharacter)

function getPlayerCache(dbid)
	if playerCache[tonumber(dbid)] then
		return playerCache[tonumber(dbid)];
	else
		return false;
	end
end

function getPlayerCacheName(dbid)
	if playerCache[tonumber(dbid)] then
		return playerCache[tonumber(dbid)].charname;
	else
		return false;
	end
end
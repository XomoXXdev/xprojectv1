fileDelete ("sourceC.lua") 
local show = false
local sx,sy = guiGetScreenSize();
local width = 800
local height = 600
local posX,posY = sx/2 - width/2, sy/2 - height/2
local pm = {}
local func = {};
local cache = {

	apanel = {
		show = true;
	};
	OpenSansB = dxCreateFont("files/OpenSansB.ttf",16);
	OpenSansEB = dxCreateFont("files/OpenSansEB.ttf",14);
	OpenSans = dxCreateFont("files/opensans.ttf",14);
	OpenSansL = dxCreateFont("files/OpenSans-Light.ttf",14)
};



--[[			local xml = xmlCreateFile( "Player/mark.xml", "marks" )
			local function saveNode( data, name )
				if #data >= 5 then
					local xml = xmlCreateChild( xml, "mark" )
					if name then
						xmlNodeSetValue( xml, name )
					end
					xmlNodeSetAttribute( xml, "x", data[1] )
					xmlNodeSetAttribute( xml, "y", data[2] )
					xmlNodeSetAttribute( xml, "z", data[3] )
					xmlNodeSetAttribute( xml, "interior", data[4] )
					xmlNodeSetAttribute( xml, "dimension", data[5] )]]

local mark = {}

function outputAdminMessage(msg)
    triggerServerEvent("outputAdminMessage",localPlayer,msg)
end

function jsonGET(file)
	local fileHandle
	local jsonDATA = {}
	if not fileExists(file) then
		fileHandle = fileCreate(file)
		fileWrite(fileHandle, toJSON({["Marks"] = widgets}))
		fileClose(fileHandle)
		fileHandle = fileOpen(file)
	else
		fileHandle = fileOpen(file)
	end
	if fileHandle then
		local buffer
		local allBuffer = ""
		while not fileIsEOF(fileHandle) do
			buffer = fileRead(fileHandle, 500)
			allBuffer = allBuffer..buffer
		end
		jsonDATA = fromJSON(allBuffer)
		fileClose(fileHandle)
	end
	return jsonDATA
end
  
function jsonSAVE(file, data)
	if fileExists(file) then
		fileDelete(file)
	end
	local fileHandle = fileCreate(file)
	fileWrite(fileHandle, toJSON(data))
	fileFlush(fileHandle)
	fileClose(fileHandle)
	return true
end
  
function cacheMarks()
	setElementData(localPlayer,"toggleadminchat",true)
	setElementData(localPlayer,"toggleaschat",true)
	local table = jsonGET("marks.json")
	records = table["Marks"]
	for k,v in pairs(records) do 
		local x,y,z,int,dim = unpack(v)
        mark[k] = {x,y,z,int,dim}
	end
end 
addEventHandler("onClientResourceStart",resourceRoot,cacheMarks)

function saveMarks()
	jsonSAVE("marks.json", {["Marks"] = mark})
end 
addEventHandler("onClientResourceStop",resourceRoot,saveMarks)

func.mark = function(cmd,name)
if getElementData(localPlayer,"player:admin") >= 1 and getElementData(localPlayer,"player:loggedIn") then 
	if not name then outputChatBox("#8163bf[Teleport]#ffffff /"..cmd.." [Név]",255,255,255,true) return end 
    if mark[name] then outputChatBox("#8163bf[Teleport]#ffffff Már van elmentve markod ilyen néven.",255,255,255,true) return end 

	local x,y,z = getElementPosition(localPlayer)
	local int = getElementInterior(localPlayer)
	local dim = getElementDimension(localPlayer)
	outputChatBox("#8163bf[Teleport]#ffffff Mark sikeresen elmentve #8163bf"..name.." #ffffffnéven.",255,255,255,true)
	mark[name] = {x,y,z,int,dim}
end
end 
addCommandHandler("mark",func.mark)

func.delmark = function(cmd,name)
if getElementData(localPlayer,"player:admin") >= 1 and getElementData(localPlayer,"player:loggedIn") then 
	if not name then outputChatBox("#8163bf[Teleport]#ffffff /"..cmd.." [Név]",255,255,255,true) return end 
    if not mark[name] then outputChatBox("#8163bf[Teleport]#ffffff Nincs ilyen nevű markod.",255,255,255,true) return end 
	mark[name] = nil
	outputChatBox("#8163bf[Teleport]#ffffff Sikeresen törölted a #8163bf"..name.." #ffffffnevű markot.",255,255,255,true)
end
end 
addCommandHandler("delmark",func.delmark)

function showminutes()
	local minute = getElementData(localPlayer,"jailtime")
	if not minute then return end
	if minute == 0 then return end
	dxDrawText("#ffffff A jailedből #8163bf"..minute.." #ffffffperc van hátra",posX+320,posY,0,0,tocolor(246,137,52,255),1,cache.OpenSansL,"left","top",false,false,false,true) -------NE RAKD BE MERT NINCS NORMÁLISAN BEPOZICIONÁLVA!!!!!!!!!!!!!!!!!!!!!!!!
end
addEventHandler("onClientRender",root,showminutes)

function bortonido()
	local minute = getElementData(localPlayer,"jailtime")
	if not minute then return end
	if minute == 0 then return end
	outputChatBox("#8163bf[xProject]#ffffff A Jailedből: #8163bf"..minute.." #ffffff perc van hátra.",255,255,255,true)
	--dxDrawText("#ffffff A jailedből #8163bf"..minute.." #ffffffperc van hátra",posX+320,posY,0,0,tocolor(246,137,52,255),1,cache.OpenSansL,"left","top",false,false,false,true) -------NE RAKD BE MERT NINCS NORMÁLISAN BEPOZICIONÁLVA!!!!!!!!!!!!!!!!!!!!!!!!
end
addCommandHandler("bortonido",bortonido)
addCommandHandler("bőrönidő",bortonido)

func.listmark = function(cmd)
if getElementData(localPlayer,"player:admin") >= 1 and getElementData(localPlayer,"player:loggedIn") then 
		outputChatBox("#8163bf[Teleport]#ffffff Elmentett markjaid:",255,255,255,true)
		--outputChatBox("#8163bf[Teleport]#ffffff Jelenleg nincsen lerakva sehova markod.",255,255,255,true)
		for k,v in pairs(mark) do 
			outputChatBox("-"..k.."",255,255,255,true)
		end 
end 
end 
addCommandHandler("listmark",func.listmark)

func.gotomark = function(cmd,name)
if getElementData(localPlayer,"player:admin") >= 1 and getElementData(localPlayer,"player:loggedIn") then 
	if not name then outputChatBox("#8163bf[Teleport]#ffffff /"..cmd.." [Név]",255,255,255,true) return end 
	if not mark[name] then outputChatBox("#8163bf[Teleport]#ffffff Nincs ilyen nevű markod.",255,255,255,true) return end 

	triggerServerEvent("gotoMark",localPlayer,localPlayer,mark[name][1],mark[name][2],mark[name][3],mark[name][4],mark[name][5],name)
end 
end 
addCommandHandler("gotomark",func.gotomark)

local show = false

func.adminPanel = function()
	show = not show
end
addCommandHandler("apanel",func.adminPanel)

func.render = function()
	if show then
		dxDrawRectangle(posX,posY,width,height,tocolor(22,22,22,255))
		dxDrawRectangle(posX,posY,width,32,tocolor(0,0,0,100))
		
		----apanel created by:Roli-----------
		
		dxDrawText("xProject#ffffff - Adminpanel",posX+320,posY,0,0,tocolor(246,137,52,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/asegit",posX+7,posY+40,0,0,tocolor(246,137,52,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Feltudod szedni az adott játékost.",posX+200,posY+40,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+40,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/goto",posX+7,posY+65,0,0,tocolor(246,137,52,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Eltudsz teleoportálni a játékoshoz.",posX+200,posY+65,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+65,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/spec",posX+7,posY+90,0,0,tocolor(246,137,52,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Megtudod figyelni a játékost.",posX+200,posY+90,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+90,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/stats",posX+7,posY+115,0,0,tocolor(246,137,52,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Játékos információi lekérése.",posX+200,posY+115,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+115,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/vá",posX+7,posY+140,0,0,tocolor(246,137,52,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Játékos PM-re válaszolás.",posX+200,posY+140,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+140,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/gethere",posX+7,posY+165,0,0,tocolor(246,137,52,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Játékos magadhoz teleportálása.",posX+200,posY+165,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+165,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/setskin",posX+7,posY+190,0,0,tocolor(246,137,52,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Skin beállítása.",posX+200,posY+190,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+190,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/kick",posX+7,posY+215,0,0,tocolor(246,137,52,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Játékos kirúgása a szerverről.",posX+200,posY+215,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+215,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/jail",posX+7,posY+240,0,0,tocolor(246,137,52,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Játékos börtönbe helyezése.",posX+200,posY+240,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+240,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/unjail",posX+7,posY+265,0,0,tocolor(246,137,52,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Játékos kivétele a börtönből.",posX+200,posY+265,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+265,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/sethp",posX+7,posY+290,0,0,tocolor(246,137,52,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Életerő adása.",posX+200,posY+290,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+290,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/setarmor",posX+7,posY+315,0,0,tocolor(246,137,52,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Páncél szint adása.",posX+200,posY+315,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+315,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/setthirsty",posX+7,posY+340,0,0,tocolor(246,137,52,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Ital szint adása.",posX+200,posY+340,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+340,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/sethunger",posX+7,posY+365,0,0,tocolor(246,137,52,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Étel szint adása.",posX+200,posY+365,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+365,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/vhspawn",posX+7,posY+390,0,0,tocolor(246,137,52,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Városházára spawnolja a játékost.",posX+200,posY+390,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+390,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/fix",posX+7,posY+415,0,0,tocolor(246,137,52,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Jármű megjavítása.",posX+200,posY+415,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+415,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/vanish",posX+7,posY+440,0,0,tocolor(246,137,52,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Láthatatlan leszel.",posX+200,posY+440,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+440,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/asay",posX+7,posY+465,0,0,tocolor(246,137,52,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Admin felhívás.",posX+200,posY+465,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+465,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/freeze",posX+7,posY+490,0,0,tocolor(246,137,52,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Játékos lefagyasztása.",posX+200,posY+490,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+490,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/unfreeze",posX+7,posY+515,0,0,tocolor(246,137,52,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Játékos kiolvasztása.",posX+200,posY+515,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+515,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/hospitalspawn",posX+7,posY+540,0,0,tocolor(246,137,52,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Kórházhoz spawnolás.",posX+200,posY+540,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+540,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/togachat",posX+7,posY+565,0,0,tocolor(246,137,52,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Adminchat kikapcsolása.",posX+200,posY+565,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+565,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
	end
end
addEventHandler("onClientRender",getRootElement(),func.render)



func.getCameraPosition = function()
	local x,y,z,lx,ly,lz = getCameraMatrix()
	outputChatBox(x..","..y..","..z..","..lx..","..ly..","..lz)
end
addCommandHandler("campos",func.getCameraPosition)

addEventHandler("onClientPlayerStealthKill", getLocalPlayer(),function(target)
	if getElementData(target,"player:adminduty") then
		cancelEvent()
	end
end)

addEventHandler ( "onClientPlayerDamage", getLocalPlayer(),function(attacker)
	if getElementData(source,"player:adminduty") then
		cancelEvent();
	end
end)

func.onChatMessage = function(text)
	if text == "ACL: Access denied for 'stop'" then
		cancelEvent();
	elseif text == "ACL: Access denied for 'start'" then
		cancelEvent();
	elseif text == "ACL: Access denied for 'restart'" then
		cancelEvent();
	elseif text == "ACL: Access denied for 'debugscript'" then
		cancelEvent();
	elseif text == "ACL: Access denied for 'refreshall'" then
		cancelEvent();
	elseif text == "ACL: Access denied for 'refresh'" then
		cancelEvent();
	elseif text == "login: You are already logged in" then
		outputChatBox("#8163bf[xProject - ACL]#ffffff Már be vagy bejelentkezve.",220,20,60,true);
		cancelEvent();
	elseif text == "logout: You logged out" then
		outputChatBox("#8163bf[xProject - ACL]#ffffff Sikeresen kijelentkeztél.",220,20,60,true);
		cancelEvent();
	elseif text == "login: You successfully logged in" then
		outputChatBox("#8163bf[xProject - ACL]#ffffff Sikeresen bejelentkeztél.",220,20,60,true);
		cancelEvent();
	elseif text == "debugscript: Your debug mode was set to 3" then
		outputChatBox("#8163bf[xProject - ACL]#ffffff Debugscript 3 bekapcsolva.",220,20,60,true);
		cancelEvent();
	elseif text == "debugscript: Your debug mode is already that" then
		outputChatBox("#8163bf[xProject - ACL]#ffffff Már be van kapcsolva az a debug tipus.",220,20,60,true);
		cancelEvent();
	elseif text == "debugscript: Your debug mode was set to 0" then
		outputChatBox("#8163bf[xProject - ACL]#ffffff Debugscript kikapcsolva.",220,20,60,true);
		cancelEvent();
	end
end
addEventHandler ( "onClientChatMessage", getRootElement(), func.onChatMessage)

local flyingState = false
local keys = {}
keys.up = "up"
keys.down = "up"
keys.f = "up"
keys.b = "up"
keys.l = "up"
keys.r = "up"
keys.a = "up"
keys.s = "up"
keys.m = "up"

addEvent("onClientFlyToggle",true)
addEventHandler("onClientFlyToggle", getLocalPlayer(), function()
	flyingState = not flyingState
	
	if flyingState then
		addEventHandler("onClientRender",getRootElement(),func.flyingRender)
		bindKey("lshift","both",func.keyH)
		bindKey("rshift","both",func.keyH)
		bindKey("lctrl","both",func.keyH)
		bindKey("rctrl","both",func.keyH)
		
		bindKey("forwards","both",func.keyH)
		bindKey("backwards","both",func.keyH)
		bindKey("left","both",func.keyH)
		bindKey("right","both",func.keyH)
		
		bindKey("lalt","both",func.keyH)
		bindKey("space","both",func.keyH)
		bindKey("ralt","both",func.keyH)
		bindKey("mouse1","both",func.keyH)
		setElementCollisionsEnabled(getLocalPlayer(),false)
	else
		removeEventHandler("onClientRender",getRootElement(),func.flyingRender)
		unbindKey("mouse1","both",func.keyH)
		unbindKey("lshift","both",func.keyH)
		unbindKey("rshift","both",func.keyH)
		unbindKey("lctrl","both",func.keyH)
		unbindKey("rctrl","both",func.keyH)
		
		unbindKey("forwards","both",func.keyH)
		unbindKey("backwards","both",func.keyH)
		unbindKey("left","both",func.keyH)
		unbindKey("right","both",func.keyH)
		
		unbindKey("space","both",func.keyH)
		
		keys.up = "up"
		keys.down = "up"
		keys.f = "up"
		keys.b = "up"
		keys.l = "up"
		keys.r = "up"
		keys.a = "up"
		keys.s = "up"
		setElementCollisionsEnabled(getLocalPlayer(),true)
	end
end)

func.flyingRender = function()
	local x,y,z = getElementPosition(getLocalPlayer())
	local speed = 10
	if keys.a=="down" then
		speed = 3
	elseif keys.s=="down" then
		speed = 50
	elseif keys.m=="down" then
		speed = 300
	end
	
	if keys.f=="down" then
		local a = func.rotFromCam(0)
		setElementRotation(getLocalPlayer(),0,0,a)
		local ox,oy = func.dirMove(a)
		x = x + ox * 0.1 * speed
		y = y + oy * 0.1 * speed
	elseif keys.b=="down" then
		local a = func.rotFromCam(180)
		setElementRotation(getLocalPlayer(),0,0,a)
		local ox,oy = func.dirMove(a)
		x = x + ox * 0.1 * speed
		y = y + oy * 0.1 * speed
	end
	
	if keys.l=="down" then
		local a = func.rotFromCam(-90)
		setElementRotation(getLocalPlayer(),0,0,a)
		local ox,oy = func.dirMove(a)
		x = x + ox * 0.1 * speed
		y = y + oy * 0.1 * speed
	elseif keys.r=="down" then
		local a = func.rotFromCam(90)
		setElementRotation(getLocalPlayer(),0,0,a)
		local ox,oy = func.dirMove(a)
		x = x + ox * 0.1 * speed
		y = y + oy * 0.1 * speed
	end
	
	if keys.up=="down" then
		z = z + 0.1*speed
	elseif keys.down=="down" then
		z = z - 0.1*speed
	end
	
	setElementPosition(getLocalPlayer(),x,y,z)
end

func.keyH = function(key,state)
	if key=="lshift" or key=="rshift" then
		keys.s = state
	end	
	if key=="lctrl" or key=="rctrl" then
		keys.down = state
	end	
	if key=="forwards" then
		keys.f = state
	end	
	if key=="backwards" then
		keys.b = state
	end	
	if key=="left" then
		keys.l = state
	end	
	if key=="right" then
		keys.r = state
	end	
	if key=="lalt" or key=="ralt" then
		keys.a = state
	end	
	if key=="space" then
		keys.up = state
	end	
	if key=="mouse1" then
		keys.m = state
	end	
end

func.rotFromCam = function(rzOffset)
	local cx,cy,_,fx,fy = getCameraMatrix(getLocalPlayer())
	local deltaY,deltaX = fy-cy,fx-cx
	local rotZ = math.deg(math.atan((deltaY)/(deltaX)))
	if deltaY >= 0 and deltaX <= 0 then
		rotZ = rotZ+180
	elseif deltaY <= 0 and deltaX <= 0 then
		rotZ = rotZ+180
	end
	return -rotZ+90 + rzOffset
end

func.dirMove = function(a)
	local x = math.sin(math.rad(a))
	local y = math.cos(math.rad(a))
	return x,y
end

addEventHandler('onClientPlayerQuit', root, function(reason)
	if getElementDimension(source) == getElementDimension(localPlayer) then
		local x,y,z = getElementPosition(source)
		local px,py,pz = getElementPosition(localPlayer)
		local dist = getDistanceBetweenPoints3D(x,y,z,px,py,pz)
		if dist < 100 then
			if reason == 'Quit' then
				reason = 'Kilépett'
			elseif reason == 'Kicked' then
				reason = 'Kirúgva egy adminisztrátor által'
			elseif reason == 'Banned' then
				reason = 'Kitiltva egy adminisztrátor által'
			elseif reason == 'Timedout' then
				reason = 'Időtúllépés'
			elseif reason == 'Unknown' then
				reason = 'Ismeretlen'
			end
			if getElementData(source,"player:charname") then
				outputChatBox('#8163bf[xProject] #8163bf'.. getElementData(source,"player:charname"):gsub('_', ' ') ..' #ffffffkilépett a közeledben! [Indok: #8163bf'.. reason ..' #ffffff| Távolság: #cd4946'.. math.floor(dist) ..' méter#ffffff]', 255, 255, 255, true)
			end
		end
	end
end)

addCommandHandler("stats",
function(cmd, target)
	if getElementData(localPlayer,"player:admin") >= 1 then
		if target then
			local targetPlayer = exports["Pcore"]:findPlayerByPartialNick(localPlayer,target)
			if targetPlayer then
				if getElementData(targetPlayer,"player:loggedIn") then
					outputChatBox("#8163bf[xProject] #ffffffKarakter név: #8163bf"..getElementData(targetPlayer,"player:charname"):gsub("_", " ").."", 255,255,255, true)
					outputChatBox("#8163bf[xProject] #ffffffÉhség: #ff9600"..getElementData(targetPlayer,"player:hunger").." #ffffff│ Szomjúság: #32b3ef"..getElementData(targetPlayer,"player:thirsty").."", 255,255,255, true)
					--outputChatBox("#8163bf[xProject] #ffffffMunka: #8163bf"..getElementData(targetPlayer,"player:job").."", localPlayer, 255,255,255, true)
					--outputChatBox("#8163bf[xProject] #ffffffJátszott perc: #8163bf"..getElementData(targetPlayer,"playedtime").."", 255,255,255, true)
					outputChatBox("#8163bf[xProject] #ffffffRuházat: #8163bf"..getElementData(targetPlayer,"player:skin").."", 255,255,255, true)
				--	outputChatBox("#8163bf[xProject] #ffffffMásodlagos nyelvtípus: #8163bf"..getElementData(targetPlayer,"player:language").."", 255,255,255, true)
					outputChatBox("#8163bf[xProject] #ffffffAccount ID: #8163bf"..getElementData(targetPlayer,"player:dbid").."", 255,255,255, true)
					outputChatBox("#8163bf[xProject] #ffffffKarakter ID: #8163bf"..getElementData(targetPlayer,"player:dbid").."", 255,255,255, true)
					outputChatBox("#8163bf[xProject] #ffffffAdminisztrátor név: #8163bf"..getElementData(targetPlayer,"player:adminname").."", 255,255,255, true)
					outputChatBox("#8163bf[xProject] #ffffffAdminisztrátor szint: #8163bf"..getElementData(targetPlayer,"player:admin").."", 255,255,255, true)
					outputChatBox("#8163bf[xProject] #ffffffAdminSegéd szint: #8163bf"..getElementData(targetPlayer,"player:helper").."", 255,255,255, true)
					outputChatBox("#8163bf[xProject] #ffffffSzint: #8163bf"..getElementData(targetPlayer,"player:level").."", 255,255,255, true)
					outputChatBox("#8163bf[xProject] #ffffffKészpénz: #8163bf"..getElementData(targetPlayer,"player:money").." $", 255,255,255, true)
					--outputChatBox("#8163bf[xProject] #ffffffBanki egyenleg: #8163bf"..getElementData(targetPlayer,"player:bankmoney").." $", localPlayer, 255,255,255, true)
					outputChatBox("#8163bf[xProject] #ffffffPrémium egyenleg: #8163bf"..getElementData(targetPlayer,"player:pp").." PP", 255,255,255, true)
					--outputChatBox("#8163bf[xProject] #ffffffSzervezet: #8163bf"..getElementData(targetPlayer,"groups:id").."", localPlayer, 255,255,255, true)
					outputAdminMessage(""..getElementData(localPlayer,"player:adminname").." #ffffffellenőrizte #8163bf" ..getElementData(targetPlayer,"player:charname"):gsub("_", " ").. " #ffffffadatait.")
				else
					outputChatBox("#8163bf[xProject] #ffffffNem található a megadott játékos.", localPlayer, 255,255,255, true)
				end
			end
		else
			outputChatBox("#8163bf[xProject] #ffffff/".. cmd .." [ID/Név]", 255,255,255, true)
		end
	end
end)

addCommandHandler("getobj", function(cmd, elore)
	if not elore then
		elore = false
	else
		elore = true
	end
	if (getElementData( localPlayer, "player:admin" )) >= 2 then
		local x,y,z = getElementPosition(localPlayer)
		local marker
		local targetX, targetY, targetZ = x,y,z-10
		if elore then
			marker = createMarker(x, y, z, "cylinder", 2, 255, 0, 0, 255)
			attachElements(marker, localPlayer, 0, 10, 0)
		end
		
		outputChatBox("Lekérdezés ...")
		setTimer(function()
			if elore then
				targetX, targetY, targetZ = getElementPosition(marker)
			end
			local hit,x,y,z,elementHit,nx,ny,nz,material,lighting,piece,buildingId,wX,wY,wZ,rX,rY,rZ,lodID = processLineOfSight(x,y,z,targetX, targetY, targetZ,true,true,true,true,true,true,false,true,localPlayer,true)
			if hit then
				if buildingId then
					outputChatBox(buildingId.." -> "..engineGetModelNameFromID(buildingId))
					
					if elementHit then
						outputChatBox("Radius: "..getElementRadius(elementHit))
						outputChatBox("LOD: "..tonumber(lodID or 0))
						local wX, wY, wZ = getElementPosition(elementHit)
						local rX, rY, rZ = getElementRotation(elementHit)
						outputChatBox("Position: "..wX..", "..wY..", "..wZ)
						outputChatBox("Rotation: "..rX..", "..rY..", "..rZ)
					else
						local tempObj = createObject(buildingId, wX, wY, wZ, rX, rY, rZ)
						outputChatBox("Radius: "..getElementRadius(tempObj))
						outputChatBox("LOD: "..tonumber(lodID or 0))
						outputChatBox("Position: "..wX..", "..wY..", "..wZ)
						outputChatBox("Rotation: "..rX..", "..rY..", "..rZ)
						destroyElement(tempObj)
					end
					
					if isElement(marker) then
						destroyElement(marker)
					end
				end
			else
				outputChatBox("Hiba")
			end
		end, 1000, 1)
	else
		outputChatBox("Hiba")
	end
end)

--adminpanel

local showAstats = false
local showedElement = nil
local screen = {guiGetScreenSize()}
local box = {500,400}
local pos = {screen[1]/2 -box[1]/2,screen[2]/2 -box[2]/2}
local font1small = dxCreateFont("files/sfpro.ttf",14)
local namefont = dxCreateFont("files/sfcDisplaybold.ttf",10)
local namefontASD = dxCreateFont("files/sfcDisplaybold.ttf",10)
local namefontKurva = dxCreateFont("files/sfcDisplaybold.ttf",13)
local logo = dxCreateTexture("files/logo.png")
function astats(cmd,target)
	if getElementData(localPlayer,"player:admin") >= 6 then
		if target then
			local targetPlayer = exports["Pcore"]:findPlayerByPartialNick(localPlayer,target)
			if targetPlayer then
			    if getElementData(localPlayer,"player:admin") >= getElementData(targetPlayer,"player:admin") then
				    if getElementData(targetPlayer,"player:loggedIn") then
					    showedElement = targetPlayer
				        showAstats = true
					end
				else
				    outputChatBox("#8163bf[xProject]: #ffffffNagyobb adminnak nem tudod lekérdezni a statjait.",255,255,255,true)
                end
			end
	    else
			outputChatBox("#8163bf[xProject] #ffffff/".. cmd .." [ID/Név]", 255,255,255, true)			
        end			
	end
end
addCommandHandler("getastats",astats)
addCommandHandler("astats",astats)
addCommandHandler("getadminstats",astats)

function drawAstats()
    if showAstats then
	    if showedElement then
		    dxDrawRectangle(pos[1]+25,pos[2]-5,box[1]-50,box[2]-125,tocolor(23,23,23,255)) -- Háttér
		    dxDrawImage(pos[1]+30,pos[2],40,40,"files/logo.png",0,0,0,tocolor(246,137,52,255)) -- Logo
			local showedElementName = getElementData(showedElement,"player:charname")
			
			local adutyTime = getElementData(showedElement,"admin:time")
			local recived = getElementData(showedElement,"admin:recived")
			local replyed = getElementData(showedElement,"admin:replyed")
			local bans = getElementData(showedElement,"admin:bans")
			local jails = getElementData(showedElement,"admin:jails")
			local fixes = getElementData(showedElement,"admin:fixs")
	        dxDrawText("Admin Stats: "..showedElementName.."", pos[1]+70,pos[2]+37,pos[1],pos[2],tocolor(246,137,52,255),1,namefont,"left","center")	
	        dxDrawText("Aduty time: "..adutyTime.." perc", pos[1]+35,pos[2]+37+(1*70),pos[1],pos[2],tocolor(246,137,52,255),1,namefont,"left","center")		
	        dxDrawText("Fogadott pm-ek: "..recived.." darab", pos[1]+35,pos[2]+37+(2*70),pos[1],pos[2],tocolor(246,137,52,255),1,namefont,"left","center")			
	        dxDrawText("Megválaszolt pm-ek: "..replyed.." darab", pos[1]+35,pos[2]+37+(3*70),pos[1],pos[2],tocolor(246,137,52,255),1,namefont,"left","center")			
	        dxDrawText("Fixek: "..fixes.." darab", pos[1]+35,pos[2]+37+(4*70),pos[1],pos[2],tocolor(246,137,52,255),1,namefont,"left","center")			
	        dxDrawText("Bannok: "..bans.." darab", pos[1]+35,pos[2]+37+(5*70),pos[1],pos[2],tocolor(246,137,52,255),1,namefont,"left","center")			
	        dxDrawText("Jailek: "..jails.." darab", pos[1]+35,pos[2]+37+(6*70),pos[1],pos[2],tocolor(246,137,52,255),1,namefont,"left","center")						
		end
	end
end
addEventHandler("onClientRender",root,drawAstats)

function szar()
    if show then
	    show = false
	elseif showAstats then
	    showAstats = false
		showedElement = nil
	end
end
bindKey("backspace","down",szar)
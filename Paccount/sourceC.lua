fileDelete ("sourceC.lua") 
local sx,sy = guiGetScreenSize()
setElementData(localPlayer,"player:loggedIn",false)
local func = {};
local cache = {};
local rot = 0;
local r,g,b = 74,101,168;
local sx,sy = guiGetScreenSize();
local width = 300
local height = 500
local posX,posY = sx/2 - width/2, sy/2 - height/2

cache.roboto = dxCreateFont("files/roboto.ttf",20)
cache.fontawsome = dxCreateFont("files/fontawsome.ttf",20)
cache.bold = dxCreateFont("files/bold.ttf",20)
cache.opensans = dxCreateFont("files/opensans.ttf",11);
cache.opensans2 = dxCreateFont("files/opensans.ttf",12);
cache.opensans3 = dxCreateFont("files/opensans.ttf",14);
cache.OpenSansB = dxCreateFont("files/OpenSansB.ttf",12);
cache.page = "";
cache.login = true;
cache.ped = nil;
cache.showpassword = false;
cache.savedata = false;


local screen = {guiGetScreenSize()}
local box = {500,400} 
local pos = {screen[1]/2 -box[1]/2,screen[2]/2 -box[2]/2}



cache.text = {
    login = {
        username = "";
        password = "";
    };
    register = {
        username = "";
        password = "";
        email = "";
    };
    charreg = {
        name = "";
        age = "";
        weight = "";
        height = "";
        descr = "";
    };
}
cache.usedtextbox = "";
cache.skins = {
    {1,"Férfi 1"},
    {2,"Férfi 2"},
    {18,"Férfi 3"},
    {23,"Férfi 4"},
    {35,"Férfi 5"},
    {39,"Nő 1"},
    {40,"Nő 2"},
};
cache.currentskin = 1;
cache.charlogin = {};
cache.charlogin.data = {};
alpha = 0;
cache.buttondown = false;

setTimer(function()
	if alpha == 255 then
		alpha = 0;
	elseif alpha == 0 then
		alpha = 255;
	end
end,800,0)

local camX,camY,camZ,camX2,camY2,camZ2 = 1234.9770507813,-1457.7902832031,110.32649993896,1234.5834960938,-1457.1604003906,109.65686798096
local lastCamTick = 0
local camDist = getDistanceBetweenPoints3D (camX,camY,camZ,camX2,camY2,camZ)
local currentCamAngle = 270

function getPointFromDistanceRotation(x, y, dist, angle)
    local a = math.rad(90 - angle);
    local dx = math.cos(a) * dist;
    local dy = math.sin(a) * dist;
    return x+dx, y+dy;
end

addEventHandler("onClientResourceStart",resourceRoot,function()
    if not getElementData(localPlayer,"player:loggedIn") then
        fadeCamera(true)
		setFarClipDistance(3000)
		triggerServerEvent("checkbanned",localPlayer,localPlayer)
        addEventHandler("onClientRender",getRootElement(),func.updateCamPosition)
        addEventHandler("onClientRender",getRootElement(),func.render);
        addEventHandler("onClientClick",getRootElement(),func.click);
        showChat(false)
        showCursor(true)
    end
end)

func.stop = function()
	if getElementData(localPlayer,"player:loggedIn") then
		triggerServerEvent("saveCharacter", localPlayer)
	end
end
addEventHandler("onClientResourceStop",resourceRoot,func.stop)

func.checkedPlayer = function(state,data)
	if state == "ban" then
		banshow= true;
		bandata = data;
	else
		cache.page = state;
	end
end
addEvent("checkedPlayer",true)
addEventHandler("checkedPlayer",getRootElement(),func.checkedPlayer)

function banned()
    if not getElementData(localPlayer,"player:loggedIn") then
            if banshow == true then
                dxDrawRectangle(pos[1]+25,pos[2]-50,box[1]-50,box[2]+100,tocolor(23,23,23,255))
                dxDrawText("Ki lettél tiltva a szerverről!", pos[1]+475,pos[2]-45,pos[1],pos[2],tocolor(246,137,52,255),1,cache.roboto,"center","center")
                dxDrawText(bandata.reason, pos[1]+475,pos[2]+175,pos[1],pos[2],tocolor(246,137,52,255),1,cache.roboto,"center","center")
                dxDrawText("Indok: ", pos[1]+235,pos[2]+175,pos[1],pos[2],tocolor(246,137,52,255),1,cache.roboto,"center","center")
                dxDrawText("Felhasználónév: ", pos[1]+265,pos[2]+75,pos[1],pos[2],tocolor(246,137,52,255),1,cache.roboto,"center","center")
                dxDrawText(bandata.username, pos[1]+585,pos[2]+75,pos[1],pos[2],tocolor(246,137,52,255),1,cache.roboto,"center","center")
                dxDrawText("Serial: ", pos[1]+225,pos[2]+275,pos[1],pos[2],tocolor(246,137,52,255),1,cache.roboto,"center","center")
                dxDrawText("Kitiltás időpontja: ", pos[1]+255,pos[2]+375,pos[1],pos[2],tocolor(246,137,52,255),0.5,cache.roboto,"center","center")
                dxDrawText(bandata.created, pos[1]+585,pos[2]+375,pos[1],pos[2],tocolor(246,137,52,255),0.5,cache.roboto,"center","center")
                dxDrawText(bandata.serial, pos[1]+585,pos[2]+275,pos[1],pos[2],tocolor(246,137,52,255),0.5,cache.roboto,"center","center")
                dxDrawText("Admin: ", pos[1]+265,pos[2]+475,pos[1],pos[2],tocolor(246,137,52,255),1,cache.roboto,"center","center")
                dxDrawText("Lejár(Kitiltástól számított óra múlva): ", pos[1]+345,pos[2]+575,pos[1],pos[2],tocolor(246,137,52,255),0.6,cache.roboto,"center","center")
                dxDrawText(bandata.defaulthours, pos[1]+685,pos[2]+575,pos[1],pos[2],tocolor(246,137,52,255),1,cache.roboto,"center","center")
                dxDrawText(bandata.admin, pos[1]+485,pos[2]+475,pos[1],pos[2],tocolor(246,137,52,255),1,cache.roboto,"center","center")
                
              
            end
        end
    end
    addEventHandler("onClientRender",root,banned)


func.updateCamPosition = function()
	local newCamTick = getTickCount ()
	local delay = newCamTick - lastCamTick
	lastCamTick = newCamTick
	local angleChange = delay/300
	currentCamAngle = currentCamAngle + angleChange
	local newX,newY = getPointFromDistanceRotation (camX,camY,camDist,currentCamAngle)
	setCameraMatrix (camX,camY,camZ,newX,newY,camZ2)
end

characterMainPosition = {1124.9599609375, 1105.240234375, 10.20704460144,307.34448242188}
offX = math.sin (math.rad(characterMainPosition[4]+150)) * 3.5
offY = math.cos (math.rad(characterMainPosition[4]+150)) * 3.5
camPosition2 = {1132.0815429688,1111.2977294922,13.235600471497,1131.3526611328,1110.6776123047,12.945497512817}
camPosition = {1128.2574462891,1132.8238525391,30.624599456787,1127.5740966797,1132.2457275391,30.178653717041}

func.onRegisterFinish = function(username,password)
	cache.page = "login";
    cache.text.login.username = cache.text.register.username;
	cache.text.login.password = cache.text.register.password;
    
	cache.text.register.username = "";
	cache.text.register.email = "";
	cache.text.register.password = "";
end
addEvent("onRegisterFinish",true)
addEventHandler("onRegisterFinish",getRootElement(),func.onRegisterFinish)

func.onRequestLogin = function(type,data)
	if type == "login" then
		cache.charlogin.data = data;
        cache.page = "";
        if ( getElementData(localPlayer,"player:dbid") == 30 ) then
            cache.veh = createVehicle(517,characterMainPosition[1]-3,characterMainPosition[2]-3,characterMainPosition[3],0,0,-70)
            --cache.obj = createObject(2780,characterMainPosition[1]-3,characterMainPosition[2]-8,characterMainPosition[3])
            cache.ped = createPed(7,characterMainPosition[1],characterMainPosition[2],characterMainPosition[3]);
            setElementRotation(cache.ped,0,0,characterMainPosition[4]);
            setElementFrozen(cache.ped,true);
            setPedAnimation(cache.ped,"COP_AMBIENT", "Coplook_loop", -1, true, false, false);
            setCameraMatrix (camPosition[1],camPosition[2],camPosition[3],camPosition[4],camPosition[5],camPosition[6])
            setTimer (moveCameraOnBeach,4000,1)
        else
            cache.ped = createPed(data["skin"],characterMainPosition[1],characterMainPosition[2],characterMainPosition[3]);
            setElementRotation(cache.ped,0,0,characterMainPosition[4]);
            setElementFrozen(cache.ped,true);
            setPedAnimation(cache.ped,"COP_AMBIENT", "Coplook_loop", -1, true, false, false);
            setCameraMatrix (camPosition[1],camPosition[2],camPosition[3],camPosition[4],camPosition[5],camPosition[6])
            setTimer (moveCameraOnBeach,4000,1)
        end
	elseif type == "create" then
		cache.page = "character";
        cache.ped = createPed(cache.skins[cache.currentskin][1],-426.54055786133,2505.4057617188,124.3046875);
        setCameraMatrix (-427.95001220703,2519.9519042969,127.55539703369,-427.85424804688,2519.0068359375,127.24275970459)
		setElementRotation(cache.ped,0,0,8.1252241134644);
		setElementFrozen(cache.ped,true);
	end
	removeEventHandler("onClientRender",getRootElement(),func.updateCamPosition)
end
addEvent("onClientRequestLogin",true)
addEventHandler("onClientRequestLogin",getRootElement(),func.onRequestLogin)

func.enterKey = function()
	if cache.page == "charLogin" then
		if not cache.buttondown then
			triggerServerEvent("loginSpawnPlayer",localPlayer,localPlayer,getElementData(localPlayer,"player:dbid"))
			fadeCamera(false,0,0,0)
			cache.buttondown = true
		end
	end
end
bindKey("enter","up",func.enterKey)

func.loginFinish = function()
    cache.page = "";
    cache.usedtextbox = "";
	fadeCamera(true);
	destroyElement(cache.ped);
	showChat(true);
	showCursor(false);
	setCameraTarget(localPlayer);
	setElementData(localPlayer,"player:loggedIn",true);
end
addEvent("loginFinish",true)
addEventHandler("loginFinish",getRootElement(),func.loginFinish)

local cameraMoveStartTick = nil
local cameraMoveDuration = 4000

function moveCameraOnBeach ()
	if camPosition2[1] then
		cameraMoveStartTick = getTickCount ()
		addEventHandler ("onClientRender",getRootElement(),moveCamera)
	end
end

function moveCamera ()
	local currentTick = getTickCount ()
	showChat(false)
	local elapsedTime = currentTick - cameraMoveStartTick
	local progress = elapsedTime / cameraMoveDuration
	local x,y,z = interpolateBetween ( 
		camPosition[1], camPosition[2], camPosition[3],
		camPosition2[1], camPosition2[2], camPosition2[3], 
		progress, "InOutQuad"
	)
	local lx,ly,lz = interpolateBetween ( 
		camPosition[4], camPosition[5], camPosition[6],
		camPosition2[4], camPosition2[5], camPosition2[6], 
		progress, "InOutQuad"
	)
	setCameraMatrix (x,y,z,lx,ly,lz)
	if progress > 1 then
		removeEventHandler ("onClientRender",getRootElement(),moveCamera)
		cache.page = "charLogin";
	end
end

func.createCharacter = function(data)
	cache.charlogin.data = data;
	cache.page = "charLogin";
	setElementPosition(cache.ped,characterMainPosition[1],characterMainPosition[2],characterMainPosition[3]);
    setElementRotation(cache.ped,0,0,characterMainPosition[4]);
    setCameraMatrix(camPosition2[1],camPosition2[2],camPosition2[3],camPosition2[4],camPosition2[5],camPosition2[6])
	setPedAnimation(cache.ped,"COP_AMBIENT", "Coplook_loop", -1, true, false, false);
end
addEvent("createCharacterToClient",true)
addEventHandler("createCharacterToClient",getRootElement(),func.createCharacter)

func.render = function()
    if cache.page == "login" then 
        rot = rot + 0.1
        dxDrawImage(sx*0.458 - 1,sy*0.2 + 1,sx*0.08,sy*0.16,"files/logo.png",0,0,0,tocolor(0,0,0,255))   ---ha azt akarod, hogy forogjon mind2nél az első 0-at a tocolor előt írd át rot ra.
        dxDrawImage(sx*0.458,sy*0.2,sx*0.08,sy*0.16,"files/logo.png",0,0,0,tocolor(255,255,255,255))

        if isInSlot(sx*0.444,sy*0.4,sx*0.11,sy*0.029) or cache.usedtextbox == "login:username" then 
            roundedRectangle(sx*0.444,sy*0.4,sx*0.11,sy*0.029,tocolor(30,30,30,200))
            roundedRectangle(sx*0.444,sy*0.4,sx*0.11,sy*0.029,tocolor(r,g,b,100))
        else
            roundedRectangle(sx*0.444,sy*0.4,sx*0.11,sy*0.029,tocolor(30,30,30,200))
        end
        dxDrawText(cache.text.login.username,sx*0.464,sy*0.402,_,_,tocolor(240,240,240,255),0.00035*sx,cache.roboto)

        if isInSlot(sx*0.444,sy*0.44,sx*0.11,sy*0.029) or cache.usedtextbox == "login:password" then 
            roundedRectangle(sx*0.444,sy*0.44,sx*0.11,sy*0.029,tocolor(30,30,30,200))
            roundedRectangle(sx*0.444,sy*0.44,sx*0.11,sy*0.029,tocolor(r,g,b,100))
        else 
            roundedRectangle(sx*0.444,sy*0.44,sx*0.11,sy*0.029,tocolor(30,30,30,200))
        end

        if cache.showpassword then
            dxDrawText(cache.text.login.password,sx*0.464,sy*0.443,_,_,tocolor(240,240,240,255),0.00035*sx,cache.roboto)
        else
            dxDrawText(toPassword(cache.text.login.password),sx*0.464,sy*0.443,_,_,tocolor(240,240,240,255),0.00035*sx,cache.roboto)
        end

        if isInSlot(sx*0.444,sy*0.53,sx*0.11,sy*0.029) then 
            roundedRectangle(sx*0.444,sy*0.53,sx*0.11,sy*0.029,tocolor(30,30,30,200))
            roundedRectangle(sx*0.444,sy*0.53,sx*0.11,sy*0.029,tocolor(r,g,b,100))
        else 
            roundedRectangle(sx*0.444,sy*0.53,sx*0.11,sy*0.029,tocolor(30,30,30,200))
        end

        dxDrawText("",sx*0.447 - 1,sy*0.403 + 1,_,_,tocolor(0,0,0,255),0.00036*sx,cache.fontawsome)
        dxDrawText("",sx*0.447,sy*0.403,_,_,tocolor(240,240,240,255),0.00036*sx,cache.fontawsome)

        dxDrawText("",sx*0.447 - 1,sy*0.443 + 1,_,_,tocolor(0,0,0,255),0.00036*sx,cache.fontawsome)
        dxDrawText("",sx*0.447,sy*0.443,_,_,tocolor(240,240,240,255),0.00036*sx,cache.fontawsome)

        if not cache.showpassword then 
            dxDrawText("Jelszó megjelenítése",sx*0.465 - 1,sy*0.48 + 1,_,_,tocolor(0,0,0,255),0.00027*sx,cache.roboto) 
            dxDrawText("Jelszó megjelenítése",sx*0.465,sy*0.48,_,_,tocolor(240,240,240,255),0.00027*sx,cache.roboto) 
        else                                                                                                                    -- sx*0.465,sy*0.48,sx*0.07,sy*0.02 showpassword poz az isInSlothoz
            dxDrawText("Jelszó megjelenítése",sx*0.465 - 1,sy*0.48 + 1,_,_,tocolor(0,0,0,255),0.00027*sx,cache.roboto) 
            dxDrawText("Jelszó megjelenítése",sx*0.465,sy*0.48,_,_,tocolor(r,g,b,255),0.00027*sx,cache.roboto) 
        end

        if not cache.savedata then 
            dxDrawText("Adatok megjegyzése",sx*0.4655 - 1,sy*0.505 + 1,_,_,tocolor(0,0,0,255),0.00027*sx,cache.roboto) 
            dxDrawText("Adatok megjegyzése",sx*0.4655,sy*0.505,_,_,tocolor(240,240,240,255),0.00027*sx,cache.roboto)
        else                                                                                                                    --  sx*0.465,sy*0.505,sx*0.07,sy*0.02 savedata poz az isInSlothoz
            dxDrawText("Adatok megjegyzése",sx*0.4655 - 1,sy*0.505 + 1,_,_,tocolor(0,0,0,255),0.00027*sx,cache.roboto) 
            dxDrawText("Adatok megjegyzése",sx*0.4655,sy*0.505,_,_,tocolor(r,g,b,255),0.00027*sx,cache.roboto)
        end
        dxDrawText("Bejelentkezés",sx*0.47 - 1,sy*0.533 + 1,_,_,tocolor(0,0,0,255),0.00035*sx,cache.roboto)
        dxDrawText("Bejelentkezés",sx*0.47,sy*0.533,_,_,tocolor(240,240,240,255),0.00035*sx,cache.roboto)

    elseif cache.page == "register" then 
        -- rot = rot + 0.1
        dxDrawImage(sx*0.458 - 1,sy*0.2 + 1,sx*0.08,sy*0.16,"files/logo.png",rot,0,0,tocolor(0,0,0,255))
        dxDrawImage(sx*0.458,sy*0.2,sx*0.08,sy*0.16,"files/logo.png",rot,0,0,tocolor(255,255,255,255))
       
        if isInSlot(sx*0.444,sy*0.4,sx*0.11,sy*0.029) or cache.usedtextbox == "reg:username" then --username
            roundedRectangle(sx*0.444,sy*0.4,sx*0.11,sy*0.029,tocolor(30,30,30,200))
            roundedRectangle(sx*0.444,sy*0.4,sx*0.11,sy*0.029,tocolor(r,g,b,100))
        else
            roundedRectangle(sx*0.444,sy*0.4,sx*0.11,sy*0.029,tocolor(30,30,30,200))
        end
        dxDrawText(cache.text.register.username,sx*0.464,sy*0.402,_,_,tocolor(240,240,240,255),0.00035*sx,cache.roboto)

        if isInSlot(sx*0.444,sy*0.44,sx*0.11,sy*0.029) or cache.usedtextbox == "reg:password" then --password
            roundedRectangle(sx*0.444,sy*0.44,sx*0.11,sy*0.029,tocolor(30,30,30,200))
            roundedRectangle(sx*0.444,sy*0.44,sx*0.11,sy*0.029,tocolor(r,g,b,100))
        else 
            roundedRectangle(sx*0.444,sy*0.44,sx*0.11,sy*0.029,tocolor(30,30,30,200))
        end
        dxDrawText(toPassword(cache.text.register.password),sx*0.464,sy*0.443,_,_,tocolor(240,240,240,255),0.00035*sx,cache.roboto)

        if isInSlot(sx*0.444,sy*0.48,sx*0.11,sy*0.029) or cache.usedtextbox == "reg:email" then --email
            roundedRectangle(sx*0.444,sy*0.48,sx*0.11,sy*0.029,tocolor(30,30,30,200))
            roundedRectangle(sx*0.444,sy*0.48,sx*0.11,sy*0.029,tocolor(r,g,b,100))
        else 
            roundedRectangle(sx*0.444,sy*0.48,sx*0.11,sy*0.029,tocolor(30,30,30,200))
        end
        --dxDrawText(cache.text.register.email,sx*0.464,sy*0.483,_,_,tocolor(240,240,240,255),0.00035*sx,cache.roboto)
        
        --EMAIL
        if utf8.len(cache.text.register.email) > 10 then 
            dxDrawText(utf8.sub(cache.text.register.email,utf8.len(cache.text.register.email)-10,utf8.len(cache.text.register.email)),sx*0.5 - 1 - dxGetTextWidth(utf8.sub(cache.text.register.email,utf8.len(cache.text.register.email)-10,utf8.len(cache.text.register.email)),0.00035*sx,cache.roboto)/2,sy*0.483 + 1,_,_,tocolor(0,0,0,255),0.00035*sx,cache.roboto)
            dxDrawText(utf8.sub(cache.text.register.email,utf8.len(cache.text.register.email)-10,utf8.len(cache.text.register.email)),sx*0.5 - dxGetTextWidth(utf8.sub(cache.text.register.email,utf8.len(cache.text.register.email)-10,utf8.len(cache.text.register.email)),0.00035*sx,cache.roboto)/2,sy*0.483,_,_,tocolor(255,255,255,255),0.00035*sx,cache.roboto)
        else 
            dxDrawText(cache.text.register.email,sx*0.5 - 1 - dxGetTextWidth(cache.text.register.email,0.00035*sx,cache.roboto)/2,sy*0.483 + 1,_,_,tocolor(0,0,0,255),0.00035*sx,cache.roboto)
            dxDrawText(cache.text.register.email,sx*0.5 - dxGetTextWidth(cache.text.register.email,0.00035*sx,cache.roboto)/2,sy*0.483,_,_,tocolor(255,255,255,255),0.00035*sx,cache.roboto)
        end

        if isInSlot(sx*0.444,sy*0.55,sx*0.11,sy*0.029) then --reg
            roundedRectangle(sx*0.444,sy*0.55,sx*0.11,sy*0.029,tocolor(30,30,30,200))
            roundedRectangle(sx*0.444,sy*0.55,sx*0.11,sy*0.029,tocolor(r,g,b,100))
        else 
            roundedRectangle(sx*0.444,sy*0.55,sx*0.11,sy*0.029,tocolor(30,30,30,200))
        end

        dxDrawText("",sx*0.447 - 1,sy*0.403 + 1,_,_,tocolor(0,0,0,255),0.00036*sx,cache.fontawsome)
        dxDrawText("",sx*0.447,sy*0.403,_,_,tocolor(240,240,240,255),0.00036*sx,cache.fontawsome)

        dxDrawText("",sx*0.447 - 1,sy*0.443 + 1,_,_,tocolor(0,0,0,255),0.00036*sx,cache.fontawsome)
        dxDrawText("",sx*0.447,sy*0.443,_,_,tocolor(240,240,240,255),0.00036*sx,cache.fontawsome)

        dxDrawText("",sx*0.447 - 1,sy*0.4835 + 1,_,_,tocolor(0,0,0,255),0.00036*sx,cache.fontawsome)
        dxDrawText("",sx*0.447,sy*0.4835,_,_,tocolor(240,240,240,255),0.00036*sx,cache.fontawsome)

        dxDrawText("Regisztráció",sx*0.4725 - 1,sy*0.552 + 1,_,_,tocolor(0,0,0,255),0.00035*sx,cache.roboto)
        dxDrawText("Regisztráció",sx*0.4725,sy*0.552,_,_,tocolor(240,240,240,255),0.00035*sx,cache.roboto)

    elseif cache.page == "character" then 

        dxDrawRectangle(sx*0.02,sy*0.3,sx*0.16,sy*0.4,tocolor(30,30,30,150))

        if isInSlot(sx*0.025,sy*0.305,sx*0.15,sy*0.029) or cache.usedtextbox == "charreg:name" then 
            dxDrawRectangle(sx*0.025,sy*0.305,sx*0.15,sy*0.029,tocolor(20,20,20,200))
            dxDrawRectangle(sx*0.025,sy*0.305,sx*0.15,sy*0.029,tocolor(r,g,b,100))
        else 
            dxDrawRectangle(sx*0.025,sy*0.305,sx*0.15,sy*0.029,tocolor(20,20,20,200))
        end
        dxDrawText(cache.text.charreg.name,sx*0.045,sy*0.308,_,_,tocolor(240,240,240,255),0.00035*sx,cache.roboto)

        dxDrawText("",sx*0.027 - 1,sy*0.309 + 1,_,_,tocolor(0,0,0,255),0.00036*sx,cache.fontawsome)
        dxDrawText("",sx*0.027,sy*0.309,_,_,tocolor(240,240,240,255),0.00036*sx,cache.fontawsome)

        if isInSlot(sx*0.025,sy*0.34,sx*0.15,sy*0.029) or cache.usedtextbox == "charreg:age" then 
            dxDrawRectangle(sx*0.025,sy*0.34,sx*0.15,sy*0.029,tocolor(20,20,20,200))
            dxDrawRectangle(sx*0.025,sy*0.34,sx*0.15,sy*0.029,tocolor(r,g,b,100))
        else 
            dxDrawRectangle(sx*0.025,sy*0.34,sx*0.15,sy*0.029,tocolor(20,20,20,200))
        end 
        dxDrawText(cache.text.charreg.age,sx*0.045,sy*0.343,_,_,tocolor(240,240,240,255),0.00035*sx,cache.roboto)
        dxDrawText("év",sx*0.16,sy*0.343,_,_,tocolor(240,240,240,255),0.00035*sx,cache.roboto)
--0.045
        dxDrawText("",sx*0.027 - 1,sy*0.343 + 1,_,_,tocolor(0,0,0,255),0.00036*sx,cache.fontawsome)
        dxDrawText("",sx*0.027,sy*0.343,_,_,tocolor(240,240,240,255),0.00036*sx,cache.fontawsome)
        
        if isInSlot(sx*0.025,sy*0.375,sx*0.15,sy*0.029) or cache.usedtextbox == "charreg:weight" then 
            dxDrawRectangle(sx*0.025,sy*0.375,sx*0.15,sy*0.029,tocolor(20,20,20,200))
            dxDrawRectangle(sx*0.025,sy*0.375,sx*0.15,sy*0.029,tocolor(r,g,b,100))
        else 
            dxDrawRectangle(sx*0.025,sy*0.375,sx*0.15,sy*0.029,tocolor(20,20,20,200))
        end
        dxDrawText(cache.text.charreg.weight,sx*0.045,sy*0.378,_,_,tocolor(240,240,240,255),0.00035*sx,cache.roboto)
        dxDrawText("kg",sx*0.16,sy*0.378,_,_,tocolor(240,240,240,255),0.00035*sx,cache.roboto)

        dxDrawText("",sx*0.027 - 1,sy*0.377 + 1,_,_,tocolor(0,0,0,255),0.00036*sx,cache.fontawsome)
        dxDrawText("",sx*0.027,sy*0.377,_,_,tocolor(240,240,240,255),0.00036*sx,cache.fontawsome)

        if isInSlot(sx*0.025,sy*0.41,sx*0.15,sy*0.029) or cache.usedtextbox == "charreg:height" then 
            dxDrawRectangle(sx*0.025,sy*0.41,sx*0.15,sy*0.029,tocolor(20,20,20,200))    
            dxDrawRectangle(sx*0.025,sy*0.41,sx*0.15,sy*0.029,tocolor(r,g,b,100))
        else 
            dxDrawRectangle(sx*0.025,sy*0.41,sx*0.15,sy*0.029,tocolor(20,20,20,200))
        end
        dxDrawText(cache.text.charreg.height,sx*0.045,sy*0.413,_,_,tocolor(240,240,240,255),0.00035*sx,cache.roboto)
        dxDrawText("cm",sx*0.158,sy*0.413,_,_,tocolor(240,240,240,255),0.00035*sx,cache.roboto)
        if isInSlot(sx*0.046,sy*0.463,40,40) then
            dxDrawImage(sx*0.046,sy*0.463,40,40,"files/left.png",0,0,0,tocolor(r,g,b))
        else
            dxDrawImage(sx*0.046,sy*0.463,40,40,"files/left.png")
        end

        if isInSlot(sx*0.134,sy*0.463,40,40) then
            dxDrawImage(sx*0.134,sy*0.463,40,40,"files/right.png",0,0,0,tocolor(r,g,b))
        else
            dxDrawImage(sx*0.134,sy*0.463,40,40,"files/right.png")
        end

        dxDrawText("",sx*0.026 - 1,sy*0.414 + 1,_,_,tocolor(0,0,0,255),0.00036*sx,cache.fontawsome)
        dxDrawText("",sx*0.026,sy*0.414,_,_,tocolor(240,240,240,255),0.00036*sx,cache.fontawsome)
        
        if isInSlot(sx*0.025,sy*0.53,sx*0.15,sy*0.12) or cache.usedtextbox == "charreg:descr" then 
            dxDrawRectangle(sx*0.025,sy*0.53,sx*0.15,sy*0.12,tocolor(20,20,20,200))
            dxDrawRectangle(sx*0.025,sy*0.53,sx*0.15,sy*0.12,tocolor(r,g,b,100))
        else 
            dxDrawRectangle(sx*0.025,sy*0.53,sx*0.15,sy*0.12,tocolor(20,20,20,200))
        end
        dxDrawText(cache.text.charreg.descr,sx*0.045,sy*0.533,_,_,tocolor(240,240,240,255),0.00035*sx,cache.roboto)
        
        dxDrawText("",sx*0.028,sy*0.535,_,_,tocolor(240,240,240,255),0.00036*sx,cache.fontawsome)

        if isInSlot(sx*0.025,sy*0.66,sx*0.15,sy*0.029) then 
            dxDrawRectangle(sx*0.025,sy*0.66,sx*0.15,sy*0.029,tocolor(20,20,20,200))
            dxDrawRectangle(sx*0.025,sy*0.66,sx*0.15,sy*0.029,tocolor(r,g,b,100))
        else 
            dxDrawRectangle(sx*0.025,sy*0.66,sx*0.15,sy*0.029,tocolor(20,20,20,200))
        end

        dxDrawText("Karakter Létrehozása",sx*0.053 - 1,sy*0.663 + 1,_,_,tocolor(0,0,0,255),0.00035*sx,cache.roboto)
        dxDrawText("Karakter Létrehozása",sx*0.053,sy*0.663,_,_,tocolor(240,240,240,255),0.00035*sx,cache.roboto)
    elseif cache.page == "charLogin" then
        local left,top = sx/2 -286/2,sy-80
        roundedRectangle(left,top,286,46,tocolor(35, 35, 35,255))
        dxDrawText(cache.charlogin.data["charname"]:gsub("_"," "),left+144,top+14,left+144,top+14,tocolor(255,255,255,255),1,cache.OpenSansB,"center","center")
        dxDrawText("Nyomj #8163bf'ENTER'#ffffff-t a belépéshez!",left+142,top+30,left+142,top+30,tocolor(255,255,255,255),1,cache.opensans,"center","center",false,false,false,true)
       -- dxDrawImage(left+272,top+4,14,14,"files/info.png")
    end
end

func.click = function(button,state)
    if button == "left" and state == "up" then
        if cache.page == "register" then
            if isInSlot(sx*0.444,sy*0.4,sx*0.11,sy*0.029) then --username
                cache.usedtextbox = "reg:username";
            elseif isInSlot(sx*0.444,sy*0.44,sx*0.11,sy*0.029) then --password
                cache.usedtextbox = "reg:password";
            elseif isInSlot(sx*0.444,sy*0.48,sx*0.11,sy*0.029) then --email
                cache.usedtextbox = "reg:email";
            else
                cache.usedtextbox = "";
            end 
    
            if isInSlot(sx*0.444,sy*0.55,sx*0.11,sy*0.029) then --reg
                local usernameText = cache.text.register.username;
				local passwordText = cache.text.register.password;
				local emailText = cache.text.register.email;
				if string.len(usernameText) >= 5 and string.len(usernameText) <= 18 then
					if string.len(passwordText) >= 6 and string.len(passwordText) <= 32 then
						if usernameText ~= passwordText then
							if emailText and (emailText):match("[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?") then
								triggerServerEvent("createAccountToServer",localPlayer,localPlayer,usernameText,passwordText,emailText);
							else	
								exports["Pinfobox"]:addNotification("Hibás e-mail cím.","error");
							end
						else
							exports["Pinfobox"]:addNotification("A felhasználóneved nem lehet azonos a jelszavaddal.","error");
						end
					else
						exports["Pinfobox"]:addNotification("A jelszónak minimum 6, maximum 17 karakterből kell állnia.","error");
					end
				else
					exports["Pinfobox"]:addNotification("A felhasználónevednek minimum 5, maximum 17 karakterből kell állnia.","error");
				end
            end
        elseif cache.page == "login" then
            if isInSlot(sx*0.444,sy*0.4,sx*0.11,sy*0.029) then 
                cache.usedtextbox = "login:username";
            elseif isInSlot(sx*0.444,sy*0.44,sx*0.11,sy*0.029) then 
                cache.usedtextbox = "login:password";
            else
                cache.usedtextbox = "";
            end

            if isInSlot(sx*0.465,sy*0.48,sx*0.07,sy*0.02) then
                cache.showpassword = not cache.showpassword;
            end
            if isInSlot(sx*0.465,sy*0.505,sx*0.07,sy*0.02) then
                cache.savedata = not cache.savedata;
            end

            if isInSlot(sx*0.444,sy*0.53,sx*0.11,sy*0.029) then 
                local usernameText = cache.text.login.username;
				local passwordText = cache.text.login.password;
				if string.len(usernameText) >= 5 and string.len(usernameText) <= 18 then
					if string.len(passwordText) >= 6 and string.len(passwordText) <= 32 then
						triggerServerEvent("loginRequest",localPlayer,localPlayer,usernameText,passwordText);
					else
						exports["Pinfobox"]:addNotification("A jelszónak minimum 6, maximum 32 karakterből kell állnia.","error");
					end
				else
					exports["Pinfobox"]:addNotification("A felhasználónevednek minimum 5, maximum 18 karakterből kell állnia.","error");
				end
            end
        elseif cache.page == "character" then
            if isInSlot(sx*0.025,sy*0.305,sx*0.15,sy*0.029) then 
                cache.usedtextbox = "charreg:name";
            elseif isInSlot(sx*0.025,sy*0.34,sx*0.15,sy*0.029) then 
                cache.usedtextbox = "charreg:age";
            elseif isInSlot(sx*0.025,sy*0.375,sx*0.15,sy*0.029) then 
                cache.usedtextbox = "charreg:weight";
            elseif isInSlot(sx*0.025,sy*0.41,sx*0.15,sy*0.029) then 
                cache.usedtextbox = "charreg:height";
            elseif isInSlot(sx*0.025,sy*0.53,sx*0.15,sy*0.12) then 
                cache.usedtextbox = "charreg:descr";
            else 
                cache.usedtextbox = "";
            end
    
            if isInSlot(sx*0.046,sy*0.463,40,40) then -- left
                if cache.currentskin - 1 >= 1 then
                    cache.currentskin = cache.currentskin - 1
                    setElementModel(cache.ped,cache.skins[cache.currentskin][1])
                end
            end
    
            if isInSlot(sx*0.134,sy*0.463,40,40) then -- right
                if cache.currentskin + 1 <= #cache.skins then
                    cache.currentskin = cache.currentskin + 1
                    setElementModel(cache.ped, cache.skins[cache.currentskin][1])
                end
            end

            if isInSlot(sx*0.025,sy*0.66,sx*0.15,sy*0.029) then --charcreate

                local charname = cache.text.charreg.name;
				local age = cache.text.charreg.age;
				local weight = cache.text.charreg.weight;
                local height = cache.text.charreg.height;
                local descr = cache.text.charreg.descr;
						
				--if string.find(charname, "_", 0) then
					if tonumber(age) >= 18 and tonumber(age) <= 60 then
						if tonumber(weight) >= 60 and tonumber(weight) <= 160 then
                            if tonumber(height) >= 150 and tonumber(height) <= 220 then
                                if #descr > 10 then
								    triggerServerEvent("createCharacter",localPlayer,localPlayer,tostring(charname),tonumber(age),tonumber(weight),tonumber(height),cache.skins[cache.currentskin][1],tostring(descr),getElementData(localPlayer,"player:dbid"))
                                    exports["Pinfobox"]:addNotification("Sikeresen elkészítetted a karaktered.","success")
                                else
                                    exports["Pinfobox"]:addNotification("Karaktered leírásának minimum 10 szóból kell állnia.","error");
                                end
							else
								exports["Pinfobox"]:addNotification("Karaktered magassága, minimum 150, de legfeljebb 220 cm lehet.","error");
							end
						else
							exports["Pinfobox"]:addNotification("Karaktered testsúlya, minimum 60, de legfeljebb 160 kg lehet.","error");
						end
					else
						exports["Pinfobox"]:addNotification("Karaktered életkora, minimum 18, de legfeljebb 90 éves lehet.","error");
					end
				--else
				--	exports["Pinfobox"]:addNotification("Karaktered neve érvénytelen. (Próbáld meg a vezeték és keresztnév közötti _ vonallal.)","error");
				--end
            end
        end
    end
end

func.onClientCharacter = function(character)
    if cache.usedtextbox == "reg:username" then
        if #cache.text.register.username < 17 then
            cache.text.register.username = cache.text.register.username..character;
        end
    elseif cache.usedtextbox == "reg:password" then
        if #cache.text.register.password < 17 then 
            cache.text.register.password = cache.text.register.password..character;
        end
    elseif cache.usedtextbox == "reg:email" then
        cache.text.register.email = cache.text.register.email..character;
    elseif cache.usedtextbox == "login:username" then
        cache.text.login.username = cache.text.login.username..character;
    elseif cache.usedtextbox == "login:password" then
        cache.text.login.password = cache.text.login.password..character;
    elseif cache.usedtextbox == "charreg:name" then
        if #cache.text.charreg.name < 25 then 
        cache.text.charreg.name = cache.text.charreg.name..character;
        end
    elseif cache.usedtextbox == "charreg:age" then
        if #cache.text.charreg.age < 3 then 
        cache.text.charreg.age = cache.text.charreg.age..character;
        end
    elseif cache.usedtextbox == "charreg:weight" then
        if #cache.text.charreg.weight < 3 then
        cache.text.charreg.weight = cache.text.charreg.weight..character;
        end
    elseif cache.usedtextbox == "charreg:height" then
        if #cache.text.charreg.height < 3 then 
        cache.text.charreg.height = cache.text.charreg.height..character;
        end
    elseif cache.usedtextbox == "charreg:descr" then
        if #cache.text.charreg.descr < 25 then 
        cache.text.charreg.descr = cache.text.charreg.descr..character;
        end
    end
	--text = text..character;
end
addEventHandler("onClientCharacter", getRootElement(), func.onClientCharacter)

func.onClientKey = function(button,state)
    if button == "backspace" and state then
        if cache.usedtextbox == "reg:username" then
            cache.text.register.username = utf8.sub(cache.text.register.username, 0, utf8.len(cache.text.register.username)-1)
        elseif cache.usedtextbox == "reg:password" then
            cache.text.register.password = utf8.sub(cache.text.register.password, 0, utf8.len(cache.text.register.password)-1)
        elseif cache.usedtextbox == "reg:email" then
            cache.text.register.email = utf8.sub(cache.text.register.email, 0, utf8.len(cache.text.register.email)-1)
        elseif cache.usedtextbox == "login:username" then
            cache.text.login.username = utf8.sub(cache.text.login.username, 0, utf8.len(cache.text.login.username)-1)
        elseif cache.usedtextbox == "login:password" then
            cache.text.login.password = utf8.sub(cache.text.login.password, 0, utf8.len(cache.text.login.password)-1)
        elseif cache.usedtextbox == "charreg:name" then
            cache.text.charreg.name = utf8.sub(cache.text.charreg.name, 0, utf8.len(cache.text.charreg.name)-1)
        elseif cache.usedtextbox == "charreg:age" then
            cache.text.charreg.age = utf8.sub(cache.text.charreg.age, 0, utf8.len(cache.text.charreg.age)-1)
        elseif cache.usedtextbox == "charreg:weight" then
            cache.text.charreg.weight = utf8.sub(cache.text.charreg.weight, 0, utf8.len(cache.text.charreg.weight)-1)
        elseif cache.usedtextbox == "charreg:height" then
            cache.text.charreg.height = utf8.sub(cache.text.charreg.height, 0, utf8.len(cache.text.charreg.height)-1)
        elseif cache.usedtextbox == "charreg:descr" then
            cache.text.charreg.descr = utf8.sub(cache.text.charreg.descr, 0, utf8.len(cache.text.charreg.descr)-1)
        end
    end
end
addEventHandler("onClientKey", getRootElement(), func.onClientKey)

function toPassword(password)
    local length = utfLen(password)
    return string.rep("*", length)
end

if not xmlLoadFile("save.xml") then
	local file = xmlCreateFile("save.xml", "root")
	local main = xmlCreateChild(file, "data")
    xmlNodeSetValue(xmlCreateChild(main, "save"), tostring(cache.savedata));
    xmlNodeSetValue(xmlCreateChild(main, "username"), tostring(cache.text.login.username));
	xmlNodeSetValue(xmlCreateChild(main, "password"), tostring(cache.text.login.password));
	xmlSaveFile(file);
    --outputChatBox(".")
    outputDebugString("XML Fájl sikeresen elmentve!")
else
	local file = xmlLoadFile("save.xml")
    local mainC2 = xmlFindChild(file, "data", 0)
    if xmlNodeGetValue(xmlFindChild(mainC2, "save", 0)) == "true" then
        cache.savedata = true;
    else
        cache.savedata = false;
    end
    if cache.savedata then
    	cache.text.login.username = tostring(xmlNodeGetValue(xmlFindChild(mainC2, "username", 0)))
	    cache.text.login.password = tostring(xmlNodeGetValue(xmlFindChild(mainC2, "password", 0)))
    end
end

function savePos()
	local file = xmlLoadFile("save.xml")
	if file then
		local mainC2 = xmlFindChild(file, "data", 0)
        xmlNodeSetValue(xmlFindChild(mainC2, "save", 0), tostring(cache.savedata));
        xmlNodeSetValue(xmlFindChild(mainC2, "username", 0), tostring(cache.text.login.username));
		xmlNodeSetValue(xmlFindChild(mainC2, "password", 0), tostring(cache.text.login.password));
		xmlSaveFile(file)
	end
end
addEventHandler("onClientResourceStop", getResourceRootElement(getThisResource()), savePos)
addEventHandler("onClientPlayerQuit", getRootElement(), savePos)

setTimer(function()
    if getElementData(localPlayer,"player:loggedIn") then 
        if not getElementData(localPlayer,"player:afk") then 
            setElementData(localPlayer,"player:minutes",getElementData(localPlayer,"player:minutes") + 1)
        end
    end 
end,60000,0)
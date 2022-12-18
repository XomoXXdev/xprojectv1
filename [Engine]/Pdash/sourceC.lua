local sx,sy = guiGetScreenSize()
local sx = sx+100
local sy = sy+100
local show = false
local func = {};
local clickTick = 0
local screenSource = dxCreateScreenSource(sx,sy)
local vehicleTuningDatas = {{"engine", "Motor"}, {"turbo", "Turbó"}, {"ecu", "ecu"}, {"weightreduction", "Súlycsökk."}, {"tires", "Gumi"}, {"brakes", "Fék"}}
local screen = {guiGetScreenSize()}
local box = {500,400}
local pos = {screen[1]/2 -box[1]/2,screen[2]/2 -box[2]/2}
local vehicleTunings = {"#8163bfalap", "#8163bfutcai", "#8163bfprofi", "#8163bfverseny", "#8163bfprémium" , "#8163bfprémium"}
local intensity = 0.50
local intensityLines = 0.1
local screenSize = {guiGetScreenSize()}
local screenSize = {guiGetScreenSize()}
screenSize.x, screenSize.y = screenSize[1], screenSize[2]
local width, height = 800, 450
local startX, startY = (screenSize.x - width) / 2, (screenSize.y - height) / 2
local groupItems = {};
local playerCache = {};
local groupCache = {};
local memberCache = {};
local vehicleCache = {};
local groupVehicles = {};
local transactionCache = {};
local spacer = 2
local spacerBig = 5
selectedveh = {}
maxVehicleRows = 9
sfpro2 = dxCreateFont("files/sfpro.ttf",8);
local cache = {
    
    blur = nil;
    crosshair = 0;

    setting = {
        ["bloom"] = {false},
        ["vignette"] = {false},
        ["motionblur"] = {false},
        ["vehicleshader"] = {false},
        ["betterwater"] = {false},
        ["noise"] = {false},
        ["bettertexture"] = {false},
    };

    serverAdmins = {};
    playerVehicles = {};
    playerInteriors = {};
    roboto = dxCreateFont("files/fontawsome.ttf",22);
    fontawsome = dxCreateFont("files/fontawsome.ttf",22);
    fonticonasd = dxCreateFont("files/fontelloasd.ttf",22);
    sfpro = dxCreateFont("files/sfpro.ttf",22);
    
    page = "mydatas";
    logo = dxCreateTexture("files/logo.png");

    mydatas = dxCreateTexture("files/mydatas.png");
    groups = dxCreateTexture("files/groups.png");
    own = dxCreateTexture("files/own.png");
    settings = dxCreateTexture("files/settings.png");
    admins = dxCreateTexture("files/admins.png");

    typename = {
        ["ambulance"] = "Egészségügy";
        ["law"] = "Rendvédelem";
        ["maffia"] = "Maffia";
        ["gang"] = "Banda";
        ["mechanic"] = "Szerelő";
        ["other"] = "Egyéb";
    };
    grouppages = {"Tagok","Rangok","Járművek","Beállítások"};
    selectedgroup = 0;
    grouppage = 1;
    group = {
        gui = nil;
        newitemgui = nil;
        permedit = false;
        guiwage = nil;
        newTag = false;
        tagtext = "";
        tagwheel = 0;
        itemWheel = 0;
        vehwheel = 0;
        selectedveh = -1;
        transactionwheel = 0;
        skinwheel = 0;
        selected = {
            member = 0;
        };
        numberChange = false;
        numberText = "";
        buttons = {"Előléptetés","Lefokozás","Tag eltávolítása","Tag felvétele","Számlaszám\nbeállítása"};
        settingbuttons = {"Pénzügyek","Duty skin beállítása","Tárgyak beállítása"};
        moneybuttons = {"Összeg berakása","Összeg kivétele"};
        selectedskin = 0;
        bankgui = nil;
        selectedsetting = 0;
        selectedsettingrank = 1;
        editrank = -1;
        editwage = -1;
        edititem = -1;
        edit = {
            items = false;
            newitem = false;
            moneygui = false;
        };
    };
};
local vehicleBlips = {};
local vehicleMarkers = {};
--[[blip = createBlip(1203.525390625, -1360.4541015625, 13.366048812866,15)
setElementData(blip, "blipIcon", 15)
setElementData(blip, "blipName", "Kijelölt jármű")
setElementData(blip, "exclusiveBlip",true)]]
vehshow = false
local ped = nil;
local prevElement = nil;

function start()
    setBlurLevel (0)
    local col = createColCuboid(2243, -1672.5, 14.6,4.2, 2.6, 2.0)

    cache.group.gui = guiCreateEdit(-1000,-1000,0,0,"",false)
    guiEditSetMaxLength(cache.group.gui,18)

    cache.group.newitemgui = guiCreateEdit(-1000,-1000,0,0,"",false)
    guiEditSetMaxLength(cache.group.newitemgui,3)

    cache.group.bankgui = guiCreateEdit(-1000,-1000,0,0,"0",false)
    guiEditSetMaxLength(cache.group.bankgui,6)
    
    addEventHandler("onClientGUIChanged", cache.group.gui, function(element)
        if (element == cache.group.gui and cache.group.editwage > 0) then
            editText = guiGetText(cache.group.gui);
            editText = editText:gsub("[^0-9]", "");
            
            guiSetText(cache.group.gui,editText);
        end
    end, true);

    addEventHandler("onClientGUIChanged", cache.group.newitemgui, function(element)
        if (element == cache.group.newitemgui) then
            editText = guiGetText(cache.group.newitemgui);
            editText = editText:gsub("[^0-9]", "");
            
            guiSetText(cache.group.newitemgui,editText);
        end
    end, true);

    addEventHandler("onClientGUIChanged", cache.group.bankgui, function(element)
        if (element == cache.group.bankgui) then
            editText = guiGetText(cache.group.bankgui);
            editText = editText:gsub("[^0-9]", "");
            
            guiSetText(cache.group.bankgui,editText);
        end
    end, true);

    for k,player in ipairs(getElementsByType("player")) do
        if getElementData(player,"player:loggedIn") then
            playerCache[player] = true;
        end
    end

    for k,vehicle in ipairs(getElementsByType("vehicle")) do
        if getElementData(vehicle,"vehicle:group") and getElementData(vehicle,"vehicle:group") > 0 then
            if not vehicleCache[vehicle] then
                vehicleCache[vehicle] = true;
            end
        end
    end

    if getElementData(localPlayer,"player:loggedIn") then
        triggerServerEvent("loadPlayerGroups",localPlayer,localPlayer,false,true)
    end

    if cache.page == "own" then 
        cache.ownvehwheel = 0
        cache.intwheel = 0
    elseif cache.page == "admins" then 
        cache.adminwheel = 0 
    end 

end
addEventHandler("onClientResourceStart",resourceRoot,start)

func.colShapeHit = function(theElement,matchingDimension)
    if theElement == localPlayer then
        if not cache.group.colHit then
			cache.group.colHit = true;
		end
    end
end
addEventHandler("onClientColShapeHit", getRootElement(),func.colShapeHit)

func.colShapeLeave = function(theElement,matchingDimension)
    if theElement == localPlayer then
         if cache.group.colHit then
			cache.group.colHit = false;
		end
    end
end
addEventHandler("onClientColShapeLeave", root, func.colShapeLeave)

addCommandHandler("load",function()
    triggerServerEvent("loadPlayerGroups",localPlayer,localPlayer,false,true)
end)

func.markerHit = function(thePlayer,matchingDimension)
	if thePlayer == localPlayer then
		if getElementDimension(source) == getElementDimension(thePlayer) then
            if getElementData(source,"vehicleElement") then
                local vehicle = getElementData(source,"vehicleElement");
                local dbid = getElementData(vehicle,"vehicle:dbid");
                detachElements (vehicleBlips[dbid],vehicle)
                detachElements (vehicleMarkers[dbid],vehicle)
                destroyElement(vehicleBlips[dbid])
                destroyElement(vehicleMarkers[dbid])
                vehicleBlips[dbid] = nil;
                vehicleMarkers[dbid] = nil;
                exports.Pinfobox:addNotification("Megérkeztél a járműhöz.","success")
            end
		end
	end
end
addEventHandler("onClientMarkerHit", resourceRoot, func.markerHit)

func.dataChange = function(dataName)
	if dataName == "player:loggedIn" then
		if getElementData(localPlayer,dataName) then
			triggerServerEvent("loadPlayerGroups",localPlayer,localPlayer,false,true)
		end
	end
end
addEventHandler("onClientElementDataChange",getLocalPlayer(),func.dataChange)

func.syncDataChange = function(dataName)
	if dataName == "player:loggedIn" then
		if getElementData(source,dataName) then
			playerCache[source] = true;
		end
    end
    
    if getElementType(source) == "vehicle" then
        if dataName == "vehicle:group" then
            if getElementData(source,dataName) and getElementData(source,dataName) > 0 then
                if not vehicleCache[source] then
                    vehicleCache[source] = true;
                end
            end
        end
    end
end
addEventHandler("onClientElementDataChange",getRootElement(),func.syncDataChange)

function onQuitGame()
    if playerCache[source] then
        playerCache[source] = nil;
    end
end
addEventHandler( "onClientPlayerQuit", getRootElement(), onQuitGame )

func.destroy = function()
    if getElementType(source) == "vehicle" then
        if vehicleCache[source] then
            vehicleCache[source] = nil;
        end

        if getElementData(source,"vehicle:dbid") and getElementData(source,"vehicle:dbid") > 0 then
            local dbid = getElementData(source,"vehicle:dbid");
            if vehicleBlips[dbid] then
                detachElements (vehicleBlips[dbid],source)
                detachElements (vehicleMarkers[dbid],source)
                destroyElement(vehicleBlips[dbid])
                destroyElement(vehicleMarkers[dbid])
                vehicleBlips[dbid] = nil;
                vehicleMarkers[dbid] = nil;
            end
        end

    end
end
addEventHandler("onClientElementDestroy", getRootElement(),func.destroy)

func.syncPlayerGroups = function(data,members,state,membersload,loaditems,loadtrans)
    groupCache = data;
    groupItems = loaditems;
    transactionCache = loadtrans;

    if membersload then
        groupMembers = members;
    end

    if state then
        cache.selectedgroup = 0;
        cache.grouppage = 1;
        cache.group.tagwheel = 0;
        cache.group.selected.member = 0;
        cache.group.newTag = false;
        cache.group.tagtext = "";
        cache.group.numberChange = false;
        cache.group.numberText = "";
        guiSetText(cache.group.gui,"")
        guiEditSetMaxLength(cache.group.gui,18)
        guiSetText(cache.group.newitemgui,"")
        cache.group.editrank = -1;
        cache.group.editwage = -1;
        cache.group.edititem = -1;
        cache.group.selectedsettingrank = 1;
        cache.group.edit.items = false;
        cache.group.edit.newitem = false;
        cache.group.edit.moneygui = false;
        cache.group.itemWheel = 0;
        cache.group.transactionwheel = 0;
        cache.group.skinwheel = 0;
    end
end
addEvent("syncPlayerGroups",true)
addEventHandler("syncPlayerGroups",getRootElement(),func.syncPlayerGroups)

func.syncGroupMemberData = function(groupid,data)
    groupMembers[groupid] = data;
end
addEvent("syncGroupMemberData",true)
addEventHandler("syncGroupMemberData",getRootElement(),func.syncGroupMemberData)

local alpha = 255;

setTimer(function()
    if alpha == 255 then
        alpha = 0;
    elseif alpha == 0 then
        alpha = 255;
    end
end,700,0)

function drawDash()
    

    if getElementData(localPlayer,"player:loggedIn") then 
        local drawColumn = 0;
        local drawRow = 0;
        
                dxDrawRectangle(sx*0.3,sy*0.21,sx*0.05,sy*0.5,tocolor(20,20,20,255))
                dxDrawRectangle(sx*0.35,sy*0.21,sx*0.38,sy*0.5,tocolor(25,25,25,255))
                dxDrawImage(sx*0.31 - 1,sy*0.23 + 1,sx*0.03,sy*0.05,cache.logo,0,0,0)
                dxDrawImage(sx*0.31,sy*0.23,sx*0.03,sy*0.05,cache.logo,0,0,0)

                dxDrawImage(sx*0.312 - 1,sy*0.31 + 1,sx*0.028,sy*0.04,cache.mydatas,0,0,0,tocolor(0,0,0,255))
                dxDrawImage(sx*0.312,sy*0.31,sx*0.028,sy*0.04,cache.mydatas,0,0,0,tocolor(40,40,40,255))

                dxDrawImage(sx*0.312 - 1,sy*0.38 + 1,sx*0.028,sy*0.04,cache.own,0,0,0,tocolor(0,0,0,255))
                dxDrawImage(sx*0.312,sy*0.38,sx*0.028,sy*0.04,cache.own,0,0,0,tocolor(40,40,40,255))

                dxDrawImage(sx*0.312 - 1,sy*0.45 + 1,sx*0.028,sy*0.04,cache.groups,0,0,0,tocolor(0,0,0,255))
                dxDrawImage(sx*0.312,sy*0.45,sx*0.028,sy*0.04,cache.groups,0,0,0,tocolor(40,40,40,255))
      
                dxDrawImage(sx*0.312 - 1,sy*0.52 + 1,sx*0.028,sy*0.04,cache.admins,0,0,0,tocolor(0,0,0,255))
                dxDrawImage(sx*0.312,sy*0.52,sx*0.028,sy*0.04,cache.admins,0,0,0,tocolor(40,40,40,255))

                dxDrawImage(sx*0.312 - 1,sy*0.6 + 1,sx*0.028,sy*0.04,cache.settings,0,0,0,tocolor(0,0,0,255))
                dxDrawImage(sx*0.312,sy*0.6,sx*0.028,sy*0.04,cache.settings,0,0,0,tocolor(40,40,40,255))

                if cache.page == "mydatas" then 
                    dxDrawImage(sx*0.312,sy*0.31,sx*0.028,sy*0.04,cache.mydatas,0,0,0,tocolor(129, 99, 191,255))
                    dxDrawRectangle(sx*0.36,sy*0.23,sx*0.175,sy*0.35,tocolor(20,20,20,255))

                    dxDrawText("Karakter Információk",sx*0.405 - 1,sy*0.238 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.sfpro)
                    dxDrawText("Karakter Információk",sx*0.405,sy*0.238,_,_,tocolor(255,255,255,255),0.00028*sx,cache.sfpro) --

                    for i = 1,5 do 
                        dxDrawRectangle(sx*0.362,sy*0.205 + (i*sy*0.062),sx*0.17,sy*0.03,tocolor(22,22,22,255)) 
                    end 

                    dxDrawText("Név",sx*0.365 - 1,sy*0.273 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto) 
                    dxDrawText("Név",sx*0.365,sy*0.273,_,_,tocolor(255,255,255,255),0.00028*sx,cache.roboto) 

                    dxDrawText(utf8.gsub(getElementData(localPlayer,"player:charname"),"_"," "),sx*0.53 - dxGetTextWidth(getElementData(localPlayer,"player:charname"),0.00028*sx,cache.roboto) - 1,sy*0.273 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto) 
                    dxDrawText(utf8.gsub(getElementData(localPlayer,"player:charname"),"_"," "),sx*0.53 - dxGetTextWidth(getElementData(localPlayer,"player:charname"),0.00028*sx,cache.roboto),sy*0.273,_,_,tocolor(129, 99, 191,255),0.00028*sx,cache.roboto) 

                    dxDrawText("Játszott perc",sx*0.365 - 1,sy*0.304 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto)
                    dxDrawText("Játszott perc",sx*0.365,sy*0.304,_,_,tocolor(255,255,255,255),0.00028*sx,cache.roboto)

                    dxDrawText(getElementData(localPlayer,"player:minutes"),sx*0.53 - dxGetTextWidth(getElementData(localPlayer,"player:minutes"),0.00028*sx,cache.roboto) - 1,sy*0.304 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto) 
                    dxDrawText(getElementData(localPlayer,"player:minutes"),sx*0.53 - dxGetTextWidth(getElementData(localPlayer,"player:minutes"),0.00028*sx,cache.roboto),sy*0.304,_,_,tocolor(129, 99, 191,255),0.00028*sx,cache.roboto) 

                    dxDrawText("Skin",sx*0.365 - 1,sy*0.335 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto)
                    dxDrawText("Skin",sx*0.365,sy*0.335,_,_,tocolor(255,255,255,255),0.00028*sx,cache.roboto)

                    dxDrawText(getElementModel(localPlayer),sx*0.53 - dxGetTextWidth(getElementModel(localPlayer),0.00028*sx,cache.roboto) - 1,sy*0.335 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto) 
                    dxDrawText(getElementModel(localPlayer),sx*0.53 - dxGetTextWidth(getElementModel(localPlayer),0.00028*sx,cache.roboto),sy*0.335,_,_,tocolor(129, 99, 191,255),0.00028*sx,cache.roboto) 

                    dxDrawText("Jelenlegi munka",sx*0.365 - 1,sy*0.366 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto)
                    dxDrawText("Jelenlegi munka",sx*0.365,sy*0.366,_,_,tocolor(255,255,255,255),0.00028*sx,cache.roboto)

                    dxDrawText(getPlayerJob(localPlayer,getElementData(localPlayer,"job")),sx*0.53 - dxGetTextWidth(getPlayerJob(localPlayer,getElementData(localPlayer,"job")),0.00028*sx,cache.roboto) - 1,sy*0.366 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto) 
                    dxDrawText(getPlayerJob(localPlayer,getElementData(localPlayer,"job")),sx*0.53 - dxGetTextWidth(getPlayerJob(localPlayer,getElementData(localPlayer,"job")),0.00028*sx,cache.roboto),sy*0.366,_,_,tocolor(129, 99, 191,255),0.00028*sx,cache.roboto) 
                    dxDrawText("Életkor",sx*0.365 - 1,sy*0.396 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto)
                    dxDrawText("Életkor",sx*0.365,sy*0.396,_,_,tocolor(255,255,255,255),0.00028*sx,cache.roboto)

                    dxDrawText(getElementData(localPlayer,"player:age"),sx*0.53 - dxGetTextWidth(getElementData(localPlayer,"player:age"),0.00028*sx,cache.roboto) - 1,sy*0.396 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto) 
                    dxDrawText(getElementData(localPlayer,"player:age"),sx*0.53 - dxGetTextWidth(getElementData(localPlayer,"player:age"),0.00028*sx,cache.roboto),sy*0.396,_,_,tocolor(129, 99, 191,255),0.00028*sx,cache.roboto) 

                    dxDrawText("Magasság",sx*0.365 - 1,sy*0.427 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto)
                    dxDrawText("Magasság",sx*0.365,sy*0.427,_,_,tocolor(255,255,255,255),0.00028*sx,cache.roboto)

                    dxDrawText(getElementData(localPlayer,"player:height"),sx*0.53 - dxGetTextWidth(getElementData(localPlayer,"player:height"),0.00028*sx,cache.roboto) - 1,sy*0.427 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto) 
                    dxDrawText(getElementData(localPlayer,"player:height"),sx*0.53 - dxGetTextWidth(getElementData(localPlayer,"player:height"),0.00028*sx,cache.roboto),sy*0.427,_,_,tocolor(129, 99, 191,255),0.00028*sx,cache.roboto) 

                    dxDrawText("Testsúly",sx*0.365 - 1,sy*0.457 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto)
                    dxDrawText("Testsúly",sx*0.365,sy*0.457,_,_,tocolor(255,255,255,255),0.00028*sx,cache.roboto)

                    dxDrawText(getElementData(localPlayer,"player:weight"),sx*0.53 - dxGetTextWidth(getElementData(localPlayer,"player:weight"),0.00028*sx,cache.roboto) - 1,sy*0.457 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto) 
                    dxDrawText(getElementData(localPlayer,"player:weight"),sx*0.53 - dxGetTextWidth(getElementData(localPlayer,"player:weight"),0.00028*sx,cache.roboto),sy*0.457,_,_,tocolor(129, 99, 191,255),0.00028*sx,cache.roboto) 

                    dxDrawText("Járművek",sx*0.365 - 1,sy*0.49 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto)
                    dxDrawText("Járművek",sx*0.365,sy*0.49,_,_,tocolor(255,255,255,255),0.00028*sx,cache.roboto)
                    dxDrawText(getPlayerVehicles(localPlayer),sx*0.53 - dxGetTextWidth(getPlayerVehicles(localPlayer),0.00028*sx,cache.roboto) - 1,sy*0.49 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto) 
                    dxDrawText(getPlayerVehicles(localPlayer),sx*0.53 - dxGetTextWidth(getPlayerVehicles(localPlayer),0.00028*sx,cache.roboto),sy*0.49,_,_,tocolor(129, 99, 191,255),0.00028*sx,cache.roboto) 

                    dxDrawText("Ingatlanok",sx*0.365 - 1,sy*0.5205 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto)
                    dxDrawText("Ingatlanok",sx*0.365,sy*0.5205,_,_,tocolor(255,255,255,255),0.00028*sx,cache.roboto)

                    dxDrawText(getPlayerPropertys(localPlayer),sx*0.53 - dxGetTextWidth(getPlayerPropertys(localPlayer),0.00028*sx,cache.roboto) - 1,sy*0.5205 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto) 
                    dxDrawText(getPlayerPropertys(localPlayer),sx*0.53 - dxGetTextWidth(getPlayerPropertys(localPlayer),0.00028*sx,cache.roboto),sy*0.5205,_,_,tocolor(129, 99, 191,255),0.00028*sx,cache.roboto) 

                    dxDrawText("Idő fizetésig",sx*0.365 - 1,sy*0.554 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto)
                    dxDrawText("Idő fizetésig",sx*0.365,sy*0.554,_,_,tocolor(255,255,255,255),0.00028*sx,cache.roboto)

                    local payTime = getElementData(localPlayer,"player:paytime");
                    dxDrawText(payTime.." perc",sx*0.53 - dxGetTextWidth(payTime.." perc",0.00028*sx,cache.roboto) - 1,sy*0.554 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto) 
                    dxDrawText(payTime.." perc",sx*0.53 - dxGetTextWidth(payTime.." perc",0.00028*sx,cache.roboto),sy*0.554,_,_,tocolor(129, 99, 191,255),0.00028*sx,cache.roboto) 

                                                                                                               --
                    dxDrawRectangle(sx*0.545,sy*0.23,sx*0.175,sy*0.197,tocolor(20,20,20,255))

                    for i = 1,3 do 
                        dxDrawRectangle(sx*0.548,sy*0.205 + (i*sy*0.062),sx*0.17,sy*0.03,tocolor(22,22,22,255)) 
                    end 

                    dxDrawText("Account Információk",sx*0.5925 - 1,sy*0.238 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.sfpro)
                    dxDrawText("Account Információk",sx*0.5925,sy*0.238,_,_,tocolor(255,255,255,255),0.00028*sx,cache.sfpro)

                    dxDrawText("Felhasználónév",sx*0.551 - 1,sy*0.273 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto) 
                    dxDrawText("Felhasználónév",sx*0.551,sy*0.273,_,_,tocolor(255,255,255,255),0.00028*sx,cache.roboto) 

                    dxDrawText(utf8.gsub(getElementData(localPlayer,"player:username"),"_"," "),sx*0.717 - dxGetTextWidth(getElementData(localPlayer,"player:username"),0.00028*sx,cache.roboto) - 1,sy*0.273 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto) 
                    dxDrawText(utf8.gsub(getElementData(localPlayer,"player:username"),"_"," "),sx*0.717 - dxGetTextWidth(getElementData(localPlayer,"player:username"),0.00028*sx,cache.roboto),sy*0.273,_,_,tocolor(129, 99, 191,255),0.00028*sx,cache.roboto) 

             --       dxDrawText("Serial",sx*0.551 - 1,sy*0.304 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto)
               --     dxDrawText("Serial",sx*0.551,sy*0.304,_,_,tocolor(255,255,255,255),0.00028*sx,cache.roboto)

                 --   dxDrawText(getPlayerSerial(localPlayer),sx*0.717 - dxGetTextWidth(getPlayerSerial(localPlayer),0.00028*sx,cache.roboto) - 1,sy*0.304 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto) 
                    dxDrawText(getPlayerSerial(localPlayer),sx*0.717 - dxGetTextWidth(getPlayerSerial(localPlayer),0.00028*sx,cache.roboto),sy*0.304,_,_,tocolor(129, 99, 191,255),0.00028*sx,cache.roboto) 

                    dxDrawText("Regisztráció dátuma",sx*0.551 - 1,sy*0.335 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto)
                    dxDrawText("Regisztráció dátuma",sx*0.551,sy*0.335,_,_,tocolor(255,255,255,255),0.00028*sx,cache.roboto)

                    dxDrawText(getElementData(localPlayer,"player:regdate"),sx*0.717 - dxGetTextWidth(getElementData(localPlayer,"player:regdate"),0.00028*sx,cache.roboto) - 1,sy*0.335 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto) 
                    dxDrawText(getElementData(localPlayer,"player:regdate"),sx*0.717 - dxGetTextWidth(getElementData(localPlayer,"player:regdate"),0.00028*sx,cache.roboto),sy*0.335,_,_,tocolor(129, 99, 191,255),0.00028*sx,cache.roboto) 

                    dxDrawText("Account ID",sx*0.551 - 1,sy*0.366 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto)
                    dxDrawText("Account ID",sx*0.551,sy*0.366,_,_,tocolor(255,255,255,255),0.00028*sx,cache.roboto)

                    dxDrawText(getElementData(localPlayer,"player:dbid"),sx*0.717 - dxGetTextWidth(getElementData(localPlayer,"player:dbid"),0.00028*sx,cache.roboto) - 1,sy*0.366 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto) 
                    dxDrawText(getElementData(localPlayer,"player:dbid"),sx*0.717 - dxGetTextWidth(getElementData(localPlayer,"player:dbid"),0.00028*sx,cache.roboto),sy*0.366,_,_,tocolor(129, 99, 191,255),0.00028*sx,cache.roboto) 

                    dxDrawText("Karakter ID",sx*0.551 - 1,sy*0.396 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto)
                    dxDrawText("Karakter ID",sx*0.551,sy*0.396,_,_,tocolor(255,255,255,255),0.00028*sx,cache.roboto)

                    dxDrawText(getElementData(localPlayer,"player:dbid"),sx*0.717 - dxGetTextWidth(getElementData(localPlayer,"player:dbid"),0.00028*sx,cache.roboto) - 1,sy*0.396 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto) 
                    dxDrawText(getElementData(localPlayer,"player:dbid"),sx*0.717 - dxGetTextWidth(getElementData(localPlayer,"player:dbid"),0.00028*sx,cache.roboto),sy*0.396,_,_,tocolor(129, 99, 191,255),0.00028*sx,cache.roboto) 

                    dxDrawRectangle(sx*0.36,sy*0.59,sx*0.175,sy*0.097,tocolor(20,20,20,255))
                    dxDrawRectangle(sx*0.362,sy*0.595,sx*0.17,sy*0.03,tocolor(22,22,22,255)) 

                    dxDrawText("Leírás",sx*0.43 - 1,sy*0.6 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.sfpro)
                    dxDrawText("Leírás",sx*0.43,sy*0.6,_,_,tocolor(255,255,255,255),0.00028*sx,cache.sfpro)
                    
                    dxDrawText(getElementData(localPlayer,"player:description"),sx*0.363 - 1,sy*0.63 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto) 
                    dxDrawText(getElementData(localPlayer,"player:description"),sx*0.363,sy*0.63,_,_,tocolor(129, 99, 191,255),0.00028*sx,cache.roboto) 


                    dxDrawRectangle(sx*0.6316,sy*0.44,sx*0.0875,sy*0.247,tocolor(20,20,20,255))

                    dxDrawText("Fegyver skillek",sx*0.647 - 1,sy*0.445 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.sfpro)
                    dxDrawText("Fegyver skillek",sx*0.647,sy*0.445,_,_,tocolor(255,255,255,255),0.00028*sx,cache.sfpro)

                    for i = 1,6 do 
                    dxDrawRectangle(sx*0.633,sy*0.424 + (i*sy*0.041),sx*0.085,sy*0.02,tocolor(22,22,22,255))
                    end 


                    dxDrawText("Colt 45",sx*0.635 - 1,sy*0.466 + 1,_,_,tocolor(0,0,0,255),0.00026*sx,cache.roboto)
                    dxDrawText("Colt 45",sx*0.635,sy*0.466,_,_,tocolor(255,255,255,255),0.00026*sx,cache.roboto)

                    dxDrawText(math.floor(getPedStat(localPlayer,69)/10).."%",sx*0.716 - dxGetTextWidth(math.floor(getPedStat(localPlayer,69)/10).."%",0.00026*sx,cache.roboto) - 1,sy*0.466 + 1,_,_,tocolor(0,0,0,255),0.00026*sx,cache.roboto)
                    dxDrawText(math.floor(getPedStat(localPlayer,69)/10).."%",sx*0.716 - dxGetTextWidth(math.floor(getPedStat(localPlayer,69)/10).."%",0.00026*sx,cache.roboto),sy*0.466,_,_,tocolor(129, 99, 191,255),0.00026*sx,cache.roboto)

                    dxDrawText("Silenced Colt",sx*0.635 - 1,sy*0.488 + 1,_,_,tocolor(0,0,0,255),0.00026*sx,cache.roboto)
                    dxDrawText("Silenced Colt",sx*0.635,sy*0.488,_,_,tocolor(255,255,255,255),0.00026*sx,cache.roboto)

                    dxDrawText(math.floor(getPedStat(localPlayer,70)/10).."%",sx*0.716 - dxGetTextWidth(math.floor(getPedStat(localPlayer,70)/10).."%",0.00026*sx,cache.roboto) - 1,sy*0.488 + 1,_,_,tocolor(0,0,0,255),0.00026*sx,cache.roboto)
                    dxDrawText(math.floor(getPedStat(localPlayer,70)/10).."%",sx*0.716 - dxGetTextWidth(math.floor(getPedStat(localPlayer,70)/10).."%",0.00026*sx,cache.roboto),sy*0.488,_,_,tocolor(129, 99, 191,255),0.00026*sx,cache.roboto)

                    dxDrawText("Deasert Eagle",sx*0.635 - 1,sy*0.508 + 1,_,_,tocolor(0,0,0,255),0.00026*sx,cache.roboto)
                    dxDrawText("Deasert Eagle",sx*0.635,sy*0.508,_,_,tocolor(255,255,255,255),0.00026*sx,cache.roboto)

                    dxDrawText(math.floor(getPedStat(localPlayer,71)/10).."%",sx*0.716 - dxGetTextWidth(math.floor(getPedStat(localPlayer,71)/10).."%",0.00026*sx,cache.roboto) - 1,sy*0.508 + 1,_,_,tocolor(0,0,0,255),0.00026*sx,cache.roboto)
                    dxDrawText(math.floor(getPedStat(localPlayer,71)/10).."%",sx*0.716 - dxGetTextWidth(math.floor(getPedStat(localPlayer,71)/10).."%",0.00026*sx,cache.roboto),sy*0.508,_,_,tocolor(129, 99, 191,255),0.00026*sx,cache.roboto)

                    dxDrawText("Tec-9",sx*0.635 - 1,sy*0.528 + 1,_,_,tocolor(0,0,0,255),0.00026*sx,cache.roboto)
                    dxDrawText("Tec-9",sx*0.635,sy*0.528,_,_,tocolor(255,255,255,255),0.00026*sx,cache.roboto)

                    dxDrawText(math.floor(getPedStat(localPlayer,75)/10).."%",sx*0.716 - dxGetTextWidth(math.floor(getPedStat(localPlayer,75)/10).."%",0.00026*sx,cache.roboto) - 1,sy*0.528 + 1,_,_,tocolor(0,0,0,255),0.00026*sx,cache.roboto)
                    dxDrawText(math.floor(getPedStat(localPlayer,75)/10).."%",sx*0.716 - dxGetTextWidth(math.floor(getPedStat(localPlayer,75)/10).."%",0.00026*sx,cache.roboto),sy*0.528,_,_,tocolor(129, 99, 191,255),0.00026*sx,cache.roboto)

                    dxDrawText("Shotgun",sx*0.635 - 1,sy*0.548 + 1,_,_,tocolor(0,0,0,255),0.00026*sx,cache.roboto)
                    dxDrawText("Shotgun",sx*0.635,sy*0.548,_,_,tocolor(255,255,255,255),0.00026*sx,cache.roboto)

                    dxDrawText(math.floor(getPedStat(localPlayer,72)/10).."%",sx*0.716 - dxGetTextWidth(math.floor(getPedStat(localPlayer,72)/10).."%",0.00026*sx,cache.roboto) - 1,sy*0.548 + 1,_,_,tocolor(0,0,0,255),0.00026*sx,cache.roboto)
                    dxDrawText(math.floor(getPedStat(localPlayer,72)/10).."%",sx*0.716 - dxGetTextWidth(math.floor(getPedStat(localPlayer,72)/10).."%",0.00026*sx,cache.roboto),sy*0.548,_,_,tocolor(129, 99, 191,255),0.00026*sx,cache.roboto)

                    dxDrawText("Spaz-12",sx*0.635 - 1,sy*0.568 + 1,_,_,tocolor(0,0,0,255),0.00026*sx,cache.roboto)
                    dxDrawText("Spaz-12",sx*0.635,sy*0.568,_,_,tocolor(255,255,255,255),0.00026*sx,cache.roboto)

                    dxDrawText(math.floor(getPedStat(localPlayer,74)/10).."%",sx*0.716 - dxGetTextWidth(math.floor(getPedStat(localPlayer,74)/10).."%",0.00026*sx,cache.roboto) - 1,sy*0.568 + 1,_,_,tocolor(0,0,0,255),0.00026*sx,cache.roboto)
                    dxDrawText(math.floor(getPedStat(localPlayer,74)/10).."%",sx*0.716 - dxGetTextWidth(math.floor(getPedStat(localPlayer,74)/10).."%",0.00026*sx,cache.roboto),sy*0.568,_,_,tocolor(129, 99, 191,255),0.00026*sx,cache.roboto)

                    dxDrawText("Uzi",sx*0.635 - 1,sy*0.588 + 1,_,_,tocolor(0,0,0,255),0.00026*sx,cache.roboto)
                    dxDrawText("Uzi",sx*0.635,sy*0.588,_,_,tocolor(255,255,255,255),0.00026*sx,cache.roboto)

                    dxDrawText(math.floor(getPedStat(localPlayer,75)/10).."%",sx*0.716 - dxGetTextWidth(math.floor(getPedStat(localPlayer,75)/10).."%",0.00026*sx,cache.roboto) - 1,sy*0.588 + 1,_,_,tocolor(0,0,0,255),0.00026*sx,cache.roboto)
                    dxDrawText(math.floor(getPedStat(localPlayer,75)/10).."%",sx*0.716 - dxGetTextWidth(math.floor(getPedStat(localPlayer,75)/10).."%",0.00026*sx,cache.roboto),sy*0.588,_,_,tocolor(129, 99, 191,255),0.00026*sx,cache.roboto)

                    dxDrawText("Mp5",sx*0.635 - 1,sy*0.608 + 1,_,_,tocolor(0,0,0,255),0.00026*sx,cache.roboto)
                    dxDrawText("Mp5",sx*0.635,sy*0.608,_,_,tocolor(255,255,255,255),0.00026*sx,cache.roboto)

                    dxDrawText(math.floor(getPedStat(localPlayer,76)/10).."%",sx*0.716 - dxGetTextWidth(math.floor(getPedStat(localPlayer,76)/10).."%",0.00026*sx,cache.roboto) - 1,sy*0.608 + 1,_,_,tocolor(0,0,0,255),0.00026*sx,cache.roboto)
                    dxDrawText(math.floor(getPedStat(localPlayer,76)/10).."%",sx*0.716 - dxGetTextWidth(math.floor(getPedStat(localPlayer,76)/10).."%",0.00026*sx,cache.roboto),sy*0.608,_,_,tocolor(129, 99, 191,255),0.00026*sx,cache.roboto)

                    dxDrawText("AK-47",sx*0.635 - 1,sy*0.629 + 1,_,_,tocolor(0,0,0,255),0.00026*sx,cache.roboto)
                    dxDrawText("AK-47",sx*0.635,sy*0.629,_,_,tocolor(255,255,255,255),0.00026*sx,cache.roboto)

                    dxDrawText(math.floor(getPedStat(localPlayer,77)/10).."%",sx*0.716 - dxGetTextWidth(math.floor(getPedStat(localPlayer,77)/10).."%",0.00026*sx,cache.roboto) - 1,sy*0.629 + 1,_,_,tocolor(0,0,0,255),0.00026*sx,cache.roboto)
                    dxDrawText(math.floor(getPedStat(localPlayer,77)/10).."%",sx*0.716 - dxGetTextWidth(math.floor(getPedStat(localPlayer,77)/10).."%",0.00026*sx,cache.roboto),sy*0.629,_,_,tocolor(129, 99, 191,255),0.00026*sx,cache.roboto)

                    dxDrawText("M4",sx*0.635 - 1,sy*0.649 + 1,_,_,tocolor(0,0,0,255),0.00026*sx,cache.roboto)
                    dxDrawText("M4",sx*0.635,sy*0.649,_,_,tocolor(255,255,255,255),0.00026*sx,cache.roboto)

                    dxDrawText(math.floor(getPedStat(localPlayer,78)/10).."%",sx*0.716 - dxGetTextWidth(math.floor(getPedStat(localPlayer,78)/10).."%",0.00026*sx,cache.roboto) - 1,sy*0.649 + 1,_,_,tocolor(0,0,0,255),0.00026*sx,cache.roboto)
                    dxDrawText(math.floor(getPedStat(localPlayer,78)/10).."%",sx*0.716 - dxGetTextWidth(math.floor(getPedStat(localPlayer,78)/10).."%",0.00026*sx,cache.roboto),sy*0.649,_,_,tocolor(129, 99, 191,255),0.00026*sx,cache.roboto)

                    dxDrawText("Mesterlövész",sx*0.635 - 1,sy*0.669 + 1,_,_,tocolor(0,0,0,255),0.00026*sx,cache.roboto)
                    dxDrawText("Mesterlövész",sx*0.635,sy*0.669,_,_,tocolor(255,255,255,255),0.00026*sx,cache.roboto)

                    dxDrawText(math.floor(getPedStat(localPlayer,79)/10).."%",sx*0.716 - dxGetTextWidth(math.floor(getPedStat(localPlayer,79)/10).."%",0.00026*sx,cache.roboto) - 1,sy*0.669 + 1,_,_,tocolor(0,0,0,255),0.00026*sx,cache.roboto)
                    dxDrawText(math.floor(getPedStat(localPlayer,79)/10).."%",sx*0.716 - dxGetTextWidth(math.floor(getPedStat(localPlayer,79)/10).."%",0.00026*sx,cache.roboto),sy*0.669,_,_,tocolor(129, 99, 191,255),0.00026*sx,cache.roboto)
                    --

                elseif cache.page == "own" then 
                    --header
                    dxDrawImage(sx*0.312,sy*0.38,sx*0.028,sy*0.04,cache.own,0,0,0,tocolor(129, 99, 191,255))
                    dxDrawRectangle(sx*0.365,sy*0.24,sx*0.17,sy*0.055,tocolor(20,20,20,255))
                    dxDrawRectangle(sx*0.3675,sy*0.243,sx*0.165,sy*0.025,tocolor(22,22,22,255))

                    dxDrawText("Készpénz",sx*0.3695 - 1,sy*0.2465 + 1,_,_,tocolor(0,0,0,255),0.00026*sx,cache.roboto)
                    dxDrawText("Készpénz",sx*0.3695,sy*0.2465,_,_,tocolor(255,255,255,255),0.00026*sx,cache.roboto)

                    dxDrawText("$"..formatMoney(getElementData(localPlayer,"player:money")),sx*0.53 - 1,sy*0.2465 + 1,_,_,tocolor(0,0,0,255),0.00026*sx,cache.roboto,"right")
                    dxDrawText("$"..formatMoney(getElementData(localPlayer,"player:money")),sx*0.53,sy*0.2465,_,_,tocolor(129, 99, 191,255),0.00026*sx,cache.roboto,"right")

                    dxDrawText("Prémium pontok",sx*0.3695 - 1,sy*0.2735 + 1,_,_,tocolor(0,0,0,255),0.00026*sx,cache.roboto)
                    dxDrawText("Prémium pontok",sx*0.3695,sy*0.2735,_,_,tocolor(255,255,255,255),0.00026*sx,cache.roboto)

                    dxDrawText(formatMoney(getElementData(localPlayer,"player:pp")).."PP",sx*0.53 - 1,sy*0.2735 + 1,_,_,tocolor(0,0,0,255),0.00026*sx,cache.roboto,"right")
                    dxDrawText(formatMoney(getElementData(localPlayer,"player:pp")).."PP",sx*0.53,sy*0.2735,_,_,tocolor(129, 99, 191,255),0.00026*sx,cache.roboto,"right")

                    dxDrawRectangle(sx*0.545,sy*0.24,sx*0.17,sy*0.055,tocolor(20,20,20,255))
                    dxDrawRectangle(sx*0.5475,sy*0.243,sx*0.165,sy*0.025,tocolor(22,22,22,255))

                    dxDrawText("Jármű slot",sx*0.55 - 1,sy*0.2465 + 1,_,_,tocolor(0,0,0,255),0.00026*sx,cache.roboto)
                    dxDrawText("Jármű slot",sx*0.55,sy*0.2465,_,_,tocolor(255,255,255,255),0.00026*sx,cache.roboto)

                    dxDrawText(getPlayerVehicles(localPlayer).."/3",sx*0.71 - 1,sy*0.2465 + 1,_,_,tocolor(0,0,0,255),0.00026*sx,cache.roboto,"right")
                    dxDrawText(getPlayerVehicles(localPlayer).."/3",sx*0.71,sy*0.2465,_,_,tocolor(129, 99, 191,255),0.00026*sx,cache.roboto,"right")

                    dxDrawText("Ingatlan slot",sx*0.55 - 1,sy*0.2735 + 1,_,_,tocolor(0,0,0,255),0.00026*sx,cache.roboto)
                    dxDrawText("Ingatlan slot",sx*0.55,sy*0.2735,_,_,tocolor(255,255,255,255),0.00026*sx,cache.roboto)

                    dxDrawText(getPlayerPropertys(localPlayer).."/5",sx*0.71 - 1,sy*0.2735 + 1,_,_,tocolor(0,0,0,255),0.00026*sx,cache.roboto,"right")
                    dxDrawText(getPlayerPropertys(localPlayer).."/5",sx*0.71,sy*0.2735,_,_,tocolor(129, 99, 191,255),0.00026*sx,cache.roboto,"right")

                    --header

                    dxDrawRectangle(sx*0.365,sy*0.318,sx*0.17,sy*0.35,tocolor(20,20,20,255))
                    dxDrawText("Járművek",sx*0.43,sy*0.328,_,_,tocolor(255,255,255,255),0.00026*sx,cache.sfpro)

                    for i = 1,6 do 
                       dxDrawRectangle(sx*0.3675,sy*0.3025 + (i*sy*0.052),sx*0.165,sy*0.025,tocolor(22,22,22,255))
                    end 

                     Vehcount = 0;
                    for k,v in ipairs(cache.playerVehicles) do
                        if k > cache.ownvehwheel and Vehcount < 12 then
                            Vehcount = Vehcount+1;
                            dxDrawText(exports.Pmods:getVehName(v),sx*0.37,sy*0.3325+(Vehcount*sy*0.0262),sx*0.4125,sy*0.3045+(Vehcount*sy*0.0262),tocolor(255,255,255,255),0.00026*sx,cache.roboto,"left","top")
                            dxDrawText("ID: "..getElementData(v,"vehicle:dbid"),sx*0.53,sy*0.3325+(Vehcount*sy*0.0262),sx*0.53,sy*0.3045+(Vehcount*sy*0.0262),tocolor(255,255,255,255),0.00026*sx,cache.roboto,"right","top")
                        end
                    end

                    dxDrawRectangle(sx*0.545,sy*0.318,sx*0.17,sy*0.35,tocolor(20,20,20,255))
                    dxDrawText("Ingatlanok",sx*0.6125,sy*0.328,_,_,tocolor(255,255,255,255),0.00026*sx,cache.sfpro)

                    for i = 1,6 do 
                        dxDrawRectangle(sx*0.5475,sy*0.3025 + (i*sy*0.052),sx*0.165,sy*0.025,tocolor(22,22,22,255))
                    end 

                    local Intcount = 0;
                    for k,v in ipairs(cache.playerInteriors) do
                        if k > cache.intwheel and Intcount < 12 then
                            Intcount = Intcount+1;
                            dxDrawText(getElementData(v,"int:name"),sx*0.55,sy*0.3325+(Intcount*sy*0.0262),sx*0.4125,sy*0.3045+(Intcount*sy*0.0262),tocolor(255,255,255,255),0.00026*sx,cache.roboto,"left","top")
                            dxDrawText("ID: "..getElementData(v,"int:dbid"),sx*0.71,sy*0.3325+(Intcount*sy*0.0262),sx*0.71,sy*0.3045+(Intcount*sy*0.0262),tocolor(255,255,255,255),0.00026*sx,cache.roboto,"right","top")
                        end
                    end

                elseif cache.page == "groups" then 
                    dxDrawImage(sx*0.312,sy*0.45,sx*0.028,sy*0.04,cache.groups,0,0,0,tocolor(129, 99, 191,255))
                    
                    --dxDrawText("Frakció Információk",sx*0.405 - 1,sy*0.238 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.sfpro)
                    local groupName = "Frakció Információk";
                    if cache.selectedgroup > 0 then
                        groupName = groupCache[cache.selectedgroup].name;
                    end

                    dxDrawText(groupName,sx*0.540,sy*0.248,sx*0.540,sy*0.248,tocolor(255,255,255,255),0.00058*sx,cache.sfpro,"center","center")

                    if cache.selectedgroup > 0 then
                        if isInSlot(sx*0.6896,sy*0.230,sx*0.03,sy*0.03) then
                            dxDrawImage(sx*0.6896,sy*0.230,sx*0.03,sy*0.03,"files/backarrow.png",0,0,0,tocolor(129, 99, 191,255))
                        else
                            dxDrawImage(sx*0.6896,sy*0.230,sx*0.03,sy*0.03,"files/backarrow.png")
                        end

                        for k,v in ipairs(cache.grouppages) do
                            dxDrawRectangle(sx*0.2596 + (k*(sx*0.094)),sy*0.280,sx*0.09,sy*0.026,tocolor(20,20,20,255))
                            if isInSlot(sx*0.2596 + (k*(sx*0.094)),sy*0.280,sx*0.09,sy*0.026) or cache.grouppage == k then
                                dxDrawRectangle(sx*0.2596+2 + (k*(sx*0.094)),sy*0.280+2,sx*0.09-4,sy*0.026-4,tocolor(129, 99, 191,255))
                            end
                            dxDrawText(v,sx*0.3054 + (k*(sx*0.094)),sy*0.292,sx*0.3054 + (k*(sx*0.094)),sy*0.292,tocolor(255,255,255,255),0.00029*sx,cache.roboto,"center","center")
                        end

                        if cache.grouppage == 1 then
                            dxDrawRectangle(sx*0.3538,sy*0.312,sx*0.117,sy*0.391,tocolor(20,20,20,255))
                            for i = 1,14 do
                                if i % 2 ~= 0 then
                                    dxDrawRectangle(sx*0.3574,sy*0.291+i*sy*0.027,sx*0.11,sy*0.027,tocolor(25,25,25,255))
                                else
                                    dxDrawRectangle(sx*0.3574,sy*0.291+i*sy*0.027,sx*0.11,sy*0.027,tocolor(22,22,22,255))
                                end
                            end
                            
                            local count = 0;
                            local a = 0;

                            for k,v in pairs(groupMembers[groupCache[cache.selectedgroup].dbid]) do
                                count = count+1;
                                if count > cache.group.tagwheel and a < 14 then
                                    local r,g,b = 255,255,255;

                                    if isInSlot(sx*0.3574,sy*0.319+(a*sy*0.027),sx*0.11,sy*0.027) or cache.group.selected.member == k then
                                        dxDrawRectangle(sx*0.3574+2,sy*0.319+2+(a*sy*0.027),sx*0.11-4,sy*0.027-4,tocolor(129, 99, 191)) 
                                    else
                                        if func.getOnline(v.charid) then
                                            r,g,b = 127,197,118;
                                        end
                                    end

                                    dxDrawText(v.name:gsub("_", " "),sx*0.4125,sy*0.331+a*sy*0.027,sx*0.4125,sy*0.331+a*sy*0.027,tocolor(r,g,b,255),0.00029*sx,cache.roboto,"center","center")
                                    
                                    a = a+1;
                                end
                            end

                            if cache.group.selected.member > 0 then

                                if not groupMembers[groupCache[cache.selectedgroup].dbid][cache.group.selected.member] then
                                    cache.group.selected.member = 0;
                                end

                                local name = groupMembers[groupCache[cache.selectedgroup].dbid][cache.group.selected.member].name:gsub("_", " ");
                                local rank = groupMembers[groupCache[cache.selectedgroup].dbid][cache.group.selected.member].rank;
                                local leader = groupMembers[groupCache[cache.selectedgroup].dbid][cache.group.selected.member].leader;
                                local lastOnline = groupMembers[groupCache[cache.selectedgroup].dbid][cache.group.selected.member].lastOnline;
                                local charid = groupMembers[groupCache[cache.selectedgroup].dbid][cache.group.selected.member].charid;
                                local dutyskin = groupMembers[groupCache[cache.selectedgroup].dbid][cache.group.selected.member].skin;
                                local cardNumber = groupMembers[groupCache[cache.selectedgroup].dbid][cache.group.selected.member].cardNumber;
                                if cardNumber == "" then
                                    cardNumber = "Nincs beállítva";
                                end
                                local rankname = groupCache[cache.selectedgroup].ranks[rank][1];
                                local wage = groupCache[cache.selectedgroup].ranks[rank][2];
                                
                                dxDrawText(name,sx*0.603,sy*0.341,sx*0.603,sy*0.341,tocolor(129, 99, 191,255),0.00062*sx,cache.sfpro,"center","center")

                                dxDrawText("Dutyskin: #8163bf"..dutyskin,sx*0.482,sy*0.56,0,0,tocolor(255,255,255,255),0.00034*sx,cache.roboto,"left","top",false,false,false,true)
                                
                                local leadertext = "Nem"
                                if leader == 1 then
                                    leadertext = "Igen"
                                end
                                
                                dxDrawText("Leader: #8163bf"..leadertext,sx*0.482,sy*0.583,0,0,tocolor(255,255,255,255),0.00034*sx,cache.roboto,"left","top",false,false,false,true)
                                dxDrawText("Fizetés: #7cc576"..formatMoney(wage).."#ffffff $ - Számlaszám: #8163bf"..cardNumber,sx*0.482,sy*0.606,0,0,tocolor(255,255,255,255),0.00034*sx,cache.roboto,"left","top",false,false,false,true)
                                dxDrawText("Rang: #8163bf"..rankname,sx*0.482,sy*0.628,0,0,tocolor(255,255,255,255),0.00034*sx,cache.roboto,"left","top",false,false,false,true)

                                local online = "#D23131Nem";
                                if func.getOnline(charid) then
                                    online = "#7cc576Igen";
                                end

                                dxDrawText("Online: "..online,sx*0.482,sy*0.65,0,0,tocolor(255,255,255,255),0.00034*sx,cache.roboto,"left","top",false,false,false,true)
                                dxDrawText("Utoljára online: #8163bf"..lastOnline,sx*0.482,sy*0.673,0,0,tocolor(255,255,255,255),0.00034*sx,cache.roboto,"left","top",false,false,false,true)

                            end

                            for k,v in ipairs(cache.group.buttons) do
                                local offset1,offset2 = 0,0

                                if k == 5 and not cache.group.numberChange then
                                    offset1,offset2 = 0.008,0.016;
                                else
                                    offset1,offset2 = 0,0
                                end
                                dxDrawRectangle(sx*0.482,sy*0.340 +(k*(sy*0.034)),sx*0.10,sy*(0.026+offset2),tocolor(20,20,20,255))
                                if isInSlot(sx*0.482,sy*0.340 +(k*(sy*0.034)),sx*0.10,sy*(0.026+offset2)) then
                                    dxDrawRectangle(sx*0.482+2,sy*0.340+2 +(k*(sy*0.034)),sx*0.10-4,sy*(0.026+offset2)-4,tocolor(129, 99, 191,255))
                                end

                                if k == 4 and cache.group.newTag then

                                    dxDrawRectangle(sx*0.586,sy*0.340 +(k*(sy*0.034)),sx*0.015,sy*0.026,tocolor(20,20,20,255))
                                    if isInSlot(sx*0.586,sy*0.340 +(k*(sy*0.034)),sx*0.015,sy*0.026) then
                                        dxDrawRectangle(sx*0.586+2,sy*0.340+2 +(k*(sy*0.034)),sx*0.015-4,sy*0.026-4,tocolor(129, 99, 191,255))
                                    end
                                    dxDrawImage(sx*0.588,sy*0.343 +(k*(sy*0.034)),sx*0.01,sy*0.018,"files/check.png")

                                    dxDrawRectangle(sx*0.606,sy*0.340 +(k*(sy*0.034)),sx*0.015,sy*0.026,tocolor(20,20,20,255))
                                    if isInSlot(sx*0.606,sy*0.340 +(k*(sy*0.034)),sx*0.015,sy*0.026) then
                                        dxDrawRectangle(sx*0.606+2,sy*0.340+2 +(k*(sy*0.034)),sx*0.015-4,sy*0.026-4,tocolor(129, 99, 191,255))
                                    end
                                    dxDrawImage(sx*0.6092,sy*0.3458 +(k*(sy*0.034)),sx*0.008,sy*0.014,"files/cancel.png")

                                    dxDrawText(cache.group.tagtext,sx*0.485,sy*0.343 +(k*(sy*0.034)),0,0,tocolor(255,255,255,255),0.00029*sx,cache.roboto)

                                    --if #cache.group.tagtext > 0 then
                                        local textwidth = dxGetTextWidth(cache.group.tagtext,0.00029*sx,cache.roboto)
                                        dxDrawRectangle(sx*0.487 +textwidth,sy*0.345 +(k*(sy*0.034)),1,sy*0.016,tocolor(255,255,255,alpha))
                                    --end
                                elseif k == 5 and cache.group.numberChange then

                                    dxDrawRectangle(sx*0.586,sy*0.340 +(k*(sy*0.034)),sx*0.015,sy*0.026,tocolor(20,20,20,255))
                                    if isInSlot(sx*0.586,sy*0.340 +(k*(sy*0.034)),sx*0.015,sy*0.026) then
                                        dxDrawRectangle(sx*0.586+2,sy*0.340+2 +(k*(sy*0.034)),sx*0.015-4,sy*0.026-4,tocolor(129, 99, 191,255))
                                    end
                                    dxDrawImage(sx*0.588,sy*0.343 +(k*(sy*0.034)),sx*0.01,sy*0.018,"files/check.png")

                                    dxDrawRectangle(sx*0.606,sy*0.340 +(k*(sy*0.034)),sx*0.015,sy*0.026,tocolor(20,20,20,255))
                                    if isInSlot(sx*0.606,sy*0.340 +(k*(sy*0.034)),sx*0.015,sy*0.026) then
                                        dxDrawRectangle(sx*0.606+2,sy*0.340+2 +(k*(sy*0.034)),sx*0.015-4,sy*0.026-4,tocolor(129, 99, 191,255))
                                    end
                                    dxDrawImage(sx*0.6092,sy*0.3458 +(k*(sy*0.034)),sx*0.008,sy*0.014,"files/cancel.png")

                                    dxDrawText(cache.group.numberText,sx*0.485,sy*0.343 +(k*(sy*0.034)),0,0,tocolor(255,255,255,255),0.00029*sx,cache.roboto)

                                    local textwidth = dxGetTextWidth(cache.group.numberText,0.00029*sx,cache.roboto)
                                    dxDrawRectangle(sx*0.487 +textwidth,sy*0.345 +(k*(sy*0.034)),1,sy*0.016,tocolor(255,255,255,alpha))
                                else
                                    dxDrawText(v,sx*0.5325,sy*(0.353+offset1) +(k*(sy*0.034)),sx*0.5325,sy*(0.353+offset1) +(k*(sy*0.034)),tocolor(255,255,255,255),0.00029*sx,cache.roboto,"center","center")
                                end
                            end
                        elseif cache.grouppage == 2 then
                            for i = 1,15 do
                                dxDrawRectangle(sx*0.354,sy*0.288 +(i*(sy*0.026)),sx*0.085,sy*0.022,tocolor(20,20,20,255))

                                local rankname = groupCache[cache.selectedgroup].ranks[i][1];
                                local wage = groupCache[cache.selectedgroup].ranks[i][2];
                                

                                if cache.group.editrank == i then
                                    local guiText = guiGetText(cache.group.gui);

                                    if guiEditSetCaretIndex(cache.group.gui, string.len(guiGetText(cache.group.gui))) then
                                        guiBringToFront(cache.group.gui)

                                    end

                                    dxDrawText(guiText,sx*0.357,sy*0.2896 +(i*(sy*0.026)),0,0,tocolor(255,255,255,255),0.00029*sx,cache.roboto)

                                    local textwidth = dxGetTextWidth(guiText,0.00029*sx,cache.roboto)

                                    dxDrawRectangle(sx*0.441,sy*0.288 +(i*(sy*0.026)),sx*0.013,sy*0.022,tocolor(20,20,20,255))
                                    if isInSlot(sx*0.441,sy*0.288 +(i*(sy*0.026)),sx*0.013,sy*0.022) then
                                        dxDrawRectangle(sx*0.441+2,sy*0.288+2 +(i*(sy*0.026)),sx*0.013-4,sy*0.022-4,tocolor(129, 99, 191,255))
                                    end
                                    dxDrawText("✔",sx*0.442,sy*0.288 +(i*(sy*0.026)),0,0,tocolor(255,255,255,255),0.00033*sx,cache.roboto)


                                    dxDrawRectangle(sx*0.456,sy*0.288 +(i*(sy*0.026)),sx*0.013,sy*0.022,tocolor(20,20,20,255))
                                    if isInSlot(sx*0.456,sy*0.288 +(i*(sy*0.026)),sx*0.013,sy*0.022) then
                                        dxDrawRectangle(sx*0.456+2,sy*0.288+2 +(i*(sy*0.026)),sx*0.013-4,sy*0.022-4,tocolor(129, 99, 191,255))
                                    end
                                    dxDrawImage(sx*0.4588,sy*0.2926 +(i*(sy*0.026)),sx*0.007,sy*0.012,"files/cancel.png")

                                    dxDrawRectangle(sx*0.359 +textwidth,sy*0.292 +(i*(sy*0.026)),1,sy*0.014,tocolor(255,255,255,alpha))
                                else
                                    dxDrawText(rankname,sx*0.357,sy*0.2896 +(i*(sy*0.026)),0,0,tocolor(255,255,255,255),0.00029*sx,cache.roboto)
                                end

                                dxDrawRectangle(sx*0.471,sy*0.288 +(i*(sy*0.026)),sx*0.028,sy*0.022,tocolor(20,20,20,255))

                                dxDrawText("$",sx*0.503,sy*0.2896 +(i*(sy*0.026)),0,0,tocolor(255,255,255,255),0.00029*sx,cache.roboto)

                                if cache.group.editwage == i then
                                    local guiText = guiGetText(cache.group.gui);

                                    if guiEditSetCaretIndex(cache.group.gui, string.len(guiGetText(cache.group.gui))) then
                                        guiBringToFront(cache.group.gui)

                                    end
                                    dxDrawText(formatMoney(guiText),sx*0.474,sy*0.2896 +(i*(sy*0.026)),0,0,tocolor(255,255,255,255),0.00029*sx,cache.roboto)
                                    local textwidth = dxGetTextWidth(formatMoney(guiText),0.00029*sx,cache.roboto)
                                    dxDrawRectangle(sx*0.476 +textwidth,sy*0.292 +(i*(sy*0.026)),1,sy*0.014,tocolor(255,255,255,alpha))

                                    dxDrawRectangle(sx*0.511,sy*0.288 +(i*(sy*0.026)),sx*0.013,sy*0.022,tocolor(20,20,20,255))
                                    if isInSlot(sx*0.511,sy*0.288 +(i*(sy*0.026)),sx*0.013,sy*0.022) then
                                        dxDrawRectangle(sx*0.511+2,sy*0.288+2 +(i*(sy*0.026)),sx*0.013-4,sy*0.022-4,tocolor(129, 99, 191,255))
                                    end
                                    dxDrawText("✔",sx*0.512,sy*0.288 +(i*(sy*0.026)),0,0,tocolor(255,255,255,255),0.00033*sx,cache.roboto)


                                    dxDrawRectangle(sx*0.526,sy*0.288 +(i*(sy*0.026)),sx*0.013,sy*0.022,tocolor(20,20,20,255))
                                    if isInSlot(sx*0.526,sy*0.288 +(i*(sy*0.026)),sx*0.013,sy*0.022) then
                                        dxDrawRectangle(sx*0.526+2,sy*0.288+2 +(i*(sy*0.026)),sx*0.013-4,sy*0.022-4,tocolor(129, 99, 191,255))
                                    end
                                    dxDrawImage(sx*0.5288,sy*0.2926 +(i*(sy*0.026)),sx*0.007,sy*0.012,"files/cancel.png")
                                else
                                    dxDrawText(formatMoney(wage),sx*0.474,sy*0.2896 +(i*(sy*0.026)),0,0,tocolor(255,255,255,255),0.00029*sx,cache.roboto)
                                end
                            end

                            local isLeader = func.getLeaderByCharid(groupCache[cache.selectedgroup].dbid,getElementData(localPlayer,"player:dbid"));
                            if isLeader then
                                local money = groupCache[cache.selectedgroup].money;
                                dxDrawText("Egyenleg a számlán: #7cc576"..formatMoney(money).." #ffffff$",sx*0.724,sy*0.679,sx*0.724,sy*0.679,tocolor(255,255,255,255),0.00036*sx,cache.roboto,"right","top",false,false,false,true)
                            end
                        elseif cache.grouppage == 3 then
                            dxDrawRectangle(sx*0.3538,sy*0.312,sx*0.117,sy*0.391,tocolor(20,20,20,255))
                            for i = 1,14 do
                                if i % 2 ~= 0 then
                                    dxDrawRectangle(sx*0.3574,sy*0.291+i*sy*0.027,sx*0.11,sy*0.027,tocolor(25,25,25,255))
                                else
                                    dxDrawRectangle(sx*0.3574,sy*0.291+i*sy*0.027,sx*0.11,sy*0.027,tocolor(22,22,22,255))
                                end
                            end

                            if groupVehicles[groupCache[cache.selectedgroup].dbid] then
                                local count = 0;
                                
                                for k,v in ipairs(groupVehicles[groupCache[cache.selectedgroup].dbid]) do
                                    if k > cache.group.vehwheel and count < 14 then
                                        count = count+1;
                                        if isInSlot(sx*0.3574,sy*0.292+(count*sy*0.027),sx*0.11,sy*0.027) or cache.group.selectedveh == k then
                                            dxDrawRectangle(sx*0.3574+2,sy*0.292+2+(count*sy*0.027),sx*0.11-4,sy*0.027-4,tocolor(129, 99, 191)) 
                                        end

                                        dxDrawText(v.name,sx*0.4125,sy*0.3045+(count*sy*0.027),sx*0.4125,sy*0.3045+(count*sy*0.027),tocolor(255,255,255,255),0.00029*sx,cache.roboto,"center","center")
                                    end
                                end

                                if cache.group.selectedveh > 0 then
                                    local name = groupVehicles[groupCache[cache.selectedgroup].dbid][cache.group.selectedveh].name;
                                    local dbid = groupVehicles[groupCache[cache.selectedgroup].dbid][cache.group.selectedveh].dbid;
                                    dxDrawText(name,sx*0.603,sy*0.341,sx*0.603,sy*0.341,tocolor(129, 99, 191,255),0.00062*sx,cache.sfpro,"center","center")
                                    dxDrawText("Azonosító: #8163bf"..dbid,sx*0.476,sy*0.38,0,0,tocolor(255,255,255,255),0.00034*sx,cache.roboto,"left","top",false,false,false,true)
                                    
                                    local health = 100;
                                    dxDrawText("Állapot: #8163bf"..health.."#ffffff %",sx*0.476,sy*0.4,0,0,tocolor(255,255,255,255),0.00034*sx,cache.roboto,"left","top",false,false,false,true)
                                    if isInSlot(sx*0.476,sy*0.42,sx*0.09-4,sy*0.026-4) then
									    dxDrawRectangle(sx*0.476,sy*0.42,sx*0.09-4,sy*0.026-4,tocolor(129, 99, 191,255))
                                    else
									    dxDrawRectangle(sx*0.476,sy*0.42,sx*0.09-4,sy*0.026-4,tocolor(35,35,35,255))
                                    end									
									dxDrawText("Jármű kulcs adás",sx*0.476,sy*0.42,0,0,tocolor(255,255,255,255),0.00034*sx,cache.roboto,"left","top",false,false,false,true)
                                end
                            end
                        elseif cache.grouppage == 4 then
                            for k,v in ipairs(cache.group.settingbuttons) do
                                dxDrawRectangle(sx*0.2596 + (k*(sx*0.094)),sy*0.312,sx*0.09,sy*0.026,tocolor(20,20,20,255))
                                if isInSlot(sx*0.2596 + (k*(sx*0.094)),sy*0.312,sx*0.09,sy*0.026) or cache.group.selectedsetting == k then
                                    dxDrawRectangle(sx*0.2596+2 + (k*(sx*0.094)),sy*0.312+2,sx*0.09-4,sy*0.026-4,tocolor(129, 99, 191,255))
                                end
                                
                                dxDrawText(v,sx*0.3053 + (k*(sx*0.094)),sy*0.325,sx*0.3053 + (k*(sx*0.094)),sy*0.325,tocolor(255,255,255,255),0.00029*sx,cache.roboto,"center","center")
                            end

                            if cache.group.selectedsetting == 1 then
                                local isLeader = func.getLeaderByCharid(groupCache[cache.selectedgroup].dbid,getElementData(localPlayer,"player:dbid"));
                                if isLeader then
                                    dxDrawText("Pénzügyek kezelése",sx*0.540,sy*0.378,sx*0.540,sy*0.378,tocolor(255,255,255,255),0.00054*sx,cache.sfpro,"center","center")

                                    dxDrawRectangle(sx*0.507,sy*0.422,sx*0.106,sy*0.029,tocolor(20,20,20,255))
                                    dxDrawText("Összeg:",sx*0.469,sy*0.424,0,0,tocolor(255,255,255,255),0.00035*sx,cache.roboto)

                                    local amount = guiGetText(cache.group.bankgui);
                                    dxDrawText(formatMoney(amount),sx*0.510,sy*0.4255,0,0,tocolor(255,255,255,255),0.00035*sx,cache.roboto)
                                    if cache.group.edit.moneygui then
                                        dxDrawRectangle(sx*0.5125 + dxGetTextWidth(formatMoney(amount),0.00035*sx,cache.roboto),sy*0.428,1,sy*0.017,tocolor(255,255,255,alpha))
                                    end

                                    for k,v in ipairs(cache.group.moneybuttons) do
                                        dxDrawRectangle(sx*0.2145 + (k*(sx*0.17)),sy*0.482,sx*0.14,sy*0.046,tocolor(20,20,20,255))
                                        if isInSlot(sx*0.2145 + (k*(sx*0.17)),sy*0.482,sx*0.14,sy*0.046) then
                                            dxDrawRectangle(sx*0.2145+2 + (k*(sx*0.17)),sy*0.482+2,sx*0.14-4,sy*0.046-4,tocolor(129, 99, 191,255))
                                        end
                                        dxDrawText(v,sx*0.284 + (k*(sx*0.17)),sy*0.503,sx*0.284 + (k*(sx*0.17)),sy*0.503,tocolor(255,255,255,255),0.00038*sx,cache.sfpro,"center","center")
                                    end

                                    dxDrawText("Eddigi történések:",sx*0.3525,sy*0.548,0,0,tocolor(255,255,255,255),0.0003*sx,cache.sfpro)
                                    dxDrawRectangle(sx*0.3501,sy*0.572,sx*0.38,1,tocolor(129, 99, 191,255))
                                
                                    local count = 0;
                                    for k,v in ipairs(transactionCache[groupCache[cache.selectedgroup].dbid]) do
                                        if k > cache.group.transactionwheel and count < 6 then
                                            count = count+1;
                                            dxDrawText(v[1].."#ffffff "..v[2].." #7cc576"..formatMoney(v[3]).." #ffffff dollárt. - #8163bf"..v[4],sx*0.3525,sy*0.5565 + ((count*(sy*0.021))),0,0,tocolor(129, 99, 191,255),0.00036*sx,cache.roboto,"left","top",false,false,false,true)
                                        end
                                    end
                                    if count == 0 then
                                        dxDrawText("Eddig nem történt tranzakció.",sx*0.3525,sy*0.5565 + ((1*(sy*0.021))),0,0,tocolor(255,255,255,255),0.00036*sx,cache.roboto,"left","top",false,false,false,true)
                                    end
                                end
                            elseif cache.group.selectedsetting == 2 then
                                dxDrawRectangle(sx*0.3538,sy*0.343,sx*0.117,sy*0.363,tocolor(20,20,20,255))
                                for i = 1,13 do
                                    
                                        if i % 2 ~= 0 then
                                            dxDrawRectangle(sx*0.3574,sy*0.322+i*sy*0.027,sx*0.11,sy*0.027,tocolor(25,25,25,255))
                                        else
                                            dxDrawRectangle(sx*0.3574,sy*0.322+i*sy*0.027,sx*0.11,sy*0.027,tocolor(22,22,22,255))
                                        end
                                end

                                if dutySkins[groupCache[cache.selectedgroup].dbid] then
                                    local count = 0;
                                    for k,v in ipairs(dutySkins[groupCache[cache.selectedgroup].dbid]) do
                                        if k > cache.group.skinwheel and count < 13 then
                                            count = count+1;
                                            if isInSlot(sx*0.3574,sy*0.322+count*sy*0.027,sx*0.11,sy*0.027) or cache.group.selectedskin == k then
                                                dxDrawRectangle(sx*0.3574+2,sy*0.322+2+count*sy*0.027,sx*0.11-4,sy*0.027-4,tocolor(129, 99, 191,255))
                                            end
                                            dxDrawText(v.name,sx*0.4125,sy*0.335+(count*sy*0.027),sx*0.4125,sy*0.335+(count*sy*0.027),tocolor(255,255,255,255),0.00029*sx,cache.roboto,"center","center")
                                        end
                                    end
                                else
                                    dxDrawText("A szervezetnek jelenleg",sx*0.4125,sy*0.335+(1*sy*0.027),sx*0.4125,sy*0.335+(1*sy*0.027),tocolor(255,255,255,255),0.00029*sx,cache.roboto,"center","center")
                                    dxDrawText("nincsenek skinjei.",sx*0.4125,sy*0.335+(2*sy*0.027),sx*0.4125,sy*0.335+(2*sy*0.027),tocolor(255,255,255,255),0.00029*sx,cache.roboto,"center","center")
                                end

                                if cache.group.selectedskin > 0 then
                                    dxDrawRectangle(sx*0.4745,sy*0.676,sx*0.095,sy*0.03,tocolor(20,20,20,255))
                                    if isInSlot(sx*0.4745,sy*0.676,sx*0.095,sy*0.03) then
                                        dxDrawRectangle(sx*0.4745+2,sy*0.676+2,sx*0.095-4,sy*0.03-4,tocolor(129, 99, 191,255))
                                    end
                                    dxDrawText("Duty skin beállítása",sx*0.4815,sy*0.68,0,0,tocolor(255,255,255,255),0.00034*sx,cache.roboto)
                                end
                            elseif cache.group.selectedsetting == 3 then
                                for i = 1,15 do
                                    local rankname = groupCache[cache.selectedgroup].ranks[i][1];
                                    local textwidth = dxGetTextWidth(rankname,0.00029*sx,cache.roboto)
                                    
                                    if isInSlot(sx*0.39 -textwidth/2,sy*0.322 +(i*(sy*0.024)),textwidth,sy*0.018) or cache.group.selectedsettingrank == i then
                                        dxDrawText(rankname,sx*0.39,sy*0.33 +(i*(sy*0.024)),sx*0.39,sy*0.33 +(i*(sy*0.024)),tocolor(129, 99, 191,255),0.00029*sx,cache.roboto,"center","center")
                                    else
                                        dxDrawText(rankname,sx*0.39,sy*0.33 +(i*(sy*0.024)),sx*0.39,sy*0.33 +(i*(sy*0.024)),tocolor(255,255,255,255),0.00029*sx,cache.roboto,"center","center")
                                    end

                                end

                                if cache.group.selectedsettingrank > 0 then
                                    local count = 0;
                                    local groupid = groupCache[cache.selectedgroup].dbid;
                                    
                                    dxDrawText(groupCache[cache.selectedgroup].ranks[cache.group.selectedsettingrank][1].." - tárgyai",sx*0.56,sy*0.36,sx*0.56,sy*0.36,tocolor(129, 99, 191,255),0.00049*sx,cache.sfpro,"center","center")
                                    
                                    for k,data in pairs(groupItems[groupid][cache.group.selectedsettingrank]) do
                                        local name = exports.inventory:getItemName(data.item);
                                        if data.count > 1 then
                                            name = name.."("..data.count..")"
                                        end
                                        dxDrawText(name,sx*0.51,sy*0.39 +(count*(sy*0.023)),sx*0.51,sy*0.39 +(count*(sy*0.023)),tocolor(255,255,255,255),0.00029*sx,cache.roboto,"right","top")
                                        --dxDrawRectangle(sx*0.52,sy*0.39 +(count*(sy*0.023)),sx*0.008,sy*0.0150,tocolor(0,0,0,120))
                                        func.border(sx*0.514,sy*0.394 +(count*(sy*0.023)),sx*0.006,sy*0.0110,1,tocolor(0,0,0,120))
                                        if isInSlot(sx*0.514,sy*0.394 +(count*(sy*0.023)),sx*0.006,sy*0.0110) then
                                            dxDrawRectangle(sx*0.514,sy*0.394 +(count*(sy*0.023)),sx*0.006,sy*0.0110,tocolor(129, 99, 191,255))
                                        end
                                        if data.equip then
                                            dxDrawImage(sx*0.514,sy*0.394 +(count*(sy*0.023)),sx*0.006,sy*0.0110,"files/check.png")
                                        end

                                        if isInSlot(sx*0.524,sy*0.394 +(count*(sy*0.023)),sx*0.006,sy*0.0110) then
                                            dxDrawImage(sx*0.524,sy*0.394 +(count*(sy*0.023)),sx*0.006,sy*0.0110,"files/cancel.png",0,0,0,tocolor(210,49,49))
                                        else
                                            dxDrawImage(sx*0.524,sy*0.394 +(count*(sy*0.023)),sx*0.006,sy*0.0110,"files/cancel.png")
                                        end

                                        count = count+1;
                                    end

                                    if count == 0 then
                                        dxDrawText("Még Nincs beállítva egyetlen\ntárgy sem. Állítsd be őket.",sx*0.49,sy*0.41 +(count*(sy*0.023)),sx*0.49,sy*0.41 +(count*(sy*0.023)),tocolor(255,255,255,255),0.00029*sx,cache.roboto,"center","center")
                                    end

                                end


                                local isLeader = func.getLeaderByCharid(groupCache[cache.selectedgroup].dbid,getElementData(localPlayer,"player:dbid"));
                                if isLeader then

                                    if cache.group.edit.items then
                                        dxDrawText("Felszerelés beállítás szerkesztése aktív!",sx*0.45,sy*0.651,0,0,tocolor(255,255,255,255),0.00029*sx,cache.roboto,"left","top",true,true,true,true)
                                    end

                                    dxDrawRectangle(sx*0.446,sy*0.677,sx*0.09,sy*0.026,tocolor(20,20,20,255))
                                    if isInSlot(sx*0.446,sy*0.677,sx*0.09,sy*0.026) then
                                        dxDrawRectangle(sx*0.446+2,sy*0.677+2,sx*0.09-4,sy*0.026-4,tocolor(129, 99, 191,255))
                                    end
                                    dxDrawText("Tárgy hozzáadása",sx*0.459,sy*0.68,0,0,tocolor(255,255,255,255),0.00029*sx,cache.roboto)

                                    dxDrawRectangle(sx*0.5399,sy*0.677,sx*0.065,sy*0.026,tocolor(20,20,20,255))
                                    if isInSlot(sx*0.5399,sy*0.677,sx*0.065,sy*0.026) then
                                        dxDrawRectangle(sx*0.5399+2,sy*0.677+2,sx*0.065-4,sy*0.026-4,tocolor(129, 99, 191,255))
                                    end
                                    dxDrawText("Szerkesztés",sx*0.551,sy*0.68,0,0,tocolor(255,255,255,255),0.00029*sx,cache.roboto)

                                    dxDrawRectangle(sx*0.6088,sy*0.677,sx*0.111,sy*0.026,tocolor(20,20,20,255))
                                    if isInSlot(sx*0.6088,sy*0.677,sx*0.111,sy*0.026) then
                                        dxDrawRectangle(sx*0.6088+2,sy*0.677+2,sx*0.111-4,sy*0.026-4,tocolor(129, 99, 191,255))
                                    end
                                    dxDrawText("Változtatások elmentése",sx*0.621,sy*0.68,0,0,tocolor(255,255,255,255),0.00029*sx,cache.roboto)

                                    if cache.group.edit.newitem then
                                        dxDrawRectangle(sx*0.554,sy*0.381,sx*0.166,sy*0.288,tocolor(20,20,20,255))
                                        dxDrawText("Tárgy(ak) hozzáadása",sx*0.58,sy*0.388,0,0,tocolor(255,255,255,255),0.00040*sx,cache.sfpro)


                                        local count = 0;

                                        for k,v in ipairs(availableGroupItems[groupCache[cache.selectedgroup].dbid]) do
                                            if k > cache.group.itemWheel and count < 8 then
                                                count = count+1;

                                                if cache.group.edititem == k then
                                                    local guiText = guiGetText(cache.group.newitemgui);
                                                    if guiEditSetCaretIndex(cache.group.newitemgui, string.len(guiGetText(cache.group.newitemgui))) then
                                                        guiBringToFront(cache.group.newitemgui)
                                                    end

                                                    dxDrawRectangle(sx*0.65,sy*0.389 +(count*(sy*0.031)),sx*0.028,sy*0.024,tocolor(15,15,15,255))
                                                    dxDrawText(guiText,sx*0.653,sy*0.391 +(count*(sy*0.031)),0,0,tocolor(255,255,255,255),0.00031*sx,cache.roboto,"left","top")
                                                    dxDrawRectangle(sx*0.655 +dxGetTextWidth(guiText,0.00031*sx,cache.roboto),sy*0.394 +(count*(sy*0.031)),1,sy*0.013,tocolor(255,255,255,alpha))

                                                    dxDrawRectangle(sx*0.683,sy*0.389 +(count*(sy*0.031)),sx*0.014,sy*0.024,tocolor(15,15,15,255))
                                                    if isInSlot(sx*0.683,sy*0.389 +(count*(sy*0.031)),sx*0.014,sy*0.024) then
                                                        dxDrawRectangle(sx*0.683+2,sy*0.389+2 +(count*(sy*0.031)),sx*0.014-4,sy*0.024-4,tocolor(129, 99, 191,255))
                                                    end
                                                    dxDrawImage(sx*0.685,sy*0.392 +(count*(sy*0.031)),sx*0.010,sy*0.018,"files/check.png")

                                                    dxDrawRectangle(sx*0.701,sy*0.389 +(count*(sy*0.031)),sx*0.014,sy*0.024,tocolor(15,15,15,255))
                                                    if isInSlot(sx*0.701,sy*0.389 +(count*(sy*0.031)),sx*0.014,sy*0.024) then
                                                        dxDrawRectangle(sx*0.701+2,sy*0.389+2 +(count*(sy*0.031)),sx*0.014-4,sy*0.024-4,tocolor(129, 99, 191,255))
                                                    end
                                                    dxDrawImage(sx*0.7035,sy*0.3935 +(count*(sy*0.031)),sx*0.009,sy*0.014,"files/cancel.png")

                                                    dxDrawText(exports.inventory:getItemName(v),sx*0.643,sy*0.390 +(count*(sy*0.031)),sx*0.643,sy*0.390 +(count*(sy*0.031)),tocolor(255,255,255,255),0.00031*sx,cache.roboto,"right","top")

                                                else
                                                    dxDrawRectangle(sx*0.665,sy*0.389 +(count*(sy*0.031)),sx*0.05,sy*0.024,tocolor(15,15,15,255))
                                                    if isInSlot(sx*0.665,sy*0.389 +(count*(sy*0.031)),sx*0.05,sy*0.024) then
                                                        dxDrawRectangle(sx*0.665+2,sy*0.389+2 +(count*(sy*0.031)),sx*0.05-4,sy*0.024-4,tocolor(129, 99, 191,255))
                                                    end
                                                    dxDrawText("Hozzáadás",sx*0.669,sy*0.390 +(count*(sy*0.031)),0,0,tocolor(255,255,255,255),0.00031*sx,cache.roboto)
                                                    dxDrawText(exports.inventory:getItemName(v),sx*0.658,sy*0.390 +(count*(sy*0.031)),sx*0.658,sy*0.390 +(count*(sy*0.031)),tocolor(255,255,255,255),0.00031*sx,cache.roboto,"right","top")
                                                end
                                            end
                                        end
                                    end

                                end
                            end
                        end
                    else
                        for i = 1,12 do

                            local left = sx*0.3515 + drawColumn * (sx*0.18 + 10) + 10;
                            local top = sy*0.280 + drawRow * (sy*0.06 + 10) + 10;

                            dxDrawRectangle(left,top,sx*0.18,sy*0.06,tocolor(20,20,20,255))

                            if groupCache[i] then
                                if isInSlot(left,top,sx*0.18,sy*0.06) then
                                    dxDrawRectangle(left+2,top+2,sx*0.18-4,sy*0.06-4,tocolor(129, 99, 191,255))
                                end
                                dxDrawText(groupCache[i].name,left+sx*0.091,top+sy*0.018,left+sx*0.091,top+sy*0.018,tocolor(255,255,255,255),0.00038*sx,cache.sfpro,"center","center")
                                dxDrawText(cache.typename[groupCache[i].type],left+sx*0.091,top+sy*0.042,left+sx*0.091,top+sy*0.042,tocolor(255,255,255,255),0.00035*sx,cache.roboto,"center","center")
                            end

                            drawColumn = drawColumn + 1;
                            if (drawColumn == 2) then
                                drawColumn = 0;
                                drawRow = drawRow + 1;
                            end
                        end
                    end

                elseif cache.page == "admins" then 
                    dxDrawImage(sx*0.312,sy*0.52,sx*0.028,sy*0.04,cache.admins,0,0,0,tocolor(129, 99, 191,255))

                    dxDrawRectangle(sx*0.365,sy*0.28,sx*0.17,sy*0.3461,tocolor(20,20,20,255))
                    dxDrawRectangle(sx*0.545,sy*0.28,sx*0.17,sy*0.3461,tocolor(20,20,20,255))
                    local admins = #cache.serverAdmins;
                    dxDrawText("Adminisztrátorok",sx*0.5 - 1,sy*0.223 + 1,_,_,tocolor(0,0,0,255),0.00035*sx,cache.sfpro)
                    dxDrawText("Adminisztrátorok",sx*0.5,sy*0.223,_,_,tocolor(255,255,255,255),0.00035*sx,cache.sfpro)
                    dxDrawText("Jelenleg Online: "..admins,sx*0.5375 - 1,sy*0.245 + 1,_,_,tocolor(0,0,0,255),0.00025*sx,cache.roboto,"center")
                    dxDrawText("Jelenleg Online: "..admins,sx*0.5375,sy*0.245,_,_,tocolor(255,255,255,255),0.00025*sx,cache.roboto,"center")

                    for i = 1,7 do 
                        dxDrawRectangle(sx*0.3675,sy*0.2325 + (i*sy*0.052),sx*0.165,sy*0.025,tocolor(22,22,22,255))
                    end 

                    for i = 1,7 do 
                        dxDrawRectangle(sx*0.5475,sy*0.2325 + (i*sy*0.052),sx*0.165,sy*0.025,tocolor(22,22,22,255))
                    end 

                    local admincount = 0;
                            
                    for k,v in ipairs(cache.serverAdmins) do
                        if k > cache.adminwheel and admincount < 13 then
                            admincount = admincount+1;

                            pingColor = "#ffffff"
                            alevel = getElementData(v,"player:admin")

                            if alevel == 1 or alevel == 2 then 
                             prefixColor = "#8163bf"
                            elseif alevel == 3 then 
                             prefixColor = "#8163bf"
                            elseif alevel == 4 then 
                             prefixColor = "#8163bf"
			                elseif alevel == 5 then 
                             prefixColor = "#8163bf"
		                    elseif alevel == 6 then 
                             prefixColor = "#9600ff"
		                    elseif alevel == 7 then 
                             prefixColor = "#ff6d3a"
			                elseif alevel == 8 then 
                             prefixColor = "#028cf6"  
			                elseif alevel == 9 then 
                             prefixColor = "#ff5353"
			                elseif alevel == 10 then 
                             prefixColor = "#44C8ff"
			                elseif alevel == 11 then 
                             prefixColor = "#ff7171"
							else
                             prefixColor = "#8163bf"							  
                            end
                            local prefix = ""
                            if getElementData(v,"player:admin") >= 1 then
                                prefix = exports["Padmin"]:getAdminTitle(alevel)
							else
							    if getElementData(v,"player:helper") == 1 then 
								    prefix = "Ideiglenes Adminsegéd"
							    elseif getElementData(v,"player:helper") == 2 then 
								    prefix = "Adminsegéd"
								end
							end
 
                            local aname = getElementData(v,"player:charname"):gsub("_"," ")
							if getElementData(v,"player:admin") >= 1 then
							    aname = getElementData(v,"player:adminname")
							end

                            dxDrawText(prefix,sx*0.445 - 1,sy*0.261+(admincount*sy*0.0262) + 1,sx*0.445,sy*0.261+(admincount*sy*0.0262),tocolor(0,0,0,255),0.00026*sx,cache.roboto,"center","top",false,false,false,true)
                            dxDrawText(prefixColor..prefix,sx*0.445,sy*0.261+(admincount*sy*0.0262),sx*0.445,sy*0.261+(admincount*sy*0.0262),tocolor(255,255,255,255),0.00026*sx,cache.roboto,"center","top",false,false,false,true)
                            dxDrawText(aname,sx*0.55 - 1,sy*0.261+(admincount*sy*0.0262) + 1,sx*0.445,sy*0.261+(admincount*sy*0.0262),tocolor(0,0,2055,255),0.00026*sx,cache.roboto,"left","top",false,false,false,true)
                            dxDrawText(prefixColor..aname,sx*0.55,sy*0.261+(admincount*sy*0.0262),sx*0.445,sy*0.261+(admincount*sy*0.0262),tocolor(255,255,255,255),0.00026*sx,cache.roboto,"left","top",false,false,false,true)
                            dxDrawText("ID: "..getElementData(v,"player:id"),sx*0.711 - 1,sy*0.261+(admincount*sy*0.0262) + 1,sx*0.711,sy*0.261+(admincount*sy*0.0262),tocolor(0,0,0,255),0.00026*sx,cache.roboto,"right","top",false,false,false,true)
                            dxDrawText(prefixColor.."ID: "..getElementData(v,"player:id"),sx*0.711,sy*0.261+(admincount*sy*0.0262),sx*0.711,sy*0.261+(admincount*sy*0.0262),tocolor(255,255,255,255),0.00026*sx,cache.roboto,"right","top",false,false,false,true)
                        end
                    end

                    dxDrawText("Az adminisztrátorokkal való kapcsolat felvételhez használd a /pm parancsot.\nÜgyelj arra hogy mindig a lehető legérthetőbb és legrövidebb módon fogalmazz.",sx*0.5375 - 1,sy*0.65 + 1,_,_,tocolor(0,0,0,255),0.00025*sx,cache.roboto,"center")
                    dxDrawText("Az adminisztrátorokkal való kapcsolat felvételhez használd a /pm parancsot.\nÜgyelj arra hogy mindig a lehető legérthetőbb és legrövidebb módon fogalmazz.",sx*0.5375,sy*0.65,_,_,tocolor(255,255,255,255),0.00025*sx,cache.roboto,"center")

                elseif cache.page == "settings" then 
                    dxDrawImage(sx*0.312,sy*0.6,sx*0.028,sy*0.04,cache.settings,0,0,0,tocolor(129, 99, 191,255))
                    dxDrawText("Beállítások",sx*0.514 - 1,sy*0.223 + 1,_,_,tocolor(0,0,0,255),0.00035*sx,cache.sfpro)
                    dxDrawText("Beállítások",sx*0.514,sy*0.223,_,_,tocolor(255,255,255,255),0.00035*sx,cache.sfpro)

                    dxDrawRectangle(sx*0.365,sy*0.265,sx*0.17,sy*0.215,tocolor(20,20,20,255))
                    dxDrawRectangle(sx*0.545,sy*0.265,sx*0.17,sy*0.404,tocolor(20,20,20,255))

                    dxDrawRectangle(sx*0.365,sy*0.5,sx*0.17,sy*0.169,tocolor(20,20,20,255))

                    if isInSlot(sx*0.47,sy*0.68,sx*0.14,sy*0.02) then 
                        dxDrawText("Alapértelmezett beállítások visszaállítása",sx*0.47 - 1,sy*0.68 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto)
                        dxDrawText("Alapértelmezett beállítások visszaállítása",sx*0.47,sy*0.68,_,_,tocolor(129, 99, 191,255),0.00028*sx,cache.roboto)
                    else 
                        dxDrawText("Alapértelmezett beállítások visszaállítása",sx*0.47 - 1,sy*0.68 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto)
                        dxDrawText("Alapértelmezett beállítások visszaállítása",sx*0.47,sy*0.68,_,_,tocolor(255,255,255,255),0.00028*sx,cache.roboto)
                    end 

                    for i = 1,4 do 
                        dxDrawRectangle(sx*0.3675,sy*0.22 + (i*sy*0.052),sx*0.165,sy*0.025,tocolor(22,22,22,255))
                    end 

                    for i = 1,7 do 
                        dxDrawRectangle(sx*0.5475,sy*0.246 + (i*sy*0.052),sx*0.165,sy*0.025,tocolor(22,22,22,255))
                    end 

                    --[[setting = {
                        ["bloom"] = {false},
                        ["contrast"] = {false},
                        ["motionblur"] = {false},
                        ["vehicleshader"] = {false},
                        ["betterwater"] = {false},
                        ["noise"] = {false},
                        ["bettertexture"] = {false},
                    }]]

                    settingX = sx*0.37
                    settingX2 = sx*0.53

                    dxDrawText("Bloom",settingX - 1,sy*0.275 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto,"left")
                    dxDrawText("Bloom",settingX,sy*0.275,_,_,tocolor(255,255,255,255),0.00028*sx,cache.roboto,"left")

                    if cache.setting["bloom"][1] == false then 
                    dxDrawText("Kikapcsolva",settingX2 - 1,sy*0.275 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto,"right")
                    dxDrawText("Kikapcsolva",settingX2,sy*0.275,_,_,tocolor(129, 99, 191,255),0.00028*sx,cache.roboto,"right")
                    else 
                    dxDrawText("Bekapcsolva",settingX2 - 1,sy*0.275 + 1,_,_,tocolor(0, 0, 0,255),0.00028*sx,cache.roboto,"right")
                    dxDrawText("Bekapcsolva",settingX2,sy*0.275,_,_,tocolor(129, 99, 191,255),0.00028*sx,cache.roboto,"right")
                    end 

                    dxDrawText("Vignetta",settingX - 1,sy*0.3007 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto,"left")
                    dxDrawText("Vignetta",settingX,sy*0.3007,_,_,tocolor(255,255,255,255),0.00028*sx,cache.roboto,"left")

                    if cache.setting["vignette"][1] == false then 
                    dxDrawText("Kikapcsolva",settingX2 - 1,sy*0.3007 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto,"right")
                    dxDrawText("Kikapcsolva",settingX2,sy*0.3007,_,_,tocolor(129, 99, 191,255),0.00028*sx,cache.roboto,"right")
                    else 
                    dxDrawText("Bekapcsolva",settingX2 - 1,sy*0.3007 + 1,_,_,tocolor(0, 0, 0,255),0.00028*sx,cache.roboto,"right")
                    dxDrawText("Bekapcsolva",settingX2,sy*0.3007,_,_,tocolor(129, 99, 191,255),0.00028*sx,cache.roboto,"right")
                    end 

                    dxDrawText("Mozgási Elmosódás",settingX - 1,sy*0.327 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto,"left")
                    dxDrawText("Mozgási Elmosódás",settingX,sy*0.327,_,_,tocolor(255,255,255,255),0.00028*sx,cache.roboto,"left")

                    if cache.setting["motionblur"][1] == false then 
                    dxDrawText("Kikapcsolva",settingX2 - 1,sy*0.327 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto,"right")
                    dxDrawText("Kikapcsolva",settingX2,sy*0.327,_,_,tocolor(129, 99, 191,255),0.00028*sx,cache.roboto,"right")
                    else 
                    dxDrawText("Bekapcsolva",settingX2 - 1,sy*0.327 + 1,_,_,tocolor(0, 0, 0,255),0.00028*sx,cache.roboto,"right")
                    dxDrawText("Bekapcsolva",settingX2,sy*0.327,_,_,tocolor(129, 99, 191,255),0.00028*sx,cache.roboto,"right")
                    end 

                    dxDrawText("Jármű tükröződés",settingX - 1,sy*0.354 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto,"left")
                    dxDrawText("Jármű tükröződés",settingX,sy*0.354,_,_,tocolor(255,255,255,255),0.00028*sx,cache.roboto,"left")

                    if cache.setting["vehicleshader"][1] == false then 
                    dxDrawText("Kikapcsolva",settingX2 - 1,sy*0.354 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto,"right")
                    dxDrawText("Kikapcsolva",settingX2,sy*0.354,_,_,tocolor(129, 99, 191,255),0.00028*sx,cache.roboto,"right")
                    else 
                    dxDrawText("Bekapcsolva",settingX2 - 1,sy*0.354 + 1,_,_,tocolor(0, 0, 0,255),0.00028*sx,cache.roboto,"right")
                    dxDrawText("Bekapcsolva",settingX2,sy*0.354,_,_,tocolor(129, 99, 191,255),0.00028*sx,cache.roboto,"right")
                    end 

                    dxDrawText("Szebb víz",settingX - 1,sy*0.38 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto,"left")
                    dxDrawText("Szebb víz",settingX,sy*0.38,_,_,tocolor(255,255,255,255),0.00028*sx,cache.roboto,"left")

                    if cache.setting["betterwater"][1] == false then 
                    dxDrawText("Kikapcsolva",settingX2 - 1,sy*0.38 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto,"right")
                    dxDrawText("Kikapcsolva",settingX2,sy*0.38,_,_,tocolor(129, 99, 191,255),0.00028*sx,cache.roboto,"right")
                    else 
                    dxDrawText("Bekapcsolva",settingX2 - 1,sy*0.38 + 1,_,_,tocolor(0, 0, 0,255),0.00028*sx,cache.roboto,"right")
                    dxDrawText("Bekapcsolva",settingX2,sy*0.38,_,_,tocolor(129, 99, 191,255),0.00028*sx,cache.roboto,"right")
                    end 

                    dxDrawText("Szemcsézés",settingX - 1,sy*0.406 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto,"left")
                    dxDrawText("Szemcsézés",settingX,sy*0.406,_,_,tocolor(255,255,255,255),0.00028*sx,cache.roboto,"left")

                    if cache.setting["noise"][1] == false then 
                    dxDrawText("Kikapcsolva",settingX2 - 1,sy*0.406 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto,"right")
                    dxDrawText("Kikapcsolva",settingX2,sy*0.406,_,_,tocolor(129, 99, 191,255),0.00028*sx,cache.roboto,"right")
                    else 
                    dxDrawText("Bekapcsolva",settingX2 - 1,sy*0.406 + 1,_,_,tocolor(0, 0, 0,255),0.00028*sx,cache.roboto,"right")
                    dxDrawText("Bekapcsolva",settingX2,sy*0.406,_,_,tocolor(129, 99, 191,255),0.00028*sx,cache.roboto,"right")
                    end 

                    dxDrawText("Szebb textúra",settingX - 1,sy*0.432 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto,"left")
                    dxDrawText("Szebb textúra",settingX,sy*0.432,_,_,tocolor(255,255,255,255),0.00028*sx,cache.roboto,"left")

                    if cache.setting["bettertexture"][1] == false then 
                    dxDrawText("Kikapcsolva",settingX2 - 1,sy*0.432 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto,"right")
                    dxDrawText("Kikapcsolva",settingX2,sy*0.432,_,_,tocolor(129, 99, 191,255),0.00028*sx,cache.roboto,"right")
                    else 
                    dxDrawText("Bekapcsolva",settingX2 - 1,sy*0.432 + 1,_,_,tocolor(0, 0, 0,255),0.00028*sx,cache.roboto,"right")
                    dxDrawText("Bekapcsolva",settingX2,sy*0.432,_,_,tocolor(129, 99, 191,255),0.00028*sx,cache.roboto,"right")
                    end 

                    dxDrawText("Harcstílus",settingX - 1,sy*0.458 + 1,_,_,tocolor(0,0,0,255),0.00028*sx,cache.roboto,"left")
                    dxDrawText("Harcstílus",settingX,sy*0.458,_,_,tocolor(255,255,255,255),0.00028*sx,cache.roboto,"left")

                    dxDrawText(fightstyles[getPedFightingStyle(localPlayer)][1],settingX2 - 1,sy*0.458 + 1,_,_,tocolor(0, 0, 0,255),0.00028*sx,cache.roboto,"right")
                    dxDrawText(fightstyles[getPedFightingStyle(localPlayer)][1],settingX2,sy*0.458,_,_,tocolor(129, 99, 191,255),0.00028*sx,cache.roboto,"right")

                    dxDrawText("Sétastílusok",sx*0.601 - 1,sy*0.27 + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.sfpro)
                    dxDrawText("Sétastílusok",sx*0.601,sy*0.27,_,_,tocolor(255,255,255,255),0.0003*sx,cache.sfpro)

                    dxDrawText("Célkeresztek",sx*0.421 - 1,sy*0.505 + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.sfpro)
                    dxDrawText("Célkeresztek",sx*0.421,sy*0.505,_,_,tocolor(255,255,255,255),0.0003*sx,cache.sfpro)

                    walkStyles = sx*0.55
                    walkStyles2 = sx*0.71

                    for k,v in pairs(walkstyles) do 
                        dxDrawText(v[1],walkStyles,sy*0.276 + (k*sy*0.0262),_,_,tocolor(255,255,255,255),0.00028*sx,cache.roboto,"left","top")

                        --dxDrawRectangle(sx*0.668,sy*0.274 + (k*sy*0.0262),sx*0.045,sy*0.023,tocolor(0,0,0,150))

                        if getPedWalkingStyle(localPlayer) == v[2] then 
                        dxDrawText("Kiválasztva",walkStyles2 - 1,sy*0.276 + (k*sy*0.0262) + 1,_,_,tocolor(0, 0, 0,255),0.00028*sx,cache.roboto,"right","top")
                        dxDrawText("Kiválasztva",walkStyles2,sy*0.276 + (k*sy*0.0262),_,_,tocolor(158, 242, 117,255),0.00028*sx,cache.roboto,"right","top")
                        else 
                        dxDrawText("Kiválasztás",walkStyles2 - 1,sy*0.276 + (k*sy*0.0262) + 1,_,_,tocolor(0, 0, 0,255),0.00028*sx,cache.roboto,"right","top")
                        dxDrawText("Kiválasztás",walkStyles2,sy*0.276 + (k*sy*0.0262),_,_,tocolor(129, 99, 191,255),0.00028*sx,cache.roboto,"right","top")
                        end 
                    end 

                    dxDrawImage(sx*0.42,sy*0.545,sx*0.0520833333333333,sy*0.09,"crosshairs/allcrosshair/"..cache.crosshair..".png")

                    if isInSlot(sx*0.49,sy*0.575,sx*0.01,sy*0.03) then 
                    dxDrawText("",sx*0.49 - 1,sy*0.575 + 1,_,_,tocolor(0,0,0,255),0.0005*sx,cache.fonticonasd,"left","top")
                    dxDrawText("",sx*0.49,sy*0.575,_,_,tocolor(129, 99, 191,255),0.0005*sx,cache.fonticonasd,"left","top")
                    else 
                    dxDrawText("",sx*0.49 - 1,sy*0.575 + 1,_,_,tocolor(0,0,0,255),0.0005*sx,cache.fonticonasd,"left","top")
                    dxDrawText("",sx*0.49,sy*0.575,_,_,tocolor(255,255,255,255),0.0005*sx,cache.fonticonasd,"left","top")
                    end 

                    if isInSlot(sx*0.395,sy*0.575,sx*0.01,sy*0.03) then 
                    dxDrawText("",sx*0.395 - 1,sy*0.575 + 1,_,_,tocolor(0,0,0,255),0.0005*sx,cache.fonticonasd,"left","top")
                    dxDrawText("",sx*0.395,sy*0.575,_,_,tocolor(129, 99, 191,255),0.0005*sx,cache.fonticonasd,"left","top")
                    else
                    dxDrawText("",sx*0.395 - 1,sy*0.575 + 1,_,_,tocolor(0,0,0,255),0.0005*sx,cache.fonticonasd,"left","top")
                    dxDrawText("",sx*0.395,sy*0.575,_,_,tocolor(255,255,255,255),0.0005*sx,cache.fonticonasd,"left","top")
                    end

                end 
        end
end 


local createdPed = false

addEventHandler("onClientKey",root,function(button,state)
    if getElementData(localPlayer,"player:loggedIn") then 
    if button == "home" and state then 
        if not show then 
        --    if groupCache then
        --       for k,v in pairs(groupCache) do
        --            triggerServerEvent("refreshGroupMembersData",localPlayer,v.dbid,localPlayer);
        --        end
        --    end

            if cache.page == "mydatas" then 
                myped = createPed(getElementModel(localPlayer),0,0,1000)
                setElementData(myped,"nohaveNametag",true)
                ped = exports["object_preview"]:createObjectPreview(myped, 0,0,180, sx*0.51,sy*0.35,sx*0.15,sy*0.4,false,true)
                createdPed = true 
            end 


            if cache.selectedgroup > 0 then
                local groupid = groupCache[cache.selectedgroup].dbid;
                groupVehicles[groupid] = {};
            
                for vehicle,k in pairs(vehicleCache) do
                    if getElementData(vehicle,"vehicle:group") == groupid then
                        groupVehicles[groupid][#groupVehicles[groupid]+1] = {
                            dbid = getElementData(vehicle,"vehicle:dbid");
                            name = exports.Pmods:getVehName(vehicle);
                            element = vehicle;
                        };
                    end
                end
            end

            cache.playerVehicles = {};
            cache.playerInteriors = {};
            cache.serverAdmins = {};
            if getElementData(localPlayer,"player:dbid") > 0 then
                for k,vehicle in ipairs(getElementsByType("vehicle")) do
                    if getElementData(vehicle,"vehicle:dbid") and getElementData(vehicle,"vehicle:owner") == getElementData(localPlayer,"player:dbid") then
                        cache.playerVehicles[#cache.playerVehicles+1 ] = vehicle;
                    end
                end

                for k,interior in ipairs(getElementsByType("pickup")) do
                    if getElementData(interior,"int:in") and getElementData(localPlayer,"player:dbid") == getElementData(interior,"int:owner") then 
                        cache.playerInteriors[#cache.playerInteriors+1] = interior;
                    end
                end
                
                for k,player in ipairs(getElementsByType("player")) do
                    if getElementData(player,"player:adminduty") then
                        cache.serverAdmins[#cache.serverAdmins+1] = player;
                    end
                end
				
            end

            blur = exports["blur"]:createBlur("dash", 10)
            setElementData(localPlayer,"player:toghud",true)
            show = true;
            addEventHandler("onClientRender",root,drawDash)
            showChat(false)

        else

            deletePrev()
            show = false;
            removeEventHandler("onClientRender",root,drawDash)
            exports["blur"]:removeBlur("dash")
            setElementData(localPlayer,"player:toghud",false)
            showChat(true)

            if createdPed then 
                exports["object_preview"]:destroyObjectPreview(myped)
                setElementPosition(myped,0,0,0)
                destroyElement(myped)
                createdPed = false
            end

        end
        cancelEvent()
        
    end 
    end
end)

function onClientClick ( button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement )
    if show then
        if button == "left" and state == "down" then 

            if isInSlot(sx*0.312,sy*0.31,sx*0.028,sy*0.04) then 
                if cache.page ~= "mydatas" then
                    cache.page = "mydatas"
                    deletePrev()

                    if not createdPed then 
                        myped = createPed(getElementModel(localPlayer),0,0,1000)
                        setElementData(myped,"nohaveNametag",true)
                        ped = exports["object_preview"]:createObjectPreview(myped, 0,0,180, sx*0.51,sy*0.35,sx*0.15,sy*0.4,false,true)
                        createdPed = true 
                    end

                end
            elseif isInSlot(sx*0.312,sy*0.38,sx*0.028,sy*0.04) then 
                if cache.page ~= "own" then
                    cache.page = "own"
                    cache.intwheel = 0 
                    cache.ownvehwheel = 0
                    deletePrev()

                    if createdPed then 
                        exports["object_preview"]:destroyObjectPreview(myped)
                        setElementPosition(myped,0,0,0)
                        destroyElement(myped)
                        createdPed = false
                    end

                end
            elseif isInSlot(sx*0.312,sy*0.45,sx*0.028,sy*0.04) then 
                if cache.page ~= "groups" then
                    cache.page = "groups"
                    deletePrev()

                    if createdPed then 
                        exports["object_preview"]:destroyObjectPreview(myped)
                        setElementPosition(myped,0,0,0)
                        destroyElement(myped)
                        createdPed = false
                    end

                end
            elseif isInSlot(sx*0.312,sy*0.52,sx*0.028,sy*0.04) then 
                if cache.page ~= "admins" then
                    cache.page = "admins"
                    cache.adminwheel = 0
                    deletePrev()

                    if createdPed then 
                        exports["object_preview"]:destroyObjectPreview(myped)
                        setElementPosition(myped,0,0,0)
                        destroyElement(myped)
                        createdPed = false
                    end

                end
            elseif isInSlot(sx*0.312,sy*0.6,sx*0.028,sy*0.04) then 
                if cache.page ~= "settings" then
                    cache.page = "settings"
                    deletePrev()

                    if createdPed then 
                        exports["object_preview"]:destroyObjectPreview(myped)
                        setElementPosition(myped,0,0,0)
                        destroyElement(myped)
                        createdPed = false
                    end
                end
            end 
             

            if cache.page == "groups" then
                local drawRow = 0;
                local drawColumn = 0;


                if cache.selectedgroup > 0 then
                    if isInSlot(sx*0.6896,sy*0.230,sx*0.03,sy*0.03) then
                        if groupVehicles[groupCache[cache.selectedgroup].dbid] then
                            cache.group.vehwheel = 0;
                            cache.group.selectedveh = -1;
                            groupVehicles[groupCache[cache.selectedgroup].dbid] = {};
                        end
                        cache.selectedgroup = 0;
                        cache.group.tagwheel = 0;
                        cache.group.selected.member = 0;
                        cache.group.newTag = false;
                        cache.group.tagtext = "";
                        cache.group.numberChange = false;
                        cache.group.numberText = "";
                        guiSetText(cache.group.gui,"")
                        guiEditSetMaxLength(cache.group.gui,18)
                        cache.group.editrank = -1;
                        cache.group.editwage = -1;
                        cache.group.edititem = -1;
                        cache.group.selectedsetting = 0;
                        cache.group.selectedsettingrank = 1;
                        cache.group.edit.items = false;
                        cache.group.edit.newitem = false;
                        cache.group.edit.moneygui = false;
                        cache.group.itemWheel = 0;
                        cache.group.transactionwheel = 0;
                        cache.group.skinwheel = 0;
                        cache.group.editperms = false;
                        cache.grouppage = 1;
                        deletePrev()
                    end

                    for k,v in ipairs(cache.grouppages) do
                        if isInSlot(sx*0.2596 + (k*(sx*0.094)),sy*0.280,sx*0.09,sy*0.026) then
                            if k == 3 then
                                local groupid = groupCache[cache.selectedgroup].dbid;
                                groupVehicles[groupid] = {};
                            
                                for vehicle,k in pairs(vehicleCache) do
                                    if getElementData(vehicle,"vehicle:group") == groupid then
                                        groupVehicles[groupid][#groupVehicles[groupid]+1] = {
                                            dbid = getElementData(vehicle,"vehicle:dbid");
                                            name = exports.Pmods:getVehName(vehicle);
                                            element = vehicle;
                                        };
                                    end
                                end

                            end
                            cache.grouppage = k;
                            deletePrev()
                        end
                    end
                    
                    if cache.grouppage == 1 then
                        local count = 0;
                        local a = 0;
                        
                        if cache.selectedgroup > 0 then
                        
                            for k,v in pairs(groupMembers[groupCache[cache.selectedgroup].dbid]) do
                                        
                                count = count+1;

                                if count > cache.group.tagwheel and a < 14 then
                                    if isInSlot(sx*0.3574,sy*0.319+(a*sy*0.027),sx*0.11,sy*0.027) then
                                        cache.group.selected.member = v.charid
                                    end

                                    a = a+1;
                                end
                            end
                        end

                        for k,v in ipairs(cache.group.buttons) do
                            local offset1,offset2 = 0,0

                            if k == 5 then
                                offset1,offset2 = 0.008,0.016;
                            else
                                offset1,offset2 = 0,0
                            end
                            
                            if isInSlot(sx*0.482,sy*0.340 +(k*(sy*0.034)),sx*0.10,sy*(0.026+offset2)) then
                                local isLeader = func.getLeaderByCharid(groupCache[cache.selectedgroup].dbid,getElementData(localPlayer,"player:dbid"));
                                if isLeader then
                                    if k == 1 then
                                        if cache.group.selected.member > 0 then

                                            if groupMembers[groupCache[cache.selectedgroup].dbid][cache.group.selected.member].rank < 15 then
                                                groupMembers[groupCache[cache.selectedgroup].dbid][cache.group.selected.member].rank = groupMembers[groupCache[cache.selectedgroup].dbid][cache.group.selected.member].rank+1;
                                                triggerServerEvent("updateMemberRank",localPlayer,groupCache[cache.selectedgroup].dbid,groupMembers[groupCache[cache.selectedgroup].dbid][cache.group.selected.member])
                                            end
                                        end
                                    elseif k == 2 then
                                        if cache.group.selected.member > 0 then
                                            if groupMembers[groupCache[cache.selectedgroup].dbid][cache.group.selected.member].rank > 1 then
                                                groupMembers[groupCache[cache.selectedgroup].dbid][cache.group.selected.member].rank = groupMembers[groupCache[cache.selectedgroup].dbid][cache.group.selected.member].rank-1;
                                                triggerServerEvent("updateMemberRank",localPlayer,groupCache[cache.selectedgroup].dbid,groupMembers[groupCache[cache.selectedgroup].dbid][cache.group.selected.member])
                                            end
                                        end
                                    elseif k == 3 then
                                        if cache.group.selected.member > 0 then
                                            local charid = groupMembers[groupCache[cache.selectedgroup].dbid][cache.group.selected.member].charid;
                                            local state,player = func.getOnline(charid);
                                            if player ~= getLocalPlayer() then
                                                triggerServerEvent("deleteGroupMember",localPlayer,localPlayer,groupCache[cache.selectedgroup].dbid,charid,state,player)
                                                groupMembers[groupCache[cache.selectedgroup].dbid][cache.group.selected.member] = nil;
                                                cache.group.selected.member = 0;
                                            else
                                                exports.Pinfobox:addNotification("Magadat nem tudod kirúgni.","error")
                                            end
                                        end
                                    elseif k == 4 then
                                        if not cache.group.newTag and not cache.group.numberChange then
                                            cache.group.newTag = true;
                                        end
                                    elseif k == 5 then
                                        if not cache.group.numberChange and not cache.group.newTag then
                                            cache.group.numberChange = true;
                                        end
                                    end
                                else
                                    exports.Pinfobox:addNotification("Nincs leader jogosultságod.","error")
                                end
                            end

                            if isInSlot(sx*0.586,sy*0.340 +(k*(sy*0.034)),sx*0.015,sy*0.026) then
                                if cache.group.newTag then
                                    local isLeader = func.getLeaderByCharid(groupCache[cache.selectedgroup].dbid,getElementData(localPlayer,"player:dbid"));
                                    if isLeader then
                                        if #cache.group.tagtext > 0 then
                                            local player = func.findPlayerByText(cache.group.tagtext);
                                            if player then
                                                if player ~= getLocalPlayer() then
                                                    local charid = getElementData(player,"player:dbid");
                                                    if not groupMembers[groupCache[cache.selectedgroup].dbid][charid] then
                                                        --outputChatBox("felvesz")
                                                        triggerServerEvent("addMemberToGroup",localPlayer,groupCache[cache.selectedgroup].dbid,charid,player)
                                                        exports.Pinfobox:addNotification("Sikeresen felvetted "..getElementData(player,"player:charname"):gsub("_", " ").."-t.","success")
                                                        cache.group.newTag = false;
                                                        cache.group.tagtext = "";
                                                    else
                                                        exports.Pinfobox:addNotification("A játékos már tagja ennek a szervezetnek.","error")
                                                    end
                                                else
                                                    exports.Pinfobox:addNotification("Magadat nem tudod felvenni.","error")
                                                end
                                            else
                                                exports.Pinfobox:addNotification("A kiválasztott játékos nem található.","error")
                                            end
                                        end
                                    else
                                        exports.Pinfobox:addNotification("Nincs leader jogosultságod.","error")
                                    end
                                elseif cache.group.numberChange then
                                    local isLeader = func.getLeaderByCharid(groupCache[cache.selectedgroup].dbid,getElementData(localPlayer,"player:dbid"));
                                    if isLeader then
                                        if #cache.group.numberText > 0 then
                                            if cache.group.selected.member > 0 then
                                                local charid = groupMembers[groupCache[cache.selectedgroup].dbid][cache.group.selected.member].charid;
                                                if groupMembers[groupCache[cache.selectedgroup].dbid][charid].cardNumber ~= cache.group.numberText then
                                                    groupMembers[groupCache[cache.selectedgroup].dbid][charid].cardNumber = cache.group.numberText;
                                                    
                                                    triggerServerEvent("changeMemberCardNumber",localPlayer,groupCache[cache.selectedgroup].dbid,charid,cache.group.numberText)
                                                    cache.group.numberChange = false;
                                                    cache.group.numberText = "";
                                                else
                                                    exports.Pinfobox:addNotification("A kiválasztott játékos számlaszáma már be van állítva a megadott számlaszámra.","error")
                                                end
                                            end
                                        end
                                    else
                                        exports.Pinfobox:addNotification("Nincs leader jogosultságod.","error")
                                    end
                                end
                            end

                            if isInSlot(sx*0.606,sy*0.340 +(k*(sy*0.034)),sx*0.015,sy*0.026) then
                                cache.group.newTag = false;
                                cache.group.tagtext = "";
                                cache.group.numberChange = false;
                                cache.group.numberText = "";
                            end

                        end
                    elseif cache.grouppage == 2 then
                        for i = 1,15 do
                            if isInSlot(sx*0.354,sy*0.288 +(i*(sy*0.026)),sx*0.085,sy*0.022) then
                                if cache.group.editrank == -1 and cache.group.editwage == -1 then
                                    local isLeader = func.getLeaderByCharid(groupCache[cache.selectedgroup].dbid,getElementData(localPlayer,"player:dbid"));
                                    if isLeader then
                                        local rankname = groupCache[cache.selectedgroup].ranks[i][1];
                                        guiSetText(cache.group.gui,rankname)
                                        cache.group.editrank = i;
                                    end
                                end
                            end

                            if isInSlot(sx*0.471,sy*0.288 +(i*(sy*0.026)),sx*0.028,sy*0.022) then
                                if cache.group.editrank == -1 and cache.group.editwage == -1 then
                                    local isLeader = func.getLeaderByCharid(groupCache[cache.selectedgroup].dbid,getElementData(localPlayer,"player:dbid"));
                                    if isLeader then
                                        local wage = groupCache[cache.selectedgroup].ranks[i][2];
                                        guiSetText(cache.group.gui,wage)
                                        cache.group.editwage = i;
                                        guiEditSetMaxLength(cache.group.gui,4)
                                    end
                                end
                            end

                            if cache.group.editrank == i then

                                if isInSlot(sx*0.441,sy*0.288 +(i*(sy*0.026)),sx*0.013,sy*0.022) then
                                    local rankname = guiGetText(cache.group.gui);
                                    groupCache[cache.selectedgroup].ranks[i][1] = rankname;
                                    triggerServerEvent("updateGroupData",localPlayer,groupCache[cache.selectedgroup].dbid,"rank",i,rankname)
                                    cache.group.editrank = -1;
                                    guiSetText(cache.group.gui,"");
                                end

                                if isInSlot(sx*0.456,sy*0.288 +(i*(sy*0.026)),sx*0.013,sy*0.022) then
                                    cache.group.editrank = -1;
                                    guiSetText(cache.group.gui,"");
                                end
                            end

                            if cache.group.editwage == i then
                                if isInSlot(sx*0.511,sy*0.288 +(i*(sy*0.026)),sx*0.013,sy*0.022) then
                                    local wage = guiGetText(cache.group.gui);
                                    if #wage > 0 then
                                        wage = tonumber(wage)
                                        --if wage > 0 then
                                            if wage <= 10000 then
                                                groupCache[cache.selectedgroup].ranks[i][2] = wage;
                                                triggerServerEvent("updateGroupData",localPlayer,groupCache[cache.selectedgroup].dbid,"wage",i,wage)
                                                cache.group.editwage = -1;
                                                guiSetText(cache.group.gui,"");
                                                guiEditSetMaxLength(cache.group.gui,18);
                                            else
                                                exports.Pinfobox:addNotification("Beírt összeg nem lehet nagyobb 1.200 dollárnál.","error")
                                            end
                                        --else
                                        --    exports.Pinfobox:addNotification("Beírt összegnek nagyobbnak kell lennie mint 0.","error")
                                        --end
                                    else
                                        exports.Pinfobox:addNotification("Nem maradhat üresen.","error")
                                    end
                                end

                                if isInSlot(sx*0.526,sy*0.288 +(i*(sy*0.026)),sx*0.013,sy*0.022) then
                                    cache.group.editwage = -1;
                                    guiSetText(cache.group.gui,"");
                                    guiEditSetMaxLength(cache.group.gui,18)
                                end
                            end
                        end
                    elseif cache.grouppage == 3 then
                        if cache.selectedgroup > 0 then
                            if groupVehicles[groupCache[cache.selectedgroup].dbid] then
                                local count = 0;

                                for k,v in ipairs(groupVehicles[groupCache[cache.selectedgroup].dbid]) do
                                    if k > cache.group.vehwheel and count < 14 then
                                        count = count+1;
                                        if isInSlot(sx*0.3574,sy*0.292+(count*sy*0.027),sx*0.11,sy*0.027) then
                                            cache.group.selectedveh = k;
                                        end
                                    end
                                end
                                local isLeader = func.getLeaderByCharid(groupCache[cache.selectedgroup].dbid,getElementData(localPlayer,"player:dbid"));
								if cache.group.selectedveh > 0 then
                                    local name = groupVehicles[groupCache[cache.selectedgroup].dbid][cache.group.selectedveh].name;
                                    local dbid = groupVehicles[groupCache[cache.selectedgroup].dbid][cache.group.selectedveh].dbid;                                    
                                    if isInSlot(sx*0.476,sy*0.42,sx*0.09-4,sy*0.026-4) then
								        if isLeader then
									        outputChatBox("#8163bf[xProject]: #ffffffSikeresen adtál kulcsot magadnak a #8163bf"..name.." (ID: "..dbid..")#ffffff járműhöz.",255,255,255,true)
										    triggerServerEvent("giveKey",localPlayer,localPlayer,105,1,dbid)
										else
                                            exports.Pinfobox:addNotification("Nincs leader jogosultságod.","error")										
										end
									end
								end
                            end
                        end
                    elseif cache.grouppage == 4 then
                        for k,v in ipairs(cache.group.settingbuttons) do
                            if isInSlot(sx*0.2596 + (k*(sx*0.094)),sy*0.312,sx*0.09,sy*0.026) then
                                if k == 1 then
                                    local isLeader = func.getLeaderByCharid(groupCache[cache.selectedgroup].dbid,getElementData(localPlayer,"player:dbid"));
                                    if isLeader then
                                        cache.group.selectedsetting = k;
                                        deletePrev()
                                    else
                                        exports.Pinfobox:addNotification("Nincs leader jogosultságod.","error")
                                    end
                                else
                                    cache.group.selectedsetting = k;
                                    deletePrev()
                                end
                            end
                        end

                        if cache.group.selectedsetting == 1 then
                            local isLeader = func.getLeaderByCharid(groupCache[cache.selectedgroup].dbid,getElementData(localPlayer,"player:dbid"));
                            if isLeader then
                                if isInSlot(sx*0.507,sy*0.422,sx*0.106,sy*0.029) then
                                    if guiEditSetCaretIndex(cache.group.bankgui, string.len(guiGetText(cache.group.bankgui))) then
                                        guiBringToFront(cache.group.bankgui)
                                    end
                                    cache.group.edit.moneygui = true;
                                else
                                    cache.group.edit.moneygui = false;
                                end

                                    local amount = guiGetText(cache.group.bankgui);
                                    if #amount > 0 then
                                        amount = tonumber(amount);
                                        if amount > 0 then
                                            for k,v in ipairs(cache.group.moneybuttons) do
                                                if isInSlot(sx*0.2145 + (k*(sx*0.17)),sy*0.482,sx*0.14,sy*0.046) then
                                                    if not isTimer(moneytimer) then
                                                        moneytimer = setTimer(function()

                                                        end,5000,1)
                                                        triggerServerEvent("updateGroupMoneyByLeader",localPlayer,localPlayer,groupCache[cache.selectedgroup].dbid,amount,k)
                                                    else
                                                        exports.Pinfobox:addNotification("Várj egy kicsit.","error")
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                        elseif cache.group.selectedsetting == 2 then
                            if dutySkins[groupCache[cache.selectedgroup].dbid] then
                                local count = 0;
                                for k,v in ipairs(dutySkins[groupCache[cache.selectedgroup].dbid]) do
                                    if k > cache.group.skinwheel and count < 13 then
                                        count = count+1;
                                        if isInSlot(sx*0.3574,sy*0.322+count*sy*0.027,sx*0.11,sy*0.027) then
                                            if cache.group.selectedskin ~= k then
                                                if cache.group.selectedskin == 0 then
                                                    ped = createPed(261,0,0,1000)
                                                    setElementFrozen(ped,true)
                                                    prevElement = exports.object_preview:createObjectPreview(ped, 0,0,180, sx*0.515,sy*0.22,sx*0.18,sy*0.55,false,true)
                                                end
                                                cache.group.selectedskin = k;
                                                setElementModel(ped,v.skin)
                                            end
                                        end
                                    end
                                end

                                if cache.group.selectedskin > 0 then
                                    if isInSlot(sx*0.4745,sy*0.676,sx*0.095,sy*0.03) then
                                            local grouptype = groupCache[cache.selectedgroup].type;
                                            local type = "normal";
                                            if isGroupTypeChangeItem[grouptype] then
                                                type = "duty";
                                            end
                                            triggerServerEvent("setPlayerGroupDutySkin",localPlayer,localPlayer,groupCache[cache.selectedgroup].dbid,getElementData(localPlayer,"player:dbid"),dutySkins[groupCache[cache.selectedgroup].dbid][cache.group.selectedskin].skin,type)
                                            exports.Pinfobox:addNotification("Sikeresen beállítottad az egyenruhád.","success")
                                            deletePrev();
                                    
                                    end
                                end
                            end
                        elseif cache.group.selectedsetting == 3 then

                            for i = 1,15 do
                                local rankname = groupCache[cache.selectedgroup].ranks[i][1];
                                local textwidth = dxGetTextWidth(rankname,0.00029*sx,cache.roboto)
                                
                                if isInSlot(sx*0.39 -textwidth/2,sy*0.322 +(i*(sy*0.024)),textwidth,sy*0.018) then
                                    cache.group.selectedsettingrank = i;
                                end
                            end

                            if cache.group.selectedsettingrank > 0 then
                                local count = 0;
                                local groupid = groupCache[cache.selectedgroup].dbid;

                                if cache.group.edit.items then
                                    for k,data in pairs(groupItems[groupid][cache.group.selectedsettingrank]) do
                                        if isInSlot(sx*0.514,sy*0.394 +(count*(sy*0.023)),sx*0.006,sy*0.0110) then
                                            data.equip = not data.equip;
                                        elseif isInSlot(sx*0.524,sy*0.394 +(count*(sy*0.023)),sx*0.006,sy*0.0110) then
                                            for i = 1,15 do
                                                if groupItems[groupid][i][k].item == data.item then
                                                    groupItems[groupid][i][k] = nil;
                                                end
                                            end
                                        end
                                        count = count+1;
                                    end
                                end
                            end

                            local isLeader = func.getLeaderByCharid(groupCache[cache.selectedgroup].dbid,getElementData(localPlayer,"player:dbid"));
                            if isLeader then

                                if isInSlot(sx*0.446,sy*0.677,sx*0.09,sy*0.026) then -- tárgy hozzáad
                                    cache.group.edit.newitem = not cache.group.edit.newitem;
                                end

                                if isInSlot(sx*0.5399,sy*0.677,sx*0.065,sy*0.026) then -- szerkeszt
                                    cache.group.edit.items = not cache.group.edit.items;
                                end

                                if isInSlot(sx*0.6088,sy*0.677,sx*0.111,sy*0.026) then --mentés
                                    if not isTimer(spamtimer) then
                                        spamtimer = setTimer(function()
                                        
                                        end,1000*30,1)
                                        local groupid = groupCache[cache.selectedgroup].dbid;
                                        triggerServerEvent("saveGroupItems",localPlayer,groupid,groupItems[groupid])
                                    else
                                        exports.Pinfobox:addNotification("Várj egy kicsit, hiszen nem rég mentettél.","error")
                                    end
                                end

                                if cache.group.edit.newitem then

                                    local count = 0;

                                    for k,v in ipairs(availableGroupItems[groupCache[cache.selectedgroup].dbid]) do
                                        if k > cache.group.itemWheel and count < 8 then
                                            count = count+1;

                                            if cache.group.edititem == k then

                                                if isInSlot(sx*0.683,sy*0.389 +(count*(sy*0.031)),sx*0.014,sy*0.024) then --hozzáad
                                                    local guiText = guiGetText(cache.group.newitemgui)
                                                    if #guiText > 0 then
                                                        guiText = tonumber(guiText);
                                                        if guiText <= 360 then
                                                            local state = false;
                                                            local stack = exports.inventory:getItemStackable(v);
                                                            if not stack then
                                                                if guiText > 1 then
                                                                    exports.Pinfobox:addNotification("A kiválasztott maximum mennyiség 1 darab lehet.","error")
                                                                else
                                                                    state = true;
                                                                end
                                                            else
                                                                state = true;
                                                            end

                                                            if state then
                                                                cache.group.edititem = -1;
                                                                for i = 1,15 do 
                                                                    groupItems[groupCache[cache.selectedgroup].dbid][i][#groupItems[groupCache[cache.selectedgroup].dbid][i]+1] = {
                                                                        equip = false;
                                                                        item = v;
                                                                        count = guiText;
                                                                    }
                                                                end
                                                            end

                                                        else
                                                            exports.Pinfobox:addNotification("Beírt mennyiség nem lehet nagyobb 360.","error")
                                                        end
                                                    else
                                                        exports.Pinfobox:addNotification("Nem maradhat üresen.","error")
                                                    end
                                                end

                                                if isInSlot(sx*0.701,sy*0.389 +(count*(sy*0.031)),sx*0.014,sy*0.024) then
                                                    cache.group.edititem = -1;
                                                end
                                            else
                                                if isInSlot(sx*0.665,sy*0.389 +(count*(sy*0.031)),sx*0.05,sy*0.024) then

                                                    local find = false;
                                                    local groupid = groupCache[cache.selectedgroup].dbid;
                                                    for a,data in pairs(groupItems[groupid][cache.group.selectedsettingrank]) do
                                                        if data.item == v then
                                                            find = true;
                                                        end
                                                    end

                                                    if not find then
                                                        cache.group.edititem = k;
                                                        guiSetText(cache.group.newitemgui,"");
                                                    else
                                                        exports.Pinfobox:addNotification("A kiválasztott tárgy már hozzá van adva.","error")
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end

                else
                    for i = 1,12 do

                        local left = sx*0.3515 + drawColumn * (sx*0.18 + 10) + 10;
                        local top = sy*0.280 + drawRow * (sy*0.06 + 10) + 10;

                        if groupCache[i] then
                            if isInSlot(left,top,sx*0.18,sy*0.06) then
                                cache.selectedgroup = i;

                                if isGroupTypeChangeItem[groupCache[cache.selectedgroup].type] then
                                    cache.group.settingbuttons[3] = "Tárgyak beállítása";
                                else
                                    cache.group.settingbuttons[3] = nil;
                                end

                            end
                        end

                        drawColumn = drawColumn + 1;
                        if (drawColumn == 2) then
                            drawColumn = 0;
                            drawRow = drawRow + 1;
                        end

                    end
                end
            end
        elseif button == "right" and state == "down" then 
            if cache.page == "groups" then
                if cache.selectedgroup > 0 then
                    if cache.grouppage == 3 then
                        if cache.selectedgroup > 0 then
                            if groupVehicles[groupCache[cache.selectedgroup].dbid] then
                                local count = 0;

                                for k,v in ipairs(groupVehicles[groupCache[cache.selectedgroup].dbid]) do
                                    if k > cache.group.vehwheel and count < 14 then
                                        count = count+1;
                                        if isInSlot(sx*0.3574,sy*0.292+(count*sy*0.027),sx*0.11,sy*0.027) then
                                            cache.group.selectedveh = k;
                                            --if isElement(v.element) then
                                                if not vehicleBlips[v.dbid] then
                                                    local x,y,z = getElementPosition(v.element);
                                                    vehicleBlips[v.dbid] = createBlip(x,y,z,15)
                                                    setElementData(vehicleBlips[v.dbid], "blipIcon", 15)
                                                    setElementData(vehicleBlips[v.dbid], "blipName", v.name.." ("..(v.dbid)..")")
                                                    setElementData(vehicleBlips[v.dbid], "exclusiveBlip",true)
                                                    vehicleMarkers[v.dbid] = createMarker(x,y,z,"checkpoint",4)
                                                    setElementData(vehicleMarkers[v.dbid],"vehicleElement",v.element)

                                                    attachElements(vehicleBlips[v.dbid],v.element)
                                                    attachElements(vehicleMarkers[v.dbid],v.element)
                                                    exports.Pinfobox:addNotification("A kiválasztott jármű megjelölve a térképeden.","success")
                                                else
                                                    detachElements (vehicleBlips[v.dbid],v.element)
                                                    detachElements (vehicleMarkers[v.dbid],v.element)
                                                    destroyElement(vehicleBlips[v.dbid])
                                                    destroyElement(vehicleMarkers[v.dbid])
                                                    vehicleBlips[v.dbid] = nil;
                                                    vehicleMarkers[v.dbid] = nil;
                                                    exports.Pinfobox:addNotification("A jármű törölve a térképedről.","success")
                                                end
                                            --end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end 
    end
end
addEventHandler("onClientClick",root,onClientClick)

func.onClientCharacter = function(character)
    if show then
        if cache.page == "groups" then
            if cache.selectedgroup > 0  then
                if cache.grouppage == 1 then
                    if cache.group.newTag then
                        if #cache.group.tagtext < 20 then
                            cache.group.tagtext = cache.group.tagtext..character;
                        end
                    elseif cache.group.numberChange then
                        if #cache.group.numberText < 13 then
                            if availableCharacter[character] then
                                cache.group.numberText = cache.group.numberText..character;
                            end
                        end
                    end
                end
            end
        end
    end
end
addEventHandler("onClientCharacter", getRootElement(), func.onClientCharacter)

function deletePrev()
    if cache.group.selectedskin > 0 then
        cache.group.selectedskin = 0;
        exports.object_preview:destroyObjectPreview(prevElement)
        setElementPosition(ped,0,0,0)
        destroyElement(ped)
    end
end

availableCharacter = {
    ["0"] = true;
    ["1"] = true;
    ["2"] = true;
    ["3"] = true;
    ["4"] = true;
    ["5"] = true;
    ["6"] = true;
    ["7"] = true;
    ["8"] = true;
    ["9"] = true;
    ["-"] = true;
}

func.deleteText = function()
    if show then
        if cache.page == "groups" then
            if cache.selectedgroup > 0  then
                if cache.grouppage == 1 then
                    if cache.group.newTag then
                        cache.group.tagtext = utf8.sub(cache.group.tagtext, 0, utf8.len(cache.group.tagtext)-1)
                    elseif cache.group.numberChange then
                        cache.group.numberText = utf8.sub(cache.group.numberText, 0, utf8.len(cache.group.numberText)-1)
                    end
                end
            end
        end
    end
end
bindKey("backspace","down",func.deleteText)

func.getLeaderByCharid = function(groupid,dbid)
    for k,data in pairs(groupMembers[groupid]) do
        if data.charid == dbid and data.leader == 1 then
            return true;
        end
    end
    return false;
end

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

-- FIZU RENDSZER



setTimer(function()
    if getElementData(localPlayer,"player:loggedIn") then

        if getElementData(localPlayer, "player:paytime") then
			setElementData(localPlayer, "player:paytime", getElementData(localPlayer, "player:paytime") - 1)
        end
        
        if getElementData(localPlayer, "player:paytime") == 0 then
			setElementData(localPlayer, "player:paytime", 60)

            local playerVehicles = 0;
            local playerInteriors = 0;
            local playerDbid = getElementData(localPlayer,"player:dbid");
            local interiorTax = 140;
            local vehicleTax = 70;
            local wages = {};

            for k,data in pairs(groupCache) do
                local state,memberData = isPlayerInGroup(data.dbid,playerDbid);
                if state then
                    if data.ranks[memberData.rank][2] > 0 then
                        wages[#wages+1] = {
                            name = data.name;
                            groupid = data.dbid;
                            wage = data.ranks[memberData.rank][2];
                            cardnumber = memberData.cardNumber;
                            money = data.money;
                        };
                    end
                end
            end

            for k,vehicle in ipairs(getElementsByType("vehicle")) do
                if getElementData(vehicle,"vehicle:dbid") and getElementData(vehicle,"vehicle:dbid") > 0 then
                    if getElementData(vehicle,"vehicle:owner") == playerDbid then
                        playerVehicles = playerVehicles + 1;
                    end
                end
            end

            for k,pickup in ipairs(getElementsByType("pickup")) do
                if getElementData(pickup,"int:in") and getElementData(pickup,"int:dbid") and getElementData(pickup,"int:dbid") > 0 then
                    if getElementData(pickup,"int:owner") == playerDbid and getElementData(pickup,"int:type") ~= 1 then
                        playerInteriors = playerInteriors + 1;
                    end
                end
            end

            exports.Pinfobox:addNotification("Megérkezett a fizetésed. Részletek a chatboxban.","info")

            outputChatBox("[MEGÉRKEZETT A FIZETÉSED]:",129, 99, 191,true)
            local allvehtax = playerVehicles*vehicleTax;
            local allinttax = playerInteriors*interiorTax;
            outputChatBox(" > Jármű adó: #7cc576"..formatMoney(allvehtax).."#ffffff $",255,255,255,true)
            outputChatBox(" > Ingatlan adó: #7cc576"..formatMoney(allinttax).."#ffffff $",255,255,255,true)
            setElementData(localPlayer,"player:money",getElementData(localPlayer,"player:money")-(allvehtax+allinttax))
            if #wages > 0 then
                outputChatBox(" > Fizetésed:",255,255,255,true)
                local allwage = 0;
                for k,v in ipairs(wages) do

                    if v.wage > 0 and v.money >= v.wage then
                        allwage = allwage + v.wage;

                        local wagetax = math.ceil((v.wage*0.1)/2);
                        local state = exports.inventory:giveCardMoneyByCardnumber(v.cardnumber,v.wage-wagetax);
                        if state then
                            outputChatBox("     "..v.name.."#ffffff #7cc576"..formatMoney(v.wage).."#ffffff $",129, 99, 191,true)
                            triggerServerEvent("setGroupMoney",localPlayer,v.groupid,v.money - v.wage)
                        else
                            outputChatBox(" > Nem tudtad megkapni a fizetésed a(z) #8163bf"..v.name.."#ffffff -tól/től mert nem létezik a megadott számlaszámod.",129, 99, 191,true)
                        end
                    end
                end

                local newWage = math.ceil((allwage*0.1)/2);
                outputChatBox(" > Jövedelem adó: #7cc576"..formatMoney(newWage).."#ffffff $",255,255,255,true)
            end
        end
    end
end, 60000, 0)

func.findPlayerByText = function(text)
	local isString = false;
	local isID = false;
	if (tostring(type(tonumber(text))) == "number") then
		isString = false;
		isID = true;
	else
		isID = false;
		isString = true;
	end
	for player,k in pairs(playerCache) do
		if isID then
			if getElementData(player,"player:id") == tonumber(text) then
				return player;
			end
		elseif isString then
			if getElementData(player,"player:charname"):gsub("_", " ") == text then
				return player;
			end
		end
    end
    return nil;
end

func.getOnline = function(dbid)
    for player,k in pairs(playerCache) do
        if getElementData(player,"player:dbid") == dbid then
            return true,player;
        end
    end
    return false,nil;
end

func.wheelUp = function()
	if show then
        if cache.page == "groups" then 
            if cache.grouppage == 1 then
                if isInSlot(sx*0.3538,sy*0.312,sx*0.117,sy*0.391) then
                    cache.group.tagwheel = cache.group.tagwheel - 1
                    if cache.group.tagwheel < 1 then
                        cache.group.tagwheel = 0
                    end
                end
            elseif cache.grouppage == 3 then
                if cache.selectedgroup > 0 then
                    if groupVehicles[groupCache[cache.selectedgroup].dbid] then
                        if isInSlot(sx*0.3538,sy*0.312,sx*0.117,sy*0.391) then
                            cache.group.vehwheel = cache.group.vehwheel - 1
                            if cache.group.vehwheel < 1 then
                                cache.group.vehwheel = 0
                            end
                        end
                    end
                end
            elseif cache.grouppage == 4 then
                if cache.group.selectedsetting == 3 then
                    if isInSlot(sx*0.554,sy*0.381,sx*0.166,sy*0.288) then
                        cache.group.itemWheel = cache.group.itemWheel - 1
                        if cache.group.itemWheel < 1 then
                            cache.group.itemWheel = 0
                        end
                    end
                elseif cache.group.selectedsetting == 1 then
                    if isInSlot(sx*0.3501,sy*0.572,sx*0.38,sy*0.136) then
                        cache.group.transactionwheel = cache.group.transactionwheel - 1
                        if cache.group.transactionwheel < 1 then
                            cache.group.transactionwheel = 0
                        end
                    end
                elseif cache.group.selectedsetting == 2 then
                    if isInSlot(sx*0.3538,sy*0.343,sx*0.117,sy*0.363) then
                        cache.group.skinwheel = cache.group.skinwheel - 1
                        if cache.group.skinwheel < 1 then
                            cache.group.skinwheel = 0
                        end
                    end
                end
            end
        end
        
        if cache.page == "own" then 
            if isInSlot(sx*0.365,sy*0.318,sx*0.17,sy*0.35) then --cache.ownvehwheel
                cache.ownvehwheel = cache.ownvehwheel - 1
                if cache.ownvehwheel < 1 then
                    cache.ownvehwheel = 0
                end
            elseif isInSlot(sx*0.545,sy*0.318,sx*0.17,sy*0.35) then 
                cache.intwheel = cache.intwheel - 1
                if cache.intwheel < 1 then
                    cache.intwheel = 0
                end
            end 
        elseif cache.page == "admins" then 
            if isInSlot(sx*0.365,sy*0.28,sx*0.17,sy*0.3461) or isInSlot(sx*0.545,sy*0.28,sx*0.17,sy*0.3461) then --cache.adminwheel
                cache.adminwheel = cache.adminwheel - 1
                if cache.adminwheel < 1 then
                    cache.adminwheel = 0
                end
            end 
        end 
	end
end
bindKey("mouse_wheel_up", "down",func.wheelUp)

func.wheelDown = function()
	if show then
        if cache.page == "groups" then 
            if cache.grouppage == 1 then
                if isInSlot(sx*0.3538,sy*0.312,sx*0.117,sy*0.391) then
                    local a = 0;
                    for k,v in pairs(groupMembers[groupCache[cache.selectedgroup].dbid]) do
                        a = a+1;
                    end

                    cache.group.tagwheel = cache.group.tagwheel + 1
                    
                    if cache.group.tagwheel > a - 14 then
                        cache.group.tagwheel = a - 14
                    end
                end
            elseif cache.grouppage == 3 then
                if cache.selectedgroup > 0 then
                    if groupVehicles[groupCache[cache.selectedgroup].dbid] then
                        if isInSlot(sx*0.3538,sy*0.312,sx*0.117,sy*0.391) then
                            cache.group.vehwheel = cache.group.vehwheel + 1
                            if cache.group.vehwheel > #groupVehicles[groupCache[cache.selectedgroup].dbid] - 14 then
                                cache.group.vehwheel = #groupVehicles[groupCache[cache.selectedgroup].dbid] - 14
                            end
                        end
                    end
                end
            elseif cache.grouppage == 4 then
                if cache.group.selectedsetting == 3 then
                    if isInSlot(sx*0.554,sy*0.381,sx*0.166,sy*0.288) then
                        cache.group.itemWheel = cache.group.itemWheel + 1
                        if cache.group.itemWheel > #availableGroupItems[groupCache[cache.selectedgroup].dbid] - 8 then
                            cache.group.itemWheel = #availableGroupItems[groupCache[cache.selectedgroup].dbid] - 8
                        end
                    end
                elseif cache.group.selectedsetting == 1 then
                    if isInSlot(sx*0.3501,sy*0.572,sx*0.38,sy*0.136) then
                        cache.group.transactionwheel = cache.group.transactionwheel + 1
                        if cache.group.transactionwheel > #transactionCache[groupCache[cache.selectedgroup].dbid] - 6 then
                            cache.group.transactionwheel = #transactionCache[groupCache[cache.selectedgroup].dbid] - 6
                        end
                    end
                elseif cache.group.selectedsetting == 2 then
                    if isInSlot(sx*0.3538,sy*0.343,sx*0.117,sy*0.363) then
                        cache.group.skinwheel = cache.group.skinwheel + 1
                        if cache.group.skinwheel > #dutySkins[groupCache[cache.selectedgroup].dbid] - 13 then
                            cache.group.skinwheel = #dutySkins[groupCache[cache.selectedgroup].dbid] - 13
                        end
                    end
                end
            end
        elseif cache.page == "own" then
            if isInSlot(sx*0.365,sy*0.318,sx*0.17,sy*0.35) then 
                cache.ownvehwheel = cache.ownvehwheel + 1
                if cache.ownvehwheel > #cache.playerVehicles - 12 then
                    cache.ownvehwheel = #cache.playerVehicles - 12
                end

            elseif isInSlot(sx*0.545,sy*0.318,sx*0.17,sy*0.35) then 
                cache.intwheel = cache.intwheel + 1
                if cache.intwheel > #cache.playerInteriors - 12 then
                    cache.intwheel = #cache.playerInteriors - 12
                end
            end 
        elseif cache.page == "admins" then 
            if isInSlot(sx*0.365,sy*0.28,sx*0.17,sy*0.3461) or isInSlot(sx*0.545,sy*0.28,sx*0.17,sy*0.3461) then
                cache.adminwheel = cache.adminwheel + 1
                if cache.adminwheel > #cache.serverAdmins - 13 then
                    cache.adminwheel = #cache.serverAdmins - 13
                end
            end 
		end
	end
end
bindKey("mouse_wheel_down", "down",func.wheelDown)

function settingClick(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
    if (button == "left") and (state == "down") and show then 
        if cache.page == "settings" then 
            if isInSlot(sx*0.487,sy*0.272,sx*0.045,sy*0.025) then                 
                if cache.setting["bloom"][1] == false then 
                    cache.setting["bloom"][1] = true
                    myScreenSource = dxCreateScreenSource( sx/2, sy/2 )

                    blurHShader,tecName = dxCreateShader( "shaders/blurH.fx" )
                    blurVShader,tecName = dxCreateShader( "shaders/blurV.fx" )            
                    brightPassShader,tecName = dxCreateShader( "shaders/brightPass.fx" )            
                    addBlendShader,tecName = dxCreateShader( "shaders/addBlend.fx" )
                    bAllValid = myScreenSource and blurHShader and blurVShader and brightPassShader and addBlendShader

                else 
                    cache.setting["bloom"][1] = false 
                    destroyElement(myScreenSource)
                    destroyElement(blurHShader)
                    destroyElement(blurVShader)
                    destroyElement(brightPassShader)
                    destroyElement(addBlendShader)
                end 
            elseif isInSlot(sx*0.487,sy*0.298,sx*0.045,sy*0.025) then 
                if cache.setting["vignette"][1] == false then 
                    cache.setting["vignette"][1] = true
                else 
                    cache.setting["vignette"][1] = false 
                end 
            elseif isInSlot(sx*0.487,sy*0.324,sx*0.045,sy*0.025) then 
                if cache.setting["motionblur"][1] == false then 
                    cache.setting["motionblur"][1] = true
                    triggerEvent("setMotion",localPlayer,true)
                else 
                    cache.setting["motionblur"][1] = false 
                    triggerEvent("setMotion",localPlayer,false)
                end 
            elseif isInSlot(sx*0.487,sy*0.352,sx*0.045,sy*0.025) then 
                if cache.setting["vehicleshader"][1] == false then 
                    cache.setting["vehicleshader"][1] = true
                        myShader, tec = dxCreateShader ( "shaders/car_paint.fx" )
        
                        -- Set textures
                        textureVol = dxCreateTexture ( "shaders/images/smallnoise3d.dds" );
                        textureCube = dxCreateTexture ( "shaders/images/cube_env256.dds" );
                        dxSetShaderValue ( myShader, "sRandomTexture", textureVol );
                        dxSetShaderValue ( myShader, "sReflectionTexture", textureCube );
            
                        -- Apply to world texture
                        engineApplyShaderToWorldTexture ( myShader, "vehiclegrunge256" )
                        engineApplyShaderToWorldTexture ( myShader, "?emap*" )

                else 
                    cache.setting["vehicleshader"][1] = false 
                    engineRemoveShaderFromWorldTexture(myShader,"vehiclegrunge256")
                    engineRemoveShaderFromWorldTexture(myShader,"?emap*")
                    destroyElement(myShader)
                end 
            elseif isInSlot(sx*0.487,sy*0.376,sx*0.045,sy*0.025) then 
                if cache.setting["betterwater"][1] == false then 
                    cache.setting["betterwater"][1] = true
                    myShader2, tec = dxCreateShader ( "shaders/water.fx" )
			        textureVol = dxCreateTexture ( "shaders/images/smallnoise3d.dds" );
			        textureCube = dxCreateTexture ( "shaders/images/cube_env256.dds" );
			        dxSetShaderValue ( myShader2, "sRandomTexture", textureVol );
			        dxSetShaderValue ( myShader2, "sReflectionTexture", textureCube );
                    engineApplyShaderToWorldTexture ( myShader2, "waterclear256" )

                            timer = setTimer(	function()
                                if myShader then
                                    local r,g,b,a = getWaterColor()
                                    dxSetShaderValue ( myShader2, "sWaterColor", r/255, g/255, b/255, a/255 );
                                end
                            end,100,0 )

                else 
                    cache.setting["betterwater"][1] = false 
                    engineRemoveShaderFromWorldTexture(myShader2,"waterclear256")
                    destroyElement(myShader2)
                    killTimer(timer)
                end 
            elseif isInSlot(sx*0.487,sy*0.402,sx*0.045,sy*0.025) then 
                if cache.setting["noise"][1] == false then 
                    cache.setting["noise"][1] = true
                    screenShadern = dxCreateShader( "shaders/noise.fx" )
                    screenSrcn = dxCreateScreenSource( sx, sy )
                    dxSetShaderValue( screenShadern, "PixelShadTexture", screenSrcn )
                    dxSetShaderValue( screenShadern, "fNintensity", intensity )
                    dxSetShaderValue( screenShadern, "fSintensity", intensityLines )
                    noise=true
        
                    addEventHandler("onClientHUDRender",getRootElement(), noiseRender)
                else 
                    cache.setting["noise"][1] = false 
                    removeEventHandler("onClientHUDRender",getRootElement(), noiseRender)

                    destroyElement( screenShadern )
                    destroyElement( screenSrcn )
                    screenShadern, screenSrcn = nil, nil
                end 
            elseif isInSlot(sx*0.487,sy*0.428,sx*0.045,sy*0.025) then 
                if cache.setting["bettertexture"][1] == false then 
                    cache.setting["bettertexture"][1] = true
                    triggerEvent("onClientSwitchDetail",localPlayer,true)
                else 
                    cache.setting["bettertexture"][1] = false 
                    triggerEvent("onClientSwitchDetail",localPlayer,false)
                end 
            elseif isInSlot(sx*0.465,sy*0.455,sx*0.07,sy*0.025) then 
                if getPedFightingStyle(localPlayer) == 4 then 
                triggerServerEvent("setFightStyle",localPlayer,localPlayer,5)
                elseif getPedFightingStyle(localPlayer) == 5 then 
                triggerServerEvent("setFightStyle",localPlayer,localPlayer,6)
                elseif getPedFightingStyle(localPlayer) == 6 then 
                triggerServerEvent("setFightStyle",localPlayer,localPlayer,7)
                elseif getPedFightingStyle(localPlayer) == 7 then 
                triggerServerEvent("setFightStyle",localPlayer,localPlayer,15)
                elseif getPedFightingStyle(localPlayer) == 15 then 
                triggerServerEvent("setFightStyle",localPlayer,localPlayer,4)
                end
            end 

            for k,v in pairs(walkstyles) do 
                if isInSlot(sx*0.668,sy*0.274 + (k*sy*0.0262),sx*0.045,sy*0.023) then 
                    triggerServerEvent("setWalkStyle",localPlayer,localPlayer,v[2])
                    exports["Pinfobox"]:addNotification("Sétasílus sikeresen beállítva.","success")
                end 
            end 

            if isInSlot(sx*0.49,sy*0.575,sx*0.01,sy*0.03) then 
                if cache.crosshair < #crosshairs then 
                    cache.crosshair = cache.crosshair + 1
                    setCrosshair(cache.crosshair)
                else
                    cache.crosshair = 0
                    setCrosshair(0)
                end 
            elseif isInSlot(sx*0.395,sy*0.575,sx*0.01,sy*0.03) then 
                if cache.crosshair >= 1 then
                    cache.crosshair = cache.crosshair - 1
                    setCrosshair(cache.crosshair)
                else 
                    cache.crosshair = 10
                    setCrosshair(cache.crosshair)
                end 
            elseif isInSlot(sx*0.47,sy*0.68,sx*0.14,sy*0.02) then 
                triggerServerEvent("setFightStyle",localPlayer,localPlayer,4)
                triggerServerEvent("setWalkStyle",localPlayer,localPlayer,54)

                if cache.setting["bloom"][1] == true then 
                    cache.setting["bloom"][1] = false 
                    destroyElement(myScreenSource)
                    destroyElement(blurHShader)
                    destroyElement(blurVShader)
                    destroyElement(brightPassShader)
                    destroyElement(addBlendShader)
                end

                if cache.setting["vignette"][1] == true then 
                    cache.setting["vignette"][1] = false 
                end

                if cache.setting["motionblur"][1] == true then 
                    cache.setting["motionblur"][1] = false 
                    triggerEvent("setMotion",localPlayer,false)
                end

                if cache.setting["vehicleshader"][1] == true then 
                    cache.setting["vehicleshader"][1] = false 
                    engineRemoveShaderFromWorldTexture(myShader,"vehiclegrunge256")
                    engineRemoveShaderFromWorldTexture(myShader,"?emap*")
                    destroyElement(myShader)
                end

                if cache.setting["betterwater"][1] == true then 
                    cache.setting["betterwater"][1] = false 
                    engineRemoveShaderFromWorldTexture(myShader2,"waterclear256")
                    destroyElement(myShader2)
                    killTimer(timer)
                end

                if cache.setting["noise"][1] == true then 
                    cache.setting["noise"][1] = false 
                    removeEventHandler("onClientHUDRender",getRootElement(), noiseRender)
                    destroyElement( screenShadern )
                    destroyElement( screenSrcn )
                    screenShadern, screenSrcn = nil, nil
                end

                if cache.setting["bettertexture"][1] == true then 
                    cache.setting["bettertexture"][1] = false 
                    triggerEvent("onClientSwitchDetail",localPlayer,false)
                end
                cache.crosshair = 0
                setCrosshair(0)
                exports["Pinfobox"]:addNotification("Alapértelmezett beállítások visszaállítva.","success")
            end 



        end 
    end 
end 
addEventHandler("onClientClick",root,settingClick)

isGroupTypeChangeItem = {
    ["ambulance"] = true,
    ["law"] = true,
    ["fired"] = true,
    ["mechanic"] = true,
};

func.border = function(x, y, w, h, radius, color)
    dxDrawRectangle(x - radius, y, radius, h, color)
    dxDrawRectangle(x + w, y, radius, h, color)
    dxDrawRectangle(x - radius, y - radius, w + (radius * 2), radius, color)
    dxDrawRectangle(x - radius, y + h, w + (radius * 2), radius, color)
end

--settings

-----------------------------------------------------------------------------------
-- Apply the different stages
-----------------------------------------------------------------------------------
function applyDownsample( Src, amount )
	if not Src then return nil end
	amount = amount or 2
	local mx,my = dxGetMaterialSize( Src )
	mx = mx / amount
	my = my / amount
	local newRT = RTPool.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT )
	dxDrawImage( 0, 0, mx, my, Src )
	return newRT
end

function applyGBlurH( Src, bloom )
	if not Src then return nil end
	local mx,my = dxGetMaterialSize( Src )
	local newRT = RTPool.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT, true ) 
	dxSetShaderValue( blurHShader, "TEX0", Src )
	dxSetShaderValue( blurHShader, "TEX0SIZE", mx,my )
	dxSetShaderValue( blurHShader, "BLOOM", bloom )
	dxDrawImage( 0, 0, mx, my, blurHShader )
	return newRT
end

function applyGBlurV( Src, bloom )
	if not Src then return nil end
	local mx,my = dxGetMaterialSize( Src )
	local newRT = RTPool.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT, true ) 
	dxSetShaderValue( blurVShader, "TEX0", Src )
	dxSetShaderValue( blurVShader, "TEX0SIZE", mx,my )
	dxSetShaderValue( blurVShader, "BLOOM", bloom )
	dxDrawImage( 0, 0, mx,my, blurVShader )
	return newRT
end

function applyBrightPass( Src, cutoff, power )
	if not Src then return nil end
	local mx,my = dxGetMaterialSize( Src )
	local newRT = RTPool.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT, true ) 
	dxSetShaderValue( brightPassShader, "TEX0", Src )
	dxSetShaderValue( brightPassShader, "CUTOFF", cutoff )
	dxSetShaderValue( brightPassShader, "POWER", power )
	dxDrawImage( 0, 0, mx,my, brightPassShader )
	return newRT
end


-----------------------------------------------------------------------------------
-- Pool of render targets
-----------------------------------------------------------------------------------
RTPool = {}
RTPool.list = {}

Set = {}
Set.var = {}
Set.var.cutoff = 0.08
Set.var.power = 1.88
Set.var.bloom = 2.0
Set.var.blendR = 204
Set.var.blendG = 153
Set.var.blendB = 130
Set.var.blendA = 140

addEventHandler( "onClientHUDRender", root,
    function()
        if cache.setting["bloom"][1] == true then 
		    if not Set.var then
		    	return
		    end
            if bAllValid then
		    	-- Reset render target pool
		    	RTPool.frameStart()

		    	-- Update screen
		    	dxUpdateScreenSource( myScreenSource )

		    	-- Start with screen
		    	local current = myScreenSource

		    	-- Apply all the effects, bouncing from one render target to another
		    	current = applyBrightPass( current, Set.var.cutoff, Set.var.power )
		    	current = applyDownsample( current )
		    	current = applyDownsample( current )
		    	current = applyGBlurH( current, Set.var.bloom )
		    	current = applyGBlurV( current, Set.var.bloom )

		    	-- When we're done, turn the render target back to default
		    	dxSetRenderTarget()

		    	-- Mix result onto the screen using 'add' rather than 'alpha blend'
		    	if current then
		    		dxSetShaderValue( addBlendShader, "TEX0", current )
		    		local col = tocolor(Set.var.blendR, Set.var.blendG, Set.var.blendB, Set.var.blendA)
		    		dxDrawImage( 0, 0, sx, sy, addBlendShader, 0,0,0, col )
		    	end
            end
        end
    end
)

addEventHandler("onClientRender",root,function()
    if cache.setting["vignette"][1] == true then 
        dxDrawImage(sx*0.0,sy*0.0,sx,sy,"shaders/images/vignette.png",0,0,0,tocolor(255,255,255,255))
    end 
end)

function noiseRender()
	if cache.setting["noise"][1] == true then 
		dxUpdateScreenSource( screenSrcn, true )
		dxSetRenderTarget()
		dxDrawImage( 0, 0, sx, sy, screenShadern )
    end
end

function RTPool.frameStart()
	for rt,info in pairs(RTPool.list) do
		info.bInUse = false
	end
end

function RTPool.GetUnused( mx, my )
	-- Find unused existing
	for rt,info in pairs(RTPool.list) do
		if not info.bInUse and info.mx == mx and info.my == my then
			info.bInUse = true
			return rt
		end
	end
	-- Add new
	local rt = dxCreateRenderTarget( mx, my )
	if rt then
		RTPool.list[rt] = { bInUse = true, mx = mx, my = my }
	end
	return rt
end

function setCrosshair(number)
    if number == 0 then 
    engineRemoveShaderFromWorldTexture(shader,"siteM16")
    engineRemoveShaderFromWorldTexture(shader,"siteM16lod")
    else 
    shader, tec = dxCreateShader ( "shaders/texture.fx" )
    tex = dxCreateTexture ( "crosshairs/"..number..".png" )
    engineApplyShaderToWorldTexture ( shader, "siteM16" )
    engineApplyShaderToWorldTexture ( shader, "siteM16lod" )
    dxSetShaderValue ( shader, "gTexture", tex )
    end 
end 

--save

if not xmlLoadFile("save.xml") then
	local posF = xmlCreateFile("save.xml", "root")
    local mainC2 = xmlCreateChild(posF, "data")
    
	xmlNodeSetValue(xmlCreateChild(mainC2, "bloom", 0), 0)
    xmlNodeSetValue(xmlCreateChild(mainC2, "vignette", 0), 0)
    xmlNodeSetValue(xmlCreateChild(mainC2, "motionblur", 0), 0)
    xmlNodeSetValue(xmlCreateChild(mainC2, "vehicleshader", 0), 0)
    xmlNodeSetValue(xmlCreateChild(mainC2, "betterwater", 0), 0)
    xmlNodeSetValue(xmlCreateChild(mainC2, "noise", 0), 0)
    xmlNodeSetValue(xmlCreateChild(mainC2, "bettertexture", 0), 0)
    xmlNodeSetValue(xmlCreateChild(mainC2, "crosshair", 0), 0)
	xmlSaveFile(posF)
else
	local posF = xmlLoadFile("save.xml")
	local mainC2 = xmlFindChild(posF, "data", 0)
    local bloom = tonumber(xmlNodeGetValue(xmlFindChild(mainC2, "bloom", 0)))
	local vignette = tonumber(xmlNodeGetValue(xmlFindChild(mainC2, "vignette", 0)))
	local motionblur = tonumber(xmlNodeGetValue(xmlFindChild(mainC2, "motionblur", 0)))
	local vehicleshader = tonumber(xmlNodeGetValue(xmlFindChild(mainC2, "vehicleshader", 0)))
	local betterwater = tonumber(xmlNodeGetValue(xmlFindChild(mainC2, "betterwater", 0)))
	local noise = tonumber(xmlNodeGetValue(xmlFindChild(mainC2, "noise", 0)))
    local bettertexture = tonumber(xmlNodeGetValue(xmlFindChild(mainC2, "bettertexture", 0)))
    local crosshair = tonumber(xmlNodeGetValue(xmlFindChild(mainC2, "crosshair", 0)))

    if bloom == 1 then 
        cache.setting["bloom"][1] = true 
        myScreenSource = dxCreateScreenSource( sx/2, sy/2 )

        blurHShader,tecName = dxCreateShader( "shaders/blurH.fx" )
        blurVShader,tecName = dxCreateShader( "shaders/blurV.fx" )            
        brightPassShader,tecName = dxCreateShader( "shaders/brightPass.fx" )            
        addBlendShader,tecName = dxCreateShader( "shaders/addBlend.fx" )
        bAllValid = myScreenSource and blurHShader and blurVShader and brightPassShader and addBlendShader
    else 
        cache.setting["bloom"][1] = false 
    end

    if vignette == 1 then 
        cache.setting["vignette"][1] = true 
    else 
        cache.setting["vignette"][1] = false 
    end

    if motionblur == 1 then 
        cache.setting["motionblur"][1] = true 
        setTimer(function()
        triggerEvent("setMotion",localPlayer,true)
        end,300,1)
    else 
        cache.setting["motionblur"][1] = false 
    end

    if vehicleshader == 1 then 
        cache.setting["vehicleshader"][1] = true 
        myShader, tec = dxCreateShader ( "shaders/car_paint.fx" )

        -- Set textures
        textureVol = dxCreateTexture ( "shaders/images/smallnoise3d.dds" );
        textureCube = dxCreateTexture ( "shaders/images/cube_env256.dds" );
        dxSetShaderValue ( myShader, "sRandomTexture", textureVol );
        dxSetShaderValue ( myShader, "sReflectionTexture", textureCube );

        -- Apply to world texture
        engineApplyShaderToWorldTexture ( myShader, "vehiclegrunge256" )
        engineApplyShaderToWorldTexture ( myShader, "?emap*" )
    else 
        cache.setting["vehicleshader"][1] = false 
    end

    if betterwater == 1 then 
        cache.setting["betterwater"][1] = true 
        myShader2, tec = dxCreateShader ( "shaders/water.fx" )
        textureVol = dxCreateTexture ( "shaders/images/smallnoise3d.dds" );
        textureCube = dxCreateTexture ( "shaders/images/cube_env256.dds" );
        dxSetShaderValue ( myShader2, "sRandomTexture", textureVol );
        dxSetShaderValue ( myShader2, "sReflectionTexture", textureCube );
        engineApplyShaderToWorldTexture ( myShader2, "waterclear256" )
    
                timer = setTimer(	function()
                    if myShader then
                        local r,g,b,a = getWaterColor()
                        dxSetShaderValue ( myShader2, "sWaterColor", r/255, g/255, b/255, a/255 );
                    end
                end,100,0 )
    else 
        cache.setting["betterwater"][1] = false 
    end

    if noise == 1 then 
        cache.setting["noise"][1] = true
        screenShadern = dxCreateShader( "shaders/noise.fx" )
        screenSrcn = dxCreateScreenSource( sx, sy )
        dxSetShaderValue( screenShadern, "PixelShadTexture", screenSrcn )
        dxSetShaderValue( screenShadern, "fNintensity", intensity )
        dxSetShaderValue( screenShadern, "fSintensity", intensityLines )
        noise=true
    
        addEventHandler("onClientHUDRender",getRootElement(), noiseRender)
    else 
        cache.setting["noise"][1] = false 
    end

    if bettertexture == 1 then 
        cache.setting["bettertexture"][1] = true
        setTimer(function()
        triggerEvent("onClientSwitchDetail",localPlayer,true)
        end,500,1)
    else 
        cache.setting["bettertexture"][1] = false 
    end

    if crosshair == 0 then 
    
    else 
    cache.crosshair = crosshair
    setCrosshair(cache.crosshair)
    end

end

--[[setting = {
    ["bloom"] = {false},
    ["vignette"] = {false},
    ["motionblur"] = {false},
    ["vehicleshader"] = {false},
    ["betterwater"] = {false},
    ["noise"] = {false},
    ["bettertexture"] = {false},
};]]

function savePos()
	local posF = xmlLoadFile("save.xml")
	if posF then
		local mainC2 = xmlFindChild(posF, "data", 0)

        if cache.setting["bloom"][1] then 
            xmlNodeSetValue(xmlFindChild(mainC2, "bloom", 0), 1)
        else 
            xmlNodeSetValue(xmlFindChild(mainC2, "bloom", 0), 0)
        end 

        if cache.setting["vignette"][1] then 
            xmlNodeSetValue(xmlFindChild(mainC2, "vignette", 0), 1)
        else 
            xmlNodeSetValue(xmlFindChild(mainC2, "vignette", 0), 0)
        end 

        if cache.setting["motionblur"][1] then 
            xmlNodeSetValue(xmlFindChild(mainC2, "motionblur", 0), 1)
        else 
            xmlNodeSetValue(xmlFindChild(mainC2, "motionblur", 0), 0)
        end 

        if cache.setting["vehicleshader"][1] then 
            xmlNodeSetValue(xmlFindChild(mainC2, "vehicleshader", 0), 1)
        else 
            xmlNodeSetValue(xmlFindChild(mainC2, "vehicleshader", 0), 0)
        end 

        if cache.setting["betterwater"][1] then 
            xmlNodeSetValue(xmlFindChild(mainC2, "betterwater", 0), 1)
        else 
            xmlNodeSetValue(xmlFindChild(mainC2, "betterwater", 0), 0)
        end 

        if cache.setting["noise"][1] then 
            xmlNodeSetValue(xmlFindChild(mainC2, "noise", 0), 1)
        else 
            xmlNodeSetValue(xmlFindChild(mainC2, "noise", 0), 0)
        end 

        if cache.setting["bettertexture"][1] then 
            xmlNodeSetValue(xmlFindChild(mainC2, "bettertexture", 0), 1)
        else 
            xmlNodeSetValue(xmlFindChild(mainC2, "bettertexture", 0), 0)
        end 

        if cache.crosshair == 0 then 
        xmlNodeSetValue(xmlFindChild(mainC2, "crosshair", 0), 0)
        else
        xmlNodeSetValue(xmlFindChild(mainC2, "crosshair", 0), cache.crosshair)
        end

		xmlSaveFile(posF)
	end
end
addEventHandler("onClientResourceStop", getResourceRootElement(getThisResource()), savePos)
addEventHandler("onClientPlayerQuit", getRootElement(), savePos)

function click(button,state)
	if button == "left" and state == "down" then
        if not show then return end
        if not cache.page =="own" then return end
        for k,v in ipairs(cache.playerVehicles) do
            if k > cache.ownvehwheel and Vehiclecount < 12 then
                Vehiclecount = Vehiclecount+1;
		if isInSlot(sx*0.37,sy*0.3325+(Vehiclecount*sy*0.0262),220,15) then
            vehshow = true
        setElementData(v,"clicked",true)
		end
                if not isInSlot(sx*0.37,sy*0.3325+(Vehiclecount*sy*0.0262),220,15) then
            vehshow = false
            setElementData(v,"clicked",false)
            end


				end
			end
		end
	end


addEventHandler("onClientClick",getRootElement(),click)

function double(button,state)
    Vehiclecount = 0
	if button == "right" and state == "down" then
        if not show then return end
        if not cache.page =="own" then return end
        for k,v in ipairs(cache.playerVehicles) do
            if k > cache.ownvehwheel and Vehiclecount < 12 then
                Vehiclecount = Vehiclecount+1;
			if 1 == 1 then
		if isInSlot(sx*0.37,sy*0.3325+(Vehiclecount*sy*0.0262),220,15) and not vehblip and not isElement(vehblip) and show and cache.page=="own" then
             blip = createBlipAttachedTo(v,15)
             vehshow = false
                setElementData(blip, "blipIcon", 15)
                setElementData(blip, "blipName", "Járműved")
                setElementData(blip, "exclusiveBlip",true)
                vehblip = true
                vehx,vehy,vehz = getElementPosition(v)
                vehmark = createMarker(vehx,vehy,vehz-2,"cylinder",6)
                attachElements(vehmark,v)
                setElementData(vehmark,"dashvehblip",true)
                setElementAlpha(vehmark,0)
                exports.Pinfobox:addNotification("A járműved meg lett jelölve a térképen!","success")
        elseif isInSlot(sx*0.37,sy*0.3325+(Vehiclecount*sy*0.0262),220,15) and vehblip and isElement(blip) and show and cache.page=="own" then
            vehshow = false
            destroyElement(blip)
            vehblip = false
            exports.Pinfobox:addNotification("Jelölés törölve!","success")
            destroyElement(vehmark)
                end
            end
        end
    end
end
end
addEventHandler("onClientClick",getRootElement(),double)

function onvehmarker()
    if not isElement(blip) or not isElement(vehmark) then return end
    if getElementData(source,"dashvehblip") then
    destroyElement(vehmark)
    destroyElement(blip)
    exports.Pinfobox:addNotification("Megérkeztél a járművedhez.","success")
    end
end
addEventHandler("onClientMarkerHit",root,onvehmarker)

function text()
    Vehiclecount = 0;
    if not show then return end
    if not cache.page =="own" then return end
    if not vehshow then return end
    for k,v in ipairs(cache.playerVehicles) do
        if k > cache.ownvehwheel and Vehiclecount < 12 then
            Vehiclecount = Vehiclecount+1;
           -- dxDrawRectangle(sx*0.37,sy*0.3325+(Vehiclecount*sy*0.0262),220,15,tocolor(255,255,255,255),true)
            if isInSlot(sx*0.37,sy*0.3325+(Vehiclecount*sy*0.0262),220,15) and getKeyState("mouse1") and clickTick+1500 < getTickCount() then
                selectedveh = v
                vehshow = true
            end
        end
    end
 if not show then return end
 if not cache.page =="own" then return end
 if not vehshow then return end
	if 1 == 1 then
        selectedveh = selectedveh
		local owner =getElementData(selectedveh,"vehicle:owner") 
		local characterid = getElementData(localPlayer, "player:dbid")
		local hp = getElementHealth(selectedveh)
		local fuel = getElementData(selectedveh,"vehicle:fuel")
		if 1 == 1 then
     --       dxDrawRectangle(pos[1]-80,pos[2]+50-10+(i*30),290,15)

if 1==1 then
    if not show then return end
    if not cache.page =="own" then return end
    if show and cache.page =="own" then
	dxDrawText(""..math.floor(hp / 10).."%", pos[1]+100,pos[2]+330+62,pos[1]-500,pos[2]-150, tocolor(255,255,255), 1,sfpro2,"left","top",false,false,true)
	dxDrawText(""..fuel.."L", pos[1]+100,pos[2]+330+75,pos[1]-500,pos[2]-150, tocolor(255,255,255), 1,sfpro2,"left","top",false,false,true)
    for key, value in ipairs(vehicleTuningDatas) do
        local forY = pos[1]+900
       -- dxDrawRectangle(startX + 2 * spacerBig + spacer, forY, width / 2 - 4 * spacerBig - 2 * spacer, 20, slotColor)
       local tuning = vehicleTunings[getElementData(selectedveh, "tuning."..value[1]) or 0 ]
       if tuning == nil then
        tuning = "#8163bfgyári"
       end
       dxDrawText("#ffffff"..value[2]..":\n "..tuning or 0, pos[1]+key*85+50,pos[1]+730,pos[1]-500,pos[2]-150, tocolor(255, 255, 255), 1, sfpro2, "left", "center", false, false, true, true)
end
end
    --	dxDrawText("Üzemanyag:", pos[1]+10,pos[2]+330-40,100,10, tocolor(255,255,255), 1,"default-bold","left","top",false,false,true)
--	dxDrawText("Állapot:", pos[1]-70,pos[2]+330-40,100,10, tocolor(255,255,255), 1,"default-bold","left","top",false,false,true)

end
end
end
end
addEventHandler("onClientRender",root,text)

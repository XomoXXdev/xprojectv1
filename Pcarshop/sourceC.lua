fileDelete ("sourceC.lua") 
local sx,sy = guiGetScreenSize()
local fix = sx*0.005
local fix2 = sx*0.1

local blocker = false
local othercolor = false
local colorPicker = {{0,0,0}}

local count = -1

local cache = {}
local start = getTickCount()

cache.roboto = dxCreateFont("files/roboto.ttf",20)
cache.fontawsome = dxCreateFont("files/fontawsome.ttf",20)
cache.bold = dxCreateFont("files/font_bold.ttf",20)

cache.carnumber = 1
cache.carshop = false
cache.choosecolor = false

function drawCarshop()
    --local id = tostring(veh[cache.carnumber][1])
    --local vehName = exports.Pmods:getVehName(veh[cache.carnumber][1])
    --local vehName = exports.Pmods:getVehName(veh[cache.carnumber][1])
    local vehName = veh[cache.carnumber][2] or "Ismeretlen (Jelentsd egy fejlesztőnek)"
    local fuelType = veh[cache.carnumber][3] or "Ismeretlen (Jelentsd egy fejlesztőnek)"
    local wheelDrive = veh[cache.carnumber][4] or "Ismeretlen (Jelentsd egy fejlesztőnek)"
    local price = tostring(veh[cache.carnumber][8]) or "Ismeretlen (Jelentsd egy fejlesztőnek)" 
    local limit = tostring(veh[cache.carnumber][9]) or "0"
    --outputChatBox(exports.Pmods:getVehName(id))
    local now = getTickCount()
    local endTime = start + 1000
    local elapsedTime = now - start
    local duration = endTime - start
    local progress = elapsedTime / duration
    local topspeed,acceleration,adherence = interpolateBetween(0, 0, 0, veh[cache.carnumber][5], veh[cache.carnumber][6], veh[cache.carnumber][7], progress, "InQuad");

    dxDrawRectangle(sx*0.0,sy*0.0,sx*0.25,sy*0.9999,tocolor(25,25,25,255))
    
    dxDrawText("JÁRMŰ",sx*0.11 - 1 - fix,sy*0.05 + 1,_,_,tocolor(0,0,0,255),0.00037*sx,cache.bold)
    dxDrawText("JÁRMŰ",sx*0.11 - fix,sy*0.05,_,_,tocolor(129, 99, 191,255),0.00037*sx,cache.bold)
    dxDrawText("VÁSÁRLÁS",sx*0.1035 - 1 - fix,sy*0.07 + 1,_,_,tocolor(0,0,0,255),0.00037*sx,cache.roboto)
    dxDrawText("VÁSÁRLÁS",sx*0.1035 - fix,sy*0.07,_,_,tocolor(129, 99, 191,255),0.00037*sx,cache.roboto)

    dxDrawText("Jármű megnevezése",sx*0.085 - 1 - fix,sy*0.2 + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.bold)
    dxDrawText("Jármű megnevezése",sx*0.085 - fix,sy*0.2,_,_,tocolor(129, 99, 191,255),0.0003*sx,cache.bold)

    --dxDrawText(vehName,sx*0.085 - fix,sy*0.2,_,_,tocolor(129, 99, 191,255),0.0003*sx,cache.bold)
    dxDrawText(vehName,sx*0.128 - dxGetTextWidth(vehName,0.00033*sx,cache.bold)/2 - fix,sy*0.225,_,_,tocolor(255,255,255,255),0.00033*sx,cache.bold)

    dxDrawText("Jármű statisztikái",sx*0.09 - 1 - fix,sy*0.3 + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.bold)
    dxDrawText("Jármű statisztikái",sx*0.09 - fix,sy*0.3,_,_,tocolor(129, 99, 191,255),0.0003*sx,cache.bold)

    dxDrawText("Végsebesség",sx*0.101 - 1 - fix,sy*0.335 + 1,_,_,tocolor(0,0,0,255),0.00033*sx,cache.roboto)
    dxDrawText("Végsebesség",sx*0.101 - fix ,sy*0.335,_,_,tocolor(230,230,230,255),0.00033*sx,cache.roboto)

    roundedRectangle(sx*0.05 - fix,sy*0.37,sx*0.16,sy*0.02,tocolor(20,20,20,255))
    roundedRectangle(sx*0.05 - fix,sy*0.37,sx*0.16*topspeed/100,sy*0.02,tocolor(129, 99, 191,255))

    dxDrawText("Gyorsulás",sx*0.107 - 1 - fix,sy*0.405 + 1,_,_,tocolor(0,0,0,255),0.00033*sx,cache.roboto)
    dxDrawText("Gyorsulás",sx*0.107 - fix ,sy*0.405,_,_,tocolor(230,230,230,255),0.00033*sx,cache.roboto)

    roundedRectangle(sx*0.05 - fix,sy*0.44,sx*0.16,sy*0.02,tocolor(20,20,20,255))
    roundedRectangle(sx*0.05 - fix,sy*0.44,sx*0.16*acceleration/100,sy*0.02,tocolor(129, 99, 191,255))

    dxDrawText("Tapadás",sx*0.11 - fix - 1,sy*0.475 + 1,_,_,tocolor(0,0,0,255),0.00033*sx,cache.roboto)
    dxDrawText("Tapadás",sx*0.11 - fix,sy*0.475,_,_,tocolor(230,230,230,255),0.00033*sx,cache.roboto)

    roundedRectangle(sx*0.05 - fix,sy*0.51,sx*0.16,sy*0.02,tocolor(20,20,20,255))
    roundedRectangle(sx*0.05 - fix,sy*0.51,sx*0.16*adherence/100,sy*0.02,tocolor(129, 99, 191,255))

    dxDrawText("Adatok",sx*0.111 - 1 - fix,sy*0.58 + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.bold)
    dxDrawText("Adatok",sx*0.111 - fix,sy*0.58,_,_,tocolor(129, 99, 191,255),0.0003*sx,cache.bold)

    dxDrawText("",sx*0.115 - dxGetTextWidth(fuelType,0.0003*sx,cache.roboto)/2 - 1 - fix,sy*0.63 + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.fontawsome)
    dxDrawText("",sx*0.115 - dxGetTextWidth(fuelType,0.0003*sx,cache.roboto)/2 - fix,sy*0.63,_,_,tocolor(255,255,255,255),0.0003*sx,cache.fontawsome)
    dxDrawText(fuelType,sx*0.117 - 1 - fix,sy*0.63 + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.roboto)
    dxDrawText(fuelType,sx*0.117 - fix,sy*0.63,_,_,tocolor(255,255,255,255),0.0003*sx,cache.roboto)

    dxDrawText("",sx*0.1 - dxGetTextWidth(wheelDrive,0.0003*sx,cache.roboto)/3.5 - 1 - fix,sy*0.66 + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.fontawsome)
    dxDrawText("",sx*0.1 - dxGetTextWidth(wheelDrive,0.0003*sx,cache.roboto)/3.5 - fix,sy*0.66,_,_,tocolor(255,255,255,255),0.0003*sx,cache.fontawsome)
    dxDrawText(wheelDrive,sx*0.1 - 1 - fix,sy*0.66 + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.roboto)
    dxDrawText(wheelDrive,sx*0.1 - fix,sy*0.66,_,_,tocolor(255,255,255,255),0.0003*sx,cache.roboto)

    dxDrawText("ÁR",sx*0.118 - 1 - fix,sy*0.77 + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.bold)
    dxDrawText("ÁR",sx*0.118 - fix,sy*0.77,_,_,tocolor(129, 99, 191,255),0.0003*sx,cache.bold)

    if not othercolor then 
    price = price
    dxDrawText(formatMoney(price).."$",sx*0.12 - dxGetTextWidth(formatMoney(price),0.00035*sx,cache.bold)/2 - 1 - fix,sy*0.79 + 1,_,_,tocolor(0,0,0,255),0.00035*sx,cache.bold,"left","top",false,false,false,true)
    dxDrawText(formatMoney(price).."#8163bf$",sx*0.12 - dxGetTextWidth(formatMoney(price),0.00035*sx,cache.bold)/2 - fix,sy*0.79,_,_,tocolor(230,230,230,255),0.00035*sx,cache.bold,"left","top",false,false,false,true)
    else 
    price = price + 750
    dxDrawText(formatMoney(price) .."$",sx*0.12 - dxGetTextWidth(formatMoney(price),0.00035*sx,cache.bold)/2 - 1 - fix,sy*0.79 + 1,_,_,tocolor(0,0,0,255),0.00035*sx,cache.bold,"left","top",false,false,false,true)
    dxDrawText(formatMoney(price) .."#8163bf$",sx*0.12 - dxGetTextWidth(formatMoney(price),0.00035*sx,cache.bold)/2 - fix,sy*0.79,_,_,tocolor(230,230,230,255),0.00035*sx,cache.bold,"left","top",false,false,false,true)
    end 

    dxDrawText("Limit: "..count.."/"..limit,sx*0.125 - dxGetTextWidth("Limit: "..count.."/"..limit,0.00035*sx,cache.roboto)/2 - fix - 1,sy*0.9 + 1,_,_,tocolor(0,0,0,255),0.00035*sx,cache.roboto,"left","top",false,false,false,true)
    dxDrawText("Limit: "..count.."/"..limit,sx*0.125 - dxGetTextWidth("Limit: "..count.."/"..limit,0.00035*sx,cache.roboto)/2 - fix,sy*0.9,_,_,tocolor(230,230,230,255),0.00035*sx,cache.roboto,"left","top",false,false,false,true)

    dxDrawRectangle(sx*0.075 - fix,sy*0.93,sx*0.1,sy*0.04,tocolor(20,20,20,255))

    if isInSlot(sx*0.075 - fix,sy*0.93,sx*0.1,sy*0.04) then 
    dxDrawText("Fizetés készpénzel",sx*0.09 - 1 - fix,sy*0.94 + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.roboto)
    dxDrawText("Fizetés készpénzel",sx*0.09 - fix,sy*0.94,_,_,tocolor(129, 99, 191,255),0.0003*sx,cache.roboto)
    else 
    dxDrawText("Fizetés készpénzel",sx*0.09 - 1 - fix,sy*0.94 + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.roboto)
    dxDrawText("Fizetés készpénzel",sx*0.09 - fix, sy*0.94,_,_,tocolor(230,230,230,255),0.0003*sx,cache.roboto)
    end 

    dxDrawText("Kilépéshez/visszalépéshez a backspace gombot, lapozáshoz pedig a nyilakat használd.",sx*0.48 - 1 - fix,sy*0.97 + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.roboto,"left","top",false,false,false,true)
    dxDrawText("Kilépéshez/visszalépéshez a #8163bfbackspace#ffffff gombot, lapozáshoz pedig a #8163bfnyilakat#ffffff használd.",sx*0.48 - fix,sy*0.97,_,_,tocolor(255,255,255,255),0.0003*sx,cache.roboto,"left","top",false,false,false,true)

    if cache.choosecolor then 
        dxDrawRectangle(sx*0.4 + fix2,sy*0.32,sx*0.2,sy*0.32,tocolor(31,31,31,255))
    

        dxDrawRectangle(sx*0.45 + fix2,sy*0.59,sx*0.1,sy*0.04,tocolor(20,20,20,200))

    
        if isInSlot(sx*0.44 + fix2,sy*0.55,sx*0.01,sy*0.017) then 
            dxDrawRectangle(sx*0.44 + fix2,sy*0.55,sx*0.01,sy*0.017,tocolor(20,20,20,200))
            dxDrawRectangle(sx*0.44 + fix2,sy*0.55,sx*0.01,sy*0.017,tocolor(129, 99, 191,50))
        else 
            dxDrawRectangle(sx*0.44 + fix2,sy*0.55,sx*0.01,sy*0.017,tocolor(20,20,20,200))
        end
    
        if othercolor then 
            dxDrawRectangle(sx*0.441 + fix2,sy*0.552,sx*0.008,sy*0.013,tocolor(129, 99, 191,200))
        end
    
            dxDrawText("Egyedi színt kérek! #8163bf(+750$)",sx*0.46 + fix2,sy*0.5502,_,_,tocolor(255,255,255,255),0.0003*sx,cache.roboto,"left","top",false,false,false,true)

            if isInSlot(sx*0.45 + fix2,sy*0.59,sx*0.1,sy*0.04) then 
                dxDrawText("Fizetés",sx*0.485 - 1 + fix2,sy*0.599 + 1,_,_,tocolor(0,0,0,255),0.00033*sx,cache.roboto)
                dxDrawText("Fizetés",sx*0.485 + fix2,sy*0.599,_,_,tocolor(129, 99, 191,255),0.00033*sx,cache.roboto)
            else 
                dxDrawText("Fizetés",sx*0.485 - 1 + fix2,sy*0.599 + 1,_,_,tocolor(0,0,0,255),0.00033*sx,cache.roboto)
                dxDrawText("Fizetés",sx*0.485 + fix2,sy*0.599,_,_,tocolor(255,255,255,255),0.00033*sx,cache.roboto)
            end


    end 
end 

function triggerCarshop(element)
    if element == localPlayer then 
        setElementData(localPlayer,"player:toghud",true)
        showChat(false)
        showCursor(true)
        fadeCamera(false)
        cache.carshop = true 
        num = math.random(1,100)*getElementData(localPlayer,"player:dbid")
        triggerServerEvent("openCarshop",localPlayer,localPlayer,num)
        vehicle = createVehicle(veh[cache.carnumber][1],1709.392578125, 1804.0283203125, 11.420310974121,0,0,258.08102416992,"Model")
        count = -1
        countVehicles(vehicle)
        setElementDimension(vehicle,num)
        setElementFrozen(localPlayer,true)
        setTimer(function()
            fadeCamera(true)
            setCameraMatrix(1735.5250244141,1799.1290283203,15.394399642944,1734.5837402344,1799.3203125,15.116074562073)
            addEventHandler("onClientRender",root,drawCarshop)
            start = getTickCount()
        end,1500,1)
    end 
end 
addEvent("triggerCarshop",true)
addEventHandler("triggerCarshop",root,triggerCarshop)

function triggerQuitAfterSuccessBuy(element)
    if element == localPlayer then 
        fadeCamera(false)
        destroyColorPicker()  
        removeEventHandler("onClientRender",root,drawCarshop)
        destroyElement(vehicle)
            setTimer(function()

                setElementFrozen(localPlayer,false)
                fadeCamera(true)
                showChat(true)
                showCursor(false)
                cache.choosecolor = false
                othercolor = false
                cache.carshop = false 
                setCameraTarget(localPlayer)
                triggerServerEvent("quitCarshop",localPlayer,localPlayer)
                setElementData(localPlayer,"player:toghud",false)
                count = -1

            end,1500,1)
    end 
end
addEvent("triggerQuitAfterSuccessBuy",true)
addEventHandler("triggerQuitAfterSuccessBuy",root,triggerQuitAfterSuccessBuy)

addEventHandler("onClientKey",root,function(button,state)
    if cache.carshop then 
        if button == "backspace" then 
            if state then 
                if not cache.choosecolor then 
                fadeCamera(false)
                removeEventHandler("onClientRender",root,drawCarshop)
                destroyElement(vehicle)
                    setTimer(function()

                        setElementFrozen(localPlayer,false)
                        fadeCamera(true)
                        showChat(true)
                        showCursor(false)
                        othercolor = false
                        cache.carshop = false 
                        setCameraTarget(localPlayer)
                        triggerServerEvent("quitCarshop",localPlayer,localPlayer)
                        setElementData(localPlayer,"player:toghud",false)
                        count = -1

                    end,1500,1)
                else 
                    cache.choosecolor = false 
                    destroyColorPicker()  
                end 
            end 
        elseif button == "arrow_r" then 
            if state then 
                if cache.carnumber >= 1 and cache.carnumber < #veh then 
                    if not blocker then
                    cache.carnumber = cache.carnumber + 1 
                    setElementModel(vehicle,veh[cache.carnumber][1])
                    start = getTickCount()
                    setElementPosition(vehicle,1709.392578125, 1804.0283203125, 11.420310974121)
                    setElementRotation(vehicle,0,0,258.08102416992)
                    blocker = true 
                    count = -1
                    countVehicles(vehicle)
                    
                    setTimer(function()
                        blocker = false 
                    end,1000,1)
                    end
                end 
            end 
        elseif button == "arrow_l" then 
            if state then 
                if cache.carnumber > 1 then 
                    if not blocker then 
                    cache.carnumber = cache.carnumber - 1 
                    setElementModel(vehicle,veh[cache.carnumber][1])
                    start = getTickCount()
                    setElementPosition(vehicle,1709.392578125, 1804.0283203125, 11.420310974121)
                    setElementRotation(vehicle,0,0,258.08102416992)
                    blocker = true 
                    count = -1
                    countVehicles(vehicle)

                    setTimer(function()
                        blocker = false 
                    end,1000,1)
                    end
                end 
            end 
        end 
    end 
end)

addEventHandler("onClientClick",root,function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
    if button == "left" and state == "down" then 
        if cache.carshop then 
            if isInSlot(sx*0.075 - fix,sy*0.93,sx*0.1,sy*0.04) then  --keszpenz fizetes
                picker = createColorPicker(colorPicker[1],sx*0.425 + fix2,sy*0.33,sx*0.15,sy*0.19, "color1")
                cache.choosecolor = true
            end

            if cache.choosecolor then 
                if isInSlot(sx*0.44 + fix2,sy*0.55,sx*0.01,sy*0.017) then 
                    if not othercolor then 
                        othercolor = true 
                    else 
                        othercolor = false
                    end 
                elseif isInSlot(sx*0.45 + fix2,sy*0.59,sx*0.1,sy*0.04) then 
                    if count >= veh[cache.carnumber][9] then
                        exports["Pinfobox"]:addNotification("Ez a jármű már elérte a limitet.","error")
                    else 
                        if othercolor then 
                            local r,g,b = getPaletteColor()
                            local park = math.random(1,#spawnpos)
                            local finalprice = veh[cache.carnumber][8] + 750
                            triggerServerEvent("buyVehicle",localPlayer,localPlayer,getElementModel(vehicle),veh[cache.carnumber][2],r,g,b,spawnpos[park][1],spawnpos[park][2],spawnpos[park][3],spawnpos[park][4],finalprice)
                        else 
                            local cr,cg,cb = getVehicleColor(vehicle,true)
                            local park = math.random(1,#spawnpos)   
                            local finalprice = veh[cache.carnumber][8]
                            triggerServerEvent("buyVehicle",localPlayer,localPlayer,getElementModel(vehicle),veh[cache.carnumber][2],cr,cg,cb,spawnpos[park][1],spawnpos[park][2],spawnpos[park][3],spawnpos[park][4],finalprice)
                        end 
                    end 
                end 
            end 
        end 
    end 
end)

function countVehicles(vehicle)

    local vehicleModel = getElementModel(vehicle)

    for k,veh in pairs(getElementsByType("vehicle")) do 
        if getElementModel(veh) == vehicleModel then 
            count = count + 1
        end 
    end 

end 
fileDelete ("sourceC.lua") 
local sx,sy = guiGetScreenSize()
local cache = {}

local start = getTickCount()
local boolean = false

local minute = 9 
local secound = 15

cache.roboto = dxCreateFont("files/roboto.ttf",50)  
cache.roboto2 = dxCreateFont("files/roboto.ttf",17)  
cache.fontawsome = dxCreateFont("files/fontawsome.ttf",20)  
cache.vignette = dxCreateTexture("files/vignette.png")
setElementData(localPlayer,"player:injured",false)


addEventHandler("onClientRender",root,function()
    if getElementData(localPlayer,"player:loggedIn") then 
    setElementData(localPlayer,"player:health",getElementHealth(localPlayer))
    end 
end)

addEventHandler("onClientResourceStart",resourceRoot,function()
    if isPlayerDead(localPlayer) then 
    local x,y,z = getElementPosition(localPlayer)
    triggerServerEvent("onClientRespawn",localPlayer,localPlayer,x,y,z)
    showChat(true)
    setCameraTarget(localPlayer)
    setElementData(localPlayer,"toGetUp",false)
    end
end)

                                                            -- HALÁL RENDSZER --

function drawDead()
    if isPlayerDead(localPlayer) then
        local now = getTickCount()
        local endTime = start + 2000
        local elapsedTime = now - start
        local duration = endTime - start
        local progress = elapsedTime / duration 
        local alpha,scale = interpolateBetween ( 0,0,0,200,0.00015,0, progress, "SineCurve")


        dxDrawRectangle(0,0,sx*0.9999,sy*0.9999,tocolor(255,255,255,50))
        dxDrawImage(0,0,sx*0.9999,sy*0.9999,cache.vignette,0,0,0,tocolor(255,255,255,alpha))

        if secound < 10 then 
        dxDrawText("0"..minute..":0"..secound,sx*0.5 - 1,sy*0.45 + 1,_,_,tocolor(0,0,0,255),0.00035*sx + scale*sx,cache.roboto,"center")
        dxDrawText("0"..minute..":0"..secound,sx*0.5,sy*0.45,_,_,tocolor(255,255,255,255),0.00035*sx + scale*sx,cache.roboto,"center")
        else 
        dxDrawText("0"..minute..":"..secound,sx*0.5 - 1,sy*0.45 + 1,_,_,tocolor(0,0,0,255),0.00035*sx + scale*sx,cache.roboto,"center")
        dxDrawText("0"..minute..":"..secound,sx*0.5,sy*0.45,_,_,tocolor(255,255,255,255),0.00035*sx + scale*sx,cache.roboto,"center")
        end 
    end 
end 

addEventHandler("onClientPlayerWasted",getRootElement(),function()
    if source == localPlayer then 
    setElementData(localPlayer,"player:injured",false)
    musicplayer = playSound("files/music.mp3",true)
    addEventHandler("onClientRender",root,drawDead)
    showChat(false)
    minute = 9
    secound = 59
    local x,y,z = getElementPosition(localPlayer)
    setElementData(localPlayer,"deadX",x)
    setElementData(localPlayer,"deadY",y)
    setElementData(localPlayer,"deadZ",z)
    setCameraMatrix(x,y,z + 10,x,y,z - 1000)
    end
end)

setTimer(function()
    if isPlayerDead(localPlayer) and not getElementData(localPlayer,"player:injured") then  

    if minute == 0 and secound == 1 then 
        triggerServerEvent("onClientRespawn",localPlayer,localPlayer,1612.900390625, 1818.640625, 10.8203125)
        showChat(true)
        minute = 9 
        secound = 59
        setCameraTarget(localPlayer)
        removeEventHandler("onClientRender",root,drawDead)
        stopSound(musicplayer)
        outputChatBox("#c23a3a[Korház] #ffffffSikeresen újraéledtél, figyelj oda hogy betartsd az erre vonatkozó szabályokat!",255,255,255,true)
    end 

     if secound > 0 then 
        secound = secound - 1
     
       if secound == 0 then 
        secound = 59 
        minute = minute - 1
       end

     end 

    end 
end,1000,0)

function toRespawnCommandC()
    removeEventHandler("onClientRender",root,drawDead)
    stopSound(musicplayer)
    minute = 9 
    secound = 59
    showChat(true)
    setElementData(localPlayer,"player:injured",false)
    setElementData(localPlayer,"toGetUp",false)
end 
addEvent("toRespawnCommandC",true)
addEventHandler("toRespawnCommandC",root,toRespawnCommandC)

                                                            -- HALÁL RENDSZER VÉGE --
   

                                                               -- ANIM RENDSZER --

function drawAnim()
    if getElementData(localPlayer,"player:injured") then 
        local now = getTickCount()
        local endTime = start + 2000
        local elapsedTime = now - start
        local duration = endTime - start
        local progress = elapsedTime / duration 
        local alpha,scale = interpolateBetween ( 0,0,0,200,0.00015,0, progress, "SineCurve")


        dxDrawRectangle(0,0,sx*0.9999,sy*0.9999,tocolor(255,255,255,50))
        dxDrawImage(0,0,sx*0.9999,sy*0.9999,cache.vignette,0,0,0,tocolor(255,255,255,alpha))

        if boolean then 

            dxDrawRectangle(0,0,sx*0.9999,sy*0.9999,tocolor(179, 37, 37,50))
            dxDrawImage(0,0,sx*0.9999,sy*0.9999,cache.vignette,0,0,0,tocolor(179, 37, 37,alpha))
    
            if secound < 10 then 
            dxDrawText("0"..minute..":0"..secound,sx*0.5 - 1,sy*0.45 + 1,_,_,tocolor(0,0,0,255),0.00035*sx + scale*sx,cache.roboto,"center")
            dxDrawText("0"..minute..":0"..secound,sx*0.5,sy*0.45,_,_,tocolor(179, 37, 37,255),0.00035*sx + scale*sx,cache.roboto,"center")
            else 
            dxDrawText("0"..minute..":"..secound,sx*0.5 - 1,sy*0.45 + 1,_,_,tocolor(0,0,0,255),0.00035*sx + scale*sx,cache.roboto,"center")
            dxDrawText("0"..minute..":"..secound,sx*0.5,sy*0.45,_,_,tocolor(179, 37, 37,255),0.00035*sx + scale*sx,cache.roboto,"center")
            end 
    
            else 
    
            dxDrawRectangle(0,0,sx*0.9999,sy*0.9999,tocolor(255,255,255,50))
            dxDrawImage(0,0,sx*0.9999,sy*0.9999,cache.vignette,0,0,0,tocolor(255,255,255,alpha))
    
            if secound < 10 then 
            dxDrawText("0"..minute..":0"..secound,sx*0.5 - 1,sy*0.45 + 1,_,_,tocolor(0,0,0,255),0.00035*sx + scale*sx,cache.roboto,"center")
            dxDrawText("0"..minute..":0"..secound,sx*0.5,sy*0.45,_,_,tocolor(255,255,255,255),0.00035*sx + scale*sx,cache.roboto,"center")
            else 
            dxDrawText("0"..minute..":"..secound,sx*0.5 - 1,sy*0.45 + 1,_,_,tocolor(0,0,0,255),0.00035*sx + scale*sx,cache.roboto,"center")
            dxDrawText("0"..minute..":"..secound,sx*0.5,sy*0.45,_,_,tocolor(255,255,255,255),0.00035*sx + scale*sx,cache.roboto,"center")
            end 
    
        end  

    end 
end                                                                

addEventHandler("onClientElementDataChange",getRootElement(),function(dataName,oldValue)
    if (dataName == "player:health") then
    if (getElementType(localPlayer) == "player") and getElementData(localPlayer,"player:loggedIn") then
      if getElementData(localPlayer,"player:health") < 20 and getElementData(localPlayer,"player:health") > 1 and not isPlayerDead(localPlayer) and not getElementData(localPlayer,"player:injured") then 
        
        exports["Pinfobox"]:addNotification("Súlyosan megsérültél! Részletek a chatboxban.","info");
        outputChatBox("#c23a3a[Figyelmeztetés] #ffffffSúlyosan megsérültél ezért nem vagy képes a további mozgásra, ha 10 percen belűl nem érkezik segítség meghalsz!",255,255,255,true)
        setElementData(localPlayer,"player:injured",true)
        triggerServerEvent("setPlayerAnim",root,localPlayer)
        addEventHandler("onClientRender",root,drawAnim)
        minute = 9
        secound = 59
		setElementFrozen(localPlayer,true)

      elseif getElementData(localPlayer,"player:health") > 20 and getElementData(localPlayer,"player:injured") then 

        setElementData(localPlayer,"player:injured",false)
        removeEventHandler("onClientRender",root,drawAnim)
        triggerServerEvent("setPlayerOutOfAnim",localPlayer,localPlayer)
        minute = 9 
        secound = 59
        boolean = false 
		setElementFrozen(localPlayer,false)

      end
    end
    end
end)

setTimer(function()
    if getElementData(localPlayer,"player:injured") and not isPlayerDead(localPlayer) then  

    if minute == 0 and secound == 1 then 
        setElementHealth(localPlayer,0)
        setElementData(localPlayer,"player:injured",false)
        removeEventHandler("onClientRender",root,drawAnim)
        boolean = false 
    end 

    if minute == 2 and secound == 59 then
        boolean = true 
    end 

     if secound > 0 then 
        secound = secound - 1
     
       if secound == 0 then 
        secound = 59 
        minute = minute - 1
       end

     end 

    end 
end,1000,0)

local damageC = 0
addEventHandler("onClientVehicleCollision", root, function(collider, force, bodyPart, x, y, z, nx, ny, nz)
  if source == getPedOccupiedVehicle(localPlayer) then
  local fDamageMultiplier = getVehicleHandling(source).collisionDamageMultiplier
  local realDamage = (force*fDamageMultiplier)*0.1
  damagecounter = realDamage/4
  damagedElement = true 
  if damagecounter > 5 and not getElementData(localPlayer,"player:adminduty") then
   if not getElementData(localPlayer,"player:seatbelt") then 
   setElementHealth(localPlayer,getElementHealth(localPlayer) - realDamage/2)
   else 
   setElementHealth(localPlayer,getElementHealth(localPlayer) - realDamage/3.5);
   end

   if not alert then 
    alert = true 
    alpha = 0
    alertCount = 0
    addEventHandler("onClientRender",root,drawAlert)
    setTimer(function()
        alert = false
        removeEventHandler("onClientRender",root,drawAlert)
    end,1200,1)
   end 

  end

  end
end)

function drawAlert ()
    if alert then 
    alertCount = getTickCount()
    local alpha = interpolateBetween(0, 0, 0, 120, 0, 0, alertCount/ 2000, "CosineCurve");
    local r, g, b = 244, 67, 54
    nameColor = string.format("#%.2X%.2X%.2X", r, g, b);

    dxDrawImage(0,0,sx*0.9999,sy*0.9999,"files/alert.png",0,0,0,tocolor(r, g, b ,alpha))
    end 
end 


 --minigame

local randomPos = {
    {sx*0.46,6000,116,78},{sx*0.455,7000,107,67},{sx*0.48,6500,155,116},{sx*0.50,8000,194,153},{sx*0.53,8500,251,212},
  }

local spaceState = false
local randomNum = math.random(1,#randomPos)
local minigameStarted = false
start2 = 0
local startP = 0 
local stopP = 308
start2 = 0
local inMinigame = false

function revive(commandName, target)
    if not target then outputChatBox("#c23a3a[Felsegítés] #ffffff/"..commandName.." [ID]",255,255,255,true) return end 
    local targetPlayer, targetPlayerName = exports["Pcore"]:findPlayerByPartialNick(localPlayer, target)
    if getElementData(targetPlayer,"player:injured") then 
        if exports["inventory"]:hasItem(121) then 
            if not isPlayerDead(targetPlayer) then 
                outputChatBox(getElementData(targetPlayer,"player:charname"))
                if localPlayer == targetPlayer then 

                    startMinigame()
                    exports["Pchat"]:takeMessage("me","lassan és óvatosan elkezdi ellátni a saját sebeit.")
                    setElementData(targetPlayer,"toGetUp",true)
                    element = targetPlayer
                    exports["inventory"]:takeItem(121)
                else    

                    startMinigame()
                    exports["Pchat"]:takeMessage("me","elkezdte felsegíteni "..utf8.gsub(getElementData(targetPlayer,"player:charname"),"_"," ").." t/et.")
                    setElementData(targetPlayer,"toGetUp",true)
                    element = targetPlayer
                    exports["inventory"]:takeItem(121)
                end 
            else 
            outputChatBox("#c23a3a[Felsegítés] #ffffffA kiválasztott játékos már halott.",255,255,255,true)
            end 
        else 
            outputChatBox("#c23a3a[Felsegítés] #ffffffNincs nálad egészségügyi doboz.",255,255,255,true)
        end 
    else 
        outputChatBox("#c23a3a[Felsegítés] #ffffffA kiválasztott játékos nincs animban.",255,255,255,true)
    end 
end 
addCommandHandler("felsegit",revive)

function startMinigame()
    inMinigame = true 
    addEventHandler("onClientRender",root,drawMinigame)
end 
addEvent("startMinigame",true)
addEventHandler("startMinigame",root,startMinigame)
  
bindKey("space","down",function() if inMinigame then  spaceState = true if math.floor(tostring(dxWeight)) < 290 then  start2 = start2 + 300 end end end)
bindKey("space","up",function() if inMinigame then spaceState = false end end)
bindKey("enter","down",function()
    if not minigameStarted and inMinigame then
        start2 = getTickCount()
        minigameStarted = true 
        setTimer(function() 
         if math.floor(tostring(dxWeight)) < randomPos[randomNum][3] and math.floor(tostring(dxWeight)) > randomPos[randomNum][4] then 
            removeEventHandler("onClientRender",root,drawMinigame)
            --exports["inventory"]:takeItem(99)
            inMinigame = false
            minigameStarted = false
            triggerServerEvent("setPlayerHpUp",localPlayer,element)
            outputChatBox("#ab2b2b[Felsegítés] #ffffffSikeresen felsegítetted "..getElementData(element,"player:charname").." t/et.",255,255,255,true)
            exports["Pchat"]:takeMessage("me","felsegítette "..getElementData(element,"player:charname").." t/et.")
            setElementData(element,"toGetUp",false)
         else 
          removeEventHandler("onClientRender",root,drawMinigame)
          --exports["vice_inventory"]:takeItem(99)
          minigameStarted = false
          inMinigame = false
          triggerServerEvent("setPlayerHpDown",localPlayer,element)
          outputChatBox("#ab2b2b[Felsegítés] #ffffffSajnos elrontottad a felsegítést.",255,255,255,true)
          setElementData(element,"toGetUp",false)
          end
        end,randomPos[randomNum][2],1)
    end
end)

function drawMinigame()

    local now = getTickCount()
    local endTime = start2 + 2000
    local elapsedTime = now - start2
    local duration = endTime - start2
    local progress = elapsedTime / duration/2
    dxWeight = interpolateBetween(308,0,0,0,0,0, progress, "Linear")
  
  
    dxDrawRectangle(sx*0.42,sy*0.25,308,sy*0.014,tocolor(0,0,0,150))
    dxDrawRectangle(sx*0.42,sy*0.25,dxWeight,sy*0.014,tocolor(255,255,255,200))
    dxDrawRectangle(randomPos[randomNum][1],sy*0.25,40,sy*0.014,tocolor(120,120,120,200))
    dxDrawText("Tartsd a csúszkát a megadott tartományon belűl.",sx*0.415 - 1,sy*0.27 + 1,_,_,tocolor(0,0,0,255),0.00035*sx,cache.roboto2)
    dxDrawText("Tartsd a csúszkát a megadott tartományon belűl.",sx*0.415,sy*0.27,_,_,tocolor(255,255,255,255),0.00035*sx,cache.roboto2)
    dxDrawText("A kezdéshez az #000000enter-t #000000, a mozgatáshoz használd a #000000spacet#000000.",sx*0.397 - 1,sy*0.285 + 1,_,_,tocolor(0,0,0,255),0.00035*sx,cache.roboto2,"left","top",false,false,false,true)
    dxDrawText("A kezdéshez az #e34058enter-t #ffffff, a mozgatáshoz használd a #e34058spacet#ffffff.",sx*0.397,sy*0.285,_,_,tocolor(255,255,255,255),0.00035*sx,cache.roboto2,"left","top",false,false,false,true)
  
    
end 

  --

                                                             -- ANIM RENDSZER VÉGE --                                                         

fileDelete ("sourceC.lua") 
local sx,sy = guiGetScreenSize()
start = getTickCount()
local cache = {}
local playerCache = {}
local show = false
cache.roboto = dxCreateFont("files/sfpro.ttf",20)
cache.sfpro = dxCreateFont("files/sfpro.ttf",20)
cache.fontawsome = dxCreateFont("files/sfpro.ttf",20)
--cache.maxplayers = triggerServerEvent("score:getMaxPlayers", resourceRoot, localPlayer)
local online = 0 
local maxshow = 14
local scrolvaule = 0
cache.maxplayers = 0

addEvent("score:receiveMaxPlayers", true)
addEventHandler("score:receiveMaxPlayers",root,function(maxPlayers)
    cache.maxplayers = maxPlayers
end)

addEventHandler("onClientResourceStart",root,function()
	if source ~= getResourceRootElement() then return end
	triggerServerEvent("score:getMaxPlayers", resourceRoot, localPlayer)
end)


addEventHandler("onClientResourceStart", resourceRoot, function()
    playerCache = getElementsByType("player")
    online = #playerCache
  end)
  
  
  addEventHandler("onClientPlayerJoin", getRootElement(), function()
    table.insert(playerCache, source)
    online = #playerCache
  end)
  
  addEventHandler("onClientPlayerQuit", getRootElement(), function()
    for k, v in ipairs(playerCache) do
        if v == source then
            table.remove(playerCache, k)
            online = #playerCache
        end
    end
  end)
  
  
function drawPanel()
if show and getElementData(localPlayer,"player:loggedIn") and not getElementData(localPlayer,"player:toghud") then 
        local players = online.."/"..cache.maxplayers
        local lenght = dxGetTextWidth(players,0.00022*sx,cache.sfpro)
        local now = getTickCount()
        local elapsedTime = now - start
        local endTime = start + 200
        local duration = endTime - start
        local progress = elapsedTime / duration

        local _,alpha,_ = interpolateBetween ( 0, 0, 0, 0, 255, 0, progress, "Linear")
     --   dxDrawImage(sx*0.395,sy*0.2,sx*0.22,sy*0.5,"files/logo.png",0,0,0,tocolor(129, 99, 191,alpha))
        dxDrawRectangle(sx*0.395,sy*0.2,sx*0.22,sy*0.5,tocolor(32,32,32,alpha))
        dxDrawRectangle(sx*0.395,sy*0.2,sx*0.22,sy*0.04,tocolor(28,28,28,alpha))
        dxDrawRectangle(sx*0.395,sy*0.24,sx*0.22,sy*0.001,tocolor(129, 99, 191,alpha))
        dxDrawText("xProject",sx*0.49 - 1,sy*0.205 + 1,_,_,tocolor(0,0,0,alpha),0.00027*sx,cache.sfpro)
        dxDrawText("xProject",sx*0.49,sy*0.205,_,_,tocolor(129, 99, 191,alpha),0.00027*sx,cache.sfpro)
        dxDrawText("Las Venturas",sx*0.484 - 1,sy*0.22 + 1,_,_,tocolor(0,0,0,alpha),0.00023*sx,cache.sfpro)
        dxDrawText("Las Venturas",sx*0.484,sy*0.22,_,_,tocolor(240,240,240,alpha),0.00023*sx,cache.sfpro)

        dxDrawRectangle(sx*0.395,sy*0.694,sx*0.22,sy*0.04,tocolor(28,28,28,alpha))
        dxDrawRectangle(sx*0.42,sy*0.692,sx*0.17,sy*0.001,tocolor(129, 99, 191,alpha))
        dxDrawText("Jelenlegi játékosok",sx*0.478 - 1,sy*0.7 + 1,_,_,tocolor(0,0,0,alpha),0.00022*sx,cache.sfpro)
        dxDrawText("Jelenlegi játékosok",sx*0.478,sy*0.7,_,_,tocolor(240,240,240,alpha),0.00022*sx,cache.sfpro)
        dxDrawText(players,sx*0.9999 + sx*0.01 - 1,sy*0.715 + 1,_,_,tocolor(0,0,0,alpha),0.00022*sx,cache.sfpro,"center")
        dxDrawText(players,sx*0.9999 + sx*0.01,sy*0.715,_,_,tocolor(240,240,240,alpha),0.00022*sx,cache.sfpro,"center")
        --dxDrawText("",sx*0.492 - lenght/2 - 1 ,sy*0.715 + 1,_,_,tocolor(0,0,0,alpha),0.00021*sx,cache.fontawsome)
        --dxDrawText("",sx*0.492 - lenght/2,sy*0.715,_,_,tocolor(240,240,240,alpha),0.00021*sx,cache.fontawsome)
        
        for i = 1,15 do 
            dxDrawRectangle(sx*0.395,sy*0.214 + (i*sy*0.03),sx*0.22,sy*0.0275,tocolor(28,28,28,alpha))
        end 
        dxDrawRectangle(sx*0.395,sy*0.274 ,sx*0.001,sy*0.0275,tocolor(129, 99, 191,255))
        dxDrawText("ID",sx*0.40,sy*0.247,_,_,tocolor(75,75,75,alpha),0.0003*sx,cache.roboto)
        dxDrawText("Játékosnév",sx*0.45  ,sy*0.247,_,_,tocolor(75,75,75,alpha),0.0003*sx,cache.roboto)
        dxDrawText("Szint",sx*0.535  ,sy*0.247,_,_,tocolor(75,75,75,alpha),0.0003*sx,cache.roboto)
        dxDrawText("Ping",sx*0.594  ,sy*0.247,_,_,tocolor(75,75,75,alpha),0.0003*sx,cache.roboto)
        for k,player in pairs(playerCache) do 
          if k <= maxshow and (k > scrolvaule) then
            
            lvl = getElementData(player,"player:level") or 5
            ping = getPlayerPing(player)
            alevel = getElementData(player,"player:admin") or 0
            aslevel = getElementData(player,"player:helper") or 0

            levelColor = "#ffffff"
            pingColor = "#ffffff"
            prefixColor = "#ffffff"

            if lvl > -1 and lvl < 10 then 
              levelColor = "#8163bf"
            elseif lvl > 9 and lvl < 30 then
              levelColor = "#4287f5"
            elseif lvl > 29 and lvl < 100 or lvl == 100 then 
              levelColor = "#d13434"
            end 
            
            if ping > -1 and ping < 70 then 
              pingColor = "#ffffff" 
            elseif ping > 69 and ping < 400 then 
              pingColor = "#c96e38" 
            elseif ping > 399 then 
              pingColor = "#c72828"
            end
        
            if alevel == 1 or alevel == 2 then 
             prefixColor = "#f68934"
            elseif alevel == 3 then 
             prefixColor = "#f68934"
            elseif alevel == 4 then 
             prefixColor = "#f68934"
			elseif alevel == 5 then 
             prefixColor = "#f68934"
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
            end
            

            if getElementData(player,"player:loggedIn") then 
              if not getElementData(player,"player:adminduty") then 
			    local textas = ""
				if getElementData(player,"player:helper") == 1 then
				    textas = "(IDGAS)"
				elseif getElementData(player,"player:helper") == 2 then
				    textas = "(AS)"
				end
              dxDrawText(getElementData(player,"player:id"),sx*0.4035 - dxGetTextWidth(getElementData(player,"player:id"),0.0003*sx,cache.roboto)/2 - 1,sy*0.278 + sy*0.03 *(k-scrolvaule-1) + 1,_,_,tocolor(0,0,0,alpha),0.0003*sx,cache.roboto,"left","top",false,false,false,true)
              dxDrawText(getElementData(player,"player:id"),sx*0.4035 - dxGetTextWidth(getElementData(player,"player:id"),0.0003*sx,cache.roboto)/2,sy*0.278 + sy*0.03 *(k-scrolvaule-1),_,_,tocolor(240,240,240,alpha),0.0003*sx,cache.roboto,"left","top",false,false,false,true)
              dxDrawText(utf8.gsub(getElementData(player,"player:charname"),"_"," ").." "..textas.."",sx*0.472- dxGetTextWidth(getElementData(player,"player:charname"),0.0003*sx,cache.roboto)/2 - 1,sy*0.278 + sy*0.03 *(k-scrolvaule-1) + 1,_,_,tocolor(0,0,0,alpha),0.0003*sx,cache.roboto,"left","top",false,false,false,true)
              dxDrawText(utf8.gsub(getElementData(player,"player:charname"),"_"," ").." #f68934"..textas.."",sx*0.472- dxGetTextWidth(getElementData(player,"player:charname"),0.0003*sx,cache.roboto)/2,sy*0.278 + sy*0.03 *(k-scrolvaule-1),_,_,tocolor(240,240,240,alpha),0.0003*sx,cache.roboto,"left","top",false,false,false,true)
              dxDrawText(tostring(lvl),sx*0.545- dxGetTextWidth(lvl,0.0003*sx,cache.roboto)/2 - 1,sy*0.278 + sy*0.03 *(k-scrolvaule-1) + 1,_,_,tocolor(0,0,0,alpha),0.0003*sx,cache.roboto,"left","top",false,false,false,true)
              dxDrawText(levelColor..lvl,sx*0.545- dxGetTextWidth(lvl,0.0003*sx,cache.roboto)/2,sy*0.278 + sy*0.03 *(k-scrolvaule-1),_,_,tocolor(240,240,240,alpha),0.0003*sx,cache.roboto,"left","top",false,false,false,true)
              dxDrawText(ping.."ms",sx*0.61- dxGetTextWidth(ping.."ms",0.0003*sx,cache.roboto) - 1,sy*0.278 + sy*0.03 *(k-scrolvaule-1) + 1,_,_,tocolor(0,0,0,alpha),0.0003*sx,cache.roboto,"left","top",false,false,false,true)
              dxDrawText(pingColor..ping.."ms",sx*0.61- dxGetTextWidth(ping.."ms",0.0003*sx,cache.roboto),sy*0.278 + sy*0.03 *(k-scrolvaule-1),_,_,tocolor(240,240,240,alpha),0.0003*sx,cache.roboto,"left","top",false,false,false,true)
              else 
                title = exports["Padmin"]:getAdminTitle(getElementData(player,"player:admin"))

                dxDrawText(getElementData(player,"player:id"),sx*0.4035 - dxGetTextWidth(getElementData(player,"player:id"),0.0003*sx,cache.roboto)/2 - 1,sy*0.278 + sy*0.03 *(k-scrolvaule-1) + 1,_,_,tocolor(0,0,0,alpha),0.0003*sx,cache.roboto,"left","top",false,false,false,true)
                dxDrawText(getElementData(player,"player:id"),sx*0.4035 - dxGetTextWidth(getElementData(player,"player:id"),0.0003*sx,cache.roboto)/2,sy*0.278 + sy*0.03 *(k-scrolvaule-1),_,_,tocolor(240,240,240,alpha),0.0003*sx,cache.roboto,"left","top",false,false,false,true)
                dxDrawText(utf8.gsub(getElementData(player,"player:adminname"),"_"," ").." ("..title..")",sx*0.472- dxGetTextWidth(utf8.gsub(getElementData(player,"player:adminname"),"_"," ").." ("..title.." )",0.0003*sx,cache.roboto)/2 - 1,sy*0.278 + sy*0.03 *(k-scrolvaule-1) + 1,_,_,tocolor(0,0,0,alpha),0.0003*sx,cache.roboto,"left","top",false,false,false,true)
                dxDrawText(utf8.gsub(getElementData(player,"player:adminname"),"_"," ")..prefixColor.." ("..title..")",sx*0.472- dxGetTextWidth(utf8.gsub(getElementData(player,"player:adminname"),"_"," ").." ("..title.." )",0.0003*sx,cache.roboto)/2,sy*0.278 + sy*0.03 *(k-scrolvaule-1),_,_,tocolor(240,240,240,alpha),0.0003*sx,cache.roboto,"left","top",false,false,false,true)
                dxDrawText(lvl,sx*0.545- dxGetTextWidth(lvl,0.0003*sx,cache.roboto)/2 - 1,sy*0.278 + sy*0.03 *(k-scrolvaule-1) + 1,_,_,tocolor(0,0,0,alpha),0.0003*sx,cache.roboto,"left","top",false,false,false,true)
                dxDrawText(levelColor..lvl,sx*0.545- dxGetTextWidth(lvl,0.0003*sx,cache.roboto)/2,sy*0.278 + sy*0.03 *(k-scrolvaule-1),_,_,tocolor(240,240,240,alpha),0.0003*sx,cache.roboto,"left","top",false,false,false,true)
                dxDrawText(ping.."ms",sx*0.61- dxGetTextWidth(ping.."ms",0.0003*sx,cache.roboto) - 1,sy*0.278 + sy*0.03 *(k-scrolvaule-1) + 1,_,_,tocolor(0,0,0,alpha),0.0003*sx,cache.roboto,"left","top",false,false,false,true)
                dxDrawText(pingColor..ping.."ms",sx*0.61- dxGetTextWidth(ping.."ms",0.0003*sx,cache.roboto),sy*0.278 + sy*0.03 *(k-scrolvaule-1),_,_,tocolor(240,240,240,alpha),0.0003*sx,cache.roboto,"left","top",false,false,false,true)
              end 
            else 
              dxDrawText(getPlayerName(player).." (Nincs bejelentkezve)",sx*0.5- dxGetTextWidth(getPlayerName(player).." (Nincs bejelentkezve)",0.0003*sx,cache.roboto)/2,sy*0.278 + sy*0.03 *(k-scrolvaule-1),_,_,tocolor(75,75,75,alpha),0.0003*sx,cache.roboto)
            end
          end 
        end 

end
end 
addEventHandler("onClientRender",root,drawPanel)

addEventHandler("onClientKey", getRootElement(), function(button, press)
  if press and show then
      if button == "mouse_wheel_up" then
        if scrolvaule > 0  then
          scrolvaule = scrolvaule -1
          maxshow = maxshow -1
        end
      elseif button == "mouse_wheel_down" then
        if maxshow < #playerCache then
          scrolvaule = scrolvaule +1
          maxshow = maxshow +1
        end
      end
  end
end)

bindKey("tab", "down", function()
  if not show then
    show = true
    start = getTickCount()
  end
end)

bindKey("tab", "up", function()
  if show then
    show = false
  end
end)


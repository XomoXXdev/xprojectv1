fileDelete ("sourceC.lua") 
local sx,sy = guiGetScreenSize();
local width = 399;
local height = 80;

local borderW = 66 
local borderH = 56

local posX = sx/2 -width/2;
local posY = sy/2 -height/2;

local cache = {}
local moneystring = ""
local UPstring = false
local stringColor = ""
local fps = 60

local greenHEX = "#92cf81"
local redHEX = "#cf7e7e"

local moneyTick = 0
local moneyChange = 0


--[[function updateFPS(msSinceLastFrame)
  fps = math.ceil((1 / msSinceLastFrame) * 1000)
  if fps == 59 then
    fps = 60
  end
end
addEventHandler("onClientPreRender", root, updateFPS)]]

local counter = 0
local starttick
local currenttick
addEventHandler("onClientRender",root,
	function()
		if not starttick then
			starttick = getTickCount()
		end
		counter = counter + 1
		currenttick = getTickCount()
		if currenttick - starttick >= 1000 then
			fps = counter
			counter = 0
			starttick = false
		end
	end
)

cache.roboto = dxCreateFont("files/roboto.ttf",20)
cache.fontawsome = dxCreateFont("files/fontawsome.ttf",20)
cache.digital = dxCreateFont("files/digital.ttf",20)



addEventHandler("onClientElementDataChange",root,function(theKey, oldValue, newValue)
  if (theKey == "player:loggedIn") then 
    
       smoothMovehealt = getElementHealth(localPlayer)
       smoothMovearmor = getPedArmor(localPlayer)
       smoothMovehunger = getElementData(localPlayer,"player:hunger") 
       smoothMovethirsty = getElementData(localPlayer,"player:thirsty") 
       smoothMovestamina = getElementData(localPlayer,"player:stamina") 
       smoothMovelevel = getElementData(localPlayer,"player:level")

  end 

  if theKey == "player:money" then
   if source == getLocalPlayer() then
    local newValue = getElementData(source, theKey)
	  if newValue then
	    moneyTick = getTickCount() + 5000
	    if not oldValue then oldValue = 0 end
	    moneyChange = moneyChange + newValue - oldValue
      playerMoney = newValue
    end
    end
  end

end) 

addEventHandler("onClientResourceStart",resourceRoot,function()
  if getElementData(localPlayer,"player:loggedIn") then 

    smoothMovehealt = getElementHealth(localPlayer)
    smoothMovearmor = getPedArmor(localPlayer)
    smoothMovehunger = getElementData(localPlayer,"player:hunger") 
    smoothMovethirsty = getElementData(localPlayer,"player:thirsty") 
    smoothMovestamina = getElementData(localPlayer,"player:stamina") 
    smoothMovelevel = getElementData(localPlayer,"player:level")
    
	
  end 
end)
local circle = dxCreateTexture("files/circle.png","argb")
--local hud = dxCreateTexture("files/hud.png","argb")
local border = dxCreateTexture("files/border.png","argb")

function drawPanel ()
  if getElementData(localPlayer,"player:loggedIn") and not getElementData(localPlayer,"player:toghud") then 

  local hp_status = -(75*(smoothMovehealt/100))
  local armor_status = -(75*(smoothMovearmor/100))
  local hunger_status = -(75*(smoothMovehunger/100))
  local thirsty_status = -(75*(smoothMovethirsty/100))
  local stamina_status = -(75*(getElementData(localPlayer,"player:stamina")/100))
  local money = getElementData(localPlayer,"player:money")
  local finalmoney = getFinalConvert(10,money)
  local wx,wy,wh,ww = sx*0.77,sy*0.08,sx*0.12,sy*0.11

  local postGUI = getElementData(localPlayer,"player:interface")

  local date = generateDate()
  local time = getRealTime()
  local h = time.hour
  local m = time.minute
  local fpsColor = "#ffffff"

  if h < 10 then h = "0"..h end
  if m < 10 then m = "0"..m end

  if fps >= 1 and fps <= 20 then 
    fpsColor = "#cf7e7e"
  elseif fps >= 21 and fps <= 40 then 
    fpsColor = "#f68934"
  elseif fps >= 36 then 
    fpsColor = "#92cf81"
  end 

  posX,posY = getElementData(localPlayer,"player:interface:hudx"),getElementData(localPlayer,"player:interface:hudy")

  local postGui = getElementData(localPlayer,"player:interface")

  moneyX,moneyY = getElementData(localPlayer,"player:interface:moneyx"),getElementData(localPlayer,"player:interface:moneyy")
  timeX,timeY = getElementData(localPlayer,"player:interface:timex"),getElementData(localPlayer,"player:interface:timey")
  fpsX,fpsY = getElementData(localPlayer,"player:interface:fpsx"),getElementData(localPlayer,"player:interface:fpsy")

    if getElementData(localPlayer,"player:interface:hudavalible") then 

    dxDrawRectangle(posX,posY,sx*0.19,sy*0.081,tocolor(35,35,35,255),postGui)
    dxDrawRectangle(posX + sx*0.0025,posY + sy*0.005,sx*0.185,sy*0.071,tocolor(25,25,25,255),postGui)

    dxDrawRectangle(posX,posY + sy*0.080,sx*0.19,sy*0.002,tocolor(239,255,250,255),postGui)
    dxDrawRectangle(posX,posY + sy*0.080,sx*0.19*smoothMovelevel/100,sy*0.002,tocolor(129, 99, 191,255),postGui)
    dxDrawText("LVL "..smoothMovelevel,posX + sx*0.095,posY + sy*0.065,_,_,tocolor(255,255,255,255),0.35,cache.roboto,"center","top",false,false,postGui)

    dxDrawRectangle(posX + sx*0.006,posY + sy*0.009*(125/100), sx*0.031, sy*0.054,tocolor(179,102,102,255),postGui)
    dxDrawRectangle(posX + sx*0.008,posY + sy*0.0119*(125/100), sx*0.027, sy*0.047,tocolor(20,20,20,255),postGui)
    dxDrawRectangle(posX + sx*0.008,posY + sy*0.0495*(125/100), sx*0.027, sy*0.047*-smoothMovehealt/100,tocolor(179,102,102,150),postGui)
    dxDrawText("",posX + sx*0.016,posY + sy*0.028,_,_,tocolor(179,102,102,255),0.00033*sx,cache.fontawsome,"left","top",false,false,postGui) 

    dxDrawRectangle(posX + sx*0.042,posY + sy*0.009*(125/100), sx*0.031, sy*0.054,tocolor(74,121,165,255),postGui)
    dxDrawRectangle(posX + sx*0.044,posY + sy*0.0119*(125/100), sx*0.027, sy*0.047,tocolor(20,20,20,255),postGui)
    dxDrawRectangle(posX + sx*0.044,posY + sy*0.0495*(125/100), sx*0.027, sy*0.047*-smoothMovearmor/100,tocolor(74,121,165,150),postGui)
    dxDrawText("",posX + sx*0.052,posY + sy*0.028,_,_,tocolor(74,121,165,255),0.00033*sx,cache.fontawsome,"left","top",false,false,postGui) 

    dxDrawRectangle(posX + sx*0.0785,posY + sy*0.009*(125/100), sx*0.031, sy*0.054,tocolor(226,169,121,255),postGui)
    dxDrawRectangle(posX + sx*0.0805,posY + sy*0.0119*(125/100), sx*0.027, sy*0.047,tocolor(20,20,20,255),postGui)
    dxDrawRectangle(posX + sx*0.0805,posY + sy*0.0495*(125/100), sx*0.027, sy*0.047*-smoothMovehunger/100,tocolor(226,169,121,150),postGui)
    dxDrawText("",posX + sx*0.0885,posY + sy*0.028,_,_,tocolor(226,169,121,255),0.00033*sx,cache.fontawsome,"left","top",false,false,postGui) 

    dxDrawRectangle(posX + sx*0.115,posY + sy*0.009*(125/100), sx*0.031, sy*0.054,tocolor(81,158,136,255),postGui)
    dxDrawRectangle(posX + sx*0.117,posY + sy*0.0119*(125/100), sx*0.027, sy*0.047,tocolor(20,20,20,255),postGui)
    dxDrawRectangle(posX + sx*0.117,posY + sy*0.0495*(125/100), sx*0.027, sy*0.047*-smoothMovethirsty/100,tocolor(81,158,136,150),postGui)
    dxDrawText("",posX + sx*0.125,posY + sy*0.028,_,_,tocolor(81,158,136,255),0.00033*sx,cache.fontawsome,"left","top",false,false,postGui) 

    dxDrawRectangle(posX + sx*0.152,posY + sy*0.009*(125/100), sx*0.031, sy*0.054,tocolor(201,219,214,255),postGui)
    dxDrawRectangle(posX + sx*0.154,posY + sy*0.0119*(125/100), sx*0.027, sy*0.047,tocolor(20,20,20,255),postGui)
    dxDrawRectangle(posX + sx*0.154,posY + sy*0.0495*(125/100), sx*0.027, sy*0.047*-getElementData(localPlayer,"player:stamina")/100,tocolor(201,219,214,150),postGui)
    dxDrawText("",posX + sx*0.163,posY + sy*0.028,_,_,tocolor(201,219,214,255),0.00033*sx,cache.fontawsome,"left","top",false,false,postGui) 

    end 

  if getElementData(localPlayer,"player:interface:moneyavalible") then 
    if getElementData(localPlayer,"player:money") > 0 then 
      dxDrawBorderedText(2,"$"..finalmoney..getElementData(localPlayer,"player:money"),moneyX,moneyY,moneyX,moneyY,tocolor(255,255,255,255),0.0006*sx,"pricedown","center","top",false,false,postGui)
      dxDrawText("#92cf81$#e0e0e0"..finalmoney.."#92cf81"..getElementData(localPlayer,"player:money"),moneyX,moneyY,_,_,tocolor(255,255,255,255),0.0006*sx,"pricedown","center","top",false,false,postGui,true)
    else 
      dxDrawBorderedText(2,"$"..finalmoney..getElementData(localPlayer,"player:money"),moneyX,moneyY,moneyX,moneyY,tocolor(255,255,255,255),0.0006*sx,"pricedown","center","top",false,false,postGui)
      dxDrawText("#d14949$#e0e0e0"..finalmoney.."#d14949"..getElementData(localPlayer,"player:money"),moneyX,moneyY,_,_,tocolor(255,255,255,255),0.0006*sx,"pricedown","center","top",false,false,postGui,true)
    end

    if moneyTick >= getTickCount() then
      if moneyChange > 0 then
        dxDrawBorderedText(2,"+"..getFinalConvert(10,moneyChange)..moneyChange,moneyX,moneyY+24,moneyX,moneyY,tocolor(255,255,255,255),0.0006*sx,"pricedown","center","top",false,false,postGui)
        dxDrawText("#92cf81+#e0e0e0"..getFinalConvert(10,moneyChange).."#92cf81"..moneyChange,moneyX,moneyY+24,_,_,tocolor(255,255,255,255),0.0006*sx,"pricedown","center","top",false,false,postGui,true)
      elseif moneyChange < 0 then
        local asd = tostring(moneyChange):gsub("-", "");
        dxDrawBorderedText(2,"-"..getFinalConvert(10,moneyChange)..asd,moneyX,moneyY+24,moneyX,moneyY,tocolor(255,255,255,255),0.0006*sx,"pricedown","center","top",false,false,postGui)
        dxDrawText("#d14949-#e0e0e0"..getFinalConvert(10,moneyChange).."#d14949"..asd,moneyX,moneyY+24,_,_,tocolor(255,255,255,255),0.0006*sx,"pricedown","center","top",false,false,postGui,true)
       end
    else
      moneyChange = 0;
    end
  end 

  if getElementData(localPlayer,"player:interface:timeavalible") then 
  dxDrawBorderedText(2,h..":"..m,timeX,timeY,timeX,timeY,tocolor(255,255,255,255),0.0006*sx,"pricedown","center","top",false,false,postGui)
  end 

  if getElementData(localPlayer,"player:interface:fpsavalible") then 
  dxDrawBorderedText(2,fps.."FPS",fpsX,fpsY,fpsX,fpsY,tocolor(255,255,255,255),0.0006*sx,"pricedown","center","top",false,false,postGui)
  dxDrawText(fpsColor..fps.."FPS",fpsX,fpsY,_,_,tocolor(255,255,255,255),0.0006*sx,"pricedown","center","top",false,false,postGui,true)
  end

  if smoothMovehealt > getElementHealth(localPlayer) then --sy*0.054
    smoothMovehealt = smoothMovehealt - 1
  end
  if smoothMovehealt < getElementHealth(localPlayer) then
    smoothMovehealt = smoothMovehealt + 1
  end

    
  if smoothMovearmor > getPedArmor(localPlayer) then
    smoothMovearmor = smoothMovearmor - 1
  end
  if smoothMovearmor < getPedArmor(localPlayer) then
    smoothMovearmor = smoothMovearmor + 1
  end


  if smoothMovehunger > getElementData(localPlayer,"player:hunger") then
    smoothMovehunger = smoothMovehunger - 1
  end
  if smoothMovehunger < getElementData(localPlayer,"player:hunger") then
    smoothMovehunger = smoothMovehunger + 1
  end
  
  if smoothMovethirsty > getElementData(localPlayer,"player:thirsty") then
    smoothMovethirsty = smoothMovethirsty - 1
  end
  if smoothMovethirsty < getElementData(localPlayer,"player:thirsty") then
    smoothMovethirsty = smoothMovethirsty + 1
  end

  if smoothMovelevel > getElementData(localPlayer,"player:level") then 
    smoothMovelevel = smoothMovelevel - 1
  end 
  if smoothMovelevel < getElementData(localPlayer,"player:level") then 
    smoothMovelevel = smoothMovelevel + 1
  end

  end 
end
addEventHandler("onClientRender",root,drawPanel)

setElementData(localPlayer,"player:stamina",100)

addEventHandler("onClientPreRender", getRootElement(), function(deltaTime)
 if not getElementData(localPlayer,"player:afk") then 
	local moveState = getPedMoveState(localPlayer)
    local stamina = getElementData(localPlayer,"player:stamina")
	if moveState ~= "jump" and tired and not anim then
		triggerServerEvent("setStaminaAnimation", localPlayer, true)
		anim = true
	end

	if moveState == "sprint" and not getElementData(localPlayer,"player:adminduty") then
		if getElementData(localPlayer,"player:stamina") > 0 then
            setElementData(localPlayer,"player:stamina", stamina - 0.005*deltaTime)
		else
			setElementData(localPlayer,"player:stamina",0)
		end
	elseif moveState == "jump" and not getElementData(localPlayer,"player:adminduty") then
		setElementData(localPlayer,"player:stamina", stamina - 0.01*deltaTime)
	else
		if getElementData(localPlayer,"player:stamina") < 100 then
			if moveState == "crawl" then return end
			setElementData(localPlayer,"player:stamina", stamina + 0.005*deltaTime)
		else
			setElementData(localPlayer,"player:stamina",100)
		end
	end

	if getElementData(localPlayer,"player:stamina") < 0 then setElementData(localPlayer,"player:stamina",0) end

	if getElementData(localPlayer,"player:stamina") == 0 then
		tired = true
		toggleAllControls(false, true, false)
	elseif (getElementData(localPlayer,"player:stamina") > 30) and tired then
		tired, anim = false, false
		toggleAllControls(true, true, false)
		triggerServerEvent("setStaminaAnimation", localPlayer)
	end
 end
end)

addEventHandler("onClientPlayerSpawn", localPlayer, function()
	setElementData(localPlayer,"player:stamina",100)
end)


setTimer(function()
	if getElementData(localPlayer, "player:loggedIn") and not (getElementData(localPlayer,"player:adminduty")) and not isPedDead(localPlayer) then	
		local drink = getElementData(localPlayer,"player:thirsty")
		if drink > 0 then 
		drink = drink - 5   
		setElementData(localPlayer,"player:thirsty",drink)
		end 

		if drink < 10 then
		setElementHealth(localPlayer,getElementHealth(localPlayer) - 20)
		outputChatBox("#f68934[Figyelmeztetés]#ffffff Figyelem a szomjúsági szinted alacsony szintre esett, igyál valamit hogy nem legyél szomjas.",255,255,255,true)    
		end
		
	end
end, 300000, 0)
	
setTimer(function()
	if getElementData(localPlayer, "player:loggedIn") and not (getElementData(localPlayer,"player:adminduty")) and not isPedDead(localPlayer) then	
		local hungry = getElementData(localPlayer,"player:hunger")
		if hungry > 0 then 
			hungry = hungry - 2
		setElementData(localPlayer,"player:hunger",hungry)
		end 

		if hungry < 10 then
		  setElementHealth(localPlayer,getElementHealth(localPlayer) - 20)
      outputChatBox("#f68934[Figyelmeztetés]#ffffff Figyelem az éhség szinted alacsony szintre esett, egyél valamit hogy nem legyél éhes.",255,255,255,true)   
		end

	end
end, 300000, 0)

function getFinalConvert(maxNulls, text)
	local maxNull = maxNulls
	local actualChar = maxNull - tostring(text):len()
	local finalConvert = ""
	for index = 0, actualChar do
		finalConvert = finalConvert .. "0"
	end
	return finalConvert
end

function formatMoney(amount)
  local formatted = amount
  while true do
      formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')
      if (k==0) then
          break
      end
  end
  return formatted
end


function generateDate()
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

function dxDrawBorderedText (outline, text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
  for oX = (outline * -1), outline do
      for oY = (outline * -1), outline do
          dxDrawText (text, left + oX, top + oY, right + oX, bottom + oY, tocolor(0, 0, 0, 255), scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
      end
  end
  dxDrawText (text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
end
fileDelete ("client.lua") 
local sx,sy = guiGetScreenSize()
local cache = {}
local x,y = sx*0.41,sy*0.3
cache.sans = dxCreateFont("files/sansheavy.otf",20)
cache.roboto = dxCreateFont("files/roboto.ttf",20)
cache.fontawsome = dxCreateFont("files/fontawsome.ttf",20)
cache.click = false 
cache.logo = dxCreateTexture("files/logo.png")
local show = false

local maxshow = 11
local scrolvaule = 0

bindKey("space","down",function()
triggerServerEvent("stopAnim",localPlayer,localPlayer)
end)

function listAnims()

  outputChatBox("#f68934[Animációk] #ffffff/daps,/daps2,/heil,/dance,/dance2,/dance3,/strip,/strip2,/sit4,/sit5",255,255,255,true)
  outputChatBox("/lay,/lay2,/gsign/gsign2,/gsign3,/gsign4,/gsign5,/rap,/rap2,/cry,/puke,/vomit",255,255,255,true)
  outputChatBox("/laugh,/plant,/grab,/putdown,/cpr,/slapass,/bitchslap,/shove,/dive,/roadcross",255,255,255,true)
  outputChatBox("/roadcross2,/roadcross3,/rap3,/cheer,/cheer2,/cheer3,/fixcar,/startrace,/carchat",255,255,255,true)
  outputChatBox("/carphone,/carphone2,/fixing,/crack,/crack2,/crack3,/crack4,/leanleft,/copaway,/copcome,/handsup",255,255,255,true)
  outputChatBox("/copleft,/copstop,/shake,/lean,/idle,/wait,/tired,/fallfront,/fall,/think",255,255,255,true)
  outputChatBox("/crouch,/shocked,/cover,/smoke,/smoke2,/smoke3,/smokelean,/lightup,/drag,/sit,/sit2",255,255,255,true)
  outputChatBox("/sit3,/sit4,/sit5,/lay,/lay2,/aim,/aim2,/hailtaxi,/hailcab,/crouch,/crouchcome",255,255,255,true)
  outputChatBox("/fu,/fu2,/scratch,/beg,/what,/photograph,/mourn,/laugh,/plant,/grab",255,255,255,true)
  outputChatBox("/putdown,/cpr,/slapass,/bitchslap,/shove,/dive,/roadcross,/roadcross2,/roadcross3",255,255,255,true)

end
--addCommandHandler("anims",listAnims)
--addCommandHandler("Anims",listAnims)

function setAnimation(thePlayer,anim)
  for k,animation in pairs(animations) do 
      if anim == animation[1] then 
          setPedAnimation(thePlayer, animation[2], animation[3], animation[4], animation[5], false, false)
          setElementData(thePlayer,"player:animation",true)
      end 
  end 
end 
addEvent("setAnimation",true)
addEventHandler("setAnimation",root,setAnimation)

function drawPanelAnim()

  if isCursorShowing(localPayer) then 
    cursorX, cursorY = getCursorPosition()
    cursorX, cursorY = cursorX * sx, cursorY * sy	

    if cache.click then 
      x,y = cursorX + windowOffsetX, cursorY + windowOffsetY
    end 
  end 
  dxDrawRectangle(x,y,sx*0.19,sy*0.447,tocolor(23,23,23,255))

  for i = 1,6 do 
    dxDrawRectangle(x,y - sy*0.067 + (i*sy*0.067),sx*0.19,sy*0.035,tocolor(20,20,20,255))
  end 

  dxDrawImage(x + sx*0.002 - 1,y + sy*0.002 + 1,sx*0.016,sy*0.03,cache.logo,0,0,0,tocolor(0, 0, 0,255))
  dxDrawImage(x + sx*0.002,y + sy*0.002,sx*0.016,sy*0.03,cache.logo,0,0,0,tocolor(246, 137, 52,255))

  if getElementData(localPlayer,"player:animation") then 

  if isInSlot(x + sx*0.0025,y + sy*0.406,sx*0.09,sy*0.035) then 
    dxDrawRectangle(x + sx*0.0025,y + sy*0.406,sx*0.09,sy*0.035,tocolor(197,84,82,255))
  else 
    dxDrawRectangle(x + sx*0.0025,y + sy*0.406,sx*0.09,sy*0.035,tocolor(197,84,82,220))
  end
  dxDrawText("Bezárás",x + sx*0.03 - 1,y + sy*0.415 + 1,_,_,tocolor(0,0,0,255),0.00027*sx,cache.sans)
  dxDrawText("Bezárás",x + sx*0.03,y + sy*0.415,_,_,tocolor(255,255,255,255),0.00027*sx,cache.sans)
  
  if isInSlot(x + sx*0.0975,y + sy*0.406,sx*0.09,sy*0.035) then 
    dxDrawRectangle(x + sx*0.0975,y + sy*0.406,sx*0.09,sy*0.035,tocolor(197,84,82,255))
  else 
    dxDrawRectangle(x + sx*0.0975,y + sy*0.406,sx*0.09,sy*0.035,tocolor(197,84,82,220))
  end

  dxDrawText("Leállítás",x + sx*0.123 - 1,y + sy*0.415 + 1,_,_,tocolor(0,0,0,255),0.00027*sx,cache.sans)
  dxDrawText("Leállítás",x + sx*0.123,y + sy*0.415,_,_,tocolor(255,255,255,255),0.00027*sx,cache.sans)
  else

  if isInSlot(x + sx*0.0025,y + sy*0.406,sx*0.185,sy*0.035) then 
    dxDrawRectangle(x + sx*0.0025,y + sy*0.406,sx*0.185,sy*0.035,tocolor(197,84,82,255))
  else 
    dxDrawRectangle(x + sx*0.0025,y + sy*0.406,sx*0.185,sy*0.035,tocolor(197,84,82,220))
  end
  dxDrawText("Bezárás",x + sx*0.075 - 1,y + sy*0.415 + 1,_,_,tocolor(0,0,0,255),0.00027*sx,cache.sans)
  dxDrawText("Bezárás",x + sx*0.075,y + sy*0.415,_,_,tocolor(255,255,255,255),0.00027*sx,cache.sans)

  end

  dxDrawText("Animációs",x + sx*0.151 - 1,y + sy*0.006 + 1,_,_,tocolor(0,0,0,255),0.00021*sx,cache.sans)
  dxDrawText("Animációs",x + sx*0.151,y + sy*0.006,_,_,tocolor(255,255,255,255),0.00021*sx,cache.sans)

  dxDrawText("Panel",x + sx*0.163 - 1,y + sy*0.016 + 1,_,_,tocolor(0,0,0,255),0.00021*sx,cache.sans)
  dxDrawText("Panel",x + sx*0.163,y + sy*0.016,_,_,tocolor(255,255,255,255),0.00021*sx,cache.sans)

  for k,v in pairs(animations) do 
    if k <= maxshow and (k > scrolvaule) then               

      if isInSlot(x,y + sy*0.04 + sy*0.0335 *(k-scrolvaule-1),sx*0.19,sy*0.022) then 
      dxDrawText(v[6],x + sx*0.004 - 1,y + sy*0.041 + sy*0.0335 *(k-scrolvaule-1) + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.roboto)
      dxDrawText(v[6],x + sx*0.004,y + sy*0.041 + sy*0.0335 *(k-scrolvaule-1),_,_,tocolor(246, 137, 52,255),0.0003*sx,cache.roboto)

      dxDrawText("/"..v[1],x + sx*0.18 - dxGetTextWidth(v[1],0.0003*sx,cache.roboto) - 1,y + sy*0.041 + sy*0.0335 *(k-scrolvaule-1) + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.roboto)
      dxDrawText("/"..v[1],x + sx*0.18 - dxGetTextWidth(v[1],0.0003*sx,cache.roboto),y + sy*0.041 + sy*0.0335 *(k-scrolvaule-1),_,_,tocolor(246, 137, 52,255),0.0003*sx,cache.roboto)
      else 
      dxDrawText(v[6],x + sx*0.004 - 1,y + sy*0.041 + sy*0.0335 *(k-scrolvaule-1) + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.roboto)
      dxDrawText(v[6],x + sx*0.004,y + sy*0.041 + sy*0.0335 *(k-scrolvaule-1),_,_,tocolor(255,255,255,255),0.0003*sx,cache.roboto)
  
      dxDrawText("/"..v[1],x + sx*0.18 - dxGetTextWidth(v[1],0.0003*sx,cache.roboto) - 1,y + sy*0.041 + sy*0.0335 *(k-scrolvaule-1) + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.roboto)
      dxDrawText("/"..v[1],x + sx*0.18 - dxGetTextWidth(v[1],0.0003*sx,cache.roboto),y + sy*0.041 + sy*0.0335 *(k-scrolvaule-1),_,_,tocolor(255,255,255,255),0.0003*sx,cache.roboto)
      end
    end

  end 

end 

function showPanel()
  if not show then 
    addEventHandler("onClientRender",root,drawPanelAnim)
    show = true
  else 
    show = false
    removeEventHandler("onClientRender",root,drawPanelAnim)
  end
end
addCommandHandler("animpanel",showPanel)
addCommandHandler("animations",showPanel)
addCommandHandler("anims",showPanel)
addCommandHandler("Anims",showPanel)

function onClientClick(button, state, absoluteX, absoluteY, worldX, worldY, worldZ)
  if (button == "left") and state == "down" and show then 

    for k,v in pairs(animations) do 
      if k <= maxshow and (k > scrolvaule) then           
      if isInSlot(x,y + sy*0.04 + sy*0.0335 *(k-scrolvaule-1),sx*0.19,sy*0.022) then 
        triggerServerEvent("trigger",localPlayer,localPlayer,v[1])
      end 
      end
    end 

    if getElementData(localPlayer,"player:animation") then 
      if isInSlot(x + sx*0.0025,y + sy*0.406,sx*0.09,sy*0.035) then 
        if show then 
        show = false
        removeEventHandler("onClientRender",root,drawPanelAnim)
        end
      elseif isInSlot(x + sx*0.0975,y + sy*0.406,sx*0.09,sy*0.035) then 
        triggerServerEvent("stopAnim",localPlayer,localPlayer)
      end 
    else 
      if isInSlot(x + sx*0.0025,y + sy*0.406,sx*0.185,sy*0.035) then 
        if show then 
          show = false
          removeEventHandler("onClientRender",root,drawPanelAnim)
        end
      end 
    end 

  end 
 end 
addEventHandler("onClientClick",root,onClientClick)

function movePanel(button, state, absoluteX, absoluteY, worldX, worldY, worldZ)
  if (button == "left") and show then 

    if state == "down" then 
      if isInSlot(x,y,sx*0.19,sy*0.035) then 
        cache.click = true
        windowOffsetX, windowOffsetY = x - absoluteX, y - absoluteY
      end
    else 
      if isInSlot(x,y,sx*0.19,sy*0.035) then 
        cache.click = false
      end
    end

  end 
 end 
addEventHandler("onClientClick",root,movePanel)

function isInSlot(xS,yS,wS,hS)
	if(isCursorShowing()) then
		XY = {guiGetScreenSize()}
		local cursorX, cursorY = getCursorPosition()
		cursorX, cursorY = cursorX*XY[1], cursorY*XY[2]
		if(isInBox(xS,yS,wS,hS, cursorX, cursorY)) then
			return true
		else
			return false
		end
	end	
end

function isInBox(dX, dY, dSZ, dM, eX, eY)
	if(eX >= dX and eX <= dX+dSZ and eY >= dY and eY <= dY+dM) then
		return true
	else
		return false
	end
end

addEventHandler("onClientKey", getRootElement(), function(button, press)
  if press and show then
      if button == "mouse_wheel_up" then
        if scrolvaule > 0  then
          scrolvaule = scrolvaule -1
          maxshow = maxshow -1
        end
      elseif button == "mouse_wheel_down" then
        if maxshow < #animations then
          scrolvaule = scrolvaule +1
          maxshow = maxshow +1
        end
      end
  end
end)


function loadAnimations()

  setTimer(function()
    rifle = engineLoadIFP("anims/rifle.ifp","New_Rifle")
    
    shotgun = engineLoadIFP("anims/shotgun.ifp","New_Shotgun")
    
    buddy = engineLoadIFP("anims/buddy.ifp","New_Buddy")
    
    uzi = engineLoadIFP("anims/uzi.ifp","New_Uzi")
    
    dealer = engineLoadIFP("anims/dealer.ifp","New_Dealer")

    ped = engineLoadIFP("anims/ped.ifp","New_Ped")

    setElementData(localPlayer,"player:extraanim",true)
  end,500,1)
end 
addEventHandler("onClientResourceStart",resourceRoot,loadAnimations)

function unloadAnimations()
  --[[engineRestoreAnimation(localPlayer,"rifle","rifle_crouchfire")
  engineRestoreAnimation(localPlayer,"rifle","rifle_crouchload")
  engineRestoreAnimation(localPlayer,"rifle","rifle_load")

  engineRestoreAnimation(localPlayer,"shotgun","shotgun_crouchfire")

  engineRestoreAnimation(localPlayer,"buddy","buddy_crouchfire")
  engineRestoreAnimation(localPlayer,"buddy","buddy_crouchload")
  engineRestoreAnimation(localPlayer,"buddy","buddy_load")

  engineRestoreAnimation(localPlayer,"uzi","uzi_crouchfire")
  engineRestoreAnimation(localPlayer,"uzi","uzi_crouchload")
  engineRestoreAnimation(localPlayer,"uzi","uzi_load")]]--

  --engineRestoreAnimation(localPlayer,"ped","IDLE_armed")
 -- engineRestoreAnimation(localPlayer,"ped","run_armed")
  --engineRestoreAnimation(localPlayer,"ped","walk_armed")

  engineRestoreAnimation(localPlayer,"dealer","dealer_idle")
  setElementData(localPlayer,"player:extraanim",false)


end 
addEventHandler("onClientResourceStop",resourceRoot,unloadAnimations)

function scoreChangeTracker(theKey, oldValue, newValue)
  if (getElementType(source) == "player") and (theKey == "player:extraanim") then
    if getElementData(source,theKey) then
      --[[engineReplaceAnimation(source,"rifle","rifle_crouchfire","New_Rifle","RIFLE_crouchfire")
      engineReplaceAnimation(source,"rifle","rifle_crouchload","New_Rifle","RIFLE_crouchload")
      engineReplaceAnimation(source,"rifle","rifle_load","New_Rifle","RIFLE_load")
    
      engineReplaceAnimation(source,"shotgun","shotgun_crouchfire","New_Shotgun","shotgun_crouchfire")
    
      engineReplaceAnimation(source,"buddy","buddy_crouchfire","New_Rifle","buddy_crouchfire")
      engineReplaceAnimation(source,"buddy","buddy_crouchload","New_Rifle","buddy_crouchload")
      engineReplaceAnimation(source,"buddy","buddy_load","New_Rifle","buddy_reload")
    
      engineReplaceAnimation(source,"uzi","uzi_crouchfire","New_Uzi","uzi_crouchfire")
      engineReplaceAnimation(source,"uzi","uzi_crouchload","New_Uzi","uzi_crouchload")
      engineReplaceAnimation(source,"uzi","uzi_load","New_Uzi","uzi_reload")]]--

      engineReplaceAnimation(source,"dealer","dealer_idle","New_Ifp","DEALER_IDLE")

      --engineReplaceAnimation(source,"ped","IDLE_armed","New_Ped","IDLE_armed")
      --engineReplaceAnimation(source,"ped","run_armed","New_Ped","run_armed")
    end
  end
end
addEventHandler("onClientElementDataChange", root, scoreChangeTracker)
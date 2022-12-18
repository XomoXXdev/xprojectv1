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

function drawAdminPanel()

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
  dxDrawImage(x + sx*0.002,y + sy*0.002,sx*0.016,sy*0.03,cache.logo,0,0,0,tocolor(129, 99, 191,255))

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

  dxDrawText("Admin",x + sx*0.151 - 1,y + sy*0.006 + 1,_,_,tocolor(0,0,0,255),0.00021*sx,cache.sans)
  dxDrawText("Admin",x + sx*0.151,y + sy*0.006,_,_,tocolor(255,255,255,255),0.00021*sx,cache.sans)

  dxDrawText("Panel",x + sx*0.163 - 1,y + sy*0.016 + 1,_,_,tocolor(0,0,0,255),0.00021*sx,cache.sans)
  dxDrawText("Panel",x + sx*0.163,y + sy*0.016,_,_,tocolor(255,255,255,255),0.00021*sx,cache.sans)

  for k,v in pairs(animations) do 
    if k <= maxshow and (k > scrolvaule) then               

      if isInSlot(x,y + sy*0.04 + sy*0.0335 *(k-scrolvaule-1),sx*0.19,sy*0.022) then 
      dxDrawText(v[6],x + sx*0.004 - 1,y + sy*0.041 + sy*0.0335 *(k-scrolvaule-1) + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.roboto)
      dxDrawText(v[6],x + sx*0.004,y + sy*0.041 + sy*0.0335 *(k-scrolvaule-1),_,_,tocolor(129, 99, 191,255),0.0003*sx,cache.roboto)

      dxDrawText("/"..v[1],x + sx*0.18 - dxGetTextWidth(v[1],0.0003*sx,cache.roboto) - 1,y + sy*0.041 + sy*0.0335 *(k-scrolvaule-1) + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.roboto)
      dxDrawText("/"..v[1],x + sx*0.18 - dxGetTextWidth(v[1],0.0003*sx,cache.roboto),y + sy*0.041 + sy*0.0335 *(k-scrolvaule-1),_,_,tocolor(129, 99, 191,255),0.0003*sx,cache.roboto)
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
    addEventHandler("onClientRender",root,drawAdminPanel)
    show = true
  else 
    show = false
    removeEventHandler("onClientRender",root,drawAdminPanel)
  end
end
addCommandHandler("ah",showPanel)

function onClientClick(button, state, absoluteX, absoluteY, worldX, worldY, worldZ)
  if (button == "left") and state == "down" and show then 

    for k,v in pairs(animations) do 

      if isInSlot(x + sx*0.0025,y + sy*0.406,sx*0.185,sy*0.035) then 
        if show then 
          show = false
          removeEventHandler("onClientRender",root,drawAdminPanel)
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
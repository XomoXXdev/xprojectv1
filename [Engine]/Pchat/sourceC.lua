fileDelete ("sourceC.lua") 
local sx,sy = guiGetScreenSize()
local roboto2 = dxCreateFont("files/roboto.ttf",14)
local roboto = dxCreateFont("files/roboto.ttf",20)
local fontawsome = dxCreateFont("files/fontawsome.ttf",20)
local opensans = dxCreateFont("files/opensans.ttf",15)
local oocTable = {}
local placedo = {}
local bubbles = {}
local showOOC = true
setElementData(localPlayer,"chat.MaxOOC",10)
local maxBubbles = 5
bindKey("b", "down", "chatbox", "LocalOOC")
bindKey("y", "down", "chatbox", " Rádió")
setElementData(localPlayer,"placedo:counter",0)


--ooc--
function drawOOC()
  if showOOC and getElementData(localPlayer,"player:loggedIn") and not getElementData(localPlayer,"player:toghud") and not isPlayerDead(localPlayer) then

    local lines = getChatboxLayout()["chat_lines"]
    local postGUI = getElementData(localPlayer,"player:interface")
    local posX,posY = getElementData(localPlayer,"player:interface:oocx"),getElementData(localPlayer,"player:interface:oocy")

    if getElementData(localPlayer,"player:interface:oocavalible") then 
      posX,posY = posX + 2,posY - 240
      dxDrawText("OOC Chat [/b]",posX - 1,posY + lines*8  + 1,_,_,tocolor(0,0,0,255),1,"default-bold","left","top",false,false,postGUI,true)
      dxDrawText("OOC Chat [/b]",posX,posY + lines*8 ,_,_,tocolor(255,255,255,255),1,"default-bold","left","top",false,false,postGUI,true)
      
      for k,v in ipairs(oocTable) do
        --dxDrawText(v,posX + 2 - 1,posY + (k*17) + lines*8 + 1 ,_,_,tocolor(0,0,0,255),1,"default-bold","left","top",false,false,postGUI,true)
        dxDrawText(v,posX + 2,posY + (k*17) + lines*8 ,_,_,tocolor(255,255,255,255),1,"default-bold","left","top",false,false,postGUI,true)
      end
    end 

  end
end
addEventHandler("onClientRender",root,drawOOC)

function insertOOC(message)
  table.insert(oocTable,message)
  outputConsole("[OOC] "..message)
  local maxLine = getElementData(localPlayer,"chat.MaxOOC")
  if #oocTable >= maxLine then
    table.remove(oocTable,1)
  end
end
addEvent("InsertOOC",true)
addEventHandler("InsertOOC",root,insertOOC)

function ClearOOC()
  for k,v in ipairs(oocTable) do
    oocTable[k] = nil
  end
end
addCommandHandler("ClearOOC",ClearOOC)
addCommandHandler("clearOOC",ClearOOC)
addCommandHandler("Clearooc",ClearOOC)
addCommandHandler("clearooc",ClearOOC)

function ToggOOC()
  if showOOC then
    showOOC =false
    outputChatBox("#8163bf[Chat] #ffffffSikeresen eltüntetted az #8163bfOOC #ffffffchatet.",255,255,255,true)
  else
    showOOC = true
    outputChatBox("#8163bf[Chat] #ffffffSikeresen előhoztad az #8163bfOOC #ffffffchatet.",255,255,255,true)
  end
end
addCommandHandler("toggleOOC",ToggOOC)
addCommandHandler("toggleooc",ToggOOC)
addCommandHandler("toggOOC",ToggOOC)
addCommandHandler("toggooc",ToggOOC)

--bubbles

function sendChatOutputC(type,message)
  triggerServerEvent("sendChatOutput",localPlayer,localPlayer,type,message);
end
addEvent("sendChatOutputC",true)
addEventHandler("sendChatOutputC",root,sendChatOutputC)

function drawBubble()
  if (getElementData(localPlayer,"player:loggedIn")) then
    local Px,Py,Pz = getElementPosition(localPlayer)
    for k,v in ipairs(bubbles) do
      element = v[1]
      text = v[2]
      type = v[3]
      success = v[4]
      local r,g,b = 255,255,255
      if element ~= localPlayer then
      if not getElementData(element,"player:adminduty") then
        local vX,vY,vZ = getElementPosition(element)
        local hX,hY,hZ = getPedBonePosition(element,5)
        local cX,cY,cZ = getCameraMatrix()
        local distance = getDistanceBetweenPoints3D(Px,Py,Pz,vX,vY,vZ)
        distance = distance-(distance/3)
        local progress = distance/22
        local scale = interpolateBetween(0.7, 0, 0, 0.2, 0, 0, progress, "OutQuad")
        scale = scale*(sx+1280)/(1280*2)
        local clear = isLineOfSightClear(cX,cY,cZ,vX,vY,hZ,true,false,false,true,false,false,false)
        local textX,textY = getScreenFromWorldPosition(vX,vY,hZ+0.45)

        if distance < 10 and getElementDimension(element) == 0 and getElementInterior(element) == 0 and textX and textY and clear then
          local textLenght = dxGetTextWidth(text,scale,roboto2)

          if type == "ic" or type == "wishper" or type == "shout" then
            r,g,b = 255,255,255
          elseif type == "me" then
            r,g,b = 194, 162, 218
          elseif type == "do" then
            r,g,b = 255, 51, 102
          elseif type == "ame" then
            r,g,b = 232, 199, 240
          elseif type == "megaphone" then
            r,g,b = 214, 212, 64
          elseif type == "try" then
            if success == 1 then
              r,g,b = 124, 197, 118
            elseif success == 2 then
              r,g,b = 204, 69, 85
            end
          end

          dxDrawRectangle(textX - textLenght / 2,textY - (k*30),textLenght + 4,sx*0.011,tocolor(0,0,0,150))
          dxDrawText(text,textX - textLenght / 2 + 2 - 1,textY - (k*30) + 1,_,_,tocolor(0,0,0,255),scale,roboto2,"left","top")
          dxDrawText(text,textX - textLenght / 2 + 2,textY - (k*30),_,_,tocolor(r,g,b,255),scale,roboto2,"left","top")
 
        end
        end
      end
    end
  end
end
addEventHandler("onClientRender",root,drawBubble)

function insertBubbles(element,message,type,success)
  if #bubbles >= 3 then
    table.remove(bubbles,1)
  end
  -- outputChatBox("inserted")
  local tableToRecord = {element,message,type,success}
  table.insert(bubbles, tableToRecord)


  setTimer(function()
  -- for k,v in ipairs(bubbles) do
  table.remove(bubbles,1)
  --end
  end,3000,1)
end
addEvent("insertBubble",true)
addEventHandler("insertBubble",root,insertBubbles)

-- placedo

function drawPlacedo()
  if (getElementData(localPlayer,"player:loggedIn")) then
    local Px,Py,Pz = getElementPosition(localPlayer)
    for k,v in ipairs(placedo) do
      element = v[1]
      text = v[2]
      x,y,z = v[3],v[4],v[5]
      local vX,vY,vZ = x,y,z
      local cX,cY,cZ = getCameraMatrix()
      local distance = getDistanceBetweenPoints3D(Px,Py,Pz,vX,vY,vZ)
      distance = distance-(distance/3)
      local progress = distance/22
      local scale = interpolateBetween(0.7, 0, 0, 0.2, 0, 0, progress, "OutQuad")
      scale = scale*(sx+1280)/(1280*2)
      local clear = isLineOfSightClear(cX,cY,cZ,vX,vY,vZ,true,false,false,true,false,false,false)
      local textX,textY = getScreenFromWorldPosition(vX,vY,vZ-0.45)
      if distance < 10 and clear and textX and textY then

        local text = text
        local lenght = dxGetTextWidth(text,1.2,"default-bold")

        dxDrawText(text,textX - lenght/2 - 1 ,textY + 1,_,_,tocolor(0,0,0,255),1.2,"default-bold")
        dxDrawText(text,textX - lenght/2,textY,_,_,tocolor(255, 51, 102,255),1.2,"default-bold")

        if getElementData(localPlayer,"player:adminduty") or element == localPlayer then 
        dxDrawText("",textX + lenght/1.9,textY - 4 + 1,_,_,tocolor(0,0,0,255),0.8,fontawsome)
        dxDrawText("",textX + lenght/1.9,textY - 4 ,_,_,tocolor(255, 51, 102,255),0.8,fontawsome)
        end 

      end

    end
  end
end
addEventHandler("onClientRender",root,drawPlacedo)

function onClientPlayerClick(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
  if button == "left" and state == "down" then 
  local Px,Py,Pz = getElementPosition(localPlayer)
  for k,v in ipairs(placedo) do 
    element = v[1]
    text = v[2]
    x,y,z = v[3],v[4],v[5]
    local vX,vY,vZ = x,y,z
    local cX,cY,cZ = getCameraMatrix()
    local distance = getDistanceBetweenPoints3D(Px,Py,Pz,vX,vY,vZ)
    distance = distance-(distance/3)
    local progress = distance/22
    local scale = interpolateBetween(0.7, 0, 0, 0.2, 0, 0, progress, "OutQuad")
    scale = scale*(sx+1280)/(1280*2)
    local clear = isLineOfSightClear(cX,cY,cZ,vX,vY,vZ,true,false,false,true,false,false,false)
    local textX,textY = getScreenFromWorldPosition(vX,vY,vZ-0.45)
    if distance < 15 and clear and textX and textY then
      local text = text
      local lenght = dxGetTextWidth(text,1.2,"default-bold")
    if getElementData(localPlayer,"player:adminduty") or v[1] == localPlayer then 
      if isInSlot(textX + lenght/1.9 - 4,textY - 4,25,25) then 
        triggerServerEvent("syncDelete",root,k)
      end 
    end 
    end
  end 
  end
end 
addEventHandler("onClientClick",root,onClientPlayerClick)

function sync(element,message,x,y,z)
  local tableToRecord = {element,message,x,y,z}
  table.insert(placedo, tableToRecord)
end
addEvent("sync",true)
addEventHandler("sync",root,sync)

function deletePlacedo(id)
  table.remove(placedo,id)
end
addEvent("deletePlacedo",true)
addEventHandler("deletePlacedo",root,deletePlacedo)


addEventHandler("onClientResourceStart",resourceRoot  ,function()
triggerServerEvent("syncServer",localPlayer,localPlayer)
end)

function takeMessage(type,message)
  triggerServerEvent("takeMessage",localPlayer,localPlayer,type,message)
end

function clearCh()
  clearChatBox(localPlayer)
end 
addCommandHandler("clearchat",clearCh)

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
addEvent("radio.sound",true);
addEventHandler("radio.sound",root,function()
	playSoundFrontEnd(47);
	setTimer(playSoundFrontEnd, 700, 1, 48);
	setTimer(playSoundFrontEnd, 800, 1, 48);
end);

function setRadiofrequency(cmd,number)
  if getElementData(localPlayer,"player:loggedIn") and not getElementData(localPlayer,"dead") then
    if not number then outputChatBox("#8163bf[Chat] #ffffff/"..cmd.." [Frekvencia]",255,255,255,true) return end
    number = math.floor(number)
    dbid = getElementData(localPlayer,"player:dbid")
    if number == 20020304 and not exports.pdash:isPlayerInGroup(dbid,2) then return end
        setElementData(localPlayer,"player:frequency",number)
        outputChatBox("#8163bf[Chat] #ffffffSikeresen megváltoztattad a Walkie Talkied frekvenciáját a következőre: #8163bf"..number.."#ffffff MHz.",255,255,255,true)
       
  end
end
addCommandHandler("tuneradio",setRadiofrequency)
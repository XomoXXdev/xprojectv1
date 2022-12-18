local screen = {guiGetScreenSize()}
local box = {500,400}
Documents = {}
local pos = {screen[1]/2 -box[1]/2,screen[2]/2 -box[2]/2}
local showJobPanel = false
local font1small = dxCreateFont("files/sfpro.ttf",14)
local namefont = dxCreateFont("files/sfcDisplaybold.ttf",16)
local logo = dxCreateTexture("files/logo.png")

addEventHandler("onClientResourceStart",resourceRoot,function()
	local jobPed = createPed(10,1049.822265625, 1041.6083984375, 10.160055160522)
	setElementRotation(jobPed,0,0, 89.498718261719)
	setElementInterior(jobPed,0)
	setElementDimension(jobPed,0)
	setElementFrozen(jobPed,true)
	setElementData(jobPed,"licenses",true)
    setElementData(jobPed,"ped:name","Lara")
    setElementData(jobPed,"ped:type","Ügyintéző");
end)

addEventHandler("onClientClick", getRootElement(),function(button, state, absX, absY, wx, wy, wz, element)
	if isElement(element) then
		if element  and getElementType(element) == "ped" and state=="down" and getElementData(element,"licenses") then
			local x, y, z = getElementPosition(getLocalPlayer())
			if getDistanceBetweenPoints3D(x, y, z, wx, wy, wz)<=2.5 then
				if not showJobPanel then
					showJobPanel = true	
					ped = element
				end
			end
		end
	end
end)
		
bindKey("backspace","down",function()
	if showJobPanel then
		ped = nil
		showJobPanel = false;
	end
end)

function showJobPanelFasz()
    if showJobPanel then
		dxDrawRectangle(pos[1]+25,pos[2]-50,box[1]-50,box[2]-100,tocolor(23,23,23,255)) -- Háttér
		dxDrawImage(pos[1]+30,pos[2]-45,40,40,"files/logo.png",0,0,0) -- Logo
	    dxDrawText("Okmányok", pos[1]+275,pos[2]-45,pos[1],pos[2],tocolor(129, 99, 191,255),1,namefont,"center","center")

		count = 0
    	for k,v in ipairs(types) do
		    count = count+1
		    dxDrawRectangle(pos[1]+50+30,pos[2]-25+(count*40),box[1]-250,box[2]-375,tocolor(34,34,34,255)) -- Háttér
		    dxDrawRectangle(pos[1]+120+box[1]-250,pos[2]-25+(count*40),box[1]-405,box[2]-375,tocolor(34,34,34,255)) -- Pipa-Háttér
	            dxDrawText(v[1], pos[1]+55+30,pos[2]-26,pos[1],pos[2]+(count*80),tocolor(255,255,255,255),1,font1small,"left","center")
				dxDrawText("Igénylés", pos[1]+55+325,pos[2]-26,pos[1],pos[2]+(count*80),tocolor(255,255,255,255),1,font1small,"left","center")
			
        end
    end
end
addEventHandler("onClientRender",getRootElement(), showJobPanelFasz)

function backarrows(button,state)
    if showJobPanel then
        if button == "left" and state =="down" then
			count = 0;
			for k,v in ipairs(types) do
				count = count + 1;
                if isInSlot(pos[1]+120+box[1]-250,pos[2]-25+(count*40),box[1]-405,box[2]-375) then	
						if getElementData(localPlayer,"player:money") >= 100 then
							local data = {
								name = getElementData(localPlayer,"player:charname"):gsub("_", " "),
								age = getElementData(localPlayer,"player:age"),
								expire = getRealTime().timestamp + (3600 * 24) * 30,
							};
						triggerServerEvent("givelicenses",localPlayer,localPlayer,v[2],toJSON(data),1,0,100,getElementData(localPlayer,"player:charname"):gsub("_", " "))
					    end			
					end
                end
			end
        end
    end
addEventHandler ( "onClientClick", getRootElement(), backarrows )

function inBox(dX, dY, dSZ, dM, eX, eY)
	if(eX >= dX and eX <= dX+dSZ and eY >= dY and eY <= dY+dM) then
		return true
	else
		return false
	end
end


function isInSlot(xS,yS,wS,hS)
	if(isCursorShowing()) then
		XY = {guiGetScreenSize()}
		local cursorX, cursorY = getCursorPosition()
		cursorX, cursorY = cursorX*XY[1], cursorY*XY[2]
		if(inBox(xS,yS,wS,hS, cursorX, cursorY)) then
			return true
		else
			return false
		end
	end
end
Documents = {}
screenX, screenY = guiGetScreenSize()

docW, docH = 512, 280
docX, docY = (screenX - docW) / 2, (screenY - docH) / 2

local docType = nil
local docData = nil
local docVisible = false

function showDocument(documentType, documentData)
    if Documents[documentType] and documentData then
        docType = documentType
        docData = documentData
        docVisible = true
    else
        docType = nil
        docData = nil
        docVisible = false
    end
end
addEvent("licenses:showDocument", true)
addEventHandler("licenses:showDocument", root, showDocument)

function asd()
    if docVisible and docType and docData then
        if Documents[docType] then
            Documents[docType](docData)
        end
    end
end
addEventHandler("onClientRender",root,asd)

Documents["Identity"] = function(data)
	if getElementData(localPlayer,"szemelyiactive") then
    local date = getRealTime(data["expire"])

    dxDrawImage(docX, docY, docW, docH, "szemelyi.png")
	--dxDrawImage(docX+328, docY+70, docW-380, docH-150, "1.jpg")
	dxDrawText("Név: ", docX + 70, docY + 60, docW + docX - 10, docH + docY, tocolor(255, 255, 255, 255), 1, font1small, "left", "top")
	dxDrawText("Állampolgárság: ", docX + 70, docY + 90, docW + docX - 10, docH + docY, tocolor(255, 255, 255, 255), 1, font1small, "left", "top")
	dxDrawText("Amerikai", docX + 220, docY + 90, docW + docX - 10, docH + docY, tocolor(129, 99, 191,255), 1, font1small, "left", "top") 
	dxDrawText("Nem: ", docX + 70, docY + 120, docW + docX - 10, docH + docY, tocolor(255,255,255,255), 1, font1small, "left", "top") 
	dxDrawText("Férfi", docX + 122, docY + 120, docW + docX - 10, docH + docY, tocolor(129, 99, 191,255), 1, font1small, "left", "top")             
    dxDrawText(data["age"], docX + 145, docY + 150, docW + docX - 10, docH + docY, tocolor(129, 99, 191,255), 1, font1small, "left", "top") 
	dxDrawText("Életkor: ", docX + 70, docY + 150, docW + docX - 10, docH + docY, tocolor(255, 255, 255, 255), 1, font1small, "left", "top")
	dxDrawText("Érvényesség: ", docX + 70, docY + 180, docW + docX - 10, docH + docY, tocolor(255, 255, 255, 255), 1, font1small, "left", "top")
	dxDrawText(data["name"], docX + 120, docY + 60, docW + docX - 10, docH + docY, tocolor(129, 99, 191,255), 1, font1small, "left", "top") 
	dxDrawText(date.year + 1900 .. ". " .. string.format("%02d", date.month + 1) .. ". " .. string.format("%02d", date.monthday) .. ".", docX + 200, docY + 180, docW + docX - 10, docH + docY, tocolor(129, 99, 191,255), 1, font1small, "left", "top") 
	show2 = true	
end
end
function szar()
	if getElementData(localPlayer,"szemelyiactive") then
		setElementData(localPlayer,"szemelyiactive",false)
	end
end
bindKey("backspace","down",szar)

Documents["Driverlicense"] = function(data)
	if getElementData(localPlayer,"driveractive") then
    local date = getRealTime(data["expire"])

    dxDrawImage(docX, docY, docW, docH, "jogsi.png")
	--dxDrawImage(docX+328, docY+70, docW-380, docH-150, "1.jpg")
	dxDrawText("Név: ", docX + 70, docY + 60, docW + docX - 10, docH + docY, tocolor(255, 255, 255, 255), 1, font1small, "left", "top")
	dxDrawText("Állampolgárság: ", docX + 70, docY + 90, docW + docX - 10, docH + docY, tocolor(255, 255, 255, 255), 1, font1small, "left", "top")
	dxDrawText("Amerikai", docX + 220, docY + 90, docW + docX - 10, docH + docY, tocolor(129, 99, 191,255), 1, font1small, "left", "top") 
	dxDrawText("Kategória: ", docX + 70, docY + 120, docW + docX - 10, docH + docY, tocolor(255,255,255,255), 1, font1small, "left", "top") 
	dxDrawText("B", docX + 172, docY + 120, docW + docX - 10, docH + docY, tocolor(129, 99, 191,255), 1, font1small, "left", "top")             
    dxDrawText(data["age"], docX + 145, docY + 150, docW + docX - 10, docH + docY, tocolor(129, 99, 191,255), 1, font1small, "left", "top") 
	dxDrawText("Életkor: ", docX + 70, docY + 150, docW + docX - 10, docH + docY, tocolor(255, 255, 255, 255), 1, font1small, "left", "top")
	dxDrawText("Érvényesség: ", docX + 70, docY + 180, docW + docX - 10, docH + docY, tocolor(255, 255, 255, 255), 1, font1small, "left", "top")
	dxDrawText(data["name"], docX + 120, docY + 60, docW + docX - 10, docH + docY, tocolor(129, 99, 191,255), 1, font1small, "left", "top") 
	dxDrawText(date.year + 1900 .. ". " .. string.format("%02d", date.month + 1) .. ". " .. string.format("%02d", date.monthday) .. ".", docX + 200, docY + 180, docW + docX - 10, docH + docY, tocolor(129, 99, 191,255), 1, font1small, "left", "top") 
	show2 = true	
end
end
function szar()
	if getElementData(localPlayer,"driveractive") then
		setElementData(localPlayer,"driveractive",false)
	end
end
bindKey("backspace","down",szar)



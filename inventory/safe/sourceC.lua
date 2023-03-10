fileDelete ("sourceC.lua") 
local safes = {};

func.safe.start = function()
	for k,v in ipairs(getElementsByType("object")) do
		if getElementData(v,"object:dbid") and getElementDimension(localPlayer) == getElementDimension(v) and getElementInterior(localPlayer) == getElementInterior(v) and getElementModel(v) == 2332 then
            if not safes[v] then
				safes[v] = true;
			end
        end
	end
end
addEventHandler("onClientResourceStart",resourceRoot,func.safe.start)

func.safe.streamOut = function()
    if getElementType(source) == "object" and getElementData(source, "object:dbid") and getElementModel(source) == 2332 then
        safes[source] = nil;
    end
end
addEventHandler("onClientElementStreamOut",getRootElement(),func.safe.streamOut)

func.safe.streamIn = function()
    if getElementType(source) == "object" and getElementData(source, "object:dbid") and getElementDimension(localPlayer) == getElementDimension(source) and getElementInterior(localPlayer) == getElementInterior(source) and getElementModel(source) == 2332 then
        if not safes[source] then
            safes[source] = true;
        end
    end
end
addEventHandler("onClientElementStreamIn",getRootElement(),func.safe.streamIn)

func.safe.destroy = function()
    if getElementType(source) == "object" and getElementData(source, "object:dbid") and getElementDimension(localPlayer) == getElementDimension(source) and getElementInterior(localPlayer) == getElementInterior(source) and getElementModel(source) == 2332 then
        if safes[source] then
            safes[source] = nil;
        end
    end
end
addEventHandler("onClientElementDestroy", getRootElement(),func.safe.destroy)

func.safe.render = function()
	if cache.safe.show then
		local pX,pY,pZ, _, _, _ = getCameraMatrix()
		for v,k in pairs(safes) do
			if isElementStreamedIn(v) then
				local safeX,safeY,safeZ = getElementPosition(v)
				local x,y = getScreenFromWorldPosition(safeX, safeY, safeZ+1)
				local distance = getDistanceBetweenPoints3D(safeX, safeY, safeZ, pX, pY, pZ)
				if distance <= 30 then
					local line = isLineOfSightClear(safeX, safeY, safeZ+1, pX, pY, pZ, true, true, false, true, false, false, false, localPlayer)
					if line then
						if x or y then
							dxDrawText("["..getElementData(v,"object:dbid").."]",x,y,x,y,tocolor(255,255,255,255),0.5,cache.font.roboto,"center","center")
						end
					end
				end
			end
		end
	end
end

func.safe.nearby = function()
	if getElementData(localPlayer,"player:admin") >= 3 then
		cache.safe.show = not cache.safe.show
		if cache.safe.show then
			addEventHandler("onClientRender",getRootElement(),func.safe.render)
			outputChatBox("#8163bf[xProject]:#ffffff Sz??f inform??ci?? megjelen??tve.",0,0,0,true)
		else
			removeEventHandler("onClientRender",getRootElement(),func.safe.render)
			outputChatBox("#8163bf[xProject]:#ffffff Sz??f inform??ci?? elt??ntetve.",0,0,0,true)
		end
	end
end
addCommandHandler("nearbysafe",func.safe.nearby)
fileDelete ("sourceC.lua") 
local bins = {};

func.trash.start = function()
	for k,v in ipairs(getElementsByType("object")) do
		if getElementData(v,"object:dbid") and getElementDimension(localPlayer) == getElementDimension(v) and getElementInterior(localPlayer) == getElementInterior(v) and getElementModel(v) == 1359 then
            if not bins[v] then
				bins[v] = true;
			end
        end
	end
end
addEventHandler("onClientResourceStart",resourceRoot,func.trash.start)

func.trash.streamOut = function()
    if getElementType(source) == "object" and getElementData(source, "object:dbid") and getElementModel(source) == 1359 then
        bins[source] = nil;
    end
end
addEventHandler("onClientElementStreamOut",getRootElement(),func.trash.streamOut)

func.trash.streamIn = function()
    if getElementType(source) == "object" and getElementData(source, "object:dbid") and getElementDimension(localPlayer) == getElementDimension(source) and getElementInterior(localPlayer) == getElementInterior(source) and getElementModel(source) == 1359 then
        if not bins[source] then
            bins[source] = true;
        end
    end
end
addEventHandler("onClientElementStreamIn",getRootElement(),func.trash.streamIn)

func.trash.destroy = function()
    if getElementType(source) == "object" and getElementData(source, "object:dbid") and getElementDimension(localPlayer) == getElementDimension(source) and getElementInterior(localPlayer) == getElementInterior(source) and getElementModel(source) == 1359 then
        if bins[source] then
            bins[source] = nil;
        end
    end
end
addEventHandler("onClientElementDestroy", getRootElement(),func.trash.destroy)

func.trash.render = function()
	if cache.trash.show then
		local pX,pY,pZ, _, _, _ = getCameraMatrix()
		for v,k in pairs(bins) do
			if isElementStreamedIn(v) then
				local trashX,trashY,trashZ = getElementPosition(v)
				local x,y = getScreenFromWorldPosition(trashX, trashY, trashZ+1)
				local distance = getDistanceBetweenPoints3D(trashX, trashY, trashZ, pX, pY, pZ)
				if distance <= 30 then
					local line = isLineOfSightClear(trashX, trashY, trashZ+1, pX, pY, pZ, true, true, false, true, false, false, false, localPlayer)
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

func.trash.nearby = function()
	if getElementData(localPlayer,"player:admin") >= 7 then
		cache.trash.show = not cache.trash.show
		if cache.trash.show then
			addEventHandler("onClientRender",getRootElement(),func.trash.render)
			outputChatBox("[Szervernév]:#ffffff Kuka információ megjelenítve.",220,20,60,true)
		else
			removeEventHandler("onClientRender",getRootElement(),func.trash.render)
			outputChatBox("[Szervernév]:#ffffff Kuka információ eltüntetve.",220,20,60,true)
		end
	end
end
addCommandHandler("nearbytrash",func.trash.nearby)
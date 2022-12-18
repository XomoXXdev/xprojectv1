fileDelete ("codeC.lua") 
Display = {};
Display.Width, Display.Height = guiGetScreenSize();
radarSettings = {
	['mapTexture'] = 'files/images/map.png',
	['mapSecondTexture'] = 'files/images/map.png',
	['mapTextureSize'] = 1600, -- px
	['mapWaterColor'] = {110,158,204},
	['alpha'] = 250
};
local posBoxes = {128,128}
local posTable = {Display.Width/2 -posBoxes[1]/2,Display.Height/2 -posBoxes[2]/2}
selectedBlip = nil
Minimap = {};
Minimap.Width = Display.Width*0.2
Minimap.Height = Display.Height*0.23
Minimap.PosX = getElementData(localPlayer,"player:interface:radarx")
Minimap.PosY = getElementData(localPlayer,"player:interface:radary")
Minimap.State = true;
local mapRatio = 6000 / radarSettings['mapTextureSize'];

Minimap.IsVisible = true;
Minimap.TextureSize = radarSettings['mapTextureSize'];
Minimap.NormalTargetSize, Minimap.BiggerTargetSize = Minimap.Width, Minimap.Width * 2;
Minimap.MapTarget = dxCreateRenderTarget(Minimap.BiggerTargetSize, Minimap.BiggerTargetSize, true);
Minimap.RenderTarget = dxCreateRenderTarget(Minimap.NormalTargetSize * 3, Minimap.NormalTargetSize * 3, true);
Minimap.MapTexture = dxCreateTexture(radarSettings['mapTexture']);

Minimap.CurrentZoom = 5;
Minimap.MaximumZoom = 10;
Minimap.MinimumZoom = 5;

Minimap.WaterColor = radarSettings['mapWaterColor'];
Minimap.Alpha = radarSettings['alpha'];
Minimap.PlayerInVehicle = false;
Minimap.LostRotation = 0;
Minimap.MapUnit = Minimap.TextureSize / 6000;

Bigmap = {};
Bigmap.Width, Bigmap.Height = Display.Width - 40, Display.Height - 40;
Bigmap.PosX, Bigmap.PosY = 20, 20;
Bigmap.IsVisible = false;
Bigmap.CurrentZoom = 2;
Bigmap.MinimumZoom = 0.8;
Bigmap.MaximumZoom = 2;

Fonts = {};
Fonts.Roboto = dxCreateFont('files/fonts/Lato-Regular.ttf', 12, false, 'antialiased');
Fonts.latosmall = dxCreateFont('files/fonts/Lato-Regular.ttf', 10, false, 'antialiased');
Fonts.fontawsome = dxCreateFont('files/fonts/fontawsome.ttf', 10, false, 'antialiased');
local wheel = 0
Stats = {};
Stats.Bar = {};
Stats.Bar.Width = Minimap.Width;
Stats.Bar.Height = 10;

local playerX, playerY, playerZ = 0, 0, 0;
local mapOffsetX, mapOffsetY, mapIsMoving = 0, 0, false;
local lastClick = 0
local maximumBlips = 15;
local currentBlip = 1
local gpsRoute = {}



local blips = {}
local maxDist = 450
local bigMapBlips = {}
local blipCache = {};
local playerCache = {};

addEventHandler("onClientElementDataChange",root,function(theKey, oldValue, newValue)
	if theKey == "player:loggedIn" then 

		--[[if source == getLocalPlayer() and getElementData(source,theKey) then 
			Minimap.MapTexture = dxCreateTexture(radarSettings['mapTexture']);
			Minimap.MapTarget = dxCreateRenderTarget(Minimap.BiggerTargetSize, Minimap.BiggerTargetSize, true);
			Minimap.RenderTarget = dxCreateRenderTarget(Minimap.NormalTargetSize * 3, Minimap.NormalTargetSize * 3, true);
		end ]]

		if getElementData(source,theKey) then
			if not playerCache[source] then
				playerCache[source] = true;
			end
		end

	end 

	if getElementType(source) == "blip" then
		if theKey == "blipIcon" then
			if getElementData(source,theKey) then
				if not blipCache[source] then
					blipCache[source] = true;
				end
			end
		end
	end

end)

addEventHandler('onClientResourceStart', resourceRoot,
	function()

		setPlayerHudComponentVisible('radar', false);
		if (Minimap.MapTexture) then
			dxSetTextureEdge(Minimap.MapTexture, 'border', tocolor(Minimap.WaterColor[1], Minimap.WaterColor[2], Minimap.WaterColor[3], 255));
		end
		for k,v in ipairs(serverBlips) do
			blips[k] = createBlip(v[3], v[4], v[5], v[1])
			setElementData(blips[k], "blipIcon", v[1])
			setElementData(blips[k], "blipName", v[2])
			blipCache[blips[k]] = true;
		end

		for _, player in ipairs(getElementsByType("player")) do
			if getElementData(player,"player:loggedIn") then
				if not playerCache[player] then
					playerCache[player] = true;
				end
			end
		end
	end
);

function onQuitGame()
    if playerCache[source] then
        playerCache[source] = nil;
    end
end
addEventHandler( "onClientPlayerQuit", getRootElement(), onQuitGame )

addEventHandler("onClientElementDestroy", getRootElement(),function()
    if getElementType(source) == "blip" then
        if blipCache[source] then
            blipCache[source] = nil;
        end
    end
end)

addEventHandler('onClientKey', root,
	function(key, state) 
		if (state) and getElementData(localPlayer, "player:loggedIn") then
			if (key == 'F11') then
				cancelEvent();
				if ( getElementInterior(localPlayer) == 0 ) then
					Bigmap.IsVisible = not Bigmap.IsVisible;
					showCursor(false);
					if (Bigmap.IsVisible) then
						setPlayerHudComponentVisible('all', false);
						setPlayerHudComponentVisible('crosshair', true);
						showChat(false);
						bubble = playSound("files/open.mp3")		
						Minimap.IsVisible = false;
						setElementData(localPlayer, "player:toghud", true)
						addEventHandler("onClientRender",root,drawnBigMap)
					else
						setElementData(localPlayer, "player:toghud", false)
						showChat(true);
						removeEventHandler("onClientRender",root,drawnBigMap)
						bubble = playSound("files/open.mp3")	
						Minimap.IsVisible = true;
						mapIsMoving = false;
					end
				end
			elseif (key == 'mouse_wheel_down' and Bigmap.IsVisible) then
					Bigmap.CurrentZoom = math.min(Bigmap.CurrentZoom + 0.25, Bigmap.MaximumZoom);
			elseif (key == 'mouse_wheel_up' and Bigmap.IsVisible) then
				Bigmap.CurrentZoom = math.max(Bigmap.CurrentZoom - 0.25, Bigmap.MinimumZoom);
			end
		end
	end
);

addEventHandler('onClientClick', root,
	function(button, state, cursorX, cursorY)
		if (not Minimap.IsVisible and Bigmap.IsVisible) then
			if (button == 'left' and state == 'down') then
				if (cursorX >= Bigmap.PosX and cursorX <= Bigmap.PosX + Bigmap.Width) then
					if (cursorY >= Bigmap.PosY and cursorY <= Bigmap.PosY + Bigmap.Height) then
						mapOffsetX = cursorX * Bigmap.CurrentZoom + playerX;
						mapOffsetY = cursorY * Bigmap.CurrentZoom - playerY;
						mapIsMoving = true;
					end
				end
			elseif (button == 'left' and state == 'up') then
				mapIsMoving = false;
			end
		end
	end
);




-- Nagy Radar
function drawnBigMap()
	if (not Minimap.IsVisible and Bigmap.IsVisible) then
		local absoluteX, absoluteY = 0, 0;
		local s = {guiGetScreenSize()}
		local rightX, rightY = (s[1]/2-85/2) * 2 , (s[2]/2 - 745/2) / 2 
		latestLine = currentBlip + maximumBlips - 1
		count = 0
		if (getElementInterior(localPlayer) == 0) then
			if (isCursorShowing()) then
				local cursorX, cursorY = getCursorPosition();
				local mapX, mapY = getWorldFromMapPosition(cursorX, cursorY);
				
				absoluteX = cursorX * Display.Width;
				absoluteY = cursorY * Display.Height;
				
				if (getKeyState('mouse1') and mapIsMoving) then
					playerX = -(absoluteX * Bigmap.CurrentZoom - mapOffsetX);
					playerY = absoluteY * Bigmap.CurrentZoom - mapOffsetY;
				else
					
				end
				
			end
			
			local playerRotation = getPedRotation(localPlayer);
			local mapX = (((3000 + playerX) * Minimap.MapUnit) - (Bigmap.Width / 2) * Bigmap.CurrentZoom);
			local mapY = (((3000 - playerY) * Minimap.MapUnit) - (Bigmap.Height / 2) * Bigmap.CurrentZoom);
			local mapWidth, mapHeight = Bigmap.Width * Bigmap.CurrentZoom, Bigmap.Height * Bigmap.CurrentZoom;

			dxDrawRectangle(Bigmap.PosX-4, Bigmap.PosY-4, Bigmap.Width+8, Bigmap.Height+8, tocolor(30,30,30,255))
			--dxDrawRectangle(Bigmap.PosX-3, Bigmap.PosY-3, Bigmap.Width+6, Bigmap.Height+6, tocolor(39,39,39,255))
			--dxDrawRectangle(Bigmap.PosX-1, Bigmap.PosY-1, Bigmap.Width+2, Bigmap.Height+2, tocolor(30,30,30,255))


			dxDrawRectangle(Bigmap.PosX+2, Bigmap.PosY+2, Bigmap.Width-4, Bigmap.Height-4, tocolor(152,200,249,200))

			dxDrawImageSection(Bigmap.PosX+2, Bigmap.PosY+2, Bigmap.Width-4, Bigmap.Height-4, mapX, mapY, mapWidth, mapHeight, Minimap.MapTexture, 0, 0, 0, tocolor(255, 255, 255, Minimap.Alpha));


			dxDrawRectangle(Bigmap.PosX, Bigmap.PosY + Bigmap.Height - 30, Bigmap.Width, 30, tocolor(39,39,39,180));
			local zonex,zoney,zonez = getElementPosition(localPlayer)
			local zone = getZoneName(zonex,zoney,zonez) 
			dxDrawText(zone, Bigmap.PosX + 30 - 1, (Bigmap.PosY + Bigmap.Height - 26) + 1, 0,0, tocolor(0,0,0, 255), 1, Fonts.Roboto, 'left', 'top');
			dxDrawText(zone, Bigmap.PosX + 30, (Bigmap.PosY + Bigmap.Height - 26), 0,0, tocolor(255,255,255, 255), 1, Fonts.Roboto, 'left', 'top');
			dxDrawText("", Bigmap.PosX + 5 - 1, (Bigmap.PosY + Bigmap.Height - 26) + 3 + 1, 0,0, tocolor(0,0,0, 255), 1, Fonts.fontawsome, 'left', 'top');
			dxDrawText("", Bigmap.PosX + 5, (Bigmap.PosY + Bigmap.Height - 26) + 3, 0,0, tocolor(255,255,255, 255), 1, Fonts.fontawsome, 'left', 'top');

			--[[
			dxDrawRectangle(Bigmap.PosX+Bigmap.Width-4-160, Bigmap.PosY-4+Bigmap.Height-30, 150+8, 20+8, tocolor(30,30,30,255))
			dxDrawRectangle(Bigmap.PosX+Bigmap.Width-3-160, Bigmap.PosY-3+Bigmap.Height-30, 150+6, 20+6, tocolor(39,39,39,255))
			dxDrawRectangle(Bigmap.PosX+Bigmap.Width-1-160, Bigmap.PosY-1+Bigmap.Height-30, 150+2, 20+2, tocolor(30,30,30,255))
			]]--
			
			--> Blipek
			for blip,k in pairs(blipCache) do
				local blipX, blipY, blipZ = getElementPosition(blip);

				if (localPlayer ~= getElementAttachedTo(blip)) then
					local blipSettings = {
						['color'] = {255, 255, 255, 255},
						['size'] = getElementData(blip, 'blipSize') or 30,
						['icon'] = getElementData(blip, 'blipIcon') or 'target',
						['exclusive'] = getElementData(blip, 'exclusiveBlip') or false,
						['name'] = getElementData(blip, 'blipName') or 'Nem Elérhető'
					};
					
					if (blipSettings['icon'] == 'target' or blipSettings['icon'] == 'waypoint') or blipSettings['icon'] == '37' then
						blipSettings['color'] = {getBlipColor(blip)};
					end
					
					local centerX, centerY = (Bigmap.PosX + (Bigmap.Width / 2)), (Bigmap.PosY + (Bigmap.Height / 2));
					local leftFrame = (centerX - Bigmap.Width / 2) + (blipSettings['size'] / 2);
					local rightFrame = (centerX + Bigmap.Width / 2) - (blipSettings['size'] / 2);
					local topFrame = (centerY - Bigmap.Height / 2) + (blipSettings['size'] / 2);
					local bottomFrame = (centerY + Bigmap.Height / 2) - (blipSettings['size'] / 2);
					local blipX, blipY = getMapFromWorldPosition(blipX, blipY);
					centerX = math.max(leftFrame, math.min(rightFrame, blipX));
					centerY = math.max(topFrame, math.min(bottomFrame, blipY));
					

					if isInSlot(centerX-12.5,centerY-12.5,25,25) then
						dxDrawImage(centerX-12.5-2.5,centerY-12.5-2.5,25+5,25+5,"files/images/blips/".. blipSettings['icon'] ..".png",0, 0, 0, tocolor(blipSettings['color'][1],blipSettings['color'][2],blipSettings['color'][3], 255),false);
						dxDrawRectangle(centerX-12.5-dxGetTextWidth(blipSettings['name'],1,Fonts.latosmall)/2+7, centerY-12.5-17,dxGetTextWidth(blipSettings['name'],1,Fonts.latosmall)+8,21.5,tocolor(41,41,41,255))
						dxDrawText(blipSettings['name'],centerX-12.5-dxGetTextWidth(blipSettings['name'],1,Fonts.latosmall)/2+12, centerY-12.5-15,_,_, tocolor(255,255,255,255),1,Fonts.latosmall)    
					else
						dxDrawImage(centerX-12.5,centerY-12.5,25,25,"files/images/blips/".. blipSettings['icon'] ..".png",0, 0, 0, tocolor(blipSettings['color'][1],blipSettings['color'][2],blipSettings['color'][3], 255),false);
					end
				end
			end
			
			
			
			for player,k in pairs(playerCache) do
				local otherPlayerX, otherPlayerY, otherPlayerZ = getElementPosition(player);
				if getElementData(localPlayer, "player:adminduty") then	
				if (localPlayer ~= player) then
					local playerIsVisible = false;
					local blipSettings = {
						['color'] = {255, 255, 255, 255},
						['size'] = 25,
						['icon'] = 'arrowotherplayer'
					};
					


					local blipX, blipY = getMapFromWorldPosition(otherPlayerX, otherPlayerY);
					local _,_,otherPlayerRotation = getElementRotation(player)
					local streamDistance, pRotation = getRadarRadius(), getRotation();


					if (blipX >= Bigmap.PosX and blipX <= Bigmap.PosX + Bigmap.Width) then
						if (blipY >= Bigmap.PosY and blipY <= Bigmap.PosY + Bigmap.Height) then
							dxDrawImage(blipX - (blipSettings['size'] / 2), blipY - (blipSettings['size'] / 2), blipSettings['size'], blipSettings['size'], 'files/images/' .. blipSettings['icon'] .. '.png',otherPlayerRotation - 320, 0, 0, tocolor(blipSettings['color'][1], blipSettings['color'][2], blipSettings['color'][3], blipSettings['color'][4]));
							if isInSlot(blipX - (blipSettings['size'] / 2), blipY - (blipSettings['size'] / 2),20,20) then
								dxDrawRectangle(blipX - (blipSettings['size'] / 2)-dxGetTextWidth(getElementData(player,"player:charname"),1,Fonts.latosmall)/2+7, blipY - (blipSettings['size'] / 2)-17,dxGetTextWidth(getElementData(player,"player:charname"),1,Fonts.latosmall)+8,21.5,tocolor(41,41,41,255))
								dxDrawText(utf8.gsub(getElementData(player,"player:charname"),"_"," "),blipX - (blipSettings['size'] / 2)-dxGetTextWidth(getElementData(player,"player:charname"),1,Fonts.latosmall)/2+12, blipY - (blipSettings['size'] / 2)-15,_,_, tocolor(255,255,255,255),1,Fonts.latosmall)
							end
						end
					end
				end
			end
			end
			--> Játékos
			--if not isPedInVehicle(localPlayer) then
				local localX, localY, localZ = getElementPosition(localPlayer);
				local blipX, blipY = getMapFromWorldPosition(localX, localY);
						
				if (blipX >= Bigmap.PosX and blipX <= Bigmap.PosX + Bigmap.Width) then
					if (blipY >= Bigmap.PosY and blipY <= Bigmap.PosY + Bigmap.Height) then
						dxDrawImage(blipX - 10, blipY - 10, 20, 20, 'files/images/arrow.png', 360 - playerRotation);
					end
				end
			--end
		else

		end
	end
end


-- Kis Radar
addEventHandler('onClientRender', root,
	function()
	if getElementData(localPlayer, "player:loggedIn") then
		if (not Minimap.IsVisible and Bigmap.IsVisible) then

			elseif (Minimap.IsVisible and not Bigmap.IsVisible) and Minimap.State then
				if not getElementData(localPlayer, "player:toghud") and getElementData(localPlayer,"player:interface:radaravalible") then

					
					if (getElementInterior(localPlayer) == 0) then

						Minimap.PosX,Minimap.PosY = getElementData(localPlayer,"player:interface:radarx"),getElementData(localPlayer,"player:interface:radary")

						--local xp = getElementData(localPlayer,"player:xp")
						--local level = getElementData(localPlayer,"player:level")

						--dxDrawRectangle(Minimap.PosX-4, Minimap.PosY-4-50, Minimap.Width+8, 40+8, tocolor(30,30,30,255))
						--dxDrawRectangle(Minimap.PosX-3, Minimap.PosY-3-50, Minimap.Width+6, 40+6, tocolor(39,39,39,255))
						--dxDrawRectangle(Minimap.PosX-1, Minimap.PosY-1-50, Minimap.Width+2, 40+2, tocolor(30,30,30,255))
						--dxDrawRectangle(Minimap.PosX+4, Minimap.PosY-1-33, Minimap.Width-8, 15, tocolor(39,39,39,255))
						--dxDrawRectangle(Minimap.PosX+6, Minimap.PosY-1-31, (Minimap.Width-12)/exports.vice_level:getNextLevelXP(level)*xpAniamtion, 11, tocolor(242, 125, 253,255))
						--dxDrawText(xpAniamtion.." xp", Minimap.PosX+6, Minimap.PosY-1-50, _, _, tocolor(255,255,255,255), 1, Fonts.latosmall)
						--dxDrawText(exports.vice_level:getNextLevelXP(level).." xp", Minimap.PosX+Minimap.Width-8-dxGetTextWidth ( exports.vice_level:getNextLevelXP(level).." xp", 1, Fonts.latosmall), Minimap.PosY-1-50, _, _, tocolor(255,255,255,255), 1, Fonts.latosmall)
						--dxDrawText(level.." #F27DFDlvl", (((Minimap.PosX+4)+(Minimap.Width-8))/2)-dxGetTextWidth ( level.." lvl", 1, Fonts.latosmall)/2, Minimap.PosY-1-50, _, _, tocolor(255,255,255,255), 1, Fonts.latosmall,"left","top",false,false,false,true)
						--latosmall

						--if xpAniamtion > tonumber(xp) then
						--	xpAniamtion = xp
						--end
						--if xpAniamtion < tonumber(xp) then
						--	xpAniamtion = xpAniamtion + 1
						--end
					

						--dxDrawRectangle(Minimap.PosX-4, Minimap.PosY-4, Minimap.Width+8, Minimap.Height+8, tocolor(30,30,30,255))
						--dxDrawRectangle(Minimap.PosX-3, Minimap.PosY-3, Minimap.Width+6, Minimap.Height+6, tocolor(39,39,39,255))
						--dxDrawRectangle(Minimap.PosX-1, Minimap.PosY-1, Minimap.Width+2, Minimap.Height+2, tocolor(30,30,30,255))


						Minimap.PlayerInVehicle = getPedOccupiedVehicle(localPlayer);
						playerX, playerY, playerZ = getElementPosition(localPlayer);
						
						--> Pozició számolás
						local _,_,playerRotation = getElementRotation(localPlayer);
						local playerMapX, playerMapY = (3000 + playerX) / 6000 * Minimap.TextureSize, (3000 - playerY) / 6000 * Minimap.TextureSize;
						local streamDistance, pRotation = getRadarRadius(), getRotation();
						local mapRadius = streamDistance / 6000 * Minimap.TextureSize * Minimap.CurrentZoom;
						local mapX, mapY, mapWidth, mapHeight = playerMapX - mapRadius, playerMapY - mapRadius, mapRadius * 2, mapRadius * 2;
						local postGui = getElementData(localPlayer,"player:interface")
						--> Set world
						dxSetRenderTarget(Minimap.MapTarget, true);
						dxDrawImageSection(0, 0, Minimap.BiggerTargetSize, Minimap.BiggerTargetSize, mapX, mapY, mapWidth, mapHeight, Minimap.MapTexture, 0, 0, 0, tocolor(255, 255, 255, Minimap.Alpha), false);
						
						--> Blipek felrajzolása
                        dxSetRenderTarget(Minimap.RenderTarget, true);
						dxDrawImage(Minimap.NormalTargetSize / 2, Minimap.NormalTargetSize / 2, Minimap.BiggerTargetSize, Minimap.BiggerTargetSize, Minimap.MapTarget, math.deg(-pRotation), 0, 0, tocolor(255, 255, 255, 255), false);

						local count = 0
						for blip,_ in pairs(blipCache) do
							if isElement(blip) then
								local blipX, blipY, blipZ = getElementPosition(blip);
								count = count + 1
								if (localPlayer ~= getElementAttachedTo(blip) and getElementInterior(localPlayer) == getElementInterior(blip) and getElementDimension(localPlayer) == getElementDimension(blip)) then
									local blipDistance = getDistanceBetweenPoints2D(blipX, blipY, playerX, playerY);
									local blipRotation = math.deg(-getVectorRotation(playerX, playerY, blipX, blipY) - (-pRotation)) - 180;
									local blipRadius = math.min((blipDistance / (streamDistance * Minimap.CurrentZoom)) * Minimap.NormalTargetSize, Minimap.NormalTargetSize);
									local distanceX, distanceY = getPointFromDistanceRotation(0, 0, blipRadius, blipRotation);
									
									local blipSettings = {
										['color'] = {255, 255, 255, 255},
										['size'] = getElementData(blip, 'blipSize') or 30,
										['exclusive'] = getElementData(blip, 'exclusiveBlip') or false,
										['icon'] = getElementData(blip, 'blipIcon') or 'target'
									};
									
									local blipX, blipY = Minimap.NormalTargetSize * 1.5 + (distanceX - (blipSettings['size'] / 2)), Minimap.NormalTargetSize * 1.5 + (distanceY - (blipSettings['size'] / 2));
									local calculatedX, calculatedY = ((Minimap.PosX + (Minimap.Width / 2)) - (blipSettings['size'] / 2)) + (blipX - (Minimap.NormalTargetSize * 1.5) + (blipSettings['size'] / 2)), (((Minimap.PosY + (Minimap.Height / 2)) - (blipSettings['size'] / 2)) + (blipY - (Minimap.NormalTargetSize * 1.5) + (blipSettings['size'] / 2)));
									
									if (blipSettings['icon'] == 'target' or blipSettings['icon'] == 'waypoint' or blipSettings['icon'] == '37') then
										blipSettings['color'] = {getBlipColor(blip)};
									end
									
									if (blipSettings['exclusive'] == true) then
										blipX = math.max(blipX + (Minimap.PosX - calculatedX), math.min(blipX + (Minimap.PosX + Minimap.Width - blipSettings['size'] - calculatedX), blipX));
										blipY = math.max(blipY + (Minimap.PosY - calculatedY), math.min(blipY + (Minimap.PosY + Minimap.Height - blipSettings['size'] - 25 - calculatedY), blipY));
									end
									dxDrawImage(blipX,blipY, 25,25,"files/images/blips/".. blipSettings['icon'] ..".png",0, 0, 0, tocolor(blipSettings['color'][1],blipSettings['color'][2],blipSettings['color'][3], 255),false);
								end
							end
						end
                    
                        --outputChatBox(count)
                    
						--> Teljes minimap
						dxSetRenderTarget();
						dxDrawRectangle(Minimap.PosX, Minimap.PosY, Minimap.Width, Minimap.Height, tocolor(50,50,50,255),postGui)

                        --dxDrawImageSection(Minimap.PosX, Minimap.PosY, Minimap.Width, Minimap.Height, Minimap.NormalTargetSize / 2 + (Minimap.BiggerTargetSize / 2) - (Minimap.Width / 2), Minimap.NormalTargetSize / 2 + (Minimap.BiggerTargetSize / 2) - (Minimap.Height / 2), Minimap.Width, Minimap.Height, Minimap.MapTarget, 0, -90, 0, tocolor(255, 255, 255, 255));
                    
						dxDrawImageSection(Minimap.PosX, Minimap.PosY, Minimap.Width, Minimap.Height, Minimap.NormalTargetSize / 2 + (Minimap.BiggerTargetSize / 2) - (Minimap.Width / 2), Minimap.NormalTargetSize / 2 + (Minimap.BiggerTargetSize / 2) - (Minimap.Height / 2), Minimap.Width, Minimap.Height, Minimap.RenderTarget, 0, -90, 0, tocolor(255, 255, 255, 255),postGui);
						
						--> Játékos
						--if not isPedInVehicle(localPlayer) then
							dxDrawImage((Minimap.PosX + (Minimap.Width / 2)) - 10, (Minimap.PosY + (Minimap.Height / 2)) - 10, 20, 20, 'files/images/arrow.png', math.deg(-pRotation) - playerRotation);
						--end
						--> GPS
						dxDrawRectangle(Minimap.PosX, Minimap.PosY + Minimap.Height - 30, Minimap.Width, 30, tocolor(42,42,42,210),postGui);

						local zonex,zoney,zonez = getElementPosition(localPlayer)
						local zone = getZoneName(zonex,zoney,zonez) 
						dxDrawText(zone, Minimap.PosX + 30, (Minimap.PosY + Minimap.Height - 26), 0,0, tocolor(255,255,255, 255), 1, Fonts.Roboto, "left", "top",false,false,postGui);
						dxDrawText("", Minimap.PosX + 5, (Minimap.PosY + Minimap.Height - 26) + 3, 0,0, tocolor(255,255,255, 255), 1, Fonts.fontawsome, 'left', 'top',false,false,postGui);

						dxDrawImage(Minimap.PosX, Minimap.PosY, Minimap.Width, Minimap.Height,"files/images/shadow.png")
						
						
						--> Zoom
						if (getKeyState('num_add') or getKeyState('num_sub')) then
							Minimap.CurrentZoom = math.max(Minimap.MinimumZoom, math.min(Minimap.MaximumZoom, Minimap.CurrentZoom + ((getKeyState('num_sub') and -1 or 1) * (getTickCount() - (getTickCount() + 50)) / 100)));
						end

					else
						--dxDrawRectangle(Minimap.PosX, Minimap.PosY, Minimap.Width, Minimap.Height, tocolor(0, 0, 0, 150));
					end
				end
			end
		end
    end
);

addEventHandler("onClientClick", getRootElement(),
	function (button, state, cursorX, cursorY)

	end
)


-- Funkciók

function remapTheFirstWay(coord)
	return (coord + 3000) / mapRatio
end


function remapTheSecondWay(coord)
	return (-coord + 3000) / mapRatio*2
end

function doesCollide(x1, y1, w1, h1, x2, y2, w2, h2)
	local horizontal = (x1 < x2) ~= (x1 + w1 < x2) or (x1 > x2) ~= (x1 > x2 + w2);
	local vertical = (y1 < y2) ~= (y1 + h1 < y2) or (y1 > y2) ~= (y1 > y2 + h2);
	
	return (horizontal and vertical);
end

function getRadarRadius()
		return 180;
end

function getPointFromDistanceRotation(x, y, dist, angle)
	local a = math.rad(90 - angle);
	local dx = math.cos(a) * dist;
	local dy = math.sin(a) * dist;
	
	return x + dx, y + dy;
end

function getRotation()
	local cameraX, cameraY, _, rotateX, rotateY = getCameraMatrix();
	local camRotation = getVectorRotation(cameraX, cameraY, rotateX, rotateY);
	
	return camRotation;
end

function getVectorRotation(X, Y, X2, Y2)
	local rotation = 6.2831853071796 - math.atan2(X2 - X, Y2 - Y) % 6.2831853071796;
	
	return -rotation;
end

function dxDrawBorder(x, y, w, h, size, color, postGUI)
	size = size or 2;
	
	dxDrawRectangle(x - size, y, size, h, color or tocolor(0, 0, 0, 180), postGUI);
	dxDrawRectangle(x + w, y, size, h, color or tocolor(0, 0, 0, 180), postGUI);
	dxDrawRectangle(x - size, y - size, w + (size * 2), size, color or tocolor(0, 0, 0, 180), postGUI);
	dxDrawRectangle(x - size, y + h, w + (size * 2), size, color or tocolor(0, 0, 0, 180), postGUI);
end

function getMinimapState()
	return Minimap.IsVisible;
end

function getBigmapState()
	return Bigmap.IsVisible;
end

function getMapFromWorldPosition(worldX, worldY)
	local centerX, centerY = (Bigmap.PosX + (Bigmap.Width / 2)), (Bigmap.PosY + (Bigmap.Height / 2));
	local mapLeftFrame = centerX - ((playerX - worldX) / Bigmap.CurrentZoom * Minimap.MapUnit);
	local mapRightFrame = centerX + ((worldX - playerX) / Bigmap.CurrentZoom * Minimap.MapUnit);
	local mapTopFrame = centerY - ((worldY - playerY) / Bigmap.CurrentZoom * Minimap.MapUnit);
	local mapBottomFrame = centerY + ((playerY - worldY) / Bigmap.CurrentZoom * Minimap.MapUnit);
	
	centerX = math.max(mapLeftFrame, math.min(mapRightFrame, centerX));
	centerY = math.max(mapTopFrame, math.min(mapBottomFrame, centerY));
	
	return centerX, centerY;
end

function getWorldFromMapPosition(mapX, mapY)
	local worldX = playerX + ((mapX * ((Bigmap.Width * Bigmap.CurrentZoom - mapOffsetX) * 2)) - (Bigmap.Width * Bigmap.CurrentZoom));
	local worldY = playerY + ((mapY * ((Bigmap.Height * Bigmap.CurrentZoom + mapOffsetY) * 2)) - (Bigmap.Height * Bigmap.CurrentZoom)) * -1;
	
	return worldX, worldY;
end

bindKey("mouse_wheel_up", "down",function()
	if Bigmap.IsVisible then
		wheel = wheel - 1
		if wheel < 1 then
			wheel = 0
		end
	end
end)

bindKey("mouse_wheel_down", "down",function()
	if Bigmap.IsVisible then
		
		wheel = wheel + 1
		if wheel > getAllBlip() - 15 then
			wheel = getAllBlip() - 15
		end
	end
end)

function getAllBlip()
	local a = 0
	for k,v in pairs(blipCache) do
		a = a+1
	end
	return a
end

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

function fixer( didClearRenderTargets )
	if didClearRenderTargets then
		Minimap.MapTarget = dxCreateRenderTarget(Minimap.BiggerTargetSize, Minimap.BiggerTargetSize, true);
		Minimap.RenderTarget = dxCreateRenderTarget(Minimap.NormalTargetSize * 3, Minimap.NormalTargetSize * 3, true);
    end
end
addEventHandler("onClientRestore",root,fixer)

function resetRadar()
	triggerServerEvent("reload",localPlayer,localPlayer)
	outputChatBox("radar restarted")
end 
addCommandHandler("resetradar",resetRadar)
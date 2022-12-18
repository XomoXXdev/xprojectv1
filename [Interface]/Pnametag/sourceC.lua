fileDelete ("sourceC.lua") 
local sx, sy = guiGetScreenSize();
local func = {};
local cache = {
    players = {};
    textures = {};
    fonts = {};
    afkTimer = {};
};

func.start = function()
    cache.fonts.sans = dxCreateFont("files/roboto.ttf", 16 * sx / 1920);
    cache.fonts.icon = dxCreateFont("files/fontello.ttf", 16 * sx / 1920);
    cache.fonts.fontawsome = dxCreateFont("files/fontawsome.ttf", 16 * sx / 1920);
    cache.fonts.sansB = dxCreateFont("files/OpenSansB.ttf", 22 * sx / 1920);
    cache.fonts.sans_small = dxCreateFont("files/OpenSans-Regular.ttf", 14 * sx / 1920);
    cache.fonts.sans_chat = dxCreateFont("files/OpenSans-Regular.ttf", 17 * sx / 1920);
    cache.textures.afk = dxCreateTexture("files/afk.png");
    cache.textures.console = dxCreateTexture("files/console.png");
    cache.textures.pm = dxCreateTexture("files/pm.png");
    cache.textures.cuffed = dxCreateTexture("files/cuff.png");
    cache.textures.logo = dxCreateTexture("files/logo.png");
       
    if not getElementData(localPlayer,"player:afk:second") then
		setElementData(localPlayer,"player:afk:second",0);
	end
	if not getElementData(localPlayer,"player:afk:string") then
		setElementData(localPlayer,"player:afk:string","");
	end
	if not cache.afkTimer[localPlayer] and getElementData(localPlayer,"player:afk") then
		cache.afkTimer[localPlayer] = setTimer(function()
			setElementData(localPlayer,"player:afk:second",getElementData(localPlayer,"player:afk:second")+1);
		end,1000,0)
	end

    for i, v in ipairs(getElementsByType("player")) do
        if getElementData(v,"player:loggedIn") then
            if not cache.players[v] then
                loadPlayerElements(v);
            end
        end
    end
	
	--setElementData(localPlayer,"player:valid",0)
end
addEventHandler("onClientResourceStart", resourceRoot, func.start)

func.dataChange = function(data)
    if getElementType(source) == "player" and cache.players[source] then
        if data == "player:charname" then
            cache.players[source].name = getElementData(source,data);
        elseif data == "player:id" then
            cache.players[source].id = getElementData(source,data);
        elseif data == "player:admin" then
            cache.players[source].admin = getElementData(source,data);
        elseif data == "player:adminname" then
            cache.players[source].adminnick = getElementData(source,data);
        elseif data == "player:adminduty" then
            cache.players[source].adminduty = getElementData(source,data);
        elseif data == "player:valid" then
            cache.players[source].valid = getElementData(source,data);
        elseif data == "player:afk" then
            cache.players[source].afk = getElementData(source,data);
        elseif data == "player:afk:second" then
			cache.players[source].afksec = getElementData(source,data);
			setElementData(source,"player:afk:string",secondsToTimeDesc(getElementData(source,data)))
		elseif data == "player:afk:string" then
            cache.players[source].afkstring = getElementData(source,data);
        elseif data == "player:typing:pm" then
            cache.players[source].pmTyping = getElementData(source,data);
        elseif data == "player:typing:console" then
            cache.players[source].consoleTyping = getElementData(source,data);
        elseif data == "player:cuffed" then
            cache.players[source].cuffed = getElementData(source,data);
        elseif data == "player:badge" then
            cache.players[source].badge = getElementData(source,data);
        end
    end
end
addEventHandler("onClientElementDataChange", root, func.dataChange);

func.unload = function()
    if cache.players[source] then
        cache.players[source] = nil;
    end
end
addEventHandler("onClientElementStreamOut", root, func.unload);
addEventHandler("onClientElementDestroy", root, func.unload);
addEventHandler("onClientPlayerQuit", root, func.unload);

func.loadElements = function()
    if getElementType(source) == "player" and not cache.players[source] then
        loadPlayerElements(source);
    end
end
addEventHandler("onClientElementStreamIn", root, func.loadElements);
local isOutLine = 1

local lAlpha = 0
local fasz = 1
local options = {}
options.scaleMultiplier = (sx+1920)/(1920*2)
options.scale = 0.9
options.scale1 = 10
options.scalemin = 0.17
options.descscale = 0.64
options.descscalemin = 0.1
options.distance = 35
options.aimdistance = options.distance-options.distance*0.15
options.descdistance = 17
options.alpha = 255
options.alphamin = 0
options.alphadistance = 5
options.alphadiff = options.distance - options.alphadistance
options.disabled = false
local optionsRB = {}
optionsRB.scaleMultiplier = (sx+1920)/(1920*2)
optionsRB.scale = 1
optionsRB.scalemin = 0.17
optionsRB.distance = 20
optionsRB.alpha = 255
optionsRB.alphamin = 0
optionsRB.alphadistance = 5
optionsRB.alphadiff = optionsRB.distance - optionsRB.alphadistance
local show = true
local showMyName = false

function togMyNametag()
    if showMyName then
	    showMyName = false
		outputChatBox("#8163bf[xProject]:#ffffff Saját neved eltűntetve.",255,255,255,true)
	else
	    showMyName = true
		outputChatBox("#8163bf[xProject]:#ffffff Saját neved megjelenítve.",255,255,255,true)
	end
end
addCommandHandler("togmyname",togMyNametag)

function togNametag()
    if show then
	    show = false
		outputChatBox("#8163bf[xProject]:#ffffff Nevek eltűntetve.",255,255,255,true)
	else
	    show = true
		outputChatBox("#8163bf[xProject]:#ffffff Nevek megjelenítve.",255,255,255,true)
	end
end
addCommandHandler("tognames",togNametag)

function draw()
    local cx, cy, cz = getElementPosition(getCamera());
    if not isPlayerDead(localPlayer) then 
	if show then
    for i, v in pairs(cache.players) do
	if not showMyName then
        if i ~= localPlayer then
            local px, py, pz = getPedBonePosition(i, 5);
            local dis = getDistanceBetweenPoints3D(cx, cy, cz, px, py, pz);
            if dis < 30 then
			if not getElementData(i,"invisible") then
                if isLineOfSightClear(cx, cy, cz, px, py, pz, true, false, false, true, true, true, false) then
                    local px, py = getScreenFromWorldPosition(px, py, pz + 0.3);
                    if px and py then
                        local size, imgSize, o = interpolateBetween(1, 96, 0, 0.5, 24, -10, dis / 30, "Linear");
                        local alpha = interpolateBetween(255, 0, 0, 0, 0, 0, dis / 40, "InQuad");
                        py = math.floor(py + o);
                        px = math.floor(px);
						
						local nameColor = "#FFFFFF";
						local idColor = "#FFFFFF";
                        local prefixColor = "#FFFFFF" 
                        
						if v.isBlood or getElementData(i,"player:injured") then
							local r, g, b = interpolateBetween(244, 67, 54, 244, 160, 160, getTickCount() / 2000, "CosineCurve");
                            nameColor = string.format("#%.2X%.2X%.2X", r, g, b);
                        elseif isPlayerDead(i) then 
                            local r, g, b = interpolateBetween(255,255,255, 10,10,10, getTickCount() / 5000, "CosineCurve");
                            nameColor = string.format("#%.2X%.2X%.2X", r, g, b);
						end
						
                        local text = "";
                        local subtext = "";
                        local afktext = "";
                        local alevel = getElementData(i,"player:admin")
                        local aslevel = getElementData(i,"player:helper")
                        v.name = utf8.gsub(v.name,"_"," ")

						if alevel == 1 or alevel == 2 then 
                          prefixColor = "#8163bf"
                        elseif alevel == 3 then 
                          prefixColor = "#8163bf"
                        elseif alevel == 4 then 
                          prefixColor = "#8163bf"
			            elseif alevel == 5 then 
                          prefixColor = "#8163bf"
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

                        if v.adminduty then
                            text = nameColor .. v.adminnick .. " " .. idColor ..prefixColor.. "("..exports["Padmin"]:getAdminTitle(v.admin)..") #ffffff(" .. v.id .. ")";
                        else
						    if aslevel >= 1 then
							if aslevel == 2 then
							    astext = "Adminsegéd"
								ascolor = "#8163bf"
							elseif aslevel == 1 then
							    astext = "Idg.Adminsegéd"
								ascolor = "#f68000"
							end
						    if getElementData(i,"player:valid") == 1 then
                                if not getElementData(i,"player:injured") then 
                                    text = nameColor .. v.name .. " "..ascolor.."("..astext..") " .. idColor .. "(" .. v.id .. ")#A23737 ";
                                else 
                                    text = nameColor .. v.name .. " "..ascolor.."("..astext..") " .. idColor .. "(" .. v.id .. ")#A23737 ";
                                end
							elseif getElementData(i,"player:valid") == 2 then
                                if not getElementData(i,"player:injured") then 
                                    text = nameColor .. v.name .. " "..ascolor.."("..astext..") " .. idColor .. "(" .. v.id .. ")#8163bf ";
                                else 
                                    text = nameColor .. v.name .. " "..ascolor.."("..astext..") " .. idColor .. "(" .. v.id .. ")#8163bf ";
                                end
							elseif getElementData(i,"player:valid") == 3 then
                                if not getElementData(i,"player:injured") then 
                                    text = nameColor .. v.name .. " "..ascolor.."("..astext..") " .. idColor .. "(" .. v.id .. ")#19AB3F ";
                                else 
                                    text = nameColor .. v.name .. " "..ascolor.."("..astext..") " .. idColor .. "(" .. v.id .. ")#19AB3F ";
                                end
                            else
                                if not getElementData(i,"player:injured") then 
                                    text = nameColor .. v.name .. " "..ascolor.."("..astext..") " .. idColor .. "(" .. v.id .. ")";
                                else 
                                    text = nameColor .. v.name .. " "..ascolor.."("..astext..") " .. idColor .. "(" .. v.id .. ")";
								end
                            end
                            else
						    if getElementData(i,"player:valid") == 1 then
                                if not getElementData(i,"player:injured") then 
                                    text = nameColor .. v.name .. " " .. idColor .. "(" .. v.id .. ")#A23737 ";
                                else 
                                    text = nameColor .. v.name .. " " .. idColor .. "(" .. v.id .. ")#A23737 ";
                                end
							elseif getElementData(i,"player:valid") == 2 then
                                if not getElementData(i,"player:injured") then 
                                    text = nameColor .. v.name .. " " .. idColor .. "(" .. v.id .. ")#8163bf ";
                                else 
                                    text = nameColor .. v.name .. " " .. idColor .. "(" .. v.id .. ")#8163bf ";
                                end
							elseif getElementData(i,"player:valid") == 3 then
                                if not getElementData(i,"player:injured") then 
                                    text = nameColor .. v.name .. " " .. idColor .. "(" .. v.id .. ")#19AB3F ";
                                else 
                                    text = nameColor .. v.name .. " " .. idColor .. "(" .. v.id .. ")#19AB3F ";
                                end
                            else
                                if not getElementData(i,"player:injured") then 
                                    text = nameColor .. v.name .. " " .. idColor .. "(" .. v.id .. ")";
                                else 
                                    text = nameColor .. v.name .. " " .. idColor .. "(" .. v.id .. ")";
								end
                            end
                            end							
                        end

                        if v.badge then
                            local badgedata = v.badge;
                            subtext = "#8163bf["..badgedata[2]:gsub("_", " ").."] "..badgedata[1];
                        end

                        local lineCount = #split(text, "\n");
                        local lineHeight = dxGetFontHeight(size, cache.fonts.sans);
                        local lineHeight2 = dxGetFontHeight(size, cache.fonts.sansB);
						
                        local width = math.floor(dxGetTextWidth(text, size, cache.fonts.sans) / 2);

                        if not getElementData(i,"player:injured") and not isPlayerDead(i) then 
                            dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), px - width + 1, 0, px + width + 1, py + 1, tocolor(0, 0, 0, 230 * alpha / 255), size, cache.fonts.icon, "center", "bottom");
                            dxDrawText(text, px - width, 0, px + width, py, tocolor(255, 255, 255, alpha), size, cache.fonts.icon, "center", "bottom", false, false, false, true);
                        elseif getElementData(i,"player:injured") then 
                            dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), px - width + 25 + 1, 0, px + width + 1, py + 1, tocolor(0, 0, 0, 230 * alpha / 255), size, cache.fonts.icon, "center", "bottom");
                            dxDrawText(text, px - width + 25, 0, px + width, py, tocolor(255, 255, 255, alpha), size, cache.fonts.icon, "center", "bottom", false, false, false, true);

                            dxDrawText(nameColor.."", px - dxGetTextWidth(text, size, cache.fonts.sans)/2 + 50 - 1, 0 + 1, px + width, py, tocolor(0, 0, 0, alpha), size, cache.fonts.fontawsome, "left", "bottom", false, false, false, true);
                            dxDrawText(nameColor.."", px - dxGetTextWidth(text, size, cache.fonts.sans)/2 + 50 - 1,  0 + 1, px + width, py, tocolor(255, 255, 255, alpha), size, cache.fonts.fontawsome, "left", "bottom", false, false, false, true);

                        elseif isPlayerDead(i) then 
                            dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), px - width + 25 + 1, 0, px + width + 1, py + 1, tocolor(0, 0, 0, 230 * alpha / 255), size, cache.fonts.sans, "center", "bottom");
                            dxDrawText(text, px - width + 25, 0, px + width, py, tocolor(255, 255, 255, alpha), size, cache.fonts.sans, "center", "bottom", false, false, false, true);

                            dxDrawText(nameColor.."", px - dxGetTextWidth(text, size, cache.fonts.sans)/2 + 50 - 1, 0 + 1, px + width, py, tocolor(0, 0, 0, alpha), size, cache.fonts.fontawsome, "left", "bottom", false, false, false, true);
                            dxDrawText(nameColor.."", px - dxGetTextWidth(text, size, cache.fonts.sans)/2 + 50 - 1,  0 + 1, px + width, py, tocolor(255, 255, 255, alpha), size, cache.fonts.fontawsome, "left", "bottom", false, false, false, true);

                        end 
						
						if subtext ~= "" then
							local subwidth = math.floor(dxGetTextWidth(subtext, size, cache.fonts.sans_small) / 2);
							dxDrawText(subtext:gsub("#%x%x%x%x%x%x", ""), px - subwidth + 1, py + 1, px + subwidth + 1, 0, tocolor(0, 0, 0, 230 * alpha / 255), size, cache.fonts.sans_small, "center", "top");
                            dxDrawText(subtext, px - subwidth, py, px + subwidth, 0, tocolor(255, 255, 255, alpha), size, cache.fonts.sans_small, "center", "top", false, false, false, true);

                        end
						
						local dist = getDistanceBetweenPoints3D(cx, cy, cz, px, py, pz);
						local maxDist = options.distance
						local dist = dist-(maxDist/3)
						local opdist = maxDist-(maxDist/3)
    					if dist < 0 then
							dist = 0
						end
						local progress2 = dist/opdist
						local asssalpha = interpolateBetween (
							options.alpha,0,0,
							options.alphamin,0,0,
							progress2,"Linear"
						)						
                        local heightPlus = 0;
                        if fasz == 1 then
						    lAlpha = lAlpha + 1
						end
					--	if v.adminduty then
                    --        local imgSize_x, imgSize_y = interpolateBetween(96, 37, 0, 42, 16, 0, dis / 30, "Linear");
                    --        heightPlus = imgSize_y + lineCount * lineHeight;
                    --        dxDrawImage(px - imgSize_x / 2, py - heightPlus, imgSize_x, imgSize_y, cache.textures.logo, 0, 0, 0, tocolor(255, 255, 255, 255 * alpha / 255));
                        if v.afk then
                            local afkwidth = math.floor(dxGetTextWidth(v.afkstring, size, cache.fonts.sansB) / 2);
							local afkHeight = lineHeight2*1.7;
                            dxDrawText(v.afkstring, px - afkwidth, py-afkHeight, px + afkwidth, -afkHeight, tocolor(30,30,30,210 * alpha / 255), size, cache.fonts.sansB, "center", "top", false, false, false, true);

                            local imgSize_x, imgSize_y = interpolateBetween(102, 102, 0, 48, 48, 0, dis / 30, "Linear");
                            heightPlus = imgSize_y + lineCount * lineHeight;
                            dxDrawImage(px - imgSize_x / 2, py - heightPlus, imgSize_x, imgSize_y, cache.textures.afk, 0, 0, 0, tocolor(30,30,30,210 * alpha / 255));
                        elseif v.pmTyping then
                            local imgSize_x, imgSize_y = interpolateBetween(102, 102, 0, 48, 48, 0, dis / 30, "Linear");
                            heightPlus = imgSize_y + lineCount * lineHeight;
                            dxDrawImage(px - imgSize_x / 2, py - heightPlus, imgSize_x, imgSize_y, cache.textures.pm, 0, 0, 0, tocolor(30,30,30,210 * alpha / 255));
                        elseif v.consoleTyping then
                            local imgSize_x, imgSize_y = interpolateBetween(102, 102, 0, 48, 48, 0, dis / 30, "Linear");
                            heightPlus = imgSize_y + lineCount * lineHeight;
                            dxDrawImage(px - imgSize_x / 2, py - heightPlus, imgSize_x, imgSize_y, cache.textures.console, 0, 0, 0, tocolor(30,30,30,210 * alpha / 255));
						elseif aslevel >= 1 or v.adminduty then
                            local imgSize_x, imgSize_y = interpolateBetween(102, 102, 0, 48, 48, 0, dis / 30, "Linear");
                            heightPlus = imgSize_y + lineCount * lineHeight;
                            --dxDrawImage(px - imgSize_x / 2, py - heightPlus-10, imgSize_x-10, imgSize_y-10, cache.textures.logo, 0, 0, 0, tocolor(246,137,52,asssalpha+lAlpha));
                        elseif v.cuffed then
                            local imgSize_x, imgSize_y = interpolateBetween(102, 102, 0, 48, 48, 0, dis / 30, "Linear");
                            heightPlus = imgSize_y + lineCount * lineHeight;
                            dxDrawImage(px - imgSize_x / 2, py - heightPlus, imgSize_x, imgSize_y, cache.textures.cuffed, 0, 0, 0, tocolor(30,30,30,210 * alpha / 255));
                        end
                        
                        if heightPlus == 0 then
                            heightPlus = lineHeight;
                        end
                        
                        heightPlus = heightPlus + 10;
                        
                        local chat = v.chat;
                        
                        if #chat > 0 then
                            local chatHeight = dxGetFontHeight(size, cache.fonts.sans_chat);
                            local marginSideX = 20;
                            local marginSideY = 4;
                            local offsetX = marginSideX / 2 + 2;

                            for i, c in ipairs(chat) do
                                local prog = (getTickCount() - c[1]) / 1000;
                                local chat_alpha = alpha;
                                if prog < 1 then
                                    if prog > 0 then
                                        chat_alpha = interpolateBetween(alpha, 0, 0, 0, 0, 0, prog, "Linear");
                                    end
                                    local chatWidth = math.floor(dxGetTextWidth(c[2], size, cache.fonts.sans_chat) / 2);
                                    dxDrawRectangle(px - chatWidth - marginSideX / 2, py - heightPlus - marginSideY / 2 - chatHeight, chatWidth * 2 + marginSideX, chatHeight + marginSideY, tocolor(0, 0, 0, 80 * chat_alpha / 255));
                                    dxDrawText(c[2]:gsub("#%x%x%x%x%x%x", ""), px - chatWidth + 1, 0, px + chatWidth + 1, py - heightPlus + 1, tocolor(0, 0, 0, 230 * chat_alpha / 255), size, cache.fonts.sans_chat, "center", "bottom");
                                    dxDrawText(c[2], px - chatWidth, 0, px + chatWidth, py - heightPlus, tocolor(255, 255, 255, chat_alpha), size, cache.fonts.sans_chat, "center", "bottom", false, false, false, true);

                                    heightPlus = heightPlus + chatHeight + offsetX;
                                end
                            end
                        end
                    end
                end
			end
            end
        end
	else
            local px, py, pz = getPedBonePosition(i, 5);
            local dis = getDistanceBetweenPoints3D(cx, cy, cz, px, py, pz);
            if dis < 30 then
			if not getElementData(i,"invisible") then
                if isLineOfSightClear(cx, cy, cz, px, py, pz, true, false, false, true, true, true, false) then
                    local px, py = getScreenFromWorldPosition(px, py, pz + 0.3);
                    if px and py then
                        local size, imgSize, o = interpolateBetween(1, 96, 0, 0.5, 24, -10, dis / 30, "Linear");
                        local alpha = interpolateBetween(255, 0, 0, 0, 0, 0, dis / 40, "InQuad");
                        py = math.floor(py + o);
                        px = math.floor(px);
						
						local nameColor = "#FFFFFF";
						local idColor = "#FFFFFF";
                        local prefixColor = "#FFFFFF" 
                        
						if v.isBlood or getElementData(i,"player:injured") then
							local r, g, b = interpolateBetween(244, 67, 54, 244, 160, 160, getTickCount() / 2000, "CosineCurve");
                            nameColor = string.format("#%.2X%.2X%.2X", r, g, b);
                        elseif isPlayerDead(i) then 
                            local r, g, b = interpolateBetween(255,255,255, 10,10,10, getTickCount() / 5000, "CosineCurve");
                            nameColor = string.format("#%.2X%.2X%.2X", r, g, b);
						end
						
                        local text = "";
                        local subtext = "";
                        local afktext = "";
                        local alevel = getElementData(i,"player:admin")
                        local aslevel = getElementData(i,"player:helper")
                        v.name = utf8.gsub(v.name,"_"," ")

						if alevel == 1 or alevel == 2 then 
                          prefixColor = "#8163bf"
                        elseif alevel == 3 then 
                          prefixColor = "#8163bf"
                        elseif alevel == 4 then 
                          prefixColor = "#8163bf"
			            elseif alevel == 5 then 
                          prefixColor = "#8163bf"
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

                        if v.adminduty then
                            text = nameColor .. v.adminnick .. " " .. idColor ..prefixColor.. "("..exports["Padmin"]:getAdminTitle(v.admin)..") #ffffff(" .. v.id .. ")";
                        else
						    if aslevel >= 1 then
							if aslevel == 2 then
							    astext = "Adminsegéd"
								ascolor = "#8163bf"
							elseif aslevel == 1 then
							    astext = "Idg.Adminsegéd"
								ascolor = "#f68000"
							end
						    if getElementData(i,"player:valid") == 1 then
                                if not getElementData(i,"player:injured") then 
                                    text = nameColor .. v.name .. " "..ascolor.."("..astext..") " .. idColor .. "(" .. v.id .. ")#A23737 ";
                                else 
                                    text = nameColor .. v.name .. " "..ascolor.."("..astext..") " .. idColor .. "(" .. v.id .. ")#A23737 ";
                                end
							elseif getElementData(i,"player:valid") == 2 then
                                if not getElementData(i,"player:injured") then 
                                    text = nameColor .. v.name .. " "..ascolor.."("..astext..") " .. idColor .. "(" .. v.id .. ")#8163bf ";
                                else 
                                    text = nameColor .. v.name .. " "..ascolor.."("..astext..") " .. idColor .. "(" .. v.id .. ")#8163bf ";
                                end
							elseif getElementData(i,"player:valid") == 3 then
                                if not getElementData(i,"player:injured") then 
                                    text = nameColor .. v.name .. " "..ascolor.."("..astext..") " .. idColor .. "(" .. v.id .. ")#19AB3F ";
                                else 
                                    text = nameColor .. v.name .. " "..ascolor.."("..astext..") " .. idColor .. "(" .. v.id .. ")#19AB3F ";
                                end
                            else
                                if not getElementData(i,"player:injured") then 
                                    text = nameColor .. v.name .. " "..ascolor.."("..astext..") " .. idColor .. "(" .. v.id .. ")";
                                else 
                                    text = nameColor .. v.name .. " "..ascolor.."("..astext..") " .. idColor .. "(" .. v.id .. ")";
								end
                            end
                            else
						    if getElementData(i,"player:valid") == 1 then
                                if not getElementData(i,"player:injured") then 
                                    text = nameColor .. v.name .. " " .. idColor .. "(" .. v.id .. ")#A23737 ";
                                else 
                                    text = nameColor .. v.name .. " " .. idColor .. "(" .. v.id .. ")#A23737 ";
                                end
							elseif getElementData(i,"player:valid") == 2 then
                                if not getElementData(i,"player:injured") then 
                                    text = nameColor .. v.name .. " " .. idColor .. "(" .. v.id .. ")#8163bf ";
                                else 
                                    text = nameColor .. v.name .. " " .. idColor .. "(" .. v.id .. ")#8163bf ";
                                end
							elseif getElementData(i,"player:valid") == 3 then
                                if not getElementData(i,"player:injured") then 
                                    text = nameColor .. v.name .. " " .. idColor .. "(" .. v.id .. ")#19AB3F ";
                                else 
                                    text = nameColor .. v.name .. " " .. idColor .. "(" .. v.id .. ")#19AB3F ";
                                end
                            else
                                if not getElementData(i,"player:injured") then 
                                    text = nameColor .. v.name .. " " .. idColor .. "(" .. v.id .. ")";
                                else 
                                    text = nameColor .. v.name .. " " .. idColor .. "(" .. v.id .. ")";
								end
                            end
                            end							
                        end

                        if v.badge then
                            local badgedata = v.badge;
                            subtext = "#8163bf["..badgedata[2]:gsub("_", " ").."] "..badgedata[1];
                        end

                        local lineCount = #split(text, "\n");
                        local lineHeight = dxGetFontHeight(size, cache.fonts.sans);
                        local lineHeight2 = dxGetFontHeight(size, cache.fonts.sansB);
						
                        local width = math.floor(dxGetTextWidth(text, size, cache.fonts.sans) / 2);

                        if not getElementData(i,"player:injured") and not isPlayerDead(i) then 
                            dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), px - width + 1, 0, px + width + 1, py + 1, tocolor(0, 0, 0, 230 * alpha / 255), size, cache.fonts.icon, "center", "bottom");
                            dxDrawText(text, px - width, 0, px + width, py, tocolor(255, 255, 255, alpha), size, cache.fonts.icon, "center", "bottom", false, false, false, true);
                        elseif getElementData(i,"player:injured") then 
                            dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), px - width + 25 + 1, 0, px + width + 1, py + 1, tocolor(0, 0, 0, 230 * alpha / 255), size, cache.fonts.icon, "center", "bottom");
                            dxDrawText(text, px - width + 25, 0, px + width, py, tocolor(255, 255, 255, alpha), size, cache.fonts.icon, "center", "bottom", false, false, false, true);

                            dxDrawText(nameColor.."", px - dxGetTextWidth(text, size, cache.fonts.sans)/2 + 50 - 1, 0 + 1, px + width, py, tocolor(0, 0, 0, alpha), size, cache.fonts.fontawsome, "left", "bottom", false, false, false, true);
                            dxDrawText(nameColor.."", px - dxGetTextWidth(text, size, cache.fonts.sans)/2 + 50 - 1,  0 + 1, px + width, py, tocolor(255, 255, 255, alpha), size, cache.fonts.fontawsome, "left", "bottom", false, false, false, true);

                        elseif isPlayerDead(i) then 
                            dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), px - width + 25 + 1, 0, px + width + 1, py + 1, tocolor(0, 0, 0, 230 * alpha / 255), size, cache.fonts.sans, "center", "bottom");
                            dxDrawText(text, px - width + 25, 0, px + width, py, tocolor(255, 255, 255, alpha), size, cache.fonts.sans, "center", "bottom", false, false, false, true);

                            dxDrawText(nameColor.."", px - dxGetTextWidth(text, size, cache.fonts.sans)/2 + 50 - 1, 0 + 1, px + width, py, tocolor(0, 0, 0, alpha), size, cache.fonts.fontawsome, "left", "bottom", false, false, false, true);
                            dxDrawText(nameColor.."", px - dxGetTextWidth(text, size, cache.fonts.sans)/2 + 50 - 1,  0 + 1, px + width, py, tocolor(255, 255, 255, alpha), size, cache.fonts.fontawsome, "left", "bottom", false, false, false, true);

                        end 
						
						if subtext ~= "" then
							local subwidth = math.floor(dxGetTextWidth(subtext, size, cache.fonts.sans_small) / 2);
							dxDrawText(subtext:gsub("#%x%x%x%x%x%x", ""), px - subwidth + 1, py + 1, px + subwidth + 1, 0, tocolor(0, 0, 0, 230 * alpha / 255), size, cache.fonts.sans_small, "center", "top");
                            dxDrawText(subtext, px - subwidth, py, px + subwidth, 0, tocolor(255, 255, 255, alpha), size, cache.fonts.sans_small, "center", "top", false, false, false, true);

                        end
						
						local dist = getDistanceBetweenPoints3D(cx, cy, cz, px, py, pz);
						local maxDist = options.distance
						local dist = dist-(maxDist/3)
						local opdist = maxDist-(maxDist/3)
    					if dist < 0 then
							dist = 0
						end
						local progress2 = dist/opdist
						local asssalpha = interpolateBetween (
							options.alpha,0,0,
							options.alphamin,0,0,
							progress2,"Linear"
						)						
                        local heightPlus = 0;
                        if fasz == 1 then
						    lAlpha = lAlpha + 1
						end
					--	if v.adminduty then
                    --        local imgSize_x, imgSize_y = interpolateBetween(96, 37, 0, 42, 16, 0, dis / 30, "Linear");
                    --        heightPlus = imgSize_y + lineCount * lineHeight;
                    --        dxDrawImage(px - imgSize_x / 2, py - heightPlus, imgSize_x, imgSize_y, cache.textures.logo, 0, 0, 0, tocolor(255, 255, 255, 255 * alpha / 255));
                        if v.afk then
                            local afkwidth = math.floor(dxGetTextWidth(v.afkstring, size, cache.fonts.sansB) / 2);
							local afkHeight = lineHeight2*1.7;
                            dxDrawText(v.afkstring, px - afkwidth, py-afkHeight, px + afkwidth, -afkHeight, tocolor(30,30,30,210 * alpha / 255), size, cache.fonts.sansB, "center", "top", false, false, false, true);

                            local imgSize_x, imgSize_y = interpolateBetween(102, 102, 0, 48, 48, 0, dis / 30, "Linear");
                            heightPlus = imgSize_y + lineCount * lineHeight;
                            dxDrawImage(px - imgSize_x / 2, py - heightPlus, imgSize_x, imgSize_y, cache.textures.afk, 0, 0, 0, tocolor(30,30,30,210 * alpha / 255));
                        elseif v.pmTyping then
                            local imgSize_x, imgSize_y = interpolateBetween(102, 102, 0, 48, 48, 0, dis / 30, "Linear");
                            heightPlus = imgSize_y + lineCount * lineHeight;
                            dxDrawImage(px - imgSize_x / 2, py - heightPlus, imgSize_x, imgSize_y, cache.textures.pm, 0, 0, 0, tocolor(30,30,30,210 * alpha / 255));
                        elseif v.consoleTyping then
                            local imgSize_x, imgSize_y = interpolateBetween(102, 102, 0, 48, 48, 0, dis / 30, "Linear");
                            heightPlus = imgSize_y + lineCount * lineHeight;
                            dxDrawImage(px - imgSize_x / 2, py - heightPlus, imgSize_x, imgSize_y, cache.textures.console, 0, 0, 0, tocolor(30,30,30,210 * alpha / 255));
						elseif aslevel >= 1 or v.adminduty then
                            local imgSize_x, imgSize_y = interpolateBetween(102, 102, 0, 48, 48, 0, dis / 30, "Linear");
                            heightPlus = imgSize_y + lineCount * lineHeight;
                            --dxDrawImage(px - imgSize_x / 2, py - heightPlus-10, imgSize_x-10, imgSize_y-10, cache.textures.logo, 0, 0, 0, tocolor(246,137,52,asssalpha+lAlpha));
                        elseif v.cuffed then
                            local imgSize_x, imgSize_y = interpolateBetween(102, 102, 0, 48, 48, 0, dis / 30, "Linear");
                            heightPlus = imgSize_y + lineCount * lineHeight;
                            dxDrawImage(px - imgSize_x / 2, py - heightPlus, imgSize_x, imgSize_y, cache.textures.cuffed, 0, 0, 0, tocolor(30,30,30,210 * alpha / 255));
                        end
                        
                        if heightPlus == 0 then
                            heightPlus = lineHeight;
                        end
                        
                        heightPlus = heightPlus + 10;
                        
                        local chat = v.chat;
                        
                        if #chat > 0 then
                            local chatHeight = dxGetFontHeight(size, cache.fonts.sans_chat);
                            local marginSideX = 20;
                            local marginSideY = 4;
                            local offsetX = marginSideX / 2 + 2;

                            for i, c in ipairs(chat) do
                                local prog = (getTickCount() - c[1]) / 1000;
                                local chat_alpha = alpha;
                                if prog < 1 then
                                    if prog > 0 then
                                        chat_alpha = interpolateBetween(alpha, 0, 0, 0, 0, 0, prog, "Linear");
                                    end
                                    local chatWidth = math.floor(dxGetTextWidth(c[2], size, cache.fonts.sans_chat) / 2);
                                    dxDrawRectangle(px - chatWidth - marginSideX / 2, py - heightPlus - marginSideY / 2 - chatHeight, chatWidth * 2 + marginSideX, chatHeight + marginSideY, tocolor(0, 0, 0, 80 * chat_alpha / 255));
                                    dxDrawText(c[2]:gsub("#%x%x%x%x%x%x", ""), px - chatWidth + 1, 0, px + chatWidth + 1, py - heightPlus + 1, tocolor(0, 0, 0, 230 * chat_alpha / 255), size, cache.fonts.sans_chat, "center", "bottom");
                                    dxDrawText(c[2], px - chatWidth, 0, px + chatWidth, py - heightPlus, tocolor(255, 255, 255, chat_alpha), size, cache.fonts.sans_chat, "center", "bottom", false, false, false, true);

                                    heightPlus = heightPlus + chatHeight + offsetX;
                                end
                            end
                        end
                    end
                end
			end
        end
	end
    end
    end
	end
end
addEventHandler("onClientRender", root, draw);

function loadPlayerElements(playerElement)
    cache.players[playerElement] = {
        name = getElementData(playerElement,"player:charname"):gsub("_", " ");
        id = getElementData(playerElement,"player:id");
        admin = getElementData(playerElement,"player:admin");
        adminnick = getElementData(playerElement,"player:adminname");
        adminduty = getElementData(playerElement,"player:adminduty");
        isBlood = false;--getElementData(playerElement,"player:charname") == "David_M_Clarkson";
        afk = getElementData(playerElement,"player:afk") or false;
        afksec = getElementData(playerElement,"player:afk:second") or 0;
        afkstring = getElementData(playerElement,"player:afk:string") or "";
        pmTyping = getElementData(playerElement,"player:typing:pm");
        consoleTyping = getElementData(playerElement,"player:typing:console");
        cuffed = getElementData(playerElement,"player:cuffed");
        chat = {
     --       {getTickCount() + 2000, "Legyen minden szép!"};
       --     {getTickCount() + 4000, "Anyááád!"};
         --   {getTickCount() + 6000, "Minden is legyen szép!"};
        };
        badge = getElementData(playerElement,"player:badge");
    };
    setPlayerNametagShowing (playerElement,false);
end

--afk
local lastClick = getTickCount()

setTimer(function()
	local cTick = getTickCount ()
	if cTick-lastClick >= 600000 then
		if not getElementData(getLocalPlayer(),"player:afk") then
			local hp = getElementHealth (getLocalPlayer())
            if hp > 0 then
				setElementData (getLocalPlayer(),"player:afk",true)
			end
		end
	end
end,50,0)

func.onRestore = function()
	lastClick = getTickCount ()
	setElementData (getLocalPlayer(),"player:afk",false)
end
addEventHandler( "onClientRestore", getLocalPlayer(), func.onRestore)

func.onMinize = function()
	setElementData (getLocalPlayer(),"player:afk",true)
end
addEventHandler( "onClientMinimize", getRootElement(), func.onMinize)

func.cursorMove = function(x,y)
	lastClick = getTickCount ()
	if getElementData(getLocalPlayer(),"player:afk") then
		setElementData (getLocalPlayer(),"player:afk",false)
	end
end
addEventHandler( "onClientCursorMove", getRootElement(), func.cursorMove)

func.onKey = function()
	lastClick = getTickCount ()
	if getElementData(getLocalPlayer(),"player:afk") then
		setElementData (getLocalPlayer(),"player:afk",false)
	end
end
addEventHandler("onClientKey", getRootElement(), func.onKey)

func.afkDataChange = function(dataName,oldValue,newValue)
	if dataName == "player:afk" then
		if newValue then
			if not cache.afkTimer[getLocalPlayer()] then
				cache.afkTimer[getLocalPlayer()] = setTimer(function()
					setElementData(localPlayer,"player:afk:second",getElementData(localPlayer,"player:afk:second")+1);
				end,1000,0)
			end
		else
			if isTimer(cache.afkTimer[getLocalPlayer()]) then
				killTimer(cache.afkTimer[getLocalPlayer()]);
				cache.afkTimer[getLocalPlayer()] = nil;
				setElementData(getLocalPlayer(),"player:afk:second",0);
			end
		end
	end
end
addEventHandler("onClientElementDataChange",getLocalPlayer(),func.afkDataChange)

setTimer(function()
	if isConsoleActive() then
		setElementData(getLocalPlayer(), "player:typing:console", true)	
	elseif not isConsoleActive() then
		setElementData(getLocalPlayer(), "player:typing:console", false)
	end
	
	if isChatBoxInputActive() then
		setElementData(localPlayer, "player:typing:pm", true)
	elseif not isChatBoxInputActive() then
		setElementData(localPlayer, "player:typing:pm", false)
	end
end,100,0)


function NPCNametag()
      
    if getElementData(localPlayer,"player:loggedIn") and not isPlayerDead(localPlayer) then 
       local cx,cy,cz = getElementPosition(getCamera());
   
       for k,peds in ipairs(getElementsByType("ped")) do 
       if isElementOnScreen(peds) then 
          
         local px,py,pz = getPedBonePosition(peds,5);
         local dis = getDistanceBetweenPoints3D(cx,cy,cz,px,py,pz);

         if dis < 30 then 

            if isLineOfSightClear(cx,cy,cz,px,py,pz,true,false,false,true,true,true,false) then 
             local px,py = getScreenFromWorldPosition(px,py,pz + 0.3);
             if px and py then 
                local size, imgSize,o = interpolateBetween(1,96,0,0.5,24,-10,dis/30,"Linear");
                local alpha = interpolateBetween(255,0,0,0,0,0,dis/40,"InQuad");
                py = math.floor(py + o);
                px = math.floor(px);
               if not getElementData(peds,"nohaveNametag") then
                local name = getElementData(peds,"ped:name") or "Nincs Megadva"
                local type = getElementData(peds,"ped:type") or "NPC"

                name = utf8.gsub(name,"_"," ")
                local width = math.floor(dxGetTextWidth(name.." ["..type.."]", size, cache.fonts.sans) / 2);

                dxDrawText(name.." ["..type.."]", px - width + 2, 0, px + width, py, tocolor(0, 0, 0, alpha), size, cache.fonts.sans, "center", "bottom", false, false, false, true);
                dxDrawText(name.." #8163bf["..type.."]", px - width, 0, px + width, py, tocolor(255, 255, 255, alpha), size, cache.fonts.sans, "center", "bottom", false, false, false, true);

               end

             end
            end

         end 
   
       end 
       end
    end 
end 
addEventHandler("onClientRender",root,NPCNametag)

function secondsToTimeDesc(seconds)
    if seconds then
		local results = {}
		local sec = ( seconds %60 )
		local min = math.floor ( ( seconds % 3600 ) /60 )
		local hou = math.floor ( ( seconds % 86400 ) /3600 )
		local day = math.floor ( seconds /86400 )

		
		if day > 0 and day < 10 then table.insert( results, day .. ( day == 1 and " day" or " days" ) ) 
		elseif day > 0  then table.insert( results, day .. ( day == 1 and "" or "" ) ) end
			
		if hou >= 0 and hou < 10 then table.insert( results, "0"..hou .. ( hou == 1 and "" or "" ) ) 
		elseif hou > 0  then table.insert( results, hou .. ( hou == 1 and "" or "" ) ) end
		
		if min >= 0 and min < 10 then table.insert( results, "0"..min .. ( min == 1 and "" or "" ) ) 
		elseif min > 0  then table.insert( results, min .. ( hou == 1 and "" or "" ) ) end
		
		if sec >= 0 and sec < 10 then table.insert( results, "0"..sec .. ( sec == 1 and "" or "" ) ) 
		elseif sec > 0  then table.insert( results, sec .. ( sec == 1 and "" or "" ) ) end
		
		return string.reverse ( table.concat ( results, ":" ):reverse():gsub(":", ":", 1 ) )
	end
end

start = getTickCount()

function drawShowitem()

    local now = getTickCount()
    local endTime = start + 2000
    local elapsedTime = now - start
    local duration = endTime - start
    local progress = elapsedTime / duration
    local Px,Py,Pz = getElementPosition(localPlayer)
    local y,alpha,alpha2 = 100,255,180

    for k,element in pairs(getElementsByType("player")) do 
    --if element ~= localPlayer then
    if getElementData(element,"showitem") then 

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
        
        local data = getElementData(element,"showitem:data")
        

            local x,y = textX - 58 ,textY - y + 50
            local args = exports["inventory"]:getItemTooltip(data.id,data.item,tostring(data.value),data.count,data.state,data.weaponserial)
            local width = 0;
     
            for i, v in ipairs(args) do
                local thisWidth = dxGetTextWidth( v, 0.8, cache.fonts.sans, true) + 20;
                if thisWidth > width then
                    width = thisWidth;
                end
            end
     
            text = table.concat(args, "\n");
     
            local height = dxGetFontHeight(0.8, cache.fonts.sans) * #args + 10;
            x = math.max( 10, math.min( x, sx - width - 10 ) )
            y = math.max( 10, math.min( y, sy - height - 10 ) )

            dxDrawRectangle( x, y, width, height, tocolor( 0, 0, 0, alpha2 ), true )
            dxDrawText( text, x, y, x + width, y + height, tocolor( 255, 255, 255, alpha ), 0.8, cache.fonts.sans, "center", "center", false, false, true, true )
            dxDrawRectangle(x + width/2 - 25 +10,y - 50,sx*0.025,sy*0.04,tocolor(40, 40, 40,alpha))
            --dxDrawText(data.count,x + 80 - 1 ,y - 51 + 1,_,_,tocolor(0,0,0,alpha), 0.8, cache.fonts.sans, "left", "top", false, false, true, true )
            --dxDrawText(data.count,x + 80 ,y - 51,_,_,tocolor(255,255,255,alpha), 0.8, cache.fonts.sans, "left", "top", false, false, true, true )
            dxDrawImage(x + width/2 - 23 +10 ,y - 48.5,sx*0.023,sy*0.037,exports["inventory"]:getItemImage(data.item),0,0,0,tocolor(255,255,255,alpha))


    end

   -- end
    end
    end 

end 
addEventHandler("onClientRender",root,drawShowitem)
setElementData(localPlayer,"showitem",false)
setElementData(localPlayer,"showitem:data",0)
function syncItem(element,data)
    if not getElementData(element,"showitem") then 
    setElementData(element,"showitem",true)
    setElementData(element,"showitem:data",data)

    setTimer(function()
        setElementData(element,"showitem",false)
        setElementData(element,"showitem:data",0)
    end,3000,1)
    else 
    outputChatBox("#8163bf[Inventory]#ffffff Várj néhány másodpercet.",255,255,255,true)
    end
end 
addEvent("syncItem",true)
addEventHandler("syncItem",root,syncItem)

function showItem(element,data)
    triggerServerEvent("sync",localPlayer,element,data)
end 
addEvent("showItem",true)
addEventHandler("showItem",root,showItem)

function dxDrawBorderedText (outline, text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    local outline = (scale or 1) * (1.333333333333334 * (outline or 1))
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left - outline, top - outline, right - outline, bottom - outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left + outline, top - outline, right + outline, bottom - outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left - outline, top + outline, right - outline, bottom + outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left + outline, top + outline, right + outline, bottom + outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left - outline, top, right - outline, bottom, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left + outline, top, right + outline, bottom, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left, top - outline, right, bottom - outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left, top + outline, right, bottom + outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
end
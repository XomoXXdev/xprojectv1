local sx, sy = guiGetScreenSize()
local myX, myY = 1600,900

local page = 1

local size = 0.9 -- NE ÁLLÍTSD ÁT!!!!!!
local phoneW, phoneH = 259/myX*sx*size, 512/myY*sy*size
local activePhone
local phoneShow = false
Pinfobox = exports.Pinfobox
local phones = {}
chat = exports.Pchat
local fonts = {
	["ui-thin-9"] = dxCreateFont("files/betutipusok/sf_ui_display/medium.ttf", 15),
	["ui-medium-9"] = dxCreateFont("files/betutipusok/sf_ui_display/medium.ttf", 12),
	["ui-heavy-9"] = dxCreateFont("files/betutipusok/sf_ui_display/medium.ttf", 15),
	["ui-thin-11"] = dxCreateFont("files/betutipusok/sf_ui_display/medium.ttf", 15),
	["ui-medium-11"] = dxCreateFont("files/betutipusok/sf_ui_display/medium.ttf", 15),
	["ui-thin-15"] = dxCreateFont("files/betutipusok/sf_ui_display/medium.ttf", 15),
	["ui-bold-15"] = dxCreateFont("files/betutipusok/sf_ui_display/medium.ttf", 15),
	["ui-medium-15"] = dxCreateFont("files/betutipusok/sf_ui_display/medium.ttf", 15),
	["ui-medium-30"] = dxCreateFont("files/betutipusok/sf_ui_display/medium.ttf", 15),
	["ui-heavy-15"] = dxCreateFont("files/betutipusok/sf_ui_display/medium.ttf", 15),
	["ui-medium-20"] = dxCreateFont("files/betutipusok/sf_ui_display/medium.ttf", 15),
	["ui-thin-30"] = dxCreateFont("files/betutipusok/sf_ui_display/medium.ttf", 15),
	["ui-heavy-50"] = dxCreateFont("files/betutipusok/sf_ui_display/medium.ttf", 15),
	["fontawesome2"] = dxCreateFont("files/betutipusok/sf_ui_display/medium.ttf", 15),
	["vekonyfont"] = dxCreateFont("files/betutipusok/freeAdelaide.ttf", 30),
}

local phoneMessages = {}
local openedMessagePage = false


local optionBG = 1

local callingState = 1
local calledNumber = 0
local talkingPlayer = false
local numberText = ""

local sound = false

local startCallTime = {0, 0, 0}
local callTimer = false

local contactState, contactPointer = 1, 0
local smsState, smsPointer = 1, 0

local editboxs = {
	["addContact-name"] = "",
	["addContact-phone"] = "",
	["addNews-text"] = "",
	["phone-calling"] = "",
	["sms"] = "",
	["sms-phoneNumber"] = "",
	["sms-message"] = "",
}
local activeEditbox = false

local callingTimer = false

local showingRingstone = false

local callStopTimer = false

local callLogsPointer = 0

local talkingTexts = {}

local isCalled911 = false

local usedGPSButton = false

-- Actions 
local actionNow = {false, 0, getTickCount(), false}

local tick = getTickCount()

local volumeScrollDatas = {false, getTickCount(), "close", 15}

local gridPositions = {}
local oneGridSize = 45

-- UI Editor 
local movedApp = false
local sizeingPanel = false

local widgets = {
	[11] = {
		[2] = dxCreateRenderTarget(88, 88, true),
		[3] = dxCreateRenderTarget(187, 88, true),
	}, 

	[16] = {
		[2] = dxCreateRenderTarget(88, 88, true),
	}, 
}

local textPointerFlash = 0

local animationTick = getTickCount()

local availableTaxis = 0
local lastTaxiInteraction = 0

function drawPhone()
	 phoneX, phoneY = getElementData(localPlayer,"player:interface:phonex"),getElementData(localPlayer,"player:interface:phoney")
	if 1==1 then 
			local time = getRealTime()
			local hour, minute = getRealTime()
			if time.minute >= 0 and time.minute < 10 then
				time.minute = "0"..time.minute
			end
			if time.second >= 0 and time.second < 10 then
				time.second = "0"..time.second
			end
			if time.monthday >=0 and time.monthday < 10 then
				time.monthday = "0"..time.monthday
			end
		if phones[activePhone] then 
			--phoneX, phoneY = 600,300

			if not phones[activePhone]["phoneSet"] then 
				dxDrawImage(phoneX, phoneY, phoneW, phoneH, "files/backgrounds/"..phones[activePhone]["bg"]..".png")

				if page == 1 then 
					--exports.blur:createBlur(phoneX+sx*0.01, phoneY+sy*0.015, phoneW-(sx*0.02), phoneH-(sy*0.015*2), 200)
					dxDrawText(time.hour..":"..time.minute, phoneX, phoneY+sy*0.08, phoneX+phoneW, phoneY+sy*0.08+sy*0.08, tocolor(255,255,255,255), 1/myX*sx, fonts["ui-heavy-50"], "center", "center")

					dxDrawText(""..getMonthName(time.month).." "..time.monthday.."., "..getWeekName(time.weekday).."", phoneX, phoneY+sy*0.08, phoneX+phoneW, phoneY+sy*0.08+sy*0.08, tocolor(255,255,255,255), 1/myX*sx, fonts["ui-medium-9"], "center", "bottom")
            
				dxDrawImage(phoneX+50, phoneY+310, phoneW-100, phoneH-330, "files/fingerprint.png")
				--Pinfobox:addNotification("Ezen a telefonon nem a te újlenyomatod szerepel.", "error")
				elseif page == 2 then 
					gridPositions = {}

					local startX = phoneX+sx*0.015
					local startY = phoneY+sy*0.05
					local idInLine = 1
					local idInColumn = 1

					for i = 1, 28 do 
						gridPositions[i] = {startX, startY, oneGridSize/myX*sx, oneGridSize/myX*sx, idInLine, idInColumn}
						startX = startX + oneGridSize/myX*sx
						idInLine = idInLine + 1

						if i % 4 == 0 then 
							startX = phoneX+sx*0.015
							startY = startY + oneGridSize/myY*sy
							idInLine = 1
							idInColumn = idInColumn + 1
						end
					end

					for k, v in pairs(gridPositions) do
						--[[if isInSlot(v[1], v[2], v[3], v[4]) then 
							dxDrawRectangle(v[1], v[2], v[3], v[4], tocolor(255, 0, 0, 255))
						else
							dxDrawRectangle(v[1], v[2], v[3], v[4], tocolor(255, 0, 0, 100))
						end]]

						local rot = 0 

						if movedApp then 
							rot = interpolateBetween(-5, 0, 0, 5, 0, 0, (tick-getTickCount())/400, "SineCurve")
						end
						
						if phones[activePhone]["apps"][k] then 
							if type(phones[activePhone]["apps"][k]) == "table" then 
								if extraAppSizes[phones[activePhone]["apps"][k][1]] then 
									local appSizeX, appSizeY = unpack(extraAppSizes[phones[activePhone]["apps"][k][1]][phones[activePhone]["apps"][k][2]])

										dxSetRenderTarget(widgets[phones[activePhone]["apps"][k][1]][phones[activePhone]["apps"][k][2]], true)   
											if phones[activePhone]["apps"][k][1] == 11 then 
											    phones[activePhone]["apps"][k] = false
												local weather = 1

												if phones[activePhone]["apps"][k][2] == 2 then 
													dxDrawText("Los Santos", 10, 10, 50, 20, tocolor(255, 255, 255, 255), 0.9/myX*sx, fonts["ui-heavy-9"], "left", "center")
													dxDrawText(math.floor(weather[3]).."°", 10, 22, 50, 50, tocolor(255, 255, 255, 255), 0.65/myX*sx, fonts["ui-medium-30"], "left", "top")

													dxDrawImage(10, 55, 25, 25, "files/weatherIcons/"..(weatherIcons[weather[1]] or "sun_1")..".png")
												elseif phones[activePhone]["apps"][k][2] == 3 then 
													dxDrawText("Los Santos", 10, 10, 50, 20, tocolor(255, 255, 255, 255), 0.95/myX*sx, fonts["ui-heavy-9"], "left", "center")
													dxDrawText(math.floor(weather[3]).."°", 10, 22, 50, 50, tocolor(255, 255, 255, 255), 0.65/myX*sx, fonts["ui-medium-30"], "left", "top")

													dxDrawText((math.floor(weather[2]*100)/100).."km/h", 10, 70, 80, 80, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["ui-heavy-9"], "left", "center")

													dxDrawImage(110, 15, 60, 60, "files/weatherIcons/"..(weatherIcons[weather[1]] or "sun_1")..".png")
												end 
											elseif phones[activePhone]["apps"][k][1] == 12 then 
											    phones[activePhone]["apps"][k] = false
											elseif phones[activePhone]["apps"][k][1] == 16 then 
											    phones[activePhone]["apps"][k] = false
												if phones[activePhone]["apps"][k][2] == 2 then 
													dxDrawText("Szabad taxik:", 10, 10, 50, 55, tocolor(255, 255, 255, 255), 0.85/myX*sx, fonts["ui-heavy-9"], "left", "bottom")
													dxDrawText(availableTaxis, 10, 52, 50, 50, tocolor(255, 255, 255, 255), 0.65/myX*sx, fonts["ui-medium-30"], "left", "top")
												end
											end                  
										dxSetRenderTarget()  

									if (widgets[phones[activePhone]["apps"][k][1]][phones[activePhone]["apps"][k][2]]) then 
										if movedApp then 
											dxDrawImage(v[1]+((6/appSizeX)/myX*sx*appSizeX), v[2]+(6/appSizeY)/myY*sy+4/myY*sy, (v[3]-(12/appSizeX)/myX*sx)*appSizeX,( v[4]-(12/appSizeY)/myY*sy)*appSizeY, "files/apps/"..phones[activePhone]["apps"][k][1].."_"..phones[activePhone]["apps"][k][2]..".png", rot)
											dxDrawImage(v[1]+((6/appSizeX)/myX*sx*appSizeX), v[2]+(6/appSizeY)/myY*sy+4/myY*sy, (v[3]-(12/appSizeX)/myX*sx)*appSizeX,( v[4]-(12/appSizeY)/myY*sy)*appSizeY, widgets[phones[activePhone]["apps"][k][1]][phones[activePhone]["apps"][k][2]], rot)
										else
											dxDrawImage(v[1]+((6/appSizeX)/myX*sx*appSizeX), v[2]+(6/appSizeY)/myY*sy+4/myY*sy, (v[3]-(12/appSizeX)/myX*sx)*appSizeX,( v[4]-(12/appSizeY)/myY*sy)*appSizeY, "files/apps/"..phones[activePhone]["apps"][k][1].."_"..phones[activePhone]["apps"][k][2]..".png", rot)

											if phones[activePhone]["apps"][k][1] == 11 then 
												local weather = core:getSyncedWeather()
	
												if phones[activePhone]["apps"][k][2] == 2 then 
													dxDrawText("Los Santos", v[1]+((6/appSizeX)/myX*sx*appSizeX) + sx*0.005, v[2]+(6/appSizeY)/myY*sy+4/myY*sy + sy*0.015, v[1]+((6/appSizeX)/myX*sx*appSizeX) + sx*0.005,  v[2]+(6/appSizeY)/myY*sy+4/myY*sy + sy*0.015, tocolor(255, 255, 255, 255), 0.55/myX*sx, fonts["ui-heavy-15"], "left", "center")
													dxDrawText(math.floor(weather[3]).."°", v[1]+((6/appSizeX)/myX*sx*appSizeX) + sx*0.005, v[2]+(6/appSizeY)/myY*sy+4/myY*sy + sy*0.025, v[1]+((6/appSizeX)/myX*sx*appSizeX) + sx*0.005, v[2]+(6/appSizeY)/myY*sy+4/myY*sy + sy*0.025, tocolor(255, 255, 255, 255), 0.65/myX*sx, fonts["ui-medium-30"], "left", "top")
	
													dxDrawImage(v[1]+((6/appSizeX)/myX*sx*appSizeX) + sx*0.005, v[2]+(6/appSizeY)/myY*sy+4/myY*sy + sy*0.06, 20/myX*sx, 20/myX*sx, "files/weatherIcons/"..(weatherIcons[weather[1]] or "sun_1")..".png")
												elseif phones[activePhone]["apps"][k][2] == 3 then 
													dxDrawText("Los Santos", v[1]+((6/appSizeX)/myX*sx*appSizeX) + sx*0.005, v[2]+(6/appSizeY)/myY*sy+4/myY*sy + sy*0.015, v[1]+((6/appSizeX)/myX*sx*appSizeX) + sx*0.005,  v[2]+(6/appSizeY)/myY*sy+4/myY*sy + sy*0.015, tocolor(255, 255, 255, 255), 0.6/myX*sx, fonts["ui-heavy-15"], "left", "center")
													dxDrawText(math.floor(weather[3]).."°", v[1]+((6/appSizeX)/myX*sx*appSizeX) + sx*0.005, v[2]+(6/appSizeY)/myY*sy+4/myY*sy + sy*0.025, v[1]+((6/appSizeX)/myX*sx*appSizeX) + sx*0.005, v[2]+(6/appSizeY)/myY*sy+4/myY*sy + sy*0.025, tocolor(255, 255, 255, 255), 0.65/myX*sx, fonts["ui-medium-30"], "left", "top")
	
													dxDrawText((math.floor(weather[2]*100)/100).."km/h", v[1]+((6/appSizeX)/myX*sx*appSizeX) + sx*0.005, v[2]+(6/appSizeY)/myY*sy+4/myY*sy + sy*0.07, v[1]+((6/appSizeX)/myX*sx*appSizeX) + sx*0.005, v[2]+(6/appSizeY)/myY*sy+4/myY*sy + sy*0.07, tocolor(255, 255, 255, 255), 0.5/myX*sx, fonts["ui-heavy-15"], "left", "center")
	
													dxDrawImage(v[1]+((6/appSizeX)/myX*sx*appSizeX) + sx*0.06, v[2]+(6/appSizeY)/myY*sy+4/myY*sy + sy*0.01, 60/myX*sx, 60/myY*sy, "files/weatherIcons/"..(weatherIcons[weather[1]] or "sun_1")..".png")
												end 
											elseif phones[activePhone]["apps"][k][1] == 16 then 
												if phones[activePhone]["apps"][k][2] == 2 then 
													dxDrawText("Szabad taxik:", v[1]+((6/appSizeX)/myX*sx*appSizeX) + sx*0.005, v[2]+(6/appSizeY)/myY*sy+4/myY*sy + sy*0.035, v[1]+((6/appSizeX)/myX*sx*appSizeX) + sx*0.005,  v[2]+(6/appSizeY)/myY*sy+4/myY*sy + sy*0.055, tocolor(255, 255, 255, 255), 0.45/myX*sx, fonts["ui-heavy-15"], "left", "bottom")
													dxDrawText(availableTaxis, v[1]+((6/appSizeX)/myX*sx*appSizeX) + sx*0.005, v[2]+(6/appSizeY)/myY*sy+4/myY*sy + sy*0.05, v[1]+((6/appSizeX)/myX*sx*appSizeX) + sx*0.005, v[2]+(6/appSizeY)/myY*sy+4/myY*sy + sy*0.025, tocolor(255, 255, 255, 255), 0.65/myX*sx, fonts["ui-medium-30"], "left", "top")
												end
											end            
										end
									else
										dxDrawImage(v[1]+((6/appSizeX)/myX*sx*appSizeX), v[2]+(6/appSizeY)/myY*sy, (v[3]-(12/appSizeX)/myX*sx)*appSizeX,( v[4]-(12/appSizeY)/myY*sy)*appSizeY, "files/apps/"..phones[activePhone]["apps"][k][1].."_"..phones[activePhone]["apps"][k][2]..".png", rot)
									end

									if appSizeY > 1 then 
										dxDrawText(appNames[phones[activePhone]["apps"][k][1]] or "", v[1], v[2]+(40/myY*sy*appSizeY)+6/myY*sy, v[1]+v[3]*appSizeX, v[2]+(40/myY*sy*appSizeY)+sy*0.011+6/myY*sy, tocolor(220, 220, 220, 255), 0.65/myX*sx, fonts["ui-heavy-9"], "center", "bottom")	
									else
										dxDrawText(appNames[phones[activePhone]["apps"][k][1]] or "", v[1], v[2]+40/myY*sy, v[1]+v[3], v[2]+40/myY*sy+sy*0.011, tocolor(220, 220, 220, 255), 0.65/myX*sx, fonts["ui-heavy-9"], "center", "bottom")	
									end
								end
							else
								if phones[activePhone]["apps"][k] == 12 then
								    phones[activePhone]["apps"][k] = false
									local dbid = getElementData(localPlayer,"player:dbid")
									if exports.pdash:isPlayerInGroup(dbid,7) then 
										dxDrawImage(v[1]+6/myX*sx, v[2]+6/myY*sy, v[3]-12/myX*sx, v[4]-12/myY*sy, "files/apps/"..phones[activePhone]["apps"][k]..".png", rot, 0, 0, tocolor(255, 255, 255, 150))
									else
										dxDrawImage(v[1]+6/myX*sx, v[2]+6/myY*sy, v[3]-12/myX*sx, v[4]-12/myY*sy, "files/apps/"..phones[activePhone]["apps"][k]..".png", rot)
									end
								else
									dxDrawImage(v[1]+6/myX*sx, v[2]+6/myY*sy, v[3]-12/myX*sx, v[4]-12/myY*sy, "files/apps/"..phones[activePhone]["apps"][k]..".png", rot)
								end
-- Itt a hírdetés ha mégis kéne a felirat
								--dxDrawText(appNames[phones[activePhone]["apps"][k]] or "", v[1]-2, v[2]+40/myY*sy, v[1]+v[3], v[2]+40/myY*sy+sy*0.011+2, tocolor(220, 220, 220, 255), 0.60/myX*sx, fonts["ui-heavy-9"], "center", "bottom")
							end						
						end
					end

					dxDrawText(time.hour..":"..time.minute, phoneX+sx*0.025, phoneY+sy*0.021, phoneX+sx*0.015+sx*0.017, phoneY+sy*0.021+sy*0.015, tocolor(255, 255, 255, 255), 0.75/myX*sx, fonts["ui-medium-9"], "center", "center")

					dxDrawImage(phoneX, phoneY-sy*0.0015, phoneW, phoneH, "files/bg105.png")
					dxDrawImage(phoneX, phoneY-sy*0.0015, phoneW, phoneH, "files/apps/default_icons.png")

					if movedApp then 
						local cX, cY = getCursorPosition()

						if type(movedApp[2]) == "table" then 
							local appSizeX, appSizeY = unpack(extraAppSizes[movedApp[2][1]][movedApp[2][2]])
								
							if widgets[movedApp[2][1]][movedApp[2][2]] then 
								dxDrawImage(cX*sx, cY*sy, (oneGridSize/myX*sx-(12/appSizeX))*appSizeX,  (oneGridSize/myY*sy-(12/appSizeY))*appSizeY, "files/apps/"..movedApp[2][1].."_"..movedApp[2][2]..".png", 0)
								dxDrawImage(cX*sx, cY*sy, (oneGridSize/myX*sx-(12/appSizeX))*appSizeX,  (oneGridSize/myY*sy-(12/appSizeY))*appSizeY, widgets[movedApp[2][1]][movedApp[2][2]], 0)
							else
								dxDrawImage(cX*sx, cY*sy, (oneGridSize/myX*sx-(12/appSizeX))*appSizeX,  (oneGridSize/myY*sy-(12/appSizeY))*appSizeY, "files/apps/"..movedApp[2][1].."_"..movedApp[2][2]..".png", 0)
							end
						else
							dxDrawImage(cX*sx, cY*sy, 32/myX*sx, 32/myY*sy, "files/apps/"..movedApp[2]..".png")
						end
					end

					if sizeingPanel then 
						--sizeingPanel = {k, phones[activePhone]["apps"][k][1], cX-phoneX, cY-phoneY, getTickCount(), "open"}

						local colors = {tocolor(220, 220, 220, 255*sizeingPanel[7]), tocolor(210, 210, 210, 255*sizeingPanel[7])}

						if phones[activePhone]["theme"] == "dark" then 
							colors = {tocolor(30, 30, 30, 255*sizeingPanel[7]), tocolor(40, 40, 40, 255*sizeingPanel[7])}
						end

						if sizeingPanel[6] == "open" then 
							sizeingPanel[7] = interpolateBetween(sizeingPanel[7], 0, 0, 1, 0, 0, (getTickCount()-sizeingPanel[5])/300, "Linear")

							if sizeingPanel[7] == 1 then 
								sizeingPanel[8] = false 
							end
						else
							sizeingPanel[7] = interpolateBetween(sizeingPanel[7], 0, 0, 0, 0, 0, (getTickCount()-sizeingPanel[5])/300, "Linear")

							if sizeingPanel[7] == 0 then 
								sizeingPanel[8] = false 
							end
						end

						local panelWidth = sx*0.05
						local panelISMinus = false
						if phoneX+sizeingPanel[3]+sx*0.05 > phoneX+(phoneW-sx*0.01) then 
							panelWidth = 0-sx*0.05
							panelISMinus = true
						end

						dxDrawImage(phoneX+sizeingPanel[3], phoneY+sizeingPanel[4], panelWidth, sy*0.025*#extraAppTypes[sizeingPanel[2]], "files/roundedRectangle.png" , 0, 0, 0, colors[1])

						local startY = phoneY+sizeingPanel[4]
						for k, v in ipairs(extraAppTypes[sizeingPanel[2]]) do 
							if panelISMinus then 
								if isInSlot(phoneX+sizeingPanel[3]-75/myX*sx, startY+1/myY*sy, 70/myX*sx, 20/myY*sy) then 
									dxDrawImage(phoneX+sizeingPanel[3]-5/myX*sx, startY+5/myY*sy, -14/myX*sx, 14/myY*sy, "files/"..v[2]..".png", 0, 0, 0, tocolor(129, 99, 191, 255*sizeingPanel[7]))
									dxDrawText(v[1], phoneX+sizeingPanel[3]-78/myX*sx, startY+1/myY*sy, phoneX+sizeingPanel[3]-78/myX*sx+55/myX*sx, startY+1/myY*sy+23/myY*sy, tocolor(129, 99, 191, 255*sizeingPanel[7]), 0.8/myX*sx, fonts["ui-medium-9"], "right", "center")
								else
									dxDrawImage(phoneX+sizeingPanel[3]-5/myX*sx, startY+5/myY*sy, -14/myX*sx, 14/myY*sy, "files/"..v[2]..".png", 0, 0, 0, tocolor(39, 123, 209, 200*sizeingPanel[7]))
									dxDrawText(v[1], phoneX+sizeingPanel[3]-78/myX*sx, startY+1/myY*sy, phoneX+sizeingPanel[3]-78/myX*sx+55/myX*sx, startY+1/myY*sy+23/myY*sy, tocolor(39, 123, 209, 200*sizeingPanel[7]), 0.8/myX*sx, fonts["ui-medium-9"], "right", "center")
								end

								if k < #extraAppTypes[sizeingPanel[2]] then 
									dxDrawLine(phoneX+sizeingPanel[3]-5/myX*sx, startY+22/myY*sy, phoneX+sizeingPanel[3]-5/myX*sx-70/myX*sx, startY+22/myY*sy, colors[2])
								end
							else
								if isInSlot(phoneX+sizeingPanel[3]+5/myX*sx, startY+1/myY*sy, 70/myX*sx, 20/myY*sy) then 
									dxDrawImage(phoneX+sizeingPanel[3]+5/myX*sx, startY+5/myY*sy, 14/myX*sx, 14/myY*sy, "files/"..v[2]..".png", 0, 0, 0, tocolor(129, 99, 191, 255*sizeingPanel[7]))
									dxDrawText(v[1], phoneX+sizeingPanel[3]+24/myX*sx, startY+1/myY*sy, phoneX+sizeingPanel[3]+24/myX*sx+55/myX*sx, startY+1/myY*sy+23/myY*sy, tocolor(129, 99, 191, 255*sizeingPanel[7]), 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
								else
									dxDrawImage(phoneX+sizeingPanel[3]+5/myX*sx, startY+5/myY*sy, 14/myX*sx, 14/myY*sy, "files/"..v[2]..".png", 0, 0, 0, tocolor(39, 123, 209, 200*sizeingPanel[7]))
									dxDrawText(v[1], phoneX+sizeingPanel[3]+24/myX*sx, startY+1/myY*sy, phoneX+sizeingPanel[3]+24/myX*sx+55/myX*sx, startY+1/myY*sy+23/myY*sy, tocolor(39, 123, 209, 200*sizeingPanel[7]), 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
								end

								if k < #extraAppTypes[sizeingPanel[2]] then 
									dxDrawLine(phoneX+sizeingPanel[3]+5/myX*sx, startY+22/myY*sy, phoneX+sizeingPanel[3]+5/myX*sx+70/myX*sx, startY+22/myY*sy, colors[2])
								end
							end

							startY = startY + 22/myY*sy
						end
					end
				elseif page == 3 then
					if contactState == 1 then 
						dxDrawRectangle(phoneX+phoneW/15, phoneY+sy*0.015, phoneW-(phoneW/15*2), phoneH-sy*0.03, uiColors[phones[activePhone]["theme"]]["bg"])
						--dxDrawText("Kontaktok", phoneX+sx*0.015, phoneY+sy*0.055, phoneX+sx*0.015+phoneW/2, phoneY+sy*0.055+sy*0.028, uiColors[phones[activePhone]["theme"]]["text-title"], 0.7/myX*sx, fonts["ui-heavy-15"], "left", "center")

						roundedRectangle(phoneX+sx*0.015, phoneY+sy*0.415, phoneW-sx*0.03, sy*0.03, tocolor(129, 99, 191, 255))
						--dxDrawText("Egy hírdetés feladásának ára 150$!", phoneX+sx*0.015, phoneY+sy*0.415, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.415+sy*0.03, tocolor(129, 99, 191, 255), 0.8/myX*sx, fonts["ui-medium-9"], "center", "center")
                        if isInSlot(phoneX+sx*0.015, phoneY+sy*0.800, phoneW/2, sy*0.02) then 
						  dxDrawText("Hozzáadás", phoneX+sx*0.04, phoneY+sy*0.800, phoneX+sx*-0.007+phoneW-sx*0.04, phoneY+sy*0.038+sy*0.02, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["ui-medium-9"], "right", "center")
					    else
						  dxDrawText("Hozzáadás", phoneX+sx*0.04, phoneY+sy*0.800, phoneX+sx*-0.007+phoneW-sx*0.04, phoneY+sy*0.038+sy*0.02, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["ui-medium-9"], "right", "center")
					    end
                       
                       roundedRectangle(phoneX+sx*0.015, phoneY+sy*0.450, phoneW-sx*0.03, sy*0.03, tocolor(255, 96, 96, 255))
					   if isInSlot(phoneX+sx*0.06, phoneY+sy*0.870, phoneW/2, sy*0.02) then 
						dxDrawText("Kilépés", phoneX+sx*0.06, phoneY+sy*0.870, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
					   else
						dxDrawText("Kilépés", phoneX+sx*0.06, phoneY+sy*0.870, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
					   end
                         
                         dxDrawImage(phoneX+ phoneW/2 - 40/myX*sx, phoneY+sy*0.0360, 80/myX*sx, 80/myY*sy, "files/logo.png", 0, 0, 0, tocolor(255, 255, 255, 255))
						--roundedRectangle(phoneX+sx*0.0145, phoneY+sy*0.085, phoneW-sx*0.03, phoneH/12, uiColors[phones[activePhone]["theme"]]["bar"], uiColors[phones[activePhone]["theme"]]["bar"])
						--dxDrawText("Saját", phoneX+sx*0.04, phoneY+sy*0.09, phoneX+sx*0.04+sx*0.1, phoneY+sy*0.09+sy*0.02, uiColors[phones[activePhone]["theme"]]["text"], 0.8/myX*sx, fonts["ui-medium-11"], "left", "center")
						--dxDrawText(activePhone, phoneX+sx*0.04, phoneY+sy*0.105, phoneX+sx*0.04+sx*0.1, phoneY+sy*0.105+sy*0.02, uiColors[phones[activePhone]["theme"]]["text-light"], 0.65/myX*sx, fonts["ui-thin-11"], "left", "center")
						--dxDrawImage(phoneX+sx*0.0155+4/myX*sx, phoneY+sy*0.085+3/myY*sy, 30/myX*sx, 30/myY*sy, "files/avatars/small/1.png")

						--dxDrawLine(phoneX+sx*0.0060, phoneY+sy*0.136, phoneX+sx*0.0180+phoneW-sx*0.03, phoneY+sy*0.136, uiColors[phones[activePhone]["theme"]]["bar"], 2)
						--dxDrawLine(phoneX+sx*0.0060, phoneY+sy*0.190, phoneX+sx*0.0180+phoneW-sx*0.03, phoneY+sy*0.190, uiColors[phones[activePhone]["theme"]]["bar"], 2)
						--dxDrawLine(phoneX+sx*0.0060, phoneY+sy*0.235, phoneX+sx*0.0180+phoneW-sx*0.03, phoneY+sy*0.235, uiColors[phones[activePhone]["theme"]]["bar"], 2)

						local startY = phoneY+sy*0.145

						for i = 1, 5 do 
							local v = phones[activePhone]["contacts"][i+contactPointer] or false 

							if v then 
								--roundedRectangle(phoneX+sx*0.0145, startY, phoneW-sx*0.03, phoneH/12, uiColors[phones[activePhone]["theme"]]["bar"], uiColors[phones[activePhone]["theme"]]["bar"])
                                 

								if isInSlot(phoneX+sx*0.0145, startY, phoneW-sx*0.03, phoneH/12) then 
									if getKeyState("mouse2") or getKeyState("mouse1") then 
										if not actionNow[1] then 
											actionNow[1] = i+contactPointer
											actionNow[3] = getTickCount()

											if getKeyState("mouse1") then 
												actionNow[4] = "call"
											else
												if not v[4] then
													actionNow[4] = "del"
												end
											end
										else
											if 1 == 1 then 
												actionNow[2] = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount()-actionNow[3])/1000, "InOutQuad")
											else 
												actionNow = {false, 0, getTickCount(), false}
											end
										end
									else 

										actionNow = {false, 2, getTickCount(), false}
									end

									if actionNow[1] == i+contactPointer then 
										if actionNow[4] == "del" then 
										--	roundedRectangle(phoneX+sx*0.0145, startY, (phoneW-sx*0.03)*actionNow[2], phoneH/12, tocolor(219, 57, 57, 255*actionNow[2]), tocolor(219, 57, 57, 255*actionNow[2]))
											--dxDrawText("Törlés", phoneX+sx*0.0145, startY, phoneX+sx*0.0145+(phoneW-sx*0.035), startY+phoneH/12, tocolor(219, 57, 57, 255), 0.8/myX*sx, fonts["ui-medium-11"], "right", "center")
										elseif actionNow[4] == "call" then 
										--	roundedRectangle(phoneX+sx*0.0145, startY, (phoneW-sx*0.03)*actionNow[2], phoneH/12, tocolor(102, 186, 102, 255*actionNow[2]), tocolor(102, 186, 102, 255*actionNow[2]))
											--dxDrawText("Hívás", phoneX+sx*0.0145, startY, phoneX+sx*0.0145+(phoneW-sx*0.035), startY+phoneH/12, tocolor(102, 186, 102, 255), 0.8/myX*sx, fonts["ui-medium-11"], "right", "center")
										elseif actionNow[4] == "sms" then 
										--	roundedRectangle(phoneX+sx*0.0145, startY, (phoneW-sx*0.03)*actionNow[2], phoneH/12, tocolor(102, 186, 102, 255*actionNow[2]), tocolor(102, 186, 102, 255*actionNow[2]))
											--dxDrawText("Hívás", phoneX+sx*0.0145, startY, phoneX+sx*0.0145+(phoneW-sx*0.035), startY+phoneH/12, tocolor(102, 186, 102, 255), 0.8/myX*sx, fonts["ui-medium-11"], "right", "center")
										end

										if actionNow[2] >= 1 then 
											if actionNow[4] == "del" then 
												table.remove(phones[activePhone]["contacts"], i+contactPointer)
											elseif actionNow[4] == "call" then 
												startCalling(phones[activePhone]["contacts"][i+contactPointer][2])
		                                        exports.Pchat:takeMessage("me","felhív valakit.")
												--chat:sendLocalMeAction("felhív valakit.")
											end
											actionNow = {false, 0, getTickCount(), false}
										end
									end
								end

								--dxDrawImage(phoneX+sx*0.0155+4/myX*sx, startY+4/myY*sy, 30/myX*sx, 30/myY*sy, "files/avatars/small/"..v[3]..".png")
								dxDrawImage(phoneX+sx*0.0950+4/myX*sx, startY+4/myY*sy, 20/myX*sx, 20/myY*sy, "files/hivas_icon2.png", 0, 0, 0, tocolor(129, 99, 191, 255))
								dxDrawImage(phoneX+sx*0.1140+4/myX*sx, startY+4/myY*sy, 20/myX*sx, 20/myY*sy, "files/delete.png", 0, 0, 0, tocolor(255, 96, 96, 255))
								--dxDrawText(v[1]:sub(1, 1, ""), phoneX+sx*0.0155+4/myX*sx, startY+4/myY*sy, phoneX+sx*0.0155+4/myX*sx+31/myX*sx, startY+4/myY*sy+30/myY*sy, tocolor(129, 99, 191, 255), 0.8/myX*sx, fonts["ui-medium-15"], "center", "center")
								dxDrawText(v[1], phoneX+sx*0.04, startY+sy*0.005, phoneX+sx*0.10+sx*0.1, startY+sy*0.001+sy*0.010, uiColors[phones[activePhone]["theme"]]["text"], 0.8/myX*sx, fonts["ui-thin-11"], "left", "center")
								dxDrawText(v[2], phoneX+sx*0.074, startY+sy*0.02, phoneX+sx*0.04+sx*0.1, startY+sy*0.02+sy*0.02, uiColors[phones[activePhone]["theme"]]["text"], 0.65/myX*sx, fonts["ui-thin-11"], "left", "center")
								dxDrawText("Telefonszám:", phoneX+sx*0.02, startY+sy*0.02, phoneX+sx*0.04+sx*0.1, startY+sy*0.02+sy*0.02, uiColors[phones[activePhone]["theme"]]["text"], 0.65/myX*sx, fonts["ui-thin-11"], "left", "center")
								dxDrawText("Név:", phoneX+sx*0.02, startY+sy*0.005, phoneX+sx*0.10+sx*0.1, startY+sy*0.001+sy*0.010, uiColors[phones[activePhone]["theme"]]["text"], 0.65/myX*sx, fonts["ui-thin-11"], "left", "center")
							end

							startY = startY + phoneH/12 + sy*0.005
						end

						local lineHeight = 7/#phones[activePhone]["contacts"]

						if #phones[activePhone]["contacts"] < 7 then 
							lineHeight = 1
						end

						--dxDrawRectangle(phoneX+phoneW-sx*0.0133, phoneY+sy*0.145, sx*0.001, phoneH-sy*0.185, tocolor(39, 123, 209, 100))
						--dxDrawRectangle(phoneX+phoneW-sx*0.0133, phoneY+sy*0.145 + ((phoneH-sy*0.185)*(lineHeight*contactPointer/7)), sx*0.001, (phoneH-sy*0.185)*lineHeight, tocolor(39, 123, 209, 200))
					elseif contactState == 2 then 
						dxDrawRectangle(phoneX+phoneW/15, phoneY+sy*0.015, phoneW-(phoneW/15*2), phoneH-sy*0.03, uiColors[phones[activePhone]["theme"]]["bg"])
						--dxDrawText("Kontakt hozzáadása", phoneX+sx*0.015, phoneY+sy*0.055, phoneX+sx*0.015+phoneW/2, phoneY+sy*0.055+sy*0.028, uiColors[phones[activePhone]["theme"]]["text-title"], 0.7/myX*sx, fonts["ui-heavy-15"], "left", "center")
                         roundedRectangle(phoneX+sx*0.015, phoneY+sy*0.22, phoneW-sx*0.03, sy*0.03, tocolor(40, 40, 40, 255))
                         roundedRectangle(phoneX+sx*0.015, phoneY+sy*0.26, phoneW-sx*0.03, sy*0.03, tocolor(40, 40, 40, 255))
                         dxDrawImage(phoneX+ phoneW/2 - 60/myX*sx, phoneY+sy*0.05, 120/myX*sx, 120/myY*sy, "files/logo.png", 0, 0, 0, tocolor(255, 255, 255, 255))
						roundedRectangle(phoneX+sx*0.015, phoneY+sy*0.450, phoneW-sx*0.03, sy*0.03, tocolor(255, 96, 96, 255))
					   if isInSlot(phoneX+sx*0.06, phoneY+sy*0.870, phoneW/2, sy*0.02) then 
						dxDrawText("Kilépés", phoneX+sx*0.06, phoneY+sy*0.870, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
					   else
						dxDrawText("Kilépés", phoneX+sx*0.06, phoneY+sy*0.870, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
					   end 

						--[[if isInSlot(phoneX+sx*0.012, phoneY+sy*0.17, sx*0.105, sy*0.03) then 
							dxDrawText("Avatar beállítása", phoneX+sx*0.015, phoneY+sy*0.17, phoneX+sx*0.015+sx*0.105, phoneY+sy*0.17+sy*0.03, tocolor(129, 99, 191, 255), 0.9/myX*sx, fonts["ui-medium-9"], "center", "center")
						else
							dxDrawText("Avatar beállítása", phoneX+sx*0.015, phoneY+sy*0.17, phoneX+sx*0.015+sx*0.105, phoneY+sy*0.17+sy*0.03, tocolor(39, 123, 209, 220), 0.9/myX*sx, fonts["ui-medium-9"], "center", "center")
						end]]

						--dxDrawRectangle(phoneX+sx*0.017, phoneY+sy*0.4, phoneW-sx*0.035, sy*0.03, tocolor(255, 0, 0))

						--dxDrawImage(phoneX+sx*0.04, phoneY+sy*0.1, 100/myX*sx, 100/myY*sy, "files/circle.png", 0, 0, 0, tocolor(39, 123, 209, 100))
						--dxDrawText("?", phoneX+sx*0.04, phoneY+sy*0.1, phoneX+sx*0.04+100/myX*sx, phoneY+sy*0.1+100/myY*sy, tocolor(129, 99, 191, 255), 0.8/myX*sx, fonts["ui-heavy-50"], "center", "center")
                       
                        roundedRectangle(phoneX+sx*0.015, phoneY+sy*0.415, phoneW-sx*0.03, sy*0.03, tocolor(129, 99, 191, 255))
						if isInSlot(phoneX+sx*0.015, phoneY+sy*0.800, phoneW/2, sy*0.02) then 
						  dxDrawText("Hozzáadás", phoneX+sx*0.04, phoneY+sy*0.800, phoneX+sx*-0.007+phoneW-sx*0.04, phoneY+sy*0.038+sy*0.02, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["ui-medium-9"], "right", "center")
					    else
						  dxDrawText("Hozzáadás", phoneX+sx*0.04, phoneY+sy*0.800, phoneX+sx*-0.007+phoneW-sx*0.04, phoneY+sy*0.038+sy*0.02, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["ui-medium-9"], "right", "center")
					    end


						if activeEditbox == "addContact-name" then 
							if string.len(editboxs["addContact-name"]) > 0 then 
								dxDrawText(editboxs["addContact-name"], phoneX+sx*0.015, phoneY+sy*0.218, phoneX+sx*0.218+sx*0.1, phoneY+sy*0.218+sy*0.03, tocolor(255, 255, 255, 255), 0.9/myX*sx, fonts["ui-thin-11"], "left", "center")
							else
								dxDrawText("Név", phoneX+sx*0.060, phoneY+sy*0.218, phoneX+sx*0.015+sx*0.1, phoneY+sy*0.218+sy*0.03, tocolor(255, 255, 255, 255), 0.9/myX*sx, fonts["ui-thin-11"], "left", "center")
							end
						else
							if string.len(editboxs["addContact-name"]) > 0 then 
								dxDrawText(editboxs["addContact-name"], phoneX+sx*0.015, phoneY+sy*0.218, phoneX+sx*0.015+sx*0.1, phoneY+sy*0.218+sy*0.03, tocolor(255, 255, 255, 255), 0.9/myX*sx, fonts["ui-thin-11"], "left", "center")
							else
								dxDrawText("Név", phoneX+sx*0.060, phoneY+sy*0.218, phoneX+sx*0.015+sx*0.1, phoneY+sy*0.218+sy*0.03, tocolor(255, 255, 255, 255), 0.9/myX*sx, fonts["ui-thin-11"], "left", "center")
							end
						end
						--dxDrawLine(phoneX+sx*0.0145, phoneY+sy*0.25, phoneX+sx*0.0145+phoneW-sx*0.03, phoneY+sy*0.25, uiColors[phones[activePhone]["theme"]]["bar"], 2)

						if activeEditbox == "addContact-phone" then 
							if string.len(editboxs["addContact-phone"]) > 0 then
								dxDrawText(editboxs["addContact-phone"], phoneX+sx*0.015, phoneY+sy*0.26, phoneX+sx*0.015+sx*0.1, phoneY+sy*0.26+sy*0.03, tocolor(255, 255, 255, 255), 0.9/myX*sx, fonts["ui-thin-11"], "left", "center")
							else
								dxDrawText("Telefonszám", phoneX+sx*0.040, phoneY+sy*0.26, phoneX+sx*0.015+sx*0.1, phoneY+sy*0.26+sy*0.03, tocolor(255, 255, 255, 255), 0.9/myX*sx, fonts["ui-thin-11"], "left", "center")
							end
						else
							if string.len(editboxs["addContact-phone"]) > 0 then
								dxDrawText(editboxs["addContact-phone"], phoneX+sx*0.015, phoneY+sy*0.26, phoneX+sx*0.015+sx*0.1, phoneY+sy*0.26+sy*0.03, tocolor(255, 255, 255, 255), 0.9/myX*sx, fonts["ui-thin-11"], "left", "center")
							else
								dxDrawText("Telefonszám", phoneX+sx*0.040, phoneY+sy*0.26, phoneX+sx*0.015+sx*0.1, phoneY+sy*0.26+sy*0.03, tocolor(255, 255, 255, 255), 0.9/myX*sx, fonts["ui-thin-11"], "left", "center")
							end
						end
						--dxDrawLine(phoneX+sx*0.0145, phoneY+sy*0.285, phoneX+sx*0.0145+phoneW-sx*0.03, phoneY+sy*0.285, uiColors[phones[activePhone]["theme"]]["bar"], 2)
					end
				elseif page == 4 then 
					dxDrawRectangle(phoneX+phoneW/13, phoneY+sy*0.01, phoneW-(phoneW/13*2), phoneH-sy*0.02, uiColors[phones[activePhone]["theme"]]["bg"])
					dxDrawText("Beállítások", phoneX+sx*0.015, phoneY+sy*0.055, phoneX+sx*0.015+phoneW/2, phoneY+sy*0.055+sy*0.028, uiColors[phones[activePhone]["theme"]]["text-title"], 0.7/myX*sx, fonts["ui-heavy-15"], "left", "center")
					
					--dxDrawImage(phoneX, phoneY, phoneW, phoneH, "files/options.png")
					if isInSlot(phoneX+sx*0.015, phoneY+sy*0.038, phoneW/2, sy*0.02) then 
						dxDrawText("Vissza", phoneX+sx*0.015, phoneY+sy*0.038, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(129, 99, 191, 255), 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
					else
						dxDrawText("Vissza", phoneX+sx*0.015, phoneY+sy*0.038, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(39, 123, 209, 220), 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
					end

					local startY = phoneY+sy*0.09
					for k, v in ipairs(options) do 
						roundedRectangle(phoneX+sx*0.0145, startY, phoneW-sx*0.03, phoneH/12, uiColors[phones[activePhone]["theme"]]["bar"], uiColors[phones[activePhone]["theme"]]["bar"])
						dxDrawText(v.name, phoneX+sx*0.02, startY+sy*0.02, phoneX+sx*0.04+sx*0.1, startY+sy*0.005+sy*0.02, uiColors[phones[activePhone]["theme"]]["text"], 0.8/myX*sx, fonts["ui-medium-11"], "left", "center")
						--dxDrawText(v.desc, phoneX+sx*0.04, startY+sy*0.02, phoneX+sx*0.04+sx*0.1, startY+sy*0.02+sy*0.02, uiColors[phones[activePhone]["theme"]]["text-light"], 0.65/myX*sx, fonts["ui-thin-11"], "left", "center")
						--dxDrawImage(phoneX+sx*0.0155+4/myX*sx, startY+4/myY*sy, 30/myX*sx, 30/myY*sy, "files/optionIcons/"..v.icon)

						if v.type == "menu" then 
							if isInSlot(phoneX+sx*0.11, startY+4/myY*sy, 30/myX*sx, 30/myY*sy) then
								--dxDrawImage(phoneX+sx*0.11, startY+4/myY*sy, 30/myX*sx, 30/myY*sy, "files/arrow3.png", 0, 0, 0, tocolor(240, 240, 240, 255))
							else
								--dxDrawImage(phoneX+sx*0.11, startY+4/myY*sy, 30/myX*sx, 30/myY*sy, "files/arrow3.png", 0, 0, 0, tocolor(220, 220, 220, 255))
							end
						elseif v.type == "on/off" then 
							local state = false 

							if v.name == "Dark Mode" then 
								if phones[activePhone]["theme"] == "dark" then 
									state = true
								end
							end

							local buttonColor

							if state then 
								buttonColor = tocolor(102, 186, 102, 200)
							else
								buttonColor = tocolor(219, 57, 57, 200)
							end

							if isInSlot(phoneX+sx*0.11, startY+4/myY*sy, 30/myX*sx, 30/myY*sy) then
								if state then 
									buttonColor = tocolor(102, 186, 102, 255)
								else
									buttonColor = tocolor(219, 57, 57, 255)
								end
							end

							if state then 
								dxDrawImage(phoneX+sx*0.11, startY+4/myY*sy, 30/myX*sx, 30/myY*sy, "files/switch.png", 180, 0, 0, buttonColor)
							else
								dxDrawImage(phoneX+sx*0.11, startY+4/myY*sy, 30/myX*sx, 30/myY*sy, "files/switch.png", 0, 0, 0, buttonColor)
							end
						end

						startY = startY + phoneH/12 + sy*0.005
					end
				elseif page == 5 then 
					dxDrawRectangle(phoneX+phoneW/13, phoneY+sy*0.01, phoneW-(phoneW/13*2), phoneH-sy*0.02, uiColors[phones[activePhone]["theme"]]["bg"])
					dxDrawText("Háttérkép beállítása", phoneX+sx*0.015, phoneY+sy*0.055, phoneX+sx*0.015+phoneW/2, phoneY+sy*0.055+sy*0.028, uiColors[phones[activePhone]["theme"]]["text-title"], 0.7/myX*sx, fonts["ui-heavy-15"], "left", "center")

					if isInSlot(phoneX+sx*0.015, phoneY+sy*0.038, phoneW/2, sy*0.02) then 
						dxDrawText("Vissza", phoneX+sx*0.015, phoneY+sy*0.038, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(129, 99, 191, 255), 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
					else
						dxDrawText("Vissza", phoneX+sx*0.015, phoneY+sy*0.038, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(39, 123, 209, 220), 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
					end

					dxDrawImage(phoneX+sx*0.037, phoneY+sy*0.13, phoneW/2, phoneH/2, "files/backgrounds/"..optionBG..".png")
					--dxDrawImage(phoneX+sx*0.037, phoneY+sy*0.13, phoneW/2, phoneH/2, "files/phone.png")
					
					if isInSlot(phoneX+sx*0.013, phoneY+phoneH/2-25/myY*sy, 40/myX*sx, 40/myY*sy) then
						dxDrawImage(phoneX+sx*0.013, phoneY+phoneH/2-25/myY*sy, 40/myX*sx, 40/myY*sy, "files/arrow3.png", 180, 0, 0, tocolor(255, 255, 255, 220))
					else
						dxDrawImage(phoneX+sx*0.013, phoneY+phoneH/2-25/myY*sy, 40/myX*sx, 40/myY*sy, "files/arrow3.png", 180, 0, 0, tocolor(255, 255, 255, 150))
					end

					if isInSlot(phoneX+phoneW-sx*0.037, phoneY+phoneH/2-25/myY*sy, 40/myX*sx, 40/myY*sy) then 
						dxDrawImage(phoneX+phoneW-sx*0.037, phoneY+phoneH/2-25/myY*sy, 40/myX*sx, 40/myY*sy, "files/arrow3.png", 0, 0, 0, tocolor(255, 255, 255, 220))
					else
						dxDrawImage(phoneX+phoneW-sx*0.037, phoneY+phoneH/2-25/myY*sy, 40/myX*sx, 40/myY*sy, "files/arrow3.png", 0, 0, 0, tocolor(255, 255, 255, 150))
					end

					if isInSlot(phoneX+sx*0.005, phoneY+phoneH-sy*0.055, phoneW-sx*0.01, sy*0.03) then 
						dxDrawText("Mentés", phoneX+sx*0.005, phoneY+sy*0.015, phoneX+sx*0.005+phoneW-sx*0.01, phoneY+sy*0.015+phoneH-(sy*0.015*3), tocolor(129, 99, 191, 255), 0.8/myX*sx, fonts["ui-bold-15"], "center", "bottom")
					else
						dxDrawText("Mentés", phoneX+sx*0.005, phoneY+sy*0.015, phoneX+sx*0.005+phoneW-sx*0.01, phoneY+sy*0.015+phoneH-(sy*0.015*3), tocolor(39, 123, 209, 220), 0.8/myX*sx, fonts["ui-bold-15"], "center", "bottom")
					end
				elseif page == 6 then 
					dxDrawRectangle(phoneX+phoneW/13, phoneY+sy*0.01, phoneW-(phoneW/13*2), phoneH-sy*0.02, uiColors[phones[activePhone]["theme"]]["bg"])
					dxDrawText("Csengőhang beállítása", phoneX+sx*0.015, phoneY+sy*0.055, phoneX+sx*0.015+phoneW/2, phoneY+sy*0.055+sy*0.028, uiColors[phones[activePhone]["theme"]]["text-title"], 0.7/myX*sx, fonts["ui-heavy-15"], "left", "center")

					if isInSlot(phoneX+sx*0.015, phoneY+sy*0.038, phoneW/2, sy*0.02) then 
						dxDrawText("Vissza", phoneX+sx*0.015, phoneY+sy*0.038, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(129, 99, 191, 255), 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
					else
						dxDrawText("Vissza", phoneX+sx*0.015, phoneY+sy*0.038, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(39, 123, 209, 220), 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
					end

					local startY = phoneY+sy*0.09
					for i = 1, 12 do 
						if fileExists("files/ringstones/"..i..".mp3") then 
							roundedRectangle(phoneX+sx*0.0145, startY, phoneW-sx*0.03, sy*0.025, uiColors[phones[activePhone]["theme"]]["bar"], uiColors[phones[activePhone]["theme"]]["bar"])

							if isInSlot(phoneX+phoneW-sx*0.03, startY+sy*0.004+1/myY*sy, 15/myX*sx, 15/myY*sy) then 
					--			dxDrawImage(phoneX+phoneW-sx*0.03, startY+sy*0.004+1/myY*sy, 15/myX*sx, 15/myY*sy, "files/speaker_icon.png", 0, 0, 0, tocolor(129, 99, 191, 255))
							else
					--			dxDrawImage(phoneX+phoneW-sx*0.03, startY+sy*0.004+1/myY*sy, 15/myX*sx, 15/myY*sy, "files/speaker_icon.png", 0, 0, 0, tocolor(39, 123, 209, 220))
							end

							if phones[activePhone]["ringstone"] == i then
								dxDrawText(i.." #277bd1(Jelenlegi)", phoneX+sx*0.018, startY, phoneX+sx*0.018+sx*0.1, startY+sy*0.025, uiColors[phones[activePhone]["theme"]]["text"], 0.7/myX*sx, fonts["ui-medium-11"], "left", "center", false, false, false, true)
							else
								dxDrawText(i, phoneX+sx*0.018, startY, phoneX+sx*0.018+sx*0.1, startY+sy*0.025, uiColors[phones[activePhone]["theme"]]["text"], 0.7/myX*sx, fonts["ui-medium-11"], "left", "center", false, false, false, true)
							end

							startY = startY + sy*0.03
						end
					end

					dxDrawLine(phoneX+sx*0.0145, phoneY+phoneH-sy*0.045, phoneX+sx*0.0145+phoneW-sx*0.03, phoneY+phoneH-sy*0.045, uiColors[phones[activePhone]["theme"]]["bar"], 2)
					dxDrawLine(phoneX+sx*0.0145, phoneY+phoneH-sy*0.045, phoneX+sx*0.0145+((phoneW-sx*0.03)*phones[activePhone]["ringstone-volume"]), phoneY+phoneH-sy*0.045, tocolor(39, 123, 209, 150), 2)

					if isInSlot(phoneX+sx*0.0145+((phoneW-sx*0.03)*phones[activePhone]["ringstone-volume"])-volumeScrollDatas[4]/2/myX*sx, phoneY+phoneH-sy*0.045-volumeScrollDatas[4]/2/myY*sy, volumeScrollDatas[4]/myX*sx, volumeScrollDatas[4]/myY*sy) then 
						if not volumeScrollDatas[1] then 
							volumeScrollDatas[1] = true 
							volumeScrollDatas[3] = "open"
							volumeScrollDatas[2] = getTickCount()
						end

						if getKeyState("mouse1") then 
							local cx, cy = getCursorPosition()
							cx = cx*sx 
	
							cx = cx - phoneX+sx*0.0145
							cx = cx - 50/myX*sx	
							
							if cx /  (phoneW-sx*0.03) > 0 then 
								if cx /  (phoneW-sx*0.03) < 1 then 
									phones[activePhone]["ringstone-volume"] = cx /  (phoneW-sx*0.03)

									if isElement(showingRingstone) then 
										setSoundVolume(showingRingstone, 5*phones[activePhone]["ringstone-volume"])
									end
								end
							end
						end
					else
						if volumeScrollDatas[1] then 
							volumeScrollDatas[1] = false
							volumeScrollDatas[3] = "close"
							volumeScrollDatas[2] = getTickCount()
						end
					end

					if volumeScrollDatas[3] == "open" then  
						volumeScrollDatas[4] = interpolateBetween(volumeScrollDatas[4], 0, 0, 17, 0, 0, (getTickCount() - volumeScrollDatas[2])/300, "Linear")
					else
						volumeScrollDatas[4] = interpolateBetween(volumeScrollDatas[4], 0, 0, 15, 0, 0, (getTickCount() - volumeScrollDatas[2])/300, "Linear")
					end
					dxDrawImage(phoneX+sx*0.0145+((phoneW-sx*0.03)*phones[activePhone]["ringstone-volume"])-volumeScrollDatas[4]/2/myX*sx, phoneY+phoneH-sy*0.045-volumeScrollDatas[4]/2/myY*sy, volumeScrollDatas[4]/myX*sx, volumeScrollDatas[4]/myY*sy, "files/circle.png", 0, 0, 0, tocolor(129, 99, 191, 255))
                   

					--dxDrawRectangle(phoneX+sx*0.0145, phoneY+phoneH-sy*0.045, phoneW-sx*0.03, sy*0.02)
					dxDrawText(math.floor(phones[activePhone]["ringstone-volume"]*100).."%", phoneX+sx*0.0145, phoneY+phoneH-sy*0.045, phoneX+sx*0.0145+phoneW-sx*0.03, phoneY+phoneH-sy*0.045+sy*0.03, uiColors[phones[activePhone]["theme"]]["text"], 0.82/myX*sx, fonts["ui-medium-9"], "center", "center")
				elseif page == 7 then -- Hívás
					dxDrawRectangle(phoneX+phoneW/15, phoneY+sy*0.01, phoneW-(phoneW/15*2), phoneH-sy*0.03, uiColors[phones[activePhone]["theme"]]["bg"])
					--dxDrawText("Telefon", phoneX+sx*0.015, phoneY+sy*0.055, phoneX+sx*0.015+phoneW/2, phoneY+sy*0.055+sy*0.028, uiColors[phones[activePhone]["theme"]]["text-title"], 0.7/myX*sx, fonts["ui-heavy-15"], "left", "center")
 
                    roundedRectangle(phoneX+sx*0.015, phoneY+sy*0.415, phoneW-sx*0.03, sy*0.03, tocolor(129, 99, 191, 255)) -- sárga genyó hívás miatt 
					roundedRectangle(phoneX+sx*0.015, phoneY+sy*0.450, phoneW-sx*0.03, sy*0.03, tocolor(255, 96, 96, 255))

					if isInSlot(phoneX+sx*0.06, phoneY+sy*0.870, phoneW/2, sy*0.02) then 
						dxDrawText("Kilépés", phoneX+sx*0.06, phoneY+sy*0.870, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
					else
						dxDrawText("Kilépés", phoneX+sx*0.06, phoneY+sy*0.870, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
					end

					if isInSlot(phoneX+sx*0.0615, phoneY+sy*0.800, phoneW/2, sy*0.02) then 
						dxDrawText("Hívás", phoneX+sx*0.0615, phoneY+sy*0.800, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
					else
						dxDrawText("Hívás", phoneX+sx*0.0615, phoneY+sy*0.800, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
					end


					local startX = phoneX+sx*0.0225
					local startY = phoneY+sy*0.14

					for i = 1, 12 do 
						if isInSlot(startX, startY, 50/myX*sx, 50/myY*sy) then 
							dxDrawImage(startX, startY, 50/myX*sx, 50/myY*sy, "files/circle.png", 0, 0, 0, uiColors[phones[activePhone]["theme"]]["bar"])
						else
							dxDrawImage(startX, startY, 50/myX*sx, 50/myY*sy, "files/circle.png", 0, 0, 0, uiColors[phones[activePhone]["theme"]]["bar-2"])
						end

						if i == 10 then 
							dxDrawImage(startX+13.5/myX*sx, startY+14/myY*sy, 22/myX*sx, 22/myY*sy, "files/backspace.png", 0, 0, 0, uiColors[phones[activePhone]["theme"]]["text"])
						else
							dxDrawText(phoneButtonTexts[i], startX, startY, startX+50/myX*sx, startY+50/myY*sy, uiColors[phones[activePhone]["theme"]]["text"], 0.8/myX*sx, fonts["ui-medium-20"], "center", "center")
						end

						roundedRectangle(phoneX+sx*0.015, phoneY+sy*0.100, phoneW-sx*0.03, sy*0.03, tocolor(40, 40, 40, 255)) -- a szám mögött lévő bg a tárcsázásnál
						dxDrawImage(phoneX+ phoneW/2 - 25/myX*sx, phoneY+sy*0.0360, 50/myX*sx, 50/myY*sy, "files/logo.png", 0, 0, 0, tocolor(255, 255, 255, 50))

						startX = startX + sx*0.035
						if i % 3 == 0 then 
							startX = phoneX+sx*0.0225
							startY = startY + sy*0.065
						end
					end

					if isInSlot(phoneX+phoneW/2-25/myX*sx, phoneY+phoneH-sy*0.095, 50/myX*sx, 50/myY*sy) then 
					--	dxDrawImage(phoneX+phoneW/2-25/myX*sx, phoneY+phoneH-sy*0.095, 50/myX*sx, 50/myY*sy, "files/circle.png", 0, 0, 0, tocolor(122, 217, 93, 200))
					else
					--	dxDrawImage(phoneX+phoneW/2-25/myX*sx, phoneY+phoneH-sy*0.095, 50/myX*sx, 50/myY*sy, "files/circle.png", 0, 0, 0, tocolor(122, 217, 93, 150))
					end
				--	dxDrawImage(phoneX+phoneW/2-25/myX*sx+14/myX*sx, phoneY+phoneH-sy*0.095+14/myY*sy, 22/myX*sx, 22/myY*sy, "files/hivas_icon.png", 0, 0, 0, uiColors[phones[activePhone]["theme"]]["text"])
	
					dxDrawText(numberText, phoneX, phoneY+sy*0.095, phoneX+phoneW, phoneY+sy*0.085+sy*0.05, uiColors[phones[activePhone]["theme"]]["text"], 0.65/myX*sx, fonts["ui-thin-30"], "center", "center")
				elseif page == 8 then -- Hívás folyamatban
			--		exports.blur:createBlur(phoneX+sx*0.01, phoneY+sy*0.015, phoneW-(sx*0.02), phoneH-(sy*0.015*2), 200)
					--dxDrawImage(phoneX, phoneY, phoneW, phoneH, "files/avatars/big/1.png")

					if callingState == 1 then 

						dxDrawImage(phoneX, phoneY, phoneW, phoneH, "files/call-bg.png")
						if isInSlot(phoneX+phoneW/2-25/myX*sx, phoneY+phoneH-sy*0.15, 50/myX*sx, 50/myY*sy) then 
							dxDrawImage(phoneX+phoneW/2-25/myX*sx, phoneY+phoneH-sy*0.15, 50/myX*sx, 50/myY*sy, "files/circle.png", 0, 0, 0, tocolor(227, 48, 48, 200))
						else
							dxDrawImage(phoneX+phoneW/2-25/myX*sx, phoneY+phoneH-sy*0.15, 50/myX*sx, 50/myY*sy, "files/circle.png", 0, 0, 0, tocolor(227, 48, 48, 150))
						end
						dxDrawImage(phoneX+phoneW/2-25/myX*sx+14/myX*sx, phoneY+phoneH-sy*0.15+14/myY*sy, 22/myX*sx, 22/myY*sy, "files/hivas_icon.png", 135, 0, 0, uiColors[phones[activePhone]["theme"]]["text"])

						dxDrawText(getContactName(calledNumber), phoneX, phoneY+sy*0.15, phoneX+phoneW, phoneY+sy*0.15+sy*0.05, tocolor(20,20,20,255), 0.8/myX*sx, fonts["ui-medium-20"], "center", "center")
						dxDrawText("Hívás...", phoneX, phoneY+sy*0.12, phoneX+phoneW, phoneY+sy*0.12+sy*0.05, tocolor(20,20,20,255), 0.8/myX*sx, fonts["ui-thin-15"], "center", "center")
					elseif callingState == 2 then 
						dxDrawImage(phoneX, phoneY, phoneW, phoneH, "files/call-bg.png")
						dxDrawText(getContactName(calledNumber), phoneX, phoneY+sy*0.15, phoneX+phoneW, phoneY+sy*0.15+sy*0.05, callingScreenColos[phones[activePhone]["bg"]], 0.7/myX*sx, fonts["ui-medium-20"], "center", "center")
						dxDrawText("Bejövő hívás", phoneX, phoneY+sy*0.13, phoneX+phoneW, phoneY+sy*0.13+sy*0.05, callingScreenColos[phones[activePhone]["bg"]], 0.7/myX*sx, fonts["ui-thin-15"], "center", "center")

						if isInSlot(phoneX+phoneW/2-75/myX*sx, phoneY+phoneH-sy*0.15, 50/myX*sx, 50/myY*sy) then 
							dxDrawImage(phoneX+phoneW/2-75/myX*sx, phoneY+phoneH-sy*0.15, 50/myX*sx, 50/myY*sy, "files/circle.png", 0, 0, 0, tocolor(227, 48, 48, 200))
						else
							dxDrawImage(phoneX+phoneW/2-75/myX*sx, phoneY+phoneH-sy*0.15, 50/myX*sx, 50/myY*sy, "files/circle.png", 0, 0, 0, tocolor(227, 48, 48, 150))
						end
						dxDrawImage(phoneX+phoneW/2-75/myX*sx+14/myX*sx, phoneY+phoneH-sy*0.15+14/myY*sy, 22/myX*sx, 22/myY*sy, "files/hivas_icon.png", 135, 0, 0, tocolor(220, 220, 220, 255))

						if isInSlot(phoneX+phoneW/2+25/myX*sx, phoneY+phoneH-sy*0.15, 50/myX*sx, 50/myY*sy) then 
							dxDrawImage(phoneX+phoneW/2+25/myX*sx, phoneY+phoneH-sy*0.15, 50/myX*sx, 50/myY*sy, "files/circle.png", 0, 0, 0, tocolor(122, 217, 93, 200))
						else
							dxDrawImage(phoneX+phoneW/2+25/myX*sx, phoneY+phoneH-sy*0.15, 50/myX*sx, 50/myY*sy, "files/circle.png", 0, 0, 0, tocolor(122, 217, 93, 150))
						end
						dxDrawImage(phoneX+phoneW/2+25/myX*sx+14/myX*sx, phoneY+phoneH-sy*0.15+14/myY*sy, 22/myX*sx, 22/myY*sy, "files/hivas_icon.png", 0, 0, 0, tocolor(220, 220, 220, 255))
					elseif callingState == 3 then 
						dxDrawImage(phoneX, phoneY, phoneW, phoneH, "files/call-bg.png")
						dxDrawText(getContactName(calledNumber), phoneX, phoneY+sy*0.03, phoneX+phoneW, phoneY+sy*0.03+sy*0.05, callingScreenColos[phones[activePhone]["bg"]], 0.8/myX*sx, fonts["ui-medium-20"], "center", "center")
						dxDrawText("Hívásban", phoneX, phoneY+sy*0.03, phoneX+phoneW, phoneY+sy*0.03+sy*0.1, callingScreenColos[phones[activePhone]["bg"]], 0.8/myX*sx, fonts["ui-thin-15"], "center", "center")

						dxDrawText(string.format("%02d:%02d:%02d", startCallTime[1], startCallTime[2], startCallTime[3]), phoneX, phoneY+sy*0.075, phoneX+phoneW, phoneY+sy*0.075+sy*0.05, callingScreenColos[phones[activePhone]["bg"]], 0.6/myX*sx, fonts["ui-thin-15"], "center", "center")

						if isCalled911 then 
							dxDrawImage(phoneX, phoneY, phoneW, phoneH, "files/call-bg.png")
							local startY = phoneY+sy*0.12
							for k, v in ipairs(Menus911) do 
								if isInSlot(phoneX+sx*0.015, startY, phoneW-sx*0.03, sy*0.04) then 
									roundedRectangle(phoneX+sx*0.015, startY, phoneW-sx*0.03, sy*0.04, uiColors[phones[activePhone]["theme"]]["bg"], uiColors[phones[activePhone]["theme"]]["bg"])
									dxDrawText(v[1], phoneX+sx*0.015, startY, phoneX+sx*0.0145+phoneW-sx*0.03, startY+sy*0.04, tocolor(255, 255, 255, 255), 0.9/myX*sx, fonts["ui-medium-9"], "center", "center", false, true)
								else
									roundedRectangle(phoneX+sx*0.015, startY, phoneW-sx*0.03, sy*0.04, uiColors[phones[activePhone]["theme"]]["bar"], uiColors[phones[activePhone]["theme"]]["bar"])
									dxDrawText(v[1], phoneX+sx*0.015, startY, phoneX+sx*0.0145+phoneW-sx*0.03, startY+sy*0.04, tocolor(129, 99, 191, 255), 0.9/myX*sx, fonts["ui-medium-9"], "center", "center", false, true)
								end
								startY = startY + (sy*0.05)
							end
						else
							local startY = phoneY + sy*0.11
							for k, v in ipairs(talkingTexts) do 
								local startX = phoneX+sx*0.02

								local boxColor = uiColors[phones[activePhone]["theme"]]["bar"]
								local textColor = tocolor(129, 99, 191, 255)

								if v[2] == 2 then 
									startX = startX + sx*0.025
									boxColor = tocolor(129, 99, 191, 255)
									textColor = tocolor(255,255,255,255)
									--dxDrawImage(startX+sx*0.08, startY+sy*0.019-4/myY*sy, 8/myX*sx, 8/myY*sy, "files/arrow2.png", 0, 0, 0, boxColor)
								else
									--dxDrawImage(startX-8/myX*sx, startY+sy*0.019-4/myY*sy, 8/myX*sx, 8/myY*sy, "files/arrow2.png", 180, 0, 0, boxColor)
								end

								roundedRectangle(startX, startY, sx*0.08, sy*0.038, boxColor)
								dxDrawText(v[1], startX, startY, startX+sx*0.08, startY+sy*0.038, textColor, 0.8/myX*sx, fonts["ui-medium-9"], "center", "center", false, true)

								startY = startY + sy*0.042
							end
                             
							roundedRectangle(phoneX+sx*0.0145, phoneY+phoneH-sy*0.13, phoneW-sx*0.03, sy*0.04, uiColors[phones[activePhone]["theme"]]["bar"])
							dxDrawText(editboxs["phone-calling"], phoneX+sx*0.0145, phoneY+phoneH-sy*0.13, phoneX+sx*0.0145+phoneW-sx*0.05, phoneY+phoneH-sy*0.13+sy*0.04, uiColors[phones[activePhone]["theme"]]["text"], 0.8/myX*sx, fonts["ui-medium-9"], "center", "center", false, true)

							if isInSlot(phoneX+sx*0.115, phoneY+phoneH-sy*0.13+9/myX*sx, 15/myX*sx, 15/myY*sy) then 
								--dxDrawImage(phoneX+sx*0.115, phoneY+phoneH-sy*0.13+9/myX*sx, 15/myX*sx, 15/myY*sy, "files/arrow2.png", 0, 0, 0, tocolor(129, 99, 191, 255))
							else
								--dxDrawImage(phoneX+sx*0.115, phoneY+phoneH-sy*0.13+9/myX*sx, 15/myX*sx, 15/myY*sy, "files/arrow2.png", 0, 0, 0, tocolor(39, 123, 209, 100))
							end
						end

						if isInSlot(phoneX+phoneW/2-25/myX*sx, phoneY+phoneH-sy*0.08, 50/myX*sx, 50/myY*sy) then 
							dxDrawImage(phoneX+phoneW/2-25/myX*sx, phoneY+phoneH-sy*0.08, 50/myX*sx, 50/myY*sy, "files/circle.png", 0, 0, 0, tocolor(227, 48, 48, 200))
						else
							dxDrawImage(phoneX+phoneW/2-25/myX*sx, phoneY+phoneH-sy*0.08, 50/myX*sx, 50/myY*sy, "files/circle.png", 0, 0, 0, tocolor(227, 48, 48, 150))
						end
						dxDrawImage(phoneX+phoneW/2-25/myX*sx+14/myX*sx, phoneY+phoneH-sy*0.08+14/myY*sy, 22/myX*sx, 22/myY*sy, "files/hivas_icon.png", 135, 0, 0, tocolor(220, 220, 220, 255))
					elseif callingState == 4 then 
						dxDrawImage(phoneX, phoneY, phoneW, phoneH, "files/call-bg.png")
						--dxDrawText(getContactName(calledNumber), phoneX, phoneY+sy*0.15, phoneX+phoneW, phoneY+sy*0.15+sy*0.05, callingScreenColos[phones[activePhone]["bg"]], 0.7/myX*sx, fonts["ui-medium-20"], "center", "center")
						dxDrawText("Ez a szám\n nem kapcsolható...", phoneX, phoneY+sy*0.185, phoneX+phoneW, phoneY+sy*0.185+sy*0.05, tocolor(255,255,255,255), 0.8/myX*sx, fonts["ui-thin-15"], "center", "center")
					elseif callingState == 5 then 
						dxDrawImage(phoneX, phoneY, phoneW, phoneH, "files/call-bg.png")
						--dxDrawText(getContactName(calledNumber), phoneX, phoneY+sy*0.15, phoneX+phoneW, phoneY+sy*0.15+sy*0.05, callingScreenColos[phones[activePhone]["bg"]], 0.7/myX*sx, fonts["ui-medium-20"], "center", "center")
						dxDrawText("Ez a szám \n foglalt!", phoneX, phoneY+sy*0.185, phoneX+phoneW, phoneY+sy*0.185+sy*0.05, tocolor(255,255,255,255), 0.8/myX*sx, fonts["ui-thin-15"], "center", "center")
					end

-------------------------------------------------------- HÍVÁS NAPLÓ KIRAJZOLÁSA -----------------------------
					--local startY = phoneY+sy*0.09
					--for i = 1, 11 do
					--	local revers = ReverseTable(phones[activePhone]["calls"]) 
					--	local v = revers[i+callLogsPointer]

					--	if actionNow[2] >= 1 then 
					--					if actionNow[4] == "calllogs_del" then 
					--						table.remove(revers, i+contactPointer)
					--						phones[activePhone]["calls"] = ReverseTable(revers)
					--					elseif actionNow[4] == "callogs_call" then 
					--						startCalling(v[1])
		            --                       exports.Pchat:takeMessage("me","felhív valakit.")
					--						--chat:sendLocalMeAction("felhív valakit.")
					--					end
					--					actionNow = {false, 0, getTickCount(), false}
					--				end
					--			end
					--		end

					--		dxDrawText(tostring(getContactName(v[1])), phoneX+sx*0.032, startY, phoneX+sx*0.032+sx*0.1, startY+sy*0.02, uiColors[phones[activePhone]["theme"]]["text"], 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
					--		dxDrawText(tostring(v[2]), phoneX+sx*0.032, startY+sy*0.012, phoneX+sx*0.032+sx*0.1, startY+sy*0.012+sy*0.02, uiColors[phones[activePhone]["theme"]]["text-light"], 0.7/myX*sx, fonts["ui-thin-9"], "left", "center")

					--		local callIconColor = tocolor(235, 66, 66, 200)
					--		local callIcon = "call_icon3"

					--		if v[3] == 2 then 
					--			callIconColor = tocolor(128, 217, 124, 200)
					--			callIcon = "call_icon2"
					--		elseif v[3] == 3 then 
					--			callIconColor = tocolor(240, 211, 98, 200)
					--			callIcon = "call_icon"
					--		end
					--		dxDrawImage(phoneX+sx*0.0145+3.5/myX*sx, startY+3.5/myY*sy, 20/myX*sx, 20/myY*sy, "files/"..callIcon..".png", 0, 0, 0, callIconColor)
					--	end

					--	startY = startY + sy*0.035
					--end 

-------------------------------------------------------------------------------------------------------------------------------

					local lineHeight = 11/#phones[activePhone]["calls"]

					if #phones[activePhone]["calls"] < 11 then 
						lineHeight = 1
					end

					--dxDrawRectangle(phoneX+phoneW-sx*0.0133, phoneY+sy*0.09, sx*0.001, phoneH-sy*0.133, tocolor(39, 123, 209, 100))
					--dxDrawRectangle(phoneX+phoneW-sx*0.0133, phoneY+sy*0.09 + ((phoneH-sy*0.133)*(lineHeight*callLogsPointer/11)), sx*0.001, (phoneH-sy*0.133)*lineHeight, tocolor(39, 123, 209, 200))
				elseif page == 10 then 
					dxDrawRectangle(phoneX+phoneW/15, phoneY+sy*0.015, phoneW-(phoneW/15*2), phoneH-sy*0.03, uiColors[phones[activePhone]["theme"]]["bg"])
					--dxDrawText("Hírdetés feladása", phoneX+sx*0.035, phoneY+sy*0.030, phoneX+sx*0.015+phoneW/2, phoneY+sy*0.055+sy*0.028, uiColors[phones[activePhone]["theme"]]["text-title"], 0.7/myX*sx, fonts["ui-heavy-15"], "left", "center")

					--if isInSlot(phoneX+sx*0.07, phoneY+sy*0.038, phoneW/2, sy*0.02) then 
						--dxDrawText("Hírdetés feladása", phoneX+sx*0.015, phoneY+sy*0.800, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(129, 99, 191, 255), 0.8/myX*sx, fonts["ui-medium-9"], "right", "center")
					--else
						--dxDrawText("Hírdetés feladása", phoneX+sx*0.015, phoneY+sy*0.800, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(39, 123, 209, 220), 0.8/myX*sx, fonts["ui-medium-9"], "right", "center")
					--end
                    
                    roundedRectangle(phoneX+sx*0.015, phoneY+sy*0.450, phoneW-sx*0.03, sy*0.03, tocolor(255, 96, 96, 255))
					if isInSlot(phoneX+sx*0.015, phoneY+sy*0.038, phoneW/2, sy*0.02) then 
						dxDrawText("Kilépés", phoneX+sx*0.06, phoneY+sy*0.870, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
					else
						dxDrawText("Kilépés", phoneX+sx*0.06, phoneY+sy*0.870, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
					end
                    dxDrawImage(phoneX+ phoneW/2 - 60/myX*sx, phoneY+sy*0.05, 120/myX*sx, 120/myY*sy, "files/logo.png", 0, 0, 0, tocolor(255, 255, 255, 255))
					roundedRectangle(phoneX+sx*0.0145, phoneY+sy*0.20, phoneW-sx*0.03, sy*0.2, uiColors[phones[activePhone]["theme"]]["bar"], uiColors[phones[activePhone]["theme"]]["bar"])
						--dxDrawText((string.len(editboxs["addNews-text"]) or 0).."/200", phoneX+sx*0.0145, phoneY+sy*0.09, phoneX+sx*0.0145+phoneW-sx*0.034, phoneY+sy*0.09+sy*0.195, tocolor(129, 99, 191, 255), 0.9/myX*sx, fonts["ui-medium-9"], "right", "bottom")
					
						if textPointerFlash + 300 < getTickCount() then 
							if textPointerFlash + 500 < getTickCount() then 
								textPointerFlash = getTickCount()
							end

							dxDrawText(editboxs["addNews-text"] .. "|", phoneX+sx*0.0155, phoneY+sy*0.20, phoneX+sx*0.0155+phoneW-sx*0.034, phoneY+sy*0.09+sy*0.185, tocolor(255, 255, 255, 255), 0.85/myX*sx, fonts["ui-medium-11"], "left", "top", false, true)
						else
							dxDrawText(editboxs["addNews-text"], phoneX+sx*0.0155, phoneY+sy*0.20, phoneX+sx*0.0155+phoneW-sx*0.034, phoneY+sy*0.09+sy*0.185, tocolor(255, 255, 255, 255), 0.85/myX*sx, fonts["ui-medium-11"], "left", "top", false, true)
						end
               
					roundedRectangle(phoneX+sx*0.015, phoneY+sy*0.415, phoneW-sx*0.03, sy*0.03, tocolor(129, 99, 191, 255))
						--dxDrawText("Egy hírdetés feladásának ára 150$!", phoneX+sx*0.015, phoneY+sy*0.415, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.415+sy*0.03, tocolor(129, 99, 191, 255), 0.8/myX*sx, fonts["ui-medium-9"], "center", "center")
                     if isInSlot(phoneX+sx*0.015, phoneY+sy*0.800, phoneW/2, sy*0.02) then 
						dxDrawText("Hírdetés feladása", phoneX+sx*-0.007, phoneY+sy*0.800, phoneX+sx*-0.007+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["ui-medium-9"], "right", "center")
					else
						dxDrawText("Hírdetés feladása", phoneX+sx*-0.007, phoneY+sy*0.800, phoneX+sx*-0.007+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["ui-medium-9"], "right", "center")
					end

					--roundedRectangle(phoneX+sx*0.015, phoneY+sy*0.45, phoneW-sx*0.03, sy*0.03, uiColors[phones[activePhone]["theme"]]["bar"], uiColors[phones[activePhone]["theme"]]["bar"])
					--dxDrawText("Hírdetéseket csak 5 percenként\n adhatsz fel!", phoneX+sx*0.015, phoneY+sy*0.45, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.45+sy*0.03, tocolor(129, 99, 191, 255), 0.8/myX*sx, fonts["ui-medium-9"], "center", "center")
				elseif page == 11 then -- időjárás
					dxDrawRectangle(phoneX+phoneW/13, phoneY+sy*0.01, phoneW-(phoneW/13*2), phoneH-sy*0.02, uiColors[phones[activePhone]["theme"]]["bg"])
					dxDrawText("Időjárás", phoneX+sx*0.015, phoneY+sy*0.055, phoneX+sx*0.015+phoneW/2, phoneY+sy*0.055+sy*0.028, uiColors[phones[activePhone]["theme"]]["text-title"], 0.7/myX*sx, fonts["ui-heavy-15"], "left", "center")

					if isInSlot(phoneX+sx*0.015, phoneY+sy*0.038, phoneW/2, sy*0.02) then 
						dxDrawText("Vissza", phoneX+sx*0.015, phoneY+sy*0.038, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(129, 99, 191, 255), 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
					else
						dxDrawText("Vissza", phoneX+sx*0.015, phoneY+sy*0.038, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(39, 123, 209, 220), 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
					end

					local weather = core:getSyncedWeather()

					--dxDrawImage(phoneX+ phoneW/2 - 50/myX*sx, phoneY+sy*0.08, 100/myX*sx, 100/myY*sy, "files/circle.png", 0, 0, 0, tocolor(39, 123, 209, 50))
					dxDrawText("Los Santos", phoneX, phoneY+sy*0.055, phoneX+phoneW, phoneY+sy*0.055+sy*0.075, uiColors[phones[activePhone]["theme"]]["text-title"], 0.8/myX*sx, fonts["ui-medium-15"], "center", "bottom")
					dxDrawText(math.floor(weather[3]).."°C", phoneX, phoneY+sy*0.055, phoneX+phoneW, phoneY+sy*0.055+sy*0.13, tocolor(129, 99, 191, 255), 0.65/myX*sx, fonts["ui-thin-30"], "center", "bottom")
					dxDrawText("Szél: "..(math.floor(weather[2]*100)/100).."km/h", phoneX, phoneY+sy*0.055, phoneX+phoneW, phoneY+sy*0.055+sy*0.16, tocolor(129, 99, 191, 255), 0.35/myX*sx, fonts["ui-thin-30"], "center", "bottom")
					--dxDrawText("Szél: "..(math.floor(weather[2]*100)/100).."km/h", phoneX, phoneY+sy*0.055, phoneX+phoneW, phoneY+sy*0.055+sy*0.22, tocolor(129, 99, 191, 255), 0.65/myX*sx, fonts["ui-heavy-15"], "center", "bottom")
					--dxDrawText(math.floor(weather[3]).."°", 10, 22, 50, 50, tocolor(255, 255, 255, 255), 0.65/myX*sx, fonts["ui-medium-30"], "left", "top")

					--dxDrawText((math.floor(weather[2]*100)/100).."km/h", 10, 70, 80, 80, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["ui-heavy-9"], "left", "center")

					dxDrawImage(phoneX + phoneW/2 - 40/myX*sx, phoneY+sy*0.3, 80/myX*sx, 80/myY*sy, "files/weatherIcons/"..(weatherIcons[weather[1]] or "sun_1")..".png")
				elseif page == 12 then -- dark web
					dxDrawImage(phoneX, phoneY, phoneW, phoneH, "files/dw_bg.png")
				--	exports.blur:createBlur(phoneX+sx*0.01, phoneY+sy*0.015, phoneW-(sx*0.02), phoneH-(sy*0.015*2), 50)

					if isInSlot(phoneX+sx*0.015, phoneY+sy*0.038, phoneW/2, sy*0.02) then 
						dxDrawText("Back", phoneX+sx*0.015, phoneY+sy*0.038, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
					else
						dxDrawText("Back", phoneX+sx*0.015, phoneY+sy*0.038, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(255, 255, 255, 220), 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
					end

					dxDrawText("Dark", phoneX, phoneY+sy*0.05, phoneX+phoneW, phoneY+sy*0.15, tocolor(255, 255, 255, 255), 0.7/myX*sx, fonts["ui-heavy-50"], "center", "center")
					dxDrawText("Web", phoneX, phoneY+sy*0.05, phoneX+phoneW, phoneY+sy*0.15, tocolor(255, 255, 255, 255), 0.55/myX*sx, fonts["ui-thin-30"], "center", "bottom")

					roundedRectangle(phoneX+sx*0.0145, phoneY+sy*0.33, phoneW-sx*0.03, sy*0.15, tocolor(10, 10, 10, 255), tocolor(20, 20, 20, 255))
						dxDrawText((string.len(editboxs["addNews-text"]) or 0).."/200", phoneX+sx*0.0145, phoneY+sy*0.33, phoneX+sx*0.0145+phoneW-sx*0.034, phoneY+sy*0.33+sy*0.145, tocolor(129, 99, 191, 255), 0.9/myX*sx, fonts["ui-medium-9"], "right", "bottom")
						if textPointerFlash + 300 < getTickCount() then 
							if textPointerFlash + 500 < getTickCount() then 
								textPointerFlash = getTickCount()
							end
							dxDrawText(editboxs["addNews-text"].."|", phoneX+sx*0.016, phoneY+sy*0.33, phoneX+sx*0.016+phoneW-sx*0.034, phoneY+sy*0.33+sy*0.145, tocolor(129, 99, 191, 255), 0.85/myX*sx, fonts["ui-medium-11"], "left", "top", false, true)
						else
							dxDrawText(editboxs["addNews-text"], phoneX+sx*0.016, phoneY+sy*0.33, phoneX+sx*0.016+phoneW-sx*0.034, phoneY+sy*0.33+sy*0.145, tocolor(129, 99, 191, 255), 0.85/myX*sx, fonts["ui-medium-11"], "left", "top", false, true)
						end

					if isInSlot(phoneX+sx*0.0155, phoneY+sy*0.312, phoneW/2-sx*0.03, sy*0.015) then 
						dxDrawText("Submit Ad", phoneX+sx*0.0145, phoneY+sy*0.3, phoneX+sx*0.0145+phoneW-sx*0.03, phoneY+sy*0.3+sy*0.045, tocolor(220, 220, 220, 255), 0.8/myX*sx, fonts["ui-medium-11"], "left", "center")
					else
						dxDrawText("Submit Ad", phoneX+sx*0.0145, phoneY+sy*0.3, phoneX+sx*0.0145+phoneW-sx*0.03, phoneY+sy*0.3+sy*0.045, tocolor(220, 220, 220, 200), 0.8/myX*sx, fonts["ui-medium-11"], "left", "center")
					end

					dxDrawText("Price: 375$", phoneX+sx*0.0145, phoneY+sy*0.3, phoneX+sx*0.0145+phoneW-sx*0.03, phoneY+sy*0.3+sy*0.045, tocolor(220, 220, 220, 255), 0.6/myX*sx, fonts["ui-bold-15"], "right", "center")
				elseif page == 13 then 
					dxDrawRectangle(phoneX+phoneW/13, phoneY+sy*0.01, phoneW-(phoneW/13*2), phoneH-sy*0.02, uiColors[phones[activePhone]["theme"]]["bg"])
					dxDrawText("Biztonsági beállítások", phoneX+sx*0.015, phoneY+sy*0.055, phoneX+sx*0.015+phoneW/2, phoneY+sy*0.055+sy*0.028, uiColors[phones[activePhone]["theme"]]["text-title"], 0.7/myX*sx, fonts["ui-heavy-15"], "left", "center")

					if isInSlot(phoneX+sx*0.015, phoneY+sy*0.038, phoneW/2, sy*0.02) then 
						dxDrawText("Vissza", phoneX+sx*0.015, phoneY+sy*0.038, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(129, 99, 191, 255), 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
					else
						dxDrawText("Vissza", phoneX+sx*0.015, phoneY+sy*0.038, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(39, 123, 209, 220), 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
					end

					roundedRectangle(phoneX+sx*0.015, phoneY+sy*0.09, phoneW-sx*0.03, sy*0.11, uiColors[phones[activePhone]["theme"]]["bar"], uiColors[phones[activePhone]["theme"]]["bar"])
					dxDrawText("Telefonszám megjelenítése", phoneX+sx*0.0175, phoneY+sy*0.095, phoneX+sx*0.0175+phoneW-sx*0.03, phoneY+sy*0.095+sy*0.1, uiColors[phones[activePhone]["theme"]]["text"], 0.57/myX*sx, fonts["ui-heavy-15"], "left", "top")
					--dxDrawText("Ennek az opciónak a kikapcsolásával elkerülheted, a telefonszámod megjelenítését a feladott hírdetésekben.", phoneX+sx*0.0175, phoneY+sy*0.115, phoneX+sx*0.0175+phoneW-sx*0.03, phoneY+sy*0.115+sy*0.11, uiColors[phones[activePhone]["theme"]]["text-light"], 0.85/myX*sx, fonts["ui-medium-9"], "left", "top", false, true)

					local buttonColor
					local state = phones[activePhone]["phoneNumber-showing"]
					if state then 
						buttonColor = tocolor(102, 186, 102, 200)
					else
						buttonColor = tocolor(219, 57, 57, 200)
					end

					if isInSlot(phoneX+sx*0.11, phoneY+sy*0.17, 30/myX*sx, 30/myY*sy) then
						if state then 
							buttonColor = tocolor(102, 186, 102, 255)
						else
							buttonColor = tocolor(219, 57, 57, 255)
						end
					end

					if state then 
						dxDrawImage(phoneX+sx*0.11, phoneY+sy*0.17, 30/myX*sx, 30/myY*sy, "files/switch.png", 180, 0, 0, buttonColor)
						dxDrawText("Bekapcsolva", phoneX+sx*0.0175, phoneY+sy*0.095, phoneX+sx*0.0175+phoneW-sx*0.03, phoneY+sy*0.095+sy*0.1, uiColors[phones[activePhone]["theme"]]["text"], 0.57/myX*sx, fonts["ui-heavy-15"], "left", "bottom")
					else
						dxDrawImage(phoneX+sx*0.11, phoneY+sy*0.17, 30/myX*sx, 30/myY*sy, "files/switch.png", 0, 0, 0, buttonColor)
						dxDrawText("Kikapcsolva", phoneX+sx*0.0175, phoneY+sy*0.095, phoneX+sx*0.0175+phoneW-sx*0.03, phoneY+sy*0.095+sy*0.1, uiColors[phones[activePhone]["theme"]]["text"], 0.57/myX*sx, fonts["ui-heavy-15"], "left", "bottom")
					end

					--[[roundedRectangle(phoneX+sx*0.015, phoneY+sy*0.09+sy*0.115, phoneW-sx*0.03, sy*0.11, uiColors[phones[activePhone]["theme"] ]["bar"], uiColors[phones[activePhone]["theme"] ]["bar"])
					dxDrawText("Telefonhasználati adatok", phoneX+sx*0.0175, phoneY+sy*0.095+sy*0.115, phoneX+sx*0.0175+phoneW-sx*0.03, phoneY+sy*0.095+sy*0.15+sy*0.115, uiColors[phones[activePhone]["theme"] ]["text"], 0.57/myX*sx, fonts["ui-heavy-15"], "left", "top")
					dxDrawText("Ha ez az opció aktív, akkor a jelenlegi szolgáltatód számára a telefon adatokat szolgál a helyadataidról és a legtöbbet használt alkalmazásaidról.", phoneX+sx*0.0175, phoneY+sy*0.115+sy*0.115, phoneX+sx*0.0175+phoneW-sx*0.03, phoneY+sy*0.115+sy*0.15+sy*0.115, uiColors[phones[activePhone]["theme"] ]["text-light"], 0.85/myX*sx, fonts["ui-medium-9"], "left", "top", false, true)
				
					local buttonColor
					local state = phones[activePhone]["sharePhoneUseingDatas"]
					if state then 
						buttonColor = tocolor(102, 186, 102, 200)
					else
						buttonColor = tocolor(219, 57, 57, 200)
					end

					if isInSlot(phoneX+sx*0.11, phoneY+sy*0.17+sy*0.115, 30/myX*sx, 30/myY*sy) then
						if state then 
							buttonColor = tocolor(102, 186, 102, 255)
						else
							buttonColor = tocolor(219, 57, 57, 255)
						end
					end

					if state then 
						dxDrawImage(phoneX+sx*0.11, phoneY+sy*0.17+sy*0.115, 30/myX*sx, 30/myY*sy, "files/switch.png", 180, 0, 0, buttonColor)
						dxDrawText("Bekapcsolva", phoneX+sx*0.0175, phoneY+sy*0.095+sy*0.115, phoneX+sx*0.0175+phoneW-sx*0.03, phoneY+sy*0.095+sy*0.1+sy*0.115, uiColors[phones[activePhone]["theme"] ]["text"], 0.57/myX*sx, fonts["ui-heavy-15"], "left", "bottom")
					else
						dxDrawImage(phoneX+sx*0.11, phoneY+sy*0.17+sy*0.115, 30/myX*sx, 30/myY*sy, "files/switch.png", 0, 0, 0, buttonColor)
						dxDrawText("Kikapcsolva", phoneX+sx*0.0175, phoneY+sy*0.095+sy*0.115, phoneX+sx*0.0175+phoneW-sx*0.03, phoneY+sy*0.095+sy*0.1+sy*0.115, uiColors[phones[activePhone]["theme"] ]["text"], 0.57/myX*sx, fonts["ui-heavy-15"], "left", "bottom")
					end]]
				elseif page == 14 then 
					dxDrawRectangle(phoneX+phoneW/15, phoneY+sy*0.01, phoneW-(phoneW/15*2), phoneH-sy*0.03, uiColors[phones[activePhone]["theme"]]["bg"])

					if smsState == 1 then 
						--dxDrawText("Üzenetek", phoneX+sx*0.015, phoneY+sy*0.055, phoneX+sx*0.015+phoneW/2, phoneY+sy*0.055+sy*0.028, uiColors[phones[activePhone]["theme"]]["text-title"], 0.7/myX*sx, fonts["ui-heavy-15"], "left", "center")

						  roundedRectangle(phoneX+sx*0.015, phoneY+sy*0.415, phoneW-sx*0.03, sy*0.03, tocolor(129, 99, 191, 255))
						--dxDrawText("Egy hírdetés feladásának ára 150$!", phoneX+sx*0.015, phoneY+sy*0.415, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.415+sy*0.03, tocolor(129, 99, 191, 255), 0.8/myX*sx, fonts["ui-medium-9"], "center", "center")
                        if isInSlot(phoneX+sx*0.015, phoneY+sy*0.800, phoneW/2, sy*0.02) then 
						  dxDrawText("Üzenet küldése", phoneX+sx*-0.007, phoneY+sy*0.800, phoneX+sx*-0.007+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["ui-medium-9"], "right", "center")
					    else
						  dxDrawText("Üzenet küldése", phoneX+sx*-0.007, phoneY+sy*0.800, phoneX+sx*-0.007+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["ui-medium-9"], "right", "center")
					    end

					 	   roundedRectangle(phoneX+sx*0.015, phoneY+sy*0.450, phoneW-sx*0.03, sy*0.03, tocolor(255, 96, 96, 255))
					    if isInSlot(phoneX+sx*0.015, phoneY+sy*0.038, phoneW/2, sy*0.02) then 
						   dxDrawText("Kilépés", phoneX+sx*0.06, phoneY+sy*0.870, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
					    else
						   dxDrawText("Kilépés", phoneX+sx*0.06, phoneY+sy*0.870, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
					    end

						local tableRealDataCount = 0

						if phoneMessages[tonumber(activePhone)] then
							local startY = phoneY+sy*0.085
							local renderedItemCount = 0
							local newItemNum = 0
							for k, v in pairs(phoneMessages[tonumber(activePhone)]) do
								if v then
									newItemNum = newItemNum + 1
									if newItemNum > smsPointer then
										if renderedItemCount < 8 then
											roundedRectangle(phoneX+sx*0.0145, startY, phoneW-sx*0.03, phoneH/12, tocolor(129, 99, 191, 255), tocolor(129, 99, 191, 255))

											local alpha = 0
											if not v.read then 
												alpha = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - animationTick) / 1000, "CosineCurve")
												roundedRectangle(phoneX+sx*0.0145, startY, phoneW-sx*0.03, phoneH/12, tocolor(129, 99, 191, 255*alpha), tocolor(39, 123, 209, 200*alpha))
											end

											--[[if isInSlot(phoneX+sx*0.0145, startY, phoneW-sx*0.03, phoneH/12) then 
												if getKeyState("mouse2") or getKeyState("mouse1") then 
													if not actionNow[1] then 
														actionNow[1] = k
														actionNow[3] = getTickCount()

														if getKeyState("mouse1") then 
															--actionNow[4] = "call"
														else
															actionNow[4] = "del"
														end
													else
														if actionNow[1] == k then 
															actionNow[2] = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount()-actionNow[3])/1000, "InOutQuad")
														else 
															actionNow = {false, 0, getTickCount(), false}
														end
													end
												else 

													actionNow = {false, 0, getTickCount(), false}
												end

												if actionNow[1] == k then 
													if actionNow[4] == "del" then 
														roundedRectangle(phoneX+sx*0.0145, startY, (phoneW-sx*0.03)*actionNow[2], phoneH/12, tocolor(219, 57, 57, 255*actionNow[2]), tocolor(219, 57, 57, 255*actionNow[2]))
														dxDrawText("Törlés", phoneX+sx*0.0145, startY, phoneX+sx*0.0145+(phoneW-sx*0.035), startY+phoneH/12, tocolor(219, 57, 57, 255), 0.8/myX*sx, fonts["ui-medium-11"], "right", "center")
													end

													if actionNow[2] >= 1 then 
														if actionNow[4] == "del" then 
															phoneMessages[tonumber(activePhone)][k] = false

															table.remove(phoneMessages[tonumber(activePhone)], k)

															--triggerServerEvent("phone > delConversationFromPhone", root, tonumber(activePhone), tonumber(k))
															--print("del")
														end
														actionNow = {false, 0, getTickCount(), false}
													end
												end
											end]]

											renderedItemCount = renderedItemCount + 1

											dxDrawImage(phoneX+sx*0.0155+4/myX*sx, startY+4/myY*sy, 30/myX*sx, 30/myY*sy, "files/avatars/small/1.png")
											
											dxDrawText(getContactName(k), phoneX+sx*0.05, startY+sy*0.02, phoneX+sx*0.04+sx*0.1, startY+sy*0.005+sy*0.02, tocolor(255,255,255,255), 0.8/myX*sx, fonts["ui-medium-11"], "left", "center")
											--dxDrawText(v.messages[#v.messages][2], phoneX+sx*0.04, startY+sy*0.02, phoneX+sx*0.04+sx*0.086, startY+sy*0.02+sy*0.02, uiColors[phones[activePhone]["theme"]]["text-light"], 0.65/myX*sx, fonts["ui-thin-11"], "left", "center", true)

											startY = startY + phoneH/12 + sy*0.005
										end
									end
								end
							end

							for k, v in pairs(phoneMessages[tonumber(activePhone)]) do 
								tableRealDataCount = tableRealDataCount + 1
							end
						end

						local lineHeight = 0
						
						lineHeight = math.min(8/(tableRealDataCount or 0), 1)

					--	dxDrawRectangle(phoneX+phoneW-sx*0.0133, phoneY+sy*0.085, sx*0.001, phoneH-sy*0.135, tocolor(39, 123, 209, 100))
					--	dxDrawRectangle(phoneX+phoneW-sx*0.0133, phoneY+sy*0.085 + ((phoneH-sy*0.135)*(lineHeight*smsPointer/8)), sx*0.001, (phoneH-sy*0.135)*lineHeight, tocolor(39, 123, 209, 200))
					elseif smsState == 2 then 
						--dxDrawText(getContactName(openedMessagePage), phoneX+sx*0.015, phoneY+sy*0.055, phoneX+sx*0.015+phoneW/2, phoneY+sy*0.055+sy*0.028, uiColors[phones[activePhone]["theme"]]["text-title"], 0.7/myX*sx, fonts["ui-heavy-15"], "left", "center")

						roundedRectangle(phoneX+sx*0.015, phoneY+sy*0.450, phoneW-sx*0.03, sy*0.03, tocolor(255, 96, 96, 255))
					    if isInSlot(phoneX+sx*0.015, phoneY+sy*0.038, phoneW/2, sy*0.02) then 
						   dxDrawText("Kilépés", phoneX+sx*0.06, phoneY+sy*0.870, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
					    else
						   dxDrawText("Kilépés", phoneX+sx*0.06, phoneY+sy*0.870, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
					    end

						local startY = phoneY + sy*0.095
						for i = 1, 4 do
							local v = phoneMessages[tonumber(activePhone)][openedMessagePage].messages [i + smsPointer] 

							if v then 

								local startX = phoneX+sx*0.02

								local boxColor = uiColors[phones[activePhone]["theme"]]["bar"]
								local textColor = tocolor(255,255,255,255)

								if v[3] then 
									startX = startX + sx*0.025
									boxColor = tocolor(129, 99, 191, 255)
									textColor = uiColors[phones[activePhone]["theme"]]["text"]
									dxDrawImage(startX+sx*0.08, startY+sy*0.024-4/myY*sy, 8/myX*sx, 8/myY*sy, "files/arrow2.png", 0, 0, 0, boxColor)
									--dxDrawText(v[1], startX, startY - sy*0.0135, startX+sx*0.08, startY, uiColors[phones[activePhone]["theme"]]["sms-time"], 0.7/myX*sx, fonts["ui-medium-9"], "right", "center", false, true)
								else
									--dxDrawText(v[1], startX, startY - sy*0.0135, startX+sx*0.08, startY, uiColors[phones[activePhone]["theme"]]["sms-time"], 0.7/myX*sx, fonts["ui-medium-9"], "left", "center", false, true)

									--dxDrawImage(startX-8/myX*sx, startY+sy*0.024-4/myY*sy, 8/myX*sx, 8/myY*sy, "files/arrow2.png", 180, 0, 0, boxColor)
								end

								roundedRectangle(startX, startY, sx*0.08, sy*0.048, boxColor)

								dxDrawText(v[2], startX, startY, startX+sx*0.08, startY+sy*0.048, tocolor(255,255,255,255), 0.8/myX*sx, fonts["ui-medium-9"], "center", "center", false, true)

								startY = startY + sy*0.065
							end
						end

						local lineHeight = math.min(5/#phoneMessages[tonumber(activePhone)][openedMessagePage].messages, 1)
						--dxDrawRectangle(phoneX+phoneW-sx*0.0133, phoneY+sy*0.085, sx*0.001, phoneH-sy*0.135, tocolor(39, 123, 209, 100))

						local linePosY = phoneY+sy*0.085 + ((phoneH-sy*0.135)*(lineHeight*smsPointer/5))

						
							linePosY =  phoneY+sy*0.085
						
						--dxDrawRectangle(phoneX+phoneW-sx*0.0133, linePosY, sx*0.001, (phoneH-sy*0.135)*lineHeight, tocolor(39, 123, 209, 200))
					
						roundedRectangle(phoneX+sx*0.0145, phoneY+sy*0.37, phoneW-sx*0.03, sy*0.07, uiColors[phones[activePhone]["theme"]]["bar"], uiColors[phones[activePhone]["theme"]]["bar"])
						--dxDrawText((string.len(editboxs["sms"]) or 0).."/65", phoneX+sx*0.0145, phoneY+sy*0.37, phoneX+sx*0.0145+phoneW-sx*0.034, phoneY+sy*0.41+sy*0.065, tocolor(129, 99, 191, 255), 0.9/myX*sx, fonts["ui-medium-9"], "right", "bottom")
					
						if textPointerFlash + 300 < getTickCount() and activeEditbox == "sms" then 
							if textPointerFlash + 500 < getTickCount() then 
								textPointerFlash = getTickCount()
							end

							dxDrawText(editboxs["sms"] .. "|", phoneX+sx*0.0155, phoneY+sy*0.372, phoneX+sx*0.0155+phoneW-sx*0.045, phoneY+sy*0.412+sy*0.065, tocolor(255, 255, 255, 255), 0.85/myX*sx, fonts["ui-medium-11"], "left", "top", false, true)
						else
							dxDrawText(editboxs["sms"], phoneX+sx*0.0155, phoneY+sy*0.372, phoneX+sx*0.0155+phoneW-sx*0.045, phoneY+sy*0.412+sy*0.065, tocolor(255, 255, 255, 255), 0.85/myX*sx, fonts["ui-medium-11"], "left", "top", false, true)
						end

						if isInSlot(phoneX+sx*0.115, phoneY+sy*0.413, sx*0.013, sy*0.02) then
							--dxDrawText("", phoneX+sx*0.0155, phoneY+sy*0.412, phoneX+sx*0.0155+phoneW-sx*0.034, phoneY+sy*0.412+sy*0.065, tocolor(129, 99, 191, 255), 0.5/myX*sx, fonts["fontawesome2"], "right", "top", false, true)
						else
							--dxDrawText("", phoneX+sx*0.0155, phoneY+sy*0.412, phoneX+sx*0.0155+phoneW-sx*0.034, phoneY+sy*0.412+sy*0.065, tocolor(39, 123, 209, 100), 0.5/myX*sx, fonts["fontawesome2"], "right", "top", false, true)
						end
					elseif smsState == 3 then 
						--dxDrawText("Üzenet írása", phoneX+sx*0.015, phoneY+sy*0.055, phoneX+sx*0.015+phoneW/2, phoneY+sy*0.055+sy*0.028, uiColors[phones[activePhone]["theme"]]["text-title"], 0.7/myX*sx, fonts["ui-heavy-15"], "left", "center")
						   dxDrawImage(phoneX+ phoneW/2 - 60/myX*sx, phoneY+sy*0.05, 120/myX*sx, 120/myY*sy, "files/logo.png", 0, 0, 0, tocolor(255, 255, 255, 255))
						roundedRectangle(phoneX+sx*0.015, phoneY+sy*0.450, phoneW-sx*0.03, sy*0.03, tocolor(255, 96, 96, 255))
					    if isInSlot(phoneX+sx*0.015, phoneY+sy*0.038, phoneW/2, sy*0.02) then 
						   dxDrawText("Kilépés", phoneX+sx*0.06, phoneY+sy*0.870, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
					    else
						   dxDrawText("Kilépés", phoneX+sx*0.06, phoneY+sy*0.870, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
					    end

						
						--dxDrawImage(phoneX+sx*0.04, phoneY+sy*0.1, 100/myX*sx, 100/myY*sy, "files/circle.png", 0, 0, 0, tocolor(39, 123, 209, 100))
						--dxDrawText("", phoneX+sx*0.04, phoneY+sy*0.1, phoneX+sx*0.04+100/myX*sx, phoneY+sy*0.1+100/myY*sy, tocolor(129, 99, 191, 255), 1/myX*sx, fonts["fontawesome2"], "center", "center")

						roundedRectangle(phoneX+sx*0.015, phoneY+sy*0.415, phoneW-sx*0.03, sy*0.03, tocolor(129, 99, 191, 255))
						--dxDrawText("Egy hírdetés feladásának ára 150$!", phoneX+sx*0.015, phoneY+sy*0.415, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.415+sy*0.03, tocolor(129, 99, 191, 255), 0.8/myX*sx, fonts["ui-medium-9"], "center", "center")
                        if isInSlot(phoneX+sx*0.015, phoneY+sy*0.800, phoneW/2, sy*0.02) then 
						  dxDrawText("Üzenet küldése", phoneX+sx*-0.007, phoneY+sy*0.800, phoneX+sx*-0.007+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["ui-medium-9"], "right", "center")
					    else
						  dxDrawText("Üzenet küldése", phoneX+sx*-0.007, phoneY+sy*0.800, phoneX+sx*-0.007+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["ui-medium-9"], "right", "center")
					    end
					    roundedRectangle(phoneX+sx*0.015, phoneY+sy*0.220, phoneW-sx*0.03, sy*0.03, tocolor(20, 20, 20, 255))
					    roundedRectangle(phoneX+sx*0.015, phoneY+sy*0.255, phoneW-sx*0.03, sy*0.10, tocolor(20, 20, 20, 255))
						if activeEditbox == "sms-phoneNumber" then 
							if string.len(editboxs["sms-phoneNumber"]) > 0 then 
								dxDrawText(editboxs["sms-phoneNumber"], phoneX+sx*0.015, phoneY+sy*0.220, phoneX+sx*0.020+sx*0.1, phoneY+sy*0.225+sy*0.03, tocolor(255, 255, 255, 255), 0.9/myX*sx, fonts["ui-medium-11"], "left", "center")
							else
								dxDrawText("Telefonszám", phoneX+sx*0.015, phoneY+sy*0.220, phoneX+sx*0.020+sx*0.1, phoneY+sy*0.225+sy*0.03, tocolor(255, 255, 255, 255), 0.9/myX*sx, fonts["ui-medium-11"], "left", "center")
							end
						else
							if string.len(editboxs["sms-phoneNumber"]) > 0 then 
								dxDrawText(editboxs["sms-phoneNumber"], phoneX+sx*0.015, phoneY+sy*0.220, phoneX+sx*0.020+sx*0.1, phoneY+sy*0.225+sy*0.03, tocolor(255, 255, 255, 255), 0.9/myX*sx, fonts["ui-medium-11"], "left", "center")
							else
								dxDrawText("Telefonszám", phoneX+sx*0.015, phoneY+sy*0.220, phoneX+sx*0.020+sx*0.1, phoneY+sy*0.225+sy*0.03, tocolor(255, 255, 255, 255), 0.9/myX*sx, fonts["ui-medium-11"], "left", "center")
							end
						end
						--dxDrawLine(phoneX+sx*0.0145, phoneY+sy*0.25, phoneX+sx*0.0145+phoneW-sx*0.03, phoneY+sy*0.25, uiColors[phones[activePhone]["theme"]]["bar"], 2)

						if activeEditbox == "sms-message" then 
							if string.len(editboxs["sms-message"]) > 0 then
								dxDrawText(editboxs["sms-message"], phoneX+sx*0.015, phoneY+sy*0.26, phoneX+sx*0.015+sx*0.1, phoneY+sy*0.345, tocolor(255, 255, 255, 255), 0.9/myX*sx, fonts["ui-medium-11"], "left", "top", false, true)
							else
								dxDrawText("Üzenet", phoneX+sx*0.015, phoneY+sy*0.26, phoneX+sx*0.015+sx*0.1, phoneY+sy*0.345, tocolor(255, 255, 255, 255), 0.9/myX*sx, fonts["ui-medium-11"], "left", "top", false, true)
							end
						else
							if string.len(editboxs["sms-message"]) > 0 then
								dxDrawText(editboxs["sms-message"], phoneX+sx*0.015, phoneY+sy*0.26, phoneX+sx*0.015+sx*0.1, phoneY+sy*0.345, tocolor(255, 255, 255, 255), 0.9/myX*sx, fonts["ui-medium-11"], "left", "top", false, true)
							else
								dxDrawText("Üzenet", phoneX+sx*0.015, phoneY+sy*0.26, phoneX+sx*0.015+sx*0.1, phoneY+sy*0.345, tocolor(255, 255, 255, 255), 0.9/myX*sx, fonts["ui-medium-11"], "left", "top", false, true)
							end
						end

						if isInSlot(phoneX+sx*0.112, phoneY+sy*0.26, sx*0.013, sy*0.02) then
							--dxDrawText("", phoneX+sx*0.015, phoneY+sy*0.26, phoneX+sx*0.015+sx*0.11, phoneY+sy*0.345, tocolor(129, 99, 191, 255), 0.5/myX*sx, fonts["fontawesome2"], "right", "top", false, true)
						else
							--dxDrawText("", phoneX+sx*0.015, phoneY+sy*0.26, phoneX+sx*0.015+sx*0.11, phoneY+sy*0.345, tocolor(39, 123, 209, 100), 0.5/myX*sx, fonts["fontawesome2"], "right", "top", false, true)
						end
						--dxDrawLine(phoneX+sx*0.0145, phoneY+sy*0.35, phoneX+sx*0.0145+phoneW-sx*0.03, phoneY+sy*0.35, uiColors[phones[activePhone]["theme"]]["bar"], 2)
					end
				elseif page == 15 then 
					dxDrawRectangle(phoneX+phoneW/13, phoneY+sy*0.01, phoneW-(phoneW/13*2), phoneH-sy*0.02, uiColors[phones[activePhone]["theme"]]["bg"])
					dxDrawText("Értesítési hang beállítása", phoneX+sx*0.015, phoneY+sy*0.055, phoneX+sx*0.015+phoneW/2, phoneY+sy*0.055+sy*0.028, uiColors[phones[activePhone]["theme"]]["text-title"], 0.7/myX*sx, fonts["ui-heavy-15"], "left", "center")

					if isInSlot(phoneX+sx*0.015, phoneY+sy*0.038, phoneW/2, sy*0.02) then 
						dxDrawText("Vissza", phoneX+sx*0.015, phoneY+sy*0.038, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(129, 99, 191, 255), 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
					else
						dxDrawText("Vissza", phoneX+sx*0.015, phoneY+sy*0.038, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(39, 123, 209, 220), 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
					end

					local startY = phoneY+sy*0.09
					for i = 1, 12 do 
						if fileExists("files/notsounds/"..i..".mp3") then 
							roundedRectangle(phoneX+sx*0.0145, startY, phoneW-sx*0.03, sy*0.025, uiColors[phones[activePhone]["theme"]]["bar"], uiColors[phones[activePhone]["theme"]]["bar"])

							if isInSlot(phoneX+phoneW-sx*0.03, startY+sy*0.004+1/myY*sy, 15/myX*sx, 15/myY*sy) then 
								dxDrawImage(phoneX+phoneW-sx*0.03, startY+sy*0.004+1/myY*sy, 15/myX*sx, 15/myY*sy, "files/speaker_icon.png", 0, 0, 0, tocolor(129, 99, 191, 255))
							else
								dxDrawImage(phoneX+phoneW-sx*0.03, startY+sy*0.004+1/myY*sy, 15/myX*sx, 15/myY*sy, "files/speaker_icon.png", 0, 0, 0, tocolor(39, 123, 209, 220))
							end

							if phones[activePhone]["notsound"] == i then
								dxDrawText(i.." #277bd1(Jelenlegi)", phoneX+sx*0.018, startY, phoneX+sx*0.018+sx*0.1, startY+sy*0.025, uiColors[phones[activePhone]["theme"]]["text"], 0.7/myX*sx, fonts["ui-medium-11"], "left", "center", false, false, false, true)
							else
								dxDrawText(i, phoneX+sx*0.018, startY, phoneX+sx*0.018+sx*0.1, startY+sy*0.025, uiColors[phones[activePhone]["theme"]]["text"], 0.7/myX*sx, fonts["ui-medium-11"], "left", "center", false, false, false, true)
							end

							startY = startY + sy*0.03
						end
					end

					dxawLine(phoneX+sx*0.0145, phoneY+phoneH-sy*0.045, phoneX+sx*0.0145+phoneW-sx*0.03, phoneY+phoneH-sy*0.045, uiColors[phones[activePhone]["theme"]]["bar"], 2)
					dxDrLine(phoneX+sx*0.0145, phoneY+phoneH-sy*0.045, phoneX+sx*0.0145+((phoneW-sx*0.03)*phones[activePhone]["notsound-volume"]), phoneY+phoneH-sy*0.045, tocolor(39, 123, 209, 150), 2)

					if isInSlot(phoneX+sx*0.0145+((phoneW-sx*0.03)*phones[activePhone]["notsound-volume"])-volumeScrollDatas[4]/2/myX*sx, phoneY+phoneH-sy*0.045-volumeScrollDatas[4]/2/myY*sy, volumeScrollDatas[4]/myX*sx, volumeScrollDatas[4]/myY*sy) then 
						if not volumeScrollDatas[1] then 
							volumeScrollDatas[1] = true 
							volumeScrollDatas[3] = "open"
							volumeScrollDatas[2] = getTickCount()
						end

						if getKeyState("mouse1") then 
							local cx, cy = getCursorPosition()
							cx = cx*sx 
	
							cx = cx - phoneX+sx*0.0145
							cx = cx - 50/myX*sx	
							
							if cx /  (phoneW-sx*0.03) > 0 then 
								if cx /  (phoneW-sx*0.03) < 1 then 
									phones[activePhone]["notsound-volume"] = cx /  (phoneW-sx*0.03)

									if isElement(showingRingstone) then 
										setSoundVolume(showingRingstone, 5*phones[activePhone]["notsound-volume"])
									end
								end
							end
						end
					else
						if volumeScrollDatas[1] then 
							volumeScrollDatas[1] = false
							volumeScrollDatas[3] = "close"
							volumeScrollDatas[2] = getTickCount()
						end
					end

					if volumeScrollDatas[3] == "open" then  
						volumeScrollDatas[4] = interpolateBetween(volumeScrollDatas[4], 0, 0, 17, 0, 0, (getTickCount() - volumeScrollDatas[2])/300, "Linear")
					else
						volumeScrollDatas[4] = interpolateBetween(volumeScrollDatas[4], 0, 0, 15, 0, 0, (getTickCount() - volumeScrollDatas[2])/300, "Linear")
					end
					dxDrawImage(phoneX+sx*0.0145+((phoneW-sx*0.03)*phones[activePhone]["notsound-volume"])-volumeScrollDatas[4]/2/myX*sx, phoneY+phoneH-sy*0.045-volumeScrollDatas[4]/2/myY*sy, volumeScrollDatas[4]/myX*sx, volumeScrollDatas[4]/myY*sy, "files/circle.png", 0, 0, 0, tocolor(129, 99, 191, 255))

					--dxDrawRectangle(phoneX+sx*0.0145, phoneY+phoneH-sy*0.045, phoneW-sx*0.03, sy*0.02)
					dxDrawText(math.floor(phones[activePhone]["notsound-volume"]*100).."%", phoneX+sx*0.0145, phoneY+phoneH-sy*0.045, phoneX+sx*0.0145+phoneW-sx*0.03, phoneY+phoneH-sy*0.045+sy*0.03, uiColors[phones[activePhone]["theme"]]["text"], 0.82/myX*sx, fonts["ui-medium-9"], "center", "center")
				elseif page == 16 then -- taxi
					dxDrawRectangle(phoneX+phoneW/13, phoneY+sy*0.01, phoneW-(phoneW/13*2), phoneH-sy*0.02, uiColors[phones[activePhone]["theme"]]["bg"])
					dxDrawText("Taxi", phoneX+sx*0.015, phoneY+sy*0.055, phoneX+sx*0.015+phoneW/2, phoneY+sy*0.055+sy*0.028, uiColors[phones[activePhone]["theme"]]["text-title"], 0.7/myX*sx, fonts["ui-heavy-15"], "left", "center")

					if isInSlot(phoneX+sx*0.015, phoneY+sy*0.038, phoneW/2, sy*0.02) then 
						dxDrawText("Vissza", phoneX+sx*0.015, phoneY+sy*0.038, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(129, 99, 191, 255), 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
					else
						dxDrawText("Vissza", phoneX+sx*0.015, phoneY+sy*0.038, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.038+sy*0.02, tocolor(39, 123, 209, 220), 0.8/myX*sx, fonts["ui-medium-9"], "left", "center")
					end

					--dxDrawImage(phoneX+ phoneW/2 - 50/myX*sx, phoneY+sy*0.08, 100/myX*sx, 100/myY*sy, "files/circle.png", 0, 0, 0, tocolor(39, 123, 209, 50))
					dxDrawText("Szabad taxik: ", phoneX, phoneY+sy*0.055, phoneX+phoneW, phoneY+sy*0.055+sy*0.075, uiColors[phones[activePhone]["theme"]]["text-title"], 0.8/myX*sx, fonts["ui-medium-15"], "center", "bottom")
					dxDrawText(availableTaxis, phoneX, phoneY+sy*0.055, phoneX+phoneW, phoneY+sy*0.055+sy*0.13, tocolor(235, 172, 63, 255), 0.65/myX*sx, fonts["ui-thin-30"], "center", "bottom")
				
					local taxiText = "Taxi hívása"

					if getElementData(localPlayer, "faction:taxi:isCalledTaxi") then 
						taxiText = "Taxi visszamondása"
					end

					if isInSlot(phoneX+sx*0.017, phoneY+sy*0.3, phoneW-sx*0.035, sy*0.03) then 
						dxDrawText(taxiText, phoneX+sx*0.017, phoneY+sy*0.3, phoneX+sx*0.017+phoneW-sx*0.035, phoneY+sy*0.3+sy*0.03, tocolor(235, 172, 63, 255), 0.95/myX*sx, fonts["ui-medium-15"], "center", "center")
					else
						dxDrawText(taxiText, phoneX+sx*0.017, phoneY+sy*0.3, phoneX+sx*0.017+phoneW-sx*0.035, phoneY+sy*0.3+sy*0.03, uiColors[phones[activePhone]["theme"]]["text-title"], 0.95/myX*sx, fonts["ui-medium-15"], "center", "center")
					end

					roundedRectangle(phoneX+sx*0.015, phoneY+sy*0.415, phoneW-sx*0.03, sy*0.03, uiColors[phones[activePhone]["theme"]]["bar"], uiColors[phones[activePhone]["theme"]]["bar"])
						dxDrawText("A taxis a hívásod koordinátáját\n kapja meg!", phoneX+sx*0.015, phoneY+sy*0.415, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.415+sy*0.03, tocolor(235, 172, 63, 255), 0.8/myX*sx, fonts["ui-medium-9"], "center", "center")

					roundedRectangle(phoneX+sx*0.015, phoneY+sy*0.45, phoneW-sx*0.03, sy*0.03, uiColors[phones[activePhone]["theme"]]["bar"], uiColors[phones[activePhone]["theme"]]["bar"])
						dxDrawText("Ameddig nem érkezik meg addig ne \n menj messzire!", phoneX+sx*0.015, phoneY+sy*0.45, phoneX+sx*0.015+phoneW-sx*0.03, phoneY+sy*0.45+sy*0.03, tocolor(235, 172, 63, 255), 0.8/myX*sx, fonts["ui-medium-9"], "center", "center")
				end

				if page >= 3 then 
					dxDrawText(time.hour..":"..time.minute, phoneX+sx*0.025, phoneY+sy*0.021, phoneX+sx*0.015+sx*0.017, phoneY+sy*0.021+sy*0.015, uiColors[phones[activePhone]["theme"]]["text-time"], 0.75/myX*sx, fonts["ui-medium-9"], "center", "center")
				end
			else
				dxDrawRectangle(phoneX+phoneW/13, phoneY+sy*0.01, phoneW-(phoneW/13*2), phoneH-sy*0.02, uiColors[phones[activePhone]["theme"]]["bg"])

				if phones[activePhone]["theme"] == "dark" then 
					dxDrawImage(phoneX+phoneW/2-50/myX*sx, phoneY+phoneH/2-70/myY*sy, 100/myX*sx, 100/myY*sy, "files/appleLogo_2.png", 0, 0, 0, tocolor(255, 255, 255, interpolateBetween(20, 0, 0, 255, 0, 0, (getTickCount()-tick)/5000, "CosineCurve")))
					dxDrawImage(phoneX+phoneW/2-50/myX*sx, phoneY+phoneH/2-70/myY*sy, 100/myX*sx, 100/myY*sy, "files/appleLogo_1.png")
				else
					dxDrawImage(phoneX+phoneW/2-50/myX*sx, phoneY+phoneH/2-70/myY*sy, 100/myX*sx, 100/myY*sy, "files/appleLogo_2.png", 0, 0, 0, tocolor(35, 35, 35, interpolateBetween(20, 0, 0, 255, 0, 0, (getTickCount()-tick)/5000, "CosineCurve")))
					dxDrawImage(phoneX+phoneW/2-50/myX*sx, phoneY+phoneH/2-70/myY*sy, 100/myX*sx, 100/myY*sy, "files/appleLogo_1.png", 0, 0, 0, tocolor(35, 35, 35, 255))
				end
			end

			dxDrawImage(phoneX, phoneY, phoneW, phoneH, "files/phone.png")
		end
	end
end	

local lastNewsAdd = 0
local lastIllegalNewsAdd = 0

local shiftState = false

local startMoveTimer = false

function clickPhone(key, state)

	if page == 2 then 
		if key == "mouse1" then 
			if sizeingPanel and state then
				local startY = phoneY+sizeingPanel[4]

				local panelWidth = sx*0.05
				local panelISMinus = false
				if phoneX+sizeingPanel[3]+sx*0.05 > phoneX+(phoneW-sx*0.01) then 
					panelWidth = 0-sx*0.05
					panelISMinus = true
				end

				for k, v in ipairs(extraAppTypes[sizeingPanel[2]]) do 
					local click = false 

					if panelISMinus then 
						if isInSlot(phoneX+sizeingPanel[3]-75/myX*sx, startY+1/myY*sy, 70/myX*sx, 20/myY*sy) then 
							click = true
						end
					else
						if isInSlot(phoneX+sizeingPanel[3]+5/myX*sx, startY+1/myY*sy, 70/myX*sx, 20/myY*sy) then 
							click = true
						end
					end

					if click then  -- KÉSZ, NE NYÚLJ HOZZÁ!!!!

						sizeingPanel[6] = "close"
						sizeingPanel[5] = getTickCount()
						sizeingPanel[8] = true

						setTimer(function()
							sizeingPanel = false
						end, 300, 1)

						local isSizeable = true

						--print(toJSON(sizeingPanel))

						local appSizeX, appSizeY = extraAppSizes[sizeingPanel[2]][k][1], extraAppSizes[sizeingPanel[2]][k][2]
						local row, column = getPositionInGrid(4, 7, sizeingPanel[1])


						--print(appSizeX, appSizeY)

						if appSizeY > 1 and appSizeX > 1 then 
							
							if appSizeX == 4 and appSizeY == 2 then
								
								if column > 1 or column == 0  then 
									isSizeable = false 
								end

								if row >= 7 then 
									isSizeable = false 
								end

								local size = sizeingPanel[1] + 7

								for k2, v2 in pairs(phones[activePhone]["apps"]) do 
									if k2 > sizeingPanel[1] and k2 < size then
										--print(k2)
										if v2 then 
											isSizeable = false 
											break
										end
									end
								end
							elseif appSizeX == 2 and appSizeY == 2 then 
								if column > 3 or column == 0 then 
									isSizeable = false 
								end

								if row >= 7 then 
									isSizeable = false 
								end

								for k2, v2 in pairs(phones[activePhone]["apps"]) do 
									if k2 == (sizeingPanel[1]+1) or k2 == (sizeingPanel[1]+4) or k2 == (sizeingPanel[1]+5) then
										if v2 then 
											isSizeable = false 
											break
										end
									end
								end
							end											
						end

						if isSizeable then
							phones[activePhone]["apps"][sizeingPanel[1]][2] = k
						end
					end

					startY = startY + 22/myY*sy
				end
				return
			end
			if state then 
				if not isTimer(startMoveTimer) then 
					startMoveTimer = setTimer(function()
						for k, v in pairs(gridPositions) do
							if phones[activePhone]["apps"][k] then 
								if type(phones[activePhone]["apps"][k]) == "table" then 
									if extraAppSizes[phones[activePhone]["apps"][k][1]] then 
										local appSizeX, appSizeY = unpack(extraAppSizes[phones[activePhone]["apps"][k][1]][phones[activePhone]["apps"][k][2]])
										if isInSlot(v[1]+((6/appSizeX)/myX*sx*appSizeX), v[2]+(6/appSizeY)/myY*sy, (v[3]-(12/appSizeX)/myX*sx)*appSizeX,( v[4]-(12/appSizeY)/myY*sy)*appSizeY) then 
											local cX, cY = getCursorPosition()
											cX, cY = cX*sx, cY*sy
		
											--movedApp = {k, phones[activePhone]["apps"][k], v[1]-cX, v[2]-cY}
											--phones[activePhone]["apps"][k] = false 
										end
									end
								else
									if isInSlot(v[1], v[2], v[3], v[4]) then 
										local cX, cY = getCursorPosition()
										cX, cY = cX*sx, cY*sy
	
										--movedApp = {k, phones[activePhone]["apps"][k], v[1]-cX, v[2]-cY}
										--phones[activePhone]["apps"][k] = false										
									end
								end			
							end
						end
					end, 300, 1)
				end
			else
				if isTimer(startMoveTimer) then 
					killTimer(startMoveTimer) 

					for k, v in pairs(gridPositions) do 
						if phones[activePhone]["apps"][k] then 
							if type(phones[activePhone]["apps"][k]) == "table" then 
								if extraAppSizes[phones[activePhone]["apps"][k][1]] then 
									local appSizeX, appSizeY = unpack(extraAppSizes[phones[activePhone]["apps"][k][1]][phones[activePhone]["apps"][k][2]])
									if isInSlot(v[1]+((6/appSizeX)/myX*sx*appSizeX), v[2]+(6/appSizeY)/myY*sy, (v[3]-(12/appSizeX)/myX*sx)*appSizeX,( v[4]-(12/appSizeY)/myY*sy)*appSizeY) then 
										if phones[activePhone]["apps"][k] == 11 or phones[activePhone]["apps"][k] == 12 then
											if not exports.Pdash:isPlayerInGroup(player, 1) then 
												--page = phones[activePhone]["apps"][k][1]
											end
										else
											page = phones[activePhone]["apps"][k][1]
										end
									end
								end
							else
								if isInSlot(v[1], v[2], v[3], v[4]) then 
									if phones[activePhone]["apps"][k] == 11 or phones[activePhone]["apps"][k] == 12 then
										if not exports.Pdash:isPlayerInGroup(player, 1) then 
											--page = phones[activePhone]["apps"][k]
										end
									else
										page = phones[activePhone]["apps"][k]
									end
								end
							end			
						end
					end
					
					return 
				end
				if movedApp then 
					if not isInSlot(phoneX, phoneY, phoneW, phoneH) then 
						phones[activePhone]["apps"][movedApp[1]] = movedApp[2]
					else
						for k, v in pairs(gridPositions) do 
							if isInSlot(v[1], v[2], v[3], v[4]) then 
								if not phones[activePhone]["apps"][k] then 
									local isPlaceable = true 

									if type(movedApp[2]) == "table" then -- EZ KÉSZ + NE ÍRD ÁT!!!!!
										local appSizeX, appSizeY = extraAppSizes[movedApp[2][1]][movedApp[2][2]][1], extraAppSizes[movedApp[2][1]][movedApp[2][2]][2]

										if appSizeY > 1 and appSizeX > 1 then 
											
											if appSizeX == 4 and appSizeY == 2 then 
												local size = k + 7

												for k2, v2 in pairs(phones[activePhone]["apps"]) do 
													if k2 >= k and k2 <= size then
														if v2 then 
															isPlaceable = false 
															break
														end
													end
												end
											elseif appSizeX == 2 and appSizeY == 2 then 
												for k2, v2 in pairs(phones[activePhone]["apps"]) do 
													if k2 == k or k2 == (k+1) or k2 == (k+5) or k2 == (k+6) then
														if v2 then 
															isPlaceable = false 
															break
														end
													end
												end
											end											
										end
									else	-- EZ KÉSZ + NE ÍRD ÁT!!!!!									
										for i = 1, 7 do 
											if phones[activePhone]["apps"][k-i] then 
												if type(phones[activePhone]["apps"][k-i]) == "table" then 
													local appSizeX, appSizeY = unpack(extraAppSizes[phones[activePhone]["apps"][k-i][1]][phones[activePhone]["apps"][k-i][2]])

													local row, column = getPositionInGrid(4, 7, k-i)
													local row2, column2 = getPositionInGrid(4, 7, k) 

													--print("POS: "..k-i, appSizeX, appSizeY)

													if appSizeX == 4 and appSizeY == 2 then 
														if k >= k-i and k <= (k-i) + 7 then 
															isPlaceable = false 
															break 
														end
													elseif appSizeX == 2 and appSizeY == 2 then 
														if k == k-i or k == (k-i) + 1 or k == (k-i) + 4 or k == (k-i) + 5 then 
															isPlaceable = false 
														end
													end

												
													break
												end
											end
										end
									end

									if isPlaceable then 
										phones[activePhone]["apps"][k] = movedApp[2]
										movedApp = false 
										return
									else
										phones[activePhone]["apps"][movedApp[1]] = movedApp[2]
									end
								end
							end
						end

						phones[activePhone]["apps"][movedApp[1]] = movedApp[2]
					end
					movedApp = false 
				end
			end
		--elseif key == "mouse2" and state then 
		--	if isTimer(startMoveTimer) then 
		--		killTimer(startMoveTimer) 
		--	end

		--	for k, v in pairs(gridPositions) do 
		--		if phones[activePhone]["apps"][k] then 
		--			if type(phones[activePhone]["apps"][k]) == "table" then 
		--				if extraAppSizes[phones[activePhone]["apps"][k][1]] then 
		--					local appSizeX, appSizeY = unpack(extraAppSizes[phones[activePhone]["apps"][k][1]][phones[activePhone]["apps"][k][2]])
		--					if isInSlot(v[1]+((6/appSizeX)/myX*sx*appSizeX), v[2]+(6/appSizeY)/myY*sy, (v[3]-(12/appSizeX)/myX*sx)*appSizeX,( v[4]-(12/appSizeY)/myY*sy)*appSizeY) then 
		--						if sizeingPanel then 
		--							if sizeingPanel[8] then return end
		--							sizeingPanel[6] = "close"
		--							sizeingPanel[5] = getTickCount()
		--							sizeingPanel[8] = true

		--							setTimer(function()
		--								sizeingPanel = false

										
		--								local cX, cY = getCursorPosition()
		--								cX, cY = cX*sx, cY*sy
		--								sizeingPanel = {k, phones[activePhone]["apps"][k][1], cX-phoneX, cY-phoneY, getTickCount(), "open", 0, true}
		--							end, 300, 1)
								
		--							return
		--						end
							
		--						local cX, cY = getCursorPosition()
		--						cX, cY = cX*sx, cY*sy
		--						sizeingPanel = {k, phones[activePhone]["apps"][k][1], cX-phoneX, cY-phoneY, getTickCount(), "open", 0, true}
		--						return
		--					end
		--				end
		--			end			
		--		end
		--	end

		--	if sizeingPanel then 
		--		sizeingPanel[6] = "close"
		--		sizeingPanel[5] = getTickCount()
		--		sizeingPanel[8] = true

		--		setTimer(function()
		--			sizeingPanel = false
		--		end, 300, 1)
		--	end
		end
	end

	if state then 
		if key == "lshift" or key == "rshift" then 
			shiftState = true
		end

		if key == "mouse_wheel_up" then 
			if page == 3 then -- kontaktok
				if contactState == 1 then
					if contactPointer > 0 then
						contactPointer = contactPointer - 1
					end  
				end
 
			elseif page == 14 then 
				if smsPointer > 0 then 
					smsPointer = smsPointer - 1
				end
			end
		end

		if key == "mouse_wheel_down" then 
			if page == 3 then -- kontaktok
				if contactState == 1 then
					if phones[activePhone]["contacts"][8+contactPointer] then
						contactPointer = contactPointer + 1
					end  
				end

			elseif page == 14 then 
				if smsState == 1 then
					local tableRealDataCount = 0
					for k, v in pairs(phoneMessages[tonumber(activePhone)]) do 
						tableRealDataCount = tableRealDataCount + 1
					end

					if smsPointer + 8 < tableRealDataCount then 
						smsPointer = smsPointer + 1
					end
				elseif smsState == 2 then 
					if phoneMessages[tonumber(activePhone)][openedMessagePage].messages[6 + smsPointer] then 
						smsPointer = smsPointer + 1
					end
				end 

			end
		end

		if key == "enter" then 
			if page == 14 then 
				if smsState == 2 then 
					if activeEditbox == "sms" then 
						if #editboxs["sms"] >= 5 then 
							activeEditbox = false
							local time = getRealTime()
							local hours = time.hour
							local minutes = time.minute
							local seconds = time.second
							local date = string.format("%04d-%02d-%02d %02d:%02d", time.year, time.month, time.monthday, time.hour, time.minute)
							triggerServerEvent("phone > sendSMS", resourceRoot, openedMessagePage, editboxs["sms"], date, activePhone)

							editboxs["sms"] = ""
							usedGPSButton = false

						--	Pinfobox:addNotification("Az SMS továbbítása folyamatban van!", "success")

							smsPointer = smsPointer + 1
						else
							Pinfobox:addNotification("Az SMS-nek minimum 5 karakterből kell állnia!", "error")
						end
					end
				end
			end
		end

		if key == "mouse1" then --KATTINTÁS GECI KURVA ANYÁD
			if page == 1 then -- kezdő
				if isInSlot(phoneX+50, phoneY+310, phoneW-100, phoneH-330) then 
					page = 2
				end
			elseif page == 2 then -- főoldal
				local startX = phoneX+sx*0.017
				for i = 1, 4 do 
					if isInSlot(startX, phoneY+phoneH-sy*0.015*5, sx*0.025, (sy*0.015*3)) then 
						if i == 1 then -- kontaktok --kattintás genyó
							contactState = 1
							contactPointer = 0
							page = 3 --- ide 3-at kell írni, hogy a kontatokthoz basszon.
							--Pinfobox:addNotification("Ez a funkció nem elérhető!", "error")
						elseif i == 2 then -- telefon
							page = 7 --7es kell ide
						elseif i == 3 then -- sms
							page = 14 ---14es kell ide a page miatt --2es ha nem megy a funkció
							--Pinfobox:addNotification("Ez a funkció nem elérhető!", "error")
							smsPointer = 0
						elseif i == 4 then -- beállítások
							page = 4 ---4es kell ide a page miatt
							--Pinfobox:addNotification("Ez a funkció nem elérhető!", "error")
						end
					end
					startX = startX + sx*0.0285
				end

				--[[if isInSlot(phoneX+sx*0.015, phoneY+sy*0.04, sx*0.0285, sy*0.07) then 
					page = 10
				end]]
			elseif page == 3 then -- kontaktok
				if contactState == 1 then 
					if isInSlot(phoneX+sx*0.02, phoneY+sy*0.450, phoneW/2, sy*0.02) then 
						page = 2
					end

					if isInSlot(phoneX+sx*0.02, phoneY+sy*0.410, phoneW/2, sy*0.02) then 
						contactState = 2

						editboxs = {
							["addContact-name"] = "",
							["addContact-phone"] = "",
						}
					end
				elseif contactState == 2 then 
					if isInSlot(phoneX+sx*0.02, phoneY+sy*0.450, phoneW/2, sy*0.02) then  
						contactState = 1
					end

					if isInSlot(phoneX+sx*0.015, phoneY+sy*0.225, sx*0.1, sy*0.03) then 
						activeEditbox = "addContact-name"
					elseif isInSlot(phoneX+sx*0.015, phoneY+sy*0.26, sx*0.1, sy*0.03) then 
						activeEditbox = "addContact-phone"
					else 
						activeEditbox = false
					end

					if isInSlot(phoneX+sx*0.02, phoneY+sy*0.410, phoneW/2, sy*0.02) then 
						if string.len(editboxs["addContact-name"]) > 0 and string.len(editboxs["addContact-phone"]) > 0 then 
							table.insert(phones[activePhone]["contacts"], {editboxs["addContact-name"], editboxs["addContact-phone"], 1})
							contactState = 1
						end
					end
				end
			elseif page == 4 then -- beállítások
				if isInSlot(phoneX+sx*0.013, phoneY+sy*0.0295, sx*0.05, sy*0.02) then 
					page = 2
				end

				local startY = phoneY+sy*0.09
				for k, v in ipairs(options) do 
					if isInSlot(phoneX+sx*0.0145, startY, phoneW-sx*0.03, phoneH/12) then
						if v.name == "Háttérkép" then 
							page = 5
							optionBG = phones[activePhone]["bg"]
						elseif v.name == "Csengőhang" then 
							page = 6
						elseif v.name == "Értesítési hang" then 
							page = 15
						elseif v.name == "Biztonság" then 
							page = 13
						elseif v.name == "Dark Mode" then 
							if phones[activePhone]["theme"] == "dark" then 
								phones[activePhone]["theme"] = "light"
							else
								phones[activePhone]["theme"] = "dark"
							end
						end
					end
					startY = startY + phoneH/12 + sy*0.005
				end
			elseif page == 5 then 
				if isInSlot(phoneX+sx*0.013, phoneY+phoneH/2-25/myY*sy, 40/myX*sx, 40/myY*sy) then
					if optionBG > 1 then 
						optionBG = optionBG - 1
					end
				end

				if isInSlot(phoneX+phoneW-sx*0.037, phoneY+phoneH/2-25/myY*sy, 40/myX*sx, 40/myY*sy) then 
					if fileExists("files/backgrounds/"..(optionBG+1)..".png") then 
						optionBG = optionBG + 1
					end
				end

				if isInSlot(phoneX+sx*0.005, phoneY+phoneH-sy*0.055, phoneW-sx*0.01, sy*0.03) then 
					phones[activePhone]["bg"] = optionBG
				end

				if isInSlot(phoneX+sx*0.015, phoneY+sy*0.038, phoneW/2, sy*0.02) then 
					page = 4
				end
			elseif page == 6 then 
				if isInSlot(phoneX+sx*0.015, phoneY+sy*0.038, phoneW/2, sy*0.02) then 
					page = 4
					if isElement(showingRingstone) then 
						destroyElement(showingRingstone)
					end
				end

				local startY = phoneY+sy*0.09
				for i = 1, 12 do 
					if fileExists("files/ringstones/"..i..".mp3") then 
						if isInSlot(phoneX+sx*0.0145, startY, phoneW-sx*0.03-30/myX*sx, sy*0.025) then 
							phones[activePhone]["ringstone"] = i 

							if isElement(showingRingstone) then 
								destroyElement(showingRingstone)
							end
						end

						if isInSlot(phoneX+phoneW-sx*0.03, startY+sy*0.004+1/myY*sy, 15/myX*sx, 15/myY*sy) then 
							if isElement(showingRingstone) then 
								destroyElement(showingRingstone)
							end

							showingRingstone = playSound("files/ringstones/"..i..".mp3")
							setSoundVolume(showingRingstone, 5*phones[activePhone]["ringstone-volume"])
						end

						startY = startY + sy*0.03
					end
				end

			elseif page == 7 then -- Hívás
				if isInSlot(phoneX+sx*0.02, phoneY+sy*0.450, phoneW/2, sy*0.02) then 
					page = 2
				end

				local startX = phoneX+sx*0.0225
				local startY = phoneY+sy*0.14

				for i = 1, 12 do 
					if isInSlot(startX, startY, 50/myX*sx, 50/myY*sy) then 
						if i == 10 then 
							numberText = tostring(numberText):gsub("[^\128-\191][\128-\191]*$", "")
						else
							if string.len(tostring(numberText)) < 11 then 
								if type(phoneButtonTexts[i]) == "number" then 
									numberText = numberText .. phoneButtonTexts[i]
								end
							end
						end
					end

					startX = startX + sx*0.035
					if i % 3 == 0 then 
						startX = phoneX+sx*0.0225
						startY = startY + sy*0.065
					end
				end

				if isInSlot(phoneX+sx*0.01, phoneY+sy*0.410, phoneW/2, sy*0.02) then
					if string.len(tostring(numberText)) >= 3 then 
						startCalling(numberText)
		                exports.Pchat:takeMessage("me","felhív valakit.")
						--chat:sendLocalMeAction("felhív valakit.")
					end
				end

				if isInSlot(phoneX+sx*0.1, phoneY+sy*0.1, 20/myX*sx, 20/myY*sy) then 
					numberText = tostring(numberText):gsub("[^\128-\191][\128-\191]*$", "")
				end
			elseif page == 8 then -- Hívás folyamatban
				if callingState == 1 then 
					if isInSlot(phoneX+phoneW/2-25/myX*sx, phoneY+phoneH-sy*0.15, 50/myX*sx, 50/myY*sy) then 
						triggerServerEvent("phone > dismissCalling", resourceRoot, talkingPlayer)
						talkingPlayer = false
						page = 2
						callingState = 1

						if isElement(sound) then 
							destroyElement(sound)
						end

						if isTimer(callTimer) then 
							killTimer(callTimer)
						end

						if isTimer(callingTimer) then 
							killTimer(callingTimer)
						end
						phones[activePhone]["calls"][lastLogIndex][3] = 3
		                exports.Pchat:takeMessage("me","letette a telefont.")
						--chat:sendLocalMeAction("letette a telefont.")
					end
				elseif callingState == 2 then 
					if isInSlot(phoneX+phoneW/2-75/myX*sx, phoneY+phoneH-sy*0.15, 50/myX*sx, 50/myY*sy) then 
						triggerServerEvent("phone > dismissCalling", resourceRoot, talkingPlayer)
						talkingPlayer = false
						page = 2
						callingState = 1

						if isElement(sound) then 
							destroyElement(sound)
						end

						if isTimer(callTimer) then 
							killTimer(callTimer)
						end

						if isTimer(callingTimer) then 
							killTimer(callingTimer)
						end
						phones[activePhone]["calls"][lastLogIndex][3] = 3
		                exports.Pchat:takeMessage("me","letette a telefont.")
						--chat:sendLocalMeAction("letette a telefont.")
					end

					if isInSlot(phoneX+phoneW/2+25/myX*sx, phoneY+phoneH-sy*0.15, 50/myX*sx, 50/myY*sy) then 
						triggerServerEvent("phone > acceptCalling", resourceRoot, talkingPlayer)
						callingState = 3

						startTimeCounting()
						if isElement(sound) then 
							destroyElement(sound)
						end
						phones[activePhone]["calls"][lastLogIndex][3] = 1
		                exports.Pchat:takeMessage("me","felvette a telefont.")
						--chat:sendLocalMeAction("felvette a telefont.")
					end
				elseif callingState == 3 then  
					if isCalled911 then 
						local startY = phoneY+sy*0.12
						for k, v in ipairs(Menus911) do 
							if isInSlot(phoneX+sx*0.015, startY, phoneW-sx*0.03, sy*0.04) then 
								talkingPlayer = false
								page = 2
								callingState = 1

								if isElement(sound) then 
									destroyElement(sound)
								end

								if isTimer(callTimer) then 
									killTimer(callTimer)
								end

								if isTimer(callingTimer) then 
									killTimer(callingTimer)
								end
								phones[activePhone]["calls"][lastLogIndex][3] = 2
								--chat:sendLocalMeAction("letette a telefont.")
		                exports.Pchat:takeMessage("me","letette a telefont.")

								Pinfobox:addNotification("Sikeresen értesítetted a(z) "..v[1].."-t.", "success")
								triggerServerEvent("create911call",localPlayer,localPlayer,v[2])
							end
							startY = startY + (sy*0.05)
						end
					else
						if isInSlot(phoneX+sx*0.0145, phoneY+phoneH-sy*0.13, phoneW-sx*0.03, sy*0.04) then 
							activeEditbox = "phone-calling"
						else
							activeEditbox = false
						end

						if isInSlot(phoneX+sx*0.115, phoneY+phoneH-sy*0.13+9/myX*sx, 15/myX*sx, 15/myY*sy) then 
							if string.len(editboxs["phone-calling"]) > 0 then 
								triggerServerEvent("phone > sendMessage", resourceRoot, editboxs["phone-calling"], talkingPlayer)

								if #talkingTexts >= 6 then 
									table.remove(talkingTexts, 1)
								end
								table.insert(talkingTexts, {editboxs["phone-calling"], 2})

								editboxs["phone-calling"] = ""
							end
						end
					end

					if isInSlot(phoneX+phoneW/2-25/myX*sx, phoneY+phoneH-sy*0.08, 50/myX*sx, 50/myY*sy) then 
						if not isCalled911 then 
							triggerServerEvent("phone > dismissCalling", resourceRoot, talkingPlayer)
						end

						talkingPlayer = false
						page = 2
						callingState = 1

						if isElement(sound) then 
							destroyElement(sound)
						end

						if isTimer(callTimer) then 
							killTimer(callTimer)
						end

						if isTimer(callingTimer) then 
							killTimer(callingTimer)
						end
						phones[activePhone]["calls"][lastLogIndex][3] = 2
		                exports.Pchat:takeMessage("me","letette a telefont.")
						--chat:sendLocalMeAction("letette a telefont.")
						editboxs["phone-calling"] = ""
					end
				end
			elseif page == 9 then 
				if isInSlot(phoneX+sx*0.013, phoneY+sy*0.035, sx*0.05, sy*0.02) then 
					page = 7
				end

				if isInSlot(phoneX+sx*0.07, phoneY+sy*0.038, phoneW/2, sy*0.02) then 
					phones[activePhone]["calls"] = {}
				end
			elseif page == 10 then -- Hírdetés
				if isInSlot(phoneX+sx*0.02, phoneY+sy*0.450, phoneW/2, sy*0.02) then 
					editboxs["addNews-text"] = ""
					page = 2
				end

				if isInSlot(phoneX+sx*0.0145, phoneY+sy*0.09, phoneW-sx*0.03, sy*0.2) then 
					activeEditbox = "addNews-text"
				else
					activeEditbox = false
				end

				if isInSlot(phoneX+sx*0.01, phoneY+sy*0.410, phoneW/2, sy*0.02) then 
					if getElementData(localPlayer, "player:money") >= 150 then 
						if string.len(editboxs["addNews-text"]) >= 3 then 
							if lastNewsAdd + 300000 <= getTickCount() then 
								lastNewsAdd = getTickCount()
								if phones[activePhone]["phoneNumber-showing"] then 
									triggerServerEvent("phone > addNews", resourceRoot, editboxs["addNews-text"], activePhone)
								else
									triggerServerEvent("phone > addNews", resourceRoot, editboxs["addNews-text"], 0)
								end
								editboxs["addNews-text"] = ""
								Pinfobox:addNotification("Sikeresen feladtál egy hírdetést!", "success")
							else
								Pinfobox:addNotification("Csak 5 percenként adhatsz fel hírdetést!", "warning")
							end
						else
							Pinfobox:addNotification("A hírdetésednek minimum 3 karakterből kell állnia!", "error")
						end
					else
						Pinfobox:addNotification("Nincs elegendő pénzed a hírdetés feladásához! (150$)", "error")
					end
				end
			elseif page == 11 then -- Időjárás
				if isInSlot(phoneX+sx*0.015, phoneY+sy*0.038, phoneW/2, sy*0.02) then 
					page = 2
				end
			elseif page == 12 then -- DW Hírdetés

				if isInSlot(phoneX+sx*0.013, phoneY+sy*0.035, sx*0.05, sy*0.02) then 
					page = 2
					editboxs["addNews-text"] = ""
				end

				if isInSlot(phoneX+sx*0.0145, phoneY+sy*0.33, phoneW-sx*0.03, sy*0.15) then 
					activeEditbox = "addNews-text"
				else
					activeEditbox = false
				end

				if isInSlot(phoneX+sx*0.0155, phoneY+sy*0.312, phoneW/2-sx*0.03, sy*0.015) then 
					if getElementData(localPlayer, "player:money") >= 375 then 
						if string.len(editboxs["addNews-text"]) >= 10 then 
							if lastIllegalNewsAdd + 300000 <= getTickCount() then 
								lastIllegalNewsAdd = getTickCount()
								if phones[activePhone]["phoneNumber-showing"] then 
									triggerServerEvent("phone > addNews", resourceRoot, editboxs["addNews-text"], activePhone, "dw")
								else
									triggerServerEvent("phone > addNews", resourceRoot, editboxs["addNews-text"], 0, "dw")
								end
								editboxs["addNews-text"] = ""
								Pinfobox:outputPinfobox("Sikeresen feladtál egy hírdetést!", "success")
							else
								Pinfobox:outputPinfobox("Csak 5 percenként adhatsz fel hírdetést!", "warning")
							end
						else
							Pinfobox:outputPinfobox("A hírdetésednek minimum 10 karakterből kell állnia!", "error")
						end
					else
						Pinfobox:outputPinfobox("Nincs elegendő pénzed a hírdetés feladásához! (375$)", "error")
					end
				end
			elseif page == 13 then 
				if isInSlot(phoneX+sx*0.013, phoneY+sy*0.035, sx*0.05, sy*0.02) then 
					page = 4
				end

				if isInSlot(phoneX+sx*0.11, phoneY+sy*0.17+sy*0.115, 30/myX*sx, 30/myY*sy) then
					phones[activePhone]["sharePhoneUseingDatas"] = not phones[activePhone]["sharePhoneUseingDatas"]
				end

				if isInSlot(phoneX+sx*0.11, phoneY+sy*0.17, 30/myX*sx, 30/myY*sy) then
					phones[activePhone]["phoneNumber-showing"] = not phones[activePhone]["phoneNumber-showing"]
				end
			elseif page == 14 then -- SMS
				if isInSlot(phoneX+sx*0.02, phoneY+sy*0.450, phoneW/2, sy*0.02) then 
					if smsState == 1 then
						page = 2
					elseif smsState == 2 then
						smsState = 1
						smsPointer = 0
					elseif smsState == 3 then
						smsState = 1
						smsPointer = 0
					end
				end

				if smsState == 1 then
					if phoneMessages[tonumber(activePhone)] then
						local startY = phoneY+sy*0.085
						local renderedItemCount = 0
						local newItemNum = 0
						for k, v in pairs(phoneMessages[tonumber(activePhone)]) do
							newItemNum = newItemNum + 1
							if newItemNum > smsPointer then
								if renderedItemCount < 8 then
									if isInSlot(phoneX+sx*0.0145, startY, phoneW-sx*0.03, phoneH/12) then 
										smsState = 2
										openedMessagePage = k
										smsPointer = #v.messages - 5
	
										v.read = true
									end
							
									renderedItemCount = renderedItemCount + 1

									startY = startY + phoneH/12 + sy*0.005
								end
							end
						end
					end

					if isInSlot(phoneX+sx*0.01, phoneY+sy*0.410, phoneW/2, sy*0.02) then 
						smsState = 3
						usedGPSButton = false

						editboxs["sms-phoneNumber"] = ""
						editboxs["sms-message"] = ""
					end
				elseif smsState == 2 then 
					if isInSlot(phoneX+sx*0.0145, phoneY+sy*0.41, phoneW-sx*0.03, sy*0.07) then 
						--if not usedGPSButton then 
							activeEditbox = "sms"
						--end
					else
						activeEditbox = false
					end

				--	if isInSlot(phoneX+sx*0.115, phoneY+sy*0.413, sx*0.013, sy*0.02) then
				--		if not usedGPSButton then
				--			if getElementDimension(localPlayer) == 0 then  
				--				usedGPSButton = true 
				--				--activeEditbox = false
				--				local posX, posY, posZ = getElementPosition(localPlayer)
				--				editboxs["sms"] = "(GPS): "..posX .. ", "..posY
				--			else
				--				outputChatBox(core:getServerPrefix("red-dark", "Telefon", 2).."Interiorban nem küldhetsz GPS koordinátát!", 255, 255, 255, true)
				--				Pinfobox:outputPinfobox("Interiorban nem küldhetsz GPS koordinátát!", "error")
				--			end
				--		end
				--	end

					local startY = phoneY + sy*0.095
					for i = 1, 5 do
						local v = phoneMessages[tonumber(activePhone)][openedMessagePage].messages [i + smsPointer] 

						if v then 
							local startX = phoneX+sx*0.02

							if v[3] then 
								startX = startX + sx*0.025
							end

						--	if isInSlot(startX, startY, sx*0.08, sy*0.048) then 
						--		if string.match(v[2], "GPS") then
						--			if getElementDimension(localPlayer) == 0 and getElementInterior(localPlayer) == 0 then 
						--				if getPedOccupiedVehicle(localPlayer) then
						--					Pinfobox:outputPinfobox("Sikeresen beállítottad a GPS-t a megadott koordinátára!", "success")
						--			        outputChatBox(core:getServerPrefix("green-dark", "Telefon", 2).."Beállítottad a GPS-t a megadott koordinátára!", 255, 255, 255, true)

						--					local firstVesszo = string.find(v[2], ",", 2)
						--					--print(firstVesszo)
						--					local posX, posY = string.sub(v[2], 8, firstVesszo-1), string.sub(v[2], firstVesszo+2, 99):gsub(",", "")
						--					--print(posX, posY)

						--					setElementData(getPedOccupiedVehicle(localPlayer), "gpsDestination", {tonumber(posX), tonumber(posY)})
						--				end
						--			end 
						--		end
						--	end

						--	startY = startY + sy*0.065
						end
					end
				elseif smsState == 3 then 
					if isInSlot(phoneX+sx*0.015, phoneY+sy*0.225, sx*0.1, sy*0.03) then 
						activeEditbox = "sms-phoneNumber"
					elseif isInSlot(phoneX+sx*0.015, phoneY+sy*0.26, sx*0.095, sy*0.085) then
						activeEditbox = "sms-message" 
					else
						activeEditbox = false
					end

					if isInSlot(phoneX+sx*0.017, phoneY+sy*0.4, phoneW-sx*0.035, sy*0.03) then 
						if #editboxs["sms-phoneNumber"] >= 5 then 
							if #editboxs["sms-message"] >= 5 then 
								activeEditbox = false
								usedGPSButton = false

								local time = getRealTime()
								local hours = time.hour
								local minutes = time.minute
								local seconds = time.second
								local date = string.format("%04d-%02d-%02d %02d:%02d", time.year, time.month, time.monthday, time.hour, time.minute)
								triggerServerEvent("phone > sendSMS", resourceRoot, editboxs["sms-phoneNumber"], editboxs["sms-message"], date, activePhone)

								editboxs["sms-phoneNumber"] = ""
								editboxs["sms-message"] = ""

								smsState = 1
							else
								Pinfobox:outputPinfobox("Az üzenetnek minimum 5 karakterből kell állnia!", "error")
							end
						else
							Pinfobox:outputPinfobox("Nem megfelelő a telefonszám!", "error")
						end
					end

				--	if isInSlot(phoneX+sx*0.112, phoneY+sy*0.26, sx*0.013, sy*0.02) then
				--		if not usedGPSButton then
				--			if getElementDimension(localPlayer) == 0 then  
				--				usedGPSButton = true 
				--				--activeEditbox = false
				--				local posX, posY, posZ = getElementPosition(localPlayer)
				--				editboxs["sms-message"] = "(GPS): "..posX .. ", "..posY
				--			else
				--				outputChatBox(core:getServerPrefix("red-dark", "Telefon", 2).."Interiorban nem küldhetsz GPS koordinátát!", 255, 255, 255, true)
				--				Pinfobox:outputPinfobox("Interiorban nem küldhetsz GPS koordinátát!", "error")
				--			end
				--		end
				--	end
				end
			elseif page == 15 then -- értesítési hang beállítása
				if isInSlot(phoneX+sx*0.015, phoneY+sy*0.038, phoneW/2, sy*0.02) then 
					page = 4
					if isElement(showingRingstone) then 
						destroyElement(showingRingstone)
					end
				end

				local startY = phoneY+sy*0.09
				for i = 1, 12 do 
					if fileExists("files/notsounds/"..i..".mp3") then 
						if isInSlot(phoneX+sx*0.0145, startY, phoneW-sx*0.03-30/myX*sx, sy*0.025) then 
							phones[activePhone]["notsound"] = i 

							if isElement(showingRingstone) then 
								destroyElement(showingRingstone)
							end
						end

						if isInSlot(phoneX+phoneW-sx*0.03, startY+sy*0.004+1/myY*sy, 15/myX*sx, 15/myY*sy) then 
							if isElement(showingRingstone) then 
								destroyElement(showingRingstone)
							end

							showingRingstone = playSound("files/notsounds/"..i..".mp3")
							setSoundVolume(showingRingstone, 5*phones[activePhone]["notsound-volume"])
						end

						startY = startY + sy*0.03
					end
				end
			elseif page == 16 then 
				if isInSlot(phoneX+sx*0.015, phoneY+sy*0.038, phoneW/2, sy*0.02) then 
					page = 2
				end

				if isInSlot(phoneX+sx*0.017, phoneY+sy*0.3, phoneW-sx*0.035, sy*0.03) then 
					if lastTaxiInteraction + 1000 < getTickCount() then
						if exports.oFactionScripts:makeTaxiCall() then
							lastTaxiInteraction = getTickCount()
						end
					end
				end
			end
		end

		if activeEditbox then 
			if isCursorShowing() then 
				cancelEvent()
				key = tostring(key:gsub("num_", ""))

				if customKeys[key] then 
					key = customKeys[key]
				end

				if tiltottgombok[key] then 
					if customKeys[key] then 
						key = customKeys[key]
					else
						if key == "backspace" then 
							if activeEditbox == "sms" or activeEditbox == "sms-message" then 
								if usedGPSButton then 
									editboxs[activeEditbox] = ""
									usedGPSButton = false
								else
									backspaceTimer = setTimer(function() 
										if activeEditbox then 
											editboxs[activeEditbox] = tostring(editboxs[activeEditbox])
											editboxs[activeEditbox] = editboxs[activeEditbox]:gsub("[^\128-\191][\128-\191]*$", "")
										end
									end, 50, 0)
								end
							else
								backspaceTimer = setTimer(function() 
									if activeEditbox then 
										editboxs[activeEditbox] = tostring(editboxs[activeEditbox])
										editboxs[activeEditbox] = editboxs[activeEditbox]:gsub("[^\128-\191][\128-\191]*$", "")
									end
								end, 50, 0)
							end
						elseif key == "space" then 
							if activeEditbox == "sms" or activeEditbox == "sms-message" then 
								if usedGPSButton then return end
							end

							editboxs[activeEditbox] = editboxs[activeEditbox] .. " "
						elseif key == "enter" then 
							if activeEditbox == "phone-calling" then 
								if string.len(editboxs["phone-calling"]) > 0 then 
									triggerServerEvent("phone > sendMessage", resourceRoot, editboxs["phone-calling"], talkingPlayer)
	
									if #talkingTexts >= 5 then 
										table.remove(talkingTexts, 1)
									end
									table.insert(talkingTexts, {editboxs["phone-calling"], 2})
	
									editboxs["phone-calling"] = ""
								end
							end
						end
						return
					end
				end

				if activeEditbox == "sms" or activeEditbox == "sms-message" then 
					if usedGPSButton then return end
				end

				if shiftState then 
					key = string.upper(key)

					if hungarianBigLetters[key] then 
						key = hungarianBigLetters[key]
					end

					if shiftKeys[tostring(key)] then 
						key = shiftKeys[tostring(key)]
					end
				end

				if getKeyState("ralt") then 
					if altgrKeys[tostring(key)] then 
						key = altgrKeys[tostring(key)]
					end
				end

				if activeEditbox == "addContact-phone" or activeEditbox == "sms-phoneNumber" then 
					if not (tonumber(key)) then 
						return
					end
				end

				local maxcount = 21
				if activeEditbox == "addContact-phone" then 
					maxcount = 21 
				elseif activeEditbox == "addNews-text" then 
					maxcount = 200
				elseif activeEditbox == "phone-calling" then 
					maxcount = 60
				elseif activeEditbox == "sms" then 
					maxcount = 65
				elseif activeEditbox == "sms-phoneNumber" then 
					maxcount = 20
				elseif activeEditbox == "sms-message" then 
					maxcount = 65
				else
					maxcount = 30
				end

				if string.len(editboxs[activeEditbox]) < maxcount then 
					editboxs[activeEditbox] = editboxs[activeEditbox] .. key
				end
			end
		end
	else
		if key == "lshift" or key == "rshift" then 
			shiftState = false
		end

		if key == "backspace" then 
			if isTimer(backspaceTimer) then 
				killTimer(backspaceTimer)
			end
		end
	end
end

local lastPhoneVisibleSet = 0
function setPhoneVisible(phoneNumber)
	if lastPhoneVisibleSet + 500 < getTickCount() then 
		lastPhoneVisibleSet = getTickCount()
		if phoneShow then 
			exports["Pchat"]:takeMessage("me","elrakott egy telefont.")
			--chat:sendLocalMeAction("elrakott egy telefont.")
			removeEventHandler("onClientRender", root, drawPhone)
			removeEventHandler("onClientKey", root, clickPhone)
			phoneShow = false
			activePhone = false

			if talkingPlayer then 
				triggerServerEvent("phone > dismissCalling", resourceRoot, talkingPlayer)
				talkingPlayer = false
				page = 2
				callingState = 1
			end

			if isElement(sound) then 
				destroyElement(sound)
			end

			if isElement(showingRingstone) then 
				destroyElement(showingRingstone)
			end
		else
			exports["Pchat"]:takeMessage("me","elővett egy telefont.")
			--outputChatBox("elővett egy telefont.")
			page = 1
			callingState = 1
			contactState = 1
			phoneShow = true
			activePhone = phoneNumber
			numberText = ""
			smsState = 1

			if not phones[phoneNumber] then
				phones[phoneNumber] = {
					["phoneSet"] = false,
					["bg"] = 1,
					["ringstone"] = 1,
					["notsound"] = 1,
					["contacts"] = {},
					["mails"] = {},
					["calls"] = {},
					["theme"] = "dark",
					["ringstone-volume"] = 1,
					["notsound-volume"] = 0.2,
					["apps"] = {
						[1] = 10,
						[2] = {11, 1},
						[3] = 12,
					},
					["phoneNumber-showing"] = true,
					["sharePhoneUseingDatas"] = true,
				}
				--outputChatBox("új: "..phoneNumber)
			end

			for k, v in ipairs(defaultContacts) do 
				local insertedTable = {v[1], v[2], v[3], true}

				local volt = false
				for k2, v2 in ipairs(phones[activePhone]["contacts"]) do 
					if (toJSON(v2) == toJSON(insertedTable)) then 
						volt = true 
						break
					end
				end

				if not volt then 
					table.insert(phones[activePhone]["contacts"], 1, insertedTable)
				end
			end

			sizeingPanel = false 

			if not phones[phoneNumber]["phoneSet"] then phones[phoneNumber]["phoneSet"] = false end
			if not phones[activePhone]["theme"] then phones[activePhone]["theme"] = "dark" end
			if not phones[activePhone]["notsound"] then phones[activePhone]["notsound"] = 1 end
			if not phones[activePhone]["notsound-volume"] then phones[activePhone]["notsound-volume"] = 0.2 end
			if not phones[activePhone]["theme"] then phones[activePhone]["theme"] = "dark" end
			if not phones[activePhone]["ringstone-volume"] then phones[activePhone]["ringstone-volume"] = 1 end
			if not tableHasKey(phones[activePhone], "phoneNumber-showing") then phones[activePhone]["phoneNumber-showing"] = true end
			if not tableHasKey(phones[activePhone], "sharePhoneUseingDatas") then phones[activePhone]["sharePhoneUseingDatas"] = true end
			if not phones[activePhone]["apps"] then phones[activePhone]["apps"] = defaultApps end

			--print(toJSON(phones[activePhone]["apps"]))
			local realLenght = 0

			local apps = phones[activePhone]["apps"]
			phones[activePhone]["apps"] = {}
			for k, v in pairs(apps) do 
				if v then 
					realLenght = realLenght + 1
					table.insert(phones[activePhone]["apps"], k, v)
				end
			end

			addEventHandler("onClientRender", root, drawPhone)
			addEventHandler("onClientKey", root, clickPhone)
		end
	end
end


function checkPhoneVisible(phoneNumber)
	if phoneNumber == activePhone then 
		if phoneShow then 
			setPhoneVisible(phoneNumber)
		end
	end
end

addEvent("phone > requestMessage", true)
addEventHandler("phone > requestMessage", root, function(text)
	if #talkingTexts >= 6 then 
		table.remove(talkingTexts, 1)
	end
	table.insert(talkingTexts, {text, 1})
end)

addEvent("phone > getBackPhoneCallingData", true)
addEventHandler("phone > getBackPhoneCallingData", root, function(value, player, callingNumber, calledPlayerNumber)
		if value == "call" then 
			callingState = 1
			--outputChatBox("hívás: "..getPlayerName(player))
			talkingPlayer = player
			activeEditbox = false
			editboxs["phone-calling"] = ""
		elseif value == "error" then 
			if isElement(sound) then 
				destroyElement(sound)
			end
			sound = playSound("files/effects/hiba.wav")
			callingState = 4
			setTimer(function() page = 2 end, 8500, 1)
			--outputChatBox("hívás vége")

			if isTimer(callTimer) then 
				killTimer(callTimer)
			end
			if isTimer(callingTimer) then 
				killTimer(callingTimer)
			end
			if isTimer(callStopTimer) then 
				killTimer(callStopTimer)
			end
			activeEditbox = false
		elseif value == "in" then 
			if not talkingPlayer then 
				talkingTexts = {}
				editboxs["phone-calling"] = ""

				if not phoneShow then 
					setPhoneVisible(calledPlayerNumber)
				else
					activePhone = calledPlayerNumber
				end
				page = 8
				callingState = 2
				--outputChatBox(callingNumber)
				calledNumber = callingNumber
				talkingPlayer = player
				--outputChatBox("vonalban: "..getPlayerName(talkingPlayer))

				triggerServerEvent("phone > syncCall", resourceRoot, phones[calledPlayerNumber]["ringstone"], phones[calledPlayerNumber]["ringstone-volume"])
				local time = getRealTime()
				local hours = time.hour
				local minutes = time.minute
				local seconds = time.second
				local date = string.format("%04d-%02d-%02d %02d:%02d", time.year, time.month, time.monthday, time.hour, time.minute)
				table.insert(phones[activePhone]["calls"], {callingNumber, date, 1})
				lastLogIndex = #phones[activePhone]["calls"]
		        exports.Pchat:takeMessage("do"," csörög a telefonja.")
				--chat:sendLocalDoAction("csörög a telefonja.")
				isCalled911 = false
			end
			activeEditbox = false
		elseif value == "dismiss" then 
			if isElement(sound) then 
				destroyElement(sound)
			end
			sound = playSound("files/effects/kimeno.wav")
			setSoundSpeed(sound, 0.8)
			talkingPlayer = false
			page = 2
			callingState = 1

			if isTimer(callTimer) then 
				killTimer(callTimer)
			end
			if isTimer(callingTimer) then 
				killTimer(callingTimer)
			end
			if isTimer(callStopTimer) then 
				killTimer(callStopTimer)
			end
		    exports.Pchat:takeMessage("do","letette a telefont.")
			--chat:sendLocalDoAction("letette a telefont.")
			activeEditbox = false
		elseif value == "accept" then 
			if isElement(sound) then 
				destroyElement(sound)
			end
			callingState = 3
			startTimeCounting()

			if isTimer(callStopTimer) then 
				killTimer(callStopTimer)
			end
			phones[activePhone]["calls"][lastLogIndex][3] = 2
			activeEditbox = false
		elseif value == "busy" then 
			if isElement(sound) then 
				destroyElement(sound)
			end
			
			callingState = 5
			sound = playSound("files/effects/kimeno.wav")
			setSoundSpeed(sound, 0.8)
			setTimer(function() page = 2 end, 1200, 1)

			if isTimer(callTimer) then 
				killTimer(callTimer)
			end

			if isTimer(callingTimer) then 
				killTimer(callingTimer)
			end

			if isTimer(callStopTimer) then 
				killTimer(callStopTimer)
			end
			activeEditbox = false
		end
end)

function startTimeCounting()
	startCallTime = {0, 0, 0}
	callTimer = setTimer(function()
		
		if startCallTime[3] == 60 then 
			startCallTime[3] = 0 
			startCallTime[2] = startCallTime[2] + 1

			if startCallTime[2] == 60 then 
				startCallTime[2] = 0 
				startCallTime[1] = startCallTime[3] + 1 
				if startCallTime[1] > 99 then 
					startCallTime[1] = 99 
				end
			end 
		else
			startCallTime[3] = startCallTime[3] + 1 
		end
		
	end, 1000, 0)
end

lastLogIndex = 0
function startCalling(phoneNumber)
	editboxs["phone-calling"] = ""
	talkingTexts = {}
	startCallTime = {0, 0, 0}
	sound = playSound("files/effects/hivas.wav", true)
	page = 8
	callingState = 1
	calledNumber = phoneNumber
	local time = getRealTime()
	local hours = time.hour
	local minutes = time.minute
	local seconds = time.second
	local date = string.format("%04d-%02d-%02d %02d:%02d", time.year, time.month, time.monthday, time.hour, time.minute)
	table.insert(phones[activePhone]["calls"], {phoneNumber, date, 2})
	lastLogIndex = #phones[activePhone]["calls"]

	isCalled911 = false

	if phoneNumber == "911" then -- 911
		isCalled911 = true
		callingTimer = setTimer(function() 
			callingState = 3 
			startTimeCounting()
			destroyElement(sound)
		end, math.random(5000, 7500), 1)
	--[[elseif phoneNumber == "28362556398" then -- Bankrob pasas
		callingTimer = setTimer(function() 
			callingState = 3 
			startTimeCounting()
			destroyElement(sound)

			local activeMission = "beforeMission"

			for k, v in ipairs(customCalls["bankrob"][activeMission]) do 
				setTimer(function()
					table.insert(talkingTexts, {v, 1})
				end, math.max(5000 * (k - 1), 50), 1)
			end

			setTimer(function()
				page = 2
				sound = playSound("files/effects/kimeno.wav")
			end, 5000 * #customCalls["bankrob"][activeMission], 1)
		end, math.random(5000, 7500), 1)]]
	else
		callStopTimer = setTimer(function() 
			triggerServerEvent("phone > dismissCalling", resourceRoot, talkingPlayer)
			talkingPlayer = false
			page = 2
			callingState = 1

			if isElement(sound) then 
				destroyElement(sound)
			end

			if isTimer(callTimer) then 
				killTimer(callTimer)
			end

			if isTimer(callingTimer) then 
				killTimer(callingTimer)
			end
		end, 30000, 1)
		
		callingTimer = setTimer(function() triggerServerEvent("phone > getPhonedMan", resourceRoot, phoneNumber, activePhone) end, math.random(5000, 7500), 1)
	end
end

function getContactName(number)
	local returnName = number

	for k, v in ipairs(phones[activePhone]["contacts"]) do 
		if tostring(v[2]) == tostring(number) then 
			returnName = v[1]
			break
		end
	end

	return returnName
end

local sounds = {}
addEventHandler("onClientElementDataChange", root, function(key, old, new)
	if key == "phone:state" then 
		if new == "called" then 
			local posX, posY, posZ = getElementPosition(source)
			local sound = playSound3D("files/ringstones/"..tonumber(getElementData(source, "phone:ringstone"))..".mp3", posX, posY, posZ, true)
			attachElements(sound, source)
			setSoundVolume(sound, 5*getElementData(source, "phone:ringstoneVolume"))
			setSoundMaxDistance(sound, 12)

			setElementInterior(sound, getElementInterior(source))
			setElementDimension(sound, getElementDimension(source))
			sounds[source] = sound
		end

		if old == "called" then 
			if isElement(sounds[source]) then 
				destroyElement(sounds[source])
				sounds[source] = false
			end
		end
	end
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
	for k, v in pairs(phones) do 
		for k2, v2 in pairs(v["apps"]) do 
			if v2 == false then 
				v2 = 0 
			end
		end
	end

	local newFile = fileCreate("savedatas.psa")
	
	fileWrite(newFile, toJSON(phones))
	--exports.oJSON:saveDataToJSONFile(phones, "phoneDatas", true)
	fileClose(newFile)
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
	local file = fileOpen("savedatas.psa")
    local count = fileGetSize(file)
    local data = fileRead(file, count)
--	outputChatBox(fromJSON(data))
	phones = fromJSON(data) or {}
fileClose(file)
end)

function roundedRectangle(x, y, w, h, borderColor, bgColor, postGUI)
	if (x and y and w and h) then
		if (not borderColor) then
			borderColor = tocolor(0, 0, 0, 200);
		end
		if (not bgColor) then
			bgColor = borderColor;
		end
		dxDrawRectangle(x, y, w, h, bgColor, postGUI);
		dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor, postGUI);
		dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor, postGUI);
		dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor, postGUI);
		dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor, postGUI);
	end
end

function ReverseTable(t)
    local reversedTable = {}
    local itemCount = #t
    for k, v in ipairs(t) do
        reversedTable[itemCount + 1 - k] = v
    end
    return reversedTable
end

function getPositionInGrid(gridSizeX, gridSizeY, pos)
	local row = 1
	local column = 1

	for i = 1, gridSizeX*gridSizeY do 
		if i == pos then 
			return row, column 
		end

		column = column + 1

		if column == gridSizeX then 
			row = row + 1 
			column = 0
		end 
	end
end

function tableHasKey(table,key)
    return table[key] ~= nil
end

function stringSplit (inputstr, sep)
	if sep == nil then
			sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
			table.insert(t, str)
	end
	return t
end

-- / SMS sync / --
addEvent("phone > syncSMS > client", true)
addEventHandler("phone > syncSMS > client", root, function(table)
	if openedMessagePage and activePhone then
		local oldlength = 0
		
		for k, v in ipairs(phoneMessages[tonumber(activePhone)][tonumber(openedMessagePage)].messages) do 
			if not v[3] then 
				oldlength = oldlength + 1
			end
		end
		
		phoneMessages = table

		local newlength =  0

		for k, v in ipairs(phoneMessages[tonumber(activePhone)][tonumber(openedMessagePage)].messages) do 
			if not v[3] then 
				newlength = newlength + 1
			end
		end

		if newlength > oldlength then 
			smsPointer = smsPointer + 1
		end
	else
		phoneMessages = table
	end
end)

addEvent("phone > getPhoneNotificationSound", true)
addEventHandler("phone > getPhoneNotificationSound", resourceRoot, function(phoneNumber)
	phoneNumber = tostring(phoneNumber)
	triggerServerEvent("phone > playPhoneNotificationSound", resourceRoot, phones[phoneNumber]["notsound"], phones[phoneNumber]["notsound-volume"])
end)

addEvent("phone > play3dNotifiactionSound", true)
addEventHandler("phone > play3dNotifiactionSound", resourceRoot, function(player, soundid, volume)
	--print(soundid, volume, "client")
	local posX, posY, posZ = getElementPosition(player)
	local sound = playSound3D("files/notsounds/"..soundid..".mp3", posX, posY, posZ)
	attachElements(sound, player)
	setSoundVolume(sound, 5*volume)
	setSoundMaxDistance(sound, 12)

	setElementInterior(sound, getElementInterior(player))
	setElementDimension(sound, getElementDimension(player))
end)

-- Taxi check

function getMonthName(num)
	if num == 0 then
		return "Január"
	elseif num == 1 then
		return "Február"
	elseif num == 2 then
		return "Március"
	elseif num == 3 then
		return "Április"
	elseif num == 4 then
		return "Május"
	elseif num == 5 then
		return "Június"
	elseif num == 6 then
		return "Július"
	elseif num == 7 then
		return "Augusztus"
	elseif num == 8 then
		return "Szeptember"
	elseif num == 9 then
		return "Október"
	elseif num == 10 then
		return "November"
	elseif num == 11 then
		return "December"
	end
end

function getWeekName(num)
	if num == 1 then
		return "Hétfő"
	elseif num == 2 then
		return "Kedd"
	elseif num == 3 then
		return "Szerda"
	elseif num == 4 then
		return "Csütörtök"
	elseif num == 5 then
		return "Péntek"
	elseif num == 6 then
		return "Szombat"
	elseif num == 0 then
		return "Vasárnap"
	end
end

setTimer(function()
	availableTaxis = 0
	for k, v in ipairs(getElementsByType("player")) do 
		local dbid = getElementData(v,"player:dbid")
		if exports.pdash:isPlayerInGroup(v,6) then 
			availableTaxis = availableTaxis + 1
		end
	end
end, 5000, 0)
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
local currentMarker = {}
addEvent("phone.createMarker",true);
addEventHandler("phone.createMarker",root,function(data,callid,type)
    for k,v in pairs(currentMarker) do 
        if isElement(v) then 
            destroyElement(v);
        end
    end
    currentMarker = {};
    local target = data[1];
    local x,y,z = getElementPosition(target);
    currentMarker[1] = createMarker(x,y,z,"checkpoint",2,129, 99, 191,100);
    currentMarker[2] = createBlip(x,y,z,15);
    currentMarker[3] = callid;
    currentMarker[4] = data[1];
    currentMarker[5] = data[2];
    currentMarker[6] = type;
    setElementData(currentMarker[2],"blipName","Hívás")
    setElementData(currentMarker[2], "blipIcon", 15)
    setElementData(currentMarker[2], "exclusiveBlip",true)
    attachElements(currentMarker[1],target,0,0,0);
	attachElements(currentMarker[2],currentMarker[1])

    addEventHandler("onClientMarkerHit",currentMarker[1],function(hitElement,dim)
        if hitElement == localPlayer and getElementDimension(source) == getElementDimension(localPlayer) then 
            triggerServerEvent("phone.kiert",localPlayer,localPlayer,currentMarker[3],currentMarker[4],currentMarker[5],currentMarker[6])
            for k,v in pairs(currentMarker) do 
                if isElement(v) then 
                    destroyElement(v)
                end
            end
            currentMarker = {}
        end
    end)
end)
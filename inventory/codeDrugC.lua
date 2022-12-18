local sx, sy = guiGetScreenSize()

local moveType = "left"
local spacer = 0

addEventHandler("onClientResourceStart", resourceRoot, function()
	blurShader, blurTec = dxCreateShader("files/blur.fx")
end)

--- LSD

function setLsdScreen(state)
	if state then
		addEventHandler("onClientRender", root, renderLsdScreen)
		screenasd = dxCreateScreenSource(sx, sy)

		setGameSpeed(0.6)
		setCameraGoggleEffect("nightvision")

		setTimer(function()
			setLsdScreen(false)
		end, 120000, 1)
	else
		removeEventHandler("onClientRender", root, renderLsdScreen)

		setGameSpeed(1)
		setCameraGoggleEffect("normal")
	end
end
addEvent("setLsdScreen", true)
addEventHandler("setLsdScreen", getRootElement(), setLsdScreen)

function renderLsdScreen()
	dxUpdateScreenSource(screenasd, true)

	if screenasd then
		if spacer == -50 and moveType == "left" then
			moveType = "right"
		elseif spacer == 0 and moveType == "right" then
			moveType = "left"
		end
		
		if moveType == "left" then
			spacer = spacer - 0.5
		elseif moveType == "right" then
			spacer = spacer + 0.5
		end

		dxDrawImage(spacer, -25, sx + 250, sy + 50, screenasd)
		dxDrawRectangle(0, 0, sx, sy, tocolor(math.random(0, 255), math.random(0, 255), math.random(0, 255), 150))
	end
end

--- SPEED

function setSpeedScreen(state)
	if state then
		addEventHandler("onClientPreRender", root, renderSpeedScreen)
		screenasd = dxCreateScreenSource(sx, sy)

		setGameSpeed(1.2)
		setCameraGoggleEffect("thermalvision")

		setTimer(function()
			setElementData(localPlayer,"drugUsing",false)
			setSpeedScreen(false)
		end, 60000*(math.random(1,3)), 1)
	else
		removeEventHandler("onClientPreRender", root, renderSpeedScreen)

		setGameSpeed(1)
		setCameraGoggleEffect("normal")
	end
end

function renderSpeedScreen()
	dxUpdateScreenSource(screenasd, false)

	if screenasd then
		if spacer == -50 and moveType == "left" then
			moveType = "right"
		elseif spacer == 0 and moveType == "right" then
			moveType = "left"
		end
		
		if moveType == "left" then
			spacer = spacer - 1
		elseif moveType == "right" then
			spacer = spacer + 1
		end

		dxDrawImage(spacer, -25, sx + 50, sy + 100, screenasd)
	end
end

--- FÜVES CIGI

function setMarijuanaScreen(state)
	if state then
		addEventHandler("onClientRender", root, renderMarijuanaScreen)
		screenasd = dxCreateScreenSource(sx, sy)

		setTimer(function()
			setElementData(localPlayer,"drugUsing",false)
			setMarijuanaScreen(false)
		end, 20000, 1)
	else
		removeEventHandler("onClientRender", root, renderMarijuanaScreen)
	end
end

function renderMarijuanaScreen()
	if blurShader then
		dxUpdateScreenSource(screenasd, true)
				
		dxSetShaderValue(blurShader, "ScreenSource", screenasd)
		dxSetShaderValue(blurShader, "BlurStrength", 25)
		dxSetShaderValue(blurShader, "UVSize", sx, sy)

		dxDrawImage(0, 0, sx, sy, blurShader)
	end

	dxUpdateScreenSource(screenasd, true)

	if screenasd then
		if spacer == -50 and moveType == "left" then
			moveType = "right"
		elseif spacer == 0 and moveType == "right" then
			moveType = "left"
		end
		
		if moveType == "left" then
			spacer = spacer - 0.5
		elseif moveType == "right" then
			spacer = spacer + 0.5
		end

		dxDrawImage(spacer, -25, sx + 50, sy + 50, screenasd)
	end
end

--- HEROIN

function setHeroinScreen(state)
	if state then
		addEventHandler("onClientRender", root, renderHeroinScreen)
		screenasd = dxCreateScreenSource(sx, sy)

		setTimer(function()
			setElementData(localPlayer,"drugUsing",false)
			setHeroinScreen(false)
		end, 60000*(math.random(1,3)), 1)

		setGameSpeed(0.8)
	else
		removeEventHandler("onClientRender", root, renderHeroinScreen)

		setGameSpeed(1)
	end
end

function renderHeroinScreen()
	if blurShader then
		dxUpdateScreenSource(screenasd, true)
				
		dxSetShaderValue(blurShader, "ScreenSource", screenasd)
		dxSetShaderValue(blurShader, "BlurStrength", 15)
		dxSetShaderValue(blurShader, "UVSize", sx, sy)

		dxDrawImage(0, 0, sx, sy, blurShader)
	end		

	dxUpdateScreenSource(screenasd, true)
end

--- GOMBA

function setMushroomScreen(state)
	if state then
		addEventHandler("onClientRender", root, renderMushroomScreen)
		screenasd = dxCreateScreenSource(sx, sy)

		setGameSpeed(0.6)
		setCameraGoggleEffect("nightvision")

		setTimer(function()
			setMushroomScreen(false)
		end, 120000, 1)

		createdElements = {}
	else
		removeEventHandler("onClientRender", root, renderMushroomScreen)

		for key, value in ipairs(createdElements) do
			if isElement(value) then
				destroyElement(value)
			end
		end

		setGameSpeed(1)
		setCameraGoggleEffect("normal")
	end
end
addEvent("setMushroomScreen", true)
addEventHandler("setMushroomScreen", getRootElement(), setMushroomScreen)

function renderMushroomScreen()
	dxUpdateScreenSource(screenasd, true)

	if screenasd then
		if spacer == -50 and moveType == "left" then
			moveType = "right"
		elseif spacer == 0 and moveType == "right" then
			moveType = "left"
		end
		
		if moveType == "left" then
			spacer = spacer - 0.5
		elseif moveType == "right" then
			spacer = spacer + 0.5
		end

		dxDrawImage(spacer, -25, sx + 250, sy + 50, screenasd)
		dxDrawRectangle(0, 0, sx, sy, tocolor(math.random(0, 255), math.random(0, 255), math.random(0, 255), 150))

		if getTickCount() % 60 == 0 then
			for key, value in ipairs(createdElements) do
				if isElement(value) then
					destroyElement(value)
				end
			end

			local x, y, z = getElementPosition(localPlayer)
			for key = 1, 12 do
				createdElements[key] = createPed(264, x + math.random(-2, 2), y + math.random(-2, 2), z, math.random(0, 360))
			end
		end
	end
end
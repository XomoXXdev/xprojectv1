toggler				= { }
dtype				= { }
syncTimer 			= { }

function bindTurnIndicators()
	bindKey(source, "", "down", "lleft")
	bindKey(source, "", "down", "lright")
end
addEventHandler("onPlayerJoin", root, bindTurnIndicators)

function bindKeys()
	for k, arrayPlayer in ipairs(getElementsByType("player")) do

		if not(isKeyBound(arrayPlayer, "", "down", "lleft")) then
			bindKey(arrayPlayer, "", "down", "lleft")
		end

		if not(isKeyBound(arrayPlayer, "", "down", "lright")) then
			bindKey(arrayPlayer, "", "down", "lright")
		end
	end
end
addEventHandler("onResourceStart", getResourceRootElement(), bindKeys)

local indexSound = {}

function toggleLights( veh )
	if veh and isElement( veh ) and getElementType(veh) == "vehicle" then
		setVehicleOverrideLights( veh, 2 )
		if toggler[veh] == 1 then
			x,y,z = getElementPosition(veh)
			--indexSound[veh] = playSound3D("files/index.mp3",x,y,z,true)
			--triggerClientEvent("receiveSoundPos", veh,x,y,z)
			setVehicleLightState( veh, 0, 1 )
			setVehicleLightState( veh, 1, 1 )
			setVehicleLightState( veh, 2, 1 )
			setVehicleLightState( veh, 3, 1 )
			setElementData(veh, "vehicle:index-l", false)
			setElementData(veh, "vehicle:index-r", false)	
			if getVehicleTowedByVehicle( veh ) then
				local veh2 = getVehicleTowedByVehicle( veh )
				if veh2 then
					setElementData(veh2, "vehicle:index-r", false)
					setElementData(veh2, "vehicle:index-l", false)
					setVehicleLightState( veh2, 0, 1 )
					setVehicleLightState( veh2, 1, 1 )
					setVehicleLightState( veh2, 2, 1 )
					setVehicleLightState( veh2, 3, 1 )
				end
			end
			toggler[veh] = 0
		else
			if dtype[veh] == "lleft" then
				setVehicleLightState( veh, 0, 0 )
				setVehicleLightState( veh, 1, 1 )
				setVehicleLightState( veh, 2, 1 )
				setVehicleLightState( veh, 3, 0 )
				setElementData(veh, "vehicle:index-l", true)
				if getVehicleTowedByVehicle( veh ) then
					local veh2 = getVehicleTowedByVehicle( veh )
					if veh2 then
						setVehicleLightState( veh2, 0, 0 )
						setVehicleLightState( veh2, 1, 1 )
						setVehicleLightState( veh2, 2, 1 )
						setVehicleLightState( veh2, 3, 0 )
						setElementData(veh2, "vehicle:index-l", true)
					end
				end
			elseif dtype[veh] == "lright" then
				setVehicleLightState( veh, 0, 1 )
				setVehicleLightState( veh, 1, 0 )
				setVehicleLightState( veh, 2, 0 )
				setVehicleLightState( veh, 3, 1 )
				setElementData(veh, "vehicle:index-r", true)
				if getVehicleTowedByVehicle( veh ) then
					local veh2 = getVehicleTowedByVehicle( veh )
					if veh2 then
						setElementData(veh2, "vehicle:index-r", true)
						setVehicleLightState( veh2, 0, 1 )
						setVehicleLightState( veh2, 1, 0 )
						setVehicleLightState( veh2, 2, 0 )
						setVehicleLightState( veh2, 3, 1 )
					end
				end
			end
			toggler[veh] = 1
		end
	end
end

function lightHandler( player, cmd )
	if player and isElement( player ) and getPedOccupiedVehicle( player ) and not isCursorShowing(player) then
		local veh = getPedOccupiedVehicle( player )
		if ( not isTimer( syncTimer[veh] ) or cmd ~= dtype[veh] ) and getVehicleOccupants(veh)[0] == player then
			setVehicleLightState( veh, 0, 1 )
			setVehicleLightState( veh, 1, 1 )
			setVehicleLightState( veh, 2, 1 )
			setVehicleLightState( veh, 3, 1 )
			setElementData(veh, "vehicle:index-r", false)
			setElementData(veh, "vehicle:index-l", false)
			setElementData(veh, "vehicle:lights",true)
			if getVehicleTowedByVehicle( veh ) then
				local veh2 = getVehicleTowedByVehicle( veh )
				if veh2 then
					setElementData(veh2, "vehicle:index-r", false)
					setElementData(veh2, "vehicle:index-l", false)
					setVehicleLightState( veh2, 0, 1 )
					setVehicleLightState( veh2, 1, 1 )
					setVehicleLightState( veh2, 2, 1 )
					setVehicleLightState( veh2, 3, 1 )
					setElementData(veh, "vehicle:lights",true)
				end
			end

			if isTimer( syncTimer[veh] ) then
				killTimer( syncTimer[veh] )
			end
			syncTimer[veh] = setTimer( toggleLights, 500, 0, veh )
			toggler[veh] = 1
			dtype[veh] = cmd
			toggleLights( veh )
		else
			if isTimer( syncTimer[veh] ) then
				killTimer( syncTimer[veh] )
			end
			startLights(veh)
		end
	end
end

addCommandHandler( "", lightHandler )
addCommandHandler( "", lightHandler )

function startLights(veh)
	if not veh or not isElement(veh) then return end
	setVehicleLightState( veh, 0, 0 )
	setVehicleLightState( veh, 1, 0 )
	setVehicleLightState( veh, 2, 0 )
	setVehicleLightState( veh, 3, 0 )
	setVehicleOverrideLights( veh, 2 )
	setElementData(veh, "vehicle:index-r", false)
	setElementData(veh, "vehicle:index-l", false)
	if getVehicleTowedByVehicle( veh ) then
		local veh2 = getVehicleTowedByVehicle( veh )
		if veh2 then
			setElementData(veh2, "vehicle:index-r", false)
			setElementData(veh2, "vehicle:index-l", false)
			setVehicleLightState( veh2, 0, 0 )
			setVehicleLightState( veh2, 1, 0 )
			setVehicleLightState( veh2, 2, 0 )
			setVehicleLightState( veh2, 3, 0 )
			setVehicleOverrideLights( veh2, 2 )
		end
	end
end

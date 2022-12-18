fileDelete ("glue.lua") 
function playerGlue()
	if not getPlayerOccupiedVehicle(localPlayer) then
		local vehicle = getPlayerContactElement(localPlayer)

		if vehicle then 
			if getElementType(vehicle) == "vehicle" then

				local px, py, pz = getElementPosition(localPlayer)
				local vx, vy, vz = getElementPosition(vehicle)
				local sx = px - vx
				local sy = py - vy
				local sz = pz - vz

				local rotpX = 0
				local rotpY = 0
				local rotpZ = getPlayerRotation(localPlayer)

				local rotvX,rotvY,rotvZ = getVehicleRotation(vehicle)

				local t = math.rad(rotvX)
				local p = math.rad(rotvY)
				local f = math.rad(rotvZ)

				local ct = math.cos(t)
				local st = math.sin(t)
				local cp = math.cos(p)
				local sp = math.sin(p)
				local cf = math.cos(f)
				local sf = math.sin(f)

				local z = ct*cp*sz + (sf*st*cp + cf*sp)*sx + (-cf*st*cp + sf*sp)*sy
				local x = -ct*sp*sz + (-sf*st*sp + cf*cp)*sx + (cf*st*sp + sf*cp)*sy
				local y = st*sz - sf*ct*sx + cf*ct*sy

				local rotX = rotpX - rotvX
				local rotY = rotpY - rotvY
				local rotZ = rotpZ - rotvZ

				local slot = getPlayerWeaponSlot(localPlayer)

				--outputDebugString("gluing ".. getPlayerName(player) .." to " .. getVehicleName(vehicle) .. "(offset: "..tostring(x)..","..tostring(y)..","..tostring(z).."; rotation:"..tostring(rotX)..","..tostring(rotY)..","..tostring(rotZ)..")")

				triggerServerEvent("gluePlayer", localPlayer, slot, vehicle, x, y, z, rotX, rotY, rotZ)

			end
		end
	end
end

local Glue = false

function setGlue ()

if not Glue then 
	playerGlue()
	Glue = true 
else 
	triggerServerEvent("ungluePlayer", localPlayer)
	Glue = false
end 

end
addCommandHandler("glue",setGlue)
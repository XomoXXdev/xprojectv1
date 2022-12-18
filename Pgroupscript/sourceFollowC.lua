fileDelete ("sourceFollowC.lua") 
local visz = false
local targetPlayer = false

function viszes()
	local x, y, z = getElementPosition(getLocalPlayer())
	local tx, ty, tz = getElementPosition(targetPlayer)
	local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
	if (distance>2) then
		triggerServerEvent("viszTP", getLocalPlayer(), getLocalPlayer(), targetPlayer)
	end
end

function viszben(target)
	if (visz) then
		visz = false
		removeEventHandler("onClientRender", getRootElement(), viszes)
		targetPlayer = false
	else
		visz = true
		addEventHandler("onClientRender", getRootElement(), viszes)
		targetPlayer = target
	end
end
addEvent("togVisz", true)
addEventHandler("togVisz", getRootElement(), viszben)

function viszOff()
	visz = false
	targetPlayer = false
	removeEventHandler("onClientRender", getRootElement(), viszes)
end
addEvent("viszOff", true)
addEventHandler("viszOff", getRootElement(), viszOff)

function followPlayer(target)
	triggerServerEvent("followPlayerServer",localPlayer,localPlayer,target)
end
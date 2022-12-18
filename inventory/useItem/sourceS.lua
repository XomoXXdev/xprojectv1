local func = {};
func.dbConnect = exports["Pcore"]
local objects = {};
local taxiCache = {}
local sirenCache = {}

addEvent("giveArmor", true)
addEventHandler("giveArmor", root, function(newValue)
	setPedArmor(source, newValue)
end)

func.giveWeaponServer = function(playerSource,weapon,ammo,item,dbid,itemValue)
	takeAllWeapons(playerSource)
	setElementData(playerSource,"tazerState", false)
	setPedAnimation(playerSource, "COLT45", "sawnoff_reload", 500, false, false, false, false)
	local asd = giveWeapon(playerSource, weapon, ammo, true)
	if item == 135 then
	    if getElementData(playerSource,"tazerState") then
	        setElementData(playerSource,"tazerState", false)
		else
	        setElementData(playerSource,"tazerState", true)		
		end
	end
	if weaponCache[item] and weaponCache[item].isBack then
		detachWeapon(playerSource,item,dbid)
	end
	if weapon == 30 and itemValue == 20 then
		exports["weapontuning"]:setStickerOnWeapon(playerSource,"ak", "ak1")
	elseif weapon == 30 and itemValue == 21 then
		exports["weapontuning"]:setStickerOnWeapon(playerSource,"ak", "ak2")
	elseif weapon == 30 and itemValue == 22 then
		exports["weapontuning"]:setStickerOnWeapon(playerSource,"ak", "ak3")
	elseif weapon == 30 and itemValue == 23 then
		exports["weapontuning"]:setStickerOnWeapon(playerSource,"ak", "ak4")
	elseif weapon == 30 and itemValue == 24 then
		exports["weapontuning"]:setStickerOnWeapon(playerSource,"ak", "ak5")
	elseif weapon == 30 and itemValue == 25 then
		exports["weapontuning"]:setStickerOnWeapon(playerSource,"ak", "ak6")
	elseif weapon == 30 and itemValue == 26 then
		exports["weapontuning"]:setStickerOnWeapon(playerSource,"ak", "ak7")
	end
	if weapon == 24 and itemValue == 20 then
		exports["weapontuning"]:setStickerOnWeapon(playerSource,"deagle", "deagle1")
	elseif weapon == 24 and itemValue == 21 then
		exports["weapontuning"]:setStickerOnWeapon(playerSource,"deagle", "deagle2")
	elseif weapon == 24 and itemValue == 22 then
		exports["weapontuning"]:setStickerOnWeapon(playerSource,"deagle", "deagle3")
	end
	if weapon == 4 and itemValue == 20 then
		exports["weapontuning"]:setStickerOnWeapon(playerSource,"kabar", "knife1")
	elseif weapon == 4 and itemValue == 21 then
		exports["weapontuning"]:setStickerOnWeapon(playerSource,"kabar", "knife2")
	elseif weapon == 4 and itemValue == 22 then
		exports["weapontuning"]:setStickerOnWeapon(playerSource,"kabar", "knife3")
	end
	if weapon == 31 and itemValue == 20 then
		exports["weapontuning"]:setStickerOnWeapon(playerSource,"m4_v3_d", "m41")
	elseif weapon == 31 and itemValue == 21 then
		exports["weapontuning"]:setStickerOnWeapon(playerSource,"m4_v3_d", "m42")
	elseif weapon == 31 and itemValue == 22 then
		exports["weapontuning"]:setStickerOnWeapon(playerSource,"m4_v3_d", "m43")
	end
	if weapon == 28 and itemValue == 20 then
		exports["weapontuning"]:setStickerOnWeapon(playerSource,"9MM_C", "tec1")
	elseif weapon == 28 and itemValue == 21 then
		exports["weapontuning"]:setStickerOnWeapon(playerSource,"9MM_C", "tec2")
	elseif weapon == 28 and itemValue == 22 then
		exports["weapontuning"]:setStickerOnWeapon(playerSource,"9MM_C", "tec3")
	elseif weapon == 28 and itemValue == 23 then
		exports["weapontuning"]:setStickerOnWeapon(playerSource,"9MM_C", "tec4")
	end
	if weapon == 23 and itemValue == 20 then
		exports["weapontuning"]:setStickerOnWeapon(playerSource,"1911", "silenced1")
	end
	local weapTimer = {}
	weapTimer[playerSource] = setTimer(function()
		toggleControl(playerSource,"next_weapon",false)
		toggleControl(playerSource,"previous_weapon",false)
		killTimer(weapTimer[playerSource])
	end,1000,1)
end
addEvent("giveWeaponServer",true)
addEventHandler("giveWeaponServer",getRootElement(),func.giveWeaponServer)

func.takeWeaponServer = function(playerSource,item,dbid,value)
	takeAllWeapons(playerSource)
	if weaponCache[item] and weaponCache[item].isBack then
		attachWeapon(playerSource,item,dbid,value)
	end
	setElementData(playerSource,"tazerState", false)	
	toggleControl(playerSource,"next_weapon",true)
	toggleControl(playerSource,"previous_weapon",true)
	toggleControl(playerSource,"fire",true)
	toggleControl(playerSource,"action",true)
end
addEvent("takeWeaponServer",true)
addEventHandler("takeWeaponServer",getRootElement(),func.takeWeaponServer)

func.eatingAnimation = function(playerSource,typ)
	if typ == "food" then
		setPedAnimation(playerSource, "FOOD", "eat_pizza", 4000,false,false,false,false)
	elseif typ == "drink" then
		setPedAnimation(playerSource, "VENDING", "vend_drink2_p", 1500,false,false,false,false)
	elseif typ == "smoke" then
		setPedAnimation(playerSource, "SMOKING", "M_smkstnd_loop", 4000,false,false,false,false)
	end
end
addEvent("eatingAnimation",true)
addEventHandler("eatingAnimation",getRootElement(),func.eatingAnimation)

func.setPlayerStat = function(playerSource,skill)
	setPedStat(playerSource,skill,999);
end
addEvent("setPedStat",true)
addEventHandler("setPedStat",getRootElement(),func.setPlayerStat)

addEvent("addphonetoworld",true)
function addphonetoworld(player,number)
	local szar = number-1
	if szar == 0 then
	--exports["inventory"]:takeItem(player,133,1)
	exports["inventory"]:giveItem(player,133,math.random(0,1500000),1,0,1)
	triggerClientEvent("togphone",player,number)
	else	
		triggerClientEvent("togphone",player,number)
		
	end
end
addEventHandler("addphonetoworld",root,addphonetoworld)

addEvent("taxiLampToServer",true)
addEventHandler("taxiLampToServer",getRootElement(),function(playerSource,vehicle,state)
	if state == "create" then
		if not isElement(getElementData(vehicle,"lampObject")) then
			local x,y,z = getElementPosition(vehicle)
			local lamp = createObject(1313,x,y,z)
            lamp.dimension = vehicle.dimension
            lamp.interior = vehicle.interior
			local posX,posY,posZ,rotX,rotY,rotZ = taxiPos[getElementModel(vehicle)][1],taxiPos[getElementModel(vehicle)][2],taxiPos[getElementModel(vehicle)][3],taxiPos[getElementModel(vehicle)][4],taxiPos[getElementModel(vehicle)][5],taxiPos[getElementModel(vehicle)][6]
			attachElements(lamp,vehicle,posX,posY,posZ,rotX,rotY,rotZ)
			setElementCollisionsEnabled(lamp, false)
			setElementData(vehicle,"lampObject",lamp)
			local clockState = tonumber(getElementData(vehicle, "Taxi->clockState") or 0)
			if clockState == 0 then
				local marker = createMarker(x,y,z,"corona",0.6,255,255,0,80)
                marker.dimension = vehicle.dimension
                marker.interior = vehicle.interior
				attachElements(marker,lamp)
				setElementData(vehicle,"lampMarker",marker)
			end
			setElementData(vehicle,"isVehicleInObject",true)
			setElementData(vehicle,"hasElcseszettElbaszottTaxiLampMertEddienekKellEgyilyenisMertMiertNeSzopdki",true)
			setElementData(playerSource,"isSirenVehicle",vehicle)
		end
	elseif state == "destroy" then
		if isElement(getElementData(vehicle,"lampObject")) then
			destroyElement(getElementData(vehicle,"lampObject"))
		end
		if isElement(getElementData(vehicle,"lampMarker")) then
			destroyElement(getElementData(vehicle,"lampMarker"))
		end
		setElementData(vehicle,"isVehicleInObject",false)
		setElementData(vehicle,"hasElcseszettElbaszottTaxiLampMertEddienekKellEgyilyenisMertMiertNeSzopdki",false)
		setElementData(playerSource,"isSirenVehicle",nil)
	end
end)

function addjalGeciVillogot(vehicle, state)
	if state then
		addVehicleSirens(vehicle, 1, 2, false, false, false, true)
		setVehicleSirens(vehicle, 1, sirenPos[getElementModel(vehicle)][1],sirenPos[getElementModel(vehicle)][2],sirenPos[getElementModel(vehicle)][3], 0, 0, 255, 255, 255)
	else
		removeVehicleSirens(vehicle)
	end
end

addEvent("sirenToServer",true)
addEventHandler("sirenToServer",getRootElement(),function(playerSource,vehicle,state)
	if state == "create" then
		if not isElement(getElementData(vehicle,"sirenObject")) then
			local x,y,z = getElementPosition(vehicle)
			local siren = createObject(1253,x,y,z)
                        siren.dimension = vehicle.dimension
                        siren.interior = vehicle.interior
			local posX,posY,posZ,rotX,rotY,rotZ = sirenPos[getElementModel(vehicle)][1],sirenPos[getElementModel(vehicle)][2],sirenPos[getElementModel(vehicle)][3],sirenPos[getElementModel(vehicle)][4],sirenPos[getElementModel(vehicle)][5],sirenPos[getElementModel(vehicle)][6]
			attachElements(siren,vehicle,posX,posY,posZ,rotX,rotY,rotZ)
			setElementCollisionsEnabled(siren, false)
			setElementData(siren,"sirenCol",true)
			setElementData(vehicle,"sirenObject",siren)
			addjalGeciVillogot(vehicle, true)
			local marker = createMarker(x,y,z,"corona",0.6,0,0,0,80)
                        marker.dimension = vehicle.dimension
                        marker.interior = vehicle.interior    
			attachElements(marker,siren)
			setElementData(vehicle,"sirenMarker",marker)
			setElementData(vehicle,"isVehicleInObject",true)
			setElementData(playerSource,"isSirenVehicle",vehicle)
		end
	elseif state == "destroy" then
		if isElement(getElementData(vehicle,"sirenObject")) then
			destroyElement(getElementData(vehicle,"sirenObject"))
		end
		if isElement(getElementData(vehicle,"sirenMarker")) then
			destroyElement(getElementData(vehicle,"sirenMarker"))
		end
		addjalGeciVillogot(vehicle, false)
		setElementData(vehicle,"isVehicleInObject",false)
		setElementData(vehicle,"vehicle:siren",0)
		setElementData(playerSource,"isSirenVehicle",nil)
	end
end)

addEventHandler("onElementDestroy", getRootElement(),function()
	if getElementType(source) == "vehicle" then
		if getElementData(source,"lampObject") then
			if isElement(getElementData(source,"lampObject")) then
				destroyElement(getElementData(source,"lampObject"))
			end
			if isElement(getElementData(source,"lampMarker")) then
				destroyElement(getElementData(source,"lampMarker"))
			end
		end
		if getElementData(source,"sirenObject") then
			if isElement(getElementData(source,"sirenObject")) then
				destroyElement(getElementData(source,"sirenObject"))
			end
			if isElement(getElementData(source,"sirenMarker")) then
				destroyElement(getElementData(source,"sirenMarker"))
			end
		end
	end
end)

addEvent("createLampMarker",true)
addEventHandler("createLampMarker",getRootElement(),function(veh)
	if taxiPos[getElementModel(veh)] then
		if not isElement(getElementData(veh,"lampMarker")) then
			local lamp = getElementData(veh,"lampObject")
			if isElement(lamp) then
				local x,y,z = getElementPosition(veh)
				local marker = createMarker(x,y,z,"corona",0.6,255,255,0,80)
                marker.dimension = veh.dimension
                marker.interior = veh.interior
				attachElements(marker,lamp)
				setElementData(veh,"lampMarker",marker)
			end
		end
	end
end)

addEvent("destroyLampMarker",true)
addEventHandler("destroyLampMarker",getRootElement(),function(veh)
	if isElement(getElementData(veh,"lampMarker")) then
		destroyElement(getElementData(veh,"lampMarker"))
	end
end)

addEventHandler("onPlayerQuit",getRootElement(),function()
	if isElement(getElementData(source,"isSirenVehicle")) then
		local vehicle = getElementData(source,"isSirenVehicle")
		if getElementData(vehicle,"lampObject") then
			if isElement(getElementData(vehicle,"lampObject")) then
				destroyElement(getElementData(vehicle,"lampObject"))
			end
			if isElement(getElementData(vehicle,"lampMarker")) then
				destroyElement(getElementData(vehicle,"lampMarker"))
			end
		end
		if getElementData(vehicle,"sirenObject") then
			if isElement(getElementData(vehicle,"sirenObject")) then
				destroyElement(getElementData(vehicle,"sirenObject"))
			end
			if isElement(getElementData(vehicle,"sirenMarker")) then
				destroyElement(getElementData(vehicle,"sirenMarker"))
			end
		end
        setElementData(vehicle,"isVehicleInObject",false)
		setElementData(source,"isSirenVehicle",nil)    
	end
end)

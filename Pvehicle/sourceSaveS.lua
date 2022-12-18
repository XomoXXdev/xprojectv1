func.saveVehicle = function(element)

    if vehicleCache[element] and getElementData(element,"vehicle:dbid") then



        local dbid = getElementData(element,"vehicle:dbid");
        local locked = getElementData(element,"vehicle:locked");
        local engine = getElementData(element,"vehicle:engine");
        local health = math.floor(getElementHealth(element));
        local fuel = getElementData(element,"vehicle:fuel")
        local miles = getElementData(element,"vehicle:miles")
        local x,y,z = getElementPosition(element);
        local rx,ry,rz = getElementRotation(element);
		local dimension = getElementDimension(element);
        local interior = getElementInterior(element);
        --local r, g, b, r1, g1, b1, r2, g2, b2, r3, g3, b3 = getVehicleColor(element,true)
		local colors = {getVehicleColor(element,true)}
        local color = toJSON({ colors[1],colors[2], colors[3], colors[4], colors[5], colors[6], colors[7], colors[8], colors[9], colors[10], colors[11], colors[12] })
		local panels = toJSON({getVehiclePanelState(element, 0), getVehiclePanelState(element, 1), getVehiclePanelState(element, 2), getVehiclePanelState(element, 3), getVehiclePanelState(element, 4), getVehiclePanelState(element, 5), getVehiclePanelState(element, 6)})
		local doors = toJSON({getVehicleDoorState(element, 0), getVehicleDoorState(element, 1), getVehicleDoorState(element, 2), getVehicleDoorState(element, 3), getVehicleDoorState(element, 4), getVehicleDoorState(element, 5)})
        local wheel1, wheel2, wheel3, wheel4 = getVehicleWheelStates(element);
		local wheels = toJSON({ wheel1, wheel2, wheel3, wheel4 })
        local turbo = getElementData(element,"tuning.turbo") or 0
        local brakes = getElementData(element,"tuning.brakes") or 0
        local tires = getElementData(element,"tuning.tires") or 0 
        local motor = getElementData(element,"tuning.engine") or 0
        local ecu = getElementData(element,"tuning.ecu") or 0
        local pj = getElementData(element,"tuning.paintjob") or 0
        local front = exports.tuning:getVehicleWheelSize(element,"front")
        local rear = exports.tuning:getVehicleWheelSize(element,"rear")
        local weightreduction = getElementData(element,"tuning.weightreduction") or 0
        local plate = getVehiclePlateText(element)
        local hr,hg,hb = getVehicleHeadLightColor(element)
        dbExec(func.dbConnect:getConnection(),"UPDATE `vehicles` SET `health`='" .. health .. "', `turbo`='" .. turbo .. "',`headlightcolor`='" .. toJSON{hr,hg,hb} .. "',`plate`='" .. plate .. "', `frontwheel`='" .. front .. "', `backwheel`='" .. rear .. "',`pj`='" .. pj .. "', `ecu`='" .. ecu .. "',`motor`='" .. motor .. "',`weightreduction`='" .. weightreduction .. "', `tires`='" .. tires .. "',`brakes`='" .. brakes .. "',`locked`='" .. locked .. "', `fuel` = '".. fuel .."' , `miles` = '".. miles .."', `engine`='" .. engine .. "', `x`='" .. x .. "', `y`='" .. y .. "', `z`='" .. z .. "', `rx`='" .. rx .. "', `ry`='" .. ry .. "', `rz`='" .. rz .. "', `dimension`='" .. dimension .. "', `interior`='" .. interior .. "', `panels`='" .. panels .. "', `doors`='" .. doors .. "', `wheels` = '" .. wheels .. "', `color` = '".. color .."' WHERE id = '" .. dbid .. "'")
        destroyElement(element)
    end
end

addEvent('changeStatus', true)
addEventHandler('changeStatus', getRootElement(), function(vehicle, status)
	setElementFrozen(vehicle, status)
end)
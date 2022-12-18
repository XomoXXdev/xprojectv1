fightstyles = {
	[4] = {"Alap",4},
	[5] = {"Boxoló",5},
	[6] = {"Kung Fu",6},
	[7] = {"Térdelő",7},
	[15] = {"Megragad és Kiüt",15},
}

walkstyles = {
    {"Gangster Séta",121},
	{"Női Séta",55},
	{"Berogyott Séta",119},
	{"Settenkedő Séta",69},
	{"Öregember Séta",120},
	{"Gangster Séta 2",122},
	{"Túlsúlyos Séta",124},
	{"Részeg Séta",126},
	{"Vak Séta",127},
	{"Szexy Női Séta",132},
	{"Foglalt Női Séta",131},
	{"Profi Női Séta",133},
	{"Feszült Séta",59},
}

crosshairs = {
	[1] = {1},
	[2] = {2},
	[3] = {3},
	[4] = {4},
	[5] = {5},
	[6] = {6},
	[7] = {7},
	[8] = {8},
	[9] = {9},
	[10] = {10},
}

availableGroupItems = {
	--[groupID] = {itemid};
	[1] = {23,24,25,27,34,35,28,31,36,38,122,123,126,135};
	[2] = {23,24,25,27,34,35,28,31,36,38,122,123,126,135};
	[11] = {121};
	[3] = {25,26,27,34,35,122,123,126,135,165};
	[14] = {41,37,38,30,31,23,24,126};
};

dutySkins = {
	--groupid
	[1] = {
		{skin = 280, name = "Férfi skin1"},
		{skin = 281, name = "Férfi skin2"},
		{skin = 282, name = "Férfi skin3"},
		{skin = 284, name = "Kadét Skin skin1"},
	};
	[2] = {
		{skin = 220, name = "Férfi SASD Skin"},
		{skin = 221, name = "Férfi SASD Skin"},
		{skin = 222, name = "Férfi SASD Skin"},
		{skin = 223, name = "Férfi SASD Skin"},
		{skin = 224, name = "Férfi SASD Skin"},
		{skin = 225, name = "Férfi SASD Skin"},
		{skin = 282, name = "Férfi SASD Skin"},
		{skin = 283, name = "Férfi SASD Skin"},
	};
	[3] = {
		{skin = 0, name = "Nincs"},
	};
	[4] = {
		{skin = 50, name = "Férfi szerelő skin"},
	};
	[5] = {
		{skin = 0, name = "Nincs"},
	};
	[6] = {
		{skin = 0, name = "Nincs"},
	};
	[7] = {
		{skin = 0, name = "Nincs"},
	};
	[8] = {
		{skin = 0, name = "Nincs"},
	};
	[9] = {
		{skin = 200, name = "Férfi Piru Skin"},
		{skin = 201, name = "Férfi Piru Skin"},
		{skin = 202, name = "Férfi Piru Skin"},
		{skin = 203, name = "Férfi Piru Skin"},
		{skin = 204, name = "Női piru skin"},
		{skin = 205, name = "Férfi Piru Skin"},
		{skin = 206, name = "Férfi Piru Skin"},
	};
	[10] = {
		{skin = 231, name = "Férfi Crips Skin"},
		{skin = 232, name = "Férfi Crips Skin"},
		{skin = 233, name = "Férfi Crips Skin"},
		{skin = 234, name = "Férfi Crips Skin"},
		{skin = 235, name = "Férfi Crips skin"},
		{skin = 236, name = "Női Crips Skin"},
		{skin = 237, name = "Férfi Crips Skin"},
	};
	[11] = {
		{skin = 274, name = "Férfi Medical Skin"},
		{skin = 275, name = "Férfi Medical Skin"},
		{skin = 276, name = "Férfi Medical Skin"},
	};
	[12] = {
		{skin = 0, name = "CJ"},
    };
};

job = {
	[1] = {"Buszsofőr"},
	[2] = {"Kamionsofőr"},
	[3] = {"Automata feltöltő"},
	[4] = {"Postás"},
	[5] = {"FoodPanda(Ételfutár)"},
	[6] = {"Rakodó"},
	[7] = {"Ételfutár"},
	[8] = {"Roncsszállító"},
	[0] = {"Munkanélküli"},
}

function formatMoney(amount)
    local formatted = amount
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')
        if (k==0) then
            break
        end
    end
    return formatted
end

function generateDate()
	local realTime = getRealTime() 

    local date = {(realTime.year)+1900,(realTime.month)+1,realTime.monthday,realTime.hour,realTime.minute,realTime.second} 
	
	if date[2] < 10 then
		date[2] = "0"..date[2]
	end
	if date[3] < 10 then
		date[3] = "0"..date[3]
    end
    if date[4] < 10 then
		date[4] = "0"..date[4]
    end
    if date[5] < 10 then
		date[5] = "0"..date[5]
    end
    if date[6] < 10 then
		date[6] = "0"..date[6]
	end
	
	return date[1].."-"..date[2].."-"..date[3].." "..date[4]..":"..date[5]..":"..date[6];
end

function isInSlot(xS,yS,wS,hS)
	if(isCursorShowing()) then
		XY = {guiGetScreenSize()}
		local cursorX, cursorY = getCursorPosition()
		cursorX, cursorY = cursorX*XY[1], cursorY*XY[2]
		if(isInBox(xS,yS,wS,hS, cursorX, cursorY)) then
			return true
		else
			return false
		end
	end	
end

function isInBox(dX, dY, dSZ, dM, eX, eY)
	if(eX >= dX and eX <= dX+dSZ and eY >= dY and eY <= dY+dM) then
		return true
	else
		return false
	end
end

function getPlayerJob(element,id)
	if element and id then 
		return job[id or 0][1]
	else 
		return "Munkanélküli"
	end 
end 

function getPlayerVehicles(element)
	local count = 0
	if element then 
		for k,v in pairs(getElementsByType("vehicle")) do
			if getElementData(element,"player:dbid") == getElementData(v,"vehicle:owner") then 
				count = count + 1
			end 
		end
		return count
	else 
		return "Hibás, vagy nem létező argumentumot adtál meg."
	end 
end 

function getPlayerPropertys(element)
	local counter = 0
	if element then 
		for k,v in pairs(getElementsByType("pickup")) do
			if getElementData(element,"player:dbid") == getElementData(v,"int:owner") and getElementData(v,"int:in") then 
				counter = counter + 1
			end 
		end
		return counter
	else 
		return "Hibás, vagy nem létező argumentumot adtál meg."
	end 
end 
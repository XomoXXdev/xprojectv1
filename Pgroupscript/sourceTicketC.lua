fileDelete ("sourceTicketC.lua") 


local cache = {
    freeAdelaide = dxCreateFont("files/freeAdelaide.ttf",20);
    sfcDisplaybold = dxCreateFont("files/sfcDisplaybold.ttf",20);
    sfcDisplaybold2 = dxCreateFont("files/sfcDisplaybold.ttf",20,true);
    ticketData = {
        name = "";
        date = "";
        location = "";
        offender = "";
        vehiclename = "";
        plate = "";
        color = "";
        reason = "";
        amount = "";
    };
    selectedbox = 0;
    show = false;
    target = nil;
};
local func = {};
local sx,sy = guiGetScreenSize();
local sx = sx+300
local sy = sy+100
local alpha = 255;

setTimer(function()
    if alpha == 255 then
        alpha = 0;
    elseif alpha == 0 then
        alpha = 255;
    end
end,600,0)

--116,116,116
--111,150,221

func.start = function()
    --if getElementData(localPlayer,"ticketpanelwrite") then
        setElementData(localPlayer,"ticketpanelwrite",false)
        bindKey("t", "down", "chatbox", "chatboxsay")
    --end
end
addEventHandler("onClientResourceStart",resourceRoot,func.start)

addCommandHandler("ticket",function(cmd,target)
    if getElementData(localPlayer,"player:loggedIn") then
        if target then
            cache.show = true;
        else
            
        end
    end
end)

func.render = function()
    if cache.show then
        dxDrawImage(sx*0.396,sy*0.233,sx*0.208,sy*0.534,"files/ticket.png")

        dxDrawText(cache.ticketData.name,sx*0.405,sy*0.341,0,0,tocolor(116,116,116),0.00022*sx,cache.sfcDisplaybold)
        if cache.selectedbox == 1 then
            dxDrawRectangle(sx*0.4058 + dxGetTextWidth(cache.ticketData.name,0.00022*sx,cache.sfcDisplaybold),sy*0.3425,1,sy*0.010,tocolor(116,116,116,alpha))
        end

        dxDrawText(cache.ticketData.date,sx*0.489,sy*0.341,0,0,tocolor(116,116,116),0.00022*sx,cache.sfcDisplaybold)
        if cache.selectedbox == 2 then
            dxDrawRectangle(sx*0.4898 + dxGetTextWidth(cache.ticketData.date,0.00022*sx,cache.sfcDisplaybold),sy*0.3425,1,sy*0.010,tocolor(116,116,116,alpha))
        end

        dxDrawText(cache.ticketData.location,sx*0.539,sy*0.341,0,0,tocolor(116,116,116),0.00022*sx,cache.sfcDisplaybold)
        if cache.selectedbox == 3 then
            dxDrawRectangle(sx*0.5398 + dxGetTextWidth(cache.ticketData.location,0.00022*sx,cache.sfcDisplaybold),sy*0.3425,1,sy*0.010,tocolor(116,116,116,alpha))
        end

        dxDrawText(cache.ticketData.offender,sx*0.405,sy*0.3695,0,0,tocolor(116,116,116),0.00022*sx,cache.sfcDisplaybold)
        if cache.selectedbox == 4 then
            dxDrawRectangle(sx*0.4058 + dxGetTextWidth(cache.ticketData.offender,0.00022*sx,cache.sfcDisplaybold),sy*0.371,1,sy*0.010,tocolor(116,116,116,alpha))
        end

        dxDrawText(cache.ticketData.vehiclename,sx*0.405,sy*0.427,0,0,tocolor(116,116,116),0.00022*sx,cache.sfcDisplaybold)
        if cache.selectedbox == 5 then
            dxDrawRectangle(sx*0.4058 + dxGetTextWidth(cache.ticketData.vehiclename,0.00022*sx,cache.sfcDisplaybold),sy*0.4285,1,sy*0.010,tocolor(116,116,116,alpha))
        end

        dxDrawText(cache.ticketData.plate,sx*0.49,sy*0.427,0,0,tocolor(116,116,116),0.00022*sx,cache.sfcDisplaybold)
        if cache.selectedbox == 6 then
            dxDrawRectangle(sx*0.4908 + dxGetTextWidth(cache.ticketData.plate,0.00022*sx,cache.sfcDisplaybold),sy*0.4285,1,sy*0.010,tocolor(116,116,116,alpha))
        end

        dxDrawText(cache.ticketData.color,sx*0.539,sy*0.427,0,0,tocolor(116,116,116),0.00022*sx,cache.sfcDisplaybold)
        if cache.selectedbox == 7 then
            dxDrawRectangle(sx*0.5398 + dxGetTextWidth(cache.ticketData.color,0.00022*sx,cache.sfcDisplaybold),sy*0.4285,1,sy*0.010,tocolor(116,116,116,alpha))
        end

        dxDrawText(cache.ticketData.reason,sx*0.405,sy*0.487,0,0,tocolor(116,116,116),0.00022*sx,cache.sfcDisplaybold)
        if cache.selectedbox == 8 then
            dxDrawRectangle(sx*0.4058 + dxGetTextWidth(cache.ticketData.reason,0.00022*sx,cache.sfcDisplaybold),sy*0.489,1,sy*0.010,tocolor(116,116,116,alpha))
        end

        dxDrawText(cache.ticketData.amount,sx*0.459,sy*0.5717,0,0,tocolor(116,116,116),0.000235*sx,cache.sfcDisplaybold2)
        if cache.selectedbox == 9 then
            dxDrawRectangle(sx*0.4598 + dxGetTextWidth(cache.ticketData.amount,0.000235*sx,cache.sfcDisplaybold2),sy*0.5738,1,sy*0.010,tocolor(116,116,116,alpha))
        end

        dxDrawText(cache.ticketData.offender,sx*0.45,sy*0.723,sx*0.45,sy*0.723,tocolor(111,150,221),0.00045*sx,cache.freeAdelaide,"center","center")
        dxDrawText(cache.ticketData.name,sx*0.55,sy*0.723,sx*0.55,sy*0.723,tocolor(111,150,221),0.00045*sx,cache.freeAdelaide,"center","center")
    end
end
addEventHandler("onClientRender",getRootElement(),func.render)

func.click = function(button,state)
    if cache.show then
        if button == "left" and state == "down" then
            if isInSlot(sx*0.403,sy*0.329,sx*0.082,sy*0.026) then
                cache.selectedbox = 1;
                setElementData(localPlayer,"ticketpanelwrite",true)
                unbindKey("t", "down", "chatbox", "chatboxsay")
            elseif isInSlot(sx*0.4865,sy*0.329,sx*0.049,sy*0.026) then
                cache.selectedbox = 2;
                setElementData(localPlayer,"ticketpanelwrite",true)
                unbindKey("t", "down", "chatbox", "chatboxsay")
            elseif isInSlot(sx*0.537,sy*0.329,sx*0.057,sy*0.026) then
                cache.selectedbox = 3;
                setElementData(localPlayer,"ticketpanelwrite",true)
                unbindKey("t", "down", "chatbox", "chatboxsay")
            elseif isInSlot(sx*0.403,sy*0.357,sx*0.082,sy*0.026) then
                cache.selectedbox = 4;
                setElementData(localPlayer,"ticketpanelwrite",true)
                unbindKey("t", "down", "chatbox", "chatboxsay")
            elseif isInSlot(sx*0.403,sy*0.415,sx*0.082,sy*0.026) then
                cache.selectedbox = 5;
                setElementData(localPlayer,"ticketpanelwrite",true)
                unbindKey("t", "down", "chatbox", "chatboxsay")
            elseif isInSlot(sx*0.4865,sy*0.415,sx*0.049,sy*0.026) then
                cache.selectedbox = 6;
                setElementData(localPlayer,"ticketpanelwrite",true)
                unbindKey("t", "down", "chatbox", "chatboxsay")
            elseif isInSlot(sx*0.537,sy*0.415,sx*0.057,sy*0.026) then
                cache.selectedbox = 7;
                setElementData(localPlayer,"ticketpanelwrite",true)
                unbindKey("t", "down", "chatbox", "chatboxsay")
            elseif isInSlot(sx*0.403,sy*0.476,sx*0.1915,sy*0.06) then
                cache.selectedbox = 8;
                setElementData(localPlayer,"ticketpanelwrite",true)
                unbindKey("t", "down", "chatbox", "chatboxsay")
            elseif isInSlot(sx*0.403,sy*0.568,sx*0.1915,sy*0.021) then
                cache.selectedbox = 9;
                setElementData(localPlayer,"ticketpanelwrite",true)
                unbindKey("t", "down", "chatbox", "chatboxsay")
            else
                setElementData(localPlayer,"ticketpanelwrite",false)
                cache.selectedbox = 0;
                bindKey("t", "down", "chatbox", "chatboxsay")
            end
        end
    end
end
addEventHandler("onClientClick",getRootElement(),func.click)

func.dataChange = function(data)
    if getElementType(source) == "player" then
        if data == "player:typing:console" and getElementData(source,data) then
            setElementData(localPlayer,"ticketpanelwrite",false)
            cache.selectedbox = 0;
            bindKey("t", "down", "chatbox", "chatboxsay")
        end
    end
end
addEventHandler("onClientElementDataChange", getLocalPlayer(), func.dataChange);

func.onClientCharacter = function(character)
    if cache.show then
        if cache.selectedbox == 1 then
            cache.ticketData.name = cache.ticketData.name..character;
        elseif cache.selectedbox == 2 then
            cache.ticketData.date = cache.ticketData.date..character;
        elseif cache.selectedbox == 3 then
            cache.ticketData.location = cache.ticketData.location..character;
        elseif cache.selectedbox == 4 then
            cache.ticketData.offender = cache.ticketData.offender..character;
        elseif cache.selectedbox == 5 then
            cache.ticketData.vehiclename = cache.ticketData.vehiclename..character;
        elseif cache.selectedbox == 6 then
            cache.ticketData.plate = cache.ticketData.plate..character;
        elseif cache.selectedbox == 7 then
            cache.ticketData.color = cache.ticketData.color..character;
        elseif cache.selectedbox == 8 then
            cache.ticketData.reason = cache.ticketData.reason..character;
        elseif cache.selectedbox == 9 then
            if availableCharacter[character] then
                cache.ticketData.amount = cache.ticketData.amount..character;
            end
        end
    end
end
addEventHandler("onClientCharacter", getRootElement(), func.onClientCharacter)

availableCharacter = {
    ["0"] = true;
    ["1"] = true;
    ["2"] = true;
    ["3"] = true;
    ["4"] = true;
    ["5"] = true;
    ["6"] = true;
    ["7"] = true;
    ["8"] = true;
    ["9"] = true;
}

func.deleteText = function()
    if cache.show then
        if cache.selectedbox == 1 then
            cache.ticketData.name = utf8.sub(cache.ticketData.name, 0, utf8.len(cache.ticketData.name)-1)
        elseif cache.selectedbox == 2 then
            cache.ticketData.date = utf8.sub(cache.ticketData.date, 0, utf8.len(cache.ticketData.date)-1)
        elseif cache.selectedbox == 3 then
            cache.ticketData.location = utf8.sub(cache.ticketData.location, 0, utf8.len(cache.ticketData.location)-1)
        elseif cache.selectedbox == 4 then
            cache.ticketData.offender = utf8.sub(cache.ticketData.offender, 0, utf8.len(cache.ticketData.offender)-1)
        elseif cache.selectedbox == 5 then
            cache.ticketData.vehiclename = utf8.sub(cache.ticketData.vehiclename, 0, utf8.len(cache.ticketData.vehiclename)-1)
        elseif cache.selectedbox == 6 then
            cache.ticketData.plate = utf8.sub(cache.ticketData.plate, 0, utf8.len(cache.ticketData.plate)-1)
        elseif cache.selectedbox == 7 then
            cache.ticketData.color = utf8.sub(cache.ticketData.color, 0, utf8.len(cache.ticketData.color)-1)
        elseif cache.selectedbox == 8 then
            cache.ticketData.reason = utf8.sub(cache.ticketData.reason, 0, utf8.len(cache.ticketData.reason)-1)
        elseif cache.selectedbox == 9 then
            cache.ticketData.amount = utf8.sub(cache.ticketData.amount, 0, utf8.len(cache.ticketData.amount)-1)
        end

    end
end
bindKey("backspace","down",func.deleteText)

function finish()
    if cache.show == true then
player = func.findPlayerByText(cache.ticketData.offender)
        cache.show = false
        local money = getElementData(player,"player:money")
        local x,y,z = getElementPosition(player)
        local px,py,pz = getElementPosition(localPlayer)
        if getDistanceBetweenPoints3D(x,y,z,px,py,pz) < 3 then
    setElementData(player,"player:money",money-cache.ticketData.amount)
    exports.Pchat:takeMessage("me","átad egy csekket "..getElementData(player,"player:charname").."-nak/nek.")
        else
            outputChatBox("[P:SA]#ffffff A kiválasztott játékos túl messze van tőled!",129, 99, 191,true)
        end
    end
end
bindKey("enter","down",finish)

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
local playerCache = {}
func.findPlayerByText = function(text)
    for k,player in ipairs(getElementsByType("player")) do
        if getElementData(player,"player:loggedIn") then
            playerCache[player] = true;
        end
    end
	local isString = false;
	local isID = false;
	if (tostring(type(tonumber(text))) == "number") then
		isString = false;
		isID = true;
	else
		isID = false;
		isString = true;
	end
	for player,k in pairs(playerCache) do
		if isID then
			if getElementData(player,"player:id") == tonumber(text) then
				return player;
			end
		elseif isString then
			if getElementData(player,"player:charname"):gsub("_", " ") == text then
				return player;
			end
		end
    end
    return nil;
end

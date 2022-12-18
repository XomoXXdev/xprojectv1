local show = false
local says = {false, "prtial_gngtlka", "prtial_gngtlkb", "prtial_gngtlkc", "prtial_gngtlkd", "prtial_gngtlke", "prtial_gngtlkf", "prtial_gngtlkg", "prtial_gngtlkh", "prtial_hndshk_01", "prtial_hndshk_biz_01"}
local box = {300,35}
local screen = {guiGetScreenSize()}
local pos = {screen[1]/2 -box[1]/2,screen[2]/2 -box[2]/2}
local selectedSayStyle = 1
setElementData(localPlayer, "sayAnim", says[selectedSayStyle])
local sfpro = dxCreateFont("sfpro.ttf",10)
function render()
    if show then
    dxDrawRectangle(pos[1]+25,pos[2]+50,box[1]-50,box[2]-100,tocolor(23,23,23,255)) -- Háttér
    dxDrawText("Beszéd", pos[1]+290,pos[2]-10,pos[1],pos[2],tocolor(129, 99, 191,255),1,sfpro,"center","center")
    dxDrawImage(pos[1]+30,pos[2]-15,30,30,"logo.png",0,0,0,tocolor(129, 99, 191,255))
    dxDrawImage(pos[1]+60,pos[2]+15,25,25,"backarrow.png",180,0,0,tocolor(255,255,255,255)) -- Háttér
    dxDrawImage(pos[1]+220,pos[2]+15,25,25,"backarrow.png",0,0,0,tocolor(255,255,255)) -- Háttér
    dxDrawText("Stílus "..getElementData(localPlayer,"sayStyle") or 0 .."", pos[1]+290,pos[2]+50,pos[1],pos[2],tocolor(255,255,255),1,sfpro,"center","center")
    end
end
addEventHandler("onClientRender",root,render)

function clicking(button,state)
    if button =="left" and state=="down" then
        if show then 
            if isInSlot(pos[1]+60,pos[2]+15,25,25) then
                if selectedSayStyle == #says then
                    selectedSayStyle = 1
                else
                    if selectedSayStyle == 1 then return end
                    selectedSayStyle = selectedSayStyle -1
                end
                
                setElementData(localPlayer, "sayStyle", selectedSayStyle)
                setElementData(localPlayer, "sayAnim", says[selectedSayStyle])
            elseif isInSlot(pos[1]+220,pos[2]+15,25,25) then
                    if selectedSayStyle == #says then
                        selectedSayStyle = 1
                    else
                        selectedSayStyle = selectedSayStyle +1
                    end
                
                setElementData(localPlayer, "sayStyle", selectedSayStyle)
                setElementData(localPlayer, "sayAnim", says[selectedSayStyle])
            end
        end
    end
end
addEventHandler("onClientClick",getRootElement(),clicking)

function closeandopen()
    show = not show
end
bindKey("F3","down",closeandopen)
function close()
    if show then
        show = false
    end
end
bindKey("backspace","down",close)

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

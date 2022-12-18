fileDelete ("sourceC.lua") 
local sx,sy = guiGetScreenSize()
local start = getTickCount()
local cache = {}
cache.roboto = dxCreateFont("files/roboto.ttf",20)
cache.fontawsome = dxCreateFont("files/fontawsome.ttf",20)

local infos = {} -- text , type

local types = {-- r,g,b 
    [1] = {129, 99, 191}, -- info
    [2] = {98, 143, 89}, -- success
    [3] = {147, 59, 61}, -- error
} 

function dxDrawInfobox()
    for k,v in ipairs(infos) do 
    alpha,_,_ = interpolateBetween(0,0,0,255,0,0,(getTickCount()-v[3])/1000,"InQuad")
    text = v[1]
    lenght = dxGetTextWidth(text,0.00033*sx,cache.roboto)

    dxDrawRectangle(sx*0.475 -lenght/2,(k*sy*0.05) - sy*0.03,sx*0.045 + lenght,sy*0.03,tocolor(35,35,35,alpha),true)
    dxDrawRectangle(sx*0.475 -lenght/2,(k*sy*0.05) - sy*0.03,sx*0.02,sy*0.03,tocolor(20,20,20,alpha),true)
    dxDrawRectangle(sx*0.475 -lenght/2,(k*sy*0.05),sx*0.045 + lenght,sy*0.002,tocolor(types[v[2]][1],types[v[2]][2],types[v[2]][3],alpha),true)

    if v[2] == 1 then 
    dxDrawText("",sx*0.4825 - 1 - lenght/2,(k*sy*0.05) - sy*0.0265 + 1,_,_,tocolor(0,0,0,alpha),0.00033*sx,cache.fontawsome,"left","top",false,false,true)
    dxDrawText("",sx*0.4825 - lenght/2,(k*sy*0.05) - sy*0.0265,_,_,tocolor(types[v[2]][1],types[v[2]][2],types[v[2]][3],alpha),0.00033*sx,cache.fontawsome,"left","top",false,false,true)
    elseif v[2] == 2 then 
    dxDrawText("",sx*0.479 - 1 - lenght/2,(k*sy*0.05) - sy*0.026 + 1,_,_,tocolor(0,0,0,alpha),0.00033*sx,cache.fontawsome,"left","top",false,false,true)
    dxDrawText("",sx*0.479 - lenght/2,(k*sy*0.05) - sy*0.026,_,_,tocolor(types[v[2]][1],types[v[2]][2],types[v[2]][3],alpha),0.00033*sx,cache.fontawsome,"left","top",false,false,true)
    elseif v[2] == 3 then 
    dxDrawText("",sx*0.481 - 1 - lenght/2,(k*sy*0.05) - sy*0.025 + 1,_,_,tocolor(0,0,0,alpha),0.00033*sx,cache.fontawsome,"left","top",false,false,true)
    dxDrawText("",sx*0.481 - lenght/2,(k*sy*0.05) - sy*0.025,_,_,tocolor(types[v[2]][1],types[v[2]][2],types[v[2]][3],alpha),0.00033*sx,cache.fontawsome,"left","top",false,false,true)
    end

    dxDrawText(text,sx*0.505 - 1 - lenght/2,(k*sy*0.05) - sy*0.026 + 1,_,_,tocolor(0,0,0,alpha),0.00033*sx,cache.roboto,"left","top",false,false,true)
    dxDrawText(text,sx*0.505 - lenght/2,(k*sy*0.05) - sy*0.026,_,_,tocolor(255,255,255,alpha),0.00033*sx,cache.roboto,"left","top",false,false,true)

    if v[3] + 5000 < getTickCount() then
        v[4] = v[4] - 15
        if v[4] < 0 then
        v[4] = 0
        table.remove(infos, k)
        end
    end 

    end
end 
addEventHandler("onClientRender",root,dxDrawInfobox)

function insertNotification(text,type)
    tableToRecord = {text,type,getTickCount(),-50,0}
    table.insert(infos, tableToRecord)

    if #infos >= 5 then
        table.remove(infos,1)
    end
end 

function addNotification(text,type)
    local text = tostring(text)
    if type == "info" then 
        insertNotification(text,1)
        playSound("files/blub.mp3")
    elseif type == "success" then 
        insertNotification(text,2)
        playSound("files/blub.mp3")
    elseif type == "error" then 
        insertNotification(text,3) 
        playSound("files/blub.mp3")
    end 
end

addEvent("infoboxClient", true)
addEventHandler("infoboxClient", root, function(text, type)
	addNotification(text, type)
end)

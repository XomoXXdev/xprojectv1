fileDelete ("sourceC.lua") 
local craftX = screen[1]/2;
local craftY = screen[2]/2;
local width = craftSlots*(itemSize+margin)+margin;
local height = craftSlots*(itemSize+margin)+margin;

func.craft.start = function()
--    cache.craft.show = true;
--    addEventHandler("onClientRender",getRootElement(),func.craft.render)
--    addEventHandler("onClientClick",getRootElement(),func.craft.click)
end
addEventHandler("onClientResourceStart",resourceRoot,func.craft.start)

func.craft.render = function()

    if cache.craft.moving then
        if isCursorShowing() then
            local cursorX,cursorY = func.getCursorPosition()
            craftX = cursorX - cache.craft.defX
            craftY = cursorY - cache.craft.defY
        else
            cache.craft.moving = false
        end
    end

    local drawRow = 0
	local drawColumn = 0

    cache.craft.cursorInSlot = false
    cache.craft.cursorInCraftbox = false
	cache.craft.hoverSlot = -1
	cache.craft.hoverItem = nil

    if func.inBox(craftX,craftY-24,width+44,height+60) then
        cache.craft.cursorInCraftbox = true;
    end

    dxDrawRectangle(craftX,craftY-24,width,height+60,tocolor(25,25,25,255))
    dxDrawRectangle(craftX+width,craftY-24,44,height+60,tocolor(25,25,25,255))

    if func.inBox(craftX+width,craftY-24 +height/2+margin-1,itemSize,itemSize) then
        dxDrawRectangle(craftX+width,craftY-24 +height/2+margin-1,itemSize,itemSize,tocolor(129, 99, 191,255))
    else
        dxDrawRectangle(craftX+width,craftY-24 +height/2+margin-1,itemSize,itemSize,tocolor(29,29,29,255))
    end

    if cache.craft.craftedItem > 0 and cache.craft.progress == 208 then
        dxDrawImage(craftX+width,craftY-24 +height/2+margin-1,itemSize,itemSize,getItemImage(cache.craft.craftedItem))
        if func.inBox(craftX+width,craftY-24 +height/2+margin-1,itemSize,itemSize) then
            dxDrawRectangle(craftX+width,craftY-24 +height/2+margin-1,itemSize,itemSize,tocolor(0,0,0,120))
        end
    end

    dxDrawText("Barkácsolás",craftX+8-1,craftY-18+1,0,0,tocolor(0,0,0,255),0.6,cache.font.sansheavy,"left","top");
    dxDrawText("Barkácsolás",craftX+8,craftY-18,0,0,tocolor(255,255,255,255),0.6,cache.font.sansheavy,"left","top");


    --208

    dxDrawRectangle(craftX+margin,craftY+height,craftSlots*itemSize +margin*craftSlots-margin,28,tocolor(29,29,29,255))

    if func.inBox(craftX+margin,craftY+height,craftSlots*itemSize +margin*craftSlots-margin,28) then
        dxDrawRectangle(craftX+margin,craftY+height,cache.craft.progress,28,tocolor(129, 99, 191,255))
    else
        if cache.craft.progress == 208 then
            dxDrawRectangle(craftX+margin,craftY+height,craftSlots*itemSize +margin*craftSlots-margin,28,tocolor(29,29,29,255))
        else
            dxDrawRectangle(craftX+margin,craftY+height,cache.craft.progress,28,tocolor(129, 99, 191,255))
        end
    end
    dxDrawText("Tárgy elkészítése",craftX+margin+24,craftY+height,0,0,tocolor(255,255,255,255),0.7,cache.font.roboto,"left","top");

    for i = 1, craftSlots * craftSlots do
        local left = craftX + drawColumn * (itemSize + margin) + margin;
        local top = craftY + drawRow * (itemSize + margin) + margin;
        local hover = func.inBox(left,top,itemSize,itemSize);

        if hover then
            cache.craft.cursorInSlot = true
            cache.craft.hoverSlot = i
            if not craftItems[i] then
                dxDrawRectangle(left,top,itemSize,itemSize,tocolor(129, 99, 191,255))
            end
        else
            dxDrawRectangle(left,top,itemSize,itemSize,tocolor(29,29,29,255))
        end

        if craftItems[i] then
            dxDrawImage(left,top,itemSize,itemSize,getItemImage(craftItems[i].item))
            if hover then
                cache.craft.moveX = left
				cache.craft.moveY = top
                cache.craft.hoverItem = craftItems[i]
                dxDrawRectangle(left,top,itemSize,itemSize,tocolor(0,0,0,120))
            end
        end

        drawColumn = drawColumn + 1;
        if (drawColumn == craftSlots) then
            drawColumn = 0;
            drawRow = drawRow + 1;
        end
    end

    if cache.craft.itemMove then
        if isCursorShowing() then    
            local x, y = func.getCursorPosition()
            moveX,moveY = x - cache.craft.defX,y - cache.craft.defY
        else
            moveX,moveY = 0,0
            if cache.craft.itemMove then
                cache.craft.itemMove = false
                cache.craft.movedSlot = -1
            end
        end
        dxDrawImage(moveX,moveY,itemSize,itemSize,getItemImage(cache.craft.movedItem["item"]),0,0,0,tocolor(255,255,255,255),true);
    --    local count = cache.craft.movedItem["count"];

    --    local cleft,ctop = moveX+itemSize-margin/2+2,moveY;
    --    dxDrawText(count,cleft-1,ctop+1,cleft-1,ctop+1,tocolor(0,0,0,255),0.42,cache.font.roboto,"right","top",false,false,true)
    --    dxDrawText(count,cleft,ctop,cleft,ctop,tocolor(255,255,255,255),0.42,cache.font.roboto,"right","top",false,false,true)
    end

end

func.craft.click = function(button,state)
    if button == "left" then
        if state == "down" then
            
            if not cache.craft.moving and func.inBox(craftX,craftY-24,width+44,26) then
                cache.craft.moving = true
				local cursorX, cursorY = func.getCursorPosition()
				local x,y = craftX,craftY
				cache.craft.defX, cache.craft.defY = cursorX - x, cursorY - y
            end

            if not cache.inventory.itemMove and cache.craft.hoverSlot > 0 and cache.craft.hoverItem and not cache.craft.itemMove then
                cache.craft.movedSlot = cache.craft.hoverSlot
                cache.craft.movedItem = cache.craft.hoverItem
                cache.craft.itemMove = true
                local cursorX,cursorY = func.getCursorPosition()
                local x,y = cache.craft.moveX,cache.craft.moveY
                cache.craft.defX,cache.craft.defY = cursorX - x, cursorY - y
            end

            if func.inBox(craftX+width,craftY-24 +height/2+margin-1,itemSize,itemSize) then
                if cache.craft.craftedItem > 0 and cache.craft.progress == 208 then
                    triggerServerEvent("giveItem",localPlayer,localPlayer,cache.craft.craftedItem,1,1)
                    outputChatBox("[xProject]:#ffffff Sikeresen kivettél egy #8163bf"..getItemName(cache.craft.craftedItem).."#ffffff-t.",129, 99, 191,true)
                    cache.craft.craftedItem = 0;
                end
            end
            if func.inBox(craftX+margin,craftY+height,craftSlots*itemSize +margin*craftSlots-margin,28) then
                
                local craftItemcount = 0;
                for i = 1, craftSlots * craftSlots do
                    if craftItems[i] then
                        craftItemcount = craftItemcount+1;
                    end
                end

                local deleteCache = {};

                for finishItem,data in pairs(availableCraft) do
                    local count = 0;
                    for k,v in pairs(data) do
                        if craftItems[v[2]] and craftItems[v[2]].slot == v[2] and craftItems[v[2]].item == v[1] then
                            local state,itemData,itemSlot = hasItem(craftItems[v[2]].item);
                            if state then --func.setItemCount = function(slot,count
                                --iprint({craftItems[v[2]].item,tonumber(itemData.count),tonumber(itemSlot)})
                                table.insert(deleteCache,v[2],{craftItems[v[2]].item,tonumber(itemData.count),tonumber(itemSlot)})
                                count = count+1;
                           end
                        end
                    end
                    if #data == count then
                        if craftItemcount == #data then
                            cache.craft.craftedItem = finishItem;
                            cache.craft.progress = 0;
                            for deletedcraftSlot,deleteditem in pairs(deleteCache) do
                                craftItems[deletedcraftSlot] = nil;
                                func.setItemCount(deleteditem[3],deleteditem[2]-1,"bag",false,localPlayer)
                            end
                        end
                    end
                end
            end
        elseif state == "up" then
            if cache.craft.moving then
                cache.craft.moving = false;
            end
            if cache.craft.itemMove then
                if cache.craft.hoverSlot > 0 then
                    if not craftItems[cache.craft.hoverSlot] then
                        craftItems[cache.craft.hoverSlot] = craftItems[cache.craft.movedSlot];
                        craftItems[cache.craft.hoverSlot].slot = cache.craft.hoverSlot;
                        craftItems[cache.craft.movedSlot] = nil;
                    end
                end

                if not cache.craft.cursorInCraftbox then
                    craftItems[cache.craft.movedSlot] = nil;
                end
                cache.craft.itemMove = false
                cache.craft.movedSlot = -1
            end
        end
    end
end
--[[addEventHandler("onResourceStart", resourceRoot, function()
    for k, animation in ipairs(animations) do
        addCommandHandler(animation[1], function(thePlayer, cmd)
        if not getElementData(thePlayer,"anim") then 
        setPedAnimation(thePlayer, animation[2], animation[3], animation[4], animation[5], false, false)
        setElementData(thePlayer,"player:animation",true)
        end
        end)
    end
end)]]

addEventHandler("onResourceStart", resourceRoot, function()
    for k, animation in ipairs(animations) do
        addCommandHandler(animation[1], function(thePlayer, cmd)
        if not getElementData(thePlayer,"anim") then 
            triggerClientEvent(root,"setAnimation",root,thePlayer,cmd)
        end
        end)
    end
end)

function trigger(thePlayer,k)
        if not getElementData(thePlayer,"anim") then 
            triggerClientEvent(root,"setAnimation",root,thePlayer,k)
        end
end 
addEvent("trigger",true)
addEventHandler("trigger",root,trigger)
 
function stopAnim(thePlayer)
    if getElementData(thePlayer,"player:animation") and not getElementData(thePlayer,"anim") and not getElementData(thePlayer,"dead") then 
       setPedAnimation(thePlayer,false)
       setElementData(thePlayer,"player:animation",false)
    end 
end 
addEvent("stopAnim",true)
addEventHandler("stopAnim",root,stopAnim)
addCommandHandler("stopAnim",stopAnim) 
addCommandHandler("stopanim",stopAnim) 
addCommandHandler("StopAnim",stopAnim) 
   
--[[function setAnimation(thePlayer,anim)
    for k,animation in pairs(animations) do 
        if anim == animation[1] then 
            setPedAnimation(thePlayer, animation[2], animation[3], animation[4], animation[5], false, false)
            setElementData(thePlayer,"player:animation",true)
        end 
    end 
end 
addEvent("setAnimation",true)
addEventHandler("setAnimation",root,setAnimation)]]
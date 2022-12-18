function setLevel(element,level,pp) 

        outputChatBox("#8163bf[Szint]: #ffffffSzint lépés! Új szinted: #8163bf"..level..". #ffffffJutalmad: #4477c9"..pp.." #ffffffprémium pont",element,255,255,255,true)
        setElementData(element,"player:level",tonumber(level))
        setElementData(element,"player:pp",getElementData(element,"player:pp") + tonumber(pp))

end  
addEvent("setLevel",true)
addEventHandler("setLevel",root,setLevel)

function setPlayerLevel(thePlayer,cmd,target,level)
    if not target or not level then outputChatBox("#8163bfHasználat:#ffffff /"..cmd.." [ID] [Szint]",thePlayer,255,255,255,true) return end 
    if not tonumber(level) then outputChatBox("#8163bf[xProject]: #ffffffHelytelen érték.",thePlayer,255,255,255,true) return end
    if tonumber(level) > 100 or tonumber(level) < 1 then outputChatBox("#8163bf[xProject]: #ffffffA szintnek 1 és 100 között kell lennie!",thePlayer,255,255,255,true) return end 

    local targetPlayer = exports["Pcore"]:findPlayerByPartialNick(thePlayer, target)

    if not getElementData(targetPlayer,"player:loggedIn") then outputChatBox("#8163bf[xProject]: #ffffffA kiválasztott játékos jelenleg nem elérhető.",thePlayer,255,255,255,true) return end

    setElementData(targetPlayer,"player:level",tonumber(level))
    outputChatBox("#8163bf[xProject]: #ffffffMegváltoztattad #8163bf"..utf8.gsub(getElementData(targetPlayer,"player:charname"),"_"," ").." #ffffffszintjét #8163bf"..level.." #ffffffra/re." ,thePlayer,255,255,255,true)
    outputChatBox("#8163bf[xProject]: "..utf8.gsub(getElementData(thePlayer,"player:adminname"),"_"," ").." #ffffffmegváltoztatta a szinted #8163bf"..level.." #ffffffra/re." ,targetPlayer,255,255,255,true)
    exports["Padmin"]:outputAdminMessage(utf8.gsub(getElementData(targetPlayer,"player:adminname"),"_"," ").." #FFFFFFmegváltoztatta #8163bf"..utf8.gsub(getElementData(targetPlayer,"player:charname"),"_"," ").." #ffffffszintjét #8163bf"..level.." #ffffffra/re.")

    

end 
addCommandHandler("setplayerlevel",setPlayerLevel)
addCommandHandler("setPlayerLevel",setPlayerLevel)
addCommandHandler("setlevel",setPlayerLevel)

function setPlayerMinute(thePlayer,cmd,target,minute)
    if not target or not minute then outputChatBox("#8163bfHasználat:#ffffff /"..cmd.." [ID] [Perc]",thePlayer,255,255,255,true) return end 
    if not tonumber(minute) then outputChatBox("#8163bf[xProject]: #ffffffHelytelen érték.",thePlayer,255,255,255,true) return end

    local targetPlayer = exports["Pcore"]:findPlayerByPartialNick(thePlayer, target)

    if not getElementData(targetPlayer,"player:loggedIn") then outputChatBox("#8163bf[xProject]: #ffffffA kiválasztott játékos jelenleg nem elérhető.",thePlayer,255,255,255,true) return end

    setElementData(targetPlayer,"player:minutes",tonumber(minute))
    outputChatBox("#8163bf[xProject]: #ffffffMegváltoztattad #8163bf"..utf8.gsub(getElementData(targetPlayer,"player:charname"),"_"," ").." #ffffffjátszott percét #8163bf"..minute.."perc #ffffffra/re." ,thePlayer,255,255,255,true)
    outputChatBox("#8163bf[xProject]: "..utf8.gsub(getElementData(thePlayer,"player:adminname"),"_"," ").." #ffffffmegváltoztatta a játszott percét #8163bf"..minute.."perc #ffffffra/re." ,targetPlayer,255,255,255,true)
    exports["Padmin"]:outputAdminMessage(utf8.gsub(getElementData(targetPlayer,"player:adminname"),"_"," ").." #FFFFFFmegváltoztatta #8163bf"..utf8.gsub(getElementData(targetPlayer,"player:charname"),"_"," ").." #ffffffjátszott percét #8163bf"..minute.."perc #ffffffra/re.")

    

end 
addCommandHandler("setplayerminute",setPlayerMinute)
addCommandHandler("setPlayerMinute",setPlayerMinute)
addCommandHandler("setminute",setPlayerMinute)
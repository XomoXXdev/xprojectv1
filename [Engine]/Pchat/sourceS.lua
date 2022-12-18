local hung = {[utfChar(252)] = "Ü",["ö"] = "Ö",["ú"] = "Ó",["ú"] = "Ú",["ű"] = "Ű",["é"] = "É",["í"] = "Í",["á"] = "Á"}
local cache = {}
local placedo = {}

local undetectedCommands = {
 ["fly"] = true,
 ["lleft"] = true,
 ["lright"] = true,
}

function spamBlocker(command)
if not undetectedCommands[command] then 
  if not cache[source] then
    cache[source] = {}
    cache[source]["num"] = 1
    cache[source]["kick"] = 1
  else
    local source = source
    cache[source]["num"] = cache[source]["num"] + 1
    if cache[source]["num"] >= 5 and cache[source]["num"] <= 10 then
      cancelEvent()
      outputChatBox("1 másodpercen belül csak 5 parancs használható!", source, 246,137,52,true)
      cache[source]["kick"] = cache[source]["kick"] + 1
      if cache[source]["kick"] >= 5 then 
        kickPlayer(source,"Console","Chat Spam")
      end 
    end
  end
end
end
addEventHandler("onPlayerCommand", root, spamBlocker)

setTimer(function()
  cache = {}
end, 2000, 0)

  function string.count (text, search)
    if ( not text or not search ) then return false end

    return select ( 2, text:gsub ( search, "" ) );
  end

  function firstToUpper(str)
    local first = utfSub(str,1,1):upper()
    if hung[first] then
      first = hung[first]
    end
    return (first..utfSub(str,2,#str))
  end

  function takeMessage(element,type,message)
    if not getElementData(element,"ticketpanelwrite") then
      local name = utf8.gsub(getElementData(element,"player:charname"),"_"," ") or "Ismeretlen"

      if getElementData(element,"player:adminduty") then
        name = "#8163bf"..getElementData(element,"player:adminname").."" or "Ismeretlen"
      end

      message = string.gsub(message, "#%x%x%x%x%x%x", "")
      local px,py,pz = getElementPosition(element)
      local veh = getPedOccupiedVehicle(element)

      for _,player in ipairs(getElementsByType("player")) do
        if isElement(player) then
          local distance = getDistanceBetweenPoints3D(px, py, pz, getElementPosition(player))
          if getElementInterior(element) == getElementInterior(player) then
            if getElementDimension(element) == getElementDimension(player) then
              if not getElementData(element,"box:writing") then  
              if type == "ic" then

                if veh then

                  if distance < 5 then
                    outputChatBox(name.." mondja (Járműben) : "..firstToUpper(message),player,255,255,255,true)
                    triggerClientEvent(player,"insertBubble",player,element,firstToUpper(message),"ic",1)
                  end

                else
                  if getElementData(source, "sayAnim") then
                    setPedAnimation(source, "GANGS", getElementData(source, "sayAnim"), #message * 150, true, true, false, false)
                  end
                  if distance < 5 then
                    outputChatBox(name.." mondja: "..firstToUpper(message),player,255,255,255,true)
                    triggerClientEvent(player,"insertBubble",player,element,firstToUpper(message),"ic",1)
                  elseif distance < 10 then
                    outputChatBox(name.." mondja: "..firstToUpper(message),player,135,135,135,true)
                    triggerClientEvent(player,"insertBubble",player,element,firstToUpper(message),"ic",1)
                  elseif distance < 15 then
                    outputChatBox(name.." mondja: "..firstToUpper(message),player,38,38,38,true)
                    triggerClientEvent(player,"insertBubble",player,element,firstToUpper(message),"ic",1)
                  end

                end

              elseif type == "me" then

                if distance < 5 then
                  outputChatBox("*** "..name.." "..message.."",player,194, 162, 218,true)
                  triggerClientEvent(player,"insertBubble",player,element,"***"..message.."","me",1)
                end

              elseif type == "do" then

                if distance < 5 then
                  outputChatBox("*"..message.." (("..name.."))",player,255, 51, 102,true)
                  triggerClientEvent(player,"insertBubble",player,element,"*"..message,"do",1)
                end

              elseif type == "ame" then

                if distance < 5 then
                  outputChatBox(name.." "..message,player,232, 199, 240,true)
                  triggerClientEvent(player,"insertBubble",player,element,message,"ame",1)
                end

              elseif type == "try" then

                local succes = math.random(1,2)

                if distance < 5 then
                  if succes == 1 then
                    outputChatBox(""..name.. " megpróbál "..message.." és sikerül neki",player,124, 197, 118,true)
                    triggerClientEvent(player,"insertBubble",player,element,"Megpróbál "..message.." és sikerül neki.","try",1)
                  elseif succes == 2 then
                    outputChatBox(""..name.. " megpróbál "..message.." de sajnos nem sikerül neki",player,204, 69, 85,true)
                    triggerClientEvent(player,"insertBubble",player,element,"Megpróbál "..message.." de sajnos nem sikerül neki.","try",2)
                  end
                end

              elseif type == "shout" then

                if distance < 20 then
                  outputChatBox(name.." kiáltja: "..firstToUpper(message),player,255,255,255)
                  triggerClientEvent(player,"insertBubble",player,element,"Kiáltva: "..firstToUpper(message),"shout",1)
                end

              elseif type == "whisper" then

                if distance < 3 then
                  outputChatBox(name.." suttogja: "..firstToUpper(message),player,255,255,255)
                end

              elseif type == "megaphone" then


                if distance < 25 then
                  outputChatBox(name.." mondja a megaphoneba: "..firstToUpper(message),player,214, 212, 64)
                end

              elseif type == "radio" then


                Playerfrequency = getElementData(player,"player:frequency")
                frequency = getElementData(element,"player:frequency")

                --[[ if frakciobanvan then
                frakirang = getFrakirang()
                end ]]

                if Playerfrequency == frequency then

                  outputChatBox(name.." mondja: "..firstToUpper(message),player,0, 206, 209)
                  triggerClientEvent(player, "radio.sound", player)
                else

                  if distance < 5 then
                    outputChatBox(name.." mondja a rádióba: "..firstToUpper(message),player,255,255,255,true)
                  elseif distance < 10 then
                    outputChatBox(name.." mondja a rádióba: "..firstToUpper(message),player,135,135,135,true)
                  elseif distance < 15 then
                    outputChatBox(name.." mondja a rádióba: "..firstToUpper(message),player,38,38,38,true)
                  end

                end

              end
              end


            end
          end


        end
      end
    end
  end
  addEvent("takeMessage",true)
  addEventHandler("takeMessage",root,takeMessage)

  function inputChat(message, messageType)
    cancelEvent()
    if (getElementData(source,"player:loggedIn")) and not (getElementData(source,"dead")) then
      if isElement(source) then
        if not getElementData(source,"box:writing") then 
        if messageType ~= 2 then
          if messageType == 0 then
            if message == ":D" or message ==":d" then
              takeMessage(source,"me","nevet.")
              setPedAnimation(source,"rapping","laugh_01",-1,false,false,false,false);
              return;
            elseif message == "XD" or message == "xd" then
              takeMessage(source,"me","szakad a nevetéstől.");
              setPedAnimation(source,"rapping","laugh_01",-1,false,false,false,false);
              return;
            elseif message == ":)" then
              takeMessage(source,"me","mosolyog.");
              return;
            elseif message == ":P" then
              takeMessage(source,"me","kinyújtja a nyelvét.");
              return;
            elseif message == ":)" then
              takeMessage(source,"me","mosolyog.");
              return;
            elseif message == ":(" or message == ":C" then
              takeMessage(source,"me","szomorú.");
              return;
            elseif message == "o-o" or message == "O.O" or message == "O-O" or message == "o.o" or message == "O_O" then
              takeMessage(source,"me","meglepődik.");
              return;
            elseif message == ";)" then
              takeMessage(source,"me","kacsint.");
              return;
            elseif message == ";C" or message == ";(" then
              takeMessage(source,"me","sírva fakad.");
              setPedAnimation(source,"GRAVEYARD","mrnF_loop",-1,false,false,false,false);
              return;
            elseif message == ":*" then
              takeMessage(source,"me","küld egy puszit a kezével.");
              return;
            elseif message == "<3" then
              takeMessage(source,"do","szeretve érzi magát.");
              return;
            end
        


            takeMessage(source,"ic", message)

          elseif messageType == 1 then

            cancelEvent()
            takeMessage(source,"me",message)

          end
        end
        end
      end
    end
  end
  addEventHandler("onPlayerChat", getRootElement(),inputChat)

  function inputDo(thePlayer,cmd,...)
    if getElementData(thePlayer,"player:loggedIn") and not getElementData(thePlayer,"dead") then
      if not ... then outputChatBox("#8163bf[Chat] #ffffff/"..cmd.." [Történés]",thePlayer,255,255,255,true) return end
      local message = table.concat({...}," ")
      takeMessage(thePlayer,"do", message)
    end
  end
  addCommandHandler("do",inputDo)

  function inputAme(thePlayer,cmd,...)
    if getElementData(thePlayer,"player:loggedIn") and not getElementData(thePlayer,"dead") then

      if not ... then outputChatBox("#8163bf[Chat] #ffffff/"..cmd.." [Leírás]",thePlayer,255,255,255,true) return end
      local message = table.concat({...}," ")
      takeMessage(thePlayer,"ame", message)
    end
  end
  addCommandHandler("ame",inputAme)

  function inputShout(thePlayer,cmd,...)
    if getElementData(thePlayer,"player:loggedIn") and not getElementData(thePlayer,"dead")  then

      if not ... then outputChatBox("#8163bf[Chat] #ffffff/"..cmd.." [Szöveg]",thePlayer,255,255,255,true) return end
      local message = table.concat({...}," ")
      takeMessage(thePlayer,"shout", message)
      setPedAnimation(thePlayer,"ON_LOOKERS","shout_01",1000,false,false,false,false)
    end
  end
  addCommandHandler("s",inputShout)
  addCommandHandler("S",inputShout)

  function inputWhisper(thePlayer,cmd,...)
    if getElementData(thePlayer,"player:loggedIn") and not getElementData(thePlayer,"dead") then

      if not ... then outputChatBox("#8163bf[Chat] #ffffff/"..cmd.." [Szöveg]",thePlayer,255,255,255,true) return end
      local message = table.concat({...}," ")
      takeMessage(thePlayer,"whisper", message)
    end
  end
  addCommandHandler("c",inputWhisper)
  addCommandHandler("C",inputWhisper)

  function inputTry(thePlayer,cmd,...)
    if getElementData(thePlayer,"player:loggedIn") and not getElementData(thePlayer,"dead")  then

      if not ... then outputChatBox("#8163bf[Chat] #ffffff/"..cmd.." [Szöveg]",thePlayer,255,255,255,true) return end
      local message = table.concat({...}," ")
      takeMessage(thePlayer,"try", message)
    end
  end
  addCommandHandler("try",inputTry)
  addCommandHandler("megprobal",inputTry)
  addCommandHandler("megpróbál",inputTry)
  addCommandHandler("Megprobal",inputTry)
  addCommandHandler("Megpróbál",inputTry)
  addCommandHandler("megprobalja",inputTry)
  addCommandHandler("megpróbálja",inputTry)
  addCommandHandler("Megprobalja",inputTry)
  addCommandHandler("Megpróbálja",inputTry)

  function inputMegaphone(thePlayer,cmd,...)
    if getElementData(thePlayer,"player:loggedIn") and not getElementData(thePlayer,"dead") then
      local playerDbid = getElementData(thePlayer,"player:dbid")
      if  exports.Pdash:isPlayerInGroup(1,playerDbid) or exports.Pdash:isPlayerInGroup(2,playerDbid) or exports.Pdash:isPlayerInGroup(3,playerDbid) then
      if not ... then outputChatBox("#8163bf[Chat] #ffffff/"..cmd.." [Szöveg]",thePlayer,255,255,255,true) return end

      --  if exports["vice_inventory"]:hasItem(thePlayer,101,getElementData(thePlayer,"dbid")) then
      local message = table.concat({...}," ")
      takeMessage(thePlayer,"megaphone", message)
      --  end
      end
    end
  end
  addCommandHandler("m",inputMegaphone)

  function inputOOC(thePlayer,cmd,...)
    if getElementData(thePlayer,"player:loggedIn") and not getElementData(thePlayer,"dead") then

      if not ... then outputChatBox("#8163bf[Chat] #ffffff/"..cmd.." [Szöveg]",thePlayer,255,255,255,true) return end


      local px,py,pz = getElementPosition(thePlayer)
      for _,player in ipairs(getElementsByType("player")) do
        local message = table.concat({...}," ")
        local name = utf8.gsub(getElementData(thePlayer,"player:charname"),"_"," ")

        if isElement(player) then
          local distance = getDistanceBetweenPoints3D(px, py, pz, getElementPosition(player))

          if distance < 15 then
            if getElementData(thePlayer,"player:adminduty") then
			    if getElementData(thePlayer,"player:admin") == 1 then
                    name = "#8163bf[Admin 1] "..getElementData(thePlayer,"player:adminname").."" or "Ismeretlen"
				elseif getElementData(thePlayer,"player:admin") == 2 then
                    name = "#8163bf[Admin 2] "..getElementData(thePlayer,"player:adminname").."" or "Ismeretlen"
				elseif getElementData(thePlayer,"player:admin") == 3 then
                    name = "#8163bf[Admin 3] "..getElementData(thePlayer,"player:adminname").."" or "Ismeretlen"
				elseif getElementData(thePlayer,"player:admin") == 4 then
                    name = "#8163bf[Admin 4] "..getElementData(thePlayer,"player:adminname").."" or "Ismeretlen"
				elseif getElementData(thePlayer,"player:admin") == 5 then
                    name = "#8163bf[Admin 5] "..getElementData(thePlayer,"player:adminname").."" or "Ismeretlen"
				elseif getElementData(thePlayer,"player:admin") == 6 then
                    name = "#9600ff[FőAdmin] "..getElementData(thePlayer,"player:adminname").."" or "Ismeretlen"
				elseif getElementData(thePlayer,"player:admin") == 7 then
                    name = "#ff6d3a[SzuperAdmin] "..getElementData(thePlayer,"player:adminname").."" or "Ismeretlen"
				elseif getElementData(thePlayer,"player:admin") == 8 then
                    name = "#028cf6[Manager] "..getElementData(thePlayer,"player:adminname").."" or "Ismeretlen"
				elseif getElementData(thePlayer,"player:admin") == 9 then
                    name = "#ff5353[Rendszergazda] "..getElementData(thePlayer,"player:adminname").."" or "Ismeretlen"
				elseif getElementData(thePlayer,"player:admin") == 10 then
                    name = "#44C8ff[Fejlesztő] "..getElementData(thePlayer,"player:adminname").."" or "Ismeretlen"
				elseif getElementData(thePlayer,"player:admin") == 11 then
                    name = "#ff7171[Tulajdonos] "..getElementData(thePlayer,"player:adminname").."" or "Ismeretlen"
				end
            end

            triggerClientEvent(player,"InsertOOC",player,name.." (( "..message.." ))")
          end
        end
      end

    end
  end
  addCommandHandler("b",inputOOC)
  addCommandHandler("LocalOOC",inputOOC)

  --functions

  function pay(thePlayer,cmd,target,money)
    if not target or not money then outputChatBox("#8163bf[Pay] #ffffff/"..cmd.." [ID] [Összeg]",thePlayer,255,255,255,true) return end
    if not tonumber(money) then outputChatBox("#8163bf[Pay] #ffffffNumerikus értéket adj meg.",thePlayer,255,255,255,true) return end
    local targetPlayer = exports["Pcore"]:findPlayerByPartialNick(thePlayer,target)
    if targetPlayer == thePlayer then outputChatBox("#8163bf[Pay] #ffffffSaját magadnak nem adhatsz pénzt.",thePlayer,255,255,255,true) return end
    local px,py,pz = getElementPosition(thePlayer)
    local x,y,z = getElementPosition(targetPlayer)
    local distance = getDistanceBetweenPoints3D(px,py,pz,x,y,z)
    if distance > 1.2 then outputChatBox("#8163bf[Pay] #ffffffTúl távol vagy a kiválasztott játékostól.",thePlayer,255,255,255,true) return end
    money = math.floor(money)
    if money < 1 then outputChatBox("#8163bf[Pay] #ffffffAz összeg nem lehet 1$-nál kevesebb.",thePlayer,255,255,255,true) return end
    if money > getElementData(thePlayer,"player:money") then outputChatBox("#8163bf[Pay] #ffffffNincs nálad ennyi pénz.",thePlayer,255,255,255,true) return end
    if getElementData(thePlayer,"payProgress") or getElementData(targetPlayer,"payProgress") then outputChatBox("#8163bf[Pay] #ffffffAz másik félnél már folyamatban van egy művelet.",thePlayer,255,255,255,true) return end

    setElementData(thePlayer,"payProgress",true)
    setElementData(targetPlayer,"payProgress",true)
    outputChatBox("#8163bf[Pay] #ffffffAz átadás pár másodpercen belül megkezdődik.",thePlayer,255,255,255,true)

    setTimer(function()
    outputChatBox("#8163bf[Pay] #ffffffÁtadtál #8163bf"..money.."$#ffffff-t #8163bf"..getElementData(targetPlayer,"player:charname").."#ffffff-nak/nek.",thePlayer,255,255,255,true)
    outputChatBox("#8163bf[Pay] "..getElementData(thePlayer,"player:charname").." #ffffffátadott neked #8163bf"..money.."$#ffffff-.t",targetPlayer,255,255,255,true)
    takeMessage(thePlayer,"me","átadott egy kis pénzt "..getElementData(targetPlayer,"player:charname").."-nak/nek.")
    setElementData(thePlayer,"player:money",getElementData(thePlayer,"player:money") - money)
    setElementData(targetPlayer,"player:money",getElementData(targetPlayer,"player:money") + money)
    setElementData(thePlayer,"payProgress",false)
    setElementData(targetPlayer,"payProgress",false)

    if getElementData(thePlayer,"player:adminduty") and getElementData(thePlayer,"player:admin") <= 5 then exports["vice_admin"]:outputAdminMessage("#ffffff"..getElementData(thePlayer,"player:adminname").." dutyban payelt "..utf8.gsub(getPlayerName(targetPlayer),"_"," ").."-nak/nek "..money.."$-t") end

    if money > 999999 then
      exports["Padmin"]:outputAdminMessage(""..utf8.gsub(getElementData(thePlayer,"player:charname"),"_"," ").." "..money.."$#ffffff-t adott át #8163bf"..utf8.gsub(getElementData(targetPlayer,"player:charname"),"_"," ").."#ffffff-nak/nek.")
    end
    end,2000,1)

  end
  addCommandHandler("pay",pay)

function setRadiofrequency(thePlayer,cmd,number)
    if getElementData(thePlayer,"player:loggedIn") and not getElementData(thePlayer,"dead") then
      if not number then outputChatBox("#8163bf[Chat] #ffffff/"..cmd.." [Frekvencia]",thePlayer,255,255,255,true) return end
      number = math.floor(number)
      dbid = getElementData(thePlayer,"player:dbid")
      if number == 20020304 and not exports.pdash:isinfaction(2,thePlayer) then
        outputChatBox("#8163bf[xProject] #ffffffVédett frekvencia!",thePlayer,255,255,255,true) return end
          setElementData(thePlayer,"player:frequency",number)
          outputChatBox("#8163bf[Chat] #ffffffSikeresen megváltoztattad a Walkie Talkied frekvenciáját a következőre: #8163bf"..number.."#ffffff MHz.",thePlayer,255,255,255,true)
         
    end
end
addCommandHandler("tuneradio",setRadiofrequency)


  function walkieTalkie(thePlayer,cmd,...)
    if getElementData(thePlayer,"player:loggedIn") and not getElementData(thePlayer,"dead") then
      if not ... then outputChatBox("#8163bf[Chat] #ffffff/"..cmd.." [Üzenet]",thePlayer,255,255,255,true) return end
      if exports["inventory"]:hasItem(thePlayer,149) then
        if getElementData(thePlayer,"player:frequency") == 0 then outputChatBox("#8163bf[Chat] #ffffffMég nem állítottál be frekvenciát a rádiódnak, ehez használd a #e34058/tuneradio #ffffffparancsot.",thePlayer,255,255,255,true) return end
        local message = table.concat({...}," ")

         takeMessage(thePlayer,"radio",message)
      else
        outputChatBox("#8163bf[Chat] #ffffffNincs nálad rádió.",thePlayer,255,255,255,true)
      end
    end
    
  end
  addCommandHandler("r",walkieTalkie)
  addCommandHandler("Rádió",walkieTalkie)

  function serviceRadio(player,command,...)
    if getElementData(player,"player:loggedIn") then 
          if not ... then outputChatBox("#8163bf[Chat] #ffffff/"..command.." [Üzenet]",player,255,255,255,true) return end

      if exports["inventory"]:hasItem(thePlayer,149) then
        local faction,id = isAllowedFaction(player);
        if faction and not (id == 68 or id == 56) then 
            local msg = table.concat({...}, " ");
            for k, v in ipairs(getElementsByType("player")) do
                if getElementData(v, "player:loggedIn")  then
                    local x,fid = isAllowedFaction(v);
                    if x and not (id == 68 or id == 56) then
                        outputChatBox("#F62459[" .. faction[1] .. "] " .. utf8.gsub(getElementData(player,"player:charname"),"_"," ") .. " mondja (rádióba): " .. msg, v, 255, 100, 0, true)
                        triggerClientEvent(v, "radio.sound", v)
                    end
                end
            end
        else 
        end
      else
        outputChatBox("#8163bf[Chat] #ffffffNincs nálad rádió.",player,255,255,255,true)
      end
    end
end
addCommandHandler("d",serviceRadio,false,false)

  function Chatplacedo(thePlayer,cmd,...)
    if getElementData(thePlayer,"player:loggedIn") and not getElementData(thePlayer,"dead") then
      if not ... then outputChatBox("#8163bf[Chat] #ffffff/"..cmd.." [Történés]",thePlayer,255,255,255,true) return end
      local message = table.concat({...}," ")
      local x,y,z = getElementPosition(thePlayer)
      triggerClientEvent(root,"sync",thePlayer,thePlayer,"*"..message.." (("..utf8.gsub(getElementData(thePlayer,"player:charname"),"_"," ").."))",x,y,z)
        
      setTimer(function()
      table.remove(placedo,1)
      triggerClientEvent(root,"deletePlacedo",root,1)
      end,7200000,1)

      local tableToRecord = {thePlayer,"*"..message.." (("..utf8.gsub(getElementData(thePlayer,"player:charname"),"_"," ").."))",x,y,z}
      table.insert(placedo, tableToRecord)

    end
  end
  addCommandHandler("placedo",Chatplacedo)

  function syncDelete(id)
    table.remove(placedo,id)
    triggerClientEvent(root,"deletePlacedo",root,id)
  end 
  addEvent("syncDelete",true)
  addEventHandler("syncDelete",root,syncDelete)

  function syncServer(element)
    for k,v in pairs(placedo) do
      triggerClientEvent(element,"sync",element,v[1],v[2],v[3],v[4],v[5])
    end
  end
  addEvent("syncServer",true)
  addEventHandler("syncServer",root,syncServer)

  function sendChatOutput(element,type,message)
    takeMessage(element,type,message)
  end
  addEvent("sendChatOutput",true)
  addEventHandler("sendChatOutput",root,sendChatOutput)

  local allowFactions = {
    --id = {rövid, hosszú mint a faszom, szín (blue,green,orange)}
    [1] = {"LVMPD","Las Venturas Police Department"},
    [2] = {"SASD","xProject Sheriff's Department"},
    [3] = {"LVMS","Las Venturas Medical Services"},
}
  function isAllowedFaction(player)
    local value = false;
    local fid = false;
    dbid = getElementData(player,"player:dbid")
    for k,v in pairs(allowFactions) do 
        if exports.pdash:isPlayerInGroup(dbid,k)then 
            value = v;
            fid = k;
            break;
        end
    end
    return value,fid;
end
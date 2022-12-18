local conn = exports.pcore:getConnection()

local phoneMessages = {}
local call = {}
call["pd"] = {}
call["sheriff"] = {}
call["medic"] = {}
call["mechanic"] = {}
local types = {
    ["medic"] = 3,
    ["pd"] = 1,
    ["sheriff"] = 2,
    ["mechanic"] = 4,
}
addEvent("phone > getPhonedMan", true)
addEventHandler("phone > getPhonedMan", resourceRoot, function(phoneNumber, callerNumber)
    local founded = false 

    --outputChatBox(callerNumber)
    for k, v in ipairs(getElementsByType("player")) do 
        if exports.inventory:hasItem(v, 133, phoneNumber) then 
            founded = v 
            break
        end
    end

    if founded then 
        if founded == client then 
            triggerClientEvent(client, "phone > getBackPhoneCallingData", client, "error", false)
            setElementData(client, "phone:state", false)
        else
            if not getElementData(founded, "phone:state") then 
                --outputChatBox("phoneNumber: "..getPlayerName(client).." > "..getPlayerName(founded))
                triggerClientEvent(client, "phone > getBackPhoneCallingData", client, "call", founded)
                triggerClientEvent(founded, "phone > getBackPhoneCallingData", founded, "in", client, callerNumber, phoneNumber)
                setElementData(client, "phone:state", "inWaiting")

                setElementData(client, "phone:talkedPlayer", founded)
                setElementData(founded, "phone:talkedPlayer", client)
            else
                triggerClientEvent(client, "phone > getBackPhoneCallingData", client, "busy", false)
                setElementData(client, "phone:state", false)
            end
        end
    else
        triggerClientEvent(client, "phone > getBackPhoneCallingData", client, "error", false)
        setElementData(client, "phone:state", false)
    end
end)

addEvent("phone > dismissCalling", true)
addEventHandler("phone > dismissCalling", resourceRoot, function(player)
    if isElement(player) then 
        triggerClientEvent(player, "phone > getBackPhoneCallingData", player, "dismiss", client)
        setElementData(player, "phone:state", false)
    end
    setElementData(client, "phone:state", false)
end)

addEvent("phone > acceptCalling", true)
addEventHandler("phone > acceptCalling", resourceRoot, function(player)
    triggerClientEvent(player, "phone > getBackPhoneCallingData", player, "accept", client)
    setElementData(client, "phone:state", "inCall")
    setElementData(player, "phone:state", "inCall")
end)

addEvent("phone > syncCall", true)
addEventHandler("phone > syncCall", resourceRoot, function(music, volume)
    setElementData(client, "phone:ringstone", music)
    setElementData(client, "phone:ringstoneVolume", volume)
    setElementData(client, "phone:state", "called")
end)

addEventHandler("onResourceStart", resourceRoot, function()
    for k, v in ipairs(getElementsByType("player")) do 
        setElementData(v, "phone:state", false)
        setElementData(v, "phone:talkedPlayer", false)
    end
end)

addEvent("phone > addNews", true)
addEventHandler("phone > addNews", resourceRoot, function(text, phoneNumber, type)
    if not type then type = "normal" end 

    if type == "normal" then 
        setElementData(client, "player:money", getElementData(client, "player:money")-150)

        for k, player in ipairs(getElementsByType("player")) do 
            if getElementData(player, "player:loggedIn") then
                if exports.inventory:hasItem(player, 133) then  
                    outputChatBox("#8163bf"..text.." #ffffff(("..getElementData(client,"player:charname"):gsub("_"," ").."))", player, 255, 255, 255, true)
                    if tonumber(phoneNumber) > 0 then 
                        --exports.Pchat:takeMessage("me","megmotozza "..getElementData(targetPlayer,"player:charname"):gsub("_"," ").." -t.")
                        outputChatBox("#8163bf".."Telefonszám: #ffffff"..phoneNumber, player, 255, 255, 255, true)
                    end
                end
            end
        end
    elseif type == "dw" then 
        setElementData(client, "player:money", getElementData(client, "player:money")-375)

        for k, player in ipairs(getElementsByType("player")) do 
            if not (exports.Pdash:isPlayerInGroup(player, 1)) then
                if getElementData(player, "player:loggedIn") then
                    if exports.inventory:hasItem(player, 133) then 
                        outputChatBox("#652d96[Dark Web]: #73449c"..text.." #ffffff(("..getPlayerName(client):gsub("_", " ").."))", player, 255, 255, 255, true)
                        if tonumber(phoneNumber) > 0 then
                            outputChatBox("#652d96[Dark Web]: #73449cTelefonszám: #ffffff"..phoneNumber, player, 255, 255, 255, true)
                        end
                    end
                end
            end
        end
    end
end)

addEvent("phone > sendMessage", true)
addEventHandler("phone > sendMessage", resourceRoot, function(text, player)
    triggerClientEvent(player, "phone > requestMessage", player, text) 
    triggerClientEvent(root, "outputChatMessage", client, client, text, 15)
end)

addEvent("phone > sendSMS", true)
addEventHandler("phone > sendSMS", resourceRoot, function(recievedPhoneNumber, message, date, senderPhoneNumber)
    --outputChatBox("[SMS]: "..senderPhoneNumber.." > "..recievedPhoneNumber)
    --outputChatBox("[SMS]: "..message.." ("..date..")")

    recievedPhoneNumber = tonumber(recievedPhoneNumber)
    senderPhoneNumber = tonumber(senderPhoneNumber)

    if not phoneMessages[recievedPhoneNumber] then 
        phoneMessages[recievedPhoneNumber] = {}
    end

    if not phoneMessages[recievedPhoneNumber][senderPhoneNumber] then
        local insertResult, _, insertID = dbPoll(dbQuery(conn, "INSERT INTO phoneMessages SET recievedPhone = ?, senderPhone = ?, messageData = ? ", recievedPhoneNumber, senderPhoneNumber, toJSON({{{message}}})), 250)

        if insertID then
            phoneMessages[recievedPhoneNumber][senderPhoneNumber] = {
                read = false,
                messages = {},
                id = insertID,
            }
        end
    end
    phoneMessages[recievedPhoneNumber][senderPhoneNumber].read = false
    table.insert(phoneMessages[recievedPhoneNumber][senderPhoneNumber].messages, {date, message})

    if not phoneMessages[senderPhoneNumber] then 
        phoneMessages[senderPhoneNumber] = {}
    end

    if not phoneMessages[senderPhoneNumber][recievedPhoneNumber] then
        local insertResult, _, insertID = dbPoll(dbQuery(conn, "INSERT INTO phoneMessages SET recievedPhone = ?, senderPhone = ?, messageData = ? ", senderPhoneNumber, recievedPhoneNumber, toJSON({{{message}}})), 250)

        if insertID then
            phoneMessages[senderPhoneNumber][recievedPhoneNumber] = {
                read = true,
                messages = {},
                id = insertID,
            }
        end
    end
    phoneMessages[senderPhoneNumber][recievedPhoneNumber].read = true
    table.insert(phoneMessages[senderPhoneNumber][recievedPhoneNumber].messages, {date, message, true})

    triggerClientEvent(root, "phone > syncSMS > client", root, phoneMessages)

    for k, v in ipairs(getElementsByType("player")) do 
        if exports.inventory:hasItem(v, 133, recievedPhoneNumber) then 
            founded = v 
            break
        end
    end

    if founded then 
		exports.Pchat:takeMessage(founded,"do","kapott egy üzenetet.")
        triggerClientEvent(founded, "phone > getPhoneNotificationSound", resourceRoot, recievedPhoneNumber)
    end
end)

function saveMessages()
    for k, v in pairs(phoneMessages) do
        for k2, v2 in pairs(v) do 
            dbExec(conn, "UPDATE phoneMessages SET messageData = ? WHERE id = ?", toJSON({v2.messages, v2.read}), v2.id)
        end
    end
end
addEventHandler("onResourceStop", resourceRoot, saveMessages)

function loadMessages()
    query = dbQuery(conn, 'SELECT * FROM phoneMessages')
    result = dbPoll(query, 255)

    if result then 
        for k, v in ipairs(result) do 
            if not phoneMessages[v["recievedPhone"]] then 
                phoneMessages[v["recievedPhone"]] = {}
            end
            local messageDatas = fromJSON(v["messageData"])
            table.insert(phoneMessages[(v["recievedPhone"])], v["senderPhone"], {
                read = messageDatas[2],
                messages = messageDatas[1],
                id = v["id"],
            })

            print(toJSON(phoneMessages))
        end
    end
end

setTimer(function()
    triggerClientEvent(root, "phone > syncSMS > client", root, phoneMessages)
end, 2000, 1)

addEventHandler("onResourceStart", resourceRoot, loadMessages)

addEventHandler ( "onPlayerJoin", root, function()
    triggerClientEvent(source, "phone > syncSMS > client", root, phoneMessages)
end)

addEvent("phone > playPhoneNotificationSound", true)
addEventHandler("phone > playPhoneNotificationSound", resourceRoot, function(sound, volume)
    triggerClientEvent("phone > play3dNotifiactionSound", resourceRoot, client, sound, volume)
end)

addEvent("phone > delConversationFromPhone", true)
addEventHandler("phone > delConversationFromPhone", resourceRoot, function(phoneNum, conversation)
    print(phoneNum, conversation)
    local id = phoneMessages[phoneNum][conversation].id
    print(toJSON(phoneMessages[phoneNum][conversation]))
    local idgtable = phoneMessages
    table.remove(idgtable[phoneNum], tostring(conversation))
    phoneMessages = idgtable
    print(toJSON(phoneMessages[phoneNum][conversation]))

    triggerClientEvent(root, "phone > syncSMS > client", root, phoneMessages)
   -- dbExec(conn, "DELETE FROM phoneMessages WHERE id=?", id)
end)
addEvent("create911call",true)
function create911call(player,id)
     name = getElementData(player,"player:charname")
    if hasplayer(id) then
        if id == 1 then
            triggerEvent("pdcall",player,player,id)
        elseif id == 3 then
            triggerEvent("mediccall",player,player,id)
    elseif id == 4 then
        triggerEvent("mechanicall",player,player,id)
    elseif id == 2 then
        triggerEvent("sheriffcall",player,player,id)
    end
    else
        outputChatBox("#f68934 [xProject] #ffffffNincs elérhető munkatársunk!",player,255,255,255,true)
    end
end
addEventHandler("create911call",root,create911call)

addEvent("pdcall",true)
function pdcall(player,id)
    for k,v in pairs(getElementsByType("player")) do 
        local dbid = getElementData(v,"player:dbid")
    if getElementData(v,"player:loggedIn") and exports.Pdash:isPlayerInGroup(dbid,id) then
        local name = getElementData(player,"player:charname")
        local callid = #call["pd"] + 1
        call["pd"][callid] = {player,false}
        outputChatBox("#f68934[xProject] #ffffffHívás érkezett, elfogadáshoz #f68934/paccept "..callid.." (("..name.."))",v,255,255,255,true)
    end
end
end
addEventHandler("pdcall",root,pdcall)

addEvent("mediccall",true)
function mediccall(player,id)
    for k,v in pairs(getElementsByType("player")) do 
        local dbid = getElementData(v,"player:dbid")
    if getElementData(v,"player:loggedIn") and exports.Pdash:isinfaction(3,v) then
        local name = getElementData(player,"player:charname")
        local callid = #call["medic"] + 1
        call["medic"][callid] = {player,false}
        outputChatBox("#f68934[xProject] #ffffffHívás érkezett, elfogadáshoz #f68934/maccept "..callid.." (("..name.."))",v,255,255,255,true)
    end
end
end
addEventHandler("mediccall",root,mediccall)

addEvent("mechanicall",true)
function mechanicall(player,id)
    for k,v in pairs(getElementsByType("player")) do 
        local dbid = getElementData(v,"player:dbid")
    if getElementData(v,"player:loggedIn") and exports.Pdash:isinfaction(4,v) then
        local name = getElementData(player,"player:charname")
        local callid = #call["mechanic"] + 1
        call["mechanic"][callid] = {player,false}
        outputChatBox("#f68934[xProject] #ffffffHívás érkezett, elfogadáshoz #f68934/mecaccept "..callid.." (("..name.."))",v,255,255,255,true)
    end
end
end
addEventHandler("mechanicall",root,mechanicall)

addEvent("sheriffcall",true)
function sheriffcall(player,id)
    for k,v in pairs(getElementsByType("player")) do 
        local dbid = getElementData(v,"player:dbid")
    if getElementData(v,"player:loggedIn") and exports.Pdash:isinfaction(2,v) then
        local name = getElementData(player,"player:charname")
        local callid = #call["sheriff"] + 1
        call["sheriff"][callid] = {player,false}
        outputChatBox("#f68934[xProject] #ffffffHívás érkezett, elfogadáshoz #f68934/saccept "..callid.." (("..name.."))",v,255,255,255,true)
    end
end
end
addEventHandler("sheriffcall",root,sheriffcall)

function pAccept(player,command,id)
    local dbid = getElementData(player,"player:dbid")
    if getElementData(player,"player:loggedIn") and exports.Pdash:isPlayerInGroup(dbid,1) then
        if not id or not math.floor(tonumber(id)) then 
            outputChatBox("#f68934[xProject]#ffffffhasználat: /paccept [id]",player,255,255,255,true)
            return;
        end
        if  getElementData(player,"call.elfogadva") then 
            outputChatBox("#f68934[xProject] #ffffffMár elfogadtál egy hívást!",player,255,255,255,true)
            return
        end
        local id = math.floor(tonumber(id));
        if id and call["pd"][id] then 
            if call["pd"][id][2] then 
                outputChatBox("#f68934[xProject] #ffffffMár valaki elfogadta ezt a hívást.",player,255,255,255,true)
                return;
            else 
                call["pd"][id][2] = true;
               setElementData(player,"call.elfogadva",true);
                outputChatBox("#f68934[xProject] #ffffffElfogadtad a hívást!",player,255,255,255,true)
                outputChatBox("#f68934[xProject] #ffffffAz LVMPD elfogadta a hívásodat!",call["pd"][id][1],255,255,255,true)
                triggerClientEvent(player,"phone.createMarker",player,call["pd"][id],"blue",id,"pd");
                sentOtherFactionMemberpd(""..getElementData(player,"player:charname").." elfogadta a(z) "..id.." számú hívást",1);
            end
        else 
            outputChatBox("#f68934 [xProject] #ffffff Nincs ilyen számmal hívás!",player,255,255,255,true)
            return;
        end
    end
end
addCommandHandler("paccept", pAccept, false, false)

function maccept(player,command,id)
    local dbid = getElementData(player,"player:dbid")
    if getElementData(player,"player:loggedIn") and exports.pdash:isinfaction(3,player)then
        if not id or not math.floor(tonumber(id)) then 
            outputChatBox("#f68934[xProject]#ffffff használat: /maccept [id]",player,255,255,255,true)
            return;
        end
        if  getElementData(player,"call.elfogadva") then 
            outputChatBox("#f68934[xProject] #ffffffMár elfogadtál egy hívást!",player,255,255,255,true)
            return
        end
        local id = math.floor(tonumber(id));
        if id and call["medic"][id] then 
            if call["medic"][id][2] then 
                outputChatBox("#f68934[xProject] #ffffffMár valaki elfogadta ezt a hívást.",player,255,255,255,true)
                return;
            else 
                call["medic"][id][2] = true;
               setElementData(player,"call.elfogadva",true);
                outputChatBox("#f68934[xProject] #ffffffElfogadtad a hívást!",player,255,255,255,true)
                outputChatBox("#f68934[xProject] #ffffffAz LVMS elfogadta a hívásodat!",call["medic"][id][1],255,255,255,true)
               triggerClientEvent(player,"phone.createMarker",player,call["medic"][id],"medic",id,"meic");
                sentOtherFactionMembermedic(""..getElementData(player,"player:charname").." elfogadta a(z) "..id.." számú hívást",1);
            end
        else 
            outputChatBox("#f68934[xProject] #ffffff Nincs ilyen számmal hívás!",player,255,255,255,true)
            return;
        end
    end
end
addCommandHandler("maccept", maccept, false, false)

function mecaccept(player,command,id)
    local dbid = getElementData(player,"player:dbid")
    if getElementData(player,"player:loggedIn") and exports.pdash:isinfaction(4,player)then
        if not id or not math.floor(tonumber(id)) then 
            outputChatBox("#f68934[xProject]#ffffff használat: /maccept [id]",player,255,255,255,true)
            return;
        end
        if  getElementData(player,"call.elfogadva") then 
            outputChatBox("#f68934[xProject] #ffffffMár elfogadtál egy hívást!",player,255,255,255,true)
            return
        end
        local id = math.floor(tonumber(id));
        if id and call["mechanic"][id] then 
            if call["mechanic"][id][2] then 
                outputChatBox("#f68934[xProject] #ffffffMár valaki elfogadta ezt a hívást.",player,255,255,255,true)
                return;
            else 
                call["mechanic"][id][2] = true;
               setElementData(player,"call.elfogadva",true);
                outputChatBox("#f68934[xProject] #ffffffElfogadtad a hívást!",player,255,255,255,true)
                outputChatBox("#f68934[xProject] #ffffffA szerelők elfogadták a hívásodat!",call["mechanic"][id][1],255,255,255,true)
               triggerClientEvent(player,"phone.createMarker",player,call["mechanic"][id],id,"mechanic");
                sentOtherFactionMembermechanic(""..getElementData(player,"player:charname").." elfogadta a(z) "..id.." számú hívást",1);
            end
        else 
            outputChatBox("#f68934[xProject] #ffffff Nincs ilyen számmal hívás!",player,255,255,255,true)
            return;
        end
    end
end
addCommandHandler("mecaccept", mecaccept, false, false)

function saccept(player,command,id)
    local dbid = getElementData(player,"player:dbid")
    if getElementData(player,"player:loggedIn") and exports.pdash:isinfaction(2,player)then
        if not id or not math.floor(tonumber(id)) then 
            outputChatBox("#f68934[xProject]#ffffff használat: /maccept [id]",player,255,255,255,true)
            return;
        end
        if  getElementData(player,"call.elfogadva") then 
            outputChatBox("#f68934[xProject] #ffffffMár elfogadtál egy hívást!",player,255,255,255,true)
            return
        end
        local id = math.floor(tonumber(id));
        if id and call["sheriff"][id] then 
            if call["sheriff"][id][2] then 
                outputChatBox("#f68934[xProject] #ffffffMár valaki elfogadta ezt a hívást.",player,255,255,255,true)
                return;
            else 
                call["sheriff"][id][2] = true;
               setElementData(player,"call.elfogadva",true);
                outputChatBox("#f68934[xProject] #ffffffElfogadtad a hívást!",player,255,255,255,true)
                outputChatBox("#f68934[xProject] #ffffffA SASD elfogadta a hívásodat!",call["sheriff"][id][1],255,255,255,true)
               triggerClientEvent(player,"phone.createMarker",player,call["sheriff"][id],id,"sheriff");
                sentOtherFactionMembersheriff(""..getElementData(player,"player:charname").." elfogadta a(z) "..id.." számú hívást",1);
            end
        else 
            outputChatBox("#f68934[xProject] #ffffff Nincs ilyen számmal hívás!",player,255,255,255,true)
            return;
        end
    end
end
addCommandHandler("saccept", saccept, false, false)

function hasplayer(type)
    local table = {};
    type = type
    for k,v in pairs(getElementsByType("player")) do 
        local dbid = getElementData(v,"player:dbid")
        if getElementData(v,"player:loggedIn") and exports.Pdash:isPlayerInGroup(dbid,type)then 
            table[#table + 1] = v;
        end
    end
    return table;
end

function sentOtherFactionMemberpd(text,type)
    for k,v in pairs(getElementsByType("player")) do 
        if getElementData(v,"player:loggedIn") then 
            local dbid = getElementData(v,"player:dbid")
            if exports.Pdash:isPlayerInGroup(1,v) then
                local white = "#ffffff" 
                outputChatBox("#f68934[Hívás]: "..white..text,v,255,255,255,true);
            end
        end
    end
end
function sentOtherFactionMembermedic(text,type)
    for k,v in pairs(getElementsByType("player")) do 
        if getElementData(v,"player:loggedIn") then 
            local dbid = getElementData(v,"player:dbid")
            if exports.Pdash:isinfaction(3,v) then
                local white = "#ffffff" 
                outputChatBox("#f68934[xProject]: "..white..text,v,255,255,255,true);
            end
        end
    end
end
function sentOtherFactionMembermechanic(text,type)
    for k,v in pairs(getElementsByType("player")) do 
        if getElementData(v,"player:loggedIn") then 
            local dbid = getElementData(v,"player:dbid")
            if exports.Pdash:isinfaction(4,v) then
                local white = "#ffffff" 
                outputChatBox("#f68934[xProject]: "..white..text,v,255,255,255,true);
            end
        end
    end
end
addEvent("phone.kiert",true);
addEventHandler("phone.kiert",root,function(player,id,target,state,type)
    setElementData(player,"call.elfogadva",false);
    call[type][id] = nil;
    outputChatBox("#f68934[xProject]#ffffff Megérkeztél a híváshoz.",player,255,255,255,true);
end);
local carshopDoor = createObject(1532,562.548828125, -1292.4609375, 11.248237609863,0,0,180)
setElementFrozen(carshopDoor,true)
func = {};
func.dbConnect = exports["Pcore"];
local connection = exports.pcore:getConnection()

for k,v in pairs(carshoppos) do 
    pickup = createPickup(v[1],v[2],v[3],3, 1239)
end 

function pickupHit(thePlayer)
    if not getPedOccupiedVehicle(thePlayer) then 
    cancelEvent()
    triggerClientEvent(thePlayer,"triggerCarshop",thePlayer,thePlayer)
    end
end
addEventHandler("onPickupHit",pickup,pickupHit)

function openCarshop(thePlayer,number)
    setElementDimension(thePlayer,number)
end 
addEvent("openCarshop",true)
addEventHandler("openCarshop",root,openCarshop) 

function quitCarshop(thePlayer)
    setElementDimension(thePlayer,0)
end 
addEvent("quitCarshop",true)
addEventHandler("quitCarshop",root,quitCarshop)

function buyVehicle(thePlayer,modelID,name,R,G,B,x,y,z,rot,price)
local money = getElementData(thePlayer,"player:money")
    if money >= price then 
        triggerClientEvent(thePlayer,"triggerQuitAfterSuccessBuy",thePlayer,thePlayer)
        exports["Pinfobox"]:addNotification(thePlayer,"Sikeres vásárlás, részletek a chatboxban.","success")
        outputChatBox("#8163bf[Kereskedés]:#ffffff Sikeresen vásároltál egy #8163bf"..name.."#ffffff tipusú járművet. A parkolóban megtalálod.",thePlayer,255,255,255,true)
        exports["Pvehicle"]:addVehicle(thePlayer,0,R,G,B,x,y,z,rot,modelID)
        setElementData(thePlayer,"player:money",getElementData(thePlayer,"player:money") - price)
				     --[[local px,py,pz = 1749.4765625, 1911.8212890625, 10.8203125;
				local prx,pry,prz = getElementRotation(thePlayer);
				local int = 0;
				local dim = 0;
				local ownerdbid = getElementData(thePlayer,"player:dbid");
				local actualcolor = toJSON({ R, G, B, 0, 0, 0, 0, 0, 0, 0, 0, 0 });
				local str = "abcdefghijklmnopqrstuvwxyz"
				local plate = ""
				for index = 1, 3 do
					plate = plate .. string.char(str:byte(math.random(1, #str)))
				end
				plate = string.upper(plate)
				plate = plate .. "-"
				for index = 1, 3 do
					plate = plate .. math.random(1, 9)
				end
				dbQuery(function(query,thePlayer)
					local _, _, insertid = dbPoll(query, 0);
					if insertid > 0 then
						local data = {
							group = -1;
							color = actualcolor;
							id = insertid;
							owner = ownerdbid;
							interior = int;
							x = px;
							y = py;
							z = pz;
							rx = prx;
							ry = pry;
							rz = prz;
							model = modelid;
							dimension = dim;
							plate = plate
						};
						exports["Pvehicle"]:vehicleLoad(data)
						--vehicleLoad(data);
					end
				end,{thePlayer},func.dbConnect:getConnection(), "INSERT INTO `vehicles` SET `x` = ?, `y` = ?, `z` = ?, `rx` = ?, `ry` = ?, `rz` = ?, `interior` = ?, `dimension` = ?, `owner` = ?,`fuel` = ? , `group` = ?, `model` = ?, `color` = ?,`plate` = ?",px,py,pz,prx,pry,prz,int,dim,ownerdbid,100,-1,modelid,actualcolor,plate);]]--
    else 
        exports["Pinfobox"]:addNotification(thePlayer,"Nincs elég pénzed a vásárláshoz.","error")
    end 
end 
addEvent("buyVehicle",true)
addEventHandler("buyVehicle",root,buyVehicle)
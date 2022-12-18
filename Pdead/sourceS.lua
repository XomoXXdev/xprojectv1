function respawnPlayer(thePlayer,x,y,z)
    spawnPlayer(thePlayer,x,y,z,270.83084106445,getElementModel(thePlayer))    
end 
addEvent("onClientRespawn",true)
addEventHandler("onClientRespawn",root,respawnPlayer)

function setPlayerAnim(thePlayer)

    for k,v in ipairs(getElementsByType("player")) do
		if getElementData(v,"player:admin") >= 1 then 
		    outputChatBox(getElementData(thePlayer,"player:charname").." animba esett.",v,105, 105, 105,true)
        end 
	end 

    if not getPedOccupiedVehicle(thePlayer) then 
        setPedAnimation(thePlayer,"crack","crckidle4",-1,false,false,true,true)
    else 
        setPedAnimation(thePlayer,"ped","car_dead_lhs",-1,false,false,true,true);
        toggleControl(thePlayer,"vehicle_left",false);
        toggleControl(thePlayer,"vehicle_right",false);
        toggleControl(thePlayer,"steer_forward",false);
        toggleControl(thePlayer,"steer_back",false);
        toggleControl(thePlayer,"accelerate",false);
        toggleControl(thePlayer,"horn",false);
        toggleControl(thePlayer,"enter_exit",false);
        toggleControl(thePlayer,"brake_reverse",false);
    end 
end 
addEvent("setPlayerAnim",true)
addEventHandler("setPlayerAnim",root,setPlayerAnim)

function setPlayerOutOfAnim(thePlayer)
    if not getPedOccupiedVehicle(thePlayer) then 
        setPedAnimation(thePlayer,false)
    else 
        setPedAnimation(thePlayer,false)
        toggleControl(thePlayer,"vehicle_left",true);
        toggleControl(thePlayer,"vehicle_right",true);
        toggleControl(thePlayer,"steer_forward",true);
        toggleControl(thePlayer,"steer_back",true);
        toggleControl(thePlayer,"accelerate",true);
        toggleControl(thePlayer,"horn",true);
        toggleControl(thePlayer,"enter_exit",true);
        toggleControl(thePlayer,"brake_reverse",true);
    end 
end
addEvent("setPlayerOutOfAnim",true)
addEventHandler("setPlayerOutOfAnim",root,setPlayerOutOfAnim)

function toRespawnCommand(thePlayer)
    triggerClientEvent(thePlayer,"toRespawnCommandC",thePlayer)
end 
addEvent("toRespawnCommand",true)
addEventHandler("toRespawnCommand",root,toRespawnCommand)

function setPlayerHpUp(element)
    --if getElementData(helper,"player:groupid") == mentosgroupid then 
        --setElementHealth(element,100)
    --else
    setElementHealth(element,30)
    --end 
  end 
  addEvent("setPlayerHpUp",true)
  addEventHandler("setPlayerHpUp",root,setPlayerHpUp)
    
  function setPlayerHpDown(element)
    setElementHealth(element,0)
  end 
  addEvent("setPlayerHpDown",true)
  addEventHandler("setPlayerHpDown",root,setPlayerHpDown)
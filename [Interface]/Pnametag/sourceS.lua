function sync(element,data)
    triggerClientEvent(root,"syncItem",root,element,data)
end 
addEvent("sync",true)
addEventHandler("sync",root,sync)

function validation(player,cmd,target,value)
    if getElementData(player,"player:loggedIn") then
	    if getElementData(player,"player:admin") >= 6 then
	    if target and value then
			local targetPlayer, targetName = exports.Pcore:findPlayerByPartialNick(player, target)
			if targetPlayer then
			    if tonumber(value) and tonumber(value) <= 3 and tonumber(value) >= 0 then
				    setElementData(targetPlayer,"player:valid",tonumber(value))
					if tonumber(value) == 1 then
					    outputChatBox("#8163bf[xProject]:#ffffff A karaktered #8163bf1-es#ffffff szintű validate szintet kapott #8163bf"..getElementData(player,"player:adminname").."#ffffff által.",targetPlayer,255,255,255,true)
						outputChatBox("#8163bf[xProject]:#ffffff Sikeresen validáltad #8163bf"..getElementData(targetPlayer,"player:charname").."#ffffff karakterét. #8163bf("..value..")",player,255,255,255,true)
					elseif tonumber(value) == 2 then
					    outputChatBox("#8163bf[xProject]:#ffffff A karaktered #8163bf2-es#ffffff szintű validate szintet kapott #8163bf"..getElementData(player,"player:adminname").."#ffffff által.",targetPlayer,255,255,255,true)
						outputChatBox("#8163bf[xProject]:#ffffff Sikeresen validáltad #8163bf"..getElementData(targetPlayer,"player:charname").."#ffffff karakterét. #8163bf("..value..")",player,255,255,255,true)					
					elseif tonumber(value) == 3 then
					    outputChatBox("#8163bf[xProject]:#ffffff A karaktered #8163bf3-as#ffffff szintű validate szintet kapott #8163bf"..getElementData(player,"player:adminname").."#ffffff által.",targetPlayer,255,255,255,true)
						outputChatBox("#8163bf[xProject]:#ffffff Sikeresen validáltad #8163bf"..getElementData(targetPlayer,"player:charname").."#ffffff karakterét. #8163bf("..value..")",player,255,255,255,true)
					else
					    outputChatBox("#8163bf[xProject]:#ffffff A karaktered unvalid lett #8163bf"..getElementData(player,"player:adminname").."#ffffff által.",targetPlayer,255,255,255,true)
						outputChatBox("#8163bf[xProject]:#ffffff Sikeresen unvalidáltad #8163bf"..getElementData(targetPlayer,"player:charname").."#ffffff karakterét.",player,255,255,255,true)					
					end
				else
				    outputChatBox("#8163bf[xProject]:#ffffff Az érték csak 0 és 3 között lehet.",player,255,255,255,true)
				end
			else
			    outputChatBox("#8163bf[xProject]:#ffffff Nem található ilyen játékos.",player,255,255,255,true)
			end
	    else
		    outputChatBox("#8163bf[xProject]:#ffffff /validate [ID] [1-3; 0 = NOT VALID]",player,255,255,255,true)
		end
		end
    end    
end
addCommandHandler("validate",validation)
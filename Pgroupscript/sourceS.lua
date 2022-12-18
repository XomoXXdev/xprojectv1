func = {};
func.badge = {};

func.badge.give = function(playerSource,target,msg,prefix)
    exports.Pchat:takeMessage(playerSource,"me","átadott jelvényt "..getElementData(target,"player:charname"):gsub("_", " ").." -nak/nek.")
	outputChatBox("#8163bf[xProject]:#ffffff Sikeresen adtál egy jelvényt #8163bf"..getElementData(target,"player:charname"):gsub("_", " ").."#ffffff -nak/nek.",playerSource,0,0,0,true)
	outputChatBox("#8163bf[xProject]:#ffffff Sikeresen kaptál egy jelvényt #8163bf"..getElementData(playerSource,"player:charname"):gsub("_", " ").."#ffffff -tól/től.",target,0,0,0,true)
	if playerSource ~= target then
		setPedAnimation(playerSource,"DEALER","DEALER_DEAL",3000,false,false,false,false)
		setPedAnimation(target,"DEALER","DEALER_DEAL",3000,false,false,false,false)
	end
	exports.inventory:giveItem(target,127,tostring(msg),1,0,100,nil,tostring(prefix))
end
addEvent("giveBadge",true)
addEventHandler("giveBadge",getRootElement(),func.badge.give)
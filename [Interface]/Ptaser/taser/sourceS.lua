--@@Nikee
addEvent("onTazerShoot", true)
addEventHandler("onTazerShoot", getRootElement(),
	function (targetPlayer)
		if isElement(source) and isElement(targetPlayer) then
			if not getElementData(targetPlayer, "player.Tazed") then
				setElementData(targetPlayer, "player.Tazed", true)
                toggleControl(targetPlayer,"jump",false)
                toggleControl(targetPlayer,"crouch",false)
                toggleControl(targetPlayer,"walk",false)
                toggleControl(targetPlayer,"aim_weapon",false)
                toggleControl(targetPlayer,"fire",false)
                toggleControl(targetPlayer,"enter_passenger",false)
		        fadeCamera ( targetPlayer, false, 1.0, 255, 255, 255 )
				setPedAnimation(targetPlayer, "ped", "FLOOR_hit_f", -1, false, false, true)

				setTimer(
					function(player)
						if isElement(player) then
							setPedAnimation(player, "FAT", "idle_tired", -1, true, false, false)

							setTimer(
								function(player)
									if isElement(player) then
                                        toggleControl(player,"jump",true)
                                        toggleControl(player,"crouch",true)
                                        toggleControl(player,"walk",true)
                                        toggleControl(player,"aim_weapon",true)
                                        toggleControl(player,"fire",true)
                                        toggleControl(player,"enter_passenger",true)
										setPedAnimation(player, false)
		                                fadeCamera(player, true, 0.5)
										setElementData(player, "player.Tazed", false)
									end
								end,
							10000, 1, player)
						end
					end,
				20000, 1, targetPlayer)
			end
		end
	end
)

local cFunc = {}
local cSetting = {}

function tazerFired(target)
	if (isElement(target) and getElementType(target)=="player") then
		fadeCamera ( target, false, 1.0, 255, 255, 255 )
		setElementData(target, "tazed", 1)
		toggleAllControls(target, false, false, false)
		setPedAnimation(target, "ped", "FLOOR_hit_f", -1, false, false, true)
		setTimer(removeAnimation, 30000, 1, target)
	end
end
addEvent("tazerFired", true )
addEventHandler("tazerFired", getRootElement(), tazerFired)

function removeAnimation(thePlayer)
	if (isElement(thePlayer) and getElementType(thePlayer)=="player") then
		fadeCamera(thePlayer, true, 0.5)
		if getElementData(thePlayer,"isAnim") then
			setElementFrozen(thePlayer,true)
			setPedAnimation(thePlayer,"sweet","sweet_injuredloop",-1,false,false,false)
		else
			setPedAnimation(thePlayer,nil,nil)
			toggleAllControls(thePlayer, true, true, true)
		end
		setElementData(thePlayer, "tazed", 0)
	end
end
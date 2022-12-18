fileDelete ("indexC.lua") 
local uSound = {}
local SoundTimer = {}

addEvent("receiveSoundPos",true)
addEventHandler("receiveSoundPos",getRootElement(),function(veh,x,y,z)
	uSound [veh]= playSound3D("files/index.mp3", x,y,z, true) 
	setSoundMaxDistance( uSound[veh], 100 )
	setSoundVolume( uSound[veh], 1 )
	SoundTimer[veh] = setTimer(function()
		if isTimer(SoundTimer[veh]) then
			killTimer(SoundTimer[veh])
		end
		stopSound(uSound[veh])
		uSound[id] = nil
	end,180000,1)
end)
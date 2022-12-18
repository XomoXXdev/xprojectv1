local screenWidth, screenHeight = guiGetScreenSize ( )
local setknockoff = false
local playerX, playerY, playerZ = getElementPosition ( localPlayer )
local OpenSans = dxCreateFont('OpenSans.ttf', 10)
local sx,sy = guiGetScreenSize()
local resStat = false
local serverStats = nil
local serverColumns, serverRows = {}, {}
local statTimer
local piros = "#dc143c"
local feher = "#ffffff"
lastfps = 0
fps = 0
timer = nil



addEventHandler("onClientCursorMove", root, 
	function(_,_,_,_,x,y,z)
		local positions = {x,y,z}
		triggerServerEvent("server:receiveCursor", root, localPlayer, positions)
	end
)

addEvent("client:receiveCursor", true)
addEventHandler("client:receiveCursor", root,
	function(e, positions)
		if e and isElement(e) then
			local x,y,z = positions[1], positions[2], positions[3]
			setPedLookAt(e, x,y,z)
		end
	end
)



function isAllowed()
	return true
end

addCommandHandler("cpu", function()
	if isAllowed() then
		resStat = not resStat
		if resStat then
			outputChatBox(piros .."[Legion] ".. feher .."Sikeresen bekapcsoltad a fejlesztői CPU jelzőt!", 255, 255, 255, true)
			addEventHandler("onClientRender", root, resStatRender)
			triggerServerEvent("getServerStat", localPlayer)
		else
			outputChatBox(piros .."[Legion] ".. feher .."Sikeresen kikapcsoltad a fejlesztői CPU jelzőt!", 255, 255, 255, true)
			removeEventHandler("onClientRender", root, resStatRender)
			serverStats = nil
			serverColumns, serverRows = {}, {}
			triggerServerEvent("destroyServerStat", localPlayer)
		end
	end
end)

addEvent("receiveServerStat", true)
addEventHandler("receiveServerStat", root, function(stat1,stat2)
	serverStats = true
	serverColumns, serverRows = stat1,stat2
end)

function resStatRender()
	local x = sx-300
	if #serverRows == 0 then
		x = sx-140
	end
	local columns, rows = getPerformanceStats("Lua timing")
	local height = (15*#rows)
	local y = sy/2-height/2
	if #serverRows == 0 then
		dxDrawText("Kliens",sx-75,y-20,sx-75,y-20,tocolor(255,255,255,255),1,"OpenSans","center")
	else
		dxDrawText("Kliens",sx-235,y-20,sx-235,y-20,tocolor(255,255,255,255),1,"OpenSans","center")
	end
	dxDrawRectangle(x-10,y,150,height+10,tocolor(0,0,0,150))
	dxDrawRectangle(x-10,y,150,height+10,tocolor(0,0,0,150))

	y = y + 5
	for i, row in ipairs(rows) do
		color = '#ffffff'

		local text = row[1]:sub(0,15)..":".. color .." "..row[2]
		dxDrawText(text,x,y,150,15,tocolor(255,255,255,255),1,"OpenSans", "left", "top", false, false, false, true)
		y = y + 15
	end
	
	if #serverRows ~= 0 then
		local x = sx-140
		local height = (15*#serverRows)
		local y = sy/2-height/2
		dxDrawText("Szerver",sx-75,y-20,sx-75,y-20,tocolor(255,255,255,255),1,"OpenSans","center")
		dxDrawRectangle(x-10,y,150,height+10,tocolor(0,0,0,150))
		y = y + 5
		for i, row in ipairs(serverRows) do
			local text = row[1]:sub(0,15)..":#ff3333 "..row[2]
			dxDrawText(text,x,y,150,15,tocolor(255,255,255,255),1,"OpenSans", "left", "top", false, false, false, true)
			y = y + 15
		end
	end
end
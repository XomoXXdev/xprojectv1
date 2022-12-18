local resources = {}
local lastResource = 0
local rovid = "#7cc576[xProject - Compiler]:#FFFFFF"

function compileResource(res)
	local xmlPatch = ":"..res.."/meta.xml"
	local xmlFile = xmlLoadFile(xmlPatch)
	if xmlFile then
		outputChatBox(rovid, "Script: "..res,0,55,167,220)
		local index = 0
		local scriptNode = xmlFindChild(xmlFile,'script',index)
		if scriptNode then
			repeat
			local scriptPath = xmlNodeGetAttribute(scriptNode,'src') or false
			local scriptType = xmlNodeGetAttribute(scriptNode,'type') or "server"
			local serverEncypt = xmlNodeGetAttribute(scriptNode,'encypt') or "null"
			if scriptPath and (scriptType:lower() == "client" or serverEncypt:lower() == "true") then
				if string.find(scriptPath:lower(), "luac") then
					outputChatBox(rovid,"Ez a fájl már levan védve! ("..scriptPath..")",3,220,20,20)
				else
					local FROM=":"..res.."/"..scriptPath
					local TO= ":"..res.."/"..scriptPath.."c"
					fetchRemote("http://luac.mtasa.com/?compile=1&debug=0&obfuscate=1", function(data) fileSave(TO,data) end, fileLoad(FROM), true)
					xmlNodeSetAttribute(scriptNode,'src',scriptPath..'c')
					if serverEncypt:lower() == "true" then
						if fileExists(FROM) then
							outputDebugString("LEVÉDÉS: ".. FROM.." törölve. (encypt = true)",3,0,255,0)
							fileDelete(FROM)
						end
					end
					outputChatBox(rovid, "A script sikeresen levédve és elmentve!",3,0,255,0)
				end
			end
			index = index + 1
			scriptNode = xmlFindChild(xmlFile,'script',index)
			until not scriptNode
		end
		xmlSaveFile(xmlFile)
		xmlUnloadFile(xmlFile)
	else
		outputChatBox(rovid,"Nem olvasható a meta fájl!",3,220,20,20)
		return false
	end
end

function uncompileResource(res)
	local xmlPatch = ":"..res.."/meta.xml"
	local xmlFile = xmlLoadFile(xmlPatch)
	if xmlFile then
		outputChatBox(rovid,"Script: "..res,0,55,167,220)
		local index = 0
		local scriptNode = xmlFindChild(xmlFile,'script',index)
		if scriptNode then
			repeat
			local scriptPath = xmlNodeGetAttribute(scriptNode,'src') or false
			local scriptType = xmlNodeGetAttribute(scriptNode,'type') or "server"
			if scriptPath and scriptType:lower() == "client" then
				if string.find(scriptPath:lower(), "luac") then
					fileDelete(":"..res.."/"..scriptPath)
					xmlNodeSetAttribute(scriptNode,'src',scriptPath:gsub("luac","lua"))
					outputChatBox(rovid," Ez a resource már nem védett! "..res.."/"..scriptPath"",0,255,0,0)
				else
					outputChatBox(rovid,"Ez a fájl már nem védett!:  "..scriptPath.."",3,220,20,20)
				end
			end
			index = index + 1
			scriptNode = xmlFindChild(xmlFile,'script',index)
			until not scriptNode
		end
		xmlSaveFile(xmlFile)
		xmlUnloadFile(xmlFile)
	else
		outputChatBox(rovid, "Nem olvasható a meta fájl!",3,220,20,20)
		return false
	end
end

addCommandHandler("compileall", function(player,cmd,res)
	--if getElementType(player) == "console" then
		resources = getResources()
		lastResource = 0
		compileNextResource()
	--else
	--	outputChatBox(rovid.." #FFFFFFBekaphatod!", player, 255, 0, 0, true)
	--end
end)
addCommandHandler("uncompileall", function(player,cmd,res)
	resources = getResources()
	lastResource = 0
	unCompileNext()
end)


function unCompileNext()
	if lastResource < #resources then
		lastResource = lastResource + 1
		uncompileResource(getResourceName(resources[lastResource]))
		setTimer(unCompileNext, 1000, 1)
	end
end

function compileNextResource()
	if lastResource < #resources then
		lastResource = lastResource + 1
		compileResource(getResourceName(resources[lastResource]))
		setTimer(compileNextResource, 1000, 1)
	end
end




function levedes(player, cmd, res)
	local resource = getResourceFromName(res)
	if resource then
		outputChatBox(rovid.." #FFFFF Resource levédés folyamatban", player, 255,255,255,true)
		compileResource(res)
		outputChatBox(rovid.." Levédve!", player, 255,255,255,true)
	else
		outputChatBox(rovid.. " Nem található", player, 255,255,255,true)
	end
end
addCommandHandler("levedes", levedes)
addCommandHandler("uncompile", function(player,cmd,res)
	if (tonumber(getElementData(player, "acc:admin")) >= 8) then
		local resource = getResourceFromName(res)
		if resource then
			outputChatBox(rovid.." #FFFFFFResource levédés levétel folyamatban ...", player, 0, 255, 0, true)
			uncompileResource(res)
			outputChatBox(rovid.." #FFFFFFResource levédés levéve!", player, 0, 255, 0, true)
		else
			outputChatBox(rovid.." #FFFFFFNem található ilyen resource!", player, 255, 0, 0, true)
		end
	end
end)

function uncompile(player, cmd, res)
	local resource = getResourceFromName(res)
	if resource then
		outputChatBox(" "..rovid.." Levédés levétel folymatban ", player, 0,255,0,true)
		uncompileResource(res)
		outputChatBox("kész", 255,255,255,true)
	else
		outputChatBox(" nuku", 255,255,255,true)
	end
end
addCommandHandler("unc", uncompile)







function fileLoad(path)
    local File = fileOpen(path, true)
    if File then
        local data = fileRead(File, 500000000)
        fileClose(File)
        return data
    end
end
 
function fileSave(path, data)
    local File = fileCreate(path)
    if File then
        fileWrite(File, data)
        fileClose(File)
    end
end
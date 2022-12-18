script_serverside = true
data_sent = {}

function sendAttachmentData()
	if data_sent[client] then return end
	triggerClientEvent(client,"boneAttach_sendAttachmentData",root,
		attached_ped,
		attached_bone,
		attached_x,
		attached_y,
		attached_z,
		attached_rx,
		attached_ry,
		attached_rz
	)
	data_sent[client] = true
end
addEvent("boneAttach_requestAttachmentData",true)
addEventHandler("boneAttach_requestAttachmentData",root,sendAttachmentData)

function removeDataSentFlag()
	data_sent[source] = nil
	if attached_ped[source] then
		clearAttachmentData(source)
	end
end
addEventHandler("onPlayerQuit",root,removeDataSentFlag)

addEventHandler("onResourceStop", resourceRoot, function()
	setElementData(root, "pb_attach_data", data_sent, false)
end)

addEventHandler("onResourceStart", resourceRoot, function()
	local data = getElementData(root, "pb_attach_data")
	if data then
		data_sent = data
		setElementData(root, "pb_attach_data", nil, false)
	end
end)
local whitelist = { 
	["7B6A1D6A9803DFA75530E7520C712E71"] = true, --XomoXX
	["E68C07BDAE43D447B90CEC60A57D19B4"] = true, --Zack
	["DDDE3F9618064709825F1A009677A094"] = true, --Zack asztali
	["1E07814A5EE8962896ED581FBB57AB52"] = true,

}
addEventHandler( "onPlayerConnect", root, function (_, _, _, serial) 
	if not ( whitelist[ serial ] ) then 
		  cancelEvent( true, "A szerver jelenleg még fejlesztés alatt áll!" ) 
	end 
end )
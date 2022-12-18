fileDelete ("sourceCgroups.lua") 

local sx,sy = guiGetScreenSize();
local width = 800
local height = 600
local posX,posY = sx/2 - width/2, sy/2 - height/2
local pm = {}
local func = {};
local cache = {

	showgroups = {
		show = true;
	};
	OpenSansB = dxCreateFont("files/OpenSansB.ttf",16);
	OpenSansEB = dxCreateFont("files/OpenSansEB.ttf",14);
	OpenSans = dxCreateFont("files/opensans.ttf",14);
	OpenSansL = dxCreateFont("files/OpenSans-Light.ttf",14)
};


func.showgroups = function()
	cache.showgroups.show = not cache.showgroups.show;
end
addCommandHandler("showgroups",func.showgroups)

func.render = function()
	if not cache.showgroups.show then
		dxDrawRectangle(posX,posY,width,height,tocolor(22,22,22,255))
		dxDrawRectangle(posX,posY,width,32,tocolor(0,0,0,100))
		
		----showgroups created by:Roli-----------
		
		dxDrawText("xProject#ffffff - showgroups",posX+320,posY,0,0,tocolor(129, 99, 191,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("xProject Police Department",posX+7,posY+40,0,0,tocolor(129, 99, 191,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Legállis frakció",posX+340,posY+40,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Tagok: 0",posX+600,posY+40,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("xProject Sherrif's Department",posX+7,posY+65,0,0,tocolor(129, 99, 191,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Legállis frakció",posX+340,posY+65,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Tagok:0",posX+600,posY+65,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("xProject Medical Center",posX+7,posY+90,0,0,tocolor(129, 99, 191,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Legális frakció",posX+340,posY+90,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Tagok: 0",posX+600,posY+90,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		[[dxDrawText("/stats",posX+7,posY+115,0,0,tocolor(129, 99, 191,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Játékos információi lekérése.",posX+200,posY+115,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+115,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/vá",posX+7,posY+140,0,0,tocolor(129, 99, 191,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Játékos PM-re válaszolás.",posX+200,posY+140,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+140,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/gethere",posX+7,posY+165,0,0,tocolor(129, 99, 191,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Játékos magadhoz teleportálása.",posX+200,posY+165,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+165,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/setskin",posX+7,posY+190,0,0,tocolor(129, 99, 191,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Skin beállítása.",posX+200,posY+190,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+190,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/kick",posX+7,posY+215,0,0,tocolor(129, 99, 191,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Játékos kirúgása a szerverről.",posX+200,posY+215,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+215,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/jail",posX+7,posY+240,0,0,tocolor(129, 99, 191,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Játékos börtönbe helyezése.",posX+200,posY+240,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+240,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/unjail",posX+7,posY+265,0,0,tocolor(129, 99, 191,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Játékos kivétele a börtönből.",posX+200,posY+265,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+265,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/sethp",posX+7,posY+290,0,0,tocolor(129, 99, 191,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Életerő adása.",posX+200,posY+290,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+290,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/setarmor",posX+7,posY+315,0,0,tocolor(129, 99, 191,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Páncél szint adása.",posX+200,posY+315,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+315,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/setthirsty",posX+7,posY+340,0,0,tocolor(129, 99, 191,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Ital szint adása.",posX+200,posY+340,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+340,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/sethunger",posX+7,posY+365,0,0,tocolor(129, 99, 191,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Étel szint adása.",posX+200,posY+365,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+365,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/vhspawn",posX+7,posY+390,0,0,tocolor(129, 99, 191,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Városházára spawnolja a játékost.",posX+200,posY+390,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+390,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/fix",posX+7,posY+415,0,0,tocolor(129, 99, 191,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Jármű megjavítása.",posX+200,posY+415,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+415,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/vanish",posX+7,posY+440,0,0,tocolor(129, 99, 191,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Láthatatlan leszel.",posX+200,posY+440,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+440,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/asay",posX+7,posY+465,0,0,tocolor(129, 99, 191,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Admin felhívás.",posX+200,posY+465,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+465,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/freeze",posX+7,posY+490,0,0,tocolor(129, 99, 191,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Játékos lefagyasztása.",posX+200,posY+490,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+490,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/unfreeze",posX+7,posY+515,0,0,tocolor(129, 99, 191,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Játékos kiolvasztása.",posX+200,posY+515,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+515,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/hospitalspawn",posX+7,posY+540,0,0,tocolor(129, 99, 191,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Kórházhoz spawnolás.",posX+200,posY+540,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+540,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		
		dxDrawText("/togachat",posX+7,posY+565,0,0,tocolor(129, 99, 191,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Leírás: Adminchat kikapcsolása.",posX+200,posY+565,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)
		dxDrawText("Szükséges szint: 1.",posX+600,posY+565,0,0,tocolor(255,255,255,255),1,cache.OpenSansL,"left","top",false,false,false,true)]]
	end
end
addEventHandler("onClientRender",getRootElement(),func.render)
local current = 0;
local show = false;
local kerdesek = {
    {"Vezethet-e gépjárművet, ha a vezetői engedélyébe feljegyzett\n orvosi alkalmassági érvényességi időpontja lejárt?","Nem","Engedéllyel igen","Ha a barátom rendőr akkor igen","Igen",1},
    {"Lakott területen belül mennyi a megengedett sebesség?","40 km/h","30 km/h","25 km/h","50 km/h",4},
    {"Mit jelent a közlekedésben a bizalmi elv?","Számíthat arra, hogy a közlekedési szabályokat mások is megtartják.","Számíthat arra, hogy a szabálysértők mindig megkapják a megérdemelt büntetésüket.","Nemtudom","Számíthat arra, hogy mások is szabályt fognak sérteni.",1},
    {"Felállhat-e gépkocsijával a járdára, ha a gyalogosok részére csak\n 1 m széles helyet tud szabadon hagyni?","Nem","Nemtudom","Igen","Ha a gyalogosokat nem zavarja.",1},
    {"Lakott területen közlekedik személygépkocsijával.\n Be kell-e kapcsolniuk biztonsági övüket a személygépkocsi\n hátsó ülésén helyet foglaló felnőtt utasainak?","Nem","Csak ha én azt mondom nekik","Nemtudom","Igen",4},
    {"Köteles-e megkülönbözető jelzést használó járműnek elsőbséget adni?","Igen, minden esetben","Nem.","Nemtudom","Ha úgy gondolom, hogy sűrgősebb dolga van, mint nekem.",1},
    {"Olyan magánúton halad, amelyre a behajtást sem jelzőtábla\n, sem sorompó, sem más eszköz\n nem tiltotta. Hogyan kell itt közlekednie?","A KRESZ szabályainak megfelelően.", "Fokozott óvatossággal.","Csak a terület tulajdonosának előírásai szerint.","Én döntöm el.","Minnél gyorsabban átmegyek az útszakaszon.",1},
}
--{"Vezethet-e gépjárművet, ha a vezetői engedélyébe feljegyzett orvosi alkalmassági érvényességi időpontja lejárt?","Nem","Engedéllyel igen","Ha a barátom rendőr","Igen",1},
--{"Mit jelent a közlekedésben a bizalmi elv?","Számíthat arra, hogy a közlekedési szabályokat mások is megtartják.","Számíthat arra, hogy a szabálysértők mindig megkapják a megérdemelt büntetésüket.","Nemtudom","Számíthat arra, hogy mások is szabályt fognak sérteni.",1},
local cache = {};
local kesz = false;
local carMarker = false;
local currentMarker = {};
local sx,sy = guiGetScreenSize()
local ped = createPed(1, 1173.2470703125, 1346.779296875, 10.921875,0,90,0);
setElementData(ped,"ped:name","Arnold Black")
setElementData(ped,"ped:type","Vizsgabiztos");


local screen = {guiGetScreenSize()}
local box = {500,400}
Documents = {}
local pos = {screen[1]/2 -box[1]/2,screen[2]/2 -box[2]/2}
local showJobPanel = false
local font1small = dxCreateFont("sfpro.ttf",14)
local logo = dxCreateTexture("logo.png")
local route = {
    {1102.95703125, 1373.52734375, 10.812507629395},
    {1007.1015625, 1281.1640625, 10.812507629395},
    {1023.8408203125, 1189.8828125, 10.812507629395},
    {1020.1259765625, 1150.974609375, 10.812507629395},
    {979.1669921875, 1129, 10.812507629395},
    {1030.23828125, 1164.033203125, 10.812507629395},
    {1009.3857421875, 1211.5869140625, 10.812507629395},
    {1010.6552734375, 1324.5732421875, 10.812507629395},
    {1037.6015625, 1370.5947265625, 10.812507629395},
    {1154.6015625, 1369.609375, 10.812507629395},


}

addEventHandler("onClientClick",root,function(button,state,x,y,wx,wy,wz,clickedElement)
if clickedElement == ped then 
    if state == "down" then 
        if not show then 
            if getElementData(localPlayer,"player:money") < 200 then 
                
                return;
            end
            show = true;
            kesz = false;
            cache = {};
            current = 1;
            removeEventHandler("onClientRender",root,renderKerdesek);
            addEventHandler("onClientRender",root,renderKerdesek);
            setElementFrozen(localPlayer,true);
             setElementData(localPlayer,"player:money",getElementData(localPlayer,"player:money") - 2000);

        end
    end
end
end);   

function renderKerdesek()
    dxDrawRectangle(sx/2-300,sy/2-200,600,300,tocolor(23,23,23,255));
    dxDrawRectangle(sx/2-300,sy/2-200,3,300,tocolor(23,23,23,255));
    dxDrawText("Autósiskola", pos[1]+125,pos[2]+65,pos[1],pos[2],tocolor(129, 99, 191,255),1,font1small,"center","center")
    dxDrawImage(pos[1]-40,pos[2]+15,40,40,"logo.png",0,0,0)
       if not kesz then 
        dxDrawText(kerdesek[current][1],0,sy/2-140,sx,400,tocolor(255,255,255),0.8,font1small,"center");
        for k,v in pairs(kerdesek[current]) do 
            if k ~= 1 and k ~= 6 then 
                local color = tocolor(50,50,50,170);
                if isInSlot(sx/2-550/2,sy/2-150+(k*40),550,30) then 
                    color = tocolor(129, 99, 191,180);
                end
                dxDrawRectangle(sx/2-550/2,sy/2-150+(k*40),550,30,color);
                dxDrawText(v,sx/2-550/2,sy/2-150+(k*40),sx/2-550/2+550,sy/2-150+(k*40)+30,tocolor(255,255,255),0.7,font1small,"center","center")
            end
        end
    else 
        local all = 0;
        for k,v in pairs(cache) do 
            if v then 
                all = all + 1;
            end
        end
        all = all*7;

        if all < 30 then 
            dxDrawText("Sikertelen viszga.",0,sy/2-140,sx,400,tocolor(255,255,255),0.8,font1small,"center");
        else 
            dxDrawText("Átmentél a vizsgán, menj ki a sárga markerhez!",0,sy/2-160,sx,400,tocolor(255,255,255),1,font1small,"center");
        end

    end
end

addEventHandler("onClientKey",root,function(button,state)
    if button == "mouse1" and state then 
        if show then 
            for k,v in pairs(kerdesek[current]) do 
                if k ~= 1 and k ~= 6 then 
                    if isInSlot(sx/2-550/2,sy/2-150+(k*40),550,30) then 
                        if kerdesek[current][6] == k-1 then 
                            cache[current] = true;
                        else 
                            cache[current] = false;
                        end
                        current = current + 1;
                        if current >= #kerdesek then 
                            kesz = true;
                            setTimer(function()
                                kesz = false;
                                show = false;
                                removeEventHandler("onClientRender",root,renderKerdesek);

                                local all = 0;
                                for k,v in pairs(cache) do 
                                    if v then 
                                        all = all + 1;
                                    end
                                end
                                all = all*7;
                                if all > 30 then 
                                    startGyakorlati();
                                    outputChatBox("#8163bf[xProject]:#ffffff Sikeres vizsga, menj ki az iskola előtt található sárga markerhez!",255,255,255,true)
                                else
                                    outputChatBox("#8163bf[xProject]:#ffffff Sikertelen vizsga.",255,255,255,true)
                                end
                                cache = {};
                                setElementFrozen(localPlayer,false);
                            end,10,1);
                        end
                    end
                end
            end
        end
    end
end);

function startGyakorlati()
   
    if isElement(carMarker) then 
        destroyElement(carMarker);
    end
    carMarker = createMarker(1174.0595703125, 1365.294921875, 10.812507629395,"cylinder",2,129, 99, 191,100);
    addEventHandler("onClientMarkerHit",carMarker,function(hitElement,dim)
        if hitElement == localPlayer then 
            if isPedInVehicle(localPlayer) then 
               
                return;
            end
            triggerServerEvent("jogsi.givecar",localPlayer,localPlayer);
            destroyElement(source);
            current = 0;
            getNextMarker();
        end
    end);
    outputDebugString(tostring(carMarker))

    for k,v in pairs(currentMarker) do 
        if isElement(v) then 
            destroyElement(v);
        end
    end
    currentMarker = {};
end

function getNextMarker()
    for k,v in pairs(currentMarker) do 
        if isElement(v) then 
            destroyElement(v);
        end
    end
    currentMarker = {};

    current = current + 1;
    local x,y,z = unpack(route[current]);
    currentMarker[1] = createMarker(x,y,z,"cylinder",2,129, 99, 191,100);
    if current == #route then 
        addEventHandler("onClientMarkerHit",currentMarker[1],function(hitElement)
            if hitElement == localPlayer then 
                local veh = getPedOccupiedVehicle(localPlayer);
                if veh and getElementData(localPlayer,"jogsi.veh") == veh then 
                    for k,v in pairs(currentMarker) do 
                        if isElement(v) then 
                            destroyElement(v);
                        end
                    end
                    currentMarker = {};
                    triggerServerEvent("jogsi.end",localPlayer,localPlayer);
                else 
                    
                    return; 
                end
            end
        end);   
    else 
        addEventHandler("onClientMarkerHit",currentMarker[1],function(hitElement)
            if hitElement == localPlayer then 
                local veh = getPedOccupiedVehicle(localPlayer);
                if veh and getElementData(localPlayer,"jogsi.veh") == veh then 
                    getNextMarker();
                else 
                  
                    return; 
                end
            end
        end);  
    end
    currentMarker[2] = createBlip(x,y,z,1);
    setElementData(currentMarker[2], "blipIcon", 15)
    setElementData(currentMarker[2], "blipName", "Következő pont")
    setElementData(currentMarker[2], "exclusiveBlip",true)
end


function isInSlot(xS,yS,wS,hS)
	if(isCursorShowing()) then
		XY = {guiGetScreenSize()}
		local cursorX, cursorY = getCursorPosition()
		cursorX, cursorY = cursorX*XY[1], cursorY*XY[2]
		if(isInBox(xS,yS,wS,hS, cursorX, cursorY)) then
			return true
		else
			return false
		end
	end
end
function isInBox(dX, dY, dSZ, dM, eX, eY)
    if eX >= dX and eX <= dX+dSZ and eY >= dY and eY <= dY+dM then
        return true
    else
        return false
    end
end
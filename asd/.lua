row = 5;
column = 10;
margin = 14;
itemSize = 30;
actionSlots = 7;
actionMargin = 7;
craftSlots = 7;

pages = {
    {
        name = "Tárgyak";
        img = "/files/images/normalicons/backpack.png";
        miniImg = "/files/images/miniicons/backpack.png";
        page = "bag";
    };
    {
        name = "Kulcsok";
        img = "/files/images/normalicons/key.png";
        miniImg = "/files/images/normalicons/key.png";
        page = "key";
    };
    {
        name = "Iratok";
        img = "/files/images/normalicons/pocket.png";
        miniImg = "/files/images/normalicons/pocket.png";
        page = "licens";
    };
    {
        name = "Barkácsolás";
        img = "/files/images/normalicons/craft.png";
        miniImg = "/files/images/miniicons/craft.png";
        page = "craft";
	};
	{
        name = "Széf";
        img = "/files/images/normalicons/safe.png";
        miniImg = "/files/images/miniicons/safe.png";
        page = "object";
	};
	{
        name = "Csomagtartó";
        img = "/files/images/normalicons/car.png";
        miniImg = "/files/images/miniicons/car.png";
        page = "vehicle";
    };
};

availableItems = {	
		--foods: {name == "név", weight = súly, stacking = true vagy false, category = "bag, key, stb...", amount = {max,min}, object = itemobject}
	{name = "Szendvics", weight = 0.02, stacking = true, category = "bag", eat = true}, --1
	{name = "Hot-dog", weight = 0.03, stacking = true, category = "bag", eat = true}, --2
	{name = "Hamburger", weight = 0.03, stacking = true, category = "bag", eat = true}, --3
	{name = "Sajtburger", weight = 0.03, stacking = true, category = "bag", eat = true}, --4
	{name = "Dupla sajtburger", weight = 0.05, stacking = true, category = "bag", eat = true}, --5
	{name = "Csirke burger", weight = 0.04, stacking = true, category = "bag", eat = true}, --6
	{name = "Sült krumpli", weight = 0.02, stacking = true, category = "bag", eat = true}, --7
	{name = "Dürüm", weight = 0.04, stacking = true, category = "bag", eat = true}, --8
	{name = "Taco", weight = 0.04, stacking = true, category = "bag", eat = true}, --9
	{name = "Gyros", weight = 0.04, stacking = true, category = "bag", eat = true}, --10
	{name = "Pizza szelet", weight = 0.02, stacking = true, category = "bag", eat = true}, --11
	{name = "Sprunk", weight = 0.03, stacking = true, category = "bag", drink = true}, --12
	{name = "Dr pepper", weight = 0.03, stacking = true, category = "bag", drink = true}, --13
	{name = "Orang O Tang", weight = 0.03, stacking = true, category = "bag", drink = true}, --14
	{name = "Ásványvíz", weight = 0.04, stacking = true, category = "bag", drink = true}, --15
	{name = "Kávé", weight = 0.03, stacking = true, category = "bag", drink = true}, --16
	{name = "Bor", weight = 0.05, stacking = true, category = "bag", alcohol= true}, --17
	{name = "Whiskey", weight = 0.05, stacking = true, category = "bag", alcohol= true}, --18
	{name = "Vodka", weight = 0.05, stacking = true, category = "bag", alcohol= true}, --19
	{name = "Sör", weight = 0.04, stacking = true, category = "bag", alcohol= true}, --20

	{name = "AK-47", weight = 5, stacking = false, category = "bag"}, --21
	{name = "AK-47 lőszer", weight = 0.002, stacking = true, category = "bag"}, --22

	{name = "M4", weight = 5, stacking = false, category = "bag"}, --23
	{name = "M4 lőszer", weight = 0.002, stacking = true, category = "bag"}, --24

	{name = "Desert Eagle", weight = 3.5, stacking = false, category = "bag"}, --25
	{name = "Colt-45", weight = 2, stacking = false, category = "bag"}, --26
	{name = "5x9mm töltény", weight = 0.002, stacking = true, category = "bag"}, --27

	{name = "Sörétes puska", weight = 8, stacking = false, category = "bag"}, --28
	{name = "Spaz 12", weight = 6, stacking = false, category = "bag"}, --29
	{name = "Lefűrészelt csövű puska", weight = 4, stacking = false, category = "bag"}, --30
	{name = "Sörétes lőszer", weight = 0.002, stacking = true, category = "bag"}, --31

	{name = "Uzi", weight = 3, stacking = false, category = "bag"}, --32
	{name = "TEC-9", weight = 3, stacking = false, category = "bag"}, --33
	{name = "MP-5", weight = 4, stacking = false, category = "bag"}, --34
	{name = "Kisgépfegyver töltény", weight = 0.002, stacking = true, category = "bag"}, --35

	{name = "Vadászpuska", weight = 8, stacking = false, category = "bag"}, --36
	{name = "Mesterlövész", weight = 8, stacking = false, category = "bag"}, --37
	{name = "Vadászpuska töltény", weight = 0.002, stacking = true, category = "bag"}, --38

	{name = "Gránát", weight = 0.5, stacking = true, category = "bag"}, --39
	{name = "Molotov koktél", weight = 0.5, stacking = true, category = "bag"}, --40
	{name = "Füst gránát", weight = 0.5, stacking = true, category = "bag"}, --41

	{name = "Festék spray", weight = 0.7, stacking = false, category = "bag"}, --42
	{name = "Kamera", weight = 1, stacking = false, category = "bag"}, --43
	{name = "Poroltó", weight = 2, stacking = false, category = "bag"}, --44

	{name = "Boxer", weight = 1, stacking = false, category = "bag"}, --45
	{name = "Sétapálca", weight = 1, stacking = false, category = "bag"}, --46
	{name = "Golf ütő", weight = 2, stacking = false, category = "bag"}, --47
	{name = "Gumibot", weight = 1, stacking = false, category = "bag"}, --48
	{name = "Kés", weight = 1, stacking = false, category = "bag"}, --49
	{name = "Baseball ütő", weight = 4, stacking = false, category = "bag"}, --50
	{name = "Ásó", weight = 3.5, stacking = false, category = "bag"}, --51
	{name = "Biliárd dákó", weight = 0.5, stacking = false, category = "bag"}, --52
	{name = "Katana", weight = 3, stacking = false, category = "bag"}, --53
	{name = "Láncfűrész", weight = 5, stacking = false, category = "bag"}, --54
	--ak47 alkatrészek
	{name = "Cső és előágy", weight = 1, stacking = true, category = "bag", craft = true}, --55
	{name = "Elsütő szerkezet", weight = 1.5, stacking = true, category = "bag", craft = true}, --56
	{name = "Ravasz és markolat", weight = 1, stacking = true, category = "bag", craft = true}, --57
	{name = "Tár", weight = 0.5, stacking = true, category = "bag", craft = true}, --58
	{name = "Tus", weight = 1, stacking = true, category = "bag", craft = true}, --59
	-- m4 alkatrészek
	{name = "Cső", weight = 0.6, stacking = true, category = "bag", craft = true}, --60
	{name = "Előágy", weight = 0.7, stacking = true, category = "bag", craft = true}, --61
	{name = "Elsütő szerkezet", weight = 1.4, stacking = true, category = "bag", craft = true}, --62
	{name = "Felső rész", weight = 0.3, stacking = true, category = "bag", craft = true}, --63
	{name = "Markolat", weight = 0.6, stacking = true, category = "bag", craft = true}, --64
	{name = "Ravasz", weight = 0.3, stacking = true, category = "bag", craft = true}, --65
	{name = "Tár", weight = 0.4, stacking = true, category = "bag", craft = true}, --66
	{name = "Tus", weight = 0.7, stacking = true, category = "bag", craft = true}, --67
	--colt alkatrészek
	{name = "Alsó rész", weight = 0.4, stacking = true, category = "bag", craft = true}, --68
	{name = "Felső rész", weight = 0.4, stacking = true, category = "bag", craft = true}, --69
	{name = "Markolat", weight = 0.4, stacking = true, category = "bag", craft = true}, --70
	{name = "Ravasz", weight = 0.4, stacking = true, category = "bag", craft = true}, --71
	{name = "Tár", weight = 0.4, stacking = true, category = "bag", craft = true}, --72
	--shoti alkatrészek
	{name = "Tus", weight = 1, stacking = true, category = "bag", craft = true}, --73
	{name = "Markolat", weight = 1.5, stacking = true, category = "bag", craft = true}, --74
	{name = "Elsütő szerkezet", weight = 2, stacking = true, category = "bag", craft = true}, --75
	{name = "Ravasz", weight = 0.5, stacking = true, category = "bag", craft = true}, --76
	{name = "Pumpáló", weight = 2, stacking = true, category = "bag", craft = true}, --77
	{name = "Cső", weight = 1, stacking = true, category = "bag", craft = true}, --78
	--sawed off alkatrészek
	{name = "Markolat", weight = 1, stacking = true, category = "bag", craft = true}, --79
	{name = "Ravasz", weight = 0.5, stacking = true, category = "bag", craft = true}, --80
	{name = "Elsütő szerkezet", weight = 1, stacking = true, category = "bag", craft = true}, --81
	{name = "Cső", weight = 1, stacking = true, category = "bag", craft = true}, --82
	{name = "Tok", weight = 0.5, stacking = true, category = "bag", craft = true}, --83
	--kés alkatrészek
	{name = "Penge", weight = 0.5, stacking = true, category = "bag", craft = true}, --84
	{name = "Markolat", weight = 0.5, stacking = true, category = "bag", craft = true}, --85
	--molotov alkatrészek
	{name = "Rongy", weight = 0.2, stacking = true, category = "bag", craft = true}, --86
	{name = "Whiskey", weight = 0.3, stacking = true, category = "bag", craft = true}, --87
	--vadász alkatrészek
	{name = "Tus", weight = 1, stacking = true, category = "bag", craft = true}, --88
	{name = "Elsütő szerkezet", weight = 2, stacking = true, category = "bag", craft = true}, --89
	{name = "Ravasz", weight = 1, stacking = true, category = "bag", craft = true}, --90
	{name = "Tok", weight = 2, stacking = true, category = "bag", craft = true}, --91
	{name = "Cső", weight = 2, stacking = true, category = "bag", craft = true}, --92
	--tec9
	{name = "Cső", weight = 0.5, stacking = true, category = "bag", craft = true}, --93
	{name = "Elsütő szerkezet", weight = 0.5, stacking = true, category = "bag", craft = true}, --94
	{name = "Alsó rész", weight = 0.5, stacking = true, category = "bag", craft = true}, --95
	{name = "Előágy", weight = 0.5, stacking = true, category = "bag", craft = true}, --96
	{name = "Tár", weight = 0.2, stacking = true, category = "bag", craft = true}, --97
	{name = "Markolat és ravasz", weight = 0.8, stacking = true, category = "bag", craft = true}, --98
	--uzi
	{name = "Cső", weight = 0.5, stacking = true, category = "bag", craft = true}, --99
	{name = "Elsütő szerkezet", weight = 0.5, stacking = true, category = "bag", craft = true}, --100
	{name = "Felső rész", weight = 0.5, stacking = true, category = "bag", craft = true}, --101
	{name = "Markolat", weight = 0.5, stacking = true, category = "bag", craft = true}, --102
	{name = "Ravasz", weight = 0.5, stacking = true, category = "bag", craft = true}, --103
	{name = "Tár", weight = 0.5, stacking = true, category = "bag", craft = true}, --104
	--kulcsok
	{name = "Jármű kulcs", weight = 0, stacking = false, category = "key"}, --105
	{name = "Kapu távirányító", weight = 0, stacking = false, category = "key"}, --106
	{name = "Széf kulcs", weight = 0, stacking = false, category = "key"}, --107
	{name = "Ingatlan kulcs", weight = 0, stacking = false, category = "key"}, --108
	--mesterkönyvek
	{name = "Mesterkönyv: AK-47", weight = 0.5, stacking = false, category = "bag", skill = 77}, --109
	{name = "Mesterkönyv: Colt-45", weight = 0.5, stacking = false, category = "bag", skill = 69}, --110
	{name = "Mesterkönyv: Desert Eagle", weight = 0.5, stacking = false, category = "bag", skill = 71}, --111
	{name = "Mesterkönyv: M4", weight = 0.5, stacking = false, category = "bag", skill = 78}, --112
	{name = "Mesterkönyv: MP5", weight = 0.5, stacking = false, category = "bag", skill = 76}, --113
	{name = "Mesterkönyv: Mesterlövész", weight = 0.5, stacking = false, category = "bag", skill = 79}, --114
	{name = "Mesterkönyv: Sawed-off", weight = 0.5, stacking = false, category = "bag", skill = 73}, --115
	{name = "Mesterkönyv: Sörétes", weight = 0.5, stacking = false, category = "bag", skill = 72}, --116
	{name = "Mesterkönyv: Silenced", weight = 0.5, stacking = false, category = "bag", skill = 70}, --117
	{name = "Mesterkönyv: Spaz 12", weight = 0.5, stacking = false, category = "bag", skill = 74}, --118
	{name = "Mesterkönyv: Uzi & Tec9", weight = 0.5, stacking = false, category = "bag", skill = 75}, --119
	--card
	{name = "Bankkártya", weight = 0, stacking = false, category = "licens"}, --120

	{name = "Egészségügyi doboz", weight = 1, stacking = true, category = "bag"}, --121
	{name = "Bilincs", weight = 0.2, stacking = false, category = "bag"}, --122
	{name = "Bilincs kulcs", weight = 0, stacking = false, category = "bag"}, --123
	{name = "Csekk füzet", weight = 0, stacking = false, category = "licens"}, --124
	{name = "Bírság", weight = 0, stacking = false, category = "licens"}, --125
	{name = "Rendőrségi fényjelző", weight = 0.2, stacking = false, category = "bag"}, --126
	{name = "Jelvény", weight = 0, stacking = false, category = "bag"}, --127

	{name = "Walkie Talkie", weight = 0.2, stacking = false, category = "bag"}, --128
	{name = "Toll", weight = 0, stacking = false, category = "bag"}, --129
	{name = "Jogositvány", weight = 0, stacking = false, category = "licens"}, --131
	{name = "Személyi igazolvány", weight = 0, stacking = false, category = "licens"}, --130
	{name = "Adásvételi szerződés", weight = 0, stacking = false, category = "licens"}, --132
	
	{name = "Huawei P30 Pro", weight = 0, stacking = false, category = "bag"}, --133
	{name = "Megaphone", weight = 2, stacking = false, category = "bag"}, --134
	{name = "Sokkoló", weight = 3, stacking = false, category = "bag"}, --135
	
	{name = "Sikeres vizsga záradék", weight = 0, stacking = false, category = "licens"}, --136
	{name = "Taxi lámpa", weight = 0, stacking = false, category = "bag"}, --137
	
	----MÉHÉSZETES GECIK
	{name = "Méh méreg", weight = 0, stacking = true, category = "bag"}, --138
	{name = "Méhpempő", weight = 0, stacking = true, category = "bag"}, --139
	{name = "Lépes méz", weight = 0, stacking = true, category = "bag"}, --140
	{name = "Pergetett méz", weight = 0, stacking = true, category = "bag"}, --141
	{name = "Méhviasz", weight = 0, stacking = true, category = "bag"}, --142
	
	{name = "Pénzkazetta", weight = 2, stacking = false, category = "bag"}, --143
	{name = "Akkumulátoros heggesztő", weight = 5, stacking = false, category = "bag"}, --144
	{name = "Kalapács", weight = 3, stacking = false, category = "bag"}, --145
	{name = "Véső", weight = 3, stacking = false, category = "bag"}, --146
	{name = "Üres kanna", weight = 1, stacking = false, category = "bag"}, --147
	{name = "Vizeskanna", weight = 5, stacking = false, category = "bag"}, --148
	{name = "Rádió", weight = 0.3, stacking = false, category = "bag"}, --149
	{name = "Paprika mag", weight = 0.1, stacking = true, category = "bag"}, --150
	{name = "Paprika", weight = 0.1, stacking = false, category = "bag"}, --151
	{name = "Dinnye mag", weight = 0.1, stacking = true, category = "bag"}, --152
	{name = "Dinnye", weight = 2, stacking = false, category = "bag"}, --153
	{name = "Répa mag", weight = 0.1, stacking = true, category = "bag"}, --154
	{name = "Répa", weight = 2, stacking = false, category = "bag"}, --155
	{name = "Horgászbot", weight = 2, stacking = false, category = "bag"}, --156
	--Drogok
	{name = "Kokain", weight = 2, stacking = true, category = "bag"}, --157
	{name = "Heroin", weight = 2, stacking = true, category = "bag"}, --158
	{name = "Füves cigaretta", weight = 2, stacking = true, category = "bag"}, --159
	{name = "Speed", weight = 2, stacking = true, category = "bag"}, --160
	{name = "LSD", weight = 2, stacking = true, category = "bag"}, --161
	{name = "Morfin", weight = 2, stacking = true, category = "bag"}, --162
	{name = "Kodein", weight = 2, stacking = true, category = "bag"}, --163
	{name = "Amfetamin", weight = 2, stacking = true, category = "bag"}, --164
	{name = "Hangtompítós Colt-45", weight = 2, stacking = false, category = "bag"}, --165

	{name = "Fegyverengedély", weight = 0, stacking = false, category = "licens"}, --166
    --Halak
	{name = "Álmacskacápa", weight = 2, stacking = false, category = "bag"}, --167
	{name = "Amerikai póc", weight = 2, stacking = false, category = "bag"}, --168
	{name = "Ismeretlen hal", weight = 2, stacking = false, category = "bag"}, --169
	{name = "Carolinai naphal", weight = 2, stacking = false, category = "bag"}, --170
	{name = "Horn-foki cápa", weight = 2, stacking = false, category = "bag"}, --171
	{name = "Törpeharcsa", weight = 2, stacking = false, category = "bag"}, --174
	{name = "Tőzegsügér", weight = 2, stacking = false, category = "bag"}, --175
	{name = "Szibériai maréna", weight = 2, stacking = false, category = "bag"}, --176
	{name = "Hínár", weight = 1, stacking = false, category = "bag"}, --177
	{name = "Bakancs", weight = 1, stacking = false, category = "bag"}, --178
	{name = "Műanyag palack", weight = 1, stacking = false, category = "bag"}, --179
	{name = "Döglött hal", weight = 2, stacking = false, category = "bag"}, --180
	{name = "Sörös doboz", weight = 0.5, stacking = false, category = "bag"}, --181
	{name = "Műanyag zacskó", weight = 0.1, stacking = false, category = "bag"}, --182
	{name = "Tejes palack", weight = 0.5, stacking = false, category = "bag"}, --183
	{ name = "Marihuana", weight = 0.5, stacking = true, category = "bag"},

};

weaponModels = {
	[21] = {355},
	[23] = {356},
	[53] = {339},
	[25] = {348},
	[50] = {336},
	[48] = {334},
	[30] = {349},
	[26] = {350},
	[37] = {358},
	[36] = {357},
	[34] = {353},
	[29] = {351},
	[11] = {322},
	--[231] = {333},
}

weaponIndexByID = {
	[21] = 30, -- ak
	[23] = 31, -- m4
	[53] = 8, -- katana
	[25] = 24, -- deagle
	[50] = 5, -- baseball
	[49] = 4, -- kés
	[48] = 3, -- gumibot
	[28] = 25, -- shotgun
	[30] = 26, -- lefűrészelt shoti
	[42] = 41, -- spray
	[26] = 22, -- colt
	[37] = 34, -- sniper
	[36] = 33, -- rifle
	[34] = 29, -- mp5
	[32] = 28, -- uzi
	--[29] = 23, -- silenced
	[33] = 32, -- tec9
	[43] = 43, -- kamera
	--[37] = 12, -- kertészlapát
	--[38] = 11, -- kalapács
	--[39] = 46, -- ejtőernyő
	--[173] = 10, -- bárd
	[29] = 27, -- SPAZ-12
	[209] = 11, -- Csákány
	--[231] = 2, -- SPAZ-12
}

weaponPositions = {
	[30] = {6, -0.09, -0.1, 0.2, 10, 155, 95},
	[31] = {5, 0.15, -0.1, 0.2, -10, 155, 90},
	[29] = {13, -0.07, 0.04, 0.06, 0, -90, 95},
	[8] = {6, -0.15, 0, -0.02, -10, -105, 90},
	[24] = {14, 0.10, 0, 0, 0, 264, 90},
	[5] = {6, -0.09, -0.1, 0.1, 10, 260, 95},
	[3] = {13, -0.05, -0.15, 0.1, 0, 10, 90},
	[25] = {5, 0.15, -0.1, 0.2, 0, 155, 90},
	[26] = {5, 0.15, 0.06, 0.2, 0, 172, 90},
	[33] = {6, -0.09, -0.1, 0.2, 10, 155, 95},
	[34] = {5, 0.15, -0.1, 0.2, -10, 155, 90},
	[27] = {6, -0.09, 0.02, 0.2, 10, 155, 95},
	[2] = {6, -0.05, -0.8, 0.25, -10, -250, 100},
}
--Uzi,Tec,Vadászpuska,Molotov,Kés
availableCraft = {
	[21] = {--ak47 amit kapsz
		--{item,slot,darab}
		{55,7,1}; -- Cső és előágy
		{56,8,1}; -- Elsütő szerkezet
		{57,13,1}; -- Ravasz és markolat
		{58,18,1}; -- Tár
		{59,9,1}; -- Tus
	};
	--m4
	[23] = {
		{63,8,1}; -- felső rész
		{60,12,1}; -- cső
		{61,13,1}; -- előágy
		{62,14,1}; -- elsütő
		{67,15,1}; -- tus
		{66,18,1}; -- tár
		{65,19,1}; -- ravasz
		{64,24,1}; -- markolat
	};
	[26] = { --colt45
		{69,8,1}; -- felső rész
		{68,12,1}; -- alsó rész
		{71,13,1}; -- ravasz
		{70,14,1}; -- markolat
		{72,19,1}; -- tár
	};
	[28] = { --shoti
		{73,11,1}; -- Tus
		{74,12,1}; -- Markolat
		{75,13,1}; -- Elsütő
		{77,14,1}; -- Pumpáló
		{78,15,1}; -- Cső
		{76,18,1}; -- Ravasz
	};
	[30] = { --sawed off
		{82,9,1}; -- Cső
		{79,12,1}; -- Markolat
		{81,13,1}; -- Elsütő
		{80,18,1}; -- Ravasz
		{83,19,1}; -- Tok
	};
	[49] = { --kés
		{84,7,1}; -- Penge
		{85,13,1}; -- Markolat
	};
	[40] = { --molotov
		{86,8,1}; -- Rongy
		{87,13,1}; -- Whiskey
	};
	[36] = { --vadász
		{88,12,1}; -- Tus
		{89,13,1}; -- Elsütő
		{90,18,1}; -- Ravasz
		{91,14,1}; -- Tok
		{92,15,1}; -- Cső
	};
	[33] = { --tec9
		{94,9,1}; -- Elsütő
		{93,11,1}; -- cső
		{96,12,1}; -- előágy
		{95,13,1}; -- alsó rész
		{98,14,1}; -- markolat és ravasz
		{97,18,1}; -- tár
	};
	[32] = { --tec9
		{101,7,1}; -- Felső rész
		{100,8,1}; -- Elsütő
		{99,9,1}; -- cső
		{102,12,1}; -- markolat
		{103,13,1}; -- ravasz
		{104,17,1}; -- tár
	};
}

weaponCache = {
	[45] = {
		isBack = false,
		hotTable = false,
		weapon = 1,
		ammo = -1,
	}, -- Boxer
	[46] = {
		isBack = false,
		hotTable = false,
		weapon = 15,
		ammo = -1,
	}, -- Sétapálca
	[47] = {
		isBack = false,
		hotTable = false,
		weapon = 2,
		ammo = -1,
	}, -- Golf ütő
	[48] = {
		isBack = false,
		hotTable = false,
		weapon = 3,
		ammo = -1,
	}, -- Gumibot
	[49] = {
		isBack = false,
		hotTable = false,
		weapon = 4,
		ammo = -1,
	}, -- Kés
	[50] = {
		isBack = false,
		hotTable = false,
		weapon = 5,
		ammo = -1,
	}, -- Base ball
	[51] = {
		isBack = false,
		hotTable = false,
		weapon = 6,
		ammo = -1,
	}, -- Ásó
	[52] = {
		isBack = false,
		hotTable = false,
		weapon = 7,
		ammo = -1,
	}, -- Biliárd dákó
	[53] = {
		isBack = false,
		hotTable = false,
		weapon = 8,
		ammo = -1,
	}, -- Katana
	[54] = {
		isBack = false,
		hotTable = false,
		weapon = 9,
		ammo = -1,
	}, -- Láncfűrész
	[21] = {
		isBack = true,
		hotTable = false,
		model = 355,
		position = {6, -0.09, -0.1, 0.2, 10, 155, 95},
		weapon = 30,
		ammo = 22,
	}, -- AK-47
	[23] = {
		isBack = true,
		hotTable = false,
		model = 356,
		position = {5, 0.15, -0.1, 0.2, -10, 155, 90},
		weapon = 31,
		ammo = 24,
	}, -- M4
	[26] = {
		isBack = false,
		hotTable = false,
		weapon = 22,
		ammo = 27,
	}, -- Colt-45
	[165] = {
		isBack = false,
		hotTable = false,
		weapon = 23,
		ammo = 27,
	}, -- Silenced Colt-45
	[25] = {
		isBack = true,
		hotTable = false,
		model = 348,
		position = {14, 0.10, 0, 0, 0, 264, 90},
		weapon = 24,
		ammo = 27,
	}, -- Beretta
	[135] = {
		isBack = true,
		hotTable = false,
		model = 348,
		position = {14, 0.10, 0, 0, 0, 264, 90},
		weapon = 24,
		ammo = 27,
	}, -- Sokkoló
	[28] = {
		isBack = true,
		hotTable = false,
		model = 349,
		position = {5, 0.15, -0.1, 0.2, 0, 155, 90},
		weapon = 25,
		ammo = 31,
	}, -- Sörétes puska
	[30] = {
		isBack = true,
		hotTable = false,
		model = 350,
		position = {5, 0.15, 0.06, 0.2, 0, 172, 90},
		weapon = 26,
		ammo = 31,
	}, -- Rövid csövű sörétes puska
	[29] = {
		isBack = true,
		hotTable = false,
		model = 351,
		position = {6, -0.09, 0.02, 0.2, 10, 155, 95},
		weapon = 27,
		ammo = 31,
	}, -- SPAZ-12
	[32] = {
		isBack = false,
		hotTable = false,
		weapon = 28,
		ammo = 35,
	}, -- Uzi
	[34] = {
		isBack = true,
		hotTable = false,
		model = 353,
		position = {13, -0.07, 0.04, 0.06, 0, -90, 95},
		weapon = 29,
		ammo = 35,
	}, -- MP5
	[33] = {
		isBack = false,
		hotTable = false,
		weapon = 32,
		ammo = 35,
	}, -- TEC-9
	[36] = {
		isBack = true,
		hotTable = false,
		model = 357,
		position = {6, -0.09, -0.1, 0.2, 10, 155, 95},
		weapon = 33,
		ammo = 38,
	}, -- Vadászpuska
	[37] = {
		isBack = true,
		hotTable = false,
		model = 358,
		position = {5, 0.15, -0.1, 0.2, -10, 155, 90},
		weapon = 34,
		ammo = 38,
	}, -- Mesterlövész
	[39] = {
		isBack = false,
		hotTable = false,
		weapon = 16,
		ammo = 39,
	}, -- Gránát
	[41] = {
		isBack = false,
		hotTable = false,
		weapon = 17,
		ammo = 41,
	}, -- Füst gránát
	[40] = {
		isBack = false,
		hotTable = false,
		weapon = 18,
		ammo = 40,
	}, -- Molotov cocktail

	[42] = {
		isBack = false,
		hotTable = false,
		weapon = 41,
		ammo = -1,
	}, -- Spray kanna
	[44] = {
		isBack = false,
		hotTable = false,
		weapon = 42,
		ammo = -1,
	}, -- Poroltó
	[43] = {
		isBack = false,
		hotTable = false,
		weapon = 43,
		ammo = -1,
	}, -- Kamera
};
identityItems = {};

function getItemName(item,value)
	if not value then
		value = 0
	else
		value = tonumber(value)
	end
	if availableItems[item] then
		if item == 21 and value == 20 then
			return "Winter AK-47" or "Ismeretlen"
		elseif item == 21 and value == 21 then
			return "Camo AK-47" or "Ismeretlen"
		elseif item == 21 and value == 22 then
			return "Digit AK-47" or "Ismeretlen"
		elseif item == 21 and value == 23 then
			return "Gold AK-47" or "Ismeretlen"
		elseif item == 21 and value == 24 then
			return "Gold AK-47 (ver2)" or "Ismeretlen"
		elseif item == 21 and value == 25 then
			return "Hello AK-47" or "Ismeretlen"
		elseif item == 21 and value == 26 then
			return "Silver AK-47" or "Ismeretlen"
		elseif item == 25 and value == 20 then
			return "Gold Desert Eagle" or "Ismeretlen"
		elseif item == 25 and value == 21 then
			return "Camo Desert Eagle" or "Ismeretlen"
		elseif item == 25 and value == 22 then
            return "Hello Desert Eagle" or "Ismeretlen"
		elseif item == 49 and value == 20 then
			return "Tiger Knife" or "Ismeretlen"
		elseif item == 49 and value == 21 then
			return "Army Knife" or "Ismeretlen"
		elseif item == 49 and value == 22 then
			return "Spider Knife" or "Ismeretlen"
		elseif item == 32 and value == 20 then
			return "Bronze Uzi" or "Ismeretlen"
		elseif item == 32 and value == 21 then
			return "Camo Uzi" or "Ismeretlen"
		elseif item == 32 and value == 22 then
			return "Gold Uzi" or "Ismeretlen"
		elseif item == 32 and value == 23 then
			return "Winter Uzi" or "Ismeretlen"
		elseif item == 168 and value == 20 then
			return "Hello Hangtompítós Colt-45" or "Ismeretlen"
		elseif item == 23 and value == 20 then
			return "Camo M4" or "Ismeretlen"
		elseif item == 23 and value == 21 then
			return "Winter M4" or "Ismeretlen"
		elseif item == 23 and value == 22 then
			return "Police M4" or "Ismeretlen"
		else
			return availableItems[item].name
		end
	end
end

function getItemImage(itemID,value)
	value = tonumber(value)
	if (tonumber(itemID)) then
		if (itemID == 21 and value == 20) or (itemID == 21 and value == 21) or (itemID == 21 and value == 22) or (itemID == 21 and value == 23) or (itemID == 21 and value == 24) or (itemID == 21 and value == 25) or (itemID == 21 and value == 26) or (itemID == 23 and value == 20) or (itemID == 23 and value == 21) or (itemID == 23 and value == 22) or (itemID == 25 and value == 20) or (itemID == 25 and value == 21) or (itemID == 25 and value == 22) or (itemID == 32 and value == 20) or (itemID == 32 and value == 21) or (itemID == 32 and value == 22) or (itemID == 32 and value == 23) or (itemID == 49 and value == 20) or (itemID == 49 and value == 21) or (itemID == 49 and value == 22) then
			itempng = itemID.."_"..value
		else
			itempng = itemID
		end
		if (fileExists(":inventory/files/items/" .. itempng .. ".png")) then
			return ":inventory/files/items/" .. itempng .. ".png" 
		end
		return ":inventory/files/items/nopicture.png" 
	end
	return ":inventory/files/items/nopicture.png" 
end

function getItemWeight(item)
	if availableItems[item] then
		return availableItems[item].weight;
	end
end

function getItemStackable(item)
	if availableItems[item] then
		return availableItems[item].stacking;
	end
end

function getItemObject(item)
	if availableItems[item] then
		return availableItems[item].object;
	end
end

function getCache(item)
	return availableItems
end

function getTypeElement(element,item)
	if isElement(element) then
		if getElementType(element) == "player" then
			if not item then
				item = 1
			end
			category = availableItems[item].category
			return {category, getElementType(element)..":dbid", 20}
		elseif getElementType(element) == "vehicle" then
			return {"vehicle", getElementType(element)..":dbid", 100} --getTrunkWeight(getElementModel(element))
		else
			return {"object", getElementType(element)..":dbid", 65}
		end
	else
		return false
	end
end

function getItemTooltip(id,item,value,count,state,weaponSerial)
	local name = getItemName(item,value);
	local drawName = "#7cc576"..name.."#ffffff";
	local drawWeight = "Súly: #3D7ABC"..getItemWeight(item)*count.."#ffffff kg.";
	if state >= 75 and state <= 100 then
		stateHtml = "#7cc576";
	elseif state >= 50 and state < 75 then
		stateHtml = "#eda828";
	elseif state < 50 then
		stateHtml = "#D23131";
	else
		stateHtml = "#7cc576";
	end
	local drawState = "Állapot: "..stateHtml..state.."#ffffff %";
	
	if weaponCache[item] and weaponCache[item].hotTable then
		tooltip = {drawName.." #787878["..weaponSerial.."]#ffffff",drawState,drawWeight}
	elseif item == 105 or item == 106 or item == 107 or item == 108 then
		tooltip = {drawName,"Azonosító: #8163bf"..value.."#ffffff"}
	elseif item == 120 then
		local data = fromJSON(value);
		tooltip = {drawName,"#eda828"..data.num1.."-"..data.num2.."#ffffff","Egyenleg: #7cc576"..formatMoney(data.money).."#ffffff dollár"};
	elseif item == 127 then
		tooltip = {drawName,"#8163bf["..tostring(weaponSerial):gsub("_", " ").."] "..value.."#ffffff"};
	elseif item == 124 then
		tooltip = {drawName,"Még #8163bf"..tonumber(value).."#ffffff lap van benne."};
	elseif item == 125 then
		local data = fromJSON(value);
		tooltip = {drawName,"Befizetésig még #8163bf"..tonumber(state).."#ffffff perc van hátra.","Büntetés összege #7cc576"..formatMoney(data.amount).."#ffffff dollár."};
	elseif item == 129 then
		tooltip = {drawName,drawState};
	else
		tooltip = {drawName,drawWeight};
	end
	
	return tooltip or "";
end

function generateSerial()
	return string.char(math.random(65,90)) .. math.random(0, 9) .. math.random(0, 9) .. math.random(0, 9)..string.char(math.random(65,90))..string.char(math.random(65,90))
end

function formatMoney(amount)
    local formatted = amount
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')
        if (k==0) then
            break
        end
    end
    return formatted
end

taxiPos = {
	[420] = {-0.4,0.2,0.88,-5,-6,0}, -- Taxi
	[551] = {-0.4,0.3,0.98,-5,-3.8,0}, -- BMW 750
	[516] = {-0.4,0.2,0.96,-5,-3.8,0}, -- BMW 535i (e34)
	[566] = {-0.4,0.38,0.83,-5,-5.8,0}, -- pezsó
	[400] = {-0.4,0.25,0.675,-5,-3.6,0}, -- BMW X5
	[580] = {-0.4,0.16,0.86,-5,-3.6,0}, -- Audi RS4
	[560] = {-0.4,0.32,1,-5,-3.6,0}, -- Evo
	[421] = {-0.4,0.32,0.71,-5,-3.6,0}, -- Washington
    [445] = {-0.5,0.15,0.76,-9,-3.6,0}, -- BMW M5
    [579] = {-0.5,0.10,1.2,-9,-3.6,0}, -- BMW M5
}

sirenPos = {
	[560] = {-0.4,0.32,1.07,-13,-3.6,0}, -- Evo
	[400] = {-0.4,0.26,0.73,-9,-3.6,0}, -- BMW X5
	[551] = {-0.4,0.3,0.98,-5,-3.8,0}, -- 750
	[580] = {-0.4,0.10,0.94,-9,-3.6,0}, -- Audi RS4
	[421] = {-0.5,0.35,0.76,-9,-3.6,0}, -- Washington
        [445] = {-0.5,0.15,0.76,-9,-3.6,0}, -- BMW M5 
        [540] = {-0.5,0.15,1.06,-9,-3.6,0}, -- Dodge
}

function getLamp()
	return taxiPos
end

function getSiren()
	return taxiPos
end
worldX, worldY = -25.6328125, -364.9140625 -- # DO NOT TOUCH IT!
farmInteriorPosition = {-23.140625, -367.431640625, 5.4296875} -- # DO NOT TOUCH IT!

-- NOTE: zCorrection: sets the start position of the plant on the Z-Axis
-- NOTE: growZ: sets the growing position on the Z-Axis
-- NOTE: If growZ is not set, the plant only grows by scale
seedTable = {
	{name = "Marihuana", modelID = 859, seedImage = "seed", seedID = 0, itemID = 182, zCorrection = 0},
	{name = "Carrot", modelID = 16192, seedImage = "seed", seedID = 399, itemID = 384, zCorrection = 0},
	{name = "Radish", modelID = 16193, seedImage = "seed", seedID = 398, itemID = 383, zCorrection = 0},
	{name = "Parsley", modelID = 16675, seedImage = "seed", seedID = 397, itemID = 385, zCorrection = 0.1},
	{name = "Lettuce", modelID = 16676, seedImage = "seed", seedID = 398, itemID = 383, zCorrection = 0},
	{name = "Onion", modelID = 16134, seedImage = "seed", seedID = 392, itemID = 377, zCorrection = 0, growZ = 0.26},
}

-- NOTE: Seed index corresponds to the index of the plant in the seedTable
seedSellTable = {
	{
		skinID = 73,
		position = {1141.2490234375, 1215.7275390625, 10.8203125, 270},
		seedIndex = 2,
	},
	{
		skinID = 15,
		position = {1139.859375, 1215.7529296875, 10.8203125, 270},
		seedIndex = 3,
	},
	{
		skinID = 31,
		position = {1138.548828125, 1216.0537109375, 10.8203125, 270},
		seedIndex = 4,
	},
	{
		skinID = 161,
		position = {1137.0537109375, 1215.947265625, 10.8203125, 270},
		seedIndex = 5,
	},
	{
		skinID = 162,
		position = {1135.6943359375, 1215.8955078125, 10.8203125, 270},
		seedIndex = 6,
	},
}

permissionMenu = {"Cultivate", "Digging", "Watering", "Plant seeds", "Harvest plants", "Open/close farm"}

-- # Marker Colors RGBA
farmMarkerColor = {197, 172, 119, 100}
farmRentMarkerColor = {124, 197, 118, 100}

-- # Tools
numberOfSpadesAllowedInFarm = 2 -- # Sets how many spades can be taken in the farm
numberOfHoesAllowedInFarm = 2 -- # Sets how many hoes can be taken in the farm

-- # Element Datas
characterIDElementData = "player:dbid"
moneyElementData = "player:money"
premiumElementData = "player:premium"
playerNameElementData = "player:charname"

-- # Renting
rentPrice = 5000
rentPricePremium = 2000
defaultRentTime = 60000*60*24*7 -- # The renting time / in milliseconds /

-- # Times
healthTime = 1000*60*60 -- # The time until the plant's health goes to 0 / in milliseconds /
growingTime = 1000*60*35 -- # The time until the plant is growing / in milliseconds /
waterLosingTime = 1000*60*60 -- # The time until the water level goes back to 0 / in milliseconds /
cultivateTime = 1000 -- # The time of the cultivating animation  / in milliseconds /
diggingTime = 4500 -- # The time of the digging animation  / in milliseconds /
plantingTime = 3000 -- # The time of the planting animation  / in milliseconds /
harvestTime = 10000 -- # The time of the harvesting animation  / in milliseconds /
wateringTime = 10000 -- # The time of the watering animation  / in milliseconds /

-- # Languages
selectedLanguage = "hu" -- NOTE: available languades: en - english; de - german; hu - hungarian
farmPrefix = "#d9534f[Farm]: #ffffff"


translationTable = {
	["en"] = {
		["harvest_button"] = "Harvest plant",
		["wateringLevel"] = "Moisture",
		["changeFarmName_button"] = "Change",
		["editFarmName_button"] = "Edit",
		["farmManagementTitle"] = "Farm Management",
		["permission_button"] = "Permissions",
		["permission_addNewMember"] = "Add new member",
		["permission_save"] = "Save",
		["permission_add"] = "Add",
		["permission_noPlayerFound"] = "Player not found.",
		["permission_morePlayerFound"] = " such player found",
		["permission_selfAdding"] = "You can not add yourself.",
		["tools_hoe"] = "Hoe",
		["tools_shovel"] = "Shovel",
		["tools_wateringCan"] = "Water can",
		["ground_wateringLevel"] = "Moisture:",
		["ground_state"] = "State:",
		["ground_uncultivated"] = "Uncultivated",
		["ground_cultivating"] = "Cultivating",
		["ground_cultivated"] = "Cultivated",
		["ground_planting"] = "Planting",
		["ground_digging"] = "Digging",
		["ground_readyForPlanting"] = "Ready for planting",
		["ground_growing"] = "Growth:",
		["ground_fillTheHole"] = "Fill the hole",
		["ground_plantTheSeed"] = "Plant seed",
		["ground_seedMenu"] = "Seeds",
		["chatbox_hoeDown"] = "First you have to put down the hoe!",
		["chatbox_shovelDown"] = "First you have to put down the shovel!",
		["chatbox_toolDown"] = "First you have to put down the tool that you are carrying!",
		["chatbox_tryHarvest"] = "You can not harvest this plant yet.",
		["chatbox_alreadyCultivated"] = "This block is already cultivated.",
		["chatbox_canNotCultivate"] = "You can not cultivate this block while the plant is growing.",
		["chatbox_notEnoughCultivation"] = "This block is not cultivated enough",
		["chatbox_rentFarmCommand1"] = "Use the command #7cc576/rentfarm #ffffff or #6699ff/rentfarm pp #ffffffto rent this farm.",
		["chatbox_rentFarmCommand2"] = "Price for a week: #7cc576$"..rentPrice.." #ffffffor #6699ff"..rentPricePremium.." Premium Point",
		["chatbox_farmLocked"] = "This farm is locked.",
		["chatbox_openFarmDoor"] = "You opened the farm's door.",
		["chatbox_closeFarmDoor"] = "You closed the farm's door.",
		["chatbox_notEnoughPP"] = "You do not have enough Premium Point.",
		["chatbox_notEnoughMoney"] = "You do not have enough money.",
		["chatbox_alreadyOwned"] = "This farm is already rented by someone else.",
		["chatbox_rentSuccess"] = "You successfully rented this farm.",
		["chatbox_canNotReach"] = "You can not reach this block.",
		["chatbox_noSeed"] = "You don't have that many pieces of this plant.",
		["chatbox_plantSold"] = "You have successfully sold the selected plant.",
		["chatbox_minigame_amount"] = "Amount:",
		["chatbox_minigame_price"] = "Price:",
		["chatbox_minigame_total"] = "Total:",
		["chatbox_minigame_description"] = "Hold ???#99cc99Space#ffffff??? until the arrow reaches \nthe green section.",
		["minigameTitle"] = "Farm - Sell",
		["board_forRentText"] = "FOR RENT!",
		["board_enterInterior"] = "Press 'E' to enter the farm",
		["piecesShortly"] = "pcs",
	},
	["de"] = {
		["harvest_button"] = "Pflanze ernten",
		["wateringLevel"] = "N??sse",
		["changeFarmName_button"] = "??ndern",
		["editFarmName_button"] = "Bearbeiten",
		["farmManagementTitle"] = "Farm Management",
		["permission_button"] = "Rechte",
		["permission_addNewMember"] = "Neuer Spieler",
		["permission_save"] = "Speichern",
		["permission_add"] = "Hinf??gen",
		["permission_noPlayerFound"] = "Spieler wurde nicht gefunden.",
		["permission_morePlayerFound"] = " Mehr Spieler wurden gefunden.",
		["permission_selfAdding"] = "Du kannst dich selbst nicht hinzuf??gen.",
		["tools_hoe"] = "Hacke",
		["tools_shovel"] = "Schaufel",
		["tools_wateringCan"] = "Wasserkanister",
		["ground_wateringLevel"] = "N??sse:",
		["ground_state"] = "Zustand:",
		["ground_uncultivated"] = "Unkultiviert",
		["ground_cultivating"] = "Wird kultiviert",
		["ground_cultivated"] = "Kultiviert",
		["ground_planting"] = "Wird gepflanzt",
		["ground_digging"] = "Wird gegraben",
		["ground_readyForPlanting"] = "Bereit f??r Pflanzen",
		["ground_growing"] = "Wachstum:",
		["ground_fillTheHole"] = "Das Loch f??llen",
		["ground_plantTheSeed"] = "Pflanzen",
		["ground_seedMenu"] = "Saaten",
		["chatbox_hoeDown"] = "Du musst zuerst die Hacke ablegen!",
		["chatbox_shovelDown"] = "Du musst zuerst die Schaufel ablegen!",
		["chatbox_toolDown"] = "Du musst zuerst das andere Werkzeug ablegen.",
		["chatbox_tryHarvest"] = "Du kannst diese Pflanze noch nicht ernten.",
		["chatbox_alreadyCultivated"] = "Dieser Block ist schon kultiviert.",
		["chatbox_canNotCultivate"] = "Du kannst diesen Block nicht kultivieren.",
		["chatbox_notEnoughCultivation"] = "Dieser Block ist noch nicht genug kultiviert",
		["chatbox_rentFarmCommand1"] = "Nutze #7cc576/rentfarm #ffffff oder #6699ff/rentfarm pp #ffffffum die Farm zu mieten.",
		["chatbox_rentFarmCommand2"] = "Preis f??r eine Woche: #7cc576$"..rentPrice.." #ffffffoder #6699ff"..rentPricePremium.." Premium Point",
		["chatbox_farmLocked"] = "Diese Farm ist geschlossen.",
		["chatbox_openFarmDoor"] = "Du hast die T??r der Farm ge??ffnet.",
		["chatbox_closeFarmDoor"] = "Du hast die T??r der Farm geschlossen.",
		["chatbox_notEnoughPP"] = "Du hast nicht genug Premium Point.",
		["chatbox_notEnoughMoney"] = "Du hast nicht genug Geld.",
		["chatbox_alreadyOwned"] = "Diese Farm ist schon gemietet.",
		["chatbox_rentSuccess"] = "Du hast diese Farm erfolgreich gemietet.",
		["chatbox_canNotReach"] = "Du kannst diesen Block nicht erreichen.",
		["chatbox_noSeed"] = "Du hast nicht so viele St??cke von dieser Pflanze.",
		["chatbox_plantSold"] = "Die ausgew??hlte Pflanze wurde erfolgreich verkauft.",
		["chatbox_minigame_amount"] = "Anzahl:",
		["chatbox_minigame_price"] = "Preis:",
		["chatbox_minigame_total"] = "Insgesamt:",
		["chatbox_minigame_description"] = "H??lt ???#99cc99Space#ffffff??? bis der Pfeil \nden gr??nen Bereich erreicht.",
		["minigameTitle"] = "Farm - Verkauf",
		["board_forRentText"] = "ZU VERMIETEN!",
		["board_enterInterior"] = "Dr??ck 'E' um die Farm beizutreten",
		["piecesShortly"] = "St??ck",
	},
	["hu"] = {
		["harvest_button"] = "N??v??ny arat??sa",
		["wateringLevel"] = "Nedvess??g",
		["changeFarmName_button"] = "M??dos??t??s",
		["editFarmName_button"] = "Szerkeszt??s",
		["farmManagementTitle"] = "Farm Management",
		["permission_button"] = "Jogosults??gok",
		["permission_addNewMember"] = "??j tag hozz??ad??sa",
		["permission_save"] = "Ment??s",
		["permission_add"] = "Hozz??ad",
		["permission_noPlayerFound"] = "J??t??kos nem tal??lhat??",
		["permission_morePlayerFound"] = " ilyen nev?? j??t??kos tal??lva.",
		["permission_selfAdding"] = " Magadat nem tudod hozz??adni.",
		["tools_hoe"] = "Kapa",
		["tools_shovel"] = "??s??",
		["tools_wateringCan"] = "Kanna",
		["ground_wateringLevel"] = "Nedvess??g:",
		["ground_state"] = "??llapot:",
		["ground_uncultivated"] = "M??veletlen",
		["ground_cultivating"] = "Kap??l??s alatt",
		["ground_cultivated"] = "Megkap??lva",
		["ground_planting"] = "??ltet??s alatt",
		["ground_digging"] = "??s??s alatt",
		["ground_readyForPlanting"] = "??ltet??sre k??sz",
		["ground_growing"] = "N??veked??s:",
		["ground_fillTheHole"] = "Lyuk bet??m??se",
		["ground_plantTheSeed"] = "N??v??ny ??ltet??se",
		["ground_seedMenu"] = "Vet??magok",
		["chatbox_hoeDown"] = "El??bb tedd le a kap??t!",
		["chatbox_shovelDown"] = "El??bb tedd le az ??s??t!",
		["chatbox_toolDown"] = "El??bb tedd le az eszk??zt, ami a kezedben van!",
		["chatbox_tryHarvest"] = "M??g nem fejl??d??tt ki el??gg?? a n??v??ny.",
		["chatbox_alreadyCultivated"] = "M??r teljesen meg van kap??lva.",
		["chatbox_canNotCultivate"] = "Ameddig be van ??ltetve a f??ld, addig nem kap??lhatod.",
		["chatbox_notEnoughCultivation"] = "Nincs el??gg?? megkap??lva a f??ld.",
		["chatbox_rentFarmCommand1"] = "Use the command #7cc576/rentfarm #ffffff or #6699ff/rentfarm pp #ffffffto rent this farm.",
		["chatbox_rentFarmCommand2"] = "Price for a week: #7cc576$"..rentPrice.." #ffffffor #6699ff"..rentPricePremium.." Premium Point",
		["chatbox_farmLocked"] = "Ez a farm z??rva van",
		["chatbox_openFarmDoor"] = "Kinyitottad a farm ajtaj??t.",
		["chatbox_closeFarmDoor"] = "Bez??rtad a farm ajtaj??t.",
		["chatbox_notEnoughPP"] = "Nincs el??g Pr??mium Pontod.",
		["chatbox_notEnoughMoney"] = "Nincs el??g p??nzed.",
		["chatbox_alreadyOwned"] = "Ezt a farmot m??r valaki b??rli.",
		["chatbox_rentSuccess"] = "Sikeresen kib??relted a farmot.",
		["chatbox_canNotReach"] = "Nem ??red el ezt a blokkot.",
		["chatbox_noSeed"] = "Nincs n??lad ilyen vet??mag.",
		["chatbox_plantSold"] = "Sikeresen eladtad a kiv??lasztott n??v??nyt.",
		["chatbox_minigame_amount"] = "Mennyis??g:",
		["chatbox_minigame_price"] = "Darab??r:",
		["chatbox_minigame_total"] = "??sszesen:",
		["chatbox_minigame_description"] = "Tartsd lenyomva a ???#99cc99Space#ffffff??? billenty??t, \nameddig a ny??l el nem ??ri a z??ld mez??t.",
		["minigameTitle"] = "Elad??s - ",
		["board_forRentText"] = "KIAD??!",
		["board_enterInterior"] = "Nyomj 'E' billenty??t a bel??p??shez.",
		["piecesShortly"] = "db",
	},
}


function getTranslatedText(index)
	if translationTable[selectedLanguage] then
		if translationTable[selectedLanguage][index] then
			return translationTable[selectedLanguage][index]
		else
			return "No matching text"
		end
	else
		return "This language is not supported."
	end
end

-- # Item functions

function hasPlayerItem(itemID)
	if exports.inventory:hasItem(itemID, 1) then
		return true
	else
		return false
	end
end

function getItemCount(itemID)
	local hasItem, _, _, _, _, _,itemCount = exports.inventory:hasItem(itemID)
	if not hasItem then
		return 0
	else
		return itemCount
	end
end

function takeSeedFromPlayer(itemID)
	exports.inventory:takeItemMinusCount(itemID)
end

function takePlantFromPlayer(itemID)
	exports.inventory:takeItem(itemID)
end

function givePlayerHarvestedPlant(itemID, health)
	if health > 10 then
		exports.inventory:giveItem(itemID, 1, 1, 0)
	end
end

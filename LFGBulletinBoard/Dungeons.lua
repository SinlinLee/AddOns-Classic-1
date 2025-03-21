local TOCNAME,
	---@class Addon_Dungeons : Addon_Tags, Addon_DungeonData
	GBB = ...;

local isClassicEra = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
local isCata = WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC
local isSoD = isClassicEra and C_Seasons.GetActiveSeason() == Enum.SeasonID.SeasonOfDiscovery

local debug = false
local print = function(...) if debug then print('['..TOCNAME.."] ",...) end end

function GBB.GetDungeonNames()
	local DefaultEnGB={
		["RFC"] = 	"Ragefire Chasm",
		["DM"] = 	"The Deadmines",
		["WC"] = 	"Wailing Caverns",
		["SFK"] = 	"Shadowfang Keep",
		["STK"] = 	"The Stockade",
		["BFD"] = 	"Blackfathom Deeps",
		["GNO"] = 	"Gnomeregan",
		["RFK"] = 	"Razorfen Kraul",
		["SM2"] =	"Scarlet Monastery",
		["SMG"] = 	"Scarlet Monastery: Graveyard",
		["SML"] = 	"Scarlet Monastery: Library",
		["SMA"] = 	"Scarlet Monastery: Armory",
		["SMC"] = 	"Scarlet Monastery: Cathedral",
		["RFD"] = 	"Razorfen Downs",
		["ULD"] = 	"Uldaman",
		["ZF"] = 	"Zul'Farrak",
		["MAR"] = 	"Maraudon",
		["ST"] = 	"The Sunken Temple",
		["BRD"] = 	"Blackrock Depths",
		["DM2"] = 	"Dire Maul",
		["DME"] = 	"Dire Maul: East",
		["DMN"] = 	"Dire Maul: North",
		["DMW"] = 	"Dire Maul: West",
		["STR"] = 	"Stratholme",
		["SCH"] = 	"Scholomance",
		["LBRS"] = 	"Lower Blackrock Spire",
		["UBRS"] = 	"Upper Blackrock Spire (10)",
		["RAMPS"] = "Hellfire Citadel: Ramparts",
		["BF"] = 	"Hellfire Citadel: Blood Furnace",
		["SP"] = 	"Coilfang Reservoir: Slave Pens",
		["UB"] = 	"Coilfang Reservoir: Underbog",
		["MT"] = 	"Auchindoun: Mana Tombs",
		["CRYPTS"] = "Auchindoun: Auchenai Crypts",
		["SETH"] = 	"Auchindoun: Sethekk Halls",
		["OHB"] = 	"Caverns of Time: Old Hillsbrad",
		["MECH"] = 	"Tempest Keep: The Mechanar",
		["BM"] = 	"Caverns of Time: Black Morass",
		["MGT"] = 	"Magisters' Terrace",
		["SH"] = 	"Hellfire Citadel: Shattered Halls",
		["BOT"] = 	"Tempest Keep: Botanica",
		["SL"] = 	"Auchindoun: Shadow Labyrinth",
		["SV"] = 	"Coilfang Reservoir: Steamvault",
		["ARC"] = 	"Tempest Keep: The Arcatraz",
		["KARA"] = 	"Karazhan",
		["GL"] = 	"Gruul's Lair",
		["MAG"] = 	"Hellfire Citadel: Magtheridon's Lair",
		["SSC"] = 	"Coilfang Reservoir: Serpentshrine Cavern",

		["UK"] = 	"Utgarde Keep",
		["NEX"] = 	"The Nexus",
		["AZN"] = 	"Azjol-Nerub",
		["ANK"] = 	"Ahn’kahet: The Old Kingdom",
		["DTK"] = 	"Drak’Tharon Keep",
		["VH"] = 	"Violet Hold",
		["GD"] = 	"Gundrak",
		["HOS"] = 	"Halls of Stone",
		["HOL"] = 	"Halls of Lightning",
		["COS"] = 	"The Culling of Stratholme",
		["OCC"] = 	"The Oculus",
		["UP"] = 	"Utgarde Pinnacle",
		["FOS"] = 	"Forge of Souls",
		["POS"] = 	"Pit of Saron",
		["HOR"] = 	"Halls of Reflection",
		["CHAMP"] = "Trial of the Champion",
		["NAXX"] = 	"Naxxramas",

		["OS"]   =  "Obsidian Sanctum",
		["VOA"] = 	"Vault of Archavon",
		["EOE"] = 	"Eye of Eternity",
		["ULDAR"] =   "Ulduar",
		["TOTC"] = 	"Trial of the Crusader",
		["RS"] = 	"Ruby Sanctum",
		["ICC"] = 	"Icecrown Citadel",

		["EYE"] = 	"Tempest Keep: The Eye",
		["ZA"] = 	"Zul-Aman",
		["HYJAL"] = "The Battle For Mount Hyjal",
		["BT"] = 	"Black Temple",
		["SWP"] = 	"Sunwell Plateau",
		["ONY"] = 	"Onyxia's Lair (40)",
		["MC"] = 	"Molten Core (40)",
		["ZG"] = 	"Zul'Gurub (20)",
		["AQ20"] = 	"Ruins of Ahn'Qiraj (20)",
		["BWL"] = 	"Blackwing Lair (40)",
		["AQ40"] = 	"Temple of Ahn'Qiraj (40)",
		["NAX"] = 	"Naxxramas (40)",
		["WSG"] = 	"Warsong Gulch (PvP)",
		["AB"] = 	"Arathi Basin (PvP)",
		["AV"] = 	"Alterac Valley (PvP)",
		["EOTS"] =  "Eye of the Storm (PvP)",
		["SOTA"] =   "Stand of the Ancients (PvP)",
		["WG"]  =   "Wintergrasp (PvP)",
		["ARENA"] = "Arena (PvP)",
		["MISC"] = 	"Miscellaneous",
		["TRADE"] =	"Trade",
		["DEBUG"] = "DEBUG INFO",
		["BAD"] =	"DEBUG BAD WORDS - REJECTED",
		["BREW"] =  "Brewfest - Coren Direbrew",
		["HOLLOW"] =  "Hallow's End - Headless Horseman",
    	["TRAVEL"] = "Travel services - Summons/Portals",
	}

	local dungeonNamesLocales={
		deDE ={
			["RFC"] = 	"Flammenschlund",
			["DM"] = 	"Die Todesminen",
			["WC"] = 	"Die Höhlen des Wehklagens",
			["SFK"] = 	"Burg Schattenfang",
			["STK"] = 	"Das Verlies",
			["BFD"] = 	"Die Tiefschwarze Grotte",
			["GNO"] = 	"Gnomeregan",
			["RFK"] = 	"Kral der Klingenhauer",
			["SM2"] =	"Scharlachrotes Kloster",
			["SMG"] = 	"Scharlachrotes Kloster: Friedhof",
			["SML"] = 	"Scharlachrotes Kloster: Bibliothek",
			["SMA"] = 	"Scharlachrotes Kloster: Waffenkammer",
			["SMC"] = 	"Scharlachrotes Kloster: Kathedrale",
			["RFD"] = 	"Hügel der Klingenhauer",
			["ULD"] = 	"Uldaman",
			["ZF"] = 	"Zul'Farrak",
			["MAR"] = 	"Maraudon",
			["ST"] = 	"Der Tempel von Atal'Hakkar",
			["BRD"] = 	"Die Schwarzfels-Tiefen",
			["DM2"] = 	"Düsterbruch",
			["DME"] = 	"Düsterbruch: Ost",
			["DMN"] = 	"Düsterbruch: Nord",
			["DMW"] = 	"Düsterbruch: West",
			["STR"] = 	"Stratholme",
			["SCH"] = 	"Scholomance",
			["LBRS"] = 	"Die Untere Schwarzfelsspitze",
			["UBRS"] = 	"Obere Schwarzfelsspitze (10)",
			["RAMPS"] = "Höllenfeuerzitadelle: Höllenfeuerbollwerk",
			["BF"] = 	"Höllenfeuerzitadelle: Der Blutkessel",
			["SP"] = 	"Echsenkessel: Die Sklavenunterkünfte",
			["UB"] = 	"Echsenkessel: Der Tiefensumpf",
			["MT"] = 	"Auchindoun: Die Managruft",
			["CRYPTS"] = "Auchindoun: Die Auchenaikrypta",
			["SETH"] = 	"Auchindoun: Sethekkhallen",
			["OHB"] = 	"Höhlen der Zeit: Flucht von Durnholde",
			["MECH"] = 	"Festung der Stürme: Die Mechanar",
			["BM"] = 	"Höhlen der Zeit: Der Schwarze Morast",
			["MGT"] = 	"Die Terrasse der Magister",
			["SH"] = 	"Höllenfeuerzitadelle: Die Zerschmetterten Hallen",
			["BOT"] = 	"Festung der Stürme: Botanica",
			["SL"] = 	"Auchindoun: Schattenlabyrinth",
			["SV"] = 	"Echsenkessel: Die Dampfkammer",
			["ARC"] = 	"Festung der Stürme: Die Arcatraz",
			["KARA"] = 	"Karazhan",
			["GL"] = 	"Gruuls Unterschlupf",
			["MAG"] = 	"Höllenfeuerzitadelle: Magtheridons Kammer",
			["SSC"] = 	"Echsenkessel: Höhle des Schlangenschreins",
			["EYE"] = 	"Das Auge des Sturms",
			["ZA"] = 	"Zul-Aman",
			["HYJAL"] = "Schlacht um den Berg Hyjal",
			["BT"] = 	"Der Schwarze Tempel",
			["SWP"] = 	"Sonnenbrunnenplateau",
			["ONY"] = 	"Onyxias Hort (40)",
			["MC"] = 	"Geschmolzener Kern (40)",
			["ZG"] = 	"Zul'Gurub (20)",
			["AQ20"] = 	"Ruinen von Ahn'Qiraj (20)",
			["BWL"] = 	"Pechschwingenhort (40)",
			["AQ40"] = 	"Tempel von Ahn'Qiraj (40)",
			["NAX"] = 	"Naxxramas (40)",
			["WSG"] = 	"Warsongschlucht (PVP)",
			["AV"] = 	"Alteractal (PVP)",
			["AB"] = 	"Arathibecken (PVP)",
			["EOTS"] =  "Auge des Sturms (PvP)",
			["ARENA"] = "Arena (PvP)",
			["MISC"] = 	"Verschiedenes",
			["TRADE"] =	"Handel",

		},
		frFR ={
    ["RFC"] = 	"Gouffre de Ragefeu",
    ["DM"] = 	"Les Mortemines",
    ["WC"] = 	"Cavernes des lamentations",
    ["SFK"] = 	"Donjon d'Ombrecroc",
    ["STK"] = 	"La Prison",
    ["BFD"] = 	"Profondeurs de Brassenoire",
    ["GNO"] = 	"Gnomeregan",
    ["RFK"] = 	"Kraal de Tranchebauge",
    ["SM2"] =	"Monastère écarlate",
    ["SMG"] = 	"Monastère écarlate: Cimetière",
    ["SML"] = 	"Monastère écarlate: Bibliothèque",
    ["SMA"] = 	"Monastère écarlate: Armurerie",
    ["SMC"] = 	"Monastère écarlate: Cathédrale",
    ["RFD"] = 	"Souilles de Tranchebauge",
    ["ULD"] = 	"Uldaman",
    ["ZF"] = 	"Zul'Farrak",
    ["MAR"] = 	"Maraudon",
    ["ST"] = 	"Le temple d'Atal'Hakkar",
    ["BRD"] = 	"Profondeurs de Blackrock",
    ["DM2"] = 	"Hache-tripes",
    ["DME"] = 	"Hache-tripes: Est",
    ["DMN"] = 	"Hache-tripes: Nord",
    ["DMW"] = 	"Hache-tripes: Ouest",
    ["STR"] = 	"Stratholme",
    ["SCH"] = 	"Scholomance",
    ["LBRS"] = 	"Pic Blackrock",
    ["UBRS"] = 	"Pic Blackrock (10)",
    ["RAMPS"] = "Citadelle des Flammes Infernales: Remparts des Flammes infernales",
    ["BF"] = 	"Citadelle des Flammes Infernales: La Fournaise du sang",
    ["SP"] = 	"Réservoir de Glissecroc : Les enclos aux esclaves",
    ["UB"] = 	"Réservoir de Glissecroc : La Basse-tourbière",
    ["MT"] = 	"Auchindoun: Tombes-mana",
    ["CRYPTS"] = "Auchindoun: Cryptes Auchenaï",
    ["SETH"] = 	"Auchindoun: Les salles des Sethekk",
    ["OHB"] = 	"Grottes du Temps: Contreforts de Hautebrande d'antan",
    ["MECH"] = 	"Donjon de la Tempête: Le Méchanar",
    ["BM"] = 	"Grottes du Temps: Le Noir Marécage",
    ["MGT"] = 	"Terrasse des Magistères",
    ["SH"] = 	"Citadelle des Flammes Infernales: Les Salles brisées",
    ["BOT"] = 	"Donjon de la Tempête: Botanica",
    ["SL"] = 	"Auchindoun: Labyrinthe des ombres",
    ["SV"] = 	"Réservoir de Glissecroc : Le Caveau de la vapeur",
    ["ARC"] = 	"Donjon de la Tempête: L'Arcatraz",
    ["KARA"] = 	"Karazhan",
    ["GL"] = 	"Repaire de Gruul",
    ["MAG"] = 	"Citadelle des Flammes Infernales: Le repaire de Magtheridon",
    ["SSC"] = 	"Réservoir de Glissecroc : Caverne du sanctuaire du Serpent",
    ["EYE"] = 	"Donjon de la Tempête : L'Oeil",
    ["ZA"] = 	"Zul-Aman",
    ["HYJAL"] = "Sommet d'Hyjal",
    ["BT"] = 	"Temple noir",
    ["SWP"] = 	"Plateau du Puits de soleil",
    ["ONY"] = 	"Repaire d'Onyxia (40)",
    ["MC"] = 	"Cœur du Magma (40)",
    ["ZG"] = 	"Zul'Gurub (20)",
    ["AQ20"] = 	"Ruines d'Ahn'Qiraj (20)",
    ["BWL"] = 	"Repaire de l'Aile noire (40)",
    ["AQ40"] = 	"Ahn'Qiraj (40)",
    ["NAX"] = 	"Naxxramas (40)",
    ["ARENA"] = "Arène (PvP)",
    ["AB"] = "Bassin d'Arathi (PvP)",
    ["ANK"] = "Ahn'kahet, l'Ancien royaume",
    ["AV"] = "Vallée d'Alterac (PvP)",
    ["AZN"] = "Azjol-Nérub",
    ["BREW"] = "Fete des brasseurs - Coren Navrebière",
    ["CHAMP"] = "L'épreuve du champion",
    ["COS"] = "L'Épuration de Stratholme",
    ["DEBUG"] = "DEBUG",
    ["DTK"] = "Donjon de Drak'Tharon",
    ["EOE"] = "L'Oeil de l'éternité",
    ["EOTS"] = "L'Oeil du cyclone (PvP)",
    ["FOS"] = "La Forge des âmes",
    ["GD"] = "Gundrak",
    ["HOL"] = "Les salles de Foudre",
    ["HOLLOW"] = "Sanssaint - Cavalier sans tête",
    ["HOR"] = "Salles des Reflets",
    ["HOS"] = "Les salles de Pierre",
    ["MISC"] = "Divers",
    ["NEX"] = "Le Nexus",
    ["OCC"] = "L'Oculus",
    ["OS"] = "Le sanctum Obsidien",
    ["POS"] = "Fosse de Saron",
    ["RS"] = "Le sanctum Rubis",
    ["SOTA"] = "Rivage des Anciens (PvP)",
    ["TOTC"] = "L'épreuve du croisé",
    ["TRADE"] = "Commerce",
    ["UK"] = "Donjon d'Utgarde",
    ["ULDAR"] = "Ulduar",
    ["UP"] = "Cime d'Utgarde",
    ["VH"] = "Le fort Pourpre",
    ["VOA"] = "Caveau d'Archavon",
    ["WG"] = "Joug-d'hiver",
    ["WSG"] = "Goulet des Chanteguerres (PvP)", 
		},
		esMX ={
			["RFC"] = 	"Sima Ígnea",
			["DM"] = 	"Las Minas de la Muerte",
			["WC"] = 	"Cuevas de los Lamentos",
			["SFK"] = 	"Castillo de Colmillo Oscuro",
			["STK"] = 	"Las Mazmorras",
			["BFD"] = 	"Cavernas de Brazanegra",
			["GNO"] = 	"Gnomeregan",
			["RFK"] = 	"Horado Rajacieno",
			["SM2"] =	"Monasterio Escarlata",
			["SMG"] = 	"Monasterio Escarlata: Friedhof",
			["SML"] = 	"Monasterio Escarlata: Bibliothek",
			["SMA"] = 	"Monasterio Escarlata: Waffenkammer",
			["SMC"] = 	"Monasterio Escarlata: Kathedrale",
			["RFD"] = 	"Zahúrda Rojocieno",
			["ULD"] = 	"Uldaman",
			["ZF"] = 	"Zul'Farrak",
			["MAR"] = 	"Maraudon",
			["ST"] = 	"El Templo de Atal'Hakkar",
			["BRD"] = 	"Profundidades de Roca Negra	",
			["DM2"] = 	"La Masacre",
			["DME"] = 	"La Masacre: Ost",
			["DMN"] = 	"La Masacre: Nord",
			["DMW"] = 	"La Masacre: West",
			["STR"] = 	"Stratholme",
			["SCH"] = 	"Scholomance",
			["LBRS"] = 	"Cumbre de Roca Negra",
			["UBRS"] = 	"Cumbre de Roca Negra (10)",
			["RAMPS"] = "Hellfire Citadel: Ramparts",
			["BF"] = 	"Hellfire Citadel: Blood Furnace",
			["SP"] = 	"Coilfang Reservoir: Slave Pens",
			["UB"] = 	"Coilfang Reservoir: Underbog",
			["MT"] = 	"Auchindoun: Mana Tombs",
			["CRYPTS"] = "Auchindoun: Auchenai Crypts",
			["SETH"] = 	"Auchindoun: Sethekk Halls",
			["OHB"] = 	"Caverns of Time: Old Hillsbrad",
			["MECH"] = 	"Tempest Keep: The Mechanar",
			["BM"] = 	"Caverns of Time: Black Morass",
			["MGT"] = 	"Magisters' Terrace",
			["SH"] = 	"Hellfire Citadel: Shattered Halls",
			["BOT"] = 	"Tempest Keep: Botanica",
			["SL"] = 	"Auchindoun: Shadow Labyrinth",
			["SV"] = 	"Coilfang Reservoir: Steamvault",
			["ARC"] = 	"Tempest Keep: The Arcatraz",
			["KARA"] = 	"Karazhan",
			["GL"] = 	"Gruul's Lair",
			["MAG"] = 	"Hellfire Citadel: Magtheridon's Lair",
			["SSC"] = 	"Coilfang Reservoir: Serpentshrine Cavern",
			["EYE"] = 	"The Eye",
			["ZA"] = 	"Zul-Aman",
			["HYJAL"] = "The Battle For Mount Hyjal",
			["BT"] = 	"Black Temple",
			["SWP"] = 	"Sunwell Plateau",
			["ONY"] = 	"Guarida de Onyxia (40)",
			["MC"] = 	"Núcleo de Magma (40)",
			["ZG"] = 	"Zul'Gurub (20)",
			["AQ20"] = 	"Ruinas de Ahn'Qiraj (20)",
			["BWL"] = 	"Guarida Alanegra (40)",
			["AQ40"] = 	"Ahn'Qiraj (40)",
			["NAX"] = 	"Naxxramas (40)",
			["ARENA"] = "Arena (PvP)",

		},
		ruRU = {
			["AB"] = "Низина Арати (PvP)",
			["ANK"] = "Ан'кахет: Старое Королевство",
			["AQ20"] = "Руины Ан'Киража (20)",
			["AQ40"] = "Ан'Кираж (40)",
			["ARC"] = "Крепость Бурь: Аркатрац",
			["ARENA"] = "Арена (PvP)",
			["AV"] = "Альтеракская Долина (PvP)",
			["AZN"] = "Азжол-Неруб",
			["BAD"] = "ОТЛАДКА ПЛОХИЕ СЛОВА - ОТКЛОНЕН",
			["BF"] = "Цитадель Адского Пламени: Кузня Крови",
			["BFD"] = "Непроглядная Пучина",
			["BM"] = "Пещеры Времени: Черные топи",
			["BOT"] = "Крепость Бурь: Ботаника",
			["BRD"] = "Глубины Черной горы",
			["BREW"] = "Хмельной фестиваль - Корен Худовар",
			["BT"] = "Черный Храм",
			["BWL"] = "Логово Крыла Тьмы (40)",
			["CHAMP"] = "Испытание Чемпиона",
			["COS"] = "Очищение Стратхольма",
			["CRYPTS"] = "Аукиндон: Аукенайские гробницы",
			["DEBUG"] = "ИНФОРМАЦИЯ О ОТЛАДКАХ",
			["DM"] = "Мертвые копи",
			["DM2"] = "Забытый Город",
			["DME"] = "Забытый Город: Восток",
			["DMN"] = "Забытый Город: Север",
			["DMW"] = "Забытый Город: Запад",
			["DTK"] = "Крепость Драк'Тарон",
			["EOE"] = "Око Вечности",
			["EOTS"] = "Око Бури (PvP)",
			["EYE"] = "Крепость Бурь: Око",
			["FOS"] = "Кузня Душ",
			["GD"] = "Гундрак",
			["GL"] = "Логово Груула",
			["GNO"] = "Гномреган",
			["HOL"] = "Чертоги Молний",
			["HOLLOW"] = "Тыквовин - Всадник без головы",
			["HOR"] = "Залы Отражений",
			["HOS"] = "Чертоги Камня",
			["HYJAL"] = "Пещеры Времени: Вершина Хиджала",
			["ICC"] = "Цитадель Ледяной Короны",
			["KARA"] = "Каражан",
			["LBRS"] = "Низ Вершины Черной горы",
			["MAG"] = "Цитадель Адского Пламени: Логово Магтеридона",
			["MAR"] = "Мародон",
			["MC"] = "Огненные Недра (40)",
			["MECH"] = "Крепость Бурь: Механар",
			["MGT"] = "Терраса магистров",
			["MISC"] = "Прочее",
			["MT"] = "Аукиндон: Гробницы Маны",
			["NAX"] = "Наксрамас (40)",
			["NAXX"] = "Наксрамас",
			["NEX"] = "Нексус",
			["OCC"] = "Окулус",
			["OHB"] = "Пещеры Времени: Старые предгорья Хилсбрада",
			["ONY"] = "Логово Ониксии (40)",
			["OS"] = "Обсидиановое святилище",
			["POS"] = "Яма Сарона",
			["RAMPS"] = "Цитадель Адского Пламени: Бастионы",
			["RFC"] = "Огненная пропасть",
			["RFD"] = "Курганы Иглошкурых",
			["RFK"] = "Лабиринты Иглошкурых",
			["RS"] = "Рубиновое Святилище",
			["SCH"] = "Некроситет",
			["SETH"] = "Аукиндон: Сетеккские залы",
			["SFK"] = "Крепость Темного Клыка",
			["SH"] = "Цитадель Адского Пламени: Разрушенные залы",
			["SL"] = "Аукиндон: Темный лабиринт",
			["SM2"] = "Монастырь Алого ордена",
			["SMA"] = "Монастырь Алого ордена: Оружейная",
			["SMC"] = "Монастырь Алого ордена: Собор",
			["SMG"] = "Монастырь Алого ордена: Кладбище",
			["SML"] = "Монастырь Алого ордена: Библиотека",
			["SOTA"] = "Берег Древних (PvP)",
			["SP"] = "Резервуар Кривого Клыка: Узилище",
			["SSC"] = "Резервуар Кривого Клыка: Змеиное святилище",
			["ST"] = "Затонувший Храм",
			["STK"] = "Тюрьма",
			["STR"] = "Стратхольм",
			["SV"] = "Резервуар Кривого Клыка: Паровое подземелье",
			["SWP"] = "Плато Солнечного Колодца",
			["TOTC"] = "Испытание Крестоносца",
			["TRADE"] = "Торговля",
			["UB"] = "Резервуар Кривого Клыка: Нижетопь",
			["UBRS"] = "Верх Вершины Черной горы (10)",
			["UK"] = "Крепость Утгард",
			["ULD"] = "Ульдаман",
			["ULDAR"] = "Ульдуар",
			["UP"] = "Вершина Утгард",
			["VH"] = "Аметистовая крепость",
			["VOA"] = "Склеп Аркавона",
			["WC"] = "Пещеры Стенаний",
			["WG"] = "Озеро ледяных оков (PvP)",
			["WSG"] = "Ущелье Песни Войны (PvP)",
			["ZA"] = "Зул'Аман",
			["ZF"] = "Зул'Фаррак",
			["ZG"] = "Зул'Гуруб (20)",
		},
		zhTW ={
			["RFC"] = 	"怒焰裂谷",
			["DM"] = 	"死亡礦坑",
			["WC"] = 	"哀嚎洞穴",
			["SFK"] = 	"影牙城堡",
			["STK"] = 	"監獄",
			["BFD"] = 	"黑暗深淵",
			["GNO"] = 	"諾姆瑞根",
			["RFK"] = 	"剃刀沼澤",
			["SM2"] =	"血色修道院",
			["SMG"] = 	"血色修道院: 墓地",
			["SML"] = 	"血色修道院: 圖書館",
			["SMA"] = 	"血色修道院: 軍械庫",
			["SMC"] = 	"血色修道院: 大教堂",
			["RFD"] = 	"剃刀高地",
			["ULD"] = 	"奧達曼",
			["ZF"] = 	"祖爾法拉克",
			["MAR"] = 	"瑪拉頓",
			["ST"] = 	"阿塔哈卡神廟",
			["BRD"] = 	"黑石深淵",
			["DM2"] = 	"厄運之槌",
			["DME"] = 	"厄運之槌: 東",
			["DMN"] = 	"厄運之槌: 北",
			["DMW"] = 	"厄運之槌: 西",
			["STR"] = 	"斯坦索姆",
			["SCH"] = 	"通靈學院",
			["LBRS"] = 	"黑石塔下層",
			["UBRS"] = 	"黑石塔上層 (10)",
			["RAMPS"] = 	"地獄火壁壘",
			["BF"] = 	"血熔爐",
			["SP"] = 	"奴隸監獄",
			["UB"] = 	"深幽泥沼",
			["MT"] = 	"法力墓地",
			["CRYPTS"] = 	"奧奇奈地穴",
			["SETH"] = 	"塞司克大廳",
			["OHB"] = 	"希爾斯布萊德丘陵舊址",
			["MECH"] = 	"麥克納爾",
			["BM"] = 	"黑色沼澤",
			["MGT"] = 	"博學者殿堂",
			["SH"] = 	"破碎大廳",
			["BOT"] = 	"波塔尼卡",
			["SL"] = 	"暗影迷宮",
			["SV"] = 	"蒸氣洞穴",
			["ARC"] = 	"亞克崔茲",
			--
			["ANK"] =	"安卡罕特：古王國",
			["AZN"] =	"阿茲歐-奈幽",
			["DTK"] =	"德拉克薩隆要塞",
			["GD"] =	"剛德拉克",
			["HOL"] =	"電光大廳",
			["HOS"] =	"石之大廳",
			["COS"] =	"斯坦索姆的抉擇",
			["NEX"] =	"奧核之心",
			["OCC"] =	"奧核之眼",
			["VH"] =	"紫羅蘭堡",
			["UK"] =	"俄特加德要塞",
			["UP"] =	"俄特加德之巔",
			["CHAMP"] =	"勇士試煉",
			["FOS"] =	"眾魂熔爐",
			["POS"] =	"薩倫之淵",
			["HOR"] =	"倒影大廳",
			["VOA"] =	"亞夏梵穹殿",
			["NAXX"] =	"納克薩瑪斯",
			["EOE"] =	"奧核之心: 永恆之眼",
			["OS"] =	"黑曜聖所",
			["ULDAR"] =	"奧杜亞",
			["TOTC"] =	"十字軍試煉",
			["ICC"] =	"冰冠城塞",
			["RS"] =	"晶紅聖所",
			["BREW"] =  "啤酒節 - 柯林．烈酒",
			["SOTA"] =  "遠古灘頭 (PvP)",
			["WG"]  =   "冬握湖 (PvP)",							   
			["KARA"] = 	"卡拉贊 (10)",
			["GL"] = 	"戈魯爾之巢 (25)",
			["MAG"] = 	"瑪瑟里頓的巢穴 (25)",
			["SSC"] = 	"毒蛇神殿洞穴 (25)",
			["EYE"] = 	"風暴要塞 (25)",
			["ZA"] = 	"祖阿曼 (10)",
			["HYJAL"] = 	"海加爾山 (25)",
			["BT"] = 	"黑暗神廟 (25)",
			["SWP"] = 	"太陽之井高地 (25)",
			["ONY"] = 	"奧妮克希亞的巢穴 (40)",
			["MC"] = 	"熔火之心 (40)",
			["ZG"] = 	"祖爾格拉布 (20)",
			["AQ20"] = 	"安其拉廢墟 (20)",
			["BWL"] = 	"黑翼之巢 (40)",
			["AQ40"] = 	"安其拉 (40)",
			["NAX"] = 	"納克薩瑪斯 (40)",
			["WSG"] = 	"戰歌峽谷 (PvP)",
			["AB"] = 	"阿拉希盆地 (PvP)",
			["AV"] = 	"奧特蘭克山谷 (PvP)",
			["EOTS"] = 	"暴風之眼 (PvP)",
			["ARENA"] = "競技場 (PvP)",
			["MISC"] = 	"未分類",
			["TRADE"] =	"交易",
			["TRAVEL"] = "傳送服務",
		},
		zhCN ={
			["UK"] = 	"乌特加德城堡",
			["NEX"] = 	"魔枢",
			["AZN"] = 	"艾卓",
			["ANK"] = 	"安卡赫特：古代王国",
			["DTK"] = 	"达克萨隆要塞",
			["VH"] = 	"紫罗兰监狱",
			["GD"] = 	"古达克",
			["HOS"] = 	"岩石大厅",
			["HOL"] = 	"闪电大厅",
			["COS"] = 	"净化斯坦索姆",
			["OCC"] = 	"魔环",
			["UP"] = 	"乌特加德之巅",
			["FOS"] = 	"灵魂洪炉",
			["POS"] = 	"萨隆深渊",
			["HOR"] = 	"映像大厅",
			["CHAMP"] = "冠军的试炼",
			["NAXX"] = 	"纳克萨玛斯80",

			["OS"]   =  "黑曜石圣殿 红龙",
			["VOA"] = 	"阿尔卡冯的宝库",
			["EOE"] = 	"永恒之眼 蓝龙",
			["ULDAR"] = "奥杜尔",
			["TOTC"] = 	"十字军的试炼",
			["RS"] = 	"红玉圣殿",
			["ICC"] = 	"冰冠碉堡",

			["RFC"] = 	"怒焰峡谷",
			["DM"] = 	"死亡矿坑",
			["WC"] = 	"哀嚎洞穴",
			["SFK"] = 	"影牙城堡",
			["STK"] = 	"监狱",
			["BFD"] = 	"黑暗深渊",
			["GNO"] =  	"诺莫瑞根" ,
			["RFK"] = 	"剃刀沼泽",
			["SM2"] =	"血色修道院",
			["SMG"] = 	"血色修道院: 墓地",
			["SML"] = 	"血色修道院: 图书馆",
			["SMA"] = 	"血色修道院: 武器库",
			["SMC"] = 	"血色修道院: 教堂",
			["RFD"] = 	"剃刀高地",
			["ULD"] = 	"奥达曼",
			["ZF"] = 	"祖尔法拉克",
			["MAR"] = 	"玛拉顿",
			["ST"] = 	"沉默的神庙",
			["BRD"] = 	"黑石深渊",
			["DM2"] = 	"厄运之槌",
			["DME"] = 	"厄運之槌: 东",
			["DMN"] = 	"厄運之槌: 北",
			["DMW"] = 	"厄運之槌: 西",
			["STR"] = 	"斯坦索姆",
			["SCH"] = 	"通灵學院",
			["LBRS"] = 	"黑石塔下层",
			["UBRS"] = 	"黑石塔上层 (10)",
			["RAMPS"] = "地狱火城墙",
			["BF"] = 	"献血熔炉",
			["SP"] = 	"奴隶围栏",
			["UB"] = 	"幽暗沼泽",
			["MT"] = 	"法力陵墓",
			["CRYPTS"] = "奥金尼地穴",
			["SETH"] = 	"塞泰克大厅",
			["OHB"] = 	"旧希尔斯布莱德丘陵",
			["MECH"] = 	"能源舰",
			["BM"] = 	"黑色沼泽",
			["MGT"] = 	"魔导师平台",
			["SH"] = 	"破碎大厅",
			["BOT"] = 	"生态船",
			["SL"] = 	"暗影迷宮",
			["SV"] = 	"蒸汽地窖",
			["ARC"] = 	"禁魔监狱",
			["KARA"] = 	"卡拉赞 (10)",
			["GL"] = 	"格鲁尔之巢 (25)",
			["MAG"] = 	"玛瑟里顿的巢穴 (25)",
			["SSC"] = 	"毒蛇神殿 (25)",
			["EYE"] = 	"风暴要塞 (25)",
			["ZA"] = 	"祖阿曼 (10)",
			["HYJAL"] = "海加尔山 (25)",
			["BT"] = 	"黑暗神庙 (25)",
			["SWP"] = 	"太阳之井高地 (25)",
			["ONY"] = 	"奧妮克希亞的巢穴 (40)",
			["MC"] = 	"熔火之心 (40)",
			["ZG"] = 	"祖尔格拉布 (20)",
			["AQ20"] = 	"安其拉废墟 (20)",
			["BWL"] = 	"黑翼之巢 (40)",
			["AQ40"] = 	"安其拉 (40)",
			["NAX"] = 	"纳克萨玛斯 (40)",
			["WSG"] = 	"战歌峽谷 (PvP)",
			["AB"] = 	"阿拉希盆地 (PvP)",
			["AV"] = 	"奧特兰克山谷 (PvP)",
			["EOTS"] = 	"风暴之眼 (PvP)",
			["MISC"] = 	"未分類",
			["TRADE"] =	"交易",
			["TRAVEL"] = "传送服务",
		},
	}



	local dungeonNames = dungeonNamesLocales[GetLocale()] or {}

	if GroupBulletinBoardDB and GroupBulletinBoardDB.CustomLocalesDungeon and type(GroupBulletinBoardDB.CustomLocalesDungeon) == "table" then
		for key,value in pairs(GroupBulletinBoardDB.CustomLocalesDungeon) do
			if value~=nil and value ~="" then
				dungeonNames[key.."_org"]=dungeonNames[key] or DefaultEnGB[key]
				dungeonNames[key]=value
			end
		end
	end


	-- use client generated names instead of english- 
	-- as fallbacks for missing manual translations
	local dungeonKeys = GBB.GetSortedDungeonKeys()
	for _, key in ipairs(dungeonKeys) do
		DefaultEnGB[key] = GBB.GetDungeonInfo(key).name or DefaultEnGB[key]
	end

	setmetatable(dungeonNames, {__index = DefaultEnGB})

	dungeonNames["DEADMINES"]=dungeonNames["DM"]

	return dungeonNames
end
----------------------------------------------
-- local/private heplers and data
----------------------------------------------

--- the `Union` function is included in sharexml's TableUtils.lua already as `MergeTable`
-- note: blizz's `MergeTable` **doesnt** return reference to the resulting table
local function mergeTables(...)
	local resulting = {}
	for i = 1, select("#", ...) do
		local nextTbl = select(i, ...)
		assert(type(nextTbl) == "table", "All arguments to `mergeTables` must be tables.")
		MergeTable(resulting, nextTbl) 
	end
	return resulting
end

-- Generated in `/dungeons/{version}.lua` files
local classicDungeonLevels = GBB.GetDungeonLevelRanges(GBB.Enum.Expansions.Classic)

local cataDungeonKeys = GBB.GetSortedDungeonKeys(
	GBB.Enum.Expansions.Cataclysm,
	{ GBB.Enum.DungeonType.Dungeon, GBB.Enum.DungeonType.Raid }
);

local wotlkDungeonNames = GBB.GetSortedDungeonKeys(
	GBB.Enum.Expansions.Wrath,
	{ GBB.Enum.DungeonType.Dungeon, GBB.Enum.DungeonType.Raid }
);

local tbcDungeonNames = GBB.GetSortedDungeonKeys(
	GBB.Enum.Expansions.BurningCrusade,
	{ GBB.Enum.DungeonType.Dungeon, GBB.Enum.DungeonType.Raid }
);

-- not specificying an expansion id gives **all** available dungeons **up to** current game xpac
local pvpNames = GBB.GetSortedDungeonKeys(nil, GBB.Enum.DungeonType.Battleground);

local debugNames = {"DEBUG", "BAD", "NIL"}

local raidNames = GBB.GetSortedDungeonKeys(nil,{ GBB.Enum.DungeonType.Raid, GBB.Enum.DungeonType.WorldBoss });

-- Becasue theyre not actually dungeons and are not parsed by 
-- `/data/dungeons/{version}.lua` we need to add them manually
local miscCatergoriesLevels = {
	["MISC"] = {0,100}, ["TRAVEL"] = {0,100}, ["DEBUG"] = {0,100},
	["BAD"] = {0,100}, ["TRADE"] = {0,100}, ["NIL"] = {0,100},
}

-- Needed because Lua sucks, Blizzard switch to Python please
-- Takes in a list of dungeon lists, it will then concatenate the lists into a single list
-- it will put the dungeons in an order and give them a value incremental value that can be used for sorting later
-- ie one list "Foo" which contains "Bar" and "FooBar" and a second list "BarFoo" which contains "BarBar"
-- the output would be single list with "Bar" = 1, "FooBar" = 2, "BarFoo" = 3, "BarBar" = 4
local function ConcatenateLists(Names)
	local result = {}
	local index = 1
	for k, nameLists in pairs (Names) do
		for _, v in pairs(nameLists) do
			result[v] = index
			index = index + 1
		end
	end
	return result, index
end
----------------------------------------------
-- Global functions/data
----------------------------------------------

---Used in GBB.RaidList to determine if an incomming request is for a raid or regular dungeon.
---@return {[string]: 1} # a table, with the keys being the `tagKey`s for all available raids
function GBB.GetRaids()
	local arr = {}
	for _, v in pairs (raidNames) do
		arr[v] = 1
	end
	return arr
end

-- used in Tags.lua for determining which tags are safe for game version
-- used in Options.lua for determining adding filter boxes
local vanillaDungeonKeys = GBB.GetSortedDungeonKeys(
	GBB.Enum.Expansions.Classic,
	{ GBB.Enum.DungeonType.Dungeon, GBB.Enum.DungeonType.Raid, GBB.Enum.DungeonType.WorldBoss }
);

-- clear unused dungeons in classic to not generate options/checkboxes with the-
-- new data pipeline api these tables should already empty anyways when in classic client
if isClassicEra then
	tbcDungeonNames = {}
	wotlkDungeonNames = {}
end

---@param additonalCategories (string[]|string[][])?
function GBB.GetDungeonSort(additonalCategories)
	if additonalCategories then
		if additonalCategories[1]  
		and type(additonalCategories[1]) == "table"
		then -- flatten if 2d array provided
			---@cast additonalCategories string[][]
			local seen = {}
			for _, categoryTable in ipairs(additonalCategories) do
				for _, category in ipairs(categoryTable) do
					seen[category] = true
				end
			end
			additonalCategories = GetKeysArray(seen) --[[@as string[] ]]
		end
	else
		additonalCategories = {} --[[@as string[] ]]
	end
	local dungeonOrder = { 
		vanillaDungeonKeys, tbcDungeonNames, wotlkDungeonNames, cataDungeonKeys, 
		pvpNames, additonalCategories, GBB.Misc, debugNames
	}

	local vanillaDungeonSize = #vanillaDungeonKeys
	local tbcDungeonSize = #tbcDungeonNames
	local wotlkDungeonSize = #wotlkDungeonNames
	local cataDungeonSize = #cataDungeonKeys
	local debugSize = #debugNames

	local tmp_dsort, concatenatedSize = ConcatenateLists(dungeonOrder)
	local dungeonSort = {}

	GBB.TBCDUNGEONSTART = vanillaDungeonSize + 1
	GBB.MAXDUNGEON = vanillaDungeonSize
	GBB.TBCMAXDUNGEON = vanillaDungeonSize  + tbcDungeonSize
	GBB.WOTLKDUNGEONSTART = GBB.TBCMAXDUNGEON + 1
	GBB.WOTLKMAXDUNGEON = wotlkDungeonSize + GBB.TBCMAXDUNGEON + cataDungeonSize
	GBB.ENDINGDUNGEONSTART = GBB.WOTLKMAXDUNGEON + 1
	
	-- used in Options.lua for drawing dungeon editboxes for search patterns 
	GBB.ENDINGDUNGEONEND = concatenatedSize - debugSize - 1

	for dungeon,nb in pairs(tmp_dsort) do
		dungeonSort[nb]=dungeon
		dungeonSort[dungeon]=nb
	end

	-- Need to do this because I don't know I am too lazy to debug the use of SM2, DM2, and DEADMINES
	dungeonSort["SM2"] = 10.5
	dungeonSort["DM2"] = 19.5

	-- add reverse link for the SM2 and DM2 for the Combine option 
	dungeonSort[dungeonSort["SM2"]] = "SM2"
	dungeonSort[dungeonSort["DM2"]] = "DM2"

	-- This is set to a high index with no reverse link because-
	-- we dont ever want to show this in the list during `UpdateList()` (might not be relevant anymore)
	-- Ideally the "DEADMINES" key should never make it to the `req.dungeon` field as it should be converted to either "DM" or "DM2"/"DMW"/"DME"/"DMN" in GBB.GetDungeon() 
	dungeonSort["DEADMINES"] = GBB.ENDINGDUNGEONEND + 20
	
	return dungeonSort
end

if isClassicEra then
	GBB.dungeonLevel = mergeTables(classicDungeonLevels, miscCatergoriesLevels)
else
	GBB.dungeonLevel = mergeTables(
		GBB.GetDungeonLevelRanges(), -- all dungeon types, all expansions
		miscCatergoriesLevels
	)
end

-- needed because Option.lua hardcodes a checkbox for "DEADMINES"
GBB.dungeonLevel["DEADMINES"] = GBB.dungeonLevel["DM"]

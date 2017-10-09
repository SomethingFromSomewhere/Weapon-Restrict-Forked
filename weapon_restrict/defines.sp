const int 	WEAPON_NONE = 0,
			WEAPON_P228 = 1,
			WEAPON_GLOCK = 2,
			WEAPON_SCOUT = 3,
			WEAPON_HEGRENADE = 4,
			WEAPON_XM1014 = 5,
			WEAPON_C4 = 6,
			WEAPON_MAC10 = 7,
			WEAPON_AUG = 8,
			WEAPON_SMOKEGRENADE = 9,
			WEAPON_ELITE = 10,
			WEAPON_FIVESEVEN = 11,
			WEAPON_UMP45 = 12,
			WEAPON_SG550 = 13,
			WEAPON_GALIL = 14,
			WEAPON_FAMAS = 15,
			WEAPON_USP = 16,
			WEAPON_AWP = 17,
			WEAPON_MP5NAVY = 18,
			WEAPON_M249 = 19,
			WEAPON_M3 = 20,
			WEAPON_M4A1 = 21,
			WEAPON_TMP = 22,
			WEAPON_G3SG1 = 23,
			WEAPON_FLASHBANG = 24,
			WEAPON_DEAGLE = 25,
			WEAPON_SG552 = 26,
			WEAPON_AK47 = 27,
			WEAPON_KNIFE = 28,
			WEAPON_P90 = 29,
			WEAPON_SHIELD = 30,
			WEAPON_KEVLAR = 31,
			WEAPON_ASSAULTSUIT = 32,
			WEAPON_NIGHTVISION = 33,
			WEAPON_GALILAR = 34,
			WEAPON_BIZON = 35,
			WEAPON_MAG7 = 36,
			WEAPON_NEGEV = 37,
			WEAPON_SAWEDOFF = 38,
			WEAPON_TEC9 = 39,
			WEAPON_TASER = 40,
			WEAPON_HKP2000 = 41,
			WEAPON_MP7 = 42,
			WEAPON_MP9 = 43,
			WEAPON_NOVA = 44,
			WEAPON_P250 = 45,
			WEAPON_SCAR17 = 46,
			WEAPON_SCAR20 = 47,
			WEAPON_SG556 = 48,
			WEAPON_SSG08 = 49,
			WEAPON_KNIFE_GG = 50,
			WEAPON_MOLOTOV = 51,
			WEAPON_DECOY = 52,
			WEAPON_INCGRENADE = 53,
			WEAPON_DEFUSER = 54,
			WEAPON_ID_MAX = 55,

			WeaponTypePistol = 0,
			WeaponTypeSMG = 1,
			WeaponTypeShotgun = 2,
			WeaponTypeRifle = 3,
			WeaponTypeSniper = 4,
			WeaponTypeGrenade = 5,
			WeaponTypeArmor = 6,
			WeaponTypeMachineGun = 7,
			WeaponTypeKnife = 8,
			WeaponTypeOther = 9,
			WeaponTypeShield = 10,
			WeaponTypeNone = 11,
			WeaponTypeTaser = 12,

			SlotNone = -1,
			SlotPrimmary = 0,
			SlotPistol = 1,
			SlotKnife = 2,
			SlotGrenade = 3,
			SlotC4 = 4,
			SlotUnknown = 5,
			
			InfoID = 0,
			InfoSlot = 1,
			InfoType = 2,
			InfoTeam = 3,
			InfoMax = 4,
			
			COUNTERTERRORISTTEAM = 3,
			TERRORISTTEAM = 2,
			BOTHTEAMS = 0,
			UNKNOWNTEAM = -1,
			
			MAXWEAPONGROUPS = 7;


char weaponNames[WEAPON_ID_MAX][] = 
{ 
	"none",			"p228",			"glock",		"scout",		
	"hegrenade",	"xm1014",		"c4",			"mac10",		
	"aug",			"smokegrenade",	"elite",		"fiveseven",
	"ump45",		"sg550",		"galil",		"famas",
	"usp",			"awp",			"mp5navy",		"m249",
	"m3",			"m4a1",			"tmp",			"g3sg1",
	"flashbang",	"deagle",		"sg552",		"ak47",
	"knife",		"p90",			"shield",		"kevlar",			
	"assaultsuit",	"nvgs",			"galilar",		"bizon",
	"mag7",			"negev",		"sawedoff",		"tec9",
	"taser",		"hkp2000",		"mp7",			"mp9",
	"nova",			"p250",			"scar17",		"scar20",
	"sg556",		"ssg08",		"knifegg",		"molotov",
	"decoy",		"incgrenade",	"defuser"
};


public const int weaponGroups[WEAPON_ID_MAX] = 
{ 
	WeaponTypeNone,		WeaponTypePistol,		WeaponTypePistol,		WeaponTypeSniper,	
	WeaponTypeGrenade,	WeaponTypeShotgun,	WeaponTypeOther,		WeaponTypeSMG,
	WeaponTypeRifle,		WeaponTypeGrenade,	WeaponTypePistol,		WeaponTypePistol,
	WeaponTypeSMG,		WeaponTypeSniper,		WeaponTypeRifle,		WeaponTypeRifle,
	WeaponTypePistol,		WeaponTypeSniper,		WeaponTypeSMG,		WeaponTypeMachineGun,
	WeaponTypeShotgun,	WeaponTypeRifle,		WeaponTypeSMG,		WeaponTypeSniper,
	WeaponTypeGrenade,	WeaponTypePistol,     WeaponTypeRifle,		WeaponTypeRifle,
	WeaponTypeKnife,		WeaponTypeSMG,		WeaponTypeShield,		WeaponTypeArmor,
	WeaponTypeArmor,		WeaponTypeOther,		WeaponTypeRifle,		WeaponTypeSMG,
	WeaponTypeShotgun,	WeaponTypeMachineGun,	WeaponTypeShotgun,	WeaponTypePistol,
	WeaponTypeTaser,		WeaponTypePistol,		WeaponTypeSMG,		WeaponTypeSMG,
	WeaponTypeShotgun,	WeaponTypePistol,		WeaponTypeRifle,		WeaponTypeSniper,
	WeaponTypeRifle,		WeaponTypeSniper,		WeaponTypeKnife,		WeaponTypeGrenade,
	WeaponTypeGrenade,	WeaponTypeGrenade,	WeaponTypeOther
};


public const int weaponSlots[WEAPON_ID_MAX] = 
{ 
	SlotUnknown,		SlotPistol,			SlotPistol,			SlotPrimmary,	
	SlotGrenade,		SlotPrimmary,		SlotC4,				SlotPrimmary,
	SlotPrimmary,		SlotGrenade,		SlotPistol,			SlotPistol,
	SlotPrimmary,		SlotPrimmary,		SlotPrimmary,		SlotPrimmary,
	SlotPistol,			SlotPrimmary,		SlotPrimmary,		SlotPrimmary,
	SlotPrimmary,		SlotPrimmary,		SlotPrimmary,		SlotPrimmary,
	SlotGrenade,		SlotPistol,			SlotPrimmary,		SlotPrimmary,
	SlotKnife,			SlotPrimmary, 		SlotUnknown,		SlotNone,
	SlotNone,			SlotNone,			SlotPrimmary,		SlotPrimmary,
	SlotPrimmary,		SlotPrimmary,		SlotPrimmary,		SlotPistol,
	SlotKnife,			SlotPistol,			SlotPrimmary,		SlotPrimmary,
	SlotPrimmary,		SlotPistol,			SlotPrimmary,		SlotPrimmary,
	SlotPrimmary,		SlotPrimmary,		SlotKnife,			SlotGrenade,
	SlotGrenade,		SlotGrenade,		SlotNone
};


public const int BuyTeams[WEAPON_ID_MAX] = 
{ 
	UNKNOWNTEAM,			BOTHTEAMS,				BOTHTEAMS,				BOTHTEAMS,	
	BOTHTEAMS,				BOTHTEAMS,				TERRORISTTEAM,			TERRORISTTEAM,
	COUNTERTERRORISTTEAM,	BOTHTEAMS,				TERRORISTTEAM,			COUNTERTERRORISTTEAM,
	BOTHTEAMS,				COUNTERTERRORISTTEAM,	TERRORISTTEAM,			COUNTERTERRORISTTEAM,
	BOTHTEAMS,				BOTHTEAMS,				BOTHTEAMS,				BOTHTEAMS,
	BOTHTEAMS,				COUNTERTERRORISTTEAM,	COUNTERTERRORISTTEAM,	TERRORISTTEAM,
	BOTHTEAMS,				BOTHTEAMS,				TERRORISTTEAM,			TERRORISTTEAM,
	BOTHTEAMS,				BOTHTEAMS,				UNKNOWNTEAM,			BOTHTEAMS,
	BOTHTEAMS,				BOTHTEAMS,				TERRORISTTEAM,			BOTHTEAMS,
	COUNTERTERRORISTTEAM,	BOTHTEAMS,				TERRORISTTEAM,			TERRORISTTEAM,
	BOTHTEAMS,				BOTHTEAMS,				BOTHTEAMS,				COUNTERTERRORISTTEAM,
	BOTHTEAMS,				BOTHTEAMS,				UNKNOWNTEAM,			COUNTERTERRORISTTEAM,
	TERRORISTTEAM,			BOTHTEAMS,				BOTHTEAMS,				TERRORISTTEAM,
	BOTHTEAMS,				COUNTERTERRORISTTEAM,	COUNTERTERRORISTTEAM
};


public const int AllowedGame[WEAPON_ID_MAX] = 
{
	-1,				2,				1,				2,
	1,				1,				1,				1,		
	1,				1,				1,				1,
	1,				2,				2,				1,
	2,				1,				2,				1,
	2,				1,				2,				1,
	1,				1,				2,				1,
	1,				1,				-1,				1,			
	1,				1,				3,				3,
	3,				3,				3,				3,
	3,				3,				3,				3,
	3,				3,				-1,				3,
	3,				3,				3,				3,
	3,				3,				1
};


public const char g_WeaponGroupNames[][WEAPONARRAYSIZE] = {"pistols", "smgs", "shotguns", "rifles", "snipers", "grenades", "armor"};


bool g_bSpamProtectPrint[MAXPLAYERS+1],		g_bPerPlayerSpecs, 						g_bPerPlayerBots, 

	g_bPerPlayerRestrict, 					g_bAdminImmunity, 						g_bAllow,
	
	bIsFirstKey = true,						g_bLateLoaded, 							g_bImmunity[MAXPLAYERS+1],
	
	g_bOverideT[WEAPON_ID_MAX], 				g_bOverideCT[WEAPON_ID_MAX];
	

int 	g_iMenuAmount[MAXPLAYERS+1], 			g_iWeaponSlected[MAXPLAYERS+1], 			g_iGroupSelected[MAXPLAYERS+1], 

	g_bIsGroup[MAXPLAYERS+1], 				g_bIsUnrestrict[MAXPLAYERS+1],			CvarArrayHandleValCT[WEAPON_ID_MAX], 
	
	CvarArrayHandleValT[WEAPON_ID_MAX], 		g_iMaxMoney, 							g_iHeAmmo, 
	
	g_iFlashAmmo, 							g_iSmokeAmmo,							defaultValuesCT[WEAPON_ID_MAX], 
	
	defaultValuesT[WEAPON_ID_MAX], 			currentID = WEAPON_NONE, 				iLastVal = -1, 
	
	iLastIndex = 0, 						perPlayer[WEAPON_ID_MAX][MAXPLAYERS+1],	g_iMyWeaponsMax = 31, 
	
	HEGRENADE_AMMO = 11, 					FLASH_AMMO = 12, 						SMOKE_AMMO = 13, 
	
	INC_AMMO = 16, 							DECOY_AMMO = 17;
	
	
TopMenuObject g_hWR;
TopMenu 		g_hAdminMenu;


ConVar 	g_hRestrictCVarsT[WEAPON_ID_MAX-4], 		g_hRestrictCVarsCT[WEAPON_ID_MAX-4];
Handle	hCanBuyForward, 						hCanPickupForward;


enum GameType
{
	GAME_CSS,
	GAME_CSGO
};


GameType g_iGame;
float g_fDelay;


ArrayList hWeaponsIDArray, hWeaponEntityArray;
StringMap g_hWeaponInfoTrie;

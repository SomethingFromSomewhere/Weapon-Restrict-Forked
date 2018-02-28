//За последние правки в связи с обновлением SM до 1.9 ответственен > T1MOXA
			
enum {
	WeaponTypePistol,
	WeaponTypeSMG,
	WeaponTypeShotgun,
	WeaponTypeRifle,
	WeaponTypeSniper,
	WeaponTypeGrenade,
	WeaponTypeArmor,
	WeaponTypeMachineGun,
	WeaponTypeKnife,
	WeaponTypeOther,
	WeaponTypeShield,
	WeaponTypeNone,
	WeaponTypeTaser
};

enum {
	SlotInvalid = -1,
	SlotPrimmary = 0,
	SlotPistol = 1,
	SlotKnife = 2,
	SlotGrenade = 3,
	SlotC4 = 4,
	SlotNone = 5,
};

#define CT_TEAM 3
#define TERROR_TEAM 2
#define BOTH_TEAMS 1
#define INVALID_TEAM -1

#define InfoID 0
#define InfoSlot 1
#define InfoType 2
#define InfoTeam 3
#define InfoMax 4

#define MAXWEAPONGROUPS 7

#define MAX_WEAPONS 62

enum {
	WEAPON_NONE,
	WEAPON_P228,
	WEAPON_GLOCK,
	WEAPON_SCOUT,
	WEAPON_HEGRENADE,
	WEAPON_XM1014,
	WEAPON_C4,
	WEAPON_MAC10,
	WEAPON_AUG,
	WEAPON_SMOKEGRENADE,
	WEAPON_ELITE,
	WEAPON_FIVESEVEN,
	WEAPON_UMP45,
	WEAPON_SG550,
	WEAPON_GALIL,
	WEAPON_FAMAS,
	WEAPON_USP,
	WEAPON_AWP,
	WEAPON_MP5NAVY,
	WEAPON_M249,
	WEAPON_M3,
	WEAPON_M4A1,
	WEAPON_TMP,
	WEAPON_G3SG1,
	WEAPON_FLASHBANG,
	WEAPON_DEAGLE,
	WEAPON_SG552,
	WEAPON_AK47,
	WEAPON_KNIFE,
	WEAPON_P90,
	WEAPON_SHIELD,
	WEAPON_KEVLAR,
	WEAPON_ASSAULTSUIT,
	WEAPON_NIGHTVISION,
	WEAPON_GALILAR,
	WEAPON_BIZON,
	WEAPON_MAG7,
	WEAPON_NEGEV,
	WEAPON_SAWEDOFF,
	WEAPON_TEC9,
	WEAPON_TASER,
	WEAPON_HKP2000,
	WEAPON_MP7,
	WEAPON_MP9,
	WEAPON_NOVA,
	WEAPON_P250,
	WEAPON_SCAR20,
	WEAPON_SG556,
	WEAPON_SSG08,
	WEAPON_KNIFE_GG,
	WEAPON_MOLOTOV,
	WEAPON_DECOY,
	WEAPON_INCGRENADE,
	WEAPON_DEFUSER,
	WEAPON_HEAVYASSAULTSUIT,
	WEAPON_HEALTHSHOT = 57,
	WEAPON_KNIFE_T = 59,
	WEAPON_M4A1_SILENCER = 60,
	WEAPON_USP_SILENCER = 61,
	WEAPON_CZ75A = 63,
	WEAPON_REVOLVER = 64,
	WEAPON_TAGGRENADE = 68,
};


public const char weaponNames[][] = 
{ 
	"none", 			"p228",			"glock",			"scout",			"hegrenade",
	"xm1014",			"c4",			"mac10",			"aug",		
	"smokegrenade",		"elite",		"fiveseven",		"ump45",
	"sg550",			"galil",		"famas",			"usp",
	"awp",				"mp5navy",		"m249",				"m3",
	"m4a1",				"tmp",			"g3sg1",			"flashbang",
	"deagle",			"sg552",		"ak47",				"knife",			//тут тоже скорее всего накосячил 
	"p90",				"shield",		"kevlar",			"assaultsuit",		"nightvision", 		"galilar",
	"bizon",			"mag7",			"negev",			"sawedoff",
	"tec9",				"taser",		"hkp2000",			"mp7",
	"mp9",				"nova",			"p250",				"scar20", 
	"sg556",			"ssg08",		"knifegg",			"molotov",
	"decoy",			"incgrenade",	"defuser",			"heavyassaultsuit",
	"healthshot",		"knife_t",		"m4a1_silencer",
	"usp_silencer",		"cz75a",		"revolver",			"tagrenade"
};

public const int weaponGroups[] = 
{ 
	WeaponTypeNone, 			WeaponTypePistol,			WeaponTypePistol,			WeaponTypeSniper,			WeaponTypeGrenade,
	WeaponTypeShotgun,			WeaponTypeOther,			WeaponTypeSMG,				WeaponTypeRifle,		
	WeaponTypeGrenade,			WeaponTypePistol,			WeaponTypePistol,			WeaponTypeSMG,
	WeaponTypeSniper,			WeaponTypeRifle,			WeaponTypeRifle,			WeaponTypePistol,
	WeaponTypeSniper,			WeaponTypeSMG,				WeaponTypeMachineGun,		WeaponTypeShotgun,
	WeaponTypeRifle,			WeaponTypeSMG,				WeaponTypeSniper,			WeaponTypeGrenade,
	WeaponTypePistol,			WeaponTypeRifle,			WeaponTypeRifle,			WeaponTypeKnife,
	WeaponTypeSMG,				WeaponTypeArmor,			WeaponTypeArmor,			WeaponTypeArmor,			WeaponTypeOther,			WeaponTypeRifle,
	WeaponTypeSMG,				WeaponTypeShotgun,			WeaponTypeMachineGun,		WeaponTypeShotgun,
	WeaponTypePistol,			WeaponTypeTaser,			WeaponTypePistol,			WeaponTypeSMG,
	WeaponTypeSMG,				WeaponTypeShotgun,			WeaponTypePistol,			WeaponTypeSniper,
	WeaponTypeRifle,			WeaponTypeSniper,			WeaponTypeKnife,			WeaponTypeGrenade,
	WeaponTypeGrenade,			WeaponTypeGrenade,			WeaponTypeOther,			WeaponTypeArmor,
	WeaponTypeOther,			WeaponTypeKnife,			WeaponTypeRifle,
	WeaponTypePistol,			WeaponTypePistol,			WeaponTypePistol,			WeaponTypeGrenade
};

public const int weaponSlots[] =
{
	SlotNone, 		SlotPistol,		SlotPistol,		SlotPrimmary,	SlotGrenade,
	SlotPrimmary,	SlotC4,			SlotPrimmary,	SlotPrimmary,
	SlotGrenade,	SlotPistol,		SlotPistol,		SlotPrimmary,
	SlotPrimmary,	SlotPrimmary,	SlotPrimmary,	SlotPistol,
	SlotPrimmary,	SlotPrimmary,	SlotPrimmary,	SlotPrimmary,
	SlotPrimmary,	SlotPrimmary,	SlotPrimmary,	SlotGrenade,
	SlotPistol,		SlotPrimmary,	SlotPrimmary,	SlotKnife,
	SlotPrimmary,	SlotNone,		SlotNone,		SlotNone,		SlotNone,	 SlotPrimmary,
	SlotPrimmary,	SlotPrimmary,	SlotPrimmary,	SlotPrimmary,
	SlotPistol,		SlotKnife,		SlotPistol,		SlotPrimmary,
	SlotPrimmary,	SlotPrimmary,	SlotPistol,		SlotPrimmary,
	SlotPrimmary,	SlotPrimmary,	SlotKnife,		SlotGrenade,
	SlotGrenade,	SlotGrenade,	SlotNone,		SlotNone,
	SlotC4,			SlotKnife,		SlotPrimmary,
	SlotPistol,		SlotPistol,		SlotPistol,		SlotGrenade
};

public const int BuyTeams[] = 
{ 
	INVALID_TEAM, 	BOTH_TEAMS,		TERROR_TEAM,	BOTH_TEAMS,		BOTH_TEAMS,
	BOTH_TEAMS,		TERROR_TEAM,	TERROR_TEAM,	CT_TEAM,		
	BOTH_TEAMS,		TERROR_TEAM,	CT_TEAM,		BOTH_TEAMS,
	CT_TEAM,		TERROR_TEAM,	CT_TEAM,		CT_TEAM,
	BOTH_TEAMS,		BOTH_TEAMS,		BOTH_TEAMS,		BOTH_TEAMS,
	CT_TEAM,		CT_TEAM,		TERROR_TEAM,	BOTH_TEAMS,
	BOTH_TEAMS,		TERROR_TEAM,	TERROR_TEAM,	BOTH_TEAMS,
	BOTH_TEAMS,		BOTH_TEAMS,		BOTH_TEAMS,		BOTH_TEAMS,		BOTH_TEAMS,		TERROR_TEAM,
	BOTH_TEAMS,		CT_TEAM,		BOTH_TEAMS,		TERROR_TEAM,
	TERROR_TEAM,	BOTH_TEAMS,		CT_TEAM,		BOTH_TEAMS,
	CT_TEAM,		BOTH_TEAMS,		BOTH_TEAMS,		CT_TEAM,
	TERROR_TEAM,	BOTH_TEAMS,		BOTH_TEAMS,		TERROR_TEAM,
	BOTH_TEAMS,		CT_TEAM,		CT_TEAM,		BOTH_TEAMS,
	BOTH_TEAMS,		TERROR_TEAM,	CT_TEAM,
	CT_TEAM,		BOTH_TEAMS,		BOTH_TEAMS,		BOTH_TEAMS
};

public const int AllowedGame[] = 
{
	-1,		2,		1,		2,
	1,		1,		1,		1,
	1,		1,		1,		1,
	1,		2,		2,		1,
	2,		1,		2,		1,
	2,		1,		2,		1,
	1,		1,		2,		1,
	1,		1,		-1,		1,
	
	//тут мог напортачить
	1,		1,		1,		1,		3,		3,
	3,		3,		3,		3,
	3,		3,		3,		3,
	3,		3,		-1,		3,
	3,		3,		3,		3,
	
	//тут тоже мог напортачить
	3,		3,		3,		3,
	3,		3,		3,		3,		3
};

public const char g_WeaponGroupNames[][WEAPONARRAYSIZE] = {"pistols", "smgs", "shotguns", "rifles", "snipers", "grenades", "armor"};


bool g_bSpamProtectPrint[MAXPLAYERS+1],		g_bPerPlayerSpecs, 						g_bPerPlayerBots, 
	g_bPerPlayerRestrict, 					g_bAdminImmunity, 						g_bAllow,
	bIsFirstKey = true,						g_bLateLoaded, 							g_bImmunity[MAXPLAYERS+1],
	g_bOverideT[MAX_WEAPONS], 				g_bOverideCT[MAX_WEAPONS],				g_bWeaponKill,
	g_bStatus = true;
	

int 	g_iMenuAmount[MAXPLAYERS+1], 			g_iWeaponSlected[MAXPLAYERS+1], 			g_iGroupSelected[MAXPLAYERS+1], 
	g_bIsGroup[MAXPLAYERS+1], 				g_bIsUnrestrict[MAXPLAYERS+1],			CvarArrayHandleValCT[MAX_WEAPONS], 
	CvarArrayHandleValT[MAX_WEAPONS], 		g_iMaxMoney, 							g_iHeAmmo, 
	g_iFlashAmmo, 							g_iSmokeAmmo,							defaultValuesCT[MAX_WEAPONS], 
	defaultValuesT[MAX_WEAPONS],  			iLastVal = -1, 
	iLastIndex = 0, 						perPlayer[MAX_WEAPONS][MAXPLAYERS+1],	g_iMyWeaponsMax = 31, 
	HEGRENADE_AMMO = 11, 					FLASH_AMMO = 12, 						SMOKE_AMMO = 13, 
	INC_AMMO = 16, 							DECOY_AMMO = 17;
	
int currentID = WEAPON_NONE;
	
	
TopMenuObject g_hWR;
TopMenu	g_hAdminMenu;


ConVar 	g_hRestrictCVarsT[MAX_WEAPONS-4], 		g_hRestrictCVarsCT[MAX_WEAPONS-4];
Handle	hCanBuyForward, 						hCanPickupForward;


enum GameType {
	GAME_CSS,
	GAME_CSGO
};


GameType g_iGame;
float g_fDelay;


ArrayList hWeaponsIDArray, hWeaponEntityArray;
StringMap g_hWeaponInfoTrie;

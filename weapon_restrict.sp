#include <sdktools_functions>
#include <sdktools_entinput>
#include <weapon_restrict>
#include <sdkhooks>
#include <cstrike>


#pragma semicolon 1
#pragma newdecls required


#undef REQUIRE_PLUGIN
#include <adminmenu>


public const char ADMINCOMMANDTAG[] = " \x01[\x04SM\x01]\x04";	// Вынести в перевод

#include "weapon_restrict/defines.sp"
#include "weapon_restrict/weapons.sp"
#include "weapon_restrict/cvars.sp"
#include "weapon_restrict/adminmenu.sp"
#include "weapon_restrict/perplayer.sp"
#include "weapon_restrict/weapon-tracking.sp"
#include "weapon_restrict/events.sp"
#include "weapon_restrict/admincmds.sp"
#include "weapon_restrict/functions.sp"

public Plugin myinfo = 
{
	name 		= 		"Weapon Restrict [FORK]",
	author 		= 		"Someone & Dr!fter",
	version 	= 		"3.1.9 F",
	url 		= 		"http://hlmod.ru/"
};


public APLRes AskPluginLoad2(Handle myself, bool bLate, char[] error, int err_max)
{
	char gamedir[PLATFORM_MAX_PATH];
	GetGameFolderName(gamedir, sizeof(gamedir));
	
	if(strcmp(gamedir, "cstrike") == 0)	g_iGame = GAME_CSS;
	else if (strcmp(gamedir, "csgo") == 0)
	{
		HEGRENADE_AMMO = 13;
		FLASH_AMMO = 14;
		SMOKE_AMMO = 15;
		g_iMyWeaponsMax = 63;
		g_iGame = GAME_CSGO;
	}
	else
	{
		FormatEx(error, err_max, "[Weapon Resctrict] [ERROR] This plugin is only supported on CS:S or CS:GO.");
		return APLRes_Failure;
	}

	g_bLateLoaded = bLate;
	
	hCanBuyForward 			=	 	CreateGlobalForward("Restrict_OnCanBuyWeapon", 		ET_Single, 		Param_Cell, 	Param_Cell, 	Param_Cell, 	Param_CellByRef		);
	hCanPickupForward 		= 		CreateGlobalForward("Restrict_OnCanPickupWeapon", 	ET_Single, 		Param_Cell, 	Param_Cell, 	Param_Cell, 	Param_CellByRef		);
	CreateNative(										"Restrict_SetImmunity",			Native_SetImmunity																	);
	CreateNative(										"Restrict_SetStatus",			Native_SetStatus																	);
	
	RegPluginLibrary("weapon_restrict");
	
	return APLRes_Success;
}

public void OnPluginStart()
{	
	InitWeaponInfoTrie();
	RegisterAdminCommands();
	
	LoadTranslations("common.phrases");
	LoadTranslations("WeaponRestrict.phrases");
	
	AddCommandListener(OnJoinClass,					"joinclass"																							);
	HookEvent(										"round_start"			,			EventRoundStart,			EventHookMode_PostNoCopy			);
	
	CreateConVars();
	
	if(LibraryExists("adminmenu"))
	{
		TopMenu hTopMenu = 	GetAdminTopMenu();
		if(hTopMenu)		OnAdminMenuReady(hTopMenu);
    }
	RequestFrame(Load);
	
	RegConsoleCmd("sm_wp", CMD_TEST);
}

public Action CMD_TEST(int iClient, int iArgs)
{
	for(int i = 1; i < WEAPON_ID_MAX; ++i)	if(i != WEAPON_SHIELD)
	{
		PrintToServer("defaultValuesT  %i", defaultValuesT[i]);
		PrintToServer("defaultValuesCT %i", defaultValuesCT[i]);
	}
	return Plugin_Handled;
}

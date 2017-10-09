#include <sdktools_functions>
#include <sdktools_entinput>
#include <sdkhooks>
#include <cstrike>
#include <weapon_restrict>


#pragma semicolon 1
#pragma newdecls required


#undef REQUIRE_PLUGIN
#include <adminmenu>


#define ADMINCOMMANDTAG " \x01[\x04SM\x01]\x04"

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
	name = "Weapon Restrict [FORK]",
	author = "Someone & Dr!fter",
	version = "3.1.7F",
	url = "http://hlmod.ru/"
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
		TopMenu hTopMenu = GetAdminTopMenu();
		if(hTopMenu)	OnAdminMenuReady(hTopMenu);
    }
	RequestFrame(Load, true);
}

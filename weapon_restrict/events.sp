public Action OnJoinClass(int iClient, const char[] command, int args) 
{
	CheckPerPlayer();
	return Plugin_Continue;
}

public void OnClientPutInServer(int iClient)
{
	CheckPerPlayer();
	SDKHook(iClient, SDKHook_WeaponCanUse, OnWeaponCanUse);
}

public void OnClientDisconnect(int iClient)
{
	CheckPerPlayer();
}

public Action OnWeaponCanUse(int iClient, int iWeapon)
{
	if(!g_bStatus)	return Plugin_Continue;
	static int iTeam, iID;
	iTeam = GetClientTeam(iClient), iID = GetWeaponIDFromEnt(iWeapon);
	
	if(iID == WEAPON_NONE || Function_CanPickupWeapon(iClient, iTeam, iID) || !IsGoingToPickup(iClient, iID))	return Plugin_Continue;
	
	if(iID == WEAPON_C4 || iID == WEAPON_KNIFE || g_bWeaponKill)	AcceptEntityInput(iWeapon, "Kill");

	if(g_fDelay > 0.0 && !g_bSpamProtectPrint[iClient])
	{
		if(iTeam == CS_TEAM_CT)	PrintToChat(iClient, "%s %t %t", ADMINCOMMANDTAG, weaponNames[iID], "IsRestrictedPickupCT", 	Function_GetRestrictValue(iTeam, iID));
		else 					PrintToChat(iClient, "%s %t %t", ADMINCOMMANDTAG, weaponNames[iID], "IsRestrictedPickupT", 	Function_GetRestrictValue(iTeam, iID));
		g_bSpamProtectPrint[iClient] = true;
		CreateTimer(g_fDelay, ResetPrintDelay, iClient);
	}
	return Plugin_Handled;
}

public Action ResetPrintDelay(Handle hTimer, int iClient)
{
	g_bSpamProtectPrint[iClient] = false;
	return Plugin_Stop;
}

public void OnMapStart()
{
	g_bStatus = true;
	ClearOverride();
	CheckWeaponArrays();
	
	if(g_bLateLoaded)
	{
		for(int i = 1; i <= MaxClients; ++i)	if(IsClientInGame(i))
		{
			OnClientPutInServer(i);
		}
	}
}

public void OnConfigsExecuted()
{
	CheckConfig();
	
	RequestFrame(Load, false);
}

public void Load(bool bNothing)
{
	PerPlayerInit();
	CheckPerPlayer();
	g_bLateLoaded = false;
}

public void EventRoundStart(Event hEvent, const char[] name, bool bDontBroadcast)
{
	Function_CheckPlayerWeapons();
}

public Action CS_OnBuyCommand(int iClient, const char[] weapon)
{
	if(!g_bStatus) return Plugin_Continue;
	static int iTeam, iID;
	iTeam = GetClientTeam(iClient), iID = Function_GetWeaponIDExtended(weapon);
	
	if(iID == WEAPON_NONE || iID == WEAPON_C4 || iID == WEAPON_SHIELD)		return Plugin_Continue;

	if(BuyTeams[iID] != 0 && iTeam != BuyTeams[iID])						return Plugin_Continue;
	
	if(!Function_CanBuyWeapon(iClient, iTeam, iID))
	{
		if(iTeam == CS_TEAM_CT)	PrintToChat(iClient, "%s %t %t", ADMINCOMMANDTAG, weaponNames[iID], "IsRestrictedBuyCT", Function_GetRestrictValue(iTeam, iID));
		else					PrintToChat(iClient, "%s %t %t", ADMINCOMMANDTAG, weaponNames[iID], "IsRestrictedBuyT", Function_GetRestrictValue(iTeam, iID));
		return Plugin_Handled;
	}
	return Plugin_Continue;
}
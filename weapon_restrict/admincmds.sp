void RegisterAdminCommands()
{
	RegAdminCmd("sm_restrict", RestrictAdminCmd, ADMFLAG_CONVARS, "Restrict weapons");
	RegAdminCmd("sm_unrestrict", UnrestrictAdminCmd, ADMFLAG_CONVARS, "Unrestrict weapons");
	RegAdminCmd("sm_reload_restrictions", ReloadRestrict, ADMFLAG_CONVARS, "Reloads all restricted weapon cvars and removes any admin overrides");
	RegAdminCmd("sm_remove_restricted", RemoveRestricted, ADMFLAG_CONVARS, "Removes restricted weapons from players to the limit the weapons are set to.");
}

public Action RemoveRestricted(int iClient, int args)
{
	LogAction(iClient, -1, "\"%L\" removed all restricted weapons", iClient);
	ShowActivity2(iClient, ADMINCOMMANDTAG, "%t", "RemovedRestricted");
	Function_CheckPlayerWeapons();
	return Plugin_Handled;
}

bool HandleRestrictionCommand(int iClient, char[] weapon, int team = 0, int amount = -1, bool shouldbeall = false)
{
	if(strcmp(weapon, "@all", false) == 0 || strcmp(weapon, "@all", false) == 0)
	{
		for(int i = 1; i < WEAPON_ID_MAX; ++i)
		{
			Function_SetRestriction(i, CS_TEAM_CT, amount, true);
			Function_SetRestriction(i, CS_TEAM_T, amount, true);
		}
		
		if(amount != -1)
		{
			ShowActivity2(iClient, ADMINCOMMANDTAG, "%t", "RestrictedAll");
		}
		else	ShowActivity2(iClient, ADMINCOMMANDTAG, "%t", "UnrestrictedAll");
		return true;
	}
	else if(!shouldbeall)
	{
		int len = strlen(weapon), i;
		for(i = 0; i < len; ++i)
		{
			weapon[i] = CharToLower(weapon[i]);
		}
		int id = Function_GetWeaponIDExtended(weapon);
		int group = GetTypeGroup(weapon);
		if(id == WEAPON_NONE && group == WeaponTypeNone)
		{
			ReplyToCommand(iClient, "%t", "InvalidWeapon");
			return false;
		}
		if(amount != -1)
		{
			if(team == 3 || team == 0)
			{
				if(group == WeaponTypeNone && Function_SetRestriction(id, CS_TEAM_CT, amount, true))		ShowActivity2(iClient, ADMINCOMMANDTAG, "%t %t %t %t", "RestrictedCmd", weaponNames[id], "ToAmount", amount, "ForCT");
				else if(id == WEAPON_NONE && Function_SetGroupRestriction(group, CS_TEAM_CT, amount))	ShowActivity2(iClient, ADMINCOMMANDTAG, "%t %t %t %t", "RestrictedCmd", g_WeaponGroupNames[group], "ToAmount", amount, "ForCT");
			}
			if(team == 2 || team == 0)
			{
				if(group == WeaponTypeNone && Function_SetRestriction(id, CS_TEAM_T, amount, true))		ShowActivity2(iClient, ADMINCOMMANDTAG, "%t %t %t %t", "RestrictedCmd", weaponNames[id], "ToAmount", amount, "ForT");
				else if(id == WEAPON_NONE && Function_SetGroupRestriction(group, CS_TEAM_T, amount))		ShowActivity2(iClient, ADMINCOMMANDTAG, "%t %t %t %t", "RestrictedCmd", g_WeaponGroupNames[group], "ToAmount", amount, "ForT");
			}
		}
		else
		{
			if(team == 3 || team == 0)
			{
				if(group == WeaponTypeNone && Function_SetRestriction(id, CS_TEAM_CT, amount, true))		ShowActivity2(iClient, ADMINCOMMANDTAG, "%t %t %t", "UnrestrictedCmd", weaponNames[id], "ForCT");
				else if(id == WEAPON_NONE && Function_SetGroupRestriction(group, CS_TEAM_CT, amount))	ShowActivity2(iClient, ADMINCOMMANDTAG, "%t %t %t", "UnrestrictedCmd", g_WeaponGroupNames[group], "ForCT");
			}
			if(team == 2 || team == 0)
			{
				if(group == WeaponTypeNone && Function_SetRestriction(id, CS_TEAM_T, amount, true))			ShowActivity2(iClient, ADMINCOMMANDTAG, "%t %t %t", "UnrestrictedCmd", weaponNames[id], "ForT");
				else if(id == WEAPON_NONE && Function_SetGroupRestriction(group, CS_TEAM_T, amount))	ShowActivity2(iClient, ADMINCOMMANDTAG, "%t %t %t", "UnrestrictedCmd", g_WeaponGroupNames[group], "ForT");
			}
		}
		return true;
	}
	return false;
}

public Action RestrictAdminCmd(int iClient, int args)
{
	if(args < 1)
	{
		ReplyToCommand(iClient, "%s %t", ADMINCOMMANDTAG, "RestrictReply");
		return Plugin_Handled;
	}
	
	char weapon[100];
	GetCmdArg(1, weapon, sizeof(weapon));
	if(args == 1 && !HandleRestrictionCommand(iClient, weapon, _, 0, true))
	{
		ReplyToCommand(iClient, "%s %t", ADMINCOMMANDTAG, "RestrictReply");
		return Plugin_Handled;
	}
	int amount;
	if(args >= 2)
	{
		char amountString[5];
		GetCmdArg(2, amountString, sizeof(amountString));
		amount = StringToInt(amountString);
		if((amount == 0 && strcmp(amountString, "0") != 0) || amount < -1)
		{
			ReplyToCommand(iClient, "%s %t", ADMINCOMMANDTAG, "InvalidAmount");
			return Plugin_Handled;
		}
	}
	int teams;
	if(args == 3)
	{
		char team[8];
		GetCmdArg(3, team, sizeof(team));
		if(strcmp(team, "both", false) == 0)		teams = 0;
		else if(strcmp(team, "ct", false) == 0)	teams = CS_TEAM_CT;
		else if(strcmp(team, "t", false) == 0)	teams = CS_TEAM_T;
		else
		{
			ReplyToCommand(iClient, "%s %t", ADMINCOMMANDTAG, "InvalidTeam");
			return Plugin_Handled;
		}
	}
	HandleRestrictionCommand(iClient, weapon, teams, amount, false);
	return Plugin_Handled;
}
public Action UnrestrictAdminCmd(int iClient, int args)
{
	if(args < 1)
	{
		ReplyToCommand(iClient, "%s %t", ADMINCOMMANDTAG, "UnrestrictReply");
		return Plugin_Handled;
	}
	char weapon[32];
	GetCmdArg(1, weapon, sizeof(weapon));
	if(args == 1)
	{
		if(!HandleRestrictionCommand(iClient, weapon, _, _, true) && !HandleRestrictionCommand(iClient, weapon))	ReplyToCommand(iClient, "%s %t", ADMINCOMMANDTAG, "UnrestrictReply");
		return Plugin_Handled;
	}
	int teams;
	if(args == 2)
	{
		char team[8];
		GetCmdArg(2, team, sizeof(team));
		if(strcmp(team, "both", false) == 0)		teams = 0;
		else if(strcmp(team, "ct", false) == 0)	teams = CS_TEAM_CT;
		else if(strcmp(team, "t", false) == 0)	teams = CS_TEAM_T;
		else
		{
			ReplyToCommand(iClient, "%s %t", ADMINCOMMANDTAG, "InvalidTeam");
			return Plugin_Handled;
		}
	}
	HandleRestrictionCommand(iClient, weapon, teams, _, false);
	return Plugin_Handled;
}

public Action ReloadRestrict(int iClient, int args)
{
	ClearOverride();
	ShowActivity2(iClient, ADMINCOMMANDTAG, "%t", "ReloadedRestricitions");
	LogAction(iClient, -1, "\"%L\" reloaded the restrictions.", iClient);
	CheckConfig();
	
	RequestFrame(Load);
	
	return Plugin_Handled;
}
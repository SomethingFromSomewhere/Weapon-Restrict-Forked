public void OnAdminMenuReady(Handle aTopMenu)
{
	TopMenu hTopMenu = TopMenu.FromHandle(aTopMenu);
	if (hTopMenu == g_hAdminMenu)	return;
	g_hAdminMenu = hTopMenu;

	g_hWR = g_hAdminMenu.AddCategory("restrict", Handle_Category, "sm_restrict", ADMFLAG_CONVARS, "Restrict");
	
	if (g_hWR != INVALID_TOPMENUOBJECT)
    {
		g_hAdminMenu.AddItem("sm_restrict", AdminMenu_Restrict, g_hWR, "sm_restrict", ADMFLAG_CONVARS);
		g_hAdminMenu.AddItem("sm_unrestrict", AdminMenu_Unrestrict, g_hWR, "sm_unrestrict", ADMFLAG_CONVARS);
	}
}

public void Handle_Category(TopMenu hMenu, TopMenuAction action, TopMenuObject object_id, int iClient, char[] sBuffer, int maxlength)
{
	switch(action)
	{
		case TopMenuAction_DisplayTitle:	FormatEx(sBuffer, maxlength, "%T", "RestrictMenuMainTitle", iClient);
		case TopMenuAction_DisplayOption:	FormatEx(sBuffer, maxlength, "%T", "RestrictMenuMainOption", iClient);
	}
}

public void AdminMenu_Restrict(TopMenu hMenu, TopMenuAction action, TopMenuObject object_id, int iClient, char[] sBuffer, int maxlength)
{
	switch(action)
	{
		case TopMenuAction_DisplayOption: FormatEx(sBuffer, maxlength, "%T", "RestrictWeaponsOption", iClient);
		case TopMenuAction_SelectOption:
		{
			g_bIsUnrestrict[iClient] = false;
			DisplayTypeMenu(iClient);
		}
	}
}

public void AdminMenu_Unrestrict(TopMenu hMenu, TopMenuAction action, TopMenuObject object_id, int iClient, char[] sBuffer, int maxlength)
{
	switch(action)
	{
		case TopMenuAction_DisplayOption:	FormatEx(sBuffer, maxlength, "%T", "UnrestrictWeaponsOption", iClient);
		case TopMenuAction_SelectOption:
		{
			g_bIsUnrestrict[iClient] = true;
			g_iMenuAmount[iClient] = -1;
			DisplayTypeMenu(iClient);
		}
	}
}

void DisplayTypeMenu(int iClient)
{
	Menu hMenu = new Menu(Handle_TypeMenu);
	char sItem[64];

	SetGlobalTransTarget(iClient);
	
	hMenu.SetTitle("%t", "RestrictionTypeMenuTitle");
	hMenu.ExitBackButton = true;
	
	FormatEx(sItem, sizeof(sItem), "%t", "TypeWeaponRestrict");
	hMenu.AddItem("", sItem);
	FormatEx(sItem, sizeof(sItem), "%t", "TypeGroupRestrict");
	hMenu.AddItem("", sItem);
	
	hMenu.Display(iClient, MENU_TIME_FOREVER);
}

public int Handle_TypeMenu(Menu hMenu, MenuAction action, int iClient, int iItem)
{
	switch(action)
	{
		case MenuAction_End:	delete hMenu;
		case MenuAction_Cancel:
		{
			if(iItem == MenuCancel_ExitBack && g_hAdminMenu)	g_hAdminMenu.DisplayCategory(g_hWR, iClient);
		}
		case MenuAction_Select:
		{
			g_bIsGroup[iClient] = iItem;
			DisplayRestrictMenu(iClient);
		}
	}
}

void DisplayRestrictMenu(int iClient)
{
	Menu hMenu = new Menu(Handle_WeaponMenu, MenuAction_End|MenuAction_Cancel|MenuAction_Select);

	SetGlobalTransTarget(iClient);
	
	hMenu.SetTitle("%t", g_bIsUnrestrict[iClient] ? "UnrestrictMenuTitle":"RestrictionTypeMenuTitle");
	hMenu.ExitBackButton = true;

	if(g_bIsGroup[iClient])	AddGroupsToMenu(hMenu);
	else					AddWeaponsToMenu(hMenu);
	
	hMenu.Display(iClient, MENU_TIME_FOREVER);
}

public int Handle_WeaponMenu(Menu hMenu, MenuAction action, int iClient, int iItem)
{
	switch(action)
	{
		case MenuAction_End:	delete hMenu;
		case MenuAction_Cancel:	if(iItem == MenuCancel_ExitBack)
		{
			DisplayTypeMenu(iClient);
		}
		case MenuAction_Select:
		{
			char weapon[WEAPONARRAYSIZE];
			hMenu.GetItem(iItem, weapon, sizeof(weapon));
			if(g_bIsGroup[iClient])	g_iGroupSelected[iClient] = GetTypeGroup(weapon);
			else	g_iWeaponSlected[iClient] = GetWeaponID(weapon);
		
			if(g_bIsGroup[iClient] && g_bIsUnrestrict[iClient])
			{
				DisplayTeamMenu(iClient);
			}
			else if(!g_bIsUnrestrict[iClient])
			{
				DisplayAmountMenu(iClient);
			}
			else
			{
				switch(g_iWeaponSlected[iClient])
				{
					case WEAPON_C4:	HandleMenuRestriction(iClient, WEAPON_C4, -1, CS_TEAM_T);
					case WEAPON_DEFUSER:	HandleMenuRestriction(iClient, WEAPON_DEFUSER, -1, CS_TEAM_CT);
					default:	DisplayTeamMenu(iClient);
				}
			}
		}
	}
}

void DisplayTeamMenu(int iClient)
{
	Menu hMenu = new Menu(Handle_TeamMenu, MenuAction_End|MenuAction_Cancel|MenuAction_Select);
	char sItem[64];
	
	SetGlobalTransTarget(iClient);
	
	hMenu.SetTitle("%t", "SelectTeamMenuTitle");
	hMenu.ExitBackButton = true;

	FormatEx(sItem, sizeof(sItem), "%t", "CounterTerrorists");
	hMenu.AddItem("3", sItem);
	
	FormatEx(sItem, sizeof(sItem), "%t", "Terrorists");
	hMenu.AddItem("2", sItem);
	
	FormatEx(sItem, sizeof(sItem), "%t", "Allteams");
	hMenu.AddItem("0", sItem);
	
	hMenu.Display(iClient, MENU_TIME_FOREVER);
}

public int Handle_TeamMenu(Menu hMenu, MenuAction action, int iClient, int iItem)
{
	switch(action)
	{
		case MenuAction_End:	delete hMenu;
		case MenuAction_Cancel:	if(iItem == MenuCancel_ExitBack)
		{
			if(!g_bIsUnrestrict[iClient])	DisplayAmountMenu(iClient);
			else							DisplayRestrictMenu(iClient);
		}
		case MenuAction_Select:
		{
			char sTeam[4];
			hMenu.GetItem(iItem, sTeam, sizeof(sTeam));
			if(!g_bIsGroup[iClient])		HandleMenuRestriction(iClient, g_iWeaponSlected[iClient], g_iMenuAmount[iClient], StringToInt(sTeam));
			else						HandleMenuGroupRestriction(iClient, g_iGroupSelected[iClient], g_iMenuAmount[iClient], StringToInt(sTeam));
		}
	}
}

void DisplayAmountMenu(int iClient)
{
	Menu hMenu = new Menu(Handle_AmountMenu, MenuAction_End|MenuAction_Cancel|MenuAction_Select);

	hMenu.SetTitle("%T", "AmountMenuTitle", iClient);
	hMenu.ExitBackButton = true;


	char num[4];
	for(int i = 0; i <= MaxClients; ++i)
	{
		FormatEx(num, sizeof(num), "%i", i);
		hMenu.AddItem(num, num);
	}
	
	hMenu.Display(iClient, MENU_TIME_FOREVER);
}

public int Handle_AmountMenu(Menu hMenu, MenuAction action, int iClient, int iItem)
{
	switch(action)
	{
		case MenuAction_End:	delete hMenu;
		case MenuAction_Cancel:	if(iItem == MenuCancel_ExitBack)
		{
			DisplayRestrictMenu(iClient);
		}
		case MenuAction_Select:
		{
			char sAmount[4];
			hMenu.GetItem(iItem, sAmount, sizeof(sAmount));
			g_iMenuAmount[iClient] = StringToInt(sAmount);
			switch(g_iWeaponSlected[iClient])
			{
				case WEAPON_C4:	HandleMenuRestriction(iClient, WEAPON_C4, g_iMenuAmount[iClient], CS_TEAM_T);
				case WEAPON_DEFUSER:	HandleMenuRestriction(iClient, WEAPON_DEFUSER, g_iMenuAmount[iClient], CS_TEAM_CT);
				default:	DisplayTeamMenu(iClient);
			}
		}
	}
}

void HandleMenuRestriction(int iClient, int id, int amount, int team)
{
	if(amount != -1)
	{
		if(team == 3 || team == 0)
		{
			Function_SetRestriction(id, CS_TEAM_CT, amount, true);
			ShowActivity2(iClient, ADMINCOMMANDTAG, "%t %t %t %t", "RestrictedCmd", weaponNames[id], "ToAmount", amount, "ForCT");
		}
		if(team == 2 || team == 0)
		{
			Function_SetRestriction(id, CS_TEAM_T, amount, true);
			ShowActivity2(iClient, ADMINCOMMANDTAG, "%t %t %t %t", "RestrictedCmd", weaponNames[id], "ToAmount", amount, "ForT");
		}
	}
	else
	{
		if(team == 3 || team == 0)
		{
			Function_SetRestriction(id, CS_TEAM_CT, amount, true);
			ShowActivity2(iClient, ADMINCOMMANDTAG, "%t %t %t", "UnrestrictedCmd", weaponNames[id], "ForCT");
		}
		if(team == 2 || team == 0)
		{
			Function_SetRestriction(id, CS_TEAM_T, amount, true);
			ShowActivity2(iClient, ADMINCOMMANDTAG, "%t %t %t", "UnrestrictedCmd", weaponNames[id], "ForT");
		}
	}
}

void HandleMenuGroupRestriction(int iClient, int group, int amount, int team)
{
	if(group == WeaponTypeNone)
	{
		for(int i = 1; i < WEAPON_ID_MAX; ++i)
		{
			Function_SetRestriction(i, CS_TEAM_CT, amount, true);
			Function_SetRestriction(i, CS_TEAM_T, amount, true);
		}
		if(amount != -1)	ShowActivity2(iClient, ADMINCOMMANDTAG, "%t", "RestrictedAll");
		else	ShowActivity2(iClient, ADMINCOMMANDTAG, "%t", "UnrestrictedAll");
		return;
	}
	if(amount != -1)
	{
		if(team == 3 || team == 0)
		{
			Function_SetGroupRestriction(group, CS_TEAM_CT, amount);
			ShowActivity2(iClient, ADMINCOMMANDTAG, "%t %t %t %t", "RestrictedCmd", g_WeaponGroupNames[group], "ToAmount", amount, "ForCT");
		}
		if(team == 2 || team == 0)
		{
			Function_SetGroupRestriction(group, CS_TEAM_T, amount);
			ShowActivity2(iClient, ADMINCOMMANDTAG, "%t %t %t %t", "RestrictedCmd", g_WeaponGroupNames[group], "ToAmount", amount, "ForT");
		}
	}
	else
	{
		if(team == 3 || team == 0)
		{
			Function_SetGroupRestriction(group, CS_TEAM_CT, amount);
			ShowActivity2(iClient, ADMINCOMMANDTAG, "%t %t %t", "UnrestrictedCmd", g_WeaponGroupNames[group], "ForCT");
		}
		if(team == 2 || team == 0)
		{
			Function_SetGroupRestriction(group, CS_TEAM_T, amount);
			ShowActivity2(iClient, ADMINCOMMANDTAG, "%t %t %t", "UnrestrictedCmd", g_WeaponGroupNames[group], "ForT");
		}
	}
}

void AddGroupsToMenu(Menu hMenu)
{
	char weaponArray[MAXWEAPONGROUPS][WEAPONARRAYSIZE], weapon[WEAPONARRAYSIZE];
	int size, i;
	
	for(i = 0; i < MAXWEAPONGROUPS; ++i)
	{
		FormatEx(weaponArray[size], WEAPONARRAYSIZE, "%s", g_WeaponGroupNames[i]);
		++size;
	}
	
	SortStrings(weaponArray, size-1, Sort_Ascending);
	
	FormatEx(weapon, sizeof(weapon), "%t", "AllWeapons");
	hMenu.AddItem("all", weapon);
	
	for(i = 0; i < size-1; ++i)
	{
		FormatEx(weapon, sizeof(weapon), "%t", weaponArray[i]); 
		hMenu.AddItem(weaponArray[i], weapon);
	}
}

void AddWeaponsToMenu(Menu hMenu)
{
	char weaponArray[WEAPON_ID_MAX][WEAPONARRAYSIZE], weapon[WEAPONARRAYSIZE];
	int size, i;
	
	for(i = 1; i < WEAPON_ID_MAX; ++i)	if(i != WEAPON_SHIELD)
	{
		if(g_iGame == GAME_CSGO && (i == WEAPON_GALIL || i == WEAPON_M3 || i == WEAPON_MP5NAVY || i == WEAPON_P228 || i == WEAPON_SCAR17 || i == WEAPON_SCOUT || i == WEAPON_SG550 || i == WEAPON_SG552 || i == WEAPON_TMP)) continue;
		if(g_iGame == GAME_CSS && (i == WEAPON_GALILAR || i == WEAPON_HKP2000 || i == WEAPON_MAG7 || i == WEAPON_MP9 || i == WEAPON_NEGEV || i == WEAPON_NOVA || i == WEAPON_P250 || i == WEAPON_SAWEDOFF || i == WEAPON_SCAR17 || i == WEAPON_SCAR20 || i == WEAPON_DECOY || i == WEAPON_INCGRENADE || i == WEAPON_MOLOTOV || i == WEAPON_KNIFE_GG || i == WEAPON_SSG08 || i == WEAPON_TASER || i == WEAPON_TEC9)) continue;
		FormatEx(weaponArray[size], WEAPONARRAYSIZE, "%s", weaponNames[i]);
		++size;
	}
	
	SortStrings(weaponArray, size-1, Sort_Ascending);

	for(i = 0; i < size-1; ++i)
	{
		FormatEx(weapon, sizeof(weapon), "[CT:%d][T:%d] %t", Function_GetRestrictValue(CS_TEAM_CT, GetWeaponID(weaponArray[i])), Function_GetRestrictValue(CS_TEAM_T, GetWeaponID(weaponArray[i])), weaponArray[i]); 
		hMenu.AddItem(weaponArray[i], weapon);
	}
}
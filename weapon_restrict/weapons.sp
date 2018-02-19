void InitWeaponInfoTrie()
{
	g_hWeaponInfoTrie = new StringMap();
	int info[InfoMax];
	for(int i; i < MAX_WEAPONS; ++i)
	{
		info[InfoID] = i;
		info[InfoSlot] = weaponSlots[i];
		info[InfoType] = weaponGroups[i];
		
		if(i == WEAPON_ELITE && g_iGame == GAME_CSGO)
		{
			info[InfoTeam] = BOTH_TEAMS;//CSGO elites are for both teams.
		}
		else info[InfoTeam] = BuyTeams[i];
		
		g_hWeaponInfoTrie.SetArray(weaponNames[i], info/*[0]*/, InfoMax);
	}
}

int GetWeaponID(const char[] sWeapon)
{
	int info[InfoMax];
	if(GetWeaponInfo(sWeapon, info)) return info[InfoID];
	return WEAPON_NONE;
}

int GetWeaponPrice(int client, int id)
{	
	if(id > WEAPON_DEFUSER || id <= WEAPON_NONE) return 0;
	if(id == WEAPON_DEFUSER && g_iGame != GAME_CSGO) return 200;//Only assume on CSS
	
	return CS_GetWeaponPrice(client, view_as<CSWeaponID>(id));
}

bool GetWeaponInfo(const char[] weapon, int info[InfoMax])
{
	char CheckWeapon[32];
	FormatEx(CheckWeapon, 32, "%s", weapon);
	
	/*
	FormatEx(CheckWeapon, sizeof(CheckWeapon), "%s", weapon);
	int len = strlen(weapon), i;
	
	for(i = 0; i < len; ++i)
	{
		CheckWeapon[i] = CharToLower(weapon[i]);
	}
	*/
	ReplaceString(CheckWeapon, sizeof(CheckWeapon), "weapon_", "", false);
	ReplaceString(CheckWeapon, sizeof(CheckWeapon), "item_", "", false);
	
	return g_hWeaponInfoTrie.GetArray(CheckWeapon, info/*[InfoID]*/, InfoMax);
}
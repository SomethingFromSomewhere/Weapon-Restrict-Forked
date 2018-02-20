void PerPlayerInit()
{
	int i, x;
	for(i = 0; i < WEAPON_ID_MAX; ++i)
	{
		for(x = 0; x <= MAXPLAYERS; ++x)
		{
			perPlayer[i][x] = -2;
		}
	}
	for(i = 1; i < WEAPON_ID_MAX; ++i)	if(i != WEAPON_SHIELD)
	{
		if(i != WEAPON_DEFUSER)
		{
			defaultValuesT[i] = Function_GetRestrictValue(CS_TEAM_T, i);
		}
		
		if(i != WEAPON_C4)
		{
			defaultValuesCT[i] = Function_GetRestrictValue(CS_TEAM_CT, i);
		}
	}
	
	char file[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, file, sizeof(file), "configs/restrict/perplayerrestrict.txt");
	if(!FileExists(file))
	{
		LogError("[Weapon Restrict] [ERROR] Failed to locate perplayer.txt");
		return;
	}
	
	SMCParser parser = new SMCParser();
	int line, col;

	
	parser.OnEnterSection = Perplayer_NewSection;
	parser.OnKeyValue = Perplayer_KeyValue;
	parser.OnLeaveSection = Perplayer_EndSection;

	SMCError error = parser.ParseFile(file, line, col);
	if (error != SMCError_Okay)
	{
		char buffer[64];
		if (parser.GetErrorString(error, buffer, sizeof(buffer)))
		{
			LogError("[Weapon Restrict] [ERROR] Perplayer parser error on line %i col %i. Error: %s.", line, col, buffer);
		} 
		else	LogError("[Weapon Restrict] [ERROR] Fatal perplayer parse error.");
		return;
	}
	
	delete  parser;
}

public SMCResult Perplayer_NewSection(SMCParser smc, const char[] name, bool opt_quotes)
{
	if(strcmp(name, "PerPlayer", false) == 0)	return SMCParse_Continue;
	
	int id = Function_GetWeaponIDExtended(name);
	if(IsValidWeaponID(id))
	{
		currentID = id;
		bIsFirstKey = true;
		iLastIndex = 0;
	}
	else
	{
		LogError("[Weapon Restrict] [ERROR] Invalid section name found in perplayer.txt");
		return SMCParse_HaltFail;
	}
	return SMCParse_Continue;
}

public SMCResult Perplayer_KeyValue(SMCParser smc, const char[] key, const char[] value, bool key_quotes, bool value_quotes)
{
	if(bIsFirstKey)
	{
		if(strcmp(key, "default", false) == 0)
		{
			bIsFirstKey = false;
			iLastVal = StringToInt(value);
			if(iLastVal < -1)	iLastVal = -1;
		}
		else	return SMCParse_HaltFail;
	}
	else
	{
		int index = StringToInt(key), i;
		
		if(index > MAXPLAYERS)	index = MAXPLAYERS;
		
		for(i = iLastIndex; i < index; ++i)
		{
			perPlayer[currentID][i] = iLastVal;
		}
		
		iLastIndex = index;
		iLastVal = StringToInt(value);
		
		if(iLastVal < -1)	iLastVal = -1;
	}
	return SMCParse_Continue;
}

public SMCResult Perplayer_EndSection(SMCParser smc)
{
	for(int i = iLastIndex; i <= MAXPLAYERS; ++i)
	{
		perPlayer[currentID][i] = iLastVal;
	}
	currentID = WEAPON_NONE;
	return SMCParse_Continue;
}

void CheckPerPlayer()
{
	int i;
	if(g_bPerPlayerRestrict)
	{
		int count = GetPlayerCount();
		for(i = 1; i < WEAPON_ID_MAX; ++i)	if(i != WEAPON_SHIELD)
		{	
			if(i != WEAPON_DEFUSER && perPlayer[i][0] != -2 && Function_GetRestrictValue(CS_TEAM_T, i) != perPlayer[i][count] && !Function_IsWeaponInOverride(CS_TEAM_T, i))	Function_SetRestriction(i, CS_TEAM_T, perPlayer[i][count], false);
			if(i != WEAPON_C4 && perPlayer[i][0] != -2 && Function_GetRestrictValue(CS_TEAM_CT, i) != perPlayer[i][count] && !Function_IsWeaponInOverride(CS_TEAM_CT, i))	Function_SetRestriction(i, CS_TEAM_CT, perPlayer[i][count], false);
		}
	}
	else
	{
		for(i = 1; i < WEAPON_ID_MAX; ++i)	if(i != WEAPON_SHIELD)
		{
			if(i != WEAPON_DEFUSER 	&& 	Function_GetRestrictValue(CS_TEAM_T, 	i) 	!= defaultValuesT[i] 	&& 	!Function_IsWeaponInOverride(CS_TEAM_T, 	i))	Function_SetRestriction(i, CS_TEAM_T, 	defaultValuesT[i], 	false);
			if(i != WEAPON_C4 		&& 	Function_GetRestrictValue(CS_TEAM_CT, 	i) 	!= defaultValuesCT[i] 	&& 	!Function_IsWeaponInOverride(CS_TEAM_CT, i))	Function_SetRestriction(i, CS_TEAM_CT, 	defaultValuesCT[i], 	false);
		}
	}
}

int GetPlayerCount()
{
	int count, iTeam, i;
	for(i = 1; i <= MaxClients; ++i)	if(IsClientInGame(i))
	{
		iTeam = GetClientTeam(i);
		if((!g_bPerPlayerBots && !IsFakeClient(i)) || (!g_bPerPlayerSpecs && (iTeam == CS_TEAM_NONE || iTeam == CS_TEAM_SPECTATOR)))	continue;
		++count;
	}
	return count;
}
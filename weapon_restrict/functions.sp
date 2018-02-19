int GetTypeGroup(const char[] sWeapon)
{
	for(int i = 0; i < MAXWEAPONGROUPS; ++i)	if(strcmp(sWeapon, g_WeaponGroupNames[i]) == 0)
	{
		return i;
	}
	return WeaponTypeNone;
}

void CheckConfig()
{
	char file[PLATFORM_MAX_PATH], szMap[32], pref[6];
	
	GetCurrentMap(szMap, sizeof(szMap));
	
	if (strncmp(szMap, "workshop", 8) == 0) 	 strcopy(szMap, sizeof(szMap), szMap[8 + StrContains(szMap[9], szMap[8] == '/' ? "/" : "\\")]);
	BuildPath(Path_SM, file, sizeof(file), "configs/restrict/%s.cfg", szMap);
	
	if(!RunFile(file))
	{
		SplitString(szMap, "_", pref, sizeof(pref));
		BuildPath(Path_SM, file, sizeof(file), "configs/restrict/%s_.cfg", pref);
		RunFile(file);
	}
}

bool RunFile(const char[] sFile)
{
	if(!FileExists(sFile))	return false;

	File FileHandle = OpenFile(sFile, "r");
	char Command[64];
	while(!IsEndOfFile(FileHandle))
	{
		ReadFileLine(FileHandle, Command, sizeof(Command));
		TrimString(Command);
		if(strncmp(Command, "//", 2) != 0 && strlen(Command) != 0)	ServerCommand("%s", Command);
	}
	delete FileHandle;
	return true;
}

bool IsGoingToPickup(int iClient, int iID)
{
	int slot = weaponSlots[iID];
	
	if(IsValidWeaponSlot(slot))
	{
		switch(slot)
		{
			case SlotGrenade:
			{
				int count = Function_GetGrenadeCount(iClient, iID);
				if(g_iGame != GAME_CSS)
				{
					if(((iID == WEAPON_HEGRENADE || iID == WEAPON_SMOKEGRENADE) && count == 0) || (iID == WEAPON_FLASHBANG && count < 2))	return true;
				}
				else
				{
					if((iID == WEAPON_HEGRENADE && count < g_iHeAmmo) || (iID == WEAPON_SMOKEGRENADE && count < g_iSmokeAmmo) || (iID == WEAPON_FLASHBANG && count < g_iSmokeAmmo))	return true;
				}
			}
			default: if(GetPlayerWeaponSlot(iClient, slot) == -1)
			{
				return true;
			}
		}
	}
	return false;
}

void ClearOverride()
{
	for(int i = 1; i < MAX_WEAPONS; ++i)
	{
		g_bOverideT[i] = false;
		g_bOverideCT[i] = false;
	}
}

int GetMaxGrenades()
{
	if(g_iGame == GAME_CSS)
	{
		return (g_iHeAmmo > g_iFlashAmmo) ? ((g_iHeAmmo > g_iSmokeAmmo) ? g_iHeAmmo:g_iSmokeAmmo):((g_iFlashAmmo > g_iSmokeAmmo) ? g_iFlashAmmo:g_iSmokeAmmo);
	}
	return 2;
}

bool IsValidWeaponID(int iID)
{
	if(iID <= WEAPON_NONE || iID >= MAX_WEAPONS)	return false;
	return true;
}

bool IsValidWeaponSlot(int slot)
{
	if(slot < SlotPrimmary || slot > SlotC4)	return false;
	return true;
}

void Function_RefundMoney(int iClient, int iID)
{
	int iAmount = GetWeaponPrice(iClient, iID), iAccount = GetEntProp(iClient, Prop_Send, "m_iAccount");
	
	iAccount += iAmount;
	if(iAccount < g_iMaxMoney)	SetEntProp(iClient, Prop_Send, "m_iAccount", iAccount);
	else						SetEntProp(iClient, Prop_Send, "m_iAccount", g_iMaxMoney);

	PrintToChat(iClient, "%s %t %t", ADMINCOMMANDTAG, "Refunded", iAmount,  weaponNames[iID]);
}

bool Function_GetImmunity(int iClient)
{
	return (g_bAdminImmunity && CheckCommandAccess(iClient, "sm_restrict_immunity_level", ADMFLAG_RESERVATION)) || g_bImmunity[iClient];
}

void Function_RemoveRandom(int count, int iTeam, int iID)
{
	int[] weaponArray = new int[MAXPLAYERS*GetMaxGrenades()];
	int index, i, gcount, ent, x, z, iClient, slot = weaponSlots[iID];
	
	for(i = 1; i <= MaxClients; ++i)	if(IsClientInGame(i) && !Function_GetImmunity(i) && GetClientTeam(i) == iTeam)
	{
		if(slot == SlotGrenade || iID == WEAPON_TASER || iID == WEAPON_KNIFE || iID == WEAPON_KNIFE_GG)
		{
			if(iID == WEAPON_TASER || iID == WEAPON_KNIFE || iID == WEAPON_KNIFE_GG)		gcount = 1;
			else																		gcount = Function_GetGrenadeCount(i, iID);
			
			for(x = 0; x <= g_iMyWeaponsMax; x++)
			{
				ent = GetEntPropEnt(i, Prop_Send, "m_hMyWeapons", x);
				if(ent != -1 && ent && IsValidEdict(ent) && GetWeaponIDFromEnt(ent) == iID)
				{
					for(z = 1; z <= gcount; ++z)
					{
						weaponArray[index] = ent;
						++index;
					}
				}
			}
		}
		else if(slot == SlotNone)
		{
			if(Function_HasSpecialItem(i, iID))
			{
				weaponArray[index] = i;
				++index;
			}
		}
		else
		{
			ent = GetPlayerWeaponSlot(i, slot);
			if(ent != -1 && GetWeaponIDFromEnt(ent) == iID)
			{
				weaponArray[index] = ent;
				++index;
			}
		}
	}
	SortIntegers(weaponArray, index-1, Sort_Random);
	
	if(slot == SlotGrenade)
	{
		int ammoindex = -1;
		switch(iID)
		{
			case WEAPON_HEGRENADE:
			{
				ammoindex = HEGRENADE_AMMO;
			}
			case WEAPON_FLASHBANG:
			{
				ammoindex = FLASH_AMMO;
			}
			case WEAPON_SMOKEGRENADE:
			{
				ammoindex = SMOKE_AMMO;
			}
			case WEAPON_INCGRENADE, WEAPON_MOLOTOV:
			{
				ammoindex = INC_AMMO;
			}
			case WEAPON_DECOY:
			{
				ammoindex = DECOY_AMMO;
			}
		}
		for(i = 0; i < count; ++i)	if(i <= index-1 && IsValidEdict(weaponArray[i]))
		{
			iClient = GetEntPropEnt(weaponArray[i], Prop_Data, "m_hOwnerEntity");
			if(iClient != -1)
			{
				gcount = Function_GetGrenadeCount(iClient, iID);
				switch(gcount)
				{
					case 0:	continue;
					case 1:	if(Function_RemoveWeaponDrop(iClient, weaponArray[i]))
					{
						Function_RefundMoney(iClient, iID);
					}
					default:
					{
						SetEntProp(iClient, Prop_Send, "m_iAmmo", gcount-1, _, ammoindex);
						Function_RefundMoney(iClient, iID);
					}
				}
			}
		}
	}
	else if(slot != SlotNone)
	{
		for(i = 0; i < count; ++i)	if(i <= index-1 && IsValidEdict(weaponArray[i]))
		{
			iClient = GetEntPropEnt(weaponArray[i], Prop_Data, "m_hOwnerEntity");
			if(iClient != -1 && Function_RemoveWeaponDrop(iClient, weaponArray[i]))	Function_RefundMoney(iClient, iID);
		}
	}
	else
	{
		for(i = 0; i < count; ++i)
		{
			if(i > index -1)	break;
			
			if(IsClientInGame(weaponArray[i]) && Function_RemoveSpecialItem(weaponArray[i], iID))	Function_RefundMoney(weaponArray[i], iID);
		}
	}
}

int Function_GetGrenadeCount(int iClient, int iID)
{
	int iIndex = -1;
	switch(iID) {
		case WEAPON_HEGRENADE: iIndex = HEGRENADE_AMMO;
		case WEAPON_FLASHBANG: iIndex = FLASH_AMMO;
		case WEAPON_SMOKEGRENADE: iIndex = SMOKE_AMMO;
		case WEAPON_INCGRENADE, WEAPON_MOLOTOV: iIndex = INC_AMMO;
		case WEAPON_DECOY: iIndex = DECOY_AMMO;
		default: {
			LogError("Weapon ID %d is not a grenade.", iID);
			return 0;
		}
	}
	return GetEntProp(iClient, Prop_Send, "m_iAmmo", _, iIndex);
}

int Function_GetTeamWeaponCount(int iTeam, int iID)
{
	int iWeaponCount, i, slot = weaponSlots[iID];
	for(i = 1; i <= MaxClients; ++i)	if(IsClientInGame(i) && !Function_GetImmunity(i) && GetClientTeam(i) == iTeam)
	{
		switch(slot)
		{
			case SlotGrenade:	iWeaponCount += Function_GetGrenadeCount(i, iID);
			case SlotNone:		if(Function_HasSpecialItem(i, iID))
			{
				iWeaponCount++;
			}
			default:	if(Function_GetWeaponIDFromSlot(i, slot) == iID)
			{
				iWeaponCount++;
			}
		}
	}
	return iWeaponCount;
}

int Function_GetRestrictValue(int iTeam, int iID)
{
	int iArray;
	switch(iTeam)
	{
		case CS_TEAM_CT:	if(iID != WEAPON_DEFUSER)
		{
			iArray = CvarArrayHandleValCT[iID];
			if(iArray == -1)	return -1;
			return g_hRestrictCVarsCT[iArray].IntValue;
		}
		case CS_TEAM_T:		if(iID != WEAPON_C4)
		{
			iArray = CvarArrayHandleValT[iID];
			if(iArray == -1)	return -1;
			return g_hRestrictCVarsT[iArray].IntValue;
		}
	}
	return -1;
}

int Function_GetWeaponIDExtended(const char[] sWeapon)
{
	int iID = GetWeaponID(sWeapon);
	if(iID != WEAPON_NONE)	return iID;
	char sBuffer[32];
	CS_GetTranslatedWeaponAlias(sWeapon, sBuffer, sizeof(sBuffer));
	
	return view_as<int>(CS_AliasToWeaponID(sBuffer));
}

int Function_GetWeaponIDFromSlot(int iClient, int iSlot)
{
	int iEnt = GetPlayerWeaponSlot(iClient, iSlot);
	if(iEnt != -1)	return GetWeaponIDFromEnt(iEnt);
	return WEAPON_NONE;
}

bool Function_HasSpecialItem(int iClient, int iID)
{
	switch(iID)
	{
		case WEAPON_DEFUSER: 		if(GetEntProp(iClient, Prop_Send, "m_bHasDefuser") != 0)
		{
			return true;
		}
		case WEAPON_ASSAULTSUIT:	if(GetEntProp(iClient, Prop_Send, "m_ArmorValue") != 0 && GetEntProp(iClient, Prop_Send, "m_bHasHelmet") != 0)
		{
			return true;
		}
		case WEAPON_KEVLAR:			if(GetEntProp(iClient, Prop_Send, "m_ArmorValue") != 0 && GetEntProp(iClient, Prop_Send, "m_bHasHelmet") == 0)
		{
			return true;
		}
		case WEAPON_NIGHTVISION:	if(GetEntProp(iClient, Prop_Send, "m_bHasNightVision") !=0)
		{
			return true;
		}
	}
	return false;
}

bool Function_IsWeaponInOverride(int iTeam, int iID)
{
	switch(iTeam)	// Заменить на if/else после проверки
	{
		case CS_TEAM_CT: if(g_bOverideCT[iID])
		{
			return true;
		}
		case CS_TEAM_T: if(g_bOverideT[iID])
		{
			return true;
		}
	}
	return false;
}

bool Function_RemoveSpecialItem(int iClient, int iID)
{
	switch(iID)
	{
		case WEAPON_DEFUSER: if(GetEntProp(iClient, Prop_Send, "m_bHasDefuser") != 0)
		{
			SetEntProp(iClient, Prop_Send, "m_bHasDefuser", 0);
			return true;
		}
		case WEAPON_ASSAULTSUIT:	if(GetEntProp(iClient, Prop_Send, "m_ArmorValue") != 0 && GetEntProp(iClient, Prop_Send, "m_bHasHelmet") != 0)
		{
			SetEntProp(iClient, Prop_Send, "m_ArmorValue", 0);
			SetEntProp(iClient, Prop_Send, "m_bHasHelmet", 0);
			return true;
		}
		case WEAPON_KEVLAR:	if(GetEntProp(iClient, Prop_Send, "m_ArmorValue") != 0 && GetEntProp(iClient, Prop_Send, "m_bHasHelmet") == 0)
		{
			SetEntProp(iClient, Prop_Send, "m_ArmorValue", 0);
			return true;
		}
		case WEAPON_NIGHTVISION:	if(GetEntProp(iClient, Prop_Send, "m_bHasNightVision") !=0)
		{
			SetEntProp(iClient, Prop_Send, "m_bHasNightVision", 0);
			return true;
		}
	}
	return false;
}

bool Function_RemoveWeaponDrop(int iClient, int iEnt)
{
	CS_DropWeapon(iClient, iEnt, true, true);
	if(AcceptEntityInput(iEnt, "Kill"))	return true;
	return false;
}

bool Function_SetRestriction(int iID, int iTeam, int iAmount, bool bOverride)
{
	if(iAmount < -1)	iAmount = -1;
	int arraycell = -1;
	
	if(iTeam == CS_TEAM_T && iID != WEAPON_DEFUSER)
	{
		arraycell = CvarArrayHandleValT[iID];
		if(arraycell == -1)	return false;
		
		g_hRestrictCVarsT[arraycell].SetInt(iAmount, true);
		if(bOverride)	g_bOverideT[iID] = true;
	}
	else if(iTeam == CS_TEAM_CT && iID != WEAPON_C4)
	{
		arraycell = CvarArrayHandleValCT[iID];
		if(arraycell == -1)	return false;
		
		g_hRestrictCVarsCT[arraycell].SetInt(iAmount, true);
		if(bOverride)	g_bOverideCT[iID] = true;
	}
	return true;
}

bool Function_SetGroupRestriction(int iGroup, int iTeam, int iAmount)
{
	for(int i = 1; i < MAX_WEAPONS; ++i)	if(iGroup == weaponGroups[i])
	{
		Function_SetRestriction(i, iTeam, iAmount, true);
	}
	return true;
}

void Function_CheckPlayerWeapons()
{
	int i, val, count;
	for(i = 1; i < MAX_WEAPONS; ++i)	if(i != WEAPON_SHIELD)
	{
		if(i != WEAPON_DEFUSER)
		{
			val = Function_GetRestrictValue(CS_TEAM_T, i);
			if(val == -1)	continue;
			
			count = Function_GetTeamWeaponCount(CS_TEAM_T, i);
			if(count > val)	Function_RemoveRandom(count-val, CS_TEAM_T, i);
		}
		if(i != WEAPON_C4)
		{
			val = Function_GetRestrictValue(CS_TEAM_CT, i);
			if(val == -1)	continue;
			
			count = Function_GetTeamWeaponCount(CS_TEAM_CT, i);
			if(count > val)	Function_RemoveRandom(count-val, CS_TEAM_CT, i);
		}
	}
}

int Function_CanBuyWeapon(int iClient, int iTeam, int iID)
{
	int iMaxAmount = Function_GetRestrictValue(iTeam, iID);
	bool bResult = true;
	Action iAction = Plugin_Continue;

	Call_StartForward(hCanBuyForward);
	Call_PushCell(iClient);
	Call_PushCell(iTeam);
	Call_PushCell(iID);
	Call_PushCellRef(bResult);
	Call_Finish(iAction);


	switch(iAction)
	{
		case Plugin_Continue:	if(iMaxAmount == -1 || Function_GetImmunity(iClient) || Function_GetTeamWeaponCount(iTeam, iID) < iMaxAmount || g_bAllow)
		{
			return true;
		}
		case Plugin_Changed:	return bResult;
		default:			return false;
	}
	return false;
}

bool Function_CanPickupWeapon(int iClient, int iTeam, int iID)
{
	int iMaxAmount = Function_GetRestrictValue(iTeam, iID);
	bool bResult = true;
	Action iAction = Plugin_Continue;
	

	Call_StartForward(hCanPickupForward);
	Call_PushCell(iClient);
	Call_PushCell(iTeam);
	Call_PushCell(iID);
	Call_PushCellRef(bResult);
	Call_Finish(iAction);

	
	switch(iAction)
	{
		case Plugin_Continue:	if(iMaxAmount == -1 || Function_GetImmunity(iClient) || Function_GetTeamWeaponCount(iTeam, iID) < iMaxAmount || g_bAllow)
		{
			return true;
		}
		case Plugin_Changed:	return bResult;
		default:				return false;
	}
	return false;
}

public int Native_SetImmunity(Handle hPlugin, int numParams)
{
	int iClient = GetNativeCell(1);
	if(IsClientConnected(iClient) && !IsFakeClient(iClient))	g_bImmunity[iClient] = view_as<bool>(GetNativeCell(2));
	else ThrowNativeError(SP_ERROR_NATIVE, "[Weapon Restrict] [ERROR] [SetImmunity] Client '%d' not connected or bot.", iClient);
}

public int Native_SetStatus(Handle hPlugin, int numParams)
{
	g_bStatus = GetNativeCell(1);
}
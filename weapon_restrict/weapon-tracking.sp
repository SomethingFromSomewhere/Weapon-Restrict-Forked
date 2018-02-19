void CheckWeaponArrays()
{
	if(hWeaponsIDArray)	hWeaponsIDArray.Clear();
	else	hWeaponsIDArray = new ArrayList();

	if(hWeaponEntityArray)	hWeaponEntityArray.Clear();
	else	hWeaponEntityArray = new ArrayList();
	
	char sName[WEAPONARRAYSIZE];
	for (int i = MaxClients; i <= GetMaxEntities(); ++i)	if (IsValidEdict(i) && IsValidEntity(i))
	{
		GetEdictClassname(i, sName, sizeof(sName));
		if((strncmp(sName, "WEAPON_", 7, false) == 0 || strncmp(sName, "item_", 5, false) == 0))
		{
			int iID = Function_GetWeaponIDExtended(sName);
			if(iID != WEAPON_NONE && hWeaponEntityArray.FindValue(i) == -1)
			{
				hWeaponsIDArray.Push(iID);
				hWeaponEntityArray.Push(i);
			}
		}
	}
}

public void OnEntityCreated(int iEnt, const char[] classname)
{
	if(!hWeaponsIDArray || !hWeaponEntityArray)	return;

	if(StrContains(classname, "WEAPON_", false) != -1 || StrContains(classname, "item_", false) != -1)
	{
		int iID = GetWeaponID(classname);
		
		if(iID == WEAPON_NONE || hWeaponEntityArray.FindValue(iEnt) != -1)	return;
		
		hWeaponsIDArray.Push(iID);
		hWeaponEntityArray.Push(iEnt);
	}
}

public void OnEntityDestroyed(int iEnt)
{	
	if(!hWeaponsIDArray || !hWeaponEntityArray)	return;
	
	int iIndex = hWeaponEntityArray.FindValue(iEnt);
	if(iIndex != -1)
	{
		hWeaponEntityArray.Erase(iIndex);
		hWeaponsIDArray.Erase(iIndex);
	}
}

int GetWeaponIDFromEnt(int iEnt)
{
	if(!IsValidEdict(iEnt))	return WEAPON_NONE;
	
	int iIndex = hWeaponEntityArray.FindValue(iEnt);
	if(iIndex != -1)		return hWeaponsIDArray.Get(iIndex);

	
	char sClassname[WEAPONARRAYSIZE];
	GetEdictClassname(iEnt, sClassname, sizeof(sClassname));
	if(StrContains(sClassname, "WEAPON_", false) != -1 || StrContains(sClassname, "item_", false) != -1)
	{
		int iID = GetWeaponID(sClassname);
		if(iID != WEAPON_NONE)
		{
			hWeaponsIDArray.Push(iID);
			hWeaponEntityArray.Push(iEnt);
			return iID;
		}
	}
	return WEAPON_NONE;
}
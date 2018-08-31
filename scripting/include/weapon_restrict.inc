#if defined _weapon_restrict_included
  #endinput
#endif
#define _weapon_restrict_included

#define WEAPONARRAYSIZE 64


/**
 * Установка иммунитета от запрета оружия.
 * 
 * @param	iClient		Индекс игрока.
 * @param	bImmunity	Значение иммунитета (true/false)
 * 
 * @noreturn
 */
native void Restrict_SetImmunity(int iClient, bImmunity = true);

/**
 * Включение/Отключение запрета оружия. (Сбрасывается после смены карты)
 * 
 * @param	bStatus		Статус запрета (true/false)
 * 
 * @noreturn
 */
native void Restrict_SetStatus(bStatus = false);

/**
 * Вызывается при попытке купить оружие.
 * 
 * @param	iClient		Индекс игрока.
 * @param	iTeam		Индекс команды.
 * @param	iID			ID оружия.
 * @param 	&bAllow		true - разрешить покупку, false - запретить. (Plugin_Changed)
 * 
 * Возврат Plugin_Continue разрешит покупку, Plugin_Changed для использования &bAllow, Plugin_Stop/Plugin_Handled для запрета покупки.
 */
forward Action Restrict_OnCanBuyWeapon(int iClient, int iTeam, int iID, bool &bAllow);

/**
 * Вызывается при попытке подобрать оружие.
 * 
 * @param	iClient		Индекс игрока.
 * @param	iTeam		Индекс команды.
 * @param	iID			ID оружия.
 * @param 	&bAllow		true - разрешить подбор, false - запретить. (Plugin_Changed)
 *
 * Возврат Plugin_Continue разрешит подбор, Plugin_Changed для использования &bAllow, Plugin_Stop/Plugin_Handled для запрета подбора.
 */
forward Action Restrict_OnCanPickupWeapon(int iClient, int iTeam, int iID, bool &bAllow);

public SharedPlugin:__pl_weapon_restrict = 
{
	name = "weapon_restrict",
	file = "weapon_restrict.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
};

#if !defined REQUIRE_PLUGIN
public void __pl_weapon_restrict_SetNTVOptional()
{
	MarkNativeAsOptional("Restrict_SetImmunity");
	MarkNativeAsOptional("Restrict_SetStatus");
}
#endif
#if defined _restrict_included
  #endinput
#endif
#define _restrict_included

const int	CanBuy_Block = 0,
			CanBuy_BlockDontDisplay = 1,
			CanBuy_Allow = 2; 

#define WEAPONARRAYSIZE 64


/**
 * Установка имммунитета от запрета оружия.
 * 
 * @param	iClient		Индекс игрока.
 * @param	bImmunity	Значение иммунитета (true/false)
 * 
 * @noreturn
 */
native void Restrict_SetImmunity(int iClient, bImmunity = true);

/**
 * Вызывается при попытка купить оружие.
 * 
 * @param	iClient		Индекс игрока.
 * @param	iTeam		Индекс команды.
 * @param	iID			ID оружия.
 * 
 * Возврат CanBuy_Block - запретит покупку | CanBuy_BlockDontDisplay - запретит покупку, но не сообщит об этом | CanBuy_Allow - разрешит покупку
 */
forward int Restrict_OnCanBuyWeapon(int iClient, int iTeam, int iID);		// Будет изменен в будущем.

/**
 * Вызывается при попытка подобрать оружие.
 * 
 * @param	iClient		Индекс игрока.
 * @param	iTeam		Индекс команды.
 * @param	iID			ID оружия.
 * @param 	&bAllow		true - разрешить подбор, false - запретить. (Plugin_Changed)
 *
 * Возврат Plugin_Continue разрешит подбор, Plugin_Changed для использования &bAllow, Plugin_Stop/Plugin_Handled для запрета подбора.
 */
forward Action Restrict_OnCanPickupWeapon(int iClient, int iTeam, int iID, bool &bAllow);

public SharedPlugin:__pl_restrict = 
{
	name = "weapon_restrict",
	file = "weapon_restrict.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
};
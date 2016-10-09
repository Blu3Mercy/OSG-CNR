// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
*
*		Andy's Cops and Robbers - a SA:MP server

*		Copyright (c) 2016 Andy Sedeyn
*
*		Permission is hereby granted, free of charge, to any person obtaining a copy
*		of this software and associated documentation files (the "Software"), to deal
*		in the Software without restriction, including without limitation the rights
*		to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
*		copies of the Software, and to permit persons to whom the Software is
*		furnished to do so, subject to the following conditions:
*
*		The above copyright notice and this permission notice shall be included in all
*		copies or substantial portions of the Software.
*
*		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
*		IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
*		FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
*		AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
*		LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
*		OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
*		SOFTWARE.
*
*/
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
*
*		Player modules: global_player_functions.pwn
*
*/

stock Player_GetIpAndPort(playerid) {

	new ipport[24];
	NetStats_GetIpPort(playerid, ipport, sizeof(ipport));
	return ipport;
}

stock Player_LoggedIn(playerid) {

	return _:BitFlag_Get(PlayerFlags[playerid], epf_LoggedIn);
}

stock Player_Kick(playerid, delay = 200) {

	defer Player_ActualKick[delay](playerid);
	return true;
}

timer Player_ActualKick[200](playerid) {

	Kick(playerid);
	return true;
}

/*
*
*	Server-sided weapons
*
*/

stock Player_GetWeapons(playerid) {

	/*
	*
	*	Ammo is not checked in this function, so having it 
	*	declared as an array is just waste of unused memory.
	*
	*/

	new
		_weapon[13],
		_ammo,
		allWeaponNames[128];

	strcat(allWeaponNames, "");
	for(new i = 0; ++i <= 12;) {

		GetPlayerWeaponData(playerid, i, _weapon[i], _ammo);
		if(_weapon[i] != Player[playerid][epd_Weapon][i]) {

			if(i == 0) {

				format(allWeaponNames, sizeof(allWeaponNames), "%s%w (%d)", allWeaponNames, _weapon[i], i);
			}
			else {

				format(allWeaponNames, sizeof(allWeaponNames), ", %s%w (%d)", allWeaponNames, _weapon[i], i);
			}
			weaponSlot[i] = i;
			cheatWeaponCount++;

		}
	}
	if(cheatWeaponCount > 0) {

		if(BitFlag_Get(PlayerFlags[playerid], epf_HackTestPositive) && Player[playerid][epd_HackTestExpire] <= 0) {

			Admin_SendTaggedMessage(1, TYPE_ALERT, "[ANTI-CHEAT #1] %p (ID: %d) has been tested positive of having hacked guns.", playerid, playerid);
			Admin_SendTaggedMessage(1, TYPE_ALERT, "[ANTI-CHEAT #2] Hacked guns (weapon name [slotid]):");
			Admin_SendTaggedMessage(1, TYPE_ALERT, "[ANTI-CHEAT #3] %s", allWeaponNames);
		}
		else {

			Admin_SendTaggedMessage(1, TYPE_ALERT, "[ANTI-CHEAT #1] %p (ID: %d) has again tested positive of having hacked guns.", playerid, playerid);
			Admin_SendTaggedMessage(1, TYPE_ALERT, "[ANTI-CHEAT #2] Use /hackers to see all the positive tested players from the past 24 hours.");
		}
		BitFlag_On(PlayerFlags[playerid], epf_HackTestPositive);
		Player[playerid][epd_HackTestExpire] = SECONDS_IN_DAY * 1;
	}
	return true;
}

stock Player_GetWeaponInSlot(playerid, slotid) {

	new
		_weapon,
		_ammo;

	GetPlayerWeaponData(playerid, slotid, _weapon, _ammo);
	if(_weapon != Player[playerid][epd_Weapon][slotid]) {

		if(!BitFlag_Get(PlayerFlags[playerid], epf_WeaponHackPositive) && Player[playerid][epd_HackTestExpire] <= 0) {

			Admin_SendTaggedMessage(1, TYPE_ALERT, "[ANTI-CHEAT #1] %p (ID: %d) has been tested positive of having hacked guns.", playerid, playerid);
			Admin_SendTaggedMessage(1, TYPE_ALERT, "[ANTI-CHEAT #2] Hacked weapon: %w [slot: %d]", _weapon, slotid);

			BitFlag_On(PlayerFlags[playerid], epf_HackTestPositive);
			BitFlag_On(PlayerFlags[playerid], epf_WeaponHackPositive);
			Player[playerid][epd_HackTestExpire] = SECONDS_IN_DAY * 1;
		}
		else {

			Admin_SendTaggedMessage(1, TYPE_ALERT, "[ANTI-CHEAT #1] %p (ID: %d) has again tested positive of having hacked ammo.", playerid, playerid);
			Admin_SendTaggedMessage(1, TYPE_ALERT, "[ANTI-CHEAT #2] Use /hackers to see all the positive tested players from the past 24 hours.");
		}
	}
	return Player[playerid][epd_Weapon][slotid];
}

stock Player_GetAmmoInSlot(playerid, slotid) {

	new
		_weapon,
		_ammo;

	GetPlayerWeaponData(playerid, slotid, _weapon, _ammo);
	if(_ammo != Player[playerid][epd_Ammo][slotid]) {

		if(!BitFlag_Get(PlayerFlags[playerid], epf_AmmoHackPositive) && Player[playerid][epd_HackTestExpire] <= 0) {

			Admin_SendTaggedMessage(1, TYPE_ALERT, "[ANTI-CHEAT #1] %p (ID: %d) has been tested positive of having hacked ammo.", playerid, playerid);
			Admin_SendTaggedMessage(1, TYPE_ALERT, "[ANTI-CHEAT #2] Hacked ammo for gun: %w (ammo: %d) [slot: %d]", _weapon, _ammo, slotid);

			BitFlag_On(PlayerFlags[playerid], epf_HackTestPositive);
			BitFlag_On(PlayerFlags[playerid], epf_AmmoHackPositive);
			Player[playerid][epd_HackTestExpire] = SECONDS_IN_DAY * 1;
		}
		else {

			Admin_SendTaggedMessage(1, TYPE_ALERT, "[ANTI-CHEAT #1] %p (ID: %d) has again tested positive of having hacked guns.", playerid, playerid);
			Admin_SendTaggedMessage(1, TYPE_ALERT, "[ANTI-CHEAT #2] Use /hackers to see all the positive tested players from the past 24 hours.");
		}
	}
	return Player[playerid][epd_Ammo][slotid];
}

stock Player_ResetWeapons(playerid) {

	for(new i = 0; i < 13; i++) {

		Player[playerid][epd_Weapon][i] = 0;
		Player[playerid][epd_Ammo][i] = 0;
	}
	ResetPlayerWeapons(playerid);

	if(BitFlag_Get(PlayerFlags[playerid], epf_WeaponHackPositive)) {

		BitFlag_Off(PlayerFlags[playerid], epf_WeaponHackPositive);
	}
	if(BitFlag_Get(PlayerFlags[playerid], epf_AmmoHackPositive)) {

		BitFlag_Off(PlayerFlags[playerid], epf_AmmoHackPositive);
	}
	return true;
}

stock Player_GiveWeapon(playerid, weaponid, ammo) {

	new
		slotid = Weapon_GetSlot(weaponid);

	Player[playerid][epd_Weapon][slotid] = weaponid;
	Player[playerid][epd_Ammo][slotid] = ammo;
	GivePlayerWeapon(playerid, weaponid, ammo);
	return true;
}

Weapon_GetSlot(weaponid) {

	switch(weaponid) {

		case 0, 1: return 0;
		case 2..9: return 1;
		case 10..15: return 10;
		case 16..18, 39: return 8;
		case 22..24: return 2;
		case 25..27: return 3;
		case 28, 29, 32: return 4;
		case 30, 31: return 5;
		case 33, 34: return 6;
		case 35..38: return 7;
		case 40: return 12;
		case 41..43: return 9;
		case 46: return 11;
	}
	return -1;
}

/*
*
*	Server-sided wanted level
*
*/

stock Player_GetWantedLevel(playerid) {

	return Player[playerid][epd_WantedLevel];
}

stock Player_DecreaseWantedLevel(playerid) {

	Player[playerid][epd_WantedLevel]--;
	SetPlayerWantedLevel(playerid, Player[playerid][epd_WantedLevel]);
	return true;
}

stock Player_IncreaseWantedLevel(playerid) {

	Player[playerid][epd_WantedLevel]++;
	SetPlayerWantedLevel(playerid, Player[playerid][epd_WantedLevel]);
	return true;
}

stock Player_SetWantedLevel(playerid, wantedlevel) {

	Player[playerid][epd_WantedLevel] = wantedlevel;
	SetPlayerWantedLevel(playerid, wantedlevel);
	return true;
}

/*
*
*	Server-sided skins
*
*/

stock Player_GetSkin(playerid) {

	return Player[playerid][epd_Skin];
}

stock Player_SetSkin(playerid, skinid) {

	Player[playerid][epd_Skin] = skinid;
	SetPlayerSkin(playerid, skinid);
	return true;
}

/*
*
*	Server-sided money
*
*/

stock Player_SetMoney(playerid, amount) {

	Player_ResetMoney(playerid);
	Player[playerid][epd_Money] = amount;
	GivePlayerMoney(playerid, amount);
	return true;
}

stock Player_GetMoney(playerid) {

	if(Player[playerid][epd_Money] != GetPlayerMoney(playerid)) {

		if(BitFlag_Get(PlayerFlags[playerid], epf_HackTestPositive) && Player[playerid][epd_HackTestExpire] <= 0) {

			Admin_SendTaggedMessage(1, TYPE_ALERT, "[ANTI-CHEAT #1] %p (ID: %d) has been tested positive of having hacked ammo.", playerid, playerid);
			Admin_SendTaggedMessage(1, TYPE_ALERT, "[ANTI-CHEAT #2] Recorded money: $%d - Suspected hacked: $%d", Player[playerid][epd_Money], GetPlayerMoney(playerid));

			BitFlag_On(PlayerFlags[playerid], epf_HackTestPositive);
			Player[playerid][epd_HackTestExpire] = SECONDS_IN_DAY * 1;
		}
		else {

			Admin_SendTaggedMessage(1, TYPE_ALERT, "[ANTI-CHEAT #1] %p (ID: %d) has again tested positive of having hacked money.", playerid, playerid);
			Admin_SendTaggedMessage(1, TYPE_ALERT, "[ANTI-CHEAT #2] Use /hackers to see all the positive tested players from the past 24 hours.");
		}
	}
	return Player[playerid][epd_Money];
}

stock Player_GiveMoney(playerid, amount) {

	Player[playerid][epd_Money] += amount;
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, Player[playerid][epd_Money]);
	return true;
}

stock Player_TakeMoney(playerid, amount) {

	Player[playerid][epd_Money] -= amount;
	ResetPlayerMoney(playerid);
	Player_SetMoney(playerid, Player[playerid][epd_Money]);
	return true;
}

stock Player_ResetMoney(playerid) {

	Player[playerid][epd_Money] = 0;
	ResetPlayerMoney(playerid);
	return true;
}

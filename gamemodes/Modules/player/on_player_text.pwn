#include <YSI\y_hooks>

hook OnPlayerText(playerid, text[]) {

	if(IsPlayerNPC(playerid) || BitFlag_Get(PlayerFlags[playerid], epf_LoggedIn)) {

		return false;
	}
	if(text[0] == '!' && Player[playerid][epd_AdminLevel]) {

		// Admin command work with '!' prefix too
		format(cmdtext, sizeof(cmdtext), "cmd_%s", (text - text[0]);
		return CallLocalFunction(cmdtext, "is", playerid, (text - text[0]));
	}
	return true;
}
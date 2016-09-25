// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
*
*		Andy's Cops and Robbers - a SA:MP server
*		Copyright (C) 2016  G. Andy K. Sedeyn
*
*		This program is free software: you can redistribute it and/or modify
*		it under the terms of the GNU Affero General Public License as published
*		by the Free Software Foundation, either version 3 of the License, or
*		(at your option) any later version.
*
*		This program is distributed in the hope that it will be useful,
*		but WITHOUT ANY WARRANTY; without even the implied warranty of
*		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*		GNU Affero General Public License for more details.
*
*		You should have received a copy of the GNU Affero General Public License
*		along with this program.  If not, see <http://www.gnu.org/licenses/>.
*
*		The full copy of the used license can be found in the "LICENSE.txt" file 
*		found in the project's root folder.
*/
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
*
*		Player module: connection.pwn
*
*/

#include <YSI\y_hooks>

/*
*
*		Script
*
*/

/*
*
*		Connect
*
*/

hook OnPlayerConnect(playerid) {

	Player_SetDefaultBits(playerid);
	Player_SetDefaultVars(playerid);

	// Set peak players when needed
	Server_SetRecords();

	TogglePlayerSpectating(playerid, true);

	// Player check
	Player_LookupIP(playerid);
	Player_LoadInitData(playerid);
	return true;
}

Player_SetDefaultBits(playerid) {

	PlayerFlags[playerid] = E_PLAYER_FLAGS:0;
}

Player_SetDefaultVars(playerid) {

	// Reset all data
	Player[playerid] = ResetPlayer;

	Server_IncreaseStat(STAT_PLAYERS_CONNECTED, 1);

	GetPlayerIp(playerid, Player[playerid][epd_IP], MAX_PLAYER_IP);
	GetPlayerName(playerid, Player[playerid][epd_Username], MAX_PLAYER_IP);
}

Player_LookupIP(playerid) {

	if(IsPlayerNPC(playerid)) {

		return false;
	}

	new
		query[45],
		session_index;

	session_index++;
	Player[playerid][epd_HostSession] = session_index;

	format(query, sizeof(query), "lookupffs.com/api.php?ip=%s", Player_GetIP(playerid));
	HTTP(session_index, HTTP_GET, query, "", "Player_OnLookupResponse");
	return true;
}

forward Player_OnLookupResponse(session_id, response, data[]);
public Player_OnLookupResponse(session_id, response, data[]) {

	new player_id = Player_GetIDFromSession(session_id);
	if(player_id == INVALID_PLAYER_ID) {

		return true;
	}
	if(response != 200) {

		if(!Player[player_id][epd_HostRetry]) {

			Player[player_id][epd_HostRetry] = true;
			Player_LookupIP(player_id);
		}
		return true;
	}

	new
		tag[5][2];

	tag[0][0] = strfind(data, "<host>", true);
	tag[0][1] = strfind(data, "</host>", true);
	tag[1][0] = strfind(data, "<isp>", true);
	tag[1][1] = strfind(data, "</isp>", true);
	tag[2][0] = strfind(data, "<code>", true);
	tag[2][1] = strfind(data, "</code>", true);
	tag[3][0] = strfind(data, "<country>", true);
	tag[3][1] = strfind(data, "</country>", true);
	tag[4][0] = strfind(data, "<region>", true);
	tag[4][1] = strfind(data, "</region>", true);

	strmidex(Player[player_id][epd_HostName], data, (6 + tag[0][0]), tag[0][1], 60);
	strmidex(Player[player_id][epd_HostISP], data, (5 + tag[1][0]), tag[1][1], 60);
	strmidex(Player[player_id][epd_HostCode], data, (6 + tag[2][0]), tag[2][1], 3);
	strmidex(Player[player_id][epd_HostCountry], data, (9 + tag[3][0]), tag[3][1], 40);
	strmidex(Player[player_id][epd_HostRegion], data, (8 + tag[4][0]), tag[4][1], 40);
	Player[player_id][epd_HostProxy] = strval(data[strfind(data, "<proxy>", true) + 7]);

	Player_OnLookupComplete(player_id);
	return true;
}

Player_GetIDFromSession(session_id) {

	new
		player_id = INVALID_PLAYER_ID;

	foreach(new i : Player) {

		if(Player[i][epd_HostSession] != session_id) {

			continue;
		}
		player_id = i;
		break;
	}
	return player_id;
}

Player_OnLookupComplete(playerid) {

	if(MF_Player_IsProxyUser(playerid)) {

		SendTaggedMessageToPlayer(playerid, TYPE_INFO, "It seems that you're using proxies. Please disable them.");
		SendTaggedMessageToPlayer(playerid, TYPE_INFO, "In case this is a false-positive, you may contact an administrator.");

		SendTaggedMessageToAll(TYPE_ADMIN, "%p [%d] has been kicked from the server by "COMMUNITY_NAME" (proxies).", playerid, playerid);
		Player_Kick(playerid);
	}
}

Player_LoadInitData(playerid) {

	new
		query[90],
		DBResult:db_Result;

	format(query, sizeof(query), "SELECT ID, Password FROM players WHERE Username = '%q'", Player[playerid][epd_Username]);
	db_Result = db_query(handle_id, query);

	if(db_num_rows(db_Result)) {

		Player[playerid][epd_ID] = db_get_field_assoc_int(db_Result, "ID");
		db_get_field_assoc(db_Result, "Password", Player[playerid][epd_Password], MAX_PLAYER_PASSWORD);
		Dialog_Show(playerid, dia_Login, DIALOG_STYLE_PASSWORD, COMMUNITY_NAME" - Login", "Enter your password to continue:", "Login", "Quit");
	}
	else {

		Dialog_Show(playerid, dia_Register, DIALOG_STYLE_PASSWORD, COMMUNITY_NAME" - Register", "Enter your desired password to continue:", "Register", "Quit");
	}
	db_free_result(db_Result);
}

Dialog:dia_Login(playerid, response, listitem, inputtext[]) {

	if(!response) 
		return Kick(playerid);

	if(strcmp(Player[playerid][epd_Password], inputtext)) {

		Player_LoadAllData(playerid);
	}
	else {

		switch(++Player[playerid][epd_LoginAttempts]) {

			case MAX_LOGIN_ATTEMPTS: {

				Player_LoadAllData(playerid);
			}
			default: {

				// Textdraws saying: "You have entered a wrong password.\nYou have x-amount attempts left."
				return Dialog_Show(playerid, dia_Login, DIALOG_STYLE_PASSWORD, COMMUNITY_NAME" - Login", "Enter your password to continue:", "Login", "Quit");
			}
		}
	}
	return true;
}

Player_LoadAllData(playerid) {

	new
		query[40],
		DBResult:db_Result;

	format(query, sizeof(query), "SELECT * FROM players WHERE ID = %d", Player[playerid][epd_ID]);
	db_Result = db_query(handle_id, query);

	if(db_num_rows(db_Result)) {

		Player[playerid][epd_Admin] = db_get_field_assoc_int(db_Result, "Admin");
	}
	db_free_result(db_Result);
	return true;
}

Dialog:dia_Register(playerid, response, listitem, inputtext[]) {

	if(!response)
		return Kick(playerid);

	if(strlen(inputtext) < 6) {

		// Textdraw saying: "Password should be +5 characters";
		return Dialog_Show(playerid, dia_Register, DIALOG_STYLE_PASSWORD, COMMUNITY_NAME" - Register", ""COL_RED"ERROR: Invalid password!\n\n"COL_WHITE"Enter your desired password to continue:", "Register", "Quit");
	}
	if(!IsValidPassword(inputtext)) {

		// Textdraw saying: "Password can only contain: '%s'", allowedCharacters();
		return Dialog_Show(playerid, dia_Register, DIALOG_STYLE_PASSWORD, COMMUNITY_NAME" - Register", ""COL_RED"ERROR: Invalid password!\n\n"COL_WHITE"Enter your desired password to continue:", "Register", "Quit");
	}

	format(Player[playerid][epd_Password], MAX_PLAYER_PASSWORD, "%s", inputtext);

	new
		query[256];

	format(query, sizeof(query), "INSERT INTO players (Username, Password, IP) VALUES ('%q', '%q', '%q')", Player_GetName(playerid), Player[playerid][epd_Password], Player_GetIP(playerid));
	db_query(handle_id, query);

	new
		DBResult:db_result;

	db_result = db_query(handle_id, "SELECT last_insert_rowid()");
	Player[playerid][epd_ID] = db_get_field_int(db_result);

	db_free_result(db_result);
	return true;
}

/*
*
*		Disconnect
*
*/

hook OnPlayerDisconnect(playerid, reason) {

	Server_DecreaseStat(STAT_PLAYERS_CONNECTED, 1);
	return true;
}
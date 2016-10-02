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

	if(IsPlayerNPC(playerid)) {

		return Server_IncreaseStat(STAT_NPCS_CONNECTED, 1);
	}
	Player_SetDefaultBits(playerid);
	Player_SetDefaultVars(playerid);

	// Set peak players when needed
	Server_SetRecords();
	
	// Check if the player has multiple accounts on their IP
	Player_GetAllAccounts(playerid);

	TogglePlayerSpectating(playerid, true);

	defer PlayerTimer_Connection(playerid, PHASE_ESTABLISH_CONNECTION);
	return true;
}

Player_GetAllAccounts(playerid) {

	new
		query[150],
		DBResult:db_Result;

	format(query, sizeof(query), "SELECT Username, LastLoginDate FROM players WHERE IP = '%q' AND Username != '%q' COLLATE NOCASE", MF_Player_GetIP(playerid), MF_Player_GetName(playerid));
	db_Result = db_query(handle_id, query);

	new
		altNames[128];

	if(db_num_rows(db_Result)) {

		new
			count,
			rowName[MAX_PLAYER_NAME];

		do {

			db_get_field_assoc(db_Result, "Username", rowName, sizeof(rowName));
			strcat(altNames, rowName);

			count ++;

			if(count == (MAX_ALTERNATIVE_ACCOUNTS) && db_num_rows(db_Result) > (MAX_ALTERNATIVE_ACCOUNTS + 1)) {

				strcat(altNames, ", and more...");
				break;
			}
		}
		while(db_next_row(db_Result) && count < (MAX_ALTERNATIVE_ACCOUNTS + 1));
	}
	else {

		strcat(altNames, "(None)");
	}
	db_free_result(db_Result);
	return altNames;
}

timer PlayerTimer_Connection[2000](playerid, phaseid) {

	switch(phaseid) {

		case PHASE_ESTABLISH_CONNECTION: {

			Player_LoadInitData(playerid);

			new
				camPos = Player[playerid][epd_CameraPosition];

			if(Player_GetCameraPosition(playerid) == -1) {

				camPos = Player[playerid][epd_CameraPosition] = random(sizeof(gArr_CameraCoordinates));
			}
			
			SetPlayerCameraPos(playerid,
				gArr_CameraCoordinates[camPos][eccd_X],
				gArr_CameraCoordinates[camPos][eccd_Y],
				gArr_CameraCoordinates[camPos][eccd_Z]
			);
			SetPlayerCameraLookAt(playerid,
				gArr_CameraCoordinates[camPos][eccd_LookatX],
				gArr_CameraCoordinates[camPos][eccd_LookatY],
				gArr_CameraCoordinates[camPos][eccd_LookatZ]
			);
			// GetPlayerCameraPos(playerid, camPosX, camPosY, camPosZ);

			// PlayAudioStreamForPlayer(playerid, gArr_RadioStations[random(sizeof(gArr_RadioStations))][ersd_URL]);
			Player_SendMessage(playerid, COLOR_GREY, "--------------------------------------------------------------------------------------------------------");
			Player_SendMessage(playerid, COLOR_RED, "Warning! "COL_WHITE"The content on this server may be considered as explicit material.");
			Player_SendMessage(playerid, COLOR_GREY, "--------------------------------------------------------------------------------------------------------");

			SetPlayerColor(playerid, COLOR_CONNECTION);
			if(Player_GetDisconnectReason(playerid) == DISCONNECT_REASON_TIMEOUT || Player_GetDisconnectReason(playerid) == DISCONNECT_REASON_RESTART) {

				Player_RemoveBuildingsFix(playerid);
			}
			else {

				SetPlayerColor(playerid, COLOR_CONNECTION);
				Player_RemoveBuildings(playerid);

				defer PlayerTimer_Connection(playerid, PHASE_VALIDATE_CONNECTION);
			}
		}
		case PHASE_VALIDATE_CONNECTION: {

			new
				query[60],
				DBResult:db_Result;

			format(query, sizeof(query), "SELECT * FROM ips_bans WHERE IP = '%q'", MF_Player_GetIP(playerid));
			db_Result = db_query(handle_id, query);

			if(db_num_rows(db_Result)) {

				new
					expire_days = db_get_field_assoc_int(db_Result, "ExpireDays"),
					bannedby[MAX_PLAYER_NAME],
					bannedreason[MAX_BAN_REASON],
					bandate[MAX_LEN_DATE];

				db_get_field_assoc(db_Result, "BannedBy", bannedby, sizeof(bannedby));
				db_get_field_assoc(db_Result, "BanReason", bannedreason, sizeof(bannedreason));
				db_get_field_assoc(db_Result, "BanDate", bandate, sizeof(bandate));

				if(expire_days == -1) {

					/*
					*
					*	IP is banned forever
					*
					*/

					Dialog_Show(playerid, Dia_Banned, DIALOG_STYLE_MSGBOX, COMMUNITY_NAME" - Banned", 
						""COL_BANNED_BLUE"Who banned my IP?\n"COL_WHITE"%s\n\n"COL_BANNED_BLUE"Why was my IP banned?\n"COL_WHITE"%s\n\n"COL_BANNED_BLUE"When was my IP banned?\n"COL_WHITE"%s\n\n"COL_BANNED_BLUE"When will this ban expire?\n"COL_WHITE"Never\n\nIf this ban wasn't placed on you, please change your nicknmae or contact an administrator.",
						"Ok", "", bannedby, bannedreason, bandate
					);
					db_free_result(db_Result);
					Admin_SendConnectionMessages(playerid);
					return Player_Kick(playerid);
				}
				else {

					/*
					*
					*	IP is still banned for n-amount of seconds
					*
					*/

					new
						timestamp = db_get_field_assoc_int(db_Result, "BannedTimestamp");

					if((gettime() - timestamp) < ((60 * 60 * 24) * expire_days)) {

						/*
						*
						*	Player is still banned for n-amount of seconds
						*
						*/

						new
							seconds = (timestamp - gettime() + ((60 * 60 * 24) * expire_days));

						Dialog_Show(playerid, Dia_Banned, DIALOG_STYLE_MSGBOX, COMMUNITY_NAME" - Banned", 
							""COL_BANNED_BLUE"Who banned my IP?\n"COL_WHITE"%s\n\n"COL_BANNED_BLUE"Why was my IP banned?\n"COL_WHITE"%s\n\n"COL_BANNED_BLUE"When was my IP banned?\n"COL_WHITE"%s\n\n"COL_BANNED_BLUE"When will this ban expire?\n"COL_WHITE"%s\n\nIf this ban wasn't placed on you, please change your nicknmae or contact an administrator.",
							"Ok", "", bannedby, bannedreason, bandate, Time_ConvertSecondsToDate(seconds)
						);
						db_free_result(db_Result);
						Admin_SendConnectionMessages(playerid);
						return Player_Kick(playerid);
					}
					else {

						/*
						*
						*	IP ban has expired but not yet removed from the DB
						*
						*/

						Dialog_Show(playerid, Dia_Banned, DIALOG_STYLE_MSGBOX, COMMUNITY_NAME" - Banned", 
							""COL_BANNED_BLUE"Who banned my IP?\n"COL_WHITE"%s\n\n"COL_BANNED_BLUE"Why was my IP banned?\n"COL_WHITE"%s\n\n"COL_BANNED_BLUE"When was my IP banned?\n"COL_WHITE"%s\n\nThis ban has been lifted. Please be more careful next time.\n\n",
							"Ok", "", bannedby, bannedreason, bandate
						);
						Admin_SendTaggedMessage(2, TYPE_ALERT, "IP %s has been unbanned [Player: %p (ID: %d)] (ban expired).", MF_Player_GetIP(playerid), playerid, playerid);
					}
				}
			}
			db_free_result(db_Result);
			Admin_SendConnectionMessages(playerid);
			defer PlayerTimer_Connection(playerid, PHASE_VALIDATE_ACCOUNT);
		}
		case PHASE_VALIDATE_ACCOUNT: {

			new
				query[56],
				DBResult:db_Result;

			format(query, sizeof(query), "SELECT * FROM players_bans WHERE ID = %d", Player[playerid][epd_ID]);
			db_Result = db_query(handle_id, query);

			if(db_num_rows(db_Result)) {

				new
					expire_days = db_get_field_assoc_int(db_Result, "ExpireDays"),
					bannedby[MAX_PLAYER_NAME],
					bannedreason[MAX_BAN_REASON],
					bandate[MAX_LEN_DATE];

				db_get_field_assoc(db_Result, "BannedBy", bannedby, sizeof(bannedby));
				db_get_field_assoc(db_Result, "BanReason", bannedreason, sizeof(bannedreason));
				db_get_field_assoc(db_Result, "BanDate", bandate, sizeof(bandate));

				if(expire_days == -1) {

					/*
					*
					*	Player is banned forever
					*
					*/

					Dialog_Show(playerid, Dia_Banned, DIALOG_STYLE_MSGBOX, COMMUNITY_NAME" - Banned", 
						""COL_BANNED_BLUE"Who banned me?\n"COL_WHITE"%s\n\n"COL_BANNED_BLUE"Why was I banned?\n"COL_WHITE"%s\n\n"COL_BANNED_BLUE"When was I banned?\n"COL_WHITE"%s\n\n"COL_BANNED_BLUE"When will my ban expire?\n"COL_WHITE"Never\n\nIf this ban wasn't placed on you, please change your nicknmae or contact an administrator.",
						"Ok", "", bannedby, bannedreason, bandate
					);
					db_free_result(db_Result);
					Admin_SendConnectionMessages(playerid);
					return Player_Kick(playerid);
				}
				else {

					new
						timestamp = db_get_field_assoc_int(db_Result, "BannedTimestamp");

					if((gettime() - timestamp) < ((60 * 60 * 24) * expire_days)) {

						/*
						*
						*	Player is still banned for n-amount of seconds
						*
						*/

						new
							seconds = (timestamp - gettime() + ((60 * 60 * 24) * expire_days));

						Dialog_Show(playerid, Dia_Banned, DIALOG_STYLE_MSGBOX, COMMUNITY_NAME" - Banned", 
							""COL_BANNED_BLUE"Who banned me?\n"COL_WHITE"%s\n\n"COL_BANNED_BLUE"Why was I banned?\n"COL_WHITE"%s\n\n"COL_BANNED_BLUE"When was I banned?\n"COL_WHITE"%s\n\n"COL_BANNED_BLUE"When will my ban expire?\n"COL_WHITE"%s\n\nIf this ban wasn't placed on you, please change your nicknmae or contact an administrator.",
							"Ok", "", bannedby, bannedreason, bandate, Time_ConvertSecondsToDate(seconds)
						);
						db_free_result(db_Result);
						Admin_SendConnectionMessages(playerid);
						return Player_Kick(playerid);
					}
					else {

						/*
						*
						*	Player's ban has expired but not yet removed from the DB
						*
						*/

						Dialog_Show(playerid, Dia_Banned, DIALOG_STYLE_MSGBOX, COMMUNITY_NAME" - Banned", 
							""COL_BANNED_BLUE"Who banned me?\n"COL_WHITE"%s\n\n"COL_BANNED_BLUE"Why was I banned?\n"COL_WHITE"%s\n\n"COL_BANNED_BLUE"When was I banned?\n"COL_WHITE"%s\nYour ban has been lifted. Please be more careful next time.",
							"Ok", "", bannedby, bannedreason, bandate
						);
						Admin_SendTaggedMessage(2, TYPE_ALERT, "%p (%d) has been unbanned (ban expired).", playerid, playerid);
					}
				}
			}
			db_free_result(db_Result);
			Admin_SendConnectionMessages(playerid);
			defer PlayerTimer_Connection(playerid, PHASE_ENTER_GAME);
		}
		case PHASE_ENTER_GAME: {

			// Player check
			Player_LookupIP(playerid);
			Player_ShowLoginRegister(playerid);
		}
	}
	return true;
}

Player_ShowLoginRegister(playerid) {

	if(BitFlag_Get(PlayerFlags[playerid], epf_Registered)) {

		Dialog_Show(playerid, dia_Login, DIALOG_STYLE_PASSWORD, COMMUNITY_NAME" - Login", "Enter your password to continue:", "Login", "Quit");
	}
	else {

		Dialog_Show(playerid, dia_Register, DIALOG_STYLE_PASSWORD, COMMUNITY_NAME" - Register", "Enter your desired password to continue:", "Register", "Quit");
	}
	return true;
}

Player_RemoveBuildingsFix(playerid) {

	Dialog_Show(playerid, Dia_RemoveBuilding, DIALOG_STYLE_MSGBOX, COMMUNITY_NAME" - Fix notice", 
		COL_WHITE"It seems like you were online and %s.\nBecause of that, we prompt you this dialog.\nThe dialog's purpose is to prevent your game from freezing.\n\nClick \'dismiss\' to skip this process (doesn't remove object)",
		"Dismiss", "Proceed",
		// Replacement for '%s' in the text:
		(Player_GetDisconnectReason(playerid) == DISCONNECT_REASON_TIMEOUT) ? ("timed out from the server") : ((Player_GetDisconnectReason(playerid) == DISCONNECT_REASON_RESTART) ? ("a server restart occured") : (""))
	);
	return true;
}

Dialog:Dia_RemoveBuilding(playerid, response, listitem, inputtext[]) {

	if(!response) {

		Player_RemoveBuildings(playerid);
		defer PlayerTimer_Connection(playerid, PHASE_VALIDATE_ACCOUNT);
	}
	else {

		defer PlayerTimer_Connection[250](playerid, PHASE_VALIDATE_ACCOUNT);
	}
	return true;
}

Player_SetDefaultBits(playerid) {

	PlayerFlags[playerid] = E_PLAYER_FLAGS:0;
	return true;
}

Player_SetDefaultVars(playerid) {

	/*
	*
	*	Reset player data to avoid data collisions
	*
	*/
	Player[playerid] = ResetPlayer;

	Server_IncreaseStat(STAT_PLAYERS_CONNECTED, 1);

	GetPlayerIp(playerid, Player[playerid][epd_IP], MAX_PLAYER_IP);
	GetPlayerName(playerid, Player[playerid][epd_Username], MAX_PLAYER_NAME);
	return true;
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

	format(query, sizeof(query), "lookupffs.com/api.php?ip=%s", MF_Player_GetIP(playerid));
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

		Player_SendTaggedMessage(playerid, TYPE_INFO, "It seems that you're using proxies. Please disable them.");
		Player_SendTaggedMessage(playerid, TYPE_INFO, "In case this is a false-positive, you may contact an administrator.");

		SendTaggedMessageToAll(TYPE_ADMIN, "%p [%d] has been kicked from the server by "COMMUNITY_NAME" (proxies).", playerid, playerid);
		Player_Kick(playerid);
	}
	return true;
}

Player_LoadInitData(playerid) {

	new
		query[128],
		DBResult:db_Result;

	format(query, sizeof(query), "SELECT ID, Password, LastLoginDate, DisconnectReason FROM players WHERE Username = '%q'", MF_Player_GetName(playerid));
	db_Result = db_query(handle_id, query);

	if(db_num_rows(db_Result)) {

		Player[playerid][epd_ID] = db_get_field_assoc_int(db_Result, "ID");
		db_get_field_assoc(db_Result, "Password", Player[playerid][epd_Password], MAX_PLAYER_PASSWORD);
		db_get_field_assoc(db_Result, "LastLoginDate", Player[playerid][epd_LastLoginDate], MAX_LEN_DATE);
		Player[playerid][epd_DisconnectReason] = db_get_field_assoc_int(db_Result, "DisconnectReason");

		BitFlag_On(PlayerFlags[playerid], epf_Registered);
	}
	else {

		BitFlag_Off(PlayerFlags[playerid], epf_Registered);
	}
	db_free_result(db_Result);
	return true;
}

Dialog:dia_Login(playerid, response, listitem, inputtext[]) {

	if(!response) 
		return Kick(playerid);

	new
		hashpass[MAX_PLAYER_PASSWORD];

	WP_Hash(hashpass, sizeof(hashpass), inputtext);

	if(strcmp(Player[playerid][epd_Password], hashpass)) {

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

		Player[playerid][epd_PlayTime] = db_get_field_assoc_int(db_Result, "PlayTime");
		Player[playerid][epd_Experience] = db_get_field_assoc_int(db_Result, "Experience");
	}
	db_free_result(db_Result);

	BitFlag_On(PlayerFlags[playerid], epf_LoggedIn);
	TogglePlayerSpectating(playerid, false);
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

	WP_Hash(Player[playerid][epd_Password], MAX_PLAYER_PASSWORD, inputtext);

	new
		query[256];

	format(query, sizeof(query), "INSERT INTO players (Username, Password, IP) VALUES ('%q', '%q', '%q')", MF_Player_GetName(playerid), Player[playerid][epd_Password], MF_Player_GetIP(playerid));
	db_query(handle_id, query);

	new
		DBResult:db_result;

	db_result = db_query(handle_id, "SELECT last_insert_rowid()");
	Player[playerid][epd_ID] = db_get_field_int(db_result);

	db_free_result(db_result);

	BitFlag_On(PlayerFlags[playerid], epf_LoggedIn);
	BitFlag_On(PlayerFlags[playerid], epf_Registered);
	TogglePlayerSpectating(playerid, false);
	return true;
}

Player_GetCameraPosition(playerid) {

	return Player[playerid][epd_CameraPosition];
}

Player_GetDisconnectReason(playerid) {

	return Player[playerid][epd_DisconnectReason];
}

Player_RemoveBuildings(playerid) {
	RemoveBuildingForPlayer(playerid, 4063, 1578.4688, -1676.4219, 13.0703, 0.25);
	return true;
}

Player_SetDisconnectReason(playerid, reason) {

	Player[playerid][epd_DisconnectReason] = reason;

	new
		query[60];

	format(query, sizeof(query), "UPDATE players SET DisconnectReason = %d WHERE ID = %d",
		Player[playerid][epd_DisconnectReason], Player[playerid][epd_ID]
	);
	db_query(handle_id, query);
	return true;
}

Admin_SendConnectionMessages(playerid) {

	Admin_SendTaggedMessage(1, TYPE_ALERT, "%p (ID: %d) has connected to the server (%s)", playerid, playerid, Player_GetIpAndPort(playerid));
	Admin_SendTaggedMessage(2, TYPE_ALERT, "\t\tAll alternative accounts on this IP: %s", Player_GetAllAccounts(playerid));
	return true;
}

Time_ConvertSecondsToDate(&seconds, &minutes = -1, &hours = -1, &days = -1, &weeks = -1, &months = -1, &years = -1) {

	#define SECONDS_IN_MINUTE	60
	#define SECONDS_IN_HOUR		SECONDS_IN_MINUTE * 60
	#define SECONDS_IN_DAY		SECONDS_IN_HOUR * 24
	#define SECONDS_IN_WEEK		SECONDS_IN_DAY * 7
	#define SECONDS_IN_MONTH	SECONDS_IN_WEEK * 4
	#define SECONDS_IN_YEAR		SECONDS_IN_MONTH * 12

	#define MF_Time_ConvertSeconds(%0,%1) %0 = (seconds / %1); seconds %= (%1)

	new
		formattedTime[128];

	if(years != -1 && (seconds / SECONDS_IN_YEAR)) {

		MF_Time_ConvertSeconds(years, SECONDS_IN_YEAR);
		MF_Time_ConvertSeconds(months, SECONDS_IN_MONTH);
		MF_Time_ConvertSeconds(weeks, SECONDS_IN_WEEK);
		MF_Time_ConvertSeconds(days, SECONDS_IN_DAY);
		MF_Time_ConvertSeconds(hours, SECONDS_IN_HOUR);
		MF_Time_ConvertSeconds(minutes, SECONDS_IN_MINUTE);

		format(formattedTime, sizeof(formattedTime), "%d %s, %d %s, %d %s, %d %s, %d %s, %d %s and %d %s",
			years, MF_Time_PluralSingular(years, "year", "years"),
			months, MF_Time_PluralSingular(months, "month", "months"),
			weeks, MF_Time_PluralSingular(weeks, "week", "weeks"),
			days, MF_Time_PluralSingular(days, "day", "days"),
			hours, MF_Time_PluralSingular(hours, "hour", "hours"),
			minutes, MF_Time_PluralSingular(minutes, "minute", "minutes"),
			seconds, MF_Time_PluralSingular(seconds, "second", "seconds")
		);
	}
	else if(months != -1 && (seconds / SECONDS_IN_MONTH)) {

		MF_Time_ConvertSeconds(months, SECONDS_IN_MONTH);
		MF_Time_ConvertSeconds(weeks, SECONDS_IN_WEEK);
		MF_Time_ConvertSeconds(days, SECONDS_IN_DAY);
		MF_Time_ConvertSeconds(hours, SECONDS_IN_HOUR);
		MF_Time_ConvertSeconds(minutes, SECONDS_IN_MINUTE);

		format(formattedTime, sizeof(formattedTime), "%d %s, %d %s, %d %s, %d %s, %d %s and %d %s",
			months, MF_Time_PluralSingular(months, "month", "months"),
			weeks, MF_Time_PluralSingular(weeks, "week", "weeks"),
			days, MF_Time_PluralSingular(days, "day", "days"),
			hours, MF_Time_PluralSingular(hours, "hour", "hours"),
			minutes, MF_Time_PluralSingular(minutes, "minute", "minutes"),
			seconds, MF_Time_PluralSingular(seconds, "second", "seconds")
		);
	}
	else if(weeks != -1 && (seconds / SECONDS_IN_WEEK)) {

		MF_Time_ConvertSeconds(weeks, SECONDS_IN_WEEK);
		MF_Time_ConvertSeconds(days, SECONDS_IN_DAY);
		MF_Time_ConvertSeconds(hours, SECONDS_IN_HOUR);
		MF_Time_ConvertSeconds(minutes, SECONDS_IN_MINUTE);

		format(formattedTime, sizeof(formattedTime), "%d %s, %d %s, %d %s, %d %s and %d %s",
			weeks, MF_Time_PluralSingular(weeks, "week", "weeks"),
			days, MF_Time_PluralSingular(days, "day", "days"),
			hours, MF_Time_PluralSingular(hours, "hour", "hours"),
			minutes, MF_Time_PluralSingular(minutes, "minute", "minutes"),
			seconds, MF_Time_PluralSingular(seconds, "second", "seconds")
		);
	}
	else if(days != -1 && (seconds / SECONDS_IN_DAY)) {

		MF_Time_ConvertSeconds(days, SECONDS_IN_DAY);
		MF_Time_ConvertSeconds(hours, SECONDS_IN_HOUR);
		MF_Time_ConvertSeconds(minutes, SECONDS_IN_MINUTE);

		format(formattedTime, sizeof(formattedTime), "%d %s, %d %s, %d %s and %d %s",
			days, MF_Time_PluralSingular(days, "day", "days"),
			hours, MF_Time_PluralSingular(hours, "hour", "hours"),
			minutes, MF_Time_PluralSingular(minutes, "minute", "minutes"),
			seconds, MF_Time_PluralSingular(seconds, "second", "seconds")
		);
	}
	else if(hours != -1 && (seconds / SECONDS_IN_HOUR)) {

		MF_Time_ConvertSeconds(hours, SECONDS_IN_HOUR);
		MF_Time_ConvertSeconds(minutes, SECONDS_IN_MINUTE);

		format(formattedTime, sizeof(formattedTime), "%d %s, %d %s and %d %s",
			hours, MF_Time_PluralSingular(hours, "hour", "hours"),
			minutes, MF_Time_PluralSingular(minutes, "minute", "minutes"),
			seconds, MF_Time_PluralSingular(seconds, "second", "seconds")
		);
	}
	else if(minutes != -1 && (seconds / SECONDS_IN_MINUTE)) {

		MF_Time_ConvertSeconds(minutes, SECONDS_IN_MINUTE);

		format(formattedTime, sizeof(formattedTime), "%d %s and %d %s",
			minutes, MF_Time_PluralSingular(minutes, "minute", "minutes"),
			seconds, MF_Time_PluralSingular(seconds, "second", "seconds")
		);
	}
	else {

		format(formattedTime, sizeof(formattedTime), "%d %s",
			seconds, MF_Time_PluralSingular(seconds, "second", "seconds")
		);
	}
	return formattedTime;
}

/*
*
*		Disconnect
*
*/

hook OnPlayerDisconnect(playerid, reason) {

	if(IsPlayerNPC(playerid)) {

		return Server_DecreaseStat(STAT_NPCS_CONNECTED, 1);
	}
	Server_DecreaseStat(STAT_PLAYERS_CONNECTED, 1);

	Player_SaveDisconnectData(playerid);

	switch(reason) {

		case 0: {

			/*
			*
			*	Timeout/crash
			*		[ The player's connection was lost. Either their game crashed or their network had a fault. ]
			*
			*/

			if(Player_GetDisconnectReason(playerid) == DISCONNECT_REASON_UNKNOWN) {

				Player_SetDisconnectReason(playerid, DISCONNECT_REASON_TIMEOUT);
			}
			Admin_SendTaggedMessage(1, TYPE_ALERT, "%p (ID: %d) has left the server, reason: timeout/crash.");
		}
		case 1: {

			/*
			*
			*	Quit
			*		[ The player purposefully quit, either using the /quit (/q) command or via the pause menu. ]
			*
			*/

			if(Player_GetDisconnectReason(playerid) == DISCONNECT_REASON_UNKNOWN) {

				Player_SetDisconnectReason(playerid, DISCONNECT_REASON_QUIT);
			}
			Admin_SendTaggedMessage(1, TYPE_ALERT, "%p (ID: %d) has left the server, reason: quit.");
		}
		case 2: {

			/*
			*
			*	Kick/ban
			*		[ The player was kicked or banned by the server. ]
			*
			*/

			if(Player_GetDisconnectReason(playerid) == DISCONNECT_REASON_UNKNOWN) {

				Player_SetDisconnectReason(playerid, DISCONNECT_REASON_KICKBAN);
			}
			Admin_SendTaggedMessage(1, TYPE_ALERT, "%p (ID: %d) has left the server, reason: kicked/banned.");
		}
	}
	return true;
}

Player_SaveDisconnectData(playerid) {

	new
		query[90];

	format(query, sizeof(query), "UPDATE players SET PlayTime = %d WHERE ID = %d",
		Player[playerid][epd_PlayTime], Player[playerid][epd_ID]
	);
	db_query(handle_id, query);
}

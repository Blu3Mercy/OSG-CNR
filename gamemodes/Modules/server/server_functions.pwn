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

Server_SetStat(type, value) {
	
	ServerInfo[type] = value;

	if(type == STAT_TOTAL_REGISTERED_PLAYERS || type == STAT_PEAK_PLAYERS_ONLINE) {

		new
			query[95];

		format(query, sizeof(query), "UPDATE server_stats SET Registered_Players = %d, Peak_Players_Online = %d WHERE ID = %d", 
			Server_GetStat(STAT_TOTAL_REGISTERED_PLAYERS), Server_GetStat(STAT_PEAK_PLAYERS_ONLINE), SERVER_DB_ID);
		
		db_query(handle_id, query);
	}
	return true;
}

Server_IncreaseStat(type, value) {

	ServerInfo[type] += value;

	// Avoid the creation of multiple database calls and local variables
	Server_SetStat(type, ServerInfo[type]);
	return true;
}

Server_DecreaseStat(type, value) {

	ServerInfo[type] -= value;

	// Avoid the creation of multiple database calls and local variables
	Server_SetStat(type, ServerInfo[type]);
	return true;
}

Server_GetStat(type) {

	return ServerInfo[type];
}

Server_SetRecords() {

	if(Server_GetStat(STAT_PEAK_PLAYERS_ONLINE) < Server_GetStat(STAT_PLAYERS_CONNECTED)) {

		Server_SetStat(STAT_PEAK_PLAYERS_ONLINE, Server_GetStat(STAT_PLAYERS_CONNECTED));
	}
	return true;
}

Server_ClearChatForPlayer(playerid) {

	for(new i = 20; --i >= 0;) {

		SendClientMessage(playerid, -1, "");
	}
	return true;
}

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

Server_SetStat(type, value) {
	
	ServerInfo[type] = value;

	if(type == STAT_TOTAL_REGISTERED_PLAYERS || type == STAT_PEAK_PLAYERS_ONLINE) {

		new
			query[95];

		format(query, sizeof(query), "UPDATE server_stats SET Registered_Players = %d, Peak_Players_Online = %d WHERE ID = %d", 
			Server_GetStat(STAT_TOTAL_REGISTERED_PLAYERS), Server_GetStat(STAT_PEAK_PLAYERS_ONLINE), SERVER_DB_ID);
		
		db_query(handle_id, query);
	}
}

Server_IncreaseStat(type, value) {

	ServerInfo[type] += value;

	// Avoid the creation of multiple database calls and local variables
	Server_SetStat(type, ServerInfo[type]);
}

Server_DecreaseStat(type, value) {

	ServerInfo[type] -= value;

	// Avoid the creation of multiple database calls and local variables
	Server_SetStat(type, ServerInfo[type]);
}

Server_GetStat(type) {

	return ServerInfo[type];
}

Server_SetRecords() {

	if(Server_GetStat(STAT_PEAK_PLAYERS_ONLINE) < Server_GetStat(STAT_PLAYERS_CONNECTED)) {

		Server_SetStat(STAT_PEAK_PLAYERS_ONLINE, Server_GetStat(STAT_PLAYERS_CONNECTED));
	}
}

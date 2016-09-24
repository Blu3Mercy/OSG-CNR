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
*		Data module: server_data.pwn
*
*/

/*
*
*		Macro Functions (MF_)
*
*/

/*
*
*		Defines
*
*/

#define STAT_PLAYERS_CONNECTED			0
#define STAT_NPCS_CONNECTED				1
#define STAT_REGISTERED_CONNECTED		2
#define STAT_TOTAL_REGISTERED_PLAYERS	3	
#define STAT_COP_COUNT					4
#define STAT_ROBBER_COUNT				5
#define STAT_PEAK_PLAYERS_ONLINE		6
#define STAT_SERVER_RUNNING_TIME		7

#define MAX_SERVER_STAT					8

/*
*
*		Variables
*
*/

new ServerInfo[MAX_SERVER_STAT];
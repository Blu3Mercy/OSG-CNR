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
*		Data module: player_data.pwn
*
*/

/*
*
*		Macro functions (MF)
*
*/

// General MFs
#define MF_IsAdmin(%0)		Player[%0][epd_Admin]
#define MF_PlayTime(%0)		Player[%0][epd_PlayTime]

// Lookup MFs
#define MF_Player_GetHost(%0)				Player[%0][epd_HostName]
#define MF_Player_GetISP(%0)				Player[%0][epd_HostISP]
#define MF_Player_GetCountryCode(%0)		Player[%0][epd_HostCode]
#define MF_Player_GetCountryName(%0)		Player[%0][epd_HostCountry]
#define MF_Player_GetCountryRegion(%0)		Player[%0][epd_HostRegion]
#define MF_Player_IsProxyUser(%0)			Player[%0][epd_HostProxy]

// Bitfalg MFs
#define BitFlag_Get(%0,%1)            ((%0) & (%1))   // Returns zero (false) if the flag isn't set.
#define BitFlag_On(%0,%1)             ((%0) |= (%1))  // Turn on a flag.
#define BitFlag_Off(%0,%1)            ((%0) &= ~(%1)) // Turn off a flag.
#define BitFlag_Toggle(%0,%1)         ((%0) ^= (%1))  // Toggle a flag (swap true/false).
#define BitFlag_Set(%1,%2,%3)		  if(%3)((%1)|=(%2));else((%1)&=~(%2))

/*
*
*		Data module: player_data.pwn
*
*/

enum E_PLAYER_FLAGS:(<<= 1) {

	epf_LoggedIn = 1,
	epf_Registered,
	epf_Spawned,
	epf_VIP
};
new E_PLAYER_FLAGS:PlayerFlags[MAX_PLAYERS];

enum E_PLAYER_DATA {

	// Database data
	epd_ID,
	epd_Username[MAX_PLAYER_NAME],
	epd_Password[MAX_PLAYER_PASSWORD],
	epd_IP[MAX_PLAYER_IP],

	epd_RegisterDate[MAX_LEN_DATE],
	epd_LastLoginDate[MAX_LEN_DATE],

	epd_Admin,

	epd_PlayTime,
	epd_Experience,

	// Lookup data
	epd_HostName[60],
	epd_HostISP[60],
	epd_HostCode[3],
	epd_HostCountry[45],
	epd_HostRegion[43],
	epd_HostProxy,

	// Session data that are not booleans

	bool:epd_LoggedIn,
	epd_LoginAttempts,

		// Lookup data
	epd_HostSession,
	epd_HostRetry,

		// Class
	epd_TempCurrentClass,
	epd_CurrentClass
};
new Player[MAX_PLAYERS][E_PLAYER_DATA];
new ResetPlayer[E_PLAYER_DATA];

/*
*
*		Global player variables
*
*/

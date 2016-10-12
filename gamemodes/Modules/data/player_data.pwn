// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
*
*       Andy's Cops and Robbers - a SA:MP server

*       Copyright (c) 2016 Andy Sedeyn
*
*       Permission is hereby granted, free of charge, to any person obtaining a copy
*       of this software and associated documentation files (the "Software"), to deal
*       in the Software without restriction, including without limitation the rights
*       to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
*       copies of the Software, and to permit persons to whom the Software is
*       furnished to do so, subject to the following conditions:
*
*       The above copyright notice and this permission notice shall be included in all
*       copies or substantial portions of the Software.
*
*       THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
*       IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
*       FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
*       AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
*       LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
*       OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
*       SOFTWARE.
*
*/
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
*
*       Data module: player_data.pwn
*
*/

/*
*
*       Macro functions (MF)
*
*/

// General MFs
#define MF_Player_GetName(%0)       Player[%0][epd_Username]
#define MF_Player_GetIP(%0)         Player[%0][epd_IP]
#define MF_Player_IsAdmin(%0)       Player[%0][epd_Admin]
#define MF_Player_PlayTime(%0)      Player[%0][epd_PlayTime]    

// Lookup MFs
#define MF_Player_GetHost(%0)               Player[%0][epd_HostName]
#define MF_Player_GetISP(%0)                Player[%0][epd_HostISP]
#define MF_Player_GetCountryCode(%0)        Player[%0][epd_HostCode]
#define MF_Player_GetCountryName(%0)        Player[%0][epd_HostCountry]
#define MF_Player_GetCountryRegion(%0)      Player[%0][epd_HostRegion]
#define MF_Player_IsProxyUser(%0)           Player[%0][epd_HostProxy]

// Bitfalg MFs
#define BitFlag_Get(%0,%1)            ((%0) & (%1))   // Returns zero (false) if the flag isn't set.
#define BitFlag_On(%0,%1)             ((%0) |= (%1))  // Turn on a flag.
#define BitFlag_Off(%0,%1)            ((%0) &= ~(%1)) // Turn off a flag.
#define BitFlag_Toggle(%0,%1)         ((%0) ^= (%1))  // Toggle a flag (swap true/false).
#define BitFlag_Set(%1,%2,%3)         if(%3)((%1)|=(%2));else((%1)&=~(%2))

/*
*
*       Data module: player_data.pwn
*
*/

enum E_PLAYER_FLAGS:(<<= 1) {

    epf_LoggedIn = 1,
    epf_Registered,
    epf_Spawned,
    epf_VIP,
    epf_HackTestPositive,
    epf_WeaponHackPositive,
    epf_AmmoHackPositive
};
new E_PLAYER_FLAGS:PlayerFlags[MAX_PLAYERS];

enum E_PLAYER_DATA {

    /*
    *
    *   Database data
    *
    */

    epd_ID,
    epd_Username[MAX_PLAYER_NAME],
    epd_Password[MAX_PLAYER_PASSWORD],
    epd_IP[MAX_PLAYER_IP],

    epd_RegisterDate[MAX_LEN_DATE],
    epd_LastLoginDate[MAX_LEN_DATE],
    epd_DisconnectReason,

    epd_Admin,

    epd_PlayTime,
    epd_Experience,
    epd_WantedLevel,
    epd_Money,

    // Array with true and false to represent whether a class is visible or not
    bool:epd_ClassVisible[MAX_CLASSES],

    // Restrictions that are not boolean
    epd_MutedTime,

    /*
    *
    *   Session data
    *       (non-boolean: all boolean vars must be put in the FLAGS enum)
    *
    */

    epd_LoginAttempts,

        // Lookup data
    epd_HostName[60],
    epd_HostISP[60],
    epd_HostCode[3],
    epd_HostCountry[45],
    epd_HostRegion[43],
    epd_HostProxy,
    epd_HostSession,
    epd_HostRetry,

        // Class
    epd_ClassEnvironment,
    epd_TempCurrentClassID,
    epd_CurrentClassID,
    epd_Class,

        // Camera positions
    epd_CameraPosition,

        // Anti hack
    epd_HackTestExpire,
    epd_Weapon[13],
    epd_Ammo[13],
    epd_Team,
    epd_Skin
};
new Player[MAX_PLAYERS][E_PLAYER_DATA];
new ResetPlayer[E_PLAYER_DATA];

enum E_PLAYER_RESTRICTION_FLAGS:(<<= 1) {

    eprf_Caps = 1,
    eprf_Muted
};
new E_PLAYER_RESTRICTION_FLAGS:PlayerRestrict[MAX_PLAYERS];

enum {

    /*
    *
    *   Connection phases
    *
    */

    PHASE_ESTABLISH_CONNECTION,
    PHASE_VALIDATE_CONNECTION,
    PHASE_VALIDATE_ACCOUNT,
    PHASE_ENTER_GAME,

    /*
    *
    *   Disconnect reasons
    *
    */

    DISCONNECT_REASON_UNKNOWN,
    DISCONNECT_REASON_TIMEOUT,
    DISCONNECT_REASON_RESTART,
    DISCONNECT_REASON_KICKBAN,
    DISCONNECT_REASON_QUIT
};

/*
*
*       Global player variables
*
*/

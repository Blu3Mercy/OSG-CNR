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

#include <YSI\y_hooks>

/*
*
*   Player module: chat.pwn
*
*/

hook OnPlayerText(playerid, text[]) {

    if(IsPlayerNPC(playerid) || BitFlag_Get(PlayerFlags[playerid], epf_LoggedIn)) {

        return false;
    }
    if(BitFlag_Get(PlayerRestrict[playerid], eprf_Muted)) {

        new
            second = Player[playerid][epd_MutedTime];

        Player_SendTaggedMessage(playerid, TYPE_ERROR, "You are muted for %d seconds.", second);
    }

    /*

    if(text[0] == '!' && Player_IsAdmin(playerid)) {
    
        // Make it possible to run admin commands like this
    }

    */

    // Restrictions:
    if(BitFlag_Get(PlayerRestrict[playerid], eprf_Caps)) {

        // Use as a function argument, not as an individual function:
        // String_ConvertToLower(text);

        SendFormattedMessageToAll(COLOR_WHITE, "%P: %s", playerid, String_ConvertToLower(text));
        return false;
    }
    return true;
}

String_ConvertToLower(string[]) {

    // using 'string' doesn't work
    new
        loweredString[145];

    strcat(loweredString, string);
    for(new i = strlen(loweredString); --i > -1;) {

        loweredString[i] |= 0x20;
    }
    return loweredString;
}

/*Admin_IsACommand(cmdtext[]) {

    for(new i, j = sizeof(gArr_AdminCommands); i < j; i++) {

        if(!strcmp(cmdtext, gArr_AdminCommands[i][eacd_Name])) {

            return true;
        }
    }
    return false;
}*/
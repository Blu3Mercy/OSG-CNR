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
*   Shops module: shops_load.pwn
*
*/

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {

    if(MF_KEY_PRESSED(KEY_YES)) {

        new
            shopid = Player_IsInRangeOfShop(playerid);

        if(shopid != -1) {

            SetPlayerPos(playerid, gArr_Shops[shopid][esd_IntX], gArr_Shops[shopid][esd_IntY], gArr_Shops[shopid][esd_IntZ]);
            SetPlayerInterior(playerid, gArr_Shops[shopid][esd_Interior]);
        }
    }
    if(MF_KEY_PRESSED(KEY_NO)) {

        new
            shopid = Player_IsInRangeOfShop(playerid, false);

        if(shopid != -1) {

            SetPlayerPos(playerid, gArr_Shops[shopid][esd_ExitX], gArr_Shops[shopid][esd_ExitY], gArr_Shops[shopid][esd_ExitZ]);
            SetPlayerInterior(playerid, 0);
        }
    }
    return true;
}

Player_IsInRangeOfShop(playerid, entrance = true) {

    for(new i = 0, j = sizeof(gArr_Shops); i < j; i++) {

        if(entrance) {

            if(IsPlayerInRangeOfPoint(playerid, 2.0, gArr_Shops[i][esd_ExitX], gArr_Shops[i][esd_ExitY], gArr_Shops[i][esd_ExitZ])) {

                return i;
            }
        }
        else {

            // exit
            if(IsPlayerInRangeOfPoint(playerid, 2.0, gArr_Shops[i][esd_IntX], gArr_Shops[i][esd_IntY], gArr_Shops[i][esd_IntZ])) {

                return i;
            }
        }
    }
    return -1;
}
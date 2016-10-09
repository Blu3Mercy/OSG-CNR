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

#include <YSI\y_hooks>

/*
*
*	Shops module: shops_load.pwn
*
*/

hook OnGameModeInit() {

	Shops_Load();
}

Shops_Load() {

	Shops_LoadMapIcons();
	return true;
}

Shops_LoadMapIcons() {

	for(new i = 0, j = sizeof(gArr_Shops); i < j; i ++) {

		CreateDynamicMapIcon(gArr_Shops[i][esd_MapIconX], gArr_Shops[i][esd_MapIconY], gArr_Shops[i][esd_MapIconZ], gArr_Shops[i][esd_MapIcon], -1, -1, -1, -1, 500.0);
		
		// Enter pickup model
		CreateDynamicPickup(gArr_Shops[i][esd_PickupModel], gArr_Shops[i][esd_PickupType], gArr_Shops[i][esd_ExitX], gArr_Shops[i][esd_ExitY], gArr_Shops[i][esd_ExitZ]);

		// Exit pickup model
		CreateDynamicPickup(gArr_Shops[i][esd_PickupModel], gArr_Shops[i][esd_PickupType], gArr_Shops[i][esd_IntX], gArr_Shops[i][esd_IntY], gArr_Shops[i][esd_IntZ], 0, gArr_Shops[i][esd_Interior]);
	}
	return true;
}
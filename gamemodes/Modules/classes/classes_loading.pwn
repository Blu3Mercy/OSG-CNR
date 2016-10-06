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
*		Classes module: classes_load.pwn
*
*/

#include <YSI\y_hooks>

/*
*
*		Script
*
*/

hook OnGameModeInit() {

	Classes_Load();
}

Classes_Load() {

	for(new i = 0, j = sizeof(gArr_Classes); i < j; i ++) {

		AddPlayerClass(0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);
	}
	return true;
}

Player_ShowClasses(playerid) {

	/*
	*
	*		Shows all appropriate classes for the given playerid
	*		This includes: VIP classes when the player is VIP
	*		EXP-oriented classes, i.e.: a class that requires 1,000 XP
	*
	*
	*/

	// sizeof(gArr_Classes) is equal to MAX_CLASSES if the user doesn't forget to update the define
	for(new i = sizeof(gArr_Classes); --i > -1;) {
		
		if((Player[playerid][epd_Experience] <= Class_GetRequiredEXP(i)) && (Class_IsVIPClass(i) && !BitFlag_Get(PlayerFlags[playerid], epf_VIP))) {

			// Player experience is not enough or player is not a vip but the class is for vips
			Class_HideForPlayer(i, playerid);
		}
		// If the player has the required EXP and is a VIP or the class isn't a VIP:
		Class_ShowForPlayer(i, playerid);
	}
	return true;
}

Class_GetRequiredEXP(classid) {

	return gArr_Classes[classid][escd_Experience];
}

Class_IsVIPClass(classid) {

	return gArr_Classes[classid][escd_IsVIP];
}

Class_HideForPlayer(classid, playerid) {

	Player[playerid][epd_ClassVisible][classid] = false;
	return true;
}

Class_ShowForPlayer(classid, playerid) {

	Player[playerid][epd_ClassVisible][classid] = true;
	return true;
}

Class_IsVisibleForPlayer(classid, playerid) {

	return Player[playerid][epd_ClassVisible][classid];
}

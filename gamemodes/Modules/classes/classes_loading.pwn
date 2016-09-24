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

/*Player_ShowClasses(playerid, experience = 0, bool:IsVIP = false) {

	*
	*
	*		Shows all appropriate classes for the given playerid
	*		This includes: VIP classes when the player is VIP
	*		EXP-oriented classes, i.e.: a class that requires 1,000 XP
	*
	*
	*

	for(new i = sizeof(gArr_Classes); --i > -1;) {

		if(experience <= Class_GetRequiredEXP(i)) {


		}
		if(Class_IsVIPClass(i) && BitFlag_Get(PlayerFlags[playerid], epf_VIP)) {

			Class_
		}
	}
	// Default classes

	return true;
}

Class_GetRequiredEXP(classid) {

	return gArr_Classes[classid][escd_Experience];
}

Class_IsVIPClass(classid) {

	return gArr_Classes[classid][escd_IsVIP];
}*/
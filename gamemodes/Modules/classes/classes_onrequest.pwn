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
*		Classes module: classes_onrequest.pwn
*
*/

#include <YSI\y_hooks>

/*
*
*		Script
*
*/

hook OnPlayerRequestClass(playerid, classid) {

	new
		classLoc = random(sizeof(gArr_ClassesEnvironment));

	if(!IsPlayerNPC(playerid) && Player_LoggedIn(playerid)) {

		PlayerPlaySound(playerid, 1097, 0.0, 0.0, 0.0);

		// Validate class
		Player_ClassValidate(playerid, classid);

		new
			currClass = Player[playerid][epd_CurrentClass];

		SetPlayerSkin(playerid, gArr_Classes[currClass][escd_SkinID]);
		SetPlayerPos(playerid, gArr_ClassesEnvironment[classLoc][eced_X], gArr_ClassesEnvironment[classLoc][eced_Y], gArr_ClassesEnvironment[classLoc][eced_Z]);
		SetPlayerFacingAngle(playerid, gArr_ClassesEnvironment[classLoc][eced_A]);

		SetPlayerCameraLookAt(playerid, gArr_ClassesEnvironment[classLoc][eced_X], gArr_ClassesEnvironment[classLoc][eced_Y], gArr_ClassesEnvironment[classLoc][eced_Z]);
		SetPlayerCameraPos(playerid, 
							gArr_ClassesEnvironment[classLoc][eced_X] + (5 * floatsin(-gArr_ClassesEnvironments[classLoc][eced_A], degrees)),
							gArr_ClassesEnvironment[classLoc][eced_Y] + (5 * floatcos(-gArr_ClassesEnvironments[classLoc][eced_A], degrees)),
							gArr_ClassesEnvironment[classLoc][eced_Z]
						);
	}
	return true;
}

Player_CLassValidate(playerid, classid, max_classes = (sizeof(gArr_Classes) - 1)) {

	new
		tempClass = classid;

	if(classid > max_classes) {

		// Reset the class selection when max_classes is exceeded
		tempClass = 0;
	}
	if(gArr_Classes[classid][escd_IsVIP] && !BitFlag_Get(Player[playerid], epf_IsVIP)) {

		// Go to the next class when the player has selected a VIP class but isn't VIP
		tempClass += 1;
	}
	if(gArr_Classes[classid][escd_Experience] > Player[playerid][epd_Experience]) {

		// Go to the next class when the player has selected an Experience class but doesn't have enough experience
		tempClass += 1;
	}
	if(tempClass != classid) {

		// Recursively redo the class checking
		Class_Validate(playerid, classid);
	}
	Player[playerid][epd_CurrentClass] = tempClass;
}

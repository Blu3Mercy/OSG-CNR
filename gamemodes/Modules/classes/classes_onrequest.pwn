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
			currClass = Player[playerid][epd_TempCurrentClass];

		SetPlayerSkin(playerid, gArr_Classes[currClass][escd_SkinID]);
		SetPlayerPos(playerid, gArr_ClassesEnvironment[classLoc][eced_X], gArr_ClassesEnvironment[classLoc][eced_Y], gArr_ClassesEnvironment[classLoc][eced_Z]);
		SetPlayerFacingAngle(playerid, gArr_ClassesEnvironment[classLoc][eced_A]);

		SetPlayerCameraLookAt(playerid, gArr_ClassesEnvironment[classLoc][eced_X], gArr_ClassesEnvironment[classLoc][eced_Y], gArr_ClassesEnvironment[classLoc][eced_Z]);
		SetPlayerCameraPos(playerid, gArr_ClassesEnvironment[classLoc][eced_X] + (5 * floatsin(-gArr_ClassesEnvironment[classLoc][eced_A], degrees)), gArr_ClassesEnvironment[classLoc][eced_Y] + (5 * floatcos(-gArr_ClassesEnvironment[classLoc][eced_A], degrees)), gArr_ClassesEnvironment[classLoc][eced_Z]);
	}
	return true;
}

Player_ClassValidate(playerid, classid, max_classes = (sizeof(gArr_Classes) - 1)) {

	new
		tempClass = classid;

	if(classid > max_classes) {

		// Reset the class selection when max_classes is exceeded
		tempClass = 0;
	}
	if(gArr_Classes[classid][escd_IsVIP] && !BitFlag_Get(PlayerFlags[playerid], epf_VIP)) {

		// Go to the next class when the player has selected a VIP class but isn't VIP
		tempClass += 1;
	}
	if(gArr_Classes[classid][escd_Experience] > Player[playerid][epd_Experience]) {

		// Go to the next class when the player has selected an Experience class but doesn't have enough experience
		tempClass += 1;
	}
	if(tempClass != classid) {

		// Recursively redo the class checking
		Player_ClassValidate(playerid, classid);
	}
	Player_SetTemporaryClass(playerid, tempClass);
}

hook OnPlayerRequestSpawn(playerid) {

	new
		tmpCurrentClass = Player[playerid][epd_TempCurrentClass];

	if(!IsPlayerNPC(playerid)) {

		if(GetPlayerScore(playerid) < ClassTemporary_GetRequiredEXP(tmpCurrentClass)) {

			return false;
		}
	}
	Player_SetCurrentClass(playerid, Player_GetTemporaryClass(playerid));
	Server_UpdateCNRCount(playerid);
	return true;
}

ClassTemporary_GetRequiredEXP(tmpCurrentClass) {

	return gArr_Classes[tmpCurrentClass][escd_Experience];
}

Server_UpdateCNRCount(playerid) {

	if(Player_GetCurrentClass(playerid) != CLASS_NULL) {

		if(ClassTemporary_LawEnforcement(playerid) && !ClassCurrent_LawEnforcement(playerid)) {

			Server_IncreaseStat(STAT_COP_COUNT, 1);
			Server_DecreaseStat(STAT_ROBBER_COUNT, 1);
		}
		else {

			Server_IncreaseStat(STAT_ROBBER_COUNT, 1);
			Server_DecreaseStat(STAT_COP_COUNT, 1);
		}
	}
	else {

		if(ClassTemporary_LawEnforcement(playerid)) {

			Server_IncreaseStat(STAT_COP_COUNT, 1);
		}
		else {

			Server_IncreaseStat(STAT_ROBBER_COUNT, 1);
		}
	}
}

Player_SetCurrentClass(playerid, classid) {

	Player[playerid][epd_CurrentClass] = classid;
}

Player_GetCurrentClass(playerid) {

	return Player[playerid][epd_CurrentClass];
}

Player_GetTemporaryClass(playerid) {

	return Player[playerid][epd_TempCurrentClass];
}

Player_SetTemporaryClass(playerid, classid) {

	Player[playerid][epd_TempCurrentClass] = classid;
}

ClassCurrent_LawEnforcement(playerid) {

	switch(Player[playerid][epd_CurrentClass]) {

		case CLASS_POLICE_OFFICER, CLASS_FBI, CLASS_SWAT, CLASS_CIA, CLASS_ARMY, CLASS_AIRPORT_GUARD: {
			
			return true;
		}
	}
	return false;
}

ClassTemporary_LawEnforcement(playerid) {

	switch(Player[playerid][epd_TempCurrentClass]) {

		case CLASS_POLICE_OFFICER, CLASS_FBI, CLASS_SWAT, CLASS_CIA, CLASS_ARMY, CLASS_AIRPORT_GUARD: {
			
			return true;
		}
	}
	return false;
}

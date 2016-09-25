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
*		Textdraw module: textdraw_creation.pwn
*
*/

#include <YSI\y_hooks>

/*
*
*		script
*
*/

/*hook OnGameModeInit() {

	Textdraw_CreateAll();
}

Textdraw_CreateAll() {


}*/

hook OnPlayerConnect(playerid) {

	Textdraw_CreateAllForPlayer(playerid);
}

Textdraw_CreateAllForPlayer(playerid) {

	PlayerTextdraw[playerid][eptd_InformationBox] = CreatePlayerTextDraw(playerid, 464.000000, 248.000000, "");
	PlayerTextDrawBackgroundColor(playerid, PlayerTextdraw[playerid][eptd_InformationBox], 255);
	PlayerTextDrawFont(playerid, PlayerTextdraw[playerid][eptd_InformationBox], 1);
	PlayerTextDrawLetterSize(playerid, PlayerTextdraw[playerid][eptd_InformationBox], 0.219999, 0.899999);
	PlayerTextDrawColor(playerid, PlayerTextdraw[playerid][eptd_InformationBox], -1);
	PlayerTextDrawSetOutline(playerid, PlayerTextdraw[playerid][eptd_InformationBox], 1);
	PlayerTextDrawSetProportional(playerid, PlayerTextdraw[playerid][eptd_InformationBox], 1);
	PlayerTextDrawUseBox(playerid, PlayerTextdraw[playerid][eptd_InformationBox], 1);
	PlayerTextDrawBoxColor(playerid, PlayerTextdraw[playerid][eptd_InformationBox], 153);
	PlayerTextDrawTextSize(playerid, PlayerTextdraw[playerid][eptd_InformationBox], 634.000000, 0.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerTextdraw[playerid][eptd_InformationBox], 0);
}
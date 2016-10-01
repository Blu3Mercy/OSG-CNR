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
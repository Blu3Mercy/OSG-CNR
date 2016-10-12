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
*       Player module: spawn.pwn
*
*/

hook OnPlayerSpawn(playerid) {

    Player_ResetGameStates(playerid);
    Player_GiveClassWeapons(playerid);
    return true;
}

Player_ResetGameStates(playerid) {

    Player_ResetWeapons(playerid);
    Player_SetWantedLevel(playerid, 0);
    Player_SetMoney(playerid, Player[playerid][epd_Money]);
    return true;
}

Player_GiveClassWeapons(playerid) {

    switch(Player[playerid][epd_Class]) {

        case CLASS_POLICE_OFFICER: {

            Player_GiveWeapon(playerid, 3, 1); // Night Stick
            Player_GiveWeapon(playerid, 22, 100); // Colt 45
            Player_GiveWeapon(playerid, 27, 100); // Combat Shotgun
            Player_GiveWeapon(playerid, 31, 100); // M4
        }
        case CLASS_FBI: {   
            Player_GiveWeapon(playerid, 23, 100); // Silenced Pistol
            Player_GiveWeapon(playerid, 27, 100); // Combat Shotgun
            Player_GiveWeapon(playerid, 30, 100); // AK-47
        }
        case CLASS_SWAT: {

            Player_GiveWeapon(playerid, 25, 100); // Combat Shotgun
            Player_GiveWeapon(playerid, 29, 100); // MP5
            Player_GiveWeapon(playerid, 31, 100); // M4
        }
        case CLASS_CIA: {

            Player_GiveWeapon(playerid, 24, 100); // Desert Eagle
            Player_GiveWeapon(playerid, 27, 100); // Combat Shotgun
            Player_GiveWeapon(playerid, 28, 100); // Uzi
            Player_GiveWeapon(playerid, 31, 100); // M4
        }
        case CLASS_ARMY: {

            Player_GiveWeapon(playerid, 24, 100); // Desert Eagle
            Player_GiveWeapon(playerid, 32, 100); // Tec-9
            Player_GiveWeapon(playerid, 31, 100); // M4
        }
        case CLASS_FIREFIGHTER: {

            Player_GiveWeapon(playerid, 8, 1); // Katana
            Player_GiveWeapon(playerid, 24, 100); // Desert Eagle
            Player_GiveWeapon(playerid, 42, 1000); // Extinguisher
        }
        case CLASS_PARAMEDIC: {

            Player_GiveWeapon(playerid, 5, 1); // Baseball Bat
            Player_GiveWeapon(playerid, 23, 100); // Silenced Pistol
            Player_GiveWeapon(playerid, 28, 100); // Uzi
        }
        case CLASS_MECHANIC: {

            Player_GiveWeapon(playerid, 15, 1); // Cane
            Player_GiveWeapon(playerid, 23, 100); // Silenced Pistol
            Player_GiveWeapon(playerid, 25, 100); // Shotgun
        }
        case CLASS_AMMUNATION_SALESMAN: {

            Player_GiveWeapon(playerid, 5, 1); // Baseball Bat
            Player_GiveWeapon(playerid, 23, 100); // Silenced Pistol
            Player_GiveWeapon(playerid, 30, 100); // AK-47
        }
        case CLASS_CONSTRUCTION_WORKER: {

            Player_GiveWeapon(playerid, 6, 1); // Shovel
            Player_GiveWeapon(playerid, 22, 100); // Colt 45
            Player_GiveWeapon(playerid, 25, 100); // Shotgun
        }
        case CLASS_AIRPORT_GUARD: {

            Player_GiveWeapon(playerid, 3, 1); // Night Stick
            Player_GiveWeapon(playerid, 23, 100); // Silenced Pistol
            Player_GiveWeapon(playerid, 31, 100); // M4
        }
        case CLASS_PIZZA_WORKER: {

            Player_GiveWeapon(playerid, 24, 100); // Desert Eagle
            Player_GiveWeapon(playerid, 28, 100); // Uzi
            Player_GiveWeapon(playerid, 30, 100); // AK-47
        }
        case CLASS_CLUCKIN_BELL_WORKER: {

            Player_GiveWeapon(playerid, 5, 1); // Baseball Bat
            Player_GiveWeapon(playerid, 30, 100); // AK-47
        }
        case CLASS_BURGERSHOT_WORKER: {

            Player_GiveWeapon(playerid, 22, 100); // Colt 45
            Player_GiveWeapon(playerid, 25, 100); // Shotgun
            Player_GiveWeapon(playerid, 30, 100); // AK-47
        }
        case CLASS_HOT_DOG_VENDOR: {

            Player_GiveWeapon(playerid, 23, 100); // Silenced Pistol
            Player_GiveWeapon(playerid, 25, 100); // Shotgun
            Player_GiveWeapon(playerid, 28, 100); // Uzi
        }
        case CLASS_BUS_DRIVER: {

            Player_GiveWeapon(playerid, 5, 1); // Baseball
            Player_GiveWeapon(playerid, 25, 100); // Shotgun
            Player_GiveWeapon(playerid, 29, 100); // MP5
        }
        case CLASS_TAXI_DRIVER: {

            Player_GiveWeapon(playerid, 23, 100); // Silenced Pistol
            Player_GiveWeapon(playerid, 28, 100); // Uzi
        }
        case CLASS_TRUCKER: {

            Player_GiveWeapon(playerid, 5, 1); // Baseball Bat
            Player_GiveWeapon(playerid, 24, 100); // Desert Eagle
            Player_GiveWeapon(playerid, 31, 100); // M4
        }
    }
    return true;
}

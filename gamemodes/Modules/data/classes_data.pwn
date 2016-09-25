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
*		Data module: classes_data.pwn
*
*/


// Credits to Kevin Marapao Reinke for the coordinates

enum {

	CLASS_NULL,
	CLASS_POLICE_OFFICER,
	CLASS_FBI,
	CLASS_SWAT,
	CLASS_CIA,
	CLASS_ARMY,
	CLASS_FIREFIGHTER,
	CLASS_PARAMEDIC,
	CLASS_MECHANIC,
	CLASS_AMMUNATION_SALESMAN,
	CLASS_CONSTRUCTION_WORKER,
	CLASS_AIRPORT_GUARD,
	CLASS_PIZZA_WORKER,
	CLASS_CLUCKIN_BELL_WORKER,
	CLASS_BURGERSHOT_WORKER,
	CLASS_HOT_DOG_VENDOR,
	CLASS_BUS_DRIVER,
	CLASS_TAXI_DRIVER,
	CLASS_TRUCKER,
	CLASS_BOXER,
	CLASS_KARATE_EXPERT,
	CLASS_STUNTER,
	CLASS_CIVILIAN,
	CLASS_PILOT
};

enum E_CLASS_ENVIRONMENT_DATA {

	Float:eced_X,
	Float:eced_Y,
	Float:eced_Z,
	Float:eced_A
};
new const gArr_ClassesEnvironment[][E_CLASS_ENVIRONMENT_DATA] = {

	{1743.237670, -1638.393676, 44.396755, 303.960815},
	{1276.083251, -1737.208740, 33.644104, 306.804290},
	{1329.847656, -1234.921386, 13.546875, 243.992095},
	{1042.005126, -1133.714843, 23.820327, 181.324569},
	{779.853393, -1166.218872, 22.626207, 98.267372},
	{513.651489, -1224.809936, 44.032375, 357.373107},
	{471.354125, -1376.478027, 36.570312, 338.764678},
	{398.848999, -1520.724731, 32.266296, 134.034515},
	{430.205566, -1824.748779, 5.363523, 176.021606},
	{375.836730, -2037.712402, 7.830090, 92.720909},
	{149.860061, -1944.892211, 3.773437, 55.457286},
	{1473.503784, -1403.958984, 46.742187, 181.081924},
	{1581.787963, -1081.340087, 24.298091, 127.814826},
	{1584.240844, 8.669057, 22.616092, 104.338180},
	{1943.188842, 704.140319, 11.132812, 357.514160},
	{1995.160400, 978.770141, 10.820312, 89.345069},
	{2106.943115, 999.993591, 10.989136, 179.296386},
	{2081.248535, 1168.480834, 10.820312, 63.698257},
	{2148.872802, 1296.003051, 17.083412, 77.485130},
	{2022.087158, 1342.922607, 10.812978, 271.126983},
	{2023.745117, 1545.480957, 10.819645, 270.547027},
	{2145.970214, 1681.910522, 10.820312, 269.630523},
	{2163.682373, 1804.700561, 11.000000, 180.642562},
	{2109.668945, 1916.766845, 10.820312, 276.280731},
	{1785.950927, 2840.272216, 10.835937, 314.217956},
	{2483.768066, 919.588806, 10.820312, 89.579399},
	{726.166503, 730.883911, 28.014823, 212.070602},
	{-440.822723, 613.665771, 16.718750, 233.040771},
	{-1491.583618, 779.349731, 7.185316, 90.786163},
	{-1657.334350, 619.523681, 24.655361, 139.039886},
	{-1734.536621, 595.071350, 24.880569, 359.628845},
	{-1963.534057, 486.792449, 35.171875, 91.122917},
	{-2026.289794, 146.564575, 28.835937, 271.267852},
	{-2315.039550, 101.657821, 35.398437, 51.932685},
	{-2283.536621, 222.444107, 35.311504, 38.145919},
	{-2614.585205, 521.041564, 48.656250, 221.134353},
	{-2629.920898, 731.570434, 39.445312, 226.919418},
	{1953.514038, -1179.000610, 20.023437, 39.648292},
	{1414.842285, 736.591491, 11.031047, 91.590263},
	{1010.291503, 1173.900024, 10.820312, 25.229377},
	{1383.002807, 2184.473632, 11.023437, 315.690612},
	{681.168579, 1193.575073, 12.011127, 105.129287},
	{-672.441101, 922.983703, 12.138488, 271.245056},
	{-643.423034, 867.392150, 2.000000, 45.979763},
	{-2395.554443, -236.321777, 40.029605, 12.683300},
	{-2475.256347, -307.014343, 41.466964, 46.523609}
};

enum E_CLASSES_DATA {

	escd_TeamName[50],
	escd_Name[50],
	escd_SelectionText[144],
	escd_Color,
	escd_SkinID,
	escd_Class,
	escd_FFT,
	escd_Experience,
	bool:escd_IsVIP
};
new const gArr_Classes[][E_CLASSES_DATA] = {

	{ "Police Officer",					"Eddie Pulaski",		"Police Officer~n~~w~~h~Eddie Pulaski",					COLOR_POLICE_OFFICER, 		266, 	CLASS_POLICE_OFFICER, 		1,			0,		false },
	{ "Police Officer",					"Frank Tenpenny",		"Police Officer~n~~w~~h~Frank Tenpenny",				COLOR_POLICE_OFFICER, 		265, 	CLASS_POLICE_OFFICER, 		1,			0,		false },
	{ "Police Officer",					"Jimmy Hernandez",		"Police Officer~n~~w~~h~Jimmy Hernandez",				COLOR_POLICE_OFFICER, 		267, 	CLASS_POLICE_OFFICER, 		1,			0,		false },
	{ "Police Officer",					"Johnny Adams",			"Police Officer~n~~w~~h~Johnny Adams",					COLOR_POLICE_OFFICER, 		284, 	CLASS_POLICE_OFFICER, 		1,			0,		false },
	{ "Police Officer",					"Freddy Roberts",		"Police Officer~n~~w~~h~Freddy Roberts",				COLOR_POLICE_OFFICER, 		288, 	CLASS_POLICE_OFFICER, 		1,			0,		false },
	{ "Police Officer",					"Grace Justice",		"Police Officer~n~~w~~h~Grace Justice",					COLOR_POLICE_OFFICER, 		211, 	CLASS_POLICE_OFFICER, 		1,			0,		false },
	{ "Police Officer",					"Faith Morin",			"Police Officer~n~~w~~h~Faith Morin",					COLOR_POLICE_OFFICER, 		93, 	CLASS_POLICE_OFFICER, 		1,			0,		false },
	{ "Police Officer",					"Darin Rendon",			"Police Officer~n~~w~~h~Darin Rendon",					COLOR_POLICE_OFFICER, 		300, 	CLASS_POLICE_OFFICER, 		1,			0,		false },
	{ "Police Officer",					"Fidel Wilt",			"Police Officer~n~~w~~h~Fidel Wilt",					COLOR_POLICE_OFFICER, 		301, 	CLASS_POLICE_OFFICER, 		1,			0,		false },
	{ "Police Officer",					"Jeremy Ponce",			"Police Officer~n~~w~~h~Jeremy Ponce",					COLOR_POLICE_OFFICER, 		302, 	CLASS_POLICE_OFFICER, 		1,			0,		false },
	{ "Police Officer",					"Addie Lebron",			"Police Officer~n~~w~~h~Addie Lebron",					COLOR_POLICE_OFFICER, 		306, 	CLASS_POLICE_OFFICER, 		1,			0,		false },
	{ "Police Officer",					"Bea Jennings",			"Police Officer~n~~w~~h~Bea Jennings",					COLOR_POLICE_OFFICER, 		307, 	CLASS_POLICE_OFFICER, 		1,			0,		false },
	{ "Police Officer",					"Dulce Horner",			"Police Officer~n~~w~~h~Dulce Horner",					COLOR_POLICE_OFFICER, 		308, 	CLASS_POLICE_OFFICER, 		1,			0,		false },
	{ "Police Officer",					"Jen Quintana",			"Police Officer~n~~w~~h~Jen Quintana",					COLOR_POLICE_OFFICER,		309, 	CLASS_POLICE_OFFICER, 		1,			0,		false },
	{ "Police Officer",					"Jagger Dahl",			"Police Officer~n~~w~~h~Jagger Dahl",					COLOR_POLICE_OFFICER, 		310, 	CLASS_POLICE_OFFICER, 		1,			0,		false },
	{ "Police Officer",					"Skylar Utley",			"Police Officer~n~~w~~h~Skylar Utley",					COLOR_POLICE_OFFICER, 		311, 	CLASS_POLICE_OFFICER, 		1,			0,		false },
	{ "F.B.I."							"Jorge Thomas",			"F.B.I.~n~~w~~h~Jorge Thomas",							COLOR_FBI,					286, 	CLASS_FBI, 					1,			0,		false },
	{ "S.W.A.T",						"Sam Anderson",			"S.W.A.T.~n~~w~~h~Sam Anderson",						COLOR_SWAT,					285, 	CLASS_SWAT, 				1,			0,		false },
	{ "C.I.A.",							"Bruno Thompson",		"C.I.A.~n~~w~~h~Bruno Thompson",						COLOR_CIA,					164, 	CLASS_CIA, 					1,			0,		false },
	{ "C.I.A.",							"Adam Craft",			"C.I.A.~n~~w~~h~Adam Craft",							COLOR_CIA,					163, 	CLASS_CIA, 					1,			0,		false },
	{ "C.I.A.",							"Cooper Clemons",		"C.I.A.~n~~w~~h~Cooper Clemons",						COLOR_CIA,					165, 	CLASS_CIA, 					1,			0,		false },
	{ "C.I.A.",							"Justin Chaney",		"C.I.A.~n~~w~~h~Justin Chaney",							COLOR_CIA,					166, 	CLASS_CIA, 					1,			0,		false },
	{ "Army Officer",					"Robert Young",			"Army Officer~n~~w~~h~Robert Young",					COLOR_ARMY,					287, 	CLASS_ARMY, 				1,			0,		false },
	{ "Firefighter",					"Steve Baker",			"Firefighter~n~~w~~h~Steve Baker",						COLOR_FIREFIGHTER,			277, 	CLASS_FIREFIGHTER, 			255,		0,		false },
	{ "Paramedic",						"Oliver Howard",		"Paramedic~n~~w~~h~Oliver Howard",						COLOR_PARAMEDIC,			276, 	CLASS_PARAMEDIC, 			255,		0,		false },
	{ "Mechanic",						"Luke Green",			"Mechanic~n~~w~~h~Luke Green",							COLOR_MECHANIC,				50, 	CLASS_MECHANIC, 			255,		0,		false },
	{ "Ammu-nation Salesman",			"Jake Reed",			"Ammu-nation Sales-~n~man ~w~~h~- Jake Reed",			COLOR_AMMUNATION_SALESMAN,	179, 	CLASS_AMMUNATION_SALESMAN, 	255,		0,		false },
	{ "Construction Worker",			"Henry Taylor",			"Construction Wor-~n~ker ~w~~h~- Henry Taylor",			COLOR_CONSTRUCTION_WORKER,	27, 	CLASS_CONSTRUCTION_WORKER, 	255,		0,		false },
	{ "Airport Guard",					"Isaac Brown",			"Airport Guard~n~~w~~h~Isaac Brown",					COLOR_AIRPORT_GUARD,		71, 	CLASS_AIRPORT_GUARD, 		255,		0,		false },
	{ "Well Stacked Pizza Worker",		"Andrew Moore",			"Well Stacked Pizza Wor-~n~ker ~w~~h~- Andrew Moore",	COLOR_PIZZA_WORKER,			155, 	CLASS_PIZZA_WORKER, 		255,		0,		false },
	{ "Cluckin' Bell Worker",			"Connor Miller",		"Cluckin' Bell Wor-~n~ker ~w~~h~- Connor Miller",		COLOR_CLUCKIN_BELL_WORKER,	167, 	CLASS_CLUCKIN_BELL_WORKER, 	255,		0,		false },
	{ "Burgershot Worker",				"Emma White",			"Burgershot Wor-~n~ker ~w~~h~- Emma White",				COLOR_BURGERSHOT_WORKER,	205, 	CLASS_BURGERSHOT_WORKER, 	255,		0,		false },
	{ "Hot Dog Vendor",					"William Robinson",		"Hot Dog Vendor~n~~w~~h~William Robinson",				COLOR_HOT_DOG_VENDOR,		168, 	CLASS_HOT_DOG_VENDOR, 		255,		0,		false },
	{ "Bus Driver",						"Nathan King",			"Bus Driver~n~~w~~h~Nathan King",						COLOR_BUS_DRIVER,			253, 	CLASS_BUS_DRIVER, 			255,		0,		false },
	{ "Taxi Driver",					"Jayden Clark",			"Taxi Driver~n~~w~~h~Jayden Clark",						COLOR_TAXI_DRIVER,			182, 	CLASS_TAXI_DRIVER, 			255,		0,		false },
	{ "Trucker",						"Max Brown",			"Trucker~n~~w~~h~Max Brown",							COLOR_TRUCKER,				34, 	CLASS_TRUCKER, 				255,		0,		false },
	{ "Trucker",						"Peter White",			"Trucker~n~~w~~h~Peter White",							COLOR_TRUCKER,				32, 	CLASS_TRUCKER, 				255,		0,		false },

	{ "Pilot",							"Jordan Brown",			"Pilot~n~~w~~h~Jordan Brown",							COLOR_PILOT, 				61, 	CLASS_PILOT, 				255,		0,		false },

	{ "Boxer",							"Wyatt Carter",			"Boxer~n~~w~~h~Wyatt Carter",							COLOR_BOXER, 				81, 	CLASS_BOXER, 				255,		0,		false },
	{ "Karate Expert",					"Joseph Murphy",		"Karate Expert~n~~w~~h~Joseph Murphy",					COLOR_KARATE_EXPERT, 		204, 	CLASS_KARATE_EXPERT, 		255,		0,		false },
	{ "Stunter",						"Owen Woods",			"Stunter~n~~w~~h~Owen Woods",							COLOR_STUNTER, 				18, 	CLASS_STUNTER, 				255,		0,		false },
	{ "Stunter",						"Ethan West",			"Stunter~n~~w~~h~Ethan West",							COLOR_STUNTER, 				45, 	CLASS_STUNTER, 				255,		0,		false },
	{ "Stunter",						"Aiden Webb",			"Stunter~n~~w~~h~Aiden Webb",							COLOR_STUNTER, 				96, 	CLASS_STUNTER, 				255,		0,		false },
	{ "Stunter",						"Logan Burns",			"Stunter~n~~w~~h~Logan Burns",							COLOR_STUNTER, 				97, 	CLASS_STUNTER, 				255,		0,		false },
	{ "Stunter",						"Elijah Rice",			"Stunter~n~~w~~h~Elijah Rice",							COLOR_STUNTER, 				146, 	CLASS_STUNTER, 				255,		0,		false },
	{ "Stunter",						"Noah Hart",			"Stunter~n~~w~~h~Noah Hart",							COLOR_STUNTER, 				154, 	CLASS_STUNTER, 				255,		0,		false },
	{ "Stunter",						"Liam Fox",				"Stunter~n~~w~~h~Liam Fox",								COLOR_STUNTER, 				252, 	CLASS_STUNTER, 				255,		0,		false },
	{ "Civilian",						"Carl Johnson",			"Civilian~n~~w~~h~Carl Johnson",						COLOR_CIVILIAN, 			0, 		CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Ryan Fields",			"Civilian~n~~w~~h~Ryan Fields",							COLOR_CIVILIAN, 			264, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Landon Carr",			"Civilian~n~~w~~h~Landon Carr",							COLOR_CIVILIAN, 			59, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Layla Meyer",			"Civilian~n~~w~~h~Layla Meyer",							COLOR_CIVILIAN, 			12, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Brooklyn Hines",		"Civilian~n~~w~~h~Brooklyn Hines",						COLOR_CIVILIAN, 			41, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Kendl Johnson",		"Civilian~n~~w~~h~Kendl Johnson",						COLOR_CIVILIAN, 			65, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Gavin Sharp",			"Civilian~n~~w~~h~Gavin Sharp",							COLOR_CIVILIAN, 			83, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Brayden Warner",		"Civilian~n~~w~~h~Brayden Warner",						COLOR_CIVILIAN, 			101, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Pancho Aguado",		"Civilian~n~~w~~h~Pancho Aguado",						COLOR_CIVILIAN, 			48, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Sarah Burgess",		"Civilian~n~~w~~h~Sarah Burgess",						COLOR_CIVILIAN, 			55, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Claire Mcgee",			"Civilian~n~~w~~h~Claire Mcgee",						COLOR_CIVILIAN, 			56, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Sadie Moss",			"Civilian~n~~w~~h~Sadie Moss",							COLOR_CIVILIAN, 			69, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Jordan Cohen",			"Civilian~n~~w~~h~Jordan Cohen",						COLOR_CIVILIAN, 			72, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Levi Blair",			"Civilian~n~~w~~h~Levi Blair",							COLOR_CIVILIAN, 			212, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Oliver Goodman",		"Civilian~n~~w~~h~Oliver Goodman",						COLOR_CIVILIAN, 			213, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Lilian Higgins",		"Civilian~n~~w~~h~Lilian Higgins",						COLOR_CIVILIAN, 			216, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Nora Stokes",			"Civilian~n~~w~~h~Nora Stokes",							COLOR_CIVILIAN, 			231, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Peyton Colon",			"Civilian~n~~w~~h~Peyton Colon",						COLOR_CIVILIAN, 			233, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Aaron Brock",			"Civilian~n~~w~~h~Aaron Brock",							COLOR_CIVILIAN, 			208, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Charles Poole",		"Civilian~n~~w~~h~Charles Poole",						COLOR_CIVILIAN, 			249, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Catalina Bowers",		"Civilian~n~~w~~h~Catalina Bowers",						COLOR_CIVILIAN, 			298, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Violet Phelps",		"Civilian~n~~w~~h~Violet Phelps",						COLOR_CIVILIAN, 			263, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Ariana Cortez",		"Civilian~n~~w~~h~Ariana Cortez",						COLOR_CIVILIAN, 			219, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Maccer Cain",			"Civilian~n~~w~~h~Maccer Cain",							COLOR_CIVILIAN, 			2, 		CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Andre Pitts",			"Civilian~n~~w~~h~Andre Pitts",							COLOR_CIVILIAN, 			3, 		CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Big Bear",				"Civilian~n~~w~~h~Big Bear",							COLOR_CIVILIAN, 			5, 		CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Bella Downs",			"Civilian~n~~w~~h~Bella Downs",							COLOR_CIVILIAN, 			10, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Serenity Vang",		"Civilian~n~~w~~h~Serenity Vang",						COLOR_CIVILIAN, 			9, 		CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Aubree Lindsay",		"Civilian~n~~w~~h~Aubree Lindsay",						COLOR_CIVILIAN, 			38, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Jethro Valencia",		"Civilian~n~~w~~h~Jethro Valencia",						COLOR_CIVILIAN, 			42, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Jeremiah Hyde",		"Civilian~n~~w~~h~Jeremiah Hyde",						COLOR_CIVILIAN, 			47, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Mila Puckett",			"Civilian~n~~w~~h~Mila Puckett",						COLOR_CIVILIAN, 			40, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Zoey Rocha",			"Civilian~n~~w~~h~Zoey Rocha",							COLOR_CIVILIAN, 			90, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Alison Whitley",		"Civilian~n~~w~~h~Abigail Whitley",						COLOR_CIVILIAN, 			31, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Cameron Burt",			"Civilian~n~~w~~h~Cameron Burt",						COLOR_CIVILIAN, 			32, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Thomas Byers",			"Civilian~n~~w~~h~Thomas Byers",						COLOR_CIVILIAN, 			34, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Colton Reach",			"Civilian~n~~w~~h~Colton Reach",						COLOR_CIVILIAN, 			35, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Sofia Bolton",			"Civilian~n~~w~~h~Sofia Bolton",						COLOR_CIVILIAN, 			76, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Autumn Dale",			"Civilian~n~~w~~h~Autumn Dale",							COLOR_CIVILIAN, 			77, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Austin Macias",		"Civilian~n~~w~~h~Austin Macias",						COLOR_CIVILIAN, 			78, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Jace Tyson",			"Civilian~n~~w~~h~Jace Tyson",							COLOR_CIVILIAN, 			147, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Brandon Pate",			"Civilian~n~~w~~h~Brandon Pate",						COLOR_CIVILIAN, 			170, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Josiah Slater",		"Civilian~n~~w~~h~Josiah Slater",						COLOR_CIVILIAN, 			107, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Zachary Merrill",		"Civilian~n~~w~~h~Zachary Merrill",						COLOR_CIVILIAN, 			102, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Parker Cote",			"Civilian~n~~w~~h~Parker Cote",							COLOR_CIVILIAN, 			109, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Blake Fry",			"Civilian~n~~w~~h~Blake Fry",							COLOR_CIVILIAN, 			116, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Jase Acevedo",			"Civilian~n~~w~~h~Jase Acevedo",						COLOR_CIVILIAN, 			137, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Chase Lott",			"Civilian~n~~w~~h~Chase Lott",							COLOR_CIVILIAN, 			111, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Jason Mccarty",		"Civilian~n~~w~~h~Jason Mccarty",						COLOR_CIVILIAN, 			29, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Lan Lee",				"Civilian~n~~w~~h~Lan Lee",								COLOR_CIVILIAN, 			49, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Bently Stein",			"Civilian~n~~w~~h~Bently Stein",						COLOR_CIVILIAN, 			230, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Billy Gagnon",			"Civilian~n~~w~~h~Billy Gagnon",						COLOR_CIVILIAN, 			200, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Adan Almanza",			"Civilian~n~~w~~h~Adan Almanza",						COLOR_CIVILIAN, 			70, 	CLASS_CIVILIAN, 			255,		0,		false },
	{ "Civilian",						"Dion Kaiser",			"Civilian~n~~w~~h~Dion Kaiser",							COLOR_CIVILIAN, 			188, 	CLASS_CIVILIAN, 			255,		0,		false }
};

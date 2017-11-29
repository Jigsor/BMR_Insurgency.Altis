// unattended_maintenance.sqf by Jigsor
// Routines performed by server when it has 0 players. Ex. cleanup and HC reset.

if (isServer) then {
	waitUntil {time > 128};

	private ["_remFog","_ctearFogThresh","_deacDelay","_czPosArrys","_ctearZones","_trees","_mpos","_justPlayers","_ctime","_waitTime","_update"];
	_remFog = FALSE;
	_deacDelay = ((DeAct_Gzone_delay * 60) + 120);
	if ((JIPweather isEqualTo 0) || {(JIPweather >3)}) then {_remFog = TRUE;};
	_czPosArrys = [];
	_ctearZones = Blu4_mkrs + ["Airfield"];

	{
		_mpos = getmarkerPos _x;
		_czPosArrys pushBack _mpos;
	} forEach _ctearZones;

	//Uncomment line below to use Headless client kick functionality
	//0 = [] execVM "\Server\HC_Reset.sqf"; // Server.cfg. allowedFilePatching=2 and -filePatching launch parameter maybe required.

	private "_resetHC";

	while {true} do {
		sleep 400.0123;

		// Clear Blufor base markers of fallen bushes and trees
		{
			_trees = nearestTerrainObjects [_x, ["TREE","SMALL TREE","BUSH"], 50, false];
			{if (damage _x isEqualTo 1) then {hideobject _x}} foreach _trees;
		} forEach _czPosArrys;

		if (isNil "_resetHC") then {_resetHC = true;};
		_justPlayers = allPlayers - entities "HeadlessClient_F";

		if (count _justPlayers isEqualTo 0) then {

			[_deacDelay] spawn {
				params ["_deacDelay","_toggle","_ctime","_waitTime","_justPlayers","_abandonedAI"];
				_toggle = server getVariable ["INS_UAMT", true];
				if (_toggle) then {
					_ctime = floor time;
					_waitTime = _ctime + _deacDelay;
					if (_waitTime < time) then {
						waitUntil {sleep 30; time > _waitTime};
					};
					_justPlayers = allPlayers - entities "HeadlessClient_F";
					if (count _justPlayers isEqualTo 0) then {

						//Disable Dust Storm if left running.
						if (missionNameSpace getVariable ["JDSactive", false]) then {[] call JIG_DustIsOn};

						//Delete Infantry AI recruits leftovers from diconnected players and zeus 
						_abandonedAI = allMissionObjects "CAManBase";
						{deleteVehicle _x} count (_abandonedAI select {(getNumber(configFile >> "CfgVehicles" >> typeOf _x >> "isUav")==0 && isNull objectParent _x) || (!(simulationEnabled (leader group _x)))});

						// Delete craters, ruins, non-Strategic objects, HEV halo pods + pod doors, Jets DLC canopys + ejection seats
						{
							if (count (allMissionObjects _x) > 0) then {
								{deleteVehicle _x} count (allMissionObjects _x);
							};
						} forEach ["Land_Sleeping_bag_F","Land_Sleeping_bag_blue_F","Land_Sleeping_bag_brown_F","B_Patrol_Respawn_tent_F","Respawn_TentDome_F","Respawn_TentA_F","CraterLong","CraterLong_small","Ruins","OPTRE_HEV","OPTRE_HEV_Door","Plane_Fighter_01_Canopy_F","B_Ejection_Seat_Plane_Fighter_01_F","rhs_k36d5_seat"];
						sleep 3;

						// Delete abandoned sandbags placed by medics.
						private _abandoned = allMissionObjects "Land_BagFence_Round_F";
						if (count _abandoned > 0) then {
							{
								if (_x getVariable "persistent") then {
									_abandoned = _abandoned - [_x];
								};
							} forEach _abandoned;
							{deleteVehicle _x} count _abandoned;
							sleep 3;
						};

						// Delete all mines beyond 500 meters away from objective position
						private _mines = allMines;
						if !(_mines isEqualTo []) then {
							{
								if ((_x distance objective_pos_logic) < 500) then {
									_mines = _mines - [_x];
								};
							} forEach _mines;
							{deleteVehicle _x} count _mines;
						};
						sleep 3;

						// Delete empty groups.
						{
							if ((count (units _x)) == 0) then {
								deleteGroup _x;
								_x = grpNull;
								_x = nil
							}
						} forEach allGroups;

						server setVariable ["INS_UAMT", false];
					}else{
						server setVariable ["INS_UAMT", true];
					};
				};
			};

			// Clear fog if for what ever reason fog accrued is above _clearFogThresh and JIPweather choice was 0 fog.
			if (_remFog) then {
				_clearFogThresh = 0.08;
				if (fog > _clearFogThresh) then {
					0 setFog 0;
					sleep 3;
				};
			};

			// Reset Headless Client.
			/*	//Will kick HCs once when no players exist and no zones active. As of A3 v1.66 HCs will not auto rejoin and resume!
				//Auto HC kick will not occur again until player(s) join then leave server and server is empty.
				//This is a preventative work-around not a fix for HC spawn bug that sometimes randomly occurs.
				//If bug occurs while server has players then HC will need to manually be restarted or kicked in order to resolve.

			if (_resetHC) then {
				if ((HC_1Present) || (HC_2Present)) then {
					if !(CCServerAdminPasswordCC isEqualTo "") then {// if server side script \Server\HC_Reset.sqf does its job then CCServerAdminPasswordCC will equal passwordAdmin from Server.cfg.
						if (Any_HC_present) then {
							_ctime = floor time;
							_waitTime = _ctime + _deacDelay;
							if (_waitTime < time) then {
								waitUntil {sleep 1; time > _waitTime};
							};

							_justPlayers = allPlayers - entities "HeadlessClient_F";
							if (count _justPlayers isEqualTo 0) then {
								//_update = false;
								//_update = [] call curr_EOSmkr_states_fnc;
								//waitUntil {_update};
								if (!isNil "HC_1") then {CCServerAdminPasswordCC serverCommand ("#kick " + "HC_1"); _resetHC = false;};
								if (!isNil "HC_2") then {CCServerAdminPasswordCC serverCommand ("#kick " + "HC_2"); _resetHC = false;};
								if !(_resetHC) then {
									Any_HC_present = false;
									publicVariable "Any_HC_present";
								};
							};
						};
					};
				};
			};
			*/

		}else{
			_resetHC = true;
			server setVariable ["INS_UAMT", true];
		};
	};
};

//if (!hasInterface && !isDedicated) then {execVM "scripts\HC_deleteEmptyGrps.sqf";};
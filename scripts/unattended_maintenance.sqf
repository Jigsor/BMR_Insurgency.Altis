// unattended_maintenance.sqf by Jigsor
// Routines performed by server when it has 0 players. Ex. cleanup and HC reset.

if (!isServer) exitWith {};
waitUntil {time > 128};

private ["_abandoned","_remFog","_clearFogThresh","_deacDelay","_justPlayers","_craters","_ctime","_waitTime","_update","_mines"];
_remFog = FALSE;
_deacDelay = ((DeAct_Gzone_delay * 60) + 120);
if ((JIPweather isEqualTo 0) || {(JIPweather >3)}) then {_remFog = TRUE;};

//Uncomment line below to use Headless client kick functionality
//0 = [] execVM "\Server\HC_Reset.sqf"; // Server.cfg. allowedFilePatching=2 and -filePatching launch parameter maybe required.

private "_resetHC";

while {true} do {
	sleep 400.0123;

	if (isNil "_resetHC") then {_resetHC = true;};
	_justPlayers = allPlayers - entities "HeadlessClient_F";

	if (count _justPlayers isEqualTo 0) then {

		// Delete all mines beyond 500 meters away from objective position
		_mines = allMines;
		if !(_mines isEqualTo []) then {
			{
				if ((_x distance objective_pos_logic) < 500) then {
					_mines = _mines - [_x];
				};
			} forEach _mines;
			{deleteVehicle _x} count _mines;
		};

		// Delete craters.
		_craters = allMissionObjects "CraterLong" + allMissionObjects "CraterLong_small";
		{deleteVehicle _x} count _craters;
		_craters = nil;
		sleep 3;

		// Delete static nonStrategic objects.
		{
			if (count (allMissionObjects _x) > 0) then {
				{deleteVehicle _x} count (allMissionObjects _x);
			};
		} forEach ["Land_Sleeping_bag_F","Land_Sleeping_bag_blue_F","Land_Sleeping_bag_brown_F","Respawn_TentDome_F"];
		sleep 3;

		// Delete abandoned sandbags placed by medics.
		_abandoned = allMissionObjects "Land_BagFence_Round_F";
		if (count _abandoned > 0) then {
			{
				if (_x getVariable "persistent") then {
					_abandoned = _abandoned - [_x];
				};
			} forEach _abandoned;
			{deleteVehicle _x} count _abandoned;
			sleep 3;
		};

		// Clear fog if for what ever reason fog accrued is above _clearFogThresh and JIPweather choice was 0 fog.
		if (_remFog) then {
			_clearFogThresh = 0.08;
			if (fog > _clearFogThresh) then {
				0 setFog 0;
				sleep 10;
			};
		};

		// Delete empty groups.
		{
			if ((count (units _x)) == 0) then {
				deleteGroup _x;
				_x = grpNull;
				_x = nil
			}
		} forEach allGroups;
		sleep 5;

		// Reset Headless Client.
		/*	//Will kick HCs once when no players exist and no zones active. Don't worry, HCs will auto rejoin and resume.
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
	};
};
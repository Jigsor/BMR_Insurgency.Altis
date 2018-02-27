// unattended_maintenance.sqf by Jigsor

if (!isServer) exitWith {};
waitUntil {time > 1};
sleep 128;

private _deacDelay = ((DeAct_Gzone_delay * 60) + 120);
private _czPosArrys = [];
private _ctearZones = Blu4_mkrs + ["Airfield"];
private _remFog = if (JIPweather isEqualTo 0 || {JIPweather >3}) then {TRUE} else {FALSE};
private "_mpos";

{
	_mpos = getmarkerPos _x;
	_czPosArrys pushBack _mpos;
} forEach _ctearZones;

while {true} do {
	sleep 400.0123;

	// Clear Blufor base markers of fallen bushes and trees
	{
		private _trees = nearestTerrainObjects [_x, ["TREE","SMALL TREE","BUSH"], 50, false];
		{if (damage _x isEqualTo 1) then {hideobject _x}} foreach _trees;
	} forEach _czPosArrys;
	sleep 3;

	// Delete empty groups.
	{
		if ((count (units _x)) == 0) then {
			deleteGroup _x;
			_x = grpNull;
			_x = nil
		}
	} forEach allGroups;

	private _justPlayers = allPlayers - entities "HeadlessClient_F";

	// Routines performed by server when it has 0 players. //
	if (count _justPlayers isEqualTo 0) then {

		[_deacDelay] spawn {
			params ["_deacDelay"];
			private _toggle = server getVariable ["INS_UAMT", true];
			if (_toggle) then {
				private _ctime = floor time;
				private _waitTime = _ctime + _deacDelay;
				if (_waitTime < time) then {
					waitUntil {sleep 30; time > _waitTime};
				};
				private _justPlayers = allPlayers - entities "HeadlessClient_F";
				if (count _justPlayers isEqualTo 0) then {

					// Disable Dust Storm if left running.
					if (missionNameSpace getVariable ["JDSactive", false]) then {call JIG_DustIsOn};

					// Delete Infantry AI recruits leftovers from diconnected players and zeus if any
					private _abandonedAI = allMissionObjects "CAManBase";
					{deleteVehicle _x} count (_abandonedAI select {(getNumber(configFile >> "CfgVehicles" >> typeOf _x >> "isUav")==0 && isNull objectParent _x) || (!(simulationEnabled (leader group _x)))});

					// Delete craters, ruins, non-Strategic objects, HEV halo pods + pod doors, Jets DLC canopys + ejection seats
					{
						if (count (allMissionObjects _x) > 0) then {
							{deleteVehicle _x} count (allMissionObjects _x);
						};
					} forEach ["Land_Sleeping_bag_F","Land_Sleeping_bag_blue_F","Land_Sleeping_bag_brown_F","B_Patrol_Respawn_tent_F","Respawn_TentDome_F","Respawn_TentA_F","CraterLong","CraterLong_small","Ruins","OPTRE_HEV","OPTRE_HEV_Door","Plane_Fighter_01_Canopy_F","Plane_CAS_01_Canopy_F","B_Ejection_Seat_Plane_Fighter_01_F","rhs_k36d5_seat","rhs_mi28_wing_right","rhs_mi28_wing_left"];
					sleep 2;

					// Delete abandoned sandbags placed by medics.
					private _abandoned = allMissionObjects "Land_BagFence_Round_F";
					if (count _abandoned > 0) then {
						{
							if (_x getVariable "persistent") then {
								_abandoned = _abandoned - [_x];
							};
						} forEach _abandoned;
						{deleteVehicle _x} count _abandoned;
						sleep 2;
					};

					// Delete all mines beyond 500 meters away from objective position
					{deleteVehicle _x} forEach (allMines select {((_x distance objective_pos_logic) > 500) && !(_x getVariable "persistent")});
					sleep 2;

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

	} else {
		server setVariable ["INS_UAMT", true];
	};
};
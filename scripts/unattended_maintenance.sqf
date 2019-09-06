// unattended_maintenance.sqf by Jigsor

if (!isServer) exitWith {};
waitUntil {time > 1};
if (isDedicated) then {
	enableEnvironment [false, false];
	setShadowDistance 0;
	//Work Around for inaccessible UAVS for players present at mission start (nonJIP)
	{{deletevehicle _x} count (allMissionObjects _x)} forEach INS_W_Serv_UAVs;//let them respawn
};
sleep 20;
{_x setDamage 0;} forEach (allMissionObjects "I_Heli_Transport_02_F"), (allMissionObjects "I_Heli_light_03_dynamicLoadout_F");// Work around for new bug since A3 1.78 - these helis incur damage at mission start and after recreated... wtf
{_x enableRopeAttach false;} forEach (vehicles select {_x isKindof "StaticWeapon"});

sleep 108;

private _czPosArrys = [];
private _ctearZones = Blu4_mkrs + ["Airfield"];
private "_mpos";
private _refreshOverCast = 0;
private _remFog = if (JIPweather isEqualTo 0 || {JIPweather >3}) then {TRUE} else {FALSE};
private _op4Check = !(INS_play_op4 in [0,99]);
private _w = INS_Blu_side;
private _pOp4 = INS_play_op4;

{
	_mpos = markerPos _x;
	_czPosArrys pushBack _mpos;
} forEach _ctearZones;

while {true} do {
	sleep 400.0123;

	// End mission for Opfor players if not enough blufor players.
	if (_op4Check && {playersNumber _w < _pOp4}) then {
		private _AllOp4Players=[];
		{_AllOp4Players pushBack _x} forEach (allPlayers select {side _x isEqualTo INS_Op4_side});
		private "_player";
		{
			_player = _x;
			[] remoteExec ["Playable_Op4_disabled",_player];
		} forEach _AllOp4Players;
		sleep 5;
	};

	// Clear Blufor base markers of fallen bushes and trees
	private "_trees";
	{
		_trees = nearestTerrainObjects [_x, ["TREE","SMALL TREE","BUSH"], 50, false];
		if !(_trees isEqualTo []) then {
			for "_i" from 0 to (count _trees - 1) step 1 do {
				_tree = _trees # 0;
				if ((damage _tree isEqualTo 1) && {!(isObjectHidden _tree)}) then {hideobjectGlobal _tree};
				_trees deleteAt 0;
			};
		};
		sleep 0.1;
	} forEach _czPosArrys;

	// Delete empty groups.
	{deleteGroup _x} forEach (allGroups select {local _x && {(count units _x) isEqualTo 0}});

	private _justPlayers = allPlayers - entities "HeadlessClient_F";

	// Routines performed by server when it has 0 players. //
	if (_justPlayers isEqualTo []) then {

		0 spawn {
			if (server getVariable ["INS_UAMT", true]) then {
				private _deacDelay = ((DeAct_Gzone_delay * 60) + 120);
				private _ctime = floor time;
				private _waitTime = _ctime + _deacDelay;
				if (_waitTime < time) then {
					waitUntil {sleep 30; time > _waitTime};
				};
				private _justPlayers = allPlayers - entities "HeadlessClient_F";
				if (_justPlayers isEqualTo []) then {

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
					} forEach ["Land_Sleeping_bag_F","Land_Sleeping_bag_blue_F","Land_Sleeping_bag_brown_F","Respawn_Sleeping_bag_F","Respawn_Sleeping_bag_brown_F","Respawn_Sleeping_bag_blue_F","B_Patrol_Respawn_tent_F","Respawn_TentDome_F","Respawn_TentA_F","CraterLong","CraterLong_small","Ruins","OPTRE_HEV","OPTRE_HEV_Door","Plane_Fighter_01_Canopy_F","Plane_Fighter_02_Canopy_F","Plane_Fighter_03_Canopy_F","Plane_Fighter_04_Canopy_F","Plane_CAS_01_Canopy_F","Plane_CAS_02_Canopy_F","B_Ejection_Seat_Plane_Fighter_01_F","I_Ejection_Seat_Plane_Fighter_04_F","O_Ejection_Seat_Plane_Fighter_02_F","O_Ejection_Seat_Plane_CAS_02_F","I_Ejection_Seat_Plane_Fighter_03_F","rhs_k36d5_seat","rhs_mi28_wing_right","rhs_mi28_wing_left","rhs_a10_acesII_seat","rhs_vs1_seat","CUP_B_Ejection_Seat_A10_USA","CUP_AV8B_EjectionSeat","CUP_AirVehicles_EjectionSeat"];
					sleep 2;

					// Delete abandoned sandbags placed by medics.
					private _abandoned = allMissionObjects "Land_BagFence_Round_F";
					if !(_abandoned isEqualTo []) then {
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
					
					// Delete sound objects created with say3D
					private _say3Dtrash = allMissionObjects "#soundonvehicle";
					{deleteVehicle _x} count _say3Dtrash;
					sleep 1;

					server setVariable ["INS_UAMT", false];
				}else{
					server setVariable ["INS_UAMT", true];
				};
			};
		};

		_refreshOverCast = _refreshOverCast + 1;
		if ((missionNameSpace getVariable ["JSSactive", false]) && {_refreshOverCast isEqualTo 7}) then {
			// Refresh Overcast if snow storm is on because it eventually gets blown away by wind.
			_refreshOverCast = 0;
			[] remoteExec ['INS_SnowOverCast'];
		} else {
			// Clear fog if for what ever reason fog accrued is above 0.08 and JIPweather choice was 0 fog.
			if (_remFog && {fog > 0.08}) then {
				0 setFog 0;
				sleep 3;
			};
		};

	} else {
		_refreshOverCast = 0;
		server setVariable ["INS_UAMT", true];
	};
};
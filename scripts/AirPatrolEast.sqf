// AirPatrolEast.sqf by Jigsor
// runs from init_server.sqf
// nul = [] execVM "scripts\AirPatrolEast.sqf";

if (!isServer) exitWith {};
waitUntil{!(isNil "BIS_fnc_init")};
waitUntil {time > 10};

private _airCenter = [] call RandomAirCenterOp4;

if (count _airCenter > 0) then
{
	air_pat_pos setPos _airCenter;
	sleep 0.1;
	private _mrkUpdate = false;
	_mrkUpdate = call Air_Dest_fnc;
	waitUntil {sleep 1; _mrkUpdate};

	airhunterE1 = ObjNull;
	airhunterE2 = ObjNull;
	private _ins_debug = if (DebugEnabled isEqualTo 1) then {TRUE}else{FALSE};

	if (_ins_debug) then {
		// show initial spawn position
		if !(getMarkerColor "curAEspawnpos" isEqualTo "") then {deleteMarker "curAEspawnpos";};
		private _currMkr = createMarker ["curAEspawnpos", getMarkerPos "spawnaire"];
		_currMkr setMarkerShape "ELLIPSE";
		"curAEspawnpos" setMarkerSize [2, 2];
		"curAEspawnpos" setMarkerShape "ICON";
		"curAEspawnpos" setMarkerType "mil_dot";//"Empty"
		"curAEspawnpos" setMarkerColor "colorOrange";
		"curAEspawnpos" setMarkerText "Initial Air Spawn";
		publicVariable "curAEspawnpos";
		sleep 2;
		private _eaLogicPos = getPos EastAirLogic;
		private _eaMkrPos = getMarkerPos "curAEspawnpos";
	};

	// Helicopter
	if ((EnableEnemyAir isEqualTo 1) || (EnableEnemyAir isEqualTo 3) ||	(EnableEnemyAir isEqualTo 4) ||	(EnableEnemyAir isEqualTo 6)) then
	{
		private _aire1 = [_ins_debug] spawn {
			params ["_debug","_delay","_loop"];
			if (isNil "INS_Op4_helis") then {INS_Op4_helis = ["O_Heli_Attack_02_black_F"]};
			if (INS_Op4_helis isEqualTo []) exitWith {};
			_delay = AirRespawnDelay;
			airhunterE1 = ObjNull;
			random_w_player2 = ObjNull;
			"airhunterE1" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
			"random_w_player2" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};

			for [{_loop=0}, {_loop<1}, {_loop=_loop}] do
			{
				if ((isNull airhunterE1) || (not(alive airhunterE1))) then {
					private ["_speed","_apeDir","_randAlts","_height","_randomTypes","_type","_vehicle","_veh","_vehgrp","_vel","_VarHunterName","_wp0","_spawnDir","_poscreate","_vehCrew"];

					sleep _delay;
					//call AirEast_move_logic_fnc;

					if (PatroleWPmode isEqualTo 1) then {
						random_w_player2 = ObjNull;
						publicVariable "random_w_player2";
						sleep 3;
						call find_me2_fnc;
						sleep 3;
						if (_debug) then {diag_log text format ["airhunterE1 West Human Target2: %1", random_w_player2];};
					};

					_poscreate = getMarkerPos "spawnaire";
					_speed = 65;
					_apeDir = getDir air_pat_east;
					_spawnDir = [getPosATL air_pat_east, getPosATL air_pat_pos] call BIS_fnc_dirTo;
					_randAlts = [70,80,90];
					_height = selectRandom _randAlts;
					_type = selectRandom INS_Op4_helis;

					_vehicle = [getPosATL air_pat_east, _apeDir, _type, EAST] call bis_fnc_spawnvehicle;
					sleep jig_tvt_globalsleep;
					_veh = _vehicle select 0;

					_vel = velocity _veh;
					_veh setpos [(_poscreate select 0) + (sin (_spawnDir -180)), (_poscreate select 1) + (cos (_spawnDir -180)), _height];
					_veh setVelocity [(_vel select 0)+(sin _apeDir*_speed),(_vel select 1)+(cos _apeDir*_speed),(_vel select 2)];

					_vehgrp = _vehicle select 2 ;// group of vehicle
					if (BTC_p_skill isEqualTo 1) then {[_vehgrp] call BTC_AI_init;};
					//_vehCrew = (group (crew _veh select 0)); {_x setVariable ["asr_ai_exclude",true];} foreach _vehCrew;

					_veh addeventhandler ["killed","[(_this select 0)] spawn remove_carcass_fnc"];
					{_x addeventhandler ["killed","[(_this select 0)] spawn remove_carcass_fnc"]} forEach (units _vehgrp);
					_veh addeventhandler ["HandleDamage", {if (((_this select 4) isKindOf "MissileCore") || ((_this select 4) isKindOf "rocketCore")) then { 1; } else { _this select 2; }; }];// Destroy This Air Vehicle With 1 Missile or Rocket

					_VarHunterName = "airhunterE1";
					_veh setVehicleVarName _VarHunterName;
					_veh Call Compile Format ["%1=_this; publicVariable '%1'",_VarHunterName];

					// Initial Waypoint
					_wp0 = _vehgrp addWaypoint [getPosATL air_pat_east, 200];
					_wp0 setWaypointType "MOVE";
					_wp0 setWaypointBehaviour "AWARE";
					_wp0 setWaypointCombatMode "GREEN";
					_wp0 setWaypointStatements ["true", ""];

					if (_debug) then {[airhunterE1] spawn {[airhunterE1] call air_debug_mkrs;};};

					if (!isNull random_w_player2) then {
						// Hunt Player / Seek and Destroy
						nul = [airhunterE1,5000,random_w_player2] call find_west_target_fnc;
					}else{
						// Guard Towns
						nul = [airhunterE1] call east_AO_guard_cycle_wp;
					};

					waitUntil {sleep 1; (!alive _veh) || ((count crew _veh) < 1) || (!canmove _veh)};
					if (((count crew _veh) < 1) && (alive _veh)) then {_veh setDamage 1};
					{
						if (alive _x) then {_x setDamage 1; sleep 0.1}
					} forEach (crew _veh);
					if (!alive _veh) then {
						{
							if (alive _x) then {_x setDamage 1; sleep 0.1}
						} forEach (units _vehgrp);
					};
					if (alive _veh) then {
						_veh setDamage 1;
						{
							if (alive _x) then {_x setDamage 1; sleep 0.1}
						} forEach (units _vehgrp);
					};
				};
				if (_debug) then {sleep 10;} else {sleep (3 + random 597);};
			};
		};
	};
	if (_ins_debug) then {sleep 10;} else {sleep (3 + random 597);};

	// Fixed Wing
	if ((EnableEnemyAir isEqualTo 2) || (EnableEnemyAir isEqualTo 3) || (EnableEnemyAir isEqualTo 5) || (EnableEnemyAir isEqualTo 6)) then
	{
		private _aire2 = [_ins_debug] spawn {
			params ["_debug","_delay","_loop"];
			if (isNil "INS_Op4_fixedWing") then {INS_Op4_fixedWing = ["I_Plane_Fighter_03_AA_F","I_Plane_Fighter_03_CAS_F","O_Plane_CAS_02_F"]};
			if (INS_Op4_fixedWing isEqualTo []) exitWith {};
			_delay = AirRespawnDelay;
			airhunterE2 = ObjNull;
			random_w_player3 = ObjNull;
			"airhunterE2" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
			"random_w_player3" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};

			for [{_loop=0}, {_loop<1}, {_loop=_loop}] do
			{
				if ((isNull airhunterE2) || (not(alive airhunterE2))) then {
					private ["_speed","_apeDir","_randAlts","_height","_randomTypes","_type","_vehicle","_veh","_vehgrp","_vel","_VarHunterName","_wp0","_spawnDir","_poscreate"];

					sleep _delay;
					//call AirEast_move_logic_fnc;

					if (PatroleWPmode isEqualTo 1) then {
						random_w_player3 = ObjNull;
						publicVariable "random_w_player3";
						sleep 3;
						call find_me3_fnc;
						sleep 3;
						if (_debug) then {diag_log text format ["airhunterE2 West Human Target3: %1", random_w_player3];};
					};

					_poscreate = getMarkerPos "spawnaire";
					_speed = 180;
					_apeDir = getDir air_pat_east;
					_spawnDir = [getPosATL air_pat_east, getPosATL air_pat_pos] call BIS_fnc_dirTo;
					_randAlts = [275,375,475,575];
					_height = selectRandom _randAlts;
					_type = selectRandom INS_Op4_fixedWing;

					_vehicle = [getPosATL air_pat_east, _apeDir, _type, EAST] call bis_fnc_spawnvehicle;
					sleep jig_tvt_globalsleep;
					_veh = _vehicle select 0;

					_vel = velocity _veh;
					_veh setpos [(_poscreate select 0) + (sin (_spawnDir -180)), (_poscreate select 1) + (cos (_spawnDir -180)), _height];
					_veh setVelocity [(_vel select 0)+(sin _apeDir*_speed),(_vel select 1)+(cos _apeDir*_speed),(_vel select 2)];

					_vehgrp = _vehicle select 2 ;
					if (BTC_p_skill isEqualTo 1) then {[_vehgrp] call BTC_AI_init;};

					_veh addeventhandler ["killed","[(_this select 0)] spawn remove_carcass_fnc"];
					{_x addeventhandler ["killed","[(_this select 0)] spawn remove_carcass_fnc"]} forEach (units _vehgrp);
					_veh addeventhandler ["HandleDamage", {if (((_this select 4) isKindOf "MissileCore") || ((_this select 4) isKindOf "rocketCore")) then { 1; } else { _this select 2; }; }];// Destroy This Air Vehicle With 1 Missile or Rocket

					_VarHunterName = "airhunterE2";
					_veh setVehicleVarName _VarHunterName;
					_veh Call Compile Format ["%1=_this; publicVariable '%1'",_VarHunterName];

					// Initial Waypoint
					_wp0 = _vehgrp addWaypoint [getPosATL air_pat_east, 200];
					_wp0 setWaypointType "MOVE";
					_wp0 setWaypointBehaviour "AWARE";
					_wp0 setWaypointCombatMode "GREEN";
					_wp0 setWaypointStatements ["true", ""];

					if (_debug) then {[airhunterE2] spawn {[airhunterE2] call air_debug_mkrs;};};

					if (!isNull random_w_player3) then {
						// Hunt Player / Seek and Destroy
						nul = [airhunterE2,5000,random_w_player3] call find_west_target_fnc;
					}else{
						// Guard Towns
						nul = [airhunterE2] call east_AO_guard_cycle_wp;
					};

					waitUntil {sleep 1; (!alive _veh) || ((count crew _veh) < 1) || (!canmove _veh)};
					if (((count crew _veh) < 1) && (alive _veh)) then {_veh setDamage 1};
					{
						if (alive _x) then {_x setDamage 1; sleep 0.1}
					} forEach (crew _veh);
					if (!alive _veh) then {
						{
							if (alive _x) then {_x setDamage 1; sleep 0.1}
						} forEach (units _vehgrp);
					};
					if (alive _veh) then {
						_veh setDamage 1;
						{
							if (alive _x) then {_x setDamage 1; sleep 0.1}
						} forEach (units _vehgrp);
					};
				};
				if (_debug) then {sleep 10;} else {sleep (3 + random 597);};
			};
		};
	};
};
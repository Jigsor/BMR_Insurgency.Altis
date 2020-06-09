// AirPatrolEast.sqf by Jigsor
// runs from init_server.sqf
// execVM "scripts\AirPatrolEast.sqf";

if (!isServer) exitWith {};
waitUntil{!(isNil "BIS_fnc_init")};
waitUntil {time > 10};

private _airCenter = call RandomAirCenterOp4;

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
	if !(getMarkerColor "curAEspawnpos" isEqualTo "") then {deleteMarker "curAEspawnpos"};
	private _currMkr = createMarker ["curAEspawnpos", markerPos "spawnaire"];
	_currMkr setMarkerShape "ELLIPSE";
	"curAEspawnpos" setMarkerSize [2, 2];
	"curAEspawnpos" setMarkerShape "ICON";
	"curAEspawnpos" setMarkerType "mil_dot";//"Empty"
	"curAEspawnpos" setMarkerColor "ColorOrange";
	"curAEspawnpos" setMarkerText "Initial Air Spawn";
	publicVariable "curAEspawnpos";
	sleep 2;
	private _eaLogicPos = getPos EastAirLogic;
	private _eaMkrPos = markerPos "curAEspawnpos";
};

// Helicopter
if (EnableEnemyAir in [1,3,4,6]) then
{
	private _aire1 = [_ins_debug] spawn {
		params ['_debug'];
		if (isNil "INS_Op4_helis") then {INS_Op4_helis = ["O_Heli_Attack_02_black_F"]};
		if (INS_Op4_helis isEqualTo []) exitWith {};
		private _delay = AirRespawnDelay;
		airhunterE1 = ObjNull;
		random_w_player2 = ObjNull;
		"airhunterE1" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
		"random_w_player2" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};

		while {true} do
		{
			if ((isNull airhunterE1) || {!(alive airhunterE1)}) then {

				sleep _delay;
				//call AirEast_move_logic_fnc;

				if (PatroleWPmode isEqualTo 1) then {
					random_w_player2 = ObjNull;
					publicVariable "random_w_player2";
					sleep 3;
					call find_me2_fnc;
					sleep 3;
					if (_debug) then {diag_log text format ["airhunterE1 West Human Target2: %1", random_w_player2]};
				};

				private _poscreate = markerPos "spawnaire";
				private _speed = 65;
				private _apeDir = getDir air_pat_east;
				private _height = selectRandom [70,80,90];
				private _type = selectRandom INS_Op4_helis;

				private _vehicle = [getPosATL air_pat_east, _apeDir, _type, INS_Op4_side] call BIS_fnc_spawnVehicle;
				_vehicle params ["_veh","_vehCrew","_vehgrp"];

				private _spawnDir = _veh getDir air_pat_pos;
				_veh setdir _spawnDir;
				_veh setpos [(_poscreate # 0) + (sin (_spawnDir -180)), (_poscreate # 1) + (cos (_spawnDir -180)), _height];
				_veh setVelocityModelSpace [0, _speed, 0];

				if (BTC_p_skill isEqualTo 1) then {[_vehgrp] call BTC_AI_init;};
				//{_x setVariable ["asr_ai_exclude",true];} foreach _vehCrew;//ASR_AI does not affect air units
				_vehgrp setVariable ["lambs_Danger_disableGroupAI", true]; 

				_veh addeventhandler ["killed","[(_this select 0)] spawn remove_carcass_fnc"];
				{_x addeventhandler ["killed","[(_this select 0)] spawn remove_carcass_fnc"]} forEach (units _vehgrp);
				_veh addeventhandler ["HandleDamage", {if (((_this select 4) isKindOf "MissileCore") || ((_this select 4) isKindOf "rocketCore")) then { 1; } else { _this select 2; }; }];// Destroy This Air Vehicle With 1 Missile or Rocket
				_veh addEventHandler ["GetOut", {params ["","","_unit"]; _unit setDamage 1;}];

				private _VarHunterName = "airhunterE1";
				_veh setVehicleVarName _VarHunterName;
				_veh Call Compile Format ["%1=_this; publicVariable '%1'",_VarHunterName];

				// Initial Waypoint
				private _wp0 = _vehgrp addWaypoint [getPosATL air_pat_east, 200];
				_wp0 setWaypointType "MOVE";
				_wp0 setWaypointBehaviour "AWARE";
				_wp0 setWaypointCombatMode "GREEN";
				_wp0 setWaypointStatements ["true", ""];

				if (_debug) then {[airhunterE1] spawn air_debug_mkrs};

				if (!isNull random_w_player2) then {
					// Hunt Player / Seek and Destroy
					_nul = [airhunterE1,5000,random_w_player2] call find_west_target_fnc;
				}else{
					// Guard Towns
					_nul = [airhunterE1] call east_AO_guard_cycle_wp;
				};

				waitUntil {sleep 1; (!alive _veh) || ((count crew _veh) < 1) || (!canmove _veh)};
				if (((count crew _veh) < 1) && (alive _veh)) then {_veh setDamage 1};
				{
					if (alive _x) then {_x setDamage 1; sleep 0.1}
				} forEach _vehCrew;
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
if (EnableEnemyAir in [2,3,5,6]) then
{
	private _aire2 = [_ins_debug] spawn {
		params ['_debug'];
		if (isNil "INS_Op4_fixedWing") then {INS_Op4_fixedWing = ["I_Plane_Fighter_03_AA_F","I_Plane_Fighter_03_CAS_F","O_Plane_CAS_02_F","I_Plane_Fighter_04_F"]};
		if (INS_Op4_fixedWing isEqualTo []) exitWith {};
		private _delay = AirRespawnDelay;
		airhunterE2 = ObjNull;
		random_w_player3 = ObjNull;
		"airhunterE2" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
		"random_w_player3" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};

		while {true} do
		{
			if ((isNull airhunterE2) || {!(alive airhunterE2)}) then {

				sleep _delay;
				//call AirEast_move_logic_fnc;

				if (PatroleWPmode isEqualTo 1) then {
					random_w_player3 = ObjNull;
					publicVariable "random_w_player3";
					sleep 3;
					call find_me3_fnc;
					sleep 3;
					if (_debug) then {diag_log text format ["airhunterE2 West Human Target3: %1", random_w_player3]};
				};

				private _poscreate = markerPos "spawnaire";
				private _speed = 180;
				private _apeDir = getDir air_pat_east;
				private _height = selectRandom [275,375,475,575];
				private _type = selectRandom INS_Op4_fixedWing;

				private _vehicle = [getPosATL air_pat_east, _apeDir, _type, INS_Op4_side] call BIS_fnc_spawnVehicle;
				_vehicle params ["_veh","_vehCrew","_vehgrp"];

				private _spawnDir = _veh getDir air_pat_pos;
				_veh setdir _spawnDir;
				_veh setpos [(_poscreate # 0) + (sin (_spawnDir -180)), (_poscreate # 1) + (cos (_spawnDir -180)), _height];
				_veh setVelocityModelSpace [0, _speed, 0];

				if (BTC_p_skill isEqualTo 1) then {[_vehgrp] call BTC_AI_init;};
				_vehgrp setVariable ["lambs_Danger_disableGroupAI", true]; 

				_veh addeventhandler ["killed","[(_this select 0)] spawn remove_carcass_fnc"];
				{_x addeventhandler ["killed","[(_this select 0)] spawn remove_carcass_fnc"]} forEach (units _vehgrp);
				_veh addeventhandler ["HandleDamage", {if (((_this select 4) isKindOf "MissileCore") || ((_this select 4) isKindOf "rocketCore")) then { 1; } else { _this select 2; }; }];// Destroy This Air Vehicle With 1 Missile or Rocket
				_veh addEventHandler ["GetOut", {params ["","","_unit"]; _unit setDamage 1;}];

				_VarHunterName = "airhunterE2";
				_veh setVehicleVarName _VarHunterName;
				_veh Call Compile Format ["%1=_this; publicVariable '%1'",_VarHunterName];

				// Initial Waypoint
				private _wp0 = _vehgrp addWaypoint [getPosATL air_pat_east, 200];
				_wp0 setWaypointType "MOVE";
				_wp0 setWaypointBehaviour "AWARE";
				_wp0 setWaypointCombatMode "GREEN";
				_wp0 setWaypointStatements ["true", ""];

				if (_debug) then {[airhunterE2] spawn air_debug_mkrs};

				if (!isNull random_w_player3) then {
					// Hunt Player / Seek and Destroy
					_nul = [airhunterE2,5000,random_w_player3] call find_west_target_fnc;
				}else{
					// Guard Towns
					_nul = [airhunterE2] call east_AO_guard_cycle_wp;
				};

				waitUntil {sleep 1; (!alive _veh) || ((count crew _veh) < 1) || (!canmove _veh)};
				if (((count crew _veh) < 1) && (alive _veh)) then {_veh setDamage 1};
				{
					if (alive _x) then {_x setDamage 1; sleep 0.1}
				} forEach _vehCrew;
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
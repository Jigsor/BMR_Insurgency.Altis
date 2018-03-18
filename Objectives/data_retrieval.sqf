//data_retrieval.sqf by Jigsor

sleep 2;
params ["_startPos","_type"];
private ["_list","_nearZones","_buildingNear","_rnum","_uncaped_eos_mkrs","_ins_debug","_nearMkrs","_objmkr","_device","_veh_name","_VarName","_grp","_stat_grp","_tskW","_tskE","_tasktopicW","_tasktopicE","_taskdescW","_taskdescE","_sideWin","_rand","_nearBuildings","_selbuild","_nearBuildings","_posArray","_r","_n","_position","_pos","_clearPos","_buildObj","_bldgPos","_buildDir","_minClearZ","_b_pos","_c","_alt"];

_list = 1;
_nearZones = [];
_lift = true;
_buildingNear = false;
_alt = false;
_b_pos = nil;
_c = 0;
_minClearZ = 2;
_rnum = str(round (random 999));
_uncaped_eos_mkrs = all_eos_mkrs;
_ins_debug = if (DebugEnabled isEqualTo 1) then {TRUE}else{FALSE};

// Find nearest occupied grid zones
objective_pos_logic setPos _startPos;

{if (getMarkerColor _x == "ColorGreen") then {_uncaped_eos_mkrs = _uncaped_eos_mkrs - [_x];};} count _uncaped_eos_mkrs;
if ((count _uncaped_eos_mkrs) isEqualTo 0) exitWith {sleep 20; nul = [] execVM "Objectives\random_objectives.sqf";};//skip objective

_nearMkrs = [_uncaped_eos_mkrs,[],{objective_pos_logic distance (getMarkerPos _x)},"ASCEND"] call BIS_fnc_sortBy;

if (count _nearMkrs > 10) then {
	private ["_g","_m"];
	_g = 0;
	for "_i" from 0 to 9 step 1 do {
		_m = _nearMkrs select _g;
		_nearZones pushBack _m;
		_g = _g + 1;
	};
} else {
	_nearZones = _nearMkrs;
};
if (_ins_debug) then {diag_log text format["Retreve Data Nearest EOS Markers : %1", _nearZones];};

// find Building position to place terminal
//block based on ghst_PutinBuild.sqf by ghost
while {!_buildingNear && count _nearZones > 0} do {
	_rand = selectRandom _nearZones;
	_nearBuildings = [getMarkerPos _rand select 0, getMarkerPos _rand select 1] nearObjects ["HouseBase", 75];
	if (_ins_debug) then {diag_log text format["Retreve Data Near Buildings Iteration %1 : %2", _list, _nearBuildings];};

	if (!isNil "_nearBuildings" && {(count _nearBuildings > 0)}) then {
		_n = count _nearBuildings;
		_i = floor(random _n);
		_selbuild = (_nearBuildings select _i);
		_nearBuildings deleteAt _i;

		_posArray = _selbuild call fnc_ghst_build_positions;
		_r = floor(random count _posArray);
		_position = _posArray select _r;
		_posArray deleteAt _r;

		if (!isnil "_position") exitwith {
			if (_ins_debug) then {diag_log text format["Retreve Data Near Buildings Chosen building position : %1", _position];};
			_buildingNear = true;
		};
	};
	_list = _list + 1;
};

if (!_buildingNear) then {
	if (_ins_debug) then {diag_log text format["FAILED TO PLACE OBJECT : %1", _type];};
	_pos = [_startPos,[100,100]] call fnc_ghst_rand_position;
	_position = _pos findEmptyPosition[0, 20, _type];
};

_bldgPos = _position;

// find nearby clear area for defences
if ((_startPos distance _bldgPos) > 100) then {
	_pos = [_position,[100,100]] call fnc_ghst_rand_position;
	_clearPos = _pos findEmptyPosition [0, 20, "O_medic_F"];
} else {
	_clearPos = _startPos;
};
if (_ins_debug) then {diag_log text format["Clear Position Near Data Terminal : %1", _clearPos];};

// create data terminal
_device = createVehicle [_type, position air_pat_pos, [], 0, "CAN_COLLIDE"];

sleep jig_tvt_globalsleep;

_device setVariable["persistent",true];
missionNamespace setVariable ["datadownloadedby",4];

_veh_name = getText (configFile >> "cfgVehicles" >> (_type) >> "displayName");
_VarName = "Land_DataTerminal_Obj";
_device setVehicleVarName _VarName;
missionNamespace setVariable [_VarName,_device];
publicVariable _VarName;
sleep 3;

// place data terminal

_buildObj = nearestBuilding _bldgPos;
_buildDir = direction _buildObj;

_device allowdamage false;
_device setdir _buildDir;
_device setpos _bldgPos;
_device setVectorUp surfaceNormal position _device;
_device setVehiclePosition [getposATL _device,[''],0];
sleep 5;

if (count(lineIntersectsObjs [(getposASL _device), [(getposASL _device select 0),(getposASL _device select 1), ((getposASL _device select 2) + 2)]]) > 1) then {
	_device setVectorUp [0,0,1];

	while {(((lineIntersectsSurfaces [AGLToASL (getPosWorld _device), AGLToASL _bldgPos, objNull, objNull, true, 1, "FIRE"]) select 0 select 0 select 2) < 0.16) || (count(lineIntersectsObjs [(getposASL _device), [(getposASL _device select 0),(getposASL _device select 1), ((getposASL _device select 2) + _minClearZ)]]) > 1)} do {
		_device setPosatl [(position _device select 0), (position _device select 1), ((getPos _device select 2) + 0.1)];
		if (_minClearZ > 0.9) then {
			_minClearZ = _minClearZ - 0.1;
		}else{
			_minClearZ = 1.99;
			_device setPosatl [(position _device select 0), (position _device select 1), ((getPos _device select 2) + 0.2)];
		};

		_c = _c + 1;
		if (_c > 300) exitWith {_alt = true;};
		sleep 0.1;
	};
	if ((count(lineIntersectsObjs [(getposASL _device), [(getposASL _device select 0),(getposASL _device select 1), ((getposASL _device select 2) + 1.8)]]) > 1) || (_alt)) then {
		_b_pos = [_bldgPos, [50,50,0]] call fnc_ghst_rand_position;

		while {(isNil "_b_pos") || (isOnRoad _b_pos)} do {
			_b_pos = _bldgPos findEmptyPosition [2, 30, _type];
			sleep 0.2;
		};

		_device setPos _b_pos;
		_device setVectorUP (surfaceNormal [(getPosATL _device) select 0,(getPosATL _device) select 1]);
		_bldgPos = _b_pos;
		_buildObj = nearestBuilding _b_pos;
	};
};

[[_buildObj, false], "allowDamage", false] call BIS_fnc_MP;

objective_pos_logic setPos _bldgPos;

// create task marker
_objmkr = createMarker ["ObjectiveMkr", _bldgPos];
"ObjectiveMkr" setMarkerShape "ELLIPSE";
"ObjectiveMkr" setMarkerSize [2, 2];
"ObjectiveMkr" setMarkerShape "ICON";
"ObjectiveMkr" setMarkerType "mil_dot";
"ObjectiveMkr" setMarkerColor "ColorRed";
"ObjectiveMkr" setMarkerText "Data Terminal";

// create defenses
_grp = [_clearPos,10] call spawn_Op4_grp; sleep 3;
_handle=[_grp, position objective_pos_logic, 75] call BIS_fnc_taskPatrol;

_stat_grp = [_clearPos,4,5] call spawn_Op4_StatDef;

//add hold action
waitUntil {sleep 1; alive _device};
[] remoteExec ["Terminal_acction_MPfnc", ([0, -2] select isDedicated), true];

// create west task
_tskW = "tskW_destroy_device" + _rnum;
_tasktopicW = localize "STR_BMR_Tsk_topic_global_Retrieve_Intel";
_taskdescW = localize "STR_BMR_Tsk_desc_global_Retrieve_Intel";
[_tskW,_tasktopicW,_taskdescW,WEST,[],"created",_bldgPos] call SHK_Taskmaster_add;
sleep 5;

// create east task
_tskE = "tskE_defend_device" + _rnum;
_tasktopicE = localize "STR_BMR_Tsk_topic_global_Retrieve_Intel";
_taskdescE = localize "STR_BMR_Tsk_desc_global_Retrieve_Intel";
[_tskE,_tasktopicE,_taskdescE,EAST,[],"created",_bldgPos] call SHK_Taskmaster_add;

// Win/Loose
waitUntil {sleep 6; ((missionNamespace getVariable "datadownloadedby") < 3)};

_sideWin = missionNamespace getVariable "datadownloadedby";

[_device] spawn {params ["_obj"]; [_obj, 0] call BIS_fnc_DataTerminalAnimate;};

//west success / east fail
if (_sideWin isEqualTo 1) then {
	[_tskW, "succeeded"] call SHK_Taskmaster_upd;
	[_tskE, "failed"] call SHK_Taskmaster_upd;
} else {
//east success / west fail
	[_tskE, "succeeded"] call SHK_Taskmaster_upd;
	[_tskW, "failed"] call SHK_Taskmaster_upd;
};

// Clean up
"ObjectiveMkr" setMarkerAlpha 0;
sleep 90;

{deleteVehicle _x; sleep 0.1} forEach (units _grp),(units _stat_grp);
{deleteGroup _x} forEach [_grp, _stat_grp];
if (!isNull _device) then {deleteVehicle _device};
private _staticGuns = objective_pos_logic getVariable "INS_ObjectiveStatics";
{deleteVehicle _x} forEach _staticGuns;
deleteMarker "ObjectiveMkr";

// Initialize new objective
if (true) exitWith {sleep 20; nul = [] execVM "Objectives\random_objectives.sqf";};
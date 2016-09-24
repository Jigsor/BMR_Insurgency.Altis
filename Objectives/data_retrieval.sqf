//data_retrieval.sqf by Jigsor

sleep 2;
private ["_startPos","_type","_list","_nearZones","_buildingNear","_rnum","_uncaped_eos_mkrs","_ins_debug","_nearMkrs","_objmkr","_device","_veh_name","_VarName","_grp","_stat_grp","_tskW","_tskE","_tasktopicW","_tasktopicE","_taskdescW","_taskdescE","_sideWin","_rand","_nearBuildings","_selbuild","_nearBuildings","_posArray","_r","_n","_position","_pos","_clearPos","_buildObj","_bldgPos","_buildDir"];

_startPos = _this select 0;
_type = _this select 1;
_list = 1;
_nearZones = [];
_buildingNear = false;
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
	for "_i" from 0 to 9 do {
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
_buildObj = nearestBuilding _bldgPos;
_buildDir = direction _buildObj;
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

// find nearby clear area for defences
if ((_startPos distance _bldgPos) > 100) then {
	_pos = [_position,[100,100]] call fnc_ghst_rand_position;
	_clearPos = _pos findEmptyPosition [0, 20, "O_medic_F"];
} else {
	_clearPos = _startPos;
};
if (_ins_debug) then {diag_log text format["Clear Position Near Data Terminal : %1", _clearPos];};

// create data terminal
_device = createVehicle [_type, position air_pat_pos, [], 0, "None"];
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
_device allowdamage false;
_device setdir _buildDir;
_device setpos _bldgPos;
_device setVectorUp surfaceNormal position _device;

// create defenses
_grp = [_clearPos,10] call spawn_Op4_grp;
_handle=[_grp, position objective_pos_logic, 75] call BIS_fnc_taskPatrol;

_stat_grp = [_clearPos ,3] call spawn_Op4_StatDef;

//add hold action
waitUntil {sleep 1; alive _device};
[] remoteExec ["Terminal_acction_MPfnc", ([0, -2] select isDedicated), true];

// create west task
_tskW = "tskW_destroy_device" + _rnum;
_tasktopicW = localize "STR_BMR_Tsk_topic_global_Retrieve_Data";
_taskdescW = localize "STR_BMR_Tsk_desc_global_Retrieve_Data";
[_tskW,_tasktopicW,_taskdescW,WEST,[],"created",_bldgPos] call SHK_Taskmaster_add;
sleep 5;

// create east task
_tskE = "tskE_defend_device" + _rnum;
_tasktopicE = localize "STR_BMR_Tsk_topic_global_Retrieve_Data";
_taskdescE = localize "STR_BMR_Tsk_desc_global_Retrieve_Data";
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

{deleteVehicle _x; sleep 0.1} forEach (units _grp);
{deleteVehicle _x; sleep 0.1} forEach (units _stat_grp);
deleteGroup _grp;
deleteGroup _stat_grp;
{if (typeof _x in INS_Op4_stat_weps) then {deleteVehicle _x; sleep 0.1}} forEach (NearestObjects [objective_pos_logic, [], 50]);
if (!isNull _device) then {deleteVehicle _device; sleep 0.1;};
deleteMarker "ObjectiveMkr";

// Initialize new objective
if (true) exitWith {sleep 20; nul = [] execVM "Objectives\random_objectives.sqf";};
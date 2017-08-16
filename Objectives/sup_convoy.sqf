//sup_convoy.sqf by Jigsor

sleep 2;
private ["_newZone","_type","_VehPool","_rnum","_range","_randVeh","_veh","_objmkr","_cone","_VarName","_grp","_handle","_obj_leader","_stat_grp","_wp","_tskW","_tasktopicW","_taskdescW","_tskE","_tasktopicE","_taskdescE","_vehicle1","_newPos","_veh1","_vehicle2","_veh2","_vehicle3","_veh3","_vehicle4","_veh4","_handle1","_allVeh","_staticGuns"];

_newZone = _this select 0;
_type = _this select 1;
_VehPool = + INS_Op4_Veh_Support;
_rnum = str(round (random 999));
_range = 550;

_randVeh = {
	_veh = selectRandom _VehPool;
	if ((count _VehPool) > 1) then {
		_VehPool = _VehPool - [_veh];
	};
	_veh
};

/*
//Move Zone to Road
private ["_roadNear","_roadSegment","_roadDir"];
_roads = _newZone nearRoads 100;
if (count _roads > 0) then {
	_roadNear = true;
	_roadSegment = _roads select 0;
	_roadDir = direction _roadSegment;
	while {!isOnRoad _newZone} do {
	_roadPos = _newZone findEmptyPosition [2, 100, _type];
	sleep 0.2;
	};
	_newZone = _roadPos;
};
*/

objective_pos_logic setPos _newZone;

_objmkr = createMarker ["ObjectiveMkr", _newZone];
"ObjectiveMkr" setMarkerShape "ELLIPSE";
"ObjectiveMkr" setMarkerSize [2, 2];
"ObjectiveMkr" setMarkerShape "ICON";
"ObjectiveMkr" setMarkerType "mil_dot";
"ObjectiveMkr" setMarkerColor "ColorRed";
"ObjectiveMkr" setMarkerText "Supply Convoy";

// Spawn Objective center object
_cone = createVehicle [_type, _newZone, [], 0, "None"];//Vanilla
sleep jig_tvt_globalsleep;
_cone setVectorUp [0,0,1];
_cone enablesimulation false;
_cone hideObjectGlobal true;

// Spawn Objective enemy deffences
_grp = [_newZone,14] call spawn_Op4_grp; sleep 3;
_stat_grp = [_newZone,3,10] call spawn_Op4_StatDef;

_handle=[_grp, position objective_pos_logic, 75] call BIS_fnc_taskPatrol;

//Spawn Convoy
sconvoy_grp = createGroup INS_Op4_side;

_newPos = [getMarkerPos "ObjectiveMkr", 0, 50, 10, 0, 0.6, 0] call BIS_fnc_findSafePos;
_type = [] call _randVeh;
_vehicle1 = [_newPos, 0, _type, sconvoy_grp] call BIS_fnc_spawnvehicle;
sleep 1;
_veh1 = _vehicle1 select 0;

_newPos = [getMarkerPos "ObjectiveMkr", 5, 55, 10, 0, 0.6, 0] call BIS_fnc_findSafePos;
_type = [] call _randVeh;
_vehicle2 = [_newPos, 0, _type, sconvoy_grp] call BIS_fnc_spawnvehicle;
sleep 1;
_veh2 = _vehicle2 select 0;

_newPos = [getMarkerPos "ObjectiveMkr", 10, 60, 10, 0, 0.6, 0] call BIS_fnc_findSafePos;
_type = [] call _randVeh;
_vehicle3 = [_newPos, 0, _type, sconvoy_grp] call BIS_fnc_spawnvehicle;
sleep 1;
_veh3 = _vehicle3 select 0;

_newPos = [getMarkerPos "ObjectiveMkr", 15, 65, 10, 0, 0.6, 0] call BIS_fnc_findSafePos;
_type = [] call _randVeh;
_vehicle4 = [_newPos, 0, _type, sconvoy_grp] call BIS_fnc_spawnvehicle;
sleep 1;
_veh4 = _vehicle4 select 0;

_allVeh = [_veh1,_veh2,_veh3,_veh4];
{_x setDamage 0} forEach _allVeh;
{_x addeventhandler ["killed","[(_this select 0)] spawn remove_carcass_fnc"]} forEach (units sconvoy_grp);
{_x addeventhandler ["killed","[(_this select 0)] spawn remove_carcass_fnc"]} forEach _allVeh;

{[_x] call anti_collision} foreach _allVeh;
{_x setVariable["persistent",true]} foreach _allVeh;
{private _car = _x; _car allowCrewInImmobile true} forEach _allVeh;

// convoy movement
_handle1=[sconvoy_grp, position objective_pos_logic, _range] call Veh_taskPatrol_mod;
if (DebugEnabled > 0) then {[sconvoy_grp] spawn INS_Tsk_GrpMkrs;};

// create west task
_tskW = "tskW_destroy_convoy" + _rnum;
_tasktopicW = localize "STR_BMR_Tsk_topicW_dsc";
_taskdescW = localize "STR_BMR_Tsk_descW_dsc";
[_tskW,_tasktopicW,_taskdescW,WEST,[],"created",_newZone] call SHK_Taskmaster_add;
sleep 5;

// create east task
_tskE = "tskE_defend_convoy" + _rnum;
_tasktopicE = localize "STR_BMR_Tsk_topicE_dsc";
_taskdescE = localize "STR_BMR_Tsk_descE_dsc";
[_tskE,_tasktopicE,_taskdescE,EAST,[],"created",_newZone] call SHK_Taskmaster_add;

waitUntil {{alive _x} count units sconvoy_grp > 0};
sleep 0.1;

if (daytime > 3.00 && daytime < 5.00) then {[] spawn {[[], "INS_fog_effect"] call BIS_fnc_mp};};

// Only one outcome supported.
waitUntil {{alive _x} count units sconvoy_grp < 1};

[_tskW, "succeeded"] call SHK_Taskmaster_upd;
[_tskE, "failed"] call SHK_Taskmaster_upd;

// clean up
"ObjectiveMkr" setMarkerAlpha 0;
sleep 90;

{deleteVehicle _x; sleep 0.1} forEach (units _grp),(units _stat_grp);
{deleteGroup _x} forEach [_grp, _stat_grp, sconvoy_grp];

if (!isNull _cone) then {deleteVehicle _cone; sleep 0.1;};
{if (!isNull _x) then {deleteVehicle _x; sleep 0.1}} foreach _allVeh;
_staticGuns = objective_pos_logic getVariable "INS_ObjectiveStatics";
{deleteVehicle _x; sleep 0.1} forEach _staticGuns;

deleteMarker "ObjectiveMkr";

if (true) exitWith {sleep 20; nul = [] execVM "Objectives\random_objectives.sqf";};
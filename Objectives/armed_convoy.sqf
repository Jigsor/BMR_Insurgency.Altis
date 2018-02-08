//armed_convoy.sqf by Jigsor

sleep 2;
params ["_newZone","_objType"];
private ["_VehPool","_rnum","_range","_randVeh","_objmkr","_cone","_VarName","_grp","_handle","_type","_obj_leader","_stat_grp","_wp","_tskW","_tasktopicW","_taskdescW","_tskE","_tasktopicE","_taskdescE","_type","_vehicle1","_newPos","_veh1","_vehicle2","_veh2","_vehicle3","_veh3","_vehicle4","_veh4","_handle1","_allVeh"];

_VehPool = + INS_Op4_Veh_Tracked;
_rnum = str(round (random 999));
_range = 500;

_randVeh = {
	private _veh = selectRandom _VehPool;
	if ((count _VehPool) > 1) then {
		_VehPool = _VehPool - [_veh];
	};
	_veh
};

objective_pos_logic setPos _newZone;

_objmkr = createMarker ["ObjectiveMkr", _newZone];
"ObjectiveMkr" setMarkerShape "ELLIPSE";
"ObjectiveMkr" setMarkerSize [2, 2];
"ObjectiveMkr" setMarkerShape "ICON";
"ObjectiveMkr" setMarkerType "mil_dot";
"ObjectiveMkr" setMarkerColor "ColorRed";
"ObjectiveMkr" setMarkerText "Armed Convoy";

// Spawn Objective center object
_cone = createVehicle [_objType, _newZone, [], 0, "NONE"];
sleep jig_tvt_globalsleep;
_cone setVectorUp [0,0,1];
_cone enablesimulation false;
_cone hideObjectGlobal true;

// Spawn Objective enemy defences
_grp = [_newZone,14] call spawn_Op4_grp; sleep 3;
_stat_grp = [_newZone,3,14] call spawn_Op4_StatDef;

_handle=[_grp, position objective_pos_logic, 75] call BIS_fnc_taskPatrol;

//Spawn Convoy
aconvoy_grp = createGroup INS_Op4_side;

_newPos = [getMarkerPos "ObjectiveMkr", 0, 50, 10, 0, 0.6, 0] call BIS_fnc_findSafePos;
_type = [] call _randVeh;
_vehicle1 = [_newPos, 0, _type, aconvoy_grp] call BIS_fnc_spawnvehicle;
sleep 1;
_veh1 = _vehicle1 select 0;

_newPos = [getMarkerPos "ObjectiveMkr", 5, 55, 10, 0, 0.6, 0] call BIS_fnc_findSafePos;
_type = [] call _randVeh;
_vehicle2 = [_newPos, 0, _type, aconvoy_grp] call BIS_fnc_spawnvehicle;
sleep 1;
_veh2 = _vehicle2 select 0;

_newPos = [getMarkerPos "ObjectiveMkr", 10, 60, 10, 0, 0.6, 0] call BIS_fnc_findSafePos;
_type = [] call _randVeh;
_vehicle3 = [_newPos, 0, _type, aconvoy_grp] call BIS_fnc_spawnvehicle;
sleep 1;
_veh3 = _vehicle3 select 0;

_newPos = [getMarkerPos "ObjectiveMkr", 15, 65, 10, 0, 0.6, 0] call BIS_fnc_findSafePos;
_type =  selectRandom INS_Op4_Veh_Light;
_vehicle4 = [_newPos, 0, _type, aconvoy_grp] call BIS_fnc_spawnvehicle;
sleep 1;
_veh4 = _vehicle4 select 0;

_allVeh = [_veh1,_veh2,_veh3,_veh4];
{_x setDamage 0} forEach _allVeh;
{
	_x addeventhandler ["killed","[(_this select 0)] spawn remove_carcass_fnc"];
	_x addEventHandler ["GetOutMan",{_this select 0 doMove (position objective_pos_logic)}];
} forEach (units aconvoy_grp);
{_x addeventhandler ["killed","[(_this select 0)] spawn remove_carcass_fnc"]} forEach _allVeh;

{[_x] call anti_collision} foreach _allVeh;
{_x setVariable["persistent",true]} foreach _allVeh;
{private _car = _x; _car allowCrewInImmobile true} forEach _allVeh;

// convoy movement
_handle1=[aconvoy_grp, position objective_pos_logic, _range] call Veh_taskPatrol_mod;
if (DebugEnabled > 0) then {[aconvoy_grp] spawn INS_Tsk_GrpMkrs;};

// create west task
_tskW = "tskW_destroy_convoy" + _rnum;
_tasktopicW = localize "STR_BMR_Tsk_topicW_dac";
_taskdescW = localize "STR_BMR_Tsk_descW_dac";
[_tskW,_tasktopicW,_taskdescW,WEST,[],"created",_newZone] call SHK_Taskmaster_add;
sleep 5;

// create east task
_tskE = "tskE_defend_convoy" + _rnum;
_tasktopicE = localize "STR_BMR_Tsk_topicE_dac";
_taskdescE = localize "STR_BMR_Tsk_descE_dac";
[_tskE,_tasktopicE,_taskdescE,EAST,[],"created",_newZone] call SHK_Taskmaster_add;

waitUntil {{alive _x} count units aconvoy_grp > 0};
sleep 0.1;

if (daytime > 3.00 && daytime < 5.00) then {[] spawn {[[], "INS_fog_effect"] call BIS_fnc_mp};};

// Only one outcome supported.
waitUntil {sleep 1; {alive _x} count units aconvoy_grp < 1};

[_tskW, "succeeded"] call SHK_Taskmaster_upd;
[_tskE, "failed"] call SHK_Taskmaster_upd;

// clean up
"ObjectiveMkr" setMarkerAlpha 0;
sleep 90;

{deleteVehicle _x; sleep 0.1} forEach (units _grp),(units _stat_grp);
{deleteGroup _x} forEach [_grp, _stat_grp, aconvoy_grp];
if (!isNull _cone) then {deleteVehicle _cone};
{deleteVehicle _x} foreach (_allVeh select {!isNull _x});
private _staticGuns = objective_pos_logic getVariable "INS_ObjectiveStatics";
{deleteVehicle _x} forEach _staticGuns;
deleteMarker "ObjectiveMkr";

if (true) exitWith {sleep 20; nul = [] execVM "Objectives\random_objectives.sqf";};
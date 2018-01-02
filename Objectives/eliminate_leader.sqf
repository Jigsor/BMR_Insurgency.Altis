//eliminate_leader.sqf by Jigsor

sleep 2;
params ["_newZone","_type"];
private ["_rnum","_mPos","_objmkr","_bunker","_VarName","_grp","_handle","_obj_leader","_stat_grp","_wp","_tskW","_tasktopicW","_taskdescW","_tskE","_tasktopicE","_taskdescE"];

_rnum = str(round (random 999));
_mPos = _newZone;

// Positional info
while {isOnRoad _mPos} do {
	_mPos = _newZone findEmptyPosition [2, 30, _type];
	sleep 0.2;
};
_newZone = _mPos;

objective_pos_logic setPos _newZone;

_objmkr = createMarker ["ObjectiveMkr", _newZone];
"ObjectiveMkr" setMarkerShape "ELLIPSE";
"ObjectiveMkr" setMarkerSize [2, 2];
"ObjectiveMkr" setMarkerShape "ICON";
"ObjectiveMkr" setMarkerType "mil_dot";
"ObjectiveMkr" setMarkerColor "colorRed";
"ObjectiveMkr" setMarkerText "Eliminate Leader";

_bunker = createVehicle [_type, _newZone, [], 0, "NONE"];
sleep jig_tvt_globalsleep;

_bunker setDir (random 359);
_bunker setVectorUp [0,0,1];

// Spawn Objective enemy defences
_grp = [_newZone,14] call spawn_Op4_grp; sleep 3;
_stat_grp = [_newZone,4,10] call spawn_Op4_StatDef;

_obj_leader = leader _grp;
_VarName = "ObjLeader";
_obj_leader setVehicleVarName _VarName;
_obj_leader Call Compile Format ["%1=_this ; publicVariable '%1'",_VarName];

_handle=[_grp, position objective_pos_logic, 75] call BIS_fnc_taskPatrol;

if (DebugEnabled > 0) then {[_grp] spawn INS_Tsk_GrpMkrs;};

waitUntil {sleep 1; alive _obj_leader};

// create west task
_tskW = "tskW_eliminate_leader" + _rnum;
_tasktopicW = localize "STR_BMR_Tsk_topicW_eil";
_taskdescW = localize "STR_BMR_Tsk_topicW_eil";
[_tskW,_tasktopicW,_taskdescW,WEST,[],"created",_newZone] call SHK_Taskmaster_add;
sleep 5;

// create east task
_tskE = "tskE_eliminate_leader" + _rnum;
_tasktopicE = localize "STR_BMR_Tsk_topicE_eil";
_taskdescE = localize "STR_BMR_Tsk_topicE_eil";
[_tskE,_tasktopicE,_taskdescE,EAST,[],"created",_newZone] call SHK_Taskmaster_add;

if (daytime > 3.00 && daytime < 5.00) then {[] spawn {[[], "INS_fog_effect"] call BIS_fnc_mp};};

waitUntil {sleep 3; !alive _obj_leader};
[_tskW, "succeeded"] call SHK_Taskmaster_upd;
[_tskE, "failed"] call SHK_Taskmaster_upd;

// clean up
"ObjectiveMkr" setMarkerAlpha 0;
sleep 90;

{deleteVehicle _x; sleep 0.1} forEach (units _grp),(units _stat_grp);
{deleteGroup _x} forEach [_grp, _stat_grp];
if (!isNull _bunker) then {deleteVehicle _bunker};
private _staticGuns = objective_pos_logic getVariable "INS_ObjectiveStatics";
{deleteVehicle _x} forEach _staticGuns;
deleteMarker "ObjectiveMkr";

if (true) exitWith {sleep 20; nul = [] execVM "Objectives\random_objectives.sqf";};
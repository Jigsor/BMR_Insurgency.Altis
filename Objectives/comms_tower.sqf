//Objectives\comms_tower.sqf by Jigsor

sleep 2;
params ["_newZone","_type"];
private ["_rnum","_objmkr","_tower","_VarName","_grp","_stat_grp","_handle","_wp","_tskW","_tasktopicW","_taskdescW","_tskE","_tasktopicE","_taskdescE"];

_rnum = str(round (random 999));
_towerPos = _newZone;

// Positional info
while {isOnRoad _towerPos} do {
	_towerPos = _newZone findEmptyPosition [2, 30, _type];
	sleep 0.2;
};
_newZone = _towerPos;

objective_pos_logic setPos _newZone;

_objmkr = createMarker ["ObjectiveMkr", _newZone];
"ObjectiveMkr" setMarkerShape "ELLIPSE";
"ObjectiveMkr" setMarkerSize [2, 2];
"ObjectiveMkr" setMarkerShape "ICON";
"ObjectiveMkr" setMarkerType "mil_dot";
"ObjectiveMkr" setMarkerColor "ColorRed";
"ObjectiveMkr" setMarkerText "Radio Tower";

// Spawn Objective Object
_tower = createVehicle [_type, _newZone, [], 0, "NONE"];
sleep jig_tvt_globalsleep;

_tower setVectorUp [0,0,1];
_tower addeventhandler ["handledamage",{_this call JIG_tower_damage}];
_VarName = "RadioTower1";
_tower setVehicleVarName _VarName;
_tower Call Compile Format ["%1=_this; publicVariable '%1'",_VarName];

// Spawn Objective enemy deffences
_grp = [_newZone,10] call spawn_Op4_grp; sleep 3;
_stat_grp = [_newZone,4,7] call spawn_Op4_StatDef;

_handle=[_grp, position objective_pos_logic, 75] call BIS_fnc_taskPatrol;
if (DebugEnabled > 0) then {[_grp] spawn INS_Tsk_GrpMkrs;};

waitUntil {sleep 1; alive _tower};

// create west task
_tskW = "tskW_Radio_Tower" + _rnum;
_tasktopicW = localize "STR_BMR_Tsk_topicW_dct";
_taskdescW = localize "STR_BMR_Tsk_descW_dct";
[_tskW,_tasktopicW,_taskdescW,WEST,[],"created",_newZone] call SHK_Taskmaster_add;
sleep 5;

// create east task
_tskE = "tskE_Radio_Tower" + _rnum;
_tasktopicE = localize "STR_BMR_Tsk_topicE_dct";
_taskdescE = localize "STR_BMR_Tsk_topicE_dct";
[_tskE,_tasktopicE,_taskdescE,EAST,[],"created",_newZone] call SHK_Taskmaster_add;

if (daytime > 3.00 && daytime < 5.00) then {[] spawn {[[], "INS_fog_effect"] call BIS_fnc_mp};};

waitUntil {sleep 3; !alive _tower};
[_tskW, "succeeded"] call SHK_Taskmaster_upd;
[_tskE, "failed"] call SHK_Taskmaster_upd;

// clean up
"ObjectiveMkr" setMarkerAlpha 0;
sleep 90;

{deleteVehicle _x; sleep 0.1} forEach (units _grp),(units _stat_grp);
{deleteGroup _x} forEach [_grp, _stat_grp];
{deleteVehicle _x} forEach ((NearestObjects [objective_pos_logic, [], 30]) select {typeOf _x in objective_ruins});
private _staticGuns = objective_pos_logic getVariable "INS_ObjectiveStatics";
{deleteVehicle _x} forEach _staticGuns;
deleteMarker "ObjectiveMkr";

if (true) exitWith {sleep 20; nul = [] execVM "Objectives\random_objectives.sqf";};
//Objectives\comms_tower.sqf by Jigsor

sleep 2;
private ["_newZone","_type","_rnum","_objmkr","_tower","_VarName","_grp","_stat_grp","_handle","_wp","_tskW","_tasktopicW","_taskdescW","_tskE","_tasktopicE","_taskdescE"];

_newZone = _this select 0;
_type = _this select 1;
_rnum = str(round (random 999));

// Positional info
objective_pos_logic setPos _newZone;

_objmkr = createMarker ["ObjectiveMkr", _newZone];
"ObjectiveMkr" setMarkerShape "ELLIPSE";
"ObjectiveMkr" setMarkerSize [2, 2];
"ObjectiveMkr" setMarkerShape "ICON";
"ObjectiveMkr" setMarkerType "mil_dot";
"ObjectiveMkr" setMarkerColor "ColorRed";
"ObjectiveMkr" setMarkerText "Radio Tower";

// Spawn Objective Object
_tower = createVehicle [_type, _newZone, [], 0, "None"];
sleep jig_tvt_globalsleep;

_tower setVectorUp [0,0,1];
_tower addeventhandler ["handledamage",{_this call JIG_tower_damage}];
_VarName = "RadioTower1";
_tower setVehicleVarName _VarName;
_tower Call Compile Format ["%1=_This ; PublicVariable ""%1""",_VarName];

// Spawn Objective enemy deffences
_grp = [_newZone,10] call spawn_Op4_grp;
_stat_grp = [_newZone,3] call spawn_Op4_StatDef;

_stat_grp setCombatMode "RED";

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

if (INS_environment isEqualTo 1) then {if (daytime > 3.00 && daytime < 5.00) then {[] spawn {[[], "INS_fog_effect"] call BIS_fnc_mp;};};};

waitUntil {sleep 3; !alive _tower};
[_tskW, "succeeded"] call SHK_Taskmaster_upd;
[_tskE, "failed"] call SHK_Taskmaster_upd;

// clean up
"ObjectiveMkr" setMarkerAlpha 0;
sleep 90;

{deleteVehicle _x; sleep 0.1} forEach (units _grp);
{deleteVehicle _x; sleep 0.1} forEach (units _stat_grp);
deleteGroup _grp;
deleteGroup _stat_grp;

{if (typeof _x in INS_Op4_stat_weps) then {deleteVehicle _x; sleep 0.1}} forEach (NearestObjects [objective_pos_logic, [], 40]);
{if (typeof _x in objective_ruins) then {deleteVehicle _x; sleep 0.1}} forEach (NearestObjects [objective_pos_logic, [], 30]);

deleteMarker "ObjectiveMkr";

if (true) exitWith {sleep 20; nul = [] execVM "Objectives\random_objectives.sqf";};
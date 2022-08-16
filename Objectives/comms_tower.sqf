//Objectives\comms_tower.sqf by Jigsor

sleep 2;
params ["_newZone","_type"];
private _towerPos = _newZone;

// Positional info
while {isOnRoad _towerPos} do {
	_towerPos = _newZone findEmptyPosition [2, 30, _type];
	sleep 0.2;
};
_newZone = _towerPos;

private _h = 0.2;
private _surfIsWat = false;
if (surfaceIsWater _newZone) then {
	_surfIsWat = true;
	_h = abs (getTerrainHeightASL _newZone);
	_newZone set [2, _h + 0.63];
} else {
	_currH = _newZone # 2;
	_newZone set [2, _currH + _h];
};

objective_pos_logic setPos _newZone;

private _objmkr = createMarker ["ObjectiveMkr", _newZone];
_objmkr setMarkerShape "ELLIPSE";
_objmkr setMarkerSize [2, 2];
_objmkr setMarkerShape "ICON";
_objmkr setMarkerType "mil_dot";
_objmkr setMarkerColor "ColorRed";
"ObjectiveMkr" setMarkerText "Radio Tower";

// Spawn Objective Object
private _tower = createVehicle [_type, _newZone, [], 0, "NONE"];
sleep 0.1;

_tower setVectorUp [0,0,1];
_tower addeventhandler ["HandleDamage",{_this call JIG_tower_damage}];
private _VarName = "RadioTower1";
_tower setVehicleVarName _VarName;
_tower Call Compile Format ["%1=_this; publicVariable '%1'",_VarName];

// Spawn Objective enemy defences
private _grp = [_newZone,10] call spawn_Op4_grp; sleep 3;
private _stat_grp = [_newZone,4,7] call spawn_Op4_StatDef;

private _wpHandle=[_grp, position objective_pos_logic, 75] call BIS_fnc_taskPatrol;
if (DebugEnabled > 0) then {[_grp] spawn INS_Tsk_GrpMkrs;};

waitUntil {sleep 1; alive _tower};

private _rnum = str(round (random 999));

// create west task
private _tskW = "tskW_Radio_Tower" + _rnum;
private _tasktopicW = localize "STR_BMR_Tsk_topicW_dct";
private _taskdescW = localize "STR_BMR_Tsk_descW_dct";
[_tskW,_tasktopicW,_taskdescW,WEST,[],"created",_newZone] call SHK_Taskmaster_add;
sleep 5;

// create east task
private _tskE = "tskE_Radio_Tower" + _rnum;
private _tasktopicE = localize "STR_BMR_Tsk_topicE_dct";
private _taskdescE = localize "STR_BMR_Tsk_topicE_dct";
[_tskE,_tasktopicE,_taskdescE,EAST,[],"created",_newZone] call SHK_Taskmaster_add;

if (daytime > 3.00 && daytime < 5.00) then {0 spawn {[] remoteExec ['INS_fog_effect', [0,-2] select isDedicated]};};

private _killcomms = true;
while {_killcomms} do
{
	if (!alive _tower) exitWith {
		[_tskW, "succeeded"] call SHK_Taskmaster_upd;
		[_tskE, "failed"] call SHK_Taskmaster_upd;
		_killcomms = false;
	};

	if (SideMissionCancel) exitWith {
		[_tskW, "canceled"] call SHK_Taskmaster_upd;
		[_tskE, "canceled"] call SHK_Taskmaster_upd;
		_killcomms = false;
	};

	sleep 5;
};

// clean up
"ObjectiveMkr" setMarkerAlpha 0;
if (SideMissionCancel) then {sleep 5} else {sleep 60};
{deleteVehicle _x; sleep 0.1} forEach units _grp;
{deleteVehicle _x; sleep 0.1} forEach units _stat_grp;
{deleteGroup _x} forEach [_grp, _stat_grp];
{deleteVehicle _x} forEach ((NearestObjects [objective_pos_logic, [], 30]) select {typeOf _x in objective_ruins});
private _staticGuns = objective_pos_logic getVariable ["INS_ObjectiveStatics",[]];
{deleteVehicle _x} forEach _staticGuns;
if (!isNull _tower) then {deleteVehicle _tower};
deleteMarker "ObjectiveMkr";

if (true) exitWith {sleep 20; execVM "Objectives\random_objectives.sqf";};
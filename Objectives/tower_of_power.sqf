//Objectives\tower_of_power.sqf by Jigsor

sleep 2;
params ["_newZone","_type"];
private _towerPos = _newZone;

// Positional info
while {isOnRoad _towerPos} do {
	_towerPos = _newZone findEmptyPosition [2, 30, _type];
	sleep 0.2;
};

objective_pos_logic setPos _towerPos;

private _objmkr = createMarker ["ObjectiveMkr", _towerPos];
_objmkr setMarkerShape "ELLIPSE";
_objmkr setMarkerSize [2, 2];
_objmkr setMarkerShape "ICON";
_objmkr setMarkerType "mil_dot";
_objmkr setMarkerColor "ColorRed";
"ObjectiveMkr" setMarkerText "Cut Power";

private _roadNear = false;
private _roadSegment = objNull;
private _roadDir = 0;
private _roads = _towerPos nearRoads 20;
if (_roads isNotEqualTo []) then {
	_roadNear = true;
	_roadSegment = _roads select 0;
	_roadDir = direction _roadSegment;
};

private _h = 0.2;
private _surfIsWat = false;
if (surfaceIsWater _towerPos) then {
	_surfIsWat = true;
	_h = abs (getTerrainHeightASL _towerPos);
	_towerPos set [2, _h + 0.63];
} else {
	_currH = _towerPos # 2;
	_towerPos set [2, _currH + _h];
};

// Spawn Objective Object
private _tower = createVehicle [_type, _towerPos, [], 0, "NONE"];
sleep 0.1;

if (_roadNear) then {_tower setDir _roadDir - 90;};
_tower setVectorUp [0,0,1];
_tower addeventhandler ["HandleDamage",{_this call JIG_tower_damage}];
private _VarName = "PowerTower1";
_tower setVehicleVarName _VarName;
_tower Call Compile Format ["%1=_this; publicVariable '%1'",_VarName];

private _plank = objNull;
if (_surfIsWat) then {
	_plank = createVehicle ["Land_Plank_01_4m_F", _towerPos, [], 0, "CAN_COLLIDE"];
	sleep 0.1;
	_plank attachTo [_tower,[0, -2.74, -8.7]];
	_plank setVectorDirAndUp [[0, 0.55, 0.18], [0, -0.18, 0.66]];
};

// Spawn Objective enemy deffences
private _grp = [_newZone,10] call spawn_Op4_grp; sleep 3;
private _stat_grp = [_newZone,4,6] call spawn_Op4_StatDef;

private _wpHandle=[_grp, position objective_pos_logic, 75] call BIS_fnc_taskPatrol;

if (DebugEnabled > 0) then {[_grp] spawn INS_Tsk_GrpMkrs;};

waitUntil {sleep 1; alive _tower};

private _rnum = str(round (random 999));

// create west task
private _tskW = "tskW_Cut_Power" + _rnum;
private _tasktopicW = localize "STR_BMR_Tsk_topicW_dhvt";
private _taskdescW = localize "STR_BMR_Tsk_descW_dhvt";
[_tskW,_tasktopicW,_taskdescW,WEST,[],"created",_towerPos] call SHK_Taskmaster_add;
sleep 5;

// create east task
private _tskE = "tskE_Cut_Power" + _rnum;
private _tasktopicE = localize "STR_BMR_Tsk_topicE_dhvt";
private _taskdescE = localize "STR_BMR_Tsk_descE_dhvt";
[_tskE,_tasktopicE,_taskdescE,EAST,[],"created",_towerPos] call SHK_Taskmaster_add;

if (daytime > 3.00 && daytime < 5.00) then {0 spawn {[] remoteExec ['INS_fog_effect', [0,-2] select isDedicated]};};

{
	[_x,true] call BIS_fnc_switchLamp;
	false;
} count nearestObjects [objective_pos_logic, INS_lights, 1000];

private _killtower = true;
while {_killtower} do
{
	if (!alive _tower) exitWith {
		private _lights = INS_lights;
		null = [objective_pos_logic,"HighVoltage"] call mp_Say3D_fnc;
		[] remoteExec ['HV_tower_effect', [0,-2] select isDedicated];
		(localize "STR_BMR_PowerTower_success") remoteExec ['JIG_MPhint_fnc', [0,-2] select isDedicated];

		private "_lamps";
		for [{_i=0},{_i < (count _lights)},{_i=_i+1}] do {
			_lamps = getPosATL objective_pos_logic nearObjects [_lights select _i, 1000];
			sleep 0.01;
			{
				[_x,false] call BIS_fnc_switchLamp;
				sleep 0.03;
			} forEach _lamps;
		};
		[_tskW, "succeeded"] call SHK_Taskmaster_upd;
		[_tskE, "failed"] call SHK_Taskmaster_upd;
		_killtower = false;
	};

	if (SideMissionCancel) exitWith {
		[_tskW, "canceled"] call SHK_Taskmaster_upd;
		[_tskE, "canceled"] call SHK_Taskmaster_upd;
		_killtower = false;
	};

	sleep 3;
};

// clean up
"ObjectiveMkr" setMarkerAlpha 0;
if (SideMissionCancel) then {sleep 5} else {sleep 90};
if (!isNull _plank) then {deleteVehicle _plank};
{deleteVehicle _x; sleep 0.1} forEach units _grp;
{deleteVehicle _x; sleep 0.1} forEach units _stat_grp;
{deleteGroup _x} forEach [_grp, _stat_grp];
{deleteVehicle _x} forEach ((NearestObjects [objective_pos_logic, [], 30]) select {typeOf _x in objective_ruins});
private _staticGuns = objective_pos_logic getVariable ["INS_ObjectiveStatics",[]];
{deleteVehicle _x} forEach _staticGuns;
deleteMarker "ObjectiveMkr";

if (true) exitWith {sleep 20; execVM "Objectives\random_objectives.sqf";};
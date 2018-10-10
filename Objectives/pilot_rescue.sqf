//Objectives\pilot_rescue.sqf by Jigsor

sleep 2;
params ["_newZone","_type"];

private _pilot_grp = grpNull;
private _radius = 5;
private _rnum = str(round (random 999));
private _basePos = (getMarkerPos "Respawn_West");
private _pilotType = nil;
private _getpilot = true;

//mod for CUP
if (INS_op_faction isEqualTo 12) then {
	if (isClass(configfile >> "CfgVehicles" >> "BlackhawkWreck")) then {
		activateAddons ["BlackhawkWreck"];
		_type = "BlackhawkWreck";
		_radius = 9;
	};
};

//mod for Operation Trebuchet
if (INS_op_faction isEqualTo 16) then {
	_type = "OPTRE_Objects_Wreck_Pelican_Static2";
	_radius = 9;
};

//mod for IFA3Lite
if (INS_op_faction isEqualTo 17) then {
	if (isClass(configFile >> "CfgPatches" >> "A3_Props_F_Exp")) then {
		activateAddons ["A3_Props_F_Exp_Military"];
		_type = "Land_HistoricalPlaneWreck_03_F";
		_pilotType = "LIB_GER_pilot";
		_radius = 9;
	};
};

if (isNil "_pilotType") then {_pilotType = "B_Pilot_F"};

// Positional info
objective_pos_logic setPos _newZone;

private _objmkr = createMarker ["ObjectiveMkr", _newZone];
"ObjectiveMkr" setMarkerShape "ELLIPSE";
"ObjectiveMkr" setMarkerSize [2, 2];
"ObjectiveMkr" setMarkerShape "ICON";
"ObjectiveMkr" setMarkerType "mil_dot";
"ObjectiveMkr" setMarkerColor "ColorRed";
"ObjectiveMkr" setMarkerText "Pilot Rescue";

// Spawn Objective Objects
private _wreck = createVehicle [_type, _newZone, [], 0, "NONE"];
sleep jig_tvt_globalsleep;

_wreck setDir (random 359);
_wreck setVectorUp [0,0,1];
_wreck enableSimulationGlobal false;
_wreck allowdamage false;

private _VarName = "OspreyWreck";
_wreck setVehicleVarName _VarName;
_wreck Call Compile Format ["%1=_this; publicVariable '%1'",_VarName];

_pilot_grp = createGroup INS_Blu_side;
private _pilot = _pilot_grp createUnit [_pilotType, _newZone, [], 0, "NONE"];
sleep jig_tvt_globalsleep;

_pilot addeventhandler ["killed","[(_this select 0)] spawn remove_carcass_fnc; _this spawn killedByInfo_fnc"];

private _pilotVarName = "DownedPilot";
_pilot setVehicleVarName _pilotVarName;
_pilot Call Compile Format ["%1=_this; publicVariable '%1'",_pilotVarName];

_pilot setUnitPos "UP";
_pilot disableAI "MOVE";
_pilot allowfleeing 0;
_pilot setBehaviour "CARELESS";
removeallweapons _pilot;
_pilot setCaptive true;
[ [ _pilot, "AmovPercMstpSsurWnonDnon" ], "switchMoveEverywhere" ] call BIS_fnc_MP;

// Spawn Objective enemy defences
private _grp = [_newZone,10] call spawn_Op4_grp; sleep 3;
private _stat_grp = [_newZone,3,_radius] call spawn_Op4_StatDef;

private _handle=[_grp, position objective_pos_logic, 75] call BIS_fnc_taskPatrol;

if (DebugEnabled > 0) then {[_grp] spawn INS_Tsk_GrpMkrs};

// create west task
private _tskW = "tskW_Pilot_Rescue" + _rnum;
private _tasktopicW = localize "STR_BMR_Tsk_topicW_rdp";
private _taskdescW = localize "STR_BMR_Tsk_descW_rdp";
[_tskW,_tasktopicW,_taskdescW,WEST,[],"created",_newZone] call SHK_Taskmaster_add;
sleep 5;

// create east task
private _tskE = "tskE_Pilot_Rescue" + _rnum;
private _tasktopicE = localize "STR_BMR_Tsk_topicE_rdp";
private _taskdescE = localize "STR_BMR_Tsk_descE_rdp";
[_tskE,_tasktopicE,_taskdescE,EAST,[],"created",_newZone] call SHK_Taskmaster_add;

if (daytime > 3.00 && daytime < 5.00) then {0 spawn {[[], "INS_fog_effect"] call BIS_fnc_mp}};

// pilot hold position until rescued or dead
private ["_nearUnits","_rescuers"];
private _rescueSide = INS_Blu_side;
private _hero = objNull;
private _loop = true;
while {_loop} do
{
	if (SideMissionCancel) exitWith {
		[_tskW, "canceled"] call SHK_Taskmaster_upd;
		[_tskE, "canceled"] call SHK_Taskmaster_upd;
		_loop = false;
	};

	if (!alive _pilot) exitWith {_loop = false};
	_nearUnits = nearestObjects [_pilot, ["CAManBase"], 5];
	_nearUnits deleteAt 0;

	if !(_nearUnits isEqualTo []) then {
		_rescuers = [];
		{_rescuers pushBack _x} forEach (_nearUnits select {(_x isKindOf "Man") && {side _x isEqualTo _rescueSide}});
		if !(_rescuers isEqualTo []) then {
			_hero = _rescuers select 0;
			_loop = false;
		};
	};

	sleep 3;
};
waitUntil {sleep 1; !_loop};

if (alive _pilot && !SideMissionCancel) then {
	_pilot setdamage 0;
	_pilot setCaptive false;
	_pilot enableAI "MOVE";
	sleep 0.01;
	[_pilot, ""] remoteExec ["switchMoveEverywhere", 0];
	sleep 0.5;
	_pilot setUnitPos "UP";
	_pilot doFollow (leader group _hero);
	[_pilot] join (group _hero);
};

// wait until pilot dead or returned to base
while {_getpilot} do
{
	if (!alive _pilot) exitWith {
		[_tskW, "failed"] call SHK_Taskmaster_upd;
		[_tskE, "succeeded"] call SHK_Taskmaster_upd;
		_getpilot = false;
	};

	if (_pilot distance _basePos < 100) exitWith {
		[_tskW, "succeeded"] call SHK_Taskmaster_upd;
		[_tskE, "failed"] call SHK_Taskmaster_upd;
		_getpilot = false;
	};

	if (SideMissionCancel) exitWith {
		[_tskW, "canceled"] call SHK_Taskmaster_upd;
		[_tskE, "canceled"] call SHK_Taskmaster_upd;
		_getpilot = false;
	};

	sleep 3;
};

// clean up
"ObjectiveMkr" setMarkerAlpha 0;

if (!isNull _pilot) then {[_pilot] joinSilent grpNull; sleep 1; deleteVehicle _pilot;};
if (SideMissionCancel) then {sleep 5} else {sleep 30};
{deleteVehicle _x; sleep 0.1} forEach units _grp;
{deleteVehicle _x; sleep 0.1} forEach units _stat_grp;
{deleteVehicle _x; sleep 0.1} forEach units _pilot_grp;

{deleteGroup _x} forEach [_grp, _stat_grp, _pilot_grp];
{deleteVehicle _x} forEach ((NearestObjects [objective_pos_logic, [], 30]) select {typeOf _x in objective_ruins});
if (!isNull _wreck) then {deleteVehicle _wreck};
private _staticGuns = objective_pos_logic getVariable ["INS_ObjectiveStatics",[]];
{deleteVehicle _x} forEach _staticGuns;
deleteMarker "ObjectiveMkr";

if (true) exitWith {sleep 20; execVM "Objectives\random_objectives.sqf";};
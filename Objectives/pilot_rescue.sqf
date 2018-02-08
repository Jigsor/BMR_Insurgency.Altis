//Objectives\pilot_rescue.sqf by Jigsor

sleep 2;
params ["_newZone","_type"];
private ["_pilotType","_rnum","_pilot_grp","_handle","_op4_side","_blu4_side","_tsk_failed","_hero","_objmkr","_wreck","_VarName","_pilot","_grp","_stat_grp","_wp","_tskW","_tasktopicW","_taskdescW","_tskE","_tasktopicE","_taskdescE","_loop","_nearUnits","_hero_speed","_pilotVarName","_end_loop","_radius","_base_pos"];

_op4_side = INS_Op4_side;
_blu4_side = INS_Blu_side;
_pilot_grp = grpNull;
_hero = objNull;
_tsk_failed = false;
_end_loop = false;
_radius = 5;
_rnum = str(round (random 999));
_base_p = (getMarkerPos "Respawn_West");
_pilotType = nil;

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

_objmkr = createMarker ["ObjectiveMkr", _newZone];
"ObjectiveMkr" setMarkerShape "ELLIPSE";
"ObjectiveMkr" setMarkerSize [2, 2];
"ObjectiveMkr" setMarkerShape "ICON";
"ObjectiveMkr" setMarkerType "mil_dot";
"ObjectiveMkr" setMarkerColor "ColorRed";
"ObjectiveMkr" setMarkerText "Pilot Rescue";

// Spawn Objective Objects
_wreck = createVehicle [_type, _newZone, [], 0, "NONE"];
sleep jig_tvt_globalsleep;

_wreck setDir (random 359);
_wreck setVectorUp [0,0,1];
_wreck enableSimulationGlobal false;
_wreck allowdamage false;

_VarName = "OspreyWreck";
_wreck setVehicleVarName _VarName;
_wreck Call Compile Format ["%1=_this; publicVariable '%1'",_VarName];

_pilot_grp = createGroup INS_Blu_side;
_pilot = _pilot_grp createUnit [_pilotType, _newZone, [], 0, "NONE"];
sleep jig_tvt_globalsleep;

_pilot addeventhandler ["killed","[(_this select 0)] spawn remove_carcass_fnc"];

_pilotVarName = "DownedPilot";
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
_grp = [_newZone,10] call spawn_Op4_grp; sleep 3;
_stat_grp = [_newZone,3,_radius] call spawn_Op4_StatDef;

_handle=[_grp, position objective_pos_logic, 75] call BIS_fnc_taskPatrol;

if (DebugEnabled > 0) then {[_grp] spawn INS_Tsk_GrpMkrs};

// create west task
_tskW = "tskW_Pilot_Rescue" + _rnum;
_tasktopicW = localize "STR_BMR_Tsk_topicW_rdp";
_taskdescW = localize "STR_BMR_Tsk_descW_rdp";
[_tskW,_tasktopicW,_taskdescW,WEST,[],"created",_newZone] call SHK_Taskmaster_add;
sleep 5;

// create east task
_tskE = "tskE_Pilot_Rescue" + _rnum;
_tasktopicE = localize "STR_BMR_Tsk_topicE_rdp";
_taskdescE = localize "STR_BMR_Tsk_descE_rdp";
[_tskE,_tasktopicE,_taskdescE,EAST,[],"created",_newZone] call SHK_Taskmaster_add;

if (daytime > 3.00 && daytime < 5.00) then {[] spawn {[[], "INS_fog_effect"] call BIS_fnc_mp}};

// pilot hold position until rescued or dead
for [{_loop=0}, {_loop<1}, {_loop=_loop}] do
{
	if (!alive _pilot) exitWith {_end_loop = true;_loop=1;};
	_nearUnits = nearestObjects [_pilot, ["CAManBase"], 5];
	_nearUnits deleteAt 0;
	
	{
		if (side _x == _op4_side) then {_nearUnits = _nearUnits - [_x];};
	} count _nearUnits;

	{
		_hero_speed = speed _x;
		_pos = (getPos _x);
		if ((_hero_speed > 8) || (_pos select 2 > 3)) then {
			_nearUnits = _nearUnits - [_x];
		};
	} count _nearUnits;

	if ((count _nearUnits > 0) and (side (_nearUnits select 0) == _blu4_side)) exitWith {_hero = _nearUnits select 0; _end_loop=true; _loop=1;};	
	sleep 3;
};
waitUntil {sleep 1; _end_loop};

if (alive _pilot) then {
	[_pilot] join (group _hero);
	_pilot setdamage 0;
	_pilot setCaptive false;
	_pilot enableAI "MOVE";
	sleep 0.01;
	[ [ _pilot, "" ], "switchMoveEverywhere" ] call BIS_fnc_MP;
	sleep 0.5;
	_pilot setUnitPos "UP";
	_pilot doFollow (leader group _hero);
};

// wait until pilot dead or returned to base
waitUntil {sleep 3; (!alive _pilot) || (position _pilot distance _base_p < 100)};

if (!alive _pilot) then {[_tskW, "failed"] call SHK_Taskmaster_upd; [_tskE, "succeeded"] call SHK_Taskmaster_upd;};
if ((position _pilot) distance _base_p < 100) then {[_tskW, "succeeded"] call SHK_Taskmaster_upd; [_tskE, "failed"] call SHK_Taskmaster_upd; sleep 20;};

// clean up
"ObjectiveMkr" setMarkerAlpha 0;
sleep 60;

if (!isNull _pilot) then {[_pilot] joinSilent grpNull; sleep 1; deleteVehicle _pilot;};
sleep 30;

{deleteVehicle _x; sleep 0.1} forEach (units _grp),(units _stat_grp);
{deleteGroup _x} forEach [_grp, _stat_grp, _pilot_grp];
{deleteVehicle _x} forEach ((NearestObjects [objective_pos_logic, [], 30]) select {typeOf _x in objective_ruins});
if (!isNull _wreck) then {deleteVehicle _wreck};
private _staticGuns = objective_pos_logic getVariable "INS_ObjectiveStatics";
{deleteVehicle _x} forEach _staticGuns;
deleteMarker "ObjectiveMkr";

if (true) exitWith {sleep 20; nul = [] execVM "Objectives\random_objectives.sqf";};
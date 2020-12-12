//Objectives\delivery.sqf mission by Jigsor

//Bypass objective if Opposing Army/Mod Initialization == IFA3. This objective currently only works with helicopter.
if (INS_op_faction in [21]) exitWith {sleep 10; execVM "Objectives\random_objectives.sqf";};

sleep 2;
params ["_newZone"];

deliveryfail = 0;
Task_Transport = [];
Demo_Loaded = false;
Demo_Unloaded = false;

private "_type";
if (isNil "INS_Op4_Veh_AA" || {INS_Op4_Veh_AA isEqualTo []}) then {
	_type = _this # 1;
}else{
	_type = selectRandom INS_Op4_Veh_AA;
};

// Positional info
objective_pos_logic setPos _newZone;

private _objmkr = createMarker ["ObjectiveMkr", _newZone];
_objmkr setMarkerShape "ELLIPSE";
_objmkr setMarkerSize [2, 2];
_objmkr setMarkerShape "ICON";
_objmkr setMarkerType "mil_dot";
_objmkr setMarkerColor "ColorRed";
"ObjectiveMkr" setMarkerText "Delivery Zone";

"deliveryfail" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
"Demo_Loaded" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
"Demo_Unloaded" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};

private _cargoPos = getPos Del_box_Pos;
if (isNil "MHQ_3" || !Alive MHQ_3) then {// Create Helicopter MHQ_3 if it doesn't exist. Added to support Revive System(s) lacking MHQ's.
	sleep 15;// wait for possible vehRespawn script
	if (isNil "MHQ_3" || !Alive MHQ_3) then	{
		if (!Alive MHQ_3) then {deleteVehicle MHQ_3; sleep 0.1;};

		private ["_dis","_mhq_3_pos","_heli","_HeliName","_actualPos"];
		_dis = 20;
		_mhq_3_pos = nil;
		_HeliName = "MHQ_3";

		while {isNil "_mhq_3_pos"} do {
			_mhq_3_pos = [_cargoPos, 5, _dis, 15, 0, 0.6, 0] call BIS_fnc_findSafePos;
			_dis = _dis + 5;
			sleep 0.1;
		};

		_heli = createVehicle ["I_Heli_Transport_02_F", _mhq_3_pos, [], 0, "NONE"];	sleep jig_tvt_globalsleep;
		_heli addeventhandler ["killed","[(_this select 0)] spawn remove_carcass_fnc"];
		[_heli] call paint_heli_fnc;
		_heli setVehicleVarName _HeliName; MHQ_3 = _heli;
		_heli Call Compile Format ["%1=_this; publicVariable '%1'",_HeliName];
		sleep 3;
		_actualPos = (getPosATL MHQ_3);
		_cargoPos = [_actualPos, 5, 14, 5, 0, 0.6, 0] call BIS_fnc_findSafePos;
	};
};

0 spawn {
	Delivery_Box setVariable ["BTK_CargoDrop_ObjectLoaded", false];
	MHQ_3 setVariable ["BTK_CargoDrop_TransporterLoaded", false];

	//// Wait until loaded
	waitUntil {sleep 1; (Delivery_Box getVariable ["BTK_CargoDrop_ObjectLoaded",false]) && {(MHQ_3 getVariable ["BTK_CargoDrop_TransporterLoaded",false])}};
	Demo_Loaded = true;
	publicVariableServer "Demo_Loaded";

	//// Wait until UNloaded
	waitUntil {sleep 0.5; !(Delivery_Box getVariable ["BTK_CargoDrop_ObjectLoaded",true]) && !(MHQ_3 getVariable ["BTK_CargoDrop_TransporterLoaded",true])};
	Demo_Unloaded = true;
	publicVariableServer "Demo_Unloaded";
};

Delivery_Box setPos _cargoPos;
Delivery_Box hideObjectGlobal false;

private _sphere = createVehicle ["Sign_Sphere100cm_F", getPosATL Delivery_Box, [], 0, "CAN_COLLIDE"];
sleep jig_tvt_globalsleep;
_sphere setPos [getPos _sphere # 0, getPos _sphere # 1, 5];

waitUntil {sleep 1; alive MHQ_3};

Demo_Arrow = createVehicle ["Sign_Arrow_Large_Yellow_F", getPosATL MHQ_3, [], 0, "CAN_COLLIDE"];
sleep jig_tvt_globalsleep;
Demo_Arrow setPos [getPos Demo_Arrow # 0, getPos Demo_Arrow # 1, 6];

private _newPos = (getposATL MHQ_3);

if !(getMarkerColor "Task_Transport" isEqualTo "") then {deleteMarker "Task_Transport"};
private _tmarker = createMarker ["Task_Transport", _newPos];
_tmarker setMarkerShape "ICON";
_tmarker setMarkerSize [2, 2];
_tmarker setMarkerType "mil_dot";
_tmarker setMarkerColor "ColorBlue";
"Task_Transport" setMarkerText "Task_Transport";
publicVariable "Task_Transport";
sleep 2;

0 spawn { while {!isNull Demo_Arrow} do { "Task_Transport" setMarkerPos getPosWorld MHQ_3; sleep 1; }; };

private _rnum = str(round (random 999));
// create west task
private _tskW = "tskW_Freight_Delivery" + _rnum;
private _tasktopicW = localize "STR_BMR_Tsk_topicW_lnds";
private _taskdescW = localize "STR_BMR_Tsk_descW_lnds";
[_tskW,_tasktopicW,_taskdescW,WEST,[],"created",_newZone] call SHK_Taskmaster_add;
sleep 5;

// create east task
private _tskE = "tskE_Freight_Delivery" + _rnum;
private _tasktopicE = localize "STR_BMR_Tsk_topicE_lnds";
private _taskdescE = localize "STR_BMR_Tsk_descE_lnds";
[_tskE,_tasktopicE,_taskdescE,EAST,[],"created",_newZone] call SHK_Taskmaster_add;

private _makedelivery = true;
while {_makedelivery} do
{
	if (Demo_Loaded) exitWith {
		deleteVehicle Demo_Arrow;
		deleteVehicle _sphere;
		MHQ_3 setDamage 0;
		if (local MHQ_3 && {fuel MHQ_3 < 0.3}) then {MHQ_3 setfuel 0.3};
		sleep 0.3;

		0 spawn {
			while {Demo_Loaded} do {
				if (alive MHQ_3) then {
					"Task_Transport" setMarkerPos getPosWorld MHQ_3;
					sleep 1.2;
				};
			};
		};
	};

	if (SideMissionCancel) exitWith {};

	sleep 1;
};

private _grp = grpNull;
private _stat_grp = grpNull;
private _vehgrp = grpNull;
private _AAveh = objNull;
while {_makedelivery} do
{
	if ((isPlayer (driver MHQ_3)) && {(isEngineOn MHQ_3) && (!isnull (driver MHQ_3))}) exitWith {

		(localize "STR_BMR_delivery_ready") remoteExec ['JIG_MPhint_fnc', [0,-2] select isDedicated];
		sleep 2;

		private _text = format [localize "STR_BMR_delivery_ready"];
		[_text] remoteExec ["JIG_MPsideChatWest_fnc", [0,-2] select isDedicated];
		sleep 3;

		// Spawn Objective Object
		_newPos = [_newZone, 0, 75, 10, 0, 0.6, 0] call BIS_fnc_findSafePos;
		private _AA = [_newPos, 180, _type, INS_Op4_side] call bis_fnc_spawnvehicle;
		sleep jig_tvt_globalsleep;

		_AAveh = _AA # 0;
		_vehgrp = _AA # 2;

		_AAveh addeventhandler ["killed","[(_this select 0)] spawn remove_carcass_fnc"];
		{_x addeventhandler ["killed","[(_this select 0)] spawn remove_carcass_fnc"]} forEach (units _vehgrp);

		private _VarName = "DeliveryDefence";
		_AAveh setVehicleVarName _VarName;
		_AAveh Call Compile Format ["%1=_this; publicVariable '%1'",_VarName];

		// Spawn Objective enemy defences
		_grp = [_newZone,10] call spawn_Op4_grp; sleep 3;
		_stat_grp = [_newZone,3,15] call spawn_Op4_StatDef;

		private _inf_patrol=[_grp, position objective_pos_logic, 75] call BIS_fnc_taskPatrol;
		private _AA_mob_patrol=[_vehgrp, position objective_pos_logic, 125] call Veh_taskPatrol_mod;

		if (DebugEnabled isEqualTo 1) then {[_grp] spawn INS_Tsk_GrpMkrs;};

		if (daytime > 3.00 && daytime < 5.00) then {0 spawn {[] remoteExec ['INS_fog_effect', [0,-2] select isDedicated]};};
	};

	if (SideMissionCancel) exitWith {Demo_Loaded = true; publicVariableServer "Demo_Loaded";};

	sleep 1;
};

// Task Conditions

private _veh = MHQ_3;
[_veh] spawn {
	params ['_veh'];
	private _loop = true;

	while {_loop} do
	{
		if (SideMissionCancel) exitWith {};
		if (Demo_Unloaded) then {
			_loop = false;
		};
		sleep 0.5;
		if ((isnull (driver _veh)) || (!alive _veh) || (!alive (driver _veh)) && {Demo_Loaded}) then {
			(localize "STR_BMR_delivery_destroyed_aborted") remoteExec ['JIG_MPhint_fnc', [0,-2] select isDedicated];
			sleep 3;

			private _text = format [localize "STR_BMR_delivery_destroyed_aborted"];
			[_text] remoteExec ["JIG_MPsideChatWest_fnc", [0,-2] select isDedicated];
			[_text] remoteExec ["JIG_MPsideChatEast_fnc", [0,-2] select isDedicated];

			deliveryfail = 1;
			publicVariableServer "deliveryfail";

			_loop = false;
		};
		sleep 1;
	};
};

private ["_smoke1","_smoke2","_smkArr"];
_smkArr = [];
while {Demo_Loaded} do {

	sleep 35;
	_smoke1 = createVehicle ["SmokeShellRed", markerPos "ObjectiveMkr", [], 0, "CAN_COLLIDE"];
	_smoke1 setPos [getPos _smoke1 # 0, getPos _smoke1 # 1, 50];
	_smoke2 = createVehicle ["SmokeShellRed", markerPos "ObjectiveMkr", [], 0, "CAN_COLLIDE"];
	_smoke2 setPos [getPos _smoke2 # 0, getPos _smoke2 # 1, 100];
	sleep jig_tvt_globalsleep;

	_smkArr pushBack _smoke1;
	_smkArr pushBack _smoke2;

	if (Demo_Unloaded || SideMissionCancel || deliveryfail isEqualTo 1) exitWith {};
};

private _deliverydone = 0;
if (Demo_Unloaded) then {
	waitUntil {sleep 2; ((getPosatl Delivery_Box select 2) < 2 || deliveryfail isEqualTo 1 || SideMissionCancel)};

	if (!SideMissionCancel) then {
		private _droppoint = [markerPos "ObjectiveMkr" # 0, markerPos "ObjectiveMkr" # 1];
		private _dropedcargo = [getPosatl Delivery_Box # 0, getPosatl Delivery_Box # 1];
		private "_text";

		if ((_droppoint distance _dropedcargo < 750) && (deliveryfail isEqualTo 0) && {(alive _veh) && (alive (driver _veh))}) then	{
			_text = format[localize "STR_BMR_delivery_success"];
			_text remoteExec ['JIG_MPTitleText_fnc', WEST];
			_deliverydone = 1;
		};

		if ((_droppoint distance _dropedcargo > 750) && (deliveryfail isEqualTo 0) && {(alive _veh) && (alive (driver _veh))}) then {
			_text = format[localize "STR_BMR_delivery_fail"];
			_text remoteExec ['JIG_MPTitleText_fnc', WEST];
			deliveryfail = 1;
		}
		else
		{
			if (isnull (driver _veh) || (!alive _veh) || (!alive (driver _veh))) then {
				_text = format[localize "STR_BMR_transport_down"];
				_text remoteExec ['JIG_MPTitleText_fnc', WEST];
				deliveryfail = 1;
			};
		};
	};
};

// Win - Loose

while {_makedelivery} do
{
	if (deliveryfail isEqualTo 1 || _deliverydone isEqualTo 1) exitWith {
		if (_deliverydone isEqualTo 1) then {
			[_tskW, "succeeded"] call SHK_Taskmaster_upd;
			[_tskE, "failed"] call SHK_Taskmaster_upd;
		};
		if (deliveryfail isEqualTo 1) then {
			[_tskE, "succeeded"] call SHK_Taskmaster_upd;
			[_tskW, "failed"] call SHK_Taskmaster_upd;
		};
		Demo_Loaded = false; publicVariableServer "Demo_Loaded"; sleep 3;
		_makedelivery = false;
	};

	if (SideMissionCancel) exitWith {
		[_tskW, "canceled"] call SHK_Taskmaster_upd;
		[_tskE, "canceled"] call SHK_Taskmaster_upd;
		Demo_Loaded = false; publicVariableServer "Demo_Loaded"; sleep 3;
		Delivery_Box setVariable ["BTK_CargoDrop_ObjectLoaded", true];
		MHQ_3 setVariable ["BTK_CargoDrop_TransporterLoaded", true];
		_makedelivery = false;
	};

	sleep 5;
};

// clean up
"ObjectiveMkr" setMarkerAlpha 0;
"Task_Transport" setMarkerAlpha 0;

{if (!isNull _x) then {deleteVehicle _x}} forEach [Demo_Arrow, _sphere];
if (SideMissionCancel) then {sleep 5} else {sleep 90};

if (!isNull _grp) then {{deleteVehicle _x; sleep 0.1} forEach units _grp;};
{deleteVehicle _x; sleep 0.1} forEach units _stat_grp;
{deleteVehicle _x; sleep 0.1} forEach units _vehgrp;

{deleteGroup _x} forEach [_grp, _stat_grp, _vehgrp];
if (!isNull _AAveh) then {deleteVehicle _AAveh};
{deleteVehicle _x} forEach ((NearestObjects [objective_pos_logic, [], 30]) select {typeOf _x in objective_ruins});
{deleteVehicle _x} forEach (_smkArr select {!isNull _x});
private _staticGuns = objective_pos_logic getVariable ["INS_ObjectiveStatics",[]];
{deleteVehicle _x} forEach _staticGuns;

Delivery_Box hideObjectGlobal true;
deleteMarker "ObjectiveMkr";

if (true) exitWith {sleep 20; execVM "Objectives\random_objectives.sqf";};
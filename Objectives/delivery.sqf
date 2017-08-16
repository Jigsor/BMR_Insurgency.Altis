//Objectives\delivery.sqf mission by Jigsor

sleep 2;
private ["_newZone","_smoke","_smkArr","_type","_rnum","_objmkr","_AA","_VarName","_grp","_vehgrp","_AAveh","_stat_grp","_inf_patrol","_AA_mob_patrol","_wp","_tskW","_tasktopicW","_taskdescW","_tskE","_tasktopicE","_taskdescE","_droppoint","_dropedcargo","_veh","_text","_deliverydone","_MHQ3DelReady","_sphere","_cargoPos","_staticGuns"];

_newZone = _this select 0;
_rnum = str(round (random 999));
_deliverydone = 0;
deliveryfail = 0;
_MHQ3DelReady = false;
Demo_Loaded = false;
Demo_Unloaded = false;
Demo_Near = false;
Demo_End = false;
Task_Transport = [];
_smkArr = [];
_cargoPos = getPos Del_box_Pos;

if ((INS_op_faction > 3) || (INS_op_faction isEqualTo 0)) then {
	_type = selectRandom INS_Op4_Veh_AA;
}else{
	_type = _this select 1;
};

// Positional info
objective_pos_logic setPos _newZone;

_objmkr = createMarker ["ObjectiveMkr", _newZone];
"ObjectiveMkr" setMarkerShape "ELLIPSE";
"ObjectiveMkr" setMarkerSize [2, 2];
"ObjectiveMkr" setMarkerShape "ICON";
"ObjectiveMkr" setMarkerType "mil_dot";
"ObjectiveMkr" setMarkerColor "ColorRed";
"ObjectiveMkr" setMarkerText "Delivery Zone";

"deliveryfail" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
"Demo_Loaded" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
"Demo_Unloaded" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};

if (isNil "MHQ_3" || !Alive MHQ_3) then {// Create Helicopter MHQ_3 if it doesn't exist. Added to support Revive System(s) lacking MHQ's.
	sleep 8;// wait for possible vehRespawn script
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
		_heli Call Compile Format ["%1=_This ; PublicVariable ""%1""",_HeliName];
		sleep 3;
		_actualPos = (getPosATL MHQ_3);
		_cargoPos = [_actualPos, 5, 14, 5, 0, 0.6, 0] call BIS_fnc_findSafePos;
	};
};

[] spawn {
	Delivery_Box setVariable ["BTK_CargoDrop_ObjectLoaded", false];
	MHQ_3 setVariable ["BTK_CargoDrop_TransporterLoaded", false];

	//// Wait until loaded
	waitUntil {sleep 1; (Delivery_Box getVariable "BTK_CargoDrop_ObjectLoaded") && {(MHQ_3 getVariable "BTK_CargoDrop_TransporterLoaded")}};
	Demo_Loaded = true;
	publicVariable "Demo_Loaded";

	//// Wait until UNloaded
	waitUntil {sleep 0.5; !(Delivery_Box getVariable "BTK_CargoDrop_ObjectLoaded") && !(MHQ_3 getVariable "BTK_CargoDrop_TransporterLoaded")};
	Demo_Unloaded = true;
	publicVariable "Demo_Unloaded";
};

Delivery_Box setPos _cargoPos;
Delivery_Box hideObjectGlobal false;

_sphere = createVehicle ["Sign_Sphere100cm_F", getPosATL Delivery_Box, [], 0, "CAN_COLLIDE"];
sleep jig_tvt_globalsleep;
_sphere setPos [(getPos _sphere select 0),(getPos _sphere select 1),5];

waitUntil {sleep 1; alive MHQ_3};

Demo_Arrow = createVehicle ["Sign_Arrow_Large_Yellow_F", getPosATL MHQ_3, [], 0, "CAN_COLLIDE"];
sleep jig_tvt_globalsleep;
Demo_Arrow setPos [(getPos Demo_Arrow select 0),(getPos Demo_Arrow select 1),6];

private ["_newPos","_tmarker"];
_newPos = (getposATL MHQ_3);

if !(getMarkerColor "Task_Transport" isEqualTo "") then {deleteMarker "Task_Transport";};
_tmarker = createMarker ["Task_Transport", _newPos];
"Task_Transport" setMarkerShape "ICON";
"Task_Transport" setMarkerSize [2, 2];
"Task_Transport" setMarkerType "mil_dot";
"Task_Transport" setMarkerColor "ColorBlue";
"Task_Transport" setMarkerText "Task_Transport";
publicVariable "Task_Transport";
sleep 2;

[] spawn { while {!isNull Demo_Arrow} do { "Task_Transport" setMarkerPos getPosWorld MHQ_3; sleep 1; }; };

// create west task
_tskW = "tskW_Freight_Delivery" + _rnum;
_tasktopicW = localize "STR_BMR_Tsk_topicW_lnds";
_taskdescW = localize "STR_BMR_Tsk_descW_lnds";
[_tskW,_tasktopicW,_taskdescW,WEST,[],"created",_newZone] call SHK_Taskmaster_add;
sleep 5;

// create east task
_tskE = "tskE_Freight_Delivery" + _rnum;
_tasktopicE = localize "STR_BMR_Tsk_topicE_lnds";
_taskdescE = localize "STR_BMR_Tsk_descE_lnds";
[_tskE,_tasktopicE,_taskdescE,EAST,[],"created",_newZone] call SHK_Taskmaster_add;

waitUntil {sleep 1; Demo_Loaded};

deleteVehicle Demo_Arrow; sleep 0.1;
deleteVehicle _sphere; sleep 0.1;
MHQ_3 setDamage 0; sleep 0.3;

[] spawn {
	while {Demo_Loaded} do {
		if (alive MHQ_3) then {
			"Task_Transport" setMarkerPos getPosWorld MHQ_3;
			sleep 1.2;
		};
	};
};


waitUntil {sleep 0.3; (isPlayer (driver MHQ_3)) && {(isEngineOn MHQ_3) && (!isnull (driver MHQ_3))}};

_MHQ3DelReady = true;
[localize "STR_BMR_delivery_ready", "JIG_MPhint_fnc"] call BIS_fnc_mp;
sleep 2;

_text = format [localize "STR_BMR_delivery_ready"];
[[_text],"JIG_MPsideChatWest_fnc"] call BIS_fnc_mp;
sleep 3;

// Spawn Objective Object
_newPos = [_newZone, 0, 75, 10, 0, 0.6, 0] call BIS_fnc_findSafePos;
_AA = [_newPos, 180, _type, INS_Op4_side] call bis_fnc_spawnvehicle;
sleep jig_tvt_globalsleep;
_AAveh = _AA select 0;
_vehgrp = _AA select 2;

_AAveh addeventhandler ["killed","[(_this select 0)] spawn remove_carcass_fnc"];
{_x addeventhandler ["killed","[(_this select 0)] spawn remove_carcass_fnc"]} forEach (units _vehgrp);

_VarName = "DeliveryDefence";
_AAveh setVehicleVarName _VarName;
_AAveh Call Compile Format ["%1=_This ; PublicVariable ""%1""",_VarName];

// Spawn Objective enemy defences
_grp = [_newZone,10] call spawn_Op4_grp; sleep 3;
_stat_grp = [_newZone,3,15] call spawn_Op4_StatDef;

_inf_patrol=[_grp, position objective_pos_logic, 75] call BIS_fnc_taskPatrol;
_AA_mob_patrol=[_vehgrp, position objective_pos_logic, 125] call Veh_taskPatrol_mod;

if (DebugEnabled isEqualTo 1) then {[_grp] spawn INS_Tsk_GrpMkrs;};

if (daytime > 3.00 && daytime < 5.00) then {[] spawn {[[], "INS_fog_effect"] call BIS_fnc_mp};};

// Task Conditions

_veh = MHQ_3;
[_veh] spawn {
	params ["_veh","_text","_loop"];

	for [{_loop=0}, {_loop<1}, {_loop=_loop}] do
	{
		if (Demo_Unloaded) then {
			_loop = 1;
		};
		sleep 0.5;
		if ((isnull (driver _veh)) || (!alive _veh) || (!alive (driver _veh)) && {(Demo_Loaded)}) then {
			[localize "STR_BMR_delivery_destroyed_aborted", "JIG_MPhint_fnc"] call BIS_fnc_mp;
			sleep 3;

			_text = format [localize "STR_BMR_delivery_destroyed_aborted"];
			[[_text],"JIG_MPsideChatWest_fnc"] call BIS_fnc_mp;
			[[_text],"JIG_MPsideChatEast_fnc"] call BIS_fnc_mp;

			deliveryfail = 1;
			publicVariable "deliveryfail";

			_loop = 1;
		};
		sleep 1;
	};
};

while {Demo_Loaded} do {
	sleep 35;
	_smoke1 = createVehicle ["SmokeShellRed", getMarkerPos "ObjectiveMkr", [], 0, "CAN_COLLIDE"];
	_smoke1 setPos [(getPos _smoke1 select 0),(getPos _smoke1 select 1),50];
	_smoke2 = createVehicle ["SmokeShellRed", getMarkerPos "ObjectiveMkr", [], 0, "CAN_COLLIDE"];
	_smoke2 setPos [(getPos _smoke2 select 0),(getPos _smoke2 select 1),100];
	sleep jig_tvt_globalsleep;

	_smkArr pushBack _smoke1;
	_smkArr pushBack _smoke2;

	if (Demo_Unloaded) exitWith {};
	if (deliveryfail isEqualTo 1) exitWith {};
};

if (Demo_Unloaded) then {
	waitUntil {sleep 1; (((getPosatl Delivery_Box select 2) < 2) || (deliveryfail isEqualTo 1))};

	_droppoint = [getMarkerPos "ObjectiveMkr" select 0, getMarkerPos "ObjectiveMkr" select 1];
	_dropedcargo = [getPosatl Delivery_Box select 0, getPosatl Delivery_Box select 1];

	if ((_droppoint distance _dropedcargo < 750) && (deliveryfail isEqualTo 0) && {(alive _veh) && (alive (driver _veh))}) then	{
		_text = format[localize "STR_BMR_delivery_success"];
		[[_text],"JIG_MPTitleText_fnc",WEST,false] call BIS_fnc_mp;
		_deliverydone = 1;
	};

	if ((_droppoint distance _dropedcargo > 750) && (deliveryfail isEqualTo 0) && {(alive _veh) && (alive (driver _veh))}) then {
		_text = format[localize "STR_BMR_delivery_fail"];
		[[_text],"JIG_MPTitleText_fnc",WEST,false] call BIS_fnc_mp;
		deliveryfail = 1;
	}
	else
	{
		if (isnull (driver _veh) || (!alive _veh) || (!alive (driver _veh))) then {
			_text = format[localize "STR_BMR_transport_down"];
			[[_text],"JIG_MPTitleText_fnc",WEST,false] call BIS_fnc_mp;
			deliveryfail = 1;
		};
	};
};

// Win - Loose
waitUntil {sleep 1; ((deliveryfail isEqualTo 1) || (_deliverydone isEqualTo 1))};

if (_deliverydone isEqualTo 1) then {
	[_tskW, "succeeded"] call SHK_Taskmaster_upd;
	[_tskE, "failed"] call SHK_Taskmaster_upd;
};
if (deliveryfail isEqualTo 1) then {
	[_tskE, "succeeded"] call SHK_Taskmaster_upd;
	[_tskW, "failed"] call SHK_Taskmaster_upd;
};

Demo_Loaded = false; publicVariable "Demo_Loaded"; sleep 3;

// clean up
"ObjectiveMkr" setMarkerAlpha 0;
"Task_Transport" setMarkerAlpha 0;

if (!isNull Demo_Arrow) then {deleteVehicle Demo_Arrow;}; sleep 0.1;
if (!isNull _sphere) then {deleteVehicle _sphere;};
sleep 90;

{deleteVehicle _x; sleep 0.1} forEach (units _grp),(units _stat_grp),(units _vehgrp);
{deleteGroup _x} forEach [_grp, _stat_grp, _vehgrp];

if (!isNull _AAveh) then {deleteVehicle _AAveh;};

_staticGuns = objective_pos_logic getVariable "INS_ObjectiveStatics";
{deleteVehicle _x; sleep 0.1} forEach _staticGuns;
{if (typeOf _x in objective_ruins) then {deleteVehicle _x; sleep 0.1}} forEach (NearestObjects [objective_pos_logic, [], 30]);
if (ObjNull in _smkArr) then {{_smkArr = _smkArr - [objNull]} forEach _smkArr;}; {deleteVehicle _x;} count _smkArr;

Delivery_Box hideObjectGlobal true;
deleteMarker "ObjectiveMkr";

if (true) exitWith {sleep 20; nul = [] execVM "Objectives\random_objectives.sqf";};
//random_objectives.sqf by Jigsor
//Randomly selects and generates objectives one at a time.

if (!isserver) exitwith {};
waitUntil{!(isNil "BIS_fnc_init")};
waitUntil {time > 60};

if (missionNameSpace getVariable ["INStasksForced", false]) exitWith {};//Forcing Random Mission In Progress

if (SideMissionCancel) then {
	SideMissionCancel = false;
	publicVariableServer "SideMissionCancel"; sleep 3;
};

private ["_newZone","_mission_mkr","_mkrPos","_xcoor","_ycoor","_type","_objsel"];

_newZone = [];
_mission_mkr = [];

if (objective_list isEqualTo []) then {
	side_mission_mkrs = side_mission_mkrs_copy;
	publicVariableServer "side_mission_mkrs"; sleep 3;
	objective_list = objective_list_copy;
	publicVariableServer "objective_list"; sleep 3;
};

_mission_mkr = selectRandom side_mission_mkrs;
_mkrPos = markerPos _mission_mkr;
_xcoor = (markerPos _mission_mkr select 0);
_ycoor = (markerPos _mission_mkr select 1);

if (DebugEnabled isEqualTo 1) then {diag_log text format ["Mission Marker Pos : %1", _mkrPos];};

{
	if (_mkrPos distance2D (markerPos _x) == 0) then {
		side_mission_mkrs = side_mission_mkrs - [_x];
	};
} foreach side_mission_mkrs;
publicVariable "side_mission_mkrs";
sleep 2;

_newZone = _newZone + [_xcoor,_ycoor] call miss_object_pos_fnc;
if (_newZone isEqualTo []) then {
	private _c = 0;
	while {_newZone isEqualTo []} do {
		_newZone = _newZone + [_xcoor,_ycoor] call miss_object_pos_fnc;
		if (!(_newZone isEqualTo [])) exitWith {_newZone;};
		_c = _c + 1;
		if (_c > 6) exitWith {};
		sleep 4;
	};
};

// select random objective from list
_objsel = selectRandom objective_list;

// uncomment the following lines one at a time to test individual missions
//_objsel = objective_list select 0;// test "comms_tower"
//_objsel = objective_list select 1;// test "kill_leader"
//_objsel = objective_list select 2;// test "rescue_pilot"
//_objsel = objective_list select 3;// test "cut_power"
//_objsel = objective_list select 4;// test "mine_field"
//_objsel = objective_list select 5;// test "deliver_supplies"
//_objsel = objective_list select 6;// test "destroy_convoy"
//_objsel = objective_list select 7;// test "destroy_armed_convoy"
//_objsel = objective_list select 8;// test "destroy_mortar_squad"
//_objsel = objective_list select 9;// test "c_n_h"
//_objsel = objective_list select 10;// test "destroy_roadblock"
//_objsel = objective_list select 11;// test "retrieve_data"
objective_list = objective_list - [_objsel];
publicVariable "objective_list";
sleep 3;

if (_newZone isEqualTo []) exitWith {
	diag_log "";
	diag_log "!!!Objective position invalid!!! Skiping to next objective.";
	diag_log "";
	sleep 10; execVM "Objectives\random_objectives.sqf";
};

switch (_objsel) do
{
	case "comms_tower": {
		_type = objective_objs select 0; [_newZone,_type] execVM "Objectives\comms_tower.sqf";
	};
	case "kill_leader": {
		_type = objective_objs select 1; [_newZone,_type] execVM "Objectives\eliminate_leader.sqf";
	};
	case "rescue_pilot": {
		_type = objective_objs select 2; [_newZone,_type] execVM "Objectives\pilot_rescue.sqf";
	};
	case "cut_power": {
		_type = objective_objs select 3; [_newZone,_type] execVM "Objectives\tower_of_power.sqf";
	};
	case "mine_field": {
		_type = objective_objs select 4; [_newZone,_type] execVM "Objectives\mine_field.sqf";
	};
	case "deliver_supplies": {
		_type = objective_objs select 5; [_newZone,_type] execVM "Objectives\delivery.sqf";
	};
	case "destroy_convoy": {
		_type = objective_objs select 6; [_newZone,_type] execVM "Objectives\sup_convoy.sqf";
	};
	case "destroy_armed_convoy": {
		_type = objective_objs select 7; [_newZone,_type] execVM "Objectives\armed_convoy.sqf";
	};
	case "destroy_mortar_squad": {
		_type = objective_objs select 8; [_newZone,_type] execVM "Objectives\mortar_squad.sqf";
	};
	case "c_n_h": {
		_type = objective_objs select 9; [_newZone,_type] execVM "Objectives\capture_n_hold.sqf";
	};
	case "destroy_roadblock": {
		_type = objective_objs select 10; [_newZone,_type] execVM "Objectives\road_block.sqf";
	};
	case "retrieve_data": {
		_type = objective_objs select 11; [_newZone,_type] execVM "Objectives\data_retrieval.sqf";
	};
};

missionNameSpace setVariable ["INStasksForced", false];
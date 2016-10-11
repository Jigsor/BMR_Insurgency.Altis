//Objectives\tower_of_power.sqf by Jigsor

sleep 2;
private ["_newZone","_type","_rnum","_objmkr","_roads","_roadNear","_roadSegment","_roadDir","_tower","_VarName","_grp","_stat_grp","_handle","_wp","_tskW","_tasktopicW","_taskdescW","_tskE","_tasktopicE","_taskdescE","_towerPos"];

_newZone = _this select 0;
_type = _this select 1;
_roadNear = false;
_rnum = str(round (random 999));
_towerPos = _newZone;

// Positional info
while {isOnRoad _newZone} do {
	_towerPos = _newZone findEmptyPosition [2, 30, _type];
	sleep 0.2;
};

objective_pos_logic setPos _towerPos;

_objmkr = createMarker ["ObjectiveMkr", _towerPos];
"ObjectiveMkr" setMarkerShape "ELLIPSE";
"ObjectiveMkr" setMarkerSize [2, 2];
"ObjectiveMkr" setMarkerShape "ICON";
"ObjectiveMkr" setMarkerType "mil_dot";
"ObjectiveMkr" setMarkerColor "ColorRed";
"ObjectiveMkr" setMarkerText "Cut Power";

_roads = _towerPos nearRoads 20;
if (count _roads > 0) then {
	_roadNear = true;
	_roadSegment = _roads select 0;
	_roadDir = direction _roadSegment;
};

// Spawn Objective Object
_tower = createVehicle [_type, _towerPos, [], 0, "None"];
sleep jig_tvt_globalsleep;

if (_roadNear) then {_tower setDir _roadDir - 90;};
_tower setVectorUp [0,0,1];
_tower addeventhandler ["handledamage",{_this call JIG_tower_damage}];
_VarName = "PowerTower1";
_tower setVehicleVarName _VarName;
_tower Call Compile Format ["%1=_This ; PublicVariable ""%1""",_VarName];

// Spawn Objective enemy deffences
_grp = [_newZone,10] call spawn_Op4_grp;
_stat_grp = [_newZone,3] call spawn_Op4_StatDef; _stat_grp setCombatMode "RED";

_handle=[_grp, position objective_pos_logic, 75] call BIS_fnc_taskPatrol;

if (DebugEnabled > 0) then {[_grp] spawn INS_Tsk_GrpMkrs;};

waitUntil {sleep 1; alive _tower};

// create west task
_tskW = "tskW_Cut_Power" + _rnum;
_tasktopicW = localize "STR_BMR_Tsk_topicW_dhvt";
_taskdescW = localize "STR_BMR_Tsk_descW_dhvt";
[_tskW,_tasktopicW,_taskdescW,WEST,[],"created",_towerPos] call SHK_Taskmaster_add;
sleep 5;

// create east task
_tskE = "tskE_Cut_Power" + _rnum;
_tasktopicE = localize "STR_BMR_Tsk_topicE_dhvt";
_taskdescE = localize "STR_BMR_Tsk_descE_dhvt";
[_tskE,_tasktopicE,_taskdescE,EAST,[],"created",_towerPos] call SHK_Taskmaster_add;

if (INS_environment isEqualTo 1) then {if (daytime > 3.00 && daytime < 5.00) then {[] spawn {[[], "INS_fog_effect"] call BIS_fnc_mp;};};};

waitUntil {sleep 2; !alive _tower};

[] spawn {
	private ["_lights","_lamps","_txtstr"];
	//_lights = ["Lamps_base_F","PowerLines_base_F","PowerLines_Small_base_F"];
	_lights = INS_lights;

	nul = [objective_pos_logic,"HighVoltage"] call mp_Say3D_fnc;
	[[], "hv_tower_effect"] call BIS_fnc_mp;

	[localize "STR_BMR_PowerTower_success", "JIG_MPhint_fnc"] call BIS_fnc_mp;

	for [{_i=0},{_i < (count _lights)},{_i=_i+1}] do {
		_lamps = getPosATL objective_pos_logic nearObjects [_lights select _i, 1000];
		sleep 0.01;
		{_x setDamage 0.95; sleep 0.03} forEach _lamps;
	};
};

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
//Objectives\mine_field.sqf by Jigsor

sleep 2;
params ["_newZone","_type"];
private ["_rnum","_alltskmines","_objmkr","_grp","_stat_grp","_patrole","_wp","_tskW","_tasktopicW","_taskdescW","_tskE","_tasktopicE","_taskdescE","_deadWmen","_knownmines","_nearestMines","_manArray","_checkmines","_minefielrad","_sandbags1","_ins_debug","_random_mine_cnt","_mfieldmkr"];

_rnum = str(round (random 999));
_alltskmines = [];
_deadWmen = [];
_checkmines = true;
_minefielrad = 65;
_ins_debug = if (DebugEnabled isEqualTo 1) then {TRUE}else{FALSE};

_random_mine_cnt = [5,15] call BIS_fnc_randomInt;

// Positional info
objective_pos_logic setPos _newZone;

_objmkr = createMarker ["ObjectiveMkr", _newZone];
"ObjectiveMkr" setMarkerShape "ELLIPSE";
"ObjectiveMkr" setMarkerSize [2, 2];
"ObjectiveMkr" setMarkerShape "ICON";
"ObjectiveMkr" setMarkerType "mil_dot";
"ObjectiveMkr" setMarkerColor "ColorRed";
"ObjectiveMkr" setMarkerText "Mine Field";

_mfieldmkr = createMarker ["MineField", _newZone];
"MineField" setMarkerShape "ELLIPSE";
"MineField" setMarkerColor "ColorRed";
"MineField" setMarkerType "Tank";//"MinefieldAP","mil_dot"
"MineField" setMarkerBrush "Cross";
"MineField" setMarkerSize [65, 65];

// Spawn Objective Objects
_sandbags1 = createVehicle ["Land_BagFence_Round_F", _newZone, [], 0, "NONE"];
sleep jig_tvt_globalsleep;
_sandbags1 setVariable["persistent",true];

// Spawn Objective enemy defences
_grp = [_newZone,10] call spawn_Op4_grp; sleep 3;
_stat_grp = [_newZone,4,25] call spawn_Op4_StatDef;

_patrole = [_grp, position objective_pos_logic, 75] call BIS_fnc_taskPatrol;
if (_ins_debug) then {[_grp] spawn INS_Tsk_GrpMkrs;};

// Spawn mines
for "_i" from 1 to _random_mine_cnt step 1 do {
	private _newpos = _newZone findEmptyPosition [0, _minefielrad, _type];
	private _mine = createMine [_type, _newpos, [], _minefielrad];
	sleep jig_tvt_globalsleep;
	_alltskmines pushBack _mine;
	_mine setVariable["persistent",true];
};

{RESISTANCE revealMine _x;} foreach _alltskmines;
{EAST revealMine _x;} foreach _alltskmines;
if (_ins_debug) then {{INS_Blu_side revealMine _x;} foreach _alltskmines;};

// create west task
_tskW = "tskW_Mine_Field" + _rnum;
_tasktopicW = localize "STR_BMR_Tsk_topicW_cmf";
_taskdescW = localize "STR_BMR_Tsk_descW_cmf";
[_tskW,_tasktopicW,_taskdescW,WEST,[],"created",_newZone] call SHK_Taskmaster_add;
sleep 5;

// create east task
_tskE = "tskE_Mine_Field" + _rnum;
_tasktopicE = localize "STR_BMR_Tsk_topicE_cmf";
_taskdescE = localize "STR_BMR_Tsk_descE_cmf";
[_tskE,_tasktopicE,_taskdescE,EAST,[],"created",_newZone] call SHK_Taskmaster_add;

sleep 8;
if (daytime > 3.00 && daytime < 5.00) then {[] spawn {[[], "INS_fog_effect"] call BIS_fnc_mp};};

while {_checkmines} do
{
	_knownmines = detectedMines west;
	{west revealMine _x;} foreach _knownmines;

	_nearestMines = (getPosATL objective_pos_logic) nearObjects ["TimeBombCore",_minefielrad];//"minebase"

	{
		if (!mineActive _x) then {
			_nearestMines = _nearestMines - [_x];
		};
	} foreach _nearestMines;

	_manArray = (position objective_pos_logic) nearentities ["CAManBase",_minefielrad];

	{
		if (captiveNum _x isEqualTo 1) then	{
			_deadWmen pushBack _x;
		};
		if (side _x in [RESISTANCE,EAST,CIVILIAN]) then {
			_manArray = _manArray - [_x];
		};
	} foreach _manArray;

	if ((count _deadWmen) > 0) exitWith	{
		[_tskE, "succeeded"] call SHK_Taskmaster_upd;
		[_tskW, "failed"] call SHK_Taskmaster_upd;
		_checkmines = false;
	};

	if (count _nearestMines < 1) exitWith {
		[_tskW, "succeeded"] call SHK_Taskmaster_upd;
		[_tskE, "failed"] call SHK_Taskmaster_upd;
		_checkmines = false;
	};
	sleep 5;
};

// clean up
"ObjectiveMkr" setMarkerAlpha 0;
"MineField" setMarkerAlpha 0;
sleep 90;

if (!isNull _sandbags1) then {deleteVehicle _sandbags1};
{deleteVehicle _x; sleep 0.1} forEach (units _grp),(units _stat_grp);
{deleteGroup _x} forEach [_grp, _stat_grp];
{deleteVehicle _x} forEach _alltskmines;
private _staticGuns = objective_pos_logic getVariable "INS_ObjectiveStatics";
{deleteVehicle _x} forEach _staticGuns;
{deleteMarker _x} forEach ["ObjectiveMkr","MineField"];

if (true) exitWith {sleep 20; nul = [] execVM "Objectives\random_objectives.sqf";};
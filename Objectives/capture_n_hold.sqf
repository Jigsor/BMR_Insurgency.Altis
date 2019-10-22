//capture_n_hold.sqf by Jigsor

sleep 2;
params ["_newZone","_type"];

private _rnum = str(round (random 999));
private _cap_rad = 25;
private _hold_rad = 50;
private _defender_rad = 200;
private _VarName = "OutPost1";
private _uncaped = true;
private _caped = true;
private _ins_debug = if (DebugEnabled isEqualTo 1) then {TRUE}else{FALSE};

if !(_ins_debug) then {
	waitUntil {sleep 2; time > 300};//wait until server time sync
};

//Positional info
objective_pos_logic setPos _newZone;
private _objmkr = createMarker ["ObjectiveMkr", _newZone];
"ObjectiveMkr" setMarkerShape "ELLIPSE";
"ObjectiveMkr" setMarkerSize [2, 2];
"ObjectiveMkr" setMarkerShape "ICON";
"ObjectiveMkr" setMarkerType "mil_dot";
"ObjectiveMkr" setMarkerColor "ColorRed";
"ObjectiveMkr" setMarkerText "Capture and Hold";

//Spawn Objective Object
private _outpost = createVehicle [_type, _newZone, [], 0, "NONE"];
sleep jig_tvt_globalsleep;

_outpost setDir (random 359);
_outpost setVectorUp [0,0,1];
_outpost setVehicleVarName _VarName;
_outpost Call Compile Format ["%1=_this; publicVariable '%1'",_VarName];

//Spawn Objective enemy defences
private _grp = [_newZone,10] call spawn_Op4_grp; sleep 3;
private _stat_grp = [_newZone,3,12] call spawn_Op4_StatDef;

//movement
private _handle=[_grp, position objective_pos_logic, 75] call BIS_fnc_taskPatrol;
if (_ins_debug) then {[_grp] spawn INS_Tsk_GrpMkrs;};

//create west task
private _tskW = "tskW_Cap_n_Hold" + _rnum;
private _tasktopicW = localize "STR_BMR_Tsk_topicW_cnho";
private _taskdescW = localize "STR_BMR_Tsk_descW_cnho";
[_tskW,_tasktopicW,_taskdescW,WEST,[],"created",_newZone] call SHK_Taskmaster_add;
sleep 5;
//create east task
private _tskE = "tskE_Cap_n_Hold" + _rnum;
private _tasktopicE = localize "STR_BMR_Tsk_topicE_cnho";
private _taskdescE = localize "STR_BMR_Tsk_descE_cnho";
[_tskE,_tasktopicE,_taskdescE,EAST,[],"created",_newZone] call SHK_Taskmaster_add;

private _dd = missionNameSpace getVariable ["BMR_DawnDusk",[]];
_dd params ["_dawn","_dusk"];

if (daytime > 3.00 && daytime < 5.00) then {0 spawn {[] remoteExec ['INS_fog_effect', [0,-2] select isDedicated]};};

private _fireF = 1;

while {_uncaped} do {

	if (SideMissionCancel) then {
		makewave = false;publicVariable "makewave"; sleep 2;
		killtime = true;publicVariable "killtime"; sleep 2;
		[_tskW, "canceled"] call SHK_Taskmaster_upd;
		[_tskE, "canceled"] call SHK_Taskmaster_upd;
		_uncaped = false;
	};

	if (_fireF isEqualTo 1) then {
		if (daytime > _dusk || daytime < _dawn) then {
			private _sfCount = [1,6] call BIS_fnc_randomInt;
			null=[_sfCount,1,220,"red",100,_newZone] spawn Drop_SmokeFlare_fnc;
			_fireF = 2;
		};
	}else{
		if (_fireF isEqualTo 9) then {_fireF = 1;}else{_fireF = _fireF +1;};
	};

	private _manArray = objective_pos_logic nearEntities ["CAManBase", _cap_rad];
	{
		if (!(side _x isEqualTo INS_Blu_side) || (captiveNum _x isEqualTo 1)) then {
			_manArray = _manArray - [_x];
		};
	} forEach _manArray;
	sleep 4;
	if ((count _manArray) > 0) exitWith {_uncaped = false};
};
waitUntil {!_uncaped};

if (!SideMissionCancel) then {

	if (timesup) then {timesup = false;};
	"timesup" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};

	private _text = format [localize "STR_BMR_outpost_caped"];
	[_text] remoteExec ["JIG_MPsideChatWest_fnc", [0,-2] select isDedicated];

	private _defenderArr = [];
	{_defenderArr pushBack _x} forEach (objective_pos_logic nearEntities ["CAManBase", _defender_rad] select {(side _x isEqualTo west) && !(captiveNum _x isEqualTo 1) && (_x isKindOf "Man")});
	sleep 3;

	private _defcnt = count _defenderArr;
	private "_holdTime";

	switch (true) do {
		case (_defcnt isEqualTo 2) : {_holdTime = 7};
		case (_defcnt isEqualTo 3) : {_holdTime = 8};
		case (_defcnt isEqualTo 4) : {_holdTime = 9};
		case (_defcnt isEqualTo 5) : {_holdTime = 10};
		case (_defcnt isEqualTo 6) : {_holdTime = 11};
		case (_defcnt isEqualTo 7) : {_holdTime = 12};
		case (_defcnt > 7) : {_holdTime = 13};
		default {_holdTime = 7};
	};

	private _currTime = time;
	private _maxTime = (60 * _holdTime) + (_currTime + 30);
	if (_ins_debug) then {diag_log format["***CnH TIMER PARAMETERS: Server Time %1, Timer Length %2, Defenders %3, Max time %4", _currTime, _holdTime, _defcnt, _maxTime];};

	[[false,_holdTime," Hold Outpost"],"scripts\Timer.sqf"] remoteExec ["BIS_fnc_execVM",([0,-2] select isDedicated),false];// without JIP persistance

	private _rwave = [_newZone,_ins_debug,_defcnt,_maxTime] spawn {

		params ["_newZone","_ins_debug","_defcnt","_maxTime"];

		private _cnhWaveUnits = [];
		private _cnhWaveGrps = [];
		private _c = 0;
		curvePosArr = [];
		makewave = true;

		"makewave" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};

		private "_rgrp1";
		while {makewave} do	{
			private _bellDir = if (floor random 2 isEqualTo 0) then {90}else{270};

			//Thanks to Larrow for this next block. Creates 2D obtuse isosceles triangle points.
			private _start_dis = [250,400] call BIS_fnc_randomInt;
			private _start_pos1 = [_newZone, 10, _start_dis, 10, 0, 0.6, 0] call BIS_fnc_findSafePos;
			private _midLength = ( _newZone distance _start_pos1 ) / 2;
			private _midDir = objective_pos_logic getRelDir _start_pos1;
			private _midPos = _newZone getPos [_midLength, _midDir];
			private _pointC = _midPos getPos [_midLength - 1, (_midDir + _bellDir)];

			if (count curvePosArr > 0) then {curvePosArr = curvePosArr - curvePosArr};

			curvePosArr = [_start_pos1,_newZone,_pointC,12,false,_ins_debug] call rej_fnc_bezier;

			private _count = 0;

			while {curvePosArr isEqualTo []} do {
				curvePosArr = [_start_pos1,_newZone,_pointC,12,false,_ins_debug] call rej_fnc_bezier;
				if !(curvePosArr isEqualTo []) exitWith {};
				_count = _count + 1;
				if (_count > 3) exitWith {if (_ins_debug) then {hintSilent "Empty curvePosArr"}; curvePosArr = []};
				sleep 3;
			};
			if (curvePosArr isEqualTo []) exitWith {makewave = false; publicVariable "makewave";};

			if (count curvePosArr > 0) then	{
				_rgrp1 = [_start_pos1,6] call spawn_Op4_grp; sleep 1;

				_cnhWaveGrps pushBack _rgrp1;
				{_cnhWaveUnits pushBack _x;} forEach (units _rgrp1);

				private _sfCount = [3,8] call BIS_fnc_randomInt;
				private _smokePos = (curvePosArr select 6);
				null=[_sfCount,0,215,"red",50,_smokePos] spawn Drop_SmokeFlare_fnc;

				//reinforcement/wave group movement
				for "_i" from 0 to (count curvePosArr) -1 step 1 do {
					private _newPosx = (curvePosArr select 0);

					private _wp = _rgrp1 addWaypoint [_newPosx, 0];
					_wp setWaypointType "MOVE";
					_wp setWaypointSpeed "NORMAL";
					_wp setWaypointBehaviour "AWARE";
					_wp setWaypointFormation "COLUMN";
					_wp setWaypointCompletionRadius 20;

					curvePosArr deleteAt 0;
					sleep 0.2;
				};
				if (_ins_debug) then {[_rgrp1] spawn INS_Tsk_GrpMkrs};

				uiSleep 27;
				if (diag_fps < 26 || _defcnt < 3) then {sleep 27};
				if (!makewave) exitWith {};

				_c = _c + 1;
				if (time > _maxTime || {_c > 30}) then {timesup = true; publicVariable "timesup"; sleep 3; makewave = false; publicVariableServer "makewave";};//added to combat runaway loop on dedi, happens when no player has timer.
			};
		};

		sleep 20;
		{deleteVehicle _x; sleep 0.1} forEach (units _rgrp1);
		deleteGroup _rgrp1; sleep 0.1;

		[_cnhWaveUnits,_cnhWaveGrps] spawn {
			params ["_unitsArr","_grpsArr"];
			sleep 120;
			{deleteVehicle _x} forEach (_unitsArr select {alive _x});
			{deleteGroup _x} count _grpsArr;
		};
	};
};

while {_caped} do {

	if (SideMissionCancel) exitWith {

		makewave = false;publicVariable "makewave"; sleep 2;
		killtime = true;publicVariable "killtime"; sleep 2;
		[_tskW, "canceled"] call SHK_Taskmaster_upd;
		[_tskE, "canceled"] call SHK_Taskmaster_upd;
		_caped = false;
	};

	_manArray = objective_pos_logic nearEntities [["CAManBase","Landvehicle"],_hold_rad];

	{
		if (!(side _x isEqualTo INS_Blu_side) || (captiveNum _x isEqualTo 1)) then {
			_manArray = _manArray - [_x];
		};
	} forEach _manArray;

	if ((count _manArray) < 1) exitWith	{
		makewave = false;publicVariable "makewave"; sleep 2;
		killtime = true;publicVariable "killtime"; sleep 2;
		[_tskE, "succeeded"] call SHK_Taskmaster_upd;
		[_tskW, "failed"] call SHK_Taskmaster_upd;
		_caped = false;
	};

	if (timesup) exitWith {
		makewave = false;publicVariable "makewave"; sleep 2;
		killtime = true;publicVariable "killtime"; sleep 2;
		[_tskW, "succeeded"] call SHK_Taskmaster_upd;
		[_tskE, "failed"] call SHK_Taskmaster_upd;
		_caped = false;
	};

	sleep 4;
};

//clean up
"ObjectiveMkr" setMarkerAlpha 0;
if (SideMissionCancel) then {sleep 5} else {sleep 180};

if (!isNull _outpost) then {deleteVehicle _outpost};
{deleteVehicle _x; sleep 0.1} forEach units _grp;
{deleteVehicle _x; sleep 0.1} forEach units _stat_grp;
{deleteGroup _x} forEach [_grp, _stat_grp];
{deleteVehicle _x} forEach ((NearestObjects [objective_pos_logic, [], 40]) select {typeOf _x in INS_men_list});
{deleteVehicle _x} forEach ((NearestObjects [objective_pos_logic, [], 30]) select {typeOf _x in objective_ruins});
private _staticGuns = objective_pos_logic getVariable ["INS_ObjectiveStatics",[]];
{deleteVehicle _x} forEach _staticGuns;
deleteMarker "ObjectiveMkr";

if (true) exitWith {sleep 20; execVM "Objectives\random_objectives.sqf"};
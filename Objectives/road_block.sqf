//road_block.sqf by Jigsor

sleep 2;
params ["_newZone"];
private ["_type","_rnum","_insdebug","_roads","_sample","_rest","_rad","_allGrps","_allUnits","_run","_rbActive","_roadsSorted","_nearestRoad","_roadConnectedTo","_connectedRoad","_bgPos","_roadDir","_rbmkr","_bargate","_VarName","_bunker1","_bunker2","_unit_type","_unit1","_unit2","_damage","_rbWP","_objmkr","_grp","_handle","_maxtype","_vehPos","_Lveh","_LvehGrp","_handle1","_onActiv","_onDeAct","_bgTrig","_tskW","_tasktopicW","_taskdescW","_tskE","_tasktopicE","_taskdescE","_stat_grp"];

_rnum = str(round (random 999));
_rest = 2;
_rad = 200;
_roads = [];
_sample = [];
_allGrps = [];
_allUnits = [];
_run = true;
_rbActive = true;
_insdebug = if (DebugEnabled isEqualTo 1) then {TRUE}else{FALSE};
RoadBlockEast = objNull;

//find roadblock position and orientation
while {_run} do {
	_sample = _newZone nearRoads _rad;
	sleep _rest;
	if (count _sample > 1) then {
		_roadsSorted = ([_sample,[],{_newZone distance _x},"ASCEND"] call BIS_fnc_sortBy) - [_sample];
		{
			if (!(isOnRoad getPos _x) || ["bridge", getModelInfo _x select 0] call BIS_fnc_inString) then {
				_roadsSorted = _roadsSorted - [_x];
			};
		} forEach _roadsSorted;

		if (count _roadsSorted > 0) then {
			_roadConnectedTo = roadsConnectedTo (_roadsSorted select 0);
			if (count _roadConnectedTo > 0) then {
				_roads pushBack (_roadsSorted select 0);
				_run = false;
			};
		};
	}else{
		_rad = _rad + 100;
		_rest = _rest + 0.5;
	};
};

waitUntil {sleep 1; !_run};

_nearestRoad = _roads select 0;
_bgPos = getPos _nearestRoad;
_connectedRoad = _roadConnectedTo select 0;
_roadDir = [_nearestRoad, _connectedRoad] call BIS_fnc_dirTo;
_bgPos = getPos _nearestRoad;

//create objective marker
if (_bgPos distance _newZone > 200) then {
	_clearPos = [_bgPos, 10, 200, 10, 0, 0.6, 0] call BIS_fnc_findSafePos;
	_newZone = _clearPos;
};
objective_pos_logic setPos _newZone;
_objmkr = createMarker ["ObjectiveMkr", _newZone];
"ObjectiveMkr" setMarkerShape "ELLIPSE";
"ObjectiveMkr" setMarkerSize [2, 2];
"ObjectiveMkr" setMarkerShape "ICON";
"ObjectiveMkr" setMarkerType "mil_dot";
"ObjectiveMkr" setMarkerColor "colorRed";
"ObjectiveMkr" setMarkerText "Destroy Roadblock";

//create roadblock
_bargate = createVehicle ["Land_BarGate_F", _bgPos, [], 0, "NONE"]; sleep jig_tvt_globalsleep;

_VarName = "RoadBlockEast";
_bargate setVehicleVarName _VarName;
_bargate Call Compile Format ["%1=_this; publicVariable '%1'",_VarName]; sleep 0.1;

waitUntil {sleep 1; alive RoadBlockEast};
_bargate allowDamage false;

while {(round (direction _bargate)) != (round _roadDir)} do {
	_bargate setdir _roadDir;
	sleep 0.1;
};

RoadBlockEast setPos [getpos RoadBlockEast select 0,getpos RoadBlockEast select 1,0];

[] spawn {RoadBlockEast animate ["Door_1_rot", 1];};

_bunker1 = createVehicle ["Land_BagBunker_Small_F", _bargate modelToWorld [7.5,-2,-4], [], 0, "CAN_COLLIDE"]; sleep jig_tvt_globalsleep;
_bunker1 setdir (_roadDir -240);

_bunker2 = createVehicle ["Land_BagBunker_Small_F", _bargate modelToWorld [-8.5,-2,-4], [], 0, "CAN_COLLIDE"]; sleep jig_tvt_globalsleep;
_bunker2 setdir (_roadDir -110);

{_x setPos [getpos _x select 0,getpos _x select 1,0];} forEach [_bunker1,_bunker2];

{_x setVariable["persistent",true];} forEach [_bunker1,_bunker2,_bargate];

if(_insdebug) then {
	_rbmkr = createmarker ["ins_sm_roadblock", _bgPos];
	_rbmkr setmarkertype "mil_dot";
	_rbmkr setmarkertext "RoadBlock";
};

//roadblock guard
infGrp1 = createGroup INS_Op4_side;
_unit_type = selectRandom INS_men_list;
_unit1 = infGrp1 createUnit [_unit_type, getPosATL _bargate, [], 0, "NONE"]; sleep jig_tvt_globalsleep;

infGrp2 = createGroup INS_Op4_side;
_unit_type = selectRandom INS_men_list;
_unit2 = infGrp2 createUnit [_unit_type, _bunker2 modelToWorld [0,-4,-1], [], 0, "NONE"]; sleep jig_tvt_globalsleep;

{
	_x addeventhandler ["killed","[(_this select 0)] spawn remove_carcass_fnc"];
	if !(AIdamMod isEqualTo 100) then {
		_x removeAllEventHandlers "HandleDamage";
		_x addEventHandler ["HandleDamage",{_damage = (_this select 2)*AIdamMod;_damage}];
	};
} forEach (units infGrp1),(units infGrp2);

_stat_grp = [_bgPos,1,10] call spawn_Op4_StatDef;

_allGrps pushBack infGrp1;
_allGrps pushBack infGrp2;
_allGrps pushBack _stat_grp;
{_allUnits pushBack _x;} forEach (units infGrp1),(units infGrp2),(units _stat_grp);

(group _unit1) setVariable ["zbe_cacheDisabled",false];
(group _unit2) setVariable ["zbe_cacheDisabled",false];

//roadblock guard movement
_unit1 doMove (_bunker1 modelToWorld [0,2,-1]);

_rbWP = infGrp2 addWaypoint [(_bunker1 modelToWorld [0,-4,-1]), 0];
_rbWP setwaypointtype "MOVE";
_rbWP setwaypointstatements ["True", ""];
_rbWP setWaypointSpeed "LIMITED";
_rbWP setWaypointBehaviour "SAFE";
_rbWP setWaypointTimeout [10, 30, 60];

_rbWP = infGrp2 addWaypoint [(_bunker2 modelToWorld [0,-4,-1]), 0];
_rbWP setwaypointtype "MOVE";
_rbWP setwaypointstatements ["True", ""];
_rbWP setWaypointSpeed "LIMITED";
_rbWP setWaypointBehaviour "SAFE";
_rbWP setWaypointTimeout [10, 30, 60];

_rbWP = infGrp2 addWaypoint [(_bunker1 modelToWorld [0,-4,-1]), 0];
_rbWP setwaypointtype "CYCLE";
_rbWP setwaypointstatements ["True", ""];
_rbWP setWaypointSpeed "LIMITED";
_rbWP setWaypointBehaviour "SAFE";
_rbWP setWaypointTimeout [10, 30, 60];

//infantry patrol
_grp = [_newZone,10] call spawn_Op4_grp; sleep 3;
_allGrps pushBack _grp;
{_allUnits pushBack _x;} forEach (units _grp);

//vehicle patrol
_type = selectRandom INS_Op4_Veh_Light;
_vehPos = [_newZone, 0, 50, 10, 0, 0.6, 0] call BIS_fnc_findSafePos;

_Lveh = createVehicle [_type, _vehPos, [], 0, "NONE"]; sleep jig_tvt_globalsleep;

_Lveh addeventhandler ["killed","[(_this select 0)] spawn remove_carcass_fnc"];

[_Lveh] call anti_collision;
_Lveh setVariable["persistent",true];

createVehicleCrew _Lveh; sleep jig_tvt_globalsleep;
_LvehGrp = (group (crew _Lveh select 0));

{_x addeventhandler ["killed","[(_this select 0)] spawn remove_carcass_fnc"]} forEach (units _LvehGrp);

_allGrps pushBack _LvehGrp;
{_allUnits pushBack _x;} forEach (units _LvehGrp);

//movement
_handle=[_grp, _bgPos, 75] call BIS_fnc_taskPatrol;
_handle1=[_LvehGrp, position objective_pos_logic, 100] call Veh_taskPatrol_mod;
if (_insdebug) then {
	[_grp] spawn INS_Tsk_GrpMkrs;
	[_LvehGrp] spawn INS_Tsk_GrpMkrs;
};

//set skills
if (BTC_p_skill isEqualTo 1) then {[infGrp2] call BTC_AI_init; [infGrp1] call BTC_AI_init; [_LvehGrp] call BTC_AI_init;};

//bargate trigger
_onActiv="RoadBlockEast animate [""Door_1_rot"", 0];";
_onDeAct="RoadBlockEast animate [""Door_1_rot"", 1];";

_bgTrig = createTrigger ["EmptyDetector",_bgPos];
_bgTrig setTriggerArea [125,125,125,FALSE];
_bgTrig setTriggerActivation ["WEST","PRESENT",true];
_bgTrig setTriggerTimeout [2, 2, 2, true];
_bgTrig setTriggerStatements ["this",_onActiv,_onDeAct];

waitUntil {{alive _x} count _allUnits > 1};

//create west task
_tskW = "tskW_Destroy RoadBlock" + _rnum;
_tasktopicW = localize "STR_BMR_Tsk_topicW_drb";
_taskdescW = localize "STR_BMR_Tsk_descW_drb";
[_tskW,_tasktopicW,_taskdescW,WEST,[],"created",_newZone] call SHK_Taskmaster_add;
sleep 5;

//create east task
_tskE = "tskE_Hold RoadBlock" + _rnum;
_tasktopicE = localize "STR_BMR_Tsk_topicE_hrb";
_taskdescE = localize "STR_BMR_Tsk_descE_hrb";
[_tskE,_tasktopicE,_taskdescE,EAST,[],"created",_newZone] call SHK_Taskmaster_add;

if (daytime > 3.00 && daytime < 5.00) then {[] spawn {[[], "INS_fog_effect"] call BIS_fnc_mp};};

//Win/Loose-Only one outcome supported.
while {_rbActive} do {
	if ({alive _x} count _allUnits < 2) exitWith {_rbActive = false;};
	sleep 5;
};

waitUntil {!_rbActive};
[_tskW, "succeeded"] call SHK_Taskmaster_upd;
[_tskE, "failed"] call SHK_Taskmaster_upd;

sleep 3;
deleteVehicle _bgTrig;
[] spawn {RoadBlockEast animate ["Door_1_rot", 1];};

//cleanup
"ObjectiveMkr" setMarkerAlpha 0;
sleep 90;

{deleteVehicle _x} forEach [_bargate,_bunker1,_bunker2,_Lveh];
{deleteGroup _x} forEach _allGrps;
private _staticGuns = objective_pos_logic getVariable "INS_ObjectiveStatics";
{deleteVehicle _x} forEach _staticGuns, _allUnits;
{deleteMarker _x} forEach ["ObjectiveMkr","ins_sm_roadblock"];

if (true) exitWith {sleep 20; nul = [] execVM "Objectives\random_objectives.sqf";};
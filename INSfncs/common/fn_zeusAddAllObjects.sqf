private _unit = _this param [0,objNull,[objNull]];
private _isHC = missionNameSpace getVariable ["IamHC", false];
if (isNull _unit || !isServer || _isHC) exitWith {};

private _curator = getAssignedCuratorLogic _unit;
if (isNull _curator) exitWith {};
private _extractionInProgress = false;
private _exclude = [];
private _objects = [];

//Prevent Zeus from interrupting/breaking an extraction in progress
if (!isNil "EvacHeliW1" && {!isNull EvacHeliW1 && {!isNull (currentPilot EvacHeliW1)}}) then {
	_exclude = missionNameSpace getVariable ["INSzeusExclude", []] select {!isNull _x};
	_extractionInProgress = true;
};

{ if (side _x != sideLogic) then { _objects pushBack _x; }; } forEach allMissionObjects "";

if (_extractionInProgress) then {
	_objects = _objects select {!(_x in _exclude)};
};

_curator synchronizeObjectsAdd [_unit];
_curator addCuratorEditableObjects [_objects,true];
//Prevent Zeus from modifying mission dependant/editor placed and named objects
_curator removeCuratorEditableObjects [[EastAirLogic, air_pat_east, air_pat_west, air_pat_cycle, air_pat_pos, objective_pos_logic, BTC_logic, camstart, INS_fw_1, Del_box_Pos, trig_alarm1, trig_alarm1init, trig_alarm2init, INS_Wep_box, INS_flag, INS_Op4_flag], true];
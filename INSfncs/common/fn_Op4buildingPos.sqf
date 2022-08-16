// fn_Op4buildingPos.sqf
// tries to find a suitable building position to respawn Op4 player. W.I.P...

//params [["_instigator",objNull]];
//if (isNull _instigator) then {


private _mkrs = server getvariable ["EOSmarkers",[]];
if (_mkrs isEqualto [] || {isNil "bastionColor"}) exitWith {_mkrs};
private _green = VictoryColor;
private _activeMkrs = _mkrs select {(markerColor _x isNotEqualTo _green) && (markerAlpha _x isEqualTo 1)};
if (_activeMkrs isEqualto []) exitWith {[]};
private _blu = entities [["SoldierWB"], ["Civilian"], true, true];
if (_blu isEqualto []) exitWith {[]};
private _atBase = _blu inAreaArray trig_alarm1init;
if (!isNil "trig_alarm3init") then {_atBase append (_blu inAreaArray trig_alarm3init)};
private _activeBlu = _blu select {!(_x in _atBase) && {(captiveNum _x isEqualTo 0) || (lifeState _x isEqualTo "HEALTHY") || (lifeState _x isEqualTo "INJURED") || (_x getVariable ["ACE_isUnconscious", false])}};
if (_activeBlu isEqualto []) exitWith {[]};

private _exclude = [];
{
	_exclude = _activeBlu inAreaArray _x;
	if (_exclude isNotEqualTo []) then {_activeMkrs = _activeMkrs - [_x];};
	//if (_exclude isNotEqualTo []) then {_mkr = _x; _activeMkrs deleteAT (_activeMkrs find _mkr);};
}forEach _activeMkrs;
if (_activeMkrs isEqualto []) exitWith {[]};

private _minDis = (AI_SpawnDis max 300) min 550;
private _maxDis = _minDis + 300;

for [{_i=1}, {_i<=(count _activeMkrs - 1)}, {_i=_i+1}] do {
	if (
			(markerPos (_activeMkrs # _i)) distance2D (_activeBlu # 0) < _minDis ||
			{( (markerPos (_activeMkrs # _i)) distance2D (_activeBlu # 0)) > _maxDis}
			//(markerPos (_activeMkrs # _i)) distance2D (_activeBlu # 0) < _minDis && {!(( (markerPos (_activeMkrs # _i)) distance2D (_activeBlu # 0)) > _maxDis)}//original
		) then {
		_activeBlu deleteAt 0;
		_activeMkrs deleteAt _i;
		_i = _i - 1;
		if (_activeBlu isEqualTo []) then { break };
	};
};

diag_log format ["!!!!! %1, -Active Op4 Spawn markers : %2, * %3 -Active Blufor Players within Range : %4", count _activeMkrs, _activeMkrs, count _activeBlu, _activeBlu];
if (_activeBlu isEqualTo [] || _activeMkrs isEqualto []) exitWith {[]};

private _findBuildPoses = {
	params ["_mkrPos"];
	private _bPoses = [];
	{
		private ["_i","_p"];
		for [{_i = 0;_p = _x buildingpos _i}, {str _p != "[0,0,0]"}, {_i = _i + 1;_p = _x buildingpos _i}] do {
			_bPoses pushBack _p;
		};
	} foreach (nearestObjects [_mkrPos, ["Building","HouseBase"], 55, true]);
	_bPoses
};

//vehicles select { _x isKindOf "StaticWeapon" } inAreaArray "myMarker"

private _shuffledMkrs = _activeMkrs call BIS_fnc_arrayShuffle;//maybe not needed
private _mkrPos = [];
private _gPos = [];
private _bPoses = [];
for "_l" from 0 to 9 step 1 do {
	if (_shuffledMkrs isNotEqualTo []) then {
		_mkrPos = markerPos (_shuffledMkrs # 0);
		_shuffledMkrs deleteAt 0;
		_bPoses = [_mkrPos] call _findBuildPoses;
		_gPos = selectRandom (_bPoses select {lineIntersects [AGLToASL _x, (AGLToASL _x) vectorAdd [0,0,10]]});
	};
	if (_gPos isNotEqualTo []) exitWith {_gPos};
};

if (_gPos isEqualTo []) exitWith {[]};
private _finalPos = ASLToATL (AGLToASL _gPos);
//player setpos _finalPos;
missionNameSpace setVariable ["OP4houseSpawn", _finalPos];
//diag_log format ["!!!!!BMR OP4 Building Spawn point succesfully found at %1", _finalPos];

_gPos
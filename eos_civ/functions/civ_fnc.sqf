if (!isServer) exitWith {};
// SINGLE INFANTRY GROUP
params ["_pos","_grpSize","_faction","_side"];
_grpSize params ["_grpMin","_grpMax"];

_d=_grpMax-_grpMin;
_r=floor(random _d);
//if (_r isEqualTo 0) then {_r=ceil(random _d);};//Aprox 12 to 22 percent increase to current lobby parameter probability?
_grpSize=_r+_grpMin;

private _pool=if (surfaceiswater _pos) then {[_faction,1] call eos_fnc_getcivunitpool;}else{[_faction,0] call eos_fnc_getcivunitpool;};

_grp=createGroup _side;

private "_unit";
for "_x" from 1 to _grpSize step 1 do {
	_unitType=selectRandom _pool;
	_unit = _grp createUnit [_unitType, _pos, [], 6, "FORM"];
	(group _unit) setVariable ["zbe_cacheDisabled",true];
};

_grp
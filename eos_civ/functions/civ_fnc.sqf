if (!isServer) exitWith {};
// SINGLE INFANTRY GROUP
private ["_grp","_unit","_pool","_pos","_faction"];

_pos=(_this select 0);
_grpSize=(_this select 1);
_faction=(_this select 2);
_side=(_this select 3);

_grpMin=_grpSize select 0;
_grpMax=_grpSize select 1;
_d=_grpMax-_grpMin;
_r=floor(random _d);
//if (_r isEqualTo 0) then {_r=ceil(random _d);};//Aprox 12 to 22 percent increase to current lobby parameter probability?. 
_grpSize=_r+_grpMin;

if (surfaceiswater _pos) then {_pool=[_faction,1] call eos_fnc_getcivunitpool;}else{_pool=[_faction,0] call eos_fnc_getcivunitpool;};

_grp=createGroup _side;

for "_x" from 1 to _grpSize step 1 do {
	_unitType=selectRandom _pool;
	_unit = _grp createUnit [_unitType, _pos, [], 6, "FORM"];
	(group _unit) setVariable ["zbe_cacheDisabled",true];
};

_grp
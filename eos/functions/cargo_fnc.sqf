HCPresent = if (isNil "Any_HC_present") then {False} else {True};

if ((!isServer && hasInterface) || (HCPresent && isServer)) exitWith{};

params ["_veh","_grpSize","_grp","_faction","_cargoType","_debug","_cargoPool","_emptySeats"];

_debug=false;

_cargoPool=[_faction,_cargoType] call eos_fnc_getunitpool;
_side=side (leader _grp);

// FILL EMPTY SEATS
_emptySeats=_veh emptyPositions "cargo";
if (_debug) then {hint format ["%1",_emptySeats]};

//GET MIN MAX GROUP
_grpMin=_grpSize select 0;
_grpMax=_grpSize select 1;
_d=_grpMax-_grpMin;
_r=floor(random _d);
_grpSize=_r+_grpMin;

// IF VEHICLE HAS SEATS
if (_emptySeats > 0) then {
	// LIMIT SEATS TO FILL TO GROUP SIZE
	if 	(_grpSize > _emptySeats) then {_grpSize = _emptySeats};
	if (_debug) then {hint format ["Seats Filled : %1",_grpSize]};

	for "_x" from 1 to _grpSize do {
		_unit=selectRandom _cargoPool;
		_unit=_unit createUnit [GETPOS _veh, _grp];
	};

	{_x moveincargo _veh}foreach units _grp;
};
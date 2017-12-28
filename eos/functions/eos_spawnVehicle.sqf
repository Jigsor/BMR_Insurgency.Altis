HCPresent = if (isNil "Any_HC_present") then {False} else {True};

if ((!isServer && hasInterface) || (HCPresent && isServer)) exitWith{};

_position=(_this select 0);
_side=(_this select 1);
_faction=(_this select 2);
_type=(_this select 3);
_special = if (count _this > 4) then {_this select 4} else {"CAN_COLLIDE"};

_vehicleType=[_faction,_type] call eos_fnc_getunitpool;
_grp = createGroup _side;

_vehPositions=[(_vehicleType select 0)] call BIS_fnc_vehicleRoles;
_vehicle = createVehicle [(_vehicleType select 0), _position, [], 0, _special];
if ((_vehicleType select 0) isKindof "StaticWeapon") then {_vehicle setDir (random 359);};

_vehCrew=[];

{
	_currentPosition=_x;
	if (_currentPosition select 0 == "driver")then {
		_unit = _grp createUnit [(_vehicleType select 1), _position, [], 0, "CAN_COLLIDE"];
		_unit assignAsDriver _vehicle;
		_unit moveInDriver _vehicle;
		_vehCrew pushBack _unit;
	};

	if (_currentPosition select 0 == "turret")then {
		_unit = _grp createUnit [(_vehicleType select 1), _position, [], 0, "CAN_COLLIDE"];
		_unit assignAsGunner _vehicle;
		_unit MoveInTurret [_vehicle,_currentPosition select 1];
		_vehCrew pushBack _unit;
	};
}foreach _vehPositions;

if (INS_op_faction isEqualTo 16) then {[_vehicle] call Trade_Biofoam_fnc};

_return=[_vehicle,_vehCrew,_grp];

_return
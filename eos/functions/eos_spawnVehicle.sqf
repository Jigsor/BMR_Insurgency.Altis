HCPresent = if (isNil "Any_HC_present") then {False} else {True};

if ((!isServer && hasInterface) || (HCPresent && isServer)) exitWith{};

_position=(_this # 0);
_side=(_this # 1);
_faction=(_this # 2);
_type=(_this # 3);
_special = if (count _this > 4) then {_this # 4} else {"CAN_COLLIDE"};

_vehicleType=[_faction,_type] call eos_fnc_getunitpool;

_vehPositions=[(_vehicleType # 0)] call BIS_fnc_vehicleRoles;
_vehicle = createVehicle [(_vehicleType # 0), _position, [], 0, _special];
if ((_vehicleType # 0) isKindof "StaticWeapon") then {_vehicle setDir random 359};

_vehCrew=[];
_grp = createGroup _side;

{
	_currentPosition=_x;
	if (_currentPosition # 0 == "driver")then {
		_unit = _grp createUnit [(_vehicleType # 1), _position, [], 0, "CAN_COLLIDE"];
		if !(side _unit isEqualTo INS_Op4_side) then {[_unit] joinSilent _grp};
		_unit assignAsDriver _vehicle;
		_unit moveInDriver _vehicle;
		_vehCrew pushBack _unit;
	};

	if (_currentPosition # 0 == "turret")then {
		_unit = _grp createUnit [(_vehicleType # 1), _position, [], 0, "CAN_COLLIDE"];
		if !(side _unit isEqualTo INS_Op4_side) then {[_unit] joinSilent _grp};
		_unit assignAsGunner _vehicle;
		_unit MoveInTurret [_vehicle,_currentPosition # 1];
		_vehCrew pushBack _unit;
	};
}foreach _vehPositions;

if (INS_op_faction isEqualTo 16) then {[_vehicle] call Trade_Biofoam_fnc};

_return=[_vehicle,_vehCrew,_grp];

_return
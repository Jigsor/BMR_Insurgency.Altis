


params ["_position","_side","_faction","_type"];

_special = if (count _this > 4) then {_this # 4} else {"CAN_COLLIDE"};

_vehicleType=[_faction,_type] call eos_fnc_getcivunitpool;

_vehPositions=[(_vehicleType # 0)] call BIS_fnc_vehicleRoles;
_vehicle = createVehicle [(_vehicleType # 0), _position, [], 0, _special];

_vehCrew=[];
_grp = createGroup _side;

{
	_currentPosition=_x;
	if (_currentPosition # 0 == "driver")then {
		_unit = _grp createUnit [(_vehicleType # 1), _position, [], 0, "CAN_COLLIDE"];
		_unit assignAsDriver _vehicle;
		_unit moveInDriver _vehicle;
		_vehCrew pushBack _unit;
	};
	if (_currentPosition # 0 == "turret")then {
		_unit = _grp createUnit [(_vehicleType # 1), _position, [], 0, "CAN_COLLIDE"];
		_unit assignAsGunner _vehicle;
		_unit MoveInTurret [_vehicle,_currentPosition # 1];
		_vehCrew pushBack _unit;
	};
} foreach _vehPositions;

_return=[_vehicle,_vehCrew,_grp];

_return
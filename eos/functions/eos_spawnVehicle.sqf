HCPresent = if (isNil "Any_HC_present") then {False} else {True};

if ((!isServer && hasInterface) || (HCPresent && isServer)) exitWith{};

params ["_position","_side","_faction","_type"];

_vehicleParams=[_faction,_type] call eos_fnc_getunitpool;
_vehicleParams params ["_vehType","_unitType"];

_special=if (count _this > 4) then {_this # 4} else {"CAN_COLLIDE"};
_vehRoles=_vehType call BIS_fnc_vehicleRoles;
_vehRoleCount=count _vehRoles;

if (_vehRoleCount > 8) then {
	if (_vehType isKindOf "AIR") then {
		_vehRoles deleteRange [10, _vehRoleCount];//reduce AI count in Air vehicles to 10 max.
	} else {
		_vehRoles deleteRange [8, _vehRoleCount];//reduce AI count in non Air vehicles to 8 max.
	};
};

_vehicle=createVehicle [_vehType, _position, [], 0, _special];
if (_vehType isKindof "StaticWeapon") then {_vehicle setDir random 359};

_vehCrew=[];
_grp = createGroup _side;

{
	_currentPosition=_x;
	if (_currentPosition # 0 == "Driver")then {
		_unit=_grp createUnit [_unitType, _position, [], 0, "CAN_COLLIDE"];
		if (side _unit isNotEqualTo INS_Op4_side) then {[_unit] joinSilent _grp};
		_unit assignAsDriver _vehicle;
		_unit moveInDriver _vehicle;
		_vehCrew pushBack _unit;
	};

	if (_currentPosition # 0 == "Turret")then {
		_unit=_grp createUnit [_unitType, _position, [], 0, "CAN_COLLIDE"];
		if (side _unit isNotEqualTo INS_Op4_side) then {[_unit] joinSilent _grp};
		_unit assignAsGunner _vehicle;
		_unit MoveInTurret [_vehicle,_currentPosition # 1];
		_vehCrew pushBack _unit;
	};
}foreach _vehRoles;

if (INS_op_faction in [20]) then {[_vehicle] call Trade_Biofoam_fnc};

_return=[_vehicle,_vehCrew,_grp];

_return
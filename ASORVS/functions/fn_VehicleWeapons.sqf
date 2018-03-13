private ["_veh","_getTurrets","_vehConfig","_vehTurrets"];
_weapons = [];
_veh = [_this,0,objnull,[objnull,""]] call bis_fnc_param;

if !(_veh isEqualType "") then {_veh = typeof _veh};

_getTurrets = {
	private ["_turrets","_turretPath","_turret","_hasGunner", "_t"];
	_turrets = (_this select 0) >> "turrets";
	if (isclass _turrets) then {
		if (count _turrets > 0) then {
			for "_t" from 0 to (count _turrets - 1) do {
				_turret = _turrets select _t;
				if (isClass _turret) then {
					{
						_weapons pushback getText(configFile >> "CfgWeapons" >> _x >> "DisplayName");
					} forEach getArray(_turret >> "Weapons");
					[_turret] call _getTurrets;
				};
			};
		};
	};
};

_vehConfig = configfile >> "cfgvehicles" >> _veh;
_vehTurrets = [_vehConfig];
{
	_weapons pushback getText(configFile >> "CfgWeapons" >> _x >> "DisplayName");
} forEach getArray(_vehConfig >> "Weapons");
[_vehConfig] call _getTurrets;
_weapons
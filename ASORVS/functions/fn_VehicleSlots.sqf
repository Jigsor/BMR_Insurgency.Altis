private ["_veh","_getTurrets","_vehConfig","_slots","_i"];
_slots = [];
_veh = _this param [0,objnull,[objnull,""]];

if !(_veh isEqualType "") then {_veh = typeof _veh};
_driverIsCommander = 0;
_commanderNames = ["commander"];
_copilotNames = ["copilot", "co-pilot"];
_getTurrets = {
	private ["_turrets","_turretPath","_turret","_hasGunner", "_t"];
	_turrets = (_this select 0) >> "turrets";
	if (isclass _turrets) then {
		if (count _turrets > 0) then {
			for "_t" from 0 to (count _turrets - 1) step 1 do {
				_turret = _turrets select _t;
				if (isclass _turret) then {
					_noGunner = (getNumber (_turrets >> "gunnerNotSpawned")) == 1;
					_hasGunner = getnumber (_turret >> "hasGunner");
					_turretInAction = tolower(getText (_turret >> "gunnerAction"));
					switch(true) do {
						//not a real turret
						case (_noGunner || (_turretInAction in ["", "disabled"]) || (_hasGunner <= 0)) : {};
						case (toLower (getText (_turret >> "GunnerName")) in _commanderNames) : { _slots pushBack "COMMANDER"; };
						case (toLower (getText (_turret >> "GunnerName")) in _copilotNames) : { _slots pushBack "COPILOT"; };
						case ((getNumber(_turret >> "isPersonTurret")) > 0) : { _slots pushBack "PLAYERTURRET"; };
						default { _slots pushBack "GUNNER"; };
					};
					[_turret] call _getTurrets;
				};
			};
		};
	};
};

_vehConfig = configfile >> "cfgvehicles" >> _veh;
_driverIsCommander = getNumber(_vehConfig >> "driverIsCommander");
_driverinaction = tolower (getText(_vehConfig >> "driverAction"));
if ((getNumber(_vehConfig >> "hasDriver") > 0) && !(_driverinaction in ["", "disabled"])) then {
	_slots pushBack "DRIVER";
};
[_vehConfig] call _getTurrets;
for[{_i = 0}, {_i < getNumber (_vehConfig >> "transportSoldier")}, {_i = _i + 1}] do {
	_slots pushBack "TRANSPORT";
}; 
_slots
remove_carcass_fnc = {
	// Deletes dead bodies and destroyed vehicles. Code by BIS
	_unit = _this select 0;
	sleep 2;
	if (not (_unit isKindOf "Man")) then {
		{_x setPos position _unit} forEach crew _unit;
		sleep 120;
		deleteVehicle _unit;
	};
	if (_unit isKindOf "Man") then {
		if(not ((vehicle _unit) isKindOf "Man")) then {_unit setPos (position vehicle _unit)};
		sleep 135;
		hideBody _unit;
		_unit removeAllEventHandlers "killed";
	};
};
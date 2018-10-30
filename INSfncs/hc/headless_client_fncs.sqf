remove_carcass_fnc = {
	// Deletes dead bodies and destroyed vehicles. Code by BIS
	params ['_unit'];
	sleep 2;
	if !(_unit isKindOf "Man") then {
		{_x setPos position _unit} forEach crew _unit;
		sleep 120;
		deleteVehicle _unit;
	};
	if (_unit isKindOf "Man") then {
		if !((vehicle _unit) isKindOf "Man") then {_unit setPos (position vehicle _unit)};
		sleep 135;
		_unit removeAllEventHandlers "killed";
		hideBody _unit;
	};
};
HC_deleteEmptyGrps = {
	{deleteGroup _x} forEach (allGroups select {local _x && {(count units _x) isEqualTo 0}});
};
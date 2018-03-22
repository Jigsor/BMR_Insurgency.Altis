remove_carcass_fnc = {
	// Deletes dead bodies and destroyed vehicles. Code by BIS
	params ["_unit"];
	sleep 2;
	if !(_unit isKindOf "Man") then {
		{_x setPos position _unit} forEach crew _unit;
		sleep 120;
		deleteVehicle _unit;
	};
	if (_unit isKindOf "Man") then {
		if !((vehicle _unit) isKindOf "Man") then {_unit setPos (position vehicle _unit)};
		sleep 135;
		hideBody _unit;
		_unit removeAllEventHandlers "killed";
	};
};
HC_deleteEmptyGrps = {
	{
		if ((count (units _x)) == 0) then {
			deleteGroup _x;
			_x = grpNull;
			_x = nil
		};
	} forEach allGroups;
};
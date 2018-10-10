//Adapted from Zonekiller's Array Builder -- Moser 07/18/2014
//http://forums.bistudio.com/showthread.php?109423-Zonekiller-s-Array-Builder
//Determines faction and classname of player, then convert them to strings (strings are easier to work with configs!)

_faction = [format["%1",faction player]];
_classname = format["%1",typeOf player];
_allowedmenclass = ["Man"]; //required if you want to only find men and not vehicles
_forbidedmenclass = [];// Men not to add -- optional
bon_recruit_recruitableunits = [];// List of arrays it will make -- only need one global array to pass to the rest of Bon's scripts

_CfgVehicles = configFile >> "CfgVehicles";
_CfgVehicleClass = configFile >> "CfgVehicleClass";
_subfaction = [getText(_CfgVehicles >> _classname >> "vehicleClass")];

for "_i" from 1 to ((count _CfgVehicles) - 1) step 1 do {
	_Vehicle = _CfgVehicles select _i;
	if ((isClass _Vehicle) && ((getnumber(_Vehicle >> "scope")) == 2) && !((configName _Vehicle) isKindOf "Building") && !((configName _Vehicle) isKindOf "Thing")) then {
		_go = 0;
		{
			if ((configName _Vehicle) isKindOf _x) exitwith {
				_go = 1;
				{if ((configName _Vehicle) isKindOf _x) exitwith {_go = 0}} foreach _forbidedmenclass;
				if (_go isEqualTo 1) then {// Makes arrays of men from the faction and subfaction
					if ((getText(_Vehicle >> "faction") in _faction) && (getText(_Vehicle >> "vehicleClass") in _subfaction)) then {bon_recruit_recruitableunits = bon_recruit_recruitableunits + [configName _Vehicle]};
				};
				_go = 0;
			};
		} foreach _allowedmenclass;
	};
};
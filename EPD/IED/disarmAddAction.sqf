/* original work from: Tankbuster */
/* adapted from:  Dynamic IED script by - Mantis -*/
/* Rewritten by Brian Sweeney - [EPD] Brian*/
params ["_unit","_b","_pd","_iedNumber"];
if(not isNull _b) then {
	_itemRequirement = "";
	for "_i" from 0 to (count itemsRequiredToDisarm) -1 step 1 do{
		_itemRequirement = _itemRequirement + format[" and ((items player) find ""%1"" > -1)", itemsRequiredToDisarm select _i];
	};

	_unit addAction [("<t color='#27EE1F'>") + ("Disarm") + "</t>", "EPD\IED\Disarm.sqf", [ _b, _pd, _iedNumber], 10, false, true, "", format["(_target distance _this < 3) %1", _itemRequirement]];

};
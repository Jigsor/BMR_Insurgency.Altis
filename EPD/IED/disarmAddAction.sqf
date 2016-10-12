/* original work from: Tankbuster */
/* adapted from:  Dynamic IED script by - Mantis -*/
/* Rewritten by Brian Sweeney - [EPD] Brian*/
_unit = _this select 0;
_b = _this select 1;
_pd = _this select 2;
_iedNumber = _this select 3;
if(not isNull _b) then {
	_itemRequirement = "";
	for "_i" from 0 to (count itemsRequiredToDisarm) -1 do{
		_itemRequirement = _itemRequirement + format[" and ((items player) find ""%1"" > -1)", itemsRequiredToDisarm select _i];
	};

	_unit addAction [("<t color=""#27EE1F"">") + ("Disarm") + "</t>", "EPD\IED\Disarm.sqf", [ _b, _pd, _iedNumber], 10, false, true, "", format["(_target distance _this < 3) %1", _itemRequirement]];

};
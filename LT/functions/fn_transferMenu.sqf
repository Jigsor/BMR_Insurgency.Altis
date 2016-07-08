/*
	File: fn_transferMenu.sqf
	Author Bryan "Tonic" Boardwine

	Description:
	Opens the transfer menu to transfer a saved loadout to
	another player in the server.
*/
private["_control","_slot","_loadout","_teammates"];
disableSerialization;

if (isNil "LT_distance") then
{
	LT_distance = 0;
};

//Check if variable is number, and if it is not it will be set to 0 because of parseNumber
LT_distance = parseNumber (str LT_distance);

if(!createDialog "LT_TransferMenu") exitWith {hint "Couldn't open the transfer menu?"};

_control = ((findDisplay 2560) displayCtrl 2601);
//Fill the units units list.

_teammates = [];
{
	_teammates = _teammates + [_x];
} foreach units group player;

{
	if (!(_x in _teammates)) then {
		_teammates = _teammates + [_x];
	};
} foreach playableUnits;

{
	if (alive _x) then {
		if (str(_x) != str(player)) then {
			if (LT_distance <= 0) then {
				_control lbAdd format["%1", name _x];
				_control lbSetData[(lbSize _control)-1,str _x];
			}
			else
			{
				if ((_x distance player) <= LT_distance) then {
					_control lbAdd format["%1", name _x];
					_control lbSetData[(lbSize _control)-1,str _x];
				};
			};
		};
		//_control lbSetPicture [(lbSize _control)-1,([_x,"texture"] call BIS_fnc_rankParams)];
	};
} foreach _teammates;
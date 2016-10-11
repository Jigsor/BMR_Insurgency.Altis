disableSerialization;

_control = ((findDisplay 2610) displayCtrl 2612);
if(lbCurSel _control == -1) exitWith {};
_targetUser = _control lbData (lbCurSel _control);



if(_targetUser == "") exitWith {hint "Bad Unit"};
{if(str(_x) == _targetUser) exitWith {_targetUser = _x;}} foreach playableUnits; //Fetch the users actual object.
if(isNull _targetUser) exitWith {hint "Bad Unit"};

[_targetUser, [missionNamespace, "LT_Check_Player"]] call BIS_fnc_saveInventory;

[player, [missionNamespace, "LT_Check_Player"]] call bis_fnc_loadInventory;

hint format ["Loadout from %1 has been loaded", _targetUser];

closeDialog 0;

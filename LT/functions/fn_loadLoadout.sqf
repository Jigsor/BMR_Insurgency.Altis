private["_control","_targetUserData", "_index", "_targetUser", "_length", "_selectData"];
disableSerialization;

_control = ((findDisplay 2580) displayCtrl 2801);
if(lbCurSel _control == -1) exitWith {};
_loadoutNumber = _control lbData (lbCurSel _control);

_loadoutName = profileNamespace getVariable "bis_fnc_saveInventory_data" select ((parseNumber _loadoutNumber));

[player, [profileNamespace, _loadoutName]] call bis_fnc_loadInventory;

hint format ["%1 loaded", _loadoutName];
closeDialog 0;
disableSerialization;

_control = ((findDisplay 2620) displayCtrl 2621);
if(lbCurSel _control == -1) exitWith {};
_loadoutNumber = _control lbData (lbCurSel _control);

_data = profileNamespace getVariable "bis_fnc_saveInventory_data";

_loadoutName = _data select ((parseNumber _loadoutNumber));
_control = ((findDisplay 2620) displayCtrl 2623);
_control ctrlSetText _loadoutName;
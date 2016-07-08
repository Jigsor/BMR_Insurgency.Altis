private["_control","_slot","_loadout","_data", "_numberLoadouts","_targetUser"];
disableSerialization;

_control = ((findDisplay 2560) displayCtrl 2601);
if(lbCurSel _control == -1) exitWith {};
_targetUser = _control lbData (lbCurSel _control);
if(_targetUser == "") exitWith {hint "Bad Unit"};
closeDialog 0;

if(!createDialog "LT_TransferLoadout") exitWith {hint "Couldn't open the transfer menu?"};

_control = ((findDisplay 2570) displayCtrl 2701);
//Fill the units units list.

_data = profileNamespace getVariable "bis_fnc_saveInventory_data";
_numberLoadouts = ((count _data) / 2) - 1;

for "_i" from 0 to _numberLoadouts do
{
	_selectNum = _i * 2;

	_control lbAdd format ["%1", _data select _selectNum];
	_control lbSetData[(lbSize _control)-1, _targetUser + "&??&" + (str _selectNum)];
};
disableSerialization;

_control = ((findDisplay 2620) displayCtrl 2621);
lbClear _control;

_data = profileNamespace getVariable "bis_fnc_saveInventory_data";
_numberLoadouts = ((count _data) / 2) - 1;

for "_i" from 0 to _numberLoadouts do
{
	_selectNum = _i * 2;

	_control lbAdd format ["%1", _data select _selectNum];
	_control lbSetData[(lbSize _control)-1,((str _selectNum))];
};

if (count _this > 0) then
{
	_control lbSetCurSel (_this select 0);
};

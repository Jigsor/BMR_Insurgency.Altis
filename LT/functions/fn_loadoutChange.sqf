disableSerialization;


_control = ((findDisplay 2510) displayCtrl 2511);
if(lbCurSel _control == -1) exitWith {};
_loadoutNumber = _control lbData (lbCurSel _control);

_data = profileNamespace getVariable "bis_fnc_saveInventory_data";
_numberLoadouts = (count _data) - 1;

_control = ((findDisplay 2510) displayCtrl 2513);

switch (parseNumber _loadoutNumber) do
{
	case  0:
	{
		lbClear _control;
		_control lbAdd "Down";
		_control lbSetData[(lbSize _control)-1,"down"];

		_control lbAdd "Edit";
		_control lbSetData[(lbSize _control)-1,"edit"];

		_control lbAdd "Delete";
		_control lbSetData[(lbSize _control)-1,"delete"];

		_control lbAdd "Bottom";
		_control lbSetData[(lbSize _control)-1,"bottom"];
	};

	case (_numberLoadouts - 1):
	{
		lbClear _control;
		_control lbAdd "Up";
		_control lbSetData[(lbSize _control)-1,"up"];

		_control lbAdd "Edit";
		_control lbSetData[(lbSize _control)-1,"edit"];

		_control lbAdd "Delete";
		_control lbSetData[(lbSize _control)-1,"delete"];

		_control lbAdd "Top";
		_control lbSetData[(lbSize _control)-1,"top"];
	};

	default
	{
		lbClear _control;
		_control lbAdd "Up";
		_control lbSetData[(lbSize _control)-1,"up"];

		_control lbAdd "Down";
		_control lbSetData[(lbSize _control)-1,"down"];


		_control lbAdd "Edit";
		_control lbSetData[(lbSize _control)-1,"edit"];

		_control lbAdd "Delete";
		_control lbSetData[(lbSize _control)-1,"delete"];

		_control lbAdd "Top";
		_control lbSetData[(lbSize _control)-1,"top"];

		_control lbAdd "Bottom";
		_control lbSetData[(lbSize _control)-1,"bottom"];
	};
};

//if (_loadoutNumber == 0) then 2513



_loadoutName = _data select ((parseNumber _loadoutNumber));
_control = ((findDisplay 2510) displayCtrl 2512);
_control ctrlSetText _loadoutName;


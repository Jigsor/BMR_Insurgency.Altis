disableSerialization;

_control = ((findDisplay 2620) displayCtrl 2621);
if(lbCurSel _control == -1) exitWith {};
_loadoutPosition = parseNumber (_control lbData (lbCurSel _control));
_loadoutNumber = (_loadoutPosition / 2);


_control = ((findDisplay 2620) displayCtrl 2623);
_newName = ctrlText _control;

_dataLoadout = profileNamespace getVariable "bis_fnc_saveInventory_data";
_numberLoadouts = ((count _dataLoadout) / 2) - 1;

_overwrite = -1;

	for "_i" from 0 to _numberLoadouts do
	{
		_selectNum = _i * 2;

		_loadoutName = profileNamespace getVariable "bis_fnc_saveInventory_data" select _selectNum;

		if (_newName == _loadoutName) then
		{
			_overwrite = _i;
		};

	};

	if (_overwrite != -1) then
	{
		if(!createDialog "LT_prompt") exitWith {hint "LT_prompt ERROR";};

		waitUntil {!isNull (findDisplay 2550)};

		((findDisplay 2550) displayCtrl 2551) ctrlSetStructuredText parseText format["<t align='center'><t size='0.8px'>Are you sure you want to overwrite loadout:</t></t><br/><t align='center'><t size='0.7px'>%1</t></t>", _newName];

		((findDisplay 2550) displayCtrl 2552) ctrlSetText "Yes";

		((findDisplay 2550) displayCtrl 2553) ctrlSetText "No";

		waitUntil {!isNil "lt_prompt_choice"};
		if(lt_prompt_choice) then
		{

			[player, [profileNamespace, _newName]] call BIS_fnc_saveInventory;
			hint format ["%1 Saved", _newName];
			closeDialog 0;
		};

		lt_prompt_choice = nil;

	}
	else
	{

		[player, [profileNamespace, _newName]] call BIS_fnc_saveInventory;
		hint format ["%1 Saved", _newName];
		closeDialog 0;
	};



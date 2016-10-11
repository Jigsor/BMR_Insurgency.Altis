disableSerialization;

_control = ((findDisplay 2510) displayCtrl 2511);
if(lbCurSel _control == -1) exitWith {};
_loadoutPosition = parseNumber (_control lbData (lbCurSel _control));
_loadoutNumber = (_loadoutPosition / 2);


_control = ((findDisplay 2510) displayCtrl 2512);
_newName = ctrlText _control;
_originalName = profileNamespace getVariable "bis_fnc_saveInventory_data" select _loadoutPosition;



_dataLoadout = profileNamespace getVariable "bis_fnc_saveInventory_data";
_numberLoadouts = ((count _dataLoadout) / 2) - 1;

_overwrite = -1;


if (_newName != _originalName) then
{
	for "_i" from 0 to _numberLoadouts do
	{
		_selectNum = _i * 2;

		if (_loadoutNumber != _i) then
		{
			_loadoutName = profileNamespace getVariable "bis_fnc_saveInventory_data" select _selectNum;

			if (_newName == _loadoutName) then
			{
				_overwrite = _i;
			};
		};
	};

	if (_overwrite != -1) then
	{
		if(!createDialog "LT_prompt") exitWith {hint "LT_prompt ERROR";};

		waitUntil {!isNull (findDisplay 2550)};

		((findDisplay 2550) displayCtrl 2551) ctrlSetStructuredText parseText format["<t align='center'><t size='.8px'>Are you sure you want to overwrite loadout:</t></t><br/><t align='center'><t size='0.6px'>%1</t></t>", _newName];

		((findDisplay 2550) displayCtrl 2552) ctrlSetText "Yes";

		((findDisplay 2550) displayCtrl 2553) ctrlSetText "No";

		waitUntil {!isNil "lt_prompt_choice"};
		if(lt_prompt_choice) then
		{
			_newData = [];

			for "_i" from 0 to _numberLoadouts do
			{
				_selectNum = _i * 2;

				if (_i != _overwrite) then
				{
					if (_i == _loadoutNumber) then
					{
						_newData = _newData + [_newName];
						_newData = _newData + [_dataLoadout select (_selectNum + 1)];
					}
					else
					{
						_newData = _newData + [_dataLoadout select _selectNum];
						_newData = _newData + [_dataLoadout select (_selectNum + 1)];
					};
				};
			};

			profileNamespace setVariable ["bis_fnc_saveInventory_data", _newData];

			if (_overwrite > _loadoutNumber) then
			{
				[_loadoutNumber] call LT_FNC_modifyLoad;
			}
			else
			{

				[(_loadoutNumber - 1)] call LT_FNC_modifyLoad;
			};
		};

		lt_prompt_choice = nil;

	}
	else
	{
		_newData = [];

		for "_i" from 0 to _numberLoadouts do
		{
			_selectNum = _i * 2;

			if (_i == _loadoutNumber) then
			{
				_newData = _newData + [_newName];
				_newData = _newData + [_dataLoadout select (_selectNum + 1)];
			}
			else
			{
				_newData = _newData + [_dataLoadout select _selectNum];
				_newData = _newData + [_dataLoadout select (_selectNum + 1)];
			};

		};

		profileNamespace setVariable ["bis_fnc_saveInventory_data", _newData];

		[(_loadoutNumber)] call LT_FNC_modifyLoad;

	};




};


private["_transfer", "_arsenal", "_loadServer", "_modPosition"];

_transfer = true;
_arsenal = true;
_manageLoadouts = true;
_loadServer = false;
_adminOptions = true;
_modPosition = 0;

if (count _this > 0) then
{
	_transfer = _this select 0;
};

if (count _this > 1) then
{
	_arsenal = _this select 1;
};

if (count _this > 2) then
{
	_manageLoadouts = _this select 2;
};

if (count _this > 3) then
{
	_loadServer = false;
};
if (count _this > 4) then
{
	_adminOptions = _this select 4;
};


disableSerialization;

if(!createDialog "LT_MainMenu") exitWith {hint "Couldn't open the loadout menu?"};

if (!(_transfer)) then
{
	_control = ((findDisplay 2400) displayCtrl 2402);
	_control ctrlShow false;
	_modPosition = _modPosition + 0.05;

}
else
{
	_control = ((findDisplay 2400) displayCtrl 2402);
	_control ctrlSetPosition [0.51, 0.35];
	_pos = ctrlPosition _control;
	_posX = _pos select 0;
	_posY = (_pos select 1) - _modPosition;


	_control ctrlSetPosition [_posX, _posY];
	_control ctrlCommit 0;

};

if (!(_arsenal)) then
{
	_control = ((findDisplay 2400) displayCtrl 2403);
	_control ctrlShow false;
	_modPosition = _modPosition + 0.05;
}
else
{
	_control = ((findDisplay 2400) displayCtrl 2403);
	_control ctrlSetPosition [0.51, 0.35];
	_pos = ctrlPosition _control;
	_posX = _pos select 0;
	_posY = (_pos select 1) - _modPosition;


	_control ctrlSetPosition [_posX, _posY];
	_control ctrlCommit 0;

};

if (!(_manageLoadouts)) then
{
	_control = ((findDisplay 2400) displayCtrl 2404);
	_control ctrlShow false;
	_modPosition = _modPosition + 0.05;
}
else
{
	_control = ((findDisplay 2400) displayCtrl 2404);
	_control ctrlSetPosition [0.51, 0.35];
	_pos = ctrlPosition _control;
	_posX = _pos select 0;
	_posY = (_pos select 1) - _modPosition;


	_control ctrlSetPosition [_posX, _posY];
	_control ctrlCommit 0;

};

if (!(_loadServer)) then
{
	_control = ((findDisplay 2400) displayCtrl 2405);
	_control ctrlShow false;
	_modPosition = _modPosition + 0.05;
}
else
{
	_control = ((findDisplay 2400) displayCtrl 2405);
	_control ctrlSetPosition [0.51, 0.35];
	_pos = ctrlPosition _control;
	_posX = _pos select 0;
	_posY = (_pos select 1) - _modPosition;


	_control ctrlSetPosition [_posX, _posY];
	_control ctrlCommit 0;
};

if (!(_adminOptions)) then
{
	_control = ((findDisplay 2400) displayCtrl 2406);
	_control ctrlShow false;
	_modPosition = _modPosition + 0.05;
}
else
{
	if (serverCommandAvailable "#logout") then
	{
		_control = ((findDisplay 2400) displayCtrl 2406);
		_control ctrlSetPosition [0.51, 0.35];
		_pos = ctrlPosition _control;
		_posX = _pos select 0;
		_posY = (_pos select 1) - _modPosition;


		_control ctrlSetPosition [_posX, _posY];
		_control ctrlCommit 0;
	}
	else
	{
		_control = ((findDisplay 2400) displayCtrl 2406);
		_control ctrlShow false;
		_modPosition = _modPosition + 0.05;
	};
};

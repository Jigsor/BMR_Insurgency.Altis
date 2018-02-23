#include "macro.sqf"
disableSerialization;
_firstIDC = _this select 0;
_controlcount = _this select 1;
_ypos = _this select 2;
_height = [_this, 3, (1/25), [1.0]] call BIS_fnc_Param;

for "_i" from 0 to (_controlcount-1) do {
	_control = ASORVS_getControl(ASORVS_Main_Display,_firstIDC + _i);
	_currentpos = ctrlPosition _control;
	_currentpos set [1, _ypos];
	_currentpos set [3, _height];
	_control ctrlSetPosition _currentpos;
	_control ctrlEnable false;
	_control ctrlShow true;
};
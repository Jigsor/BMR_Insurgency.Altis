/*
	File: fn_transferAction.sqf
	Author: Bryan "Tonic" Boardwine

	Description:
	Sends the transfer request to the selected user.
*/

private["_control","_targetUserData", "_index", "_targetUser", "_length", "_selectData"];
disableSerialization;
_control = ((findDisplay 2570) displayCtrl 2701);
if(lbCurSel _control == -1) exitWith {};
_targetUserData = _control lbData (lbCurSel _control);


_index = [_targetUserData, "&??&"] call LT_fnc_KRON_StrIndex;
_targetUser = [_targetUserData, (_index)] call LT_fnc_KRON_StrLeft;
_length = [_targetUserData] call LT_fnc_KRON_StrLen;
_selectData = [_targetUserData, (_length - (_index + 4)) ] call LT_fnc_KRON_StrRight;

//hint format ["%1", _targetUserData];

if(_targetUser == "") exitWith {hint "Bad Unit"};
{if(str(_x) == _targetUser) exitWith {_targetUser = _x;}} foreach allUnits; //Fetch the users actual object.
if(isNull _targetUser) exitWith {hint "Bad Unit"};

//hintC format ["%1 | %2 | %3", _selectData, _targetUser, _targetUserData];

_loadoutName = "LT" + str ((random 100) + (random 100) + (random 100)+(random 100));


_dataLoadout = profileNamespace getVariable "bis_fnc_saveInventory_data" select ( (parseNumber _selectData)  + 1);

_data = missionNamespace getVariable "bis_fnc_saveInventory_data";

if (isNil "_data") then
{

	missionNamespace setVariable ["bis_fnc_saveInventory_data", [_loadoutName, _dataLoadout]];
	publicVariable "bis_fnc_saveInventory_data";
}
else
{
	_data = _data + [_loadoutName];
	_data = _data + [_dataLoadout];

	missionNamespace setVariable ["bis_fnc_saveInventory_data", _data];
	publicVariable "bis_fnc_saveInventory_data";
};

if (isPlayer _targetUser) then
{
	[[player, _loadoutName],"LT_fnc_transferNetwork", _targetUser,false] spawn BIS_fnc_MP;
}
else
{
	[_targetUser, [missionNamespace, _loadoutName]] call bis_fnc_loadInventory;
	;
};
hint "Loadout Transfered";
closeDialog 0;
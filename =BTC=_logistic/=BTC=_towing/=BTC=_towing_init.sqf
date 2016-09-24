/*
Created by =BTC= Giallustio

Date: 20/03/2013
Visit us at: http://www.blacktemplars.altervista.org/
*/
waitUntil {!isNull player && player == player};

BTC_towed      = ObjNull;
//Functions
BTC_tow_check =
{
	if (!(vehicle player isKindOf "LandVehicle") || BTC_attached == 1) exitWith {false};
	_array = [vehicle player] call BTC_get_towable_array;
	if (count _array isEqualTo 0) exitWith {false};
	_tower  = vehicle player;
	_can_lift = false;
	_cargo_array = nearestObjects [_tower, _array, 50];
	_pos_towed = [];_pos_tower = [];
	if (count _cargo_array > 0) then {if (driver (_cargo_array select 0) == player) then {_cargo_array set [0,0];_cargo_array deleteAt 0;};};
	if (count _cargo_array > 0) then {BTC_towed = _cargo_array select 0;} else {BTC_towed = objNull;_can_lift = false;};
	if (({BTC_towed isKindOf _x} count _array) > 0) then {_can_lift = true;} else {_can_lift = false;};
	if (_can_lift && ((BTC_towed isKindOf "Air" && getdammage BTC_towed != 1) || (format ["%1", BTC_towed getVariable "BTC_cannot_tow"] == "1"))) then {_can_lift = false;};
	if (!isNull BTC_towed && _can_lift) then
	{
		_pos_towed = BTC_towed modeltoworld [0,5,0];
		_pos_tower = _tower modeltoworld [0,-6,0];

		if (_pos_tower distance _pos_towed < 4) then
		{_can_lift = true;} else {_can_lift = false;};
	};
	_can_lift
};
BTC_t_attach_cargo =
{
	private ["_cargo"];
	_tower = vehicle player;
	_array = [vehicle player] call BTC_get_towable_array;
	_cargo_array = nearestObjects [_tower, _array, 50];
	if (count _cargo_array > 0 && driver (_cargo_array select 0) == player) then {_cargo_array set [0,0];_cargo_array deleteAt 0;};
	if (count _cargo_array > 0) then {_cargo = _cargo_array select 0;} else {_cargo = objNull;};
	if (isNull _cargo) exitWith {};
	BTC_attached    = 1;
	_cargo attachTo [_tower, [0,-10,0]];
	_name_cargo  = getText (configFile >> "cfgVehicles" >> typeof _cargo >> "displayName");
	_tower vehicleChat format ["%1 attached", _name_cargo];
	BTC_cargo_attached = _cargo;
};
BTC_t_detach_cargo =
{
	detach BTC_cargo_attached;
	_name_cargo  = getText (configFile >> "cfgVehicles" >> typeof BTC_cargo_attached >> "displayName");
	vehicle player vehicleChat format ["%1 dropped", _name_cargo];
	BTC_cargo_attached = ObjNull;
	BTC_attached = 0;
};
[] spawn
{
	player addAction [("<t color=""#ED2744"">" + ("Tow") + "</t>"),BTC_dir_action, [[],BTC_t_attach_cargo], 9, true, false, "", "[] call BTC_tow_check"];
	player addAction [("<t color=""#ED2744"">" + ("Release") + "</t>"),BTC_dir_action, [[],BTC_t_detach_cargo], -9, true, false, "", "BTC_attached isEqualTo 1"];
	player addEventHandler ["Respawn", 
	{
		[] spawn 
		{
			WaitUntil {sleep 1; Alive player};
			player addAction [("<t color=""#ED2744"">" + ("Tow") + "</t>"),BTC_dir_action, [[],BTC_t_attach_cargo], 9, true, false, "", "[] call BTC_tow_check"];
			player addAction [("<t color=""#ED2744"">" + ("Release") + "</t>"),BTC_dir_action, [[],BTC_t_detach_cargo], -9, true, false, "", "BTC_attached isEqualTo 1"];
		};
	}];
};
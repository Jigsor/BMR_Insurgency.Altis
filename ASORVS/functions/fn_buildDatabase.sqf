ASORDOLL_FinishedLoading = false;
ASORVS_Loading = false;
if(isNil 'ASORVS_Whitelist') then {ASORVS_Whitelist = [];};
if(isNil 'ASORVS_Blacklist') then {ASORVS_Blacklist = [];};
#include "macro.sqf"

_endsWith = {
	//infinite loop without this!
	private["_name", "_length", "_nameend", "_start", "_i", "_result"];
	_name = toArray format["%1", _this select 0];
	_length = count toArray (_this select 1);
	_nameend = [];
	if((count _name) >= _length) then {;
		_start = (count _name) - _length;
		for[{_i = 0}, {_i < _length}, {_i = _i + 1}] do {
			_nameend = _nameend + [(_name select (_start +_i)) ];
		};
	};
	_result = (toString _nameend) == (_this select 1);
	_result
};
_indexof = {
	private["_array", "_value", "_keycolumn", "_result", "_i"];
	_array = _this select 0;
	_value = _this select 1;
	_keycolumn = _this param [2, 1, [0]];
	_result = -1;
	for[{_i = 0}, {(_i < (count _array)) && (_result == -1)}, {_i = _i + 1}] do {
		if((_array select _i select _keycolumn) == _value) then{
			_result = _i;
		};
	};
	_result
};

_cfgthrowable = ASORVS_throwable;
_cfgexplosives = ASORVS_explosives;
_pSide = (side player) call BIS_fnc_sideID;

_explosives = [];
_throwable = [];
_backpacks = [];
_cars = [];
_helicopters = [];
_planes = [];
_tanks = [];
_autonomous = [];
_ships = [];
_othervehicles = [];
_allVehicleClasses = (configFile >> "CfgVehicles") call BIS_fnc_getCfgSubClasses;
{
	_classname = _x;
	if([_classname, true] call ASORVS_fnc_IsAllowed) then {
		_cfg = configfile >> "CfgVehicles" >> _classname;
		_displayName = getText(_cfg >> "displayName");
		_picture = getText(_cfg >> "picture");
		_desc = getText(_cfg >> "descriptionshort");
		_scope = getNumber(_cfg >> "scope");
		_type = getNumber(_cfg >> "type");
		_side = getNumber(_cfg >> "side");
		_isbackpack = getNumber(_cfg >> "isbackpack");
		_hasDriver = getNumber(_cfg >> "hasDriver");
		if((_scope >= 2) && {_picture != ""} && {_displayName != ""} && {_hasDriver > 0}) then {
			switch(true) do {
				case (_isbackpack==1) : {
					_capacity = getNumber (_cfg >> "maximumLoad");
					_backpacks set [count _backpacks, [DB_Backpacks, _classname, _displayName, _picture, _capacity, count _backpacks]];
				};
				case (_classname isKindOf "Helicopter") : {
					_helicopters pushBack [DB_Helicopters, _classname, _displayname, _picture, nil, count _helicopters, _side];
				};
				case(_classname isKindOf "Plane") : {
					_planes pushBack [DB_Planes, _classname, _displayname, _picture, nil, count _planes, _side];
				};
				case((_classname isKindOf "Tank") || (_classname isKindOf "Wheeled_APC_F")) : {
					_tanks pushBack [DB_Tanks, _classname, _displayname, _picture, nil, count _tanks, _side];
				};
				case(_classname isKindOf "Autonomous") : {
					if (_pSide isEqualTo _side) then {					
						_autonomous pushBack [DB_Autonomous, _classname, _displayname, _picture, nil, count _autonomous, _side];
					};
				};
				case((_classname isKindOf "Car") && !(_classname isKindOf "Wheeled_APC_F")) : {
					_cars pushBack [DB_Cars, _classname, _displayname, _picture, nil, count _cars, _side];
				};
				case(_classname isKindOf "Ship") : {
					_ships pushBack [DB_Ships, _classname, _displayname, _picture, nil, count _ships, _side];
				};
				default {
					_othervehicles pushBack [count _autonomous, _classname, _displayname, _picture, getText(_cfg >> "vehicleClass"), count _othervehicles, _side];
				};
			};
		};
	};
} forEach (_allVehicleClasses);

#define DB_Cars 0
#define DB_Tanks 1
#define DB_Autonomous 2
#define DB_Planes 3
#define DB_Boats 4
#define DB_Ships 4
#define DB_Helicopters 5

ASORVS_DB = [_cars, _tanks, _autonomous, _planes, _ships, _helicopters];

/*
diag_log "--------------------------------Cars" ;
{ diag_log format["%1",_x];
} foreach _cars;
diag_log "--------------------------------Helicopters" ;
{ diag_log format["%1",_x];
} foreach _helicopters;
diag_log "--------------------------------Planes" ;
{ diag_log format["%1",_x];
} foreach _planes;
diag_log "--------------------------------Tanks" ;
{ diag_log format["%1",_x];
} foreach _tanks;
diag_log "--------------------------------Autonomous" ;
{ diag_log format["%1",_x];
} foreach _autonomous;
diag_log "--------------------------------Other Vehicles" ;
{ diag_log format["%1",_x];
} foreach _othervehicles;
*/
ASORDOLL_FinishedLoading = false;
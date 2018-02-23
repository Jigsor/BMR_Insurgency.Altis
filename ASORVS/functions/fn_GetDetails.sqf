private ["_i", "_classname", "_array", "_keycolumn", "_value"];
_classname = _this select 0;
_array = _this select 1;
_keycolumn = [_this, 2, 1, [2]] call BIS_fnc_param;

_value = [];
for[{_i = 0}, {(_i < (count _array)) && ((count _value) == 0)}, {_i = _i + 1}] do {
	if((_array select _i select _keycolumn) == _classname) then {
		_value = _array select _i;
	};
};

_value
private["_in","_len","_arr","_i","_out"];
	_in=_this select 0;
	_len=_this select 1;
	_arr=[_in] call KRON_StrToArray;
	_out="";
	if (_len>(count _arr)) then {_len=count _arr};
	for "_i" from ((count _arr)-_len) to ((count _arr)-1) do {
		_out=_out + (_arr select _i);
	};
 _out
_arr = _this select 0;
_good = true;
for "_i" from 0 to (count _arr) -1 do{
	if(!ScriptDone (_arr select _i)) then {_good = false;};
};

_good;
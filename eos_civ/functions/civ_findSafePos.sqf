params ["_mrk","_radveh"];

_pos = [_mkr,true] call SHK_civ_pos;

for "_counter" from 0 to 20 step 1 do {
	_newpos = [_pos,0,_radveh,5,1,20,0] call BIS_fnc_findSafePos;
	if ((_pos distance _newpos) < (_radveh + 5)) exitWith {_pos = _newpos;};
};
_newpos
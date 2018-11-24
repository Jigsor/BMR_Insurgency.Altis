_mrk=(_this # 0);
_radveh	=(_this # 1);

_pos = [_mkr,true] call SHK_pos;

_vpos = _pos isFlatEmpty [8,384,0.7,10,0,false,ObjNull];//Jig adding
if !(_vpos isEqualTo []) then {_pos = _vpos};

for "_counter" from 0 to 20 step 1 do {
	_newpos = [_pos,0,_radveh,5,1,20,0] call BIS_fnc_findSafePos;
	if ((_pos distance _newpos) < (_radveh + 5)) exitWith {_pos = _newpos;};
};
_newpos
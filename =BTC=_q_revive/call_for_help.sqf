params ["_caller"];

_pos = position _caller;
private _side = _caller getVariable ["btc_qr_side",west];
private _units = (_caller nearEntities ["CAManBase", btc_qr_help_radius]) - [_caller];
private _helper = objNull;
private _dist = 99999;

if (isPlayer _caller) then {playSound3D [(selectRandom btc_qr_call_medic),_caller]};

{
	if (!isPlayer _x && {side _x == _side} && {damage _x < 0.9} && {_x distanceSqr _caller < _dist} && {"FirstAidKit" in items _x || "Medikit" in items _x}) then {_helper = _x;_dist = _x distanceSqr _caller;};
	//diag_log format ["CHECKING %1: %2 %3 %4 %5 %6",_x,!isPlayer _x,side _x == _side,damage _x < 0.9,_x distanceSqr _caller < _dist,"FirstAidKit" in items _x || "Medikit" in items _x];
} foreach _units;

//diag_log format ["RESULT %1 - %2",_caller,_helper];
[_caller,_helper] spawn btc_qr_fnc_help;

_helper 
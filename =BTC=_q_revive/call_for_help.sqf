private ["_caller", "_pos", "_units", "_helper", "_dist"];
_caller = _this select 0;

if (isPlayer _caller) then {playSound3D [(btc_qr_call_medic call BIS_fnc_selectRandom),_unit];};

_side = _caller getVariable ["btc_qr_side",west];
_pos = position _caller;
_units = _caller nearEntities ["CAManBase", btc_qr_help_radius];
_units = _units - [_caller];
_helper = objNull;
_dist = 99999;

{
	if (!isPlayer _x && {side _x == _side} && {damage _x < 0.9} && {_x distanceSqr _caller < _dist} && {"FirstAidKit" in items _x || "Medikit" in items _x}) then {_helper = _x;_dist = _x distanceSqr _caller;};
	//diag_log format ["CHECKING %1: %2 %3 %4 %5 %6",_x,!isPlayer _x,side _x == _side,damage _x < 0.9,_x distanceSqr _caller < _dist,"FirstAidKit" in items _x || "Medikit" in items _x];
} foreach _units;

//diag_log format ["RESULT %1 - %2",_caller,_helper];
[_caller,_helper] spawn btc_qr_fnc_help;

_helper 
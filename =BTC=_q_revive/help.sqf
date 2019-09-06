params ["_unit","_helper"];

if (_helper getVariable ["btc_qr_helping",false]) exitWith {};

_unit setVariable ["btc_qr_helper",_helper];
_helper setVariable ["btc_qr_helping",true];

if (isPlayer _unit && {local _unit}) then {if (isNull _helper) then {hint localize "STR_BMR_NoOneNear";} else {hint format ["%1 is on the way to help you", name _helper];};};

while {Alive _unit && {Alive _helper} && {damage _unit > 0.25} && {damage _helper < 0.9} && {"FirstAidKit" in items _helper || "Medikit" in items _helper}} do
{
	_helper stop false;
	_helper doMove (position _unit);//hint format ["%1 helping %2", name _helper, name _unit];
	if (_unit distance _helper < 2) then {_helper action ["HealSoldier",_unit];};
	sleep 2;
};

_unit setVariable ["btc_qr_helper",objNull];
_helper setVariable ["btc_qr_helping",false];
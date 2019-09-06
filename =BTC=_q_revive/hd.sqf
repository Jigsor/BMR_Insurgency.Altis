params ["_unit","_part","_dam","_injurer","_ammo"];

//diag_log format ["----QR: HD = %1",_this];

if (_unit getVariable ["btc_qr_unc",false] && {!btc_qr_dam_unc}) then {
	_dam = 0.9;
}
else
{
	if (_part isEqualTo "head" && {btc_qr_ik_headshot}) then {if (_dam > 1) then {_unit setVariable ["btc_qr_hs",true];};};
	if (_dam > 1.5 && {btc_qr_ik_heavy_damage}) then {_unit setVariable ["btc_qr_hdam",true];};
	if (_part isEqualTo "") then
	{
		_exit = false;
		if (_unit getVariable ["btc_qr_hs",false] || _unit getVariable ["btc_qr_hdam",false]) then {_dam = 2;_exit = true;};
		if (!_exit && {damage _unit + _dam > 0.95} && {!(_unit getVariable ["btc_qr_unc",false])}) then	{
			_dam = 0;
			_unit spawn btc_qr_fnc_unc;
		};
		if (_unit getVariable ["btc_qr_unc",false]) then {
			_dam = _dam / btc_qr_dam_unc_ratio;
			if (damage _unit + _dam > 0.95) then {_dam = 0;_dam = _unit call btc_qr_fnc_resp};
		};
	} else {if (_dam > 0.95) then {_dam = 0.9;};};
};

_dam 
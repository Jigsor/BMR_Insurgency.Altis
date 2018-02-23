private ["_ui", "_isPlayer", "_unit", "_timer", "_call", "_group", "_time_unc", "_fa", "_mk"];

_unit = _this;

if (_unit getVariable ["btc_qr_unc",false]) exitWith {};

_fa = {_x == "FirstAidKit"} count items _unit; 
_mk = {_x == "Medikit"} count items _unit;
{_unit removeItems _x;} foreach ["FirstAidKit","Medikit"];

_unit setVariable ["btc_qr_unc",true];

if (vehicle _unit != _unit) then {
	_unit action ["getOut", vehicle _unit];
};

_unit setDamage btc_qr_unc_dam;
_unit setCaptive true;

waitUntil {vehicle _unit == _unit};
_unit switchMove "AinjPpneMstpSnonWrflDnon";

_time_unc = _unit getVariable ["btc_qr_set_unc_time",btc_qr_time];

_unit setVariable ["btc_qr_unc_time",time];
_unit setVariable ["btc_qr_helper",objNull];
_unit setVariable ["btc_qr_resp",false];
_unit setVariable ["btc_qr_is_leader",false];

_isPlayer = isPlayer _unit;
_group = group _unit;

if (btc_qr_unc_leave_group) then {if (leader group _unit == _unit) then {_unit setVariable ["btc_qr_is_leader",true];};[_unit] joinSilent grpNull;};

if (!isNil {_unit getVariable "btc_qr_on_unc"}) then {_unit spawn (_unit getVariable "btc_qr_on_unc");};

if (!_isPlayer) then {{_unit disableAI _x} foreach ["TARGET","AUTOTARGET","MOVE","ANIM"];} else 
{
	if (Dialog) then {closeDialog 0;};
	disableSerialization;
	createDialog "btc_qr_dlg";
	_ui = uiNamespace getVariable "btc_qr_dlg";
	_ui displayAddEventHandler ["KeyDown", "if ((_this select 1) == 1) then { true }"];
	if (!btc_qr_show_time) then {(_ui displayCtrl 172) ctrlShow true;};
};

_timer = true;
_call = 16;

while {_timer && {Alive _unit} && {damage _unit > 0.25}} do
{
	if (_time_unc > 0) then {if ((time - (_unit getVariable ["btc_qr_unc_time",time])) > _time_unc) then {_timer = false;};};
	if (_isPlayer) then
	{
		//Player
		if (isNull (_unit getVariable ["btc_qr_helper",objNull])) then {(_ui displayCtrl 171) ctrlShow true;} else {(_ui displayCtrl 171) ctrlShow false;};
		if (btc_qr_show_time) then {(_ui displayCtrl 172) ctrlSetText format ["Time: %1", round (_time_unc - (time - (_unit getVariable ["btc_qr_unc_time",time])))];};
	}else{
		//AI
		if ((!isPlayer leader _group) && {isNull (_unit getVariable ["btc_qr_helper",objNull])}) then {[_unit] call btc_qr_fnc_call_for_help};
	};
	if (btc_qr_unc_scream && {!isPlayer _unit} && {_call > 15}) then {_call = 0;playSound3D [(selectRandom btc_qr_call_medic),_unit];} else {_call = _call + 1;};
	sleep 1;
};

if (!_timer) exitWith {_unit call btc_qr_fnc_resp};
if (_isPlayer && {local _unit} && {!(_unit getVariable ["btc_qr_resp",false])}) then {closeDialog 0;};

_unit setVariable ["btc_qr_unc",false];

if (btc_qr_unc_leave_group) then {[_unit] joinSilent _group;if (_unit getVariable ["btc_qr_is_leader",true]) then {_group selectLeader _unit};};
sleep 0.5;

if (_unit getVariable ["btc_qr_resp",false]) exitWith {_unit setVariable ["btc_qr_resp",false];};

if (Alive _unit) then {
	if (!_isPlayer) then {{_unit enableAI _x} foreach ["TARGET","AUTOTARGET","MOVE","ANIM"];};
	_unit playMoveNow "AmovPpneMstpSnonWnonDnon_healed";
	_unit setCaptive false;
};

for "_i" from 1 to _fa do {_unit addItem "FirstAidKit";};
for "_i" from 1 to _mk do {_unit addItem "Medikit";};
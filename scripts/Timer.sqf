//Timer.sqf
//code by  MuzzleFlash. Adapted for A3 by Jigsor

if (!hasInterface) exitWith {};
params ["_bool","_minutes","_chars2","_countdown"];

killtime = _bool;
_countdown = (60 * _minutes) +1;
private _done = false;

"killtime" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};

private _numbersToTimeString = {
	params ["_hours","_minutes","_chars"];
	_chars = [];
	_chars set [0, (floor (_hours / 10)) + 48];
	_chars set [1, (floor (_hours mod 10)) + 48];
	_chars set [2, 58];
	_chars set [3, (floor (_minutes / 10)) + 48];
	_chars set [4, (floor (_minutes mod 10)) + 48];
	toString _chars + _chars2
};

if (_countdown > 0) then {
	if (timesup) then {
		timesup = false;
		publicVariable "timesup";
	};
	while {uiSleep 0.5; _countdown > 0} do {//uiSleep does not seem affected by fps
		if (killtime) exitwith {_done = true};
		_countdown = _countdown - 0.5;
		if (_countdown > 0) then {
			hintSilent parseText format ["<t size='1.5' color='#ffffba0c'>%1</t>", ([floor (_countdown / 60), _countdown mod 60] call _numbersToTimeString)];
		};
	};
};
uiSleep 1.0;
hintSilent "";// Make hint disappear immediately after the countdown

if (_done) exitwith {};
waituntil {!(_countdown > 0)};
if !(timesup) then {
	timesup = true;
	publicVariable "timesup";
};
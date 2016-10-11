//Timer.sqf
//code by  MuzzleFlash. Adapted for A3 by Jigsor
//[[[time,false,5," Hold Outpost"],"scripts\Timer.sqf"],"BIS_fnc_execVM",true] call BIS_fnc_MP;// with JIP persistence
//[[[time,false,5," Hold Outpost"],"scripts\Timer.sqf"],"BIS_fnc_execVM"] call BIS_fnc_MP;// without JIP persistence

if (isDedicated) exitWith {};
if (!hasInterface && !isDedicated) exitWith {};
private ["_countdown","_serverTime","_chars2","_totalTime","_numbersToTimeString","_done","_seconds","_minutes","_mpTimeDiff"];

_serverTime = _this select 0;
killtime = _this select 1;
_minutes = _this select 2;
_chars2 = _this select 3;
_done = false;
_seconds = 60;
_mpTimeDiff = time - _serverTime;
_totalTime = (_seconds * _minutes) - _mpTimeDiff;

"killtime" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};

_numbersToTimeString = {
	private ["_hours", "_minutes","_chars"];
	_hours = _this select 0;
	_minutes = _this select 1;
	_chars = [];
	_chars set [0, (floor (_hours / 10)) + 48];
	_chars set [1, (floor (_hours mod 10)) + 48];
	_chars set [2, 58];
	_chars set [3, (floor (_minutes / 10)) + 48];
	_chars set [4, (floor (_minutes mod 10)) + 48];
	toString _chars + _chars2
};

_countdown = _totalTime - time + _serverTime;

if (_countdown > 0) then {
	timesup = false;
	publicVariable "timesup";
	while {uiSleep 0.5; _countdown > 0} do {
		if (killtime) exitwith {_done = true};
		//Find how much time is left
		_countdown = _totalTime - time + _serverTime;
		if (_countdown > 0) then {
			hintSilent parseText format ["<t size='1.5' color='#ffffba0c'>%1</t>", ([floor (_countdown / 60), _countdown mod 60] call _numbersToTimeString)];
		};
	};
};
sleep 1.0;
hintSilent "";// Make hint disappear immediately after the countdown

if (_done) exitwith {};
waituntil {!(_countdown > 0)};
timesup = true;
publicVariable "timesup";
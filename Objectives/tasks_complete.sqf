//tasks_complete.sqf
//Check if all zones captured then check if current task complete. If so, activate ending.

waitUntil {time > 90};

private ["_curtasks","_all_zones_caped","_uncaped_eos_mkrs","_INS_tsks_finished"];

_all_zones_caped = false;
_INS_tsks_finished = false;
_curtasks = [];

{_curtasks pushBack (_x select 0);} forEach SHK_Taskmaster_Tasks;

while {true} do {
	sleep 15;
	{
		if (_x call SHK_Taskmaster_isCompleted) then {
			_curtasks = _curtasks - [_x];
		};
	} foreach _curtasks;
	if (count _curtasks isEqualTo 0) exitwith {_INS_tsks_finished = true;};
};

if (_INS_tsks_finished) then {
	_uncaped_eos_mkrs = all_eos_mkrs;
	while {true} do {
		{if (getMarkerColor _x == "ColorGreen") then {_uncaped_eos_mkrs = _uncaped_eos_mkrs - [_x]; sleep 0.1;};} foreach _uncaped_eos_mkrs;
		if (count _uncaped_eos_mkrs isEqualTo 0) exitWith {_all_zones_caped = true;};
		sleep 15;
	};
};

if (_all_zones_caped) then {
	{_curtasks pushBack (_x select 0);} forEach SHK_Taskmaster_Tasks;

	while {true} do {
		{
			if (_x call SHK_Taskmaster_isCompleted) then {
				_curtasks = _curtasks - [_x];
			};
		} foreach _curtasks;
		if (count _curtasks isEqualTo 0) exitwith {
			[[],"INS_end_mssg",true,true,true] spawn BIS_fnc_MP;
			sleep 24;
			[["END1",true,true], "BIS_fnc_endMission",true,true,true] spawn BIS_fnc_MP
		};
		sleep 10;
	};
};
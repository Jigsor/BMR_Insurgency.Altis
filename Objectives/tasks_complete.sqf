//tasks_complete.sqf
//Check if all zones captured then check if current task complete. If so, activate ending.

waitUntil {sleep 1; time > 90};

private _allZonesCaptured = false;
private _INS_tsks_finished = false;
private _curtasks = [];

{_curtasks pushBack (_x select 0);} forEach SHK_Taskmaster_Tasks;

while {true} do {
	sleep 15;
	{
		if (_x call SHK_Taskmaster_isCompleted) then {
			_curtasks = _curtasks - [_x];
		};
	} foreach _curtasks;
	if (_curtasks isEqualTo []) exitwith {_INS_tsks_finished = true;};
};

if (_INS_tsks_finished) then {
	private _c = if (INS_persistence in [1,2]) then {0} else {7};
	private _s = if (INS_persistence in [1,2]) then {true}else{false};
	private _uncapturedMkrs = all_eos_mkrs;
	while {true} do {
		{if (markerColor _x isEqualTo "ColorGreen") then {_uncapturedMkrs = _uncapturedMkrs - [_x]; sleep 0.1;};} foreach _uncapturedMkrs;

		//Save progression every 5 minutes if lobby option permits
		if (_s && {_c isEqualTo 6}) then {
			profileNamespace setVariable ["BMR_INS_progress", _uncapturedMkrs];
			_c = 0;
		};
		if (_c isNotEqualTo 7) then {_c = _c + 1};

		if (_uncapturedMkrs isEqualTo []) exitWith {_allZonesCaptured = true;};
		sleep 15;
	};
};

if (_allZonesCaptured) then {
	{_curtasks pushBack (_x select 0);} forEach SHK_Taskmaster_Tasks;
	profileNamespace setVariable ["BMR_INS_progress", []];

	while {true} do {
		{
			if (_x call SHK_Taskmaster_isCompleted) then {
				_curtasks = _curtasks - [_x];
			};
		} foreach _curtasks;
		if (_curtasks isEqualTo []) exitwith {
			[[],"INS_end_mssg",true,true,true] spawn BIS_fnc_MP;
			sleep 26;
			[["END1",true,true], "BIS_fnc_endMission",true,true,true] spawn BIS_fnc_MP
		};
		sleep 10;
	};
};
if (isServer) exitWith {};
params ["_completeList","_uncaptured","_didJIP"];
all_eos_mkrs = _completeList;
HCzoneProgress = _uncaptured;
diag_log format ["*****HCzoneProgress= %1 all_eos_mkrs= %2", count HCzoneProgress, count all_eos_mkrs];
if (!_didJIP) then {
	waitUntil {time > 50};//Some maps like Livonia need lots of time for HC to load EOS
	[] spawn BMRINS_fnc_persistence;
	diag_log "BMRINS_fnc_persistence executed on non JIP HC(s)";
};
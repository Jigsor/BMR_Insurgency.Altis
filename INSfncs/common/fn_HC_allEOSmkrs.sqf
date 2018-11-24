if (isServer) exitWith {};
params ["_completeList","_uncaptured"];
all_eos_mkrs = _completeList;
HCzoneProgress = _uncaptured;
diag_log format ["*****HCzoneProgress= %1 all_eos_mkrs= %2", count HCzoneProgress, count all_eos_mkrs];
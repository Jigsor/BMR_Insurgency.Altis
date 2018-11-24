// Force cancel current side mission
if (!isServer || {SideMissionCancel}) exitWith {};
private _txt = "Side Mission Cancelation Requested by Admin";
[_txt] remoteExec ["JIG_MPSystemChat_fnc", [0,-2] select isDedicated];
diag_log "***Side Mission Canceled";
SideMissionCancel = true;
publicVariableServer "SideMissionCancel";

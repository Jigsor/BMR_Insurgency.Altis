//Op4PlayerKilled

params ["_op4Player"];
missionNameSpace setVariable ["OP4houseSpawn", []];

private _validPos = call BMRINS_fnc_Op4buildingPos;

if (_validPos isEqualTo []) exitWith {[_op4Player] spawn BMRINS_fnc_MoveOp4Base};

missionNameSpace setVariable ["OP4houseSpawn", _validPos];
if (INS_p_rev < 6) then {BTC_r_base_spawn setPos _validPos};
"Respawn_East" setMarkerPos _validPos;

diag_log format ["!!!!!BMR OP4 Building Spawn point succesfully found at %1", _validPos];
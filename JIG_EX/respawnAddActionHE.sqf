// respawnAddActionHE.sqf v1.11 by Jigsor
// player addEventHandler ["killed", {_nul = _this execVM "JIG_EX\respawnAddActionHE.sqf";}];
// runs in JIG_EX\extraction_init.sqf

player removeaction jig_ex_actid_show;
jig_ex_actid_show = 9999;

waituntil {sleep 0.9; alive player};

// Editing the following line required./////////////////////////////////////////////////////////////////////////////////
JIG_EX_Caller = CAS1;// Name of playable unit in editor who can call in Extraction Via scroll action, ie; s1, TeamLeader or TL1. This edit is required at the very least to run script pack.
// Do not edit past here.

publicVariable "JIG_EX_Caller";

if (not (isNull EvacHeliW1)) exitWith {call Cancel_Evac_fnc};

sleep 5;
jig_ex_actid_show = player addAction [("<t color=""#12F905"">") + ("Heli Extraction") + "</t>","JIG_EX\extraction_player.sqf",JIG_EX_Caller removeAction jig_ex_actid_show,1, false, true,"","player ==_target"];
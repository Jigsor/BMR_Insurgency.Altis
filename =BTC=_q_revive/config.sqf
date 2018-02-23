//Settings

btc_qr_ik_headshot = false; //No revive if headshot
btc_qr_ik_heavy_damage = false; //No revive if heavy damage (eg big explosion)

btc_qr_help_radius = 75; //Check for helpers nearby
btc_qr_time = INS_p_rev_time; //time in seconds for revive (0 = no time limit)
btc_qr_show_time = true; //if true it shows time while unc
btc_qr_dam_unc = false; //An unconscious unit can be damaged
btc_qr_dam_unc_ratio = 1; //if btc_qr_dam_unc is true, you can reduce the damage taken when unc (1 = no reduce)
btc_qr_unc_scream = true; //if true units will call for help
btc_qr_unc_leave_group = false; // if true unc units will leave the group
btc_qr_AI_resp = false; //If false the AI will die when the time expires
btc_qr_multiple_spawn = true; //If true a dialog will appear after respawn and you can select where to spawn (Only players)
btc_qr_cam_dist = 20;

//Markers names where you want to spawn
if (!isDedicated && hasInterface) then {// Jig adding change option for side MHQs
	if (INS_MHQ_enabled) then {
		if (playerSide isEqualTo WEST) then {
			btc_qr_def_spawn = ["MHQ_1","MHQ_2","MHQ_3"];
		};
		if (playerSide isEqualTo EAST) then {
			btc_qr_def_spawn = ["Opfor_MHQ"];
		};
	};
};


BTC_respawn_marker = format ["respawn_%1",playerSide];
btc_qr_def_spawn pushBack BTC_respawn_marker;
BTC_r_base_spawn = "Land_ClutterCutter_small_F" createVehicleLocal getMarkerPos BTC_respawn_marker;

/*
	_unit setVariable ["btc_qr_set_unc_time",time_in_seconds]; // time_in_seconds = type number
	You can set the unc time individually
*/
/*
	_unit setVariable ["btc_qr_on_respawn",{}]; //Execute when a unit respawns (_this -> _unit)
	Example:
	_unit setVariable ["btc_qr_on_respawn",{hint format ["%1 is back in action", name _this];}];
*/
/*
	_code = _unit setVariable ["btc_qr_on_unc",{}]; //Execute when a unit falls unc (_this -> _unit)
	Example:
	_unit setVariable ["btc_qr_on_unc",{hint format ["%1 needs help!", name _this];}];
*/

//Don't edit below

btc_qr_call_medic = 
[
	"a3\sounds_f\characters\human-sfx\Person0\P0_moan_13_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_14_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_15_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_16_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_17_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_18_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_19_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_20_words.wss",
	"a3\sounds_f\characters\human-sfx\Person1\P1_moan_19_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_20_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_21_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_22_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_23_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_24_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_25_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_26_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_27_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_28_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_29_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_30_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_31_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_32_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_33_words.wss",
	"a3\sounds_f\characters\human-sfx\Person2\P2_moan_19_words.wss"
];

btc_qr_unc_dam = 0.9; //0.25 healed by FA

btc_qr_fnc_call_for_help = compile preprocessFileLineNumbers "=BTC=_q_revive\call_for_help.sqf";
btc_qr_fnc_hd = compile preprocessFileLineNumbers "=BTC=_q_revive\hd.sqf";
btc_qr_fnc_help = compile preprocessFileLineNumbers "=BTC=_q_revive\help.sqf";
btc_qr_fnc_multiple_spawn = compile preprocessFileLineNumbers "=BTC=_q_revive\multiple_spawn.sqf";
btc_qr_fnc_resp = compile preprocessFileLineNumbers "=BTC=_q_revive\resp.sqf";
btc_qr_fnc_resp_AI = compile preprocessFileLineNumbers "=BTC=_q_revive\resp_AI.sqf";
btc_qr_fnc_unc = compile preprocessFileLineNumbers "=BTC=_q_revive\unc.sqf";
btc_qr_fnc_unit_init = compile preprocessFileLineNumbers "=BTC=_q_revive\unit_init.sqf";
btc_qr_fnc_var = compile preprocessFileLineNumbers "=BTC=_q_revive\var.sqf";

btc_qr_ready = true;

//hint "=BTC= Quick revive ready!";
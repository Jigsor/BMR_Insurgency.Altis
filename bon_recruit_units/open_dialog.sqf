bon_recruit_barracks = _this # 0;
if ((toLower (worldName)) in ["wl_rosche","enoch"]) then {bon_recruit_barracks = trig_alarm1init};
if (player != (leader group player) || !("bis_dg_reg" in (allvariables group player))) exitWith {
	hint localize "STR_BMR_group_leaders_only";
	player sideChat localize "STR_BMR_group_leaders_only";
};
createDialog "RecruitUnitsDialog";
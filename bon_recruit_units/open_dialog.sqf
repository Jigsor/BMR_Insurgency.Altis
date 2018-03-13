bon_recruit_barracks = _this select 0;
if (player != (leader group player) || !("bis_dg_reg" in (allvariables group player))) exitWith {
	hint localize "STR_BMR_group_leaders_only";
	player sideChat localize "STR_BMR_group_leaders_only";
};
createDialog "RecruitUnitsDialog";
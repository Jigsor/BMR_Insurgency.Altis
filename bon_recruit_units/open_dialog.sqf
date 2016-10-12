bon_recruit_barracks = _this select 0;
if (leader group player != player) exitWith {
	player sideChat localize "STR_BMR_leader_recruit_restrict";
};
createDialog "RecruitUnitsDialog";
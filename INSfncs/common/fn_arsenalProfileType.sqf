//call BMRINS_fnc_arsenalProfileType;
If ((side player == west && {INS_VA_type in [1,2]}) || (side player == east && {INS_VA_type in [2,3]})) then {
	//Whitelisting Arsenal Space
	BMRINS_profileSave = ["BMR_bis_fnc_saveInventory_east_data", "BMR_bis_fnc_saveInventory_west_data"] select (playerside isEqualTo WEST);
} else {
	//Non Whitelisting Arsenal Space
	BMRINS_profileSave = "bis_fnc_saveInventory_data";
};
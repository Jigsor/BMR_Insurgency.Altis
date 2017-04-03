// DefLoadoutOp4.sqf by Jigsor
params ["_p"];
waitUntil {alive _p};

// CSAT (A3) or CSAT (Pacific)
if ((INS_op_faction isEqualTo 1) || (INS_op_faction isEqualTo 4) || (INS_op_faction isEqualTo 5)) exitWith
{
	removeAllAssignedItems _p;
	{_p linkItem _x} forEach ["ItemMap","ItemCompass","ItemRadio","ItemGPS","ItemWatch","NVGoggles_OPFOR"];
};

removeAllWeapons _p;
removeAllAssignedItems _p;
removeAllContainers _p;
removeHeadgear _p;
removeGoggles _p;

if ((INS_op_faction isEqualTo 2) || (INS_op_faction isEqualTo 3)) then {
// AAF (A3)

	_p forceAddUniform "U_I_CombatUniform";
	_p addVest "V_PlateCarrierIA2_dgtl";
	_p addBackpack "B_AssaultPack_dgtl";
	_p addHeadgear "H_HelmetIA";//"H_HelmetIA_camo","H_HelmetIA_net"

	_p setFace "GreekHead_A3_01";
	_p setSpeaker "Male02GRE";

	_p addItemToUniform "FirstAidKit";
	_p addItemToUniform "30Rnd_556x45_Stanag";

	{_p addItemToBackpack "FirstAidKit"} foreach [1,2];
	{_p addItemToBackpack "HandGrenade"} foreach [1,2,3,4];
	{_p addItemToBackpack "APERSTripMine_Wire_Mag"} foreach [1,2];
	{_p addItemToBackpack "APERSBoundingMine_Range_Mag"} foreach [1,2];
	_p addItemToBackpack "SLAMDirectionalMine_Wire_Mag";
	_p addItemToBackpack "DemoCharge_Remote_Mag";

	_p addMagazines ["HandGrenade", 4];

	_p addMagazine "SmokeShell";
	_p addMagazine "SmokeShell";
	_p addMagazine "SmokeShellGreen";
	_p addMagazine "SmokeShellGreen";
	_p addMagazine "Chemlight_green";
	_p addMagazine "Chemlight_green";

	_p addWeapon "Binocular";

	[_p,"arifle_Mk20_ACO_F",10] call BIS_fnc_AddWeapon;//"arifle_Mk20_ACO_F" compatible mags = "30Rnd_556x45_Stanag"
	[_p,"hgun_ACPC2_F",5] call BIS_fnc_AddWeapon;//"hgun_ACPC2_F" compatible mags = "9Rnd_45ACP_Mag"

	_p removePrimaryWeaponItem "optic_ACO_grn";
	_p addprimaryweaponitem "optic_Hamr";
	_p addprimaryweaponitem "acc_flashlight";//"optic_Arco","optic_MRCO"

	{_p linkItem _x} forEach ["ItemMap","ItemCompass","ItemRadio","ItemGPS","ItemWatch","NVGoggles_INDEP"];
};

switch (INS_op_faction) do {

case 6: {
// RHS - Armed Forces of the Russian Federation (@RHSAFRF)

	_p forceAddUniform "rhs_uniform_flora";
	_p addVest "rhs_6b23_rifleman";
	_p addBackpack "rhs_assault_umbts";
	_p addHeadgear "rhs_6b27m";

	_p setFace "GreekHead_A3_01";
	_p setSpeaker "rhs_Male01RUS";

	_p addItemToUniform "FirstAidKit";
	_p addItemToUniform "rhs_30Rnd_545x39_7N10_AK";

	{_p addItemToVest "rhs_VOG25"} foreach [1,2];//gp25 ammo
	{_p addItemToVest "rhs_VOG25P"} foreach [1,2];//gp25 ammo

	{_p addItemToBackpack "FirstAidKit"} foreach [1,2];
	{_p addItemToBackpack "rhs_mag_plamyam"} foreach [1,2];//flashbang
	_p addItemToBackpack "APERSTripMine_Wire_Mag";
	_p addItemToBackpack "APERSBoundingMine_Range_Mag";
	_p addItemToBackpack "DemoCharge_Remote_Mag";

	_p addMagazine "rhs_mag_rgd5";//hand grenade
	_p addMagazine "SmokeShell";
	_p addMagazine "SmokeShellGreen";
	_p addMagazine "SmokeShellGreen";
	_p addMagazine "Chemlight_green";
	_p addMagazine "Chemlight_green";
	_p addMagazine "9Rnd_45ACP_Mag";

	_p addWeapon "Binocular";
	[_p,"rhs_weap_ak74m_gp25",9] call BIS_fnc_AddWeapon;
	[_p,"hgun_ACPC2_F",2] call BIS_fnc_AddWeapon;//"hgun_ACPC2_F" compatible mags = "9Rnd_45ACP_Mag"
	_p addprimaryweaponitem "rhs_acc_1p29";

	{_p linkItem _x} forEach ["ItemMap","ItemCompass","ItemRadio","ItemGPS","ItemWatch","NVGoggles"];//"NVGoggles_OPFOR"
};
case 7: {
// RHS - DES Armed Forces of the Russian Federation (@RHSAFRF)

	_p forceAddUniform "rhs_uniform_vdv_emr_des";
	_p addVest "rhs_6b23_rifleman";
	_p addBackpack "rhs_assault_umbts";
	_p addHeadgear "rhs_6b27m";

	_p setFace "GreekHead_A3_01";
	_p setSpeaker "rhs_Male01RUS";

	_p addItemToUniform "FirstAidKit";
	_p addItemToUniform "rhs_30Rnd_545x39_7N10_AK";

	{_p addItemToVest "rhs_VOG25"} foreach [1,2];//gp25 ammo
	{_p addItemToVest "rhs_VOG25P"} foreach [1,2];//gp25 ammo

	{_p addItemToBackpack "FirstAidKit"} foreach [1,2];
	{_p addItemToBackpack "rhs_mag_plamyam"} foreach [1,2];//flashbang
	_p addItemToBackpack "APERSTripMine_Wire_Mag";
	_p addItemToBackpack "APERSBoundingMine_Range_Mag";
	_p addItemToBackpack "DemoCharge_Remote_Mag";

	_p addMagazine "rhs_mag_rgd5";//hand grenade
	_p addMagazine "SmokeShell";
	_p addMagazine "SmokeShellGreen";
	_p addMagazine "SmokeShellGreen";
	_p addMagazine "Chemlight_green";
	_p addMagazine "Chemlight_green";
	_p addMagazine "9Rnd_45ACP_Mag";

	_p addWeapon "Binocular";
	[_p,"rhs_weap_ak74m_gp25",9] call BIS_fnc_AddWeapon;
	[_p,"hgun_ACPC2_F",2] call BIS_fnc_AddWeapon;//"hgun_ACPC2_F" compatible mags = "9Rnd_45ACP_Mag"
	_p addprimaryweaponitem "rhs_acc_1p29";

	{_p linkItem _x} forEach ["ItemMap","ItemCompass","ItemRadio","ItemGPS","ItemWatch","NVGoggles"];//"NVGoggles_OPFOR"
};
case 8: {
// RHS - GREF (@RHSAFRF;@RHSUSAF;@RHSGREF)

	_p forceAddUniform "rhsgref_uniform_ttsko_mountain";
	_p addVest "rhsgref_6b23_khaki_rifleman";
	_p addBackpack "rhs_assault_umbts";
	_p addHeadgear "rhsgref_6b27m_ttsko_mountain";

	_p setFace "GreekHead_A3_10_a";
	_p setSpeaker "RHS_Male05CZ";

	_p addItemToUniform "FirstAidKit";
	_p addItemToUniform "rhs_30Rnd_545x39_7N10_AK";

	{_p addItemToVest "rhs_VOG25"} foreach [1,2];//gp25 ammo
	{_p addItemToVest "rhs_VOG25P"} foreach [1,2];//gp25 ammo

	{_p addItemToBackpack "FirstAidKit"} foreach [1,2];
	{_p addItemToBackpack "rhs_mag_plamyam"} foreach [1,2];//flashbang
	_p addItemToBackpack "APERSTripMine_Wire_Mag";
	_p addItemToBackpack "APERSBoundingMine_Range_Mag";
	_p addItemToBackpack "DemoCharge_Remote_Mag";

	_p addMagazine "rhs_mag_rgd5";//hand grenade
	_p addMagazine "SmokeShell";
	_p addMagazine "SmokeShellGreen";
	_p addMagazine "SmokeShellGreen";
	_p addMagazine "Chemlight_green";
	_p addMagazine "Chemlight_green";
	_p addMagazine "9Rnd_45ACP_Mag";

	_p addWeapon "Binocular";
	[_p,"rhs_weap_ak74m_fullplum_gp25",9] call BIS_fnc_AddWeapon;
	[_p,"hgun_ACPC2_F",2] call BIS_fnc_AddWeapon;//"hgun_ACPC2_F" compatible mags = "9Rnd_45ACP_Mag"
	_p addprimaryweaponitem "rhs_acc_dtk";
	_p addprimaryweaponitem "rhs_acc_pkas";

	{_p linkItem _x} forEach ["ItemMap","ItemCompass","ItemRadio","ItemGPS","ItemWatch","NVGoggles"];//"NVGoggles_INDEP"
};
case 9: {
// RHS - SAF (@RHSAFRF;@RHSUSAF;@RHSGREF;@RHSSAF)
	_p forceAddUniform "rhssaf_uniform_m10_digital";
	_p addItemToUniform "FirstAidKit";
	for "_i" from 1 to 2 do {_p addItemToUniform "rhs_mag_9x19mm_7n21_20";};
	for "_i" from 1 to 2 do {_p addItemToUniform "rhs_GRD40_White";};

	_p addVest "rhssaf_vest_md98_digital";
	_p addItemToVest "HandGrenade";
	_p addItemToVest "SmokeShell";
	_p addItemToVest "rhs_mag_9x19mm_7n21_20";
	for "_i" from 1 to 5 do {_p addItemToVest "rhs_VOG25";};
	for "_i" from 1 to 2 do {_p addItemToVest "rhs_VOG25P";};

	_p addBackpack "rhssaf_kitbag_digital";
	for "_i" from 1 to 5 do {_p addItemToBackpack "FirstAidKit";};
	for "_i" from 1 to 3 do {_p addItemToBackpack "rhs_mag_9x19mm_7n21_20";};
	for "_i" from 1 to 2 do {_p addItemToBackpack "HandGrenade";};
	for "_i" from 1 to 3 do {_p addItemToBackpack "APERSTripMine_Wire_Mag";};
	for "_i" from 1 to 2 do {_p addItemToBackpack "APERSBoundingMine_Range_Mag";};
	for "_i" from 1 to 2 do {_p addItemToBackpack "SmokeShell";};
	_p addItemToBackpack "rhs_VOG25";

	_p addHeadgear "rhssaf_helmet_m97_olive_nocamo";

	_p addWeapon "Binocular";
	[_p,"rhs_weap_m70b3n_pbg40",9] call BIS_fnc_AddWeapon;
	_p addPrimaryWeaponItem "rhs_acc_pgo7v";
	[_p,"rhs_weap_pp2000_folded",4] call BIS_fnc_AddWeapon;
	_p addSecondaryWeaponItem "rhs_acc_rpg7v_zeroing_100";

	{_p linkItem _x} forEach ["ItemMap","ItemCompass","ItemWatch","ItemRadio","ItemGPS","NVGoggles"];

	_p setFace "WhiteHead_22_l";
	_p setSpeaker "Male05GRE";
};
case 10: {
// Leight's Opfor Pack (@RHSAFRF;@RHSUSAF; + (@leights_opfor or @Project_OPFOR))

	_p forceAddUniform "LOP_U_ISTS_Fatigue_01";
	for "_i" from 1 to 3 do {_p addItemToUniform "FirstAidKit";};
	for "_i" from 1 to 5 do {_p addItemToUniform "rhs_VOG25P";};
	for "_i" from 1 to 2 do {_p addItemToUniform "rhs_mag_9x19_17";};

	_p addVest "LOP_6sh46";
	for "_i" from 1 to 3 do {_p addItemToVest "rhs_mag_rgd5";};
	for "_i" from 1 to 6 do {_p addItemToVest "rhs_30Rnd_545x39_AK";};
	for "_i" from 1 to 2 do {_p addItemToVest "rhs_mag_an_m14_th3";};
	_p addItemToVest "rhs_mag_plamyam";
	for "_i" from 1 to 2 do {_p addItemToVest "Chemlight_blue";};
	for "_i" from 1 to 2 do {_p addItemToVest "rhs_mag_m18_yellow";};
	for "_i" from 1 to 2 do {_p addItemToVest "rhs_mag_m18_green";};

	_p addBackpack "B_FieldPack_khk";
	for "_i" from 1 to 3 do {_p addItemToBackpack "FirstAidKit";};
	for "_i" from 1 to 2 do {_p addItemToBackpack "rhs_30Rnd_545x39_AK";};
	for "_i" from 1 to 2 do {_p addItemToBackpack "APERSBoundingMine_Range_Mag";};
	for "_i" from 1 to 2 do {_p addItemToBackpack "APERSTripMine_Wire_Mag";};
	_p addItemToBackpack "SLAMDirectionalMine_Wire_Mag";
	_p addItemToBackpack "IEDUrbanSmall_Remote_Mag";
	_p addItemToBackpack "rhs_mag_plamyam";
	_p addItemToBackpack "rhs_mag_9x19_17";

	_p addHeadgear "LOP_H_Shemag_BLK";

	[_p,"rhs_weap_ak74m_gp25",1] call BIS_fnc_AddWeapon;
	_p addPrimaryWeaponItem "rhs_acc_1p29";
	[_p,"rhs_weap_pya",1] call BIS_fnc_AddWeapon;

	{_p linkItem _x} forEach ["ItemMap","ItemCompass","ItemWatch","ItemRadio","ItemGPS","NVGoggles_OPFOR"];

	_p setFace "PersianHead_A3_02";
	_p setSpeaker "Male03PER";
};
case 11: {
// Iraqi-Syrian Conflict - Islamic State (@RHSAFRF;@RHSUSAF;@RHSGREF;@RHSSAF;@ISC)

	_p forceAddUniform "rhsgref_uniform_woodland";
	for "_i" from 1 to 2 do {_p addItemToUniform "FirstAidKit";};
	_p addItemToUniform "SmokeShellRed";
	for "_i" from 1 to 2 do {_p addItemToUniform "rhs_30Rnd_545x39_AK";};

	_p addVest "V_TacVest_camo";
	for "_i" from 1 to 2 do {_p addItemToVest "FirstAidKit";};
	_p addItemToVest "rhs_30Rnd_545x39_AK";
	for "_i" from 1 to 3 do {_p addItemToVest "rhs_45Rnd_545X39_AK";};
	for "_i" from 1 to 2 do {_p addItemToVest "rhs_VOG25P";};
	for "_i" from 1 to 2 do {_p addItemToVest "rhs_VOG25";};
	for "_i" from 1 to 2 do {_p addItemToVest "rhs_GRD40_Red";};
	_p addItemToVest "rhs_mag_m67";

	_p addBackpack "rhs_assault_umbts";
	for "_i" from 1 to 2 do {_p addItemToBackpack "APERSTripMine_Wire_Mag";};
	for "_i" from 1 to 2 do {_p addItemToBackpack "APERSBoundingMine_Range_Mag";};
	for "_i" from 1 to 2 do {_p addItemToBackpack "rhs_rpg7_PG7V_mag";};
	_p addItemToBackpack "rhs_mag_an_m14_th3";

	_p addHeadgear "rhssaf_helmet_m97_md2camo";

	[_p,"rhs_weap_ak74mr_gp25",1] call BIS_fnc_AddWeapon;
	_p addPrimaryWeaponItem "optic_Hamr";//"rhs_acc_dtk1"
	_p addPrimaryWeaponItem "rhs_acc_perst1ik_ris";
	_p addPrimaryWeaponItem "rhs_acc_rakursPM";
	[_p,"rhs_weap_rpg7",1] call BIS_fnc_AddWeapon;
	_p addSecondaryWeaponItem "rhs_acc_rpg7v_zeroing_100";
	_p addSecondaryWeaponItem "rhs_acc_pgo7v2";

	{_p linkItem _x} forEach ["ItemMap","ItemCompass","ItemWatch","ItemRadio","ItemGPS","rhs_1PN138"];

	_p setFace "PersianHead_A3_02";
	_p setSpeaker "male03per";
};
case 12: {
// CUP Takistan Army (@CBA_A3;@cup_units;@cup_weapons;@cup_vehicles")

	_p forceAddUniform "CUP_U_O_TK_Green";
	_p addItemToUniform "FirstAidKit";
	for "_i" from 1 to 2 do {_p addItemToUniform "SmokeShellRed";};
	for "_i" from 1 to 2 do {_p addItemToUniform "CUP_30Rnd_545x39_AK_M";};

	_p addVest "CUP_V_O_TK_Vest_1";
	for "_i" from 1 to 2 do {_p addItemToVest "CUP_HandGrenade_RGD5";};
	for "_i" from 1 to 7 do {_p addItemToVest "CUP_1Rnd_HE_GP25_M";};
	for "_i" from 1 to 4 do {_p addItemToVest "CUP_1Rnd_SmokeRed_GP25_M";};
	for "_i" from 1 to 5 do {_p addItemToVest "CUP_30Rnd_TE1_Yellow_Tracer_545x39_AK_M";};
	_p addItemToVest "CUP_45Rnd_TE4_LRT4_Green_Tracer_545x39_RPK_M";

	_p addBackpack "CUP_B_AlicePack_Khaki";
	_p addItemToBackpack "Medikit";
	for "_i" from 1 to 5 do {_p addItemToBackpack "CUP_HandGrenade_RGD5";};
	_p addItemToBackpack "IEDLandSmall_Remote_Mag";
	for "_i" from 1 to 2 do {_p addItemToBackpack "APERSTripMine_Wire_Mag";};
	_p addItemToBackpack "DemoCharge_Remote_Mag";
	_p addItemToBackpack "CUP_30Rnd_TE1_Yellow_Tracer_545x39_AK_M";
	for "_i" from 1 to 2 do {_p addItemToBackpack "CUP_30Rnd_545x39_AK_M";};

	_p addHeadgear "CUP_H_TK_Helmet";
	_p addGoggles "CUP_TK_NeckScarf";

	[_p,"CUP_arifle_AK107_GL",1] call BIS_fnc_AddWeapon;
	_p addPrimaryWeaponItem "CUP_muzzle_PBS4";
	_p addPrimaryWeaponItem "CUP_optic_Kobra";

	{_p linkItem _x} forEach ["ItemMap","ItemCompass","ItemWatch","ItemRadio","ItemGPS","NVGoggles_OPFOR"];

	_p setFace "PersianHead_A3_02";
	_p setSpeaker "Male01PER";
};
case 13: {
//Masi Middle Eastern Wafare CSAT Army

	_p forceAddUniform "U_mas_med_O_CombatUniform_ir";
	_p addItemToUniform "FirstAidKit";
	for "_i" from 1 to 3 do {_p addItemToUniform "20Rnd_mas_762x51_T_Stanag";};
	for "_i" from 1 to 2 do {_p addItemToUniform "20Rnd_mas_762x51_Stanag";};
	_p addItemToUniform "SmokeShell";

	_p addVest "V_mas_med_ME_armor_she";
	for "_i" from 1 to 2 do {_p addItemToVest "20Rnd_mas_762x51_Stanag";};
	for "_i" from 1 to 4 do {_p addItemToVest "HandGrenade";};
	for "_i" from 1 to 6 do {_p addItemToVest "1Rnd_HE_Grenade_shell";};
	for "_i" from 1 to 3 do {_p addItemToVest "40Rnd_mas_46x30_Mag";};
	for "_i" from 1 to 2 do {_p addItemToVest "SmokeShell";};
	_p addItemToVest "1Rnd_SmokeRed_Grenade_shell";

	_p addBackpack "B_mas_med_m_Bergen_rus";
	for "_i" from 1 to 3 do {_p addItemToBackpack "FirstAidKit";};
	for "_i" from 1 to 2 do {_p addItemToBackpack "APERSTripMine_Wire_Mag";};
	for "_i" from 1 to 2 do {_p addItemToBackpack "APERSBoundingMine_Range_Mag";};
	_p addItemToBackpack "IEDLandSmall_Remote_Mag";
	_p addItemToBackpack "IEDUrbanSmall_Remote_Mag";
	_p addItemToBackpack "APERSMine_Range_Mag";

	_p addHeadgear "H_mas_med_HelmetIR";
	_p addGoggles "G_Bandanna_khk";

	[_p,"arifle_mas_med_g3_m203_hd",1] call BIS_fnc_AddWeapon;
	_p addPrimaryWeaponItem "muzzle_mas_snds_Mc";
	_p addPrimaryWeaponItem "optic_mas_Arco_blk";
	[_p,"hgun_mas_mp7p_F",1] call BIS_fnc_AddWeapon;
	_p addHandgunItem "optic_mas_Arco_blk";
	_p addWeapon "Binocular";

	{_p linkItem _x} forEach ["ItemMap","ItemCompass","ItemWatch","ItemRadio","ItemGPS","NVGoggles_OPFOR"];

	_p setFace "GreekHead_A3_10_a";
	_p setSpeaker "Male03PER";
};
case 14: {
//Masi Middle Eastern Wafare Takistan Army

	_p forceAddUniform "U_mas_med_O_CombatUniform";
	_p addItemToUniform "FirstAidKit";
	for "_i" from 1 to 2 do {_p addItemToUniform "30Rnd_mas_762x39_mag";};
	for "_i" from 1 to 3 do {_p addItemToUniform "30Rnd_mas_762x39_T_mag";};
	_p addItemToUniform "SmokeShell";

	_p addVest "V_mas_med_Sovest_she";
	for "_i" from 1 to 2 do {_p addItemToVest "30Rnd_mas_762x39_T_mag";};
	for "_i" from 1 to 3 do {_p addItemToVest "HandGrenade";};
	for "_i" from 1 to 6 do {_p addItemToVest "1Rnd_HE_Grenade_shell";};
	for "_i" from 1 to 3 do {_p addItemToVest "40Rnd_mas_46x30_Mag";};
	for "_i" from 1 to 2 do {_p addItemToVest "SmokeShell";};

	_p addBackpack "B_mas_med_m_Bergen_rus";
	for "_i" from 1 to 3 do {_p addItemToBackpack "FirstAidKit";};
	_p addItemToBackpack "SmokeShell";
	for "_i" from 1 to 2 do {_p addItemToBackpack "APERSBoundingMine_Range_Mag";};
	for "_i" from 1 to 2 do {_p addItemToBackpack "APERSTripMine_Wire_Mag";};
	_p addItemToBackpack "IEDLandSmall_Remote_Mag";
	_p addItemToBackpack "IEDUrbanSmall_Remote_Mag";
	_p addItemToBackpack "APERSMine_Range_Mag";

	_p addHeadgear "H_mas_med_HelmetruO";
	_p addGoggles "G_mas_wpn_shemag";

	[_p,"arifle_mas_med_akm_gl_hd",1] call BIS_fnc_AddWeapon;
	_p addPrimaryWeaponItem "muzzle_mas_snds_AK";
	_p addPrimaryWeaponItem "optic_mas_kobra_c";
	[_p,"hgun_mas_mp7p_F",1] call BIS_fnc_AddWeapon;
	_p addHandgunItem "muzzle_mas_snds_MP7";
	_p addHandgunItem "optic_mas_Arco_blk";
	_p addWeapon "Binocular";

	{_p linkItem _x} forEach ["ItemMap","ItemCompass","ItemWatch","ItemRadio","ItemGPS","NVGoggles_OPFOR"];

	_p setFace "GreekHead_A3_10_a";
	_p setSpeaker "Male03PER";
};
case 15: {
// African Conflict (@CBA_A3;@AfricanConflict_mas;@NATO_Rus_Weapons_CBA;@NATO_Rus_Vehicle)

	_p forceAddUniform "U_mas_afr_O_uniform1";
	for "_i" from 1 to 2 do {_p addItemToUniform "FirstAidKit";};
	for "_i" from 1 to 2 do {_p addItemToUniform "SmokeShell";};
	for "_i" from 1 to 2 do {_p addItemToUniform "SmokeShellGreen";};
	for "_i" from 1 to 2 do {_p addItemToUniform "Chemlight_green";};

	_p addVest "V_mas_afr_ME_armor";
	_p addItemToVest "40Rnd_mas_46x30_Mag";
	_p addItemToVest "100Rnd_mas_762x39_T_mag";
	for "_i" from 1 to 2 do {_p addItemToVest "FirstAidKit";};

	_p addBackpack "B_mas_AssaultPack_mul";
	for "_i" from 1 to 4 do {_p addItemToBackpack "HandGrenade";};
	for "_i" from 1 to 2 do {_p addItemToBackpack "APERSTripMine_Wire_Mag";};
	for "_i" from 1 to 2 do {_p addItemToBackpack "APERSBoundingMine_Range_Mag";};
	_p addItemToBackpack "SLAMDirectionalMine_Wire_Mag";

	_p addHeadgear "H_mas_afr_HelmetO";

	_p addWeapon "Binocular";
	[_p,"LMG_mas_m72_F",1] call BIS_fnc_AddWeapon;
	_p addPrimaryWeaponItem "optic_mas_kobra";
	[_p,"hgun_mas_mp7p_F",1] call BIS_fnc_AddWeapon;
	_p addHandgunItem "optic_mas_Arco_blk";
	[_p,"LMG_mas_m72_F",2] call BIS_fnc_AddWeapon;
	[_p,"hgun_mas_mp7p_F",1] call BIS_fnc_AddWeapon;

	{_p linkItem _x} forEach ["ItemMap","ItemCompass","ItemRadio","ItemGPS","ItemWatch","NVGoggles_OPFOR"];

	_p setFace "PersianHead_A3_02";
	_p setSpeaker "Male01PER";
};
case 16: {
// OPTRE (@CBA_A3;@OPTRE)
	_p forceAddUniform "OPTRE_Ins_ER_uniform_GAtan";
	for "_i" from 1 to 4 do {_p addItemToUniform "FirstAidKit";};

	_p addVest "OPTRE_INS_UNSC_vest12";
	for "_i" from 1 to 4 do {_p addItemToVest "OPTRE_60Rnd_762x51_Mag";};
	for "_i" from 1 to 2 do {_p addItemToVest "OPTRE_60Rnd_762x51_Mag_Tracer";};
	for "_i" from 1 to 4 do {_p addItemToVest "OPTRE_12Rnd_127x40_Mag";};

	_p addBackpack "OPTRE_ILCS_Rucksack_tan";
	_p addItemToBackpack "OPTRE_MedKit";
	for "_i" from 1 to 4 do {_p addItemToBackpack "OPTRE_M9_Frag";};
	for "_i" from 1 to 4 do {_p addItemToBackpack "OPTRE_M8_Flare";};
	for "_i" from 1 to 2 do {_p addItemToBackpack "OPTRE_M2_Smoke";};
	for "_i" from 1 to 2 do {_p addItemToBackpack "OPTRE_M2_Smoke_Red";};
	_p addItemToBackpack "DemoCharge_Remote_Mag";
	for "_i" from 1 to 2 do {_p addItemToBackpack "APERSTripMine_Wire_Mag";};
	for "_i" from 1 to 2 do {_p addItemToBackpack "APERSBoundingMine_Range_Mag";};
	_p addItemToBackpack "IEDUrbanBig_Remote_Mag";

	_p addHeadgear "OPTRE_INS_Helmet_vet";

	[_p,"OPTRE_MA5B",1] call BIS_fnc_AddWeapon;
	_p addPrimaryWeaponItem "OPTRE_MA5B_Flashlight";
	_p addPrimaryWeaponItem "OPTRE_MA5B_AmmoCounter";
	[_p,"OPTRE_M6C",1] call BIS_fnc_AddWeapon;
	_p addHandgunItem "OPTRE_M6C_Laser";
	_p addWeapon "Rangefinder";

	{_p linkItem _x} forEach ["ItemMap","ItemCompass","ItemWatch","ItemRadio","ItemGPS","OPTRE_NVG"];

	_p setFace "PersianHead_A3_02";
	_p setSpeaker "Male03PER";
};
// IFA3 Desert US Army (@CBA_A3;@CUP_Terrains_Core;@CUP_Terrains_Maps;@IFA3_Terrains_LITE;@I44_Terrains@IFA3_LITE;@IFA3_Objects_LITE)
case 17: {
	_P forceAddUniform "U_LIB_US_Private";
	for "_i" from 1 to 3 do {_P addItemToUniform "FirstAidKit";};
	for "_i" from 1 to 2 do {_P addItemToUniform "LIB_8Rnd_9x19";};

	_P addVest "V_LIB_US_Vest_Bar";
	_P addItemToVest "FirstAidKit";
	_P addItemToVest "LIB_8Rnd_9x19";
	for "_i" from 1 to 3 do {_P addItemToVest "LIB_63Rnd_762x54";};
	for "_i" from 1 to 5 do {_P addItemToVest "LIB_m39";};

	_P addBackpack "B_LIB_US_Backpack";
	_P addItemToBackpack "FirstAidKit";
	for "_i" from 1 to 4 do {_P addItemToBackpack "LIB_US_M18_Red";};
	_P addItemToBackpack "LIB_US_TNT_4pound_mag";

	_p addHeadgear "H_LIB_US_Helmet";

	[_p,"LIB_DT",1] call BIS_fnc_AddWeapon;
	[_p,"LIB_M1A1_Bazooka",1] call BIS_fnc_AddWeapon;
	[_p,"OPTRE_M6C",1] call BIS_fnc_AddWeapon;
	_P addWeapon "LIB_M1908";
	_P addWeapon "LIB_Binocular_GER";

	{_p linkItem _x} forEach ["ItemMap","ItemCompass","ItemWatch","ItemRadio","ItemGPS","G_LIB_Scarf_G"];

	_p setFace "WhiteHead_22_l";
	_p setSpeaker "Male03Ger";
};
default {};
};

/*
British Voices ["Male01ENGB","Male02ENGB","Male03ENGB","Male04ENGB"]
primaryWeaponItems player, magazinecargo player
*/
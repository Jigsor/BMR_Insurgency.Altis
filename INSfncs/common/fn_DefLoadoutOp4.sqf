// DefLoadoutOp4.sqf by Jigsor
params ["_p"];
waitUntil {alive _p};

// CSAT (A3) or CSAT (Pacific)
if (INS_op_faction in [1,4,5]) exitWith {
	removeAllAssignedItems _p;
	//{_p linkItem _x} forEach ["ItemMap","ItemCompass","ItemRadio","ItemGPS","ItemWatch","G_Tactical_Clear","NVGoggles_OPFOR"];
	["ItemMap","ItemCompass","ItemRadio","ItemGPS","ItemWatch","G_Tactical_Clear","NVGoggles_OPFOR"] apply {_p linkItem _x};
};

removeAllWeapons _p;
removeAllAssignedItems _p;
removeAllContainers _p;
removeHeadgear _p;
removeGoggles _p;

if (INS_op_faction in [2,3]) exitWith {
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

	//{_p linkItem _x} forEach ["ItemMap","ItemCompass","ItemRadio","ItemGPS","ItemWatch","G_Tactical_Clear","NVGoggles_INDEP"];
	["ItemMap","ItemCompass","ItemRadio","ItemGPS","ItemWatch","G_Tactical_Clear","NVGoggles_INDEP"] apply {_p linkItem _x};
};

if (INS_op_faction in [6,7]) exitWith {
// LDF (A3)

	_p addWeapon "arifle_MSBS65_ico_pointer_f";
	_p addPrimaryWeaponItem "muzzle_snds_H";
	_p addPrimaryWeaponItem "acc_pointer_IR";
	_p addPrimaryWeaponItem "optic_Arco_lush_F";
	_p addPrimaryWeaponItem "30Rnd_65x39_caseless_msbs_mag";
	_p addWeapon "launch_RPG32_green_F";
	_p addSecondaryWeaponItem "RPG32_F";
	_p addWeapon "hgun_Pistol_heavy_01_green_F";
	_p addHandgunItem "11Rnd_45ACP_Mag";

	_p forceAddUniform "U_I_E_Uniform_01_F";
	_p addVest "V_CarrierRigKBT_01_light_EAF_F";
	_p addBackpack "B_Fieldpack_green_IEAT_F";

	for "_i" from 1 to 2 do {_p addItemToUniform "FirstAidKit";};
	for "_i" from 1 to 2 do {_p addItemToUniform "30Rnd_65x39_caseless_msbs_mag";};
	for "_i" from 1 to 2 do {_p addItemToUniform "Chemlight_blue";};
	for "_i" from 1 to 3 do {_p addItemToVest "30Rnd_65x39_caseless_msbs_mag";};
	for "_i" from 1 to 2 do {_p addItemToVest "11Rnd_45ACP_Mag";};
	for "_i" from 1 to 3 do {_p addItemToVest "SmokeShellBlue";};
	_p addItemToVest "APERSBoundingMine_Range_Mag";
	for "_i" from 1 to 2 do {_p addItemToVest "APERSTripMine_Wire_Mag";};
	_p addItemToVest "HandGrenade";
	for "_i" from 1 to 3 do {_p addItemToBackpack "FirstAidKit";};
	_p addItemToBackpack "MineDetector";
	for "_i" from 1 to 2 do {_p addItemToBackpack "RPG32_F";};
	for "_i" from 1 to 2 do {_p addItemToBackpack "30Rnd_65x39_caseless_msbs_mag";};
	_p addItemToBackpack "HandGrenade";
	_p addHeadgear "H_HelmetHBK_ear_F";
	_p addGoggles "G_Tactical_Clear";

	//{_p linkItem _x} forEach ["ItemMap","ItemCompass","ItemWatch","ItemRadio","ItemGPS","NVGoggles_INDEP"];
	["ItemMap","ItemCompass","ItemWatch","ItemRadio","ItemGPS","NVGoggles_INDEP"] apply {_p linkItem _x};

	[_p,"WhiteHead_22_l","male03pol"] call BIS_fnc_setIdentity;
};

if (INS_op_faction in [8]) exitWith {
// Spetsnaz (A3)

	_p addWeapon "arifle_AK12_lush_F";
	_p addPrimaryWeaponItem "muzzle_snds_B_lush_F";
	_p addPrimaryWeaponItem "acc_pointer_IR";
	_p addPrimaryWeaponItem "optic_Arco_AK_lush_F";
	_p addPrimaryWeaponItem "30rnd_762x39_AK12_Lush_Mag_F";
	_p addWeapon "launch_RPG32_green_F";
	_p addSecondaryWeaponItem "RPG32_F";
	_p addWeapon "hgun_Rook40_F";
	_p addHandgunItem "16Rnd_9x21_Mag";

	_p forceAddUniform "U_O_R_Gorka_01_camo_F";
	_p addVest "V_SmershVest_01_F";
	_p addBackpack "B_FieldPack_taiga_RPG_AT_F";

	_p addWeapon "Binocular";

	_p addItemToUniform "FirstAidKit";
	_p addItemToUniform "Chemlight_red";
	for "_i" from 1 to 3 do {_p addItemToUniform "30rnd_762x39_AK12_Lush_Mag_F";};
	_p addItemToVest "MineDetector";
	_p addItemToVest "FirstAidKit";
	for "_i" from 1 to 2 do {_p addItemToVest "16Rnd_9x21_Mag";};
	for "_i" from 1 to 4 do {_p addItemToVest "SmokeShellRed";};
	_p addItemToVest "Chemlight_red";
	for "_i" from 1 to 4 do {_p addItemToVest "30rnd_762x39_AK12_Lush_Mag_F";};
	for "_i" from 1 to 2 do {_p addItemToVest "HandGrenade";};
	_p addItemToVest "APERSBoundingMine_Range_Mag";
	_p addItemToVest "APERSTripMine_Wire_Mag";
	for "_i" from 1 to 2 do {_p addItemToBackpack "FirstAidKit";};
	_p addItemToBackpack "ToolKit";
	_p addItemToBackpack "RPG32_F";
	_p addItemToBackpack "RPG32_HE_F";
	_p addHeadgear "H_HelmetAggressor_cover_taiga_F";
	_p addGoggles "G_Tactical_Clear";

	_p linkItem "ItemMap";
	_p linkItem "ItemCompass";
	_p linkItem "ItemWatch";
	_p linkItem "ItemRadio";
	_p linkItem "ItemGPS";
	_p linkItem "O_NVGoggles_grn_F";

	[_p,"WhiteHead_22_l","male02rus"] call BIS_fnc_setIdentity;
};

switch (INS_op_faction) do {//begin switch

case 9: {
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

	//{_p linkItem _x} forEach ["ItemMap","ItemCompass","ItemRadio","ItemGPS","ItemWatch","G_Tactical_Clear","NVGoggles"];//"NVGoggles_OPFOR"
	["ItemMap","ItemCompass","ItemRadio","ItemGPS","ItemWatch","G_Tactical_Clear","NVGoggles"] apply {_p linkItem _x};//"NVGoggles_OPFOR"
};
case 10: {
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

	//{_p linkItem _x} forEach ["ItemMap","ItemCompass","ItemRadio","ItemGPS","ItemWatch","G_Tactical_Clear","NVGoggles"];//"NVGoggles_OPFOR"
	["ItemMap","ItemCompass","ItemRadio","ItemGPS","ItemWatch","G_Tactical_Clear","NVGoggles"] apply {_p linkItem _x};//"NVGoggles_OPFOR"
};
case 11: {
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

	{_p linkItem _x} forEach ["ItemMap","ItemCompass","ItemRadio","ItemGPS","ItemWatch","G_Tactical_Clear","NVGoggles"];//"NVGoggles_INDEP"
};
case 12: {
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

	{_p linkItem _x} forEach ["ItemMap","ItemCompass","ItemWatch","ItemRadio","ItemGPS","G_Tactical_Clear","NVGoggles"];

	_p setFace "WhiteHead_22_l";
	_p setSpeaker "Male05GRE";
};
case 13: {
// Project OPFOR (@RHSAFRF;@RHSUSAF;@RHSGREF;@Project_OPFOR)

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
case 14: {
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
case 15: {
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
case 16: {
// CUP Armed Forces of the Russian Federation MSV (@CBA_A3;@cup_units;@cup_weapons;@cup_vehicles")

	_p forceAddUniform "CUP_U_O_RUS_EMR_2";
	_p addItemToUniform "FirstAidKit";
	for "_i" from 1 to 2 do {_p addItemToUniform "SmokeShell";};
	_p addItemToUniform "CUP_HandGrenade_RGD5";

	_p addVest "CUP_V_RUS_6B45_2";

	_p addBackpack "CUP_B_RUS_Pack_MG";
	_p addItemToBackpack "CUP_optic_PechenegScope";
	for "_i" from 1 to 6 do {_p addItemToBackpack "FirstAidKit";};
	_p addItemToBackpack "ToolKit";
	_p addItemToBackpack "MineDetector";
	for "_i" from 1 to 3 do {_p addItemToBackpack "CUP_HandGrenade_RGD5";};
	for "_i" from 1 to 2 do {_p addItemToBackpack "APERSBoundingMine_Range_Mag";};
	for "_i" from 1 to 2 do {_p addItemToBackpack "APERSMine_Range_Mag";};
	for "_i" from 1 to 2 do {_p addItemToBackpack "APERSTripMine_Wire_Mag";};

	_p addHeadgear "CUP_H_RUS_6B46";
	_p addGoggles "G_Tactical_Clear";

	[_p,"CUP_lmg_Pecheneg_PScope",2] call BIS_fnc_AddWeapon;
	_p addPrimaryWeaponItem "CUP_optic_ekp_8_02";
	[_p,"CUP_hgun_MicroUzi",3] call BIS_fnc_AddWeapon;
	_p addWeapon "CUP_launch_RPG18";
	_p addWeapon "CUP_LRTV";

	{_p linkItem _x} forEach ["ItemMap","ItemCompass","ItemWatch","ItemRadio","ItemGPS","CUP_NVG_HMNVS"];

	_p setFace "WhiteHead_22_l";
	_p setSpeaker "cup_d_male03_ru";
};
case 17: {
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
case 18: {
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
case 19: {
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
case 20: {
// OPTRE (@CBA_A3;@OPTRE)

	_p addWeapon "OPTRE_MA5A";
	_p addPrimaryWeaponItem "muzzle_snds_65_TI_blk_F";
	_p addPrimaryWeaponItem "acc_pointer_IR";
	_p addPrimaryWeaponItem "optic_Hamr";
	_p addPrimaryWeaponItem "OPTRE_60Rnd_762x51_Mag_Tracer_Yellow";
	_p addWeapon "OPTRE_M41_SSR";
	_p addSecondaryWeaponItem "OPTRE_M41_Twin_HEAT";

	_p forceAddUniform "OPTRE_Ins_URF_Combat_Uniform";
	_p addVest "OPTRE_Ins_URF_Armor1";
	_p addBackpack "OPTRE_B_TacticalPack_blk_M41G";

	_p addWeapon "Binocular";

	for "_i" from 1 to 2 do {_p addItemToUniform "FirstAidKit";};
	_p addItemToUniform "OPTRE_M2_Smoke";
	_p addItemToUniform "HandGrenade";
	for "_i" from 1 to 3 do {_p addItemToVest "FirstAidKit";};
	_p addItemToVest "MineDetector";
	for "_i" from 1 to 4 do {_p addItemToVest "OPTRE_60Rnd_762x51_Mag_Tracer_Yellow";};
	_p addItemToVest "OPTRE_M2_Smoke_Green";
	for "_i" from 1 to 3 do {_p addItemToVest "SmokeShellGreen";};
	_p addItemToBackpack "OPTRE_M41_Twin_HEAT";
	for "_i" from 1 to 2 do {_p addItemToBackpack "APERSTripMine_Wire_Mag";};
	_p addItemToBackpack "APERSBoundingMine_Range_Mag";
	_p addItemToBackpack "M41_IED_B_Remote_Mag";
	_p addItemToBackpack "UNSCMine_Range_Mag";
	_p addHeadgear "OPTRE_Ins_URF_Helmet4";
	_p addGoggles "G_Tactical_Clear";

	{_p linkItem _x} forEach ["ItemMap","ItemCompass","ItemWatch","ItemRadio","OPTRE_NVG"];

	[_p,"WhiteHead_22_l",""] call BIS_fnc_setIdentity;
};
case 21: {
// IFA3 Desert US Army (@CBA_A3;@CUP_Terrains_Core;@CUP_Terrains_Maps;@IFA3_AIO_LITE)

	_p forceAddUniform "U_LIB_US_private";
	for "_i" from 1 to 3 do {_p addItemToUniform "FirstAidKit";};
	for "_i" from 1 to 2 do {_p addItemToUniform "LIB_8Rnd_9x19";};

	_p addVest "V_LIB_US_Vest_Bar";
	_p addItemToVest "FirstAidKit";
	_p addItemToVest "LIB_8Rnd_9x19";
	for "_i" from 1 to 3 do {_p addItemToVest "LIB_63Rnd_762x54";};
	for "_i" from 1 to 5 do {_p addItemToVest "LIB_m39";};

	_p addBackpack "B_LIB_US_Backpack";
	_p addItemToBackpack "FirstAidKit";
	for "_i" from 1 to 4 do {_p addItemToBackpack "LIB_US_M18_Red";};
	_p addItemToBackpack "LIB_US_TNT_4pound_mag";

	_p addHeadgear "H_LIB_US_Helmet";

	[_p,"LIB_DT",1] call BIS_fnc_AddWeapon;
	[_p,"LIB_M1A1_Bazooka",1] call BIS_fnc_AddWeapon;
	_p addWeapon "LIB_M1908";
	_p addWeapon "LIB_Binocular_GER";

	{_p linkItem _x} forEach ["ItemMap","ItemCompass","ItemWatch","ItemRadio","ItemGPS","G_LIB_Scarf_G"];

	_p setFace "WhiteHead_22_l";
	_p setSpeaker "Male03Ger";
};
case 22: {
// Unsung VC

	_p forceAddUniform "UNS_VC_G";
	for "_i" from 1 to 2 do {_p addItemToUniform "FirstAidKit";};
	for "_i" from 1 to 2 do {_p addItemToUniform "uns_makarovmag";};

	_p addVest "UNS_VC_A1";
	_p addItemToVest "FirstAidKit";
	_p addItemToVest "uns_traps_nade_mag4";
	for "_i" from 1 to 3 do {_p addItemToVest "uns_ak47mag";};
	for "_i" from 1 to 5 do {_p addItemToVest "uns_rdg2";};

	_p addBackpack "UNS_TROP_R1";
	for "_i" from 1 to 2 do {_p addItemToBackpack "FirstAidKit";};
	for "_i" from 1 to 2 do {_p addItemToBackpack "uns_ak47mag";};
	_p addItemToBackpack "uns_molotov_mag";
	for "_i" from 1 to 3 do {_p addItemToVest "uns_t67gren";};
	_p addItemToBackpack "uns_rpg7grenade";

	_p addHeadgear "UNS_Boonie4_VC";

	[_p,"uns_ak47",1] call BIS_fnc_AddWeapon;
	[_p,"uns_rpg7",1] call BIS_fnc_AddWeapon;
	[_p,"uns_makarov",1] call BIS_fnc_AddWeapon;
	_p addWeapon "Binocular";

	{_p linkItem _x} forEach ["ItemMap","ItemCompass","ItemWatch","ItemRadio"];

	_p setFace "AsianHead_A3_05_cfaces_lrrpcamo06";
	_p setSpeaker "Male03CHI";
};
case 23: {
// Unsung VC

	_p forceAddUniform "UNS_VC_G";
	for "_i" from 1 to 2 do {_p addItemToUniform "FirstAidKit";};
	for "_i" from 1 to 2 do {_p addItemToUniform "uns_makarovmag";};

	_p addVest "UNS_VC_A1";
	_p addItemToVest "FirstAidKit";
	_p addItemToVest "uns_traps_nade_mag4";
	for "_i" from 1 to 3 do {_p addItemToVest "uns_ak47mag";};
	for "_i" from 1 to 5 do {_p addItemToVest "uns_rdg2";};

	_p addBackpack "UNS_TROP_R1";
	for "_i" from 1 to 2 do {_p addItemToBackpack "FirstAidKit";};
	for "_i" from 1 to 2 do {_p addItemToBackpack "uns_ak47mag";};
	_p addItemToBackpack "uns_molotov_mag";
	for "_i" from 1 to 3 do {_p addItemToVest "uns_t67gren";};
	_p addItemToBackpack "uns_rpg7grenade";

	_p addHeadgear "UNS_Boonie4_VC";

	[_p,"uns_ak47",1] call BIS_fnc_AddWeapon;
	[_p,"uns_rpg7",1] call BIS_fnc_AddWeapon;
	[_p,"uns_makarov",1] call BIS_fnc_AddWeapon;
	_p addWeapon "Binocular";

	{_p linkItem _x} forEach ["ItemMap","ItemCompass","ItemWatch","ItemRadio"];

	_p setFace "AsianHead_A3_05_cfaces_lrrpcamo06";
	_p setSpeaker "Male03CHI";
};
case 24: {
//	PRACS 2023 1st Infantry Division

	_p forceAddUniform "PRACS_M10_1ID_uniform";
	_p addVest "PRACS_C_CIRAS_G3_medic";
	_p addBackpack "rhs_medic_bag_filled";
	_p addHeadgear "PRACS_LWH_6TDES";
	//_p addGoggles "G_Tactical_Clear";

	_p addItemToUniform "FirstAidKit";
	_p addItemToUniform "PRACS_20rd_G3_mag";

	for "_i" from 1 to 4 do {_p addItemToVest "PRACS_20rd_G3_mag";};
	for "_i" from 1 to 2 do {_p addItemToVest "rhs_mag_m18_purple";};
	for "_i" from 1 to 3 do {_p addItemToVest "rhs_mag_m67";};

	_p addItemToBackpack "Medikit";
	for "_i" from 1 to 2 do {_p addItemToBackpack "FirstAidKit";};

	[_p,"PRACS_g3a3",1] call BIS_fnc_AddWeapon;
	[_p,"PRACS_SAAWS",1] call BIS_fnc_AddWeapon;
	_p addSecondaryWeaponItem "rhs_mag_maaws_HEAT";
	[_p,"rhs_weap_savz61_folded",2] call BIS_fnc_AddWeapon;
	//_p addWeapon "Binocular";
	_p addWeapon "rhssaf_zrak_rd7j";

	//items
	{_p linkItem _x} forEach ["ItemMap","ItemCompass","ItemRadio","ItemGPS","ItemWatch","G_Tactical_Clear","NVGoggles"];//"NVGoggles_INDEP"
	_p setFace "GreekHead_A3_10_a";
	_p setSpeaker "RHS_Male05CZ";
	//[_p,"WhiteHead_22_l","male12eng"] call BIS_fnc_setIdentity;

};

case 25: {
// PRACS 2023 Royal Sahrani Marines

	_p forceAddUniform "PRACS_M10_Marine_Raider_uniform";
	_p addVest "PRACS_C_CIRAS_G3_medic";
	_p addBackpack "PRACS_FieldPack_medic";
	_p addHeadgear "rhsusf_ach_bare_tan_headset_ess";
	//_p addGoggles "G_Tactical_Clear";

	_p addItemToUniform "FirstAidKit";
	_p addItemToUniform "PRACS_40rd_HK33_M855A1_mag";
	_p addItemToUniform "SmokeShellPurple";
	_p addItemToUniform "rhsgref_20rnd_765x17_vz61";

	_p addItemToVest "Medikit";
	_p addItemToVest "SmokeShellPurple";
	_p addItemToVest "rhsgref_20rnd_765x17_vz61";
	for "_i" from 1 to 4 do {_p addItemToVest "FirstAidKit";};
	for "_i" from 1 to 4 do {_p addItemToVest "PRACS_40rd_HK33_M855A1_mag";};
	for "_i" from 1 to 2 do {_p addItemToVest "SmokeShell";};
	for "_i" from 1 to 2 do {_p addItemToVest "Chemlight_green";};

	_p addItemToBackpack "rhs_mag_maaws_HEAT";
	_p addItemToBackpack "rhs_mine_m2a3b_trip_mag";
	_p addItemToBackpack "rhs_mine_glasmine43_hz_mag";
	_p addItemToBackpack "rhs_mine_a200_bz_mag";
	_p addItemToBackpack "rhs_mine_Mk2_tripwire_mag";
	for "_i" from 1 to 2 do {_p addItemToBackpack "rhs_grenade_mkii_mag";};

	_p addWeapon "PRACS_HK53_ACO";//rifle
	_p addPrimaryWeaponItem "optic_Aco";
	_p addPrimaryWeaponItem "PRACS_40rd_HK33_M855A1_mag";
	_p addWeapon "PRACS_SAAWS";//launcher
	_p addSecondaryWeaponItem "rhs_mag_maaws_HEAT";
	_p addWeapon "rhs_weap_savz61_folded";//handgun
	_p addHandgunItem "rhsgref_20rnd_765x17_vz61";
	_p addWeapon "rhssaf_zrak_rd7j";//binoculars

	//items
	{_p linkItem _x} forEach ["ItemMap","ItemCompass","ItemRadio","ItemGPS","ItemWatch","G_Tactical_Clear","NVGoggles"];//"NVGoggles_INDEP"

	_p setFace "GreekHead_A3_10_a";
	_p setSpeaker "RHS_Male05CZ";
};

default {};

};//end switch

//primaryWeaponItems player, magazinecargo player
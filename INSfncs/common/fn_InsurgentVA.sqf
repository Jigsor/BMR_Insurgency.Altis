// Modify this file with desired classnames for customization of Opfor/Resistance Arsenal. Only items listed here will be available in Virtual Arsenal.
// If using class names from moded content then these mods must be loaded or else client side error warning occurs.
// becarefull not to make opfor/resistance players to op.
if (!hasInterface) exitWith {};

if (INS_op_faction in [21]) exitWith
{ // IFA3/FOW contents only
_availableBackpacks = [
	"B_Parachute",       //Vanilla, Not required for HALO or Bail
	"B_LIB_US_Backpack",
	"B_LIB_US_Backpack_Bandoleer",
	"B_LIB_US_Backpack_dday",
	"B_LIB_US_Backpack_eng",
	"B_LIB_US_Backpack_Mk2",
	"B_LIB_US_Backpack_RocketBag",
	"B_LIB_US_Backpack_RocketBag_Big_Empty",
	"B_LIB_US_Backpack_RocketBag_Empty",
	"B_LIB_US_Bag",
	"B_LIB_US_Bandoleer",
	"B_LIB_US_BARBag",
	"B_LIB_US_BazBag",
	"B_LIB_US_M2Flamethrower",
	"B_LIB_US_M36",
	"B_LIB_US_M36_Bandoleer",
	"B_LIB_US_M36_KOTH",
	"B_LIB_US_M36_MGbag",
	"B_LIB_US_M36_Rocketbag",
	"B_LIB_US_M36_Rocketbag_Big_Empty",
	"B_LIB_US_M36_Rocketbag_Empty",
	"B_LIB_US_M36_Rope",
	"B_LIB_US_MedicBackpack",
	"B_LIB_US_MedicBackpack_Big_Empty",
	"B_LIB_US_MedicBackpack_Empty",
	"B_LIB_US_MGbag",
	"B_LIB_US_MGbag_Big_Empty",
	"B_LIB_US_MGbag_Empty",
	"B_LIB_US_MineBag",
	"B_LIB_US_Parachute",
	"B_LIB_US_Radio",
	"B_LIB_US_Radio_ACRE2",
	"B_LIB_US_Radio_Empty",
	"B_LIB_US_RocketBag",
	"B_LIB_US_RocketBag_Big_Empty",
	"B_LIB_US_RocketBag_Empty",
	"B_LIB_US_Type5",
	"B_LIB_US_TypeA3",
	"LIB_Backpack_us",
	"LIB_Backpack_US_BAR",
	"LIB_Backpack_US_Baz",
	"LIB_Backpack_US_Mine",

	"B_LIB_UK_HSack",
	"B_LIB_UK_HSack_Cape",
	"B_LIB_UK_HSack_Tea",
	"B_LIB_UK_HSack_Blanco",
	"B_LIB_UK_HSack_Blanco_Cape",
	"B_LIB_UK_HSack_Blanco_Tea",
	"B_LIB_UK_HSack_Medic",
	"B_LIB_UK_HSack_Blanco_Medic",
	"B_LIB_UK_HSack_AT",
	"B_LIB_UK_HSack_Blanco_AT",
	"B_LIB_SD_UK_Army_LMG",
	"B_LIB_SD_UK_Army_AR",
	"B_LIB_SD_UK_Army_LMG_Blanco",
	"B_LIB_SD_UK_Army_AR_Blanco",

	"fow_b_uk_bergenpack",
	"fow_b_uk_p37",
	"fow_b_uk_p37_blanco",
	"fow_b_uk_p37_blanco_shovel",
	"fow_b_uk_p37_radio",
	"fow_b_uk_p37_radio_blanco",
	"fow_b_uk_p37_shovel",
	"fow_b_uk_piat",
	"fow_b_uk_vickers_support",
	"fow_b_uk_vickers_weapon",
	"fow_b_us_bandoleer",
	"fow_b_us_m1928",
	"fow_b_us_m1944",
	"fow_b_us_m1944_ropes",
	"fow_b_us_m2_fueltank",
	"fow_b_us_m2_mortar_adv_weapon",
	"fow_b_us_m2_mortar_support",
	"fow_b_us_m2_mortar_weapon",
	"fow_b_us_radio",
	"fow_b_us_radio_scr",
	"fow_b_us_rocket_bag",
	"fow_b_usa_m1919_support",
	"fow_b_usa_m1919_weapon",
	"fow_b_usmc_m1928",
	"fow_b_usmc_m1928_02"
];

_availableItems = [
	"ItemMap",               //Required for many Map Click mission functions.
	"FirstAidKit",           //Required for BTC Revives
	//"ToolKit",             //Does nothing in IFA3, use LIB_ToolKit instead
	"MineDetector",
	"LIB_ToolKit",
	"Medikit",
	"ItemRadio",
	"ItemCompass",
	"ItemGPS",
	"ItemWatch",
	//NVGs
	"LIB_Headwrap",
	"LIB_Headwrap_gloves",
	"LIB_Mohawk",
	"LIB_GER_Gloves2",
	"LIB_GER_Gloves3",
	"LIB_GER_Gloves4",
	"LIB_GER_Gloves5",//<-US Airborne
	"LIB_GER_Headset",
	"fow_i_nvg_US_A4Wool_Beige",
	"fow_i_nvg_US_A4Wool_Blue",
	"fow_i_nvg_US_A4Wool_Green",
	"fow_i_nvg_US_scr",
	//Facewear
	"G_LIB_Dust_Goggles",
	"G_LIB_Headwrap",
	"G_LIB_Scarf2_B",
	"G_LIB_Scarf2_G",
	"fow_g_gloves1",
	"fow_g_gloves3",
	"fow_g_gloves4",
	"fow_g_gloves5",
	"fow_g_gloves6",
	"fow_g_glasses4",

	//Uniforms
	"U_LIB_US_AB_Uniform_M42",
	"U_LIB_US_AB_Uniform_M42_506",
	"U_LIB_US_AB_Uniform_M42_corporal",
	"U_LIB_US_AB_Uniform_M42_FC",
	"U_LIB_US_AB_Uniform_M42_Gas",
	"U_LIB_US_AB_Uniform_M42_Medic",
	"U_LIB_US_AB_Uniform_M42_NCO",
	"U_LIB_US_AB_Uniform_M42_W",
	"U_LIB_US_AB_Uniform_M43",
	"U_LIB_US_AB_Uniform_M43_corporal",
	"U_LIB_US_AB_Uniform_M43_FC",
	"U_LIB_US_AB_Uniform_M43_Flag",
	"U_LIB_US_AB_Uniform_M43_Medic",
	"U_LIB_US_AB_Uniform_M43_Medic_82AB",
	"U_LIB_US_AB_Uniform_M43_NCO",
	"U_LIB_US_AB_Uniform_M43_W",
	"U_LIB_US_Bomber_Crew",
	"U_LIB_US_Bomber_Pilot",
	"U_LIB_US_Cap",
	"U_LIB_US_Cap_w",
	"U_LIB_US_Corp",
	"U_LIB_US_Corp_w",
	"U_LIB_US_Eng",
	"U_LIB_US_Eng_w",
	"U_LIB_US_Med",
	"U_LIB_US_Med_w",
	"U_LIB_US_NAC_Med",
	"U_LIB_US_NAC_Uniform",
	"U_LIB_US_NAC_Uniform_2",
	"U_LIB_US_Off",
	"U_LIB_US_Off_w",
	"U_LIB_US_Pilot",
	"U_LIB_US_Pilot_2",
	"U_LIB_US_Private",
	"U_LIB_US_Private_1st",
	"U_LIB_US_Private_1st_w",
	"U_LIB_US_Private_w",
	"U_LIB_US_Rangers_Corp",
	"U_LIB_US_Rangers_Eng",
	"U_LIB_US_Rangers_Med",
	"U_LIB_US_Rangers_Private_1st",
	"U_LIB_US_Rangers_Sergant",
	"U_LIB_US_Rangers_Uniform",
	"U_LIB_US_Sergant",
	"U_LIB_US_Sergant_w",
	"U_LIB_US_Snipe",
	"U_LIB_US_Snipe_w",
	"U_LIB_US_Tank_Crew",
	"U_LIB_US_Tank_Crew2",

	"V_LIB_UK_P37_Rifleman",
	"V_LIB_UK_P37_Gasmask",
	"V_LIB_UK_P37_Sten",
	"V_LIB_UK_P37_Holster",
	"V_LIB_UK_P37_Heavy",
	"V_LIB_UK_P37_Officer",
	"V_LIB_UK_P37_Crew",
	"V_LIB_UK_P37_Rifleman_Blanco",
	"V_LIB_UK_P37_Gasmask_Blanco",
	"V_LIB_UK_P37_Sten_Blanco",
	"V_LIB_UK_P37_Holster_Blanco",
	"V_LIB_UK_P37_Heavy_Blanco",
	"V_LIB_UK_P37_Officer_Blanco",

	"U_LIB_UK_P37",
	"U_LIB_UK_P37Jerkins",
	"U_LIB_UK_P37_LanceCorporal",
	"U_LIB_UK_P37Jerkins_LanceCorporal",
	"U_LIB_UK_P37_Corporal",
	"U_LIB_UK_P37Jerkins_Corporal",
	"U_LIB_UK_P37_Sergeant",
	"U_LIB_UK_P37Jerkins_Sergeant",
	"U_LIB_UK_KhakiDrills",

	"fow_u_aus_m37_01_private",
	"fow_u_aus_m37_02_private",
	"fow_u_aus_m37_03_private",
	"fow_u_uk_bd40_01_corporal",
	"fow_u_uk_bd40_01_lance_corporal",
	"fow_u_uk_bd40_01_lieutenant",
	"fow_u_uk_bd40_01_private",
	"fow_u_uk_bd40_01_sergeant",
	"fow_u_uk_bd40_bp_01_corporal",
	"fow_u_uk_bd40_bp_01_lance_corporal",
	"fow_u_uk_bd40_bp_01_lieutenant",
	"fow_u_uk_bd40_bp_01_private",
	"fow_u_uk_bd40_bp_01_sergeant",
	"fow_u_uk_bd40_can_01_corporal",
	"fow_u_uk_bd40_can_01_lance_corporal",
	"fow_u_uk_bd40_can_01_lieutenant",
	"fow_u_uk_bd40_can_01_private",
	"fow_u_uk_bd40_can_01_sergeant",
	"fow_u_uk_bd40_can_02_corporal",
	"fow_u_uk_bd40_can_02_lance_corporal",
	"fow_u_uk_bd40_can_02_lieutenant",
	"fow_u_uk_bd40_can_02_private",
	"fow_u_uk_bd40_can_02_sergeant",
	"fow_u_uk_bd40_commando_01_private",
	"fow_u_uk_bd40_corporal",
	"fow_u_uk_bd40_kieffer_01",
	"fow_u_uk_bd40_kieffer_02",
	"fow_u_uk_bd40_lance_corporal",
	"fow_u_uk_bd40_lieutenant",
	"fow_u_uk_bd40_nor_01_commando_corporal",
	"fow_u_uk_bd40_nor_01_commando_lance_corporal",
	"fow_u_uk_bd40_nor_01_commando_lieutenant",
	"fow_u_uk_bd40_nor_01_commando_private",
	"fow_u_uk_bd40_nor_01_commando_sergeant",
	"fow_u_uk_bd40_nor_02_commando_private",
	"fow_u_uk_bd40_pib_01_corporal",
	"fow_u_uk_bd40_pib_01_lance_corporal",
	"fow_u_uk_bd40_pib_01_lieutenant",
	"fow_u_uk_bd40_pib_01_private",
	"fow_u_uk_bd40_pib_01_sergeant",
	"fow_u_uk_bd40_pol_01_commando_corporal",
	"fow_u_uk_bd40_pol_01_commando_lance_corporal",
	"fow_u_uk_bd40_pol_01_commando_lieutenant",
	"fow_u_uk_bd40_pol_01_commando_private",
	"fow_u_uk_bd40_pol_01_commando_sergeant",
	"fow_u_uk_bd40_pol_02_commando_private",
	"fow_u_uk_bd40_private",
	"fow_u_uk_bd40_seac_01_corporal",
	"fow_u_uk_bd40_seac_01_lance_corporal",
	"fow_u_uk_bd40_seac_01_lieutenant",
	"fow_u_uk_bd40_seac_01_private",
	"fow_u_uk_bd40_seac_01_sergeant",
	"fow_u_uk_bd40_seac_02_corporal",
	"fow_u_uk_bd40_seac_02_lance_corporal",
	"fow_u_uk_bd40_seac_02_lieutenant",
	"fow_u_uk_bd40_seac_02_private",
	"fow_u_uk_bd40_seac_02_sergeant",
	"fow_u_uk_bd40_sergeant",
	"fow_u_uk_parasmock",
	"fow_u_uk_pol_parasmock",
	"fow_u_us_hbt_01_private",
	"fow_u_us_hbt_02_private",
	"fow_u_us_m37_01_private",
	"fow_u_us_m37_02_private",
	"fow_u_us_m41_01_private",
	"fow_u_us_m42_ab_01_101_corporal",
	"fow_u_us_m42_ab_01_101_flag_corporal",
	"fow_u_us_m42_ab_01_101_flag_private",
	"fow_u_us_m42_ab_01_101_flag_sergeant",
	"fow_u_us_m42_ab_01_101_flag_staffsergeant",
	"fow_u_us_m42_ab_01_101_private",
	"fow_u_us_m42_ab_01_101_sergeant",
	"fow_u_us_m42_ab_01_101_staffsergeant",
	"fow_u_us_m42_ab_01_82_corporal",
	"fow_u_us_m42_ab_01_82_flag_corporal",
	"fow_u_us_m42_ab_01_82_flag_private",
	"fow_u_us_m42_ab_01_82_flag_sergeant",
	"fow_u_us_m42_ab_01_82_flag_staffsergeant",
	"fow_u_us_m42_ab_01_82_private",
	"fow_u_us_m42_ab_01_82_sergeant",
	"fow_u_us_m42_ab_01_82_staffsergeant",
	"fow_u_us_m42_ab_01_corporal",
	"fow_u_us_m42_ab_01_private",
	"fow_u_us_m42_ab_01_sergeant",
	"fow_u_us_m42_ab_01_staffsergeant",
	"fow_u_us_pilot_01",
	"fow_u_us_pilot_02",
	"fow_u_usmc_p41_01_private",
	"fow_u_usmc_p42_01_camo01_1_private",
	"fow_u_usmc_p42_01_camo01_2_private",
	"fow_u_usmc_p42_01_camo01_3_private",
	"fow_u_usmc_p42_01_camo02_1_private",
	"fow_u_usmc_p42_01_camo02_2_private",
	"fow_u_usmc_p42_01_camo02_3_private",

	//Headgear / Masks
	"H_LIB_US_AB_Helmet",
	"H_LIB_US_AB_Helmet_2",
	"H_LIB_US_AB_Helmet_3",
	"H_LIB_US_AB_Helmet_4",
	"H_LIB_US_AB_Helmet_5",
	"H_LIB_US_AB_Helmet_Clear_1",
	"H_LIB_US_AB_Helmet_Clear_2",
	"H_LIB_US_AB_Helmet_Clear_3",
	"H_LIB_US_AB_Helmet_CO_1",
	"H_LIB_US_AB_Helmet_CO_2",
	"H_LIB_US_AB_Helmet_Jump_1",
	"H_LIB_US_AB_Helmet_Jump_2",
	"H_LIB_US_AB_Helmet_Medic_1",
	"H_LIB_US_AB_Helmet_NCO_1",
	"H_LIB_US_AB_Helmet_NCO_2",
	"H_LIB_US_AB_Helmet_Plain_1",
	"H_LIB_US_AB_Helmet_Plain_2",
	"H_LIB_US_AB_Helmet_Plain_3",
	"H_LIB_US_Helmet",
	"H_LIB_US_Helmet_Cap",
	"H_LIB_US_Helmet_Cap_w",
	"H_LIB_US_Helmet_CO",
	"H_LIB_US_Helmet_Cover_w",
	"H_LIB_US_Helmet_First_lieutenant",
	"H_LIB_US_Helmet_First_lieutenant_w",
	"H_LIB_US_Helmet_Med",
	"H_LIB_US_Helmet_Med_ns",
	"H_LIB_US_Helmet_Med_os",
	"H_LIB_US_Helmet_Med_w",
	"H_LIB_US_Helmet_NCO",
	"H_LIB_US_Helmet_Net",
	"H_LIB_US_Helmet_Net_ns",
	"H_LIB_US_Helmet_Net_os",
	"H_LIB_US_Helmet_Net_w",
	"H_LIB_US_Helmet_ns",
	"H_LIB_US_Helmet_os",
	"H_LIB_US_Helmet_Pilot",
	"H_LIB_US_Helmet_Pilot_Glasses_Down",
	"H_LIB_US_Helmet_Pilot_Glasses_Up",
	"H_LIB_US_Helmet_Pilot_Respirator",
	"H_LIB_US_Helmet_Pilot_Respirator_Glasses_Down",
	"H_LIB_US_Helmet_Pilot_Respirator_Glasses_Up",
	"H_LIB_US_Helmet_Second_lieutenant",
	"H_LIB_US_Helmet_Second_lieutenant_w",
	"H_LIB_US_Helmet_Tank",
	"H_LIB_US_Helmet_w",
	"H_LIB_US_Pilot_Cap",
	"H_LIB_US_Pilot_Cap_Khaki",
	"H_LIB_US_Rangers_Helmet",
	"H_LIB_US_Rangers_Helmet_Cap",
	"H_LIB_US_Rangers_Helmet_First_lieutenant",
	"H_LIB_US_Rangers_Helmet_NCO",
	"H_LIB_US_Rangers_Helmet_ns",
	"H_LIB_US_Rangers_Helmet_os",
	"H_LIB_US_Rangers_Helmet_Second_lieutenant",

	"H_LIB_UK_Para_Helmet_Mk2_Net",
	"H_LIB_UK_Para_Helmet_Mk2_Camo",
	"H_LIB_UK_Para_Beret",
	"H_LIB_UK_Helmet_Mk2_Net",
	"H_LIB_UK_Helmet_Mk2_Camo",
	"H_LIB_UK_Helmet_Mk2_Beachgroup",
	"H_LIB_UK_Helmet_Mk2_FAK_Camo",
	"H_LIB_UK_Helmet_Mk2_Cover",
	"H_LIB_UK_Helmet_Mk3",
	"H_LIB_UK_Helmet_Mk3_Net",
	"H_LIB_UK_Helmet_Mk3_Camo",
	"H_LIB_UK_Pilot_Cap",
	"H_LIB_UK_Beret",
	"H_LIB_UK_Beret_Tankist",
	"H_LIB_UK_Beret_Headset",
	"H_LIB_UK_Beret_Commando",
	"H_LIB_UK_Beret_Commando_Kieffer",
	"H_LIB_UK_Balmoral",
	"H_LIB_UK_Helmet_Mk2_Desert",
	"H_LIB_UK_Helmet_Mk2_Desert_Bowed",
	"H_LIB_UK_Helmet_Mk2",
	"H_LIB_UK_Helmet_Mk2_FAK",
	"H_LIB_UK_Helmet_Mk2_Bowed",
	"H_LIB_UK_Para_Helmet_Mk2",
	"H_LIB_UK_Helmet_Mk2_Cover_w",
	"H_LIB_UK_Helmet_Mk2_w",
	"H_LIB_UK_Helmet_Mk2_Net_w",
	"H_LIB_UK_Helmet_Mk3_w",
	"H_LIB_UK_Para_Helmet_Mk2_w",
	"H_LIB_UK_Para_Helmet_Mk2_Net_w",

	"fow_h_uk_beret_commando",
	"fow_h_uk_beret_commando_kieffer",
	"fow_h_uk_beret_commando_nor",
	"fow_h_uk_beret_commando_pol",
	"fow_h_uk_beret_para",
	"fow_h_uk_beret_para_2",
	"fow_h_uk_beret_para_pol",
	"fow_h_uk_beret_rha",
	"fow_h_uk_beret_rha_headset",
	"fow_h_uk_beret_royalmarines",
	"fow_h_uk_beret_rtr",
	"fow_h_uk_beret_rtr_headset",
	"fow_h_uk_beret_sas",
	"fow_h_uk_beret_sas_2",
	"fow_h_uk_bp_beret",
	"fow_h_uk_jungle_hat_01",
	"fow_h_uk_jungle_hat_02",
	"fow_h_uk_jungle_hat_03",
	"fow_h_uk_mk2",
	"fow_h_uk_mk2_net",
	"fow_h_uk_mk2_net_camo",
	"fow_h_uk_mk2_net_foliage",
	"fow_h_uk_mk2_para",
	"fow_h_uk_mk2_para_camo",
	"fow_h_uk_mk2_para_foliage",
	"fow_h_uk_mk3",
	"fow_h_uk_mk3_net_camo",
	"fow_h_uk_pib_beret",
	"fow_h_uk_pol_mk2_para",
	"fow_h_uk_pol_mk2_para_camo",
	"fow_h_uk_woolen_hat",
	"fow_h_uk_woolen_hat02",
	"fow_h_us_daisy_mae_01",
	"fow_h_us_daisy_mae_02",
	"fow_h_us_daisy_mae_03",
	"fow_h_us_flight_helmet",
	"fow_h_us_m1",
	"fow_h_us_m1_closed",
	"fow_h_us_m1_folded",
	"fow_h_us_m1_medic",
	"fow_h_us_m1_nco",
	"fow_h_us_m1_nco_closed",
	"fow_h_us_m1_nco_folded",
	"fow_h_us_m1_net",
	"fow_h_us_m1_officer",
	"fow_h_us_m1_officer_closed",
	"fow_h_us_m1_officer_folded",
	"fow_h_us_m2",
	"fow_h_us_m2_ace",
	"fow_h_us_m2_camo",
	"fow_h_us_m2_camo_ace",
	"fow_h_us_m2_camo_clover",
	"fow_h_us_m2_camo_diamond",
	"fow_h_us_m2_camo_heart",
	"fow_h_us_m2_camo_open",
	"fow_h_us_m2_camo_open_ace",
	"fow_h_us_m2_camo_open_clover",
	"fow_h_us_m2_camo_open_diamond",
	"fow_h_us_m2_camo_open_heart",
	"fow_h_us_m2_clover",
	"fow_h_us_m2_diamond",
	"fow_h_us_m2_fak",
	"fow_h_us_m2_fak_camo",
	"fow_h_us_m2_fak_net",
	"fow_h_us_m2_heart",
	"fow_h_us_m2_net",
	"fow_h_us_m2_net_ace",
	"fow_h_us_m2_net_clover",
	"fow_h_us_m2_net_diamond",
	"fow_h_us_m2_net_heart",
	"fow_h_usmc_m1",
	"fow_h_usmc_m1_camo_01",
	"fow_h_usmc_m1_camo_02",

	//Vests
	"V_LIB_US_AB_Vest_45",
	"V_LIB_US_AB_Vest_Asst_MG",
	"V_LIB_US_AB_Vest_Bar",
	"V_LIB_US_AB_Vest_Carbine",
	"V_LIB_US_AB_Vest_Carbine_eng",
	"V_LIB_US_AB_Vest_Carbine_nco",
	"V_LIB_US_AB_Vest_Carbine_nco_Radio",
	"V_LIB_US_AB_Vest_Garand",
	"V_LIB_US_AB_Vest_Grenadier",
	"V_LIB_US_AB_Vest_M1919",
	"V_LIB_US_AB_Vest_Thompson",
	"V_LIB_US_AB_Vest_Thompson_nco",
	"V_LIB_US_AB_Vest_Thompson_nco_Radio",
	"V_LIB_US_Assault_Vest",
	"V_LIB_US_Assault_Vest_dday",
	"V_LIB_US_Assault_Vest_Light",
	"V_LIB_US_Assault_Vest_Thompson",
	"V_LIB_US_LifeVest",
	"V_LIB_US_Vest_45",
	"V_LIB_US_Vest_Asst_MG",
	"V_LIB_US_Vest_Bar",
	"V_LIB_US_Vest_Carbine",
	"V_LIB_US_Vest_Carbine_eng",
	"V_LIB_US_Vest_Carbine_nco",
	"V_LIB_US_Vest_Carbine_nco_Radio",
	"V_LIB_US_Vest_Garand",
	"V_LIB_US_Vest_Grenadier",
	"V_LIB_US_Vest_M1919",
	"V_LIB_US_Vest_Medic",
	"V_LIB_US_Vest_Medic2",
	"V_LIB_US_Vest_Thompson",
	"V_LIB_US_Vest_Thompson_nco",
	"V_LIB_US_Vest_Thompson_nco_Radio",

	"V_LIB_UK_P37_Rifleman",
	"V_LIB_UK_P37_Gasmask",
	"V_LIB_UK_P37_Sten",
	"V_LIB_UK_P37_Holster",
	"V_LIB_UK_P37_Heavy",
	"V_LIB_UK_P37_Officer",
	"V_LIB_UK_P37_Crew",
	"V_LIB_UK_P37_Rifleman_Blanco",
	"V_LIB_UK_P37_Gasmask_Blanco",
	"V_LIB_UK_P37_Sten_Blanco",
	"V_LIB_UK_P37_Holster_Blanco",
	"V_LIB_UK_P37_Heavy_Blanco",
	"V_LIB_UK_P37_Officer_Blanco",

	"fow_v_uk_bren",
	"fow_v_uk_bren_green",
	"fow_v_uk_officer",
	"fow_v_uk_officer_green",
	"fow_v_uk_para_bren",
	"fow_v_uk_para_bren_green",
	"fow_v_uk_para_sten",
	"fow_v_uk_para_sten_green",
	"fow_v_uk_sten",
	"fow_v_uk_sten_green",
	"fow_v_us_45",
	"fow_v_us_ab_45",
	"fow_v_us_ab_asst_mg",
	"fow_v_us_ab_bar",
	"fow_v_us_ab_carbine",
	"fow_v_us_ab_carbine_eng",
	"fow_v_us_ab_carbine_nco",
	"fow_v_us_ab_carbine_nco_scr",
	"fow_v_us_ab_garand",
	"fow_v_us_ab_garand_bandoleer",
	"fow_v_us_ab_grenade",
	"fow_v_us_ab_thompson",
	"fow_v_us_ab_thompson_nco",
	"fow_v_us_ab_thompson_nco_scr",
	"fow_v_us_asst_mg",
	"fow_v_us_bar",
	"fow_v_us_carbine",
	"fow_v_us_carbine_eng",
	"fow_v_us_carbine_nco",
	"fow_v_us_carbine_nco_scr",
	"fow_v_us_garand",
	"fow_v_us_garand_bandoleer",
	"fow_v_us_grenade",
	"fow_v_us_medic",
	"fow_v_us_thompson",
	"fow_v_us_thompson_nco",
	"fow_v_us_thompson_nco_scr",
	"fow_v_usmc_45",
	"fow_v_usmc_bar",
	"fow_v_usmc_carbine",
	"fow_v_usmc_garand",
	"fow_v_usmc_thompson",
	"fow_v_usmc_thompson_nco",

	//Weapon Accessories
	"LIB_ACC_K98_Bayo",
	"LIB_M1918A2_BAR_Bipod",
	"LIB_ACC_GW_SB_Empty",
	"fow_w_acc_M1897_bayo",
	"fow_w_acc_m1918a2_bipod",
	"fow_w_acc_m1918a2_handle",
	"fow_w_acc_m1_bayo",
	"fow_w_acc_fg42_bayo",
	"fow_w_acc_no4_bayo",
	"fow_w_acc_type30_bayo"
];

_availableMagazines = [
	"SmokeShellGreen",
	"SmokeShellBlue",
	"SmokeShellOrange",
	"SmokeShellPurple",
	"SmokeShellRed",
	"SmokeShell",

	"LIB_US_M18",
	"LIB_US_M18_Red",
	"LIB_US_M18_Green",
	"LIB_US_M18_Yellow",
	"LIB_1Rnd_flare_white",
	"LIB_1Rnd_flare_red",
	"LIB_1Rnd_flare_green",
	"LIB_1Rnd_flare_yellow",
	"LIB_100Rnd_792x57",
	"LIB_10Rnd_792x57_sS",
	"LIB_10Rnd_792x57_SMK",
	"LIB_10Rnd_792x57_T",
	"LIB_10Rnd_792x57_T2",
	"LIB_30rnd_792x33_t",
	"LIB_32rnd_9x19_t",
	"LIB_US_TNT_4pound_mag",
	"LIB_50Rnd_792x57",
	"LIB_50Rnd_792x57_sS",
	"LIB_50Rnd_792x57_SMK",
	"LIB_5Rnd_792x57_sS",
	"LIB_5Rnd_792x57_SMK",
	"LIB_5Rnd_792x57_t",
	"LIB_75Rnd_792x57",
	"LIB_1Rnd_RPzB",
	"LIB_10Rnd_9x19_M1896",
	"LIB_Ladung_Big_MINE_mag",
	"LIB_Ladung_Small_MINE_mag",
	"LIB_1Rnd_Faustpatrone",
	"LIB_20Rnd_792x57",
	"LIB_10Rnd_792x57_clip",
	"LIB_10Rnd_792x57",
	"LIB_1rnd_81mmHE_GRWR34",
	"LIB_5Rnd_792x57",
	"LIB_Shg24",
	"LIB_Shg24x7",
	"LIB_M39",
	"LIB_32Rnd_9x19",
	"LIB_30Rnd_792x33",
	"LIB_NB39",
	"LIB_8Rnd_9x19_P08",
	"LIB_8Rnd_9x19",
	"LIB_1Rnd_PzFaust_30m",
	"LIB_1Rnd_PzFaust_60m",
	"LIB_PMD6_MINE_mag",
	"LIB_pomzec_MINE_mag",
	"LIB_Pwm",
	"LIB_Rg42",
	"LIB_Rpg6",
	"LIB_shumine_42_MINE_mag",
	"LIB_SMI_35_MINE_mag",
	"LIB_SMI_35_1_MINE_mag",
	"LIB_RDG",
	"LIB_STMI_MINE_mag",
	"LIB_TM44_MINE_mag",
	"LIB_TMI_42_MINE_mag",
	"LIB_7Rnd_9x19",

	"LIB_30Rnd_770x56",//BREN
	"LIB_20Rnd_762x63",//BAR
	"LIB_50Rnd_762x63",//M1919

	"fow_1Rnd_pzfaust_100",
	"fow_10nd_792x57",
	"fow_20Rnd_792x57",
	"fow_1Rnd_pzfaust_30",
	"fow_1Rnd_pzfaust_30_klein",
	"fow_30Rnd_792x33",
	"fow_30Rnd_77x58",
	"fow_32Rnd_8x22",
	"fow_32Rnd_9x19_mp40",
	"fow_32Rnd_9x19_sten",
	"fow_50Rnd_792x57",
	"fow_5Rnd_792x57",
	"fow_5Rnd_77x58",
	"fow_1Rnd_pzfaust_60",
	"fow_7Rnd_765x17",
	"fow_8Rnd_765x17",
	"fow_8Rnd_8x22",
	"fow_13Rnd_9x19",
	"fow_8Rnd_9x19",
	"fow_e_m24K_spli",
	"fow_e_m24_at",
	"fow_e_m24_spli",
	"fow_e_m24",
	"fow_e_m24K",
	"fow_e_nb39b",
	"fow_e_tnt_halfpound",
	"fow_e_tnt_onepound_mag",
	"fow_e_tnt_twohalfpound_mag",
	"fow_e_tnt_twopound_mag",
	"fow_1Rnd_type2_40",
	"fow_e_type97",
	"fow_e_type99",
	"fow_e_type99_at"
];

_availableWeapons = [
	"LIB_Binocular_US",
	"LIB_Binocular_UK",
	"LIB_FLARE_PISTOL",
	"LIB_M1896",
	"LIB_Faustpatrone",
	"LIB_FG42G",
	"LIB_G3340",
	"LIB_G41",
	"LIB_G43",
	"LIB_GrWr34_Barrel",
	"LIB_GrWr34_Tripod",
	"LIB_K98",
	"LIB_K98_Late",
	"LIB_K98ZF39",
	"LIB_MG42",
	"LIB_MG34",
	"LIB_MG34_PT",
	"LIB_MP38",
	"LIB_MP40",
	"LIB_MP44",
	"LIB_P08",
	"LIB_P38",
	"LIB_PzFaust_30m",
	"LIB_PzFaust_60m",
	"LIB_RPzB",
	"LIB_RPzB_w",
	"LIB_WaltherPPK",

	"fow_i_dienstglas",
	"fow_w_fg42",
	"fow_w_g43",
	"fow_w_k98",
	"fow_w_k98_scoped",
	"fow_w_mg34",
	"fow_w_mg42",
	"fow_w_mp40",
	"fow_w_p08",
	"fow_w_p640p",
	"fow_w_stg44",
	"fow_w_ppk",
	"fow_w_type10",
	"fow_w_type100",
	"fow_w_type14",
	"fow_w_type99",
	"fow_w_type99_lmg",
	"fow_w_type99_sniper",
	"fow_w_pzfaust_100",
	"fow_w_pzfaust_30",
	"fow_w_pzfaust_30_klein",
	"fow_w_pzfaust_60",
	"fow_w_webley",
	"fow_w_welrod_mkii",
	"fow_w_piat"
];

[_availableBackpacks,_availableItems,_availableMagazines,_availableWeapons]
};


if (INS_op_faction in [22,23]) exitWith
{ // Unsung contents only
_availableWeapons = [
	"uns_m127a1_flare",
	"uns_mkvFlarePistol",
	"uns_MX991_w",
	"uns_p64",
	"uns_nagant_m1895",
	"uns_makarov",
	"uns_Tt33",
	"uns_pm63f",
	"uns_sa61f",
	"uns_thompsonvc",
	"uns_type100",
	"uns_mat49",
	"uns_PPS43f",
	"uns_PPS43",
	"uns_PPS52",
	"uns_k50m",
	"uns_k50mdrum",
	"uns_ppsh41",
	"uns_type50",
	"uns_mp40",
	"uns_STG_44",
	"uns_baikal_sawnoff",
	"uns_baikal",
	"uns_svt",
	"uns_sks",
	"uns_sksbayo",
	"uns_kar98k",
	"uns_kar98k_bayo",
	"uns_kar98ks",
	"uns_mosin",
	"uns_mosins",
	"uns_type99",
	"uns_type99_bayo",
	"uns_type99_gl",
	"uns_type99_sniper",
	"uns_type99_sniper_bayo",
	"uns_mas36",
	"uns_mas36bayo",
	"uns_mas36_gl",
	"uns_mas36short",
	"uns_mas36short_bayo",
	"uns_mas36short_gl",
	"uns_mas4956",
	"uns_mas4956s",
	"uns_mas4956sbayo",
	"uns_mas4956bayo",
	"uns_mas4956_gl",
	"uns_type56",
	"uns_type56_bayo",
	"uns_ak47",
	"uns_ak47_bayo",
	"uns_aks47f",
	"uns_aks47",
	"uns_aks47_bayo",
	"uns_ak47_49",
	"uns_ak47_49_bayo",
	"uns_ak47_52",
	"uns_ak47_52_bayo",
	"uns_akm",
	"uns_akm_bayo",
	"uns_akms",
	"uns_akms_bayo",
	"uns_akmsf","uns_rpd",
	"uns_RPDsupport",
	"uns_DP28",
	"uns_MG42",
	"uns_mg42_bakelite",
	"uns_MG42support",
	"uns_B40",
	"uns_sa7b", //SA-7b Strela-2M anti air
	"uns_sa7",  // SA-7 Strela
	"uns_rpg2",
	"uns_rpg7"
];

_availableMagazines = [
    "uns_sa7bmag", // Rocket SA-7b Strela-2M
    "uns_sa7mag",  // Rocket SA-7 Strela
	"uns_12gaugemag_2",
	"uns_nagant_m1895mag",
	"uns_6Rnd_czak",
	"uns_makarovmag",
	"uns_tokarevmag",
	"uns_20Rnd_APS",
	"uns_25Rnd_pm_pa",
	"uns_20Rnd_sa61_pa",
	"uns_20Rnd_sa61",
	"uns_thompsonmag_20",
	"uns_thompsonmag_20_T",
	"uns_thompsonmag_20_NT",
	"uns_25Rnd_pm",
	"uns_mat49mag_T",
	"uns_mat49mag_NT",
	"uns_mat49mag",
	"uns_mat49_20_mag",
	"uns_type100mag",
	"uns_type100_NT",
	"uns_type100_T",
	"uns_k50mag",
	"uns_k50mag_NT",
	"uns_k50mag_T",
	"uns_ppshmag",
	"uns_ppshmag_T",
	"uns_ppshmag_NT",
	"uns_mp40mag",
	"uns_30Rnd_kurtz_stg",
	"uns_ak47mag",
	"uns_ak47mag_T",
	"uns_ak47mag_NT",
	"uns_svtmag",
	"uns_svtmag_T",
	"uns_sksmag",
	"uns_sksmag_T",
	"uns_sksmag_NT",
	"uns_kar98kmag",
	"uns_kar98kmag_T",
	"uns_mosinmag",
	"uns_mosinmag_T",
	"uns_type99mag",
	"uns_type99mag_T",
	"uns_mas36mag",
	"uns_mas36mag_T",
	"uns_mas4956mag",
	"uns_mas4956mag_T",
	"uns_rpdmag",
	"uns_50Rnd_792x57_Mg42",
	"uns_250Rnd_792x57_Mg42",
	"Uns_1Rnd_30mm_FRAG",
	"Uns_1Rnd_22mm_FRAG",
	"Uns_1Rnd_22mm_AT",
	"Uns_1Rnd_22mm_HEAT",
	"uns_1Rnd_22mm_lume",
	"Uns_1Rnd_22mm_smoke",
	"Uns_1Rnd_22mm_WP",
	"uns_1Rnd_M127_mag",
	"uns_B40grenade",
	"uns_rpg2grenade",
	"uns_rpg7grenade",
	"uns_molotov_mag",
	"uns_f1gren",
	"uns_rg42gren",
	"uns_rgd33gren",
	"uns_t67gren",
	"uns_rdg2",
	"uns_40mm_mkv_White",
	"uns_40mm_mkv_Red",
	"uns_40mm_mkv_Yellow",
	"uns_40mm_mkv_Green",
	"uns_1Rnd_Smoke_MKV",
	"uns_1Rnd_SmokeGreen_MKV",
	"uns_1Rnd_SmokeRed_MKV",
	"uns_1Rnd_SmokeYellow_MKV",
	"uns_leaflet1",
	"uns_leaflet2",
	"uns_leaflet3",
	"uns_leaflet6",
	"uns_leaflet13",
	"uns_leaflet16",
	"uns_item_dong",
	"uns_item_MPC",
	"uns_item_map1",
	"uns_item_map2",
	"uns_item_zippo",
	"uns_item_smokes",
	"uns_item_ashtray",
	"uns_item_messpass",
	"uns_item_P38",
	"uns_ItemFuelcan",
	"uns_ItemSiphon",
	"uns_knife",
	"uns_mine_cigs_mag",
	"uns_mine_beer_mag",
	"uns_mine_fkit_mag",
	"uns_mine_radio_mag",
	"uns_mine_guitar_mag",
	"uns_mine_fuel_mag",
	"uns_mine_ammo_mag",
	"uns_traps_punj1_mag",
	"uns_traps_punj2_mag",
	"uns_traps_punj4_mag",
	"uns_traps_punj5_mag",
	"uns_traps_nade_mag2",
	"uns_traps_nade_mag4",
	"uns_traps_nade_mag5",
	"uns_traps_nade_mag6",
	"uns_traps_arty_mag",
	"uns_traps_mine_mag",
	"uns_mine_AP_mag",
	"uns_mine_AT_mag",
	"uns_mine_AV_mag",
	"PipeBomb"
];

_availableItems = [
	"ItemCompass",
	"ItemMap",
	"ItemRadio",
	"ItemWatch",
	"Medikit",
	"FirstAidKit",
	"ToolKit",
	"Binocular",
	"UNS_ItemRadio_T_884",
	"uns_BA30",
	"UNS_TrapKit",
	"uns_b_type30",
	"uns_b_mas49",
	"uns_b_spike17",
	"b_kar_m1884",
	"uns_b_sks",
	"uns_b_6H3",
	"uns_b_spike",
	"uns_o_Akatihi4x",
	"uns_o_APXSOM",
	"uns_o_PSO1",
	"uns_o_PSO1_camo",
	"uns_o_zf41",
	"uns_o_PU",
	"uns_bp_DP28",
	"uns_bp_MG42",
	// uniforms
	"UNS_VC_S",//Viet Cong
	"UNS_VC_U",
	"UNS_VC_G",
	"UNS_VC_B",
	"UNS_VC_K",
	"UNS_NVA_G",//People's Army of Vietnam
	"UNS_NVA_K",
	"UNS_NVA_GS",
	"UNS_NVA_KS",
	"UNS_NVA_CC",
	"UNS_NVA_CP",
	"UNS_NVA_CK",
	"UNS_NVA_CG",
	"UNS_DCCR_G",//Đặc Công
	"UNS_DCCR_B",
	"UNS_DCCR_TGS",
	"UNS_DCCR_BBS",
	"UNS_DCCR_BTS",
	"UNS_DCCR_GTS",
	"UNS_DUCK_BDU",
	// vests
	"UNS_VC_K",
	"UNS_VC_A1",
	"UNS_VC_A2",
	"UNS_VC_A3",
	"UNS_VC_S1",
	"UNS_VC_S2",
	"UNS_VC_MG",
	"UNS_VC_SP",
	"UNS_VC_B1",
	"uns_vc_chestrig",
	"UNS_NVA_A1",
	"UNS_NVA_A2",
	"UNS_NVA_A3",
	"UNS_NVA_S1",
	"UNS_NVA_S2",
	"UNS_NVA_SP",
	"UNS_NVA_GR",
	"UNS_NVA_MG",
	"UNS_NVA_B1",
	"UNS_NVA_G1",
	"UNS_NVA_RTO",
	"UNS_NVA_RPG",
	"UNS_NVA_RPG2",
	"UNS_NVA_R1",
	"UNS_NVA_R3",
	"UNS_NVA_MED",
	"UNS_NVA_MED2",
	"UNS_NVA_RC",
	"UNS_VC_R1",
	"UNS_VC_R1_RPG",
	// headgear
	"UNS_Headband_VC",
	"UNS_Boonie_VC",
	"UNS_Boonie2_VC",
	"UNS_Boonie3_VC",
	"UNS_Boonie4_VC",
	"UNS_Boonie5_VC",
	"UNS_Conehat_VC",
	"uns_sas_booniehat_vc",
	"uns_sas_booniehat_vc_tan",
	"uns_vc_headband_blue",
	"UNS_Headband_BK",
	"UNS_Boonie_DK",
	"UNS_Boonie_DKF",
	"UNS_Headband_VC",
	"UNS_NVA_HG",
	"UNS_NVA_HK",
	"UNS_NVA_HGG",
	"UNS_NVA_HKG",
	"UNS_PAVN_HN",
	"UNS_PAVN_HC",
	"UNS_PAVN_HG",
	"UNS_NVA_CH",
	"UNS_NVA_CHG",
	"UNS_NVA_CHB",
	"UNS_NVA_CHBG",
	"UNS_NVA_PL",
	"UNS_NVA_PLC",
	"UNS_NVA_SSH40",
	"UNS_NVA_SSH60",
	//goggles
	"UNS_Scarf_BK_W",
	"UNS_Scarf_PL",
	"UNS_Scarf_GR",
	"UNS_Scarf_Red",
	"UNS_Scarf_Blue",
	"UNS_Band_H",
	"UNS_Goggles_NVA"
];

_availableBackpacks = [
	"UNS_TROP_R1",
	"UNS_TROP_R2",
	"UNS_TROP_R3",
	"UNS_NVA_RPG",
	"UNS_NVA_R1",
	"UNS_NVA_MED",
	"UNS_NVA_MED2",
	"UNS_NVA_RC",
	"UNS_VC_R1",
	"UNS_VC_R1_RPG",
	"uns_men_NVA_68_AS2_Bag",
	"uns_men_NVA_68_AS4_Bag",
	"uns_men_NVA_68_AS5_Bag",
	"uns_men_NVA_68_AS6_Bag",
	"uns_men_NVA_68_AS7_Bag",
	"uns_men_NVA_68_AS8_Bag",
	"uns_men_NVA_68_LMG_Bag",
	"uns_men_NVA_68_COM_Bag",
	"uns_men_NVA_68_HMG_Bag",
	"uns_men_NVA_68_MED_Bag",
	"uns_men_NVA_65_RF1_Bag",
	"uns_men_NVA_65_RF2_Bag",
	"uns_men_NVA_recon_65_nco_Bag",
	"uns_men_NVA_recon_65_MRK_Bag",
	"uns_men_VC_mp40_Bag",
	"uns_men_VC_m3a1_Bag",
	"uns_men_VC_dp28_Bag",
	"Uns_PK_High_NVA_Bag",
	"uns_pk_low_NVA_Bag",
	"uns_SPG9_NVA_Bag",
	"uns_Type36_NVA_Bag",
	"Uns_NVA_searchlight_Bag",
	"Uns_PK_High_VC_Bag",
	"uns_pk_low_VC_Bag",
	"uns_MG42_VC_Bag",
	"Uns_Dshk_High_VC_Bag",
	"Uns_Dshk_Low_VC_Bag",
	"uns_SPG9_VC_Bag",
	"uns_Type36_VC_Bag",
	"Uns_M1941_82mm_Mortar_VC_Bag",
	"uns_Tripod_Bag"
];

[_availableBackpacks,_availableItems,_availableMagazines,_availableWeapons]
};

_availableBackpacks = [
// Vanilla Backpacks
	"B_Parachute",
	"B_AssaultPack_dgtl",
	"B_FieldPack_ocamo",
	"B_FieldPack_ghex_F",
	"B_FieldPack_oli",
	"B_FieldPack_cbr",
	"B_FieldPack_ghex_OTMedic_F",
	"B_FieldPack_cbr_LAT",
	"B_FieldPack_blk",
	"B_TacticalPack_ocamo",

	//Contact
	"B_AssaultPack_rgr",
	//"B_Carryall_wdl_F",
	"B_FieldPack_green_F",
	"B_FieldPack_taiga_F",
	"B_FieldPack_taiga_RPG_AT_F",
	"B_AssaultPack_wdl_F",
	"B_AssaultPack_eaf_F",
	"B_RadioBag_01_digi_F",
	"B_RadioBag_01_eaf_F",
	"B_RadioBag_01_ghex_F",
	"B_RadioBag_01_hex_F",
	"B_RadioBag_01_oucamo_F",
		//CUP
		"CUP_B_AlicePack_Khaki"
];

_availableItems = [
// Vanilla items
	"G_Tactical_Clear",            //<-Required for Helmet Cam HUD
	"FirstAidKit",                 //Required for BTC Revives
	"Medikit",                     //Opfor Players are Medics by Class
	"ToolKit",                     //Opfor Players are Engineers by Trait
	"MineDetector",
	"ItemCompass",
	"ItemGPS",
	"ItemMap",
	"ItemWatch",
	"ItemRadio",

	//Optics
	"NVGoggles",
	"NVGoggles_OPFOR",
	"NVGoggles_INDEP",
	"NVGoggles_tna_F",
	"O_NVGoggles_grn_F",
	"O_NVGoggles_hex_F",
	"O_NVGoggles_urb_F",
	"O_NVGoggles_ghex_F",
	"G_Goggles_VR",
	"G_O_Diving",
	"G_I_Diving",
	"G_Lady_Blue",
	"G_Tactical_Black",
		//CUP
		"CUP_LRTV",
		"CUP_NVG_HMNVS",

	//Uniforms
	"U_I_OfficerUniform",
	"U_O_officer_noInsignia_hex_F",
	"U_O_PilotCoveralls",
	"U_I_CombatUniform",
	"U_I_CombatUniform_tshirt",
	"U_I_CombatUniform_shortsleeve",
	"U_I_Wetsuit",
	"U_IG_leader",
	"U_IG_Guerilla1_1",
	"U_IG_Guerilla2_1",
	"U_IG_Guerilla2_2",
	"U_IG_Guerilla2_3",
	"U_IG_Guerilla3_1",
	"U_IG_Guerilla3_2",
	"U_IG_Guerrilla_6_1",
	"U_BG_leader",
	"U_BG_Guerilla1_1",
	"U_BG_Guerilla1_2_F",
	"U_BG_Guerilla2_1",
	"U_BG_Guerilla2_2",
	"U_BG_Guerilla2_3",
	"U_BG_Guerilla3_1",
	"U_BG_Guerilla3_2",
	"U_BG_Guerrilla_6_1",
	"U_OG_leader",
	"U_OG_Guerilla1_",
	"U_OG_Guerilla2_1",
	"U_OG_Guerilla2_2",
	"U_OG_Guerilla2_3",
	"U_OG_Guerilla3_1",
	"U_OG_Guerilla3_2",
	"U_OG_Guerrilla_6_1",
	"U_I_G_resistanceLeader_F",
	"U_O_OfficerUniform_ocamo",
	"U_O_SpecopsUniform_ocamo",
	"U_O_SpecopsUniform_blk",
	"U_O_CombatUniform_ocamo",
	"U_O_CombatUniform_oucamo",
	"U_O_GhillieSuit",
	"U_O_Wetsuit",
	"U_O_T_Soldier_F",
	"U_O_T_Officer_F",
	"U_O_T_Sniper_F",
	"U_I_C_Soldier_Bandit_3_F",
	"U_I_C_Soldier_Para_2_F",
	"U_I_C_Soldier_Para_3_F",
	"U_I_C_Soldier_Para_4_F",
	"U_I_C_Soldier_Para_1_F",
	"U_I_C_Soldier_Camo_F",
	"U_I_E_Uniform_01_F",
	"U_I_E_Uniform_01_tanktop_F",
	"U_I_E_Uniform_01_shortsleeve_F",
	"U_I_E_Uniform_01_officer_F",
	"U_I_E_Uniform_01_sweater_F",
	"U_I_E_CBRN_Suit_01_EAF_F",
	"U_C_E_LooterJacket_01_F",
	"U_I_L_Uniform_01_tshirt_skull_F",
	"U_I_L_Uniform_01_tshirt_black_F",
	"U_I_L_Uniform_01_tshirt_sport_F",
	"U_I_L_Uniform_01_tshirt_olive_F",
	"U_I_CBRN_Suit_01_AAF_F",
	"U_O_R_Gorka_01_camo_F",
		//CUP
		"CUP_U_O_TK_Green",
		"CUP_U_O_RUS_EMR_2",

	//Helmets
	"H_HelmetIA",
	"H_HelmetIA_net",
	"H_HelmetIA_camo",
	"H_HelmetO_ocamo",
	"H_HelmetO_ghex_F",
	"H_Watchcap_camo",
	"H_HelmetLeaderO_ghex_F",
	"H_HelmetLeaderO_ocamo",
	"H_HelmetLeaderO_oucamo",
	"H_HelmetSpecO_ocamo",
	"H_HelmetSpecO_ghex_F",
	"H_HelmetSpecO_blk",
	"H_HelmetCrew_O",
	"H_HelmetCrew_O_ghex_F",
	"H_HelmetCrew_I",
	"H_Watchcap_cbr",
	"H_Watchcap_camo",
	"H_Watchcap_khk",
	"H_Booniehat_dgtl",
	"H_Cap_blk_Raven",
	"H_Cap_brn_SPECOPS",
	"H_PilotHelmetHeli_O",
	"H_PilotHelmetHeli_I",
	"H_Bandanna_gry",
	"H_Bandanna_blu",
	"H_Bandanna_cbr",
	"H_Bandanna_khk_hs",
	"H_Bandanna_khk",
	"H_Bandanna_sgg",
	"H_Bandanna_sand",
	//"H_HelmetO_ViperSP_ghex_F",

	"H_MilCap_eaf",
	"H_HelmetHBK_headset_F",
	"H_HelmetHBK_chops_F",
	"H_HelmetHBK_ear_F",
	"H_HelmetHBK_F",
	"H_HelmetAggressor_F",
	"H_HelmetAggressor_Cover_F",
	"H_HelmetAggressor_cover_taiga_F",
		//CUP
		"CUP_H_TK_Helmet",

	//HeadGear
	"H_Shemag_khk",
	"H_Shemag_tan",
	"H_Shemag_olive",
	"H_Shemag_olive_hs",
	"H_ShemagOpen_khk",
	"H_ShemagOpen_tan",
	"H_Bandanna_camo",
	"G_Balaclava_combat",
	"G_Balaclava_oli",
	"G_Balaclava_blk",
	"G_Bandanna_tan",
		//CUP
		"CUP_TK_NeckScarf",
		"CUP_H_RUS_6B46",

	//Vests
	"V_BandollierB_cbr",
	"V_TacChestrig_cbr_F",
	"V_TacVest_oli",
	"V_Chestrig_oli",
	"V_Chestrig_khk",
	"V_HarnessO_brn",
	"V_TacVest_khk",
	"V_PlateCarrierIA2_dgtl",
	"V_BandollierB_ghex_F",
	"V_RebreatherIR",
	"V_RebreatherIA",
	"V_CarrierRigKBT_01_heavy_EAF_F",
	"V_CarrierRigKBT_01_light_EAF_F",
	"V_CarrierRigKBT_01_EAF_F",
	"V_SmershVest_01_F",
		//CUP
		"CUP_V_O_TK_Vest_1",
		"CUP_V_RUS_6B45_2",

	//Weapon Accessories
	"muzzle_snds_H",
	"muzzle_snds_L",
	"muzzle_snds_B",
	"muzzle_snds_93mmg",
	"muzzle_snds_93mmg_tan",
	"muzzle_snds_58_blk_F",
	"muzzle_snds_58_ghex_F",
	"muzzle_snds_65_TI_blk_F",
	"muzzle_snds_65_TI_hex_F",
	"muzzle_snds_65_TI_ghex_F",
	"muzzle_snds_B_khk_F",
	"muzzle_snds_B_snd_F",
	"muzzle_snds_B_lush_F",
	"muzzle_snds_B_arid_F",
	"muzzle_snds_570",
	"bipod_02_F_blk",
	"bipod_02_F_hex",
	"bipod_02_F_tan",
	"bipod_01_F_blk",
	"acc_flashlight",
	"acc_pointer_IR",
	"optic_Yorris",
	"optic_Holosight",
	"optic_Holosight_blk_F",
	"optic_Holosight_smg",
	"optic_Holosight_smg_blk_F",
	"optic_MRCO",
	"optic_MRD",
	"optic_Hamr",
	"optic_Aco",
	"optic_ACO_grn",
	"optic_ARCO",
	"optic_Arco_blk_F",
	"optic_ERCO_blk_F",
	"optic_Arco_ghex_F",
	"optic_Arco_lush_F",
	"optic_Arco_arid_F",
	"optic_Arco_AK_blk_F",
	"optic_Arco_AK_lush_F",
	"optic_Arco_AK_arid_F",
	"optic_ico_01_f",
	"optic_ico_01_black_f",
	"optic_ico_01_camo_f",
	"optic_ico_01_sand_f",
		//CUP
		"CUP_muzzle_PBS4",
		"CUP_optic_Kobra",
		"CUP_optic_ekp_8_02"
];

_availableMagazines = [
// Vanilla Magazines
	//Misc
	"Laserbatteries",

	//Throw
	//"SmokeShellYellow",//is Gas Grenade
	"SmokeShellGreen",
	"SmokeShellBlue",
	"SmokeShellOrange",
	"SmokeShellPurple",
	"SmokeShellRed",
	"SmokeShell",
	"Chemlight_blue",
	"Chemlight_green",
	"Chemlight_red",
	"Chemlight_yellow",
	"MiniGrenade",
	"HandGrenade",
	"O_IR_Grenade",
	"I_IR_Grenade",
		//CUP
		"CUP_HandGrenade_RGD5",

	//UGL
	"1Rnd_HE_Grenade_shell",
	"1Rnd_Smoke_Grenade_shell",
	"1Rnd_SmokeGreen_Grenade_shell",
	"1Rnd_SmokeRed_Grenade_shell",
	//"1Rnd_SmokeYellow_Grenade_shell",//is Gas Grenade
	"1Rnd_SmokePurple_Grenade_shell",
	"1Rnd_SmokeBlue_Grenade_shell",
	"1Rnd_SmokeOrange_Grenade_shell",
	"UGL_FlareYellow_F",
	"UGL_FlareRed_F",
	"UGL_FlareGreen_F",

	//Launcher ammo
	"Titan_AA",
	//"Titan_AT",
	//"Titan_AP",
	"RPG32_HE_F",
	"RPG32_F",
	"RPG7_F",
		//CUP
		"CBA_FakeLauncherMagazine",

	//Rifle/Handgun ammo
	"6Rnd_45ACP_Cylinder",
	"9Rnd_45ACP_Mag",
	"11Rnd_45ACP_Mag",
	"30Rnd_580x42_Mag_F",
	"30Rnd_65x39_caseless_green",
	"16Rnd_9x21_Mag",
	"150Rnd_762x54_Box",
	"150Rnd_762x54_Box_Tracer",
	"30Rnd_9x21_Mag_SMG_02",
	"10Rnd_762x54_Mag",
	"30Rnd_556x45_Stanag",
	"30Rnd_9x21_Mag",
	"20Rnd_762x51_Mag",
	"30Rnd_762x39_Mag_F",
	"30Rnd_545x39_Mag_F",
	"200Rnd_556x45_Box_F",
	"10Rnd_9x21_Mag",
	"200Rnd_65x39_cased_Box",
	"200Rnd_65x39_cased_Box_Tracer",
	"50Rnd_570x28_SMG_03",//ADR
		//CUP
		"CUP_30Rnd_545x39_AK_M",
		"CUP_30Rnd_545x39_AK74M_M",
		"CUP_30Rnd_TE1_Yellow_Tracer_545x39_AK_M",
		"CUP_45Rnd_TE4_LRT4_Green_Tracer_545x39_RPK_M",
		"CUP_1Rnd_HE_GP25_M",
		"CUP_1Rnd_SmokeRed_GP25_M",

	//Put
	"APERSBoundingMine_Range_Mag",
	"APERSMine_Range_Mag",
	"APERSTripMine_Wire_Mag",
	"ATMine_Range_Mag",
	"ClaymoreDirectionalMine_Remote_Mag",
	"DemoCharge_Remote_Mag",
	"SLAMDirectionalMine_Wire_Mag",
	"SatchelCharge_Remote_Mag",
		//CUP
		"IEDLandSmall_Remote_Mag",

	//Contact Mixed
	"3Rnd_HE_Grenade_shell",
	"UGL_FlareWhite_F",
	"30Rnd_45ACP_Mag_SMG_01",
	"30Rnd_65x39_caseless_mag",
	"30Rnd_65x39_caseless_khaki_mag",
	"30Rnd_65x39_caseless_black_mag",
	"100Rnd_65x39_caseless_mag",
	"100Rnd_65x39_caseless_khaki_mag",
	"100Rnd_65x39_caseless_black_mag",
	"100Rnd_65x39_caseless_mag_Tracer",
	"100Rnd_65x39_caseless_khaki_mag_tracer",
	"100Rnd_65x39_caseless_black_mag_tracer",
	"30Rnd_762x39_AK12_Mag_F",
	"30Rnd_762x39_Mag_Green_F",
	"30Rnd_762x39_Mag_Tracer_F",
	"30Rnd_762x39_Mag_Tracer_Green_F",
	"30Rnd_762x39_AK12_Mag_Tracer_F",
	"75Rnd_762x39_Mag_F",
	"75Rnd_762x39_Mag_Tracer_F",
	"30rnd_762x39_AK12_Lush_Mag_F",
	"30rnd_762x39_AK12_Lush_Mag_Tracer_F",
	"30rnd_762x39_AK12_Arid_Mag_F",
	"30rnd_762x39_AK12_Arid_Mag_Tracer_F",
	"75rnd_762x39_AK12_Mag_F",
	"75rnd_762x39_AK12_Lush_Mag_F",
	"75rnd_762x39_AK12_Arid_Mag_F",
	"30Rnd_65x39_caseless_msbs_mag",
	"30Rnd_65x39_caseless_msbs_mag_Tracer",
	"6Rnd_12Gauge_Pellets",
	"6Rnd_12Gauge_Slug",
	"2Rnd_12Gauge_Pellets",
	"2Rnd_12Gauge_Slug"
];

_availableWeapons = [
// Vanilla Weapons
	//Misc
	"Binocular",
	"Rangefinder",
	"Laserdesignator",
	"Laserdesignator_02",
	"Laserdesignator_02_ghex_F",

	//Rifles
	"arifle_TRG21_F",
	"arifle_SDAR_F",
	"arifle_Mk20_F",
	"arifle_Mk20C_F",
	"arifle_Mk20_GL_F",
	"arifle_Mk20_ACO_F",
	"arifle_Katiba_F",
	"arifle_Katiba_C_F",
	"arifle_Katiba_GL_F",
	"arifle_CTAR_blk_Pointer_F",
	"arifle_CTAR_blk_F",
	"arifle_CTAR_GL_blk_F",
	"arifle_AKM_F",
	"arifle_AKS_F",
	"arifle_AK12_F",
	"arifle_AK12_GL_F",
	"srifle_DMR_01_F",
	"hgun_PDW2000_F",
	//ADR
	"SMG_03_camo",
	"SMG_03_hex",
	"SMG_03_TR_camo",
	"SMG_03_TR_hex",
	"SMG_03C_camo",
	"SMG_03C_hex",
	"SMG_03C_TR_camo",
	"SMG_03C_TR_hex",

	//MachineGuns
	"LMG_Zafir_F",
	"LMG_Mk200_F",
	"LMG_Mk200_BI_F",
	"SMG_02_F",
	"SMG_05_F",
	"SMG_01_F",

	//Launchers
	"launch_RPG32_ghex_F",
	"launch_O_Titan_F",
	"launch_I_Titan_F",
	//"launch_O_Titan_short_F",
	//"launch_I_Titan_short_F",
	"launch_RPG32_F",
	"launch_RPG7_F",
	"launch_RPG32_green_F",

	//SideArms
	"hgun_ACPC2_F",
	"hgun_Rook40_F",
	"hgun_Pistol_heavy_02_F",
	"hgun_Pistol_heavy_01_green_F",//Contact
	"hgun_Pistol_01_F",

	//Contact Mixed
	"sgun_HunterShotgun_01_F",//shotgun
	"sgun_HunterShotgun_01_sawedoff_F",//shotgun
	"arifle_AK12_lush_F",
	"arifle_AK12_arid_F",
	"arifle_AK12_GL_lush_F",
	"arifle_AK12_GL_arid_F",
	"arifle_RPK12_F",
	"arifle_RPK12_lush_F",
	"arifle_RPK12_arid_F",
	"arifle_AK12U_F",
	"arifle_AK12U_lush_F",
	"arifle_AK12U_arid_F",
	"arifle_MSBS65_F",
	"arifle_MSBS65_Mark_F",
	"arifle_MSBS65_GL_F",
	"arifle_MSBS65_UBS_F",
	"arifle_MSBS65_black_F",
	"arifle_MSBS65_Mark_black_F",
	"arifle_MSBS65_GL_black_F",
	"arifle_MSBS65_UBS_black_F",
	"arifle_MSBS65_sand_F",
	"arifle_MSBS65_Mark_sand_F",
	"arifle_MSBS65_GL_sand_F",
	"arifle_MSBS65_UBS_sand_F",
	"arifle_MSBS65_camo_F",
	"arifle_MSBS65_Mark_camo_F",
	"arifle_MSBS65_GL_camo_F",
	"arifle_MSBS65_UBS_camo_F",
	"arifle_MSBS65_ico_pointer_f",

		//CUP
		"CUP_arifle_AK107_GL",
		"CUP_lmg_Pecheneg_PScope",
		"CUP_hgun_MicroUzi",
		"CUP_launch_RPG18"
];

[_availableBackpacks,_availableItems,_availableMagazines,_availableWeapons]
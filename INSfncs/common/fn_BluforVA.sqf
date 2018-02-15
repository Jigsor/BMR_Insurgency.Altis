// Modify this file with desired classnames for customization of Blufor Arsenal. Only items listed here will be available in Virtual Arsenal.
// If using class names from moded content then these mods must be loaded or else client side error occurs.
if (!hasInterface) exitWith {};

_availableBackpacks = [
// Vanilla Backpacks
	"B_Parachute",       //Not required for HALO or Bail
	"B_AssaultPack_mcamo",
	"B_Static_Designator_01_weapon_F",
	"B_UAV_01_backpack_F"
];

_availableItems = [
// Vanilla items
	"ItemMap",               //Required for many Map Click mission functions.
	"G_Tactical_Clear",      //Required for Helmet Cam HUD
	"FirstAidKit",           //Required for BTC Revives
	"B_UavTerminal",         //Required to Access UAVs/UGVs
	"H_HelmetB_TI_tna_F",    //Is Gas mask
	"H_CrewHelmetHeli_B",    //Is Gas mask
	"H_PilotHelmetFighter_B",//Is Gas mask
	"MineDetector",
	"ToolKit",
	"Medikit",
	"ItemRadio",
	"ItemCompass",
	"ItemGPS",
	"ItemWatch",

	//Optics
	"Rangefinder",
	"Binocular",
	"Laserdesignator",
	"Laserdesignator_01_khk_F",
	"Laserdesignator_03",
	"NVGoggles",
	"NVGoggles_tna_F",

	//Uniforms
	"U_B_CombatUniform_mcam",
	"U_B_CombatUniform_mcam_tshirt",
	"U_B_CombatUniform_mcam_worn",
	"U_B_FullGhillie_lsh",
	"U_B_FullGhillie_sard",
	"U_B_FullGhillie_ard",
	"U_B_CTRG_1",
	"U_B_CTRG_2",
	"U_B_CTRG_3",
	"U_B_CTRG_Soldier_F",
	"U_B_survival_uniform",
	"U_B_CombatUniform_wdl",
	"U_B_CombatUniform_wdl_tshirt",
	"U_B_CombatUniform_wdl_vest",
	"U_B_CombatUniform_sgg",
	"U_B_CombatUniform_sgg_tshirt",
	"U_B_CombatUniform_sgg_vest",
	"U_B_SpecopsUniform_sgg",
	"U_B_PilotCoveralls",

	//Vests
	"V_BandollierB_khk",
	"V_BandollierB_blk",
	"V_PlateCarrier1_rgr",
	"V_PlateCarrier2_rgr",
	"V_PlateCarrier3_rgr",
	"V_PlateCarrierGL_rgr",
	"V_PlateCarrierSpec_rgr",
	"V_PlateCarrierL_CTRG",
	"V_PlateCarrierH_CTRG",

	//Helmets
	"H_HelmetB",
	"H_HelmetB_camo",
	"H_HelmetB_paint",
	"H_HelmetB_light",
	"H_HelmetB_grass",
	"H_HelmetB_snakeskin",
	"H_HelmetB_sand",
	"H_HelmetB_desert",
	"H_HelmetB_light_desert",
	"H_HelmetSpecB",
	"H_HelmetSpecB_sand",
	"H_HelmetSpecB_snakeskin",

	//Weapon Accessories
	"acc_flashlight",
	"acc_pointer_IR",
	"bipod_01_F_blk",
	"bipod_03_F_blk",

	"optic_Yorris",
	"optic_MRD",
	"optic_Hamr",
	"optic_Aco",
	"optic_ACO_grn",
	"optic_Aco_smg",
	"optic_ACO_grn_smg",
	"optic_ARCO",
	"optic_Arco_blk_F",
	"optic_ERCO_blk_F",
	"optic_MRCO",
	"optic_Holosight",
	"optic_Holosight_blk_F",
	"optic_Holosight_smg",
	"optic_Holosight_smg_blk_F",
	"optic_KHS_old"
];

_availableMagazines = [
// Vanilla Magazines
	//Misc
	"Laserbatteries",

	//Throw
	"SmokeShellYellow",               //Poison Gas Grenade
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
	"B_IR_Grenade",

	//Put
	"SatchelCharge_Remote_Mag",       //Can Destroy Ammo Caches and Towers
	"DemoCharge_Remote_Mag",          //Can Destroy Ammo Caches and Towers
	"APERSBoundingMine_Range_Mag",
	"APERSMine_Range_Mag",
	"APERSTripMine_Wire_Mag",
	"ATMine_Range_Mag",
	"ClaymoreDirectionalMine_Remote_Mag",
	"SLAMDirectionalMine_Wire_Mag",
	
	//Mags
	"UGL_FlareWhite_F",               //Required for Hunt IR
	"1Rnd_SmokeYellow_Grenade_shell", //Poison Gas Grenade
	"3Rnd_SmokeYellow_Grenade_shell", //Poison Gas Grenade
	"200Rnd_65x39_cased_Box",
	"200Rnd_65x39_cased_Box_Tracer",
	"30Rnd_9x21_Mag",
	"16Rnd_9x21_Mag",
	"16Rnd_9x21_green_Mag",
	"30Rnd_9x21_Green_Mag"
];

_availableWeapons = [
// Vanilla Weapons
	//Rifles
	"arifle_SDAR_F",
	"srifle_DMR_06_camo_khs_F",
	"srifle_EBR_F",
	"srifle_DMR_03_F",
	"arifle_MX_GL_Black_F",
	"arifle_MX_GL_F",
	"arifle_MX_Black_F",
	"arifle_MX_khk_F",
	"arifle_MX_F",
	"arifle_MX_SW_Black_F",
	"arifle_MX_SW_khk_F",
	"arifle_MX_SW_F",
	"arifle_MXC_Black_F",
	"arifle_MXC_khk_F",
	"arifle_MXC_F",
	"arifle_MXM_Black_F",
	"arifle_MXM_khk_F",
	"arifle_MXM_F",
	"arifle_MXM_DMS_LP_BI_snds_F",
	"arifle_SPAR_01_blk_F",
	"arifle_SPAR_01_khk_F",
	"arifle_SPAR_01_snd_F",
	"arifle_SPAR_01_GL_blk_F",
	"arifle_SPAR_02_blk_F",
	"arifle_SPAR_03_blk_F",
	"LMG_Mk200_BI_F",

	//launchers
	"launch_NLAW_F",
	"launch_B_Titan_F",
	"launch_B_Titan_short_F",
	//SideArms
	"hgun_Pistol_heavy_01_F",
	"hgun_ACPC2_F",
	"hgun_Pistol_Signal_F",
	"hgun_P07_F"
];

[_availableBackpacks,_availableItems,_availableMagazines,_availableWeapons]
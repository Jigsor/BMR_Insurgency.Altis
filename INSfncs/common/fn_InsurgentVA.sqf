// Modify this file with desired classnames for customization of Opfor/Resistance Arsenal. Only items listed here will be available in Virtual Arsenal.
// If using class names from moded content then these mods must be loaded or else client side error occurs.
if (!hasInterface) exitWith {};

_availableBackpacks = [
// Vanilla Backpacks
	"B_AssaultPack_dgtl"
];

_availableItems = [
// Vanilla items
	"FirstAidKit",                 //Required for BTC Revives
	"Medikit",                     //Opfor Players are Medics by Class
	"ToolKit",                     //Opfor Players are Engineers by Trait
	"G_Tactical_Clear",            //<-Required for Helmet Cam HUD
	//"H_HelmetO_ViperSP_ghex_F",  //Is Gas Mask
	//"H_CrewHelmetHeli_O",        //Is Gas Mask
	//"H_CrewHelmetHeli_I",        //Is Gas Mask
	"O_UavTerminal",
	"Binocular",
	"ItemCompass",
	"ItemGPS",
	"ItemMap",
	"ItemWatch",
	"ItemRadio",

	//Optics
	"Laserdesignator",
	"Laserdesignator_01_khk_F",
	"Laserdesignator_03",
	"MineDetector",
	"Rangefinder",
	"NVGoggles_OPFOR",
	"NVGoggles_INDEP",
	"NVGoggles_tna_F",

	//Uniforms
	"U_I_OfficerUniform",
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
	"U_I_G_Story_Protagonist_F",
	"U_I_G_resistanceLeader_F",
	"U_O_OfficerUniform_ocamo",
	"U_O_CombatUniform_oucamo",
	"U_O_SpecopsUniform_ocamo",
	"U_O_SpecopsUniform_blk",	

	"H_HelmetIA",
	"H_HelmetIA_net",
	"H_HelmetIA_camo",

	"H_Shemag_khk",
	"H_Shemag_tan",
	"H_Shemag_olive",
	"H_Shemag_olive_hs",
	"H_ShemagOpen_khk",
	"H_ShemagOpen_tan",

	//Weapon Accessories
	"muzzle_snds_H",
	"bipod_02_F_blk",
	"bipod_03_F_blk",
	"acc_flashlight",
	"acc_pointer_IR",
	"optic_Yorris",
	"optic_MRD",
	"optic_Hamr",
	"optic_Aco",
	"optic_ACO_grn",
	"optic_ARCO",
	"optic_Arco_blk_F",
	"optic_ERCO_blk_F"
];

_availableMagazines = [
// Vanilla Magazines
	//Throw
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

	//Put
	"APERSBoundingMine_Range_Mag",
	"APERSMine_Range_Mag",
	"APERSTripMine_Wire_Mag",
	"ATMine_Range_Mag",
	"ClaymoreDirectionalMine_Remote_Mag",
	"DemoCharge_Remote_Mag",
	"Laserbatteries",
	"SLAMDirectionalMine_Wire_Mag",
	"SatchelCharge_Remote_Mag"
];

_availableWeapons = [
// Vanilla Weapons
	//Rifles
	"arifle_SDAR_F",
	"arifle_Mk20_F",
	"arifle_Mk20_GL_F",
	"arifle_Mk20_ACO_F",
	"arifle_Katiba_F",
	"arifle_Katiba_C_F",
	"arifle_Katiba_GL_F",
	"arifle_CTAR_blk_F",
	"arifle_CTAR_GL_blk_F",
	"Weapon_arifle_AK12_F",
	"Weapon_arifle_AK12_GL_F",
	"Weapon_arifle_AKM_F",
	"Weapon_arifle_AKS_F",
	"hgun_PDW2000_F",
	"srifle_DMR_06_camo_khs_F",
	//launchers
	"launch_RPG32_ghex_F",
	"launch_O_Titan_F",
	"launch_I_Titan_F",
	"launch_O_Titan_short_F",
	"launch_I_Titan_short_F",
	//SideArms
	"hgun_ACPC2_F",
	"hgun_Rook40_F"
];

[_availableBackpacks,_availableItems,_availableMagazines,_availableWeapons]
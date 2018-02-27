// Modify this file with desired classnames for customization of Opfor/Resistance Arsenal. Only items listed here will be available in Virtual Arsenal.
// If using class names from moded content then these mods must be loaded or else client side error occurs.
// becarefull not to make opfor/resistance players to op.
if (!hasInterface) exitWith {};

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
	"B_TacticalPack_ocamo"
];

_availableItems = [
// Vanilla items
	"G_Tactical_Clear",            //<-Required for Helmet Cam HUD
	"FirstAidKit",                 //Required for BTC Revives
	"Medikit",                     //Opfor Players are Medics by Class
	"ToolKit",                     //Opfor Players are Engineers by Trait
	//"H_HelmetO_ViperSP_ghex_F",  //Is Gas Mask
	//"H_CrewHelmetHeli_O",        //Is Gas Mask
	//"H_CrewHelmetHeli_I",        //Is Gas Mask
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
	"O_NVGoggles_hex_F",
	"O_NVGoggles_urb_F",
	"O_NVGoggles_ghex_F",
	"G_Goggles_VR",
	"G_O_Diving",
	"G_I_Diving",
	"G_Lady_Blue",
	"G_Tactical_Black",

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
	"G_Bandanna_tan",

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
	"bipod_02_F_blk",
	"bipod_02_F_hex",
	"bipod_02_F_tan",
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
	"optic_ERCO_blk_F"
];

_availableMagazines = [
// Vanilla Magazines
	//Misc
	"Laserbatteries",

	//Throw
	//"SmokeShellYellow"//is Gas Grenade
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
	"Titan_AT",
	"Titan_AP",
	"RPG32_HE_F",
	"RPG32_F",
	"RPG7_F",

	//Rifle/Handgun ammo
	"6Rnd_45ACP_Cylinder",
	"9Rnd_45ACP_Mag",
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
	//Put
	"APERSBoundingMine_Range_Mag",
	"APERSMine_Range_Mag",
	"APERSTripMine_Wire_Mag",
	"ATMine_Range_Mag",
	"ClaymoreDirectionalMine_Remote_Mag",
	"DemoCharge_Remote_Mag",
	"SLAMDirectionalMine_Wire_Mag",
	"SatchelCharge_Remote_Mag"
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
	"launch_O_Titan_short_F",
	"launch_I_Titan_short_F",
	"launch_RPG32_F",
	"launch_RPG7_F",

	//SideArms
	"hgun_ACPC2_F",
	"hgun_Rook40_F",
	"hgun_Pistol_heavy_02_F",
	"hgun_Pistol_01_F"
];

[_availableBackpacks,_availableItems,_availableMagazines,_availableWeapons]
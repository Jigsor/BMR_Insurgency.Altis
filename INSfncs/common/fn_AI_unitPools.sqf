// fn_AI_unitPools.sqf
private _opposingArmies = ["INS_op_faction", 0] call BIS_fnc_getParamValue;
if (_opposingArmies isEqualTo 0) exitWith {diag_log "!!! BMR Insurgency Warning: lobby option Opposing Army/Mod Initialization does not exist or configured improperly"};

// Global Class Arrays ///////////////////////////////////////////////////////////////////////
	//Typically used for objectives, civilians, civilian vehicles,  airpatrol types, CAS type.

// CSAT
if (_opposingArmies isEqualTo 1) then {
	INS_Op4_side = EAST;// Cfg based side
	INS_men_list = ["O_SoldierU_SL_F","O_Soldier_GL_F","O_soldierU_repair_F","O_soldierU_medic_F","O_sniper_F","O_Soldier_A_F","O_Soldier_AA_F","O_Soldier_AAA_F","O_Soldier_AAR_F","O_Soldier_AAT_F","O_Soldier_AR_F","O_Soldier_AT_F","O_soldier_exp_F","O_Soldier_F","O_engineer_F","O_engineer_U_F","O_medic_F","O_recon_exp_F","O_recon_F","O_recon_JTAC_F","O_recon_LAT_F","O_recon_M_F","O_recon_medic_F","O_recon_TL_F","O_Sharpshooter_F","O_HeavyGunner_F","O_Soldier_HAT_F","O_Soldier_AHAT_F"];// Armed soldiers wich defend objectives - typically main armies/non guerilla
	INS_Op4_medic = "O_soldierU_medic_F";// One Medic
	INS_Op4_Eng = "O_soldierU_repair_F";// One Engineer
	INS_Op4_pilot = ["O_helipilot_F","O_Fighter_Pilot_F"];// Pilots
	INS_Op4_Veh_Light = ["O_MRAP_02_hmg_F","O_MRAP_02_gmg_F","O_G_Offroad_01_armed_F","O_APC_Wheeled_02_rcws_v2_F"];// Armed Wheeled Vehicles
	INS_Op4_Veh_Tracked = ["O_APC_Tracked_02_cannon_F","O_APC_Tracked_02_AA_F","O_MBT_02_cannon_F","O_MBT_04_command_F","O_MBT_04_cannon_F","O_MBT_02_railgun_F"];// Armed Tracked Vehicles
	INS_Op4_Veh_Support = ["O_Truck_03_ammo_F","O_Truck_03_repair_F","O_Truck_02_Ammo_F","O_Truck_02_fuel_F","O_Truck_02_box_F","O_Truck_02_medical_F","O_Truck_03_device_F"];// Wheeled Support Vehicles
	INS_Op4_Veh_AA = ["O_APC_Tracked_02_AA_F"];// Anti Air Vehicles
	INS_Op4_stat_weps = ["O_GMG_01_high_F","O_HMG_01_high_F","O_static_AT_F","O_static_AA_F","O_HMG_01_A_F","O_GMG_01_F","O_G_Mortar_01_F"];// Static Weapons - Classes at the begining of list are more often chosen.
	INS_civlist = ["C_man_p_beggar_F","C_man_1","C_man_polo_1_F","C_man_polo_2_F","C_man_polo_3_F","C_man_polo_4_F","C_man_polo_5_F","C_man_polo_6_F","C_man_shorts_1_F","C_man_1_1_F","C_man_1_2_F","C_man_1_3_F","C_man_p_fugitive_F","C_man_p_shorts_1_F","C_man_hunter_1_F","C_man_shorts_2_F","C_man_shorts_3_F","C_man_shorts_4_F"];// Civilian Units
	INS_civ_Veh_Car = ["C_Hatchback_01_F","C_Offroad_01_F","C_Quadbike_01_F","C_SUV_01_F"];// Civilian Cars
	INS_civ_Veh_Utl = ["C_Tractor_01_F","C_Truck_02_fuel_F","C_Truck_02_box_F","C_Truck_02_transport_F","C_Van_01_box_F","C_Van_01_transport_F","C_Van_01_fuel_F"];// Civilian Utility Vehicles
};

// AAF
if (_opposingArmies in [2,3]) then {
	INS_Op4_side = RESISTANCE;
	INS_men_list = ["I_soldier_F","I_Soldier_lite_F","I_soldier_AT_F","I_soldier_GL_F","I_soldier_LAT_F","I_soldier_exp_F","I_soldier_F","I_soldier_AR_F","I_soldier_repair_F","I_soldier_LAT_F","I_soldier_AR_F","I_soldier_M_F","I_soldier_AT_F","I_soldier_AA_F","I_soldier_AAA_F","I_soldier_F","I_soldier_TL_F","I_medic_F","I_soldier_GL_F","I_soldier_F","I_Soldier_LAT2_F"];
	INS_Op4_medic = "I_medic_F";
	INS_Op4_Eng = "I_soldier_repair_F";
	INS_Op4_pilot = ["I_Soldier_04_F","I_Fighter_Pilot_F"];
	INS_Op4_Veh_Light = ["I_G_Offroad_01_armed_F","I_MRAP_03_gmg_F","I_MRAP_03_hmg_F","I_APC_Wheeled_03_cannon_F"];
	INS_Op4_Veh_Tracked = ["I_APC_tracked_03_cannon_F","I_MBT_03_cannon_F"];
	INS_Op4_Veh_Support = ["I_Truck_02_ammo_F","I_Truck_02_fuel_F","I_Truck_02_box_F","I_Truck_02_medical_F","I_G_Van_01_fuel_F"];
	INS_Op4_Veh_AA = ["O_APC_Tracked_02_AA_F","I_LT_01_AA_F"];
	INS_Op4_stat_weps = ["I_GMG_01_high_F","I_HMG_02_high_F","I_Mortar_01_F","I_static_AT_F","I_static_AA_F","I_GMG_01_F","I_HMG_01_high_F","I_HMG_02_F"];
	INS_civlist = ["C_man_p_beggar_F","C_man_1","C_man_polo_1_F","C_man_polo_2_F","C_man_polo_3_F","C_man_polo_4_F","C_man_polo_5_F","C_man_polo_6_F","C_man_shorts_1_F","C_man_1_1_F","C_man_1_2_F","C_man_1_3_F","C_man_p_fugitive_F","C_man_p_shorts_1_F","C_man_hunter_1_F","C_man_shorts_2_F","C_man_shorts_3_F","C_man_shorts_4_F"];// A3 Civilians
	INS_civ_Veh_Car = ["C_Hatchback_01_F","C_Offroad_01_F","C_Quadbike_01_F","C_SUV_01_F"];
	INS_civ_Veh_Utl = ["C_Tractor_01_F","C_Van_01_box_F","C_Van_01_transport_F","C_Van_01_fuel_F"];
};

// CSAT (Pacific)
if (_opposingArmies in [4,5]) then {
	INS_Op4_side = EAST;
	INS_men_list = ["O_T_Soldier_A_F","O_T_Soldier_AAR_F","O_T_Support_AMG_F","O_T_Support_AMort_F","O_T_Soldier_AAA_F","O_T_Soldier_AAT_F","O_T_Soldier_AR_F","O_T_Medic_F","O_T_Crew_F","O_T_Engineer_F","O_T_Soldier_Exp_F","O_T_Soldier_GL_F","O_T_Support_GMG_F","O_T_Support_MG_F","O_T_Support_Mort_F","O_T_Soldier_M_F","O_T_Soldier_AA_F","O_T_Soldier_AT_F","O_T_Officer_F","O_T_Soldier_PG_F","O_T_Soldier_Repair_F","O_T_Soldier_F","O_T_Soldier_LAT_F","O_T_Soldier_SL_F","O_T_Soldier_TL_F","O_T_Soldier_UAV_F","O_T_Recon_Exp_F","O_T_Recon_JTAC_F","O_T_Recon_M_F","O_T_Recon_Medic_F","O_T_Recon_F","O_T_Recon_LAT_F","O_T_Recon_TL_F","O_T_Sniper_F","O_T_Spotter_F","O_T_ghillie_tna_F","O_V_Soldier_ghex_F","O_V_Soldier_TL_ghex_F","O_V_Soldier_Exp_ghex_F","O_V_Soldier_Medic_ghex_F","O_V_Soldier_M_ghex_F","O_V_Soldier_LAT_ghex_F","O_V_Soldier_JTAC_ghex_F","O_T_Soldier_HAT_F","O_T_Soldier_AHAT_F"];
	INS_Op4_medic = "O_soldierU_medic_F";
	INS_Op4_Eng = "O_T_Soldier_Repair_F";
	INS_Op4_pilot = ["O_T_Pilot_F"];
	INS_Op4_Veh_Light = ["O_T_MRAP_02_hmg_ghex_F","O_T_MRAP_02_gmg_ghex_F","O_T_LSV_02_armed_F","O_T_APC_Wheeled_02_rcws_v2_ghex_F","O_T_LSV_02_AT_F"];
	INS_Op4_Veh_Tracked = ["O_T_MBT_02_cannon_ghex_F","O_T_APC_Tracked_02_cannon_ghex_F","O_T_APC_Tracked_02_AA_ghex_F","O_T_MBT_04_command_F","O_T_MBT_04_cannon_F","O_T_MBT_02_railgun_ghex_F"];
	INS_Op4_Veh_Support = ["O_T_Truck_03_ammo_ghex_F","O_T_Truck_03_repair_ghex_F","O_T_Truck_03_fuel_ghex_F","O_T_Truck_03_medical_ghex_F","O_T_Truck_03_device_ghex_F"];
	INS_Op4_Veh_AA = ["O_T_APC_Tracked_02_AA_ghex_F"];
	INS_Op4_stat_weps = ["O_HMG_01_high_F","O_GMG_01_high_F","O_G_Mortar_01_F","B_T_HMG_01_F","O_static_AT_F","O_static_AA_F","O_GMG_01_F"];
	INS_civlist = ["C_Man_casual_1_F_afro","C_Man_casual_2_F_afro","C_Man_casual_3_F_afro","C_man_sport_1_F_afro","C_man_sport_2_F_afro","C_man_sport_3_F_afro","C_Man_casual_4_F_afro","C_Man_casual_5_F_afro","C_Man_casual_6_F_afro","C_man_polo_1_F_afro","C_man_polo_2_F_afro","C_man_polo_3_F_afro","C_man_polo_4_F_afro","C_man_polo_5_F_afro","C_man_polo_6_F_afro","C_man_p_fugitive_F_afro","C_man_p_shorts_1_F_afro","C_man_shorts_2_F_afro","C_man_shorts_3_F_afro","C_man_shorts_4_F_afro"];
	INS_civ_Veh_Car = ["C_Offroad_02_unarmed_F","C_Hatchback_01_F","C_Offroad_01_F","C_Quadbike_01_F","C_SUV_01_F"];
	INS_civ_Veh_Utl = ["C_Tractor_01_F","C_Truck_02_fuel_F","C_Truck_02_box_F","C_Truck_02_covered_F","C_Van_01_box_F","C_Van_01_transport_F","C_Van_01_fuel_F"];
};

// LDF
if (_opposingArmies in [6,7]) then {
	INS_Op4_side = RESISTANCE;
	INS_men_list = ["I_E_Soldier_A_F","I_E_Soldier_AAR_F","I_E_Soldier_AAA_F","I_E_Soldier_AAT_F","I_E_Soldier_AR_F","I_E_Soldier_CBRN_F","I_E_Medic_F","I_E_Engineer_F","I_E_Soldier_Exp_F","I_E_Soldier_GL_F","I_E_soldier_M_F","I_E_soldier_Mine_F","I_E_Soldier_AA_F","I_E_Soldier_AT_F","I_E_Officer_F","I_E_Soldier_Pathfinder_F","I_E_RadioOperator_F","I_E_Soldier_Repair_F","I_E_Soldier_F","I_E_Soldier_LAT_F","I_E_Soldier_LAT2_F","I_E_Soldier_lite_F","I_E_Soldier_SL_F","I_E_Soldier_TL_F"];
	INS_Op4_medic = "I_E_Medic_F";
	INS_Op4_Eng = "I_E_Engineer_F";
	INS_Op4_pilot = ["I_E_Helipilot_F","I_Fighter_Pilot_F"];
	INS_Op4_Veh_Light = ["I_G_Offroad_01_armed_F","I_E_Truck_02_transport_F","I_E_Truck_02_F","I_MRAP_03_gmg_F","I_MRAP_03_hmg_F","I_APC_Wheeled_03_cannon_F"];
	INS_Op4_Veh_Tracked = ["I_E_APC_tracked_03_cannon_F","I_MBT_03_cannon_F"];
	INS_Op4_Veh_Support = ["I_E_Truck_02_Ammo_F","I_E_Truck_02_fuel_F","I_E_Truck_02_Medical_F","I_E_Truck_02_Box_F","O_Truck_03_device_F"];
	INS_Op4_Veh_AA = ["O_T_APC_Tracked_02_AA_ghex_F","I_LT_01_AA_F"];
	INS_Op4_stat_weps = ["I_HMG_02_high_F","I_E_GMG_01_high_F","I_E_Mortar_01_F","I_E_HMG_01_F","I_E_HMG_01_A_F","I_E_GMG_01_F","I_E_GMG_01_A_F","I_E_Static_AA_F","I_E_Static_AT_F","I_E_HMG_01_high_F","I_HMG_02_F"];
	INS_civlist = ["C_Man_1_enoch_F","C_Man_2_enoch_F","C_Man_3_enoch_F","C_Man_4_enoch_F","C_Man_5_enoch_F","C_Man_6_enoch_F","C_Farmer_01_enoch_F"];
	INS_civ_Veh_Car = ["C_Offroad_01_covered_F","C_Offroad_01_comms_F","C_Offroad_02_unarmed_F","C_Hatchback_01_F","C_Offroad_01_F","C_Quadbike_01_F","C_SUV_01_F"];
	INS_civ_Veh_Utl = ["C_Tractor_01_F","C_Truck_02_fuel_F","C_Truck_02_box_F","C_Truck_02_transport_F","C_Van_01_box_F","C_Van_01_transport_F","C_Van_01_fuel_F"];
};

// Spetsnaz
if (_opposingArmies isEqualTo 8) then {
	INS_Op4_side = EAST;
	INS_men_list = ["O_R_Soldier_AR_F","O_R_medic_F","O_R_soldier_exp_F","O_R_Soldier_GL_F","O_R_JTAC_F","O_R_soldier_M_F","O_R_Soldier_LAT_F","O_R_Soldier_TL_F","O_R_Patrol_Soldier_A_F","O_R_Patrol_Soldier_AR2_F","O_R_Patrol_Soldier_AR_F","O_R_Patrol_Soldier_Medic","O_R_Patrol_Soldier_Engineer_F","O_R_Patrol_Soldier_GL_F","O_R_Patrol_Soldier_M2_F","O_R_Patrol_Soldier_LAT_F","O_R_Patrol_Soldier_M_F","O_R_Patrol_Soldier_TL_F","O_R_recon_AR_F","O_R_recon_exp_F","O_R_recon_GL_F","O_R_recon_JTAC_F","O_R_recon_medic_F","O_R_recon_LAT_F","O_R_recon_TL_F"];
	INS_Op4_medic = "O_R_medic_F";
	INS_Op4_Eng = "O_R_Patrol_Soldier_Engineer_F";
	INS_Op4_pilot = ["O_helipilot_F","O_Fighter_Pilot_F"];
	INS_Op4_Veh_Light = ["O_T_MRAP_02_hmg_ghex_F","O_T_MRAP_02_gmg_ghex_F","O_T_LSV_02_armed_F","O_T_APC_Wheeled_02_rcws_v2_ghex_F","O_T_LSV_02_armed_F","O_T_LSV_02_AT_F"];
	INS_Op4_Veh_Tracked = ["I_E_APC_tracked_03_cannon_F","O_T_MBT_02_cannon_ghex_F","O_T_APC_Tracked_02_AA_ghex_F","O_T_MBT_04_command_F","O_T_MBT_04_cannon_F","O_T_MBT_02_railgun_ghex_F"];
	INS_Op4_Veh_Support = ["I_E_Truck_02_Ammo_F","I_E_Truck_02_fuel_F","I_E_Truck_02_Medical_F","I_E_Truck_02_Box_F","O_Truck_03_device_F"];
	INS_Op4_Veh_AA = ["O_T_APC_Tracked_02_AA_ghex_F","I_LT_01_AA_F"];
	INS_Op4_stat_weps = ["I_E_HMG_01_high_F","I_E_GMG_01_high_F","I_E_Mortar_01_F","I_E_HMG_01_F","I_E_HMG_01_A_F","I_E_GMG_01_F","I_E_GMG_01_A_F","I_E_Static_AA_F","I_E_Static_AT_F"];
	INS_civlist = ["C_Man_1_enoch_F","C_Man_2_enoch_F","C_Man_3_enoch_F","C_Man_4_enoch_F","C_Man_5_enoch_F","C_Man_6_enoch_F","C_Farmer_01_enoch_F"];
	INS_civ_Veh_Car = ["C_Offroad_01_covered_F","C_Offroad_01_comms_F","C_Offroad_02_unarmed_F","C_Hatchback_01_F","C_Offroad_01_F","C_Quadbike_01_F","C_SUV_01_F"];
	INS_civ_Veh_Utl = ["C_Tractor_01_F","C_Truck_02_fuel_F","C_Truck_02_box_F","C_Truck_02_transport_F","C_Van_01_box_F","C_Van_01_transport_F","C_Van_01_fuel_F"];
};

// RHS - Armed Forces of the Russian Federation MSV
if (_opposingArmies isEqualTo 9) then {
	INS_Op4_side = EAST;
	INS_men_list = ["rhs_msv_rifleman","rhs_msv_efreitor","rhs_msv_grenadier","rhs_msv_machinegunner","rhs_msv_machinegunner_assistant","rhs_msv_at","rhs_msv_strelok_rpg_assist","rhs_msv_marksman","rhs_msv_officer_armored","rhs_msv_officer","rhs_msv_junior_sergeant","rhs_msv_sergeant","rhs_msv_engineer","rhs_msv_driver","rhs_msv_aa","rhs_msv_medic","rhs_msv_LAT"];//"rhs_msv_crew","rhs_msv_crew_commander","rhs_msv_armoredcrew","rhs_msv_combatcrew",
	INS_Op4_medic = "rhs_msv_medic";
	INS_Op4_Eng = "rhs_msv_engineer";
	INS_Op4_pilot = ["rhs_pilot"];
	INS_Op4_Veh_Light = ["rhs_btr60_msv","rhs_btr70_msv","rhs_btr80_msv","rhs_btr80a_msv","rhs_tigr_3camo_msv","rhs_tigr_sts_3camo_msv","rhs_tigr_sts_3camo_msv","rhs_tigr_m_3camo_msv","rhs_gaz66_zu23_msv","RHS_Ural_Zu23_MSV_01"];
	INS_Op4_Veh_Tracked = ["rhs_bmp1_msv","rhs_bmp1d_msv","rhs_bmp1k_msv","rhs_bmp1p_msv","rhs_bmp2e_msv","rhs_bmp2_msv","rhs_bmp2d_msv","rhs_bmp2k_msv","rhs_bmp3_msv","rhs_bmp3_late_msv","rhs_bmp3m_msv","rhs_bmp3mera_msv","rhs_brm1k_msv","rhs_Ob_681_2","rhs_prp3_msv","rhs_t80u","rhs_t80bv","rhs_t80a","rhs_t72bc_tv","rhs_t72bb_tv","rhs_zsu234_aa","rhs_t90_tv","rhs_t90a_tv"];
	INS_Op4_Veh_Support = ["rhs_gaz66_r142_msv","rhs_gaz66_ap2_msv","rhs_gaz66_repair_msv","RHS_Ural_Fuel_MSV_01","RHS_Ural_Open_MSV_01"];
	INS_Op4_Veh_AA = ["rhs_zsu234_aa"];
	INS_Op4_stat_weps = ["RHS_ZU23_MSV","rhs_KORD_high_MSV","rhs_2b14_82mm_msv","rhs_Igla_AA_pod_msv","RHS_AGS30_TriPod_MSV","rhs_KORD_MSV","RHS_NSV_TriPod_MSV","rhs_SPG9M_MSV","rhs_D30_msv","rhs_D30_at_msv","rhs_Kornet_9M133_2_msv"];
	INS_Op4_fixedWing = ["RHS_Su25SM_vvsc","RHS_Su25SM_CAS_vvsc","RHS_T50_vvs_052","RHS_T50_vvs_054","RHS_T50_vvs_blueonblue","rhs_mig29s_vvsc"];//"RHS_Su25SM_KH29_vvsc"
	INS_Op4_helis = ["RHS_Ka52_vvsc","RHS_Ka52_UPK23_vvsc","RHS_Mi24P_CAS_vvsc","RHS_Mi24V_vvsc","RHS_Mi24P_vvsc","RHS_Mi24V_UPK23_vvsc","RHS_Mi8AMTSh_FAB_vvsc"];//,"RHS_Mi8AMTSh_UPK23_vvsc"
	INS_civ_Veh_Car = ["C_Hatchback_01_F","C_Offroad_01_F","C_Quadbike_01_F","C_SUV_01_F"];
	INS_civ_Veh_Utl = ["RHS_Ural_Civ_02","RHS_Ural_Civ_03","RHS_Ural_Open_Civ_01","RHS_Civ_Truck_02_covered_F","RHS_Civ_Truck_02_transport_F","C_Van_01_box_F","C_Van_01_transport_F","C_Van_01_fuel_F"];
	INS_civlist = ["C_man_p_beggar_F","C_man_1","C_man_polo_1_F","C_man_polo_2_F","C_man_polo_3_F","C_man_polo_4_F","C_man_polo_5_F","C_man_polo_6_F","C_man_shorts_1_F","C_man_1_1_F","C_man_1_2_F","C_man_1_3_F","C_man_p_fugitive_F","C_man_p_shorts_1_F","C_man_hunter_1_F","C_man_shorts_2_F","C_man_shorts_3_F","C_man_shorts_4_F"];// A3 Civilians
	INS_CAS = "RHS_A10";
};

// RHS - DESERT Armed Forces of the Russian Federation VDV
if (_opposingArmies isEqualTo 10) then {
	INS_Op4_side = EAST;
	INS_men_list = ["rhs_vdv_des_aa","rhs_vdv_des_at","rhs_vdv_des_arifleman","rhs_vdv_des_sergeant","rhs_vdv_des_efreitor","rhs_vdv_des_grenadier_rpg","rhs_vdv_des_strelok_rpg_assist","rhs_vdv_des_junior_sergeant","rhs_vdv_des_machinegunner","rhs_vdv_des_machinegunner_assistant","rhs_vdv_des_marksman","rhs_vdv_des_marksman_asval","rhs_vdv_des_rifleman","rhs_vdv_des_rifleman_asval","rhs_vdv_des_rifleman_lite","rhs_vdv_des_grenadier"];//"rhs_msv_crew","rhs_msv_crew_commander","rhs_msv_armoredcrew","rhs_msv_combatcrew",
	INS_Op4_medic = "rhs_vdv_des_medic";
	INS_Op4_Eng = "rhs_vdv_des_engineer";
	INS_Op4_pilot = ["rhs_pilot"];
	INS_Op4_Veh_Light = ["rhs_btr60_msv","rhs_btr70_msv","rhs_btr80_msv","rhs_btr80a_msv","rhs_tigr_3camo_msv","rhs_tigr_sts_3camo_msv","rhs_tigr_sts_3camo_msv","rhs_tigr_m_3camo_msv","rhs_gaz66_zu23_msv","RHS_Ural_Zu23_MSV_01"];
	INS_Op4_Veh_Tracked = ["rhs_bmp1_msv","rhs_bmp1d_msv","rhs_bmp1k_msv","rhs_bmp1p_msv","rhs_bmp2e_msv","rhs_bmp2_msv","rhs_bmp2d_msv","rhs_bmp2k_msv","rhs_bmp3_msv","rhs_bmp3_late_msv","rhs_bmp3m_msv","rhs_bmp3mera_msv","rhs_brm1k_msv","rhs_Ob_681_2","rhs_prp3_msv","rhs_t80u","rhs_t80bv","rhs_t80a","rhs_t72bc_tv","rhs_t72bb_tv","rhs_zsu234_aa","rhs_t90_tv","rhs_t90a_tv"];
	INS_Op4_Veh_Support = ["rhs_gaz66_r142_msv","rhs_gaz66_ap2_msv","rhs_gaz66_repair_msv","RHS_Ural_Fuel_MSV_01","RHS_Ural_Open_MSV_01"];
	INS_Op4_Veh_AA = ["rhs_zsu234_aa"];
	INS_Op4_stat_weps = ["RHS_ZU23_MSV","rhs_KORD_high_MSV","rhs_2b14_82mm_msv","rhs_Igla_AA_pod_msv","RHS_AGS30_TriPod_MSV","rhs_KORD_MSV","RHS_NSV_TriPod_MSV","rhs_SPG9M_MSV","rhs_D30_msv","rhs_D30_at_msv","rhs_Kornet_9M133_2_msv"];
	INS_Op4_fixedWing = ["RHS_Su25SM_vvsc","RHS_Su25SM_CAS_vvsc","RHS_T50_vvs_052","RHS_T50_vvs_054","RHS_T50_vvs_blueonblue","rhs_mig29s_vvsc"];//,"RHS_Su25SM_KH29_vvsc"
	INS_Op4_helis = ["RHS_Ka52_vvsc","RHS_Ka52_UPK23_vvsc","RHS_Mi24P_CAS_vvsc","RHS_Mi24V_vvsc","RHS_Mi24P_vvsc","RHS_Mi24V_UPK23_vvsc","RHS_Mi8AMTSh_FAB_vvsc"];//,"RHS_Mi8AMTSh_UPK23_vvsc"
	INS_civ_Veh_Car = ["C_Hatchback_01_F","C_Offroad_01_F","C_Quadbike_01_F","C_SUV_01_F"];
	INS_civ_Veh_Utl = ["RHS_Ural_Civ_02","RHS_Ural_Civ_03","RHS_Ural_Open_Civ_01","RHS_Civ_Truck_02_covered_F","RHS_Civ_Truck_02_transport_F","C_Van_01_box_F","C_Van_01_transport_F","C_Van_01_fuel_F"];
	INS_civlist = ["C_man_p_beggar_F","C_man_1","C_man_polo_1_F","C_man_polo_2_F","C_man_polo_3_F","C_man_polo_4_F","C_man_polo_5_F","C_man_polo_6_F","C_man_shorts_1_F","C_man_1_1_F","C_man_1_2_F","C_man_1_3_F","C_man_p_fugitive_F","C_man_p_shorts_1_F","C_man_hunter_1_F","C_man_shorts_2_F","C_man_shorts_3_F","C_man_shorts_4_F"];// A3 Civilians
	INS_CAS = "RHS_A10";
};

// RHS GREF - Chenarus Ground Forces (RESISTANCE)
if (_opposingArmies isEqualTo 11) then {
	INS_Op4_side = RESISTANCE;
	INS_men_list = 	["rhsgref_cdf_reg_rifleman","rhsgref_cdf_reg_rifleman_m70","rhsgref_cdf_reg_rifleman_lite","rhsgref_cdf_reg_grenadier","rhsgref_cdf_reg_machinegunner","rhsgref_cdf_reg_marksman","rhsgref_cdf_reg_officer","rhsgref_cdf_reg_squadleader","rhsgref_cdf_reg_grenadier_rpg","rhsgref_cdf_reg_specialist_aa","rhsgref_cdf_reg_medic","rhsgref_cdf_reg_engineer","rhsgref_cdf_para_rifleman","rhsgref_cdf_para_rifleman_lite","rhsgref_cdf_para_autorifleman","rhsgref_cdf_para_machinegunner","rhsgref_cdf_para_marksman","rhsgref_cdf_para_squadleader","rhsgref_cdf_para_grenadier_rpg","rhsgref_cdf_para_specialist_aa","rhsgref_cdf_para_medic","rhsgref_cdf_para_engineer"];//"rhsgref_cdf_reg_general","rhsgref_cdf_para_officer"
	INS_Op4_medic = "rhsgref_cdf_para_medic";
	INS_Op4_Eng = "rhsgref_cdf_reg_engineer";
	INS_Op4_pilot = ["rhsgref_cdf_air_pilot"];
	INS_Op4_Veh_Light = ["rhsgref_cdf_btr60","rhsgref_cdf_btr70","rhsgref_BRDM2","rhsgref_BRDM2_HQ","rhsgref_BRDM2_ATGM","rhsgref_c_a2port_armor","rhsgref_cdf_reg_uaz_ags","rhsgref_cdf_reg_uaz_dshkm","rhsgref_cdf_reg_uaz_spg9"];
	INS_Op4_Veh_Tracked = ["rhsgref_cdf_t72ba_tv","rhsgref_cdf_bmd1","rhsgref_cdf_bmd1","rhsgref_cdf_bmd1p","rhsgref_cdf_bmd1pk","rhsgref_cdf_bmd2","rhsgref_cdf_bmd2k","rhsgref_cdf_bmp1","rhsgref_cdf_bmp1d","rhsgref_cdf_bmp1k","rhsgref_cdf_bmp1p","rhsgref_cdf_bmp2e","rhsgref_cdf_bmp2","rhsgref_cdf_bmp2d","rhsgref_cdf_gaz66_zu23"];
	INS_Op4_Veh_Support = ["rhsgref_cdf_gaz66_ammo","rhsgref_cdf_ural_fuel","rhsgref_cdf_gaz66_repair","rhsgref_cdf_gaz66_r142","rhsgref_cdf_gaz66_ap2"];
	INS_Op4_Veh_AA = ["rhsgref_cdf_zsu234"];
	INS_Op4_stat_weps = ["RHSgref_cdf_ZU23","rhsgref_cdf_reg_M252","rhsgref_cdf_reg_d30","rhsgref_cdf_reg_d30_at","rhsgref_cdf_Igla_AA_pod","rhsgref_cdf_AGS30_TriPod","rhsgref_cdf_DSHKM","rhsgref_cdf_DSHKM_Mini_TriPod","rhsgref_cdf_NSV_TriPod","rhsgref_cdf_SPG9","rhsgref_cdf_SPG9M"];
	INS_Op4_fixedWing = ["rhs_l159_CDF_CAP","rhs_l159_CDF_CAS","rhs_l159_CDF_plamen","rhs_l159_CDF","rhs_l39_cdf","rhsgref_cdf_su25","rhsgref_cdf_mig29s"];
	INS_Op4_helis = ["rhsgref_mi24g_CAS","rhsgref_mi24g_FAB","rhsgref_mi24g_UPK23","rhsgref_cdf_Mi35","rhsgref_cdf_Mi35_UPK","rhsgref_cdf_reg_Mi17Sh"];
	INS_civ_Veh_Car = ["C_Hatchback_01_F","C_Offroad_01_F","C_Quadbike_01_F","C_SUV_01_F"];
	INS_civ_Veh_Utl = ["RHS_Ural_Civ_02","RHS_Ural_Civ_03","RHS_Ural_Open_Civ_01","RHS_Civ_Truck_02_covered_F","RHS_Civ_Truck_02_transport_F","C_Van_01_box_F","C_Van_01_transport_F","C_Van_01_fuel_F"];
	INS_civlist = ["C_man_p_beggar_F","C_man_1","C_man_polo_1_F","C_man_polo_2_F","C_man_polo_3_F","C_man_polo_4_F","C_man_polo_5_F","C_man_polo_6_F","C_man_shorts_1_F","C_man_1_1_F","C_man_1_2_F","C_man_1_3_F","C_man_p_fugitive_F","C_man_p_shorts_1_F","C_man_hunter_1_F","C_man_shorts_2_F","C_man_shorts_3_F","C_man_shorts_4_F"];// A3 Civilians
	INS_CAS = "RHS_A10";
};

// RHS - Serbian Armed Forces
if (_opposingArmies isEqualTo 12) then {
	INS_Op4_side = RESISTANCE;
	INS_men_list = 	["rhssaf_army_m10_digital_asst_mgun","rhssaf_army_m10_digital_spec_aa","rhssaf_army_m10_digital_spec_at","rhssaf_army_m10_digital_crew","rhssaf_army_m10_digital_exp","rhssaf_army_m10_digital_ft_lead","rhssaf_army_m10_digital_gl","rhssaf_army_m10_digital_mgun_m84","rhssaf_army_m10_digital_sniper_m76","rhssaf_army_m10_digital_asst_spec_aa","rhssaf_army_m10_digital_asst_spec_at","rhssaf_army_m10_digital_officer","rhssaf_army_m10_digital_repair","rhssaf_army_m10_digital_rifleman_ammo","rhssaf_army_m10_digital_rifleman_at","rhssaf_army_m10_digital_rifleman_m21","rhssaf_army_m10_digital_rifleman_m70","rhssaf_army_m10_digital_spotter","rhssaf_army_m10_digital_sq_lead","rhssaf_army_m10_para_spec_aa","rhssaf_army_m10_para_spec_at","rhssaf_army_m10_para_crew","rhssaf_army_m10_para_ft_lead","rhssaf_army_m10_para_gl_ag36","rhssaf_army_m10_para_gl_m320","rhssaf_army_m10_para_mgun_m84","rhssaf_army_m10_para_mgun_minimi","rhssaf_army_m10_para_sniper_m76","rhssaf_army_m10_para_asst_spec_aa","rhssaf_army_m10_para_asst_spec_at","rhssaf_army_m10_para_repair","rhssaf_army_m10_para_rifleman_ammo","rhssaf_army_m10_para_rifleman_at","rhssaf_army_m10_para_rifleman_hk416","rhssaf_army_m10_para_rifleman_g36","rhssaf_army_m10_para_sniper_m82a1","rhssaf_army_m10_para_spotter","rhssaf_army_m10_para_sq_lead"];//"rhssaf_army_m10_para_officer",
	INS_Op4_medic = "rhssaf_army_m10_digital_medic";
	INS_Op4_Eng = "rhssaf_army_m10_digital_engineer";
	INS_Op4_pilot = ["rhssaf_airforce_pilot_transport_heli"];
	INS_Op4_Veh_Light = ["rhssaf_m1025_olive_m2"];
	INS_Op4_Veh_Tracked = ["rhssaf_army_t72s"];
	INS_Op4_Veh_Support = ["rhssaf_army_ural_fuel"];
	INS_Op4_Veh_AA = ["rhsgref_cdf_zsu234"];
	INS_Op4_stat_weps = ["RHSgref_cdf_ZU23","rhsgref_cdf_reg_M252","rhssaf_army_d30","rhsgref_cdf_reg_d30","rhsgref_cdf_reg_d30_at","rhsgref_cdf_Igla_AA_pod","rhsgref_cdf_AGS30_TriPod","rhsgref_cdf_DSHKM","rhsgref_cdf_DSHKM_Mini_TriPod","rhsgref_cdf_NSV_TriPod","rhsgref_cdf_SPG9","rhsgref_cdf_SPG9M","rhssaf_army_metis_9k115"];
	INS_Op4_fixedWing = ["rhs_l159_CDF_CAP","rhs_l159_CDF_CAS","rhs_l159_CDF_plamen","rhs_l159_CDF","rhs_l39_cdf","rhsgref_cdf_su25","rhssaf_airforce_l_18"];
	INS_Op4_helis = ["rhsgref_mi24g_CAS","rhsgref_mi24g_FAB","rhsgref_mi24g_UPK23","rhsgref_cdf_Mi35","rhsgref_cdf_Mi35_UPK","rhsgref_cdf_reg_Mi17Sh","rhs_mi28n_vvsc"];
	INS_civ_Veh_Car = ["C_Hatchback_01_F","C_Offroad_01_F","C_Quadbike_01_F","C_SUV_01_F"];
	INS_civ_Veh_Utl = ["RHS_Ural_Civ_02","RHS_Ural_Civ_03","RHS_Ural_Open_Civ_01","RHS_Civ_Truck_02_covered_F","RHS_Civ_Truck_02_transport_F","C_Van_01_box_F","C_Van_01_transport_F","C_Van_01_fuel_F"];
	INS_civlist = ["C_man_p_beggar_F","C_man_1","C_man_polo_1_F","C_man_polo_2_F","C_man_polo_3_F","C_man_polo_4_F","C_man_polo_5_F","C_man_polo_6_F","C_man_shorts_1_F","C_man_1_1_F","C_man_1_2_F","C_man_1_3_F","C_man_p_fugitive_F","C_man_p_shorts_1_F","C_man_hunter_1_F","C_man_shorts_2_F","C_man_shorts_3_F","C_man_shorts_4_F"];// A3 Civilians
	INS_CAS = "RHS_A10";
};

// Project OPFOR mod Islamic State of Takistan and Sahrani
if (_opposingArmies isEqualTo 13) then {
	INS_Op4_side = RESISTANCE;
	INS_men_list = ["LOP_ISTS_Infantry_TL","LOP_ISTS_Infantry_SL","LOP_ISTS_Infantry_Corpsman","LOP_ISTS_Infantry_AR","LOP_ISTS_Infantry_AT","LOP_ISTS_Infantry_Marksman","LOP_ISTS_Infantry_Engineer","LOP_ISTS_Infantry_GL","LOP_ISTS_Infantry_Rifleman_3","LOP_ISTS_Infantry_Rifleman","LOP_ISTS_Infantry_AT","LOP_TKA_Infantry_AA"];
	INS_Op4_medic = "LOP_ISTS_Infantry_Corpsman";
	INS_Op4_Eng = "LOP_ISTS_Infantry_Engineer";
	INS_Op4_pilot = ["LOP_ISTS_Infantry_Engineer"];
	INS_Op4_Veh_Light = ["LOP_ISTS_Landrover_M2","LOP_ISTS_M1025_W_M2","LOP_ISTS_M1025_W_Mk19","LOP_ISTS_M1025_D","LOP_ISTS_M998_D_4DR","LOP_ISTS_Offroad_M2","LOP_ISTS_Landrover_SPG9"];
	INS_Op4_Veh_Tracked = ["LOP_ISTS_BMP1","LOP_ISTS_BMP2","LOP_ISTS_BTR60","LOP_ISTS_M113_W","LOP_ISTS_T72BA","LOP_ISTS_ZSU234"];
	INS_Op4_Veh_Support = ["RHS_Ural_Fuel_MSV_01","LOP_UA_Ural_fuel","LOP_IRAN_KAMAZ_Ammo","RHS_Ural_Repair_MSV_01","LOP_IRAN_KAMAZ_Medical"];
	INS_Op4_Veh_AA = ["LOP_ISTS_ZSU234"];
	INS_Op4_stat_weps = ["LOP_AM_Static_ZU23","LOP_ISTS_Static_Mk19_TriPod","LOP_AM_Static_SPG9","LOP_ISTS_Static_M2","LOP_ISTS_Static_M2_MiniTripod","O_G_Mortar_01_F"];
	INS_Op4_fixedWing = ["RHS_Su25SM_vvsc","I_Plane_Fighter_03_AA_F","I_Plane_Fighter_03_CAS_F","O_Plane_CAS_02_F"];
	INS_Op4_helis = ["O_Heli_Attack_02_black_F","RHS_Mi24V_UPK23_vvsc","RHS_Mi8AMTSh_FAB_vvsc"];
	INS_civ_Veh_Car = ["LOP_TAK_Civ_Offroad","LOP_TAK_Civ_Hatchback","LOP_TAK_Civ_Landrover","LOP_TAK_Civ_UAZ","LOP_TAK_Civ_UAZ_Open","C_Hatchback_01_F","C_Offroad_01_F","C_Quadbike_01_F","C_SUV_01_F"];
	INS_civ_Veh_Utl = ["LOP_TAK_Civ_Ural","LOP_TAK_Civ_Ural_open","C_Van_01_box_F","C_Van_01_transport_F","C_Van_01_fuel_F"];
	INS_civlist = ["LOP_Tak_Civ_Man_01","LOP_Tak_Civ_Man_02","LOP_Tak_Civ_Man_04","LOP_Tak_Civ_Man_05","LOP_Tak_Civ_Man_06","LOP_Tak_Civ_Man_07","LOP_Tak_Civ_Man_08","LOP_Tak_Civ_Man_09","LOP_Tak_Civ_Man_10","LOP_Tak_Civ_Man_11","LOP_Tak_Civ_Man_12","LOP_Tak_Civ_Man_13","LOP_Tak_Civ_Man_14","LOP_Tak_Civ_Man_15","LOP_Tak_Civ_Man_16"];
};

// ISC - Syrian Arab Army
if (_opposingArmies isEqualTo 14) then {
	INS_Op4_side = EAST;
	INS_men_list = ["isc_saa_at_o","isc_saa_crewman_o","isc_saa_grenadier_o","isc_saa_machinegunner_o","isc_saa_medic_o","isc_saa_officer_o","isc_saa_rifleman_o","isc_saa_sapper_o","isc_saa_sniper_o"];
	INS_Op4_medic = "isc_saa_medic_o";
	INS_Op4_Eng = "isc_saa_sapper_o";
	INS_Op4_pilot = ["isc_saa_crewman_o"];
	INS_Op4_Veh_Light = ["isc_saa_Ural_zu23_o","isc_saa_gaz66_zu23_o","isc_saa_BTR60PB_o","isc_saa_BTR80_o","isc_saa_BTR80a_o","isc_saa_tigr_m_o","isc_saa_tigr_m_3camo_o","isc_saa_tigr_sts_o","isc_saa_tigr_sts_3camo_o","isc_saa_UAZ_ags_o","isc_saa_UAZ_dshkm_o","isc_saa_UAZ_spg9_o"];
	INS_Op4_Veh_Tracked = ["isc_saa_zsu23_o","isc_saa_T72ba_o","isc_saa_T72bb_o","isc_saa_BMP1_o","isc_saa_BMP1p_o","isc_saa_BMP2_o"];
	INS_Op4_Veh_Support = ["isc_saa_ural_fuel_o","isc_saa_kamaz_o","isc_saa_BM21_o","isc_saa_ural_o","isc_saa_gaz66_o","isc_saa_tigr_o","isc_saa_kamaz_open_o","isc_saa_ural_open_o"];
	INS_Op4_Veh_AA = ["isc_saa_gaz66_zu23_o","isc_saa_Ural_zu23_o","isc_saa_ZSU_o"];
	INS_Op4_stat_weps = ["isc_saa_zu23_o","isc_saa_kord_high_o","isc_saa_ags30_o","isc_saa_dshkm_minitripod_o","isc_saa_dshkm_o","isc_saa_kord_o","isc_saa_spg9_o","isc_saa_Kornet_o","isc_saa_Metis_o","isc_saa_nsv_o","isc_saa_2b14_o","isc_saa_D30_at_o","isc_saa_D30_o"];
	INS_Op4_fixedWing = ["isc_saa_L39_AA_o","isc_saa_L39_CAS_o","isc_saa_su25_o","isc_saa_su25_cas_o","isc_saa_su25_kh29_o","isc_saa_yak130_o"];
	INS_Op4_helis = ["isc_saa_mi24_o","isc_saa_mi24_at_o","isc_saa_mi24_fab_o","isc_saa_mi24_upk23_o","isc_saa_mi8amtsh_o","isc_saa_mi8amtsh_fab_o","isc_saa_mi8amtsh_upk23_o","isc_saa_mi8mtv_o","isc_saa_mi8mtv_fab_o","isc_saa_mi8mtv_upk23_o"];
	INS_civlist = ["C_man_p_beggar_F","C_man_1","C_man_polo_1_F","C_man_polo_2_F","C_man_polo_3_F","C_man_polo_4_F","C_man_polo_5_F","C_man_polo_6_F","C_man_shorts_1_F","C_man_1_1_F","C_man_1_2_F","C_man_1_3_F","C_man_p_fugitive_F","C_man_p_shorts_1_F","C_man_hunter_1_F","C_man_shorts_2_F","C_man_shorts_3_F","C_man_shorts_4_F"];// A3 Civilians
	INS_civ_Veh_Car = ["C_Hatchback_01_F","C_Offroad_01_F","C_Quadbike_01_F","C_SUV_01_F"];
	INS_civ_Veh_Utl = ["C_Van_01_box_F","C_Van_01_transport_F","C_Van_01_fuel_F"];
};

// CUP - Takistan Army
if (_opposingArmies isEqualTo 15) then {
	INS_Op4_side = EAST;
	INS_men_list = ["CUP_O_TK_Soldier_AA","CUP_O_TK_Soldier_AAT","CUP_O_TK_Soldier_AMG","CUP_O_TK_Soldier_HAT","CUP_O_TK_Soldier_AR","CUP_O_TK_Commander","CUP_O_TK_Engineer","CUP_O_TK_Soldier_GL","CUP_O_TK_Soldier_MG","CUP_O_TK_Medic","CUP_O_TK_Officer","CUP_O_TK_Soldier","CUP_O_TK_Soldier_Backpack","CUP_O_TK_Soldier_LAT","CUP_O_TK_Soldier_AT","CUP_O_TK_Sniper","CUP_O_TK_Sniper_KSVK","CUP_O_TK_Soldier_AKS_74_GOSHAWK","CUP_O_TK_Spotter","CUP_O_TK_Soldier_SL"];
	INS_Op4_medic = "CUP_O_TK_Medic";
	INS_Op4_Eng = "CUP_O_TK_Engineer";
	INS_Op4_pilot = ["CUP_O_TK_Pilot"];
	INS_Op4_Veh_Light = ["CUP_O_BRDM2_TKA","CUP_O_LR_MG_TKA","CUP_O_LR_SPG9_TKA","CUP_O_BTR60_TK","CUP_O_UAZ_MG_TKA","CUP_O_UAZ_AGS30_TKA","CUP_O_UAZ_SPG9_TKA","CUP_O_Ural_ZU23_TKA","CUP_O_BTR40_MG_TKA"];
	INS_Op4_Veh_Tracked = ["CUP_O_BMP2_ZU_TKA","CUP_O_BMP_HQ_TKA","CUP_O_T34_TKA","CUP_O_BMP1_TKA","CUP_O_BMP1P_TKA","CUP_O_BMP2_TKA","CUP_O_T72_TKA","CUP_O_T55_TK","CUP_O_M113_TKA","CUP_O_ZSU23_TK"];
	INS_Op4_Veh_Support = ["CUP_O_BMP2_AMB_TKA","CUP_O_LR_Ambulance_TKA","CUP_O_Ural_TKA","CUP_O_Ural_Reammo_TKA","CUP_O_Ural_Refuel_TKA","CUP_O_Ural_Repair_TKA"];
	INS_Op4_Veh_AA = ["CUP_O_ZSU23_TK"];
	INS_Op4_stat_weps = ["O_HMG_01_high_F","CUP_O_ZU23_TK","CUP_O_AGS_TK","CUP_O_2b14_82mm_TK","CUP_O_D30_TK","CUP_O_D30_AT_TK","CUP_O_SPG9_TK"];
	INS_Op4_fixedWing = ["CUP_B_SU34_LGB_CDF","CUP_I_SU34_LGB_AAF","CUP_O_Su25_TKA","CUP_O_Su25_Dyn_TKA","CUP_O_L39_TK"];
	INS_Op4_helis = ["CUP_O_UH1H_slick_TKA","CUP_O_Mi24_D_Dynamic_TK","CUP_O_Mi17_TK","O_Heli_Attack_02_black_F","CUP_AirVehicles_Ka50"];
	INS_civ_Veh_Car = ["CUP_C_Golf4_whiteblood_Civ","CUP_C_Golf4_random_Civ","CUP_C_Golf4_camo_Civ","CUP_C_Golf4_camodigital_Civ","CUP_C_Golf4_camodark_Civ","CUP_C_LR_Transport_CTK","CUP_C_Octavia_CIV","CUP_C_Datsun","CUP_C_Datsun_4seat","CUP_C_Datsun_Plain","CUP_C_Datsun_Covered","CUP_C_Skoda_White_CIV","CUP_C_Skoda_Green_CIV","CUP_C_Skoda_Red_CIV","CUP_C_Skoda_Blue_CIV","CUP_C_SUV_TK"];
	INS_civ_Veh_Utl = ["CUP_C_Ural_Civ_01","CUP_C_Ural_Open_Civ_01","CUP_C_Ural_Civ_02","CUP_C_Ural_Civ_03","CUP_C_Ural_Open_Civ_03","CUP_C_UAZ_Open_TK_CIV","CUP_C_UAZ_Unarmed_TK_CIV","C_Truck_02_covered_F","C_Truck_02_box_F","C_Van_01_box_F","C_Van_01_transport_F","C_Van_01_fuel_F"];
	INS_civlist = ["CUP_C_TK_Man_07_Waist","CUP_C_TK_Man_04","CUP_C_TK_Man_04_Jack","CUP_C_TK_Man_04_Waist","CUP_C_TK_Man_07","CUP_C_TK_Man_07_Coat","CUP_C_TK_Man_07_Waist","CUP_C_TK_Man_08","CUP_C_TK_Man_08_Jack","CUP_C_TK_Man_08_Waist","CUP_C_TK_Man_05_Coat","CUP_C_TK_Man_05_Jack","CUP_C_TK_Man_05_Waist","CUP_C_TK_Man_06_Coat","CUP_C_TK_Man_06_Jack","CUP_C_TK_Man_06_Waist","CUP_C_TK_Man_02","CUP_C_TK_Man_02_Jack","CUP_C_TK_Man_02_Waist","CUP_C_TK_Man_01_Waist","CUP_C_TK_Man_01_Coat","CUP_C_TK_Man_01_Jack","CUP_C_TK_Man_03_Coat","CUP_C_TK_Man_03_Jack","CUP_C_TK_Man_03_Waist"];//Takistani Civilians
	INS_CAS = "CUP_B_A10_AT_USA";
};

// CUP - CUP Armed Forces of the Russian Federation
if (_opposingArmies isEqualTo 16) then {
	INS_Op4_side = EAST;
	INS_men_list = ["CUP_O_RU_Soldier_AA_M_EMR","CUP_O_RU_Soldier_AA_M_EMR","CUP_O_RU_Soldier_HAT_M_EMR","CUP_O_RU_Soldier_HAT_M_EMR","CUP_O_RU_Soldier_AR_M_EMR","CUP_O_RU_Engineer_M_EMR","CUP_O_RU_Explosive_Specialist_M_EMR","CUP_O_RU_Soldier_GL_M_EMR","CUP_O_RU_Soldier_MG_M_EMR","CUP_O_RU_Soldier_Marksman_M_EMR","CUP_O_RU_Medic_M_EMR","CUP_O_RU_Officer_M_EMR","CUP_O_RU_Soldier_M_EMR","CUP_O_RU_Soldier_LAT_M_EMR","CUP_O_RU_Soldier_AT_M_EMR","CUP_O_RU_Soldier_Saiga_M_EMR","CUP_O_RU_Sniper_M_EMR","CUP_O_RU_Sniper_KSVK_M_EMR","CUP_O_RU_Spotter_M_EMR","CUP_O_RU_Soldier_SL_M_EMR","CUP_O_RU_Soldier_TL_M_EMR"];
	INS_Op4_medic = "CUP_O_RU_Medic_M_EMR";
	INS_Op4_Eng = "CUP_O_RU_Engineer_M_EMR";
	INS_Op4_pilot = ["CUP_O_RU_Pilot_M_EMR"];
	INS_Op4_Veh_Light = ["CUP_O_GAZ_Vodnik_BPPU_RU","CUP_O_GAZ_Vodnik_AGS_RU","CUP_O_GAZ_Vodnik_PK_RU","CUP_O_BTR90_RU","CUP_O_Ural_ZU23_RU","CUP_O_BTR60_Green_RU","CUP_O_BRDM2_RUS","CUP_O_BTR60_RU"];
	INS_Op4_Veh_Tracked = ["CUP_O_T72_RU","CUP_O_T90_RU","CUP_O_2S6_RU","CUP_O_2S6M_RU","CUP_O_BMP2_RU","CUP_O_BMP_HQ_RU","CUP_O_BMP3_RU"];
	INS_Op4_Veh_Support = ["CUP_O_Kamaz_Reammo_RU","CUP_O_Kamaz_Refuel_RU","CUP_O_Kamaz_Repair_RU","CUP_O_Ural_Reammo_RU","CUP_O_Ural_Refuel_RU","CUP_O_Ural_Repair_RU","CUP_O_GAZ_Vodnik_MedEvac_RU","CUP_O_BRDM2_HQ_RUS","CUP_O_BTR90_HQ_RU"];
	INS_Op4_Veh_AA = ["CUP_O_2S6_RU","CUP_O_2S6M_RU","CUP_O_Ural_ZU23_RU"];
	INS_Op4_stat_weps = ["O_HMG_01_high_F","CUP_O_ZU23_RU","CUP_O_AGS_RU","CUP_O_D30_RU","CUP_O_D30_AT_RU","CUP_O_KORD_high_RU","CUP_O_KORD_RU","CUP_O_Metis_RU","CUP_O_2b14_82mm_RU"];
	INS_Op4_fixedWing = ["CUP_O_Su25_Dyn_RU","CUP_O_SU34_RU","CUP_I_SU34_AAF","CUP_O_Su25_Dyn_CSAT_T","CUP_O_Su25_Dyn_SLA","CUP_O_SU34_SLA"];
	INS_Op4_helis = ["O_Heli_Attack_02_black_F","CUP_O_Ka60_Grey_RU","CUP_O_Mi24_P_Dynamic_RU","CUP_O_Mi24_V_Dynamic_RU","CUP_O_Mi8_RU","CUP_O_Ka52_RU","CUP_O_Ka50_DL_RU"];
	INS_civ_Veh_Car = ["C_Quadbike_01_F","C_Hatchback_01_F","C_Hatchback_01_sport_F","C_Offroad_01_F","C_SUV_01_F","CUP_C_Datsun","CUP_C_Datsun_4seat","CUP_C_Golf4_black_Civ","CUP_C_Golf4_blue_Civ","CUP_C_Golf4_camo_Civ","CUP_C_Golf4_camodark_Civ","CUP_C_Golf4_camodigital_Civ","CUP_C_Golf4_green_Civ","CUP_C_Golf4_kitty_Civ","CUP_C_Golf4_crowe_Civ","CUP_C_Golf4_random_Civ","CUP_C_Golf4_reptile_Civ","CUP_C_Golf4_white_Civ","CUP_C_Golf4_whiteblood_Civ","CUP_C_Golf4_yellow_Civ","CUP_C_Octavia_CIV","CUP_C_Skoda_Blue_CIV","CUP_C_Skoda_Green_CIV","CUP_C_Skoda_Red_CIV","CUP_C_Skoda_White_CIV","CUP_C_S1203_Militia_CIV","CUP_C_Datsun_Covered","CUP_C_Datsun_Plain","CUP_C_Datsun_Tubeframe","CUP_C_Golf4_red_Civ","CUP_C_Lada_White_CIV","CUP_LADA_LM_CIV","CUP_C_Lada_Red_CIV","CUP_C_SUV_CIV"];
	INS_civ_Veh_Utl = ["C_Truck_02_fuel_F","C_Truck_02_box_F","C_Truck_02_transport_F","C_Truck_02_covered_F","C_Van_01_fuel_F","C_Offroad_01_repair_F","C_Van_01_transport_F","C_Van_01_box_F","CUP_C_Tractor_CIV","CUP_C_Tractor_Old_CIV","CUP_C_Ural_Civ_03","CUP_C_Ural_Open_Civ_03","CUP_C_Ural_Open_Civ_01","CUP_C_Ural_Civ_02","CUP_C_Ural_Open_Civ_02"];
	INS_civlist = ["CUP_C_R_Assistant_01","CUP_C_R_Citizen_02","CUP_C_R_Citizen_01","CUP_C_R_Citizen_04","CUP_C_R_Citizen_03","CUP_C_R_Doctor_01","CUP_C_R_Functionary_01","CUP_C_R_Functionary_02","CUP_C_R_Worker_05","CUP_C_R_Mechanic_02","CUP_C_R_Mechanic_03","CUP_C_R_Mechanic_01","CUP_C_R_Profiteer_02","CUP_C_R_Profiteer_03","CUP_C_R_Profiteer_01","CUP_C_R_Profiteer_04","CUP_C_R_Rocker_01","CUP_C_R_Rocker_03","CUP_C_R_Rocker_02","CUP_C_R_Rocker_04","CUP_C_R_Schoolteacher_01","CUP_C_R_Villager_01","CUP_C_R_Villager_04","CUP_C_R_Villager_02","CUP_C_R_Villager_03","CUP_C_R_Woodlander_01","CUP_C_R_Woodlander_02","CUP_C_R_Woodlander_03","CUP_C_R_Woodlander_04","CUP_C_R_Worker_03","CUP_C_R_Worker_04","CUP_C_R_Worker_02","CUP_C_R_Worker_01"];
	INS_CAS = "CUP_B_A10_AT_USA";
};

// Massi Middle Eastern Warfare CSAT Army (EAST)
if (_opposingArmies isEqualTo 17) then {
	INS_Op4_side = EAST;
	INS_men_list = ["O_mas_irahd_Army_F","O_mas_irahd_Army_SL_F","O_mas_irahd_Army_LITE_F","O_mas_irahd_Army_OFF_F","O_mas_irahd_Army_EXP_F","O_mas_irahd_Army_GL_F","O_mas_irahd_Army_TL_F","O_mas_irahd_Army_MG_F","O_mas_irahd_Army_AR_F","O_mas_irahd_Army_LAT_F","O_mas_irahd_Army_AT_F","O_mas_irahd_Army_AA_F","O_mas_irahd_Army_M_F","O_mas_irahd_Army_MEDIC_F","O_mas_irahd_Army_ENG_F","O_mas_irahd_Army_amort_F","O_mas_irahd_Army_smort_F","O_mas_irahd_SOF_F","O_mas_irahd_SOF_SL_F","O_mas_irahd_SOF_EXP_F","O_mas_irahd_SOF_MEDIC_F","O_mas_irahd_SOF_M_F","O_mas_irahd_SOF_MO_F"];
	INS_Op4_medic = "O_mas_irahd_Army_MEDIC_F";
	INS_Op4_Eng = "O_mas_irahd_Army_ENG_F";
	INS_Op4_pilot = ["O_mas_irahd_Army_Pilot_F"];
	INS_Op4_Veh_Light = ["O_mas_BRDM2","O_mas_BTR60","O_mas_cars_UAZ_AGS30","O_mas_cars_UAZ_MG","O_mas_cars_UAZ_Med","O_mas_cars_UAZ_SPG9","O_mas_cars_Ural_ZU23"];
	INS_Op4_Veh_Tracked = ["O_mas_T55_OPF_01","O_mas_T72_OPF_01","O_mas_T72B_OPF_01","O_mas_T72B_Early_OPF_01","O_mas_T72BM_OPF_01","O_mas_T90_OPF_01","O_mas_ZSU_OPF_01","O_mas_BMP1_OPF_01","O_mas_BMP1P_OPF_01","O_mas_BMP2_OPF_01","O_mas_BMP2_HQ_OPF_01"];
	INS_Op4_Veh_AA = ["O_mas_ZSU_OPF_01"];
	INS_Op4_Veh_Support = ["O_mas_cars_Ural_BM21","O_mas_cars_Ural","O_mas_cars_Ural_open","O_mas_cars_Ural_ammo","O_mas_cars_Ural_fuel","O_mas_cars_Ural_repair"];//"O_mas_cars_UAZ_Med"
	INS_Op4_stat_weps = ["O_mas_DSHKM_AAF","O_mas_ZU23_AAF","O_mas_AGS_AAF","O_mas_DSHkM_Mini_TriPod","O_mas_KORD_AAF","O_mas_KORD_high_AAF","O_mas_Metis_AAF","O_mas_SPG9_AAF","O_mas_Igla_AA_pod_AAF","O_mas_2b14_82mm_AAF","O_mas_D30_AAF","O_mas_D30_AT_AAF"];
	INS_Op4_fixedWing = ["I_Plane_Fighter_03_AA_F","I_Plane_Fighter_03_CAS_F","O_Plane_CAS_02_F"];
	INS_Op4_helis = ["O_mas_MI24V","O_mas_MI8","O_mas_MI8MTV"];
	INS_civ_Veh_Car = ["C_Hatchback_01_F","C_Offroad_01_F","C_Quadbike_01_F","C_SUV_01_F"];
	INS_civ_Veh_Utl = ["C_Van_01_box_F","C_Van_01_transport_F","C_Van_01_fuel_F"];
	INS_civlist = ["C_mas_med_1","C_mas_med_2","C_mas_med_3","C_mas_med_4","C_mas_med_5","C_mas_med_6","C_mas_med_7","C_mas_med_8","C_mas_med_9","C_mas_med_10"];//Faction - mas_med_cim
};

// Massi Takistan Army (EAST)
if (_opposingArmies isEqualTo 18) then {
	INS_Op4_side = EAST;
	INS_men_list = ["O_mas_med_Armyhd_F","O_mas_med_Armyhd_SL_F","O_mas_med_Armyhd_OFF_F","O_mas_med_Armyhd_EXP_F","O_mas_med_Armyhd_GL_F","O_mas_med_Armyhd_TL_F","O_mas_med_Armyhd_MG_F","O_mas_med_Armyhd_AR_F","O_mas_med_Armyhd_LAT_F","O_mas_med_Armyhd_AT_F","O_mas_med_Armyhd_AA_F","O_mas_med_Armyhd_M_F","O_mas_med_Armyhd_MEDIC_F","O_mas_med_Armyhd_ENG_F","O_mas_med_Armyhd_amort_F","O_mas_med_Armyhd_smort_F","O_mas_med_ArmyhdSF_F","O_mas_med_ArmyhdSF_EXP_F","O_mas_med_ArmyhdSF_TL_F","O_mas_med_ArmyhdSF_M_F","O_mas_med_ArmyhdSF_MEDIC_F"];
	INS_Op4_medic = "O_mas_med_Armyhd_MEDIC_F";
	INS_Op4_Eng = "O_mas_med_Armyhd_ENG_F";
	INS_Op4_pilot = ["O_mas_med_Army_Pilot_F"];
	INS_Op4_Veh_Light = ["O_mas_BRDM2","O_mas_BTR60","O_mas_cars_UAZ_AGS30","O_mas_cars_UAZ_MG","O_mas_cars_UAZ_Med","O_mas_cars_UAZ_SPG9","O_mas_cars_Ural_ZU23"];
	INS_Op4_Veh_Tracked = ["O_mas_T55_OPF_01","O_mas_T72_OPF_01","O_mas_T72B_OPF_01","O_mas_T72B_Early_OPF_01","O_mas_T72BM_OPF_01","O_mas_T90_OPF_01","O_mas_ZSU_OPF_01","O_mas_BMP1_OPF_01","O_mas_BMP1P_OPF_01","O_mas_BMP2_OPF_01","O_mas_BMP2_HQ_OPF_01"];
	INS_Op4_Veh_AA = ["O_mas_ZSU_OPF_01"];
	INS_Op4_Veh_Support = ["O_mas_cars_Ural_BM21","O_mas_cars_Ural","O_mas_cars_Ural_open","O_mas_cars_Ural_ammo","O_mas_cars_Ural_fuel","O_mas_cars_Ural_repair"];
	INS_Op4_stat_weps = ["O_mas_DSHKM_AAF","O_mas_ZU23_AAF","O_mas_AGS_AAF","O_mas_DSHkM_Mini_TriPod","O_mas_KORD_AAF","O_mas_KORD_high_AAF","O_mas_Metis_AAF","O_mas_SPG9_AAF","O_mas_Igla_AA_pod_AAF","O_mas_2b14_82mm_AAF","O_mas_D30_AAF","O_mas_D30_AT_AAF"];
	INS_Op4_fixedWing = ["I_Plane_Fighter_03_AA_F","I_Plane_Fighter_03_CAS_F","O_Plane_CAS_02_F"];
	INS_Op4_helis = ["O_mas_MI24V","O_mas_MI8","O_mas_MI8MTV"];
	INS_civ_Veh_Car = ["C_Hatchback_01_F","C_Offroad_01_F","C_Quadbike_01_F","C_SUV_01_F"];
	INS_civ_Veh_Utl = ["C_Van_01_box_F","C_Van_01_transport_F","C_Van_01_fuel_F"];
	INS_civlist = ["C_mas_med_Civil_1_1_F","C_mas_med_Civil_1_2_F","C_mas_med_Civil_1_3_F","C_mas_med_Civil_1_4_F","C_mas_med_Civil_2_1_F","C_mas_med_Civil_2_2_F","C_mas_med_Civil_2_3_F","C_mas_med_Civil_2_4_F","C_mas_med_Civil_doc_F","C_mas_med_Civil_fun_F"];//Faction - mas_med_civ
};

// Massi African REBEL ARMY UNITS and RUSSIAN SPETSNAZ ADVISORS (EAST)
if (_opposingArmies isEqualTo 19) then {
	INS_Op4_side = EAST;
	INS_men_list = ["O_mas_afr_Soldier_F","O_mas_afr_Soldier_GL_F","O_mas_afr_soldier_AR_F","O_mas_afr_soldier_MG_F","O_mas_afr_Soldier_lite_F","O_mas_afr_Soldier_off_F","O_mas_afr_Soldier_SL_F","O_mas_afr_soldier_M_F","O_mas_afr_soldier_LAT_F","O_mas_afr_soldier_LAA_F","O_mas_afr_medic_F","O_mas_afr_soldier_repair_F","O_mas_afr_soldier_exp_F","O_mas_afr_rusadv1_F","O_mas_afr_rusadv2_F","O_mas_afr_rusadv3_F"];
	INS_Op4_medic = "O_mas_afr_medic_F";
	INS_Op4_Eng = "O_mas_afr_soldier_repair_F";
	INS_Op4_pilot = ["O_helipilot_F"];
	INS_Op4_Veh_Light = ["O_mas_BRDM2","O_mas_BTR60","O_mas_cars_UAZ_AGS30","O_mas_cars_UAZ_MG","O_mas_cars_UAZ_Med","O_mas_cars_UAZ_SPG9","O_mas_cars_Ural_ZU23"];
	INS_Op4_Veh_Tracked = ["O_mas_T55_OPF_01","O_mas_T72_OPF_01","O_mas_T72B_OPF_01","O_mas_T72B_Early_OPF_01","O_mas_T72BM_OPF_01","O_mas_T90_OPF_01","O_mas_ZSU_OPF_01","O_mas_BMP1_OPF_01","O_mas_BMP1P_OPF_01","O_mas_BMP2_OPF_01","O_mas_BMP2_HQ_OPF_01"];
	INS_Op4_Veh_AA = ["O_mas_ZSU_OPF_01"];
	INS_Op4_Veh_Support = ["O_mas_cars_Ural_BM21","O_mas_cars_Ural","O_mas_cars_Ural_open","O_mas_cars_Ural_ammo","O_mas_cars_Ural_fuel","O_mas_cars_Ural_repair"];
	INS_Op4_stat_weps = ["O_mas_DSHKM_AAF","O_mas_ZU23_AAF","O_mas_AGS_AAF","O_mas_DSHkM_Mini_TriPod","O_mas_KORD_AAF","O_mas_KORD_high_AAF","O_mas_Metis_AAF","O_mas_SPG9_AAF","O_mas_Igla_AA_pod_AAF","O_mas_2b14_82mm_AAF","O_mas_D30_AAF","O_mas_D30_AT_AAF"];
	INS_Op4_fixedWing = ["I_Plane_Fighter_03_AA_F","I_Plane_Fighter_03_CAS_F","O_Plane_CAS_02_F"];
	INS_Op4_helis = ["O_mas_MI24V","O_mas_MI8","O_mas_MI8MTV"];
	INS_civlist = ["C_mas_afr_1","C_mas_afr_2","C_mas_afr_3","C_mas_afr_4","C_mas_afr_5","C_mas_afr_6","C_mas_afr_7","C_mas_afr_8","C_mas_afr_9","C_mas_afr_10"];// Masi African Civilians
	INS_civ_Veh_Car = ["C_Hatchback_01_F","C_Offroad_01_F","C_Quadbike_01_F","C_SUV_01_F"];
	INS_civ_Veh_Utl = ["C_Van_01_box_F","C_Van_01_transport_F","C_Van_01_fuel_F"];
};

// OPTRE - Insurrectionists
if (_opposingArmies isEqualTo 20) then {
	INS_Op4_side = EAST;
	INS_men_list = ["OPTRE_Ins_URF_AA_Specialist","OPTRE_Ins_URF_Assist_Autorifleman","OPTRE_Ins_URF_Autorifleman","OPTRE_Ins_URF_AT_Specialist","OPTRE_Ins_URF_Breacher","OPTRE_Ins_URF_Crewman","OPTRE_Ins_URF_Demolitions","OPTRE_Ins_URF_Marksman","OPTRE_Ins_URF_Grenadier","OPTRE_Ins_URF_Observer","OPTRE_Ins_URF_Officer","OPTRE_Ins_URF_Radioman","OPTRE_Ins_URF_Rifleman_AT","OPTRE_Ins_URF_Rifleman_BR","OPTRE_Ins_URF_Rifleman_AR","OPTRE_Ins_URF_Rifleman_Light","OPTRE_Ins_URF_Sniper","OPTRE_Ins_URF_SquadLead","OPTRE_Ins_URF_TeamLead"];
	INS_Op4_medic = "OPTRE_Ins_URF_Medic";
	INS_Op4_Eng = "OPTRE_Ins_URF_Engineer";
	INS_Op4_pilot = ["OPTRE_Ins_URF_Pilot"];
	INS_Op4_Veh_Light = ["OPTRE_M12_LRV_Ins","OPTRE_M12_FAV_Ins","OPTRE_M12_FAV_APC"];
	INS_Op4_Veh_Tracked = ["OPTRE_M12A1_LRV_Ins","OPTRE_M12R_AA_Ins"];
	INS_Op4_Veh_Support = ["O_Truck_03_ammo_F","O_Truck_03_repair_F","O_Truck_02_Ammo_F","O_Truck_02_fuel_F","O_Truck_02_box_F","O_Truck_02_medical_F","O_Truck_03_device_F"];
	INS_Op4_Veh_AA = ["OPTRE_M12R_AA_Ins"];
	INS_Op4_helis = ["OPTRE_Pelican_armed_ins","OPTRE_UNSC_hornet_ins"];
	INS_Op4_fixedWing = ["I_Plane_Fighter_03_AA_F","I_Plane_Fighter_03_CAS_F","O_Plane_CAS_02_F","I_Plane_Fighter_04_F"];
	INS_Op4_stat_weps = ["OPTRE_Static_M41_Ins","O_G_Mortar_01_F","OPTRE_Static_AA_Ins","OPTRE_Static_FG75","OPTRE_Static_ATGM_Ins","O_GMG_01_high_F","O_HMG_01_high_F"];
	INS_civlist = ["C_man_p_beggar_F","C_man_1","C_man_polo_1_F","C_man_polo_2_F","C_man_polo_3_F","C_man_polo_4_F","C_man_polo_5_F","C_man_polo_6_F","C_man_shorts_1_F","C_man_1_1_F","C_man_1_2_F","C_man_1_3_F","C_man_p_fugitive_F","C_man_p_shorts_1_F","C_man_hunter_1_F","C_man_shorts_2_F","C_man_shorts_3_F","C_man_shorts_4_F"];
	INS_civ_Veh_Car = ["OPTRE_Genet_Black","OPTRE_Genet_Blue","OPTRE_Genet_Green","OPTRE_Genet_Orange","OPTRE_Genet_Yellow","OPTRE_Genet_Purple","OPTRE_Genet"];
	INS_civ_Veh_Utl = ["C_Truck_02_fuel_F","C_Truck_02_box_F","C_Truck_02_transport_F","C_Van_01_box_F","C_Van_01_transport_F","C_Van_01_fuel_F"];
};

// IFA3 - Desert US Army
if (_opposingArmies isEqualTo 21) then {
	INS_Op4_side = RESISTANCE;
	INS_men_list = ["LIB_US_NAC_AT_soldier","LIB_US_NAC_captain","LIB_US_NAC_engineer","LIB_US_NAC_first_lieutenant","LIB_US_NAC_grenadier","LIB_US_NAC_grenadier","LIB_US_NAC_mgunner","LIB_US_NAC_medic","LIB_US_NAC_radioman","LIB_US_NAC_corporal","LIB_US_NAC_FC_rifleman","LIB_US_NAC_rifleman","LIB_US_NAC_second_lieutenant","LIB_US_NAC_sniper","LIB_US_NAC_smgunner"];
	INS_Op4_medic = "LIB_US_NAC_medic";
	INS_Op4_Eng = "LIB_US_NAC_engineer";
	INS_Op4_pilot = ["LIB_US_pilot"];
	INS_Op4_Veh_Light = ["LIB_US_NAC_Willys_MB","LIB_US_GMC_Tent","LIB_US_GMC_Open","LIB_US_Scout_M3_FFV","LIB_US_Willys_MB"];
	INS_Op4_Veh_Tracked = ["LIB_US_NAC_M3_Halftrack","LIB_US_NAC_M4A3_75","LIB_M4A4_FIREFLY","LIB_M4A3_76_HVSS","LIB_M5A1_Stuart"];
	INS_Op4_Veh_Support = ["LIB_US_GMC_Ambulance","LIB_US_GMC_Ammo","LIB_US_GMC_Fuel","LIB_US_GMC_Parm"];
	INS_Op4_Veh_AA = ["LIB_61k"];
	INS_Op4_helis = [];
	INS_Op4_fixedWing = ["LIB_US_NAC_P39","LIB_US_NAC_P39_2","LIB_US_NAC_P39_2","LIB_US_P39","LIB_US_P39_2","LIB_P47","LIB_RAF_P39","LIB_RAAF_P39"];
	INS_Op4_stat_weps = ["LIB_Zis3","lib_maxim_m30_base","LIB_61k"];
	INS_civlist = ["LIB_CIV_Assistant","LIB_CIV_Assistant_2","LIB_CIV_Citizen_1","LIB_CIV_Citizen_2","LIB_CIV_Citizen_3","LIB_CIV_Citizen_4","LIB_CIV_Citizen_5","LIB_CIV_Citizen_6","LIB_CIV_Citizen_7","LIB_CIV_Citizen_8","LIB_CIV_Doctor","LIB_CIV_Functionary_4","LIB_CIV_Functionary_1","LIB_CIV_Functionary_2","LIB_CIV_Functionary_3","LIB_CIV_Priest","LIB_CIV_Rocker","LIB_CIV_SchoolTeacher","LIB_CIV_SchoolTeacher_2","LIB_CIV_Villager_1","LIB_CIV_Villager_4","LIB_CIV_Villager_2","LIB_CIV_Villager_3","LIB_CIV_Woodlander_1","LIB_CIV_Woodlander_2","LIB_CIV_Woodlander_3","LIB_CIV_Woodlander_4","LIB_CIV_Worker_3","LIB_CIV_Worker_4","LIB_CIV_Worker_1","LIB_CIV_Worker_2"];
	INS_civ_Veh_Car = ["LIB_GazM1","LIB_GazM1_SOV","LIB_GazM1_FFI","LIB_Zis5v_w","LIB_Zis5v"];
	INS_civ_Veh_Utl = ["LIB_Zis6_Parm","LIB_Zis5v_Fuel","LIB_Zis5v_Med"];
	INS_CAS = "LIB_DAK_Ju87_2";
};

// UNSUNG - VC
if (_opposingArmies in [22,23]) then {
	INS_Op4_side = EAST;
	INS_men_list = ["uns_men_VC_mainforce_68_AT","uns_men_VC_mainforce_68_AS1","uns_men_VC_mainforce_68_HMG","uns_men_VC_mainforce_68_nco","uns_men_VC_mainforce_68_MED","uns_men_VC_mainforce_68_AS5","uns_men_VC_mainforce_68_RTO","uns_men_VC_mainforce_68_Rmrk","uns_men_VC_mainforce_68_AT2","uns_men_VC_mainforce_68_off","uns_men_VC_mainforce_68_Rmg","uns_men_VC_mainforce_68_Rmed"];
	INS_Op4_medic = "uns_men_VC_mainforce_68_MED";
	INS_Op4_Eng = "uns_men_VC_mainforce_68_SAP";
	INS_Op4_pilot = ["uns_nvaf_pilot1"];
	INS_Op4_Veh_Light = ["uns_Type55_M40","uns_Type55_RR57","uns_Type55_MG","uns_Type55_LMG"];
	INS_Op4_Veh_Tracked = ["uns_ot34_85_nva","uns_pt76","uns_t34_85_nva","uns_to55_nva","uns_Type63_mg","uns_ZSU57_NVA"];
	INS_Op4_Veh_Support = ["uns_zil157","uns_nvatruck","uns_nvatruck_repair","uns_nvatruck_reammo","uns_nvatruck_refuel","uns_Type63_amb"];
	INS_Op4_Veh_AA = ["uns_ZSU_NVA","uns_nvatruck_zu23","uns_nvatruck_zpu"];
	INS_Op4_stat_weps = ["uns_ZU23_NVA","uns_dshk_twin_NVA","uns_dshk_high_NVA","uns_KS19_NVA","uns_mg42_low_NVA","uns_S60_NVA","uns_Type36_57mm_NVA"];
	INS_Op4_fixedWing = ["uns_mig21_MR","uns_Mig21_CAP","uns_an2_bmb","uns_an2_cas"];
	INS_Op4_helis = ["uns_Mi8TV_VPAF"];
	INS_civ_Veh_Car = ["C_Tractor_01_F"];
	INS_civ_Veh_Utl = ["C_Van_01_transport_F"];
	INS_civlist = ["uns_civilian1","uns_civilian1_b1","uns_civilian1_b2","uns_civilian1_b3","uns_civilian2","uns_civilian2_b1","uns_civilian2_b2","uns_civilian2_b3","uns_civilian3","uns_civilian3_b1","uns_civilian3_b2","uns_civilian3_b3","uns_civilian4","uns_civilian4_b1","uns_civilian4_b2","uns_civilian4_b3"];
	INS_CAS = "uns_A1J_HCAS";
};

if (!isServer && hasInterface) exitWith {};

private _gridMarkerUnitPools = {
	// Classes used by grid system //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	params ["_faction"];
	//diag_log format ["RESULT %1",_faction];
	private ["_InfPool","_ArmPool","_MotPool","_ACHPool","_CHPool","_uavPool","_stPool","_shipPool","_diverPool","_crewPool","_heliCrew","_issueNVG"];
	switch (_faction) do {
		case 0: {// EAST CSAT FACTION
			_InfPool=	["O_SoldierU_SL_F","O_Soldier_GL_F","O_soldierU_repair_F","O_soldierU_medic_F","O_sniper_F","O_Soldier_A_F","O_Soldier_AA_F","O_Soldier_AA_F","O_Soldier_AAA_F","O_Soldier_AAR_F","O_Soldier_AAT_F","O_Soldier_AR_F","O_Soldier_AT_F","O_soldier_exp_F","O_Soldier_F","O_engineer_F","O_engineer_U_F","O_medic_F","O_recon_exp_F","O_recon_F","O_recon_JTAC_F","O_recon_LAT_F","O_recon_M_F","O_recon_medic_F","O_recon_TL_F","O_HeavyGunner_F","O_Soldier_HAT_F","O_Soldier_AHAT_F"];
			_ArmPool=	["O_APC_Tracked_02_AA_F","O_APC_Tracked_02_cannon_F","O_APC_Wheeled_02_rcws_v2_F","O_MBT_02_arty_F","O_MBT_02_cannon_F"];
			_MotPool=	["O_Truck_02_covered_F","O_MRAP_02_gmg_F","O_MRAP_02_hmg_F","O_G_Offroad_01_armed_F","O_MBT_04_cannon_F"];
			_ACHPool=	["O_Heli_Attack_02_black_F","O_Heli_Attack_02_F"];
			_CHPool=	["O_Heli_Light_02_F","O_Heli_Light_02_unarmed_F","O_Heli_Transport_04_covered_F"];//"O_Heli_Transport_04_bench_F"
			_uavPool=	["O_UAV_01_F","O_UAV_02_CAS_F","O_UGV_01_rcws_F"];
			_stPool=	["O_Mortar_01_F","O_Mortar_01_F","O_static_AT_F","O_static_AA_F","O_GMG_01_high_F","O_HMG_01_high_F"];
			_shipPool=	["O_Boat_Armed_01_hmg_F","O_Boat_Transport_01_F"];
			_diverPool=	["O_diver_exp_F","O_diver_F","O_diver_TL_F"];
			_crewPool=	["O_crew_F"];
			_heliCrew=	["O_helicrew_F","O_helipilot_F"];
			_issueNVG= true;// true if faction can have NVGs else false
		};
		case 1: {// INDEPENDENT AAF FACTION
			_InfPool=	["I_engineer_F","I_Soldier_A_F","I_Soldier_AA_F","I_Soldier_AA_F","I_Soldier_AAA_F","I_Soldier_AAR_F","I_Soldier_AAT_F","I_Soldier_AR_F","I_Soldier_AT_F","I_Soldier_exp_F","I_soldier_F","I_Soldier_GL_F","I_Soldier_repair_F","I_Spotter_F","I_Sniper_F","I_Soldier_LAT2_F"];
			_ArmPool=	["I_APC_Wheeled_03_cannon_F","I_APC_tracked_03_cannon_F","I_MBT_03_cannon_F","I_LT_01_scout_F","I_LT_01_cannon_F","I_LT_01_AA_F"];
			_MotPool=	["I_MRAP_03_gmg_F","I_MRAP_03_hmg_F","I_Truck_02_transport_F","I_G_Offroad_01_armed_F"];//"I_MRAP_03_F"
			_ACHPool=	["I_Heli_light_03_dynamicLoadout_F"];
			_CHPool=	["I_Heli_Transport_02_F","I_Heli_light_03_unarmed_F","O_Heli_Transport_04_covered_F"];
			_uavPool=	["I_UAV_01_F","I_UAV_02_CAS_F","I_UGV_01_rcws_F"];
			_stPool=	["I_Mortar_01_F","I_GMG_01_high_F","I_HMG_01_high_F","I_HMG_01_F","I_static_AT_F","I_static_AA_F","I_GMG_01_F","I_HMG_02_F","I_HMG_02_high_F"];
			_shipPool=	["I_Boat_Transport_01_F","I_Boat_Armed_01_minigun_F"];
			_diverPool=	["I_diver_exp_F","I_diver_F","I_diver_TL_F"];
			_crewPool=	["I_crew_F"];
			_heliCrew=	["I_helicrew_F","I_helipilot_F"];
			_issueNVG= true;
		};
		case 2: {// INDEPENDENT FIA FACTION
			_InfPool=	["I_G_Soldier_F","I_G_Soldier_lite_F","I_G_Soldier_SL_F","I_G_Soldier_TL_F","I_G_Soldier_AR_F","I_G_medic_F","I_G_engineer_F","I_G_Soldier_exp_F","I_G_Soldier_GL_F","I_G_Soldier_M_F","I_G_Soldier_LAT_F","I_G_Soldier_A_F","I_G_officer_F","I_G_Sharpshooter_F","I_G_Soldier_LAT2_F"];
			_ArmPool=	["I_APC_tracked_03_cannon_F"];
			_MotPool=	["I_G_Offroad_01_armed_F","O_G_Offroad_01_armed_F","O_G_Offroad_01_AT_F","I_G_Offroad_01_AT_F","I_C_Offroad_02_AT_F","I_C_Offroad_02_LMG_F"];
			_ACHPool=	["I_Heli_light_03_dynamicLoadout_F"];
			_CHPool=	["I_Heli_Transport_02_F","I_Heli_light_03_unarmed_F","O_Heli_Transport_04_covered_F"];
			_uavPool=	[];
			_stPool=	["I_G_Mortar_01_F","I_GMG_01_high_F","I_HMG_01_high_F","I_HMG_01_F","I_static_AT_F","I_static_AA_F","I_GMG_01_F","I_HMG_02_F","I_HMG_02_high_F"];
			_shipPool=	["I_Boat_Transport_01_F","I_G_Boat_Transport_01_F","I_Boat_Armed_01_minigun_F"];
			_diverPool=	["I_diver_exp_F","I_diver_F","I_diver_TL_F"];
			_crewPool=	["I_G_engineer_F"];
			_heliCrew=	["I_G_Soldier_SL_F","I_G_Soldier_F","I_G_Soldier_AR_F","I_G_medic_F","I_G_Soldier_LAT_F","I_G_Soldier_GL_F"];
			_issueNVG= false;
		};
		case 3: {// EAST CSAT Pacific FACTION
			_InfPool=	["O_T_Soldier_A_F","O_T_Soldier_AAR_F","O_T_Support_AMG_F","O_T_Support_AMort_F","O_T_Soldier_AAA_F","O_T_Soldier_AAT_F","O_T_Soldier_AR_F","O_T_Medic_F","O_T_Crew_F","O_T_Engineer_F","O_T_Soldier_Exp_F","O_T_Soldier_GL_F","O_T_Support_GMG_F","O_T_Support_MG_F","O_T_Support_Mort_F","O_T_Soldier_M_F","O_T_Soldier_AA_F","O_T_Soldier_AA_F","O_T_Soldier_AT_F","O_T_Officer_F","O_T_Soldier_PG_F","O_T_Soldier_Repair_F","O_T_Soldier_F","O_T_Soldier_LAT_F","O_T_Soldier_SL_F","O_T_Soldier_TL_F","O_T_Soldier_UAV_F","O_T_Recon_Exp_F","O_T_Recon_JTAC_F","O_T_Recon_M_F","O_T_Recon_Medic_F","O_T_Recon_F","O_T_Recon_LAT_F","O_T_Recon_TL_F","O_T_Sniper_F","O_T_Spotter_F","O_T_ghillie_tna_F","O_V_Soldier_ghex_F","O_V_Soldier_TL_ghex_F","O_V_Soldier_Exp_ghex_F","O_V_Soldier_Medic_ghex_F","O_V_Soldier_M_ghex_F","O_V_Soldier_LAT_ghex_F","O_V_Soldier_JTAC_ghex_F","O_T_Soldier_HAT_F","O_T_Soldier_AHAT_F"];
			_ArmPool=	["O_T_MBT_02_cannon_ghex_F","O_T_APC_Tracked_02_cannon_ghex_F","O_T_APC_Tracked_02_AA_ghex_F","O_T_MBT_04_command_F","O_T_MBT_04_cannon_F","O_T_MBT_02_railgun_ghex_F"];
			_MotPool=	["O_T_MRAP_02_hmg_ghex_F","O_T_MRAP_02_gmg_ghex_F","O_T_LSV_02_armed_F","O_G_Offroad_01_armed_F","O_T_APC_Wheeled_02_rcws_v2_ghex_F"];
			_ACHPool=	["O_Heli_Attack_02_black_F","O_Heli_Attack_02_F"];
			_CHPool=	["O_Heli_Light_02_F","O_Heli_Light_02_unarmed_F","O_Heli_Transport_04_covered_F"];//"O_Heli_Transport_04_bench_F"
			_uavPool=	["O_T_UAV_04_CAS_F","O_UAV_01_F","O_T_UGV_01_rcws_ghex_F"];
			_stPool=	["B_T_HMG_01_F","O_GMG_01_high_F","O_HMG_01_high_F","O_static_AT_F","O_static_AA_F","O_GMG_01_F","O_G_Mortar_01_F"];
			_shipPool=	["O_T_Boat_Transport_01_F","O_T_Boat_Armed_01_hmg_F"];
			_diverPool=	["O_T_Diver_Exp_F","O_T_Diver_TL_F","O_T_Diver_F"];
			_crewPool=	["O_T_Crew_F"];
			_heliCrew=	["O_T_Helicrew_F","O_T_Helipilot_F"];
			_issueNVG= false;
		};
		case 4: {// INDEPENDENT Synikat FACTION
			_InfPool=	["I_C_Soldier_Para_7_F","I_C_Soldier_Para_2_F","I_C_Soldier_Para_3_F","I_C_Soldier_Para_4_F","I_C_Soldier_Para_6_F","I_C_Soldier_Para_8_F","I_C_Soldier_Para_1_F","I_C_Soldier_Para_5_F","I_C_Soldier_Bandit_7_F","I_C_Soldier_Bandit_3_F","I_C_Soldier_Bandit_2_F","I_C_Soldier_Bandit_5_F","I_C_Soldier_Bandit_6_F","I_C_Soldier_Bandit_1_F","I_C_Soldier_Bandit_8_F","I_C_Soldier_Bandit_4_F"];
			_ArmPool=	["I_APC_tracked_03_cannon_F"];
			_MotPool=	["I_G_Offroad_01_armed_F","O_G_Offroad_01_armed_F","I_C_Offroad_02_AT_F","I_C_Offroad_02_LMG_F","I_G_Offroad_01_AT_F","O_G_Offroad_01_AT_F"];
			_ACHPool=	["I_Heli_light_03_dynamicLoadout_F"];
			_CHPool=	["I_Heli_Transport_02_F","I_Heli_light_03_unarmed_F","I_C_Heli_Light_01_civil_F"];
			_uavPool=	[];
			_stPool=	["I_G_Mortar_01_F","I_GMG_01_high_F","I_HMG_01_high_F","I_HMG_01_F","I_static_AT_F","I_static_AA_F","I_GMG_01_F","I_HMG_02_F","I_HMG_02_high_F"];
			_shipPool=	["I_C_Boat_Transport_02_F","I_C_Boat_Transport_01_F","I_Boat_Armed_01_minigun_F"];
			_diverPool=	["I_diver_exp_F","I_diver_F","I_diver_TL_F"];
			_crewPool=	["I_C_Soldier_Para_8_F"];
			_heliCrew=	["I_C_Pilot_F","I_C_Helipilot_F"];
			_issueNVG= false;
		};
		case 5: {// INDEPENDENT Livonian Defense Force
			_InfPool=	["I_E_Soldier_A_F","I_E_Soldier_AAR_F","I_E_Soldier_AAA_F","I_E_Soldier_AAT_F","I_E_Soldier_AR_F","I_E_Soldier_CBRN_F","I_E_Medic_F","I_E_Engineer_F","I_E_Soldier_Exp_F","I_E_Soldier_GL_F","I_E_soldier_M_F","I_E_soldier_Mine_F","I_E_Soldier_AA_F","I_E_Soldier_AA_F","I_E_Soldier_AT_F","I_E_Officer_F","I_E_Soldier_Pathfinder_F","I_E_RadioOperator_F","I_E_Soldier_Repair_F","I_E_Soldier_F","I_E_Soldier_LAT_F","I_E_Soldier_LAT2_F","I_E_Soldier_lite_F","I_E_Soldier_SL_F","I_E_Soldier_TL_F"];
			_ArmPool=	["I_E_APC_tracked_03_cannon_F","I_APC_tracked_03_cannon_F","I_MBT_03_cannon_F","I_LT_01_scout_F","I_LT_01_cannon_F","I_LT_01_AA_F"];
			_MotPool=	["I_MRAP_03_gmg_F","I_MRAP_03_hmg_F","I_Truck_02_transport_F","I_G_Offroad_01_armed_F"];
			_ACHPool=	["I_E_Heli_light_03_dynamicLoadout_F"];
			_CHPool=	["I_Heli_Transport_02_F","I_Heli_Transport_02_F","O_Heli_Transport_04_covered_F","I_E_Heli_light_03_unarmed_F"];
			_uavPool=	["I_UAV_01_F","I_UAV_02_CAS_F","I_UGV_01_rcws_F"];
			_stPool=	["I_E_HMG_01_high_F","I_E_GMG_01_high_F","I_E_Mortar_01_F","I_E_HMG_01_F","I_E_HMG_01_A_F","I_E_GMG_01_F","I_E_GMG_01_A_F","I_E_Static_AA_F","I_E_Static_AT_F","I_E_HMG_02_F","I_E_HMG_02_high_F"];
			_shipPool=	["I_Boat_Transport_01_F","O_T_Boat_Armed_01_hmg_F"];
			_diverPool=	["I_diver_exp_F","I_diver_F","I_diver_TL_F"];
			_crewPool=	["I_E_Crew_F"];
			_heliCrew=	["I_E_Helicrew_F","I_E_Helipilot_F"];
			_issueNVG= true;
		};
		case 6: {//EAST Spetsnaz
			_InfPool=	["O_R_Soldier_AR_F","O_R_medic_F","O_R_soldier_exp_F","O_R_Soldier_GL_F","O_R_JTAC_F","O_R_soldier_M_F","O_R_Soldier_LAT_F","O_R_Soldier_TL_F","O_R_Patrol_Soldier_A_F","O_R_Patrol_Soldier_AR2_F","O_R_Patrol_Soldier_AR_F","O_R_Patrol_Soldier_Medic","O_R_Patrol_Soldier_Engineer_F","O_R_Patrol_Soldier_GL_F","O_R_Patrol_Soldier_M2_F","O_R_Patrol_Soldier_LAT_F","O_R_Patrol_Soldier_M_F","O_R_Patrol_Soldier_TL_F","O_R_recon_AR_F","O_R_recon_exp_F","O_R_recon_GL_F","O_R_recon_JTAC_F","O_R_recon_medic_F","O_R_recon_LAT_F","O_R_recon_TL_F"];
			_ArmPool=	["I_E_APC_tracked_03_cannon_F","O_T_MBT_02_cannon_ghex_F","O_T_APC_Tracked_02_AA_ghex_F","O_T_MBT_04_command_F","O_T_MBT_04_cannon_F","O_T_MBT_02_railgun_ghex_F"];
			_MotPool=	["O_T_MRAP_02_hmg_ghex_F","O_T_MRAP_02_gmg_ghex_F","O_T_LSV_02_armed_F","O_T_APC_Wheeled_02_rcws_v2_ghex_F","O_T_LSV_02_armed_F","O_T_LSV_02_AT_F"];
			_ACHPool=	["O_Heli_Attack_02_black_F","O_Heli_Attack_02_F"];
			_CHPool=	["I_Heli_Transport_02_F","I_Heli_Transport_02_F","O_Heli_Light_02_F","O_Heli_Light_02_unarmed_F","O_Heli_Transport_04_covered_F"];
			_uavPool=	["O_T_UAV_04_CAS_F","O_UAV_01_F","O_T_UGV_01_rcws_ghex_F"];
			_stPool=	["I_E_HMG_01_high_F","I_E_GMG_01_high_F","I_E_Mortar_01_F","I_E_HMG_01_F","I_E_HMG_01_A_F","I_E_GMG_01_F","I_E_GMG_01_A_F","I_E_Static_AA_F","I_E_Static_AT_F"];
			_shipPool=	["O_Boat_Transport_01_F","O_T_Boat_Armed_01_hmg_F"];
			_diverPool=	["O_diver_exp_F","O_diver_F","O_diver_TL_F"];
			_crewPool=	["O_R_Soldier_TL_F","O_R_Soldier_LAT_F","O_R_medic_F"];
			_heliCrew=	["I_E_Helicrew_F","I_E_Helipilot_F"];
			_issueNVG= true;
		};
		case 7: {// INDEPENDENT Looters
			_InfPool=	["I_L_Criminal_SG_F","I_L_Criminal_SMG_F","I_L_Hunter_F","I_L_Looter_Rifle_F","I_L_Looter_Pistol_F","I_L_Looter_SG_F","I_L_Looter_SMG_F"];
			_ArmPool=	["I_LT_01_AT_F","I_LT_01_cannon_F"];
			_MotPool=	["I_C_Offroad_02_LMG_F","I_C_Offroad_02_AT_F","O_G_Offroad_01_AT_F","O_G_Offroad_01_armed_F"];
			_ACHPool=	["I_Heli_light_03_dynamicLoadout_F"];
			_CHPool=	["I_Heli_Transport_02_F","I_Heli_light_03_unarmed_F","I_C_Heli_Light_01_civil_F"];
			_uavPool=	[];
			_stPool=	["I_G_Mortar_01_F","I_GMG_01_high_F","I_HMG_01_high_F","I_HMG_01_F","I_static_AT_F","I_static_AA_F","I_GMG_01_F","I_HMG_02_F","I_HMG_02_high_F"];
			_shipPool=	["I_C_Boat_Transport_02_F","I_C_Boat_Transport_01_F","I_Boat_Armed_01_minigun_F"];
			_diverPool=	["I_diver_exp_F","I_diver_F","I_diver_TL_F"];
			_crewPool=	["I_C_Soldier_Para_8_F"];
			_heliCrew=	["I_C_Pilot_F","I_C_Helipilot_F"];
			_issueNVG= false;
		};
		case 8: {// EAST FIA FACTION
			_InfPool=	["O_G_Soldier_F","O_G_Soldier_lite_F","O_G_Soldier_SL_F","O_G_Soldier_TL_F","O_G_Soldier_AR_F","O_G_medic_F","O_G_engineer_F","O_G_Soldier_exp_F","O_G_Soldier_GL_F","O_G_Soldier_M_F","O_G_Soldier_LAT_F","O_G_Soldier_A_F","O_G_officer_F","O_G_Sharpshooter_F","O_G_Soldier_LAT2_F"];
			_ArmPool=	["I_APC_tracked_03_cannon_F"];
			_MotPool=	["I_G_Offroad_01_armed_F","O_G_Offroad_01_armed_F","O_G_Offroad_01_AT_F","I_G_Offroad_01_AT_F","I_C_Offroad_02_AT_F","I_C_Offroad_02_LMG_F","O_G_Van_01_transport_F"];
			_ACHPool=	["I_Heli_light_03_dynamicLoadout_F"];
			_CHPool=	["I_Heli_Transport_02_F","I_Heli_light_03_unarmed_F"];
			_uavPool=	[];
			_stPool=	["O_G_Mortar_01_F","O_G_Mortar_01_F","I_GMG_01_high_F","I_HMG_01_high_F","I_HMG_01_F","I_static_AT_F","I_static_AA_F","I_GMG_01_F","I_HMG_02_F","I_HMG_02_high_F"];
			_shipPool=	["O_G_Boat_Transport_01_F","I_Boat_Armed_01_minigun_F"];
			_diverPool=	["O_diver_exp_F","O_diver_F","O_diver_TL_F"];
			_crewPool=	["O_G_engineer_F"];
			_heliCrew=	["O_G_Soldier_SL_F","O_G_Soldier_F","O_G_Soldier_AR_F","O_G_medic_F","O_G_Soldier_LAT_F","O_G_Soldier_GL_F"];
			_issueNVG= false;
		};
		case 9: {// RHS - Armed Forces of the Russian Federation MSV
			_InfPool=	["rhs_msv_driver_armored","rhs_msv_rifleman","rhs_msv_efreitor","rhs_msv_grenadier","rhs_msv_machinegunner","rhs_msv_machinegunner_assistant","rhs_msv_at","rhs_msv_strelok_rpg_assist","rhs_msv_marksman","rhs_msv_officer_armored","rhs_msv_junior_sergeant","rhs_msv_sergeant","rhs_msv_engineer","rhs_msv_driver","rhs_msv_aa","rhs_msv_medic","rhs_msv_LAT"];//"rhs_msv_officer",
			_ArmPool=	["rhs_bmp1_msv","rhs_bmp1d_msv","rhs_bmp1k_msv","rhs_bmp1p_msv","rhs_bmp2e_msv","rhs_bmp2_msv","rhs_bmp2d_msv","rhs_bmp2k_msv","rhs_bmp3_msv","rhs_bmp3_late_msv","rhs_bmp3m_msv","rhs_bmp3mera_msv","rhs_brm1k_msv","rhs_Ob_681_2","rhs_prp3_msv","rhs_t80u","rhs_t80bv","rhs_t80a","rhs_t72bc_tv","rhs_t72bb_tv","rhs_zsu234_aa","rhs_t90_tv","rhs_t90a_tv"];
			_MotPool=	["rhs_btr60_msv","rhs_btr70_msv","rhs_btr80_msv","rhs_btr80a_msv","rhs_tigr_3camo_msv","rhs_tigr_sts_3camo_msv","rhs_tigr_sts_3camo_msv","rhs_tigr_m_3camo_msv","rhs_gaz66_zu23_msv","RHS_Ural_Zu23_MSV_01","RHS_Ural_Open_MSV_01"];
			_ACHPool=	["RHS_Mi24P_vvsc","RHS_Mi24V_vvsc"];
			_CHPool=	["Cha_Mi24_P","Cha_Mi24_V","O_Heli_Light_02_F","O_Heli_Light_02_unarmed_F"];
			_uavPool=	["rhs_pchela1t_vvs"];
			_stPool=	["RHS_ZU23_MSV","rhs_KORD_high_MSV","rhs_2b14_82mm_msv","rhs_Igla_AA_pod_msv","RHS_AGS30_TriPod_MSV","rhs_KORD_MSV","RHS_NSV_TriPod_MSV","rhs_SPG9M_MSV","rhs_D30_msv","rhs_D30_at_msv","rhs_Kornet_9M133_2_msv"];
			_shipPool=	["O_Boat_Armed_01_hmg_F","O_Boat_Transport_01_F"];
			_diverPool=	["O_diver_exp_F","O_diver_F","O_diver_TL_F"];
			_crewPool=	["rhs_msv_crew_commander","rhs_msv_combatcrew","rhs_msv_armoredcrew","rhs_msv_crew"];
			_heliCrew=	["rhs_msv_grenadier","rhs_msv_machinegunner","rhs_msv_at","rhs_msv_rifleman","rhs_msv_engineer","rhs_msv_aa","rhs_msv_medic","rhs_msv_LAT","rhs_msv_marksman"];
			_issueNVG= true;
		};
		case 10: {// RHS - DESERT Armed Forces of the Russian Federation VDV
			_InfPool=	["rhs_vdv_des_aa","rhs_vdv_des_at","rhs_vdv_des_arifleman","rhs_vdv_des_sergeant","rhs_vdv_des_efreitor","rhs_vdv_des_grenadier_rpg","rhs_vdv_des_strelok_rpg_assist","rhs_vdv_des_junior_sergeant","rhs_vdv_des_machinegunner","rhs_vdv_des_machinegunner_assistant","rhs_vdv_des_marksman","rhs_vdv_des_marksman_asval","rhs_vdv_des_rifleman","rhs_vdv_des_rifleman_asval","rhs_vdv_des_rifleman_lite","rhs_vdv_des_grenadier"];
			_ArmPool=	["rhs_bmp1_msv","rhs_bmp1d_msv","rhs_bmp1k_msv","rhs_bmp1p_msv","rhs_bmp2e_msv","rhs_bmp2_msv","rhs_bmp2d_msv","rhs_bmp2k_msv","rhs_bmp3_msv","rhs_bmp3_late_msv","rhs_bmp3m_msv","rhs_bmp3mera_msv","rhs_brm1k_msv","rhs_Ob_681_2","rhs_prp3_msv","rhs_t80u","rhs_t80bv","rhs_t80a","rhs_t72bc_tv","rhs_t72bb_tv","rhs_zsu234_aa","rhs_t90_tv","rhs_t90a_tv"];
			_MotPool=	["rhs_btr60_msv","rhs_btr70_msv","rhs_btr80_msv","rhs_btr80a_msv","rhs_tigr_3camo_msv","rhs_tigr_sts_3camo_msv","rhs_tigr_sts_3camo_msv","rhs_tigr_m_3camo_msv","rhs_gaz66_zu23_msv","RHS_Ural_Zu23_MSV_01","RHS_Ural_Open_MSV_01"];
			_ACHPool=	["RHS_Mi24P_vvsc","RHS_Mi24V_vvsc"];
			_CHPool=	["Cha_Mi24_P","Cha_Mi24_V","O_Heli_Light_02_F","O_Heli_Light_02_unarmed_F"];
			_uavPool=	["rhs_pchela1t_vvs"];
			_stPool=	["RHS_ZU23_MSV","rhs_KORD_high_MSV","rhs_2b14_82mm_msv","rhs_Igla_AA_pod_msv","RHS_AGS30_TriPod_MSV","rhs_KORD_MSV","RHS_NSV_TriPod_MSV","rhs_SPG9M_MSV","rhs_D30_msv","rhs_D30_at_msv","rhs_Kornet_9M133_2_msv"];
			_shipPool=	["O_Boat_Armed_01_hmg_F","O_Boat_Transport_01_F"];
			_diverPool=	["O_diver_exp_F","O_diver_F","O_diver_TL_F"];
			_crewPool=	["rhs_vdv_des_crew_commander","rhs_vdv_des_combatcrew","rhs_vdv_des_armoredcrew"];
			_heliCrew=	["rhs_msv_grenadier","rhs_msv_machinegunner","rhs_msv_at","rhs_msv_rifleman","rhs_msv_engineer","rhs_msv_aa","rhs_msv_medic","rhs_msv_LAT","rhs_msv_marksman"];
			_issueNVG= true;
		};
		case 11: {// RHS GREF - Chenarus Ground Forces (RESISTANCE)
			_InfPool=	["rhsgref_cdf_reg_rifleman","rhsgref_cdf_reg_rifleman_m70","rhsgref_cdf_reg_rifleman_lite","rhsgref_cdf_reg_grenadier","rhsgref_cdf_reg_machinegunner","rhsgref_cdf_reg_marksman","rhsgref_cdf_reg_officer","rhsgref_cdf_reg_squadleader","rhsgref_cdf_reg_grenadier_rpg","rhsgref_cdf_reg_specialist_aa","rhsgref_cdf_reg_medic","rhsgref_cdf_reg_engineer","rhsgref_cdf_para_rifleman","rhsgref_cdf_para_rifleman_lite","rhsgref_cdf_para_autorifleman","rhsgref_cdf_para_machinegunner","rhsgref_cdf_para_marksman","rhsgref_cdf_para_squadleader","rhsgref_cdf_para_grenadier_rpg","rhsgref_cdf_para_specialist_aa","rhsgref_cdf_para_medic","rhsgref_cdf_para_engineer"];//"rhsgref_cdf_reg_general","rhsgref_cdf_para_officer"
			_ArmPool=	["rhsgref_cdf_t72ba_tv","rhsgref_cdf_bmd1","rhsgref_cdf_bmd1","rhsgref_cdf_bmd1p","rhsgref_cdf_bmd1pk","rhsgref_cdf_bmd2","rhsgref_cdf_bmd2k","rhsgref_cdf_bmp1","rhsgref_cdf_bmp1d","rhsgref_cdf_bmp1k","rhsgref_cdf_bmp1p","rhsgref_cdf_bmp2e","rhsgref_cdf_bmp2","rhsgref_cdf_bmp2d","rhsgref_cdf_gaz66_zu23"];
			_MotPool=	["rhsgref_cdf_btr60","rhsgref_cdf_btr70","rhsgref_BRDM2","rhsgref_BRDM2_HQ","rhsgref_BRDM2_ATGM","rhsgref_c_a2port_armor","rhsgref_cdf_reg_uaz_ags","rhsgref_cdf_reg_uaz_dshkm","rhsgref_cdf_reg_uaz_spg9"];
			_ACHPool=	["rhsgref_mi24g_UPK23","rhsgref_cdf_Mi35","rhsgref_cdf_reg_Mi17Sh"];
			_CHPool=	["rhsgref_cdf_reg_Mi8amt"];
			_uavPool=	[];
			_stPool=	["RHSgref_cdf_ZU23","rhsgref_cdf_reg_M252","rhsgref_cdf_reg_d30","rhsgref_cdf_reg_d30_at","rhsgref_cdf_Igla_AA_pod","rhsgref_cdf_AGS30_TriPod","rhsgref_cdf_DSHKM","rhsgref_cdf_DSHKM_Mini_TriPod","rhsgref_cdf_NSV_TriPod","rhsgref_cdf_SPG9","rhsgref_cdf_SPG9M"];
			_shipPool=	["O_Boat_Armed_01_hmg_F","O_Boat_Transport_01_F"];
			_diverPool=	["I_diver_exp_F","I_diver_F","I_diver_TL_F"];
			_crewPool=	["rhsgref_cdf_reg_crew","rhsgref_cdf_para_crew"];
			_heliCrew=	["rhsgref_cdf_reg_grenadier","rhsgref_cdf_reg_grenadier_rpg","rhsgref_cdf_reg_machinegunner","rhs_msv_at","rhsgref_cdf_reg_rifleman","rhsgref_cdf_para_engineer","rhsgref_cdf_para_specialist_aa","rhsgref_cdf_para_medic","rhsgref_cdf_para_grenadier_rpg","rhsgref_cdf_reg_marksman"];
			_issueNVG= true;
		};
		case 12: {// RHS GREF - Nationalist Troops (RESISTANCE)
			_InfPool=	["rhsgref_nat_rifleman","rhsgref_nat_rifleman_akms","rhsgref_nat_militiaman_kar98k","rhsgref_nat_rifleman_m92","rhsgref_nat_grenadier","rhsgref_nat_warlord","rhsgref_nat_commander","rhsgref_nat_machinegunner","rhsgref_nat_grenadier_rpg","rhsgref_nat_specialist_aa","rhsgref_nat_hunter","rhsgref_nat_scout","rhsgref_nat_saboteur","rhsgref_nat_medic"];
			_ArmPool=	["rhs_bmd1_chdkz","rhs_bmd2_chdkz"];
			_MotPool=	["rhsgref_nat_btr70","rhsgref_nat_uaz_ags","rhsgref_nat_uaz_dshkm","rhsgref_nat_uaz_spg9","rhsgref_nat_ural_Zu23"];
			_ACHPool=	["rhsgref_mi24g_UPK23","rhsgref_cdf_Mi35","rhsgref_cdf_reg_Mi17Sh"];
			_CHPool=	["rhsgref_cdf_reg_Mi8amt"];
			_uavPool=	[];
			_stPool=	["rhsgref_nat_ZU23","rhsgref_nat_AGS30_TriPod","rhsgref_nat_DSHKM","rhsgref_nat_DSHKM_Mini_TriPod","rhsgref_nat_NSV_TriPod","rhsgref_nat_SPG9","rhsgref_nat_2b14","rhsgref_nat_d30","rhsgref_nat_d30_at"];
			_shipPool=	["O_Boat_Armed_01_hmg_F","O_Boat_Transport_01_F"];
			_diverPool=	["I_diver_exp_F","I_diver_F","I_diver_TL_F"];
			_crewPool=	["rhsgref_nat_crew"];
			_heliCrew=	["rhsgref_nat_grenadier","rhsgref_nat_grenadier_rpg","rhsgref_nat_machinegunner","rhsgref_nat_hunter","rhsgref_nat_saboteur","rhsgref_nat_medic","rhsgref_nat_rifleman_akms"];
			_issueNVG= false;
		};
		case 13: {// RHS Serbian Armed Forces (RESISTANCE)
			_InfPool=	["rhssaf_army_m10_digital_asst_mgun","rhssaf_army_m10_digital_spec_aa","rhssaf_army_m10_digital_spec_at","rhssaf_army_m10_digital_crew","rhssaf_army_m10_digital_exp","rhssaf_army_m10_digital_ft_lead","rhssaf_army_m10_digital_gl","rhssaf_army_m10_digital_mgun_m84","rhssaf_army_m10_digital_sniper_m76","rhssaf_army_m10_digital_asst_spec_aa","rhssaf_army_m10_digital_asst_spec_at","rhssaf_army_m10_digital_officer","rhssaf_army_m10_digital_repair","rhssaf_army_m10_digital_rifleman_ammo","rhssaf_army_m10_digital_rifleman_at","rhssaf_army_m10_digital_rifleman_m21","rhssaf_army_m10_digital_rifleman_m70","rhssaf_army_m10_digital_spotter","rhssaf_army_m10_digital_sq_lead","rhssaf_army_m10_para_spec_aa","rhssaf_army_m10_para_spec_at","rhssaf_army_m10_para_crew","rhssaf_army_m10_para_ft_lead","rhssaf_army_m10_para_gl_ag36","rhssaf_army_m10_para_gl_m320","rhssaf_army_m10_para_mgun_m84","rhssaf_army_m10_para_mgun_minimi","rhssaf_army_m10_para_sniper_m76","rhssaf_army_m10_para_asst_spec_aa","rhssaf_army_m10_para_asst_spec_at","rhssaf_army_m10_para_repair","rhssaf_army_m10_para_rifleman_ammo","rhssaf_army_m10_para_rifleman_at","rhssaf_army_m10_para_rifleman_hk416","rhssaf_army_m10_para_rifleman_g36","rhssaf_army_m10_para_sniper_m82a1","rhssaf_army_m10_para_spotter","rhssaf_army_m10_para_sq_lead"];//"rhssaf_army_m10_para_officer",
			_ArmPool=	["rhssaf_army_t72s","rhsgref_cdf_t72ba_tv","rhsgref_cdf_bmd1","rhsgref_cdf_bmd1","rhsgref_cdf_bmd1p","rhsgref_cdf_bmd1pk","rhsgref_cdf_bmd2","rhsgref_cdf_bmd2k","rhsgref_cdf_bmp1","rhsgref_cdf_bmp1d","rhsgref_cdf_bmp1k","rhsgref_cdf_bmp1p","rhsgref_cdf_bmp2e","rhsgref_cdf_bmp2","rhsgref_cdf_bmp2d","rhsgref_cdf_gaz66_zu23"];
			_MotPool=	["rhssaf_m1025_olive_m2","rhsgref_cdf_btr60","rhsgref_cdf_btr70","rhsgref_BRDM2","rhsgref_BRDM2_HQ","rhsgref_BRDM2_ATGM","rhsgref_c_a2port_armor","rhsgref_cdf_reg_uaz_ags","rhsgref_cdf_reg_uaz_dshkm","rhsgref_cdf_reg_uaz_spg9"];
			_ACHPool=	["rhsgref_cdf_reg_Mi17Sh"];
			_CHPool=	["rhssaf_airforce_ht48"];
			_uavPool=	["O_UAV_01_F","O_UAV_02_CAS_F","O_UGV_01_rcws_F"];
			_stPool=	["RHSgref_cdf_ZU23","rhsgref_cdf_reg_M252","rhssaf_army_d30","rhsgref_cdf_reg_d30","rhsgref_cdf_reg_d30_at","rhsgref_cdf_Igla_AA_pod","rhsgref_cdf_AGS30_TriPod","rhsgref_cdf_DSHKM","rhsgref_cdf_DSHKM_Mini_TriPod","rhsgref_cdf_NSV_TriPod","rhsgref_cdf_SPG9","rhsgref_cdf_SPG9M","rhssaf_army_metis_9k115"];
			_shipPool=	["O_Boat_Armed_01_hmg_F","O_Boat_Transport_01_F"];
			_diverPool=	["I_diver_exp_F","I_diver_F","I_diver_TL_F"];
			_crewPool=	["rhssaf_army_m10_digital_crew_armored_nco","rhssaf_army_m10_digital_crew_armored","rhssaf_army_m10_digital_crew"];
			_heliCrew=	["rhssaf_airforce_pilot_transport_heli"];
			_issueNVG= true;
		};
		case 14: {// Project_OPFOR - Islamic State of Takistan and Sahrani
			_InfPool=	["LOP_ISTS_Infantry_Rifleman","LOP_ISTS_Infantry_Rifleman_3","LOP_ISTS_Infantry_Rifleman_4","LOP_ISTS_Infantry_Rifleman_5","LOP_ISTS_Infantry_Rifleman_6","LOP_ISTS_Infantry_Rifleman_8","LOP_ISTS_Infantry_Rifleman_9","LOP_ISTS_Infantry_AR_2","LOP_ISTS_Infantry_AR_Asst_2","LOP_ISTS_Infantry_AR","LOP_ISTS_Infantry_AR_Asst","LOP_ISTS_Infantry_GL","LOP_ISTS_Infantry_TL","LOP_ISTS_Infantry_SL","LOP_ISTS_Infantry_Marksman","LOP_ISTS_Infantry_Corpsman","LOP_ISTS_Infantry_Engineer","LOP_ISTS_Infantry_AT","LOP_ISTS_Infantry_AT","LOP_TKA_Infantry_AA","LOP_TKA_Infantry_AA"];
			_ArmPool=	["LOP_ISTS_BMP1","LOP_ISTS_BMP2","LOP_ISTS_BTR60","LOP_ISTS_M113_W","LOP_ISTS_T72BA","LOP_ISTS_ZSU234"];
			_MotPool=	["LOP_ISTS_Landrover_M2","LOP_ISTS_M1025_W_M2","LOP_ISTS_M1025_W_Mk19","LOP_ISTS_M1025_D","LOP_ISTS_M998_D_4DR","LOP_ISTS_Offroad_M2","LOP_ISTS_Landrover_SPG9"];
			_ACHPool=	["O_Heli_Attack_02_black_F","O_Heli_Attack_02_F"];
			_CHPool=	["LOP_SLA_Mi8MT_Cargo","LOP_SLA_Mi8MTV3_FAB","LOP_SLA_Mi8MTV3_UPK23"];
			_uavPool=	[];
			_stPool=	["LOP_ISTS_Static_Mk19_TriPod","LOP_ISTS_Static_M2","LOP_ISTS_Static_M2_MiniTripod","LOP_ISTS_Static_SPG9","LOP_ISTS_Static_ZU23","LOP_ISTS_Static_ZU23","LOP_ISTS_Static_AT4","LOP_ISTS_Igla_AA_pod","LOP_ISTS_AGS30_TriPod","LOP_ISTS_Static_DSHKM","LOP_ISTS_Kord"];
			_shipPool=	["O_Boat_Armed_01_hmg_F","O_Boat_Transport_01_F"];
			_diverPool=	["I_diver_exp_F","I_diver_F","I_diver_TL_F"];
			_crewPool=	["LOP_ISTS_Infantry_SL","LOP_ISTS_Infantry_AR","LOP_ISTS_Infantry_AT","LOP_ISTS_Infantry_Engineer","LOP_ISTS_Infantry_GL"];
			_heliCrew=	["LOP_ISTS_Infantry_SL","LOP_ISTS_Infantry_AR","LOP_ISTS_Infantry_AT","LOP_ISTS_Infantry_Engineer","LOP_ISTS_Infantry_GL"];
			_issueNVG= true;
		};
		case 15: {// Project_OPFOR - Afghan militia
			_InfPool=	["LOP_AM_Infantry_TL","LOP_AM_Infantry_SL","LOP_AM_Infantry_Corpsman","LOP_AM_Infantry_AR","LOP_AM_Infantry_AT","LOP_AM_Infantry_Marksman","LOP_AM_Infantry_Engineer","LOP_AM_Infantry_GL"];
			_ArmPool=	["LOP_AM_BTR60","LOP_AM_M113_W","LOP_AM_T72BA"];
			_MotPool=	["LOP_AM_Landrover_M2","LOP_AM_Offroad_M2","LOP_IA_M1025_W_Mk19","LOP_IA_M1025_W_M2","LOP_AM_UAZ_SPG","LOP_AM_UAZ_DshKM","LOP_AM_UAZ_AGS","LOP_ISTS_Nissan_PKM"];
			_ACHPool=	["O_Heli_Attack_02_black_F","O_Heli_Attack_02_F"];
			_CHPool=	["LOP_SLA_Mi8MT_Cargo","LOP_SLA_Mi8MTV3_FAB","LOP_SLA_Mi8MTV3_UPK23"];
			_uavPool=	[];
			_stPool=	["LOP_ISTS_Static_Mk19_TriPod","LOP_ISTS_Static_M2","LOP_ISTS_Static_M2_MiniTripod","O_G_Mortar_01_F","LOP_AM_Static_ZU23","LOP_AM_Static_ZU23","LOP_AM_Static_SPG9","LOP_AM_Static_AT4","LOP_AM_Igla_AA_pod","LOP_AM_Static_DSHKM","LOP_AM_Kord"];
			_shipPool=	["O_Boat_Armed_01_hmg_F","O_Boat_Transport_01_F"];
			_diverPool=	["I_diver_exp_F","I_diver_F","I_diver_TL_F"];
			_crewPool=	["LOP_AM_Infantry_Engineer","LOP_AM_Infantry_GL","LOP_AM_Infantry_AT"];
			_heliCrew=	["LOP_AM_Infantry_SL","LOP_AM_Infantry_Engineer","LOP_AM_Infantry_GL","LOP_AM_Infantry_AT","LOP_AM_Infantry_AR"];
			_issueNVG= false;
		};
		case 16: {// ISC - Syrian Arab Army (Opfor)
			_InfPool=	["isc_saa_at_o","isc_saa_crewman_o","isc_saa_grenadier_o","isc_saa_machinegunner_o","isc_saa_medic_o","isc_saa_officer_o","isc_saa_rifleman_o","isc_saa_sapper_o","isc_saa_sniper_o"];
			_ArmPool=	["isc_saa_zsu23_o","isc_saa_T72ba_o","isc_saa_T72bb_o","isc_saa_BMP1_o","isc_saa_BMP1p_o","isc_saa_BMP2_o"];
			_MotPool=	["isc_saa_BTR60PB_o","isc_saa_BTR80_o","isc_saa_BTR80a_o","isc_saa_tigr_m_o","isc_saa_tigr_m_3camo_o","isc_saa_tigr_sts_o","isc_saa_tigr_sts_3camo_o","isc_saa_UAZ_ags_o","isc_saa_UAZ_dshkm_o","isc_saa_UAZ_spg9_o","isc_saa_Ural_zu23_o","isc_saa_gaz66_zu23_o"];
			_ACHPool=	["isc_saa_mi24_o","isc_saa_mi24_at_o","isc_saa_mi24_fab_o","isc_saa_mi24_upk23_o","isc_saa_mi8amtsh_o","isc_saa_mi8amtsh_fab_o","isc_saa_mi8amtsh_upk23_o","isc_saa_mi8mtv_o","isc_saa_mi8mtv_cargo_o","isc_saa_mi8mtv_fab_o","isc_saa_mi8mtv_upk23_o"];
			_CHPool=	["isc_saa_mi8amt_o","isc_saa_mi8mt_o","isc_saa_mi8mt_cargo_o"];
			_uavPool=	["O_UAV_01_F","O_UAV_02_CAS_F","O_UGV_01_rcws_F"];
			_stPool=	["isc_saa_zu23_o","isc_saa_kord_high_o","isc_saa_ags30_o","isc_saa_dshkm_minitripod_o","isc_saa_dshkm_o","isc_saa_kord_o","isc_saa_spg9_o","isc_saa_Kornet_o","isc_saa_Metis_o","isc_saa_nsv_o","isc_saa_2b14_o","isc_saa_D30_at_o","isc_saa_D30_o"];
			_shipPool=	["O_Boat_Armed_01_hmg_F","O_Boat_Transport_01_F"];
			_diverPool=	["O_diver_exp_F","O_diver_F","O_diver_TL_F"];
			_crewPool=	["isc_saa_crewman_o"];
			_heliCrew=	["isc_saa_grenadier_o","isc_saa_machinegunner_o","isc_saa_at_o","isc_saa_crewman_o"];
			_issueNVG= true;
		};
		case 17: {// ISC - Islamic State (Opfor)
			_InfPool=	["isc_is_at_o","isc_is_autorifleman_o","isc_is_crewman_o","isc_is_grenadier_o","isc_is_irregular_o","isc_is_machinegunner_o","isc_is_medic_o","isc_is_militaman_o","isc_is_rifleman_o","isc_is_sapper_o","isc_is_sniper_o","isc_is_squad_leader_o","isc_is_team_leader_o"];
			_ArmPool=	["isc_is_BMP1_o","isc_is_BMP1_flag_o","isc_is_BMP1p_o","isc_is_BMP1p_flag_o","isc_is_BMP2_o","isc_is_BMP2_flag_o","isc_is_T72ba_o","isc_is_T72ba_flag_o","isc_is_T72bb_o","isc_is_T72bb_flag_o","isc_is_zsu23_o"];
			_MotPool=	["isc_is_BTR60PB_o","isc_is_m113d_o","isc_is_m113d_flag_o","isc_is_UAZ_ags_o","isc_is_UAZ_dshkm_o","isc_is_UAZ_spg9_o","isc_is_offroad_M2_o","isc_is_offroad_M2_flag_o","isc_is_gaz66_zu23_o","isc_is_Ural_zu23_o"];
			_ACHPool=	["isc_saa_mi24_o","isc_saa_mi24_at_o","isc_saa_mi24_fab_o","isc_saa_mi24_upk23_o","isc_saa_mi8amtsh_o","isc_saa_mi8amtsh_fab_o","isc_saa_mi8amtsh_upk23_o","isc_saa_mi8mtv_o","isc_saa_mi8mtv_cargo_o","isc_saa_mi8mtv_fab_o","isc_saa_mi8mtv_upk23_o"];
			_CHPool=	["isc_saa_mi8amt_o","isc_saa_mi8mt_o","isc_saa_mi8mt_cargo_o"];
			_uavPool=	["O_UAV_01_F","O_UAV_02_CAS_F","O_UGV_01_rcws_F"];
			_stPool=	["isc_is_ags30_o","isc_is_dshkm_o","isc_is_dshkm_minitripod_o","isc_is_kord_o","isc_is_kord_high_o","isc_is_Kornet_o","isc_is_Metis_o","isc_is_nsv_o","isc_is_spg9_o","isc_is_zu23_o","isc_is_2b14_o","isc_is_D30_at_o","isc_is_D30_o"];
			_shipPool=	["O_Boat_Armed_01_hmg_F","O_Boat_Transport_01_F"];
			_diverPool=	["O_diver_exp_F","O_diver_F","O_diver_TL_F"];
			_crewPool=	["isc_is_crewman_o"];
			_heliCrew=	["isc_is_grenadier_o","isc_is_machinegunner_o","isc_is_at_o","isc_is_crewman_o"];
			_issueNVG= false;
		};
		case 18: {// CUP Takistan Army
			_InfPool=	["CUP_O_TK_Soldier_AA","CUP_O_TK_Soldier_AAT","CUP_O_TK_Soldier_AMG","CUP_O_TK_Soldier_HAT","CUP_O_TK_Soldier_AR","CUP_O_TK_Story_Aziz","CUP_O_TK_Commander","CUP_O_TK_Engineer","CUP_O_TK_Soldier_GL","CUP_O_TK_Soldier_MG","CUP_O_TK_Medic","CUP_O_TK_Officer","CUP_O_TK_Pilot","CUP_O_TK_Soldier","CUP_O_TK_Soldier_Backpack","CUP_O_TK_Soldier_LAT","CUP_O_TK_Soldier_AT","CUP_O_TK_Sniper","CUP_O_TK_Sniper_KSVK","CUP_O_TK_Soldier_AKS_74_GOSHAWK","CUP_O_TK_Spotter","CUP_O_TK_Soldier_SL","CUP_O_TK_SpecOps_MG","CUP_O_TK_SpecOps","CUP_O_TK_SpecOps_TL"];
			_ArmPool=	["CUP_O_BMP2_ZU_TKA","CUP_O_BMP_HQ_TKA","CUP_O_BMP1_TKA","CUP_O_BMP1P_TKA","CUP_O_BMP2_TKA","CUP_O_T34_TKA","CUP_O_T55_TK","CUP_O_T72_TKA","CUP_O_M113_TKA","CUP_O_ZSU23_TK"];//"CUP_O_M113_Med_TKA",
			_MotPool=	["CUP_O_BRDM2_TKA","CUP_O_LR_MG_TKA","CUP_O_LR_SPG9_TKA","CUP_O_BTR60_TK","CUP_O_UAZ_MG_TKA","CUP_O_UAZ_AGS30_TKA","CUP_O_UAZ_SPG9_TKA","CUP_O_Ural_ZU23_TKA","CUP_O_BTR40_MG_TKA"];
			_ACHPool=	["CUP_O_Mi17_TK","CUP_O_Mi24_D_TK"];
			_CHPool=	["CUP_O_UH1H_slick_TKA","CUP_O_Mi17_TK"];
			_uavPool=	[];
			_stPool=	["CUP_O_ZU23_TK","O_HMG_01_high_F","CUP_O_AGS_TK","CUP_O_2b14_82mm_TK","CUP_O_D30_TK","CUP_O_D30_AT_TK","CUP_O_SPG9_TK"];//"CUP_O_DSHkM_MiniTriPod_TK","CUP_O_DSHKM_TK"
			_shipPool=	["O_Boat_Armed_01_hmg_F","O_Boat_Transport_01_F"];
			_diverPool=	["O_diver_exp_F","O_diver_F","O_diver_TL_F"];
			_crewPool=	["CUP_O_TK_Crew"];
			_heliCrew=	["CUP_O_TK_Soldier_AA","CUP_O_TK_Soldier_AAT","CUP_O_TK_Soldier_AMG","CUP_O_TK_Soldier_HAT","CUP_O_TK_Soldier_AR","CUP_O_TK_Commander","CUP_O_TK_Engineer","CUP_O_TK_Soldier_GL","CUP_O_TK_Soldier_MG","CUP_O_TK_Medic","CUP_O_TK_Officer","CUP_O_TK_Pilot","CUP_O_TK_Soldier","CUP_O_TK_Soldier_Backpack","CUP_O_TK_Soldier_LAT","CUP_O_TK_Soldier_AT","CUP_O_TK_Sniper","CUP_O_TK_Sniper_KSVK","CUP_O_TK_Soldier_AKS_74_GOSHAWK","CUP_O_TK_Spotter","CUP_O_TK_Soldier_SL","CUP_O_TK_SpecOps_MG","CUP_O_TK_SpecOps","CUP_O_TK_SpecOps_TL"];
			_issueNVG= true;
		};
		case 19: {// CUP Takistan Militia
			_InfPool=	["CUP_O_TK_INS_Soldier_AA","CUP_O_TK_INS_Soldier_AR","CUP_O_TK_INS_Guerilla_Medic","CUP_O_TK_INS_Soldier_MG","CUP_O_TK_INS_Bomber","CUP_O_TK_INS_Mechanic","CUP_O_TK_INS_Soldier_GL","CUP_O_TK_INS_Soldier","CUP_O_TK_INS_Soldier_FNFAL","CUP_O_TK_INS_Soldier_Enfield","CUP_O_TK_INS_Soldier_AAT","CUP_O_TK_INS_Soldier_AT","CUP_O_TK_INS_Sniper","CUP_O_TK_INS_Soldier_TL","CUP_O_TK_INS_Commander"];
			_ArmPool=	["CUP_O_T72_TKA","CUP_O_M113_TKA","CUP_O_T55_TK","CUP_O_T72_TKA","CUP_O_T55_TK","CUP_O_M113_TKA","CUP_O_ZSU23_TK"];
			_MotPool=	["CUP_O_LR_MG_TKA","CUP_O_LR_SPG9_TKA","CUP_O_UAZ_MG_TKA","CUP_O_UAZ_AGS30_TKA","CUP_O_UAZ_SPG9_TKA","CUP_I_Datsun_PK_TK_Random","CUP_O_Hilux_AGS30_TK_INS","CUP_O_Hilux_BMP1_TK_INS","CUP_O_Hilux_btr60_TK_INS","CUP_O_Hilux_DSHKM_TK_INS","CUP_O_Hilux_igla_TK_INS","CUP_O_Hilux_M2_TK_INS","CUP_O_Hilux_metis_TK_INS","CUP_O_Hilux_MLRS_TK_INS","CUP_O_Hilux_podnos_TK_INS","CUP_O_Hilux_SPG9_TK_INS","CUP_O_Hilux_UB32_TK_INS","CUP_O_Hilux_zu23_TK_INS","CUP_O_Hilux_armored_AGS30_TK_INS","CUP_O_Hilux_armored_BMP1_TK_INS","CUP_O_Hilux_armored_BTR60_TK_INS","CUP_O_Hilux_armored_DSHKM_TK_INS","CUP_O_Hilux_armored_igla_TK_INS","CUP_O_Hilux_armored_M2_TK_INS","CUP_O_Hilux_armored_metis_TK_INS","CUP_O_Hilux_armored_MLRS_TK_INS","CUP_O_Hilux_armored_podnos_TK_INS","CUP_O_Hilux_armored_SPG9_TK_INS","CUP_O_Hilux_armored_UB32_TK_INS","CUP_O_Hilux_armored_zu23_TK_INS"];
			_ACHPool=	["CUP_O_Mi17_TK","CUP_O_Mi24_D_TK"];
			_CHPool=	["CUP_O_UH1H_slick_TKA","CUP_O_Mi17_TK"];
			_uavPool=	[];
			_stPool=	["CUP_O_ZU23_TK_INS","CUP_O_D30_TK_INS","CUP_O_D30_AT_TK_INS","CUP_O_DSHKM_TK_INS","CUP_O_DSHkM_MiniTriPod_TK_INS","CUP_O_2b14_82mm_TK_INS","CUP_O_SPG9_TK_INS","CUP_O_AGS_TK_INS"];
			_shipPool=	["O_Boat_Armed_01_hmg_F","O_Boat_Transport_01_F"];
			_diverPool=	["CUP_O_TK_INS_Soldier"];
			_crewPool=	["CUP_O_TK_INS_Soldier"];
			_heliCrew=	["CUP_O_TK_INS_Soldier_AA","CUP_O_TK_INS_Soldier_AR","CUP_O_TK_INS_Guerilla_Medic","CUP_O_TK_INS_Soldier_MG","CUP_O_TK_INS_Bomber","CUP_O_TK_INS_Mechanic","CUP_O_TK_INS_Soldier_GL","CUP_O_TK_INS_Soldier","CUP_O_TK_INS_Soldier_FNFAL","CUP_O_TK_INS_Soldier_Enfield","CUP_O_TK_INS_Soldier_AAT","CUP_O_TK_INS_Soldier_AT","CUP_O_TK_INS_Sniper","CUP_O_TK_INS_Soldier_TL","CUP_O_TK_INS_Commander"];
			_issueNVG= false;
		};
		case 20: {// CUP Armed Forces of the Russian Federation Modern MSV
			_InfPool=	["CUP_O_RU_Soldier_AA_M_EMR","CUP_O_RU_Soldier_HAT_M_EMR","CUP_O_RU_Soldier_AR_M_EMR","CUP_O_RU_Engineer_M_EMR","CUP_O_RU_Explosive_Specialist_M_EMR","CUP_O_RU_Soldier_GL_M_EMR","CUP_O_RU_Soldier_MG_M_EMR","CUP_O_RU_Soldier_Marksman_M_EMR","CUP_O_RU_Medic_M_EMR","CUP_O_RU_Officer_M_EMR","CUP_O_RU_Soldier_M_EMR","CUP_O_RU_Soldier_LAT_M_EMR","CUP_O_RU_Soldier_AT_M_EMR","CUP_O_RU_Soldier_Saiga_M_EMR","CUP_O_RU_Sniper_M_EMR","CUP_O_RU_Sniper_KSVK_M_EMR","CUP_O_RU_Spotter_M_EMR","CUP_O_RU_Soldier_SL_M_EMR","CUP_O_RU_Soldier_TL_M_EMR"];
			_ArmPool=	["CUP_O_2S6_RU","CUP_O_2S6M_RU","CUP_O_BMP2_RU","CUP_O_BMP_HQ_RU","CUP_O_BMP3_RU","CUP_O_T72_RU","CUP_O_T90_RU"];
			_MotPool=	["CUP_O_Ural_ZU23_RU","CUP_O_BRDM2_RUS","CUP_O_BRDM2_ATGM_RUS","CUP_O_BTR60_RU","CUP_O_BTR60_Green_RU","CUP_O_BTR90_RU","CUP_O_GAZ_Vodnik_PK_RU","CUP_O_GAZ_Vodnik_AGS_RU","CUP_O_GAZ_Vodnik_BPPU_RU","CUP_O_UAZ_AGS30_RU","CUP_O_UAZ_MG_RU","CUP_O_UAZ_METIS_RU","CUP_O_UAZ_SPG9_RU"];
			_ACHPool=	["CUP_O_Mi8_RU","CUP_O_Mi24_V_Dynamic_RU"];
			_CHPool=	["CUP_O_Mi8_RU","CUP_O_Ka60_Grey_RU","CUP_O_Mi8_VIV_RU"];
			_uavPool=	[];//"CUP_O_Pchela1T_RU"
			_stPool=	["CUP_O_AGS_RU","CUP_O_D30_RU","CUP_O_D30_AT_RU","CUP_O_KORD_high_RU","CUP_O_KORD_RU","CUP_O_Metis_RU","CUP_O_2b14_82mm_RU","CUP_O_ZU23_RU"];
			_shipPool=	["O_Boat_Armed_01_hmg_F","CUP_O_PBX_RU"];
			_diverPool=	["O_diver_exp_F","O_diver_F","O_diver_TL_F"];
			_crewPool=	["CUP_O_RU_Crew_M_EMR"];
			_heliCrew=	["CUP_O_RU_Soldier_AA_M_EMR","CUP_O_RU_Soldier_HAT_M_EMR","CUP_O_RU_Soldier_MG_M_EMR","CUP_O_RU_Soldier_M_EMR","CUP_O_RU_Soldier_AT_M_EMR","CUP_O_RU_Soldier_TL_M_EMR","CUP_O_RU_Soldier_SL_M_EMR","CUP_O_RU_Soldier_Marksman_M_EMR"];
			_issueNVG= true;
		};
		case 21: {// CUP Armed Forces of the Russian Federation MSV EMR
			_InfPool=	["CUP_O_RU_Soldier_AA_EMR","CUP_O_RU_Soldier_HAT_EMR","CUP_O_RU_Soldier_AR_EMR","CUP_O_RU_Engineer_EMR","CUP_O_RU_Explosive_Specialist_EMR","CUP_O_RU_Soldier_GL_EMR","CUP_O_RU_Soldier_MG_EMR","CUP_O_RU_Soldier_Marksman_EMR","CUP_O_RU_Medic_EMR","CUP_O_RU_Officer_EMR","CUP_O_RU_Soldier_EMR","CUP_O_RU_Soldier_LAT_EMR","CUP_O_RU_Soldier_AT_EMR","CUP_O_RU_Soldier_Saiga_EMR","CUP_O_RU_Sniper_EMR","CUP_O_RU_Sniper_KSVK_EMR","CUP_O_RU_Spotter_EMR","CUP_O_RU_Soldier_SL_EMR","CUP_O_RU_Soldier_TL_EMR","CUP_O_RU_Soldier_AA_EMR","CUP_O_RU_Soldier_HAT_EMR"];
			_ArmPool=	["CUP_O_2S6_RU","CUP_O_2S6M_RU","CUP_O_BMP2_RU","CUP_O_BMP_HQ_RU","CUP_O_BMP3_RU","CUP_O_T72_RU","CUP_O_T90_RU"];
			_MotPool=	["CUP_O_Ural_ZU23_RU","CUP_O_BRDM2_RUS","CUP_O_BRDM2_ATGM_RUS","CUP_O_BTR60_RU","CUP_O_BTR60_Green_RU","CUP_O_BTR90_RU","CUP_O_GAZ_Vodnik_PK_RU","CUP_O_GAZ_Vodnik_AGS_RU","CUP_O_GAZ_Vodnik_BPPU_RU","CUP_O_UAZ_AGS30_RU","CUP_O_UAZ_MG_RU","CUP_O_UAZ_METIS_RU","CUP_O_UAZ_SPG9_RU"];
			_ACHPool=	["CUP_O_Mi8_RU","CUP_O_Mi24_V_Dynamic_RU"];
			_CHPool=	["CUP_O_Mi8_RU","CUP_O_Ka60_Grey_RU","CUP_O_Mi8_VIV_RU"];
			_uavPool=	[];//"CUP_O_Pchela1T_RU"
			_stPool=	["CUP_O_AGS_RU","CUP_O_D30_RU","CUP_O_D30_AT_RU","CUP_O_KORD_high_RU","CUP_O_KORD_RU","CUP_O_Metis_RU","CUP_O_2b14_82mm_RU","CUP_O_ZU23_RU"];
			_shipPool=	["O_Boat_Armed_01_hmg_F","CUP_O_PBX_RU"];
			_diverPool=	["O_diver_exp_F","O_diver_F","O_diver_TL_F"];
			_crewPool=	["CUP_O_RU_Crew_EMR"];
			_heliCrew=	["CUP_O_RU_Soldier_HAT_EMR","CUP_O_RU_Soldier_AA_EMR","CUP_O_RU_Soldier_GL_EMR","CUP_O_RU_Soldier_MG_EMR","CUP_O_RU_Soldier_AR_EMR","CUP_O_RU_Soldier_Marksman_EMR","CUP_O_RU_Soldier_AT_EMR","CUP_O_RU_Soldier_SL_EMR","CUP_O_RU_Soldier_TL_EMR"];
			_issueNVG= true;
		};
		case 22: {// Massi CSAT Army (EAST)
			_InfPool= 	["O_mas_irahd_Army_F","O_mas_irahd_Army_SL_F","O_mas_irahd_Army_LITE_F","O_mas_irahd_Army_OFF_F","O_mas_irahd_Army_EXP_F","O_mas_irahd_Army_GL_F","O_mas_irahd_Army_TL_F","O_mas_irahd_Army_MG_F","O_mas_irahd_Army_AR_F","O_mas_irahd_Army_LAT_F","O_mas_irahd_Army_AT_F","O_mas_irahd_Army_AA_F","O_mas_irahd_Army_M_F","O_mas_irahd_Army_MEDIC_F","O_mas_irahd_Army_ENG_F","O_mas_irahd_Army_amort_F","O_mas_irahd_Army_smort_F","O_mas_irahd_SOF_F","O_mas_irahd_SOF_SL_F","O_mas_irahd_SOF_EXP_F","O_mas_irahd_SOF_MEDIC_F","O_mas_irahd_SOF_M_F","O_mas_irahd_SOF_MO_F"];
			_ArmPool= 	["O_mas_T55_OPF_01","O_mas_T72_OPF_01","O_mas_T72B_OPF_01","O_mas_T72B_Early_OPF_01","O_mas_T72BM_OPF_01","O_mas_T90_OPF_01","O_mas_ZSU_OPF_01","O_mas_BMP1_OPF_01","O_mas_BMP1P_OPF_01","O_mas_BMP2_OPF_01","O_mas_BMP2_HQ_OPF_01"];
			_MotPool= 	["O_mas_BRDM2","O_mas_BTR60","O_mas_cars_UAZ_AGS30","O_mas_cars_UAZ_MG","O_mas_cars_UAZ_SPG9","O_mas_cars_Ural_ZU23","O_mas_cars_Ural_open"];
			_ACHPool= 	[];
			_CHPool= 	["O_mas_MI8"];
			_uavPool= 	[];
			_stPool= 	["O_mas_ZU23_AAF","O_mas_DSHKM_AAF","O_mas_AGS_AAF","O_mas_DSHkM_Mini_TriPod","O_mas_KORD_AAF","O_mas_KORD_high_AAF","O_mas_Metis_AAF","O_mas_SPG9_AAF","O_mas_Igla_AA_pod_AAF","O_mas_2b14_82mm_AAF","O_mas_D30_AAF","O_mas_D30_AT_AAF"];
			_shipPool=	["O_Boat_Armed_01_hmg_F","O_Boat_Transport_01_F"];
			_diverPool= ["O_diver_exp_F","O_diver_F","O_diver_TL_F"];
			_crewPool=	["O_mas_irahd_Army_CREW_F","O_mas_irahd_Army_GL_F","O_mas_irahd_Army_ENG_F","O_mas_irahd_Army_F","O_mas_irahd_Army_LAT_F","O_mas_irahd_Army_AR_F"];
			_heliCrew=	["O_mas_irahd_Army_Pilot_F","O_mas_irahd_SOF_F","O_mas_irahd_SOF_SL_F","O_mas_irahd_SOF_EXP_F","O_mas_irahd_SOF_MEDIC_F","O_mas_irahd_Army_MG_F"];
			_issueNVG= true;
		};
		case 23: {// Massi Middle East Insurgents (EAST)
			_InfPool= 	["O_mas_med_Rebelhd1_F","O_mas_med_Rebelhd8a_F","O_mas_med_Rebelhd1a_F","O_mas_med_Rebelhd2_F","O_mas_med_Rebelhd3_F","O_mas_med_Rebelhd4_F","O_mas_med_Rebelhd_amort_F","O_mas_med_Rebelhd_smort_F","O_mas_med_Rebelhd5_F","O_mas_med_Rebelhd6_F","O_mas_med_Rebelhd6a_F","O_mas_med_Rebelhd7_F","O_mas_med_Rebelhd8_F"];
			_ArmPool= 	["O_mas_BMP1_OPF_01","O_mas_BMP1P_OPF_01","O_mas_BMP2_OPF_01","O_mas_BMP2_HQ_OPF_01"];
			_MotPool= 	["O_mas_afr_GMG_01_F","O_mas_afr_Offroad_01_armed_F","B_mas_cars_Hilux_MG","B_mas_cars_Hilux_AGS30","B_mas_cars_Hilux_SPG9","B_mas_cars_Hilux_RKTS","B_mas_cars_Hilux_M2"];//"O_mas_afr_Offroad_01s_armed_F",
			_ACHPool= 	[];
			_CHPool=	["O_mas_MI8"];
			_uavPool= 	[];
			_stPool= 	["O_mas_ZU23_AAF","O_mas_DSHKM_AAF","O_mas_AGS_AAF","O_mas_DSHkM_Mini_TriPod","O_mas_KORD_AAF","O_mas_KORD_high_AAF","O_mas_Metis_AAF","O_mas_SPG9_AAF","O_mas_Igla_AA_pod_AAF","O_mas_2b14_82mm_AAF","O_mas_D30_AAF","O_mas_D30_AT_AAF"];
			_shipPool=	["O_Boat_Armed_01_hmg_F","O_Boat_Transport_01_F"];
			_diverPool= ["O_diver_exp_F","O_diver_F","O_diver_TL_F"];
			_crewPool=  ["O_mas_med_Rebelhd1_F","O_mas_med_Rebelhd8a_F","O_mas_med_Rebelhd1a_F","O_mas_med_Rebelhd2_F","O_mas_med_Rebelhd3_F","O_mas_med_Rebelhd4_F","O_mas_med_Rebelhd_amort_F"];
			_heliCrew=  ["O_mas_med_Rebelhd_smort_F","O_mas_med_Rebelhd5_F","O_mas_med_Rebelhd6_F","O_mas_med_Rebelhd6a_F","O_mas_med_Rebelhd7_F","O_mas_med_Rebelhd8_F"];
			_issueNVG= false;
		};
		case 24: {// Massi Takistan Army (EAST)
			_InfPool= 	["O_mas_med_Armyhd_F","O_mas_med_Armyhd_SL_F","O_mas_med_Armyhd_OFF_F","O_mas_med_Armyhd_EXP_F","O_mas_med_Armyhd_GL_F","O_mas_med_Armyhd_TL_F","O_mas_med_Armyhd_MG_F","O_mas_med_Armyhd_AR_F","O_mas_med_Armyhd_LAT_F","O_mas_med_Armyhd_AT_F","O_mas_med_Armyhd_AA_F","O_mas_med_Armyhd_M_F","O_mas_med_Armyhd_MEDIC_F","O_mas_med_Armyhd_ENG_F","O_mas_med_Armyhd_amort_F","O_mas_med_Armyhd_smort_F","O_mas_med_ArmyhdSF_F","O_mas_med_ArmyhdSF_EXP_F","O_mas_med_ArmyhdSF_TL_F","O_mas_med_ArmyhdSF_M_F","O_mas_med_ArmyhdSF_MEDIC_F"];//"O_mas_med_Armyhd_UNA_F"
			_ArmPool= 	["O_mas_T55_OPF_01","O_mas_T72_OPF_01","O_mas_T72B_OPF_01","O_mas_T72B_Early_OPF_01","O_mas_T72BM_OPF_01","O_mas_T90_OPF_01","O_mas_ZSU_OPF_01","O_mas_BMP1_OPF_01","O_mas_BMP1P_OPF_01","O_mas_BMP2_OPF_01","O_mas_BMP2_HQ_OPF_01"];
			_MotPool= 	["O_mas_BRDM2","O_mas_BTR60","O_mas_cars_UAZ_AGS30","O_mas_cars_UAZ_MG","O_mas_cars_UAZ_SPG9","O_mas_cars_Ural_ZU23","O_mas_cars_Ural_open"];
			_ACHPool= 	[];
			_CHPool= 	["O_mas_MI8"];
			_uavPool= 	[];
			_stPool= 	["O_mas_ZU23_AAF","O_mas_DSHKM_AAF","O_mas_AGS_AAF","O_mas_DSHkM_Mini_TriPod","O_mas_KORD_AAF","O_mas_KORD_high_AAF","O_mas_Metis_AAF","O_mas_SPG9_AAF","O_mas_Igla_AA_pod_AAF","O_mas_2b14_82mm_AAF","O_mas_D30_AAF","O_mas_D30_AT_AAF"];
			_shipPool=	["O_Boat_Armed_01_hmg_F","O_Boat_Transport_01_F"];
			_diverPool= ["O_diver_exp_F","O_diver_F","O_diver_TL_F","O_mas_med_Armyhd_MEDIC_F","O_mas_med_Armyhd_ENG_F"];
			_crewPool=	["O_mas_med_Armyhd_CREW_F","O_mas_med_Armyhd_GL_F","O_mas_med_Armyhd_LAT_F","O_mas_med_Armyhd_ENG_F","O_mas_med_Armyhd_AR_F"];
			_heliCrew=	["O_mas_med_Armyhd_Pilot_F","O_mas_med_ArmyhdSF_TL_F","O_mas_med_ArmyhdSF_M_F","O_mas_med_ArmyhdSF_MEDIC_F"];
			_issueNVG= true;
		};
		case 25: {// Massi Takistan Insurgents (EAST)
			_InfPool= 	["O_mas_med_Insuhd_F","O_mas_med_Insuhd_SL_F","O_mas_med_Insuhd_OFF_F","O_mas_med_Insuhd_EXP_F","O_mas_med_Insuhd_GL_F","O_mas_med_Insuhd_TL_F","O_mas_med_Insuhd_MG_F","O_mas_med_Insuhd_AR_F","O_mas_med_Insuhd_LAT_F","O_mas_med_Insuhd_AT_F","O_mas_med_Insuhd_AA_F","O_mas_med_Insuhd_M_F","O_mas_med_Insuhd_MEDIC_F","O_mas_med_Insuhd_ENG_F","O_mas_med_Insuhd_amort_F","O_mas_med_Insuhd_smort_F"];
			_ArmPool= 	["O_mas_BMP1_OPF_01","O_mas_BMP1P_OPF_01","O_mas_BMP2_OPF_01","O_mas_BMP2_HQ_OPF_01"];
			_MotPool= 	["O_mas_afr_Offroad_01s_armed_F","O_mas_afr_Offroad_01_armed_F","B_mas_cars_Hilux_MG","B_mas_cars_Hilux_AGS30","B_mas_cars_Hilux_SPG9","B_mas_cars_Hilux_RKTS","B_mas_cars_Hilux_M2"];
			_ACHPool= 	[];
			_CHPool=	["O_mas_MI8"];
			_uavPool= 	[];
			_stPool= 	["O_mas_ZU23_AAF","O_mas_DSHKM_AAF","O_mas_AGS_AAF","O_mas_DSHkM_Mini_TriPod","O_mas_KORD_AAF","O_mas_KORD_high_AAF","O_mas_Metis_AAF","O_mas_SPG9_AAF","O_mas_Igla_AA_pod_AAF","O_mas_2b14_82mm_AAF","O_mas_D30_AAF","O_mas_D30_AT_AAF"];
			_shipPool=	["O_Boat_Armed_01_hmg_F","O_Boat_Transport_01_F"];
			_diverPool= ["O_diver_exp_F","O_diver_F","O_diver_TL_F"];
			_crewPool=  ["O_mas_med_Insuhd_ENG_F","O_mas_med_Insuhd_MEDIC_F","O_mas_med_Insuhd_F","O_mas_med_Insuhd_GL_F","O_mas_med_Insuhd_AR_F","O_mas_med_Insuhd_LAT_F"];
			_heliCrew=  ["O_mas_med_Insuhd_MEDIC_F","O_mas_med_Insuhd_AA_F","O_mas_med_Insuhd_F","O_mas_med_Insuhd_OFF_F","O_mas_med_Insuhd_EXP_F"];
			_issueNVG= false;
		};
		case 26: {// Massi Africian Rebel Army (EAST)
			_InfPool= 	["O_mas_afr_Soldier_F","O_mas_afr_Soldier_GL_F","O_mas_afr_soldier_AR_F","O_mas_afr_soldier_MG_F","O_mas_afr_Soldier_lite_F","O_mas_afr_Soldier_off_F","O_mas_afr_Soldier_SL_F","O_mas_afr_soldier_M_F","O_mas_afr_soldier_LAT_F","O_mas_afr_soldier_LAA_F","O_mas_afr_medic_F","O_mas_afr_soldier_repair_F","O_mas_afr_soldier_exp_F","O_mas_afr_rusadv1_F","O_mas_afr_rusadv2_F","O_mas_afr_rusadv3_F"];//"O_mas_afr_Soldier_TL_Fn"
			_ArmPool= 	["O_mas_T55_OPF_01","O_mas_T72_OPF_01","O_mas_T72B_OPF_01","O_mas_T72B_Early_OPF_01","O_mas_T72BM_OPF_01","O_mas_T90_OPF_01","O_mas_ZSU_OPF_01","O_mas_BMP1_OPF_01","O_mas_BMP1P_OPF_01","O_mas_BMP2_OPF_01","O_mas_BMP2_HQ_OPF_01"];
			_MotPool= 	["O_mas_BRDM2","O_mas_BTR60","O_mas_cars_UAZ_AGS30","O_mas_cars_UAZ_MG","O_mas_cars_UAZ_SPG9","O_mas_cars_Ural_ZU23","O_mas_cars_Ural_open"];
			_ACHPool= 	[];
			_CHPool= 	["O_mas_MI8"];
			_uavPool= 	[];
			_stPool= 	["O_mas_ZU23_AAF","O_mas_DSHKM_AAF","O_mas_AGS_AAF","O_mas_DSHkM_Mini_TriPod","O_mas_KORD_AAF","O_mas_KORD_high_AAF","O_mas_Metis_AAF","O_mas_SPG9_AAF","O_mas_Igla_AA_pod_AAF","O_mas_2b14_82mm_AAF","O_mas_D30_AAF","O_mas_D30_AT_AAF"];
			_shipPool=	["O_Boat_Armed_01_hmg_F","O_Boat_Transport_01_F"];
			_diverPool= ["O_diver_exp_F","O_diver_F","O_diver_TL_F"];
			_crewPool=	["O_mas_afr_crew_F","O_mas_afr_soldier_AR_F","O_mas_afr_rusadv1_F"];
			_heliCrew=	["O_mas_afr_Soldier_GL_F","O_mas_afr_soldier_AR_F","O_mas_afr_rusadv1_F"];
			_issueNVG= false;
		};
		case 27: {// Massi Armed African Civilians (Rebel supporters EAST)
			_InfPool= 	["O_mas_afr_Rebel1_F","O_mas_afr_Rebel2_F","O_mas_afr_Rebel3_F","O_mas_afr_Rebel4_F","O_mas_afr_Rebel5_F","O_mas_afr_Rebel6_F","O_mas_afr_Rebel6a_F","O_mas_afr_Rebel7_F","O_mas_afr_Rebel8_F","O_mas_afr_Rebel8a_F","O_mas_afr_Rebel_amort_F","O_mas_afr_Rebel_smort_F"];
			_ArmPool= 	["O_mas_BMP1_OPF_01","O_mas_BMP1P_OPF_01","O_mas_BMP2_OPF_01","O_mas_BMP2_HQ_OPF_01"];
			_MotPool= 	["O_mas_afr_GMG_01_F","O_mas_afr_Offroad_01s_armed_F","O_mas_afr_Offroad_01_armed_F","B_mas_cars_Hilux_MG","B_mas_cars_Hilux_AGS30","B_mas_cars_Hilux_SPG9","B_mas_cars_Hilux_RKTS","B_mas_cars_Hilux_M2"];
			_ACHPool= 	[];
			_CHPool=	["O_mas_MI8"];
			_uavPool= 	[];
			_stPool= 	["O_mas_ZU23_AAF","O_mas_DSHKM_AAF","O_mas_AGS_AAF","O_mas_DSHkM_Mini_TriPod","O_mas_KORD_AAF","O_mas_KORD_high_AAF","O_mas_Metis_AAF","O_mas_SPG9_AAF","O_mas_Igla_AA_pod_AAF","O_mas_2b14_82mm_AAF","O_mas_D30_AAF","O_mas_D30_AT_AAF"];
			_shipPool=	["O_Boat_Armed_01_hmg_F","O_Boat_Transport_01_F"];
			_diverPool= ["O_diver_exp_F","O_diver_F","O_diver_TL_F"];
			_crewPool=  ["O_mas_afr_Rebel1_F","O_mas_afr_Rebel2_F","O_mas_afr_Rebel8a_F","O_mas_afr_Rebel_amort_F"];
			_heliCrew=  ["O_mas_afr_Rebel1_F","O_mas_afr_Rebel2_F","O_mas_afr_Rebel3_F","O_mas_afr_Rebel4_F"];
			_issueNVG= false;
		};
		case 28: {// OPTRE URF (Opfor)
			_InfPool=	["OPTRE_Ins_URF_AA_Specialist","OPTRE_Ins_URF_Assist_Autorifleman","OPTRE_Ins_URF_Autorifleman","OPTRE_Ins_URF_AT_Specialist","OPTRE_Ins_URF_Breacher","OPTRE_Ins_URF_Crewman","OPTRE_Ins_URF_Demolitions","OPTRE_Ins_URF_Marksman","OPTRE_Ins_URF_Grenadier","OPTRE_Ins_URF_Observer","OPTRE_Ins_URF_Officer","OPTRE_Ins_URF_Radioman","OPTRE_Ins_URF_Rifleman_AT","OPTRE_Ins_URF_Rifleman_BR","OPTRE_Ins_URF_Rifleman_AR","OPTRE_Ins_URF_Rifleman_Light","OPTRE_Ins_URF_Sniper","OPTRE_Ins_URF_SquadLead","OPTRE_Ins_URF_TeamLead"];
			_ArmPool=	["OPTRE_M12A1_LRV_Ins","OPTRE_M12R_AA_Ins"];
			_MotPool=	["OPTRE_M12_LRV_Ins","OPTRE_M12_LRV_Ins","OPTRE_M12_LRV_Ins","OPTRE_M12_FAV_APC"]; // Bias towards MG
			_ACHPool=	["OPTRE_Pelican_armed_ins","OPTRE_UNSC_hornet_ins"];
			_CHPool=	["OPTRE_Pelican_unarmed_ins"];
			_uavPool=	["OPTRE_mako_drone_CAS_ins"];
			_stPool=	["OPTRE_Static_M41_Ins","O_G_Mortar_01_F","OPTRE_Static_AA_Ins","OPTRE_Static_FG75","OPTRE_Static_ATGM_Ins","O_Mortar_01_F","O_GMG_01_high_F","O_HMG_01_high_F"];
			_shipPool=	["O_Boat_Armed_01_hmg_F","O_Boat_Transport_01_F"];
			_diverPool=	["O_diver_exp_F","O_diver_F","O_diver_TL_F"];
			_crewPool=	["OPTRE_Ins_URF_Crewman"];
			_heliCrew=	["OPTRE_Ins_URF_Pilot"];
			_issueNVG= false;
		};
		case 29: {// OPTRE Insurgents (Opfor)
			_InfPool=	["OPTRE_Ins_ER_Assassin","OPTRE_Ins_ER_Deserter_GL","OPTRE_Ins_ER_Farmer","OPTRE_Ins_ER_Guerilla_AR","OPTRE_Ins_ER_Hacker","OPTRE_Ins_ER_Insurgent_BR","OPTRE_Ins_ER_Militia_MG","OPTRE_Ins_ER_Rebel_AT","OPTRE_Ins_ER_Terrorist"];
			_ArmPool=	["OPTRE_M12A1_LRV_Ins","OPTRE_M12R_AA_Ins"];
			_MotPool=	["OPTRE_M12_LRV_Ins","OPTRE_M12_LRV_Ins","OPTRE_M12_LRV_Ins","OPTRE_M12_FAV_APC"]; // Bias towards MG
			_ACHPool=	["OPTRE_Pelican_armed_ins","OPTRE_UNSC_hornet_ins"];
			_CHPool=	["OPTRE_Pelican_unarmed_ins"];
			_uavPool=	["OPTRE_mako_drone_CAS_ins"];
			_stPool=	["O_Mortar_01_F","O_Mortar_01_F","O_static_AT_F","O_static_AA_F","O_GMG_01_high_F","O_HMG_01_high_F"];
			_shipPool=	["O_Boat_Armed_01_hmg_F","O_Boat_Transport_01_F"];
			_diverPool=	["O_diver_exp_F","O_diver_F","O_diver_TL_F"];
			_crewPool=	["OPTRE_Ins_URF_Crewman"];
			_heliCrew=	["OPTRE_Ins_URF_Pilot"];
			_issueNVG= false;
		};
		case 30: {// IFA3 Desert US Army
			_InfPool=	["LIB_US_NAC_AT_soldier","LIB_US_NAC_captain","LIB_US_NAC_engineer","LIB_US_NAC_first_lieutenant","LIB_US_NAC_grenadier","LIB_US_NAC_grenadier","LIB_US_NAC_mgunner","LIB_US_NAC_medic","LIB_US_NAC_radioman","LIB_US_NAC_corporal","LIB_US_NAC_FC_rifleman","LIB_US_NAC_rifleman","LIB_US_NAC_second_lieutenant","LIB_US_NAC_sniper","LIB_US_NAC_smgunner"];
			_ArmPool=	["LIB_US_NAC_M3_Halftrack","LIB_US_NAC_M4A3_75","LIB_M3A3_Stuart","LIB_M4A3_75","LIB_M4A4_FIREFLY","LIB_M4A3_76","LIB_M4A3_76_HVSS","LIB_M5A1_Stuart"];
			_MotPool=	["LIB_US_NAC_Scout_M3_FFV","LIB_US_NAC_Willys_MB","LIB_US_GMC_Tent","LIB_US_GMC_Open","LIB_US_Scout_M3_FFV","LIB_US_Willys_MB"];
			_ACHPool=	[];
			_CHPool=	[];
			_uavPool=	[];
			_stPool=	["LIB_Zis3","lib_maxim_m30_base","LIB_61k"];
			_shipPool=	["O_Boat_Transport_01_F"];
			_diverPool=	["LIB_US_NAC_AT_soldier","LIB_US_NAC_captain","LIB_US_NAC_engineer","LIB_US_NAC_first_lieutenant","LIB_US_NAC_grenadier","LIB_US_NAC_grenadier","LIB_US_NAC_mgunner","LIB_US_NAC_medic","LIB_US_NAC_radioman","LIB_US_NAC_corporal","LIB_US_NAC_FC_rifleman","LIB_US_NAC_rifleman","LIB_US_NAC_second_lieutenant","LIB_US_NAC_sniper","LIB_US_NAC_smgunner"];
			_crewPool=	["LIB_US_tank_crew","LIB_US_tank_second_lieutenant","LIB_US_tank_sergeant"];
			_heliCrew=	["LIB_US_pilot"];
			_issueNVG= false;
		};
		case 31: {// UNSUNG - VC
			_InfPool=	["uns_men_VC_mainforce_68_AT","uns_men_VC_mainforce_68_AS1","uns_men_VC_mainforce_68_HMG","uns_men_VC_mainforce_68_nco","uns_men_VC_mainforce_68_MED","uns_men_VC_mainforce_68_AS5","uns_men_VC_mainforce_68_RTO","uns_men_VC_mainforce_68_Rmrk","uns_men_VC_mainforce_68_AT2","uns_men_VC_mainforce_68_SAP","uns_men_VC_mainforce_68_RF4","uns_men_VC_mainforce_68_Rmg"];
			_ArmPool=	["uns_t34_76_vc","uns_ot34_85_nva","uns_pt76","uns_t34_85_nva","uns_to55_nva","uns_Type63_mg","uns_ZSU57_NVA"];
			_MotPool=	["uns_Type55_twinMG","uns_Type55_M40","uns_Type55_RR57","uns_Type55_MG","uns_Type55_LMG"];
			_ACHPool=	["uns_Mi8TV_VPAF"];
			_CHPool=	["uns_Mi8TV_VPAF_MG","uns_Mi8T_VPAF"];
			_uavPool=	[];
			_stPool=	["uns_dshk_twin_VC","uns_pk_high_NVA","uns_dshk_bunker_closed_NVA","uns_m1941_82mm_mortarNVA","uns_dshk_armoured_NVA","uns_pk_bunker_low_NVA","uns_SPG9_73mm_NVA","Uns_D20_artillery","Uns_D30_artillery","uns_S60_VC","uns_Type74_VC","uns_ZPU2_VC","uns_ZPU4_VC","uns_ZU23_VC"];
			_shipPool=	["UNS_ASSAULT_BOAT_VC","UNS_PATROL_BOAT_NVA","UNS_Zodiac_NVA"];
			_diverPool=	["uns_men_VC_mainforce_68_AS1","uns_men_VC_mainforce_68_HMG","uns_men_VC_mainforce_68_nco","uns_men_VC_mainforce_68_MED","uns_men_VC_mainforce_68_AS5","uns_men_VC_mainforce_68_RTO","uns_men_VC_mainforce_68_Rmrk"];
			_crewPool=	["uns_men_NVA_crew_crewman"];
			_heliCrew=	["uns_nvaf_pilot5"];
			_issueNVG= false;
		};
		case 32: {// UNSUNG - PAVN
			_InfPool=	["uns_men_NVA_daccong_ACR","uns_men_NVA_daccong_AA1","uns_men_NVA_daccong_AT2","uns_men_NVA_daccong_AT3","uns_men_NVA_daccong_AT","uns_men_NVA_daccong_AS6","uns_men_NVA_daccong_AS3","uns_men_NVA_daccong_AS2","uns_men_NVA_daccong_AS1","uns_men_NVA_daccong_AS5","uns_men_NVA_daccong_AS4","uns_men_NVA_daccong_LMG","uns_men_NVA_daccong_COM","uns_men_NVA_daccong_cov2","uns_men_NVA_daccong_cov3","uns_men_NVA_daccong_cov1","uns_men_NVA_daccong_cov6","uns_men_NVA_daccong_cov5","uns_men_NVA_daccong_cov7","uns_men_NVA_daccong_cov4","uns_men_NVA_daccong_MGS","uns_men_NVA_daccong_HMG","uns_men_NVA_daccong_MED","uns_men_NVA_daccong_MTS","uns_men_NVA_daccong_nco","uns_men_NVA_daccong_off","uns_men_NVA_daccong_RTO","uns_men_NVA_daccong_SAP2","uns_men_NVA_daccong_SAP3","uns_men_NVA_daccong_MRK","uns_men_NVA_daccong_TRI"];//"uns_men_NVA_daccong_SAP1" causes Warning Message: Bad vehicle type uns_men_NVA_daccong_LMG_Bag
			_ArmPool=	["uns_ot34_85_nva","uns_pt76","uns_t34_85_nva","uns_to55_nva","uns_Type63_mg","uns_ZSU57_NVA"];
			_MotPool=	["uns_Type55_twinMG","uns_Type55_M40","uns_Type55_RR57","uns_Type55_MG","uns_Type55_LMG","uns_BTR152_ZPU"];
			_ACHPool=	["uns_Mi8TV_VPAF"];
			_CHPool=	["uns_Mi8TV_VPAF_MG","uns_Mi8T_VPAF"];
			_uavPool=	[];
			_stPool=	["uns_dshk_twin_VC","uns_pk_high_NVA","uns_dshk_bunker_closed_NVA","uns_m1941_82mm_mortarNVA","uns_dshk_armoured_NVA","uns_pk_bunker_low_NVA","uns_SPG9_73mm_NVA","Uns_D20_artillery","Uns_D30_artillery","uns_S60_VC","uns_Type74_VC","uns_ZPU2_VC","uns_ZPU4_VC","uns_ZU23_VC"];
			_shipPool=	["UNS_ASSAULT_BOAT_VC","UNS_PATROL_BOAT_NVA","UNS_Zodiac_NVA"];
			_diverPool=	["uns_men_NVA_daccong_cov2","uns_men_NVA_daccong_cov3","uns_men_NVA_daccong_cov1","uns_men_NVA_daccong_cov4","uns_men_NVA_daccong_cov5","uns_men_NVA_daccong_SAP2"];
			_crewPool=	["uns_men_NVA_crew_crewman","uns_men_NVA_daccong_AS4","uns_men_NVA_daccong_LMG","uns_men_NVA_daccong_AS6","uns_men_NVA_daccong_COM","uns_men_NVA_daccong_RTO"];
			_heliCrew=	["uns_nvaf_pilot5"];
			_issueNVG= false;
		};
	};

	//return
	_ret = [_InfPool,_ArmPool,_MotPool,_ACHPool,_CHPool,_uavPool,_stPool,_shipPool,_diverPool,_crewPool,_heliCrew,_issueNVG];
	//diag_log format ["RESULT %1",_ret];
	_ret
};

private "_enemyFactions";
switch (_opposingArmies) do {
	// CSAT (no mods)
	case 1: {_enemyFactions = [0,0]};
	// AAF (no mods)
	case 2: {_enemyFactions = [1,1]};
	// AAF and FIA (no mods)
	case 3: {_enemyFactions = [1,2]};
	// CSAT Pacific Apex (no mods)
	case 4: {_enemyFactions = [3,3]};
	// CSAT Pacific and Syndikat Apex (no mods)
	case 5: {_enemyFactions = [3,4]};
	// LDF and Spetsnaz (no mods)
	case 6: {_enemyFactions = [5,6]};
	// LDF and Looters (no mods)
	case 7: {_enemyFactions = [5,7]};
	// Spetsnaz and and FIA (no mods)
	case 8: {_enemyFactions = [6,8]};
	// RHS - Armed Forces of the Russian Federation (@RHSAFRF)
	case 9: {_enemyFactions = [9,9]};
	// RHS - DESERT Armed Forces of the Russian Federation (@RHSAFRF)
	case 10: {_enemyFactions = [10,10]};
	// RHS - GREF (@RHSAFRF;@RHSUSAF;@RHSGREF)
	case 11: {_enemyFactions = [11,12]};
	// RHS - RHS Serbia (@RHSAFRF;@RHSUSAF;@RHSGREF;@RHSSAF)
	case 12: {_enemyFactions = [13,13]};
	// Project OPFOR - Islamic State of Takistan/Sahrani and Afghan Militia (@RHSAFRF;@RHSUSAF;@RHSGREF;@Project_OPFOR)
	case 13: {_enemyFactions = [14,15]};
	// Iraqi-Syrian Conflict (@RHSAFRF;@RHSUSAF;@RHSGREF;@RHSSAF;@ISC)
	case 14: {_enemyFactions = [16,17]};
	// CUP - Takistan Army and Takistan Militia (@CBA_A3;@cup_units;@cup_weapons;@cup_vehicles)
	case 15: {_enemyFactions = [18,19]};
	// CUP - Armed Forces of the Russian Federation (@CBA_A3;@cup_units;@cup_weapons;@cup_vehicles)
	case 16: {_enemyFactions = [20,21]};
	// Middle East Warfare - CSAT Army and Middle East Insurgents, NATO SF and Russian Spetsnaz Weapons, NATO Russsian Vehicles (@CBA_A3;@MiddleEastWarfare;@NATO_Rus_Weapons_CBA;@NATO_Rus_Vehicle)
	case 17: {_enemyFactions = [22,23]};
	// Middle East Warfare - Takistan Army and Takistan Insurgents, NATO SF and Russian Spetsnaz Weapons, NATO Russsian Vehicles (@CBA_A3;@MiddleEastWarfare;@NATO_Rus_Weapons_CBA;@NATO_Rus_Vehicle)
	case 18: {_enemyFactions = [24,25]};
	// African Conflict, NATO SF and Russian Spetsnaz Weapons, NATO Russsian Vehicles (@CBA_A3;@AfricanConflict_mas;@NATO_Rus_Weapons_CBA;@NATO_Rus_Vehicle)
	case 19: {_enemyFactions = [26,27]};
	// OPTRE Insurrection (@CBA_A3;@OPTRE)
	case 20: {_enemyFactions = [28,29]};
	// IFA3 Desert US Army (@CUP_Terrains_Core;@IFA3_AIO_LITE)
	case 21: {_enemyFactions = [30,30]};
	// UNSUNG - VC (@Unsung)
	case 22: {_enemyFactions = [31,31]};
	// UNSUNG - VC and PAVN (@Unsung)
	case 23: {_enemyFactions = [31,32]};

};

private _majorFaction = _enemyFactions # 0;
private _currFactionArrays = [_majorFaction] call _gridMarkerUnitPools;
missionNamespace setVariable ["BMR_major_facArr", _currFactionArrays];

private _minorFaction = _enemyFactions # 1;
_currFactionArrays = [_minorFaction] call _gridMarkerUnitPools;
missionNamespace setVariable ["BMR_minor_facArr", _currFactionArrays];
/*
Created by =BTC= Giallustio
Version: 0.14 rc 1
Date: 20/03/2013
Visit us at: http://www.blacktemplars.altervista.org/
*/

if (!hasInterface && !isServer) exitwith {};
if (isServer) then {
	BTC_id_repo = 10;publicVariable "BTC_id_repo";
	BTC_cargo_repo = "Land_HBarrierBig_F" createVehicle [- 5000,- 5000,0];publicVariable "BTC_cargo_repo";
};
if (isDedicated) exitwith {};

if (INS_logistics isEqualTo 1) then {BTC_active_lift = 1;} else {BTC_active_lift = 0;};//adding Duda's Advanced SlingLoading option
BTC_active_cargo     = 1;
BTC_active_towing    = 1;
//Common
BTC_dir_action = "=BTC=_logistic\=BTC=_addAction.sqf";
BTC_l_placement_area = 20;
if (BTC_active_lift isEqualTo 1) then {
	//Lift
	BTC_lift_pilot    = [];// Leave empty if all soldiers can use choppers to lift or ristrict by class name ex. ["US_Soldier_Pilot_EP1","USMC_Soldier_Pilot", ...etc etc];
	BTC_lift          = 1;
	BTC_lifted        = 0;
	BTC_lift_min_h    = 7;// Min height required to lift an object
	BTC_lift_max_h    = 13;// Max height required to lift an object
	BTC_lift_radius   = 4;// You have to stay in this radius to lift an object
	BTC_def_hud       = 1;
	BTC_def_pip       = 1;
	BTC_l_pip_cond    = false;
	BTC_cargo_lifted  = objNull;
	BTC_Hud_Cond      = false;
	BTC_HUD_x         = (SafeZoneW+2*SafeZoneX) - 0.155;//+ 0.045;
	BTC_HUD_y         = (SafeZoneH+2*SafeZoneY) + 0.045;
	_lift = [] execVM "=BTC=_logistic\=BTC=_lift\=BTC=_lift_init.sqf";

	BTC_get_liftable_array = {
		_chopper = _this select 0;
		_array   = [];
		switch (typeOf _chopper) do	{
	// Modify the array to change liftable objects by chopper class
	//A3
			//CH49 Mowhawk
			case "I_Heli_Transport_02_F" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","B_UGV_01_F","B_UGV_01_rcws_F","Air","Ship","ffaa_et_pizarro_mauser","ffaa_et_toa_mando","ffaa_et_toa_zapador","ffaa_et_toa_ambulancia","ffaa_et_toa_m2","ffaa_et_toa_spike"] + BTC_fob_materials};
			//CH67 Huron
			case "B_Heli_Transport_03_F" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","B_UGV_01_F","B_UGV_01_rcws_F","Air","Ship"] + BTC_fob_materials;};
			case "B_Heli_Transport_03_unarmed_F" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","B_UGV_01_F","B_UGV_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			//UH80 Ghost Hawk
			case "B_Heli_Transport_01_F" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","B_UGV_01_F","B_UGV_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			case "B_Heli_Transport_01_camo_F" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","B_UGV_01_F","B_UGV_01_rcws_F","Wheeled_APC","Air","Ship"] + BTC_fob_materials};
			//WY-55 Hellcat
			case "I_Heli_light_03_dynamicLoadout_F" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","Quadbike_01_base_F","StaticWeapon","B_UGV_01_F","B_UGV_01_rcws_F"] + BTC_fob_materials};
			case "I_Heli_light_03_F" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","Quadbike_01_base_F","StaticWeapon","B_UGV_01_F","B_UGV_01_rcws_F"] + BTC_fob_materials};
			case "I_Heli_light_03_unarmed_F" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","Quadbike_01_base_F","StaticWeapon","B_UGV_01_F","B_UGV_01_rcws_F"] + BTC_fob_materials};
			//MH9
			case "B_Heli_Light_01_F" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","Quadbike_01_base_F"]};
			case "B_Heli_Light_01_dynamicLoadout_F" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","Quadbike_01_base_F"]};
			//PO-30 Orca
			case "O_Heli_Light_02_F" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car"]};
	//RHS
			//CH53
			case "rhsusf_CH53E_USMC_D" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			case "rhsusf_CH53E_USMC_W" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			//UH60M
			case "RHS_UH60M" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","B_UGV_01_F","B_UGV_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			case "RHS_UH60M_d" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","B_UGV_01_F","B_UGV_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			case "RHS_UH60M_MEV" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","B_UGV_01_F","B_UGV_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			case "RHS_UH60M_ESSS" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","B_UGV_01_F","B_UGV_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			//CH47
			case "RHS_CH_47F" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			case "RHS_CH_47F_10" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			case "RHS_CH_47F_light_10" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			case "RHS_CH_47F_light" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			//Huey
			case "rhs_uh1h_hidf_gunship" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","Quadbike_01_base_F","StaticWeapon"] + BTC_fob_materials};
			case "rhs_uh1h_hidf" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","Quadbike_01_base_F","StaticWeapon"] + BTC_fob_materials};
			case "rhs_uh1h_hidf_unarmed" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","Quadbike_01_base_F","StaticWeapon"] + BTC_fob_materials};
			//MI8
			case "RHS_Mi8AMT_vvsc" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","B_UGV_01_F","B_UGV_01_rcws_F","Wheeled_APC","Air","Ship"] + BTC_fob_materials};
			case "RHS_Mi8MTV3_vvs" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","B_UGV_01_F","B_UGV_01_rcws_F","Wheeled_APC","Air","Ship"] + BTC_fob_materials};
			case "RHS_Mi8AMTSh_FAB_vvs" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","B_UGV_01_F","B_UGV_01_rcws_F","Wheeled_APC","Air","Ship"] + BTC_fob_materials};
			case "RHS_Mi8AMTSh_UPK23_vvs" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","B_UGV_01_F","B_UGV_01_rcws_F","Wheeled_APC","Air","Ship"] + BTC_fob_materials};
			case "RHS_Mi8AMTSh_vvs" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","B_UGV_01_F","B_UGV_01_rcws_F","Wheeled_APC","Air","Ship"] + BTC_fob_materials};
			case "RHS_Mi8MTV3_vvsc" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","B_UGV_01_F","B_UGV_01_rcws_F","Wheeled_APC","Air","Ship"] + BTC_fob_materials};
			case "RHS_Mi8AMTSh_FAB_vvsc" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","B_UGV_01_F","B_UGV_01_rcws_F","Wheeled_APC","Air","Ship"] + BTC_fob_materials};
			case "RHS_Mi8AMTSh_UPK23_vvsc" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","B_UGV_01_F","B_UGV_01_rcws_F","Wheeled_APC","Air","Ship"] + BTC_fob_materials};
			case "RHS_Mi8AMTSh_vvsc" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","B_UGV_01_F","B_UGV_01_rcws_F","Wheeled_APC","Air","Ship"] + BTC_fob_materials};
			case "RHS_Mi8MTV3_vdv" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","B_UGV_01_F","B_UGV_01_rcws_F","Wheeled_APC","Air","Ship"] + BTC_fob_materials};
	//CUP
			//HC3 Merlins
			case "CUP_B_Merlin_HC3A_Armed_GB" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","CUP_B_M113_desert_USA","B_UGV_01_F","B_UGV_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			case "CUP_B_Merlin_HC3_Armed_GB" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","CUP_B_M113_desert_USA","B_UGV_01_F","B_UGV_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			case "CUP_Merlin_HC3" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","CUP_B_M113_desert_USA","Air","B_UGV_01_F","B_UGV_01_rcws_F","Ship"] + BTC_fob_materials};
			//CH47 Chinook
			case "CUP_B_CH47F_USA" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","CUP_B_M113_desert_USA","CUP_B_M2A3Bradley_USA_D","CUP_B_M6LineBacker_USA_D","B_UGV_01_F","B_UGV_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			case "CUP_B_CH47F_VIV_USA" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","CUP_B_M113_desert_USA","CUP_B_M2A3Bradley_USA_D","CUP_B_M6LineBacker_USA_D","B_UGV_01_F","B_UGV_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			//CH53 Super Stallion
			case "CUP_B_CH53E_USMC" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","CUP_B_M113_desert_USA","CUP_B_M2A3Bradley_USA_D","CUP_B_M6LineBacker_USA_D","B_UGV_01_F","B_UGV_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			case "CUP_B_CH53E_VIV_USMC" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","CUP_B_M113_desert_USA","CUP_B_M2A3Bradley_USA_D","CUP_B_M6LineBacker_USA_D","B_UGV_01_F","B_UGV_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			//Mi6
			case "CUP_B_MI6A_CDF" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Tank","CUP_B_USMC_MQ9","B_UAV_02_CAS_F","B_UAV_02_dynamicLoadout_F","B_UGV_01_F","B_UGV_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			case "CUP_O_MI6T_TKA" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Tank","CUP_B_USMC_MQ9","B_UAV_02_CAS_F","B_UAV_02_dynamicLoadout_F","B_UGV_01_F","B_UGV_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			//MH60 BlackHawk
			case "CUP_B_MH60L_DAP_2x_US" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","B_UGV_01_F","B_UGV_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			case "CUP_B_MH60L_DAP_4x_US" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","B_UGV_01_F","B_UGV_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			case "CUP_B_UH60M_FFV_US" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","B_UGV_01_F","B_UGV_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			case "CUP_B_MH60L_DAP_2x_USN" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","B_UGV_01_F","B_UGV_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			case "CUP_B_MH60L_DAP_4x_USN" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","B_UGV_01_F","B_UGV_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			case "CUP_B_UH60S_USN" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","B_UGV_01_F","B_UGV_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			case "CUP_B_MH60S_USMC" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","B_UGV_01_F","B_UGV_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			case "CUP_B_MH60S_FFV_USMC" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","B_UGV_01_F","B_UGV_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			case "CUP_I_UH60L_RACS" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","B_UGV_01_F","B_UGV_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			case "CUP_I_UH60L_FFV_RACS" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","B_UGV_01_F","B_UGV_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			case "CUP_B_MH60L_DAP_4x_Escort_US" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","B_UGV_01_F","B_UGV_01_rcws_F","Air","Ship"] + BTC_fob_materials};//depricated class
			//Mi17
			case "CUP_O_Mi17_TK" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			//UH1 Huey
			case "CUP_B_UH1Y_Gunship_Dynamic_USMC" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","Quadbike_01_base_F","StaticWeapon"] + BTC_fob_materials};
			case "CUP_B_UH1Y_UNA_USMC" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","Quadbike_01_base_F","StaticWeapon"] + BTC_fob_materials};
			//AW159 WyldeCat
			case "CUP_B_AW159_RN_Grey" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","Quadbike_01_base_F","StaticWeapon","B_UGV_01_F","B_UGV_01_rcws_F"] + BTC_fob_materials};
			case "CUP_B_AW159_RN_Blackcat" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","Quadbike_01_base_F","StaticWeapon","B_UGV_01_F","B_UGV_01_rcws_F"] + BTC_fob_materials};
			//SA330 Pumas
			case "CUP_B_SA330_Puma_HC1_BAF" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","B_UGV_01_F","B_UGV_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			//MV22V Osprey
			case "CUP_B_MV22_USMC" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			//Little Bird
			case "CUP_B_MH6M_USA" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","Quadbike_01_base_F"]};
			case "CUP_B_AH6M_USA" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","Quadbike_01_base_F"]};
	//FFAA
			//NH90
			case "ffaa_nh90_nfh_transport" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","B_UGV_01_F","B_UGV_01_rcws_F","Air","Ship","ffaa_et_pizarro_mauser","ffaa_et_toa_mando","ffaa_et_toa_zapador","ffaa_et_toa_ambulancia","ffaa_et_toa_m2","ffaa_et_toa_spike"] + BTC_fob_materials};
			case "ffaa_nh90_tth_armed" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","B_UGV_01_F","B_UGV_01_rcws_F","Air","Ship","ffaa_et_pizarro_mauser","ffaa_et_toa_mando","ffaa_et_toa_zapador","ffaa_et_toa_ambulancia","ffaa_et_toa_m2","ffaa_et_toa_spike"] + BTC_fob_materials};
			case "ffaa_nh90_tth_cargo" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","B_UGV_01_F","B_UGV_01_rcws_F","Air","Ship","ffaa_et_pizarro_mauser","ffaa_et_toa_mando","ffaa_et_toa_zapador","ffaa_et_toa_ambulancia","ffaa_et_toa_m2","ffaa_et_toa_spike"] + BTC_fob_materials};
			//AS532 Cougar
			case "ffaa_famet_cougar_olive" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","Air","Ship","ffaa_et_toa_mando","ffaa_et_toa_zapador","ffaa_et_toa_ambulancia","ffaa_et_toa_m2","ffaa_et_toa_spike"] + BTC_fob_materials};
			case "ffaa_famet_cougar" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","Air","Ship","ffaa_et_toa_mando","ffaa_et_toa_zapador","ffaa_et_toa_ambulancia","ffaa_et_toa_m2","ffaa_et_toa_spike"] + BTC_fob_materials};
			//CH47
			case "ffaa_famet_ch47_des_mg" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","Air","Ship","ffaa_et_pizarro_mauser","ffaa_et_toa_mando","ffaa_et_toa_zapador","ffaa_et_toa_ambulancia","ffaa_et_toa_m2","ffaa_et_toa_spike"] + BTC_fob_materials};
			case "ffaa_famet_ch47_mg" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","Air","Ship","ffaa_et_pizarro_mauser","ffaa_et_toa_mando","ffaa_et_toa_zapador","ffaa_et_toa_ambulancia","ffaa_et_toa_m2","ffaa_et_toa_spike"] + BTC_fob_materials};
	//OPTRE
			//Pelican
			case "OPTRE_Pelican_armed" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			case "OPTRE_Pelican_unarmed" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","Air","Ship"] + BTC_fob_materials};
			case "OPTRE_Pelican_unarmed_ins" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","Air","Ship"] + BTC_fob_materials};
	//Masi
			//CH47
			case "B_mas_CH_47F" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","Air","Ship"] + BTC_fob_materials};
	//KYO
			//Boeing/SOAR MH47
			case "kyo_MH47E_base" :{_array=["Motorcycle","ReammoBox","ReammoBox_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","Air","Ship"] + BTC_fob_materials};
		};
		_array
	};
};
if (BTC_active_cargo isEqualTo 1) then {
	//Cargo System
	_cargo = [] execVM "=BTC=_logistic\=BTC=_cargo_system\=BTC=_cargo_system_init.sqf";
	BTC_def_vehicles     = ["Tank","Wheeled_APC","Truck","Car","Helicopter"];
	BTC_def_cargo        = ["Motorcycle","StaticWeapon","ReammoBox","ReammoBox_F","Land_BagFence_Long_F","thingX","Wall_F","BagBunker_base_F"] + BTC_fob_materials;//"HBarrier_base_F"
	BTC_def_drag         = ["ReammoBox_F"];
	BTC_def_placement    = ["ReammoBox","StaticWeapon","ReammoBox_F","Land_BagFence_Long_F","thingX","Wall_F","BagBunker_base_F"] + BTC_fob_materials;//"HBarrier_base_F"
	BTC_cargo_selected   = objNull;
	BTC_def_cc =
	[
		"B_Quadbike_01_F",2,
		"B_UGV_01_rcws_F",4,
		"B_UGV_01_F",4,
		//Trucks
		"B_Truck_01_transport_F",10,
		"B_Truck_01_covered_F",10,
		"I_Truck_02_covered_F",10,
		"O_Truck_02_covered_F",10,
		"I_Truck_02_transport_F",10,
		"O_Truck_02_transport_F",10,
		"O_Truck_02_transport_F",10
	];
	BTC_def_rc =
	[
		"Land_BagBunker_Small_F",5,
		"Land_Cargo20_military_green_F",10
	];
};
if (BTC_active_towing isEqualTo 1) then {
	_lift = [] execVM "=BTC=_logistic\=BTC=_towing\=BTC=_towing_init.sqf";
	BTC_cargo_attached = objNull;
	BTC_attached = 0;
	BTC_get_towable_array = {
		_array = [];
		if (typeOf (_this select 0) in INS_TowTruck) then {_array = ["LandVehicle","Air"]};
		_array
	};
};
//Functions
BTC_l_paradrop = {
	_veh = _this select 0;
	_dropped = _this select 1;
	_chute_type = _this select 2;
	_dropped_type = typeOf _dropped;
	_dropped attachTo [_veh,[0,2,-5]];
	sleep 0.1;
	detach _dropped;
	_dropped setvariable ["BTC_cannot_lift",1,false];
	waitUntil {_dropped distance _veh > 50};
	_dropped setvariable ["BTC_cannot_lift",0,false];
	private _chute = createVehicle [_chute_type, getposatl _dropped, [], 0, "FLY"];
	_smoke = "SmokeshellGreen" createVehicle position _dropped;
	_chem  = "Chemlight_green" createVehicle position _dropped;
	_smoke attachto [_dropped,[0,0,0]];
	_chem attachto [_dropped,[0,0,0]];
	_dropped attachTo [_chute,[0,0,0]];
	_heigh = 0;
	while {((getPos _chute) select 2) > 0.3} do {sleep 1;_heigh = (getPos _chute) select 2;};
	detach _dropped;
};
BTC_l_obj_fall = {
	_obj    = _this select 0;
	_height = (getPos _obj) select 2;
	_fall   = 0.09;
	while {((getPos _obj) select 2) > 0.1} do {
		_fall = (_fall * 1.1);
		_obj setPos [getPos _obj select 0, getPos _obj select 1, _height];
		_height = _height - _fall;
		//hint format ["%1 - %2", (getPos _obj) select 2,_height];
		sleep 0.01;
	};
	//if (((getPos _obj) select 2) < 0.3) then {_obj setPos [getPos _obj select 0, getPos _obj select 1, 0.2];};
};
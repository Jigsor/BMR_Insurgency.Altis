/*
Created by =BTC= Giallustio
Version: 0.14 rc 1
Date: 20/03/2013
Visit us at: http://www.blacktemplars.altervista.org/
*/

if (IamHC) exitwith {};
if (isServer) then {
	BTC_id_repo = 10;publicVariable "BTC_id_repo";
	BTC_cargo_repo = "Land_HBarrierBig_F" createVehicle [- 5000,- 5000,0];publicVariable "BTC_cargo_repo";
};
if (isDedicated) exitwith {};

BTC_active_lift      = 1;
BTC_active_fast_rope = 0;
BTC_active_cargo     = 1;
BTC_active_towing    = 1;
//Common
BTC_dir_action = "=BTC=_logistic\=BTC=_addAction.sqf";
BTC_l_placement_area = 20;
if (BTC_active_lift == 1) then {
	//Lift
	BTC_lift_pilot    = [];
	BTC_lift          = 1;
	BTC_lifted        = 0;
	BTC_lift_min_h    = 7;
	BTC_lift_max_h    = 13;
	BTC_lift_radius   = 4;
	BTC_def_hud       = 1;
	BTC_def_pip       = 1;
	BTC_l_def_veh_pip = ["B_Heli_Light_01_F","O_Heli_Light_02_F","B_Heli_Transport_01_F","B_Heli_Transport_01_camo_F","I_Heli_Transport_02_F","B_Heli_Transport_03_F","B_Heli_Transport_03_unarmed_F","rhsusf_CH53E_USMC_D","rhsusf_CH53E_USMC_W"];
	BTC_l_def_veh_hud = ["B_Heli_Light_01_F","O_Heli_Light_02_F","B_Heli_Transport_01_F","B_Heli_Transport_01_camo_F","I_Heli_Transport_02_F","B_Heli_Transport_03_F","B_Heli_Transport_03_unarmed_F","rhsusf_CH53E_USMC_D","rhsusf_CH53E_USMC_W"];
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
			//MH9
			case "B_Heli_Light_01_F" : {_array = ["Motorcycle","ReammoBox","ReammoBox_F","Quadbike_01_base_F","Land_BagFence_Long_F","Land_BarGate_F"];};
			//PO-30
			case "O_Heli_Light_02_F" : {_array = ["Motorcycle","ReammoBox","ReammoBox_F","Land_BagFence_Long_F","StaticWeapon","Car","Land_BarGate_F"];};
			//UH80 Ghost Hawk
			case "B_Heli_Transport_01_F" : {_array = ["Motorcycle","ReammoBox","ReammoBox_F","Land_BagFence_Long_F","Land_BarGate_F","StaticWeapon","Car","Truck","Wheeled_APC","B_UGV_01_F","B_UGV_01_rcws_F","B_UAV_02_CAS_F","Air","Ship"] + BTC_fob_materials;};
			//UH80 camo Ghost Hawk
			case "B_Heli_Transport_01_camo_F" : {_array = ["Motorcycle","ReammoBox","ReammoBox_F","Land_BagFence_Long_F","Land_BarGate_F","StaticWeapon","Car","Truck","B_UGV_01_F","B_UGV_01_rcws_F","B_UAV_02_CAS_F","Wheeled_APC","Air","Ship"] + BTC_fob_materials;};
			//WY-55 Hellcat
			case "I_Heli_light_03_F" : {_array = ["Motorcycle","ReammoBox","ReammoBox_F","Land_BagFence_Long_F","Land_BarGate_F","StaticWeapon","Car","Truck","Wheeled_APC","B_UGV_01_F","B_UGV_01_rcws_F","B_UAV_02_CAS_F","Air","Ship"] + BTC_fob_materials;};
			//CH49 Mowhawk
			case "I_Heli_Transport_02_F" : {_array = ["Motorcycle","ReammoBox","ReammoBox_F","Land_BagFence_Long_F","Land_BarGate_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","Steve_IFV_Warrior","Air","Ship"] + BTC_fob_materials;};
			//CH67 Huron
			case "B_Heli_Transport_03_F" : {_array = ["Motorcycle","ReammoBox","ReammoBox_F","Land_BagFence_Long_F","Land_BarGate_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","Steve_IFV_Warrior","Air","Ship"] + BTC_fob_materials;};//"HBarrier_base_F",
			//CH67 Huron unarmed
			case "B_Heli_Transport_03_unarmed_F" : {_array = ["Motorcycle","ReammoBox","ReammoBox_F","Land_BagFence_Long_F","Land_BarGate_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","Steve_IFV_Warrior","Air","Ship"] + BTC_fob_materials;};
			// RHS CH53E
			case "rhsusf_CH53E_USMC_D" : {_array = ["Motorcycle","ReammoBox","ReammoBox_F","Land_BagFence_Long_F","Land_BarGate_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","Steve_IFV_Warrior","Air","Ship"] + BTC_fob_materials;};
			case "rhsusf_CH53E_USMC_W" : {_array = ["Motorcycle","ReammoBox","ReammoBox_F","Land_BagFence_Long_F","Land_BarGate_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","Steve_IFV_Warrior","Air","Ship"] + BTC_fob_materials;};
			//RHS UH60M
			case "RHS_UH60M" : {_array = ["Motorcycle","ReammoBox","ReammoBox_F","Land_BagFence_Long_F","Land_BarGate_F","StaticWeapon","Car","Truck","Wheeled_APC","B_UGV_01_F","B_UGV_01_rcws_F","B_UAV_02_CAS_F","Air","Ship"] + BTC_fob_materials;};
			case "RHS_UH60M_d" : {_array = ["Motorcycle","ReammoBox","ReammoBox_F","Land_BagFence_Long_F","Land_BarGate_F","StaticWeapon","Car","Truck","Wheeled_APC","B_UGV_01_F","B_UGV_01_rcws_F","B_UAV_02_CAS_F","Air","Ship"] + BTC_fob_materials;};
			case "RHS_UH60M_MEV" : {_array = ["Motorcycle","ReammoBox","ReammoBox_F","Land_BagFence_Long_F","Land_BarGate_F","StaticWeapon","Car","Truck","Wheeled_APC","B_UGV_01_F","B_UGV_01_rcws_F","B_UAV_02_CAS_F","Air","Ship"] + BTC_fob_materials;};
			//RHS CH47F
			case "RHS_CH_47F" : {_array = ["Motorcycle","ReammoBox","ReammoBox_F","Land_BagFence_Long_F","Land_BarGate_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","Steve_IFV_Warrior","Air","Ship"] + BTC_fob_materials;};
			case "RHS_CH_47F_10" : {_array = ["Motorcycle","ReammoBox","ReammoBox_F","Land_BagFence_Long_F","Land_BarGate_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","Steve_IFV_Warrior","Air","Ship"] + BTC_fob_materials;};
			case "RHS_CH_47F_light_10" : {_array = ["Motorcycle","ReammoBox","ReammoBox_F","Land_BagFence_Long_F","Land_BarGate_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","Steve_IFV_Warrior","Air","Ship"] + BTC_fob_materials;};
			case "RHS_CH_47F_light" : {_array = ["Motorcycle","ReammoBox","ReammoBox_F","Land_BagFence_Long_F","Land_BarGate_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","Steve_IFV_Warrior","Air","Ship"] + BTC_fob_materials;};
			//Masi Vehicles
			case "B_mas_CH_47F": {_array = ["Motorcycle","ReammoBox","ReammoBox_F","Land_BagFence_Long_F","Land_BarGate_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","Steve_IFV_Warrior","Air","Ship"] + BTC_fob_materials;};
			//CUP Merlin HC3
			case "CUP_Merlin_HC3" : {_array = ["Motorcycle","ReammoBox","ReammoBox_F","Land_BagFence_Long_F","Land_BarGate_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","Steve_IFV_Warrior","Air","Ship"] + BTC_fob_materials;};
			//CUP CH53E Super Stallion
			case "CUP_B_CH53E_USMC" : {_array = ["Motorcycle","ReammoBox","ReammoBox_F","Land_BagFence_Long_F","Land_BarGate_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","Steve_IFV_Warrior","Air","Ship"] + BTC_fob_materials;};
			//CUP MV22V Osprey
			case "CUP_B_MV22_USMC" : {_array = ["Motorcycle","ReammoBox","ReammoBox_F","Land_BagFence_Long_F","Land_BarGate_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","Steve_IFV_Warrior","Air","Ship"] + BTC_fob_materials;};
			//RHS MI8s
			case "RHS_Mi8MTV3_vvs" : {_array = ["Motorcycle","ReammoBox","ReammoBox_F","Land_BagFence_Long_F","Land_BarGate_F","StaticWeapon","Car","Truck","B_UGV_01_F","B_UGV_01_rcws_F","B_UAV_02_CAS_F","Wheeled_APC","Air","Ship"] + BTC_fob_materials;};
			case "RHS_Mi8AMTSh_FAB_vvs" : {_array = ["Motorcycle","ReammoBox","ReammoBox_F","Land_BagFence_Long_F","Land_BarGate_F","StaticWeapon","Car","Truck","B_UGV_01_F","B_UGV_01_rcws_F","B_UAV_02_CAS_F","Wheeled_APC","Air","Ship"] + BTC_fob_materials;};
			case "RHS_Mi8AMTSh_UPK23_vvs" : {_array = ["Motorcycle","ReammoBox","ReammoBox_F","Land_BagFence_Long_F","Land_BarGate_F","StaticWeapon","Car","Truck","B_UGV_01_F","B_UGV_01_rcws_F","B_UAV_02_CAS_F","Wheeled_APC","Air","Ship"] + BTC_fob_materials;};
			case "RHS_Mi8AMTSh_vvs" : {_array = ["Motorcycle","ReammoBox","ReammoBox_F","Land_BagFence_Long_F","Land_BarGate_F","StaticWeapon","Car","Truck","B_UGV_01_F","B_UGV_01_rcws_F","B_UAV_02_CAS_F","Wheeled_APC","Air","Ship"] + BTC_fob_materials;};
			case "RHS_Mi8MTV3_vvsc" : {_array = ["Motorcycle","ReammoBox","ReammoBox_F","Land_BagFence_Long_F","Land_BarGate_F","StaticWeapon","Car","Truck","B_UGV_01_F","B_UGV_01_rcws_F","B_UAV_02_CAS_F","Wheeled_APC","Air","Ship"] + BTC_fob_materials;};
			case "RHS_Mi8AMTSh_FAB_vvsc" : {_array = ["Motorcycle","ReammoBox","ReammoBox_F","Land_BagFence_Long_F","Land_BarGate_F","StaticWeapon","Car","Truck","B_UGV_01_F","B_UGV_01_rcws_F","B_UAV_02_CAS_F","Wheeled_APC","Air","Ship"] + BTC_fob_materials;};
			case "RHS_Mi8AMTSh_UPK23_vvsc" : {_array = ["Motorcycle","ReammoBox","ReammoBox_F","Land_BagFence_Long_F","Land_BarGate_F","StaticWeapon","Car","Truck","B_UGV_01_F","B_UGV_01_rcws_F","B_UAV_02_CAS_F","Wheeled_APC","Air","Ship"] + BTC_fob_materials;};
			case "RHS_Mi8AMTSh_vvsc" : {_array = ["Motorcycle","ReammoBox","ReammoBox_F","Land_BagFence_Long_F","Land_BarGate_F","StaticWeapon","Car","Truck","B_UGV_01_F","B_UGV_01_rcws_F","B_UAV_02_CAS_F","Wheeled_APC","Air","Ship"] + BTC_fob_materials;};
			case "RHS_Mi8MTV3_vdv" : {_array = ["Motorcycle","ReammoBox","ReammoBox_F","Land_BagFence_Long_F","Land_BarGate_F","StaticWeapon","Car","Truck","B_UGV_01_F","B_UGV_01_rcws_F","B_UAV_02_CAS_F","Wheeled_APC","Air","Ship"] + BTC_fob_materials;};
			//Boeing/SOAR MH-47E
			case "kyo_MH47E_base" : {_array = ["Motorcycle","ReammoBox","ReammoBox_F","Land_BagFence_Long_F","Land_BarGate_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","Steve_IFV_Warrior","Air","Ship"] + BTC_fob_materials;};
			//CH49
			case "BTC_ch49_EI" : {_array = ["Motorcycle","ReammoBox","ReammoBox_F","Land_BagFence_Long_F","Land_BarGate_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","Air","Ship"] + BTC_fob_materials;};
			//Boeing/SOAR MH-47E
			case "CH49_Mohawk_FG" : {_array = ["Motorcycle","ReammoBox","ReammoBox_F","Land_BagFence_Long_F","Land_BarGate_F","StaticWeapon","Car","Truck","Wheeled_APC","Tracked_APC","APC_Tracked_01_base_F","APC_Tracked_02_base_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_APC_Tracked_01_rcws_F","Steve_IFV_Warrior","Air","Ship"] + BTC_fob_materials;};
		};
		_array
	};
};
if (BTC_active_fast_rope isEqualTo 1) then {
	//Fast roping
	BTC_fast_rope_h = 35;
	BTC_fast_rope_h_min = 5;
	BTC_roping_chopper = ["B_Heli_Light_01_F","O_Heli_Light_02_F","B_Heli_Transport_01_F","B_Heli_Transport_01_camo_F","I_Heli_Transport_02_F","BTC_EI_ch49","CH_47F","UH60M","UH60M_MEV","UH1H","UH1Y","Cha_Mi24_D","Cha_Mi35_ACR"];
	_rope = [] execVM "=BTC=_logistic\=BTC=_fast_roping\=BTC=_fast_roping_init.sqf";
};
if (BTC_active_cargo isEqualTo 1) then {
	//Cargo System
	_cargo = [] execVM "=BTC=_logistic\=BTC=_cargo_system\=BTC=_cargo_system_init.sqf";
	BTC_def_vehicles     = ["Tank","Wheeled_APC","Truck","Car","Helicopter"];
	BTC_def_cargo        = ["Motorcycle","StaticWeapon","ReammoBox","ReammoBox_F","Land_BarGate_F","Land_BagFence_Long_F","thingX","Wall_F","BagBunker_base_F"] + BTC_fob_materials;//"HBarrier_base_F"
	BTC_def_drag         = ["ReammoBox_F"];
	BTC_def_placement    = ["ReammoBox","StaticWeapon","ReammoBox_F","Land_BarGate_F","Land_BagFence_Long_F","thingX","Wall_F","BagBunker_base_F"] + BTC_fob_materials;//"HBarrier_base_F"
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
		_tower = _this select 0;
		_array = [];
		switch (typeOf _tower) do {
			case "B_APC_Tracked_01_CRV_F"	: {_array = ["LandVehicle","Air"];};//Bobcat A3
			case "B_T_APC_Tracked_01_CRV_F"	: {_array = ["LandVehicle","Air"];};//Bobcat A3 Apex
			//case "B_Truck_01_mover_F"	: {_array = ["LandVehicle","Air"];};//HEMTT Mover
		};
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
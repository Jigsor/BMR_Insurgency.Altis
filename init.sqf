if (!isServer && isNull player) then {isJIP=true;} else {isJIP=false; if (didJIP) then {isJIP=true;};};
HC_1Present = false;
HC_2Present = false;

// Set friendly/enemy sides
_EastHQ = createCenter EAST;
_WestHQ = createCenter WEST;
_IndHQ = createCenter RESISTANCE;
EAST setFriend [WEST, 0];
WEST setFriend [EAST, 0];
RESISTANCE setFriend [WEST, 0];
RESISTANCE setFriend [EAST, 1];
EAST setFriend [RESISTANCE, 1];
WEST setFriend [RESISTANCE, 0];

if (isMultiplayer) then {enableSaving [false, false];};

// Init Headless Client
if (isMultiplayer) then {
	if (!hasInterface && !isDedicated) then
	{
		call compile preProcessFileLineNumbers "INSfncs\headless_client_fncs.sqf";
		diag_log format ["HEADLESSCLIENT: %1 Connected HEADLESSCLIENT ID: %2", name player, owner player];

		private "_enableLogs";
		_enableLogs = true;// set to false to disable logging to headless client(s) .rpt
		if (_enableLogs) then {
			[] spawn {
				waitUntil {time > 3};
				if (INS_mod_missing) then {[] spawn INS_missing_mods;};

				private "_AllEnemyGroups";
				while {true} do {
					sleep 60.123;
					_AllEnemyGroups=[];
					//{if (count units _x>0 and side _x==INS_Op4_side) then {_AllEnemyGroups pushBack _x}} forEach allGroups;// count non empty enemy groups
					{if (side _x==INS_Op4_side) then {_AllEnemyGroups pushBack _x;};} forEach allGroups;// count all enemy groups empty or not

					diag_log format ["HEADLESSCLIENT FPS: %1 TIME: %2 IDCLIENT: %3 TOTAL ENEMY GROUPS: %4", diag_fps, time, owner player, count _AllEnemyGroups];
				};
			};
		};
	};
} else {
	if (isServer) then {
		Any_HC_present = false;
		publicVariable "Any_HC_present";
	};
};

// Common Functions
call compile preprocessFile "INS_definitions.sqf";
Remedy_SEHs_fnc = call compile preprocessFile "INSfncs\Remedy_SEHs_fnc.sqf";
call compile preProcessFileLineNumbers "INSfncs\commom_fncs.sqf";
call compile preprocessFile "=BTC=_TK_punishment\=BTC=_tk_init.sqf";
if (INS_p_rev < 4) then {
	call compile preprocessFile "=BTC=_revive\=BTC=_revive_init.sqf";
}else{
	if ((INS_p_rev isEqualTo 4) || (INS_p_rev isEqualTo 5)) then {
		call compile preprocessFile "=BTC=_q_revive\config.sqf";
	};
};
if (!IamHC) then {[] spawn {call compile preprocessFileLineNumbers "EPD\Ied_Init.sqf";};};

// EOS
private "_requiredAddons";
switch (INS_op_faction) do {
	case 1: {
	// CSAT (no mods)
		[EAST,0,0]execVM "eos\OpenMe.sqf";
	};
	case 2: {
	// AAF (no mods)
		[RESISTANCE,1,1]execVM "eos\OpenMe.sqf";
	};
	case 3: {
	// AAF and FIA (no mods)
		[RESISTANCE,1,2]execVM "eos\OpenMe.sqf";
	};
	case 4: {
	// African Conflict, NATO SF and Russian Spetsnaz Weapons, NATO Russsian Vehicles (@CBA_A3;@AfricanConflict_mas;@NATO_Rus_Weapons_CBA;@NATO_Rus_Vehicle)
		_requiredAddons = ["asdg_jointrails","mas_afr_rebl_c","mas_afr_rebl","mas_HMMWV","mas_apc","mas_brdm","mas_CH47","mas_veh_F_35C","mas_cars_Hilux","mas_cars_LR","mas_MI24","mas_MI8"];
		if ({isClass(configFile >> "cfgPatches" >> _x)} count _requiredAddons == count _requiredAddons) then {
			activateAddons ["asdg_jointrails","asdg_jointmuzzles","mas_afr_rebl_c","mas_afr_rebl","mas_HMMWV","mas_apc","mas_brdm","mas_CH47","mas_veh_F_35C","mas_cars_Hilux","mas_cars_LR","mas_MI24","mas_MI8"];
			[EAST,3,4]execVM "eos\OpenMe.sqf";
		}else{INS_mod_missing = true;};
	};
	case 5: {
	// Middle East Warfare - CSAT Army and Middle East Insurgents, NATO SF and Russian Spetsnaz Weapons, NATO Russsian Vehicles (@CBA_A3;@MiddleEastWarfare;@NATO_Rus_Weapons_CBA;@NATO_Rus_Vehicle)
		_requiredAddons = ["CBA_main","asdg_jointrails","mas_med_rebl_army_HD","mas_med_rebl_civ_HD","mas_med_rebl_civ","mas_HMMWV","mas_apc","mas_brdm","mas_CH47","mas_veh_F_35C","mas_cars_Hilux","mas_cars_LR","mas_MI24","mas_MI8"];
		if ({isClass(configFile >> "cfgPatches" >> _x)} count _requiredAddons == count _requiredAddons) then {
			activateAddons ["CBA_main","asdg_jointrails","asdg_jointmuzzles","mas_med_rebl_army_HD","mas_med_rebl_civ_HD","mas_med_rebl_civ","mas_HMMWV","mas_apc","mas_brdm","mas_CH47","mas_veh_F_35C","mas_cars_Hilux","mas_cars_LR","mas_MI24","mas_MI8"];
			[EAST,5,6]execVM "eos\OpenMe.sqf";
		}else{INS_mod_missing = true;};
	};
	case 6: {
	// Middle East Warfare - Takistan Army and Takistan Insurgents, NATO SF and Russian Spetsnaz Weapons, NATO Russsian Vehicles (@CBA_A3;@MiddleEastWarfare;@NATO_Rus_Weapons_CBA;@NATO_Rus_Vehicle)
		_requiredAddons = ["CBA_main","asdg_jointrails","mas_med_rebl_army_HD","mas_med_rebl_ins_HD","mas_med_rebl_c","mas_HMMWV","mas_apc","mas_brdm","mas_CH47","mas_veh_F_35C","mas_cars_Hilux","mas_cars_LR","mas_MI24","mas_MI8"];
		if ({isClass(configFile >> "cfgPatches" >> _x)} count _requiredAddons == count _requiredAddons) then {
			activateAddons ["CBA_main","asdg_jointrails","asdg_jointmuzzles","mas_med_rebl_army_HD","mas_med_rebl_ins_HD","mas_med_rebl_c","mas_HMMWV","mas_apc","mas_brdm","mas_CH47","mas_veh_F_35C","mas_cars_Hilux","mas_cars_LR","mas_MI24","mas_MI8"];
			[EAST,7,8]execVM "eos\OpenMe.sqf";
		}else{INS_mod_missing = true;};
	};
	case 7: {
	// Leight's Opfor Pack - Islamic State of Takistan/Sahrani and Afghan Militia (@rhs_afrf3;@rhs_usf3;@leights_opfor)
		if ((isClass(configFile >> "cfgPatches" >> "rhs_main")) &&
		{(isClass(configFile >> "cfgPatches" >> "lop_main"))}) then {
			activateAddons ["rhs_main","rhs_weapons","rhsusf_main","rhs_c_troops","rhs_c_btr","rhs_c_bmp","rhs_c_tanks","rhs_c_a2port_armor","RHS_A2_CarsImport","RHS_A2_AirImport","rhsusf_c_heavyweapons","rhsusf_c_weapons","rhs_c_a2port_air","lop_faction_ists","lop_faction_am","lop_faction_sla","lop_faction_ia","lop_faction_cdf","lop_faction_tak_civ"];
			[RESISTANCE,9,10]execVM "eos\OpenMe.sqf";
		}else{INS_mod_missing = true;};
	};
	case 8: {
	// CUP - Takistan Army and Takistan Militia (@CBA_A3;@cup_units;@cup_weapons;@cup_vehicles)
		_requiredAddons = ["CUP_Creatures_Military_Taki","asdg_jointrails","CUP_Creatures_People_Military_DummyInfantrySet","CUP_Creatures_People_Civil_Chernarus","CUP_WheeledVehicles_LR","CUP_WheeledVehicles_UAZ","CUP_WheeledVehicles_Ural","CUP_WheeledVehicles_BRDM2","CUP_WheeledVehicles_BTR60","CUP_TrackedVehicles_M113","CUP_TrackedVehicles_T55","CUP_TrackedVehicles_T72","CUP_TrackedVehicles_ZSU23","cup_watervehicles_rhib","CUP_AirVehicles_Su25","CUP_AirVehicles_AN2","CUP_AirVehicles_UH1H","CUP_AirVehicles_Mi8","CUP_AirVehicles_Mi24"];
		if ({isClass(configFile >> "cfgPatches" >> _x)} count _requiredAddons == count _requiredAddons) then {
			activateAddons ["asdg_jointrails","asdg_jointmuzzles","CUP_Creatures_Military_Taki","CUP_Creatures_People_Military_DummyInfantrySet","CUP_Creatures_People_Civil_Chernarus","CUP_WheeledVehicles_LR","CUP_WheeledVehicles_UAZ","CUP_WheeledVehicles_Ural","CUP_WheeledVehicles_BRDM2","CUP_WheeledVehicles_BTR60","CUP_TrackedVehicles_M113","CUP_TrackedVehicles_T55","CUP_TrackedVehicles_T72","CUP_TrackedVehicles_ZSU23","cup_watervehicles_rhib","CUP_AirVehicles_Su25","CUP_AirVehicles_AN2","CUP_AirVehicles_UH1H","CUP_AirVehicles_Mi8","CUP_AirVehicles_Mi24"];
			[EAST,11,12]execVM "eos\OpenMe.sqf";
		}else{INS_mod_missing = true;};
	};
	case 9: {
	// RHS - Armed Forces of the Russian Federation (@rhs_afrf3)
		if (isClass(configFile >> "cfgPatches" >> "rhs_c_troops")) then {
			activateAddons ["rhs_c_troops","rhs_c_heavyweapons","rhs_c_btr","rhs_c_bmp","rhs_c_bmp3","rhs_c_cars","rhs_c_trucks","rhs_c_a2port_car","rhs_c_a2port_armor","rhs_c_tanks","rhs_c_t72","rhs_c_sprut","rhs_c_a2port_air","rhs_c_air","RHS_A2_CarsImport","RHS_A2_AirImport","rhs_c_a3retex"];
			[EAST,13,13]execVM "eos\OpenMe.sqf";

			// (optional/not required) United States Armed Forces (@rhs_usf3)
			// Vehicles will show up in vehicle rewards.
			if (isClass(configFile >> "cfgPatches" >> "rhsusf_main")) then {
				activateAddons ["rhsusf_main","rhsusf_c_troops","rhsusf_c_statics","rhsusf_vehicles","rhsusf_c_hmmwv","rhsusf_c_rg33","rhsusf_c_m1117","rhsusf_c_fmtv","rhsusf_c_HEMTT_A4""RHS_US_A2Port_Armor","rhsusf_c_m113","rhsusf_c_m109","rhsusf_c_m1a1","RHS_US_A2_AirImport","rhsusf_c_f22","rhsusf_c_melb"];
			};
		}else{INS_mod_missing = true;};
	};
	case 10: {
	// RHS - GREF (@rhs_afrf3;@rhs_usf3;@rhs_gref)
		_requiredAddons = ["rhs_c_troops","rhsusf_main","rhsgref_c_troops"];
		if ({isClass(configFile >> "cfgPatches" >> _x)} count _requiredAddons == count _requiredAddons) then {
			activateAddons ["rhs_c_troops","rhs_c_heavyweapons","rhs_c_btr","rhs_c_bmp","rhs_c_bmp3","rhs_c_cars","rhs_c_trucks","rhs_c_a2port_car","rhs_c_a2port_armor","rhs_c_tanks","rhs_c_t72","rhs_c_sprut","rhs_c_a2port_air","rhs_c_air","RHS_A2_CarsImport","RHS_A2_AirImport","rhs_c_a3retex"];
			activateAddons ["rhsusf_main","rhsusf_c_troops","rhsusf_c_statics","rhsusf_vehicles","rhsusf_c_hmmwv","rhsusf_c_rg33","rhsusf_c_m1117","rhsusf_c_fmtv","rhsusf_c_HEMTT_A4""RHS_US_A2Port_Armor","rhsusf_c_m113","rhsusf_c_m109","rhsusf_c_m1a1","RHS_US_A2_AirImport","rhsusf_c_f22","rhsusf_c_melb"];
			activateAddons ["rhsgref_c_troops","rhsgref_c_vehicles_ret","rhs_cti_insurgents","rhsgref_c_air","rhsgref_c_tohport_air"];
			[EAST,14,15]execVM "eos\OpenMe.sqf";
		}else{INS_mod_missing = true;};
	};
	case 11: {
	// Iraqi-Syrian Conflict (@CBA_A3;@ISC;@cup_weapons;@mas_nato_rus_sf_veh;@rhs_afrf3;@rhs_usf3)
		_requiredAddons = ["CBA_main","asdg_jointrails","Iraqi_Syrian_Conflict","mas_HMMWV","mas_apc","mas_brdm","mas_CH47","mas_veh_F_35C","mas_cars_Hilux","mas_cars_LR","mas_MI24","mas_MI8","rhs_c_troops","rhsusf_main"];
		if ({isClass(configFile >> "cfgPatches" >> _x)} count _requiredAddons == count _requiredAddons) then {
			activateAddons ["CBA_main","asdg_jointrails","Iraqi_Syrian_Conflict","iraqi_syrian_conflict_v","mas_CH47","mas_veh_F_35C","mas_MI24","mas_MI8"];
			activateAddons ["rhs_c_troops","rhs_c_heavyweapons","rhs_c_btr","rhs_c_bmp","rhs_c_bmp3","rhs_c_cars","rhs_c_trucks","rhs_c_a2port_car","rhs_c_a2port_armor","rhs_c_tanks","rhs_c_t72","rhs_c_sprut","rhs_c_a2port_air","rhs_c_air","RHS_A2_CarsImport","RHS_A2_AirImport","rhs_c_a3retex"];
			activateAddons ["rhsusf_main","rhsusf_c_troops","rhsusf_c_statics","rhsusf_vehicles","rhsusf_c_hmmwv","rhsusf_c_rg33","rhsusf_c_m1117","rhsusf_c_fmtv","rhsusf_c_HEMTT_A4""RHS_US_A2Port_Armor","rhsusf_c_m113","rhsusf_c_m109","rhsusf_c_m1a1","RHS_US_A2_AirImport","rhsusf_c_f22","rhsusf_c_melb"];
			[EAST,16,17]execVM "eos\OpenMe.sqf";
		}else{INS_mod_missing = true;};
	};
};
if (CiviFoot isEqualTo 1) then {[]execVM "eos_civ\OpenMeCiv.sqf";};// Civilians

// Common Scripts
execVM "Objectives\shk_taskmaster.sqf";
if (JigHeliExtraction isEqualTo 1) then {if (!IamHC) then {null = [] execVM "JIG_EX\extraction_init.sqf";};};
if (CiviMobiles isEqualTo 1) then {[2, 400, 500] execVM "scripts\MAD_traffic.sqf";};
if (INS_logistics isEqualTo 1) then {_logistic = execVM "=BTC=_Logistic\=BTC=_logistic_init.sqf";};
if (max_ai_recruits > 1) then {[] execVM "bon_recruit_units\init.sqf";};
execVM "scripts\zlt_fastrope.sqf";
execVM "JWC_CASFS\initCAS.sqf";
nul = ["mission"] execVM "hcam_init.sqf";
execVM "LT\init.sqf";

// Init Server
if (isServer) then
{
	call compile preprocessFile "init_server.sqf";
	call compile preprocessFileLineNumbers "INSfncs\AirPatrole_Fncs.sqf";
	rej_fnc_bezier = compile preProcessFileLineNumbers "INSfncs\rej_fnc_bezier.sqf";
	
	if ((DebugEnabled isEqualTo 1) && (tky_perfmon > 0)) then {
		if (AI_SpawnDis > 1000) then {
			[AI_SpawnDis,11,true,1000,60000,1200]execVM "zbe_cache\main.sqf";
		}else{
			[1000,11,true,1000,60000,1200]execVM "zbe_cache\main.sqf";
		};
	}else{
		if (AI_SpawnDis < 1000) then {
			[1000,12,false,1000,60000,1200]execVM "zbe_cache\main.sqf";
		}else{
			[AI_SpawnDis,12,false,1000,60000,1200]execVM "zbe_cache\main.sqf";
		};
	};	
};

// Init Player
if (!isDedicated && hasInterface) then
{
	[] spawn {
		#include "add_diary.sqf"
		waitUntil {!isNull player && player == player};
		if (DebugEnabled isEqualTo 0) then {["BIS_ScreenSetup", false] call BIS_fnc_blackOut;};
		call compile preprocessFile "INSfncs\client_fncs.sqf";
		call compile preprocessFile "ATM_airdrop\functions.sqf";
		getLoadout = compile preprocessFileLineNumbers 'scripts\get_loadout.sqf';
		setLoadout = compile preprocessFileLineNumbers 'scripts\set_loadout.sqf';
		player sideChat localize "STR_BMR_loading";

		if (!isServer) then {
			["BIS_introPreload", "onPreloadFinished", {
				["BIS_introPreload", "onPreloadFinished"] call BIS_fnc_removeStackedEventHandler;
				missionNamespace setVariable ["BIS_readyForIntro", true];
			}] call BIS_fnc_addStackedEventHandler;

			waitUntil {
				!isNil { missionNamespace getVariable "BIS_readyForIntro" };
			};

			if (isJIP) then {uiSleep 3;};
		};

		call compile preprocessFile "init_player.sqf";
		[] call compile preprocessFile "INSui\UI\HUD.sqf";
		0 = [] execVM 'scripts\player_markers.sqf';
		execVM "BTK\Cargo Drop\Start.sqf";
	};
};
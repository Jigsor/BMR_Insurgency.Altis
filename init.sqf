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

if (isMultiplayer) then {
	enableSaving [false, false];

	// Init Headless Client
	if (!hasInterface && !isDedicated) then {
		call BMRINS_fnc_HCpresent;
		call compile preProcessFileLineNumbers "INSfncs\hc\headless_client_fncs.sqf";
		diag_log format ["HEADLESSCLIENT: %1 Connected HEADLESSCLIENT ID: %2", name player, owner player];

		[] spawn {
			if (!isJIP) then {waitUntil {time > 3}};
			waitUntil {!isNil "all_eos_mkrs"};
			if (INS_mod_missing) then {[] spawn INS_missing_mods};
			if ((INS_persistence isEqualTo 0) || (INS_persistence isEqualTo 2)) then {profileNamespace setVariable ["BMR_INS_progress", []]};

			private _enableLogs = true;// set false to disable logging on headless client(s) .rpt Frames per second, Headless client ID, Total group count, Total unit count.
			private "_AllEnemyGroups";
			private _uncapturedMkrs = all_eos_mkrs;
			private _c = if (INS_persistence isEqualTo 1 || INS_persistence isEqualTo 2) then {0} else {7};
			private _s = if (INS_persistence isEqualTo 1 || INS_persistence isEqualTo 2) then {true}else{false};

			while {true} do {
				sleep 60.123;
				if (_enableLogs) then {
					_AllEnemyGroups=[];
					{_AllEnemyGroups pushBack _x} forEach (allGroups select {side _x isEqualTo INS_Op4_side});
					diag_log format ["HEADLESSCLIENT FPS: %1 TIME: %2 IDCLIENT: %3 TOTAL ENEMY GROUPS: %4 TOTAL UNITS: %5", diag_fps, time, owner player, count _AllEnemyGroups, count allUnits];
				};
				//Save progression approximately every 5 minutes if lobby option permits.
				if (_s && {_c isEqualTo 6}) then {
					{if (getMarkerColor _x isEqualTo "colorGreen") then {_uncapturedMkrs = _uncapturedMkrs - [_x]; sleep 0.1};} foreach _uncapturedMkrs;
					profileNamespace setVariable ["BMR_INS_progress", _uncapturedMkrs];
					_c = 0;
				};
				if !(_c isEqualTo 7) then {_c = _c + 1};
				if (_c isEqualTo 5) then {[] spawn HC_deleteEmptyGrps};
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
Remedy_SEHs_fnc = call compile preprocessFile "INSfncs\common\Remedy_SEHs_fnc.sqf";
call compile preProcessFileLineNumbers "INSfncs\common\commom_fncs.sqf";
call compile preprocessFile "=BTC=_TK_punishment\=BTC=_tk_init.sqf";
if (INS_p_rev < 4) then {
	call compile preprocessFile "=BTC=_revive\=BTC=_revive_init.sqf";
}else{
	if (INS_p_rev isEqualTo 4 || INS_p_rev isEqualTo 5) then {
		call compile preprocessFile "=BTC=_q_revive\config.sqf";
	};
};
if (INS_IEDs isEqualTo 1 && !IamHC) then {
	if !(INS_op_faction isEqualTo 17) then {[] spawn {call compile preprocessFileLineNumbers "EPD\Ied_Init.sqf"}};
};

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
	// CSAT Pacific Apex (no mods)
		[EAST,3,3]execVM "eos\OpenMe.sqf";
	};
	case 5: {
	// CSAT Pacific and Syndikat Apex (no mods)
		[EAST,3,4]execVM "eos\OpenMe.sqf";
	};
	case 6: {
	// RHS - Armed Forces of the Russian Federation (@RHSAFRF)
		if (isClass(configFile >> "cfgPatches" >> "rhs_c_troops")) then {
			activateAddons ["rhs_c_troops","rhs_c_heavyweapons","rhs_c_btr","rhs_c_bmp","rhs_c_bmp3","rhs_c_cars","rhs_c_trucks","rhs_c_a2port_car","rhs_c_a2port_armor","rhs_c_tanks","rhs_c_t72","rhs_c_sprut","rhs_c_a2port_air","rhs_c_air","RHS_A2_CarsImport","RHS_A2_AirImport","rhs_c_a3retex","rhs_c_mig29"];
			[EAST,5,5]execVM "eos\OpenMe.sqf";

			// (optional/not required) United States Armed Forces (@RHSUSAF). Vehicles will be available in Vehicle Reward.
			if (isClass(configFile >> "cfgPatches" >> "rhsusf_main")) then {
				activateAddons ["rhsusf_main","rhsusf_c_troops","rhsusf_c_statics","rhsusf_vehicles","rhsusf_c_hmmwv","rhsusf_c_rg33","rhsusf_c_m1117","rhsusf_c_fmtv","rhsusf_c_HEMTT_A4","RHS_US_A2Port_Armor","rhsusf_c_m113","rhsusf_c_m109","rhsusf_c_m1a1","RHS_US_A2_AirImport","rhsusf_c_f22","rhsusf_c_melb","rhsusf_c_markvsoc","rhsusf_c_Caiman","rhsusf_c_RG33L"];
			};
		}else{INS_mod_missing = true;};
	};
	case 7: {
	// RHS - DESERT Armed Forces of the Russian Federation (@RHSAFRF)
		if (isClass(configFile >> "cfgPatches" >> "rhs_c_troops")) then {
			activateAddons ["rhs_c_troops","rhs_c_heavyweapons","rhs_c_btr","rhs_c_bmp","rhs_c_bmp3","rhs_c_cars","rhs_c_trucks","rhs_c_a2port_car","rhs_c_a2port_armor","rhs_c_tanks","rhs_c_t72","rhs_c_sprut","rhs_c_a2port_air","rhs_c_air","RHS_A2_CarsImport","RHS_A2_AirImport","rhs_c_a3retex","rhs_c_mig29"];
			[EAST,6,6]execVM "eos\OpenMe.sqf";

			// (optional/not required) United States Armed Forces (@RHSUSAF). Vehicles will be available in Vehicle Reward.
			if (isClass(configFile >> "cfgPatches" >> "rhsusf_main")) then {
				activateAddons ["rhsusf_main","rhsusf_c_troops","rhsusf_c_statics","rhsusf_vehicles","rhsusf_c_hmmwv","rhsusf_c_rg33","rhsusf_c_m1117","rhsusf_c_fmtv","rhsusf_c_HEMTT_A4","RHS_US_A2Port_Armor","rhsusf_c_m113","rhsusf_c_m109","rhsusf_c_m1a1","RHS_US_A2_AirImport","rhsusf_c_f22","rhsusf_c_melb","rhsusf_c_markvsoc","rhsusf_c_Caiman","rhsusf_c_RG33L"];
			};
		}else{INS_mod_missing = true;};
	};
	case 8: {
	// RHS - GREF (@RHSAFRF;@RHSUSAF;@RHSGREF)
		_requiredAddons = ["rhs_c_troops","rhsusf_main","rhsgref_c_troops"];
		if ({isClass(configFile >> "cfgPatches" >> _x)} count _requiredAddons == count _requiredAddons) then {
			activateAddons ["rhs_c_troops","rhs_c_heavyweapons","rhs_c_btr","rhs_c_bmp","rhs_c_bmp3","rhs_c_cars","rhs_c_trucks","rhs_c_a2port_car","rhs_c_a2port_armor","rhs_c_tanks","rhs_c_t72","rhs_c_sprut","rhs_c_a2port_air","rhs_c_air","RHS_A2_CarsImport","RHS_A2_AirImport","rhs_c_a3retex","rhs_c_mig29"];
			activateAddons ["rhsusf_main","rhsusf_c_troops","rhsusf_c_statics","rhsusf_vehicles","rhsusf_c_hmmwv","rhsusf_c_rg33","rhsusf_c_m1117","rhsusf_c_fmtv","rhsusf_c_HEMTT_A4","RHS_US_A2Port_Armor","rhsusf_c_m113","rhsusf_c_m109","rhsusf_c_m1a1","RHS_US_A2_AirImport","rhsusf_c_f22","rhsusf_c_melb","rhsusf_c_markvsoc","rhsusf_c_Caiman","rhsusf_c_RG33L"];
			activateAddons ["rhsgref_c_troops","rhsgref_c_vehicles_ret","rhs_cti_insurgents","rhsgref_c_air","rhsgref_c_tohport_air"];
			[RESISTANCE,7,8]execVM "eos\OpenMe.sqf";
		}else{INS_mod_missing = true;};
	};
	case 9: {
	// RHS - RHS Serbia (@RHSAFRF;@RHSUSAF;@RHSGREF;@RHSSAF)
		_requiredAddons = ["rhs_c_troops","rhsusf_main","rhsgref_c_troops","rhssaf_main"];
		if ({isClass(configFile >> "cfgPatches" >> _x)} count _requiredAddons == count _requiredAddons) then {
			activateAddons ["rhs_c_troops","rhs_c_heavyweapons","rhs_c_btr","rhs_c_bmp","rhs_c_bmp3","rhs_c_cars","rhs_c_trucks","rhs_c_a2port_car","rhs_c_a2port_armor","rhs_c_tanks","rhs_c_t72","rhs_c_sprut","rhs_c_a2port_air","rhs_c_air","RHS_A2_CarsImport","RHS_A2_AirImport","rhs_c_a3retex","rhs_c_mig29"];
			activateAddons ["rhsusf_main","rhsusf_c_troops","rhsusf_c_statics","rhsusf_vehicles","rhsusf_c_hmmwv","rhsusf_c_rg33","rhsusf_c_m1117","rhsusf_c_fmtv","rhsusf_c_HEMTT_A4","RHS_US_A2Port_Armor","rhsusf_c_m113","rhsusf_c_m109","rhsusf_c_m1a1","RHS_US_A2_AirImport","rhsusf_c_f22","rhsusf_c_melb","rhsusf_c_markvsoc","rhsusf_c_Caiman","rhsusf_c_RG33L"];
			activateAddons ["rhsgref_c_troops","rhsgref_c_vehicles_ret","rhs_cti_insurgents","rhsgref_c_air","rhsgref_c_tohport_air"];
			activateAddons ["rhssaf_main","rhssaf_c_gear","rhssaf_c_troops","rhssaf_c_vehicles"];
			[RESISTANCE,9,9]execVM "eos\OpenMe.sqf";
		}else{INS_mod_missing = true;};
	};
	case 10: {
	// Leight's Opfor Pack - Islamic State of Takistan/Sahrani and Afghan Militia (@RHSAFRF;@RHSUSAF; + (@leights_opfor or @Project_OPFOR))
		if ((isClass(configFile >> "cfgPatches" >> "rhs_main")) &&
		{(isClass(configFile >> "cfgPatches" >> "lop_main"))}) then {
			activateAddons ["rhs_main","rhs_weapons","rhsusf_main","rhs_c_troops","rhs_c_btr","rhs_c_bmp","rhs_c_tanks","rhs_c_a2port_armor","RHS_A2_CarsImport","RHS_A2_AirImport","rhsusf_c_heavyweapons","rhsusf_c_weapons","rhs_c_a2port_air","lop_faction_ists","lop_faction_am","lop_faction_sla","lop_faction_ia","lop_faction_cdf","lop_faction_tak_civ"];
			[RESISTANCE,10,11]execVM "eos\OpenMe.sqf";
		}else{INS_mod_missing = true;};
	};
	case 11: {
	// Iraqi-Syrian Conflict (@RHSAFRF;@RHSUSAF;@RHSGREF;@RHSSAF;@ISC;)
		_requiredAddons = ["rhs_c_troops","rhsusf_main","rhsgref_c_troops","rhssaf_main","Iraqi_Syrian_Conflict","Iraqi_Syrian_Conflict_v"];
		if ({isClass(configFile >> "cfgPatches" >> _x)} count _requiredAddons == count _requiredAddons) then {
			activateAddons ["Iraqi_Syrian_Conflict","Iraqi_Syrian_Conflict_v"];
			[EAST,12,13]execVM "eos\OpenMe.sqf";
		}else{INS_mod_missing = true;};
	};
	case 12: {
	// CUP - Takistan Army and Takistan Militia (@CBA_A3;@cup_units;@cup_weapons;@cup_vehicles)
		_requiredAddons = ["CUP_Creatures_Military_Taki","asdg_jointrails","CUP_Creatures_People_Military_DummyInfantrySet","CUP_Creatures_People_Civil_Chernarus","CUP_WheeledVehicles_LR","CUP_WheeledVehicles_UAZ","CUP_WheeledVehicles_Ural","CUP_WheeledVehicles_BRDM2","CUP_WheeledVehicles_BTR60","CUP_TrackedVehicles_M113","CUP_TrackedVehicles_T55","CUP_TrackedVehicles_T72","CUP_TrackedVehicles_ZSU23","cup_watervehicles_rhib","CUP_AirVehicles_Su25","CUP_AirVehicles_AN2","CUP_AirVehicles_UH1H","CUP_AirVehicles_Mi8","CUP_AirVehicles_Mi24","CUP_AirVehicles_L39","CUP_Creatures_Military_SLA","CUP_AirVehicles_Ka50"];
		if ({isClass(configFile >> "cfgPatches" >> _x)} count _requiredAddons == count _requiredAddons) then {
			activateAddons ["asdg_jointrails","asdg_jointmuzzles","CUP_Creatures_Military_Taki","CUP_Creatures_People_Military_DummyInfantrySet","CUP_Creatures_People_Civil_Chernarus","CUP_WheeledVehicles_LR","CUP_WheeledVehicles_UAZ","CUP_WheeledVehicles_Ural","CUP_WheeledVehicles_BRDM2","CUP_WheeledVehicles_BTR60","CUP_TrackedVehicles_M113","CUP_TrackedVehicles_T55","CUP_TrackedVehicles_T72","CUP_TrackedVehicles_ZSU23","cup_watervehicles_rhib","CUP_AirVehicles_Su25","CUP_AirVehicles_AN2","CUP_AirVehicles_UH1H","CUP_AirVehicles_Mi8","CUP_AirVehicles_Mi24","CUP_WheeledVehicles_V3S","CUP_Creatures_People_Civil_Takistan","CUP_AirVehicles_L39","CUP_Creatures_Military_SLA","CUP_AirVehicles_Ka50"];
			[EAST,14,15]execVM "eos\OpenMe.sqf";
		}else{INS_mod_missing = true;};
	};
	case 13: {
	// Middle East Warfare - CSAT Army and Middle East Insurgents, NATO SF and Russian Spetsnaz Weapons, NATO Russsian Vehicles (@CBA_A3;@MiddleEastWarfare;@NATO_Rus_Weapons_CBA;@NATO_Rus_Vehicle)
		_requiredAddons = ["CBA_main","asdg_jointrails","mas_med_rebl_army_HD","mas_med_rebl_civ_HD","mas_med_rebl_civ","mas_HMMWV","mas_apc","mas_brdm","mas_CH47","mas_veh_F_35C","mas_cars_Hilux","mas_cars_LR","mas_MI24","mas_MI8"];
		if ({isClass(configFile >> "cfgPatches" >> _x)} count _requiredAddons == count _requiredAddons) then {
			activateAddons ["CBA_main","asdg_jointrails","asdg_jointmuzzles","mas_med_rebl_army_HD","mas_med_rebl_civ_HD","mas_med_rebl_civ","mas_HMMWV","mas_apc","mas_brdm","mas_CH47","mas_veh_F_35C","mas_cars_Hilux","mas_cars_LR","mas_MI24","mas_MI8"];
			[EAST,16,17]execVM "eos\OpenMe.sqf";
		}else{INS_mod_missing = true;};
	};
	case 14: {
	// Middle East Warfare - Takistan Army and Takistan Insurgents, NATO SF and Russian Spetsnaz Weapons, NATO Russsian Vehicles (@CBA_A3;@MiddleEastWarfare;@NATO_Rus_Weapons_CBA;@NATO_Rus_Vehicle)
		_requiredAddons = ["CBA_main","asdg_jointrails","mas_med_rebl_army_HD","mas_med_rebl_ins_HD","mas_med_rebl_c","mas_HMMWV","mas_apc","mas_brdm","mas_CH47","mas_veh_F_35C","mas_cars_Hilux","mas_cars_LR","mas_MI24","mas_MI8"];
		if ({isClass(configFile >> "cfgPatches" >> _x)} count _requiredAddons == count _requiredAddons) then {
			activateAddons ["CBA_main","asdg_jointrails","asdg_jointmuzzles","mas_med_rebl_army_HD","mas_med_rebl_ins_HD","mas_med_rebl_c","mas_HMMWV","mas_apc","mas_brdm","mas_CH47","mas_veh_F_35C","mas_cars_Hilux","mas_cars_LR","mas_MI24","mas_MI8"];
			[EAST,18,19]execVM "eos\OpenMe.sqf";
		}else{INS_mod_missing = true;};
	};
	case 15: {
	// African Conflict, NATO SF and Russian Spetsnaz Weapons, NATO Russsian Vehicles (@CBA_A3;@AfricanConflict_mas;@NATO_Rus_Weapons_CBA;@NATO_Rus_Vehicle)
		_requiredAddons = ["asdg_jointrails","mas_afr_rebl_c","mas_afr_rebl","mas_HMMWV","mas_apc","mas_brdm","mas_CH47","mas_veh_F_35C","mas_cars_Hilux","mas_cars_LR","mas_MI24","mas_MI8"];
		if ({isClass(configFile >> "cfgPatches" >> _x)} count _requiredAddons == count _requiredAddons) then {
			activateAddons ["asdg_jointrails","asdg_jointmuzzles","mas_afr_rebl_c","mas_afr_rebl","mas_HMMWV","mas_apc","mas_brdm","mas_CH47","mas_veh_F_35C","mas_cars_Hilux","mas_cars_LR","mas_MI24","mas_MI8"];
			[EAST,20,21]execVM "eos\OpenMe.sqf";
		}else{INS_mod_missing = true;};
	};
	case 16: {
	// OPTRE Insurrection (@CBA_A3;@OPTRE)
		_requiredAddons = ["CBA_main","OPTRE_Core"];
		if ({isClass(configFile >> "cfgPatches" >> _x)} count _requiredAddons == count _requiredAddons) then {
			activateAddons ["CBA_main","OPTRE_Core","OPTRE_Vehicles","OPTRE_Ins_Units","OPTRE_Hud","OPTRE_CAA_Units"];
			[EAST,22,23]execVM "eos\OpenMe.sqf";
		}else{INS_mod_missing = true;};
	};
	case 17: {
	// IFA3 Desert US Army (@CBA_A3;@CUP_Terrains_Core;@CUP_Terrains_Maps;@IFA3_Terrains_LITE;@I44_Terrains@IFA3_LITE;@IFA3_Objects_LITE)
		_requiredAddons = ["WW2_Assets_c_Characters_Americans_c_US_Rangers"];
		if ({isClass(configFile >> "cfgPatches" >> _x)} count _requiredAddons == count _requiredAddons) then {
			activateAddons ["WW2_Assets_c_Characters_Americans_c_US_Rangers","WW2_Core_c_EditorPreviews_c","WW2_Assets_c_Characters_Americans_c_US_Army","WW2_Assets_c_Vehicles_StaticWeapons_c_Towing","WW2_Assets_c_Vehicles_WheeledAPC_c_M3_Halftrack","WW2_Assets_c_Vehicles_Extended_HUD_c","WW2_Assets_c_Vehicles_ModelConfig_c","WW2_Core_c_Core_c_Eventhandlers","WW2_Assets_c_Vehicles_Boats_c_LCVP","WW2_Assets_c_Vehicles_TurretsConfig_c","WW2_Assets_s_Megagoth1702_Sounds_Config_CfgVehicles","WW2_Assets_c_Vehicles_Wheeled_c_GMC","WW2_Assets_c_Characters_Americans_c_US_NAC","WW2_Core_c_Core_c_Explosion","WW2_Assets_c_Vehicles_Wheeled_c_Scout_M3","WW2_Assets_c_Vehicles_Wheeled_c_Willys_MB","WW2_Assets_c_Vehicles_Planes_c_P39","WW2_Assets_c_Vehicles_Planes_c_P47","WW2_Assets_c_Characters_Civilians_c_CIV_French","WW2_Assets_c_Vehicles_Tanks_c_M4A3_75","WW2_Assets_c_Vehicles_Wheeled_c_Zis5v","WW2_Assets_c_Characters_Civilians_c_CIV_Civilians"];
			[RESISTANCE,24,24]execVM "eos\OpenMe.sqf";
		} else {INS_mod_missing = true;};
	};
};
if (isServer && {CiviFoot isEqualTo 1}) then {[]execVM "eos_civ\OpenMeCiv.sqf"};// Civilians

// Common Scripts
execVM "Objectives\shk_taskmaster.sqf";
if ((JigHeliExtraction isEqualTo 1) && {!IamHC}) then {null = [] execVM "JIG_EX\extraction_init.sqf"};
if (CiviMobiles > 0) then {[CiviMobiles, 400, 500] execVM "scripts\MAD_traffic.sqf"};
if (INS_logistics > 0) then {_logistic = execVM "=BTC=_Logistic\=BTC=_logistic_init.sqf"};
if (INS_logistics > 1) then {[] execVM "scripts\fn_advancedSlingLoadingInit.sqf"};
if (max_ai_recruits > 1) then {execVM "bon_recruit_units\init.sqf"};
if (INS_IEDs isEqualTo 2) then {execVM "scripts\JigIEDs.sqf"};
execVM "JWC_CASFS\initCAS.sqf";
nul = ["mission"] execVM "hcam_init.sqf";

// Init Server
if (isServer) then
{
	call compile preprocessFile "init_server.sqf";
	call compile preprocessFileLineNumbers "INSfncs\server\AirPatrole_Fncs.sqf";
	rej_fnc_bezier = compile preProcessFileLineNumbers "INSfncs\server\rej_fnc_bezier.sqf";

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
		waitUntil {!isNull player && player == player};
		#include "add_diary.sqf"
		if (DebugEnabled isEqualTo 0) then {["BIS_ScreenSetup", false] call BIS_fnc_blackOut};
		call compile preProcessFileLineNumbers "INSfncs\client\client_fncs.sqf";
		call compile preProcessFileLineNumbers "ATM_airdrop\functions.sqf";

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
		call compile preprocessFile "INSui\UI\HUD.sqf";
		if (INS_Player_Markers isEqualTo 1) then {0 = [] execVM 'scripts\player_markers.sqf';};
		execVM "scripts\zlt_fastrope.sqf";
	};
};
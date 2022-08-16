if (!isServer && {isNull player}) then {isJIP=true;} else {isJIP=false; if (didJIP) then {isJIP=true;};};

// Set friendly/enemy sides
EAST setFriend [WEST, 0];
WEST setFriend [EAST, 0];
RESISTANCE setFriend [WEST, 0];
RESISTANCE setFriend [EAST, 1];
EAST setFriend [RESISTANCE, 1];
WEST setFriend [RESISTANCE, 0];

call BMRINS_fnc_AI_unitPools;

if (isMultiplayer) then {
	enableSaving [false, false];

	// Init Headless Client
	if (!hasInterface && !isDedicated) then {
		call BMRINS_fnc_HCpresent;
		call compile preProcessFileLineNumbers "INSfncs\hc\headless_client_fncs.sqf";

		0 = 0 spawn {
			if (isJIP) then {waitUntil {!isNull player}} else {waitUntil {time > 3}};
			diag_log format ["***HEADLESSCLIENT: %1 Connected HEADLESSCLIENT ID: %2", name player, owner player];
			if (INS_mod_missing) then {0 spawn INS_missing_mods};

			private _enableLogs = true;// set false to disable logging on headless client(s) .rpt Frames per second, Headless client ID, Total enemy groups, Total units.
			private "_AllEnemyGroups";
			private _c = 0;

			0 spawn {waitUntil {time > 0}; enableEnvironment [false, false]; setShadowDistance 0;};

			while {true} do {
				sleep 60.123;
				if (_enableLogs) then {
					_AllEnemyGroups=[];
					{_AllEnemyGroups pushBack _x} forEach (allGroups select {side _x isEqualTo INS_Op4_side});
					diag_log format ["HEADLESSCLIENT FPS: %1 TIME: %2 IDCLIENT: %3 TOTAL ENEMY GROUPS: %4 TOTAL UNITS: %5", diag_fps, time, owner player, count _AllEnemyGroups, count allUnits];
				};
				//Delete empty groups every 5 minutes.
				_c = _c + 1;
				if (_c isEqualTo 5) then {
					call HC_deleteEmptyGrps;
					_c = 0;
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
call compile preProcessFileLineNumbers "INS_definitions.sqf";
Remedy_SEHs_fnc = call compileFinal preprocessFileLineNumbers "INSfncs\common\Remedy_SEHs_fnc.sqf";
call compile preProcessFileLineNumbers "INSfncs\common\commom_fncs.sqf";
call compile preProcessFileLineNumbers "=BTC=_TK_punishment\=BTC=_tk_init.sqf";
if (INS_p_rev < 4 || {INS_p_rev in [6,7] && (!INS_ACE_med)}) then {
	call compile preprocessFileLineNumbers "=BTC=_revive\=BTC=_revive_init.sqf";
}else{
	if (INS_p_rev in [4,5]) then {
		call compile preprocessFile "=BTC=_q_revive\config.sqf";
	};
};
if (INS_IEDs isEqualTo 1 && !IamHC) then {
	if !(INS_op_faction in [21]) then {0 spawn {call compile preprocessFileLineNumbers "EPD\Ied_Init.sqf"}};
};

// EOS
private _requiredAddons = [];
switch (INS_op_faction) do {
	case 1: {
	// CSAT (no mods)
		[EAST]execVM "eos\OpenMe.sqf";
	};
	case 2: {
	// AAF (no mods)
		[RESISTANCE]execVM "eos\OpenMe.sqf";
	};
	case 3: {
	// AAF and FIA (no mods)
		[RESISTANCE]execVM "eos\OpenMe.sqf";
	};
	case 4: {
	// CSAT Pacific Apex (no mods)
		[EAST]execVM "eos\OpenMe.sqf";
	};
	case 5: {
	// CSAT Pacific and Syndikat Apex (no mods)
		[EAST]execVM "eos\OpenMe.sqf";
	};
	case 6: {
	// LDF and Spetsnaz Contact (no mods)
		[RESISTANCE]execVM "eos\OpenMe.sqf";
	};
	case 7: {
	// LDF and Looters Contact (no mods)
		[RESISTANCE]execVM "eos\OpenMe.sqf";
	};
	case 8: {
	// Spetsnaz and FIA Contact (no mods)
		[EAST]execVM "eos\OpenMe.sqf";
	};
	case 9: {
	// RHS - Armed Forces of the Russian Federation (@RHSAFRF)
		if (isClass(configFile >> "cfgPatches" >> "rhs_c_troops")) then {
			activateAddons ["rhs_c_troops","rhs_c_heavyweapons","rhs_c_btr","rhs_c_bmp","rhs_c_bmp3","rhs_c_cars","rhs_c_trucks","rhs_c_a2port_car","rhs_c_a2port_armor","rhs_c_tanks","rhs_c_t72","rhs_c_sprut","rhs_c_a2port_air","rhs_c_air","RHS_A2_CarsImport","RHS_A2_AirImport","rhs_c_a3retex","rhs_c_mig29"];
			[EAST]execVM "eos\OpenMe.sqf";

			// (optional/not required) United States Armed Forces (@RHSUSAF). Vehicles will be available in Vehicle Reward.
			if (isClass(configFile >> "cfgPatches" >> "rhsusf_main")) then {
				activateAddons ["rhsusf_main","rhsusf_c_troops","rhsusf_c_statics","rhsusf_vehicles","rhsusf_c_hmmwv","rhsusf_c_rg33","rhsusf_c_m1117","rhsusf_c_fmtv","rhsusf_c_HEMTT_A4","RHS_US_A2Port_Armor","rhsusf_c_m113","rhsusf_c_m109","rhsusf_c_m1a1","RHS_US_A2_AirImport","rhsusf_c_f22","rhsusf_c_melb","rhsusf_c_markvsoc","rhsusf_c_Caiman","rhsusf_c_RG33L","rhsusf_c_Cougar","rhsusf_c_himars"];
			};
		}else{INS_mod_missing = true;};
	};
	case 10: {
	// RHS - DESERT Armed Forces of the Russian Federation (@RHSAFRF)
		if (isClass(configFile >> "cfgPatches" >> "rhs_c_troops")) then {
			activateAddons ["rhs_c_troops","rhs_c_heavyweapons","rhs_c_btr","rhs_c_bmp","rhs_c_bmp3","rhs_c_cars","rhs_c_trucks","rhs_c_a2port_car","rhs_c_a2port_armor","rhs_c_tanks","rhs_c_t72","rhs_c_sprut","rhs_c_a2port_air","rhs_c_air","RHS_A2_CarsImport","RHS_A2_AirImport","rhs_c_a3retex","rhs_c_mig29"];
			[EAST]execVM "eos\OpenMe.sqf";

			// (optional/not required) United States Armed Forces (@RHSUSAF). Vehicles will be available in Vehicle Reward.
			if (isClass(configFile >> "cfgPatches" >> "rhsusf_main")) then {
				activateAddons ["rhsusf_main","rhsusf_c_troops","rhsusf_c_statics","rhsusf_vehicles","rhsusf_c_hmmwv","rhsusf_c_rg33","rhsusf_c_m1117","rhsusf_c_fmtv","rhsusf_c_HEMTT_A4","RHS_US_A2Port_Armor","rhsusf_c_m113","rhsusf_c_m109","rhsusf_c_m1a1","RHS_US_A2_AirImport","rhsusf_c_f22","rhsusf_c_melb","rhsusf_c_markvsoc","rhsusf_c_Caiman","rhsusf_c_RG33L","rhsusf_c_Cougar","rhsusf_c_himars"];
			};
		}else{INS_mod_missing = true;};
	};
	case 11: {
	// RHS - GREF (@RHSAFRF;@RHSUSAF;@RHSGREF)
		_requiredAddons = ["rhs_c_troops","rhsusf_main","rhsgref_c_troops"];
		if ({isClass(configFile >> "cfgPatches" >> _x)} count _requiredAddons == count _requiredAddons) then {
			activateAddons ["rhs_c_troops","rhs_c_heavyweapons","rhs_c_btr","rhs_c_bmp","rhs_c_bmp3","rhs_c_cars","rhs_c_trucks","rhs_c_a2port_car","rhs_c_a2port_armor","rhs_c_tanks","rhs_c_t72","rhs_c_sprut","rhs_c_a2port_air","rhs_c_air","RHS_A2_CarsImport","RHS_A2_AirImport","rhs_c_a3retex","rhs_c_mig29"];
			activateAddons ["rhsusf_main","rhsusf_c_troops","rhsusf_c_statics","rhsusf_vehicles","rhsusf_c_hmmwv","rhsusf_c_rg33","rhsusf_c_m1117","rhsusf_c_fmtv","rhsusf_c_HEMTT_A4","RHS_US_A2Port_Armor","rhsusf_c_m113","rhsusf_c_m109","rhsusf_c_m1a1","RHS_US_A2_AirImport","rhsusf_c_f22","rhsusf_c_melb","rhsusf_c_markvsoc","rhsusf_c_Caiman","rhsusf_c_RG33L","rhsusf_c_Cougar","rhsusf_c_himars"];
			activateAddons ["rhsgref_c_troops","rhsgref_c_vehicles_ret","rhs_cti_insurgents","rhsgref_c_air","rhsgref_c_tohport_air","rhsgref_c_a2port_armor"];
			[RESISTANCE]execVM "eos\OpenMe.sqf";
		}else{INS_mod_missing = true;};
	};
	case 12: {
	// RHS - RHS Serbia (@RHSAFRF;@RHSUSAF;@RHSGREF;@RHSSAF)
		_requiredAddons = ["rhs_c_troops","rhsusf_main","rhsgref_c_troops","rhssaf_main"];
		if ({isClass(configFile >> "cfgPatches" >> _x)} count _requiredAddons == count _requiredAddons) then {
			activateAddons ["rhs_c_troops","rhs_c_heavyweapons","rhs_c_btr","rhs_c_bmp","rhs_c_bmp3","rhs_c_cars","rhs_c_trucks","rhs_c_a2port_car","rhs_c_a2port_armor","rhs_c_tanks","rhs_c_t72","rhs_c_sprut","rhs_c_a2port_air","rhs_c_air","RHS_A2_CarsImport","RHS_A2_AirImport","rhs_c_a3retex","rhs_c_mig29"];
			activateAddons ["rhsusf_main","rhsusf_c_troops","rhsusf_c_statics","rhsusf_vehicles","rhsusf_c_hmmwv","rhsusf_c_rg33","rhsusf_c_m1117","rhsusf_c_fmtv","rhsusf_c_HEMTT_A4","RHS_US_A2Port_Armor","rhsusf_c_m113","rhsusf_c_m109","rhsusf_c_m1a1","RHS_US_A2_AirImport","rhsusf_c_f22","rhsusf_c_melb","rhsusf_c_markvsoc","rhsusf_c_Caiman","rhsusf_c_RG33L","rhsusf_c_Cougar","rhsusf_c_himars"];
			activateAddons ["rhsgref_c_troops","rhsgref_c_vehicles_ret","rhs_cti_insurgents","rhsgref_c_air","rhsgref_c_tohport_air","rhsgref_c_a2port_armor"];
			activateAddons ["rhssaf_main","rhssaf_c_gear","rhssaf_c_troops","rhssaf_c_vehicles"];
			[RESISTANCE]execVM "eos\OpenMe.sqf";
		}else{INS_mod_missing = true;};
	};
	case 13: {
	// Project OPFOR - Islamic State of Takistan/Sahrani and Afghan Militia (@RHSAFRF;@RHSUSAF;@RHSGREF;@Project_OPFOR)
		if ((isClass(configFile >> "cfgPatches" >> "rhs_main")) &&
		{(isClass(configFile >> "cfgPatches" >> "lop_main"))}) then {
			activateAddons ["rhs_main","rhs_weapons","rhsusf_main","rhs_c_troops","rhs_c_btr","rhs_c_bmp","rhs_c_tanks","rhs_c_a2port_armor","RHS_A2_CarsImport","RHS_A2_AirImport","rhsusf_c_heavyweapons","rhsusf_c_weapons","rhs_c_a2port_air","lop_faction_ists","lop_faction_am","lop_faction_sla","lop_faction_ia","lop_faction_cdf","lop_faction_tak_civ"];
			[RESISTANCE]execVM "eos\OpenMe.sqf";
		}else{INS_mod_missing = true;};
	};
	case 14: {
	// Iraqi-Syrian Conflict (@RHSAFRF;@RHSUSAF;@RHSGREF;@RHSSAF;@ISC;)
		_requiredAddons = ["rhs_c_troops","rhsusf_main","rhsgref_c_troops","rhssaf_main","Iraqi_Syrian_Conflict","Iraqi_Syrian_Conflict_v"];
		if ({isClass(configFile >> "cfgPatches" >> _x)} count _requiredAddons == count _requiredAddons) then {
			activateAddons ["Iraqi_Syrian_Conflict","Iraqi_Syrian_Conflict_v"];
			[EAST]execVM "eos\OpenMe.sqf";
		}else{INS_mod_missing = true;};
	};
	case 15: {
	// CUP - Takistan Army and Takistan Militia (@CBA_A3;@cup_units;@cup_weapons;@cup_vehicles)
		_requiredAddons = ["CUP_Creatures_Military_Taki","asdg_jointrails","CUP_Creatures_People_Military_DummyInfantrySet","CUP_Creatures_People_Civil_Chernarus","CUP_WheeledVehicles_LR","CUP_WheeledVehicles_UAZ","CUP_WheeledVehicles_Ural","CUP_WheeledVehicles_BRDM2","CUP_WheeledVehicles_BTR60","CUP_TrackedVehicles_NewM113","CUP_TrackedVehicles_T55","CUP_TrackedVehicles_T72","CUP_TrackedVehicles_ZSU23","cup_watervehicles_rhib","CUP_AirVehicles_Su25","CUP_AirVehicles_AN2","CUP_AirVehicles_UH1H","CUP_AirVehicles_Mi8","CUP_AirVehicles_Mi24","CUP_AirVehicles_L39","CUP_Creatures_Military_SLA","CUP_AirVehicles_Ka50","CUP_WheeledVehicles_Datsun","CUP_WheeledVehicles_RG31","CUP_TrackedVehicles_M1_Abrams","CUP_TrackedVehicles_Bradley","CUP_WheeledVehicles_Stryker","CUP_TrackedVehicles_BMP","CUP_TrackedVehicles_MTLB","CUP_WheeledVehicles_Hilux"];
		if ({isClass(configFile >> "cfgPatches" >> _x)} count _requiredAddons == count _requiredAddons) then {
			activateAddons ["asdg_jointrails","asdg_jointmuzzles","CUP_Creatures_Military_Taki","CUP_Creatures_People_Military_DummyInfantrySet","CUP_Creatures_People_Civil_Chernarus","CUP_WheeledVehicles_LR","CUP_WheeledVehicles_UAZ","CUP_WheeledVehicles_Ural","CUP_WheeledVehicles_BRDM2","CUP_WheeledVehicles_BTR60","CUP_TrackedVehicles_NewM113","CUP_TrackedVehicles_T55","CUP_TrackedVehicles_T72","CUP_TrackedVehicles_ZSU23","cup_watervehicles_rhib","CUP_AirVehicles_Su25","CUP_AirVehicles_AN2","CUP_AirVehicles_UH1H","CUP_AirVehicles_Mi8","CUP_AirVehicles_Mi24","CUP_WheeledVehicles_V3S","CUP_Creatures_People_Civil_Takistan","CUP_AirVehicles_L39","CUP_Creatures_Military_SLA","CUP_AirVehicles_Ka50","CUP_WheeledVehicles_Datsun","CUP_WheeledVehicles_RG31","CUP_TrackedVehicles_M1_Abrams","CUP_TrackedVehicles_Bradley","CUP_WheeledVehicles_Stryker","CUP_TrackedVehicles_BMP","CUP_WheeledVehicles_BTR40","CUP_TrackedVehicles_MTLB","CUP_WheeledVehicles_Hilux"];
			[EAST]execVM "eos\OpenMe.sqf";
		}else{INS_mod_missing = true;};
	};
	case 16: {
	// CUP - CUP Armed Forces of the Russian Federation MSV (@CBA_A3;@cup_units;@cup_weapons;@cup_vehicles)
		_requiredAddons = ["CBA_main","asdg_jointrails","CUP_Creatures_Military_Russia","CUP_TrackedVehicles_2S6M","CUP_WheeledVehicles_Ural","CUP_TrackedVehicles_BMP","CUP_TrackedVehicles_BMP3","CUP_WheeledVehicles_BRDM2","CUP_WheeledVehicles_BTR60","CUP_WheeledVehicles_BTR90","CUP_WheeledVehicles_Vodnik","CUP_TrackedVehicles_MTLB","CUP_WheeledVehicles_Kamaz","CUP_WheeledVehicles_UAZ","CUP_AirVehicles_Pchela1T","CUP_AirVehicles_Ka50","CUP_AirVehicles_Ka52","CUP_AirVehciles_KA60","CUP_AirVehicles_Mi24","CUP_AirVehicles_MI6","CUP_AirVehicles_Mi8","CUP_AirVehicles_Su25","CUP_AirVehicles_SU34","CUP_TrackedVehicles_T72","CUP_TrackedVehicles_T90","CUP_Creatures_StaticWeapons","CUP_WheeledVehicles_TT650","CUP_Creatures_People_Civil_Russia","CUP_WheeledVehicles_Datsun","CUP_Wheeledvehicles_VWGolf","CUP_wheeledvehicles_Octaiva","CUP_WheeledVehicles_TowingTractor","CUP_WaterVehicles_Fishing_Boat","CUP_WaterVehicles_PBX","CUP_WaterVehicles_Zodiac","CUP_WheeledVehicles_Skoda","CUP_WheeledVehicles_S1203","CUP_WheeledVehicles_Ikarus","CUP_WheeledVehicles_Lada","CUP_Wheeled_SUV","CUP_WheeledVehicles_Tractor","CUP_AirVehicles_AN2","CUP_AirVehicles_AmbientPlanes","CUP_WheeledVehicles_RG31","CUP_TrackedVehicles_Bradley","CUP_TrackedVehicles_NewM113","CUP_WheeledVehicles_Stryker"];
		if ({isClass(configFile >> "cfgPatches" >> _x)} count _requiredAddons == count _requiredAddons) then {
			activateAddons ["CBA_main","asdg_jointrails","asdg_jointmuzzles","CUP_Creatures_Military_Russia","CUP_TrackedVehicles_2S6M","CUP_WheeledVehicles_Ural","CUP_TrackedVehicles_BMP","CUP_TrackedVehicles_BMP3","CUP_WheeledVehicles_BRDM2","CUP_WheeledVehicles_BTR60","CUP_WheeledVehicles_BTR90","CUP_WheeledVehicles_Vodnik","CUP_TrackedVehicles_MTLB","CUP_WheeledVehicles_Kamaz","CUP_WheeledVehicles_UAZ","CUP_AirVehicles_Pchela1T","CUP_AirVehicles_Ka50","CUP_AirVehicles_Ka52","CUP_AirVehciles_KA60","CUP_AirVehicles_Mi24","CUP_AirVehicles_MI6","CUP_AirVehicles_Mi8","CUP_AirVehicles_Su25","CUP_AirVehicles_SU34","CUP_TrackedVehicles_T72","CUP_TrackedVehicles_T90","CUP_Creatures_StaticWeapons","CUP_WheeledVehicles_TT650","CUP_Creatures_People_Civil_Russia","CUP_WheeledVehicles_Datsun","CUP_Wheeledvehicles_VWGolf","CUP_wheeledvehicles_Octaiva","CUP_WheeledVehicles_TowingTractor","CUP_WaterVehicles_Fishing_Boat","CUP_WaterVehicles_PBX","CUP_WaterVehicles_Zodiac","CUP_WheeledVehicles_Skoda","CUP_WheeledVehicles_S1203","CUP_WheeledVehicles_Ikarus","CUP_WheeledVehicles_Lada","CUP_Wheeled_SUV","CUP_WheeledVehicles_Tractor","CUP_AirVehicles_AN2","CUP_AirVehicles_AmbientPlanes","CUP_WheeledVehicles_RG31","CUP_TrackedVehicles_Bradley","CUP_TrackedVehicles_NewM113","CUP_WheeledVehicles_Stryker","CUP_WheeledVehicles_BTR40"];
			[EAST]execVM "eos\OpenMe.sqf";
		}else{INS_mod_missing = true;};
	};
	case 17: {
	// Middle East Warfare - CSAT Army and Middle East Insurgents, NATO SF and Russian Spetsnaz Weapons, NATO Russsian Vehicles (@CBA_A3;@MiddleEastWarfare;@NATO_Rus_Weapons_CBA;@NATO_Rus_Vehicle)
		_requiredAddons = ["CBA_main","asdg_jointrails","mas_med_rebl_army_HD","mas_med_rebl_civ_HD","mas_med_rebl_civ","mas_HMMWV","mas_apc","mas_brdm","mas_CH47","mas_veh_F_35C","mas_cars_Hilux","mas_cars_LR","mas_MI24","mas_MI8"];
		if ({isClass(configFile >> "cfgPatches" >> _x)} count _requiredAddons == count _requiredAddons) then {
			activateAddons ["CBA_main","asdg_jointrails","asdg_jointmuzzles","mas_med_rebl_army_HD","mas_med_rebl_civ_HD","mas_med_rebl_civ","mas_HMMWV","mas_apc","mas_brdm","mas_CH47","mas_veh_F_35C","mas_cars_Hilux","mas_cars_LR","mas_MI24","mas_MI8"];
			[EAST]execVM "eos\OpenMe.sqf";
		}else{INS_mod_missing = true;};
	};
	case 18: {
	// Middle East Warfare - Takistan Army and Takistan Insurgents, NATO SF and Russian Spetsnaz Weapons, NATO Russsian Vehicles (@CBA_A3;@MiddleEastWarfare;@NATO_Rus_Weapons_CBA;@NATO_Rus_Vehicle)
		_requiredAddons = ["CBA_main","asdg_jointrails","mas_med_rebl_army_HD","mas_med_rebl_ins_HD","mas_med_rebl_c","mas_HMMWV","mas_apc","mas_brdm","mas_CH47","mas_veh_F_35C","mas_cars_Hilux","mas_cars_LR","mas_MI24","mas_MI8"];
		if ({isClass(configFile >> "cfgPatches" >> _x)} count _requiredAddons == count _requiredAddons) then {
			activateAddons ["CBA_main","asdg_jointrails","asdg_jointmuzzles","mas_med_rebl_army_HD","mas_med_rebl_ins_HD","mas_med_rebl_c","mas_HMMWV","mas_apc","mas_brdm","mas_CH47","mas_veh_F_35C","mas_cars_Hilux","mas_cars_LR","mas_MI24","mas_MI8"];
			[EAST]execVM "eos\OpenMe.sqf";
		}else{INS_mod_missing = true;};
	};
	case 19: {
	// African Conflict, NATO SF and Russian Spetsnaz Weapons, NATO Russsian Vehicles (@CBA_A3;@AfricanConflict_mas;@NATO_Rus_Weapons_CBA;@NATO_Rus_Vehicle)
		_requiredAddons = ["asdg_jointrails","mas_afr_rebl_c","mas_afr_rebl","mas_HMMWV","mas_apc","mas_brdm","mas_CH47","mas_veh_F_35C","mas_cars_Hilux","mas_cars_LR","mas_MI24","mas_MI8"];
		if ({isClass(configFile >> "cfgPatches" >> _x)} count _requiredAddons == count _requiredAddons) then {
			activateAddons ["asdg_jointrails","asdg_jointmuzzles","mas_afr_rebl_c","mas_afr_rebl","mas_HMMWV","mas_apc","mas_brdm","mas_CH47","mas_veh_F_35C","mas_cars_Hilux","mas_cars_LR","mas_MI24","mas_MI8"];
			[EAST]execVM "eos\OpenMe.sqf";
		}else{INS_mod_missing = true;};
	};
	case 20: {
	// OPTRE Insurrection (@CBA_A3;@OPTRE)
		_requiredAddons = ["CBA_main","OPTRE_Core"];
		if ({isClass(configFile >> "cfgPatches" >> _x)} count _requiredAddons == count _requiredAddons) then {
			activateAddons ["CBA_main","OPTRE_Core","OPTRE_Vehicles","OPTRE_Ins_Units","OPTRE_Hud","OPTRE_CAA_Units","OPTRE_Weapons_StaticTurret","OPTRE_UNSC_Units_Army","OPTRE_Vehicles_Warthog","OPTRE_Vehicles_Pelican","OPTRE_Misc_Crates","OPTRE_Vehicles_Mongoose","OPTRE_Vehicles_Bison","OPTRE_Vehicles_Hornet","OPTRE_Vehicles_Falcon","OPTRE_UNSC_Structure_Military","OPTRE_Vehicles_Misc","OPTRE_Weapons_FG75","OPTRE_Vehicles_Cart","OPTRE_Vehicles_genet"];
			missionNamespace setVariable ["OPTRE_disable_SlimLeg", true];// disable switch uniforms on the fly feature as of OPTRE v0.18
			[EAST]execVM "eos\OpenMe.sqf";
		}else{INS_mod_missing = true;};
	};
	case 21: {
	// IFA3 Desert US Army (@CBA_A3;@CUP_Terrains_Core;@CUP_Terrains_Maps;@IFA3_Terrains_LITE;@I44_Terrains@IFA3_LITE;@IFA3_Objects_LITE)
		_requiredAddons = ["WW2_Assets_c_Characters_Americans_c_US_Rangers"];
		if ({isClass(configFile >> "cfgPatches" >> _x)} count _requiredAddons == count _requiredAddons) then {
			activateAddons ["WW2_Assets_c_Characters_Americans_c_US_Rangers","WW2_Core_c_EditorPreviews_c","WW2_Assets_c_Characters_Americans_c_US_Army","WW2_Assets_c_Vehicles_StaticWeapons_c_Towing","WW2_Assets_c_Vehicles_WheeledAPC_c_M3_Halftrack","WW2_Assets_c_Vehicles_Extended_HUD_c","WW2_Assets_c_Vehicles_ModelConfig_c","WW2_Core_c_Core_c_Eventhandlers","WW2_Assets_c_Vehicles_Boats_c_LCVP","WW2_Assets_c_Vehicles_TurretsConfig_c","WW2_Assets_s_Megagoth1702_Sounds_Config_CfgVehicles","WW2_Assets_c_Vehicles_Wheeled_c_GMC","WW2_Assets_c_Characters_Americans_c_US_NAC","WW2_Core_c_Core_c_Explosion","WW2_Assets_c_Vehicles_Wheeled_c_Scout_M3","WW2_Assets_c_Vehicles_Wheeled_c_Willys_MB","WW2_Assets_c_Vehicles_Planes_c_P39","WW2_Assets_c_Vehicles_Planes_c_P47","WW2_Assets_c_Characters_Civilians_c_CIV_French","WW2_Assets_c_Vehicles_Tanks_c_M3_Stuart","WW2_Assets_c_Vehicles_Pictures_c","WW2_Assets_c_Vehicles_Icons_c","WW2_Assets_c_Vehicles_Tanks_c_M4_Sherman","WW2_Assets_c_Vehicles_Tanks_c_M4A3_75","WW2_Assets_c_Vehicles_Wheeled_c_Zis5v","WW2_Assets_c_Characters_Civilians_c_CIV_Civilians"];
			[RESISTANCE]execVM "eos\OpenMe.sqf";
		}else{INS_mod_missing = true;};
	};
	case 22: {
	// @Unsung VC
		_requiredAddons = ["uns_main"];
		if ({isClass(configFile >> "cfgPatches" >> _x)} count _requiredAddons == count _requiredAddons) then {
			activateAddons ["uns_main","uns_boats_c","uns_men_US_1AC_68","uns_men_USAF","CSJ_UH1Gun_c","uns_OV10_c","uns_skymaster_c","uns_C130","uns_ch53_c","uns_F4e_c","UNS_F111_c","uns_dc3_c","uns_A7_c","uns_A1J_c","uns_oh6_c","uns_ch47a_c","uns_H21C_c","uns_AH1G_c","uns_ch34_c","uns_men_NZ_c","UNS_TankCrew","uns_wheeled3_c","uns_m35_c","uns_Wheeled_w_c","uns_men_USMC_65","uns_m274_c","PBR_Crew","uns_PBR_c","uns_men_US_1ID","uns_men_USMC_68","uns_men_US_5SFG","uns_static_c","uns_stabo","uns_m113_c","uns_men_US_Arty","uns_Arty_c","uns_m107_c","uns_m48a3_c","uns_sheridan_c","uns_men_NVA_crew","uns_men_VC_regional","uns_men_VC_mainforce_68","uns_men_VC_mainforce","uns_men_VC_local","uns_men_VC_recon","uns_men_VC_mainforce","uns_men_VC_mainforce_67","uns_t34_t55_c","UNS_sampan","uns_bunkers","csj_seaobj","uns_AAA_c","uns_pt76_c","uns_men_NVA_68","uns_Type63_c","uns_men_NVA_65","uns_btr_c","uns_wheeled_e_c","uns_men_US_11ACR","uns_men_US_SOG","uns_men_US_SEAL","uns_men_US_1AC","uns_men_US_25ID","uns_men_US_6SFG","uns_uh1d_c","uns_civ","uns_static_c","uns_mig21_c","uns_an2_c","uns_men_NVA_daccong","uns_A4_c","UNS_A6_c","uns_men_ROK"];
			[EAST]execVM "eos\OpenMe.sqf";
		}else{INS_mod_missing = true;};
	};
	case 23: {
	// @Unsung VC and PAVN
		_requiredAddons = ["uns_main"];
		if ({isClass(configFile >> "cfgPatches" >> _x)} count _requiredAddons == count _requiredAddons) then {
			activateAddons ["uns_main","uns_boats_c","uns_men_US_1AC_68","uns_men_USAF","CSJ_UH1Gun_c","uns_OV10_c","uns_skymaster_c","uns_C130","uns_ch53_c","uns_F4e_c","UNS_F111_c","uns_dc3_c","uns_A7_c","uns_A1J_c","uns_oh6_c","uns_ch47a_c","uns_H21C_c","uns_AH1G_c","uns_ch34_c","uns_men_NZ_c","UNS_TankCrew","uns_wheeled3_c","uns_m35_c","uns_Wheeled_w_c","uns_men_USMC_65","uns_m274_c","PBR_Crew","uns_PBR_c","uns_men_US_1ID","uns_men_USMC_68","uns_men_US_5SFG","uns_static_c","uns_stabo","uns_m113_c","uns_men_US_Arty","uns_Arty_c","uns_m107_c","uns_m48a3_c","uns_sheridan_c","uns_men_NVA_crew","uns_men_VC_regional","uns_men_VC_mainforce_68","uns_men_VC_mainforce","uns_men_VC_local","uns_men_VC_recon","uns_men_VC_mainforce","uns_men_VC_mainforce_67","uns_t34_t55_c","UNS_sampan","uns_bunkers","csj_seaobj","uns_AAA_c","uns_pt76_c","uns_men_NVA_68","uns_Type63_c","uns_men_NVA_65","uns_btr_c","uns_wheeled_e_c","uns_men_US_11ACR","uns_men_US_SOG","uns_men_US_SEAL","uns_men_US_1AC","uns_men_US_25ID","uns_men_US_6SFG","uns_uh1d_c","uns_civ","uns_static_c","uns_mig21_c","uns_an2_c","uns_men_NVA_daccong","uns_A4_c","UNS_A6_c","uns_men_ROK"];
			[EAST]execVM "eos\OpenMe.sqf";
		}else{INS_mod_missing = true;};
	};
};
if (isServer && {!(CivProbability isEqualTo 0)}) then {[]execVM "eos_civ\OpenMeCiv.sqf"};// Civilians

// Common Scripts
execVM "Objectives\shk_taskmaster.sqf";
if ((JigHeliExtraction isEqualTo 1) && {!IamHC}) then {execVM "JIG_EX\extraction_init.sqf"};
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
	call compile preProcessFileLineNumbers "init_server.sqf";
	call compile preprocessFileLineNumbers "INSfncs\server\AirPatrole_Fncs.sqf";
	rej_fnc_bezier = compile preProcessFileLineNumbers "INSfncs\server\rej_fnc_bezier.sqf";
	if (INS_IEDs isEqualTo 3) then {[] spawn BMRINS_fnc_JigPunjiTraps};

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
if (hasInterface) then
{
	0 spawn {
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

		call compile preProcessFileLineNumbers "init_player.sqf";
		call compile preprocessFileLineNumbers "INSui\UI\HUD.sqf";
		if (INS_Player_Markers isEqualTo 1) then {0 = [] execVM 'scripts\player_markers.sqf';};
		execVM "scripts\zlt_fastrope.sqf";
	};
};
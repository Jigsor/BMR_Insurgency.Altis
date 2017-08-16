// init_server.sqf by Jigsor //

// Server Functions //
call compile preprocessFileLineNumbers "INSfncs\server_fncs.sqf";

// Weather //
if ((JIPweather isEqualTo 0) || {(JIPweather >3)}) then {
	[] spawn {
		//Date is advanced + 48 hours of editor settings
		waitUntil {time > 1};
		skipTime (((INS_p_time - (daytime) +24) % 24) -24);
		86400 setOvercast (JIPweather/100);
		UIsleep 1;
		0 setFog 0;
		skipTime 24;
		sleep 1;
		//setWind [1,1,false];
		simulWeatherSync;
		if (JIPweather isEqualTo 0) then {sleep 15; overCastValue = [0] call BIS_fnc_paramWeather; 0 setFog 0;};
	};
}else{
	if (JIPweather isEqualTo 2) then {
		[] execVM "scripts\real_weather.sqf"; skipTime ((INS_p_time - (daytime) +24) % 24);
	}else{
		if (JIPweather !=1) then {
			[] execVM "scripts\randomWeather2.sqf"; skipTime (INS_p_time -0.84);
		};
		if (JIPweather isEqualTo 1) then {skipTime ((INS_p_time - (daytime) +24) % 24);};
	};
};

// Group Manager //
["Initialize", [true]] call BIS_fnc_dynamicGroups;

// PublicVariable EventHandlers //
if (isNil "ghst_Build_objs") then {ghst_Build_objs = [];};
if (isNil "intel_Build_objs") then {intel_Build_objs = [];};
if (isNil "activated_cache_pos") then {activated_cache_pos = [];};
if (isNil "paddscore") then {paddscore = 0;};

"BTC_to_server" addPublicVariableEventHandler BTC_m_fnc_only_server;
"ghst_Build_objs" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
"activated_cache_pos" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
"paddscore" addPublicVariableEventHandler {_data = _this select 1; (_data select 0) addScore (_data select 1);};
"PVEH_netSay3D" addPublicVariableEventHandler {private _array = _this select 1; (_array select 0) say3D (_array select 1);};
"side_mission_mkrs" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
"objective_list" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
if (INS_GasGrenadeMod isEqualTo 1) then {"ToxicGasLoc" addPublicVariableEventHandler {(_this select 1) spawn GAS_smoke_AIdamage};};

// Editor object settings //
[] spawn {
	waitUntil {!isNil "INS_MHQ_VarName"};

	if (!isNil "MHQ_1") then {
		MHQ_1 setVariable ["persistent",true];
		if (INS_MHQ_enabled) then {
			MHQ_1 addEventhandler ["Respawn","[(_this select 0)] call INS_MHQ_VarName"];
			_nul = [MHQ_1, 60, 0.01, {_this setVariable["persistent",true]; _VarName = "MHQ_1"; _veh setVehicleVarName _VarName; _veh Call Compile Format ["%1=_This ; PublicVariable ""%1""",_VarName]; INS_MHQ_killed = "MHQ_1"; publicVariable "INS_MHQ_killed";}] execVM "vehrespawn.sqf";
		};
	};
	if (!isNil "MHQ_2") then {
		MHQ_2 setVariable["persistent",true];
		if (INS_MHQ_enabled) then {
			MHQ_2 addEventhandler ["Respawn","[(_this select 0)] call INS_MHQ_VarName"];
			_nul = [MHQ_2, 60, 0.01, {_this setVariable["persistent",true]; _VarName = "MHQ_2"; _veh setVehicleVarName _VarName; _veh Call Compile Format ["%1=_This ; PublicVariable ""%1""",_VarName]; INS_MHQ_killed = "MHQ_2"; publicVariable "INS_MHQ_killed";}] execVM "vehrespawn.sqf";
		};
	};
	if (!isNil "MHQ_3") then {
		MHQ_3 setVariable ["persistent",true];
		[MHQ_3] call paint_heli_fnc;
		if (INS_MHQ_enabled) then {
			MHQ_3 addEventhandler ["killed","[(_this select 0)] call INS_MHQ_VarName"];
			_nul = [MHQ_3, 60, 0.01, {_this setVariable["persistent",true]; _VarName = "MHQ_3"; _veh setVehicleVarName _VarName; _veh Call Compile Format ["%1=_This ; PublicVariable ""%1""",_VarName]; [_this] call paint_heli_fnc; [_this] call anti_collision; INS_MHQ_killed = "MHQ_3"; publicVariable "INS_MHQ_killed";}] execVM "vehrespawn.sqf";
		};
	};
	if (!isNil "Opfor_MHQ") then {
		Opfor_MHQ setVariable["persistent",true];
		if (INS_MHQ_enabled) then {
			Opfor_MHQ addEventhandler ["Respawn","[(_this select 0)] call INS_MHQ_VarName"];
			_nul = [Opfor_MHQ, 60, 0.01, {_this setVariable["persistent",true]; _VarName = "Opfor_MHQ"; _veh setVehicleVarName _VarName; _veh Call Compile Format ["%1=_This ; PublicVariable ""%1""",_VarName]; INS_MHQ_killed = "Opfor_MHQ"; publicVariable "INS_MHQ_killed";}] execVM "vehrespawn.sqf";
		};
	};
};

{
	_x setVariable ["BTC_cannot_lift",1,true];
	_x setVariable ["BTC_cannot_drag",1,true];
	_x setVariable ["BTC_cannot_load",1,true];
	_x setVariable ["BTC_cannot_place",1,true];
} forEach INS_log_blacklist; // Set editor placed objects with names not liftable, not draggable, not loadable and not placeable with BTC Logistics
Delivery_Box setVariable ["BTC_cannot_lift",1,true];
Delivery_Box setVariable ["BTC_cannot_load",1,true];
Delivery_Box hideObjectGlobal true;
INS_Op4_flag setVectorUp [0,0,1];
INS_flag setVectorUp [0,0,1];
INS_flag setFlagTexture "images\bmrflag.paa";// your squad flag here or comment out for default Blufor flag
Delivery_Box hideObjectGlobal true;
[] spawn opfor_NVG;
[180] execVM "scripts\SingleThreadCrateRefill.sqf";

// Param enabled scripts/settings //
if (INS_GasGrenadeMod isEqualTo 1) then {[] spawn editorAI_GasMask;};
if (Fatigue_ability < 1) then {{[_x] spawn INS_full_stamina;} forEach playableUnits;};
if (EnableEnemyAir > 0) then {0 = [] execVM "scripts\AirPatrolEast.sqf";};
if (DebugEnabled isEqualTo 1) then {
	if (SuicideBombers isEqualTo 1) then {[] spawn {sleep 30; nul = [] execVM "scripts\INS_SuicideBomber.sqf";};};
}else{
	if (SuicideBombers isEqualTo 1) then {[] spawn {sleep 600; nul = [] execVM "scripts\INS_SuicideBomber.sqf";};};
};

// Clean up Maintenance //
[
	2*60, // seconds to delete dead bodies
	5*60, // seconds to delete dead vehicles
	0, // (0 means don't delete)
	2*60, // seconds to delete dropped weapons
	0, // (0 means don't delete)// interferes with minefield task if set above 0
	6*60, // seconds to delete dropped smokes/chemlights
	1*60, // seconds to delete craters
	5*60 // seconds to delete canopies,ejection seats
] execVM 'scripts\repetitive_cleanup.sqf';

{_x setVariable ["persistent",true];} forEach [Jig_m_obj,Delivery_Box];
{_x setVariable ["persistent",true];} forEach INS_Blu4_wepCrates;
{_x setVariable ["persistent",true];} forEach INS_Op4_wepCrates;

execVM "scripts\remove_boobyTraps.sqf";
execVM "scripts\unattended_maintenance.sqf";

// Friendly Fixed Wing Assets //
if (Airfield_opt) then
{
	//Clear Altis Airfield near Selakano of trees and bushes if used as air base.
	if (toLower (worldName) isEqualTo "altis") then {
		if ((getMarkerPos "Airfield") distance2D [21020.1,7311.07] < 200) then {
			{ _x hideObjectGlobal true } foreach (nearestTerrainObjects [[21020.1,7311.07,0],["TREE","SMALL TREE","BUSH"],175]);
		};
	};

	//Default empty Bluefor Fixed Wing
	private ["_mod","_class","_dirfw1","_fw1","_type"];
	_mod = false;

	switch (INS_op_faction) do {
		case 6: {
			if (isClass(configFile >> "CfgVehicles" >> "RHS_A10_AT")) then {
				_mod = true; _class = "RHS_A10_AT";
			};
		};
		case 7: {
			if (isClass(configFile >> "CfgVehicles" >> "RHS_A10_AT")) then {
				_mod = true; _class = "RHS_A10_AT";
			};
		};
		case 8: {
			if (isClass(configFile >> "CfgVehicles" >> "RHS_A10_AT")) then {
				_mod = true; _class = "RHS_A10_AT";
			};
		};
		case 9: {
			if (isClass(configFile >> "CfgVehicles" >> "RHS_A10_AT")) then {
				_mod = true; _class = "RHS_A10_AT";
			};
		};
		case 10: {
			if (isClass(configFile >> "CfgVehicles" >> "RHS_A10_AT")) then {
				_mod = true; _class = "RHS_A10_AT";
			};
		};
		case 11: {
			if (isClass(configFile >> "CfgVehicles" >> "RHS_A10_AT")) then {
				_mod = true; _class = "RHS_A10_AT";
			};
		};
		case 12: {
			if (isClass(configFile >> "CfgVehicles" >> "CUP_B_A10_AT_USA")) then {
				_mod = true; _class = "CUP_B_A10_DYN_USA";
				INSdefLoadOutBlu = dynPylons8;
			};
		};
		case 13: {
			if (isClass(configfile >> "CfgVehicles" >> "mas_F_35C")) then {
				_mod = true; _class = "mas_F_35C_cas";
			};
		};
		case 14: {
			if (isClass (configfile >> "CfgVehicles" >> "mas_F_35C")) then {
				_mod = true; _class = "mas_F_35C_cas";
			};
		};
		case 15: {
			if (isClass (configfile >> "CfgVehicles" >> "mas_F_35C")) then {
				_mod = true; _class = "mas_F_35C_cas";
			};
		};
		case 16: {
			if (isClass(configFile >> "CfgVehicles" >> "OPTRE_UNSC_hornet_black_CAS"))then {
				_mod = true; _class = "OPTRE_UNSC_hornet_black_CAS";
			};
		};
		case 17: {
			if (isClass(configFile >> "CfgVehicles" >> "LIB_DAK_FW190F8"))then {
				_mod = true; _class = "LIB_DAK_FW190F8";
			};
		};
		default {
			_dirfw1 = getDir INS_fw_1;
			_fw1 = createVehicle ["B_Plane_CAS_01_dynamicLoadout_F", getPos INS_fw_1, [], 0, "NONE"];
			_fw1 setDir _dirfw1;[_fw1] call anti_collision;
			_nul = [_fw1, dynPylons1] call INS_replace_pylons;
			_nul = [_fw1, 2, 1, {[_this] call anti_collision; [_this, dynPylons1] call INS_replace_pylons}] execVM "vehrespawn.sqf";
		};
	};

	if (_mod) then {
		_dirfw1 = getDir INS_fw_1;
		_type = format ["%1", _class];
		_fw1 = createVehicle [_type, getPos INS_fw_1, [], 0, "NONE"];
		_fw1 setDir _dirfw1;[_fw1] call anti_collision;
		if (!isNil "INSdefLoadOutBlu") then {
			_nul = [_fw1, INSdefLoadOutBlu] call INS_replace_pylons;
			_nul = [_fw1, 2, 1, {[_this] call anti_collision; [_this, INSdefLoadOutBlu] call INS_replace_pylons}] execVM "vehrespawn.sqf";
		} else {
			_nul = [_fw1, 2, 1, {[_this] call anti_collision}] execVM "vehrespawn.sqf";
		};
	};

	//UAV service trigger
	[] spawn {
		if (!(getMarkerColor "AircraftMaintenance" isEqualTo "") || (markerAlpha "AircraftMaintenance" isEqualTo 1)) then {
			private ["_mPos","_actCond","_onActiv","_uavServiceTrig"];

			_mPos=markerpos "AircraftMaintenance";
			_actCond="{(typeOf _x) in INS_W_Serv_UAVs} count thisList > 0";
			_onActiv="
				_uavArr = thislist;
				{if !(_x in INS_W_Serv_UAVs) then {_uavArr = _uavArr - [_x];};} count _uavArr;
				{_x setDamage 0; _x setVehicleAmmo 1; _x setFuel 1;} count _uavArr;
			";

			_uavServiceTrig = createTrigger ["EmptyDetector",_mPos];
			_uavServiceTrig setTriggerArea [15,15,0,FALSE];
			_uavServiceTrig setTriggerActivation ["WEST","PRESENT",true];
			_uavServiceTrig setTriggerTimeout [2, 2, 2, true];
			_uavServiceTrig setTriggerStatements [_actCond,_onActiv,""];
		};
	};
};

addMissionEventHandler ["HandleDisconnect", {
    _unit = _this select 0;
    deleteVehicle _unit;
}];

// Tasks //
[] spawn {
/*
// Persistence Check/Set Marker Color
	if (!isNil {profileNamespace getVariable "BMR_INS_progress"}) then {
		waitUntil {! isNil "VictoryColor"};
		private _uncapedMarkers = profileNamespace getVariable "BMR_INS_progress";
		{
			if !(_x in all_eos_mkrs) then {
				_x setMarkerColor VictoryColor;
			};
		} foreach _uncapedMarkers;
	};
*/
	waitUntil {! isNil "SHK_Taskmaster_Tasks"};

	if (DebugEnabled isEqualTo 1) then {
		sleep 2;
		tasks_handler = [] execVM "Objectives\random_objectives.sqf";
		waitUntil { scriptDone tasks_handler };
		if (EnemyAmmoCache isEqualTo 1) then {execVM "scripts\ghst_PutinBuild.sqf";};
		sleep 30;
		execVM "Objectives\tasks_complete.sqf";
	}else{
		sleep 45;
		tasks_handler = [] execVM "Objectives\random_objectives.sqf";
		waitUntil { scriptDone tasks_handler };
		if (EnemyAmmoCache isEqualTo 1) then {execVM "scripts\ghst_PutinBuild.sqf";};
		sleep 75;
		execVM "Objectives\tasks_complete.sqf";
	};
};

diag_log "BMR Insurgency Mission Parameters:";
for [ {_i = 0}, {_i < count(paramsArray)}, {_i = _i + 1} ] do {
	diag_log format
	[
		"%1 = %2",
		(configName ((missionConfigFile >> "Params") select _i)),
		(paramsArray select _i)
	];
};

//BMR_server_initialized = true;publicVariable "BMR_server_initialized";
// init_server.sqf by Jigsor //

// Server Functions //
call compile preprocessFileLineNumbers "INSfncs\server\server_fncs.sqf";

// Weather //
if ((JIPweather isEqualTo 0) || {(JIPweather >3)}) then {
	0 = 0 spawn {
		//Date is advanced + 48 hours of editor settings
		waitUntil {time > 1};
		skipTime (((INS_p_time - (daytime) +24) % 24) -24);
		86400 setOvercast (JIPweather/100);
		UIsleep 1;
		0 setFog 0;
		skipTime 24;
		sleep 1;
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
"BTC_to_server" addPublicVariableEventHandler BTC_m_fnc_only_server;
"ghst_Build_objs" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
"activated_cache_pos" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
"side_mission_mkrs" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
"objective_list" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
"paddscore" addPublicVariableEventHandler {_data = _this select 1; (_data select 0) addScore (_data select 1);};
"PVEH_netSay3D" addPublicVariableEventHandler {private _array = _this select 1; (_array select 0) say3D (_array select 1)};
if (INS_GasGrenadeMod isEqualTo 1) then {"ToxicGasLoc" addPublicVariableEventHandler {(_this select 1) spawn GAS_smoke_AIdamage}};

// Mission EventHandlers //
addMissionEventHandler ["HandleDisconnect", {
	params ["_unit", "_id", "_uid", "_name"];
	if !(isPlayer leader (group _unit)) then {
		{deleteVehicle _x} forEach (units (group _unit) select {(_x isKindOf "Man")});
	};
	if (typeOf _unit isEqualTo "HeadlessClient_F") then {
		{deleteVehicle _x} forEach (allUnits select {(side _x isNotEqualTo west) && (side _x isNotEqualTo civilian) && (_x isKindOf "Man")});
		diag_log format ["*****Headless Client %1 Disconnected", _name];
		if (_name == "HC_1") then {HC_1Present = false; publicVariable "HC_1Present"};
		if (_name == "HC_2") then {HC_2Present = false; publicVariable "HC_2Present"};
	};
	deleteVehicle _unit;
}];

// Editor object settings //
0 spawn {
	waitUntil {!isNil "INS_MHQ_VarName"};

	if (!isNil "MHQ_1") then {
		MHQ_1 setVariable["persistent",true];
		if (MHQ_1 isKindOf "Ship") then {[MHQ_1] call Push_Acc};
		[MHQ_1] call BMRINS_fnc_customMHQ;
		if (JIG_MHQ_enabled) then {
			MHQ_1 addEventhandler ["Respawn","[(_this select 0)] call INS_MHQ_VarName"];
			0 = [MHQ_1, 60, 0.01, {_this setVariable["persistent",true]; _VarName = "MHQ_1"; _this setVehicleVarName _VarName; _this Call Compile Format ["%1=_this; publicVariable '%1'",_VarName]; [_this] call BMRINS_fnc_customMHQ; INS_MHQ_killed = "MHQ_1"; publicVariable "INS_MHQ_killed";}] execVM "vehrespawn.sqf";
		};
	};
	if (!isNil "MHQ_2") then {
		MHQ_2 setVariable["persistent",true];
		if (MHQ_2 isKindOf "Ship") then {[MHQ_2] call Push_Acc};
		[MHQ_2] call BMRINS_fnc_customMHQ;
		if (JIG_MHQ_enabled) then {
			MHQ_2 addEventhandler ["Respawn","[(_this select 0)] call INS_MHQ_VarName"];
			0 = [MHQ_2, 60, 0.01, {_this setVariable["persistent",true]; _VarName = "MHQ_2"; _this setVehicleVarName _VarName; _this Call Compile Format ["%1=_this; publicVariable '%1'",_VarName]; [_this] call BMRINS_fnc_customMHQ; INS_MHQ_killed = "MHQ_2"; publicVariable "INS_MHQ_killed";}] execVM "vehrespawn.sqf";
		};
	};
	if (!isNil "MHQ_3") then {
		MHQ_3 setVariable["persistent",true];
		[MHQ_3] call paint_heli_fnc;
		[MHQ_3] spawn BMR_resetDamage;
		if (JIG_MHQ_enabled) then {
			MHQ_3 addEventhandler ["killed","[(_this select 0)] call INS_MHQ_VarName"];
			0 = [MHQ_3, 60, 0.01, {_this setVariable["persistent",true]; _VarName = "MHQ_3"; _this setVehicleVarName _VarName; _this Call Compile Format ["%1=_this; publicVariable '%1'",_VarName]; [_this] call paint_heli_fnc; [_this] call anti_collision; [_this] spawn BMR_resetDamage; INS_MHQ_killed = "MHQ_3"; publicVariable "INS_MHQ_killed";}] execVM "vehrespawn.sqf";
		};
	};
	if (!isNil "Opfor_MHQ") then {
		Opfor_MHQ setVariable["persistent",true];
		if (JIG_MHQ_enabled) then {
			Opfor_MHQ addEventhandler ["Respawn","[(_this select 0)] call INS_MHQ_VarName"];
			0 = [Opfor_MHQ, 60, 0.01, {_this setVariable["persistent",true]; _VarName = "Opfor_MHQ"; _this setVehicleVarName _VarName; _this Call Compile Format ["%1=_this; publicVariable '%1'",_VarName]; INS_MHQ_killed = "Opfor_MHQ"; publicVariable "INS_MHQ_killed";}] execVM "vehrespawn.sqf";
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
0 spawn opfor_NVG;
[180] execVM "scripts\SingleThreadCrateRefill.sqf";

//Add moded units and vehicles in this marker to make addons a requirement, activate the addons and make available for zeus. These items get deleted at mission start.
if (markerAlpha "AuxiliaryContent" isEqualTo 1) then {
	"AuxiliaryContent" setMarkerAlpha 0;
	private _v = vehicles inAreaArray "AuxiliaryContent";
	private _u = allUnits inAreaArray "AuxiliaryContent";
	{deleteVehicle _x} count _v;
	{deleteVehicle _x} count _u;
};

// Param enabled scripts/settings //
if (INS_GasGrenadeMod isEqualTo 1) then {0 spawn editorAI_GasMask};
if (EnableEnemyAir > 0) then {execVM "scripts\AirPatrolEast.sqf"};
if (DebugEnabled isEqualTo 1) then {
	if (SuicideBombers isEqualTo 1) then {0 spawn {sleep 30; execVM "scripts\INS_SuicideBomber.sqf"}};
}else{
	if (SuicideBombers isEqualTo 1) then {0 spawn {sleep 600; execVM "scripts\INS_SuicideBomber.sqf"}};
};

// Clean up Maintenance //
{_x setVariable ["persistent",true]} forEach [Jig_m_obj,Delivery_Box], INS_Blu4_wepCrates, INS_Op4_wepCrates;
execVM 'scripts\repetitive_cleanup.sqf';
execVM "scripts\remove_boobyTraps.sqf";
execVM "scripts\unattended_maintenance.sqf";

// Friendly Fixed Wing Assets //
if (Airfield_opt) then
{
	//Clear Altis Airfield near Selakano of trees and bushes if used as air base.
	if (toLower (worldName) isEqualTo "altis") then {
		if ((markerPos "Airfield") distance2D [21020.1,7311.07] < 200) then {
			{ _x hideObjectGlobal true } foreach (nearestTerrainObjects [[21020.1,7311.07,0],["TREE","SMALL TREE","BUSH"],175]);
		};
	};
	{_x animateSource ["Door_7_sound_source", 1]} forEach nearestObjects [(markerPos "Airfield"), ["Land_Ss_hangar","Land_Ss_hangard","WarfareBAirport"], 500];

	//Default empty Bluefor Fixed Wing
	private ["_class","_dirfw1","_fw1","_type"];
	private _mod = false;

	private _vanillaDefault = {
		_dirfw1 = getDir INS_fw_1;
		_fw1 = createVehicle ["B_Plane_CAS_01_dynamicLoadout_F", getPos INS_fw_1, [], 0, "NONE"];
		_fw1 setDir _dirfw1;[_fw1] call anti_collision;
		0 = [_fw1, dynPylons1] call INS_replace_pylons;
		0 = [_fw1, 2, 1, {[_this] call anti_collision; [_this, dynPylons1] call INS_replace_pylons}] execVM "vehrespawn.sqf";
	};

	switch (INS_op_faction) do {
		case 9: {
			if (isClass(configFile >> "CfgVehicles" >> "RHS_A10")) then {
				_mod = true; _class = "RHS_A10";
				INSdefLoadOutBlu = dynPylons9;
			};
		};
		case 10: {
			if (isClass(configFile >> "CfgVehicles" >> "RHS_A10")) then {
				_mod = true; _class = "RHS_A10";
				INSdefLoadOutBlu = dynPylons9;
			};
		};
		case 11: {
			if (isClass(configFile >> "CfgVehicles" >> "RHS_A10")) then {
				_mod = true; _class = "RHS_A10";
				INSdefLoadOutBlu = dynPylons9;
			};
		};
		case 12: {
			if (isClass(configFile >> "CfgVehicles" >> "RHS_A10")) then {
				_mod = true; _class = "RHS_A10";
				INSdefLoadOutBlu = dynPylons9;
			};
		};
		case 13: {
			if (isClass(configFile >> "CfgVehicles" >> "RHS_A10")) then {
				_mod = true; _class = "RHS_A10";
				INSdefLoadOutBlu = dynPylons9;
			};
		};
		case 14: {
			if (isClass(configFile >> "CfgVehicles" >> "RHS_A10")) then {
				_mod = true; _class = "RHS_A10";
				INSdefLoadOutBlu = dynPylons9;
			};
		};
		case 15: {
			if (isClass(configFile >> "CfgVehicles" >> "CUP_B_A10_DYN_USA")) then {
				_mod = true; _class = "CUP_B_A10_DYN_USA";
				INSdefLoadOutBlu = dynPylons8;
			};
		};
		case 16: {
			if (isClass(configFile >> "CfgVehicles" >> "CUP_B_A10_DYN_USA")) then {
				_mod = true; _class = "CUP_B_A10_DYN_USA";
				INSdefLoadOutBlu = dynPylons8;
			};
		};
		case 17: {
			if (isClass(configfile >> "CfgVehicles" >> "mas_F_35C")) then {
				_mod = true; _class = "mas_F_35C_cas";
			};
		};
		case 18: {
			if (isClass (configfile >> "CfgVehicles" >> "mas_F_35C")) then {
				_mod = true; _class = "mas_F_35C_cas";
			};
		};
		case 19: {
			if (isClass (configfile >> "CfgVehicles" >> "mas_F_35C")) then {
				_mod = true; _class = "mas_F_35C_cas";
			};
		};
		case 20: {
			if (isClass(configFile >> "CfgVehicles" >> "OPTRE_UNSC_hornet_CAS"))then {
				_mod = true; _class = "OPTRE_UNSC_hornet_CAS";
			};
		};
		case 21: {
			if (isClass(configFile >> "CfgVehicles" >> "LIB_DAK_FW190F8"))then {
				_mod = true; _class = "LIB_DAK_FW190F8";
			};
		};
		case 22: {
			if (isClass(configFile >> "CfgVehicles" >> "uns_A7_MR"))then {
				_mod = true; _class = "uns_A7_MR";
				INSdefLoadOutBlu = dynPylons10;
			};
		};
		case 23: {
			if (isClass(configFile >> "CfgVehicles" >> "uns_A7_MR"))then {
				_mod = true; _class = "uns_A7_MR";
				INSdefLoadOutBlu = dynPylons10;
			};
		};
		case 24: {
			if (isClass(configFile >> "CfgVehicles" >> "RHS_A10")) then {
				_mod = true; _class = "RHS_A10";
				INSdefLoadOutBlu = dynPylons9;
			};
		};
		case 25: {
			if (isClass(configFile >> "CfgVehicles" >> "RHS_A10")) then {
				_mod = true; _class = "RHS_A10";
				INSdefLoadOutBlu = dynPylons9;
			};
		};
		default {};
	};

	if (_mod) then {
		_dirfw1 = getDir INS_fw_1;
		_type = format ["%1", _class];
		_fw1 = createVehicle [_type, getPos INS_fw_1, [], 0, "NONE"];
		_fw1 setDir _dirfw1;[_fw1] call anti_collision;
		if (!isNil "INSdefLoadOutBlu") then {
			0 = [_fw1, INSdefLoadOutBlu] call INS_replace_pylons;
			0 = [_fw1, 2, 1, {[_this] call anti_collision; [_this, INSdefLoadOutBlu] call INS_replace_pylons}] execVM "vehrespawn.sqf";
		} else {
			0 = [_fw1, 2, 1, {[_this] call anti_collision}] execVM "vehrespawn.sqf";
		};
	} else {
		call _vanillaDefault;
	};

	//UAV service trigger
	0 spawn {
		if ((markerColor "AircraftMaintenance" isNotEqualTo "") || (markerAlpha "AircraftMaintenance" isEqualTo 1)) then {
			private ["_mPos","_actCond","_onActiv","_uavServiceTrig"];

			_mPos=markerpos "AircraftMaintenance";
			_actCond="{(typeOf _x) in INS_W_Serv_UAVs} count thisList > 0";
			_onActiv="
				_uavArr = thislist;
				{if !(_x in INS_W_Serv_UAVs) then {_uavArr = _uavArr - [_x];};} forEach _uavArr;
				{_x setDamage 0; _x setVehicleAmmo 1; _x setFuel 1;} forEach _uavArr;
			";

			_uavServiceTrig = createTrigger ["EmptyDetector",_mPos];
			_uavServiceTrig setTriggerArea [15,15,0,false,15];
			_uavServiceTrig setTriggerActivation ["WEST","PRESENT",true];
			_uavServiceTrig setTriggerTimeout [2, 2, 2, true];
			_uavServiceTrig setTriggerStatements [_actCond,_onActiv,""];
		};
	};
};

//Save Op4 Weapon Crates Orientation
private _anchorPos = getPosATL INS_E_tent;
private _op4CrateComposition = [INS_Op4_wepCrates,_anchorPos] call BMRINS_fnc_objPositionsGrabber;
missionNamespace setVariable ["op4CratesOrientation", _op4CrateComposition, true];

// Tasks //
0 spawn {
	waitUntil {!isNil "SHK_Taskmaster_Tasks" && time > 0};

	if (DebugEnabled isEqualTo 1) then {
		sleep 2;
		localNamespace setVariable ["BMR_tasksHandlerDone", false];
		execVM "Objectives\random_objectives.sqf";
		waitUntil {localNamespace getVariable ["BMR_tasksHandlerDone", false]};
		if (EnemyAmmoCache isEqualTo 1) then {execVM "scripts\ghst_PutinBuild.sqf"};
		sleep 30;
		execVM "Objectives\tasks_complete.sqf";
	}else{
		sleep 30;
		localNamespace setVariable ["BMR_tasksHandlerDone", false];
		execVM "Objectives\random_objectives.sqf";
		waitUntil {localNamespace getVariable ["BMR_tasksHandlerDone", false]};
		if (EnemyAmmoCache isEqualTo 1) then {execVM "scripts\ghst_PutinBuild.sqf"};
		sleep 60;
		execVM "Objectives\tasks_complete.sqf";
	};
};

// Log internal mission version //
_version = localNamespace getVariable ["BMR_INS_IntVer", "BMR Insurgency build version undetermined"];
diag_log format ["BMR Insurgency internal mission build version %1", _version];
// Log mission parameters //
diag_log "BMR Insurgency Mission Parameters:";
for [ {_i = 0}, {_i < count(paramsArray)}, {_i = _i + 1} ] do {
	diag_log format
	[
		"%1 = %2",
		(configName ((missionConfigFile >> "Params") select _i)),
		(paramsArray select _i)
	];
};
diag_log format ["****Server File Patching Enabled = %1", isFilePatchingEnabled];

//BMR_server_initialized = true;publicVariable "BMR_server_initialized";
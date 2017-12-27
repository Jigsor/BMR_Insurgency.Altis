//commom_fncs.sqf by Jigsor

// Global hint
JIG_MPhint_fnc = {if (!isDedicated && hasInterface) then { hintSilent _this };};
JIG_MPsideChatWest_fnc = { [West,"HQ"] SideChat (_this select 0); };
JIG_MPsideChatEast_fnc = { [East,"HQ"] SideChat (_this select 0); };
JIG_MPTitleText_fnc = {
	if (!isDedicated && hasInterface) then {
		params ["_text"];
		copyToClipboard str(_text);
		sleep 3;
		//("BMR_MPTitleText_Layer" call BIS_fnc_rscLayer) cutText [_text,"PLAIN"];
		cutText [_text,"PLAIN"];
	};
};
INS_missing_mods = {
	if (!isDedicated && hasInterface) then {
		if (isServer) then {
			player sideChat "BMR Insurgency warning. This machine is missing mods and will not spawn enemy AI. Check mod installations.";
		}else{
			player sideChat "BMR Insurgency warning. This machine is missing mods you may not see and enemies or their equipment. Check mod installations.";
			//("BMR_Layer_end4" call BIS_fnc_rscLayer) cutText [ "This machine is missing required mod(s). Check mod installations and try again.", "BLACK OUT", 1, true ]; sleep 10; endMission "END4";// Uncomment this line to kick players missing mods required by the mission.
		};
	}else{
		diag_log "BMR Insurgency warning. This machine is missing mods and will not spawn enemy AI. Check mod installations.";
	};
};
Hide_Mkr_fnc = {
	params ["_mkrarray","_hidden_side"];
	if (isDedicated || !hasInterface) exitWith {};
	if (side player == _hidden_side) then {
		{
			_x setMarkerAlphaLocal 0;
		} forEach _mkrarray;
	};
	true
};
JIPmkr_updateServer_fnc = {
	// Stores all current intel markers' states to variable "IntelMarkers". by Jigsor
	params ["_JIPmkr","_coloredMarkers"];

	{
		if (isNil {server getVariable "IntelMarkers"}) then {
			_coloredMarkers=[];
			_coloredMarkers pushBack _x;
			server setVariable ["IntelMarkers",_coloredMarkers,true];
		}else{
			_coloredMarkers=server getVariable "IntelMarkers";
			if (isNil "_coloredMarkers") then {_coloredMarkers=[];};
			_coloredMarkers pushBack _x;
			server setVariable ["IntelMarkers",_coloredMarkers,true];
		};
	}forEach _JIPmkr;
	true
};
disableEOSmkrs_fnc = {
	waitUntil {!isNil "EOS_Spawn"}; sleep 1;
	private _arr = server getVariable "EOSmkrStates";
	{
		if (getMarkerColor _x == "colorGreen") then {
			_x setMarkerColorLocal "colorBlack";
			_x setmarkerAlpha 0;
		};
	} forEach _arr;
	true
};
anti_collision = {
	// fixes wheels stuck in ground/vehicles exploding when entering bug by Jigsor.
	params ["_obj"];
	_obj setVectorUP (surfaceNormal [(getPosATL _obj) select 0,(getPosATL _obj) select 1]);
	_obj setPos [(getPosATL _obj) select 0,(getPosATL _obj) select 1,((getPos _obj) select 2) + 0.3];
	true
};
Playable_Op4_disabled = {
	if (!isServer && hasInterface) then {
		player enableSimulationGlobal false;
		("BMR_Layer_end2" call BIS_fnc_rscLayer) cutText [ "Opfor player slots are currently disabled. Please rejoin and choose a Blufor slot.", "BLACK OUT", 1, true ];
		sleep 10;
		endMission "END2";
	};
};
Kicked_for_TKing = {
	if (!isServer && hasInterface) then {
		player enableSimulationGlobal false;
		("BMR_Layer_end3" call BIS_fnc_rscLayer) cutText [ "You have been kicked for team killing for mission duration!", "BLACK OUT", 1, true ];
		sleep 10;
		endMission "END3";
	};
};
INS_full_stamina = {
	params ["_unit"];
	_unit enableStamina false;
	_unit enableFatigue false;
	_unit forceWalk false;
	_unit setCustomAimCoef 0.2;//weapon sway 1=max, 0=min
	_unit setAnimSpeedCoef 1;//animation speed 1=max, 0=min
	true
};
mhq_actions_fnc = {
	// Add action for VA and quick VA profile to respawned MHQs. by Jigsor
	params ["_veh","_var"];

	switch (true) do {
		case (_var isEqualTo "MHQ_1"): {
			_veh addAction [("<t color='#F56618'>") + (localize "STR_BMR_load_VAprofile") + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[(_this select 1)],JIG_load_VA_profile_MHQ1], 1, true, true, "", "true"];
			_veh addAction[("<t color='#ff1111'>") + (localize "STR_BMR_open_VA") + "</t>",{["Open",true] call BIS_fnc_arsenal;}];
		};
		case (_var isEqualTo "MHQ_2"): {
			_veh addAction [("<t color='#F56618'>") + (localize "STR_BMR_load_VAprofile") + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[(_this select 1)],JIG_load_VA_profile_MHQ2], 1, true, true, "", "true"];
			_veh addAction[("<t color='#ff1111'>") + (localize "STR_BMR_open_VA") + "</t>",{["Open",true] call BIS_fnc_arsenal;}];
		};
		case (_var isEqualTo "MHQ_3"): {
			_veh addAction [("<t color='#F56618'>") + (localize "STR_BMR_load_VAprofile") + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[(_this select 1)],JIG_load_VA_profile_MHQ3], 1, true, true, "", "true"];
			_veh addAction[("<t color='#ff1111'>") + (localize "STR_BMR_open_VA") + "</t>",{["Open",true] call BIS_fnc_arsenal;}];
		};
		case (_var isEqualTo "Opfor_MHQ"): {
			_veh addAction [("<t color='#12F905'>") + ("Deploy MHQ") + "</t>","scripts\deployOpforMHQ.sqf",nil,1, false, true, "", "side _this != INS_Blu_side"];
			//_veh addAction[("<t color='#12F905'>") + (localize "STR_BMR_restore_default_loadout") + "</t>",{call Op4_restore_loadout},nil,1, false, true, "", "side _this != INS_Blu_side"];
		};
		case (_var isEqualTo ""): {};
	};
};
Op4_restore_loadout = {
	_caller = _this select 1;
	[_caller] execVM "scripts\DefLoadoutOp4.sqf";
};
JIG_load_VA_profile_MHQ1 = {
	if (!isNil {profileNamespace getVariable "bis_fnc_saveInventory_data"}) then {
		private ["_name_index","_VA_Loadouts_Count"];
		_VA_Loadouts_Count = count (profileNamespace getVariable "bis_fnc_saveInventory_data");
		_name_index = 0;
		for "_i" from 0 to (_VA_Loadouts_Count/2) -1 do	{
			[_i,_name_index] spawn {
				private ["_name_index","_loadout_name"];
				_name_index = _this select 1;
				_loadout_name = profileNamespace getVariable "bis_fnc_saveInventory_data" select _name_index;
				_id = MHQ_1 addAction [("<t color='#00ffe9'>") + ("Load " + format ["%1",_loadout_name]) + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[player,[profileNamespace, format ["%1", _loadout_name]]],BIS_fnc_loadInventory],8,true,true,"","true"];
				sleep 20;
				MHQ_1 removeAction _id;
			};
			_name_index = _name_index + 2;
		};
	};
};
JIG_load_VA_profile_MHQ2 = {
	if (!isNil {profileNamespace getVariable "bis_fnc_saveInventory_data"}) then {
		private ["_name_index","_VA_Loadouts_Count"];
		_VA_Loadouts_Count = count (profileNamespace getVariable "bis_fnc_saveInventory_data");
		_name_index = 0;
		for "_i" from 0 to (_VA_Loadouts_Count/2) -1 do	{
			[_i,_name_index] spawn {
				private ["_name_index","_loadout_name"];
				_name_index = _this select 1;
				_loadout_name = profileNamespace getVariable "bis_fnc_saveInventory_data" select _name_index;
				_id = MHQ_2 addAction [("<t color='#00ffe9'>") + ("Load " + format ["%1",_loadout_name]) + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[player,[profileNamespace, format ["%1", _loadout_name]]],BIS_fnc_loadInventory],8,true,true,"","true"];
				sleep 20;
				MHQ_2 removeAction _id;
			};
			_name_index = _name_index + 2;
		};
	};
};
JIG_load_VA_profile_MHQ3 = {
	if (!isNil {profileNamespace getVariable "bis_fnc_saveInventory_data"}) then {
		private ["_name_index","_VA_Loadouts_Count"];
		_VA_Loadouts_Count = count (profileNamespace getVariable "bis_fnc_saveInventory_data");
		_name_index = 0;
		for "_i" from 0 to (_VA_Loadouts_Count/2) -1 do {
			[_i,_name_index] spawn {
				private ["_name_index","_loadout_name"];
				_name_index = _this select 1;
				_loadout_name = profileNamespace getVariable "bis_fnc_saveInventory_data" select _name_index;
				_id = MHQ_3 addAction [("<t color='#00ffe9'>") + ("Load " + format ["%1",_loadout_name]) + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[player,[profileNamespace, format ["%1", _loadout_name]]],BIS_fnc_loadInventory],8,true,true,"","true"];
				sleep 20;
				MHQ_3 removeAction _id;
			};
			_name_index = _name_index + 2;
		};
	};
};
mp_Say3D_fnc = {
	// code by Twirly
	params ["_obj","_snd"];

	PVEH_netSay3D = [_obj,_snd];
	publicVariable "PVEH_netSay3D";

	if (!isDedicated && hasInterface) then {_obj say3D _snd};
	true
};
fnc_mp_intel = {
	// Intel addaction. by Jigsor
	params ["_intelobj","_cachepos"];

	if (!isNull _intelobj) then {
		_intelobj addAction ["<t color='#ffff00'>Grab Intel</t>", "call JIG_intel_found", _cachepos, 6, true, true, "",""];
		intel_objArray pushBack _intelobj;
	};
	if (ObjNull in intel_objArray) then {{intel_objArray = intel_objArray - [objNull]} foreach intel_objArray;};
	publicVariable "intel_objArray";
	true
};
fnc_jip_mp_intel = {
	// JIP Intel addaction. by Jigsor
	params ["_intelobj","_cachepos"];

	if (!isNull _intelobj) then {
		_intelobj addAction ["<t color='#ffff00'>Grab Intel</t>", "call JIG_intel_found", _cachepos, 6, true, true, "",""];
	};
	true
};
INS_end_mssg = {
	if (!isDedicated && hasInterface) then {
		[] spawn {
			private ["_video","_play"];
			0 fadeMusic 1;
			playMusic ["LeadTrack01a_F_EXP",16];
			if (daytime > 21.00 || daytime < 3.50) then {
				0=[15,1,160,"red",10,(position player)] spawn Drop_SmokeFlare_fnc;
			};
			_video = selectRandom INS_ending_videos;
			_play = [_video] spawn bis_fnc_playvideo;
			waitUntil {scriptDone _play};
			titleText [format["It Was an Honor to Serve with You, %1", name player], "PLAIN", 2.0];
			titleFadeOut 8;
			[(position player),360,0.25,0.01] spawn JIG_circling_cam;
			("BMR_Layer_end1" call BIS_fnc_rscLayer) cutRsc ["bmr_intro", "PLAIN"];
		};
	}else{
		sleep 25;
	};
	true
};
hv_tower_effect = {
	if (!isDedicated && hasInterface) then {
		private ["_emitter","_source","_lightningpos"];
		_emitter = objective_pos_logic;
		_lightningpos = [position objective_pos_logic select 0,position objective_pos_logic select 1,10];

		_source = "#particlesource" createVehiclelocal (getPos objective_pos_logic);
		_source setParticleCircle [0,[0,0,0]];
		_source setParticleRandom [0,[0.25,0.25,0], [0.175,0.175,0],0,0.25,[0,0,0,0.1],0,0];

		_source setParticleParams [["\A3\data_f\blesk1",1,0,1],"","SpaceObject",1,0.4,_lightningpos,[0,0,3],0,10,7.9,0.075,[1.2, 2, 4],[[0.1,0.1,0.1,1],[0.25,0.25,0.25,0.5],[0.5,0.5,0.5,0]],[0.08,0,0,0,0,0,5],0.5,0,"","",_emitter];
		_source setDropInterval 0.1;

		_i = 0;
		while {_i < 3} do {
			drop ["\A3\data_f\blesk1","","SpaceObject",1,0.1,_lightningpos,[0,0,3],0,10,7.9,0.075,[1.2,2,4],[[0.1,0.1,0.1,1],[0.25,0.25,0.25,0.5],[0.5,0.5,0.5,0]],[0.08,0,0,0,0,0,5],0.5,0,"","",""];
			_i = _i + 1;
			sleep 0.1;
		};
		deleteVehicle _source;
	};
	true
};
JIG_base_protection = {
	// Intrinsic destruction of Opfor and Independant units entering protection triggers trig_alarm1init, trig_alarm2init and triggers trig_alarm3init and trig_alarm4init if applicable by Jigsor.
	if (!hasInterface && !isDedicated) exitWith {};
	private "_defend";
	_defend = [(_this select 0),(_this select 1)] spawn {
		params ["_unit","_trigger"];
		if (isDedicated && {isPlayer _unit}) exitWith {};
		if (isDedicated) then {
			sleep 0.899;
			(vehicle _unit) call BIS_fnc_neutralizeUnit;
		}else{
		// Give players 10 second warning to leave.
			if (!isServer && {local player && _unit == player}) exitWith {
				private ["_intrude_pos","_trigPos","_dis1","_dis2"];
				_intrude_pos = (getPosATL _unit);
				_trigPos = (getPosWorld _trigger);
				_dis1 = (_intrude_pos distance _trigPos);

				for '_i' from 10 to 1 step -1 do {
					hint format ["You have entered a protected zone. You've got %1 seconds to leave", _i];
					uiSleep 1;
				}; hint "";
				sleep 0.13;

				_intrude_pos = (getPosATL _unit);
				_dis2 = (_intrude_pos distance _trigPos);
				if (_dis2 <= _dis1) then {(vehicle _unit) call BIS_fnc_neutralizeUnit;};
			};
			if (local player && _unit == player) then {
				private ["_intrude_pos","_trigPos","_dis1","_dis2"];
				_intrude_pos = (getPosATL _unit);
				_trigPos = (getPosWorld _trigger);
				_dis1 = (_intrude_pos distance _trigPos);

				for '_i' from 10 to 1 step -1 do {
					hint format ["You have entered a protected zone. You've got %1 seconds to leave", _i];
					uiSleep 1;
				}; hint "";
				sleep 0.13;

				_intrude_pos = (getPosATL _unit);
				_dis2 = (_intrude_pos distance _trigPos);
				if (_dis2 <= _dis1) then {(vehicle _unit) call BIS_fnc_neutralizeUnit;};
			}else{
				sleep 0.899;
				(vehicle _unit) call BIS_fnc_neutralizeUnit;
			};
		};
	};
	true
};
fnc_mp_push = {
	if (!isDedicated && hasInterface) then {
		params ["_veh"];
		_veh addAction ["<t color='#FF9900'>Push</t>",{call Push_Vehicle},[],-1,false,true,"","_this distance _target < 8"];
	};
	true
};
Push_Acc = {
	params ["_veh"];
	[[_veh],"fnc_mp_push"] call BIS_fnc_MP;
	true
};
Push_Vehicle = {
	/* Boat push script - v0.1
	Pushes the boat in the direction the player is looking
	Created by BearBison */

	private ["_veh","_unit","_isWater"];
	_veh = _this select 0;
	_unit = _this select 1;
	_isWater = surfaceIsWater position _unit;
	if (_unit in _veh) exitWith {titleText[localize "STR_BMR_push_restrict2","PLAIN DOWN",1]};
	if (_isWater) exitWith {titleText[localize "STR_BMR_push_restrict1","PLAIN DOWN",1]};
	_veh setOwner (owner _unit);
	_unit playMove "AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon_Putdown";
	if (currentWeapon _unit == "") then {sleep 1;} else {sleep 2;};
	_veh setVelocity [(sin(direction _unit))*3, (cos(direction _unit))*3, 0];
	true
};
INS_fog_effect = {
	if (!isDedicated && hasInterface) then {null=["ObjectiveMkr",100,11,10,3,7,-0.3,0.1,0.5,1,1,1,13,12,15,true,2,2.1,0.1,4,6,0,3.5,17.5] execFSM "scripts\Fog.fsm";};
};
mhq_obj_fnc = {
	// returns MHQ vehicleVarname object
	private ["_var","_obj"];
	_var = _this select 0;
	_obj = objNull;
	switch (true) do {
		case (_var isEqualTo "MHQ_1") : {_obj = MHQ_1; if (vehicleVarname MHQ_1 isEqualTo "") then {MHQ_1 setVehicleVarname "MHQ_1"; MHQ_1 = _obj;};};
		case (_var isEqualTo "MHQ_2") : {_obj = MHQ_2; if (vehicleVarname MHQ_2 isEqualTo "") then {MHQ_2 setVehicleVarname "MHQ_2"; MHQ_2 = _obj;};};
		case (_var isEqualTo "MHQ_3") : {_obj = MHQ_3; if (vehicleVarname MHQ_3 isEqualTo "") then {MHQ_3 setVehicleVarname "MHQ_3"; MHQ_3 = _obj;};};
		case (_var isEqualTo "Opfor_MHQ") : {_obj = Opfor_MHQ; if (vehicleVarname Opfor_MHQ isEqualTo "") then {Opfor_MHQ setVehicleVarname "Opfor_MHQ"; Opfor_MHQ = _obj;};};
		case (_var isEqualTo "") : {};
		default {};
	};
	_obj
};
INS_Zeus_MP = {
	// Admin can toggle Zeus on or off in breifing admin panel.
	private ["_unit", "_announce"];
	_unit = [_this,0,objNull] call bis_fnc_param;
	_announce = [_this,1,false] call bis_fnc_param;
	[[_unit,_announce],"INS_toggle_Zeus",false] spawn BIS_fnc_MP;
};
INS_toggle_Zeus = {
	if (IamHC) exitWith {};
	private ["_unit","_announce","_addons","_curator","_curatorCreate","_text"];

	_unit = [_this,0,objNull] call bis_fnc_param;
	_announce = [_this,1,false] call bis_fnc_param;
	_addons = [""];

	if (!isNull (getAssignedCuratorLogic _unit)) exitWith {
		_curator = getAssignedCuratorLogic _unit;
		unassignCurator _curator;
		deleteVehicle _curator;

		if (_announce) then {
			_text = format [localize "STR_BMR_curator_removed", name _unit];
			[_text,"JIG_MPhint_fnc"] call BIS_fnc_mp;
		};
	};

	if (!(_unit in playableUnits)) exitWith {};

	(localize "STR_BMR_loading") remoteExec ["JIG_MPhint_fnc", _unit];

	_curatorCreate = true;
	{
		if (isNull (getAssignedCuratorUnit _x)) exitWith {
			_curator = _x;
			_curatorCreate = false;
		};
	} forEach allCurators;

	if (_curatorCreate) then {
		_curator = (createGroup sideLogic) createUnit ["modulecurator_f",[0,0,0],[],0,"NONE"];
		{_curator setCuratorCoef [_x,0];} forEach ["place","edit","delete","destroy","group","synchronize"];
		_curator addEventHandler ['CuratorObjectPlaced',{
			{
				[_x] call BTC_AIunit_init;
				_x addeventhandler ["killed","[(_this select 0)] spawn remove_carcass_fnc"];
				if !(AIdamMod isEqualTo 100) then {
					_x removeAllEventHandlers "HandleDamage";
					_x addEventHandler ["HandleDamage",{_damage = (_this select 2)*AIdamMod;_damage}];
					_x addEventHandler ['Local',{
						if (_this select 1) then {
							(_this select 0) removeAllEventHandlers 'HandleDamage';
							(_this select 0) addEventHandler ['HandleDamage',{_damage = (_this select 2)*AIdamMod;_damage}];
						};
					}];
				};
				if (INS_op_faction isEqualTo 16) then {[_x] call Trade_Biofoam_fnc};
			} forEach crew (_this select 1);
		}];
	};

	_curator setVariable ["Addons",3,true];
	_cfgPatches = configfile >> "cfgpatches";
	for "_i" from 0 to (count _cfgPatches - 1) do {
		_class = _cfgPatches select _i;
		if (isclass _class) then {_addons pushBack (configname _class);};
	};

	_addons call bis_fnc_activateaddons;
	removeallcuratoraddons _curator;
	[_curator,_addons,{true},""] call BIS_fnc_manageCuratorAddons;
	_curator addCuratorAddons _addons;
	_curator addCuratorEditableObjects [allUnits,true];
	//if (!isNil "BTC_cargo_repo") then {
	//	_curator removeCuratorEditableObjects [[BTC_cargo_repo],true];
	//};
	_unit assignCurator _curator;

	if (DebugEnabled isEqualTo 1) then {diag_log curatorAddons _curator;};

	if (_announce) then {
		_text = format[localize "STR_BMR_is_curator",name _unit];
		[_text,"JIG_MPhint_fnc"] call BIS_fnc_mp;
	};
};
Terminal_acction_MPfnc = {
	if (hasInterface) then {
		if (isNil "TerminalAcctionID" && (!isNull Land_DataTerminal_Obj)) then {
			TerminalAcctionID =
			[
				Land_DataTerminal_Obj,
				(localize "STR_BMR_Tsk_topic_global_Retrieve_Intel"),
				"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
				"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
				"_this distance Land_DataTerminal_Obj < 2",
				"true",
				{[Land_DataTerminal_Obj, 3] call BIS_fnc_DataTerminalAnimate},
				{hintSilent "Dont stop"},
				{
					private _side = (side player) call bis_fnc_sideID;
					missionNamespace setVariable ["datadownloadedby",_side,true];
					hintSilent "Intel Received";
					[Land_DataTerminal_Obj,TerminalAcctionID] call BIS_fnc_holdActionRemove;
				},
				{hintSilent "Retrieval aborted"; [Land_DataTerminal_Obj, 0] call BIS_fnc_DataTerminalAnimate},
				["Your side wins"],
				6,
				0,
				true,
				false
			] call bis_fnc_holdActionAdd;
		};
	};
	true
};
INS_Brighter_Nights = {
	// Thanks to Ralian for code
	params [["_intensity", 1, [0]]];
	[
		"ColorCorrections",
		1500,
		[
			1,
			_intensity,
			0,
			1, 1, 1, 0.01,
			1, 1, 1, 1,
			.299, .587, .114, 0
		]
	] spawn {
		params ["_name", "_priority", "_effect", "_handle"];
		if (DebugEnabled isEqualTo 1) then {diag_log format ["Brighter Night Effect Array: %1", _effect]};
		while {
			_handle = ppEffectCreate [_name, _priority];
			_handle < 0
		} do {
			_priority = _priority + 1;
		};
		_handle ppEffectEnable true;
		_handle ppEffectAdjust _effect;
		_handle ppEffectCommit 1;
	};
	true
};
Drop_SmokeFlare_fnc = {
	/*
	Pops Chemlight and (Smoke or Airborne Flare) at map click position. by Jigsor.
	PARAMETERS:
		1. How many smokes or flares to spawn. Min = 1. Max = 50
		2. Type - 0 = smoke greanades, 1 = flares
		3. Flare height in meters
		4. Color of the flares and smoke. Accepted - "red","green","yellow" or "white"
		5. Dispersion radius. Optional. Min = 5. Max = 500
		6. position. Optional. Must be provided when function executioner is not player.
	Execute Local Examples:
		Smoke only -
			0=[10,0,208,"green",20] spawn Drop_SmokeFlare_fnc;
		Flares only -
			0=[15,1,208,"green",25] spawn Drop_SmokeFlare_fnc;
	Executed from server:
		Flares from server -
			0=[12,1,220,"green",75,[3276.91,5278.15,0.00141907]] spawn Drop_SmokeFlare_fnc;
	*/
	params ["_objCount","_objTyp","_height","_color","_range","_pos"];
	private ["_col","_lA","_fA","_sA","_mapClick","_chemLight","_smoke","_flare","_dir","_dir2","_logic","_lPos","_cA","_offset"];

	_col = toLower _color;
	_lA = [];
	_fA = [];
	_sA = [];
	_mapClick = false;

	if (_objCount < 1) then {
		_objCount = 1;
	}else{
		if (_objCount > 50) then {_objCount = 50};
	};

	if ((_objTyp == 0) && (_color isEqualTo "white")) then {
		_col = "";
	}else{
		switch (true) do {
			case (_col isEqualTo "red") : {_cA = [1.0,0,0];};
			case (_col isEqualTo "green") : {_cA = [0,1.0,0];};
			case (_col isEqualTo "yellow") : {_cA = [1.0,1.0,0];};
			case (_col isEqualTo "white") : {_cA = [1.0,1.0,1.0];};
			default {_cA = [1.0,1.0,1.0];};
		};
	};

	if ((count _this) -1 < 3) then {
		_range = 25;
	}else{
		if (_range < 5) then {_range = 5};
		if (_range > 500) then {_range = 500};
	};

	if ((count _this) -1 < 5) then {_mapClick = true;}else{_pos = _this select 5;};

	if (_mapClick) then {
		if ({_x in (items player + assignedItems player)}count ["ItemMap"] < 1) exitWith {hint localize "STR_BMR_missing_map"};

		uiSleep 3;
		openMap true;
		player groupChat "Map Click";
		mapclick = false;

		["Flare_mapclick","onMapSingleClick", {
			clickpos = _pos;
			mapclick = true;
		}] call BIS_fnc_addStackedEventHandler;

		waituntil {mapclick or !(visiblemap)};
		["Flare_mapclick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;

		if (!visibleMap) exitwith {hint "Standby";};

		_pos = clickpos;
		sleep 1;
		openMap false;
	};

	_logic = createVehicle ["Land_ClutterCutter_small_F", _pos, [], 0, "CAN_COLLIDE"]; sleep 0.1;
	_chemLight = createVehicle ["Chemlight_green", _pos, [], 0, "NONE"]; sleep 0.1;
	_lPos = [(getPosWorld _logic) select 0, (getPosWorld _logic) select 1, ((getPosWorld _logic) select 2) + _height];

	if (_objTyp == 0) then {
		for "_i" from 0 to (_objCount -1) do {
			_dir = floor random 360;
			_dir2 = floor random 360;
			_offset = [round((_lPos select 0)-_range*sin(_dir)), round((_lPos select 1)-_range*cos(_dir2)), 50];
			_smoke = createVehicle [(format ["Smokeshell%1", _col]), _offset, [], 0, "NONE"];
			_sA pushBack _smoke;
			uiSleep 0.5;
		};
	};

	if (_objTyp == 1) then {
		for "_i" from 0 to (_objCount -1) do {
			_dir = floor random 360;
			_offset = [round((_lPos select 0)-_range*sin(_dir)), round((_lPos select 1)-_range*cos(_dir)), _height];
			_flare = (format ["F_40mm%1","_"+_col]) createVehicle _offset; sleep 0.01;

			_light = "#lightpoint" createVehicle (getPosATL _flare);
			_light setLightBrightness 2.0;
			_light setLightAmbient _cA;
			_light setLightUseFlare true;
			_light setLightFlareSize 4;
			_light setLightFlareMaxDistance 500;
			_light setLightColor _cA;
			_light lightAttachObject [_flare, [0,0,0]];
			_flare setVelocity [round(random 14) -7,round(random 14) -7,-10];

			_lA pushBack _light;
			_fA pushBack _flare;
			uiSleep 0.5;
		};

		while {count _fA > 0} do {
			if (vectorMagnitudeSqr velocity (_fA select 0) <= 0.5) then {
				deleteVehicle (_lA select 0);
				_fA deleteAt 0;
				_lA deleteAt 0;
			};
			uiSleep 0.4;
		};
	};

	deleteVehicle _chemLight;
	deleteVehicle _logic;
};
Trade_Biofoam_fnc = {
	params ["_obj","_objItems"];
	_objItems = items _obj;
	{
		if (_objItems find "OPTRE_Biofoam" != -1) then {
			_obj removeItem "OPTRE_Biofoam";
			_obj addItem "FirstAidKit";
		};
	} forEach _objItems;
	true
};
JIG_Dust_Storm_Server = {
	// Admin Menu Dust Storm Toggle
	if !([] call JIG_DustIsOn) then {
		[] spawn JIG_ActivateDust;
	};
};
JIG_Dust_Storm = {
	// Client Side Dust Storm
	if (!hasInterface) exitWith {};
	waituntil {!isNull player};
	if (JIG_DustStorm) then {call JIG_dsHaze};// Haze color correction
	[] spawn {// Dust
		private ["_color","_alpha","_d"];
		while {JIG_DustStorm} do {
			_pos = position player;
			_color = [1,0.894,0.631];
			_alpha = 0.02 + random 0.02;
			_d = "#particlesource" createVehicleLocal _pos;
			_d setParticleParams [["\A3\data_f\ParticleEffects\Universal\universal.p3d", 16, 12, 8], "", "Billboard", 1, 6, [0, 0, -5], [(wind select 0), (wind select 1), -1], 1, 1.275, 1, 0.01, [20], [_color + [0], _color + [_alpha], _color + [0]], [1000], 1, 0.1, "", "", _pos];
			_d setParticleRandom [3, [-30, -30, 0], [0, 0, 0], 1, 0, [0, 0, 0, 0.01], 0, 0, 0, 1];
			_d setParticleCircle [30, [0, 0, 0]];
			_d setDropInterval 0.01;
			uiSleep 1 + random 2;
			deleteVehicle _d;
		};
	};
	[] spawn {// Branches/TumbleWeeds
		private ["_b","_ran"];
		while {JIG_DustStorm} do {
			_ran = ceil random 5;
			playsound format ["wind%1",_ran];
			_b  = "#particlesource" createVehicleLocal (getpos player);
			if (vehicle player != player) then {_b attachto [vehicle player];} else {_b attachto [player];};
			_b setParticleRandom [0, [10, 10, 7], [(wind select 0), (wind select 1), 5], 2, 0.1, [0, 0, 0, 0.5], 1, 1];
			_b setParticleCircle [100, [0, 0, 0]];
			_b setParticleParams [["\A3\data_f\ParticleEffects\Hit_Leaves\Sticks_Green", 1, 1, 1], "", "SpaceObject", 3, 7, [0,0,0], [(wind select 0), (wind select 1),10], 5, 0.000001, 0.0, 0.04, [0.5 + random 3], [[0.68,0.68,0.68,1]], [1.5,1], 1, 1, "", "", vehicle player, 0, true, 1, [[0,0,0,0]]];
			_b setDropInterval 0.6;
			sleep 5 + random 10;
			deleteVehicle _b;
		};
	};
	[] spawn {// Leaves
		private "_l";
		while {JIG_DustStorm} do {
			_l  = "#particlesource" createVehicleLocal (getpos player);
			if (vehicle player != player) then {_l attachto [vehicle player];} else {_l attachto [player];};
			_l setParticleRandom [0, [10, 10, 7], [(wind select 0), (wind select 1), 5], 2, 0.1, [0, 0, 0, 0.5], 1, 1];
			_l setParticleCircle [100, [0, 0, 0]];
			_l setParticleParams [["\A3\data_f\cl_leaf3", 1, 0, 1], "", "SpaceObject", 3, 7, [0,0,0], [(wind select 0), (wind select 1), 6], 2, 0.00003, 0.0, 0.00001, [0.5 + random 3], [[0.1,0.1,0.1,1]], [1.5,1], 1, 1, "", "", vehicle player, 0, true, 1, [[0,0,0,0]]];
			_l setDropInterval 0.2;
			uiSleep 0.2 + random 0.5;
			deleteVehicle _l;
		};
		call JIG_dsClear;// Clear color correction
	};
};
JIG_IED_FX = {
	if (!hasInterface) exitWith {};
	params ["_trig"];
	addCamShake [5, 5, 20];
	[player, 1] call BIS_fnc_dirtEffect;
	playSound3d['A3\Missions_F_EPA\data\sounds\combat_deafness.wss', _trig, false, getPosASL _trig, 15, 1, 50];
};
switchMoveEverywhere = compileFinal " _this select 0 switchMove (_this select 1); ";
INS_BluFor_Siren = compileFinal " if (isServer) then {
	[INS_BF_Siren,""siren""] call mp_Say3D_fnc;
	[[""Enemy Presence Detected at Base!""],""JIG_MPsideChatWest_fnc""] call BIS_fnc_mp;
	[INS_BF_Siren2,""siren""] call mp_Say3D_fnc;
	alarm1On = false;
}; ";
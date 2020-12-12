//commom_fncs.sqf by Jigsor

// Global hint
JIG_MPhint_fnc = {if (hasInterface) then { hintSilent _this };};
JIG_MPsideChatWest_fnc = {[West,"HQ"] SideChat (_this # 0)};
JIG_MPsideChatEast_fnc = {[East,"HQ"] SideChat (_this # 0)};
JIG_MPSystemChat_fnc = { systemChat (_this # 0)};
JIG_Boo = {playSound "boo"};
JIG_MPTitleText_fnc = {
	if (hasInterface) then {
		params ["_text"];
		copyToClipboard str(_text);
		sleep 3;
		//("BMR_MPTitleText_Layer" call BIS_fnc_rscLayer) cutText [_text,"PLAIN"];
		cutText [_text,"PLAIN"];
	};
};
INS_missing_mods = {
	if (hasInterface) then {
		if (isServer) then {
			player sideChat "BMR Insurgency warning. This machine is missing mods and will not spawn enemy AI. Check mod installations.";
		}else{
			player sideChat "BMR Insurgency warning. This machine is missing mods. You may not see enemies or their equipment. Check mod installations";
			// Uncomment next line to kick players missing mods required by the mission.
			//("BMR_Layer_end4" call BIS_fnc_rscLayer) cutText [ "This machine is missing required mod(s). Check mod installations and try again.", "BLACK OUT", 1, true ]; sleep 10; endMission "END4";
		};
	}else{
		diag_log "!!!BMR Insurgency warning!!! This machine is missing mods and will not spawn enemy AI. Check mod installations.";
	};
};
Hide_Mkr_fnc = {
	params ["_mkrarray","_hidden_side"];
	if (!hasInterface) exitWith {};
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
anti_collision = {
	// fixes wheels stuck in ground/vehicles exploding when entering bug by Jigsor.
	params ["_obj"];
	private _origPos = getPosATL _obj;
	_obj setVectorUP (surfaceNormal [_origPos # 0,_origPos # 1]);
	_obj setPos (_origPos vectorAdd [0,0,0.3]);
	true
};
BMR_resetDamage = {
	params ["_veh"];
	sleep 2;
	if (!isNull _veh && {damage _veh > 0}) then {_veh setdamage 0};
};
Playable_Op4_disabled = {
	if (!hasInterface) exitWith {};
	_playAsOp4 = ["INS_play_op4", 5] call BIS_fnc_getParamValue;
	_txt = if (_playAsOp4 isEqualTo 99) then {"Opfor player slots are currently disabled. Please rejoin and choose a Blufor slot."} else {format ["%1 Blufor players are required to play as Opfor. Please rejoin and choose a Blufor slot.", _playAsOp4]};
	("BMR_Layer_end2" call BIS_fnc_rscLayer) cutText [ _txt, "BLACK OUT", 1, true ];
	if (isServer) then {"END2" remoteExec ["endMission", -2]};
	sleep 10;
	endMission "END2";
};
Kicked_for_TKing = {
	if (!isServer && hasInterface) then {
		("BMR_Layer_end3" call BIS_fnc_rscLayer) cutText [ "You have been kicked for team killing for mission duration!", "BLACK OUT", 1, true ];
		sleep 10;
		endMission "END3";
	};
};
INS_full_stamina = {
	params [["_unit",objNull]];
	if (isNull _unit) exitWith {};
	_unit enableStamina false;
	_unit enableFatigue false;
	_unit forceWalk false;
	_unit setCustomAimCoef 0.2;//weapon sway 1=max, 0=min
	_unit setAnimSpeedCoef 1;//animation speed 1=max, 0=min
};
mhq_actions_fnc = {
	// Add action for VA and quick VA profile to respawned MHQs. by Jigsor
	params ["_veh","_var"];

	switch (true) do {
		case (_var isEqualTo "MHQ_1"): {
			if (INS_VA_type in [0,3]) then {
				_veh addAction[("<t color='#F56618'>") + (localize "STR_BMR_load_VAprofile") + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[(_this # 1)],JIG_load_VA_profile_MHQ1],1,true,true,"","true",12];
				_veh addAction[("<t color='#ff1111'>") + (localize "STR_BMR_open_VA") + "</t>",{["Open",true] call BIS_fnc_arsenal},nil,6,true,true,"","side _this != EAST",12];
			};
			if (INS_VA_type in [1,2]) then {
				_veh addAction[("<t color='#ff1111'>") + (localize "STR_BMR_open_VA") + "</t>",{[_this] call JIG_VA},nil,6,true,true,"","side _this != EAST",12];
			};
			if (_veh isKindOf "Ship") then {
				_veh addAction ["<t color='#FF9900'>Push</t>",{call Push_Vehicle},[],-1,false,true,"","",8];
			};
		};
		case (_var isEqualTo "MHQ_2"): {
			if (INS_VA_type in [0,3]) then {
				_veh addAction[("<t color='#F56618'>") + (localize "STR_BMR_load_VAprofile") + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[(_this # 1)],JIG_load_VA_profile_MHQ2],1,true,true,"","true",12];
				_veh addAction[("<t color='#ff1111'>") + (localize "STR_BMR_open_VA") + "</t>",{["Open",true] call BIS_fnc_arsenal},nil,6,true,true,"","side _this != EAST",12];
			};
			if (INS_VA_type in [1,2]) then {
				_veh addAction[("<t color='#ff1111'>") + (localize "STR_BMR_open_VA") + "</t>",{[_this] call JIG_VA},nil,6,true,true,"","side _this != EAST",12];
			};
			if (_veh isKindOf "Ship") then {
				_veh addAction ["<t color='#FF9900'>Push</t>",{call Push_Vehicle},[],-1,false,true,"","",8];
			};
		};
		case (_var isEqualTo "MHQ_3"): {
			if (INS_VA_type in [0,3]) then {
				_veh addAction[("<t color='#F56618'>") + (localize "STR_BMR_load_VAprofile") + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[(_this # 1)],JIG_load_VA_profile_MHQ3],1,true,true,"","true",12];
				_veh addAction[("<t color='#ff1111'>") + (localize "STR_BMR_open_VA") + "</t>",{["Open",true] call BIS_fnc_arsenal},nil,6,true,true,"","side _this != EAST",12];
			};
			if (INS_VA_type in [1,2]) then {
				_veh addAction[("<t color='#ff1111'>") + (localize "STR_BMR_open_VA") + "</t>",{[_this] call JIG_VA},nil,6,true,true,"","side _this != EAST",12];
			};
		};
		case (_var isEqualTo "Opfor_MHQ"): {
			_veh addAction[("<t color='#12F905'>") + ("Deploy MHQ") + "</t>","scripts\deployOpforMHQ.sqf",nil,1, false, true, "", "side _this != INS_Blu_side", 12];
			//_veh addAction[("<t color='#12F905'>") + (localize "STR_BMR_restore_default_loadout") + "</t>",{call Op4_restore_loadout},nil,1,false,true,"","side _this != INS_Blu_side",12];
		};
		case (_var isEqualTo ""): {};
	};
};
Op4_restore_loadout = {
	_caller = _this # 1;
	[_caller] execVM "scripts\DefLoadoutOp4.sqf";
};
JIG_load_VA_profile_MHQ1 = {
	if (!isNil {profileNamespace getVariable "bis_fnc_saveInventory_data"}) then {
		private ["_name_index","_VA_Loadouts_Count"];
		_VA_Loadouts_Count = count (profileNamespace getVariable "bis_fnc_saveInventory_data");
		_name_index = 0;
		for "_i" from 0 to (_VA_Loadouts_Count/2) -1 step 1 do {
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
		for "_i" from 0 to (_VA_Loadouts_Count/2) -1 step 1 do {
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
		for "_i" from 0 to (_VA_Loadouts_Count/2) -1 step 1 do {
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
	if (hasInterface) then {_obj say3D _snd};
	true
};
fnc_mp_intel = {
	// Intel addaction. by Jigsor
	params ["_intelobj","_cachepos"];
	if (!isNull _intelobj) then {
		_intelobj addAction [("<t color='#ffff00'>") + (localize "STR_BMR_GrabIntel") + "</t>", "call JIG_intel_found", _cachepos, 6];
	};
	true
};
INS_end_mssg = {
	if (hasInterface) then {
		0 spawn {
			private ["_video","_play"];
			0 fadeMusic 1;
			playMusic ["LeadTrack01a_F_EXP",16];
			if (isNull objectParent player) then {
				removeAllWeapons player;
				removeBackpack player;
				player playMove "AmovPercMstpSnonWnonDnon_exerciseKata";
			};
			private _dd = missionNameSpace getVariable ["BMR_DawnDusk",[]];
			_dd params ["_dawn","_dusk"];
			if (daytime > _dusk || daytime < _dawn) then {
				0=[15,1,160,"red",10,(position player)] spawn Drop_SmokeFlare_fnc;
			};
			_video = selectRandom INS_ending_videos;
			_play = [_video] spawn BIS_fnc_playVideo;
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
HV_tower_effect = {
	if (hasInterface) then {
		private _emitter = objective_pos_logic;
		private _lightningpos = [position objective_pos_logic # 0,position objective_pos_logic # 1,10];
		private _source = "#particlesource" createVehiclelocal (getPos objective_pos_logic);

		_source setParticleCircle [0,[0,0,0]];
		_source setParticleRandom [0,[0.25,0.25,0], [0.175,0.175,0],0,0.25,[0,0,0,0.1],0,0];
		_source setParticleParams [["\A3\data_f\blesk1",1,0,1],"","SpaceObject",1,0.4,_lightningpos,[0,0,3],0,10,7.9,0.075,[1.2, 2, 4],[[0.1,0.1,0.1,1],[0.25,0.25,0.25,0.5],[0.5,0.5,0.5,0]],[0.08,0,0,0,0,0,5],0.5,0,"","",_emitter];
		_source setDropInterval 0.1;

		for "_i" from 0 to 7 step 1 do {
			drop ["\A3\data_f\blesk1","","SpaceObject",1,0.1,_lightningpos,[0,0,3],0,10,7.9,0.075,[1.2,2,4],[[0.1,0.1,0.1,1],[0.25,0.25,0.25,0.5],[0.5,0.5,0.5,0]],[0.08,0,0,0,0,0,5],0.5,0,"","",""];
			uiSleep 0.1;
		};
		deleteVehicle _source;
	};
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
				if (_dis2 <= _dis1) then {(vehicle _unit) call BIS_fnc_neutralizeUnit};
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
				if (_dis2 <= _dis1) then {(vehicle _unit) call BIS_fnc_neutralizeUnit};
			}else{
				sleep 0.899;
				(vehicle _unit) call BIS_fnc_neutralizeUnit;
			};
		};
	};
	true
};
fnc_mp_push = {
	if (hasInterface) then {
		params ["_veh"];
		_veh addAction [("<t color='#FF9900'>") + (localize "STR_BMR_Push") + "</t>", {call Push_Vehicle},[],-1,false,true,"","",8];
	};
	true
};
Push_Acc = {
	params [["_veh",objNull]];
	if (isNull _veh) exitWith {};
	[_veh] remoteExec ["fnc_mp_push", [0,-2] select isDedicated];
	true
};
Push_Vehicle = {
	/* Boat push script - v0.1
	Pushes the boat in the direction the player is looking
	Created by BearBison */
	params ["_veh","_unit"];
	private _isWater = surfaceIsWater getPosWorld _unit;
	if (_unit in _veh) exitWith {titleText[localize "STR_BMR_push_restrict2","PLAIN DOWN",1]};
	if (_isWater) exitWith {titleText[localize "STR_BMR_push_restrict1","PLAIN DOWN",1]};
	_veh setOwner (owner _unit);
	_unit playMove "AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon_Putdown";
	if (currentWeapon _unit isEqualTo "") then {sleep 1} else {sleep 2};
	_veh setVelocity [(sin(direction _unit))*3, (cos(direction _unit))*3, 0];
	true
};
INS_fog_effect = {
	if (hasInterface) then {null=["ObjectiveMkr",100,11,10,3,7,-0.3,0.1,0.5,1,1,1,13,12,15,true,2,2.1,0.1,4,6,0,3.5,17.5] execFSM "scripts\Fog.fsm"};
};
mhq_obj_fnc = {
	// returns MHQ vehicleVarname object
	private ["_var","_obj"];
	_var = _this # 0;
	_obj = objNull;
	switch (true) do {
		case (_var isEqualTo "MHQ_1") : {_obj = MHQ_1; if (vehicleVarname MHQ_1 isEqualTo "") then {MHQ_1 setVehicleVarname "MHQ_1"; MHQ_1 = _obj}};
		case (_var isEqualTo "MHQ_2") : {_obj = MHQ_2; if (vehicleVarname MHQ_2 isEqualTo "") then {MHQ_2 setVehicleVarname "MHQ_2"; MHQ_2 = _obj}};
		case (_var isEqualTo "MHQ_3") : {_obj = MHQ_3; if (vehicleVarname MHQ_3 isEqualTo "") then {MHQ_3 setVehicleVarname "MHQ_3"; MHQ_3 = _obj}};
		case (_var isEqualTo "Opfor_MHQ") : {_obj = Opfor_MHQ; if (vehicleVarname Opfor_MHQ isEqualTo "") then {Opfor_MHQ setVehicleVarname "Opfor_MHQ"; Opfor_MHQ = _obj}};
		case (_var isEqualTo "") : {};
		default {};
	};
	_obj
};
INS_Zeus_MP = {
	// Admin can toggle Zeus on or off in breifing admin panel.
	private _unit = _this param [0,objNull,[objNull]];
	private _announce = _this param [1,false,[true]];
	if(isNull _unit) exitWith {};
	[[_unit,_announce],"INS_toggle_Zeus",false] spawn BIS_fnc_MP;
};
INS_toggle_Zeus = {
	if (IamHC) exitWith {};

	private _unit = _this param [0,objNull,[objNull]];
	private _announce = _this param [1,false,[true]];
	if(isNull _unit) exitWith {};
	private _addons = [""];

	private ["_curator","_curatorCreate","_text","_allunits"];
	if (!isNull (getAssignedCuratorLogic _unit)) exitWith {
		_curator = getAssignedCuratorLogic _unit;
		unassignCurator _curator;
		deleteVehicle _curator;

		_text = format [localize "STR_BMR_curator_removed", name _unit];
		if (_announce) then {
			_text remoteExec ['JIG_MPhint_fnc', [0,-2] select isDedicated];
		} else {
			(localize "STR_BMR_curator_removed") remoteExec ['JIG_MPhint_fnc', _unit];
		};
		diag_log _text;
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
		_curator = (createGroup sideLogic) createUnit ["modulecurator_f",[0,0,0],[],0,"CAN_COLLIDE"];
		{_curator setCuratorCoef [_x,0];} forEach ["place","edit","delete","destroy","group","synchronize"];
		_curator setVariable ["TFAR_curatorCamEars", true];
		_curator addEventHandler ['CuratorObjectPlaced',{
			params ["_curator","_entity"];
			{
				[_x] call BTC_AIunit_init;
				_x addeventhandler ["killed","[(_this select 0)] spawn remove_carcass_fnc"];
				if !(AIdamMod isEqualTo 1) then {
					_x removeAllEventHandlers 'HandleDamage';
					_x addEventHandler ['HandleDamage',{_damage = (_this select 2)*AIdamMod;_damage}];
					_x addEventHandler ['Local',{
						if (_this select 1) then {
							(_this select 0) removeAllEventHandlers 'HandleDamage';
							(_this select 0) addEventHandler ['HandleDamage',{_damage = (_this select 2)*AIdamMod;_damage}];
						};
					}];
				};
				if (INS_op_faction in [20]) then {[_x] call Trade_Biofoam_fnc};
			} forEach crew _entity;
			if ((_entity isKindOf "CAManBase") && {count units group _entity < 2}) then {
				if (!(side _entity isEqualTo INS_Op4_side) && {side _entity in [RESISTANCE,EAST]}) then {
					_grp = createGroup INS_Op4_side;
					[_entity] joinSilent _grp;
				};
			};
		}];

		_curator addEventHandler ['CuratorGroupPlaced',{
			params ["", "_group"];
			if (!(side leader _group isEqualTo INS_Op4_side) && {side leader _group in [RESISTANCE,EAST]}) then {
				_grp = createGroup INS_Op4_side;
				_units = units _group;
				{[_x] joinSilent _grp;} forEach _units;
			};
		}];
	};

	_curator setVariable ["Addons",3,true];
	_cfgPatches = configfile >> "cfgpatches";
	for "_i" from 0 to (count _cfgPatches - 1) do {
		_class = _cfgPatches select _i;
		if (isclass _class) then {_addons pushBack (configname _class)};
	};

	_addons call bis_fnc_activateaddons;
	removeallcuratoraddons _curator;
	[_curator,_addons,{true},""] call BIS_fnc_manageCuratorAddons;
	_curator addCuratorAddons _addons;
	
	
	//Prevent Zeus from interrupting an extraction in progress
	if (isDedicated && {!isNil "EvacHeliW1" && {!isNull EvacHeliW1 && {!isNull (currentPilot EvacHeliW1)}}}) then {
		_exclude = units (group (driver EvacHeliW1));
		_allunits = allUnits select {!(_x in _exclude)};
	}
	else
	{
		_allunits = allUnits;
	};

	_curator addCuratorEditableObjects [_allunits,true];	

	//if (!isNil {missionNamespace getVariable "BTC_cargo_repo"} && {!isNull BTC_cargo_repo}) then {_curator removeCuratorEditableObjects [[BTC_cargo_repo],true]};
	if (!isNil {missionNamespace getVariable "Land_DataTerminal_Obj"} && {!isNull Land_DataTerminal_Obj}) then {_curator addCuratorEditableObjects [[Land_DataTerminal_Obj],true]};
	_unit assignCurator _curator;

	if (DebugEnabled isEqualTo 1) then {diag_log curatorAddons _curator};

	_text = format[localize "STR_BMR_is_curator",name _unit];
	if (_announce) then {
		_text remoteExec ['JIG_MPhint_fnc', [0,-2] select isDedicated];
	} else {
		(localize "STR_BMR_initialize_done") remoteExec ['JIG_MPhint_fnc', _unit];
	};
	diag_log _text;
};
Terminal_acction_MPfnc = {
	if (hasInterface) then {
		waitUntil {sleep 1; !isNull player};
		if (isNil "TerminalAcctionID" && (!isNull Land_DataTerminal_Obj)) then {
			TerminalAcctionID =
			[
				Land_DataTerminal_Obj,
				(localize "STR_BMR_Tsk_topic_global_Retrieve_Intel"),
				"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
				"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
				"_this distance Land_DataTerminal_Obj < 2 && side _this in [WEST,EAST,RESISTANCE]",
				"true",
				{[player, "Acts_TerminalOpen"] remoteExec ["switchMoveEverywhere", 0]; Land_DataTerminal_Obj setdir getdir player; [Land_DataTerminal_Obj, 3] call BIS_fnc_DataTerminalAnimate},
				{hintSilent "Recieving..."},
				{
					private _side = (side player) call bis_fnc_sideID;
					missionNamespace setVariable ["datadownloadedby",_side,true];
					hintSilent "Intel Received";
					[Land_DataTerminal_Obj,TerminalAcctionID] call BIS_fnc_holdActionRemove;
					[player, "AmovPknlMstpSrasWrflDnon"] remoteExec ["switchMoveEverywhere", 0];
				},
				{hintSilent "Retrieval aborted"; [player, "AmovPknlMstpSrasWrflDnon"] remoteExec ["switchMoveEverywhere", 0]; [Land_DataTerminal_Obj, 0] call BIS_fnc_DataTerminalAnimate},
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
	if (!hasInterface) exitWith {};
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
			case (_col isEqualTo "red") : {_cA = [1.0,0,0]};
			case (_col isEqualTo "green") : {_cA = [0,1.0,0]};
			case (_col isEqualTo "yellow") : {_cA = [1.0,1.0,0]};
			case (_col isEqualTo "white") : {_cA = [1.0,1.0,1.0]};
			default {_cA = [1.0,1.0,1.0]};
		};
	};

	if ((count _this) -1 < 3) then {
		_range = 25;
	}else{
		if (_range < 5) then {_range = 5};
		if (_range > 500) then {_range = 500};
	};

	if ((count _this) -1 < 5) then {_mapClick = true}else{_pos = _this # 5};

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

		if (!visibleMap) exitwith {hint "Standby"};

		_pos = clickpos;
		sleep 1;
		openMap false;
	};

	_logic = createVehicle ["Land_ClutterCutter_small_F", _pos, [], 0, "CAN_COLLIDE"]; sleep 0.1;
	_chemLight = createVehicle ["Chemlight_green", _pos, [], 0, "NONE"]; sleep 0.1;
	_lPos = ((getPosWorld _logic) vectorAdd [0,0,_height]);

	if (_objTyp == 0) then {
		for "_i" from 0 to (_objCount -1) step 1 do {
			_dir = floor random 360;
			_dir2 = floor random 360;
			_offset = [round((_lPos select 0)-_range*sin(_dir)), round((_lPos select 1)-_range*cos(_dir2)), 50];
			_smoke = createVehicle [(format ["Smokeshell%1", _col]), _offset, [], 0, "NONE"];
			_sA pushBack _smoke;
			uiSleep 0.5;
		};
	};

	if (_objTyp == 1) then {
		for "_i" from 0 to (_objCount -1) step 1 do {
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
	params [["_vel", 12, [0]]];
	if !(call JIG_DustIsOn) then {
		[_vel] spawn JIG_ActivateDust;
	};
};
JIG_Dust_Storm = {
	// Client Side Dust Storm
	if (!hasInterface) exitWith {};
	waituntil {!isNull player};
	if (JIG_DustStorm) then {call JIG_dsHaze};// Haze color correction
	0 spawn {// Dust
		private ["_color","_alpha","_d"];
		while {JIG_DustStorm} do {
			_pos = position player;
			_color = [1,0.894,0.631];
			_alpha = 0.02 + random 0.02;
			_d = "#particlesource" createVehicleLocal _pos;
			_d setParticleParams [["\A3\data_f\ParticleEffects\Universal\universal.p3d", 16, 12, 8], "", "Billboard", 1, 6, [0, 0, -5], [(wind # 0), (wind # 1), -1], 1, 1.275, 1, 0.01, [20], [_color + [0], _color + [_alpha], _color + [0]], [1000], 1, 0.1, "", "", _pos];
			_d setParticleRandom [3, [-30, -30, 0], [0, 0, 0], 1, 0, [0, 0, 0, 0.01], 0, 0, 0, 1];
			_d setParticleCircle [30, [0, 0, 0]];
			_d setDropInterval 0.01;
			uiSleep 1 + random 2;
			deleteVehicle _d;
		};
	};
	0 spawn {// Branches/TumbleWeeds
		private ["_b","_ran"];
		while {JIG_DustStorm} do {
			_ran = ceil random 5;
			playsound format ["wind%1",_ran];
			_b  = "#particlesource" createVehicleLocal (getpos player);
			if !(isNull objectParent player) then {_b attachto [vehicle player];} else {_b attachto [player];};
			_b setParticleRandom [0, [10, 10, 7], [(wind # 0), (wind # 1), 5], 2, 0.1, [0, 0, 0, 0.5], 1, 1];
			_b setParticleCircle [100, [0, 0, 0]];
			_b setParticleParams [["\A3\data_f\ParticleEffects\Hit_Leaves\Sticks_Green", 1, 1, 1], "", "SpaceObject", 3, 7, [0,0,0], [(wind # 0), (wind # 1),10], 5, 0.000001, 0.0, 0.04, [0.5 + random 3], [[0.68,0.68,0.68,1]], [1.5,1], 1, 1, "", "", vehicle player, 0, true, 1, [[0,0,0,0]]];
			_b setDropInterval 0.6;
			sleep 5 + random 10;
			deleteVehicle _b;
		};
	};
	0 spawn {// Leaves
		private "_l";
		while {JIG_DustStorm} do {
			_l  = "#particlesource" createVehicleLocal (getpos player);
			if !(isNull objectParent player) then {_l attachto [vehicle player];} else {_l attachto [player];};
			_l setParticleRandom [0, [10, 10, 7], [(wind # 0), (wind # 1), 5], 2, 0.1, [0, 0, 0, 0.5], 1, 1];
			_l setParticleCircle [100, [0, 0, 0]];
			_l setParticleParams [["\A3\data_f\cl_leaf3", 1, 0, 1], "", "SpaceObject", 3, 7, [0,0,0], [(wind # 0), (wind # 1), 6], 2, 0.00003, 0.0, 0.00001, [0.5 + random 3], [[0.1,0.1,0.1,1]], [1.5,1], 1, 1, "", "", vehicle player, 0, true, 1, [[0,0,0,0]]];
			_l setDropInterval 0.2;
			uiSleep 0.2 + random 0.5;
			deleteVehicle _l;
		};
		call JIG_dsClear;// Clear color correction
	};
};
JIG_Snow_Server = {
	// Admin Menu Snow Toggle
	params [["_vel", 2, [0]]];
	if !(call JIG_SnowIsOn) then {
		[_vel] spawn JIG_ActivateSnow;
	};
};
JIG_Snow_Storm = {
	// Client Side Snow Storm
	if (!hasInterface) exitWith {};
	waituntil {!isNull player};
	hintSilent "Snow Storm On";
	enableEnvironment [false, false];

	0 spawn {// Snow Dust
		private ["_color","_alpha","_sd"];
		while {JIG_SnowStorm} do {
			if (floor random 6 isEqualTo 0) then {
				_ran = ceil random 5;
				playsound format ["wind%1",_ran];
			};
			_pos = position player;
			_color = [0.9, 1.0, 0.9];
			_alpha = 0.02 + random 0.02;
			_sd = "#particlesource" createVehicleLocal _pos;
			_sd setParticleParams [["\A3\data_f\ParticleEffects\Universal\universal.p3d", 16, 12, 8], "", "Billboard", 1, 2, [0,0,-6], [(wind # 0),(wind # 1),-1], 1, 1.275, 1, 0.01, [11], [_color + [_alpha], _color + [0], _color + [_alpha]], [1000], 1, 0, "", "", _pos, 0, false, 0.5];
			_sd setParticleRandom [3, [30, 30, 0], [0, 0, 0], 1, 0, [0, 0, 0, 0.01], 0, 0, 0, 1];
			_sd setParticleCircle [0.1, [0, 0, 0]];
			_sd setDropInterval 0.2;
			uiSleep 1 + random 2;
			deleteVehicle _sd;
		};
	};

	0 spawn {// Snow Flakes
		private _toDelete = [];
		private "_s";
		while {JIG_SnowStorm} do {
			_s = "#particlesource" createVehicleLocal (getPosATL cameraOn);
			_s setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 8, 1], "", "Billboard", 1, 4, [0,0,0], [0,0,0], 1, 0.000001, 0, 1.4, [0.05,0.05], [[0.8,0.7,0.7,0.8]], [0,1], 0.2, 1.2, "", "", cameraOn, 0, false, 0];
			_s setParticleRandom [0, [10, 10, 7], [0, 0, 0], 0, 0.01, [0, 0, 0, 0.1], 0, 0];
			_s setParticleCircle [0.0, [0, 0, 0]];
			_s setDropInterval 0.02;
			_toDelete pushBack _s;
			uiSleep 0.6 + random 0.6;
			if (count _toDelete > 19) then {
				for "_i" from 0 to 10 step 1 do {
					deleteVehicle (_toDelete select 0);
					_toDelete deleteAt 0;
				};
			};
		};
		{deleteVehicle _x} count _toDelete;
		hintSilent "Snow Storm Off";
	};
};
INS_SnowOverCast = {
	private "_overcast";
	if (!(JIPweather in [2,3]) && {overcast < 0.75}) then {
		_overcast = if ((JIPweather/100) > 0.74) then {(JIPweather/100)} else {0.65};
	} else {
		_overcast = if (overcast < 0.65) then {0.65} else {overcast};
	};
	skipTime -24;
	86400 setOvercast _overcast;
	86400 setFog 0.29;
	skipTime 24;
	sleep 1;
	simulweatherSync;
};
INS_ClearSnowOverCast = {
	private "_overcast";
	if (!(JIPweather in [2,3]) && {overcast < 0.75}) then {
		_overcast = if ((JIPweather/100) > 0.74) then {0.65} else {(JIPweather/100)};
	} else {
		_overcast = if (overcast < 0.5) then {overcast} else {0.5};
	};
	skipTime -24;
	86400 setOvercast _overcast;
	86400 setFog 0;
	skipTime 24;
	sleep 1;
	simulweatherSync;
	0 spawn {sleep 5; if (overcast < 51) then {enableEnvironment [false, true]}};
};
JIG_IED_FX = {
	if (!hasInterface) exitWith {};
	params ["_trig"];
	addCamShake [5, 5, 20];
	[player, 1] call BIS_fnc_dirtEffect;
	playSound3d['A3\Missions_F_EPA\data\sounds\combat_deafness.wss', _trig, false, getPosASL _trig, 15, 1, 50];
};
JWC_CAStrack = {
	// Code by JW Custom modified by Jig
	params [["_plane",objNull]];
	if (isNull _plane) exitWith {};
	_c = [([_plane, true] call BIS_fnc_objectSide), true] call BIS_fnc_sideColor;
	_markerName = format ["track%1",random 99999];
	_marker = createMarker[_markerName, [0,0,0]];
	_markerName setMarkerType "c_plane";
	_markerName setMarkerColor _c;
	while {!isNull _plane} do {
	  _markerName setMarkerDir (getDir _plane);
	  _markerName setMarkerPos (getPosWorld _plane);
	  uiSleep 0.1;
	};
	deleteMarker _marker;
};
Manual_ProgressionSave = {
	// Force zone marker progression saving on Server
	if (!isServer) exitWith {};
	private _uncapturedMkrs = all_eos_mkrs;
	{if (getMarkerColor _x isEqualTo "ColorGreen") then {_uncapturedMkrs = _uncapturedMkrs - [_x];};} foreach _uncapturedMkrs;
	profileNamespace setVariable ["BMR_INS_progress", _uncapturedMkrs];
	saveProfileNamespace;//<-necessary to survive Server executable restart
	diag_log "***Manual Progression Save Complete";
};
Manual_ProgressionClearnEnd = {
	// Clear progression saving on HC and Server then end the mission if saving was enabled
	if (!isServer) exitWith {};
	if !((["INS_persistence", 0] call BIS_fnc_getParamValue) isEqualTo 0) then {
		profileNamespace setVariable ["BMR_INS_progress", []];
		saveProfileNamespace;//<-necessary to survive Server executable restart
		[["END1",true,true], "BIS_fnc_endMission",true,true,true] spawn BIS_fnc_MP;
	};
};
KilledVehRewardMP = {
	params [["_veh",objNull]];
	if (!isNull _veh) then {
		_veh addeventhandler ["killed","[(_this # 0)] spawn remove_carcass_fnc"];
	};
};
switchMoveEverywhere = compileFinal " _this select 0 switchMove (_this select 1); ";
INS_BluFor_Siren = compileFinal " if (isServer) then {
	[INS_BF_Siren,""siren""] call mp_Say3D_fnc;
	[""Enemy Presence Detected at Base!""] remoteExec [""JIG_MPsideChatWest_fnc"", [0,-2] select isDedicated];
	[INS_BF_Siren2,""siren""] call mp_Say3D_fnc;
	alarm1On = false;
}; ";
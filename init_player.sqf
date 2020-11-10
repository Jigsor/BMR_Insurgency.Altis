// init_player.sqf by Jigsor //

if (isNil "aomkr") then {aomkr = []};//air patrole center marker
"aomkr" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};

if (DebugEnabled > 0) then {
	waitUntil {!isNull player && player == player};

	if (isNil "spawnaire") then {spawnaire = []};
	if (isNil "spawnairw") then {spawnairw = []};
	if (isNil "cyclewpmrk") then {cyclewpmrk = []};

	"spawnaire" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
	"spawnairw" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
	"cyclewpmrk" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};

	0 spawn {
		waitUntil {time > 3};
		if (local player) then {
			player allowDamage false;
			player addAction[("<t color='#ff1111'>") + (localize "STR_BMR_open_VA") + "</t>",{["Open",true] call BIS_fnc_arsenal;}];
			player addAction["Reveal All Units","scripts\Reveal_Marker.sqf", [600,15], 1, false, true, "", "true"];
			0 spawn {
				sleep 4;
				setTerrainGrid 50;
				ctrlActivate ((findDisplay 12) displayCtrl 107);
				["Teleport_mapclick","onMapSingleClick", {
					vehicle player setPos [_pos # 0,_pos # 1,0];
				}] call BIS_fnc_addStackedEventHandler;
				while {true} do {
					{systemChat str _x} forEach diag_activeSQFScripts;
					uiSleep 10;
				};
			};
		};
	};

	if (tky_perfmon > 0) then {_nul1 = [tky_perfmon] execVM "scripts\tky_evo_performance_report.sqf"};
	{_x setMarkerAlphaLocal 1} forEach Op4_mkrs + Blu4_mkrs;
};

0 spawn {
	waitUntil {!isNull player && player == player};

	// Player Variables	//

	private _playertype = typeOf (vehicle player);
	player setVariable ["BIS_noCoreConversations", true];
	disableMapIndicators [false,true,true,false];
	enableSentences false;
	setTerrainGrid 25;
	status_hud_on = false;
	INS_SavedLoadout = nil;
	INS_editor_Pgrp = groupId (group player);
	//Delivery_Box enableRopeAttach false;
	//if (local player) then {player setVariable ["BIS_enableRandomization", false]};// Disables randomization of gear
	if (AI_radio_volume isEqualTo 1) then {0 fadeRadio 0};
	if (INS_p_rev in [4,5]) then {player call btc_qr_fnc_unit_init};// BTC Quick Revive
	if (INS_GasGrenadeMod isEqualTo 1) then {player setVariable ["inSmoke",false]};
	if (Remove_grass_opt isEqualTo 1) then {tawvd_disablenone = true};// Disables the grass Option 'None' button in Taw View Distance UI
	if (_playertype in INS_W_PlayerUAVop) then {player setVariable ["ghst_ugvsup", 0]};
	if (_playertype in INS_W_PlayerEng) then {player setVariable ["INS_farp_deployed", false]};
	if (_playertype in INS_W_PlayerEOD) then {
		if !(player getUnitTrait "explosiveSpecialist") then {player setUnitTrait ['explosiveSpecialist',true]};
		0=[] execVM "scripts\minedetector.sqf";
	};
	if (_playertype in INS_all_medics) then {
		if !(player getUnitTrait "Medic") then {player setUnitTrait ['Medic',true]};
	};

	// Fatigue and Stamina
	setStaminaScheme "FastDrain";
	if (Fatigue_ability isEqualTo 0) then {//Disable Fatigue/Stamina
		[player] call INS_full_stamina;
	};

	// Group Manager
	["InitializePlayer", [player]] call BIS_fnc_dynamicGroups;

	// Object Actions //

	// Base Flag Pole
	if (INS_op_faction in [20]) then {
		INS_flag addAction[("<t size='1.5' shadow='2' color='#ff9900'>") + (localize "STR_BMR_halo_jump") + "</t>","scripts\HALO_Pod.sqf", 0, 3.9];
		if (max_ai_recruits > 1) then {
			INS_flag addAction[("<t size='1.5' shadow='2' color='#ff9900'>") + (localize "STR_BMR_ai_halo_jump") + "</t>","scripts\HALO_Pod.sqf", 1, 3.8];
			INS_flag addAction[("<t size='1.5' shadow='2' color='#ff9900'>") + "Player and AI HALO" + "</t>","scripts\HALO_Pod.sqf", 2, 3.79];
		};
	}else{
		INS_flag addAction[("<t size='1.5' shadow='2' color='#ff9900'>") + (localize "STR_BMR_halo_jump") + "</t>","ATM_airdrop\atm_airdrop.sqf", nil, 3.9];
		if (max_ai_recruits > 1) then {INS_flag addAction[("<t size='1.5' shadow='2' color='#ff9900'>") + (localize "STR_BMR_ai_halo_jump") + "</t>","scripts\INS_AI_Halo.sqf", nil, 3.8];};
	};

	INS_flag addAction["<t size='1.5' shadow='2' color='#12F905'>Airfield</t>","call JIG_transfer_fnc", ["Airfield"], 3.7];
	INS_flag addAction["<t size='1.5' shadow='2' color='#12F905'>Dock</t>","call JIG_transfer_fnc", ["Dock"], 3.6];
	if (!isNil "USSfreedom") then {
		private _carrierPos = USSfreedom getRelPos [181, 349];
		INS_flag addAction["<t size='1.5' shadow='2' color='#12F905'>USS Freedom</t>", "call JIG_transfer_fnc", [[(_carrierPos # 0),(_carrierPos # 1),19.2468]], 3.5];
	};

	// Ace Arsenal Init
	if (INS_ACE_core) then {[INS_Wep_box, true] call ace_arsenal_fnc_initBox};

	// Virtual Arsenal
	if (INS_VA_type in [0,3]) then {
		INS_Wep_box addAction[("<t size='1.5' shadow='2' color='#ff1111'>") + (localize "STR_BMR_open_VA") + "</t>",{["Open",true] call BIS_fnc_arsenal}, nil, 1.5, true, true, "", "true", 15];
		MHQ_1 addAction[("<t color='#ff1111'>") + (localize "STR_BMR_open_VA") + "</t>",{["Open",true] call BIS_fnc_arsenal}, nil, 6, true, true, "", "side _this != EAST", 12];
		MHQ_2 addAction[("<t color='#ff1111'>") + (localize "STR_BMR_open_VA") + "</t>",{["Open",true] call BIS_fnc_arsenal}, nil, 6, true, true, "", "side _this != EAST", 12];
		MHQ_3 addAction[("<t color='#ff1111'>") + (localize "STR_BMR_open_VA") + "</t>",{["Open",true] call BIS_fnc_arsenal}, nil, 6, true, true, "", "side _this != EAST", 12];

		INS_Wep_box addAction[("<t size='1.5' shadow='2' color='#00ffe9'>") + (localize "STR_BMR_load_VAprofile") + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[],JIG_load_VA_profile], 1, true, true, "", "true", 15];
		MHQ_1 addAction[("<t color='#F56618'>") + (localize "STR_BMR_load_VAprofile") + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[],JIG_load_VA_profile_MHQ1], 1, true, true, "", "side _this != EAST", 12];
		MHQ_2 addAction[("<t color='#F56618'>") + (localize "STR_BMR_load_VAprofile") + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[],JIG_load_VA_profile_MHQ2], 1, true, true, "", "side _this != EAST", 12];
		MHQ_3 addAction[("<t color='#F56618'>") + (localize "STR_BMR_load_VAprofile") + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[],JIG_load_VA_profile_MHQ3], 1, true, true, "", "side _this != EAST", 12];
	};
	if (INS_VA_type in [1,2]) then {
		INS_Wep_box addAction[("<t size='1.5' shadow='2' color='#ff1111'>") + (localize "STR_BMR_open_VA") + "</t>",{[_this] call JIG_VA}, nil, 1.5, true, true, "", "true", 15];
		MHQ_1 addAction[("<t color='#ff1111'>") + (localize "STR_BMR_open_VA") + "</t>",{[_this] call JIG_VA}, nil, 6, true, true, "", "side _this != EAST", 12];
		MHQ_2 addAction[("<t color='#ff1111'>") + (localize "STR_BMR_open_VA") + "</t>",{[_this] call JIG_VA}, nil, 6, true, true, "", "side _this != EAST", 12];
		MHQ_3 addAction[("<t color='#ff1111'>") + (localize "STR_BMR_open_VA") + "</t>",{[_this] call JIG_VA}, nil, 6, true, true, "", "side _this != EAST", 12];
	};

	// Blufor save respawn loadout
	if (INS_full_loadout isEqualTo 1) then {
		INS_Wep_box addAction[("<t size='1.5' shadow='2' color='#ff9207'>") + (localize "STR_BMR_save_loadout") + "</t>", {call INS_RespawnLoadout}, [], 1, false, true, "", "side _this != EAST", 15];
	};

	// Op4 MHQ
	Opfor_MHQ addAction[("<t color='#12F905'>") + ("Deploy MHQ") + "</t>","scripts\deployOpforMHQ.sqf",nil,1, false, true, "", "side _this != INS_Blu_side", 12];

	// Op4 Weapon Box
	if (INS_VA_type in [2,3]) then {INS_weps_Cbox addAction[("<t size='1.5' shadow='2' color='#ff1111'>") + (localize "STR_BMR_open_VA") + "</t>",{[_this] call JIG_VA}, [], 1, false, true, "", "side _this != INS_Blu_side", 12]};
	if (INS_full_loadout isEqualTo 1) then {INS_weps_Cbox addAction[("<t size='1.5' shadow='2' color='#ff9207'>") + (localize "STR_BMR_save_loadout") + "</t>",{call INS_RespawnLoadout}, [], 1, false, true, "", "side _this != INS_Blu_side", 12]};
	INS_weps_Cbox addAction[("<t size='1.5' shadow='2' color='#ff1111'>") + (localize "STR_BMR_load_saved_loadout") + "</t>",{(_this select 1) call INS_RestoreLoadout},nil,1, false, true, "", "side _this != INS_Blu_side", 12];
	INS_weps_Cbox addAction[("<t size='1.5' shadow='2' color='#12F905'>") + (localize "STR_BMR_restore_default_loadout") + "</t>",{call Op4_restore_loadout},nil,1, false, true, "", "side _this != INS_Blu_side", 12];

	// AI recruitment
	if (max_ai_recruits > 1) then {INS_Wep_box addAction[("<t size='1.5' shadow='2' color='#1d78ed'>") + (localize "STR_BMR_recruit_inf") + "</t>","bon_recruit_units\open_dialog.sqf", [], 1, true, true, "", "true", 15];};

	// Player actions for Engineer's FARP/vehicle service point
	Jig_m_obj addAction[("<t size='1.5' shadow='2' color='#12F905'>") + (localize "STR_BMR_maintenance_veh") + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[],INS_maintenance_veh], 8, true, true, "", "count (nearestObjects [_this, ['LandVehicle','Air','Ship'], 15]) > 0"];
	Jig_m_obj addAction[("<t size='1.5' shadow='2' color='#12F905'>") + (localize "STR_BMR_repair_wreck") + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[],BTC_repair_wreck], 8, true, true, "", "count (nearestObjects [_this, ['LandVehicle','Air','Ship'], 15]) > 0"];
	Jig_m_obj addAction[("<t size='1.5' shadow='2' color='#12F905'>") + (localize "STR_BMR_flip_veh") + "</t>","call INS_Flip_Veh", nil, 8];

	// Player Object Actions //

	0 spawn JIG_p_actions_resp;

	// Player event handlers //

	if (INS_SEH_check) then {
		//Remove any stacked event handler left behind by any mission/rejoin if exists on player. Ideally it should happen once player disconnects or leaves any mission automatically but, it does not. Shitty work around below.
		//To allow a particular pre-existing stacked event handler from a mod for example, add the name of the key to array StackedEHkeysWhiteList in INS_definitions.sqf and INSfncs\common\Remedy_SEHs_fnc.sqf.
		//Detect a stacked EH in debug by type in example line below. indexVarX returns event key string.
		//_data = missionNameSpace getVariable "BIS_stackedEventhandlers_oneachframe"; indexVarX = _data select count _data - 1;
		{
			private ["_event","_namespaceId","_namespaceEvent","_data"];
			_event = _x;
			_namespaceId = "BIS_stackedEventHandlers_";
			_namespaceEvent = _namespaceId + _event;
			_data = missionNameSpace getVariable [_namespaceEvent, []];
			{
				private ["_itemId","_allowed"];
				_allowed = _data select count _data -1 select 0;
				if (_allowed in StackedEHkeysWhiteList) then {
					_data deleteAt count _data -1;
				}else{
					_itemId = _x param [0, "", [""]];
					[_itemId,_event] call bis_fnc_removeStackedEventHandler;
				};
			} foreach _data;
		} forEach ["oneachframe", "onpreloadstarted", "onpreloadfinished", "onmapsingleclick", "onplayerconnected", "onplayerdisconnected"];
	};

	0 spawn {
		sleep 5;
		waitUntil {!isNull (findDisplay 46)};
		(findDisplay 46) displayAddEventHandler ["KeyUp", "_this call Jig_fnc_keyHandler"];
		(findDisplay 46) displayAddEventHandler ["KeyUp", {if ((_this # 1) in ((actionKeys 'User3') + [0x3d])) then {call INS_planeReverse_key_F3;};}];
		if (limitPOV isEqualTo 1 && {(difficultyOption "thirdPersonView") isEqualTo 1}) then {
			player switchCamera "INTERNAL";
			JIG_3rdPersonVeh = (findDisplay 46) displayAddEventHandler["KeyDown", {
				_keyOver = false;
				params['_display','_key','_shift','_ctrl','_alt'];
				if (inputAction 'personView' > 0 && {isNull objectParent player}) then {
					player switchCamera 'INTERNAL';
					_keyOver = true;
				};
				if (_key in [DIK_NUMPADENTER, DIK_DECIMAL, DIK_ABNT_C2] && {inputAction 'personView' isEqualTo 0} && {isNull objectParent player}) then {
					player switchCamera 'INTERNAL';
					_keyOver = true;
				};
				_keyOver
			}];
			player addEventHandler["GetOutMan", {if (cameraView isEqualTo "EXTERNAL") then {player switchCamera "INTERNAL"};}];
		};
	};

	if (INS_full_loadout isEqualTo 0) then {
		player removealleventhandlers "Reloaded";
		player addEventHandler ["Reloaded", {_null = call INS_Depleated_Loadout}];
		player addEventHandler ["Killed", {(_this # 0) removealleventhandlers "Reloaded"; _this spawn killedInfo_fnc}];
		player addEventHandler ["Respawn", {params ["_unit","_corpse"]; _unit spawn INS_RestoreLoadout; _unit addEventHandler ["Reloaded", {_null = call INS_Depleated_Loadout}]; 0 spawn JIG_p_actions_resp; _unit spawn INS_UI_pref; if (INS_p_rev in [6,7]) then {deletevehicle _corpse}}];
	}else{
		player addEventHandler ["Killed", {_this spawn killedInfo_fnc}];
		player addEventHandler ["Respawn", {params ["_unit","_corpse"]; 0 spawn JIG_p_actions_resp; _unit spawn INS_RestoreLoadout; _unit spawn INS_UI_pref; if (INS_p_rev in [6,7]) then {deletevehicle _corpse}}];
	};

	if (!isServer) then {"PVEH_netSay3D" addPublicVariableEventHandler {private _array = _this # 1; (_array # 0) say3D (_array # 1)}};

	if (INS_GasGrenadeMod isEqualTo 1) then {
		player addEventHandler ["Fired", {
			if ((_this # 4) in INS_Gas_Grenades) then {
				(_this # 6) spawn {
					waitUntil {vectorMagnitudeSqr velocity _this <= 0.5};
					private _grenadePos = getPos _this;
					sleep 0.2;
					ToxicGasLoc = _grenadePos;
					publicVariableServer "ToxicGasLoc";
				};
			};
		}];

		smokeNearSEHID = [ "smokeNear", "onEachFrame", {
			if (!(player getVariable ["inSmoke",false]) && {call GAS_smokeNear}) then {
				_inSmokeThread = [] spawn GAS_inSmoke;
			};
		}] call BIS_fnc_addStackedEventHandler;
	};

	if (INS_p_rev in [4,5]) then {
		player addEventHandler ["Killed",{_this spawn {sleep 3; deletevehicle (_this # 0)}}];
		player addEventHandler ["Respawn", {
			[(_this # 0)] spawn {
				waitUntil {sleep 1; alive (_this select 0)};
				if (captive (_this # 0)) then {(_this # 0) setCaptive false};
			};
		}];
	}else{
		If (side player == east) then {player addEventHandler ["Killed", {Op4handle = [_this select 0] execVM "scripts\MoveOp4Base.sqf"}];};
	};

	if (!(INS_ACE_core) && !(INSpDamMul isEqualTo 100)) then {
		if (INS_p_rev in [4,5]) then {
			0 spawn {
				waitUntil {time > 4};
				hint "Player damage modifier not compatible with BTC Quick Revive. Default damage will be taken (100%)";
			};
		}else{
			pdammod = INSpDamMul*0.01;
			player addEventHandler ["HandleDamage",{_damage = (_this select 2)*pdammod;_damage}];
		};
	};

	if ((INS_ACE_core) && {INS_p_rev in [6,7]}) then {call INS_3d_Fallen};

	// DLC Vehicle Restriction Bypass
	inGameUISetEventHandler ["Action","
		private _obj = cursorTarget;
		private _appID = getObjectDLC _obj;
		if (!isNil '_appID' && {_appID in getDLCs 2}) then {
			private _act = format ['%1', (_this select 4)];
			if (_obj isKindOf 'Car') then {[_act, _obj] call CarHax};
			if (_obj isKindOf 'Plane') then {[_act, _obj] call PlaneHax};
			if (_obj isKindOf 'Helicopter') then {[_act, _obj] call HeliHax};
			if (_obj isKindOf 'Tank') then {[_act, _obj] call TankHax};
			if (_obj isKindOf 'Ship') then {[_act, _obj] call ShipHax};
		};
	"];

	// Broken door on buildings fix for Terrains like Kunduz until terrain updated. inGameUISetEventHandler is not stackable and will over ride DLC Vehicle Restriction Bypass if enabled
	/*
	inGameUISetEventHandler ["action","
		if (_this # 4 == 'Close Door') then {
			_intersects = [cursorTarget, 'VIEW'] intersect [ASLToATL eyepos player, (screentoworld [0.5,0.5])];
			{_intersects pushBack _x} forEach  ([cursorTarget, 'GEOM'] intersect [ASLToATL eyepos player, (screentoworld [0.5,0.5])]);
			_select_door = format ['%1_rot', (_intersects select 0) select 0];
			cursorObject animate [_select_door, 0];true
		};
		if (_this # 4 == 'Open Door') then {
			_intersects = [cursorTarget, 'VIEW'] intersect [ASLToATL eyepos player, (screentoworld [0.5,0.5])];
			{_intersects pushBack _x} forEach  ([cursorTarget, 'GEOM'] intersect [ASLToATL eyepos player, (screentoworld [0.5,0.5])]);
			_select_door = format ['%1_rot', (_intersects select 0) select 0];
			cursorObject animate [_select_door, 1];true
		};
	"];
	*/

	// Remove Load/Save from Arsenal if Whitelisted Aresenal Enabled.
	If ((side player == west && {INS_VA_type in [1,2]}) || (side player == east && {INS_VA_type in [2,3]})) then {
		[missionNamespace, "arsenalOpened", {
			disableSerialization;
			params ["_display"];
			_display displayAddEventHandler ["KeyDown", "_this # 3"];
			{(_display displayCtrl _x) ctrlEnable false; (_display displayCtrl _x) ctrlShow false} forEach [44151, 44150, 44146, 44147, 44148, 44149, 44346];
		}] call BIS_fnc_addScriptedEventHandler;
	};

	// Remove black listed weapons from player when Arsenal Closed
	[missionNamespace, "arsenalClosed", {call BMRINS_fnc_arsenalWeaponRemoval}] call BIS_fnc_addScriptedEventHandler;

	// Delete useless sleeping bags and respawn tents on deployment.
	player addEventHandler ["WeaponAssembled", {
		params ["_unit", "_staticWeapon"];
		if ((typeof _staticWeapon) in ["Land_Sleeping_bag_F","Land_Sleeping_bag_blue_F","Land_Sleeping_bag_brown_F","Respawn_Sleeping_bag_F","Respawn_Sleeping_bag_brown_F","Respawn_Sleeping_bag_blue_F","B_Patrol_Respawn_tent_F","Respawn_TentDome_F","Respawn_TentA_F"]) then {
			deleteVehicle _staticWeapon;
			hint "This item is useless";
		};
	}];

	// Restrict Aircraft Pilot Seat to Pilots Only / exclude Op4 players
	if (!(side player isEqualTo east) && {!(INS_PlayerPilot isEqualTo [])} && {!((typeOf player) in INS_PlayerPilot)}) then {
		player addEventHandler ["GetInMan", {
			params ["_player","","_veh"];
			if ((_veh isKindOf "Plane") || {((_veh isKindOf "Helicopter") && !(_veh isKindOf "ParachuteBase"))}) then {
				if (_player isEqualTo driver _veh) then {
					if (isEngineOn _veh) then {_veh engineOn false};
					_player action ["getOut", _veh];
					hintSilent localize "STR_BMR_restrict_pilot";
				};
				if (!isNull (objectParent player turretUnit [0]) && {objectParent player turretUnit [0] isEqualTo player}) then {
					vehicle player addEventHandler ["Engine", {
						params ["_veh","_engineState"];
						if (_engineState && {isCopilotEnabled _veh}) then {
							_veh engineOn false;
							player action ["getOut", _veh];
							hintSilent localize "STR_BMR_restrict_pilot";
						};
						_veh removeEventHandler ["Engine", _thisEventHandler];
					}];
				};
			};
		}];
	};

	//UAV controll view distance
	addMissionEventHandler ["PlayerViewChanged", {
		params ["_oldUnit","_newUnit","_vehicle","_oldCamera","_newCamera","_uav"];
		if (isNull _uav) exitWith {
			call TAWVD_fnc_updateViewDistance;
		};
		if (!isNull getConnectedUAV player) then {
			private _dist = tawvd_car;
			if (typeof (getConnectedUAV player) isKindof "Air") then {
				_dist = tawvd_air;
			};
			setViewDistance _dist;
			if(tawvd_syncObject) then {
				setObjectViewDistance [_dist,100];
				tawvd_object = _dist;
			};
		};
	}];

	// Routines //

	// Intro and side settings
	if (DebugEnabled isEqualTo 0) then {
		If (side player == east) then {
			if (INS_play_op4 isEqualTo 99) exitWith {};
			{_x setMarkerAlphaLocal 1;} forEach Op4_mkrs;
			{_x setMarkerAlphaLocal 0;} forEach Blu4_mkrs;
			deleteMarkerLocal "bluforFarp";
			player setUnitTrait ['Engineer',true];
			player setUnitTrait ['Medic',true];
			0 spawn INS_intro_op4;
			0 spawn {sleep 10; [player] call Op4_spawn_pos};
			0 spawn {
				waitUntil {time > 1};
				loadout_handler = [player] execVM "scripts\DefLoadoutOp4.sqf";
				waitUntil { scriptDone loadout_handler };
				loadout = getUnitLoadout player;
				if (JIG_MHQ_enabled) then {
					private ["_mhqObj","_mhqPos"];
					missionNamespace setVariable ["INS_usesOP4mhq", true];
					_mhqObj = objNull;
					_mhqObj = ["Opfor_MHQ"] call mhq_obj_fnc;
					_mhqPos = getPos Opfor_MHQ; _nul = [_mhqObj,_mhqPos] spawn INS_MHQ_mkr;
					INS_Op4_flag addAction["<t size='1.5' shadow='2' color='#ED2744'>Transfer to Opfor_MHQ</t>", "call JIG_transfer_fnc", ["Opfor_MHQ"], 1];
				};
				if (!isNil "MHQ_1") then {removeAllActions MHQ_1};
				if (!isNil "MHQ_2") then {removeAllActions MHQ_2};
				if (!isNil "MHQ_3") then {removeAllActions MHQ_3};
				player addEventHandler ["GetInMan",{if ((_this # 2) isKindOf "Plane") then {_this # 0 action ["getOut", (_this # 2)]}}];
			};
		};
		If (side player == west) then {
			{_x setMarkerAlphaLocal 1;} forEach Blu4_mkrs;
			{_x setMarkerAlphaLocal 0;} forEach Op4_mkrs;
			0 spawn INS_intro;
			0 spawn {
				sleep 15;
				loadout = getUnitLoadout player;
				if (JIG_MHQ_enabled) then {
					private ["_op4","_mhqPos","_mhqObj1","_mhqObj2","_mhqObj3"];
					missionNamespace setVariable ["INS_usesOP4mhq", false];
					_mhqObj1 = objNull;
					_mhqObj2 = objNull;
					_mhqObj3 = objNull;
					_mhqObj1 = ["MHQ_1"] call mhq_obj_fnc;
					_mhqPos = getPos MHQ_1; _nul = [_mhqObj1,_mhqPos] spawn INS_MHQ_mkr;
					_mhqObj2 = ["MHQ_2"] call mhq_obj_fnc;
					_mhqPos = getPos MHQ_2; _nul = [_mhqObj2,_mhqPos] spawn INS_MHQ_mkr;
					_mhqObj3 = ["MHQ_3"] call mhq_obj_fnc;
					_mhqPos = getPos MHQ_3; _nul = [_mhqObj3,_mhqPos] spawn INS_MHQ_mkr;
					INS_flag addAction["<t size='1.5' shadow='2' color='#ED2744'>Transfer to MHQ_1</t>", "call JIG_transfer_fnc", ["MHQ_1"], 4.2];
					INS_flag addAction["<t size='1.5' shadow='2' color='#ED2744'>Transfer to MHQ_2</t>", "call JIG_transfer_fnc", ["MHQ_2"], 4.1];
					INS_flag addAction["<t size='1.5' shadow='2' color='#ED2744'>Transfer to MHQ_3</t>", "call JIG_transfer_fnc", ["MHQ_3"], 4];
				};
				execVM "BTK\Cargo Drop\InitBTK.sqf";
			};
		};
	}
	else
	{
		If (side player == east) then {
			if (INS_play_op4 isEqualTo 99) exitWith {};
			player setUnitTrait ['Engineer',true];
			player setUnitTrait ['Medic',true];
			0 spawn {[player] call Op4_spawn_pos};
			0 spawn {
				loadout_handler = [player] execVM "scripts\DefLoadoutOp4.sqf";
				waitUntil { scriptDone loadout_handler };
				loadout = getUnitLoadout player;
				if (JIG_MHQ_enabled) then {
					private ["_op4","_mhqObj","_mhqPos"];
					missionNamespace setVariable ["INS_usesOP4mhq", true];
					_mhqObj = objNull;
					_mhqObj = ["Opfor_MHQ"] call mhq_obj_fnc;
					_mhqPos = getPos Opfor_MHQ; _nul = [_mhqObj,_mhqPos] spawn INS_MHQ_mkr;
					INS_Op4_flag addAction["<t size='1.5' shadow='2' color='#ED2744'>Transfer to Opfor_MHQ</t>", "call JIG_transfer_fnc", ["Opfor_MHQ"], 1];
				};
			};
		};
		If (side player == west) then {
			0 spawn {loadout = getUnitLoadout player};
			if (JIG_MHQ_enabled) then {
				private ["_op4","_mhqPos","_mhqObj1","_mhqObj2","_mhqObj3"];
				missionNamespace setVariable ["INS_usesOP4mhq", false];
				_mhqObj1 = objNull;
				_mhqObj2 = objNull;
				_mhqObj3 = objNull;
				_mhqObj1 = ["MHQ_1"] call mhq_obj_fnc;
				_mhqPos = getPos MHQ_1; _nul = [_mhqObj1,_mhqPos] spawn INS_MHQ_mkr;
				_mhqObj2 = ["MHQ_2"] call mhq_obj_fnc;
				_mhqPos = getPos MHQ_2; _nul = [_mhqObj2,_mhqPos] spawn INS_MHQ_mkr;
				_mhqObj3 = ["MHQ_3"] call mhq_obj_fnc;
				_mhqPos = getPos MHQ_3; _nul = [_mhqObj3,_mhqPos] spawn INS_MHQ_mkr;
				INS_flag addAction["<t size='1.5' shadow='2' color='#ED2744'>Transfer to MHQ_1</t>", "call JIG_transfer_fnc", ["MHQ_1"], 4.2];
				INS_flag addAction["<t size='1.5' shadow='2' color='#ED2744'>Transfer to MHQ_2</t>", "call JIG_transfer_fnc", ["MHQ_2"], 4.1];
				INS_flag addAction["<t size='1.5' shadow='2' color='#ED2744'>Transfer to MHQ_3</t>", "call JIG_transfer_fnc", ["MHQ_3"], 4];
			};
			execVM "BTK\Cargo Drop\InitBTK.sqf";
		};
	};

	0 spawn {
		private _delay = round (3600 / timeMultiplier);
		while {true} do {
			if (daytime > 21.00 || daytime < 3.50) then {
				// Brighter Nights
				if (Brighter_Nights isEqualTo 1) then {
					[3] call INS_Brighter_Nights;
				}else{
					[1] call INS_Brighter_Nights;
				};
				// Experimental-Improve AI detection of player at night for better AI responsiveness.
				player setUnitTrait ["camouflageCoef", 50];// resets to default after changing uniform or respawning...booo.
				player setUnitTrait ["audibleCoef", 50];
			}else{
				player setUnitTrait ["camouflageCoef", 1.8];
				player setUnitTrait ["audibleCoef", 1.8];
			};
			uiSleep _delay;
		};
	};

	// Ambient Radio Chatter in/near Vehicles (TPW code)
	if (ambRadioChatter isEqualTo 1) then {
		0 spawn {
			while {true} do	{
					if (!(isNull objectParent player) && {!(objectParent player isKindOf "ParachuteBase")} && {!(objectParent player isKindOf "StaticWeapon")}) then {
						playMusic format ["RadioAmbient%1",floor (random 31)];
					} else {
						private _veh = ((position player) nearEntities [["Air","Landvehicle"], 10]) select 0;
						if !(isNil "_veh") then	{
							private _sound = format ["A3\Sounds_F\sfx\radio\ambient_radio%1.wss",floor (random 31)];
							playsound3d [_sound,_veh,true,getPosasl _veh,1,1,50];
						};
					};
				sleep (1 + random 59);
			};
		};
	};

	// Vehicle Reward incentive initialized if Mechanized Armor threat enabled.
	if (MecArmPb > 1) then {
		0 spawn {
			waitUntil{!isNull player};
			private _uid = (getPlayerUID player);
			private _text = (localize "STR_BMR_veh_awarded");
			rewardp = "";
			"rewardp" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
			while {true} do	{
				if (rewardp isEqualTo "") then {
					sleep 10;
				}
				else
				{
					if ((local player) and (rewardp == _uid)) then {
						//[activated_cache_pos,45,1,0.01] spawn JIG_circling_cam;// optional cache cam
						player setVariable ["createEnabled", true];
						VehRewardID = player addAction[("<t size='1.5' shadow='2' color='#12F905'>") + (localize "STR_BMR_veh_reward") + "</t>",{call JIG_map_click}, [], 10, false, true];// Use it or loose it when player dies.
						[_text] spawn JIG_MPsideChatWest_fnc;
						rewardp = "";
						publicVariable "rewardp";
					};
				};
			};
		};
	};

	// Ambient Combat Sound
	if (ambCombSound isEqualTo 1) then {INSambs=[objective_pos_logic,24,36] execVM "scripts\fn_Battle.sqf"};

	// INS MHQ respawn actions and markers
	if (JIG_MHQ_enabled) then {
		0 spawn {
			waitUntil{!isNull player};

			private _op4 = if (side player == east) then {TRUE}else{FALSE};
			missionNamespace setVariable ["INS_usesOP4mhq", _op4];

			if (!isServer) then {
				"INS_MHQ_killed" addPublicVariableEventHandler {
					call compile format ["%1",_this select 1];
					call INS_MHQ_client;
				};
			} else {
				"INS_MHQ_killed" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
				while {true} do	{
					if (INS_MHQ_killed isEqualTo "") then {
						sleep 5;
					} else {
						sleep 5;
						private ["_mhqPos","_mhqAcc","_mhqObj"];
						_mhqAcc = [INS_MHQ_killed] call mhq_actions2_fnc;
						_mhqObj = objNull;
						_mhqObj = [INS_MHQ_killed] call mhq_obj_fnc;
						_mhqPos = getPosASL _mhqObj;
						_nul = [_mhqObj,_mhqPos] spawn INS_MHQ_mkr;
						INS_MHQ_killed = "";
					};
				};
			};
		};
	};

	// Admin Briefing Menu only for logged in admins not voted admins
	0 spawn {
		private _l = true;
		while {_l} do {
			if (serverCommandAvailable "#lock") then {
				#include "scripts\AdminMenu.sqf"
				hintSilent "Admin Menu Available";
				_l = false;
			};
			sleep 60;
		};
	};
};
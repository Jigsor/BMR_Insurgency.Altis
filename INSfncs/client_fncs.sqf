INS_intro_playTrack = {
	//Plays a random intro track:
	private ["_track"]; 
	
	// 0 => title, 1 => start delay
	_track = [
		["LeadTrack05_F", 1],
		["AmbientTrack01a_F", 32],
		["LeadTrack01_F_Bootcamp", 36],
		["Track06_CarnHeli", 1]
	] call BIS_fnc_selectRandom;
	0 fadeMusic 1;
	playMusic _track;
	uisleep 40;
	3 fadeMusic 0;
	uisleep 3;
	playMusic "";
};

INS_intro = {
	// Bluefor Intro by Jigsor
	private ["_dir","_rx","_ry","_text","_cam"];
	disableSerialization;
	showCinemaBorder false;
	enableRadio false;
	setViewDistance 1100;
	if (daytime > 19.00 || daytime < 5.00) then {camUseNVG true};
	_dir = (direction player) -180;
	_rx = selectRandom [38,-38];
	_ry = selectRandom [38,-38];
	_text = [  [format["%1", name player],"color='#F73105'"], ["", "<br/>"], ["Welcome to", "color='#F73105'"], ["", "<br/>"],  [format["BMR Insurgency %1", toUpper (worldName)], "color='#0059B0' font='PuristaBold'"] ];
	0 = 0 spawn INS_intro_playTrack;
	_cam = "camera" camCreate [position camstart select 0, position camstart select 1, (position camstart select 2) + 80];
	_cam camPreload 5;
	_cam camSetTarget player;
	waitUntil {preloadCamera [position camstart select 0, position camstart select 1, (position camstart select 2) + 80];};
	_cam cameraEffect ["internal", "BACK"];
	["BIS_ScreenSetup",true] call BIS_fnc_blackIn;
	_camPos = [(getPos player select 0) + _rx, (getPos player select 1) + _ry, (getTerrainHeightASL (position player)) + 20];
	_cam camSetPos [(_camPos select 0) + (100 * sin _dir), (_camPos select 1) + (100 * cos _dir), _camPos select 2];
	_cam camCommit 25;
	sleep 10;
	("BMR_Layer" call BIS_fnc_rscLayer) cutRsc ["bmr_intro", "PLAIN"];
	[_text, safezoneX - 0.01, safeZoneY + (1 - 0.125) * safeZoneH, true, "<t align='right' size='1.0' font='PuristaLight'>%1</t>"] spawn BIS_fnc_typeText2;
	sleep 7;
	waitUntil {camcommitted _cam};
	//[] spawn {[jig_anode,nil,true] call BIS_fnc_moduleLightning;};
	_cam camSetPos [position player select 0, position player select 1, 2.2];
	_cam camCommit 3;
	playSound "introfx";
	player sideChat localize "STR_BMR_initialize_done";
	player sideChat localize "STR_BMR_intro_tip1";
	player sideChat localize "STR_BMR_intro_tip2";
	waitUntil {camcommitted _cam};
	player cameraEffect ["terminate","back"];
	setViewDistance -1;
	camDestroy _cam;
	enableRadio true;
	if (INS_environment isEqualTo 0) then {enableEnvironment false;};
	if (INS_mod_missing) then {[] spawn INS_missing_mods;};
	//if (true) exitWith {INS_intro_op4 = nil; INS_intro = nil};
};
INS_intro_op4 = {
	// Opfor Intro by Jigsor
	disableSerialization;
	showCinemaBorder false;
	enableRadio false;
	setViewDistance 1800;
	if (daytime > 19.00 || daytime < 5.00) then {camUseNVG true};
	_text = [  [format["%1", name player],"color='#F73105'"], ["", "<br/>"], ["Welcome to", "color='#F73105'"], ["", "<br/>"],  [format["BMR Insurgency %1", toUpper (worldName)], "color='#0059B0' font='PuristaBold'"] ];
	0 = 0 spawn INS_intro_playTrack;
	_centPos = getPosATL center;
	_offsetPos = [_centPos select 0, _centPos select 1, (_centPos select 2) + 300];
	_cam = "camera" camCreate [(position center select 0) + 240, (position center select 1) + 100, 450];
	_cam camPreload 5;
	_cam camSetTarget _offsetPos;
	waitUntil {preloadCamera [(position center select 0) + 240, (position center select 1) + 100, 450];};
	_cam cameraEffect ["internal", "BACK"];
	["BIS_ScreenSetup",true] call BIS_fnc_blackIn;
	_cam camSetPos [(position center select 0) - 240, (position center select 1) + 100, 450];
	_cam camCommit 15;
	sleep 5;
	("BMR_Layer" call BIS_fnc_rscLayer) cutRsc ["bmr_intro", "PLAIN"];
	[_text, safezoneX - 0.01, safeZoneY + (1 - 0.125) * safeZoneH, true, "<t align='right' size='1.0' font='PuristaLight'>%1</t>"] spawn BIS_fnc_typeText2;
	UIsleep 3;
	waitUntil {camcommitted _cam};
	player cameraEffect ["terminate","back"];
	UIsleep 0.5;
	[] spawn {
	player sideChat localize "STR_BMR_initialize_done";
	player sideChat localize "STR_BMR_intro_tip1";
	player sideChat localize "STR_BMR_intro_tip2";};
	setViewDistance -1;
	camDestroy _cam;
	enableRadio true;
	if (INS_environment isEqualTo 0) then {enableEnvironment false;};
	if (INS_mod_missing) then {[] spawn INS_missing_mods;};
	//if (true) exitWith {INS_intro = nil; INS_intro_op4 = nil; true};
};
JIG_placeSandbag_fnc = {
	// Player action place sandbag barrier. by Jigsor
	private ["_player","_dist","_zfactor","_zvector","_isWater","_height"];
	_player = _this select 1;

	if(vehicle _player != player) exitWith {hintSilent localize "STR_BMR_Sandbag_restrict"};
	_isWater = surfaceIsWater position _player;
	if (_isWater) exitWith {hintSilent localize "STR_BMR_Sandbag_restrict"};

	_lift = 0.2;
	_dist = 2;
	_zfactor = 1;
	_zvector = ((_player weaponDirection (primaryWeapon _player)) select 2) * 3;

	if (not (isNull MedicSandBag)) then {deleteVehicle MedicSandBag;};
	MedicSandBag = createVehicle ["Land_BagFence_Round_F",[(getposATL _player select 0) + (sin(getdir _player) * _dist), (getposATL _player select 1) + (cos(getdir _player) * _dist)], [], 0, "CAN_COLLIDE"];

	MedicSandBag setposATL [(getposATL _player select 0) + (sin(getdir _player) * _dist), (getposATL _player select 1) + (cos(getdir _player) * _dist), (getposATL _player select 2) + _zvector + _zfactor];
	MedicSandBag setDir getDir (_this select 1) - 180;

	if ((getPosATL MedicSandBag select 2) > (getPosATL _player select 2)) then {
		MedicSandBag setPos [(getPosATL MedicSandBag select 0), (getPosATL MedicSandBag select 1), (getPosATL _player select 2)];
		MedicSandBag setVectorUp [0,0,1];
	}else{
		while {((position MedicSandBag select 2) + 0.2) < (getPosATL _player select 2)} do {
			MedicSandBag setPos [(getPosATL MedicSandBag select 0), (getPosATL MedicSandBag select 1), ((getPosATL MedicSandBag select 2) + _lift)];
			MedicSandBag setVectorUp [0,0,1];
			_lift = _lift + 0.1;
		};
	};

	(_this select 1) removeAction (_this select 2);
	_id = MedicSandBag addAction [(localize "STR_BMT_remove_sandbag"), {call JIG_removeSandbag_fnc}];
};
JIG_removeSandbag_fnc = {
	// Player action remove sandbag barrier. by Jigsor
	deleteVehicle (_this select 0);
	_id = (_this select 1) addAction [(localize "STR_BMR_place_sandbag"), {call JIG_placeSandbag_fnc}, 0, -9, false];
};
JIG_UGVdrop_fnc = {
	// Player action UGV para drop. by Jigsor
	private _player = _this select 1;
	/*// Require UAV backpack
	if (!(backpack _player isKindof "B_UAV_01_backpack_F")) exitWith {hint "You cannot call UGV without UAV backpack"; (_this select 1) removeAction (_this select 2); _id = _player addAction ["UGV Air Drop", {call JIG_UGVdrop_fnc}, 0, -9, false];};
	if (backpack _player isKindof "B_UAV_01_backpack_F") then {hint "";};
	*/
	if !({_x find "_UavTerminal" != -1} count assignedItems _player > 0) then {
		if ({_x in ["ItemGPS"]} count assignedItems _player > 0) then {_player unlinkItem "ItemGPS";};
		if ({_x in ["O_UavTerminal"]} count assignedItems _player > 0) then {_player unlinkItem "O_UavTerminal";};
		if ({_x in ["I_UavTerminal"]} count assignedItems _player > 0) then {_player unlinkItem "I_UavTerminal";};
		_player linkItem "B_UAVTerminal";
	}else{
		_player unlinkItem "B_UAVTerminal";
		_player linkItem "B_UAVTerminal";
	};
	ghst_ugvsupport = [(getMarkerPos "ugv_spawn"),"B_UGV_01_rcws_F",3,30] execVM "scripts\ghst_ugvsupport.sqf";
	true
};
X_fnc_returnConfigEntry = {
	/*	File: returnConfigEntry.sqf
		Author: Joris-Jan van 't Land
		Description:
		Explores parent classes in the run-time config for the value of a config entry.
		Parameter(s):
		_this select 0: starting config class (Config)
		_this select 1: queried entry name (String)
		Returns:
		Number / String - value of the found entry
	*/
	if ((count _this) < 2) exitWith {nil};
	params ["_config","_entryName"];
	if ((typeName _config) != (typeName configFile)) exitWith {nil};
	if ((typeName _entryName) != (typeName "")) exitWith {nil};
	private ["_entry", "_value"];
	_entry = _config >> _entryName;
	if (((configName (_config >> _entryName)) isEqualTo "") && (!((configName _config) in ["CfgVehicles", "CfgWeapons", ""]))) then {
		[inheritsFrom _config, _entryName] call X_fnc_returnConfigEntry;
	}else{
		if (isNumber _entry) then {
			_value = getNumber _entry;
		}else{
			if (isText _entry) then {_value = getText _entry};
		};
	};
	if (isNil "_value") exitWith {nil};
	_value
};
X_fnc_returnVehicleTurrets = {
	/*	File: fn_returnVehicleTurrets.sqf
		Author: Joris-Jan van 't Land
		Description:
		Function return the path to all turrets and sub-turrets in a vehicle.
		Parameter(s):
		_this select 0: vehicle config entry (Config)
		Returns:
		Array of Scalars and Arrays - path to all turrets
	*/
	if ((count _this) < 1) exitWith {[]};
	params ["_entry"];
	if ((typeName _entry) != (typeName configFile)) exitWith {[]};
	private ["_turrets", "_turretIndex"];
	_turrets = [];
	_turretIndex = 0;
	for "_i" from 0 to ((count _entry) - 1) do {
		private _subEntry = _entry select _i;
		if (isClass _subEntry) then {
			private _hasGunner = [_subEntry, "hasGunner"] call X_fnc_returnConfigEntry;
			if (!(isNil "_hasGunner")) then {
				if (_hasGunner isEqualTo 1) then {
					_turrets pushBack _turretIndex;
					if (isClass (_subEntry >> "Turrets")) then {
						_turrets set [count _turrets, [_subEntry >> "Turrets"] call X_fnc_returnVehicleTurrets];
					}else{
						_turrets set [count _turrets, []];
					};
				};
			};
			_turretIndex = _turretIndex + 1;
		};
	};
	_turrets
};
INS_maintenance_veh = {
	// code by Xeno
	private ["_config","_count","_i","_mags","_obj","_type","_type_name"];

	_obj = (nearestObjects [position player, ["LandVehicle","Air"], 10]) select 0;
	if (!alive _obj) exitWith {hint localize "STR_BMR_Vehicle_destroyed";};
	_type = typeOf _obj;
	hint format ["%1 under maintenance",typeOf _obj];
	_reload_time = 2;

	_obj action ["engineOff", _obj];
	if (!alive _obj) exitWith {};
	_obj setFuel 0;
	_obj setVehicleAmmo 1;

	_mags = getArray(configFile >> "CfgVehicles" >> _type >> "magazines");

	if (count _mags > 0) then {
		_removed = [];
		{
			if (!(_x in _removed)) then {
				_obj removeMagazines _x;
				_removed pushBack _x;
			};
		} forEach _mags;
		{
			sleep _reload_time;
			if (!alive _obj) exitWith {};
			_obj addMagazine _x;
		} forEach _mags;
	};

	_turrets = [configFile >> "CfgVehicles" >> _type >> "Turrets"] call X_fnc_returnVehicleTurrets;

	_reloadTurrets = {
		params ["_turrets","_path"];
		private _i = 0;
		while {_i < (count _turrets)} do {
			private ["_turretIndex", "_thisTurret"];
			_turretIndex = _turrets select _i;
			_thisTurret = _path + [_turretIndex];

			_mags = _obj magazinesTurret _thisTurret;
			if (!alive _obj) exitWith {};
			_removed = [];
			{
				if (!(_x in _removed)) then {
					_obj removeMagazinesTurret [_x, _thisTurret];
					_removed pushBack _x;
				};
			} forEach _mags;
			if (!alive _obj) exitWith {};
			{
				sleep _reload_time;
				if (!alive _obj) exitWith {};
				_obj addMagazineTurret [_x, _thisTurret];
				sleep _reload_time;
				if (!alive _obj) exitWith {};
			} forEach _mags;

			if (!alive _obj) exitWith {};

			[_turrets select (_i + 1), _thisTurret] call _reloadTurrets;
			_i = _i + 2;
			if (!alive _obj) exitWith {};
		};
	};

	if (count _turrets > 0) then {
		[_turrets, []] call _reloadTurrets;
	};

	if (!alive _obj) exitWith {};

	_obj setVehicleAmmo 1;

	sleep _reload_time;
	if (!alive _obj) exitWith {};
	_obj setDamage 0;
	sleep _reload_time;
	if (!alive _obj) exitWith {};
	while {fuel _obj < 0.99} do {
		_obj setFuel 1;
		sleep 0.01;
	};
	sleep _reload_time;
	if (!alive _obj) exitWith {};

	reload _obj;
	if (typeOf _obj in INS_add_Chaff) then {_obj addWeapon "CMFlareLauncher"; _obj addMagazine "120Rnd_CMFlare_Chaff_Magazine";};
	hintSilent localize "STR_BMR_Maint_done";
};
BTC_repair_wreck = {
	_object = (nearestObjects [position player, ["LandVehicle","Air"], 10]) select 0;
	if (damage _object != 1) exitWith {hintSilent localize "STR_BMR_useMaint_action"};
	BTC_to_server = [0,_object];publicVariableServer "BTC_to_server";
};
INS_Flip_Veh = {
	// Flip vehicle by Jigsor.
	_target = _this select 0;
	_caller = _this select 1;
	if (vehicle _caller != player) exitWith {hintSilent localize "STR_BMR_flip_restrict";};
	_veh = (nearestObjects [_target, ["LandVehicle"], 15]) select 0;
	if (!isNil "_veh") then {
		if ((damage _veh < 1) && {(count crew _veh isEqualTo 0)}) then {
			_veh setOwner (owner _caller);
			_veh setPos [getPos _veh select 0, getPos _veh select 1, 0];
		};
	};
	true
};
JIG_load_VA_profile = {
	// Force load of saved Virtual Aresenal preset regardless if mod used to make loadout is currently not activated minus missing content by Jigsor.
	if (!isNil {profileNamespace getVariable "bis_fnc_saveInventory_data"}) then {
		private ["_name_index","_VA_Loadouts_Count"];
		_VA_Loadouts_Count = count (profileNamespace getVariable "bis_fnc_saveInventory_data");
		_name_index = 0;
		for "_i" from 0 to (_VA_Loadouts_Count/2) -1 do	{
			[_i,_name_index] spawn {
				private ["_name_index","_loadout_name"];
				_name_index = _this select 1;
				_loadout_name = profileNamespace getVariable "bis_fnc_saveInventory_data" select _name_index;
				_id = INS_Wep_box addAction	[("<t size='1.5' shadow='2' color=""#00ffe9"">") + ("Load " + format ["%1",_loadout_name]) + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[player,[profileNamespace, format ["%1", _loadout_name]]],BIS_fnc_loadInventory],8,true,true,"","true"];
				sleep 15;
				INS_Wep_box removeAction _id;
			};
			_name_index = _name_index + 2;
		};
	};
};
JIG_p_actions_resp = {
	// Add player actions. by Jigsor
	waitUntil {sleep 1; alive player};
	private _playertype = typeOf (vehicle player);
	// Engineer
	if (_playertype in INS_W_PlayerEng) then {player addAction[("<t color=""#12F905"">") + (localize "STR_BMR_cunstruct_farp") + "</t>","scripts\repair_special.sqf",0,1, false, true,"test2"];};
	// JTAC
	if (_playertype in INS_W_PlayerJTAC) then {null = [player, 500, true, 3] execVM "JWC_CASFS\addAction.sqf";};
	// Medic
	if (_playertype in INS_W_PlayerMedic) then	{MedicSandBag = ObjNull; _id = player addAction[(localize "STR_BMR_place_sandbag"),{call JIG_placeSandbag_fnc}, 0, -9, false];};
	// UAV Operator
	if (_playertype in INS_W_PlayerUAVop) then {
		myhuntiraction = player addAction["use HuntIR","scripts\myhuntir.sqf", [], 1, false, true, "", "true"]; lck_markercnt=0;
		_id = player addAction[(localize "STR_BMR_ugv_air_drop"),{call JIG_UGVdrop_fnc}, 0, -9, false];
	};
	// Sniper/Marksman/Spotter
	if (_playertype in INS_W_PlayerSniper) then	{
		player RemoveAllEventHandlers "Fired";
		_id = player addAction [(localize "STR_BMR_bullet_cam_on"),{call INS_bullet_cam}, 0, -9, false];
	};
	// All players mission settings
	if (Fatigue_ability < 1) then {[player] call INS_full_stamina;};
	true
};
PVPscene_POV = {
	// Limit 3rd person view to vehicles only
	[(_this select 0)] spawn {
		while {alive (_this select 0)} do {
			if (cameraView isEqualTo "EXTERNAL" || cameraView isEqualTo "GROUP") then {
				if (isNull objectParent player) then {
					player switchCamera "INTERNAL";
				};
			};
			uiSleep 0.1;
		};
	};
};
JIG_transfer_fnc = {
	// teleport by Jigsor
	_dest = (_this select 3) select 0;
	_dir = random 359;

	titleText ["", "BLACK OUT"];
	switch (typeName _dest) do {
		case "ARRAY" : {player setPos [(position _dest select 0)-10*sin(_dir),(position _dest select 1)-10*cos(_dir)];};
		case "OBJECT" : {player setPos [(getPosATL _dest select 0)-10*sin(_dir),(getPosATL _dest select 1)-10*cos(_dir)];};
		case "STRING" : {player setPos [(getMarkerPos _dest select 0)-10*sin(_dir),(getMarkerPos _dest select 1)-10*cos(_dir)];};
	};
	titleText ["", "BLACK IN",2];
	true
};
killedInfo_fnc = {
	// Generates killed by whom, weapon used and distance from killer message. by Jigsor
	params ["_poorSoul","_killer"];

	//remove blur
	//BIS_fnc_radialRed = false;
	//BIS_fnc_radialRedOut = false;
	//BIS_fnc_damagePulsing = false;
	BIS_DeathBlur ppEffectAdjust [0.0];
	BIS_DeathBlur ppEffectCommit 0.0;

	if (!isNull _killer) then {
		_killerName = name _killer;
		_killerWeapon = currentWeapon _killer;
		_distance = _poorSoul distance _killer;
		_killerWeaponName = getText (configFile >> "CfgWeapons" >> _killerWeapon >> "displayName");
		if (_killerWeaponName == "Throw") then {_killerWeaponName = "Grenade"};
		if (_killerWeaponName == "Put") then {_killerWeaponName = "Explosive"};
		if (_killerName == "Error: No unit") then {_killerName = "Unidentified"};
		uiSleep 7;
		_text = format ["Killed by %1, from %2 meters, with %3",_killerName, str(_distance), str(_killerWeaponName)];
		copyToClipboard str(_text);
		if (!isServer) then {
			("BMR_KilledInfo_Layer" call BIS_fnc_rscLayer) cutText [_text,"PLAIN"];
		}else{
			cutText [_text,"PLAIN"];
		};
	};
};
JIG_intel_found = {
	// Remove intel addaction, grab intel animation, delete intel object, creates intel maker, update JIP intel marker state, global sidechat player name found intel, add 2 points to caller by Jigsor
	params ["_host","_caller","_id","_pos_info"];
	_pName = name _caller;
	_text = format [localize "STR_BMR_found_intel",_pName];
	_maxClueDis = INS_maxClueDis;

	_host removeAction _id;

	_caller playaction "putdown";
	for "_i" from 0 to 1 do {
		_state = animationState _caller;
		waitUntil {_state != animationState _caller};
	};

	deleteVehicle _host;
	sleep 0.1;
	[[_text],"JIG_MPsideChatWest_fnc"] call BIS_fnc_mp;

	_distance = [10,_maxClueDis] call BIS_fnc_randomInt; // Minimum intel marker range 10m. Maximum intel marker range defined by INS_maxClueDis in INS_definitions.sqf.
	_direction = [0,359] call BIS_fnc_randomInt; // Random direction between 0 and 359 degrees.
	_randomPos = [_pos_info, _distance, _direction] call BIS_fnc_relPos; // The position at the random distance and random direction from current_cache_pos.

	_rnum = str(round (random 999));
	_dis_str = str(_distance);
	_VarName = ("intel_mkr" + _rnum);
	_mkr_txt = (_dis_str + " meters");
	_pScore = 2;

	_intelMkr = createMarker [_VarName, _randomPos];
	_intelMkr setMarkerShape "ELLIPSE";
	_intelMkr setMarkerSize [1, 1];
	_intelMkr setMarkerShape "ICON";
	_intelMkr setMarkerType "hd_unknown";
	_intelMkr setMarkerText _mkr_txt;
	sleep 0.1;

	all_intel_mkrs pushBack _intelMkr;
	[all_intel_mkrs] call JIPmkr_updateServer_fnc;
	publicVariable "all_intel_mkrs";
	sleep 0.1;

	if (side _caller == INS_Blu_side) then {
		_caller addRating 200;
		_caller addScore _pScore;
		paddscore = [_caller, _pscore];
		publicVariableServer "paddscore";
		[West,"HQ"] sideChat "+2 points";
	};
	true
};
Op4_spawn_pos = {
	// Initial Op4 spawn position by Jigsor
	private ["_op4Player","_posnotfound","_random_w_player","_basePos","_players","_movelogic","_blu4Speed","_playerPos","_cooX","_cooY","_wheX","_wheY","_randPos","_c","_spawnPos","_centerPos","_dis","_dir"];
	_op4Player = _this select 0;
	_posnotfound = false;
	_random_w_player = nil;
	_basePos = getMarkerPos "Respawn_West";
	_players = playableUnits;
	if (INS_p_rev > 5) then {_movelogic = false;}else{_movelogic = true;};

	titleCut["", "BLACK out",2];

	_players = _players - [_op4Player];// exclude player calling the script
	if (count _players > 0) then {
		{
			_blu4Speed = speed _x;
			_pos = (getPos _x);
			if ((_blu4Speed > 8) || (_pos select 2 > 4) || {(side _x == east)}) then {_players = _players - [_x];};
		} foreach _players;// exclude east players, players in moving vehicles, above ground players such as players in aircraft or in high structures
	}else{
		_posnotfound = true;
	};

	if (count _players > 0) then {
		_random_w_player = _players select (floor (random (count _players)));
		_players = _players - ["_random_w_player"];
		while {!isNil "_random_w_player" && {_random_w_player distance _basePos < 500}} do {
			_random_w_player = _players select (floor (random (count _players)));
			_players = _players - ["_random_w_player"];
		};
	};// exclude players to close to blufor base

	if (!isNil "_random_w_player") then	{
		// Move Op4 Base within 250 to 500 meters of blufor player
		_playerPos = getPos _random_w_player;
		_cooX = _playerPos select 0;
		_cooY = _playerPos select 1;
		_wheX = [250,500] call BIS_fnc_randomInt;
		_wheY = [250,500] call BIS_fnc_randomInt;
		_randPos = [_cooX+_wheX,_cooY+_wheY,0];
		_c = 0;
		_spawnPos = _randPos isFlatEmpty [8,384,0.5,2,0,false,ObjNull];

		while {(count _spawnPos) < 1} do {
			_spawnPos = _randPos isFlatEmpty [5,384,0.9,2,0,false,ObjNull];
			_c = _c + 1;
			if (_c > 5) exitWith {_posnotfound = true;};
			sleep 0.2;
		};
		if (count _spawnPos > 0) exitWith {
			if (_movelogic) then {BTC_r_base_spawn setPos _spawnPos;};
			"Respawn_East" setMarkerPos _spawnPos;
			_op4Player setPos _spawnPos;
			titleCut["", "BLACK IN",1];
		};
	}else{
		_posnotfound = true;
	};

	if (_posnotfound) then {
		if ((INS_MHQ_enabled) && {(!isNil "Opfor_MHQ")}) then {
			// Move to Op4 MHQ
			if (_movelogic) then {BTC_r_base_spawn setPos getMarkerPos "Opfor_MHQ";};
			"Respawn_East" setMarkerPos getMarkerPos "Opfor_MHQ";
			_dir = random 359;
			_op4Player setPos [(getMarkerPos "Opfor_MHQ" select 0)-10*sin(_dir),(getMarkerPos "Opfor_MHQ" select 1)-10*cos(_dir)];
			titleCut["", "BLACK IN",1];
		}else{
			// Move Op4 Base to center
			_centerPos = getPosATL center;
			_cooX = _centerPos select 0;
			_cooY = _centerPos select 1;
			_dis = 400;
			_wheX = random (_dis*2)-_dis;
			_wheY = random (_dis*2)-_dis;
			_randPos = [_cooX+_wheX,_cooY+_wheY,0];
			_spawnPos = _randPos isFlatEmpty [10,384,0.5,2,0,false,ObjNull];

			while {(count _spawnPos) < 1} do {
				_spawnPos = _randPos isFlatEmpty [5,384,0.9,2,0,false,ObjNull];
				sleep 0.2;
			};
			if (_movelogic) then {BTC_r_base_spawn setPos _spawnPos;};
			"Respawn_East" setMarkerPos _spawnPos;
			_op4Player setPos _spawnPos;
			titleCut["", "BLACK IN",1];
		};
	};
	if (true) exitWith {Op4_spawn_pos = nil; true;};
};
INS_bullet_cam = {
	// add bullet cam
	//http://killzonekid.com/arma-scripting-tutorials-a-simple-bullet-cam/
	player addEventHandler ["Fired", {
		_null = _this spawn {
			_missile = _this select 6;
			_cam = "camera" camCreate (position player);
			_cam cameraEffect ["External", "Back"];
			waitUntil {
				if (isNull _missile) exitWith {true};
				_cam camSetTarget _missile;
				_cam camSetRelPos [0,-3,0];
				_cam camCommit 0;
			};
			sleep 0.4;
			_cam cameraEffect ["Terminate", "Back"];
			camDestroy _cam;
		};
	}];
	(_this select 1) removeAction (_this select 2);
	_id = (_this select 1) addAction[(localize "STR_BMR_bullet_cam_off"),{call JIG_removeBulletCam_fnc}, 0, -9, false];
};
JIG_removeBulletCam_fnc = {
	// remove bullet cam
	(_this select 1) removeAction (_this select 2);
	(_this select 1) RemoveAllEventHandlers "Fired";
	_id = (_this select 1) addAction[(localize "STR_BMR_bullet_cam_on"),{call INS_bullet_cam}, 0, -9, false];
};
/*
VehDrop_smoke_fnc = {
	// Pops Smoke,Flare and Chemlight at vehicle reward air drop position by Jigsor.
	params ["_dropPos","_grndPos","_veh","_smokeColor","_chemLight","_smoke","_c","_flrObj"];
	_smokeColor = "SmokeShellBlue";
	_chemLight = createVehicle ["Chemlight_green", _grndPos, [], 0, "NONE"];
	sleep 1;

	_flrObj = "F_20mm_Red" createVehicle ((_veh) ModelToWorld [0,100,200]);
	_flrObj setVelocity [1,1,-10];
	sleep 0.1;

	_c = 0;
	while {_c < 2} do {
		_smoke = createVehicle [_smokeColor, [(_dropPos select 0) + 2, (_dropPos select 1) + 2, 55], [], 0, "NONE"];
		_i = _c + 1;
		sleep 20;
	};
	deleteVehicle _chemLight;
	true
};
*/
JIG_circling_cam = {
	// Circling camera by Jigsor
	_pos = _this select 0;
	_dir = random 359;
	_maxRotation = (_dir + 45);// 360
	_camHeight = 15;
	_camDis = -30;
	_interval = 1;
	_delay = 0.01;
	_logic_pos = [_pos select 0, _pos select 1, (_pos select 2) + 3];
	_camPos = [_pos select 0, _pos select 1, (_pos select 2) + _camHeight];

	_logic = createVehicle ["Land_ClutterCutter_small_F", _logic_pos, [], 0, "CAN_COLLIDE"];
	_logic setDir _dir;

	_cam = "camera" camCreate _camPos;
	_cam camSetPos _camPos;
	_cam camSetTarget _logic;
	_cam camCommit 0;
	waitUntil {camcommitted _cam};

	_cam attachTo [_logic, [0,_camDis,_camHeight] ];
	_cam cameraEffect ["internal", "BACK"];

	while {_dir < _maxRotation} do {
		_dir = _dir + _interval;
		_logic setDir _dir;
		sleep _delay;
	};

	camDestroy _cam;
	deleteVehicle _logic;
	player cameraEffect ["terminate", "BACK"];
	true
};
JIG_map_click = {
	// Vehicle reward mapclick position by Jigsor
	if (player getVariable "createEnabled") then {
		private ["_marker","_roads","_roadsSorted","_nearestRoad","_roadDir"];
		if !(getMarkerColor "VehDrop" isEqualTo "") then {deleteMarkerLocal "VehDrop";};
		hint "";
		_roadDir = 0;
		_nearestRoad = objNull;
		GetClick = true;
		openMap true;
		waitUntil {visibleMap};
		[] spawn {[localize "STR_BMR_reward_mapclick",0,.1,3,.005,.1] call bis_fnc_dynamictext;};

		["Reward_mapclick","onMapSingleClick", {

			if (isOnRoad _pos) then {
				_roads = _pos nearRoads 15;
				if (count _roads > 0) then {
					_roadsSorted = [_roads,[],{_pos distance _x},"ASCEND"] call BIS_fnc_sortBy;
					_nearestRoad = _roadsSorted select 0;
				};
			};

			_marker=createMarkerLocal ["VehDrop", _pos ];
			"VehDrop" setMarkerShapeLocal "ICON";
			"VehDrop" setMarkerSizeLocal [1, 1];
			"VehDrop" setMarkerTypeLocal "mil_dot";
			"VehDrop" setMarkerColorLocal "Color3_FD_F";
			"VehDrop" setMarkerTextLocal "Vehicle Reward Location";
			if (!isNull _nearestRoad) then {"VehDrop" setMarkerDirLocal (direction _nearestRoad);};

			GetClick = false;
		}] call BIS_fnc_addStackedEventHandler;

		waitUntil {!GetClick or !(visiblemap)};
		["Reward_mapclick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;

		if (!visibleMap) exitWith {[] call JIG_map_click};
		mapAnimAdd [0.5, 0.1, markerPos 'VehDrop'];
		mapAnimCommit;
		sleep 1.2;
		openMap false;

		[["cars", "tanks", "helicopters", "planes", "boats"], [], "VehDrop", [0,0,0.3], 3] execVM "ASORVS\open.sqf";
	}else{
		(_this select 0) removeAction (_this select 2);
		if !(getMarkerColor "VehDrop" isEqualTo "") then {deleteMarkerLocal "VehDrop";};
	};
	true
};
INS_AI_revive = {
	// Initialize =BTC= Quick Revive for all group members including AI by Jigsor.
	if ((INS_p_rev isEqualTo 4) || (INS_p_rev isEqualTo 5)) then {
		private ["_pA","_aiA"];
		_pA = [];
		_aiA = [];
		_grp = group player;

		if (count bon_recruit_queue > 0) then { waitUntil {sleep 1; count bon_recruit_queue < 1}; };
		{if (isPlayer _x) then {_pA pushBack _x;}else{_aiA pushBack _x;};} forEach (units _grp);
		if (count _pA > 0) then {["btc_qr_fnc_unit_init", _grp] call BIS_fnc_MP;};
		{_x call btc_qr_fnc_unit_init;} forEach _aiA;
	};
};
INS_Vehicle_Reward = {
	// Issues Vehicle Reward action to player by Jigsor. Admins can create vehicle at any time. Run the following command locally from debug console.
	// player spawn INS_Vehicle_Reward;
	player setVariable ["createEnabled", true];
	_id = player addAction[("<t size='1.5' shadow='2' color='#12F905'>") + (localize "STR_BMR_veh_reward") + "</t>",{call JIG_map_click}, [], 10, false, true];
};
INS_Recruit_skill = {
	// Sets skill of a recruited unit if ASR AI mod is not running on server or client
	if ((ASRrecSkill isEqualTo 1) || {(isClass(configFile >> "cfgPatches" >> "asr_ai_main"))}) exitWith {true};
	params ["_unit"];
	_unit setSkill ["aimingAccuracy", BTC_AI_skill];
	_unit setSkill ["aimingShake", 0.6];
	_unit setSkill ["aimingSpeed", 0.5];
	_unit setSkill ["endurance", 0.6];
	_unit setSkill ["spotDistance", 0.6];
	_unit setSkill ["spotTime", 0.5];
	_unit setSkill ["courage", 0.5];
	_unit setSkill ["reloadSpeed", 1];
	_unit setSkill ["general", 0.6];
	if (_unit isEqualTo (leader group _unit)) then {_unit setSkill ["commanding", 1];}else{	_unit setSkill ["commanding", 0.6];};
	true
};
INS_Depleated_Loadout = {
	// Save current kit when player reloads magazine
	INS_SaveLoadout = [player, [missionNamespace, "BMRInsInv"]] call BIS_fnc_saveInventory;
	true
};
INS_RespawnLoadout = {
	// Save respawn kit used with "Save Respawn Loadout" action by Jigsor
	INS_SaveLoadout = [(_this select 1), [missionNamespace, "BMRInsInv"]] call BIS_fnc_saveInventory;
	_kitSaved = "A3\Sounds_F\sfx\Beep_Target.wss";
	playsound3d [_kitSaved, (_this select 0), false, getPosasl (_this select 1), 10,0.5,10];
	true
};
INS_RestoreLoadout = {
	// Restore saved kit when respawned by Jigsor.
	if (isNil "INS_SaveLoadout") then {
		[player, loadout] call setLoadout;
	}else{
		[player, [missionNamespace, "BMRInsInv"]] call BIS_fnc_loadInventory;
	};
	true
};
INS_UI_pref = {
	// Restore status hud and digital heading on respawn if they were activated before death by Jigsor.
	waitUntil {sleep 2; alive player};
	if (player getVariable "stathud_resp") then {execVM "INSui\staus_hud_toggle.sqf";};
	if (player getVariable "dhs_resp") then {execVM "scripts\heading.sqf";};
	true
};
INS_AI_Halo = {
	// AI halo based on/uses functions from ATM_airdrop.
	private ["_target","_loadout","_target","_halo_pos","_jumpAlt","_openChuteAlt","_freefall","_headgear","_back_pack","_back_pack_items","_back_pack_weap","_back_pack_maga"];
	_target = _this select 0;
	_halo_pos = _this select 1;
	_openChuteAlt = 75;//This does not work in Arma 3 as of v1.5. AI will open chute at 150m.
	_jumpAlt = 450;
	_freefall = true;
	_loadout = [];
	_headgear = headgear _target;
	_back_pack = backpack _target;
	_back_pack_items = getItemCargo (unitBackpack _target);
	_back_pack_weap = getWeaponCargo (unitBackpack _target);
	_back_pack_maga = getMagazineCargo (unitBackpack _target);
	_loadout = [_headgear, _back_pack, _back_pack_items, _back_pack_weap, _back_pack_maga];

	0=[_target] call Frontpack;

	removeBackpack _target;
	sleep 0.5;
	_target addBackpack "B_Parachute";
	_target setPos [_halo_pos select 0, _halo_pos select 1, (_halo_pos select 2) + _jumpAlt];
	_target switchMove "halofreefall_non";
	sleep 0.1;

	while {(getPos _target select 2) > 2.5} do {
		if (_freefall) then {
			if((getPos _target select 2) < _openChuteAlt) then {
				_target action ["OpenParachute", _target];
				_freefall = false;
			};
		};
		if(!alive _target) then {
			sleep (random 5) + 3;
			_target setPos [getPos _target select 0, getPos _target select 1, 0];
		};
		sleep 1;
	};

	deleteVehicle (_target getVariable "frontpack");
	_target setVariable ["frontpack",nil];

	0=[_target,_loadout] spawn ATM_Setloadout;
};
mhq_actions2_fnc = {
	// Add action for VA and quick VA profile to respawned MHQs by Jigsor.
	params ["_var","_op4"];
	switch (true) do {
		case (_var isEqualTo "MHQ_1") : {if (!_op4) then {MHQ_1 addAction[("<t size='1.5' shadow='2' color='#F56618'>") + (localize "STR_BMR_load_VAprofile") + "</t>", "call JIG_load_VA_profile_MHQ1", [(_this select 1)]]; MHQ_1 addAction[("<t color='#ff1111'>") + (localize "STR_BMR_open_VA") + "</t>",{["Open",true] call BIS_fnc_arsenal;}];};};
		case (_var isEqualTo "MHQ_2") : {if (!_op4) then {MHQ_2 addAction[("<t size='1.5' shadow='2' color='#F56618'>") + (localize "STR_BMR_load_VAprofile") + "</t>", "call JIG_load_VA_profile_MHQ2", [(_this select 1)]]; MHQ_2 addAction[("<t color='#ff1111'>") + (localize "STR_BMR_open_VA") + "</t>",{["Open",true] call BIS_fnc_arsenal;}];};};
		case (_var isEqualTo "MHQ_3") : {if (!_op4) then {MHQ_3 addAction[("<t size='1.5' shadow='2' color='#F56618'>") + (localize "STR_BMR_load_VAprofile") + "</t>", "call JIG_load_VA_profile_MHQ3", [(_this select 1)]]; MHQ_3 addAction[("<t color='#ff1111'>") + (localize "STR_BMR_open_VA") + "</t>",{["Open",true] call BIS_fnc_arsenal;}];};};
		case (_var isEqualTo "Opfor_MHQ") : {if (_op4) then {Opfor_MHQ addAction [("<t size='1.5' shadow='2' color='#12F905'>") + ("Deploy MHQ") + "</t>","scripts\deployOpforMHQ.sqf",nil,1, false, true, "", "side _this != INS_Blu_side"];};};
		default {};
	};
	true
};
INS_MHQ_mkr = {
	// Tracking MHQ marker by Jigsor.
	params ["_mhq","_op4","_mhqPos","_mkrName","_mkr"];

	if (_mhq isEqualTo objNull) exitWith {hint format ["Mobile Headquarters %1 does not exist", _mhq]};
	if (vehicleVarName _mhq != "") then {_mkrName = vehicleVarName _mhq;}else{_mkrName = format ["%1", _mhq];};

	if ((_op4 isEqualTo TRUE) && {(_mkrName isEqualTo "Opfor_MHQ")}) then {
		deleteMarkerLocal _mkrName;
		_mkr = createMarkerLocal [_mkrName, _mhqPos];
		_mkr setMarkerTypeLocal "mil_dot";
		_mkr setMarkerTextLocal _mkrName;
		_mkr setMarkerColorLocal "ColorRed";
		_mkr setMarkerSizeLocal [0.5, 0.5];

		while {alive _mhq} do {
			_mkr setMarkerPosLocal (getPosWorld _mhq);
			UIsleep 1;
		};
		if (!alive _mhq) exitWith {deleteMarkerLocal _mkrName; hintSilent format ["%1 has been destroyed!", _mkrName]};
	}else{
		deleteMarkerLocal _mkrName;
		_mkr = createMarkerLocal [_mkrName, _mhqPos];
		_mkr setMarkerTypeLocal "mil_dot";
		_mkr setMarkerTextLocal _mkrName;
		_mkr setMarkerColorLocal "ColorGreen";
		_mkr setMarkerSizeLocal [0.5, 0.5];

		while {alive _mhq} do {
			_mkr setMarkerPosLocal (getPosWorld _mhq);
			UIsleep 1;
		};
		if (!alive _mhq) exitWith {deleteMarkerLocal _mkrName; hintSilent format ["%1 has been destroyed!", _mkrName]};
	};
};
GAS_smokeNear = {
	//Are we near a smoke shell. Are we not wearing a gas mask. code by Larrow modified by Jigsor
	if ((headgear player in INS_gasMaskH) || {(goggles player in INS_gasMaskG)}) then {
		false
	}else{
		_smokeShell = player nearObjects ["GrenadeHand", 30];
		{
			if !(typeOf _x in INS_Gas_Grenades) then {_smokeShell = _smokeShell - [_x];};
		} count _smokeShell;

		if !(isNull (_smokeShell select 0)) then {
			vectorMagnitudeSqr velocity (_smokeShell select 0) <= 0.5 && { (_smokeShell select 0) distance player < 15 }
		}else{
			false
		};
	};
};
GAS_inSmoke = {
	// We are in smoke. code by Larrow
	player setVariable ["inSmoke",true];

	private ["_maxtype","_sound"];
	_maxtype = (count Choke_Sounds);

	"dynamicBlur" ppEffectEnable true;
    "dynamicBlur" ppEffectAdjust [12];
	"dynamicBlur" ppEffectCommit 5;
	enableCamShake true;
	addCamShake [10, 45, 10];
	5 fadeSound 0.1;

	//While were in smoke
	while { alive player && not captive player && [] call GAS_smokeNear } do {
		_sound = Choke_Sounds select (floor random _maxtype);
		playsound3d [_sound, player, false, getPosasl player, 10,1,30];
		player setDamage (damage player + 0.14);
		//if(round(random(1)) isEqualTo 0) then {hint "You Should Wear a Gas Mask";};
    	sleep 2.8123;
	};

	[] call GAS_smokeClear;
};
GAS_smokeClear = {
	// Clear effects. code by Larrow
	player setVariable ["inSmoke",false];

	"dynamicBlur" ppEffectEnable true;
	"dynamicBlur" ppEffectAdjust [0];
	"dynamicBlur" ppEffectCommit 10;
	resetCamShake;
	20 fadeSound 1;
};

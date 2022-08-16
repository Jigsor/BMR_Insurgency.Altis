INS_intro_playTrack = {
	//Plays a random intro track:
	// 0 => title, 1 => start delay
	playMusic "";
	private _track = selectRandom
	[
		[["LeadTrack05_F", 1], 33],
		[["AmbientTrack01a_F", 32], 33],
		[["LeadTrack01_F_Bootcamp", 36], 32.9],
		[["Track06_CarnHeli", 1], 33],
		[["BackgroundTrack01a_F", 63], 33],
		[["BackgroundTrack01a_F", 27], 33],
		[["EventTrack02_F_EPA", 1.63], 34.3],
		[["EventTrack01_F_EPA", 1.63], 34.3],
		[["LeadTrack03_F_EPA",60.85], 33.678]
	];
	0 fadeMusic 1;
	playMusic (_track # 0);
	uiSleep (_track # 1);
	playMusic "";
};
INS_intro = {
	// Bluefor Intro by Jigsor
	player enableSimulation false;
	disableSerialization;
	showCinemaBorder false;
	enableRadio false;
	setViewDistance 1100;
	_dd = missionNameSpace getVariable ["BMR_DawnDusk",[]];
	_dd params ["_dawn","_dusk"];
	if (daytime > (_dusk + 1) || daytime < (_dawn - 1)) then {camUseNVG true};
	private _dir = (direction player) -180;
	private _rx = selectRandom [38,-38];
	private _ry = selectRandom [38,-38];
	private _worldDesc = getText (configFile >> "CfgWorlds" >> worldName >> "description");
	private _text = [  [format["%1", name player],"color='#F73105'"], ["", "<br/>"], ["Welcome to", "color='#F73105'"], ["", "<br/>"], [format["BMR Insurgency %1", toUpper (_worldDesc)], "color='#0059B0' font='PuristaBold'"] ];
	private _camStartPos = getPos camstart;
	_camStartPos vectorAdd [0, 0, 80]; 
	private _pPos = getPos player;
	_pPos params ["_pPosX", "_pPosY", "_pPosZ"];
	private _camPos = [_pPosX + _rx, _pPosY + _ry, (getTerrainHeightASL _pPos) + 20];
	0 = 0 spawn INS_intro_playTrack;
	private _cam = "camera" camCreate _camStartPos;
	_cam camPreload 5;
	_cam camSetTarget player;
	waitUntil {preloadCamera _camStartPos};
	_cam cameraEffect ["Internal", "BACK"];
	["BIS_ScreenSetup",true] call BIS_fnc_blackIn;
	_cam camCommand "inertia on";
	_cam camSetPos [(_camPos # 0) + (100 * sin _dir), (_camPos # 1) + (100 * cos _dir), _camPos # 2];
	_cam camCommit 25;
	sleep 10;
	("BMR_Layer" call BIS_fnc_rscLayer) cutRsc ["bmr_intro", "PLAIN"];
	[_text, safezoneX - 0.01, safeZoneY + (1 - 0.125) * safeZoneH, true, "<t align='right' size='1.0' font='PuristaLight'>%1</t>"] spawn BIS_fnc_typeText2;
	sleep 7;
	waitUntil {camcommitted _cam};
	//[] spawn {[jig_anode,nil,true] call BIS_fnc_moduleLightning;};
	_cam camCommand "inertia off";
	_cam camSetPos [_pPosX, _pPosY, 2.2];
	_cam camCommit 3;
	playSound "introfx";
	player sideChat localize "STR_BMR_initialize_done";
	player sideChat localize "STR_BMR_intro_tip1";
	player sideChat localize "STR_BMR_intro_tip2";
	waitUntil {camcommitted _cam};
	player enableSimulation true;
	player cameraEffect ["Terminate", "BACK"];
	setViewDistance -1;
	camDestroy _cam;
	enableRadio true;
	if (INS_mod_missing) then {0 spawn INS_missing_mods} else {INS_mod_missing=nil};
	if (JIG_DustStorm) then {0 spawn JIG_Dust_Storm};
	if (JIG_SnowStorm) then {0 spawn JIG_Snow_Storm};
	if (INS_full_loadout isEqualTo 0) then {player sideChat localize "STR_BMR_Reload_toSave_Kit"};
	if (INS_p_rev in [6,7] && (!INS_ACE_med)) then {player sideChat "You Have 1 life. Bleed out or forced Respawn initiates spectator camera"};
};
INS_intro_op4 = {
	// Opfor Intro by Jigsor
	player enableSimulation false;
	disableSerialization;
	showCinemaBorder false;
	enableRadio false;
	setViewDistance 1800;
	_dd = missionNameSpace getVariable ["BMR_DawnDusk",[]];
	_dd params ["_dawn","_dusk"];
	if (daytime > (_dusk + 1) || daytime < (_dawn - 1)) then {camUseNVG true};
	_worldDesc = getText (configFile >> "CfgWorlds" >> worldName >> "description");
	_text = [  [format["%1", name player],"color='#F73105'"], ["", "<br/>"], ["Welcome to", "color='#F73105'"], ["", "<br/>"], [format["BMR Insurgency %1", toUpper (_worldDesc)], "color='#0059B0' font='PuristaBold'"] ];
	_ok = preloadTitleRsc ["bmr_intro", "PLAIN"];
	0 = 0 spawn INS_intro_playTrack;
	_centPos = getPosATL center;
	_offsetPos = [_centPos # 0, _centPos # 1, (_centPos select 2) + 300];
	_cam = "camera" camCreate [(position center select 0) + 240, (position center select 1) + 100, 450];
	_cam camPreload 5;
	_cam camSetTarget _offsetPos;
	waitUntil {UIsleep 0.1; preloadCamera [(position center select 0) + 240, (position center select 1) + 100, 450]};
	_cam cameraEffect ["Internal", "BACK"];
	["BIS_ScreenSetup",true] call BIS_fnc_blackIn;
	_cam camSetPos [(position center select 0) - 240, (position center select 1) + 100, 450];
	_cam camCommit 15;
	sleep 5;
	("BMR_Layer" call BIS_fnc_rscLayer) cutRsc ["bmr_intro", "PLAIN"];
	[_text, safezoneX - 0.01, safeZoneY + (1 - 0.125) * safeZoneH, true, "<t align='right' size='1.0' font='PuristaLight'>%1</t>"] spawn BIS_fnc_typeText2;
	UIsleep 3;
	waitUntil {camcommitted _cam};
	player enableSimulation true;
	player cameraEffect ["Terminate","BACK"];
	UIsleep 0.5;
	0 spawn {
		player sideChat localize "STR_BMR_initialize_done";
		player sideChat localize "STR_BMR_intro_tip1";
		player sideChat localize "STR_BMR_intro_tip2";
		if (INS_full_loadout isEqualTo 0) then {player sideChat localize "STR_BMR_Reload_toSave_Kit"};
		if (INS_p_rev in [6,7] && (!INS_ACE_med)) then {player sideChat "You Have 1 life. Bleed out or forced Respawn initiates spectator camera"};
	};
	setViewDistance -1;
	camDestroy _cam;
	enableRadio true;
	if (INS_mod_missing) then {0 spawn INS_missing_mods} else {INS_mod_missing=nil};
	if (JIG_DustStorm) then {0 spawn JIG_Dust_Storm};
	if (JIG_SnowStorm) then {0 spawn JIG_Snow_Storm};
};
JIG_placeSandbag_fnc = {
	// Player action place sandbag barrier. by Jigsor //WIP
	private _p = _this # 1;

	hintSilent "";
	if (!isNull objectParent _p) exitWith {hintSilent localize "STR_BMR_Sandbag_restrict"};

	private _isOverWater = false;
	private _wldPos = getPosWorld _p;
	private _posATLplyr = getPosATL _p;

	private _inWater = false;
	if (surfaceIsWater _wldPos) then {
		_isOverWater = true;
		//if ((getTerrainHeightASL getpos _p < -0.6 && _posATLplyr # 2 < 0.146) || eyePos _p select 2 < 0.2) then {_inWater = true};
		if ((getTerrainHeightASL getpos _p < -0.6 && _wldPos # 2 < -0.8) || eyePos _p select 2 < 0.2) then {_inWater = true};
	};

	if (_inWater) exitWith {hintSilent "Water is to deep!"};
	if (_wldPos inArea trig_alarm1init) exitWith {hintSilent "No Sandbags on Base!"};

	private _dist = 2;
	private _zvector = ((_p weaponDirection (primaryWeapon _p)) # 2) * 3;
	private _lift = 0.2;

	if (!isNull MedicSandBag) then {deleteVehicle MedicSandBag};
	private _type =  missionNamespace getVariable ["BMRmedSBtype", "Land_BagFence_Round_F"];
	MedicSandBag = createVehicle [_type, [(_posATLplyr # 0) + (sin(getdir _p) * _dist), (_posATLplyr # 1) + (cos(getdir _p) * _dist)], [], 0, "CAN_COLLIDE"];
	MedicSandBag setDir (getDir _p) - 180;
	MedicSandBag setposATL [(_posATLplyr # 0) + (sin(getdir _p) * _dist), (_posATLplyr # 1) + (cos(getdir _p) * _dist), (_posATLplyr # 2) + _zvector + 1];

	if (_isOverWater && _posATLplyr # 2 > 0.145) then {
		private _waterPos = ASLToATL (AGLToASL _wldPos); //(ASLToAGL getPosASL _p)
		MedicSandBag setPosATL (_p ModelToWorld [0,1.3, (_waterPos select 2) - (_wldPos select 2)]);
		//MedicSandBag setPosATL (_p ModelToWorld [0,1.3, (abs(_waterPos select 2)) - (_wldPos select 2)]);
	} else {
		if ((getPosATL MedicSandBag # 2) > _posATLplyr # 2) then {
			MedicSandBag setPos [getPosATL MedicSandBag # 0, getPosATL MedicSandBag # 1, _posATLplyr # 2];
			MedicSandBag setVectorUp [0,0,1];
		} else {
			while {((position MedicSandBag # 2) + 0.2) < _posATLplyr # 2} do {
				MedicSandBag setPos [getPosATL MedicSandBag # 0, getPosATL MedicSandBag # 1, (getPosATL MedicSandBag select 2) + _lift];
				MedicSandBag setVectorUp [0,0,1];
				_lift = _lift + 0.1;
			};
			if (((getPosATL MedicSandBag # 2) -2) > _posATLplyr # 2) then {
				MedicSandBag setPosATL (_p ModelToWorld [0,1.3,0]);
			};
		};
	};

	(_this # 1) removeAction (_this # 2);
	_id = MedicSandBag addAction [(localize "STR_BMT_remove_sandbag"), {call JIG_removeSandbag_fnc}];
};
JIG_removeSandbag_fnc = {
	// Player action remove sandbag barrier. by Jigsor
	deleteVehicle (_this # 0);
	{if ((_this # 1) actionParams _x select 0 isEqualTo (localize "STR_BMR_place_sandbag")) then {(_this # 1) removeAction _x}} forEach actionIDs (_this # 1);
	_id = (_this # 1) addAction [(localize "STR_BMR_place_sandbag"), {call JIG_placeSandbag_fnc}, 0, -9, false];
};
JIG_UGVdrop_fnc = {
	// Player action UGV para drop. by Jigsor
	private _p = _this # 1;
	/*// Require UAV backpack
	if (!(backpack _p isKindof "B_UAV_01_backpack_F")) exitWith {hint "You cannot call UGV without UAV backpack"; (_this # 1) removeAction (_this # 2); _id = _p addAction [(localize "STR_BMR_ugv_air_drop"),{call JIG_UGVdrop_fnc}, 0, -9, false];};
	if (backpack _p isKindof "B_UAV_01_backpack_F") then {hint "";};
	*/
	if !({_x find "_UavTerminal" != -1} count assignedItems _p > 0) then {
		if ({_x in ["ItemGPS"]} count assignedItems _p > 0) then {_p unlinkItem "ItemGPS"};
		if ({_x in ["O_UavTerminal"]} count assignedItems _p > 0) then {_p unlinkItem "O_UavTerminal"};
		if ({_x in ["I_UavTerminal"]} count assignedItems _p > 0) then {_p unlinkItem "I_UavTerminal"};
		_p linkItem "B_UAVTerminal";
	}else{
		_p unlinkItem "B_UAVTerminal";
		_p linkItem "B_UAVTerminal";
	};
	ghst_ugvsupport = [(markerPos "ugv_spawn"),"B_UGV_01_rcws_F",3,30] execVM "scripts\ghst_ugvsupport.sqf";
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
	if !(_entryName isEqualType "") exitWith {nil};
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

	_obj = (nearestObjects [position player, ["LandVehicle","Air"], 15]) select 0;
	if (!alive _obj) exitWith {hint localize "STR_BMR_Vehicle_destroyed"};
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
	_object = (nearestObjects [position player, ["LandVehicle","Air","Ship"], 10]) select 0;
	if (!isNil "_object") then {
		if (damage _object != 1) exitWith {hintSilent localize "STR_BMR_useMaint_action"};
		BTC_to_server = [0,_object];publicVariableServer "BTC_to_server";
	};
};
INS_Flip_Veh = {
	// Flip vehicle by Jigsor.
	params ["_target","_caller"];
	if (vehicle _caller != player) exitWith {hintSilent localize "STR_BMR_flip_restrict"};
	_veh = (nearestObjects [_target, ["LandVehicle"], 15]) select 0;
	if (!isNil "_veh") then {
		if ((damage _veh < 1) && {(count crew _veh isEqualTo 0)}) then {
			_veh setPos [getPos _veh # 0, getPos _veh # 1, 0];
		};
	};
	true
};
INS_planeReverse_key_F3 = {
	// Reverse Plane by Jigsor
	private ["_veh","_vel","_dir"];
	_veh = vehicle player;
	if (_veh isKindOf "Plane") then {
		if (driver _veh isEqualTo player && vectorMagnitudeSqr velocity _veh <= 0.5) then {
			_vel = velocity _veh;
			_dir = direction _veh;
			_veh setVelocity [(_vel select 0) + (sin _dir * -6), (_vel select 1) + (cos _dir * -6), (_vel select 2)];
		};
	};
};
JIG_load_VA_profile = {
	// Force load of saved Virtual Aresenal preset regardless if mod used to make loadout is currently not activated minus missing content by Jigsor.
	if (!isNil {profileNamespace getVariable "bis_fnc_saveInventory_data"}) then {
		private _loadOutsC = count (profileNamespace getVariable "bis_fnc_saveInventory_data");
		private _nameIndex = 0;
		private _toSort = [];
		for '_i' from 0 to (_loadOutsC / 2) -1 do {
			_toSort pushBack (profileNamespace getVariable "bis_fnc_saveInventory_data" select _nameIndex);
			_nameIndex = _nameIndex + 2;
		};
		_toSort sort true;
		[_toSort] spawn {
			params ['_sorted', '_loName', '_ids'];
			_ids = [];
			for '_i' from 0 to (count _sorted) -1 do {
				_loName = _sorted # _i;
				_id = INS_Wep_box addAction [("<t size='1.5' shadow='2' color='#00ffe9'>") + (localize "STR_BMR_load") + (format [" %1",_loName]) + "</t>",{(_this # 3) call BIS_fnc_loadInventory; call BMRINS_fnc_arsenalWeaponRemoval}, [player, [profileNamespace, format ["%1", _loName]]], 8, true, true, "", "true"];
				_ids pushback _id;
			};
			sleep 20;
			_ids apply {INS_Wep_box removeAction _x;}
		};
	};
};
JIG_p_actions_resp = {
	// Add player actions. by Jigsor
	waitUntil {sleep 1; alive player};
	private _playertype = typeOf (vehicle player);
	// Engineer
	if (_playertype in INS_W_PlayerEng) then {player addAction[("<t color='#12F905'>") + (localize "STR_BMR_cunstruct_farp") + "</t>","scripts\repair_special.sqf",0,1, false, true,"test2"];};
	// JTAC
	if (_playertype in INS_W_PlayerJTAC) then {null = [player, 500, true, 3] execVM "JWC_CASFS\addAction.sqf";};
	// Medic
	if (_playertype in INS_W_PlayerMedic) then {MedicSandBag = ObjNull; _id = player addAction[(localize "STR_BMR_place_sandbag"),{call JIG_placeSandbag_fnc}, 0, -9, false];};
	// UAV Operator
	if (_playertype in INS_W_PlayerUAVop) then {
		if !(INS_ACE_huntir) then {
			myhuntiraction = player addAction["use HuntIR","scripts\myhuntir.sqf", [], 1, false, true, "", "true"]; lck_markercnt=0;
		};
		_id = player addAction[(localize "STR_BMR_ugv_air_drop"),{call JIG_UGVdrop_fnc}, 0, -9, false];
	};
	// Sniper/Marksman/Spotter
	if (_playertype in INS_W_PlayerSniper) then	{
		player RemoveAllEventHandlers "FiredMan";
		_id = player addAction [(localize "STR_BMR_bullet_cam_on"),{call INS_bullet_cam}, 0, -9, false];
	};
	// All players mission settings
	if (Fatigue_ability < 1) then {[player] call INS_full_stamina};
	if !(((toLower (speaker player)) isEqualTo 'novoice') && {_playertype isEqualTo INS_op4_players}) then {
		player setSpeaker 'NoVoice';
	};
	showChat true;
	true
};
JIG_transfer_fnc = {
	// teleport by Jigsor
	_dest = (_this select 3) select 0;
	_dir = random 359;

	titleText ["", "BLACK OUT"];
	if (_dest isEqualType []) then {
		_pos = [(_dest select 0)-2*sin(_dir),(_dest select 1)-2*cos(_dir),_dest select 2];
		if (surfaceIsWater _pos) then {player setposASL _pos} else {player setPos _pos};
	};
	if (_dest isEqualType objNull) then {player setPos [(getPosATL _dest select 0)-10*sin(_dir),(getPosATL _dest select 1)-10*cos(_dir)]};
	if (_dest isEqualType "") then {player setPos [(markerPos _dest select 0)-10*sin(_dir),(markerPos _dest select 1)-10*cos(_dir)]};
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
	BIS_DeathBlur ppEffectAdjust [0];
	BIS_DeathBlur ppEffectCommit 0;

	if (!isNull _killer) then {
		if (_poorSoul isEqualTo _killer) exitWith {};
		_killerName = name _killer;
		_killerWeapon = currentWeapon _killer;
		_distance = round(_poorSoul distance2d _killer);
		_killerWeaponName = getText (configFile >> "CfgWeapons" >> _killerWeapon >> "displayName");
		if (_killerWeaponName == "Throw") then {_killerWeaponName = "Grenade"};
		if (_killerWeaponName == "Put") then {_killerWeaponName = "Explosive"};
		if (_killerWeaponName == "Horn") then {_killerWeaponName = "Vehicle"};
		if (_killerName == "Error: No unit") then {_killerName = "Unidentified"};
		uiSleep 7;
		_text = format ["Killed by %1, from %2 meters, with %3",_killerName, str(_distance), str(_killerWeaponName)];
		//copyToClipboard str(_text);
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
	[_text] remoteExec ["JIG_MPsideChatWest_fnc", [0,-2] select isDedicated];

	_direction = floor random 360;
	_distance = floor linearConversion [0, 1, random 1, 10 min _maxClueDis, _maxClueDis max 10 + 1]; // Minimum intel marker range 10m. Maximum intel marker range defined by INS_maxClueDis in INS_definitions.sqf.
	_randomPos = _pos_info getPos [_distance, _direction];

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

	if (side _caller isEqualTo INS_Blu_side) then {
		_caller addRating 200;
		_caller addScore _pScore;
		paddscore = [_caller, _pscore];
		publicVariableServer "paddscore";
		[West,"HQ"] sideChat "+2 points";
	};
	true
};
Op4_initial_spawn_pos = {
	// Initial Op4 spawn position by Jigsor
	params ["_op4Player"];
	private ["_posnotfound","_random_w_player","_basePos","_players","_movelogic","_blu4Speeding","_playerPos","_cooX","_cooY","_wheX","_wheY","_randPos","_c","_spawnPos","_centerPos","_dis","_dir"];
	_posnotfound = false;
	_random_w_player = nil;
	_basePos = markerPos "Respawn_West";
	_players = [];
	_movelogic = if (INS_p_rev > 5) then {false}else{true};

	{_players pushBack _x} forEach (playableUnits select {side _x isEqualTo INS_Blu_side && isPlayer _x});

	if (count _players > 0) then {
		{
			_blu4Speeding = (vectorMagnitudeSqr velocity _x > 8);
			_pos = (getPos _x);
			if ((_blu4Speeding) || (_pos select 2 > 4)) then {_players = _players - [_x];};
		} foreach _players;// exclude players in moving vehicles, above ground players such as players in aircraft or in high structures
	}else{
		_posnotfound = true;
	};

	if (count _players > 0) then {
		_random_w_player = selectRandom _players;
		_players = _players - ["_random_w_player"];
		while {!isNil "_random_w_player" && {_random_w_player distance _basePos < 500}} do {
			_random_w_player = selectRandom _players;
			_players = _players - ["_random_w_player"];
		};
	};// exclude players to close to blufor base

	if (!isNil "_random_w_player") then	{
		// Move Op4 Base within 250 to 500 meters of blufor player
		_playerPos = getPos _random_w_player;
		_cooX = _playerPos # 0;
		_cooY = _playerPos # 1;
		_wheX = floor linearConversion [0, 1, random 1, 250 min 500, 500 max 250 + 1];
		_wheY = floor linearConversion [0, 1, random 1, 250 min 500, 500 max 250 + 1];
		_randPos = [_cooX+_wheX,_cooY+_wheY,0];
		_c = 0;
		_spawnPos = _randPos isFlatEmpty [8,384,0.5,2,0,false,ObjNull];

		while {(count _spawnPos) < 1} do {
			_spawnPos = _randPos isFlatEmpty [5,384,0.9,2,0,false,ObjNull];
			_c = _c + 1;
			if (_c > 5) exitWith {_posnotfound = true};
			sleep 0.2;
		};
		if (count _spawnPos > 0) exitWith {
			if (_movelogic) then {BTC_r_base_spawn setPos _spawnPos};
			"Respawn_East" setMarkerPos _spawnPos;
			_op4Player setPos _spawnPos;
			titleCut["", "BLACK IN",1];
		};
	}else{
		_posnotfound = true;
	};

	if (_posnotfound) then {
		if (INS_MHQ_exists && {!isNil "Opfor_MHQ"}) then {
			// Move to Op4 MHQ
			if !(markerColor "Opfor_MHQ" isEqualTo "") then {
				if (_movelogic) then {BTC_r_base_spawn setPos markerPos "Opfor_MHQ"};
				"Respawn_East" setMarkerPos markerPos "Opfor_MHQ";
				_dir = random 359;
				_op4Player setPos [(markerPos "Opfor_MHQ" select 0)-10*sin(_dir),(markerPos "Opfor_MHQ" select 1)-10*cos(_dir)];
			};
			titleCut["", "BLACK IN",1];
		}else{
			// Move Op4 Base to center
			_centerPos = getPosATL center;
			_cooX = _centerPos # 0;
			_cooY = _centerPos # 1;
			_dis = 400;
			_wheX = random (_dis*2)-_dis;
			_wheY = random (_dis*2)-_dis;
			_randPos = [_cooX+_wheX,_cooY+_wheY,0];
			_spawnPos = _randPos isFlatEmpty [10,384,0.5,2,0,false,ObjNull];

			while {(count _spawnPos) < 1} do {
				_spawnPos = _randPos isFlatEmpty [5,384,0.9,2,0,false,ObjNull];
				sleep 0.2;
			};
			if (_movelogic) then {BTC_r_base_spawn setPos _spawnPos};
			"Respawn_East" setMarkerPos _spawnPos;
			_op4Player setPos _spawnPos;
			titleCut["", "BLACK IN",1];
		};
	};
	if (true) exitWith {Op4_initial_spawn_pos = nil; true};
};
INS_bullet_cam = {
	// add bullet cam
	//http://killzonekid.com/arma-scripting-tutorials-a-simple-bullet-cam/
	player addEventHandler ["FiredMan", {
		if !((_this select 1) in ["Throw","Put"]) then {
			0 = (_this # 6) spawn {
				_cam = "camera" camCreate (position player);
				_cam cameraEffect ["External", "BACK"];
				waitUntil {
					if (isNull _this) exitWith {true};
					_cam camSetTarget _this;
					_cam camSetRelPos [0,-3,0];
					_cam camCommit 0;
					false
				};
				sleep 0.4;
				_cam cameraEffect ["Terminate", "BACK"];
				camDestroy _cam;
			};
		};
	}];
	(_this # 1) removeAction (_this # 2);
	_id = (_this # 1) addAction[(localize "STR_BMR_bullet_cam_off"),{call JIG_removeBulletCam_fnc}, 0, -9, false];
};
JIG_removeBulletCam_fnc = {
	// remove bullet cam
	(_this # 1) removeAction (_this # 2);
	(_this # 1) RemoveAllEventHandlers "FiredMan";
	_id = (_this # 1) addAction[(localize "STR_BMR_bullet_cam_on"),{call INS_bullet_cam}, 0, -9, false];
};
JIG_circling_cam = {
	// Circling camera by Jigsor
	params ["_pos","_travel","_interval","_delay"];
	_dir = random 359;
	_maxRotation = (_dir + _travel);
	_camHeight = 15;
	_camDis = -30;
	_logic_pos = _pos vectorAdd [0,0,3];
	_camPos = _pos vectorAdd [0,0,_camHeight];

	_logic = createVehicle ["Land_ClutterCutter_small_F", _logic_pos, [], 0, "CAN_COLLIDE"];
	_logic setDir _dir;

	_cam = "camera" camCreate _camPos;
	_cam camSetPos _camPos;
	_cam camSetTarget _logic;
	_cam camCommit 0;
	waitUntil {camcommitted _cam};

	_cam attachTo [_logic, [0,_camDis,_camHeight] ];
	_cam cameraEffect ["Internal", "BACK"];

	while {_dir < _maxRotation} do {
		_dir = _dir + _interval;
		_logic setDir _dir;
		sleep _delay;
	};

	camDestroy _cam;
	deleteVehicle _logic;
	player cameraEffect ["Terminate", "BACK"];
	true
};
JIG_map_click = {
	// Vehicle reward mapclick position by Jigsor
	if ({_x in (items player + assignedItems player)}count ["ItemMap"] < 1) exitWith {hint localize "STR_BMR_missing_map";true};
	if (player getVariable "createEnabled") then {
		if !(markerColor "VehDrop" isEqualTo "") then {deleteMarkerLocal "VehDrop"};
		hint "";
		GetClick = true;
		openMap true;
		waitUntil {visibleMap};
		0 spawn {[localize "STR_BMR_reward_mapclick",0,.1,3,.005,.1] call bis_fnc_dynamictext;};

		["Reward_mapclick","onMapSingleClick", {

			private ["_nearestRoad","_roads","_marker"];
			if (isOnRoad _pos) then {
				_nearestRoad = objNull;
				_roads = _pos nearRoads 15;
				if (count _roads > 0) then {
					_nearestRoad = ([_roads,[],{_pos distance _x},"ASCEND"] call BIS_fnc_sortBy) select 0;
				};
			};

			_marker=createMarkerLocal ["VehDrop", _pos];
			"VehDrop" setMarkerShapeLocal "ICON";
			"VehDrop" setMarkerSizeLocal [1, 1];
			"VehDrop" setMarkerTypeLocal "mil_dot";
			"VehDrop" setMarkerColorLocal "Color3_FD_F";
			"VehDrop" setMarkerTextLocal "Vehicle Reward Location";
			if (!isNull _nearestRoad) then {"VehDrop" setMarkerDirLocal (_pos getDir _nearestRoad)};

			GetClick = false;
		}] call BIS_fnc_addStackedEventHandler;

		waitUntil {!GetClick or !(visiblemap)};
		["Reward_mapclick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;

		if (!visibleMap) exitWith {[] call JIG_map_click};
		mapAnimAdd [0.5, 0.1, markerPos 'VehDrop'];
		mapAnimCommit;
		sleep 1.2;
		openMap false;

		[["cars", "tanks", "helicopters", "planes", "boats"], [], "VehDrop", 0.3, 3] execVM "ASORVS\open.sqf";
	}else{
		(_this # 0) removeAction (_this # 2);
		if !(markerColor "VehDrop" isEqualTo "") then {deleteMarkerLocal "VehDrop"};
	};
	true
};
INS_AI_revive = {
	// Initialize =BTC= Quick Revive for all group members including AI by Jigsor.
	if (INS_p_rev in [4,5]) then {
		private _pA = [];
		private _aiA = [];
		_grp = group player;

		if (count bon_recruit_queue > 0) then { waitUntil {sleep 1; count bon_recruit_queue < 1}; };
		{if (isPlayer _x) then {_pA pushBack _x;}else{_aiA pushBack _x;};} forEach (units _grp);
		if !(_pA isEqualTo []) then {["btc_qr_fnc_unit_init", _grp] call BIS_fnc_MP;};
		{_x call btc_qr_fnc_unit_init;} forEach _aiA;
	};
};
INS_Vehicle_Reward = {
	// Issues Vehicle Reward action to player by Jigsor. Admins can create vehicle at any time from breifing admin panel
	player setVariable ["createEnabled", true];
	_id = player addAction[("<t size='1.5' shadow='2' color='#12F905'>") + (localize "STR_BMR_veh_reward") + "</t>",{call JIG_map_click}, [], 10, false, true];
};
INS_Recruit_skill = {
	// Sets skill of a recruited unit
	params ["_unit"];
	_unit setSkill ["aimingAccuracy", (BTC_AI_skill*0.1)];
	_unit setSkill ["aimingShake", 0.6];
	_unit setSkill ["aimingSpeed", 0.5];
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
	missionNamespace setVariable ["INS_SavedLoadout", (getUnitLoadout player)];
	true
};
INS_RespawnLoadout = {
	// Save respawn kit used with "Save Respawn Loadout" action by Jigsor
	missionNamespace setVariable ["INS_SavedLoadout", (getUnitLoadout player)];
	_kitSaved = "A3\Sounds_F\sfx\Beep_Target.wss";
	playsound3d [_kitSaved, (_this # 0), false, getPosasl (_this # 1), 5,0.5,10];
	hintSilent "Kit Saved";
	true
};
INS_RestoreLoadout = {
	// Restore saved kit when respawned by Jigsor.
	_kit = missionNamespace getVariable ["INS_SavedLoadout", loadout];
	player setUnitLoadout _kit;
	true
};
INS_UI_pref = {
	// Restore status hud and digital heading on respawn if they were activated before death by Jigsor.
	_dhFlag = false;
	if (!isNull (uiNamespace getVariable ["jig_headingDisplay", displayNull])) then {
		"jig_headingDisplay" cutText ["", "PLAIN"];
		_dhFlag = true;
	};
	waitUntil {sleep 2; alive player};
	if (_dhFlag) then {0 spawn Jig_fnc_DigiHeading};
	if (player getVariable "stathud_resp") then {execVM "INSui\staus_hud_toggle.sqf"};
	true
};
INS_aiHalo = {
	// AI halo based on/uses functions from ATM_airdrop.
	params ["_target","_halo_pos"];
	private _openChuteAlt = 75;//This does not work in Arma 3 as of v1.5. AI will open chute at 150m.
	private _jumpAlt = 450;
	private _freefall = true;
	private _headgear = headgear _target;
	private _back_pack = backpack _target;
	private _back_pack_items = getItemCargo (unitBackpack _target);
	private _back_pack_weap = getWeaponCargo (unitBackpack _target);
	private _back_pack_mags = getMagazineCargo (unitBackpack _target);
	private _loadout = [_headgear, _back_pack, _back_pack_items, _back_pack_weap, _back_pack_mags];

	//0=[_target] call Frontpack;//<-causes freezing

	removeBackpack _target;
	sleep 0.5;
	_target addBackpack "B_Parachute";
	_target setPos [(_halo_pos # 0), (_halo_pos # 1), (_halo_pos select 2) + _jumpAlt];
	_target switchMove "HaloFreeFall_non";//"halofreefall_non";
	sleep 0.1;

	while {(getPos _target select 2) > 2.5} do {
		if (_freefall) then {
			if(isNull objectParent _target && {(getPos _target select 2) < _openChuteAlt}) then {
				_target action ["OpenParachute", _target];
				_freefall = false;
			} else {
				_freefall = false;
			};
		};
		if(!alive _target) then {
			sleep (random 5) + 3;
			_target setPos [getPos _target # 0, getPos _target # 1, 0];
		};
		sleep 1;
	};

	//deleteVehicle (_target getVariable "frontpack");
	_target setVariable ["frontpack",nil];

	0=[_target,_loadout] spawn ATM_Setloadout;
};
mhq_actions2_fnc = {
	// Add action for VA and quick VA profile to respawned MHQs by Jigsor.
	params ["_var"];
	private _op4 = missionNamespace getVariable ["INS_usesOP4mhq", true];
	switch (_var) do {
		case "MHQ_1" : {
			if (!_op4) then {
				if (INS_VA_type in [0,3]) then {
					MHQ_1 addAction[("<t color='#F56618'>") + (localize "STR_BMR_load_VAprofile") + "</t>", "call JIG_load_VA_profile_MHQ1", [(_this # 1)],1,true,true,"","true",12];
					MHQ_1 addAction[("<t color='#ff1111'>") + (localize "STR_BMR_open_VA") + "</t>",{["Open",true] call BIS_fnc_arsenal},nil,6,true,true,"","side _this != EAST && _this isEqualTo vehicle player",12];
				};
				if (INS_VA_type in [1,2]) then {
					MHQ_1 addAction[("<t color='#ff1111'>") + (localize "STR_BMR_open_VA") + "</t>",{[_this] call JIG_VA},nil,6,true,true,"","side _this != EAST && _this isEqualTo vehicle player",12];
				};
				if (MHQ_1 isKindOf "Ship") then {
					MHQ_1 addAction ["<t color='#FF9900'>Push</t>",{call Push_Vehicle},[],-1,false,true,"","_this distance _target < 8"];
				};
			};
		};
		case "MHQ_2" : {
			if (!_op4) then {
				if (INS_VA_type in [0,3]) then {
					MHQ_2 addAction[("<t color='#F56618'>") + (localize "STR_BMR_load_VAprofile") + "</t>", "call JIG_load_VA_profile_MHQ2", [(_this # 1)],1,true,true,"","true",12];
					MHQ_2 addAction[("<t color='#ff1111'>") + (localize "STR_BMR_open_VA") + "</t>",{["Open",true] call BIS_fnc_arsenal},nil,6,true,true,"","side _this != EAST && _this isEqualTo vehicle player",12];
				};
				if (INS_VA_type in [1,2]) then {
					MHQ_2 addAction[("<t color='#ff1111'>") + (localize "STR_BMR_open_VA") + "</t>",{[_this] call JIG_VA},nil,6,true,true,"","side _this != EAST && _this isEqualTo vehicle player",12];
				};
				if (MHQ_2 isKindOf "Ship") then {
					MHQ_2 addAction ["<t color='#FF9900'>Push</t>",{call Push_Vehicle},[],-1,false,true,"","_this distance _target < 8"];
				};
			};
		};
		case "MHQ_3" : {
			if (!_op4) then {
				if (INS_VA_type in [0,3]) then {
					MHQ_3 addAction[("<t color='#F56618'>") + (localize "STR_BMR_load_VAprofile") + "</t>", "call JIG_load_VA_profile_MHQ3", [(_this # 1)],1,true,true,"","true",12];
					MHQ_3 addAction[("<t color='#ff1111'>") + (localize "STR_BMR_open_VA") + "</t>",{["Open",true] call BIS_fnc_arsenal},nil,6,true,true,"","side _this != EAST && _this isEqualTo vehicle player",12];
				};
				if (INS_VA_type in [1,2]) then {
					MHQ_3 addAction[("<t color='#ff1111'>") + (localize "STR_BMR_open_VA") + "</t>",{[_this] call JIG_VA},nil,6,true,true,"","side _this != EAST && _this isEqualTo vehicle player",12];
				};
			};
		};
		case "Opfor_MHQ" : {
			if (_op4) then {
				Opfor_MHQ addAction [("<t size='1.5' shadow='2' color='#12F905'>") + ("Deploy MHQ") + "</t>","scripts\deployOpforMHQ.sqf", nil, 1, false, true, "", "side _this != INS_Blu_side", 12];
			};
		};
		default {};
	};
	true
};
INS_MHQ_mkr = {
	// Tracking MHQ marker by Jigsor.
	params [["_mhq",ObjNull,[ObjNull]], ["_mhqPos",[0,0,0],[[]]]];
	if (isNull _mhq) exitWith {};

	private _op4 = missionNamespace getVariable ["INS_usesOP4mhq", true];
	private _exit = false;
	private ["_mkrName","_color"];

	if (vehicleVarName _mhq != "") then {
		_mkrName = vehicleVarName _mhq;
	}else{
		_mkrName = format ["%1", _mhq];
	};
	if (_op4 && {_mkrName isEqualTo "Opfor_MHQ"}) then {
		_color = "ColorRed";
	}else{
		if (_op4) then {_exit = true};
		_color = "ColorGreen";
	};

	if (!_op4 && {_mkrName isEqualTo "Opfor_MHQ"}) then {_exit = true};
	if (_exit) exitWith {};

	deleteMarkerLocal _mkrName;
	private _mkr = createMarkerLocal [_mkrName, _mhqPos];
	_mkr setMarkerTypeLocal "mil_dot";
	_mkr setMarkerTextLocal _mkrName;
	_mkr setMarkerColorLocal _color;
	_mkr setMarkerSizeLocal [0.5, 0.5];

	while {alive _mhq} do {
		_mkr setMarkerPosLocal (getPosWorld _mhq);
		UIsleep 1;
	};
	if (!alive _mhq) exitWith {deleteMarkerLocal _mkrName; hintSilent format ["%1 has been destroyed!", _mkrName]};
};
INS_MHQ_client = {
	_INS_MHQ_killed = INS_MHQ_killed;
	_INS_MHQ_killed spawn {
		private ["_qued_MHQ_killed","_mhqPos","_mhqAcc","_mhqObj"];
		_qued_MHQ_killed = _this;
		sleep 6;
		_mhqAcc = [_qued_MHQ_killed] call mhq_actions2_fnc;
		_mhqObj = objNull;
		_mhqObj = [_qued_MHQ_killed] call mhq_obj_fnc;
		_mhqPos = getPosASL _mhqObj;
		_nul = [_mhqObj,_mhqPos] spawn INS_MHQ_mkr;
	};
	true
};
GAS_smokeNear = {
	//Are we near a smoke shell. Are we not wearing a gas mask. code by Larrow modified by Jigsor
	if !(([(headgear player),(goggles player)] arrayIntersect INS_allGasMask) isEqualTo []) then {
		false
	}else{
		_smokeShell = player nearObjects ["GrenadeHand", 30] select {typeOf _x in INS_Gas_Grenades};
		if !(isNull (_smokeShell # 0)) then {
			vectorMagnitudeSqr velocity (_smokeShell select 0) <= 0.5 && { (_smokeShell select 0) distance player < 15 && !((_smokeShell select 0) inArea trig_alarm1init) }
		}else{
			false
		};
	};
};
GAS_inSmoke = {
	// We are in smoke. code by Larrow
	player setVariable ["inSmoke",true];

	"dynamicBlur" ppEffectEnable true;
	"dynamicBlur" ppEffectAdjust [12];
	"dynamicBlur" ppEffectCommit 5;
	enableCamShake true;
	addCamShake [10, 45, 10];
	5 fadeSound 0.1;

	//While were in smoke
	while { alive player && not captive player && call GAS_smokeNear } do {
		private _sound = selectRandom Choke_Sounds;
		playsound3d [_sound, player, false, getPosasl player, 5,1,30];
		player setDamage (damage player + 0.13);
		//if(floor random 2 isEqualTo 0) then {hint "You Should Wear a Gas Mask";};
    	sleep 2.8123;
	};

	call GAS_smokeClear;
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
INS_EarPlugs = {
	if (INS_ACE_core && {missionnamespace getvariable ['ace_hearing_EnableCombatDeafness', false]}) exitWith {
		if (!([player] call ace_hearing_fnc_hasEarPlugsIn) && {'ACE_EarPlugs' in items player}) then {
			[player] call ace_hearing_fnc_putInEarPlugs;
		} else {
			if ([player] call ace_hearing_fnc_hasEarPlugsIn) then {
				[player] call ace_hearing_fnc_removeEarPlugs;
			};
		};
	};
	if (soundVolume isEqualTo 1) then {
		1 fadeSound 0.22; hintSilent localize "STR_BMR_ON";
	}else{
		1 fadeSound 1; hintSilent localize "STR_BMR_OFF";
	};
};
JIG_dsHaze = {
	// Dust Storm Haze
	hintSilent localize "STR_BMR_DustStorm_On";
	enableEnvironment [(environmentEnabled select 0), false];//Ambient sound off
	private _ppe = ppEffectCreate ["colorCorrections", 1501];
	_ppe ppEffectAdjust [1, 0.85, -0.001, [0.0, 0.0, 0.0, 0.0], [0.1*3, 0.1*3, 0.0, 0.8], [0.9, 0.9, 0.9, 0.0]];
	_ppe ppEffectCommit 3;
	_ppe ppEffectEnable true;
};
JIG_dsClear = {
	// Clear Dust Storm Haze
	private _ppe = ppEffectCreate ["colorCorrections", 1501];
	_ppe ppEffectAdjust [1, 1, 0, [0, 0, 0, 0], [1, 1, 1, 1] , [0.299, 0.587, 0.114, 0], [-1, -1, 0, 0, 0, 0, 0]];
	_ppe ppEffectCommit 3;
	_ppe ppEffectEnable true;
	enableEnvironment [(environmentEnabled select 0), true];//Ambient sound On
	hintSilent localize "STR_BMR_DustStorm_Off";
};
CarHax = {
	params ["_action","_veh"];
	private _p = player;
	if (_action find "Driver" != -1) exitWith {_p moveInDriver _veh};
	switch (_action) do {
		case "Get in Prowler (Unarmed) as Gunner": {_p moveInTurret [_veh, [5]]};
		case "Get in Prowler (Armed) as Gunner": {_p moveInTurret [_veh, [0]]};
		case "Get in Prowler (Light) as Gunner": {_p moveInTurret [_veh, [5]]};
		case "Get in Qilin (Armed) as Gunner": {_p moveInTurret [_veh, [0]]};
		case "Get in Qilin (Unarmed) as Gunner": {_p moveInTurret [_veh, [5]]};
		case "Get in Rhino MGS as Gunner": {_p moveInTurret [_veh, [0]]};
		case "Get in Rhino MGS UP as Gunner": {_p moveInTurret [_veh, [0]]};
		case "Get in MB 4WD (AT) as Gunner": {_p moveInTurret [_veh, [0]]};
		case "Get in MB 4WD (LMG) as Gunner": {_p moveInTurret [_veh, [0]]};
		case "Get in Prowler (AT) as Gunner": {_p moveInTurret [_veh, [0]]};
		case "Get in Prowler (HMG) as Gunner": {_p moveInTurret [_veh, [0]]};
		case "Get in Qilin (AT) as Gunner": {_p moveInTurret [_veh, [0]]};
		default {};
	};
};
PlaneHax = {
	params ["_action","_veh"];
	private _p = player;
	switch (_action) do {
		case "Get in F/A-181 Black Wasp II as Pilot": {_p moveInDriver _veh};
		case "Get in F/A-181 Black Wasp II (Stealth) as Pilot": {_p moveInDriver _veh};
		case "Get in To-201 Shikra as Pilot": {_p moveInDriver _veh};
		case "Get in To-201 Shikra (Stealth) as Pilot": {_p moveInDriver _veh};
		case "Get in A-149 Gryphon as Pilot": {_p moveInDriver _veh};
		case "Get in V-44 X Blackfish (Armed) as Pilot": {_p moveInDriver _veh};
		case "To Pilot's seat": {_p moveInDriver _veh};
		case "Get in V-44 X Blackfish (Armed) as Copilot": {_p moveInTurret [_veh, [0]]};
		case "To Copilot's seat": {_p moveInTurret [_veh, [0]]};
		case "Get in V-44 X Blackfish (Armed) as Left door gunner": {_p moveInTurret [_veh, [1]]};
		case "To Left door gunner's seat": {_p moveInTurret [_veh, [1]]};
		case "Get in V-44 X Blackfish (Armed) as Right door gunner": {_p moveInTurret [_veh, [2]]};
		case "To Right door gunner's seat": {_p moveInTurret [_veh, [2]]};
		case "Get in V-44 X Blackfish (Vehicle Transport) as Pilot": {_p moveInDriver _veh};
		case "To Pilot's seat": {_p moveInDriver _veh};
		case "Get in V-44 X Blackfish (Vehicle Transport) as Copilot": {_p moveInTurret [_veh, [0]]};
		case "To Copilot's seat": {_p moveInTurret [_veh, [0]]};
		case "Get in V-44 X Blackfish (Vehicle Transport) as Passenger (Left Seat)": {_p moveInTurret [_veh, [1]]};
		case "To Passenger (Left Seat)'s seat": {_p moveInTurret [_veh, [1]]};
		case "Get in V-44 X Blackfish (Vehicle Transport) as Passenger (Right Seat)": {_p moveInTurret [_veh, [2]]};
		case "To Passenger (Right Seat)'s seat": {_p moveInTurret [_veh, [2]]};
		case "Get in Y-32 Xi'an (Infantry Transport) as Pilot": {_p moveInDriver _veh};
		case "Get in Y-32 Xi'an (Infantry Transport) as Gunner": {_p moveInTurret [_veh, [0]]};
		case "Get in Y-32 Xi'an (Vehicle Transport) as Pilot": {_p moveInDriver _veh};
		case "Get in Y-32 Xi'an (Vehicle Transport) as Gunner": {_p moveInTurret [_veh, [0]]};
		case "Get in Caesar BTT as Pilot": {_p moveInDriver _veh};
		case "Get in Caesar BTT as Copilot": {_p moveInTurret [_veh, [0]]};
		case "Get in Caesar BTT (Racing) as Pilot": {_p moveInDriver _veh};
		case "Get in Caesar BTT (Racing) as Copilot": {_p moveInTurret [_veh, [0]]};
		default {};
	};
};
HeliHax = {
	params ["_action","_veh"];
	private _p = player;
	switch (_action) do {
		case "Get in CH-67 Huron as Pilot": {_p moveInDriver _veh};
		case "Get in CH-67 Huron as Copilot": {_p moveInTurret [_veh, [0]]};
		case "Get in CH-67 Huron as Left door gunner": {_p moveInTurret [_veh, [1]]};
		case "Get in CH-67 Huron as Right door gunner": {_p moveInTurret [_veh, [2]]};
		case "Get in CH-67 Huron (Unarmed) as Pilot": {_p moveInDriver _veh};
		case "Get in CH-67 Huron (Unarmed) as Copilot": {_p moveInTurret [_veh, [0]]};
		case "Get in Mi-290 Taru (Bench) as Pilot": {_p moveInDriver _veh};
		case "Get in Mi-290 Taru (Bench) as Copilot": {_p moveInTurret [_veh, [0]]};
		case "Get in Mi-290 Taru (Bench) as Loadmaster": {_p moveInTurret [_veh, [1]]};
		case "Get in Mi-290 Taru as Pilot": {_p moveInDriver _veh};
		case "Get in Mi-290 Taru as Copilot": {_p moveInTurret [_veh, [0]]};
		case "Get in Mi-290 Taru as Loadmaster": {_p moveInTurret [_veh, [1]]};
		case "Get in M-900 as Pilot": {_p moveInDriver _veh};
		case "Get in WY-55 Czapla as Pilot": {_p moveInDriver _veh};
		case "Get in WY-55 Czapla (Unarmed) as Pilot": {_p moveInDriver _veh};
		default {};
	};
};
TankHax = {
	params ["_action","_veh"];
	private _p = player;
	if (_action find "Driver" != -1) exitWith {_p moveInDriver _veh};
	switch (_action) do {
		case "Get in FV-720 Odyniec as Gunner": {_p moveInTurret [_veh, [0]]};
		case "Get in AWC 301 Nyx (AT) as Commander": {_p moveInTurret [_veh, [0]]};
		case "Get in AWC 302 Nyx (AA) as Commander": {_p moveInTurret [_veh, [0]]};
		case "Get in AWC 303 Nyx (Recon) as Commander": {_p moveInTurret [_veh, [0]]};
		case "Get in AWC 304 Nyx (Autocannon) as Commander": {_p moveInTurret [_veh, [0]]};
		case "Get in T-140 Angara as Gunner": {_p moveInTurret [_veh, [0]]};
		case "Get in T-140 Angara as Commander": {_p moveInTurret [_veh, [0,0]]};
		case "Get in T-140K Angara as Gunner": {_p moveInTurret [_veh, [0]]};
		case "Get in T-140K Angara as Commander": {_p moveInTurret [_veh, [0,0]]};
		default {};
	};
};
ShipHax = {
	params ["_action","_veh"];
	private _p = player;
	if (_action find "Driver" != -1) exitWith {_p moveInDriver _veh};
	switch (_action) do {
		case "Get in Water Scooter Ride in back": {_p moveInCargo _veh};
		case "Get in Speedboat HMG as Commander": {_p moveInTurret [_veh, [0]]};
		case "Get in Speedboat HMG as Rear gunner": {_p moveInTurret [_veh, [1]]};
		default {};
	};
};
JIG_VA = {
	// Whitelisted Virtual Arsenal by Jigsor
	_VAobj = _this select 0 select 0;
	_caller = _this select 0 select 1;
	_list = [];
	_remArsAct = {{if (_this actionParams _x select 0 isEqualTo (localize "STR_A3_Arsenal")) exitWith {_this removeAction _x}} forEach actionIDs _this};
	if (playerside isEqualTo WEST) then {BMRINS_profileSave = "BMR_bis_fnc_saveInventory_west_data"; _list = call BMRINS_fnc_BluforVA};
	if (playerside isEqualTo EAST) then {BMRINS_profileSave = "BMR_bis_fnc_saveInventory_east_data"; _list = call BMRINS_fnc_InsurgentVA};
	clearMagazineCargoGlobal _VAobj;
	clearWeaponCargoGlobal _VAobj;
	clearItemCargoGlobal _VAobj;
	clearBackpackCargoGlobal _VAobj;
	["Open",[nil,_VAobj,_caller]] call bis_fnc_arsenal;
	[_VAobj,((backpackCargo _VAobj) + (_list select 0))] call BIS_fnc_addVirtualBackpackCargo;
	[_VAobj,((itemCargo _VAobj) + (_list select 1))] call BIS_fnc_addVirtualItemCargo;
	[_VAobj,((magazineCargo _VAobj) + (_list select 2))] call BIS_fnc_addVirtualMagazineCargo;
	[_VAobj,((weaponCargo _VAobj) + (_list select 3))] call BIS_fnc_addVirtualWeaponCargo;
	sleep 1;
	_VAobj call _remArsAct;
};
INS_3d_Fallen = {
	_fallen = addMissionEventHandler ["Draw3D", {
		{
			if ((_x distance player) < 31 && {side player isEqualTo side _x} && {(lifeState _x isEqualTo "INCAPACITATED") || (_x getVariable ["ACE_isUnconscious", false])}) then {
				drawIcon3D["a3\ui_f\data\map\MapControl\hospital_ca.paa",[1,0,0,1],_x,0.5,0.5,0,format["%1 (%2m)", name _x, ceil (player distance _x)],0,0.02];
			};
		} foreach playableUnits;
	}];
};
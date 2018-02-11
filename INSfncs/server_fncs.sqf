remove_carcass_fnc = {
	// Deletes dead bodies and destroyed vehicles. Code by BIS
	params ["_unit"];
	sleep 2;
	if (not (_unit isKindOf "Man")) then {
		{_x setPos position _unit} forEach crew _unit;
		sleep 120;
		deleteVehicle _unit;
	};
	if (_unit isKindOf "Man") then {
		if(not ((vehicle _unit) isKindOf "Man")) then {_unit setPos (position vehicle _unit)};
		sleep 135;
		hideBody _unit;
		_unit removeAllEventHandlers "killed";
	};
};
BTC_m_fnc_only_server = {
	params ["_type","_array"];
	if (_type isEqualTo 0) then	{
		private _veh = _array select 1;
		_veh spawn BTC_server_repair_wreck;
	}
	else
	{};
};
BTC_AIunit_init = {
	// sets skill of a unit if ASR AI is not detected
	params ["_unit"];
	if (isClass(configFile >> "cfgPatches" >> "asr_ai_main")) exitWith {};
	_unit setSkill ["aimingAccuracy", (BTC_AI_skill*0.1)];
	_unit setSkill ["aimingShake", 0.6];
	_unit setSkill ["aimingSpeed", 0.5];
	_unit setSkill ["endurance", 0.6];
	_unit setSkill ["spotDistance", 0.6];
	_unit setSkill ["spotTime", 0.5];
	_unit setSkill ["courage", 0.5];
	_unit setSkill ["reloadSpeed", 1];
	if (_unit isEqualTo (leader group _x)) then	{
		_unit setSkill ["commanding", 1];
	};
	_unit setSkill ["general", 0.6];
};
BTC_AI_init = {
	// sets skill of a group if ASR AI is not detected
	params ["_group"];
	if (isClass(configFile >> "cfgPatches" >> "asr_ai_main")) exitWith {};
	{
		_x setSkill ["aimingAccuracy", (BTC_AI_skill*0.1)];
		_x setSkill ["aimingShake", 0.6];
		_x setSkill ["aimingSpeed", 0.5];
		_x setSkill ["endurance", 0.6];
		_x setSkill ["spotTime", 0.5];
		_x setSkill ["courage", 0.5];
		_x setSkill ["spotDistance", 0.6];
		_x setSkill ["reloadSpeed", 1];
		if (leader _group isEqualTo _x) then {
			_x setSkill ["commanding", 1];
		};
		_x setSkill ["general", 0.6];
	} forEach units _group;
};
paint_heli_fnc = {
	//Paints blufor helis (typically Mowhawk and Hellcat) a different color matching terrain as to not mistake them for Opfor helis by Jigsor.
	params ["_veh"];
	private ["_color","_darkGrey","_sandColor","_green1","_green2"];
	_darkGrey = [
		[0,"#(argb,8,8,3)color(0.518,0.519,0.455,0.2)"],
		[1,"#(argb,8,8,3)color(0.518,0.519,0.455,0.2)"],
		[2,"#(argb,8,8,3)color(0.518,0.519,0.455,0.2)"]
	];
	_sandColor = [
		[0,"#(argb,8,8,3)color(0.96,0.88,0.69,0.35)"],
		[1,"#(argb,8,8,3)color(0.96,0.88,0.69,0.35)"],
		[2,"#(argb,8,8,3)color(0.96,0.88,0.69,0.35)"]
	];
	_green1 = [
		[0,"#(argb,8,8,3)color(0.550,0.620,0.4,0.1)"],
		[1,"#(argb,8,8,3)color(0.550,0.620,0.4,0.1)"],
		[2,"#(argb,8,8,3)color(0.550,0.620,0.4,0.1)"]
	];
	_green2 = [
		[0,"#(argb,8,8,3)color(0.56,0.62,0.4,0.07)"],
		[1,"#(argb,8,8,3)color(0.56,0.62,0.4,0.07)"],
		[2,"#(argb,8,8,3)color(0.56,0.62,0.4,0.07)"]
	];
	switch (true) do {
		case (toLower (worldName) isEqualTo "altis"): {_color = _darkGrey;};
		case (toLower (worldName) isEqualTo "tanoa"): {_color = _green2;};
		case (toLower (worldName) isEqualTo "malden"): {_color = _darkGrey;};
		case (toLower (worldName) isEqualTo "stratis"): {_color = _darkGrey;};
		case (toLower (worldName) isEqualTo "takistan"): {_color = _sandColor;};
		case (toLower (worldName) isEqualTo "fallujah"): {_color = _sandColor;};
		case (toLower (worldName) isEqualTo "lingor3"): {_color = _green1;};
		case (toLower (worldName) isEqualTo "dingor"): {_color = _sandColor;};
		case (toLower (worldName) isEqualTo "pja305"): {_color = _green1;};
		case (toLower (worldName) isEqualTo "sara"): {_color = _darkGrey;};
		case (toLower (worldName) isEqualTo "zargabad"): {_color = _sandColor;};
		case (toLower (worldName) isEqualTo "kunduz"): {_color = _sandColor;};
		case (toLower (worldName) isEqualTo "pja310"): {_color = _sandColor;};
		case (toLower (worldName) isEqualTo "xcam_taunus"): {_color = _green1;};
		case (toLower (worldName) isEqualTo "mog"): {_color = _sandColor;};
		case (toLower (worldName) isEqualTo "dya"): {_color = _sandColor;};
		case (toLower (worldName) isEqualTo "fata"): {_color = _sandColor;};
		case (toLower (worldName) isEqualTo "bornholm"): {_color = _green1;};
		case (toLower (worldName) isEqualTo "clafghan"): {_color = _sandColor;};
		case ((toLower (worldName) isEqualTo "napfwinter") || (toLower (worldName) isEqualTo "napf")): {_color = _darkGrey;};
		case (toLower (worldName) isEqualTo "kapaulio"): {_color = _green1;};
		case (toLower (worldName) isEqualTo "lythium"): {_color = _sandColor;};
		default {_color = [];};
	};
	if !(_color isEqualTo []) then {
		{_veh setObjectTextureGlobal _x;} forEach _color;
	};
};
add_UAV_crew = {
	// add crew to UAV/UGV.
	params ["_veh"];
	createVehicleCrew _veh;
};
add_veh_flare = {
	// add flares
	params ["_veh"];
	_veh addweapon "CMFlareLauncher";
	_veh addmagazine "120Rnd_CMFlare_Chaff_Magazine";
};
remove_veh_ti = {
	// remove vehicle thermal imaging
	params ["_veh"];
	_veh disableTIEquipment true;
};
INS_fold_wings = {
	params ["_veh"];
	_veh animate ["wing_fold_l", 1, true]; _veh animate ["wing_fold_r", 1, true];
};
INS_replace_pylons = {
	params ["_veh","_pylons"];
	private _pylonPaths = (configProperties [configFile >> "CfgVehicles" >> typeOf _veh >> "Components" >> "TransportPylonsComponent" >> "Pylons", "isClass _x"]) apply {getArray (_x >> "turret")};
	private _nonPylonWeapons = [];
	{ _nonPylonWeapons append getArray (_x >> "weapons") } forEach ([_veh, configNull] call BIS_fnc_getTurrets);
	{ _veh removeWeaponGlobal _x } forEach ((weapons _veh) - _nonPylonWeapons);
	{ _veh setPylonLoadOut [_forEachIndex + 1, _x, true, _pylonPaths select _forEachIndex] } forEach _pylons;
};
INS_noBTC_Logistics = {
	params ["_obj"];
	_obj setVariable ["BTC_cannot_lift",1,true];
	_obj setVariable ["BTC_cannot_drag",1,true];
	_obj setVariable ["BTC_cannot_load",1,true];
	_obj setVariable ["BTC_cannot_place",1,true];
};
INS_unilimitedAmmo = {
	params ["_wep"];
	_wep addeventhandler ["fired", {(_this select 0) setvehicleammo 1}];
};
fnc_ghst_build_positions = {
	/*
	Original code by Ghost. Modified by Jigsor to exclude exit positions, buildings listed in StructureBlackList and buildings with "_Pier" in classname.
	//building positions function for one building
	//_build_positions = _building call fnc_ghst_find_positions;
	*/
	private ["_i","_p","_b","_e","_type"];
	_i = 0;
	_b = [];
	_build_positions = [];
	_pIsEmpty = false;
	_type = typeof _this;

	while { ! _pIsEmpty } do {

		_e = _this buildingExit _i;
		_p = _this buildingPos _i;

		if (( str _p != "[0,0,0]" ) && !(_type in StructureBlackList) && !(_type find "_Pier" != -1) && !(_e isEqualTo _p)) then {
			_b pushback _p;
		}else{
			_pIsEmpty = true;
		};
		_i = _i + 1;
	};
	if ((count _b > 0) and !(isNil "_b")) then {
		_build_positions = _build_positions + _b;
	};

	_build_positions
};
fnc_ghst_rand_position = {
	/*
	//Find Random Position in a rectangle radius
	//_pos = [[1,1,2],[300,500,60]] call fnc_ghst_rand_position;
	//_pos = ["marker",[]] call fnc_ghst_rand_position;
	*/
	private ["_dir","_position_mark","_radx","_rady","_pos","_xpos","_ypos","_loop"];

	_pos_mark = _this select 0;//position or marker
	_radarray = _this select 1;//array of x,y radius and direction
	_wateronly = if (count _this > 2) then {_this select 2;} else {false;};//get position in water only

	if (typeName _pos_mark == typeName []) then {
		_position_mark = _pos_mark;//position array
		_radx = _radarray select 0;//radius A if position is Not a marker
		_rady = _radarray select 1;//radius B if position is Not a marker
		_dir = _radarray select 2;
		if (isNil "_dir") then {
			_dir = (random 360) * -1;//random direction if not given
		}else{
			_dir = (_radarray select 2) * -1;//specified direction
		};
	}else{
		_position_mark = (getmarkerpos _pos_mark);//getmarker position
		_radx = (getMarkerSize _pos_mark) select 0;//radius A if position is a marker
		_rady = (getMarkerSize _pos_mark) select 1;//radius b if position is a marker
		_dir = (markerDir _pos_mark) * -1;//Marker Direction
	};
	_loop = true;
	while {_loop} do {
		_rx = (random (_radx * 2)) - _radx;
		_ry = (random (_rady * 2)) - _rady;
		if (_dir != 0) then {
			_xpos = (abs(_position_mark select 0)) + ((cos _dir) * _rx - (sin _dir) * _ry);
			_ypos = (abs(_position_mark select 1)) + ((sin _dir) * _rx + (cos _dir) * _ry);
		}else{
			_xpos = (abs(_position_mark select 0)) + _rx;
			_ypos = (abs(_position_mark select 1)) + _ry;
		};
		_pos = [_xpos,_ypos,0];
		if (!_wateronly and !(surfaceIsWater [_pos select 0,_pos select 1])) then {_loop = false};
		if (_wateronly and (surfaceIsWater [_pos select 0,_pos select 1])) then {_loop = false};
	};
	_pos
};
JIG_issue_reward = {
	params ["_p"];
	if (side _p == INS_Blu_side) then {
		_pScore = 20;
		_p addrating 2000;
		_p addScore _pScore;
		paddscore = [_p, _pscore]; publicVariable "paddscore";
		[West,"HQ"] sideChat "+20 points";
		rewardp = getPlayerUID _p;
		publicVariable "rewardp";
		_destroyerName = name _p;
		_text = format [localize "STR_BMR_who_destroyed_ammocache",_destroyerName];
		[[_text],"JIG_MPsideChatWest_fnc"] call BIS_fnc_mp;
	}else{
		_pScore = -10;
		_p addScore _pScore;
		paddscore = [_p, _pscore]; publicVariable "paddscore";
		[East,"HQ"] sideChat "-10 points";
	};
};
JIG_ammmoCache_damage = {
	// Restrict damage to be taken only when satchel or charge used, delete cache box, add score to explosive setter, side chat who destroyed cache, add vehicle reward to cache destroyer. by Jigsor
    _cache = _this select 0;
    _damage = _this select 2;
    _source = _this select 3;
    _ammo = _this select 4;
    _out = 0;

    if ((_ammo == "satchelCharge_remote_ammo") ||
	(_ammo == "demoCharge_remote_ammo") ||
	(_ammo == "satchelCharge_remote_ammo_scripted") ||
	(_ammo == "demoCharge_remote_ammo_scripted") ||
	(_ammo == "LIB_Ladung_Small_ammo") ||
	(_ammo == "LIB_Ladung_Big_ammo") ||
	(_ammo == "LIB_US_TNT_4pound_ammo")) then {
        _cache spawn {
            sleep 0.1;
            _this setDamage 1;
            sleep 1;

			private ["_pos","_dur","_count","_veh","_bObj"];
			_pos = getPosATL(_this);
			_bObj = nearestBuilding _pos;
			[[_bObj, true], "allowDamage", false] call BIS_fnc_MP;

			//Block from Insurgency by Fireball, Kol9yN
			curTime	= time;
			_dur = 5 + random 5;
			deleteVehicle _this;
			"Bo_Air_LGB" createVehicle _pos;
			while{ (time - curTime) < _dur } do {
			_veh = "Bo_Air_LGB" createVehicle _pos;
			_veh setVectorDirAndUp [[(((random 1) -0.5) max 0.2),(((random 1) -0.5) max 0.2),(((random 1) -0.5) min 0.8)],[0,(random -1.5),(random 1) -0.5]];//Jig adding
			sleep random 1;
			};
			"Bo_Air_LGB" createVehicle _pos;
        };
		if (!isNull _source) then {
			[_source] spawn JIG_issue_reward;
		}else{
			//Reward compatibility fix for ACE explosives
			private _rpos = getPosATL _cache;
			[_rpos] spawn {
				params ["_pos"];
				private _uArr = _pos nearEntities ["CAManBase",100];
				{
					private _u = _x;
					if ((!isPlayer _u) || {(side _u == INS_Op4_side)}) then {
						_uArr = _uArr - [_u];
					};
				} forEach _uArr;
				if !(_uArr isEqualTo []) then {
					private _source = _uArr select 0;
					[_source] call JIG_issue_reward;
				};
			};
		};
	};
    _out
};
JIG_tower_damage = {
	// Restrict damage to be taken only when satchel or charge used, delete undamaged tower model, add score to explosive setter, side chat who destroyed tower. by Jigsor
    _tower = _this select 0;
    _damage = _this select 2;
    _source = _this select 3;
    _ammo = _this select 4;
    _out = 0;

	if ((_ammo == "satchelCharge_remote_ammo") || (_ammo == "demoCharge_remote_ammo") || (_ammo == "satchelCharge_remote_ammo_scripted") || (_ammo == "demoCharge_remote_ammo_scripted") || (_ammo == "LIB_Ladung_Small_ammo") || (_ammo == "LIB_Ladung_Big_ammo") || (_ammo == "LIB_US_TNT_4pound_ammo")) then {
        _tower spawn {
            sleep 0.1;
            _this setDamage 1;
            sleep 3;
            deleteVehicle _this;
        };
		if (!isNull _source) then {
			_destroyerName = name _source;
			_text = format [localize "STR_BMR_who_destroyed_tower",_destroyerName];
			[[_text],"JIG_MPsideChatWest_fnc"] call BIS_fnc_mp;
		};
    };
    _out
};
miss_object_pos_fnc = {
	// Objective position. by Jigsor
	params ["_cooX","_cooY","_dis","_wheX","_wheY","_ObjRandomPos","_empty","_goodPos","_newPos","_mkr"];

	_dis = 150;
	_wheX = random (_dis*2)-_dis;
	_wheY = random (_dis*2)-_dis;
	_ObjRandomPos = [_cooX+_wheX,_cooY+_wheY,0];
	_empty = [];
	_goodPos = [];
	_newPos = _ObjRandomPos isFlatEmpty [25,384,0.4,2,0,false,ObjNull];

	while {(count _newPos) < 1} do {
		_newPos = _ObjRandomPos isFlatEmpty [20,384,0.6,2,0,false,ObjNull];
		_dis = _dis + 50;
		_wheX = random (_dis*2)-_dis;
		_wheY = random (_dis*2)-_dis;
		_ObjRandomPos = [_cooX+_wheX,_cooY+_wheY,0];
		if (_dis > 550) exitWith {_goodPos = [];};
		sleep 0.5;
	};

	if (!(_newPos isEqualTo [])) then {
		if !(getMarkerType "tempObjMkr" isEqualTo "") then {deleteMarkerLocal "tempObjMkr";};
		_mkr = createMarkerLocal ["tempObjMkr", _newPos];
		_mkr setMarkerShapeLocal "ELLIPSE";
		"tempObjMkr" setMarkerSizeLocal [1, 1];
		"tempObjMkr" setMarkerShapeLocal "ICON";
		"tempObjMkr" setMarkerTypeLocal "mil_dot";//"EMPTY"
	};
	if (_newPos isEqualTo []) exitWith {_empty;};
	_newPos;
};
opfor_NVG = {
	// Add NVG to all existing enemy AI units by Jigsor.
	private _ai = allUnits;
	{if (isPlayer _x) then {_ai =_ai - [_x];};} count _ai;
	{
		if (side _x isEqualTo resistance) then {
			_x unlinkItem "NVGoggles_INDEP";
			_x linkItem "NVGoggles_INDEP";
		}else{
			if (side _x isEqualTo east) then {
				_x unlinkItem "NVGoggles_OPFOR";
				_x linkItem "NVGoggles_OPFOR";
			};
		};
		_x addPrimaryWeaponItem "acc_flashlight";
		_x enableGunLights "forceOn";//"AUTO"
	} forEach _ai;
};
editorAI_GasMask = {
	// Add Gas Masks to all existing AI units by Jigsor.
	private _ai = allUnits;
	{if (isPlayer _x) then {_ai =_ai - [_x];};} count _ai;
	{
		removeHeadgear _x;
		if (side _x isEqualTo resistance) then {_x addHeadgear "H_CrewHelmetHeli_I";};
		if (side _x isEqualTo east) then {_x addHeadgear "H_CrewHelmetHeli_O";};
		If (side _x isEqualTo west) then {_x addHeadgear "H_CrewHelmetHeli_B";};
	} count _ai;
};
JIPmkr_updateClient_fnc = {
	// Local client maker states update. by Jigsor
	_coloredMarkers=server getVariable "IntelMarkers";
	if (isNil {server getVariable "IntelMarkers"}) exitWith {};
	{
		_x setMarkerType (getMarkerType _x);
		_x setMarkercolor (getMarkercolor _x);
		_x setMarkerAlpha (MarkerAlpha _x);
	} forEach _coloredMarkers;
	true
};
curr_EOSmkr_states_fnc = {
	private ["_colorArr","_coloredEOSmkrs","_color"];
	_colorArr = [];
	_coloredEOSmkrs=server getVariable "EOSmarkers";
	{
		_color = getMarkercolor _x;
		_colorArr pushBack _color;
	} forEach _coloredEOSmkrs;
	server setVariable ["EOSmkrStates",_colorArr,true];
	true
};
find_bombee_fnc = {
	// Find suicide bomber player target. by Jigsor
	private ["_missionPlayers","_btarget","_bombeeSpeeding"];
	_btarget = ObjNull;
	_missionPlayers = playableUnits;

	{
		_bombeeSpeeding = (vectorMagnitudeSqr velocity _x > 8);
		_pos = (getPosATL _x);
		if ((_bombeeSpeeding) || (_pos select 2 > 3)) then {_missionPlayers = _missionPlayers - [_x];};
	} count _missionPlayers;// exclude players in moving vehicles, exclude above ground players such as players in aircraft or in high structures

	{if (side _x isEqualTo east) then {_missionPlayers = _missionPlayers - [_x];};} count _missionPlayers;// exclude east players

	if (count _missionPlayers > 0) then	{
		_btarget = selectRandom _missionPlayers;
	};
	_btarget
};
find_civ_bomber_fnc = {
	// Look for a suitable draftee by SupahG33K. Slightly modified by Jigsor.
	private ["_foundCiv","_civs","_closestEntity","_text","_draftee"];
	_draftee = ObjNull;
	if (isNull random_w_player4) exitWith {_draftee};
	_foundCiv = false;
	_civs = (position random_w_player4) nearEntities ["CAManBase",300];
	if (count _civs != 0) then {_civs deleteAt 0;};

	//Filter _civs array for CIVILIANS, take the closest one found
	{
		if (count _civs != 0) then {
			_closestEntity = _civs select 0;
			if ((side _closestEntity == CIVILIAN) && {(!isPlayer _closestEntity)}) then {
				_draftee = _closestEntity;
				_foundCiv = true;
				//diag_log text format ["SupahG33K - Civilian Jihadi Draftee found object: %1", _draftee];
				//_text = format ["SupahG33K - Civilian Jihadi Draftee found object: %1 class: %2", _draftee, typeOf _draftee]; [_text,"JIG_MPhint_fnc"] call BIS_fnc_mp;
			}else{
				_civs deleteAt 0;
			};
		};
		if(_foundCiv) exitWith{_foundCiv};
	} forEach _civs;
	_draftee
};
killed_ss_bmbr_fnc = {
	// Add suicide bomber evidence and chance of deadMan switch by SupahG33K
	// Add point/rating back to killer of civilian bomber. by Jigsor
	params ["_bmbr","_killer"];
	_pRating = rating _killer;// Jig adding low rating deterrent for killing innocent civilians.

	if (!isNull _killer) then {// no deadman switch if bomb detonates
		//SupahG33K - random deadMan-switch detonation. Small explosion when bomber killed (not full power)
		_detChance = floor(random 100);
		if((_detChance < 33) || (_pRating < 10000)) then {
			_bmbr spawn {
				_miniexplosive = selectRandom suicide_bmbr_deadman;
				_explosive = _miniexplosive createVehicle (position _this);
				sleep jig_tvt_globalsleep;
				_explosive setDamage 1;
			};
		};
	};

	//SupahG33K - Add small grenade to body for identification purposes
	_miniExplosiveEvidence = selectRandom suicide_bmbr_miniweps;
	_bmbr addItemToUniform _miniExplosiveEvidence;
	_bmbr addMagazines [_miniExplosiveEvidence,1];

	_pScore = 1;
	_killer addrating 1000;
	_killer addScore _pScore;
	paddscore = [_killer, _pscore]; publicVariable "paddscore";
	true
};
bmbrBuildPos = {
	params ["_posX","_posY","_debug"];
	private ["_found","_c","_repeat","_n","_build","_houses","_l","_r","_position"];
	_found = false;
	_c = 1;
	while {!_found && _c < 20} do {
		_houses = [_posX, _posY] nearObjects ["HouseBase", 150];
		//if (_debug) then {diag_log text format["Bomber building position placement %1 : %2", _c, _houses];};
		if (!isNil "_houses" && {(count _houses > 0)}) then {
			_n = count _houses;
			_i = floor(random _n);
			_build = (_houses select _i);
			_houses deleteAt _i;
			_l = _build call fnc_ghst_build_positions;
			_r = floor(random count _l);
			_position = _l select _r;
			_l deleteAt _r;
			if (!isnil "_position") exitwith {
				if (_debug) then {diag_log text format["Bomber Spawning building position : %1", _position];};
				_found = true;
			};
		};
		_c = _c + 1;
	};
	if (!_found) then {
		//if (_debug) then {diag_log "FAILED TO PLACE Bomber in Building";};
		_position = [0,0,0];
	};
	_position
};
bmbr_spawnpos_fnc = {
	// Suicide bomber random position. by Jigsor
	params ["_cooX","_cooY"];
	private ["_disX","_disY","_wheX","_wheY","_startPos","_empty","_goodPos","_c","_newPos","_mkr"];

	_disX = [130,240] call BIS_fnc_randomInt;
	_disY = [130,240] call BIS_fnc_randomInt;
	_wheX = random (_disX*2)-_disX;
	_wheY = random (_disY*2)-_disY;
	_startPos = [_cooX+_wheX,_cooY+_wheY,0];
	_empty = [];
	_goodPos = [];
	_c = 0;

	_newPos = _startPos isFlatEmpty [15,384,0.5,2,0,false,ObjNull];
	while {(count _newPos) < 1} do {
		_disX = [110,135] call BIS_fnc_randomInt;
		_disY = [110,135] call BIS_fnc_randomInt;
		_wheX = random (_disX*2)-_disX;
		_wheY = random (_disY*2)-_disY;
		_startPos = [_cooX+_wheX,_cooY+_wheY,0];
		_newPos = _startPos isFlatEmpty [10,384,0.7,2,0,false,ObjNull];
		_c = _c + 1;
		if (DebugEnabled > 0) then {hintSilent "finding suitable pos for sstBomber";};
		if (_c > 5) exitWith {_goodPos = [];};
		sleep 0.2;
	};

	if (!(_newPos isEqualTo [])) then {
		if !(getMarkerType "bomberMkr" isEqualTo "") then {deleteMarkerLocal "bomberMkr";};
		_mkr = createMarkerLocal ["bomberMkr", _newPos];
		_mkr setMarkerShapeLocal "ELLIPSE";
		"bomberMkr" setMarkerSizeLocal [1, 1];
		"bomberMkr" setMarkerShapeLocal "ICON";
		"bomberMkr" setMarkerTypeLocal "EMPTY";//"mil_dot"
	};

	if (_newPos isEqualTo []) exitWith {if (DebugEnabled > 0) then {hintSilent "suitable pos for sstBomber not found";}; _empty;};
	_newPos
};
spawn_Op4_grp = {
	// Creates infantry group. by Jigsor
	params ["_newZone","_grpSize","_grp","_unit_type","_unit","_damage"];
	_grp = createGroup INS_Op4_side;

	for "_i" from 0 to (_grpSize - 2) do {
		_unit_type = selectRandom INS_men_list;
		_unit = _grp createUnit [_unit_type, _newZone, [], 0, "NONE"];
		sleep 0.5;
	};
	_grp createUnit [INS_Op4_medic, _newZone, [], 0, "NONE"];
	sleep 0.5;

	(group _unit) setVariable ["zbe_cacheDisabled",false];
	if (BTC_p_skill isEqualTo 1) then {[_grp] call BTC_AI_init};

	{
		_x addeventhandler ["killed","[(_this select 0)] spawn remove_carcass_fnc"];
		if !(AIdamMod isEqualTo 1) then {
			_x removeAllEventHandlers "HandleDamage";
			_x addEventHandler ["HandleDamage",{_damage = (_this select 2)*AIdamMod;_damage}];
		};
		if (INS_op_faction isEqualTo 16) then {[_x] call Trade_Biofoam_fnc};
	} forEach (units _grp);

	_grp
};
spawn_Op4_StatDef = {
	// Static Gunner group creation and placements. by Jigsor
	params ["_newZone","_grpSize","_radius"];
	private ["_allGuns1","_interval","_assets","_randType","_circle","_startPos","_finalPos","_type","_static","_statGrp","_unitType","_allGuns2","_list1","_list2","_ranSel"];

	_assets = [];
	_allGuns1 = [];
	_allGuns2 = [];
	_interval = round(360/_grpSize);

	//add weighting/favored static guns
	_favored1 = (INS_Op4_stat_weps select 0);
	_favored2 = (INS_Op4_stat_weps select 1);
	_assets pushBack _favored1;
	_assets pushBack _favored2;

	if (_grpSize > 2) then {
		for "_i" from 0 to _grpSize do {
			_randType = selectRandom INS_Op4_stat_weps;
			_assets pushBack _randType;
		};
	};

	for "_circle" from 1 to 360 step _interval do {
		_startPos = [(_newZone select 0) + (sin(_circle)*_radius), (_newZone select 1) + (cos(_circle)*_radius), _newZone select 2];
		_type = _assets select 0;
		_assets deleteAt 0;

		if (isOnRoad _startPos) then {
			_finalPos = _startPos findEmptyPosition [2, 30, _type];
			if (_finalPos isEqualTo []) then {_finalPos = _startPos;};
		}else{
			_finalPos = _startPos;
		};

		_static = createVehicle [_type, _finalPos, [], 0, "NONE"];
		_static allowDamage false;
		_static modelToWorld _finalPos;
		_static setDir ([_newZone, _finalPos] call BIS_fnc_dirTo);
		_allGuns1 pushBack _static;
		_allGuns2 pushBack _static;
	};

	_statGrp = createGroup INS_Op4_side;

	for "_i" from 1 to _grpSize do {
		_unitType = selectRandom INS_men_list;
		_statGrp createUnit [_unitType, _newZone, [], 0, "NONE"];
	};

	if (BTC_p_skill isEqualTo 1) then {[_statGrp] call BTC_AI_init;};

	{
		_x addeventhandler ["killed", "[(_this select 0)] spawn remove_carcass_fnc"];
		if !(AIdamMod isEqualTo 1) then {
			_x removeAllEventHandlers "HandleDamage";
			_x addEventHandler ["HandleDamage", {_damage = (_this select 2)*AIdamMod;_damage}];
		};
		if (INS_op_faction isEqualTo 16) then {[_x] call Trade_Biofoam_fnc};
	} forEach (units _statGrp);

	objective_pos_logic setVariable ["INS_ObjectiveStatics", _allGuns1];

	{
		private _thisGun = (_allGuns2 select 0);
		_allGuns2 deleteAt 0;
		_thisGun setVectorUp [0,0,1];
		_thisGun allowDamage true;
		_x assignAsGunner _thisGun;
		_x moveInGunner _thisGun;
	} forEach (units _statGrp);

	_statGrp setCombatMode "RED";

	// Roof top placement
	if (_grpSize > 2) then {
		_list1 = [];
		_ranSel = selectRandom _allGuns1;
		_list1 pushBack _ranSel;

		[_list1,_newZone] spawn {
			params ["_array1","_sPos"];
			private _fail = false;
			[_array1,_sPos] call {
				if (!params [
					["_array1", [0]],
					["_sPos", [0,0,0]]
				]) exitWith {_fail = true;};
			};
			if (_sPos isEqualTo [0,0,0] || _fail) exitWith {if (DebugEnabled isEqualTo 1) then {diag_log format["RoofTop Static UnitArray: %1 Static Center %2", _array1, _sPos];};};
			if (DebugEnabled isEqualTo 1) then {diag_log "Attempting rooftop static placement";};

			sleep 2;
			nul = [_sPos, _array1, 110, 2, [0,33], true, false] execVM "scripts\SHK_buildingpos.sqf";
		};
	};

	_statGrp
};
INS_Tsk_GrpMkrs = {
	params ["_grp","_wpMkrArray","_mkr","_wpMkr","_cid","_newMkr"];
	_wpMkrArray = [];

	for "_i" from 1 to (count (waypoints _grp)) -1 do {
		_mkr = format["%1 WP%2", objective_pos_logic, _i];
		_wpMkr = createMarker [_mkr, getWPPos [_grp, _i]];
		_wpMkr setMarkerText _mkr;
		_wpMkr setMarkerType "waypoint";
		_wpMkrArray pushBack _wpMkr;
	};

	_cid = floor(random 1000);
	_mkr = format["Tsk Defence Grp_%1", _cid];
	_newMkr = createMarker [_mkr, (position leader _grp)];
	_newMkr setMarkerText _mkr;
	_newMkr setMarkerType "o_inf";

	while {alive leader _grp} do {
		_newMkr setMarkerPos (getPosWorld leader _grp);
		uiSleep 0.5;
	};
	deleteMarker _newMkr;
	{deleteMarker _x;} forEach _wpMkrArray;
};
Veh_taskPatrol_mod = {
	// BIS_fnc_taskPatrol modified by Demonized to fix some vehicle bugs not moving when speed or behaviour was not defined for each wp.
	_grp = _this select 0;
	_pos = _this select 1;
	_maxDist = _this select 2;

	for "_i" from 0 to (2 + (floor (random 3))) do {
		_newPos = [_pos, 50, _maxDist, 1, 0, 60 * (pi / 180), 0, []] call BIS_fnc_findSafePos;
		_wp = _grp addWaypoint [_newPos, 0];
		_wp setWaypointType "MOVE";
		_wp setWaypointSpeed "LIMITED";
		_wp setWaypointBehaviour "SAFE";
		_wp setWaypointFormation "COLUMN";//"STAG COLUMN"
		_wp setWaypointCompletionRadius 20;
	};

	_wp = _grp addWaypoint [_pos, 0];
	_wp setWaypointType "CYCLE";
	_wp setWaypointCompletionRadius 20;
	true
};
remove_charge_fnc = {
	// remove charge/satchel from ammo cache's cargo space by Jigsor.
	params ["_crate","_all_mags","_type"];
	_all_mags = magazineCargo _crate;
	{
		_type = [_x] call BIS_fnc_itemType;
		if ((_type select 1) == "mine") then {
			_all_mags = _all_mags - [_x];
		};
	} count _all_mags;
	clearMagazineCargoGlobal _crate;
	{_crate addMagazineCargoGlobal [_x, 1];} count _all_mags;
	//hint str (_all_mags);
	true
};
INS_MHQ_VarName = {
	params ["_veh"];
	INS_MHQ_killed = VehicleVarName _veh;
	publicVariable "INS_MHQ_killed";
	true
};
GAS_smoke_AIdamage = {
	// Give damage to AI not wearing gas mask in toxic smoke by Jigsor
	private ["_currPos","_aiArray","_sound","_odd"];
	_currPos = _this;
	_odd = 1;

	// loop time based on approximate life time of smoke grenade (21 seconds)
	for '_i' from 1 to 10 do {
		_aiArray = _currPos nearEntities [["CAManBase"],15];
		{if ((isPlayer _x) || (headgear _x in INS_gasMaskH) || (goggles _x in INS_gasMaskG)) then {_aiArray = _aiArray - [_x];};} count _aiArray;
		{
			if (_aiArray isEqualTo []) exitWith {};
			if (_odd isEqualTo 1) then {
				_sound = selectRandom Choke_Sounds;
				playsound3d [_sound, _x, false, getPosasl _x, 14,1,40];
				_odd = 2;
			}else{
				_odd = 1;
			};
			uiSleep (random 0.21);
			_x setDamage (damage _x + 0.14);
		} count _aiArray;
		uiSleep 2.1;
	};
	ToxicGasLoc = [];
};
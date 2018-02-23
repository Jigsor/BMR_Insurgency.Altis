/*
 execVM "scripts\ghst_PutinBuild.sqf";
 V2.5.2 - By Ghost - coord snippet is from DiRaven
 fills a random building around a position with all objects listed. best to keep radius small so not many buidlings need to be calculated
 Modified by Jigsor 9/29/2014. Modified mostly beginning and ending. The core is by Ghost. Creates and places Ammo Cache.
*/

if (!isServer) exitWith{};
sleep 2;

private _cache_loop = [] spawn
{
	private ["_all_caches_destroyed","_uncaped_eos_mkrs","_all_cache_types","_objtype","_ins_debug"];

	#define debug false//set to true for diag_log
	_all_caches_destroyed = false;
	cache_destroyed = true;
	_uncaped_eos_mkrs = all_eos_mkrs;
	_all_cache_types = cache_types;
	_objtype = _all_cache_types select 0;
	_ins_debug = if (DebugEnabled isEqualTo 1) then {TRUE}else{FALSE};

	"cache_destroyed" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
	"intel_Build_objs" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
	"all_intel_mkrs" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};

	for [{_loop=0}, {_loop<1}, {_loop=_loop}] do
	{
		if (_uncaped_eos_mkrs isEqualTo []) exitWith {diag_log text format ["All Ammo Caches destroyed: %1", _all_caches_destroyed]; _all_caches_destroyed = true;};
		while {!cache_destroyed} do {sleep 10;};
		sleep 5;

		if (count intel_Build_objs > 0) then
		{
			{
				if (!isNull _x) then {deleteVehicle _x; sleep 0.1};
			} count intel_Build_objs;
			intel_Build_objs = intel_Build_objs - intel_Build_objs;// empty array
			publicVariableServer "intel_Build_objs"; sleep 1;
		};

		{_x setMarkerAlpha 0; sleep 0.01} count all_intel_mkrs;
		{deleteMarker _x; sleep 0.1} count all_intel_mkrs;
		private _spam = allmapmarkers select {getMarkerType _x isEqualTo "hd_unknown";};
		{deleteMarker _x} count _spam;
		publicVariable "all_intel_mkrs";
		sleep 3;

		cache_destroyed = false;
		publicVariableServer "cache_destroyed";
		sleep 3;

		if (_ins_debug) then {titletext ["Creating Ammo Cache","plain down"];};

		private ["_all_cache_pos","_ammocache","_rnum","_veh_name","_VarName","_params_PutinBuild","_position_mark","_new_city","_radarray","_unitarray","_markunitsarray","_markunits","_mcolor","_msize","_markunitspos","_haveguards","_minguards","_maxguards","_sideguards","_jigcoor","_jigxcoor","_jigycoor","_cache_coor","_menlist","_nearBuildings","_loop","_p","_n","_i","_markname","_mark1","_nul","_egrp","_trig1stat","_trig1act","_trg1","_mkr_position","_activated_cache","_alive_cache","_curr_mkr","_buildObj"];

		{if (getMarkerColor _x isEqualTo "ColorGreen") then {_uncaped_eos_mkrs = _uncaped_eos_mkrs - [_x];};} count _uncaped_eos_mkrs;
		_curr_mkr = selectRandom _uncaped_eos_mkrs;
		_uncaped_eos_mkrs = _uncaped_eos_mkrs - [_curr_mkr];
		_mkr_position = getMarkerpos _curr_mkr;
		_rnum = str(round (random 999));

		_ammocache = createVehicle [_objtype , position air_pat_pos, [], 0, "NONE"];
		sleep jig_tvt_globalsleep;

		_ammocache addeventhandler ["handledamage",{_this call JIG_ammmoCache_damage}];

		_ammocache setVariable["persistent",true];
		_ammocache setVariable ["BTC_cannot_lift",1,true];
		_ammocache setVariable ["BTC_cannot_drag",1,true];
		_ammocache setVariable ["BTC_cannot_load",1,true];
		_ammocache setVariable ["BTC_cannot_place",1,true];
		if (INS_ACE_core) then {_ammocache setVariable ["ace_cookoff_enable", false, true]};

		[_ammocache] call remove_charge_fnc;

		_veh_name = getText (configFile >> "cfgVehicles" >> (_objtype) >> "displayName");
		_VarName = ("ammo_cache" + _rnum);
		_ammocache setVehicleVarName _VarName;

		missionNamespace setVariable [_VarName,_ammocache];
		publicVariable _VarName;
		sleep 1;

		_params_PutinBuild = [[_mkr_position],[100,100,0],[_ammocache],[true,"ColorOrange",[2,2],true],[6,10,EAST],0.5,true];

		_position_mark = _params_PutinBuild select 0;//position
			_new_city = _position_mark select (count _position_mark)-1;
		_radarray = _params_PutinBuild select 1;//radius array around position and Direction [300,300,53]
		_unitarray = _params_PutinBuild select 2;//object to be placed in building
		_markunitsarray = _params_PutinBuild select 3;
			_markunits = _markunitsarray select 0;
			_mcolor = _markunitsarray select 1;
			_msize = _markunitsarray select 2;// marker size 90
			_markunitspos = _markunitsarray select 3;
		_haveguards = _params_PutinBuild select 4;//guard array
			_minguards = _haveguards select 0;//how many guards min
			_maxguards = _haveguards select 1;//how many guards max
			_sideguards = _haveguards select 2;//marker size [50,50]
		//#define aiSkill _params_PutinBuild select 5//sets AI accuracy and aiming speed
		//#define debug _params_PutinBuild select 6//set to true for diag_log

		_cache_coor = _new_city;
		_jigcoor = _cache_coor;
		_jigxcoor = _jigcoor select 0;
		_jigycoor = _jigcoor select 1;

		//get all buildings around position of set radius
		private "_rad";

		if ((_radarray select 0) > (_radarray select 1)) then {_rad = (_radarray select 0);} else {_rad = (_radarray select 1);};

		_nearBuildings = [_jigxcoor,_jigycoor] nearObjects ["HouseBase", _rad];

		if (debug) then {diag_log format ["Number of Buildings: %1, Number of units in array: %2, Radius Array: %3, Radius for buildings: %4, Position for Buildings: %5", count _nearBuildings, count _unitarray, _radarray, _rad, _position_mark];};

		//Put specified objects in Buildings With Guards
		{
			private ["_selbuild","_position","_positionarray"];

			_loop = true;
			_p = 1;
			while {_loop} do {

				if (_nearBuildings isEqualTo []) exitwith {_loop = false};

				//select random building and remove from list
				_n = count _nearBuildings;
				_i = floor(random _n);
				_selbuild = (_nearBuildings select _i);
				_nearBuildings deleteAt _i;

				//get positions for selected building
				_positionarray = _selbuild call fnc_ghst_build_positions;

				_r = floor(random count _positionarray);
				_position = _positionarray select _r;
				_positionarray deleteAt _r;

				if !(isnil "_position") exitwith {_loop = false};

				if (debug) then {_p = _p + 1};
			};

			//debug
			if (debug) then {
				diag_log format ["Ran Position Loop %1 Times", _p];
				diag_log format ["BUILD POS ARRAY %1 BUILD POS SELECTED %2", _positionarray, _position];
			};

				if (isNil "_position") then {
					if (debug) then {diag_log format["FAILED TO PLACE OBJECT %1", _x];};

					_pos = [_cache_coor,_radarray] call fnc_ghst_rand_position;

					_x allowdamage false;
					_position = _pos findEmptyPosition[ 0 , 20 , typeof _x];
					_x setPosatl _position;
					//_x setFormDir (random 360);
					_x setFormDir 0;
					_x allowdamage true;
				} else {
					if (debug) then {diag_log format["PLACED OBJECT %1 POS %2", _x, _position];};
					_x allowdamage false;
					_x setPosatl [(_position select 0), (_position select 1), (_position select 2) + 0.5];
					//_x setFormDir (random 360);
					_x setFormDir 0;
					_x setUnitPos "UP";
					_x setVectorUP (surfaceNormal [(getPosATL _x) select 0,(getPosATL _x) select 1]);//adding
					_x allowdamage true;
				};

			//create markers for units
			if (_markunits) then {
				_pos = [_position,[_msize select 0,_msize select 1,(random 360)]] call fnc_ghst_rand_position;
				_markname = str(_pos);
				_mark1 = createMarker [_markname, _pos];
				_mark1 setMarkerShape "Ellipse";
				_mark1 setmarkersize _msize;
				_mark1 setmarkercolor _mcolor;//"ColorBlack";
				_mark1 setmarkerAlpha 0;//0 to hide marker
					if (_markunitspos) then {
					_mark1 setmarkertext format ["Ammo Cache:%1", _x];
					};

				_nul = [_x,_mark1] spawn {
					params ["_unit","_mark1"];

					while {alive _unit} do {
						sleep 5;
					};
					deletemarker _mark1;
				};
			};

			sleep 1;
		} foreach _unitarray;

		if (debug) then {diag_log "Objects put in buildings"};

		if (!isNull _ammocache) then {
			ghst_Build_objs pushBack _ammocache;

			_activated_cache = [];
			_activated_cache = _activated_cache + [ghst_Build_objs select (count ghst_Build_objs)-1];
			_cachepos = _activated_cache select 0;
			activated_cache_pos = getPos _cachepos;

			publicVariable "activated_cache_pos";
			sleep 3;

			private "_objmkr";
			if (_ins_debug) then {
				_objmkr = createMarker ["cachemkr", activated_cache_pos];
				"cachemkr" setMarkerShape "ELLIPSE";
				"cachemkr" setMarkerSize [1, 1];
				"cachemkr" setMarkerShape "ICON";
				"cachemkr" setMarkerType "mil_dot";
				"cachemkr" setMarkerColor "ColorRed";
				"cachemkr" setMarkerText "Ammo Cache";
			}else{
				_objmkr = createMarker ["cachemkr", activated_cache_pos];
				"cachemkr" setMarkerShape "ELLIPSE";
				"cachemkr" setMarkerSize [1, 1];
				"cachemkr" setMarkerShape "ICON";
				"cachemkr" setMarkerType "EMPTY";
			};

			// Disallow destruction of building ammo cache is placed in to avoid being buried.
			_buildObj = nearestBuilding activated_cache_pos;
			[[_buildObj, false], "allowDamage", false] call BIS_fnc_MP;
			sleep 1;

			[activated_cache_pos] execVM "scripts\ghst_PutinBuildIntel.sqf";
			// player setpos activated_cache_pos; // paste into debug console to teleport to ammo cache.

			_alive_cache = _activated_cache select 0;
			while {alive _alive_cache} do {
				sleep 4;
			};

			deleteMarker "cachemkr";
			(localize "STR_BMR_Cache_Destroyed") remoteExec ['JIG_MPhint_fnc', [0,-2] select isDedicated];
			cache_destroyed = true;
			publicVariable "cache_destroyed";
			sleep 3;
		}
		else
		{
			if (!isNil "cachemkr") then {deleteMarker "cachemkr";};
			(localize "STR_BMR_Cache_Destroyed") remoteExec ['JIG_MPhint_fnc', [0,-2] select isDedicated];
			cache_destroyed = true;
			publicVariable "cache_destroyed";
			sleep 3;
		};
	};
	if (_all_caches_destroyed) exitWith {};
};
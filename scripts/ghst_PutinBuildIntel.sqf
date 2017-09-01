/*
 [activated_cache_pos] execVM "scripts\ghst_PutinBuildIntel.sqf";
 V2.5.2 - By Ghost - coord snippet is from DiRaven
 fills a random building around a position with all objects listed. Best to keep radius small so not many buidlings need to be calculated.
 Modified by Jigsor. Last Edit 4/25/2016.//Adapted to spawn intel. Modified mostly beginning and ending. The core is by Ghost. Places Intel and creates intel location markers.
*/

if (!isServer) exitWith{};
if (EnemyAmmoCache isEqualTo 0) exitWith{};

private ["_cache_loop","_uncaped_eos_mkrs","_hide_intel","_current_cache","_uncaped_mkr_count","_total_intelObjs"];

current_cache_pos = _this select 0; publicVariable "current_cache_pos";
_all_cache_pos = [];
activated_cache = [];
_uncaped_eos_mkrs = all_eos_mkrs;
_hide_intel = Intel_Loc_Alpha;

if (DebugEnabled > 0) then {titletext ["Creating Intel","plain down"];};

"activated_cache" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
waitUntil {sleep 1; count ghst_Build_objs > 0};

if (!(activated_cache isEqualTo [])) then {activated_cache = [];publicVariable "activated_cache";sleep 3;};

activated_cache = activated_cache + [ghst_Build_objs select (count ghst_Build_objs)-1];
publicVariable "activated_cache";
sleep 2;

if ([activated_cache] in _all_cache_pos) exitWith {};

if (!([activated_cache] in _all_cache_pos)) then {_all_cache_pos pushBack activated_cache;};
_current_cache = activated_cache select 0;

{if (getMarkerColor _x == "ColorGreen") then {_uncaped_eos_mkrs = _uncaped_eos_mkrs - [_x];};} foreach _uncaped_eos_mkrs;
_uncaped_mkr_count = (count _uncaped_eos_mkrs);
_total_intelObjs = (round(_uncaped_mkr_count/Intel_Count));//total max suitcases per ammo cache

_cache_loop = [_uncaped_eos_mkrs,_hide_intel,_current_cache,_uncaped_mkr_count,_total_intelObjs] spawn
{
	private ["_nearBuildings","_all_cache_pos","_intel","_rnum","_objtype","_intel_types","_imks","_veh_name","_VarName","_params_PutinBuild","_position_mark","_intel_coor_selection","_radarray","_unitarray","_markunitsarray","_markunits","_mcolor","_msize","_markunitspos","_jigxcoor","_jigycoor","_intel_coor","_loop","_p","_n","_i","_markname","_mark1","_nul","_unit1","_mkr_position","_iobj","_current_cache","_total_intelObjs","_hide_intel","_uncaped_eos_mkrs","_current_cache","_debug","_uncaped_mkr_count","_total_intelObjs"];

	_uncaped_eos_mkrs = _this select 0;
	_hide_intel = _this select 1;
	_current_cache = _this select 2;
	_uncaped_mkr_count = _this select 3;
	_total_intelObjs = _this select 4;
	_iobj = 0;
	_intel_types = ["Land_Suitcase_F","Land_Laptop_unfolded_F","Land_PortableLongRangeRadio_F","Land_SurvivalRadio_F"];
	_objtype = _intel_types select 0;
	_imks = [];
	#define _debug false//set true for diag_log

	while {((_iobj < _total_intelObjs) and (_iobj < _uncaped_mkr_count)) and alive _current_cache} do
	{
		_curr_mkr = selectRandom _uncaped_eos_mkrs;
		if (_debug) then {diag_log format ["Current Marker %1", _curr_mkr];};
		_mkr_position = getMarkerpos _curr_mkr;
		_rnum = str(round (random 9999));

		_intel = createVehicle [_objtype , position air_pat_pos, [], 0, "CAN_COLLIDE"];
		sleep jig_tvt_globalsleep;

		_intel allowDamage false;
		_intel setVariable["persistent",true];
		_veh_name = getText (configFile >> "cfgVehicles" >> (_objtype) >> "displayName");
		_VarName = ("ghst_obj" + _rnum);
		_intel setVehicleVarName _VarName;
		missionNamespace setVariable [_VarName,_intel];
		publicVariable _VarName;
		sleep 0.3;

		_params_PutinBuild = [[_mkr_position],[50,50,0],[_intel],[true,"ColorBlack",[3,3],true],false];

		_position_mark = _params_PutinBuild select 0;//position
		_intel_coor_selection = _position_mark select (count _position_mark)-1;
		_radarray = _params_PutinBuild select 1;//radius array around position and Direction [30,30,0]
		_unitarray = _params_PutinBuild select 2;//object to be placed in building
		_markunitsarray = _params_PutinBuild select 3;
			_markunits = _markunitsarray select 0;
			_mcolor = _markunitsarray select 1;
			_msize = _markunitsarray select 2;// marker size 3
			_markunitspos = _markunitsarray select 3;
		//#define _debug _params_PutinBuild select 4//set to true for diag_log

		_intel_coor = _intel_coor_selection;
		_jigxcoor = _intel_coor select 0;
		_jigycoor = _intel_coor select 1;

		//get all buildings around position of set radius
		private "_rad";

		if ((_radarray select 0) > (_radarray select 1)) then {_rad = (_radarray select 0);} else {_rad = (_radarray select 1);};

		_nearBuildings = [_jigxcoor,_jigycoor] nearObjects ["HouseBase", _rad];
		if (_nearBuildings isEqualTo []) then {_nearBuildings = [] + [(nearestBuilding [_jigxcoor,_jigycoor])];};//Jig adding

		if (_debug) then {diag_log format ["Number of Buildings: %1, Number of units in array: %2, Radius Array: %3, Radius for buildings: %4, Position for Buildings: %5", count _nearBuildings, count _unitarray, _radarray, _rad, _position_mark];};

		//Put specified objects in Buildings
		{
			private ["_selbuild","_position","_posArr"];

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
				_posArr = _selbuild call fnc_ghst_build_positions;

				_r = floor(random count _posArr);
				_position = _posArr select _r;
				_posArr deleteAt _r;

				if !(isnil "_position") exitwith {_loop = false};

				if (_debug) then {_p = _p + 1};
			};

			//_debug
			if (_debug) then {
				diag_log format ["Ran Position Loop %1 Times", _p];
				if !(isNil "_position") then {
					diag_log format ["BUILD POS ARRAY %1 BUILD POS SELECTED %2", _posArr, _position];
				}else{
					diag_log format["FAILED TO PLACE OBJECT %1", _x];
				};
			};

			//Jig adding redundancy for invalid or troublesome building positions.
			private ["_safepos","_dis","_b_pos"];
			if (isNil "_position") then {
				//"house_c_4_ep1","a_mosque_big_wall_ep1","House_C_11_EP1"
				if (typeof (nearestBuilding _intel_coor) == "Land_Pier_small_F") then {
					_dis = 100;
					_safepos = [_intel_coor, 30, _dis, 1, 0, 0.8, 0] call BIS_fnc_findSafePos;
				};
				if !(isNil "_safepos") then {
					_b_pos = _safepos;
				}else{
					_b_pos = [_intel_coor,_radarray] call fnc_ghst_rand_position;
					if (isNil "_b_pos") then {
						_b_pos = _intel_coor findEmptyPosition[ 0 , 20 , typeof _x];
					};
				};
				_position = _b_pos;

				_x allowdamage false;
				_x setPosatl [(_position select 0), (_position select 1), 0.5];
				_x setFormDir 0;
				_x setUnitPos "UP";
				_x setVectorUP (surfaceNormal [(getPosATL _x) select 0,(getPosATL _x) select 1]);
			} else {
				if (_debug) then {diag_log format["PLACED OBJECT %1 POS %2", _x, _position];};
				_x allowdamage false;
				_x setPosatl [(_position select 0), (_position select 1), (_position select 2) + 0.5];
				_x setFormDir 0;
				_x setUnitPos "UP";
				_x setVectorUP (surfaceNormal [(getPosATL _x) select 0,(getPosATL _x) select 1]);
			};

			//create markers for units
			if (_markunits) then {
				_pos = [_position,[_msize select 0,_msize select 1,(random 360)]] call fnc_ghst_rand_position;
				_markname = str(_pos);
				_mark1 = createMarker [_markname, _pos];
				_mark1 setMarkerShape "Ellipse";
				_mark1 setmarkersize _msize;
				_mark1 setmarkercolor _mcolor;//"ColorBlack";
				_mark1 setmarkerAlpha _hide_intel;//hide intel location markers
					if (_markunitspos) then {
					_mark1 setmarkertext format ["Intel obj%1", _x];
					};

				if (_hide_intel isEqualTo 1) then {_imks pushBack [_x,_mark1];};
			};
			sleep 0.1;
		} foreach _unitarray;

		if (_debug) then {diag_log "Objects put in buildings"};

		if (!isNull _intel) then
		{
			_uncaped_eos_mkrs = _uncaped_eos_mkrs - [_curr_mkr];

			//attaches addaction to intel object
			[[_intel,current_cache_pos],"fnc_mp_intel",WEST] spawn BIS_fnc_MP;

			if (ObjNull in intel_Build_objs) then {{intel_Build_objs = intel_Build_objs - [objNull]} foreach intel_Build_objs;};
			intel_Build_objs pushBack _intel;
			_iobj = _iobj + 1;
		};
	};

	if (DebugEnabled > 0) then {titletext ["Spawning Intel Complete","plain down"];};

	if (_hide_intel isEqualTo 1) then {
		_nul = [_imks] spawn {
			params ["_arr"];
			while {count _arr > 0} do {
				{
					private ["_o","_m"];
					_o = (_x select 0);
					_m = (_x select 1);
					if (!alive _o) then {
						deletemarker _m;
						_arr = _arr - [_x];
					};
				} forEach _arr;
				uiSleep 10;
			};
		};
	};

	publicVariableServer "intel_Build_objs";
	sleep 3;

	if (true) exitwith {};
};
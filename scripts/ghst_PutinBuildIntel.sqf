/*
 [activated_cache_pos] execVM "scripts\ghst_PutinBuildIntel.sqf";
 V2.5.2 - By Ghost - coord snippet is from DiRaven
 fills a random building around a position with all objects listed. Best to keep radius small so not many buidlings need to be calculated.
 Modified by Jigsor. Last Edit 10/6/2018.//Adapted to spawn intel. Modified mostly beginning and ending. The core is by Ghost. Places Intel and creates intel location markers.
*/

if (!isServer) exitWith{};
if (EnemyAmmoCache isEqualTo 0) exitWith{};

current_cache_pos = _this select 0; publicVariable "current_cache_pos";
private _all_cache_pos = [];
activated_cache = [];
private _uncaped_eos_mkrs = all_eos_mkrs;
private _hide_intel = Intel_Loc_Alpha;

if (DebugEnabled > 0) then {titleText ["Creating Intel","PLAIN DOWN"]};

"activated_cache" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
waitUntil {sleep 1; count ghst_Build_objs > 0};

if !(activated_cache isEqualTo []) then {activated_cache = [];publicVariable "activated_cache";sleep 3;};

activated_cache = activated_cache + [ghst_Build_objs select (count ghst_Build_objs)-1];
publicVariable "activated_cache";
sleep 2;

if ([activated_cache] in _all_cache_pos) exitWith {};

if !([activated_cache] in _all_cache_pos) then {_all_cache_pos pushBack activated_cache};
private _current_cache = activated_cache select 0;

{if (getMarkerColor _x isEqualTo "ColorGreen") then {_uncaped_eos_mkrs = _uncaped_eos_mkrs - [_x];};} foreach _uncaped_eos_mkrs;
private _uncaped_mkr_count = (count _uncaped_eos_mkrs);
private _total_intelObjs = (round(_uncaped_mkr_count/Intel_Count));//total max suitcases per ammo cache

private _cache_loop = [_uncaped_eos_mkrs,_hide_intel,_current_cache,_uncaped_mkr_count,_total_intelObjs] spawn
{
	params ["_uncaped_eos_mkrs","_hide_intel","_current_cache","_uncaped_mkr_count","_total_intelObjs"];
	private ["_nearBuildings","_intel","_strNum","_displayName","_VarName","_mkrPos","_radarray","_unitarray","_markunits","_mcolor","_msize","_markunitspos","_jigxcoor","_jigycoor","_loop","_p","_n","_i","_markname","_mkr","_current_cache"];

	private _iobj = 0;
	private _intel_types = ["Land_Suitcase_F","Land_Laptop_unfolded_F","Land_PortableLongRangeRadio_F","Land_SurvivalRadio_F"];
	private _objtype = _intel_types select 0;
	private _createPos = position air_pat_pos;
	private _imks = [];
	private _displayName = getText (configFile >> "cfgVehicles" >> (_objtype) >> "displayName");
	#define _debug false//set true for diag_log

	while {((_iobj < _total_intelObjs) && (_iobj < _uncaped_mkr_count)) && alive _current_cache} do
	{
		_curr_mkr = selectRandom _uncaped_eos_mkrs;
		if (_debug) then {diag_log format ["Current Marker %1", _curr_mkr]};
		_strNum = str(_iobj);

		_intel = createVehicle [_objtype, _createPos, [], 0, "CAN_COLLIDE"];
		sleep jig_tvt_globalsleep;

		_intel allowDamage false;
		_intel setVariable["persistent",true];
		_VarName = ("intel" + _strNum);
		_intel setVehicleVarName _VarName;
		missionNamespace setVariable [_VarName,_intel];
		publicVariable _VarName;
		sleep 0.3;

		_mkrPos = getMarkerpos _curr_mkr;//position
		_radarray = [50,50,0];//radius array around position and Direction [30,30,0]
		_unitarray = [_intel];//object to be placed in building
		_markunits = true;
		_mcolor = "ColorBlack";
		_msize = [3,3];// marker size 3
		_markunitspos = true;
		_jigxcoor = _mkrPos select 0;
		_jigycoor = _mkrPos select 1;

		//get all buildings around position of set radius
		private "_rad";

		if ((_radarray select 0) > (_radarray select 1)) then {_rad = (_radarray select 0);} else {_rad = (_radarray select 1);};

		_nearBuildings = [_jigxcoor,_jigycoor] nearObjects ["HouseBase", _rad];
		if (_nearBuildings isEqualTo []) then {_nearBuildings = [] + [(nearestBuilding [_jigxcoor,_jigycoor])]};//Jig adding

		if (_debug) then {diag_log format ["Number of Buildings: %1, Number of units in array: %2, Radius Array: %3, Radius for buildings: %4, Position for Buildings: %5", count _nearBuildings, count _unitarray, _radarray, _rad, _mkrPos]};

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

			// Usefull debug info
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
				if (typeof (nearestBuilding _mkrPos) == "Land_Pier_small_F") then {
					_dis = 100;
					_safepos = [_mkrPos, 30, _dis, 1, 0, 0.8, 0] call BIS_fnc_findSafePos;
				};
				if !(isNil "_safepos") then {
					_b_pos = _safepos;
				}else{
					_b_pos = [_mkrPos,_radarray] call fnc_ghst_rand_position;
					if (isNil "_b_pos") then {
						_b_pos = _mkrPos findEmptyPosition[ 0 , 20 , typeof _x];
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
				_mkr = createMarker [_markname, _pos];
				_mkr setMarkerShape "Ellipse";
				_mkr setmarkersize _msize;
				_mkr setmarkercolor _mcolor;//"ColorBlack";
				_mkr setmarkerAlpha _hide_intel;//hide intel location markers
				if (_markunitspos) then {_mkr setmarkertext format ["Intel obj%1", _x]};
				if (_hide_intel isEqualTo 1) then {_imks pushBack [_x,_mkr]};
			};
			sleep 0.1;
		} foreach _unitarray;

		if (_debug) then {diag_log "Objects put in buildings"};

		if (!isNull _intel) then {
			_uncaped_eos_mkrs = _uncaped_eos_mkrs - [_curr_mkr];

			//attach addaction to intel object
			[_intel,current_cache_pos] remoteExec ['fnc_mp_intel',WEST];

			if (ObjNull in intel_Build_objs) then {{intel_Build_objs = intel_Build_objs - [objNull]} foreach intel_Build_objs;};
			intel_Build_objs pushBack _intel;
			_iobj = _iobj + 1;
		};
	};

	if (DebugEnabled > 0) then {titleText ["Spawning Intel Complete","PLAIN DOWN"]};

	if (_hide_intel isEqualTo 1) then {
		_nul = [_imks] spawn {
			params ['_arr'];
			while {!(_arr isEqualTo [])} do {
				{
					private ['_o','_m'];
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
};
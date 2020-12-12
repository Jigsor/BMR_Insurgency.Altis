// AirPatrole_Fncs.sqf all functions by Jigsor
RandomAirCenterOp4 = {
	//Find random center position for air patrol
	private ["_westbase1","_whitelist1","_whitelist2","_whitelist3","_nearestMkr","_AirWP_span","_dis","_dirTo","_startPos","_maxDis","_minDis","_newPos"];

	_westbase1 = markerPos "Respawn_West";
	_whitelist1 = markerPos "airWhiteList1";
	_whitelist2 = markerPos "airWhiteList2";
	_whitelist3 = markerPos "airWhiteList3";
	_nearestMkr = ([[_westbase1,_whitelist1,_whitelist2,_whitelist3],[],{center distance2d _x},"ASCEND"] call BIS_fnc_sortBy) select 0;
	_AirWP_span = 3500;

	_dis = _nearestMkr distance2d center;
	if (_dis < 4002) then {
		_dirTo = _nearestMkr getDir center;
		_startPos = [(getPosATL center select 0) + (_AirWP_span * sin _dirTo), (getPosATL center select 1) + (_AirWP_span * cos _dirTo), 0];
	}else{
		_startPos = getPosATL center;
	};

	_maxDis = _dis - _AirWP_span;
	_minDis = round (random _maxDis);
	_newPos = [_startPos, _minDis, _maxDis, 10, 0, 0.7, 0] call BIS_fnc_findSafePos;

	_newPos
};
Air_Dest_fnc = {
	//creates 3 markerks in triangle -- "cyclewpmrk", "spawnaire" "spawnairw" and one in center of triangle -- "aomkr"
	// center logic object is air_pat_pos. Other logics for each other way point markers are placed around center logic
	private ["_AirWP_span","_air_pat_pos","_posHpad","_posnewAO","_currentmarker","_wpcyclemark","_spwnaire","_spwnairepos","_spwnairedir","_spwnairw","_spwnairwpos","_spwnairwdir","_spwnairdire","_spwnairenewdir","_spwnairdirw","_spwnairwnewdir"];
	_AirWP_span = 3500;
	_air_pat_pos = getPosATL air_pat_pos;
	_posHpad = [_air_pat_pos # 0, _air_pat_pos # 1];
	if (!isNil "aomkr") then
	{
		_posnewAO = [ markerPos "aomkr" # 0, markerPos "aomkr" # 1];
		if (_posHpad distance _posnewAO isEqualTo 0) exitwith {};
		if !(_posHpad distance _posnewAO isEqualTo 0) then {
			sleep 0.2;
			deleteMarker "aomkr";
			_currentmarker = createMarker ["aomkr", _air_pat_pos];
			_currentmarker setMarkerShape "ELLIPSE";
			"aomkr" setMarkerSize [1, 1];
			"aomkr" setMarkerShape "ICON";
			"aomkr" setMarkerType "Empty";//"mil_dot"
			"aomkr" setMarkerColor "ColorRed";
			"aomkr" setMarkerText "Enemy Occupied";
			"aomkr" setMarkerPos _air_pat_pos;

			if (!isNil "cyclewpmrk") then {deleteMarker "cyclewpmrk"};
			_wpcyclemark = createMarker ["cyclewpmrk", _air_pat_pos];
			_wpcyclemark setMarkerShape "ELLIPSE";
			"cyclewpmrk" setMarkerSize [1, 1];
			"cyclewpmrk" setMarkerShape "ICON";
			"cyclewpmrk" setMarkerType "Empty";//"mil_dot"
			"cyclewpmrk" setMarkerColor "ColorRed";
			"cyclewpmrk" setMarkerText "WPcycle";
			"cyclewpmrk" setMarkerPos [(markerPos "aomkr" select 0) + (_AirWP_span * sin floor(random 360)), (markerPos "aomkr" select 1) + (_AirWP_span * cos floor(random 360)), 0];//cycle waypoint distance is _AirWP_span meters from AO marker

			air_pat_cycle setPosATL markerPos "cyclewpmrk";
			if (!isNil "spawnaire") then {deleteMarker "spawnaire"};
			_spwnaire = createMarker ["spawnaire", _air_pat_pos];
			_spwnaire setMarkerShape "ELLIPSE";
			_spwnairepos = markerPos "cyclewpmrk";
			_spwnairedir = _spwnairepos getDir air_pat_pos;
			"spawnaire" setMarkerSize [1, 1];
			"spawnaire" setMarkerShape "ICON";
			"spawnaire" setMarkerType "Empty";//"mil_dot"
			"spawnaire" setMarkerColor "ColorRed";
			"spawnaire" setMarkerText "SpawnAirEst";
			"spawnaire" setMarkerPos [(markerPos "aomkr" select 0) + (_AirWP_span * sin (_spwnairedir -300)), (markerPos "aomkr" select 1) + (_AirWP_span * cos (_spwnairedir -300)), 0];//East Air spawn point distance is _AirWP_span meters from AO marker
			_spwnairdire = markerPos "spawnaire";
			_spwnairenewdir = _spwnairdire getDir air_pat_pos;
			"spawnaire" setMarkerDir _spwnairenewdir;//point marker direction towards aomkr

			air_pat_east setPosATL markerPos "spawnaire";
			air_pat_east setDir _spwnairenewdir;
			if (!isNil "spawnairw") then {deleteMarker "spawnairw"};
			_spwnairw = createMarker ["spawnairw", _air_pat_pos];
			_spwnairw setMarkerShape "ELLIPSE";
			"spawnairw" setMarkerSize [1, 1];
			"spawnairw" setMarkerShape "ICON";
			"spawnairw" setMarkerType "Empty";//"mil_dot"
			"spawnairw" setMarkerColor "ColorRed";
			"spawnairw" setMarkerText "Retreat";
			"spawnairw" setMarkerPos [(markerPos "aomkr" select 0) + (_AirWP_span * sin (_spwnairedir -60)), (markerPos "aomkr" select 1) + (_AirWP_span * cos (_spwnairedir -60)), 0];//East Air spawn point distance is _AirWP_span meters from AO marker
			_spwnairdirw = markerPos "spawnairw";
			_spwnairwnewdir = _spwnairdirw getDir air_pat_pos;
			"spawnairw" setMarkerDir _spwnairwnewdir;//point marker direction towards aomkr

			air_pat_west setPosATL markerPos "spawnairw";
			air_pat_west setDir _spwnairwnewdir;
		};
	} else {
		if (isNil "aomkr") then {
			_currentmarker = createMarker ["aomkr", _air_pat_pos];
			_currentmarker setMarkerShape "ELLIPSE";
			"aomkr" setMarkerSize [1, 1];
			"aomkr" setMarkerShape "ICON";
			"aomkr" setMarkerType "Empty";
			"aomkr" setMarkerColor "ColorRed";
			"aomkr" setMarkerText "Enemy Occupied";
			"aomkr" setMarkerPos _air_pat_pos;

			_wpcyclemark = createMarker ["cyclewpmrk", _air_pat_pos];
			_wpcyclemark setMarkerShape "ELLIPSE";
			"cyclewpmrk" setMarkerSize [1, 1];
			"cyclewpmrk" setMarkerShape "ICON";
			"cyclewpmrk" setMarkerType "Empty";
			"cyclewpmrk" setMarkerColor "ColorRed";
			"cyclewpmrk" setMarkerText "WPcycle";
			"cyclewpmrk" setMarkerPos [(markerPos "aomkr" select 0) + (_AirWP_span * sin floor(random 360)), (markerPos "aomkr" select 1) + (_AirWP_span * cos floor(random 360)), 0];//cycle waypoint distance is _AirWP_span meters from AO marker

			air_pat_cycle setPosATL markerPos "cyclewpmrk";
			_spwnaire = createMarker ["spawnaire", _air_pat_pos];
			_spwnaire setMarkerShape "ELLIPSE";
			_spwnairepos = markerPos "cyclewpmrk";
			_spwnairedir = _spwnairepos getDir air_pat_pos;
			"spawnaire" setMarkerSize [1, 1];
			"spawnaire" setMarkerShape "ICON";
			"spawnaire" setMarkerType "Empty";
			"spawnaire" setMarkerColor "ColorRed";
			"spawnaire" setMarkerText "SpawnAirEst";
			"spawnaire" setMarkerPos [(markerPos "aomkr" select 0) + (_AirWP_span * sin (_spwnairedir -300)), (markerPos "aomkr" select 1) + (_AirWP_span * cos (_spwnairedir -300)), 0];//East Air spawn point distance is _AirWP_span meters from AO marker
			_spwnairdire = markerPos "spawnaire";
			_spwnairenewdir = _spwnairdire getDir air_pat_pos;
			"spawnaire" setMarkerDir _spwnairenewdir;//point marker direction towards aomkr

			air_pat_east setPosATL markerPos "spawnaire";
			air_pat_east setDir _spwnairenewdir;
			_spwnairw = createMarker ["spawnairw", _air_pat_pos];
			_spwnairw setMarkerShape "ELLIPSE";
			"spawnairw" setMarkerSize [1, 1];
			"spawnairw" setMarkerShape "ICON";
			"spawnairw" setMarkerType "Empty";
			"spawnairw" setMarkerColor "ColorRed";
			"spawnairw" setMarkerText "Retreat";
			"spawnairw" setMarkerPos [(markerPos "aomkr" select 0) + (_AirWP_span * sin (_spwnairedir -60)), (markerPos "aomkr" select 1) + (_AirWP_span * cos (_spwnairedir -60)), 0];//East Air spawn point distance is _AirWP_span meters from AO marker
			_spwnairdirw = markerPos "spawnairw";
			_spwnairwnewdir = _spwnairdirw getDir air_pat_pos;
			"spawnairw" setMarkerDir _spwnairwnewdir;//point marker direction towards aomkr

			air_pat_west setPosATL markerPos "spawnairw";
			air_pat_west setDir _spwnairwnewdir;
		};
	};
	true
};
AirEast_move_logic_fnc = {
	private _ranAEguard = getPos EastAirLogic;
	private _lastpos = markerPos "curAEspawnpos";
	if (_ranAEguard distance2D _lastpos > 1) then {
		EastAirLogic setPos markerPos "spawnaire";
		if !(getMarkerColor "curAEspawnpos" isEqualTo "") then {deleteMarker "curAEspawnpos"};
		private _currentmarker = createMarker ["curAEspawnpos", getPosATL EastAirLogic];
		_currentmarker setMarkerShape "ELLIPSE";
		"curAEspawnpos" setMarkerSize [2, 2];
		"curAEspawnpos" setMarkerShape "ICON";
		"curAEspawnpos" setMarkerType "Empty";//"mil_dot"
		"curAEspawnpos" setMarkerColor "ColorOrange";
		publicVariable "curAEspawnpos";
	};
	true
};
find_west_target_fnc = {
	// based on example by Mattar_Tharkari in BIS community forums http://forums.bistudio.com/showthread.php?145573-How-to-make-AI-vehicle-follow-chase-players/page2
	private ["_vcl","_dis","_hunted","_future_time","_delay","_wpRad","_cfgMapSize","_sqrt","_mh","_patrolRad","_towns","_r","_randomTownPos","_wpArray","_i","_wp1","_nrstWTgts","_cntrPos"];

	_vcl = _this # 0;
	_dis = _this # 1;//search distance
	_hunted = _this # 2;
	_future_time = time + AirRespawnDelay + 120;
	if (typeOf _vcl in INS_Op4_helis) then {
		_delay = 30;
		_wpRad = selectRandom [12,24,36,48,60];
	} else {
		_delay = 90;
		_wpRad = floor linearConversion [0, 1, random 1, 50 min 150, 150 max 50 + 1];
	};

	_cfgMapSize = getnumber (configfile >> "CfgWorlds" >> worldName >> "mapSize");
	if ((!isNil "_cfgMapSize") && {(_cfgMapSize != 0)}) then {
		_sqrt = sqrt 2;
		_mh = _cfgMapSize / _sqrt;
		_patrolRad = round(_mh / 2);
	}else{
		_patrolRad = 10000;
	};
	_towns = nearestLocations [getPosATL CENTER, ["NameVillage","NameCity","NameCityCapital"], _patrolRad];

	//movement loop
	while {alive _vcl} do {
		//remove all previous wayPoints
		_wpArray = wayPoints (group _vcl);
		for "_i" from 0 to (count _wpArray -1) do {
			deleteWaypoint [(group _vcl), _i]
		};

		//add 1 WP it's all you need
		_wp1 = (group _vcl) addWaypoint [(getPos _vcl), 0];
		_wp1 setWaypointType "MOVE";

		if ((PatroleWPmode isEqualTo 0) || (isNull _hunted)) then {
// Seek N Destroy

			if ((isNull _hunted) || (_vcl distance _hunted > _dis)) then {
				_vcl setVehicleAmmo 1;
				_vcl setFuel 1;

				_nrstWTgts = [];
				{_nrstWTgts pushBack _x} forEach ((position _vcl) nearEntities [["Air","CAManBase"], _dis] select {((captiveNum _x isEqualTo 0) || (lifeState _x isEqualTo "HEALTHY") || (lifeState _x isEqualTo "INJURED") || (_x getVariable ["ACE_isUnconscious", false])) && (side _x isEqualTo west)});

				_cntrPos =  getPos (_nrstWTgts # 0);
				if (!(_nrstWTgts isEqualTo []) && {(format ["%1", _cntrPos] != "[0,0,0]")}) then {
					//chase enemy if exist and have valid position
					_wp1 setWaypointPosition [_cntrPos, _wpRad];
					(group _vcl) setCurrentWaypoint _wp1;

					{
						_x forgetTarget (_nrstWTgts # 0);
						_x reveal [(_nrstWTgts # 0), 4];
					} forEach (units group _vcl);

					private _chance = floor(random 3);
					if (_chance >= 1) then {
						{
							_x doTarget (_nrstWTgts # 0);
							_x doFire (_nrstWTgts # 0);
						} forEach (units group _vcl);
					};
				};
				sleep _delay;
			}
			else
			{
				private ["_vicPosArr","_targets","_grpMemberPos","_sel","_randSel","_attackPos","_victim"];
				while {!isNull _hunted} do {
					_vicPosArr = [];
					_targets = [];
					_vcl setvehicleammo 1;
					_vcl setfuel 1;

					_wpArray = waypoints (group _vcl);
					for "_i" from 0 to (count _wpArray -1) do {
						deleteWaypoint [(group _vcl), _i]
					};

					_wp1 = (group _vcl) addWaypoint [(getPos _vcl), 0];
					_wp1 setWaypointType "MOVE";

					{
						if ((alive _x) && (captiveNum _x isEqualTo 0)) then {
							_grpMemberPos = getPos _x;

							if (format ["%1", _grpMemberPos] != "[0,0,0]") then	{
								_vicPosArr pushBack _grpMemberPos;
								_targets pushBack _x;
							};
						};
					} forEach units (group _hunted);

					if (count _vicPosArr > 0) then {
						_sel = (count _vicPosArr) -1;
						_randSel = floor (round(random _sel));
						_attackPos = _vicPosArr # _randSel;
						_victim = _targets # _randSel;

						_wp1 setWaypointPosition [_attackPos, _wpRad];
						(group _vcl) setCurrentWaypoint _wp1;

						_cntrPos = getPos _victim;
						{
							_x forgetTarget _victim;
							_x reveal [_victim, 4];
							_x doTarget _cntrPos;
							_x doFire _cntrPos;
						} forEach (units group _vcl);
					};
					sleep _delay;
				};

				while {isNull _hunted} do {
					if (count _towns !=0 && alive _vcl) then {
						_r = ceil(random count _towns);
						_randomTownPos = position (_towns # _r);
						_towns deleteAt _r;

						_wpArray = wayPoints (group _vcl);
						for "_i" from 0 to (count _wpArray -1) do {
							deleteWaypoint [(group _vcl), _i]
						};

						_wp1 = (group _vcl) addWaypoint [(getPos _vcl), 0];
						_wp1 setWaypointType "MOVE";
						_wp1 setWaypointPosition [_randomTownPos, _wpRad];
						(group _vcl) setCurrentWaypoint _wp1;
						sleep 200;
					};
					if ((_towns isEqualTo []) || (!alive _vcl)) exitWith {};
					if (time > _future_time) then {[_vcl] spawn {(_this # 0) setFuel 0; sleep 60; if (alive (_this # 0)) then {(_this # 0) setdamage 1;};};};
				};

				_vcl setVehicleAmmo 1;
				_vcl setFuel 1;

				_nrstWTgts = [];
				{_nrstWTgts pushBack _x} forEach ((position _vcl) nearEntities [["Air","CAManBase"], 2000] select {((captiveNum _x isEqualTo 0) || (lifeState _x isEqualTo "HEALTHY") || (lifeState _x isEqualTo "INJURED") || (_x getVariable ["ACE_isUnconscious", false])) && (side _x isEqualTo west)});
				//need to test array order of above
				_cntrPos = getPos (_nrstWTgts # 0);

				if (!(_nrstWTgts isEqualTo []) && {(format ["%1", _cntrPos] != "[0,0,0]")}) then {
					//chase enemy if exist and have valid position
					_wp1 setWaypointPosition [_cntrPos, _wpRad];
					(group _vcl) setCurrentWaypoint _wp1;

					{
						_x forgetTarget (_nrstWTgts # 0);
						_x reveal [(_nrstWTgts # 0), 4];
						_x doTarget _cntrPos;
						_x doFire _cntrPos;
					} forEach (units group _vcl);
				};
				sleep _delay;
			};
			if (time > _future_time) then {[_vcl] spawn {(_this # 0) setFuel 0; sleep 60; if (alive (_this # 0)) then {(_this # 0) setdamage 1;};};};
		}
		else
		{
// Hunt Players

			_vcl setVehicleAmmo 1;
			_vcl setFuel 1;

			_wp1 setWaypointPosition [(getPos _hunted), _wpRad];
			_wp1 setWaypointBehaviour "AWARE";
			(group _vcl) setCurrentWaypoint _wp1;

			if (_hunted == random_w_player2) then {
				_wp1 setWaypointStatements ["true","this reveal random_w_player2;"];
			}else{
				_wp1 setWaypointStatements ["true","this reveal random_w_player3;"];
			};

			{
				_x forgetTarget _hunted;
				_x reveal [_hunted, 4];
				_x doTarget _hunted;
				_x doFire _hunted;
			} forEach (units group _vcl);
			sleep _delay;
			waitUntil {sleep 1; isNull _hunted};// this will delay aircraft respawn until _hunted respawns as side affect

			_wpArray = wayPoints (group _vcl);
			for "_i" from 0 to (count _wpArray -1) do {
				deleteWaypoint [(group _vcl), _i]
			};

			_wp1 = (group _vcl) addWaypoint [(getPos _vcl), 0];
			_wp1 setWaypointType "SAD";
			_wp1 setWaypointPosition [(getPos air_pat_pos), _wpRad];
			(group _vcl) setCurrentWaypoint _wp1;
		};
		sleep 45;
	};
};
east_AO_guard_cycle_wp = {
	params ["_vcl"];
	private ["_vehgrp","_wPArray","_i","_wp0","_wp1","_wp2","_wp3","_wp4"];

	//remove all previous wayPoints
	_wPArray = wayPoints (group _vcl);
	for "_i" from 0 to (count _wPArray -1) do {
		deleteWaypoint [(group _vcl), _i]
	};

	_vehgrp = group _vcl;

	_wp0 = _vehgrp addWaypoint [markerPos "spawnaire", 250];
	_wp0 setWaypointType "MOVE";
	_wp0 setWaypointBehaviour "AWARE";
	_wp0 setWaypointCombatMode "RED";
	_wp0 setWaypointStatements ["true", ""];

	_wp1 = _vehgrp addWaypoint [markerPos "aomkr", 250];
	_wp1 setWaypointType "MOVE";
	_wp1 setWaypointBehaviour "AWARE";
	_wp1 setWaypointCombatMode "RED";
	_wp1 setWaypointStatements ["true", ""];

	_wp2 = _vehgrp addWaypoint [markerPos "cyclewpmrk", 250];
	_wp2 setWaypointType "MOVE";
	_wp2 setWaypointBehaviour "AWARE";
	_wp2 setWaypointCombatMode "RED";
	_wp2 setWaypointStatements ["true", ""];

	_wp3 = _vehgrp addWaypoint [markerPos "spawnairw", 250];
	_wp3 setWaypointType "MOVE";
	_wp3 setWaypointBehaviour "AWARE";
	_wp3 setWaypointCombatMode "RED";
	_wp3 setWaypointStatements ["true", "if ((random 6) < 1) then {[objectParent this,5000,objNull] spawn find_west_target_fnc;};"];

	_wp4 = _vehgrp addWaypoint [markerPos "aomkr", 250];
	_wp4 setWaypointType "CYCLE";
	_wp4 setWaypointBehaviour "AWARE";
	_wp4 setWaypointCombatMode "RED";
	_wp4 setWaypointStatements ["true", "objectParent this setVehicleAmmo 1; objectParent this setFuel 1;"];
};
find_me2_fnc = {
	private _bluforPlayers = playableUnits select {side _x isEqualTo INS_Blu_side};
	if (count _bluforPlayers < 1) exitWith {random_w_player2 = ObjNull; publicVariable "random_w_player2";};
	random_w_player2 = selectRandom _bluforPlayers;
	publicVariable "random_w_player2";
	if (DebugEnabled > 0) then {diag_log text format ["Variable West Human Target: %1", random_w_player2]};
	true
};
find_me3_fnc = {
	private _bluforPlayers = playableUnits select {side _x isEqualTo INS_Blu_side};
	if (count _bluforPlayers < 1) exitWith {random_w_player3 = ObjNull; publicVariable "random_w_player3";};
	random_w_player3 = selectRandom _bluforPlayers;
	publicVariable "random_w_player3";
	if (DebugEnabled > 0) then {diag_log text format ["Variable West Human Target: %1", random_w_player3]};
	true
};
air_debug_mkrs = {
	params ["_airhunter","_aircraftName","_wpMkrList","_c","_mkrType","_patrolWPmkrs","_currWP","_WPmkr","_mkrName","_mkr"];
	_aircraftName = str(_airhunter);
	_c = 0;
	_mkrType = if (_airhunter == airhunterE1) then {"o_air"} else {"o_plane"};

	sleep 10;
	if (alive leader _airhunter) then {while {count wayPoints (group _airhunter) < 1} do {sleep 10};};

	_patrolWPmkrs = {
		_wpMkrList = [];
		for "_i" from 1 to (count (wayPoints _airhunter)) -1 step 1 do {
			_currWP = format["%1 WP%2", _airhunter, _i];
			_WPmkr = createMarker [_currWP, getWPPos [_airhunter, _i]];
			_WPmkr setMarkerText _currWP;
			_WPmkr setMarkerType "waypoint";
			_WPmkr setMarkerColor "ColorOrange";
			_wpMkrList pushBack _WPmkr;
		};
	};
	call _patrolWPmkrs;

	_mkrName = "" + _aircraftName;
	_mkr = createMarker [_mkrName, (position leader _airhunter)];
	_mkr setMarkerText _mkrName;
	_mkr setMarkerType _mkrType;

	while {alive leader _airhunter} do {
		_mkr setMarkerPos (getPosWorld leader _airhunter);
		uiSleep 0.5;
		_c = _c + 1;
		if (_c isEqualTo 200) then {
			{deleteMarker _x} count _wpMkrList;
			call _patrolWPmkrs;
			_c = 0;
		};
	};

	deleteMarker _mkr;
	{deleteMarker _x} count _wpMkrList;
	true
};
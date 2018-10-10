/*
 extraction_main.sqf v1.26 by Jigsor
 null = [] execVM "JIG_EX\extraction_main.sqf";
 runs in JIG_EX\extraction_init.sqf
*/

if (!isServer) exitWith {};
if (!hasInterface && !isDedicated) exitWith {};
0 spawn {
	private ["_recruitsArry","_playerArry","_range","_poscreate","_speed","_SAdir","_spwnairdir","_height","_type","_vehicle","_veh","_vel","_vehgrp","_VarName","_wp0","_evacComplete","_vehgrp_units","_gunners_removed","_has_gunner_pos","_without_gunner_pos","_switch_driver","_animateDoors","_changeLocality"];

	evac_toggle = false;publicVariable "evac_toggle";
	sleep 0.3;
	_evacComplete = false;
	_gunners_removed = false;
	_vehgrp = grpNull;
	EvacHeliW1 = ObjNull;
	ex_group_ready = false;
	_has_gunner_pos = ["B_CTRG_Heli_Transport_01_tropic_F","B_Heli_Transport_01_F","B_Heli_Transport_01_camo_F","kyo_MH47E_base","RHS_CH_47F_10","RHS_CH_47F_light"];
	_without_gunner_pos = ["I_Heli_Transport_02_F","CH49_Mohawk_FG","B_Heli_Light_01_F"];
	_helcat_types = ["AW159_Transport_Camo"];
	_chinook_types = ["kyo_MH47E_Ramp","kyo_MH47E_HC","RHS_CH_47F_10","RHS_CH_47F_light"];// ("kyo_MH47E_base" unsupported)

	"ext_caller_group" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};//Allows group members to update on the fly
	"EvacHeliW1" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
	"ex_group_ready" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
	"JIG_EX_Caller" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
	sleep 5;

	while {!ex_group_ready} do {sleep 3;};
	ex_group_ready = false;
	publicVariable "ex_group_ready";
	call Evac_Spawn_Loc;
	waitUntil {sleep 0.3; !isNull EvacSpawnPad};
	(localize "STR_BMR_heli_extraction_inbound") remoteExec ['JIG_EX_MPhint_fnc', ext_caller_group];// Everything is now ready. Next code block creates chopper and performs Evac/Cleanup.
	sleep 1;

	if ((isNull EvacHeliW1) || !(alive EvacHeliW1)) then
	{
		_recruitsArry = [];
		_playerArry = [];
		{if (isPlayer _x) then {_playerArry pushBack _x;}else{_recruitsArry pushBack _x;};} forEach (units ext_caller_group);

		_poscreate = getMarkerPos "EvacSpawnMkr";
		_speed = 60;// starting speed
		_SAdir = getDir EvacSpawnPad;
		_spwnairdir = (getPosATL EvacSpawnPad) getDir (getPosATL EvacLZpad);
		_height = selectRandom [35,45,55];
		if (JIG_EX_Random_Type) then {
			_type = selectRandom JIG_EX_Chopper_Type;
		} else {
			_type = JIG_EX_Chopper_Type select 0;// select default type
		};

		_vehicle = [getPosATL EvacSpawnPad, _SAdir, _type, JIG_EX_Side] call bis_fnc_spawnvehicle;
		sleep 0.1;
		(_vehicle select 0) addeventhandler ["killed","[(_this select 0)] spawn remove_carcass_fncJE"];

		_veh = _vehicle select 0;
		_vel = velocity _veh;

		_veh setpos [(_poscreate select 0) + (sin (_spwnairdir -180)), (_poscreate select 1) + (cos (_spwnairdir -180)), _height];
		_veh setVelocity [(_vel select 0)+(sin _SAdir*_speed),(_vel select 1)+ (cos _SAdir*_speed),(_vel select 2)];

		_vehgrp = _vehicle select 2 ;// original group of vehicle
		{_x addeventhandler ["killed","[(_this select 0)] spawn remove_carcass_fncJE"]} forEach (units _vehgrp);

		_veh enableCopilot false;
		_veh allowdamage JIG_EX_damage;

		_VarName = "EvacHeliW1";
		_veh setVehicleVarName _VarName;
		_veh Call Compile Format ["%1=_this; publicVariable '%1'",_VarName];
		_veh setVariable["persistent",true];

		if (!(alive _veh) || !(canMove _veh)) then {(localize "STR_BMR_heli_extraction_down") remoteExec ['JIG_EX_MPhint_fnc', ext_caller_group];};

		if !(JIG_EX_gunners) then {
			if (_type in _has_gunner_pos) then {
				// remove gunners from GhostHawk.
				[EvacHeliW1 turretUnit [0]] join grpNull;// most all seem to use [0] as copilot
				deleteVehicle (EvacHeliW1 turretUnit [0]);
				[EvacHeliW1 turretUnit [1]] join grpNull;
				deleteVehicle (EvacHeliW1 turretUnit [1]);
				[EvacHeliW1 turretUnit [2]] join grpNull;
				deleteVehicle (EvacHeliW1 turretUnit [2]);

				if (_type in _chinook_types) then {
					// remove gunners from Chinook types.
					[EvacHeliW1 turretUnit [3]] join grpNull;
					deleteVehicle (EvacHeliW1 turretUnit [3]);
					[EvacHeliW1 turretUnit [4]] join grpNull;
					deleteVehicle (EvacHeliW1 turretUnit [4]);

					//RHS Chinooks
					if (_type in ["RHS_CH_47F_10","RHS_CH_47F_light"]) then {
						[EvacHeliW1 turretUnit [1]] join grpNull;
						deleteVehicle (EvacHeliW1 turretUnit [1]);
					};
				};
				_gunners_removed = true;
			};
			if (_type in _helcat_types) then {
				[EvacHeliW1 turretUnit [0]] join grpNull;// most all seem to use [0] as copilot
				deleteVehicle (EvacHeliW1 turretUnit [0]);
			};
		};

		if (isLightOn EvacHeliW1) then {EvacHeliW1 setPilotLight false};
		if (isCollisionLightOn EvacHeliW1) then {driver EvacHeliW1 action ["CollisionLightOff", EvacHeliW1]};
		[EvacHeliW1] spawn {private _animateDoors = [(_this select 0)] call animate_doors_fnc};

		// Set Evac helicopter waypoints and move to evacuation LZ.
		private _wPArray = waypoints _vehgrp;
		for "_i" from 0 to (count _wPArray -1) do {
			deleteWaypoint [_vehgrp, _i]
		};

		_wp0 = _vehgrp addWaypoint [getPosATL EvacLZpad, 1];
		_wp0 setWaypointType "LOAD";
		_wp0 setWaypointSpeed "NORMAL";
		_wp0 setWaypointBehaviour "CARELESS";
		_wp0 setWaypointCombatMode "BLUE";// Never fire
		_wp0 setWaypointStatements ["true","doStop EvacHeliW1; EvacHeliW1 land 'LAND'; hint 'This is RED DOG, stay clear of LZ, get aboard asap when we are down!';"];

		EvacHeliW1 setdamage 0;
		EvacHeliW1 setfuel 1;
		sleep 0.1;

		if (!isNull EvacHeliW1) then {
			private _totalSeats = [typeof EvacHeliW1,true] call BIS_fnc_crewCount;
			private _usedSeats = count crew EvacHeliW1;
			private _availableSeats = _totalSeats - _usedSeats;
			private _chopper_to_small = if (({alive _x && !captive _x} count units ext_caller_group) > _availableSeats) then {true} else {false};

			if (_chopper_to_small) then {
				waitUntil {sleep 1.2; {_x in EvacHeliW1} count units ext_caller_group == {alive _x && !captive _x} count units ext_caller_group || count crew EvacHeliW1 isEqualTo _totalSeats || (isNull EvacHeliW1) || ((count crew EvacHeliW1) < 1)};
			} else {
				waitUntil {sleep 0.9; {_x in EvacHeliW1} count units ext_caller_group == {alive _x && !captive _x} count units ext_caller_group || (isNull EvacHeliW1) || ((count crew EvacHeliW1) < 1)};
			};
		};

		if ((isNull EvacHeliW1) || ((count crew EvacHeliW1) < 1)) then {
			if (alive _veh) exitWith {{ deleteVehicle _x; sleep 0.1} forEach (units _vehgrp); deleteVehicle _veh; _evacComplete = true; deleteMarker "tempDropMkr";};
		};

		deleteMarker "tempPUmkr";

		if !(_evacComplete) then
		{
			_vehgrp_units = (units _vehgrp);
			_vehgrp_leader = (leader _vehgrp);

			if (!isDedicated) then {
				_vehgrp_leader addEventHandler ["GetOutMan",{if (alive(_this select 2)) then {_this select 0 moveInDriver (_this select 2)};}];
			} else {
				[_vehgrp_leader] remoteExec ["JigEx_RemoteGetoutMan", JIG_EX_Caller];
				sleep 3;
			};

			[_vehgrp_leader] join (group JIG_EX_Caller);

			if (!isDedicated) then {[(driver EvacHeliW1)] spawn JigEx_MoveToDrop};

			waitUntil {sleep 1; {_x in EvacHeliW1} count _playerArry isEqualTo 0};//wait until all players disembark
			{
				[_x, EvacHeliW1] remoteExec ["JigEx_getout_nonGrouped", [0,-2] select isDedicated];
			} forEach ((crew EvacHeliW1) select {(isplayer _x) && !(_x isEqualTo JIG_EX_Caller)});

			EvacHeliW1 setdamage 0;
			EvacHeliW1 setfuel 1;
			sleep 0.1;

			if (JIG_EX_gunners) then {
				{unassignVehicle (_x);(_x) action ["getOut", vehicle _x]; sleep 0.5} foreach _recruitsArry;
				{unassignVehicle (_x);(_x) action ["getOut", vehicle _x]; sleep 0.5} forEach ((units ext_caller_group) select {(alive _x) && (_x in (crew EvacHeliW1))});
				{[_x] join (group EvacHeliW1); sleep 0.5;} forEach _vehgrp_units;// Ensures original AI crew joins their own group
				[_vehgrp_leader] join (group EvacHeliW1);
				_vehgrp_leader assignAsDriver EvacHeliW1;
				[_vehgrp_leader] orderGetIn true;
			};
			if !(JIG_EX_gunners) then {
				_switch_driver = true;
				while {_switch_driver} do {
					if (_type in _without_gunner_pos) then {
						{unassignVehicle (_x);(_x) action ["getOut", vehicle _x]; [_x] join (group EvacHeliW1); sleep 0.5} foreach _recruitsArry;
						{unassignVehicle (_x);(_x) action ["getOut", vehicle _x]; [_x] join (group EvacHeliW1); sleep 0.5} foreach (units ext_caller_group);
						[_vehgrp_leader] join (group EvacHeliW1);
						_vehgrp_leader assignAsCommander EvacHeliW1;
						[_vehgrp_leader] orderGetIn true;
						{[_x] join (group EvacHeliW1); sleep 0.5;} forEach _vehgrp_units;
						_switch_driver = false;
					};
					if (_type in _helcat_types) then {
						_vehgrp_leader = driver EvacHeliW1;
						{unassignVehicle (_x); sleep 0.1; (_x) action ["getOut", vehicle _x]; sleep 0.1; [_x] join (group EvacHeliW1); sleep 6;} foreach _recruitsArry;
						{unassignVehicle (_x); sleep 0.1; (_x) action ["getOut", vehicle _x]; sleep 0.1; [_x] join (group EvacHeliW1); sleep 6;} foreach (units ext_caller_group);
						[_vehgrp_leader] join grpNull;
						[_vehgrp_leader] join (group EvacHeliW1);
						_vehgrp_leader assignAsDriver EvacHeliW1;
						_vehgrp_leader moveInDriver EvacHeliW1;
						_switch_driver = false;
					};
					if ((_type in _chinook_types) && (_type in _has_gunner_pos)) then {
						{unassignVehicle (_x);(_x) action ["getOut", vehicle _x]; (_x) setPos [(getPosATL EvacHeliW1 select 0) - 8, (getPosATL EvacHeliW1 select 1) + 8, 0]; sleep 0.5} foreach _recruitsArry;
						{unassignVehicle (_x);(_x) action ["getOut", vehicle _x]; (_x) setPos [(getPosATL EvacHeliW1 select 0) - 8, (getPosATL EvacHeliW1 select 1) + 8, 0]; sleep 0.5} forEach ((units ext_caller_group) select {(alive _x) && (_x in (crew EvacHeliW1))});// Unassign leader/driver and all crew from player group, reposition.
						{[_x] join (group EvacHeliW1); sleep 0.5;} forEach _vehgrp_units;
						[_vehgrp_leader] join (group EvacHeliW1);
						_vehgrp_leader assignAsDriver EvacHeliW1;
						_vehgrp_leader moveInDriver EvacHeliW1;//less realistic than orderGetIn but more reliable
						_switch_driver = false;
					};
					if (_type in _has_gunner_pos) then {
						{unassignVehicle (_x);(_x) action ["getOut", vehicle _x]; sleep 0.5} foreach _recruitsArry;
						{unassignVehicle (_x);(_x) action ["getOut", vehicle _x]; sleep 0.5} forEach ((units ext_caller_group) select {(alive _x) && (_x in (crew EvacHeliW1))});

						{[_x] join (group EvacHeliW1)} forEach _vehgrp_units;
						if (!isNull _vehgrp_leader) then {
							[_vehgrp_leader] join (group EvacHeliW1);
							_vehgrp_leader assignAsDriver EvacHeliW1;
							_vehgrp_leader moveInDriver EvacHeliW1;
						};
						_switch_driver = false;
					};
				};
			};

			deleteMarker "tempDropMkr";
			sleep 2;

			// Move Evac helicopter back towards original pick up location and delete itself.
			waitUntil {!isNull driver EvacHeliW1 || isNull EvacHeliW1};

			if (isNull EvacHeliW1) exitWith {{deleteVehicle _x; sleep 0.1} forEach (units _vehgrp), [_veh, EvacSpawnPad, EvacLZpad]; deleteMarker "tempDropMkr"; sleep 0.1; deleteMarker "tempPUmkr"; sleep 0.1; _evacComplete = true; evac_toggle = true; publicVariable "evac_toggle";};

			{EvacHeliW1 lock 2} forEach playableunits;

			if !((groupOwner group EvacHeliW1) isEqualTo 2) then {
				//_changeLocality = group EvacHeliW1 setGroupOwner 2;
			};

			if !(JIG_EX_damage) then {_veh allowdamage true};//allow damage after drop off needed to complete script in some cases.

			private _wPArray = waypoints (group EvacHeliW1);
			for "_i" from 0 to (count _wPArray -1) do {
				deleteWaypoint [(group EvacHeliW1), _i]
			};

			_vehgrp_leader action ["engineOn", EvacHeliW1];
			driver EvacHeliW1 action ["engineOn", EvacHeliW1];
			sleep 0.1;
			_animateDoors = [] spawn {[EvacHeliW1] call animate_doors_fnc;};
			sleep 2;
			EvacHeliW1 doMove _poscreate;
			(leader group EvacHeliW1) doMove _poscreate;
			sleep 2;

			wp2rtp = (group _vehgrp_leader) addWaypoint [(getPos EvacHeliW1), 0];
			wp2rtp setWaypointType "MOVE";
			wp2rtp setWaypointPosition [_poscreate, 1];
			wp2rtp setWaypointVisible false;
			(group EvacHeliW1) setCurrentWaypoint wp2rtp;
			[group EvacHeliW1, currentWaypoint (group EvacHeliW1)] setWaypointVisible false;
			EvacHeliW1 doMove _poscreate;

			if (alive _veh) then {
				sleep JIG_EX_Despawn_Time;
				{deleteVehicle _x; sleep 0.1} forEach (units _vehgrp);
				{deleteVehicle _x; sleep 0.1} forEach (units EvacHeliW1) - _recruitsArry;
				deleteVehicle _veh;
				_evacComplete = true;
			};
		};

		// Cleanup residual markers/objects if any and flip Evac toggle switch.
		if !(getMarkerColor "tempDropMkr" isEqualTo "") then {deleteMarker "tempDropMkr"};
		if (!isNull _veh) then {_veh removeEventHandler ["Engine", 0]};

		if (_evacComplete) exitWith {{deleteVehicle _x;} forEach [EvacSpawnPad, EvacLZpad]; evac_toggle = true; publicVariable "evac_toggle";};

		waitUntil {sleep 1; (!alive _veh) || ((count crew _veh) < 1) || (!canmove _veh)};
		if (((count crew _veh) < 1) && (alive _veh)) then {_veh setDamage 1};
		{
			if (alive _x) then {_x setDamage 1; sleep 0.1}
		} forEach (crew _veh);// original crew
		if (!alive _veh) then {
			{
				if (alive _x) then {_x setDamage 1; sleep 0.1}
			} forEach (units EvacHeliW1);
		} else {
			_veh setDamage 1;
			{
				if (alive _x) then {_x setDamage 1; sleep 0.1}
			} forEach (units EvacHeliW1);
		};

		if !(getMarkerColor "EvacSpawnMkr" isEqualTo "") then {deleteMarker "EvacSpawnMkr"};
		if (!isNull EvacSpawnPad) then {deleteVehicle EvacSpawnPad};
		if (!isNull EvacLZpad) then {deleteVehicle EvacLZpad};
		evac_toggle = true;
		publicVariable "evac_toggle";
		sleep 1.2;
		(localize "STR_BMR_heli_extraction_standby") remoteExec ['JIG_EX_MPhint_fnc', ext_caller_group];
	};
};
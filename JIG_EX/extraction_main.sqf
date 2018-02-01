/*
 extraction_main.sqf v1.25 by Jigsor is WIP
 null = [] execVM "JIG_EX\extraction_main.sqf";
 runs in JIG_EX\extraction_init.sqf 
*/

if (!isServer) exitWith {};
if (!hasInterface && !isDedicated) exitWith {};
[] spawn {
	private ["_recruitsArry","_playerArry","_range","_poscreate","_speed","_SAdir","_spwnairdir","_height","_type","_vehicle","_veh","_vel","_vehgrp","_VarName","_wp0","_evacComplete","_availableSeats","_ext_caller_group_count","_chopper_to_small","_vehgrp_units","_gunners_removed","_has_gunner_pos","_without_gunner_pos","_switch_driver","_animateDoors","_localityChanged"];

	evac_toggle = false;publicVariable "evac_toggle";
	sleep 0.3;
	_evacComplete = false;
	_chopper_to_small = false;
	_gunners_removed = false;
	_ext_caller_group_count = [];
	_ext_caller_group_count = grpNull;
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
	waitUntil {sleep 0.9; count units ext_caller_group > 0};//wait until Evac group has units
	ex_group_ready = false;
	publicVariable "ex_group_ready";
	call Evac_Spawn_Loc;
	waitUntil {sleep 0.3; !isNull EvacSpawnPad};
	[localize "STR_BMR_heli_extraction_inbound", "JIG_EX_MPhint_fnc", ext_caller_group, false, false] call BIS_fnc_mp;// Everything is now ready. Next code block creates chopper and performs Evac/Cleanup.
	sleep 1;

	if ((isNull EvacHeliW1) || !(alive EvacHeliW1)) then
	{
		_recruitsArry = [];
		_playerArry = [];
		{if (isPlayer _x) then {_playerArry pushBack _x;}else{_recruitsArry pushBack _x;};} forEach (units ext_caller_group);

		_poscreate = getMarkerPos "EvacSpawnMkr";
		_speed = 60;// starting speed
		_SAdir = getDir EvacSpawnPad;
		_spwnairdir = [getPosATL EvacSpawnPad, getPosATL EvacLZpad] call BIS_fnc_dirTo;
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

		_availableSeats = EvacHeliW1 emptyPositions "Cargo";

		if (!(alive _veh) || !(canMove _veh)) then {[localize "STR_BMR_heli_extraction_down", "JIG_EX_MPhint_fnc", ext_caller_group, false, false] call BIS_fnc_mp;};

		if !(JIG_EX_gunners) then {
			if (_type in _has_gunner_pos) then {
				// remove gunners from GhostHawk. //player moveInTurret [vehicle,[0]];
				[EvacHeliW1 turretUnit [ 0 ]] join grpNull;// most all seem to use [ 0 ] as copilot
				deleteVehicle (EvacHeliW1 turretUnit [ 0 ]);
				[EvacHeliW1 turretUnit [ 1 ]] join grpNull;
				deleteVehicle (EvacHeliW1 turretUnit [ 1 ]);
				[EvacHeliW1 turretUnit [ 2 ]] join grpNull;
				deleteVehicle (EvacHeliW1 turretUnit [ 2 ]);

				if (_type in _chinook_types) then {
					// remove gunners from Chinook types.
					[EvacHeliW1 turretUnit [ 3 ]] join grpNull;
					deleteVehicle (EvacHeliW1 turretUnit [ 3 ]);
					[EvacHeliW1 turretUnit [ 4 ]] join grpNull;
					deleteVehicle (EvacHeliW1 turretUnit [ 4 ]);

					//RHS Chinooks
					if ((_type == "RHS_CH_47F_10") || (_type == "RHS_CH_47F_light")) then {
						[EvacHeliW1 turretUnit [ 1 ]] join grpNull;
						deleteVehicle (EvacHeliW1 turretUnit [ 1 ]);
					};
				};
				_gunners_removed = true;
			};
			if (_type in _helcat_types) then {
				[EvacHeliW1 turretUnit [ 0 ]] join grpNull;// most all seem to use [ 0 ] as copilot
				deleteVehicle (EvacHeliW1 turretUnit [ 0 ]);
			};
		};

		[EvacHeliW1] spawn {private _animateDoors = [(_this select 0)] call animate_doors_fnc;};

		// Set Evac helicopter waypoints and move to evacuation LZ.
		_wp0 = _vehgrp addWaypoint [getPosATL EvacLZpad, 1];
		_wp0 setWaypointType "LOAD";
		_wp0 setWaypointSpeed "NORMAL";
		_wp0 setWaypointBehaviour "CARELESS";
		_wp0 setWaypointCombatMode "BLUE";// Never fire
		_wp0 setWaypointStatements ["true","doStop EvacHeliW1; EvacHeliW1 land 'LAND'; hint 'This is RED DOG, stay clear of LZ, get aboard asap when we are down!';"];

		EvacHeliW1 setdamage 0;
		EvacHeliW1 setfuel 1;
		sleep 0.1;

		if (({alive _x and !captive _x} count units ext_caller_group) > _availableSeats) then {
			_ext_caller_group_count = _ext_caller_group_count + [{count units ext_caller_group}];
			for "_i" from 1 to _availableSeats do {
				_ext_caller_group_count = _ext_caller_group_count - [_x];
			} forEach units _ext_caller_group_count;
			_chopper_to_small = true;
		};// needs testing with multiple players in full chopper

		if (!isNull EvacHeliW1) then {
			if (_chopper_to_small) then {
				waitUntil {sleep 1.2; {_x in EvacHeliW1} count units ext_caller_group == {alive _x and !captive _x} count units ext_caller_group || {_x in EvacHeliW1} count units ext_caller_group <= count (units _ext_caller_group_count) || (isNull EvacHeliW1) || ((count crew EvacHeliW1) < 1)};//working?
				//[_vehgrp] join (group JIG_EX_Caller);
			} else	{
				waitUntil {sleep 0.9; {_x in EvacHeliW1} count units ext_caller_group == {alive _x and !captive _x} count units ext_caller_group || (isNull EvacHeliW1) || ((count crew EvacHeliW1) < 1)};//working
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

			if (!isDedicated) then {[(leader group EvacHeliW1)] spawn JigEx_MoveToDrop};

			waitUntil {sleep 1; {_x in EvacHeliW1} count _playerArry isEqualTo 0};//wait until all players disembark

			EvacHeliW1 setdamage 0;
			EvacHeliW1 setfuel 1;
			sleep 0.1;

			if (JIG_EX_gunners) then {
				{unassignVehicle (_x);(_x) action ["getOut", vehicle _x]; sleep 0.5} foreach _recruitsArry;
				{unassignVehicle (_x);(_x) action ["getOut", vehicle _x]; sleep 0.5} foreach (units ext_caller_group);
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
					if ((_type in _chinook_types) and (_type in _has_gunner_pos)) then {
						{unassignVehicle (_x);(_x) action ["getOut", vehicle _x]; (_x) setPos [(getPosATL EvacHeliW1 select 0) - 8, (getPosATL EvacHeliW1 select 1) + 8, 0]; sleep 0.5} foreach _recruitsArry;
						{unassignVehicle (_x);(_x) action ["getOut", vehicle _x]; (_x) setPos [(getPosATL EvacHeliW1 select 0) - 8, (getPosATL EvacHeliW1 select 1) + 8, 0]; sleep 0.5} foreach (units ext_caller_group);// Unassign leader/driver and all crew from player group, reposition.
						{[_x] join (group EvacHeliW1); sleep 0.5;} forEach _vehgrp_units;
						[_vehgrp_leader] join (group EvacHeliW1);
						_vehgrp_leader assignAsDriver EvacHeliW1;
						_vehgrp_leader moveInDriver EvacHeliW1;//less realistic than orderGetIn but more reliable
						_switch_driver = false;
					};
					if (_type in _has_gunner_pos) then {
						{unassignVehicle (_x);(_x) action ["getOut", vehicle _x]; sleep 0.5} foreach _recruitsArry;
						{unassignVehicle (_x);(_x) action ["getOut", vehicle _x]; sleep 0.5} foreach (units ext_caller_group);
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

			if !(JIG_EX_damage) then {_veh allowdamage true};//allow damage after drop off needed to complete script in some cases.

			_localityChanged = group EvacHeliW1 setGroupOwner 2;

			_vehgrp_leader action ["engineOn", EvacHeliW1];
			(leader group EvacHeliW1) action ["engineOn", EvacHeliW1];// working without this
			driver EvacHeliW1 action ["engineOn", EvacHeliW1];
			sleep 0.1;
			_animateDoors = [] spawn {[EvacHeliW1] call animate_doors_fnc;};
			sleep 2;
			EvacHeliW1 doMove (position EvacLZpad);
			(leader group EvacHeliW1) doMove (position EvacLZpad);
			sleep 2;

			wp2rtp = (group _vehgrp_leader) addWaypoint [(getPos EvacHeliW1), 0];
			wp2rtp setWaypointType "MOVE";
			wp2rtp setWaypointPosition [(position EvacLZpad), 1];
			(group EvacHeliW1) setCurrentWaypoint wp2rtp;

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
		[localize "STR_BMR_heli_extraction_standby", "JIG_EX_MPhint_fnc", ext_caller_group, false, false] call BIS_fnc_mp;
	};
	if (true) exitwith {};
};
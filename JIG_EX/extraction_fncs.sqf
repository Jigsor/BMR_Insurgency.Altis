// extraction_fncs.sqf v1.28 by Jigsor

// Global hint
JIG_EX_MPhint_fnc = {if (hasInterface) then { hint _this };};
extraction_pos_fnc = {
	// Actual Evac Position based on requested map click evac position
	private _posNotFound = [];
	private _dis = JIG_EX_Clear_Pos_Dis;
	private _size = JIG_EX_Chopper_size;
	private _mrkPos = markerPos "extractmkr";
	private _randPos = _mrkPos getPos [_dis * sqrt random 1, random 360];
	private _newPos = _randPos isFlatEmpty [20,50,0.4,2,0,false,player];

	if (_newPos isNotEqualTo []) then {
		private _maxAttempts = 8;
		for "_i" from 1 to _maxAttempts do {
			_randPos = _mrkPos getPos [_dis * sqrt random 1, random 360];
			_newPos = _randPos isFlatEmpty [_size,256,0.5,2,0,false,player];
			if (_newPos isNotEqualTo []) exitWith {_newPos};
			sleep 0.2;
		};
	};

	if (_newPos isNotEqualTo []) then {
		if (markerColor "tempPUmkr" isNotEqualTo "") then {deleteMarker "tempPUmkr"};
		private _mkr = createMarker ["tempPUmkr", _newPos];
		_mkr setMarkerShape "ELLIPSE";
		_mkr setMarkerSize [1, 1];
		_mkr setMarkerShape "ICON";
		_mkr setMarkerType "mil_dot";
		_mkr setMarkerColor "ColorOrange";
		"tempPUmkr" setMarkerText "Extraction Position";
		[[_mkr],east] remoteExec ["Hide_Mkr_fnc", [0,-2] select isDedicated];

		private _veh = createVehicle ["Land_HelipadEmpty_F", markerPos "tempPUmkr", [], 0, "NONE"];
		sleep 0.1;
		private _lzName = "EvacLZpad";
		_veh setVehicleVarName _lzName;
		missionNamespace setVariable [_lzName,_veh,true];
		_veh Call Compile Format ["%1=_this; publicVariable '%1'", _lzName];
		sleep 1;
	};

	if (_newPos isEqualTo []) exitWith {_posNotFound};
	"extractmkr" setMarkerAlpha 0;
	_newPos
};
drop_off_pos_fnc = {
	// Actual Drop Off Position based on requested map click drop off position

	private _posNotFound = [];
	private _dis = JIG_EX_Clear_Pos_Dis;
	private _size = JIG_EX_Chopper_size;
	private _mrkPos = markerPos "dropmkr";
	private _randPos = _mrkPos getPos [_dis * sqrt random 1, random 360];
	private _newPos = _randPos isFlatEmpty [20,50,0.4,2,0,false,player];

	if (_newPos isNotEqualTo []) then {
		private _maxAttempts = 8;
		for "_i" from 1 to _maxAttempts do {
			_randPos = _mrkPos getPos [_dis * sqrt random 1, random 360];
			_newPos = _randPos isFlatEmpty [_size,256,0.5,2,0,false,player];
			if (_newPos isNotEqualTo []) exitWith {_newPos};
			sleep 0.2;
		};
	};

	if (_newPos isNotEqualTo []) then {
		if (markerColor "tempDropMkr" isNotEqualTo "") then {deleteMarker "tempDropMkr"};
		private _mkr = createMarker ["tempDropMkr", _newPos];
		_mkr setMarkerShape "ELLIPSE";
		_mkr setMarkerSize [1, 1];
		_mkr setMarkerShape "ICON";
		_mkr setMarkerType "mil_dot";
		_mkr setMarkerColor "ColorOrange";
		"tempDropMkr" setMarkerText "Drop Off Position";
		[[_mkr],east] remoteExec ["Hide_Mkr_fnc", [0,-2] select isDedicated];

		private _veh = createVehicle ["Land_HelipadEmpty_F", markerPos "tempDropMkr", [], 0, "NONE"];
		sleep 0.1;
		private _lzName = "DropLZpad";
		_veh setVehicleVarName _lzName;
		missionNamespace setVariable [_lzName,_veh,true];
		_veh Call Compile Format ["%1=_this; publicVariable '%1'",_lzName];
		sleep 1;
	};

	if (_newPos isEqualTo []) exitWith {_posNotFound};
	"dropmkr" setMarkerAlpha 0;
	_newPos
};
Evac_Spawn_Loc = {
	// Spawn position of Evac heli
	private ["_mkr","_mkrPos"];
	if (markerColor "EvacSpawnMkr" isNotEqualTo "") then {deleteMarker "EvacSpawnMkr"};
	private _mkr = createMarker ["EvacSpawnMkr", getposATL EvacLZpad];
	_mkr setMarkerShape "ELLIPSE";
	_mkr setMarkerSize [1, 1];
	_mkr setMarkerShape "ICON";
	_mkr setMarkerType "Empty";
	_mkr setMarkerColor "ColorRed";
	_mkr setMarkerText "Evac Spawn Pos";
	"EvacSpawnMkr" setMarkerPos [(markerPos "tempPUmkr" select 0) + (JIG_EX_Spawn_Dis * sin floor(random 360)), (markerPos "tempPUmkr" select 1) + (JIG_EX_Spawn_Dis * cos floor(random 360)), 0];
	private _mkrPos = markerPos "EvacSpawnMkr";
	EvacSpawnPad = createVehicle ["Land_HelipadEmpty_F", _mkrPos, [], 0, "NONE"];
	EvacSpawnPad setDir (_mkrPos getDir EvacLZpad);
	EvacSpawnPad setpos getPos EvacSpawnPad;
};
Ex_LZ_smoke_fnc = {
	// Pops Smoke and Chemlight at Extraction LZ
	(localize "STR_BMR_heli_extraction_smoke") remoteExec ['JIG_EX_MPhint_fnc', WEST];
	private _smokeColor = JIG_EX_Smoke_Color;
	private _lz = getPosATL EvacLZpad;
	private _chemLight = createVehicle ["Chemlight_green", _lz, [], 0, "NONE"];

	sleep 1;
	private _flrObj = "F_20mm_Red" createVehicle ((EvacHeliW1) ModelToWorld [0,100,200]);
	_flrObj setVelocity [0,0,-10];
	sleep 0.1;

	private "_smoke";
	for "_i" from 0 to 8 do {
		_smoke = createVehicle [_smokeColor, [(_lz # 0) + 2, (_lz # 1) + 2, 55], [], 0, "NONE"];
		sleep 20;
		if (isNull EvacHeliW1) exitWith {};
	};
	deleteVehicle _chemLight;
};
Drop_LZ_smoke_fnc = {
	// Pops Smoke and Chemlight at Drop Off LZ
	private _smokeColor = JIG_EX_Smoke_Color;
	private _lz = getPosATL DropLZpad;
	private _chemLight = createVehicle ["Chemlight_green", _lz, [], 0, "NONE"];
	private "_smoke";

	sleep 1;
	for "_i" from 0 to 4 do {
		_smoke = createVehicle [_smokeColor, [(_lz # 0) + 1, (_lz # 1) + 1, 55], [], 0, "NONE"];
		sleep 12.5;
		if (isNull EvacHeliW1) exitWith {};
	};
};
Evac_MPcleanUp = {
	private _localityChanged = group EvacHeliW1 setGroupOwner 2;
	if (((count crew EvacHeliW1) < 1) && (alive EvacHeliW1)) then {
		deleteVehicle EvacHeliW1;
	}else{
		private _nonCrew = (units ext_caller_group);
		private _crew = (crew EvacHeliW1);
		private _toDelete = (units EvacHeliW1);
		{
			if !(_x in _nonCrew) then {
				_toDelete pushBackUnique _x;
			};
		} forEach _crew;

		private "_p";
		{
			_p = _x;
			if (isPlayer _p && {!isNull objectParent _p && {!(_p isEqualTo (driver objectParent _p))}}) then {
				[[_p], objNull] remoteExec ["moveOut", _p];
				_toDelete = _toDelete - [_p];
			};
		} forEach _toDelete;
		{deleteVehicle _x} count _toDelete;

		if (!isNull EvacHeliW1) then {
			[_nonCrew] spawn {
				params ["_nonCrew"];
				{unassignVehicle (_x);(_x) action ["getOut", vehicle _x]; sleep 0.5} foreach _nonCrew;
				sleep 0.1;
				deleteVehicle EvacHeliW1;
			};
		};
	};
	true
};
Cancel_Evac_fnc = {
	if (JIG_EX_Caller in EvacHeliW1) then {
		moveout player;
		// if evac cancelled while aboard evac and above 9 meters from ground then caller and passengers could fall to death.
		if (getPosATL JIG_EX_Caller select 2 >9) then {
			hint "This is the end my friend";
		};
	};
	if (!isServer) exitWith {[] remoteExec ["Evac_MPcleanUp", 2]; resetEvac = false;};
	(call Evac_MPcleanUp)
};
JIP_Reset_Evac_fnc = {
	if (!isNull EvacHeliW1) then {
		call Evac_MPcleanUp;
		resetEvac = false;
		EvacHeliW1 = ObjNull;
		publicVariable "EvacHeliW1";
		sleep 1;
		publicVariable "resetEvac";
	}else{
		resetEvac = false;
		publicVariable "resetEvac";
		sleep 1;
		evac_toggle = true;
		publicVariable "evac_toggle";
	};
	resetEvac
};
animate_doors_fnc = {
	params ["_veh"];
	switch (true) do {
		case (_veh isKindOf "B_Heli_Transport_01_camo_F"): {if ((_veh doorPhase "door_R") == 0) then {{_veh animateDoor [_x, 1]} forEach ["door_L","door_R"];} else {{_veh animateDoor [_x, 0]} forEach ["door_L","door_R"];}};
		case (_veh isKindOf "B_CTRG_Heli_Transport_01_tropic_F"): {if ((_veh doorPhase "door_R") == 0) then {{_veh animateDoor [_x, 1]} forEach ["door_L","door_R"];} else {{_veh animateDoor [_x, 0]} forEach ["door_L","door_R"];}};
		case (_veh isKindOf "B_Heli_Transport_01_F"): {if ((_veh doorPhase "door_R") == 0) then {{_veh animateDoor [_x, 1]} forEach ["door_L","door_R"];} else {{_veh animateDoor [_x, 0]} forEach ["door_L","door_R"];}};
		case (_veh isKindOf "I_Heli_Transport_02_F"): {if (_veh animationPhase "door_back_R" < 0.5) then {{_veh animateDoor [_x, 1]} forEach ["door_back_L","door_back_R"];} else {{_veh animateDoor [_x, 0]} forEach ["door_back_L","door_back_R"];}};//_veh animateDoor ["CargoRamp_Open",1]
		case (_veh isKindOf "O_Heli_Attack_02_black_F"): {if ((_veh doorPhase "door_R") == 0) then {{_veh animateDoor [_x, 1]} forEach ["door_L","door_R"];} else {{_veh animateDoor [_x, 0]} forEach ["door_L","door_R"];}};
		case (_veh isKindOf "O_Heli_Attack_02_F"): {if ((_veh doorPhase "door_R") == 0) then {{_veh animateDoor [_x, 1]} forEach ["door_L","door_R"];} else {{_veh animateDoor [_x, 0]} forEach ["door_L","door_R"];}};
		case ((_veh isKindOf "RHS_CH_47F_10") || (_veh isKindOf "RHS_CH_47F_light")): {if (_veh animationPhase "Door_Back_R" < 0.5) then {{_veh animateDoor [_x, 1]} forEach ["Door_Back_L","Door_Back_R"];} else {{_veh animateDoor [_x, 0]} forEach ["Door_Back_L","Door_Back_R"];}};
		case (_veh isKindOf "CH49_Mohawk_FG"): {if (_veh animationPhase "door_back_R" < 0.5) then {{_veh animateDoor [_x, 1]} forEach ["door_back_L","door_back_R"];} else {{_veh animateDoor [_x, 0]} forEach ["door_back_L","door_back_R"];}};//_veh animateDoor ["CargoRamp_Open",1]
		case (_veh isKindOf "kyo_MH47E_base"): {if ((_veh doorPhase "Ani_Hatch1") == 0) then {{_veh animateDoor [_x, 1]} forEach ["Ani_Hatch1","Ani_Hatch2"];} else {{_veh animateDoor [_x, 0]} forEach ["Ani_Hatch1","Ani_Hatch2"];}};
		default {};
	};
};
AmbExRadio_fnc = {
	// Ambient Radio Chatter in/near Vehicles (TPW code) modified by Jigsor
	if (ambRadioChatter isEqualTo 1 || !hasInterface) exitWith {};
	for "_i" from 0 to 4 do {
		if (!(isNull objectParent player) && {!(objectParent player isKindOf "ParachuteBase")} && {!(objectParent player isKindOf "StaticWeapon")}) then {
			playmusic format ["RadioAmbient%1",floor (random 31)];
		} else {
			private _veh = ((position player) nearEntities ["Air", 10]) select 0;
			if !(isNil "_veh") then {
				private _sound = format ["A3\Sounds_F\sfx\radio\ambient_radio%1.wss",floor (random 31)];
				playsound3d [_sound,_veh,true,getPosasl _veh,1,1.1,20];
			};
		};
		sleep 30;
	};
};
remove_carcass_fncJE = {
	// Deletes dead bodies and destroyed vehicles. Code by BIS.
	params ["_unit"];
	if !(_unit isKindOf "Man") then {
		{_x setpos position _unit} forEach crew _unit;
		sleep 30.0;
		deletevehicle _unit;
	};
	if (_unit isKindOf "Man") then {
		if !((vehicle _unit) isKindOf "Man") then {_unit setpos (position vehicle _unit)};
		[_unit] joinSilent grpNull;
		sleep 35.0;
		_unit removeAllEventHandlers "killed";
		hideBody _unit;
	};
};
JigEx_RemoteGetoutMan = {
	params ["_pilot"];
	_pilot addEventHandler ['Local',{
		if (_this select 1) then {
			(_this select 0) addEventHandler ['GetOutMan',{
				[_this select 0,(_this select 2)] spawn {
					sleep 2;
					if (alive(_this select 1)) then {_this select 0 moveInDriver (_this select 1)};
				};
			}];
			[(driver EvacHeliW1)] spawn JigEx_MoveToDrop;
		};
	}];
};
JigEx_MoveToDrop = {
	params ["_pilot"];
	// Set Evac helicopter waypoints and move to Drop Off LZ.
	_wPArray = waypoints (group EvacHeliW1);
	for "_i" from 0 to (count _wPArray -1) do {
		deleteWaypoint [(group EvacHeliW1), _i]
	};
	EvacHeliW1 setdamage 0;
	EvacHeliW1 setfuel 1;
	EvacHeliW1 allowdamage JIG_EX_damage;
	sleep 0.1;
	[EvacHeliW1] call animate_doors_fnc;
	sleep 2;

	_pilot action ["engineOn", EvacHeliW1];
	sleep 2;
	_pilot doMove (getPosATL DropLZpad);
	sleep 2;
	private _wp1 = (group EvacHeliW1) addWaypoint [(getPosATL DropLZpad), 1];
	_wp1 setWaypointType "MOVE";
	_wp1 setWaypointSpeed "NORMAL";
	_wp1 setWaypointBehaviour "CARELESS";
	_wp1 setWaypointCombatMode "GREEN";// Hold fire - defend only.
	_wp1 setWaypointVisible false;
	_wp1 setWaypointStatements [
		"true",
		"doStop EvacHeliW1;
			EvacHeliW1 land 'LAND';
			hint 'LZ In Sight';
			0 = 0 spawn Drop_LZ_smoke_fnc;
			0 = 0 spawn {
				waitUntil {sleep 1; (getPosatl EvacHeliW1 select 2) < 4};
				if (!isNil 'animate_doors_fnc') then {[EvacHeliW1] call animate_doors_fnc};
			};
		EvacHeliW1 engineOn true;"
	];
	[group EvacHeliW1, currentWaypoint (group EvacHeliW1)] setWaypointVisible false;
};
JigEx_getout_nonGrouped = {if (hasInterface) then {_this select 0 action ["getOut", (_this select 1)]};};
JigEx_heliMkr = {
	waitUntil {sleep 1; !(isNull (findDisplay 12))};
	if (isNil "EvacHeliW1") then {EvacHeliW1 = objNull};
	findDisplay 12 displayCtrl 51 ctrlAddEventHandler ["Draw", "
		if (!isNull EvacHeliW1) then {
			_this # 0 drawIcon [
				'iconHelicopter',
				missionNamespace getVariable ['JIGEXcolor',[0,0,1,1]],
				getPosWorld EvacHeliW1,
				24,
				24,
				getDir EvacHeliW1,
				localize 'STR_BMR_heli_extraction',
				1,
				0.03,
				'RobotoCondensed',
				'right'
			];
		};
	"];
};
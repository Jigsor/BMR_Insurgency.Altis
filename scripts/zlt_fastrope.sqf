// v1g Fast Rope by [STELS]Zealot

#define MAX_SPEED_WHILE_FASTROPING 10
#define MAX_SPEED_ROPES_AVAIL 30
#define STR_TOSS_ROPES "Toss Ropes"
#define STR_FAST_ROPE "Fast Rope"
#define STR_CUT_ROPES "Cut Ropes"

if (!hasInterface) exitwith {};
waituntil {!isNull player && player == player};

zlt_rope_ropes = [];
zlt_mutexAction = false;

zlt_rope_helis = ["O_Heli_Light_02_unarmed_F","O_Heli_Light_02_F","B_Heli_Transport_01_F","B_CTRG_Heli_Transport_01_tropic_F","B_CTRG_Heli_Transport_01_sand_F","RHS_UH60M","RHS_UH60M_d","RHS_UH60M_MEV","CAF_CH146_SF","ST1_UH_80_MED_FG","B_Heli_Transport_01_camo_F","O_Heli_Attack_02_F","O_Heli_Attack_02_black_F","I_Heli_Transport_02_F","B_Heli_Light_01_F","B_Heli_Light_01_dynamicLoadout_F","B_Heli_Transport_03_F","B_Heli_Transport_03_unarmed_F","I_Heli_light_03_F","I_Heli_light_03_unarmed_F","I_Heli_light_03_dynamicLoadout_F","I_E_Heli_light_03_unarmed_F","I_E_Heli_light_03_dynamicLoadout_F"];
zlt_rope_helidata =
[
	[
		["O_Heli_Light_02_unarmed_F","O_Heli_Light_02_F"],
		[1.35,1.35,-1.95],
		[-1.45,1.35,-1.95]
	],
	[
		["B_Heli_Transport_01_F","B_Heli_Transport_01_camo_F","RHS_UH60M", "RHS_UH60M_d","RHS_UH60M_MEV","CAF_CH146_SF","ST1_UH_80_MED_FG"],
		[-1.11,2.5,-1.7],
		[1.11,2.5,-1.7]
	],
	[
		["O_Heli_Attack_02_F","O_Heli_Attack_02_black_F"],
		[1.3,1.3,-1],
		[-1.3,1.3,-1]
	],
	[
		["I_Heli_Transport_02_F"],
		[0,-5,-2.2],
		[]
	],
	[
		["B_Heli_Light_01_F","B_Heli_Light_01_dynamicLoadout_F"],
		[0.6,0.5,-0.9],
		[-0.8,0.5,-0.9]
	],
	[
		["B_Heli_Transport_03_F","B_Heli_Transport_03_unarmed_F"],
		[0,1.5,-2.9],
		[]
	],
	[
		["I_Heli_light_03_F","I_Heli_light_03_unarmed_F","I_Heli_light_03_dynamicLoadout_F","I_E_Heli_light_03_unarmed_F","I_E_Heli_light_03_dynamicLoadout_F"],
		[-1.22,1.5,-1.6],
		[1.22,1.5,-1.6]
	]
];

zlt_fnc_tossropes = {
	private ["_heli","_ropes","_oropes","_rope"];
	_heli = _this;
	_ropes = [];
	_oropes = _heli getvariable ["zlt_ropes",[]];
	if !(_oropes isEqualTo []) exitwith {};
	_i = 0;
	{
		if ((typeof _heli) in (_x select 0)) exitwith {
			_ropes = _ropes + [_x select 1];
			if ( count (_x select 2) !=0 ) then {
				_ropes = _ropes + [_x select 2];
			};
		};
		_i = _i +1;
	} foreach zlt_rope_helidata;

	sleep random 0.3;
	if ( count (_heli getvariable ["zlt_ropes",[]]) != 0 ) exitwith { zlt_mutexAction = false; };
	_heli animateDoor ['door_R', 1];
	_heli animateDoor ['door_L', 1];
	{
		_rope = ropeCreate [_this, [0,0,0], 35]; //35 length of the rope
		_rope setdir (getdir _heli);
		_rope attachto [_heli, _x];
		_oropes = _oropes + [_rope];
	} foreach _ropes;
	_heli setvariable ["zlt_ropes",_oropes,true];

	_heli spawn {
		private ["_heli","_ropes"];
		_heli = _this;
		while {alive _heli && count (_heli getvariable ["zlt_ropes", []]) != 0 && abs (speed _heli) < MAX_SPEED_ROPES_AVAIL } do {
			sleep 0.3;
		};
		_ropes = (_heli getvariable ["zlt_ropes", []]);
		{ropeDestroy _x} foreach _ropes;
		_heli setvariable ["zlt_ropes", [], true];
	};
};
zlt_fnc_ropes_cond = {
	_veh = vehicle player;
	_flag = (_veh != player) && {!zlt_mutexAction} && {player == driver vehicle player} && {(_veh getvariable ["zlt_ropes", []]) isEqualTo []} && { (typeof _veh) in zlt_rope_helis } && {alive player && alive _veh && (abs (speed _veh) < MAX_SPEED_ROPES_AVAIL ) };//only pilots can toss ropes
	//_flag = (_veh != player) && {!zlt_mutexAction)} && {(_veh getvariable ["zlt_ropes", []]) isEqualTo []} && { (typeof _veh) in zlt_rope_helis } && {alive player && alive _veh && (abs (speed _veh) < MAX_SPEED_ROPES_AVAIL ) };//any crew or passenger can toss ropes
	_flag;
};
zlt_fnc_fastropeaiunits = {
	diag_log ["zlt_fnc_fastropeaiunits", _this];
	params ["_heli","_grunits"];

	doStop (driver _heli );
	(driver _heli) setBehaviour "CARELESS";
	(driver _heli) setCombatMode "BLUE";

	_heli spawn zlt_fnc_tossropes;

	[_heli, _grunits] spawn {
		params ["_heli","_units"];
		sleep random 0.5;
		_units = _units - [player];
		_units = _units - [driver _heli];
		{if (!alive _x or isplayer _x or vehicle _x != _heli) then {_units = _units - [_x];}; } foreach _units;

		{ sleep (0.5 + random 0.7); _x spawn zlt_fnc_fastropeUnit; } foreach _units;
		waituntil {sleep 0.5; { (getpos _x select 2) < 1 } count _units == count _units; };
		sleep 10;
		(driver _heli) doFollow (leader group (driver _heli ));
		(driver _heli) setBehaviour "AWARE";
		(driver _heli) setCombatMode "WHITE";
		_heli call zlt_fnc_cutropes;
	};
};
zlt_fnc_fastrope = {
	diag_log ["fastrope", _this];
	zlt_mutexAction = true;
	sleep random 0.3;
	if (player == leader group player) then {
		[vehicle player, units group player] call zlt_fnc_fastropeaiunits;
	};
	player call zlt_fnc_fastropeUnit;
	zlt_mutexAction = false;
};
zlt_fnc_fastropeUnit = {
	private ["_unit","_veh","_ropes","_ropeSel","_ropePos"];
	_unit = _this;
	_veh = vehicle _unit;
	_ropes = (_veh getVariable ["zlt_ropes", []]);
	if (_ropes isEqualTo []) exitWith {};
	_ropeSel = selectRandom _ropes;
	_unit action ["getOut",_veh];
	sleep 0.5;
	_unit leaveVehicle _veh;
	moveOut _unit;
	_unit allowDamage false;
	_ropePos = (ropeEndPosition _ropeSel) select 0;
	_unit setPosATL [(_ropePos select 0),(_ropePos select 1),(_ropePos select 2) -0.5];
	_unit switchMove "LadderRifleStatic";
	While {alive _unit && (((getPos _unit) select 2) > 1)} do
	{
		_unit switchMove "LadderRifleStatic";
	};
	_unit setVelocity [0,0,0];
	_unit playMove "LadderRifleDownOff";
	_unit allowDamage true;
};
zlt_fnc_cutropes = {
	_veh = _this;
	_ropes = (_veh getvariable ["zlt_ropes", []]);
	{deletevehicle _x} foreach _ropes;
	_veh setvariable ["zlt_ropes", [], true];
	_veh animateDoor ['door_R', 0];
	_veh animateDoor ['door_L', 0];
};
zlt_fnc_removeropes = {
	(vehicle player) call zlt_fnc_cutropes;
};
zlt_fnc_createropes = {
	zlt_mutexAction = true;
	(vehicle player) call zlt_fnc_tossropes;
	zlt_mutexAction = false;
};

zlt_fastrope_acts = {
	player addAction["<t color='#ffff00'>"+STR_TOSS_ROPES+"</t>", zlt_fnc_createropes, [], -1, false, false, '','[] call zlt_fnc_ropes_cond'];
	player addAction["<t color='#ff0000'>"+STR_CUT_ROPES+"</t>", zlt_fnc_removeropes, [], -1, false, false, '','!zlt_mutexAction && count ((vehicle player) getvariable ["zlt_ropes", []]) != 0'];
	player addAction["<t color='#00ff00'>"+STR_FAST_ROPE+"</t>", zlt_fnc_fastrope, [], 15, false, false, '','!zlt_mutexAction && count ((vehicle player) getvariable ["zlt_ropes", []]) != 0 && player != driver vehicle player'];
};
call zlt_fastrope_acts;

player addEventHandler ["Respawn", {call zlt_fastrope_acts;}];
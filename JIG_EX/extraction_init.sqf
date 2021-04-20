/*
 extraction_init.sqf v1.28 by Jigsor
 null = [] execVM "JIG_EX\extraction_init.sqf";
 runs in init.sqf
*/

// Editable Global Variable Parameters ////////////////////////////////////////////////////////////////////////////////
JIG_EX_Caller = 		{CAS1};							// Name of playable unit in editor who can call in Extraction Via scroll action, ie; s1, TeamLeader or TL1. This edit is required at the very least to run script pack.
JIG_EX_Chopper_Type	= 	["B_Heli_Transport_01_F"];		// Desired Evac Chopper classname in quotes and array.
JIG_EX_Side			=	WEST;							// Side or Group Chopper belongs to, ie. RESISTANCE EAST WEST EvacGroup
JIG_EX_Chopper_size = 	14;								// 12 meters is good for GhostHawk.//If to small chopper cannot land. If to large, clear enough area will not be found.
JIG_EX_Spawn_Dis = 		1400;							// Chopper spawns at this distance from actual evac marker and flies in.
JIG_EX_Clear_Pos_Dis = 	45;								// Max possible range in meters between requested evac/drop marker and actual evac/drop marker used to find random clear position to land.// If too small, clear enough area will not be found. Depends on terrain.
JIG_EX_Smoke_Color = 	"SmokeShellOrange";				// Possible Smoke colors classname in quotes goes here, ie: "SmokeShellOrange","SmokeShellBlue","SmokeShellPurple","SmokeShellGreen","SmokeShellRed","SmokeShell".
JIG_EX_Despawn_Time	= 	60;								// Delete Chopper timer. Starts after chopper reaches destination and caller's group disembarks. Action does not return until this completes or chopper destroyed.
JIG_EX_damage	=		false;							// true allows damage to be taken / false prohibits damage to be taken.
JIG_EX_Group_Dis	=	500;							// Ungroup group members beyond range of Evac Caller.//Chopper will not Leave Evac LZ until all group members in this range are in chopper
JIG_EX_AmbRadio		=	true;							// Ambient Heli Radio Chatter. Set true to enable. Set false to disable.
JIG_EX_Random_Type	=	true;							// Select random Heli Type from JIG_EX_Chopper_Type. If False, Fist Vehicle in array JIG_EX_Chopper_Type is chosen. Example: JIG_EX_Chopper_Type = ["B_Heli_Transport_01_camo_F","CH49_Mohawk_FG"];
JIG_EX_gunners		= 	false;							// Set false to make side gunners position empty and available to passengers. Set true to spawn chopper with side gunners/crew with default bis_fnc_spawnvehicle. "false" value tested to support "B_Heli_Transport_01_camo_F" GhostHawk.
////////////////////////////////////////////////////////// JIG_EX_gunners = false Tested to Support: "B_Heli_Transport_01_camo_F" "CH49_Mohawk_FG".
////////////////////////////////////////////////////////// JIG_EX_gunners = true Tested to Support: "B_Heli_Transport_01_camo_F"
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

jig_ex_actid_show = 9999;
private _sideColor = [JIG_EX_Side, false] call BIS_fnc_sideColor;
missionNamespace setVariable ["JIGEXcolor", _sideColor];

waitUntil {isDedicated || !isNull player};

call compile preProcessFileLineNumbers "JIG_EX\extraction_fncs.sqf";
if (hasInterface && {side player isEqualTo JIG_EX_Side}) then {0 spawn JigEx_heliMkr};

//JIP Hosted server
if ((!isServer) && (isNil JIG_EX_Caller)) exitWith {};//exit if not caller or Server working on hosted Server
if ((!isServer) && (isNil JIG_EX_Caller)) then {breakOut "exit";};// exit client on Dedi
if ((!isDedicated) && (isNil JIG_EX_Caller)) then {waitUntil {sleep 10; !isNil JIG_EX_Caller};};// Player/Caller wait until caller's slot has player

//JIP Dedicated Server
if (isDedicated) then {waitUntil {!isNil JIG_EX_Caller};};
// Editing the following line required./////////////////////////////////////////////////////////////////////////////////
JIG_EX_Caller = CAS1;// Name of playable unit in editor who can call in Extraction Via scroll action, ie; s1, TeamLeader or TL1. This edit is required at the very least to run script pack.

private _all_players = playableUnits;
if ((isServer) && (! (JIG_EX_Caller in _all_players))) then {waitUntil {sleep 10; (JIG_EX_Caller in _all_players)};};// Server wait until caller's slot has player

ext_caller_group = grpNull;
evac_toggle = false;
"evac_toggle" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};

if (isServer) then {
	0 = 0 spawn {
		EvacHeliW1 = ObjNull;
		ext_caller_group = grpNull;
		resetEvac = false;
		"resetEvac" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
		while {true} do {
			if (resetEvac) then {
				JIG_EX_Caller = CAS1;
				publicVariable "JIG_EX_Caller";// JIP reset
				sleep 1;
				call JIP_Reset_Evac_fnc;
			};
			sleep 5;
		};
	};
};
sleep 1;

// Player
if (!isDedicated) then {
	waitUntil {!isNull player && player == player};
	waitUntil {sleep 3; alive player};
	if (not (JIG_EX_Caller == player)) exitWith {};
	EvacHeliW1 = ObjNull;
	resetEvac = true;
	publicVariable "resetEvac";
	private _ex_caller = JIG_EX_Caller;
	_ex_caller addEventHandler ["killed", {_nul = _this execVM "JIG_EX\respawnAddActionHE.sqf";}];
};// addaction on player killed/ reset Evac for JIP JIG_EX_Caller

waitUntil {evac_toggle};
while {true} do {
	if (evac_toggle) then {
		// Server
		if (isServer) then {
			if (isDedicated) then {sleep 6};
			null = [] execVM "JIG_EX\extraction_main.sqf";
			sleep 3;
			ex_group_ready = false;
			publicVariable "ex_group_ready";
		};
		// Hosted server/Player
		if (!isDedicated) then {
			if (!(isNull player)) then {
				sleep 5;// wait for server eventhandlers to initialize
				if (JIG_EX_Caller == player) then {
					jig_ex_actid_show = 9999;
					private _ex_caller = JIG_EX_Caller;
					_ex_caller removeaction jig_ex_actid_show;
					jig_ex_actid_show = _ex_caller addAction [("<t color='#12F905'>") + (localize "STR_BMR_heli_extraction") + "</t>","JIG_EX\extraction_player.sqf",JIG_EX_Caller removeAction jig_ex_actid_show,1, false, true,"","player ==_target"];
				};
			};
		};
		evac_toggle = false;
		publicVariable "evac_toggle";
	};
	while {!evac_toggle} do {sleep 3;};
	// Hosted server/Player
	if (!isDedicated) then {
		if (!(isNull player)) then {
			if (JIG_EX_Caller == player) then {
				player removeaction jig_ex_cancelid_show;
			};
		};
	};
};
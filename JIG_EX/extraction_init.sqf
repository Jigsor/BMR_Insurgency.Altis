/*
 extraction_init.sqf v1.25 by Jigsor
 null = [] execVM "JIG_EX\extraction_init.sqf";
 runs in init.sqf
 This is still WIP
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

waitUntil {isDedicated || !isNull player};

[] call compile preProcessFile "JIG_EX\extraction_fncs.sqf";

//JIP Hosted server
if ((!isServer) and (isNil JIG_EX_Caller)) exitWith {};//exit if not caller or Server working on hosted Server
if ((!isServer) and (isNil JIG_EX_Caller)) then {breakOut "exit";};// exit client on Dedi
if ((!isDedicated) and (isNil JIG_EX_Caller)) then {waitUntil {sleep 10; !isNil JIG_EX_Caller};};// Player/Caller wait until caller's slot has player

//JIP Dedicated Server
if (isDedicated) then {waitUntil {!isNil JIG_EX_Caller};};
// Editing the following line required./////////////////////////////////////////////////////////////////////////////////
JIG_EX_Caller = CAS1;// Name of playable unit in editor who can call in Extraction Via scroll action, ie; s1, TeamLeader or TL1. This edit is required at the very least to run script pack.

private _all_players = playableUnits;
if ((isServer) and (not (JIG_EX_Caller in _all_players))) then {waitUntil {sleep 10; (JIG_EX_Caller in _all_players)};};// Server wait until caller's slot has player

ext_caller_group = grpNull;
evac_toggle = false;
"evac_toggle" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};

if (isServer) then {
	[] spawn {
		private "_loop";
		EvacHeliW1 = ObjNull;
		ext_caller_group = grpNull;
		resetEvac = false;
		"resetEvac" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
		for [{_loop=0}, {_loop<1}, {_loop=_loop}] do {
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

/*
// Chopper DisplayName/ClassName
// A3:	MH-9 Hummingbird "B_Heli_Light_01_F", PO-30 Orca "O_Heli_Light_02_F", PO-30 Orca [Black] "O_Heli_Light_02_unarmed_F", UH-80 Ghost Hawk "B_Heli_Transport_01_F", UH-80 Ghost Hawk [Camo] "B_Heli_Transport_01_camo_F", CH-49 Mohawk "I_Heli_Transport_02_F", WY-55 Hellcat "I_Heli_light_03_F", WY-55 Hellcat [Green] "I_Heli_light_03_unarmed_F"
// Moded HAFM helis @hafm_helis: UH60M "UH60M", UH60M_MEV "UH60M_MEV", CH47F "CH_47F".
// Moded Blufor Wildcat @NATO_HELCAT: AW159 Armed Camo "AW159_Armed_Camo", AW-159 Transport Camo "AW159_Transport_Camo", AW-159 Transport Black "AW159_Transport_Black", AW159 Transport Grey "AW159_Transport_Grey"
// Moded Boeing/SOAR MH-47E: "kyo_MH47E_base", "kyo_MH47E_HC", "kyo_MH47E_Ramp" Co-pilot is Gunner01. Left Gunner is Gunner02. Right Gunner is Gunner03. Loadmaster is Gunner04. Backcrew is Gunner05. //"kyo_MH47E_base" not supported
// Moded Blufor Mmohawk @KDK_Mohawk;"CH49_Mohawk_FG"
// Moded @RHSUSF3 Chinnoks ,"RHS_CH_47F_10","RHS_CH_47F_light" (JIG_EX_gunners = true not tested).
*/
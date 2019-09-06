/*
Created by =BTC= Giallustio
version 0.98 Offical release
Visit us at:
http://www.blacktemplars.altervista.org/
06/03/2012
*/

////////////////// EDITABLE \\\\\\\\\\\\\\\\\\\\\\\\\\

switch (INS_p_rev) do {
	case 0 : {
		BTC_who_can_revive = ["Man"];
		BTC_objects_actions_west = [];
		BTC_objects_actions_east = [];
		BTC_objects_actions_guer = [];
		BTC_objects_actions_civ  = [];
		if (isServer) then {
			BTC_vehs_mobile_west = [];
			BTC_vehs_mobile_east = [];
			BTC_vehs_mobile_guer = [];
			BTC_vehs_mobile_civ  = [];
		};
	};
	case 1 : {
		BTC_who_can_revive = ["Man"];
		BTC_objects_actions_west = [INS_flag];
		BTC_objects_actions_east = [INS_Op4_flag];
		BTC_objects_actions_guer = [];
		BTC_objects_actions_civ  = [];
		if (isServer) then {
			BTC_vehs_mobile_west = [MHQ_1, MHQ_2, MHQ_3];//Editable - define mobile west
			BTC_vehs_mobile_east = [Opfor_MHQ];//Editable - define mobile east
			BTC_vehs_mobile_guer = [];//Editable - define mobile independent
			BTC_vehs_mobile_civ  = [];//Editable - define mobile civilian
		};
	};
	case 2 : {
		BTC_who_can_revive = INS_all_medics;
		BTC_objects_actions_west = [];
		BTC_objects_actions_east = [];
		BTC_objects_actions_guer = [];
		BTC_objects_actions_civ  = [];
		if (isServer) then {
			BTC_vehs_mobile_west = [];
			BTC_vehs_mobile_east = [];
			BTC_vehs_mobile_guer = [];
			BTC_vehs_mobile_civ  = [];
		};
	};
	case 3 : {
		BTC_who_can_revive = INS_all_medics;
		BTC_objects_actions_west = [INS_flag];
		BTC_objects_actions_east = [INS_Op4_flag];
		BTC_objects_actions_guer = [];
		BTC_objects_actions_civ  = [];
		if (isServer) then {
			BTC_vehs_mobile_west = [MHQ_1, MHQ_2, MHQ_3];//Editable - define mobile west
			BTC_vehs_mobile_east = [Opfor_MHQ];//Editable - define mobile east
			BTC_vehs_mobile_guer = [];//Editable - define mobile independent
			BTC_vehs_mobile_civ  = [];//Editable - define mobile civilian
		};
	};
	case 6 : {
		BTC_who_can_revive = ["Man"];
		BTC_objects_actions_west = [];
		BTC_objects_actions_east = [];
		BTC_objects_actions_guer = [];
		BTC_objects_actions_civ  = [];
		if (isServer) then {
			BTC_vehs_mobile_west = [];
			BTC_vehs_mobile_east = [];
			BTC_vehs_mobile_guer = [];
			BTC_vehs_mobile_civ  = [];
		};
	};
	case 7 : {
		BTC_who_can_revive = ["Man"];
		BTC_objects_actions_west = [INS_flag];
		BTC_objects_actions_east = [INS_Op4_flag];
		BTC_objects_actions_guer = [];
		BTC_objects_actions_civ  = [];
		if (isServer) then {
			BTC_vehs_mobile_west = [MHQ_1, MHQ_2, MHQ_3];//Editable - define mobile west
			BTC_vehs_mobile_east = [Opfor_MHQ];//Editable - define mobile east
			BTC_vehs_mobile_guer = [];
			BTC_vehs_mobile_civ  = [];
		};
	};
};
BTC_revive_time_min	= 5;
BTC_revive_time_max	= INS_p_rev_time;
BTC_disable_respawn	= 0;
BTC_active_lifes	= 1;
BTC_lifes			= 99;
BTC_spectating		= 0;//0 = disable; 1 = units group; 2 = side units; 3 = all units
BTC_spectating_view	= [0,0];//To force a view set the first number of the array to 1. The second one is the view mode: 0 = first person; 1 = behind the back; 2 = High; 3 = free
BTC_s_mode_view		= ["First person","Behind the back","High","Free"];
BTC_black_screen	= 0;//Black screen + button while unconscious or action wheel and clear view
BTC_action_respawn	= 0;//if black screen is set to 0 you can choose if you want to use the action wheel or the button. Keep in mind that if you don't use the button, the injured player can use all the action, frag too....
BTC_camera_unc		= 1;
BTC_camera_unc_type	= ["Behind the back","High","Free"];
BTC_respawn_time	= 0;
BTC_active_mobile	= 1;//Active mobile respawn (You have to put in map the vehicle and give it a name. Then you have to add one object per side to move to the mobile (INS_flag,INS_Op4_flag) - (1 = yes, 0 = no))
BTC_mobile_respawn	= 1;//Active the mobile respawn fnc (1 = yes, 0 = no)
BTC_mobile_respawn_time = 30;//Secs delay for mobile vehicle to respawn
BTC_need_first_aid  = 1;//You need a first aid kit to revive (1 = yes, 0 = no)
BTC_pvp				= 1;//(disable the revive option for the enemy)
BTC_injured_marker	= 1;
BTC_3d_can_see		= ["Man"];
BTC_3d_distance		= 30;
BTC_3d_icon_size	= 0.5;
BTC_3d_icon_color	= [1,0,0,1];
BTC_dlg_on_respawn	= 1;//1 = Mobile only - 2 Leader group and mobile - 3 = Units group and mobile - 4 = All side units and mobile

if (INS_p_rev in [6,7]) then {//No Respawn, only revive. Will spectate if bled out or respawn forced.
	BTC_lifes = 1;
	BTC_spectating = 3;
};

////////////////// Don't edit below \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//FNC
call compile preprocessFileLineNumbers "=BTC=_revive\=BTC=_functions.sqf";

if (isServer) then {
	//Mobile
	BTC_vehs_mobile_west_str = [];BTC_vehs_mobile_east_str = [];BTC_vehs_mobile_guer_str = [];BTC_vehs_mobile_civ_str = [];
	if (BTC_active_mobile isEqualTo 1 && !(BTC_vehs_mobile_west isEqualTo [])) then {for "_i" from 0 to ((count BTC_vehs_mobile_west) - 1) step 1 do {_veh = (BTC_vehs_mobile_west select _i);_var = str (_veh);BTC_vehs_mobile_west_str = BTC_vehs_mobile_west_str + [_var];_veh setVariable ["BTC_mobile_west",_var,true];if (BTC_mobile_respawn isEqualTo 1) then {_resp = [_veh,_var,"BTC_mobile_west"] spawn BTC_vehicle_mobile_respawn;};};} else {{deleteVehicle _x} foreach BTC_vehs_mobile_west;};
	if (BTC_active_mobile isEqualTo 1 && !(BTC_vehs_mobile_east isEqualTo [])) then {for "_i" from 0 to ((count BTC_vehs_mobile_east) - 1) do {_veh = (BTC_vehs_mobile_east select _i);_var = str (_veh);BTC_vehs_mobile_east_str = BTC_vehs_mobile_east_str + [_var];_veh setVariable ["BTC_mobile_east",_var,true];if (BTC_mobile_respawn isEqualTo 1) then {_resp = [_veh,_var,"BTC_mobile_east"] spawn BTC_vehicle_mobile_respawn;};};} else {{deleteVehicle _x} foreach BTC_vehs_mobile_east;};
	if (BTC_active_mobile isEqualTo 1 && !(BTC_vehs_mobile_guer isEqualTo [])) then {for "_i" from 0 to ((count BTC_vehs_mobile_guer) - 1) do {_veh = (BTC_vehs_mobile_guer select _i);_var = str (_veh);BTC_vehs_mobile_guer_str = BTC_vehs_mobile_guer_str + [_var];_veh setVariable ["BTC_mobile_guer",_var,true];if (BTC_mobile_respawn isEqualTo 1) then {_resp = [_veh,_var,"BTC_mobile_guer"] spawn BTC_vehicle_mobile_respawn;};};} else {{deleteVehicle _x} foreach BTC_vehs_mobile_guer;};
	if (BTC_active_mobile isEqualTo 1 && !(BTC_vehs_mobile_civ isEqualTo [])) then {for "_i" from 0 to ((count BTC_vehs_mobile_civ) - 1) do {_veh = (BTC_vehs_mobile_civ select _i);_var = str (_veh);BTC_vehs_mobile_civ_str = BTC_vehs_mobile_civ_str + [_var];_veh setVariable ["BTC_mobile_civ",_var,true];if (BTC_mobile_respawn isEqualTo 1) then {_resp = [_veh,_var,"BTC_mobile_civ"] spawn BTC_vehicle_mobile_respawn;};};} else {{deleteVehicle _x} foreach BTC_vehs_mobile_civ;};
	if (BTC_active_mobile isEqualTo 1) then {publicVariable "BTC_vehs_mobile_west_str";publicVariable "BTC_vehs_mobile_east_str";publicVariable "BTC_vehs_mobile_guer_str";publicVariable "BTC_vehs_mobile_civ_str";};

	BTC_killed_pveh = [];publicVariable "BTC_killed_pveh";
	BTC_drag_pveh = [];publicVariable "BTC_drag_pveh";
	BTC_carry_pveh = [];publicVariable "BTC_carry_pveh";
	BTC_marker_pveh = [];publicVariable "BTC_marker_pveh";
	BTC_load_pveh = [];publicVariable "BTC_load_pveh";
	BTC_pullout_pveh = [];publicVariable "BTC_pullout_pveh";
};
if (isDedicated) exitWith {};

BTC_dragging = false;
BTC_respawn_cond = false;
//Init
0 spawn {
	waitUntil {!isNull player && player == player};
	"BTC_drag_pveh" addPublicVariableEventHandler BTC_fnc_PVEH;
	"BTC_carry_pveh" addPublicVariableEventHandler BTC_fnc_PVEH;
	"BTC_marker_pveh" addPublicVariableEventHandler BTC_fnc_PVEH;
	"BTC_load_pveh" addPublicVariableEventHandler BTC_fnc_PVEH;
	"BTC_pullout_pveh" addPublicVariableEventHandler BTC_fnc_PVEH;
	"BTC_killed_pveh" addPublicVariableEventHandler BTC_fnc_PVEH;
	BTC_r_mobile_selected = objNull;
	BTC_r_bleeding = 0;
	BTC_r_bleeding_loop = false;
	//player addRating 9999;//<- redundant, initial rating applied in =BTC=_tk_init.sqf Team Kill punishment script.
	BTC_r_list = [];
	BTC_side = playerSide;
	BTC_r_s_cam_view = [-15,-15,15];
	BTC_respawn_marker = format ["respawn_%1",playerSide];
	if (BTC_respawn_marker == "respawn_guer") then {BTC_respawn_marker = "respawn_guerrila"};
	if (BTC_respawn_marker == "respawn_civ") then {BTC_respawn_marker = "respawn_civilian"};
	BTC_r_base_spawn = "Land_ClutterCutter_small_F" createVehicleLocal markerPos BTC_respawn_marker;
	player addEventHandler ["Killed", BTC_player_killed];
	player setVariable ["BTC_need_revive",0,true];
	//{_x setVariable ["BTC_need_revive",0,true];} foreach allunits;//[] spawn {while {true} do {sleep 0.1;player sidechat format ["%1",BTC_r_mobile_selected];};};
	if (BTC_pvp isEqualTo 1) then {player setVariable ["BTC_revive_side",str (BTC_side),true]};
	player setVariable ["BTC_dragged",0,true];

	//player actions
	0 spawn BTC_assign_actions;

	if (BTC_active_mobile isEqualTo 1) then {
		switch (true) do {
			case (BTC_side isEqualTo WEST) : {
				waitUntil {!isNil "BTC_vehs_mobile_west_str"};
				{
					private _veh = _x;
					_spawn = [_x] spawn BTC_mobile_marker;
					{
						_x addAction [("<t size='1.5' shadow='2' color='#ED2744'>") + ("Move to mobile " + _veh) + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[_veh],BTC_move_to_mobile], 8, true, true, "", format ["['%1'] call BTC_mobile_check",_veh]];
					} foreach BTC_objects_actions_west;
				} foreach BTC_vehs_mobile_west_str;
			};
			case (BTC_side isEqualTo EAST) : {
				waitUntil {!isNil "BTC_vehs_mobile_east_str"};
				{
					private _veh = _x;
					_spawn = [_x] spawn BTC_mobile_marker;
					{
						_x addAction [("<t size='1.5' shadow='2' color='#ED2744'>") + ("Move to mobile " + _veh) + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[_veh],BTC_move_to_mobile], 8, true, true, "", format ["['%1'] call BTC_mobile_check",_veh]];
					} foreach BTC_objects_actions_east;
				} foreach BTC_vehs_mobile_east_str;
			};
			case (str(BTC_side) isEqualTo "GUER") : {
				waitUntil {!isNil "BTC_vehs_mobile_guer_str"};
				{
					private _veh = _x;
					_spawn = [_x] spawn BTC_mobile_marker;
					{
						_x addAction [("<t size='1.5' shadow='2' color='#ED2744'>") + ("Move to mobile " + _veh) + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[_veh],BTC_move_to_mobile], 8, true, true, "", format ["['%1'] call BTC_mobile_check",_veh]];
					} foreach BTC_objects_actions_guer;
				} foreach BTC_vehs_mobile_guer_str;
			};
			case (str(BTC_side) == "civ") : {
				waitUntil {!isNil "BTC_vehs_mobile_civ_str"};
				{
					private _veh = _x;
					_spawn = [_x] spawn BTC_mobile_marker;
					{
						_x addAction [("<t size='1.5' shadow='2' color='#ED2744'>") + ("Move to mobile " + _veh) + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[_veh],BTC_move_to_mobile], 8, true, true, "", format ["['%1'] call BTC_mobile_check",_veh]];
					} foreach BTC_objects_actions_civ;
				} foreach BTC_vehs_mobile_civ_str;
			};
		};
	}
	else
	{
		BTC_vehs_mobile_west_str = [];BTC_vehs_mobile_east_str = [];BTC_vehs_mobile_guer_str = [];BTC_vehs_mobile_civ_str = [];
	};
	if (({player isKindOf _x} count BTC_3d_can_see) > 0) then {
		_3d = if (BTC_pvp isEqualTo 1) then {[] spawn BTC_3d_markers_pvp} else {[] spawn BTC_3d_markers};
	};
	BTC_revive_started = true;
	//hint "REVIVE STARTED";
};
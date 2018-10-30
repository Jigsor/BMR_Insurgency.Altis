/*
Created by =BTC= Giallustio

Visit us at:
http://www.blacktemplars.altervista.org/
06/03/2012
*/
//Functions
BTC_assign_actions = {
	if ([player] call BTC_is_class_can_revive) then {//Jig changed addaction to hold action
		ReviveAcc_id =
		[
			player,
			(localize "str_a3_cfgrespawntemplates_revive_displayname"),
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_revive_ca.paa",
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa",
			"[] call BTC_check_action_first_aid",
			"true",
			{player playMove "AinvPknlMstpSlayWrflDnon_medic"},
			{}, //{hintSilent ""},
			{
				private _revived = call BTC_first_aid;
				if (!isNull _revived) then {
					private _txt = format ["%1 revived %2", name player, name _revived];
					if (side player isEqualTo INS_Blu_side) then {
						[_txt] remoteExec ["JIG_MPsideChatWest_fnc", [0,-2] select isDedicated];
					}else{
						[_txt] remoteExec ["JIG_MPsideChatEast_fnc", [0,-2] select isDedicated];
					};
				};
			},
			{[player, "AmovPknlMstpSrasWrflDnon"] remoteExec ["switchMoveEverywhere", 0]},
			[],
			6,
			8,
			false,
			false
		] call bis_fnc_holdActionAdd;
	};
	player addAction [("<t color='#ED2744'>") + (localize "STR_BTC_Drag") + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[],BTC_drag], 8, true, true, "", "[] call BTC_check_action_drag"];
	player addAction [("<t color='#ED2744'>") + (localize "STR_BTC_Pull_out_injured") + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[],BTC_pull_out], 8, true, true, "", "[] call BTC_pull_out_check"];
	player addAction [("<t color='#ED2744'>") + (localize "STR_BTC_Carry") + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[],BTC_carry], 8, true, true, "", "[] call BTC_check_action_drag"];
	//player addAction [("<t color='#ED2744'>") + "Extinguish Fire" + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[],JIG_Extinguish], 8, true, true, "", "[] call JIG_check_action_fire"];
};
/*
BTC_r_debug = {
	_unit = _this;
	[] spawn {BTC_r_debug_c = true;
	while {BTC_r_debug_c} do {
		hintSilent format ["STATUS: %1\nISBLEEDING: %2\nDAMAGE: %3 L = %4 H = %5\nUNC: %6",player getVariable "BTC_r_status",BTC_is_bleeding,BTC_r_damage,BTC_r_damage_legs,BTC_r_damage_hands,BTC_r_unc];
		sleep 0.05;
	};};
};
*/
BTC_fnc_PVEH = {
	//0 - first aid - create // [0,east,pos]
	//1 - first aid - delete
	_array = _this select 1;
	_type  = _array select 0;
	switch (true) do {
		case (_type isEqualTo 0) :
		{
			_side = _array select 1;
			_unit = _array select 3;
			if (_side == BTC_side) then {
				_pos = _array select 2;
				_marker = createmarkerLocal [format ["FA_%1", _pos], _pos];
				format ["FA_%1", _pos] setmarkertypelocal "mil_box";
				format ["FA_%1", _pos] setMarkerTextLocal format ["F.A. %1", name _unit];
				format ["FA_%1", _pos] setmarkerColorlocal "ColorGreen";
				format ["FA_%1", _pos] setMarkerSizeLocal [0.3, 0.3];
				[_pos,_unit] spawn
				{
					_pos  = _this select 0;
					_unit = _this select 1;
					while {(!(isNull _unit) && (format ["%1", _unit getVariable "BTC_need_revive"] == "1"))} do {
						format ["FA_%1", _pos] setMarkerPosLocal getpos _unit;
						sleep 1;
					};
					deleteMarker format ["FA_%1", _pos];
				};
			};
		};
		case (_type isEqualTo 1) : {(_array select 1) setDir 180;(_array select 1) playMoveNow "AinjPpneMstpSnonWrflDb_grab";};
		case (_type isEqualTo 2) :
		{
			private _injured = (_array select 1);
			[_injured] spawn {
				_injured = _this select 0;
				_injured allowDamage false;
				WaitUntil {sleep 1; (isNull _injured) || (format ["%1", _injured getVariable "BTC_need_revive"] == "0")};
				_injured allowDamage true;
			};
		};
		case (_type isEqualTo 3) :
		{
			private ["_injured","_veh"];
			_injured = (_array select 1);
			_veh     = (_array select 2);
			if (name _injured == name player) then {_injured moveInCargo _veh};
		};
		case (_type isEqualTo 4) :
		{
			private _array_injured = (_array select 1);
			{
				if (name player == name _x) then {unAssignVehicle player;player action ["getOut", vehicle player];_spawn = [] spawn {sleep 0.5;player switchMove "ainjppnemstpsnonwrfldnon";};};
			} foreach _array_injured;
		};
		case (_type isEqualTo 5) :
		{
			_spawn = [(_array select 1),(_array select 2)] spawn {
				_injured = _this select 0;
				_healer  = _this select 1;
				_injured setPos (_healer modelToWorld [0,1,0]);
				_injured setDir (getDir _healer + 180);
				_injured switchMove "AinjPfalMstpSnonWnonDnon_carried_up";
				WaitUntil {!Alive _healer || ((animationstate _healer == "acinpercmstpsraswrfldnon") || (animationstate _healer == "acinpercmrunsraswrfldf") || (animationstate _healer == "acinpercmrunsraswrfldr") || (animationstate _healer == "acinpercmrunsraswrfldl"))};
				_injured switchMove "AinjPfalMstpSnonWnonDf_carried_dead";
				sleep 0.2;
				_injured setDir 180;
			};
		};
		case (_type isEqualTo 6) :
		{
			_spawn = [(_array select 1)] spawn {
				params ["_injured"];
				[_injured, "AinjPfalMstpSnonWrflDnon_carried_down"] remoteExec ["switchMoveEverywhere", 0];
				sleep 3;
				if (format ["%1", _injured getVariable "BTC_need_revive"] == "1") then {
					[_injured, "ainjppnemstpsnonwrfldnon"] remoteExec ["switchMoveEverywhere", 0];
				};
			};
		};
		case (_type isEqualTo 7) :
		{
			private ["_injured","_cpr_bonus"];
			_injured = _array select 1;
			_cpr_bonus = _array select 2;
			if (name player == _injured) then {BTC_r_timeout = BTC_r_timeout + _cpr_bonus;};
		};
		case (_type isEqualTo 8) :
		{
			private _injured = _array select 1;
			if (name player == _injured) then {
				private ["_state","_bleed"];
				_state = (_injured getVariable "BTC_r_status");
				_bleed = (_state select 0) - 70;
				if (_bleed < 0) then {_bleed = 0;};
				_injured setVariable ["BTC_r_status",[0,_bleed,(_state select 2),(_state select 3),(_state select 4)],true];
			};
		};
		case (_type isEqualTo 9) :
		{
			private _injured = _array select 1;
			if (name player == _injured) then {
				BTC_r_damage = 0;BTC_r_head = 0;BTC_r_damage_legs = 0;BTC_r_damage_hands = 0;player forceWalk false;BTC_r_med_effect = false;player setHit ["legs", 0];player setHit ["hands", 0];
			};
		};
		case (_type isEqualTo 10) :
		{
			_unit = _array select 1;
			_anim = _array select 2;
			_unit switchMove _anim;
		};
	};
};
BTC_first_aid = {
	private ["_injured","_array_item_injured","_array_item","_cond"];
	_injured = objNull;
	_men = nearestObjects [player, ["Man"], 2];
	if (count _men < 2) exitWith {_injured};
	if (count _men > 1) then {_injured = _men select 1};
	if (format ["%1",_injured getVariable "BTC_need_revive"] != "1") exitWith {_injured};
	_array_item = items player;
	_array_item_injured = items _injured;
	_cond = false;
	if (BTC_need_first_aid isEqualTo 0) then {_cond = true};
	if ((_array_item_injured find "FirstAidKit" == -1) && (BTC_need_first_aid isEqualTo 1)) then {_cond = false;} else {_cond = true;};
	if ((!_cond && BTC_need_first_aid isEqualTo 1) && {_array_item find "FirstAidKit" == -1}) then {_cond = false;} else {_cond = true;};
	if (!_cond) exitWith {hint "Can't revive him"; _injured};
	if (BTC_need_first_aid isEqualTo 1 && {_array_item_injured find "FirstAidKit" == -1}) then {player removeItem "FirstAidKit"};
	waitUntil {!Alive player || (animationState player != "AinvPknlMstpSlayWrflDnon_medic" && animationState player != "amovpercmstpsraswrfldnon_amovpknlmstpsraswrfldnon" && animationState player != "amovpknlmstpsraswrfldnon_ainvpknlmstpslaywrfldnon" && animationState player != "ainvpknlmstpslaywrfldnon_amovpknlmstpsraswrfldnon")};
	if (Alive player && Alive _injured && format ["%1",player getVariable "BTC_need_revive"] == "0") then {
		_injured setVariable ["BTC_need_revive",0,true];
		_injured playMoveNow "AinjPpneMstpSnonWrflDnon_rolltoback";
	};
	_injured
};
BTC_drag = {
	private "_injured";
	_men = nearestObjects [player, ["Man"], 2];
	if (count _men > 1) then {_injured = _men select 1};
	if (format ["%1",_injured getVariable "BTC_need_revive"] != "1") exitWith {};
	BTC_dragging = true;
	_injured setVariable ["BTC_dragged",1,true];
	_injured attachTo [player, [0, 1.1, 0.092]];
	player playMoveNow "AcinPknlMstpSrasWrflDnon";
	_id = player addAction [("<t color='#ED2744'>") + (localize "STR_BTC_Release") + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[],BTC_release], 9, true, true, "", "true"];
	BTC_drag_pveh = [1,_injured];publicVariable "BTC_drag_pveh";
	WaitUntil {!Alive player || ((animationstate player == "acinpknlmstpsraswrfldnon") || (animationstate player == "acinpknlmwlksraswrfldb"))};
	private ["_act","_veh_selected","_array","_array_veh","_name_veh","_text_action","_action_id"];
	_act = 0;_veh_selected = objNull;_array_veh = [];
	while {!isNull player && alive player && !isNull _injured && alive _injured && format ["%1", _injured getVariable "BTC_need_revive"] == "1" && BTC_dragging} do
	{
		_array = nearestObjects [player, ["Air","LandVehicle"], 5];
		_array_veh = [];
		{if (_x emptyPositions "cargo" != 0) then {_array_veh pushBack _x;};} foreach _array;
		if (_array_veh isEqualTo []) then {_veh_selected = objNull};
		if (count _array_veh > 0 && _veh_selected != _array_veh select 0) then {
			_veh_selected    = _array_veh select 0;
			_name_veh        = getText (configFile >> "cfgVehicles" >> typeof _veh_selected >> "displayName");
			_text_action     = ("<t color='#ED2744'>" + (localize "STR_BTC_Load_wounded_in") + (_name_veh) + "</t>");
			_action_id = player addAction [_text_action,"=BTC=_revive\=BTC=_addAction.sqf",[[_injured,_veh_selected],BTC_load_in], 7, true, true];
			_act  = 1;
		};
		if (_array_veh isEqualTo [] && _act isEqualTo 1) then {player removeAction _action_id;_act = 0};
		sleep 0.1;
	};
	if (_act isEqualTo 1) then {player removeAction _action_id};
	player playMoveNow "AmovPknlMstpSrasWrflDnon";
	_injured setVariable ["BTC_dragged",0,true];
	if (format ["%1",_injured getVariable "BTC_need_revive"] == "1") then {detach _injured;_injured playMoveNow "AinjPpneMstpSnonWrflDb_release";};
	player removeAction _id;
	BTC_dragging = false;
};
BTC_carry = {
	private "_injured";
	_men = nearestObjects [player, ["Man"], 2];
	if (count _men > 1) then {_injured = _men select 1};
	if (format ["%1",_injured getVariable "BTC_need_revive"] != "1") exitWith {};
	BTC_dragging = true;
	_healer = player;
	_injured setVariable ["BTC_dragged",1,true];
	detach _injured;
	player playMoveNow "acinpknlmstpsraswrfldnon_acinpercmrunsraswrfldnon";
	_id = player addAction [("<t color='#ED2744'>") + (localize "STR_BTC_Release") + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[],BTC_release], 9, true, true, "", "true"];
	BTC_carry_pveh = [5,_injured,_healer];publicVariable "BTC_carry_pveh";
	WaitUntil {!Alive player || ((animationstate player == "acinpercmstpsraswrfldnon") || (animationstate player == "acinpercmrunsraswrfldf") || (animationstate player == "acinpercmrunsraswrfldr") || (animationstate player == "acinpercmrunsraswrfldl"))};
	_injured attachto [player,[0.15, 0.15, 0]];_injured setDir 180;
	private ["_act","_veh_selected","_array","_array_veh","_name_veh","_text_action","_action_id"];
	_act = 0;_veh_selected = objNull;_array_veh = [];
	while {!isNull player && alive player && !isNull _injured && alive _injured && format ["%1", _injured getVariable "BTC_need_revive"] == "1" && BTC_dragging} do
	{
		_array = nearestObjects [player, ["Air","LandVehicle"], 5];
		_array_veh = [];
		{if (_x emptyPositions "cargo" != 0) then {_array_veh = _array_veh + [_x];};} foreach _array;
		if (_array_veh isEqualTo []) then {_veh_selected = objNull;};
		if (count _array_veh > 0 && _veh_selected != _array_veh select 0) then {
			_veh_selected    = _array_veh select 0;
			_name_veh        = getText (configFile >> "cfgVehicles" >> typeof _veh_selected >> "displayName");
			_text_action     = ("<t color='#ED2744'>" + (localize "STR_BTC_Load_wounded_in") + (_name_veh) + "</t>");
			_action_id = player addAction [_text_action,"=BTC=_revive\=BTC=_addAction.sqf",[[_injured,_veh_selected],BTC_load_in], 7, true, true];
			_act  = 1;
		};
		if (_array_veh isEqualTo [] && _act isEqualTo 1) then {player removeAction _action_id;_act = 0;};
		sleep 0.1;
	};
	if (_act isEqualTo 1) then {player removeAction _action_id};
	player playAction "released";
	_injured switchMove "AinjPfalMstpSnonWrflDnon_carried_down";
	BTC_carry_pveh = [6,_injured];publicVariable "BTC_carry_pveh";
	detach _injured;
	_injured setVariable ["BTC_dragged",0,true];
	player removeAction _id;
	BTC_dragging = false;
};
BTC_release = {
	BTC_dragging = false;
};
BTC_load_in = {
	_injured = _this select 0;
	_veh     = _this select 1;
	BTC_dragging = false;
	BTC_load_pveh = [3,_injured,_veh];publicVariable "BTC_load_pveh";
};
BTC_pull_out = {
	_array = nearestObjects [player, ["Air","LandVehicle"], 5];
	_array_injured = [];
	if !(_array isEqualTo []) then {
		{
			if (format ["%1",_x getVariable "BTC_need_revive"] == "1") then {_array_injured = _array_injured + [_x];};
		} foreach crew (_array select 0);
	};
	BTC_pullout_pveh = [4,_array_injured];publicVariable "BTC_pullout_pveh";
};
BTC_pull_out_check = {
	_cond = false;
	_array = nearestObjects [player, ["Air","LandVehicle"], 5];
	if !(_array isEqualTo []) then {
		{
			if (format ["%1",_x getVariable "BTC_need_revive"] == "1") then {_cond = true;};
		} foreach crew (_array select 0);
	};
	_cond
};
BTC_player_killed = {
	titleText ["", "BLACK OUT"];
	_body = _this select 0;
	[_body] spawn {
		_body = _this select 0;
		_dir = getDir _body;
		_pos = getPosATL vehicle _body;
		if (BTC_lifes != 0 || BTC_active_lifes isEqualTo 0) then {
			WaitUntil {Alive player};
			detach player;
			//player setPos [getMarkerPos BTC_respawn_marker select 0, getMarkerPos BTC_respawn_marker select 1, 5000];
			private _body_marker = player;
			player setcaptive true;
			BTC_r_camera_nvg = false;
			BTC_killed_pveh = [2,_body_marker];publicVariable "BTC_killed_pveh";player allowDamage false;
			player setVariable ["BTC_need_revive",1,true];
			player switchMove "AinjPpneMstpSnonWrflDnon";
			_actions = [] spawn BTC_assign_actions;

			WaitUntil {animationstate player == "ainjppnemstpsnonwrfldnon"};
			sleep 2;
			player setDir _dir;
			player setVelocity [0,0,0];
			player setPosATL _pos;
			deletevehicle _body;
			if (BTC_injured_marker isEqualTo 1) then {BTC_marker_pveh = [0,BTC_side,_pos,_body_marker];publicVariable "BTC_marker_pveh";};
			disableUserInput true;
			for [{_n = BTC_revive_time_min}, {_n > 0 && player getVariable "BTC_need_revive" == 1}, {_n = _n - 0.5}] do {
				if (BTC_active_lifes isEqualTo 1) then {titleText [format ["Lifes remaining: %1",BTC_lifes], "BLACK FADED"];} else {titleText ["", "BLACK FADED"];};
				sleep 0.5;
			};
			if (BTC_black_screen isEqualTo 0) then {titleText ["", "BLACK IN"]};
			disableUserInput false;
			_time = time;
			_timeout = _time + BTC_revive_time_max;
			BTC_respawn_cond = false;
			if (BTC_disable_respawn isEqualTo 1) then {player enableSimulation false};
			if (BTC_camera_unc isEqualTo 0) then {
				if (BTC_black_screen isEqualTo 0 && BTC_disable_respawn isEqualTo 0) then {disableSerialization;_dlg = createDialog "BTC_respawn_button_dialog";};
				if (BTC_black_screen isEqualTo 1 && BTC_disable_respawn isEqualTo 0 && !Dialog) then {_dlg = createDialog "BTC_respawn_button_dialog";};
				BTC_display_EH = (findDisplay 46) displayAddEventHandler ["KeyDown", "_anim = [] spawn {sleep 1;player switchMove ""AinjPpneMstpSnonWrflDnon"";};"];
			} else {
				BTC_r_u_camera = "camera" camCreate (position player);
				BTC_r_u_camera camSetTarget player;
				BTC_r_u_camera cameraEffect ["Internal", "BACK"];
				BTC_r_u_camera camSetPos [(getpos player select 0) + 15,(getpos player select 1) + 15,10];
				BTC_r_u_camera camCommit 0;
				disableSerialization;
				_r_dlg = createDialog "BTC_spectating_dialog";
				BTC_r_camera_EH_keydown = (findDisplay 46) displayAddEventHandler ["KeyDown", "_keydown = _this spawn BTC_r_s_keydown"];
				{_lb = lbAdd [121,_x];if (_x == BTC_camera_unc_type select 0) then {lbSetCurSel [121,_lb];}} foreach BTC_camera_unc_type;
				_ui = uiNamespace getVariable "BTC_r_spectating";
				(_ui displayCtrl 120) ctrlShow false;
				if (BTC_disable_respawn isEqualTo 1) then {(_ui displayCtrl 122) ctrlShow false;};
			};
			while {format ["%1", player getVariable "BTC_need_revive"] == "1" && time < _timeout && !BTC_respawn_cond} do {
				if (BTC_disable_respawn isEqualTo 0 && {BTC_camera_unc isEqualTo 0} && {!Dialog} && {!BTC_respawn_cond}) then {
					_dlg = createDialog "BTC_respawn_button_dialog";
				};
				if (BTC_camera_unc isEqualTo 1 && {!Dialog} && {!BTC_respawn_cond}) then {
					disableSerialization;
					_r_dlg = createDialog "BTC_spectating_dialog";
					_ui = uiNamespace getVariable "BTC_r_spectating";
					(_ui displayCtrl 120) ctrlShow false;
					if (BTC_disable_respawn isEqualTo 1) then {(_ui displayCtrl 122) ctrlShow false;};
					{_lb = lbAdd [121,_x];if (_x == BTC_camera_unc_type select 0) then {lbSetCurSel [121,_lb];}} foreach BTC_camera_unc_type;
				};
				_healer = call BTC_check_healer;
				private _lifes = "";
				if (BTC_active_lifes isEqualTo 1) then {_lifes = format ["Lifes remaining: %1",BTC_lifes]};
				if (BTC_black_screen isEqualTo 1 && BTC_camera_unc isEqualTo 0) then {
					titleText [format ["%1\n%2\n%3", round (_timeout - time),_healer,_lifes], "BLACK FADED"]
				} else {
					hintSilent format ["%1\n%2\n%3", round (_timeout - time),_healer,_lifes];
				};
				if (BTC_camera_unc isEqualTo 1) then {
					titleText [format ["%1\n%2\n%3", round (_timeout - time),_healer,_lifes], "PLAIN DOWN", 0.01];
					//if (!dialog) then {disableSerialization;_r_dlg = createDialog "BTC_spectating_dialog";sleep 0.01;_ui = uiNamespace getVariable "BTC_r_spectating";(_ui displayCtrl 120) ctrlShow false;if (BTC_disable_respawn isEqualTo 1) then {(_ui displayCtrl 122) ctrlShow false;};{_lb = lbAdd [121,_x];if (_x == BTC_camera_unc_type select 0) then {lbSetCurSel [121,_lb];}} foreach BTC_camera_unc_type;};
					BTC_r_u_camera attachTo [player,BTC_r_s_cam_view];
					BTC_r_u_camera camCommit 0;
					if (BTC_r_camera_nvg) then {camusenvg true;} else {camusenvg false;};
				};
			};
			if (BTC_camera_unc isEqualTo 0) then {
				(findDisplay 46) displayRemoveEventHandler ["KeyDown",BTC_display_EH];
			} else {
				player cameraEffect ["Terminate", "BACK"];
				camDestroy BTC_r_u_camera;
				BTC_r_u_camera = objNull;
				titleText ["", "PLAIN DOWN"];
				(findDisplay 46) displayRemoveEventHandler ["KeyDown",BTC_r_camera_EH_keydown];
			};
			closedialog 0;
			if (time > _timeout && format ["%1", player getVariable "BTC_need_revive"] == "1") then {
				//_respawn = [] spawn BTC_player_respawn;
				BTC_respawn_cond = true;closeDialog 0;player setVariable ["BTC_need_revive",0,true];_respawn = [] spawn BTC_r_close;//Jig - respawns player when revive timer exceeded
			};
			if (format ["%1", player getVariable "BTC_need_revive"] == "0" && !BTC_respawn_cond) then {
				if (BTC_black_screen isEqualTo 1) then {titleText ["", "BLACK IN"];} else {hintSilent "";};
				if (BTC_need_first_aid isEqualTo 1 && ((items player) find "FirstAidKit" != -1)) then {player removeItem "FirstAidKit";};
				player switchMove "AinjPpneMstpSnonWnonDnon_rolltofront";
				sleep 0.5;
				player playMove "amovppnemstpsraswrfldnon";
			};
			if (BTC_disable_respawn isEqualTo 0 && BTC_action_respawn isEqualTo 1) then {player removeAction BTC_action_respawn_id;};
			player setcaptive false;
			if (BTC_disable_respawn isEqualTo 1) then {player enableSimulation true};
			//player switchMove "";
			player allowDamage true;
			hintSilent "";
		};
	};
};
BTC_check_healer = {
	_pos = getpos player;
	_men = [];_veh = [];_dist = 501;_healer = objNull;_healers = [];
	_msg = "No medics nearby.";
	_men = nearestObjects [_pos, BTC_who_can_revive, 500];
	_veh = nearestObjects [_pos, ["LandVehicle", "Air", "Ship"], 500];
	{
		{private _man = _x;if (isPlayer _man && ({_man isKindOf _x} count BTC_who_can_revive) > 0) then {_men pushBack _man;};} foreach crew _x;
	} foreach _veh;
	if (count _men > 0) then {
		{if (Alive _x && format ["%1",_x getVariable "BTC_need_revive"] != "1" && ([_x,player] call BTC_can_revive) && isPlayer _x && side _x == BTC_side) then {_healers pushBack _x;};} foreach _men;
		if !(_healers isEqualTo []) then {
			{
				if (_x distance _pos < _dist) then {_healer = _x;_dist = _x distance _pos;};
			} foreach _healers;
			if !(isNull _healer) then {_msg = format ["%1 could heal you! He is %2 m away!", name _healer,round(_healer distance _pos)];};
		};
	};
	_msg
};
BTC_player_respawn = {
	BTC_respawn_cond = true;
	if (BTC_active_lifes isEqualTo 1) then {BTC_lifes = BTC_lifes - 1};
	if (BTC_active_lifes isEqualTo 1 && BTC_lifes isEqualTo 0) exitWith BTC_out_of_lifes;
	if (BTC_active_lifes != 1 || BTC_lifes != 0) then {
		deTach player;
		player setVariable ["BTC_need_revive",0,true];
		closeDialog 0;
		if (BTC_black_screen isEqualTo 0) then {titleText ["", "BLACK OUT"]};
		sleep 0.2;
		titleText ["", "BLACK FADED"];
		if !(isNull objectParent player) then {unAssignVehicle player;player action ["getOut", vehicle player];};
		player setPos getMarkerPos BTC_respawn_marker;
		sleep 1;
		closeDialog 0;
		player setDamage 0;
		player switchMove "amovpercmstpslowwrfldnon";
		player switchMove "";
		if (BTC_respawn_time > 0) then {
			player enableSimulation false;
			player attachTo [BTC_r_base_spawn,[0,0,6000]];
			sleep 1;
			private "_n";
			for [{_n = BTC_respawn_time}, {_n != 0}, {_n = _n - 1}] do {
				titleText [format ["Respawn in %1",_n], "BLACK FADED"];
				sleep 1;
			};
		};
		player setVariable ["BTC_need_revive",0,true];
		closeDialog 0;
		sleep 0.1;
		BTC_respawn_cond = false;
		if !(BTC_dlg_on_respawn isEqualTo 0) then {
			_dlg = [] spawn BTC_r_create_dialog_mobile;
		} else {
			player attachTo [BTC_r_base_spawn,[0,0,0]];
			sleep 0.1;
			deTach player;
			player setVelocity [0,0,0];
			player setPos getMarkerPos BTC_respawn_marker;
			player enableSimulation true;
			player switchMove "amovpercmstpsraswrfldnon";
			player switchMove "";
			if (BTC_black_screen isEqualTo 1 && BTC_respawn_time isEqualTo 0) then {titleText ["", "BLACK IN"];sleep 2;titleText ["", "PLAIN"];};
			if (BTC_black_screen isEqualTo 0 || BTC_respawn_time > 0) then	{
				titleText ["", "BLACK IN"];
				sleep 2;
				titleText ["", "PLAIN"];
			};
		};
	};
};
BTC_check_action_first_aid = {
	private ["_injured","_array_item_injured"];
	_cond = false;
	_array_item = items player;
	_men = nearestObjects [vehicle player, ["Man"], 2];
	if (count _men > 1 && format ["%1", player getVariable "BTC_need_revive"] == "0") then {
		if (format ["%1", (_men select 1) getVariable "BTC_need_revive"] == "1" && !BTC_dragging && format ["%1", (_men select 1) getVariable "BTC_dragged"] != "1") then {_cond = true;};
		_injured = _men select 1;
	};
	if (_cond && BTC_pvp isEqualTo 1) then {
		if ((_men select 1) getVariable "BTC_revive_side" == str (BTC_side)) then {_cond = true;} else {_cond = false;};
	};
	if (_cond && BTC_need_first_aid isEqualTo 1) then {
		if (_array_item find "FirstAidKit" == -1) then {_cond = false};
		_array_item_injured = items _injured;
		if (!_cond && _array_item_injured find "FirstAidKit" != -1) then {_cond = true};
	};
	_cond
};
BTC_check_action_drag = {
	_cond = false;
	_men = (ASLToAGL getPosASL player) nearEntities [["CAManBase", "Man"], 2];
	if (count _men > 1) then {
		if (BTC_pvp isEqualTo 1 && {(_men select 1) getVariable "BTC_revive_side" == str (BTC_side)}) then {
			if (format ["%1", (_men select 1) getVariable "BTC_need_revive"] == "1" && !BTC_dragging && format ["%1", (_men select 1) getVariable "BTC_dragged"] != "1") then {_cond = true;};
		} else {
			if (format ["%1", (_men select 1) getVariable "BTC_need_revive"] == "1" && !BTC_dragging && format ["%1", (_men select 1) getVariable "BTC_dragged"] != "1") then {_cond = true;};
		};
	};
	_cond
};
BTC_is_class_can_revive = {
	_unit    = _this select 0;
	_cond = false;
	{if (_unit isKindOf _x) then {_cond = true};} foreach BTC_who_can_revive;
	_cond
};
BTC_can_revive = {
	_unit    = _this select 0;
	_injured = _this select 1;
	_array_item_unit    = items _unit;
	_array_item_injured = items _injured;
	_cond = false;
	{if (_unit isKindOf _x) then {_cond = true};} foreach BTC_who_can_revive;
	if (_cond && BTC_need_first_aid isEqualTo 1) then {
		if (_array_item_unit find "FirstAidKit" == -1) then {_cond = false};
		if (!_cond && _array_item_injured find "FirstAidKit" != -1) then {_cond = true};
	};
	_cond
};
//Mobile
BTC_move_to_mobile = {
	_var = _this select 0;
	_side = "";
	switch (true) do {
		case (BTC_side isEqualTo WEST) : {_side = "BTC_mobile_west";};
		case (BTC_side isEqualTo EAST) : {_side = "BTC_mobile_east";};
		case (str(BTC_side) isEqualTo "GUER") : {_side = "BTC_mobile_guer";};
		case (str(BTC_side) == "civ") : {_side = "BTC_mobile_civ";};
	};
	_mobile = objNull;
	{
		if ((_x getvariable _side) isEqualType "" && {(_x getvariable _side) == _var}) then {_mobile = _x;};
	} foreach vehicles;
	if (isNull _mobile) exitWith {};
	if (speed _mobile > 5) exitWith {hint "Mobile respawn is moving! Can't move there!";};
	_pos = getPos _mobile;
	titleText ["Get Ready", "BLACK OUT"];
	sleep 3;
	titleText ["Get Ready", "BLACK FADED"];
	sleep 2;
	titleText ["", "BLACK IN"];
	//player setPos [(_pos select 0) + ((random 50) - (random 50)), (_pos select 1) + ((random 50) - (random 50)), 0];
	player moveInAny _mobile;
};
BTC_mobile_marker = {
	_var = _this select 0;
	_side = "";
	switch (true) do {
		case (BTC_side isEqualTo WEST) : {_side = "BTC_mobile_west";};
		case (BTC_side isEqualTo EAST) : {_side = "BTC_mobile_east";};
		case (str(BTC_side) isEqualTo "GUER") : {_side = "BTC_mobile_guer";};
		case (str(BTC_side) == "civ") : {_side = "BTC_mobile_civ";};
	};
	while {true} do	{
		_obj = objNull;
		while {isNull _obj} do {
			{
				if (format ["%1",_x getVariable _side] == _var && Alive _x) then {_obj = _x;};
			} foreach vehicles;
			sleep 1;
		};
		deleteMarkerLocal format ["%1", _var];
		_marker = createmarkerLocal [format ["%1", _var], getPos _obj];
		format ["%1", _var] setmarkertypelocal "mil_dot";
		format ["%1", _var] setMarkerTextLocal format ["%1", _var];
		format ["%1", _var] setmarkerColorlocal "ColorGreen";
		format ["%1", _var] setMarkerSizeLocal [0.5, 0.5];
		hint format ["%1 is available!", _var];
		while {Alive _obj} do {
			format ["%1", _var] setMarkerPosLocal (getPos _obj);
			if (speed _obj <= 5 && speed _obj >= -3) then {format ["%1", _var] setMarkerTextLocal format ["%1 deployed", _var];format ["%1", _var] setmarkerColorlocal "ColorGreen";} else {format ["%1", _var] setMarkerTextLocal format ["%1 is moving", _var];format ["%1", _var] setmarkerColorlocal "ColorBlack";};
			sleep 1;
		};
		hint format ["%1 has been destroyed!", _var];
		format ["%1", _var] setMarkerTextLocal format ["%1 destroyed!", _var];
		format ["%1", _var] setmarkerColorlocal "ColorRed";
		if (BTC_mobile_respawn isEqualTo 0) exitWith {};
	};
};
BTC_mobile_check = {
	_var = _this select 0;
	_side = "";
	switch (true) do {
		case (BTC_side isEqualTo WEST) : {_side = "BTC_mobile_west";};
		case (BTC_side isEqualTo EAST) : {_side = "BTC_mobile_east";};
		case (str(BTC_side) isEqualTo "GUER") : {_side = "BTC_mobile_guer";};
		case (str(BTC_side) == "civ") : {_side = "BTC_mobile_civ";};
	};
	_cond = false;
	{
		if ((_x getvariable _side) isEqualType "" && {(_x getvariable _side) == _var}) then {_cond = true;};
	} foreach vehicles;
	_cond
};
BTC_vehicle_mobile_respawn = {
	_veh  = _this select 0;
	_var  = _this select 1;
	_set  = _this select 2;
	_type = typeOf _veh;
	_pos  = getPos _veh;
	_dir  = getDir _veh;
	waitUntil {sleep 1; !Alive _veh};
	_veh setVariable [_set,0,true];
	sleep BTC_mobile_respawn_time;
	deleteVehicle _veh;
	_veh = createVehicle [_type, (_pos findEmptyPosition [2,200,_type]),[],0,"NONE"];
	if(getNumber(configFile >> "CfgVehicles" >> typeof _veh >> "isUav") isEqualTo 1) then {createVehicleCrew _veh};
	_veh setDir _dir;
	_veh setVelocity [0, 0, -1];
	_veh setVariable [_set,_var,true];
	_resp = [_veh,_var,_set] spawn BTC_vehicle_mobile_respawn;
	_veh setpos _pos;
	//Jig adding
	switch (_var) do {
		case "MHQ_1" : {_VarName = "MHQ_1"; _veh setVehicleVarName _VarName; _veh Call Compile Format ["%1=_this; publicVariable '%1'",_VarName]; _veh setVariable["persistent",true]; [[_veh,_var],"mhq_actions_fnc",WEST] spawn BIS_fnc_MP;};
		case "MHQ_2" : {_VarName = "MHQ_2"; _veh setVehicleVarName _VarName; _veh Call Compile Format ["%1=_this; publicVariable '%1'",_VarName]; _veh setVariable["persistent",true]; [[_veh,_var],"mhq_actions_fnc",WEST] spawn BIS_fnc_MP;};
		case "MHQ_3" : {_VarName = "MHQ_3"; _veh setVehicleVarName _VarName; _veh Call Compile Format ["%1=_this; publicVariable '%1'",_VarName]; _veh setVariable["persistent",true]; [[_veh,_var],"mhq_actions_fnc",WEST] spawn BIS_fnc_MP; [_veh] call paint_heli_fnc; [_veh] spawn BMR_resetDamage;};
		case "Opfor_MHQ" : {_VarName = "Opfor_MHQ"; _veh setVehicleVarName _VarName; _veh Call Compile Format ["%1=_this; publicVariable '%1'",_VarName]; [[_veh,_var],"mhq_actions_fnc",EAST] spawn BIS_fnc_MP;};
	};
};
BTC_out_of_lifes = {
	if (BTC_lifes isEqualTo 0) then	{
		closeDialog 0;
		removeAllWeapons player;
		player enableSimulation false;
		titleText ["You have no more lifes", "BLACK FADED"];
		sleep 1;
		if (BTC_spectating isEqualTo 0) then {
			while {true} do	{
				player enableSimulation false;
				player setpos [0,0,6000];
				player setVelocity [0,0,0];
				titleText ["You have no more lifes", "BLACK FADED"];
				sleep 1;
			};
		} else {0 spawn BTC_r_spectator;};
	};
};
BTC_3d_markers = {
	_3d = addMissionEventHandler ["Draw3D",
	{
		{
			if (((_x distance player) < BTC_3d_distance) && (format ["%1", _x getVariable "BTC_need_revive"] == "1")) then {
				drawIcon3D["a3\ui_f\data\map\MapControl\hospital_ca.paa",BTC_3d_icon_color,_x,BTC_3d_icon_size,BTC_3d_icon_size,0,format["%1 (%2m)", name _x, ceil (player distance _x)],0,0.02];
			};
		} foreach playableUnits;
	}];
};
BTC_3d_markers_pvp = {
	_3d = addMissionEventHandler ["Draw3D",
	{
		{
			if (((_x distance player) < BTC_3d_distance) && {_x getVariable "BTC_revive_side" == str (BTC_side)} && {format ["%1", _x getVariable "BTC_need_revive"] == "1"}) then {
				drawIcon3D["a3\ui_f\data\map\MapControl\hospital_ca.paa",BTC_3d_icon_color,_x,BTC_3d_icon_size,BTC_3d_icon_size,0,format["%1 (%2m)", name _x, ceil (player distance _x)],0,0.02];
			};
		} foreach playableUnits;
	}];
};
//Dialog
BTC_r_get_list = {
	_list_str = ["BASE"];
	_list_name = [BTC_r_base_spawn];
	_side = "";_array = [];
	switch (true) do {
		case (BTC_side isEqualTo WEST) : {_side = "BTC_mobile_west";_array = BTC_vehs_mobile_west_str;};
		case (BTC_side isEqualTo EAST) : {_side = "BTC_mobile_east";_array = BTC_vehs_mobile_east_str;};
		case (str(BTC_side) isEqualTo "GUER") : {_side = "BTC_mobile_guer";_array = BTC_vehs_mobile_guer_str;};
		case (str(BTC_side) == "civ") : {_side = "BTC_mobile_civ";_array = BTC_vehs_mobile_civ_str;};
	};
	{
		_var = _x;
		{
			if ((_x getvariable _side) isEqualType "" && {(_x getvariable _side) == _var}) then {
				_list_name pushBack _x;_list_str = _list_str + [(_x getvariable _side)];
			};
		} foreach vehicles;
	} foreach _array;
	switch (BTC_dlg_on_respawn) do {
		case 2:
		{
			private _leader = leader group player;
			if (_leader != player && (format ["%1", _leader getVariable "BTC_need_revive"] == "0")) then {_list_name pushBack _leader;_list_str = _list_str + [name _leader];};
		};
		case 3:
		{
			{if (_x != player && (format ["%1", _x getVariable "BTC_need_revive"] == "0")) then {_list_name pushBack _x;_list_str = _list_str + [name _x];};} foreach (units group player);
		};
		case 4:
		{
			{if (_x != player && side _x == BTC_side && (format ["%1", _x getVariable "BTC_need_revive"] == "0")) then {_list_name pushBack _x;_list_str = _list_str + [name _x];};} foreach allUnits;
		};
	};
	_list = [_list_str,_list_name];
	_list
};
BTC_r_load = {
	_list = call BTC_r_get_list;
	_list_name = _list select 0;
	_list_units = _list select 1;
	_n = 0;_side = "";_array = [];
	switch (true) do {
		case (BTC_side isEqualTo WEST) : {_side = "BTC_mobile_west";_array = BTC_vehs_mobile_west_str;};
		case (BTC_side isEqualTo EAST) : {_side = "BTC_mobile_east";_array = BTC_vehs_mobile_east_str;};
		case (str(BTC_side) isEqualTo "GUER") : {_side = "BTC_mobile_guer";_array = BTC_vehs_mobile_guer_str;};
		case (str(BTC_side) == "civ") : {_side = "BTC_mobile_civ";_array = BTC_vehs_mobile_civ_str;};
	};
	if (!isNull BTC_r_mobile_selected) then {if ((_list_name find (BTC_r_mobile_selected getVariable _side)) == -1 && (_list_name find (name BTC_r_mobile_selected)) == -1) then {BTC_r_mobile_selected = _list_units select 0;};};
	if (count _list_name != count BTC_r_list) then {
		lbClear 119;
		{
			_lb = lbAdd [119,_x];
			if (!isNull BTC_r_mobile_selected) then {if ((BTC_r_mobile_selected getVariable _side) == _x || name BTC_r_mobile_selected == _x) then {lbSetCurSel [119,_lb];};};
			if (isNull BTC_r_mobile_selected) then {lbSetCurSel [119,_lb];_n = _list_name find _x;BTC_r_mobile_selected = _list_units select _n;};
		} foreach _list_name;BTC_r_list = _list_name;
	};
	true
};
BTC_r_create_dialog_mobile = {
	if (BTC_active_lifes != 1 || BTC_lifes != 0) then {
		player allowdamage false;
		deTach player;
		player attachTo [BTC_r_base_spawn,[0,0,6000]];
		//player setpos [0,0,6000];
		player setVelocity [0,0,0];
		BTC_r_camera = "camera" camCreate (position BTC_r_base_spawn);
		BTC_r_camera camSetTarget BTC_r_base_spawn;
		BTC_r_camera cameraEffect ["Internal", "BACK"];
		BTC_r_camera camSetPos (BTC_r_base_spawn modelToWorld [-15,-15,15]);
		BTC_r_camera camCommit 0;
		BTC_r_chosen = false;
		BTC_r_list = [];
		BTC_r_mobile_selected = objNull;
		titleText ["", "BLACK IN"];
		sleep 0.5;
		disableSerialization;
		closeDialog 0;
		_r_dlg = createDialog "BTC_move_to_mobile_dialog";
		sleep 0.5;
		titleText ["", "PLAIN"];
		waitUntil {dialog};
		player enableSimulation false;
		call BTC_r_load;
		while {!BTC_r_chosen} do {
			if (!dialog && !BTC_r_chosen) then {_r_dlg = createDialog "BTC_move_to_mobile_dialog";sleep 0.5;};
			player setpos [0,0,6000];
			//player setVelocity [0,0,0];
			call BTC_r_load;
			if (count BTC_r_list isEqualTo 0) then {titleText ["NO SPAWN POINTS FOUND", "PLAIN"];};
			sleep 1;
		};
		player allowdamage true;
		closeDialog 0;
	};
};
BTC_r_apply = {
	BTC_r_chosen = true;
	closeDialog 0;
	titleText ["", "BLACK OUT"];
	sleep 0.5;
	titleText ["", "BLACK FADED"];
	player cameraEffect ["Terminate","BACK"];
	camDestroy BTC_r_camera;
	if (!isNull BTC_r_mobile_selected) then {
		private _mobile = BTC_r_mobile_selected;
		if (speed _mobile > 2) then {titleText ["Mobile is moving...", "BLACK FADED"];WaitUntil {speed _mobile > 2 || !Alive _mobile};};
		if (!Alive _mobile) then {_dlg = [] spawn BTC_r_create_dialog_mobile;} else {player attachTo [_mobile,[3,3,0]];sleep 0.1;deTach player;player setVelocity [0,0,0];player setpos [(getPosATL _mobile select 0) + (random 5),(getPosATL _mobile select 1) + (random 5),(getPosATL _mobile select 2)];sleep 0.1;player playMoveNow "amovpercmstpsraswrfldnon";};
	} else {
		player setPos getMarkerPos BTC_respawn_marker;
	};
	player enableSimulation true;
	titleText ["", "BLACK IN"];sleep 1;titleText ["", "PLAIN"];
};
BTC_r_close = {
	BTC_r_chosen = true;
	closeDialog 0;
	titleText ["", "BLACK OUT"];
	player setVelocity [0,0,0];
	player attachTo [BTC_r_base_spawn,[0,0,0]];
	sleep 0.1;
	detach player;
	player setPos getMarkerPos BTC_respawn_marker;
	sleep 0.5;
	player enableSimulation true;
	player switchMove "amovpercmstpsraswrfldnon";
	titleText ["", "BLACK FADED"];
	player cameraEffect ["Terminate","BACK"];
	if !(isNil "BTC_r_camera") then {//Jig - adding condition
		camDestroy BTC_r_camera;
	};
	titleText ["", "BLACK IN"];
	sleep 1;
	titleText ["", "PLAIN"];
	closeDialog 0;
};
BTC_r_change_target = {
	_var = lbText [119,lbCurSel 119];
	_target = objNull;_side = "";_array = [];
	if (_var == "BASE") then {_target = BTC_r_base_spawn};
	switch (true) do {
		case (BTC_side isEqualTo WEST) : {_side = "BTC_mobile_west";_array = BTC_vehs_mobile_west_str;};
		case (BTC_side isEqualTo EAST) : {_side = "BTC_mobile_east";_array = BTC_vehs_mobile_east_str;};
		case (str(BTC_side) isEqualTo "GUER") : {_side = "BTC_mobile_guer";_array = BTC_vehs_mobile_guer_str;};
		case (str(BTC_side) == "civ") : {_side = "BTC_mobile_civ";_array = BTC_vehs_mobile_civ_str;};
	};
	{
		if ((_x getvariable _side) isEqualType "" && {(_x getvariable _side) == _var}) then {_target = _x;};
	} foreach vehicles;
	switch (true) do {
		case (BTC_dlg_on_respawn isEqualTo 2 || BTC_dlg_on_respawn isEqualTo 3) :
		{
			{if (_var == name _x) then {_target = _x;};} foreach (units group player);
		};
		case (BTC_dlg_on_respawn isEqualTo 4) :
		{
			{if (_var == name _x) then {_target = _x;};} foreach allUnits;
		};
	};
	//if (!isNull _target) then {BTC_r_mobile_selected = _target};
	//if (isNull _target) then {BTC_r_mobile_selected = player};
	BTC_r_mobile_selected = _target;
	BTC_r_camera camSetTarget BTC_r_mobile_selected;
	BTC_r_camera cameraEffect ["Internal", "BACK"];
	BTC_r_camera camSetPos (BTC_r_mobile_selected modelToWorld [-15,-15,15]);
	BTC_r_camera camCommit 0;
};
//Spectating
BTC_r_s_load = {
	_list_name = [];
	_list_units = [];
	switch (true) do {
		case (BTC_spectating isEqualTo 1) : {{if (_x != player) then {_list_name = _list_name + [name _x];_list_units = _list_units + [_x];};} foreach units group player;};
		case (BTC_spectating isEqualTo 2) : {{if (side _x == BTC_side && _x != player) then {_list_name = _list_name + [name _x];_list_units = _list_units + [_x];};} foreach switchableunits;};//switchableunits
		case (BTC_spectating isEqualTo 3) : {{if (_x != player) then {_list_name = _list_name + [name _x];_list_units = _list_units + [_x];};} foreach playableUnits;};
	};
	_n = 0;
	if (!isNull BTC_r_s_target && BTC_r_s_target != BTC_r_base_spawn) then {if ((_list_name find (name BTC_r_s_target)) == -1) then {BTC_r_s_target = BTC_r_base_spawn;};};
	if (count _list_name != count BTC_r_s_list) then {
		lbClear 120;
		{
			_lb = lbAdd [120,_x];
			if (!isNull BTC_r_s_target && BTC_r_s_target != BTC_r_base_spawn) then {if (name BTC_r_s_target == _x) then {lbSetCurSel [120,_lb];};};
			if (isNull BTC_r_s_target) then {lbSetCurSel [120,_lb];_n = _list_name find _x;BTC_r_s_target = _list_units select _n;};
		} foreach _list_name;BTC_r_s_list = _list_name;
	} else {};
	if (count _list_name isEqualTo 0) then {titleText ["No units found!","PLAIN DOWN"];BTC_r_s_target = BTC_r_base_spawn;} else {titleText ["","PLAIN DOWN"];};
	true
};
BTC_r_s_change_target = {
	_name = lbText [120,lbCurSel 120];
	switch (true) do {
		case (BTC_spectating isEqualTo 1) : {{if (name _x == _name) then {BTC_r_s_target = _x;};} foreach units group player;};
		case (BTC_spectating isEqualTo 2) : {{if (name _x == _name) then {BTC_r_s_target = _x;};} foreach playableUnits;};//switchableunits
		case (BTC_spectating isEqualTo 3) : {{if (name _x == _name) then {BTC_r_s_target = _x;};} foreach playableUnits;};
	};
};
BTC_r_s_change_view = {
	_view = lbText [121,lbCurSel 121];
	switch (true) do {
		case (_view == "First person")    : {BTC_r_s_cam_view = [0,0.3,1.55];};
		case (_view == "Behind the back") : {BTC_r_s_cam_view = [0,-2,2];};
		case (_view == "High")            : {BTC_r_s_cam_view = [-15,-15,15];};
	};
};
BTC_r_s_keydown = {
	private ["_key","_dir","_view","_value"];
	if (count _this > 1) then {
		_key = _this select 1;
		_alt = _this select 4;
		_view = BTC_r_s_cam_view;
		_value = if (_alt) then {10} else {1};
		//player globalchat format ["%1 - %2",_key,_this];
		switch (true) do {
			case (_key isEqualTo 30 && (lbText [121,lbCurSel 121] == "Free")) : {BTC_r_s_cam_view = [(_view select 0) - _value,(_view select 1),(_view select 2)];};//A
			case (_key isEqualTo 32 && (lbText [121,lbCurSel 121] == "Free")) : {BTC_r_s_cam_view = [(_view select 0) + _value,(_view select 1),(_view select 2)];};//D
			case (_key isEqualTo 31 && (lbText [121,lbCurSel 121] == "Free")) : {BTC_r_s_cam_view = [(_view select 0),(_view select 1) - _value,(_view select 2)];};
			case (_key isEqualTo 17 && (lbText [121,lbCurSel 121] == "Free")) : {BTC_r_s_cam_view = [(_view select 0),(_view select 1) + _value,(_view select 2)];};
			case (_key isEqualTo 44 && (lbText [121,lbCurSel 121] == "Free")) : {BTC_r_s_cam_view = [(_view select 0),(_view select 1),(_view select 2) - _value];};
			case (_key isEqualTo 16 && (lbText [121,lbCurSel 121] == "Free")) : {BTC_r_s_cam_view = [(_view select 0),(_view select 1),(_view select 2) + _value];};
			case (_key isEqualTo 49) : {if (BTC_r_camera_nvg) then {BTC_r_camera_nvg = false;} else {BTC_r_camera_nvg = true;};};
		};
	};
};
BTC_r_spectator = {
	BTC_r_s_list = [];
	BTC_r_s_target = objNull;
	BTC_r_camera_nvg = false;
	BTC_r_s_camera = "camera" camCreate (position BTC_r_base_spawn);
	BTC_r_s_camera camSetTarget BTC_r_base_spawn;
	BTC_r_s_camera cameraEffect ["Internal", "BACK"];
	BTC_r_s_camera camSetPos [(getpos BTC_r_base_spawn select 0) + 15,(getpos BTC_r_base_spawn select 1) + 15,10];
	BTC_r_s_camera camCommit 0;
	player enableSimulation false;
	disableSerialization;
	_r_dlg = createDialog "BTC_spectating_dialog";
	_ui = uiNamespace getVariable "BTC_r_dialog";
	(_ui displayCtrl 122) ctrlShow false;
	BTC_r_camera_EH_keydown = (findDisplay 46) displayAddEventHandler ["KeyDown", "_keydown = _this spawn BTC_r_s_keydown"];
	if ((BTC_spectating_view select 0) isEqualTo 1) then {_lb = lbAdd [121,(BTC_s_mode_view select (BTC_spectating_view select 1))];} else {{_lb = lbAdd [121,_x];} foreach BTC_s_mode_view};
	sleep 0.5;
	call BTC_r_s_load;
	while {true} do	{
		if (!dialog) then {_r_dlg = createDialog "BTC_spectating_dialog";sleep 0.5;};
		WaitUntil {dialog};
		_ui = uiNamespace getVariable "BTC_r_dialog";
		(_ui displayCtrl 122) ctrlShow false;
		call BTC_r_s_load;
		player setpos [0,0,6000];
		player setVelocity [0,0,0];
		BTC_r_s_camera camSetTarget BTC_r_s_target;
		//BTC_r_s_camera camSetPos [(getpos BTC_r_s_target select 0) + 15,(getpos BTC_r_s_target select 1) + 15,10];
		/*if (lbText [121,lbCurSel 121] == "First person") then
		{
			deTach BTC_r_s_camera;
			BTC_r_s_camera camSetPos (BTC_r_s_target modelToWorld [0,0.3,1.5]);
		}
		else {*/BTC_r_s_camera attachTo [BTC_r_s_target,BTC_r_s_cam_view];//};
		BTC_r_s_camera camCommit 0;
		if (BTC_r_camera_nvg) then {camusenvg true;} else {camusenvg false;};
		//sleep 0.5;
	};
};
JIG_check_action_fire = {
	_cond = false;
	_fire = nearestObjects [player, ["test_EmptyObjectForFireBig"], 5];
	if !(_fire isEqualTo []) then {_cond = true};
	_cond
};
JIG_Extinguish = {
	player playMove "AinvPknlMstpSlayWrflDnon_medic";
	_fire = nearestObjects [player, ["test_EmptyObjectForFireBig"], 5];
	if !(_fire isEqualTo []) then {
		deleteVehicle (_fire select 0);	
	};
};
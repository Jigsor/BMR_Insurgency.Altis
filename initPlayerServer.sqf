params ["_player","_didJIP"];

private _hcEntities = entities "HeadlessClient_F";

if (_player in _hcEntities) then {
	waitUntil {!isNil "all_eos_mkrs"};
	private "_INSmkrs";

	if (!_didJIP && {(["INS_persistence", 0] call BIS_fnc_getParamValue) isEqualTo 1}) then {
		_INSmkrs = profileNamespace getVariable ["BMR_INS_progress", []];
	} else {
		_INSmkrs = all_eos_mkrs;
		{if (getMarkerColor _x isEqualTo "ColorGreen") then {_INSmkrs = _INSmkrs - [_x];};} foreach _INSmkrs;
	};

	[all_eos_mkrs,_INSmkrs,_didJIP] remoteExec ["BMRINS_fnc_HC_allEOSmkrs",_player];
	diag_log "******BMRINS_fnc_HC_allEOSmkrs remote execute scheduled on HC";
	diag_log format ["*****HC* _didJIP = %1",_didJIP];
};

if !(_player in _hcEntities) then {

	private _uid = getPlayerUID _player;
	if (isNull _player || {_uid isEqualTo ""}) exitWith {
		diag_log "*****BMR Insurgency notice!!! A player connected as null object or with an empty UID";
		diag_log "*****This means the player has not connected properly, resulting in a no unit message!!!";
		diag_log format ["*****Player object: %1 Player UID: %2 did JIP: %3", _player, _uid, _didJIP];
		if (!isNull _player) then {
			[] remoteExec ["BMRINS_fnc_playerHang",_player];
			diag_log "Mission ending forced on player";
		};
	};

	if (side _player == east) then {
		waitUntil {!isNil "INS_play_op4"};
		if !(INS_play_op4 isEqualTo 0) then {
			waitUntil {!isNil "INS_Blu_side"};
			if (playersNumber INS_Blu_side < INS_play_op4) exitWith {
				waitUntil {!isNil "Playable_Op4_disabled"};
				if (!isNull _player) then {
					_player enableSimulationGlobal false;
					[] remoteExec ["Playable_Op4_disabled",_player];
				};
			};
		};
	};

	waitUntil {!isNil "Kick_For_Duration"};
	if !(Kick_For_Duration isEqualTo []) then {
		private ["_uid","_pname"];
		_uid = getPlayerUID _player;
		waitUntil {!isNil "Kicked_for_TKing"};
		if (_uid in Kick_For_Duration) exitWith {
			if (!isNull _player) then {
				_pname = if (alive player) then {name _player} else {"UnIdentified Name"};
				_player enableSimulationGlobal false;
				[] remoteExec ["Kicked_for_TKing",_player];
				diag_log format ["Forced mission ending applied to PlayerName: %1 SteamID: %2 Player tried to rejoin after exceeding team kill warning limit set by BTC_tk_last_warning.", _pname, _uid];
			};
		};
	};

	waitUntil {!isNil "JIPmkr_updateClient_fnc"};
	call JIPmkr_updateClient_fnc;

	[_player] spawn {
		sleep (random 7);
		sleep 45;
		waitUntil {!isNil "intel_Build_objs"};
		params [["_player",objNull]];
		private _update = false;
		if (isNull _player) exitWith {};
		if !(intel_Build_objs isEqualTo []) then {
			//{if (format["%1",_x] == "<NULL-object>") then {intel_Build_objs = intel_Build_objs - [_x];};} forEach intel_Build_objs;
			if (ObjNull in intel_Build_objs) then {
				{intel_Build_objs = intel_Build_objs - [objNull]} forEach intel_Build_objs;
				_update = true;
			};
		};
		{_intel = _x; [_intel,current_cache_pos] remoteExec ["fnc_mp_intel",_player];} forEach intel_Build_objs;
		if (_update) then {publicVariableServer "intel_Build_objs";};
	};

	if (!isNil {missionNamespace getVariable "Land_DataTerminal_Obj"} && {!isNull Land_DataTerminal_Obj}) then {
		[] remoteExec ["Terminal_acction_MPfnc", _player, false];
	};
};
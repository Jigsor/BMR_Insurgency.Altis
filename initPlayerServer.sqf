private["_player","_didJIP","_update","_intel","_hcEntities"];

_player = _this select 0;
_didJIP =  _this select 1;
_update = false;
_hcEntities = entities "HeadlessClient_F";

//private _text = format["%1 joined the game!",name _player];
//[_text] remoteExec ["JIG_MPsideChatWest_fnc", [0,-2] select isDedicated];
//[_text] remoteExec ["JIG_MPsideChatEast_fnc", [0,-2] select isDedicated];

if !(_player in _hcEntities) then {

	waitUntil {!isNil "INS_play_op4"};
	if (INS_play_op4 isEqualTo 0) then {
		waitUntil {!isNil "Playable_Op4_disabled"};
		if (side _player == east) exitWith {
			[] remoteExec ["Playable_Op4_disabled",_player];
		};
	};

	waitUntil {!isNil "Kick_For_Duration"};
	if ((count Kick_For_Duration) > 0) then {
		private ["_uid","_pname"];
		_uid = getPlayerUID _player;
		waitUntil {!isNil "Kicked_for_TKing"};
		if (_uid in Kick_For_Duration) exitWith {
			_pname = name _player;
			[] remoteExec ["Kicked_for_TKing",_player];
			diag_log format ["Forced mission ending applied to PlayerName: %1 SteamID: %2 Player tried to rejoin after exceeding team kill warning limit set by BTC_tk_last_warning.", _pname, _uid];
		};
	};

	waitUntil {!isNil "JIPmkr_updateClient_fnc"};
	call JIPmkr_updateClient_fnc;

	waitUntil {!isNil "intel_Build_objs"};
	if ((count intel_Build_objs) > 0) then {
		//{if (format["%1",_x] == "<NULL-object>") then {intel_Build_objs = intel_Build_objs - [_x];};} forEach intel_Build_objs;
		if (ObjNull in intel_Build_objs) then {
			{intel_Build_objs = intel_Build_objs - [objNull]} forEach intel_Build_objs;
			_update = true;
		};
	};

	// Line below is the old method to add acctions to intel for JIP players. On some occations for unknow reason this does not get applied and ations are missing.
	{_intel = _x; [_intel,current_cache_pos] remoteExec ["fnc_jip_mp_intel",_player];} forEach intel_Build_objs;//<- Original way

	//Line below is experimental new method to add action to intel. This might work better. Needs more play testing
	//if (!isNil "current_cache_pos" then  {[intel_Build_objs,current_cache_pos] remoteExec ["fnc_jip_mp_intel2",_player];};//New way

	if (_update) then {publicVariableServer "intel_Build_objs";};

	if (!isNil {missionNamespace getVariable "Land_DataTerminal_Obj"}) then {
		if (!isNull Land_DataTerminal_Obj) then {
			[] remoteExec ["Terminal_acction_MPfnc", _player, false];
		};
	};

} else {
	waitUntil {!isNil "all_eos_mkrs"};
	[all_eos_mkrs] remoteExec ["BMRINS_fnc_HC_allEOSmkrs",_player];
};
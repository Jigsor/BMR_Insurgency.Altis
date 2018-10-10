//fn_requestRandomMission.sqf by Jigsor
if (!isServer) exitWith {};
if (time < 90) exitWith {};//Let server try to produce initial objective on its own.
_index = allPlayers findIf {owner _x isEqualTo remoteExecutedOwner};
_admin = allPlayers select _index;
diag_log text format ["**** Random Mission Requested by %1", _admin];
if (missionNameSpace getVariable ["INStasksForced", false]) exitWith {
	if (!isNull _admin) then {
		_txt = localize "STR_BMR_Side_Request";
		[_txt] remoteExec ['JIG_MPTitleText_fnc', _admin];
	};
};
missionNameSpace setVariable ["INStasksForced", true];
if !(SideMissionCancel) then {
	diag_log "**** Side Mission Canceled Via Forced Random Objective Request";
	SideMissionCancel = true;
	publicVariableServer "SideMissionCancel";
};
sleep 45;//Make sure all objectives finish cancellation. Most only take a few seconds but Delivery can take more time.
missionNameSpace setVariable ["INStasksForced", false];
execVM "Objectives\random_objectives.sqf";
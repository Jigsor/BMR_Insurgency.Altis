//deployOpforMHQ.sqf by Jigsor
//Opfor_MHQ addAction[("<t color='#12F905'>") + ("Deploy MHQ") + "</t>","scripts\deployOpforMHQ.sqf",nil,1, false, true, "", "side _this != INS_Blu_side"];

private ["_target","_caller","_data","_newPos","_playerPos","_dir"];

_target = _this select 0;
_caller = _this select 1;

if (vehicle _caller != player) exitWith {hint localize "STR_BMR_Op4MHQ_deploy_restrict"};

_data = missionNamespace getVariable ["op4CratesOrientation", []];
if (_data isEqualTo []) exitWith {hint "Error: No Op4 Crate Composition Data Available"};

_newPos = [];
_playerPos = getPosATL _caller;
_curWepsPos = getPosWorld INS_weps_Cbox;

for "_counter" from 0 to 10 do {
	_newPos = _playerPos isFlatEmpty [3,384,0.7,2,0,false,ObjNull];
	if (count _newPos > 0) exitWith {};
	sleep 0.1;
};
if (_newPos isEqualTo []) exitWith {hint localize "STR_BMR_NoSpace_forMHQ"};

_caller playMove "AinvPknlMstpSnonWnonDnon_medicUp0";
sleep 3;
waitUntil {animationState _caller != "AinvPknlMstpSnonWnonDnon_medicUp0"};

_dir = round(direction _caller);
[_newPos,_dir,_data] call BMRINS_fnc_objectMapper;

/*
//Create Arsenal marker at crates' deployment position
//Disabled for now because it does not always hide the marker from blufor. Not sure why..
waitUntil {sleep 0.2; !(_curWepsPos isEqualTo getPosWorld INS_weps_Cbox)};
if !(markerColor "OpforWeapons" isEqualTo "") then {deleteMarker "OpforWeapons"};
private _mark = (localize "STR_A3_Arsenal");
private _op4MHQ = createMarker ["OpforWeapons", getPosWorld INS_weps_Cbox];
_op4MHQ setMarkerShape "ICON";
_op4MHQ setMarkerType "o_hq";
_op4MHQ setMarkerColor "ColorRed";
_op4MHQ setMarkerText _mark;
_op4MHQ setMarkerSize [0.5, 0.5];
[[_op4MHQ],west] remoteExec ["Hide_Mkr_fnc", [0,-2] select isDedicated, "OP4weps_JIP_ID"];
*/
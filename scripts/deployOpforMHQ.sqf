//deployOpforMHQ.sqf by Jigsor
//Opfor_MHQ addAction[("<t color=""#12F905"">") + ("Deploy MHQ") + "</t>","scripts\deployOpforMHQ.sqf",nil,1, false, true, "", "side _this != INS_Blu_side"];

private ["_target","_caller","_allboxes","_playerPos","_mark","_depDir","_pos2","_pos3","_pos4","_pos5","_pos6","_op4MHQ","_newPosAmmo"];

_target = _this select 0;
_caller = _this select 1;
_newPosAmmo = [];
_allboxes = INS_Op4_wepCrates;
_depDir = random 360;

if (vehicle _caller != player) exitWith {hint localize "STR_BMR_Op4MHQ_deploy_restrict"};

_caller playMove "AinvPknlMstpSnonWnonDnon_medicUp0";
sleep 3;

_playerPos = getPosATL _caller;

for "_counter" from 0 to 10 do {
	_newPosAmmo = _playerPos isFlatEmpty [3,384,0.7,2,0,false,ObjNull];
	if (count _newPosAmmo > 0) exitWith {};
};
if (_newPosAmmo isEqualTo []) exitWith {hint "STR_BMR_NoSpace_forMHQ";};

WaitUntil {animationState _caller != "AinvPknlMstpSnonWnonDnon_medicUp0"};

//_mark = format["%1MHQ",(name _caller)];
//deleteMarker _mark;

_pos2 = [_newPosAmmo select 0,(_newPosAmmo select 1)-1,_newPosAmmo select 2];
_pos3 = [(_newPosAmmo select 0)-1.5,_newPosAmmo select 1,_newPosAmmo select 2];
_pos4 = [_newPosAmmo select 0,(_newPosAmmo select 1)+1,_newPosAmmo select 2];
_pos5 = [(_newPosAmmo select 0)+1.5,_newPosAmmo select 1,_newPosAmmo select 2];
_pos6 = [_newPosAmmo select 0,(_newPosAmmo select 1)+2,_newPosAmmo select 2];

INS_E_tent setPos _newPosAmmo;
INS_weps_Cbox setPos _newPosAmmo;
INS_ammo_Cbox setPos _pos2;
INS_nade_Cbox setPos _pos3;
INS_launchers_Cbox setPos _pos4;
INS_demo_Cbox setPos _pos5;
INS_sup_Cbox setPos _pos6;

{
	_x setDir _depDir;
	_x setVectorUp [0,0,1];
} foreach _allboxes;

/*
_op4MHQ = createMarker ["OpforWeapons", _newPosAmmo];
_op4MHQ setMarkerShape "ICON";
_op4MHQ setMarkerType "b_hq";
_op4MHQ setMarkerColor "ColorRed";
_op4MHQ setMarkerText _mark;
_op4MHQ setMarkerSize [0.5, 0.5];
[[[_op4MHQ],INS_Blu_side],"Hide_Mkr_fnc",true] call BIS_fnc_MP;
*/
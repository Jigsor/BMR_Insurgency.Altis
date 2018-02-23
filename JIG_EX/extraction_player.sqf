/*
 extraction_player.sqf v1.25 by Jigsor
 handles map click pickup/dropoff points and group inventory.
 jig_ex_actid_show = _ex_caller addAction [("<t color='#12F905'>") + ("Heli Extraction") + "</t>", "JIG_EX\extraction_player.sqf", JIG_EX_Caller removeAction jig_ex_actid_show, 1, false, true, "","player ==_target"];
 runs from JIG_EX\extraction_init.sqf and JIG_EX\respawnAddActionHE.sqf
*/

private ["_target","_caller","_action","_recruitsArry","_pPos","_tempmkr1","_tempmkr2","_actual_ext_pos","_actual_drop_pos","_leaderPos","_outof_range_members","_orAI","_orP"];

_target = _this select 0;  // Object that had the Action (also _target in the addAction command)
_caller = _this select 1;  // Unit that used the Action (also _this in the addAction command)
_action = _this select 2;  // ID of the Action
_recruitsArry = [];

_target removeAction _action;

if ({_x in (items player + assignedItems player)}count ["ItemMap"] < 1) exitWith {hint localize "STR_BMR_missing_map"; player addAction [("<t color='#12F905'>") + ("Heli Extraction") + "</t>","JIG_EX\extraction_player.sqf", JIG_EX_Caller removeAction jig_ex_actid_show, 1, false, true, "", "player ==_target"];};
if (_caller != (leader group _caller)) exitWith {hint localize "STR_BMR_group_leaders_only"; player addAction [("<t color='#12F905'>") + ("Heli Extraction") + "</t>", "JIG_EX\extraction_player.sqf", JIG_EX_Caller removeAction jig_ex_actid_show, 1, false, true, "", "player ==_target"];};

extractmkr = [];
dropmkr = [];
_pPos = getPosATL vehicle player;

if !(getMarkerColor "extractmkr" isEqualTo "") then {deleteMarker "extractmkr"};
_tempmkr1 = createMarker ["extractmkr", [0,0,0]];
_tempmkr1 setMarkerShape "ELLIPSE";
"extractmkr" setMarkerSize [1, 1];
"extractmkr" setMarkerShape "ICON";
"extractmkr" setMarkerType "mil_dot";
"extractmkr" setMarkerColor "Color3_FD_F";
"extractmkr" setMarkerText "Requested Extraction Position";
"extractmkr" setMarkerAlpha 0;
sleep 0.1;

if !(getMarkerColor "dropmkr" isEqualTo "") then {deleteMarker "dropmkr"};
_tempmkr2 = createMarker ["dropmkr", [0,0,0]];
_tempmkr2 setMarkerShape "ELLIPSE";
"dropmkr" setMarkerSize [1, 1];
"dropmkr" setMarkerShape "ICON";
"dropmkr" setMarkerType "mil_dot";
"dropmkr" setMarkerColor "Color3_FD_F";
"dropmkr" setMarkerText "Requested Drop Off Position";
"dropmkr" setMarkerAlpha 0;
sleep 0.1;

hintSilent "";
ex_group_ready = false;
GetClick = true;
openMap true;
waitUntil {visibleMap};
ctrlActivate ((findDisplay 12) displayCtrl 107);// map texture toggle
[] spawn {["Click on Map for Extraction Point or escape to cancel",0,.1,3,.005,.1] call bis_fnc_dynamictext;};

["Ext_pu_mapclick","onMapSingleClick", {
	"extractmkr" setMarkerAlpha 1;
	"extractmkr" setMarkerPos _pos;
	GetClick = false;
}] call BIS_fnc_addStackedEventHandler;

waituntil {!GetClick or !(visiblemap)};
["Ext_pu_mapclick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;

if (!visibleMap) exitwith {hintSilent localize "STR_BMR_heli_extraction_standby"; ctrlActivate ((findDisplay 12) displayCtrl 107); openMap false; player addAction [("<t color='#12F905'>") + ("Heli Extraction") + "</t>","JIG_EX\extraction_player.sqf",JIG_EX_Caller removeAction jig_ex_actid_show,1, false, true,"","player ==_target"]};

_actual_ext_pos = [];
_actual_ext_pos = _actual_ext_pos + call extraction_pos_fnc;
if (DebugEnabled isEqualTo 1) then {vehicle player setPos _pPos;};
if (_actual_ext_pos isEqualTo []) exitWith {hint "Heli cannot land at your chosen position"; ctrlActivate ((findDisplay 12) displayCtrl 107); openMap false; player addAction [("<t color='#12F905'>") + ("Heli Extraction") + "</t>","JIG_EX\extraction_player.sqf",JIG_EX_Caller removeAction jig_ex_actid_show,1, false, true,"","player ==_target"]};
mapAnimAdd [0.5, 0.1, markerPos "tempPUmkr"];
mapAnimCommit;
sleep 1.2;
openMap false;

sleep 0.9;

GetClick = true;
openMap true;
[] spawn {["Click on Map for Drop Point or escape to cancel",0,.1,3,.005,.1] call bis_fnc_dynamictext;};

["Ext_do_mapclick","onMapSingleClick", {
	"dropmkr" setMarkerAlpha 1;
	"dropmkr" setMarkerPos _pos;
	GetClick = false;
}] call BIS_fnc_addStackedEventHandler;

waituntil {!GetClick or !(visiblemap)};
["Ext_do_mapclick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;

if (!visibleMap) exitwith {hintSilent localize "STR_BMR_heli_extraction_standby"; ctrlActivate ((findDisplay 12) displayCtrl 107); openMap false; player addAction [("<t color='#12F905'>") + ("Heli Extraction") + "</t>", "JIG_EX\extraction_player.sqf", JIG_EX_Caller removeAction jig_ex_actid_show, 1, false, true, "", "player ==_target"]};

_actual_drop_pos = [];
_actual_drop_pos = _actual_drop_pos + call drop_off_pos_fnc;
if (DebugEnabled isEqualTo 1) then {vehicle player setPos _pPos;};
if (_actual_drop_pos isEqualTo []) exitWith {hint "Heli cannot land at your chosen position"; ctrlActivate ((findDisplay 12) displayCtrl 107); openMap false; player addAction [("<t color='#12F905'>") + ("Heli Extraction") + "</t>", "JIG_EX\extraction_player.sqf", JIG_EX_Caller removeAction jig_ex_actid_show, 1, false, true, "","player ==_target"]};
mapAnimAdd [0.5, 0.1, markerPos "tempDropMkr"];
mapAnimCommit;
sleep 1.5;
ctrlActivate ((findDisplay 12) displayCtrl 107);// map texture toggle
openMap false;

if (getMarkerPos "extractmkr" distance getMarkerPos "dropmkr" < 500) exitWith {hint "Extraction and Drop Position is less then 500 meters apart. Try again."; player addAction [("<t color='#12F905'>") + ("Heli Extraction") + "</t>", "JIG_EX\extraction_player.sqf", JIG_EX_Caller removeAction jig_ex_actid_show, 1, false, true, "", "player ==_target"]};

[] spawn Ex_LZ_smoke_fnc;
if (JIG_EX_AmbRadio) then {	[] spawn { call AmbExRadio_fnc }; };

jig_ex_cancelid_show = 9998;
ext_caller_group = group player;
_outof_range_members = [];
_leaderPos = position player;

{
	if (_x distance _leaderPos > JIG_EX_Group_Dis) then {
		_outof_range_members pushBack _x;
	};
} forEach (units ext_caller_group);

if (count _outof_range_members > 0) then {
	{
		_orAI = _x;
		if (!isPlayer _orAI && _orAI in _outof_range_members) then {
			[_orAI] join grpNull;
		};
	} forEach (units ext_caller_group);
	{
		_orP = _x;
		[[_orP], grpNull] remoteExec ["join", _orP];
	} forEach _outof_range_members;
	sleep 3;
};

{if (!isPlayer _x) then {_recruitsArry pushBack _x;};} forEach (units ext_caller_group);
if (count _recruitsArry > 0) then {
	[] spawn {
		titleText ["Load recruits into chopper first. Do not use disembark orders after landing.", "PLAIN DOWN", 0.5];
		sleep 7; titleText ["", "PLAIN DOWN", 0.1];
	};
};

ext_caller_group = group player;
publicVariable "ext_caller_group";
sleep 3;
ex_group_ready = true;
publicVariable "ex_group_ready";
sleep 1;

if (ex_group_ready) then {sleep 6; jig_ex_cancelid_show = _caller addAction [("<t color='#ED2744'>") + (localize "STR_BMR_heli_extraction_cancel") + "</t>", {(_this select 0)removeAction(_this select 2); call Cancel_Evac_fnc}, nil, -9, false];};
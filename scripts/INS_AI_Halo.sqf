/*
 INS_AI_Halo.sqf by Jigsor
 Runs only if caller is group leader and has AI in his squad.
 Script will open map and wait for map click of location for AI to halo from then call function INS_AI_Halo to place existing backpack if any in ventral position and add parachute backpack.
 Once landed, parachute and parachute backpack is deleted and original backpack is returned.
 Uses ATM's reliable getloadout and setloadout functions.
*/

if (leader group player != player) exitWith {
	player sideChat localize "STR_BMR_group_leaders_only";
};

if (count units group player < 2) exitWith {};

private ["_aiArr","_mkr_pos"];
_aiArr = [];

mapclick = false;
openMap true;

waitUntil {visibleMap};
0 spawn {[localize "STR_BMR_ai_halo_mapclick",0,.1,3,.005,.1] call bis_fnc_dynamictext;};

["AIdrop_mapclick","onMapSingleClick", {
	clickpos = _pos;
	mapclick = true;

	_mkr=createMarkerLocal ["AI_halo", _pos];
	"AI_halo" setMarkerShapeLocal "ICON";
	"AI_halo" setMarkerSizeLocal [1, 1];
	"AI_halo" setMarkerTypeLocal "mil_dot";
	"AI_halo" setMarkerColorLocal "ColorGreen";
	"AI_halo" setMarkerTextLocal "AI_halo";

}] call BIS_fnc_addStackedEventHandler;

waitUntil {mapclick or !(visibleMap)};
if (mapclick) then {_mkr_pos = markerPos "AI_halo"; deleteMarker "AI_halo";};
["AIdrop_mapclick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;

if (!visibleMap) exitwith {};
if (mapclick) then {hint localize "STR_BMR_ai_halo_inprogress"};
sleep 1;
openMap false;

if (count bon_recruit_queue > 0) then { waitUntil {sleep 1; count bon_recruit_queue < 1}; };

_grp = group player;

{if (!(isPlayer _x) && (vehicle _x == _x)) then {_aiArr pushBack _x;};} forEach (units _grp);

{
	[_x,_mkr_pos] spawn INS_aiHalo;
	sleep 2.5;
} count _aiArr;
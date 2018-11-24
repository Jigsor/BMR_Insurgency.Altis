//Jig_Draw_Circles.sqf by Jigsor

_circle_Radius = 100; // <-- define radius of circle in meters. Run this block again to globally change size.
if (isNil {missionNamespace getVariable "JIG_circle_Radius"}) then {
	missionNamespace setVariable ["JIG_circle_Radius", _circle_Radius, true];
} else {
	if !((missionNamespace getVariable ["JIG_circle_Radius", 100]) isEqualTo _circle_Radius) then {
		missionNamespace setVariable ["JIG_circle_Radius", _circle_Radius, true];
	};
};

JIG_MP_DrawCircle = {
	if (!hasInterface) exitWith {};
	_mapCtrl = (findDisplay 12 displayCtrl 51);
	_mapID = _mapCtrl ctrlAddEventHandler ["Draw", {
		_this select 0 drawEllipse [
			(missionNamespace getVariable ["JIG_circlePos", [0,0,0]]), (missionNamespace getVariable ["JIG_circle_Radius", 100]), (missionNamespace getVariable ["JIG_circle_Radius", 100]), 90, [0.1, 0.1, 0.1, 1], ""
		];
	}];
	//_mapCtrl ctrlRemoveEventHandler ["Draw", _mapID];
};

JIG_Draw_Circles = {
	if (!hasInterface) exitWith {};
	if ({_x in (items player + assignedItems player)}count ["ItemMap"] < 1) exitWith {hint "Missing map item";true};
	hint "";
	NeedCircleClick = true;
	openMap true;
	waitUntil {visibleMap};
	0 spawn {["Click on Map to Place Circle",0,.1,3,.005,.1] call bis_fnc_dynamictext;};

	["CirclePlacement_mapclick","onMapSingleClick", {
		missionNamespace setVariable ["JIG_circlePos", _pos, true];
		NeedCircleClick = false;
	}] call BIS_fnc_addStackedEventHandler;

	waitUntil {!NeedCircleClick or !(visiblemap)};
	["CirclePlacement_mapclick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;

	if (!visibleMap) exitWith {};
	mapAnimAdd [0.5, 0.1, (missionNamespace getVariable ["JIG_circlePos", [0,0,0]])];
	mapAnimCommit;
	sleep 1.2;
	openMap false;

	[] remoteExec ['JIG_MP_DrawCircle', [0,-2] select isDedicated];
};

if (hasInterface) then {
	0 spawn {
		waitUntil {!isNull player};
		_id = player addAction[("<t size='1.5' shadow='2' color='#12F905'>") + "Draw Circle" + "</t>", {0 spawn JIG_Draw_Circles}, [], 10, false, true];
	};
};
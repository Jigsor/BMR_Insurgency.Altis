params ["_owner","_caller","_id","_argArr"];

maxDisReq   = _argArr # 0;
_lockToOwner = _argArr # 1;

if (firstRun) then {
	numCAS = _argArr # 2;
	firstRun = false;
};
_num = _argArr # 2;

if ((_lockToOwner) && (_caller != _owner) && (vehicle _owner isKindOf "Man")) exitWith {titleText["You are not authorized to access the CAS Field System!","PLAIN DOWN"]};

_borderMarker = createMarkerLocal["maxDist", getPos _caller];
_borderMarker setMarkerShapeLocal "ELLIPSE";
_borderMarker setMarkerSizeLocal[maxDisReq, maxDisReq];
_borderMarker setMarkerColorLocal "ColorRed";
_borderMarker setMarkerBrushLocal "Border";

casType = "JDAM";
_dlg = createDialog "casMenu";
disableSerialization;
_display = uiNamespace getVariable "casMenu";

_display displayAddEventHandler ["KeyDown", "_this call onKeyPress"];

_button = _display displayCtrl 100112;
_button ctrlEnable false;

_toggle = _display displayCtrl 100118;

if (doSnap) then {
	_toggle ctrlSetText "<Enabled>";
	_toggle ctrlSetTextColor [0.3, 1, 0.6, 0.5];
} else {
  _toggle ctrlSetText "<Disabled>";
  _toggle ctrlSetTextColor [1, 0, 0, 0.5];
};

if (abortCAS) then {
  _button = _display displayCtrl 100113;
  _button ctrlEnable false;
} else {
  _button = _display displayCtrl 100113;
  _button ctrlEnable true;
};

casRequest = false;
targetPos = getPos _caller;
nearTargetList = [];
nearestVeh = objNull;

while {dialog && alive _caller && alive _owner} do
{
	mapclick = false;

	["CAS_mapclick","onMapSingleClick", {
		deleteMarker "CAS_TARGET";
		_marker = createMarker["CAS_TARGET", _pos];
		_marker setMarkerType "mil_destroy";
		_marker setMarkerSize[0.5, 0.5];
		_marker setMarkerColor "ColorRed";
		_marker setMarkerText " CAS";

		_display = uiNamespace getVariable "casMenu";
		_button = _display displayCtrl 100119;
		_button ctrlSetTextColor [0,0,0,0];
		_button = _display displayCtrl 100112;

		nearTargetList = [];
		nearestVeh = objNull;

		if ((player distance2D _pos) <= maxDisReq) then {
			_button ctrlEnable true;
			hintSilent "";
			titleText["","PLAIN DOWN"];

			nearTargetVehList = (_pos) nearEntities [["Man", "Air", "Car", "Motorcycle", "Tank"], 15];
			_dist = 999;
			{
				if ((_x distance _pos < _dist) && (player knowsAbout _x > 2.5)) then {
					nearestVeh = _x;
				};
			} forEach nearTargetVehList;
		} else {
			hintSilent format ["Max distance to target is limited to: %1m", maxDisReq];
			playSound "cantDo";
			_button ctrlEnable false;
			deleteMarker "CAS_TARGET";
		};
		if (_pos inArea trig_alarm1init) then {
			hintSilent "No bombing on Base!";
			playSound "cantDo";
			_button ctrlEnable false;
			deleteMarker "CAS_TARGET";
		};

		targetPos = _pos;
		mapclick = true;
	}] call BIS_fnc_addStackedEventHandler;

	while {true} do
	{
		if (doSnap) then {
			_toggle ctrlSetText "<Enabled>";
			_toggle ctrlSetTextColor [0.3, 1, 0.6, 0.5];
		} else {
			_toggle ctrlSetText "<Disabled>";
			_toggle ctrlSetTextColor [1, 0, 0, 0.5];
		};
		if (mapclick || !dialog) exitWith {};
		if ((doSnap) && !isNull nearestVeh) then {
			"CAS_TARGET" setMarkerPos (getPos nearestVeh);
		};
		if ((player distance targetPos >= 3) && !(doSnap)) then {
			"CAS_TARGET" setMarkerPos (targetPos);
		};
		sleep 0.3;
	};

	if (!dialog) exitWith {["CAS_mapclick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler};

	sleep 0.123;
};

sleep 0.123;

deleteMarker "maxDist";

if !(casRequest) then {
	deleteMarker "CAS_TARGET";
} else {
	[["CAS_TARGET"],east] remoteExec ["Hide_Mkr_fnc", [0,-2] select isDedicated];
	[_owner, maxDisReq, _lockToOwner, _num, casType,"CAS_TARGET",_id] execVM "JWC_CASFS\CAS.sqf";
};
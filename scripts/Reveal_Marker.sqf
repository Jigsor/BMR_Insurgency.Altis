// Reveal_Marker.sqf by Jigsor
// Displays stationary markers on map of all units with side color and limited vehicle icons within _x range for _x seconds. Is W.I.P.
// Parameters:	0=range, 1=display seconds
// player addAction["Reveal All Units","scripts\Reveal_Marker.sqf", [600,15], 1, false, true, "", "true"];

if (!hasInterface) exitWith {};

private _range = _this select 3 select 0;
private _time =  _this select 3 select 1;
private _pPos = getPosVisual player;
private _uA = allUnits;

(_this select 1) removeAction (_this select 2);

private _getColor = {[(((side _this) call bis_fnc_sideID) call bis_fnc_sideType),true] call bis_fnc_sidecolor;};

private _getType = {
	private _t = "mil_triangle";
	private _v = vehicle _this;
	private _s = (side _this) call BIS_fnc_sideID;

	if (_v != _this && !(_v isKindOf "ParachuteBase")) then {
		switch (_s) do {
			case 0: {
				if(_v isKindOf "Plane") exitWith {_t="o_plane"};
				if(_v isKindOf "Helicopter") exitWith {_t="o_air"};
				if(_v isKindOf "LandVehicle") exitWith {_t="o_motor_inf"};
			};
			case 1: {
				if(_v isKindOf "Plane") exitWith {_t="b_plane"};
				if(_v isKindOf "Helicopter") exitWith {_t="b_air"};
				if(_v isKindOf "LandVehicle") exitWith {_t="b_motor_inf"};
			};
			case 2: {
				if(_v isKindOf "Plane") exitWith {_t="n_plane"};
				if(_v isKindOf "Helicopter") exitWith {_t="n_air"};
				if(_v isKindOf "LandVehicle") exitWith {_t="n_motor_inf"};
				//if(getNumber(configFile >> "CfgVehicles" >> typeOf _v >> "isUav")==1) then {_t="n_uav"};
			};
			case 3: {
				_t = if(_v isKindOf "LandVehicle") then {"c_car"}else{"c_unknown"};
			};
			default {_t="mil_triangle";};
		};
	}else{
		switch (_s) do {
			case 0: {_t="o_inf";};
			case 1: {_t="b_inf";};
			case 2: {_t="n_inf";};
			case 3: {_t="c_unknown";};
			default {_t="n_unknown";};
		};
	};
	_t
};

{if ((_x distance2D _pPos) > _range) then {_uA =_uA - [_x];};} forEach _uA;
openMap true;

private _mN = 0;
private _mA = [];
for '_i' from 0 to (_time * 2) step 1 do {
	{
		private _t = _x call _getType;
		private _c = _x call _getColor;
		_pos = getPosASL _x;
		_mN = _mN + 1;
		private _n = format["Rev%1", _mN];

		private _m = createMarkerLocal [_n, _pos];
		_m setMarkerColorLocal _c;
		_m setMarkerDirLocal getDir _x;
		_m setMarkerTypeLocal _t;
		_m setMarkerSizeLocal [0.5,0.7];

		_mA pushBack _m;
	} forEach _uA;

	UIsleep 0.5;
	{deleteMarkerLocal _x;} count _mA;
};

if (DebugEnabled isEqualTo 1) then {player addAction["Reveal All Units","scripts\Reveal_Marker.sqf", [600,15], 1, false, true, "", "true"];};
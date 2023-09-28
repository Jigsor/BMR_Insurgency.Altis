/*
	File: fn_updateViewDistance.sqf
	Author: Bryan "Tonic" Boardwine	
	Description:
	Updates the view distance dependant on whether the player is on foot, a car or an aircraft.
*/

private _dist = tawvd_foot;
private _vp = vehicle player;
switch (true) do {
	case (_vp isKindOf "Man"): {
		_dist = tawvd_foot;
	};
	case (_vp isKindOf "LandVehicle"): {
		_dist = tawvd_car;
	};
	case (_vp isKindOf "Air"): {
		_dist = tawvd_air;
	};
	case (_vp isKindOf "Ship"): {
		_dist = tawvd_car;
	};
};

setViewDistance _dist;

if(tawvd_syncObject) then {
	setObjectViewDistance [_dist,100];
	tawvd_object = _dist;
};
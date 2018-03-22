/*
	File: fn_trackViewDistance.sqf
	Author: Bryan "Tonic" Boardwine	
	Description:
	Constantly monitors the players state.	
	i.e Player gets in landvehicle then adjust viewDistance.
*/
while {true} do {
	private _recorded = vehicle player;
	if(!alive player) then {
		waitUntil {sleep 1; alive player};
	};
	[] call TAWVD_fnc_updateViewDistance;
	waitUntil {sleep 0.5; _recorded != vehicle player || !alive player};
};
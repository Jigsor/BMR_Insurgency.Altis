#include "macro.sqf"
private ["_ret"];
_ret = [];
if("cars" in ASORVS_VehicleTypes) then {
	{
		if([_x select DBF_ClassName] call ASORVS_fnc_IsAllowed) then {
			_ret pushBack _x;
		};
	} forEach (ASORVS_DB select DB_Cars);
};
if(("tanks" in ASORVS_VehicleTypes) || ("armoured" in ASORVS_VehicleTypes)) then {
	{
		if([_x select DBF_ClassName] call ASORVS_fnc_IsAllowed) then {
			_ret pushBack _x;
		};
	} forEach (ASORVS_DB select DB_Tanks);
};
if("helicopters" in ASORVS_VehicleTypes) then {
	{
		if([_x select DBF_ClassName] call ASORVS_fnc_IsAllowed) then {
			_ret pushBack _x;
		};
	} forEach (ASORVS_DB select DB_Helicopters);
};
if(("planes" in ASORVS_VehicleTypes)) then {
	{
		if([_x select DBF_ClassName] call ASORVS_fnc_IsAllowed) then {
			_ret pushBack _x;
		};
	} forEach (ASORVS_DB select DB_Planes);
};
if(("boats" in ASORVS_VehicleTypes) || ("ships" in ASORVS_VehicleTypes)) then {
	{
		if([_x select DBF_ClassName] call ASORVS_fnc_IsAllowed) then {
			_ret pushBack _x;
		};
	} forEach (ASORVS_DB select DB_Boats);
};

_ret
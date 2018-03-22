disableSerialization;
#include "functions\macro.sqf"
if(!isNil 'ASORVS_loading_preset' ) exitWith {hint "Still applying gear. Please wait before reopening Gear Selector.";};
if(isNil '_this') exitWith { "No parameters"; };
//this addAction ["Tank Garage", {[["tanks"], "vehiclespawn1"] execVM 'ASORVS\open.sqf'}];
ASORVS_VehicleTypes = [_this, 0, [], [[]]] call BIS_fnc_Param;
ASORVS_VehicleWhitelist = [_this, 1, [], [[]]] call BIS_fnc_Param;
ASORVS_VehicleSpawnPos = getMarkerPos ([_this, 2, "", [""]] call BIS_fnc_Param);
ASORVS_VehicleSpawnDir = markerDir ([_this, 2, "", [""]] call BIS_fnc_Param);
ASORVS_VehicleHeightATL = [_this, 3, 0, [0]] call BIS_fnc_Param;
ASORVS_VehicleSpawnRadius = [_this, 4, 5, [0]] call BIS_fnc_Param;
ASORVS_VehicleSpawnName = [_this, 5, "Vehicle Pad", [""]] call BIS_fnc_Param;
if((format["%1", ASORVS_VehicleSpawnPos]) == "[0,0,0]" ) exitWith {hint "Invalid spawn marker."};

player setVariable ["createEnabled", false];
player setVariable ["cancelCreate", true];

ASORVS_FirstLoad = true;
if(isNil 'ASORVS_CurrentVehicle') then {ASORVS_CurrentVehicle = ""};
if(isNil 'ASORVS_Rotating') then {ASORVS_Rotating = false;};
ASORVS_Clone = objNull;
ASORVS_VehicleSpawnPosClear = false;

createDialog "ASORVS_Main_Dialog";
[] call ASORVS_fnc_CameraStart;
player sideChat localize "STR_BMR_veh_menu_tip";
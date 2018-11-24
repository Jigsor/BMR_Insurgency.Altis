disableSerialization;
#include "functions\macro.sqf"
if(!isNil 'ASORVS_loading_preset' ) exitWith {hint "Still applying gear. Please wait before reopening Gear Selector.";};
if(isNil '_this') exitWith { "No parameters"; };
//this addAction ["Tank Garage", {[["tanks"], "vehiclespawn1"] execVM 'ASORVS\open.sqf'}];
ASORVS_VehicleTypes = _this param [0, [], [[]]];
ASORVS_VehicleWhitelist = _this param [1, [], [[]]];
ASORVS_VehicleSpawnPos = getMarkerPos (_this param [2, "", [""]]);
ASORVS_VehicleSpawnDir = markerDir (_this param [2, "", [""]]);
ASORVS_VehicleHeightATL = _this param [3, 0, [0]];
ASORVS_VehicleSpawnRadius = _this param [4, 5, [0]];
ASORVS_VehicleSpawnName = _this param [5, "Vehicle Pad", [""]];
if((format["%1", ASORVS_VehicleSpawnPos]) == "[0,0,0]" ) exitWith {hint "Invalid spawn marker."};

player setVariable ["createEnabled", false];
player setVariable ["cancelCreate", true];

ASORVS_FirstLoad = true;
if(isNil 'ASORVS_CurrentVehicle') then {ASORVS_CurrentVehicle = ""};
if(isNil 'ASORVS_Rotating') then {ASORVS_Rotating = false};
ASORVS_Clone = objNull;
ASORVS_VehicleSpawnPosClear = false;

createDialog "ASORVS_Main_Dialog";
[] call ASORVS_fnc_CameraStart;
player sideChat localize "STR_BMR_veh_menu_tip";
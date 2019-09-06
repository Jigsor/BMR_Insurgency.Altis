#include "macro.sqf"

private["_request","_filter","_control","_info"];
_selectedPreset = _this param [0, -1, [1]];

waitUntil {!isNull (findDisplay ASORVS_Main_Display)};
waitUntil {!ASORVS_Loading};
disableSerialization;

#define SIDE_EAST 0
#define SIDE_WEST 1
#define SIDE_INDEPENDENT 2
#define SIDE_CIV 3
_playerSide = -1;

switch (side player) do {
	case EAST: {_playerSide = SIDE_EAST};
	case WEST: {_playerSide = SIDE_WEST};
	case INDEPENDENT: {_playerSide = SIDE_INDEPENDENT};
	case CIVILIAN: {_playerSide = SIDE_CIV};
};
ASORVS_PlayerSideID = _playerSide;

_sideBlacklistName = format["ASORVS_Blacklist_%1", side player];
_sideBlacklist = missionNamespace getVariable _sideBlacklistName;
if(isNil '_sideBlacklist') then {_sideBlacklist = []};

_factionName = faction player;
_factionBlacklistName = format["ASORVS_Blacklist_%1", side player];
_factionBlacklist = missionNamespace getVariable _factionBlacklistName;
if(isNil '_factionBlacklist') then {_factionBlacklist = []};

ASORVS_RuntimeBlacklist = _sideBlacklist + _factionBlacklist;

_sideWhitelistName = format["ASORVS_Whitelist_%1", side player];
_sideWhitelist = missionNamespace getVariable _sideWhitelistName;
if(isNil '_sideWhitelist') then {_sideWhitelist = []};

_factionName = faction player;
_factionWhitelistName = format["ASORVS_Whitelist_%1", side player];
_factionWhitelist = missionNamespace getVariable _factionWhitelistName;
if(isNil '_factionWhitelist') then {_factionWhitelist = []};
ASORVS_RuntimeWhitelist = _sideWhitelist + _factionWhitelist + ASORVS_VehicleWhitelist;

//hint format["%1,%2,%3",_sideBlacklist, _factionBlacklist, ASORVS_RuntimeBlacklist];
ASORVS_Busy = 0;
ASORVS_Loading = true;
ASORVS_NeedsUpdating = [];

[ASORVS_vehicle_combo, [ASORVS_CurrentVehicle] ] call ASORVS_fnc_Updatecombo;

[] call ASORVS_fnc_UpdateUI;
sleep 0.1;
//nothing needs updating as loading just finished
ASORVS_CurrentVehicle = "";
ASORVS_NeedsUpdating = [ASORVS_vehicle_combo];
waitUntil {!isNil 'ASORVS_RenderTarget'};
if(isNil {ASORVS_UpdateLoop}) then {
	ASORVS_UpdateLoop = [] spawn ASORVS_fnc_UpdateLoop;
};
ASORVS_Loading = false;
ASORVS_FirstLoad = false;
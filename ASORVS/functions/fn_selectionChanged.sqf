#include "macro.sqf"
if(ASORVS_Loading) exitWith{};

waitUntil {isNil 'ASORVS_HandlingEvent'};
ASORVS_HandlingEvent = true;
disableSerialization;
_control = _this select 0;
_index = _this select 1;

_idc = ctrlIDC _control;
switch (_idc) do {
	default {
		ASORVS_NeedsUpdating = ASORVS_NeedsUpdating - [_idc];
		ASORVS_NeedsUpdating = ASORVS_NeedsUpdating + [_idc];
	};
};
ASORVS_HandlingEvent = nil;
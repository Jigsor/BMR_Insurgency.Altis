#include "macro.sqf"
//#include "selectionChangedMacros.sqf"
disableSerialization;
_maxChangeFrequency = 0.02;
waitUntil{!ASORVS_Loading};
#define ASORVS_SLEEPTIME 0.0

while{ASORVS_Open} do {
	while{(count ASORVS_NeedsUpdating) > 0} do {
		_idc = ASORVS_NeedsUpdating select 0;
		_control = ASORVS_getControl(ASORVS_Main_Display, _idc);
		_index = _control lbValue (lbCurSel _control);
		_newclass = _control lbData (lbCurSel _control);
		switch (_idc) do {
			case ASORVS_vehicle_combo : {
				ASORVS_CurrentVehicle = _newclass;
			};
		};
		[] call ASORVS_fnc_ResetClone;
		ASORVS_NeedsUpdating = ASORVS_NeedsUpdating - [_idc];
		//diag_log format["%1", ASORVS_NeedsUpdating];
		sleep _maxChangeFrequency;
	};
	sleep _maxChangeFrequency;
};
ASORVS_UpdateLoop = nil;
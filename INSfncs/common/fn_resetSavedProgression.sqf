//Reset saved progression
if (!hasInterface || isServer) then {
	if !((["INS_persistence", 0] call BIS_fnc_getParamValue) isEqualTo 1) then {profileNamespace setVariable ["BMR_INS_progress", []]; saveProfileNamespace};
};
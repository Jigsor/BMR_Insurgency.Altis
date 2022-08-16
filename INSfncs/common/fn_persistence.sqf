/*
 Persistence Check/Set zone marker color and remove corresponding triggers.
 By Jigsor
 Reccomened to use -loadMissionToMemory startup parameter on server.
*/

HCPresent = if (isNil "Any_HC_present") then {False} else {True};

if ((!isServer && hasInterface) || (HCPresent && isServer)) exitWith{};

if ((count (profileNamespace getVariable ["BMR_INS_progress", []]) > 0) || (HCzoneProgress isNotEqualTo [])) then {
	if (!isServer) then {
		if (!canSuspend) exitWith {[] spawn BMRINS_fnc_persistence};
		uiSleep 0.3;
	} else {
		waitUntil {time > 0};
		sleep 5;
	};

	private "_uncapturedMkrs";
	if (HCzoneProgress isEqualTo []) then {
		_uncapturedMkrs = profileNamespace getVariable "BMR_INS_progress";
	} else {
		_uncapturedMkrs = HCzoneProgress;
	};
	private _capturedMkrs = [];
	private _mkr = "";
	private _trig = "";

	{
		_mkr = _x;
		if ((_mkr in all_eos_mkrs) && !(_mkr in _uncapturedMkrs)) then {
			_capturedMkrs pushBack _mkr;
		};
	} foreach all_eos_mkrs;

	{
		_mkr = _x;
		_trig = format ["EOSTrigger%1", _mkr];
		if (isNil {server getVariable [_trig, nil]}) then {
			waitUntil {!isNil {server getVariable [_trig, nil]} && {!isNull (server getVariable _trig)}};
		};
		_mkr setMarkerColor "ColorGreen";
		_mkr setMarkerAlpha 0.5;
		deleteVehicle (server getVariable _trig);
	} forEach _capturedMkrs;

	server setvariable ["EOSmarkers", _uncapturedMkrs, true];
	diag_log format ["***** %1 Uncaptured zone markers restored out of %2 Total zone markers", count _uncapturedMkrs, count all_eos_mkrs];
} else {
	profileNamespace setVariable ["BMR_INS_progress", []];
	saveProfileNamespace;
};
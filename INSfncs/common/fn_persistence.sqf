/*
 Persistence Check/Set zone marker color and remove corresponding triggers.
 By Jigsor
 HC can only JIP/reconnect and resume properly if it was present at mission start.
 Reccomened to use -loadMissionToMemory startup parameter on server.
*/

HCPresent = if (isNil "Any_HC_present") then {False} else {True};

if ((!isServer && hasInterface) || (HCPresent && isServer)) exitWith{};

if ((count (profileNamespace getVariable ["BMR_INS_progress", []]) > 0) || !(HCzoneProgress isEqualTo [])) then {
	if (!isServer && {isJIP}) then {uiSleep 0.3;};

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
		_mkr setMarkerColor "ColorGreen";
		deleteVehicle (server getVariable _trig);
	} forEach _capturedMkrs;


	server setvariable ["EOSmarkers", _uncapturedMkrs, true];
	diag_log format ["***** %1 Uncaptured zone markers restored out of %2 Total zone markers", count _uncapturedMkrs, count all_eos_mkrs];
} else {
	profileNamespace setVariable ["BMR_INS_progress", []];
	saveProfileNamespace;
};
// Persistence Check/Set zone marker color and removed cooresponding triggers.
// By Jigsor
HCPresent = if (isNil "Any_HC_present") then {False} else {True};
if (isServer && !HCPresent && {INS_persistence isEqualTo 0}) then {
	profileNamespace setVariable ["BMR_INS_progress", []];
};

if ((!isServer && hasInterface) || (HCPresent && isServer)) exitWith{};

if (count (profileNamespace getVariable ["BMR_INS_progress", []]) > 0) then {
	waitUntil {sleep 0.3; time > 0};

	private _uncapturedMkrs = profileNamespace getVariable "BMR_INS_progress";
	private _capturedMkrs = [];
	private _mkr = "";
	private _trig = "";

	{
		_mkr = _x;
		if ((_mkr in all_eos_mkrs) && !(_mkr in _uncapturedMkrs)) then {
			_capturedMkrs pushBack _mkr;
		};
	} foreach all_eos_mkrs;

	{	_mkr = _x;
		_trig = format ["EOSTrigger%1", _mkr];
		_mkr setMarkerColor "colorGreen";
		deleteVehicle (server getVariable _trig);
	} count _capturedMkrs;

	server setvariable ["EOSmarkers", _uncapturedMkrs, true];
};
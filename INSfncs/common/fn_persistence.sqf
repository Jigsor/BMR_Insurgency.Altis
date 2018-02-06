/*
 Persistence Check/Set zone marker color and remove corresponding triggers.
 By Jigsor
 Crucial note reguarding use of Headless Client (HC):
 HC must have mission cached to memory or else HC is not recognized in time and both server and HC will fail in EOS If HC JIPs.
 HC can only JIP/reconnect and resume properly if it was present at mission start so when using HC and running a new version/edit of this mission, mission must be loaded twice with #missions command.
 Reccomened to use -loadMissionToMemory startup parameter on server.
 Currently does not work with Vanilla Terrains for some unknown reason.
*/

HCPresent = if (isNil "Any_HC_present") then {False} else {True};
if (isServer && !HCPresent && {INS_persistence isEqualTo 0 || INS_persistence isEqualTo 2}) then {
	profileNamespace setVariable ["BMR_INS_progress", []];
	//saveProfileNamespace;// adding this line does not fix vanilla terrain incompatibility.
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
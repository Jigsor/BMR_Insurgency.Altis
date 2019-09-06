params ["_fakeNumber","_junkPosition","_junkType"];

_junk = _junkType createVehicle _junkPosition;
_junk setdir(random 360);
_junk setPos _junkPosition;
_junk enableSimulation false;
_junk allowDamage false;

if(EPD_IED_debug) then {
	call compile format ['
	fakebombmarker_%1 = createmarker ["fakebombmarker_%1", _junkPosition];
	"fakebombmarker_%1" setMarkerTypeLocal "hd_warning";
	"fakebombmarker_%1" setMarkerColorLocal "ColorBlue";
	"fakebombmarker_%1" setMarkerTextLocal "fake";
	', _fakeNumber];
};
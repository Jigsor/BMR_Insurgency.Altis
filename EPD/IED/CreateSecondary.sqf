if(!isserver) exitwith{};

_location = _this select 0;
_iedNumber = _this select 1;
_theta = random 360;
_offset = 4 + random 12;
_iedPos = [(_location select 0) + _offset*cos(_theta), (_location select 1) + _offset*sin(_theta),0];
_iedType = iedSecondaryItems select(floor random(iedSecondaryItemsCount));
call compile format ['secied_%1 = _iedType createVehicle _iedPos;
						secied_%1 setDir (random 360);
						secied_%1 enableSimulation false;
						secied_%1 setPos _iedPos;
						secied_%1 allowDamage false;
						publicVariable "secied_%1";
						', _iedNumber, _iedPos];

call compile format [' st_%1 = createTrigger["EmptyDetector", _iedPos];
st_%1 setTriggerArea[11,11,0,true];
st_%1 setTriggerActivation ["any","PRESENT",false];
st_%1 setTriggerStatements ["[this, thislist, %2, %1] call EXPLOSION_CHECK && (alive secied_%1)","terminate pd_%1; [%2,sec_%1, %1] spawn EXPLOSIVESEQUENCE_SECONDARY; deleteVehicle thisTrigger;  deleteVehicle secied_%1",""];
publicVariable "st_%1";
',_iedNumber, _iedPos];

_eventhandler = "";
_disarm = "";
if(allowExplosiveToTriggerIEDs) then {
	call compile format['pd_%1 = [secied_%1, %1, "SECONDARY", st_%1] spawn PROJECTILE_DETECTION; publicVariable "pd_%1";', _iedNumber];

	_eventhandler = format['["secied_%1","SECONDARY",%2,"st_%1",%1] spawn EXPLOSION_EVENT_HANDLER_ADDER;', _iedNumber, _iedPos];

	_disarm = format ['[secied_%1, st_%1, pd_%1, %1] spawn Disarm;', _iedNumber];
} else {
	_disarm = format ['[secied_%1, st_%1, "", %1] spawn Disarm;', _iedNumber];
};

_code = format["%1 %2",_eventhandler, _disarm ];

eventHandlers set[_iedNumber, _code];
publicVariable "eventHandlers";

[[_code],"SECONDARY_EVENT_ADDER",true,false] spawn BIS_fnc_MP;

if(EPD_IED_debug) then {
	hint format["Secondary Explosive Created"];
	call compile format ['
	secbombmarker_%1 = createmarker ["secbombmarker_%1", _iedPos];
	"secbombmarker_%1" setMarkerTypeLocal "hd_warning";
	"secbombmarker_%1" setMarkerColorLocal "ColorGreen";
	"secbombmarker_%1" setMarkerTextLocal "Secondary";', _iedNumber];
};
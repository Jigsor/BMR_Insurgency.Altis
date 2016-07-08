_iedNumber = _this select 0;
_iedPos = _this select 1;
_iedSize = _this select 2;
_iedType = _this select 3;
_side = _this select 4;

if(typename _side != "array") then { _side = [_side];};
for "_i" from 0 to (count _side) -1 do{
	_side set [_i, toUpper (_side select _i)];
};

call compile format ['ied_%1 = _iedType createVehicle _iedPos;
						ied_%1 setDir (random 360);
						ied_%1 enableSimulation false;
						ied_%1 setPos _iedPos;
						ied_%1 allowDamage false;
						publicVariable "ied_%1";
					', _iedNumber];

call compile format [' t_%1 = createTrigger["EmptyDetector", _iedPos];
t_%1 setTriggerArea[11,11,0,true];
t_%1 setTriggerActivation ["any","PRESENT",false];
tSides_%1 = _side;
t_%1 setTriggerStatements ["[this, thislist, %2, %1] call EXPLOSION_CHECK && (alive ied_%1)","terminate pd_%1; [%2, ied_%1, %1] spawn EXPLOSIVESEQUENCE_%3; deleteVehicle thisTrigger;",""];
publicVariable "t_%1";
',_iedNumber, _iedPos,_iedSize];

_eventhandler = "";
_disarm = "";
if(allowExplosiveToTriggerIEDs) then {
	call compile format['pd_%1 = [ied_%1, %1, _iedSize, t_%1] spawn PROJECTILE_DETECTION; publicVariable "pd_%1";', _iedNumber];

	_eventhandler = format ['["ied_%1","%2",%3,"t_%1",%1] spawn EXPLOSION_EVENT_HANDLER_ADDER;', _iedNumber,_iedSize, _iedPos];

	_disarm = format ['[ied_%1, t_%1, pd_%1, %1] spawn Disarm;', _iedNumber];
} else {
	_disarm = format ['[ied_%1, t_%1, "", %1] spawn Disarm;', _iedNumber];
};

eventHandlers set[_iedNumber, format["%1 %2",_eventhandler, _disarm ]];
//publicVariable "eventHandlers";

if(EPD_IED_debug) then {

	call compile format ['
	bombmarker_%1 = createmarker ["bombmarker_%1", _iedPos];
	"bombmarker_%1" setMarkerTypeLocal "hd_warning";
	"bombmarker_%1" setMarkerColorLocal "ColorRed";
	"bombmarker_%1" setMarkerTextLocal "%2";', _iedNumber, _iedSize];
};
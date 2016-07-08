_iedPosition = _this select 0;
_explosiveSequence = _this select 1;
(_this select 2) removeAllEventHandlers "HitPart";
deleteVehicle (_this select 2);
_iedNumber = _this select 3;

[[_iedPosition] , "IED_SMOKE", true, false] spawn BIS_fnc_MP;
[[_iedPosition] , "IED_SCREEN_EFFECTS", true, false] spawn BIS_fnc_MP;
for "_i" from 0 to (count _explosiveSequence) -1 do{
	[[_iedPosition] , "IED_ROCKS", true, false] spawn BIS_fnc_MP;
	_explosive = (_explosiveSequence select _i);
	_xCoord = (random 4)-2;
	_yCoord = (random 4)-2;
	_bomb = _explosive createVehicle _iedPosition;
	_bomb setPos [(_iedPosition select 0)+_xCoord,(_iedPosition select 1)+_yCoord, 0];
	if(((position player) distanceSqr getPos _bomb) < 40000) then {  //less than 200 meters away
		addCamShake[1+random 5, 1+random 3, 5+random 15];
	};
	sleep .01;
};

eventHandlers set [_iedNumber, "true;"];
publicVariable "eventHandlers";

if(secondaryChance>random 100) then {
	_sleepTime = 15;
	if(EPD_IED_debug) then {
		hint format["Creating Secondary Explosive"];
	};
	sleep _sleepTime;
	[[_iedPosition, _iedNumber], "SPAWN_SECONDARY", true, false] spawn BIS_fnc_MP;
};
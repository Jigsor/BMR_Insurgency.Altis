EXPLOSION = {
	_iedPosition = _this select 0;
	_explosiveSequence = ["R_80mm_HE","M_PG_AT","M_PG_AT","R_80mm_HE","M_PG_AT","R_80mm_HE","M_PG_AT","M_PG_AT","M_PG_AT","R_80mm_HE"];
	[[_iedPosition] , "IED_SCREEN_EFFECTS", true, false] spawn BIS_fnc_MP;
	for "_i" from 0 to (count _explosiveSequence) -1 do{
		[[_iedPosition] , "IED_ROCKS", true, false] spawn BIS_fnc_MP;
		_explosive = (_explosiveSequence select _i);
		_xCoord = (random 4)-2;
		_yCoord = (random 4)-2;
		_bomb = _explosive createVehicle _iedPosition;
		_bomb setPos [(_iedPosition select 0)+_xCoord,(_iedPosition select 1)+_yCoord, 0];
		_i = _i + floor random 7;
		if(((position player) distanceSqr getPos _bomb) < 40000) then {  //less than 200 meters away
			addCamShake[1+random 5, 1+random 3, 5+random 15];
		};
		sleep .01;
	};
};

[_this select 0] spawn EXPLOSION;
(_this select 1) removeAllEventHandlers "HitPart";
eventHandlers set [_this select 2, "true;"];
publicVariable "eventHandlers";
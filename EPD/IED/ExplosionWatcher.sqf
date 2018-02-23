//watch projectiles that passed by these and sees if they are explosives and if they are close enough to set off the IED

_isExplosive = false;
_item = _this select 0;
_class = _this select 4;
_position = _this select 5;

{
	if(_class iskindof _x) then {
		_isExplosive = true;
	};
} foreach explosiveSuperClasses;

{//smoke grenades.. chem lights.. ir strobes.. rocks..
	if(_class iskindof _x) then{
		_isExplosive = false;
	}
} foreach thingsToIgnore;

if(_isExplosive) then {
	_updateInterval = .1;
	_radius = 49;		
	_ied = _this select 1;
	_trigger = _this select 2;
	
	while {(alive _item) and !(isnull _ied) and !(isnull _trigger)} do {
		_position = getpos _item;
		sleep _updateInterval;
	};
	
	_origin = getpos (_this select 1);
	
	if(EPD_IED_debug) then {player sidechat format["distance = %1", (_origin distance _position)]; };
	if((_origin distancesqr _position < _radius) and !(isnull _ied) and !(isnull _trigger)) then {
		_chance = 100;
		if(_class iskindof "Grenade") then { _chance = 35; };
		
		_r = random 100;
		if(EPD_IED_debug) then {hint format["random = %1\nmax to explode = %2\n%3",_r,_chance,_class];};
		if(_r < _chance) then {
			_iedNumber = _this select 6;
			_iedSize = _this select 3;
			if(EPD_IED_debug) then { player sidechat format ["%1 triggered IED",_class]; };
			if(!(isnull _ied)) then {
				_ied removeAllEventHandlers "HitPart";
				call compile format["terminate pd_%2; [_origin, _ied, _iedNumber] call EXPLOSIVESEQUENCE_%1", _iedSize, _iedNumber ];
				deleteVehicle _ied;
				deleteVehicle _trigger;
			};
		};
	};
};

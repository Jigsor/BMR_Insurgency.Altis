if(allowExplosiveToTriggerIEDs) then {

	_ied = _this select 1;
	_trigger = _this select 5;	
	if((isnull _ied) or (isnull _trigger)) exitwith{};

	_iedSize = _this select 2; 
	_iedPosition = _this select 3;
	_iedNumber = _this select 4;

	_projectile =  _this select 0 select 0 select 6 select 4;
	_isExplosive = false;
	_isExplosiveBullet = false;

	{
		if(_projectile iskindof _x) then {
			_isExplosive = true;
		};
	} foreach ehExplosiveSuperClasses;

	if((! _isExplosive) && (_projectile in explosiveBullets)) then
	{
		_isExplosiveBullet = true;
	};

	{//smoke grenades.. chem lights.. ir strobes.. rocks..
		if(_projectile iskindof _x) then{
			_isExplosive = false;
			_isExplosiveBullet = false;
		}
	} foreach thingsToIgnore;

	//hint format["projectile = %3\nexplosive = %1\nexbullet = %2", _isExplosive, _isExplosiveBullet,_projectile];
	if(_isExplosive || _isExplosiveBullet) then {
		_chance = 100;
			
		if(_projectile iskindof "GrenadeCore") then { _chance = 50; };
		if(_isExplosiveBullet) then {_chance = 40; };
		
		_r = random 100;
		if(EPD_IED_debug) then {hint format["random = %1\nmax to explode = %2\n%3",_r,_chance,_projectile];};
		if(_r < _chance) then {
			if(!(isnull _ied) and !(isnull _trigger)) then {
				
				if(EPD_IED_debug) then { player sidechat format ["%1 triggered IED",_projectile]; };
				eventHandlers set [_iedNumber, compile "true;"];
				publicVariable "eventHandlers";
				call compile format["terminate pd_%2; [_iedPosition, _ied, _iedNumber] call EXPLOSIVESEQUENCE_%1", _iedSize, _iedNumber ];
				_ied removeAllEventHandlers "HitPart";
				deleteVehicle _ied;
				deleteVehicle _trigger;
			};
		};
	};
};
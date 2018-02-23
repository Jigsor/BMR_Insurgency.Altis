if(_this select 0) then
{
	_items = 0;
	_triggerNum = _this select 3;
	_iedPos = _this select 2;
	_objects = _this select 1;
	_minDistance = 10000;
	_minHeight = 10000;
	_maxSpeed = 0;
	_sides = call compile format["tSides_%1", _triggerNum];

	{
		if((_x iskindof "man") or (_x iskindof "allvehicles")) then {
			if(format["%1", side _x] in _sides) then {
				_items = _items + 1;
				_dist = (position _x distance _iedPos);
				if(_dist < _minDistance) then {
					_minDistance = _dist;
				};
				if((((velocity _x) distanceSqr [0,0,velocity _x select 2]) > _maxSpeed) and (stance _x != "PRONE")) then {
					_maxSpeed = (velocity _x) distanceSqr [0,0,velocity _x select 2]; //ignore the z component, because you get large speed increases steping over stone walls
				};
				if((position _x) select 2 < _minheight) then {
					_minHeight = (position _x) select 2;
				};
			};
		};
	} foreach _objects;

	if(EPD_IED_debug && _items > 0) then {
		hintSilent format["Trigger %5\nPeople/Vehicles in trigger = %1\nMax Speed = %2\nMin Height = %3\nDistance = %4", _items,_maxSpeed, _minHeight,_minDistance, _triggerNum];
	};

	//fast walk forward without gear averages 44.6
	//fast crouch forward without gear averages 44.6
	//regular walk forward without gear averages 16.02
	//regular crouch forward without gear averages 12.76
	//slow walk forward without gear averages 2.95
	//slow crouch forward without gear averages 1.97
	//crawl forward averages without gear averages 0.30
	if((_maxSpeed > 2.8) and (_minHeight < 3)) then { true; } else {false;}; 
} else {
	false;
};
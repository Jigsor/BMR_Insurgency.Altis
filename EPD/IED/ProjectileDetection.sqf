//http://forums.bistudio.com/showthread.php?170903-How-do-you-find-out-what-type-of-explosive-hit-an-object
//Detects projectiles that go near this object

if(allowExplosiveToTriggerIEDs) then {
	_range = 35;
	_ied = _this select 0;
	_iedNumber = _this select 1;
	_iedSize = _this select 2;
	_trigger = _this select 3;

	_fired = [];
	while {alive _ied} do 
	{
		_list = (position _ied) nearObjects ["Default",_range]; //Default = superclass of ammo

		if (count _list >=1) then 
		{
			_ammo = _list select 0;

			if (!(_ammo in _fired)) then
			{
				[_ammo, _ied, _trigger, _iedSize, typeof _ammo, getpos _ammo, _iedNumber ] spawn EXPLOSION_WATCHER;
				_fired pushBack _ammo;
			};
		};
		sleep 0.1;
		//remove dead projectiles
		_fired = _fired - [objNull];
	};
};
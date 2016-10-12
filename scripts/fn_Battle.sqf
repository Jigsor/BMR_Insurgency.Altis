/*
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	This is ambs script version. examples of scale and intensity
	Scale:
	Skirmishes = 42
	Engagement = 21
	Battle = 7

	Intensity:
	Light = 42
	Moderate = 21
	Heavy = 7

	Example:
	s=[player,42,42] execVM "fn_Battle.sqf";
	1) is where you want the central point of battle sounds to originate
	2) would be a skirmish
	3) would be the intensity of that Skirmish. Which would be light intensity

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

private ["_mod","_units","_activated","_Scale","_intensity"];
_mod = [_this,0,objNull,[objNull]] call BIS_fnc_param;

_mod setVariable ["Scale", _this select 1, true];
_mod setVariable ["Intensity", _this select 2, true];
_activated = true;
_units = [];

if (_activated) then {

 	AMBSBattle = {
 		private ["_source","_logic","_units","_battle_radius","_intensity","_Scale","_SSize","_Isize"];
		_source = _this select 0;
		_logic = _this select 1;
		_units = _this select 2;
		_battle_radius = if ((_this select 3) < 200) then {200} else {(_this select 3)};
		_intensity = _this select 4;
		_Scale = _this select 5;
		_SSize = _this select 6;
		_Isize = _this select 7;
		_where = if (count _units >= 1) then {_units call BIS_fnc_selectRandom} else {_source};

		_saI = (Round (random _Isize)/3.5);

		for "_sb" from 1 to _saI do {
			[_logic,_where,_battle_radius,_intensity,_SSize,_Scale,_Isize] spawn AMBSWarfare;
			sleep Floor ((random (_intensity / 7) + random (_intensity / 7)) / 3.5);
		};

 	};
 	AMBSWarfare = {
 		private ["_logic","_source","_radius","_intensity","_Scale","_SSize","_Isize","_allsounds"];
		_logic = _this select 0;
		_source = _this select 1;
		_radius = if ((_this select 2) < 200) then {200} else {(_this select 2)};
		_intensity = _this select 3;
		_Scale = _this select 4;
		_SSize = _this select 5;
		_Isize = _this select 6;
		_allsounds = [];
		_logic setPos (_source modelToWorld [random _radius - Random _radius,random _radius - Random _radius,random 1 - Random 2]);
		private ["_sound","_sound1","_sound2","_maxtype"];
		_sound1 = format ["A3\Sounds_F\ambient\battlefield\battlefield_explosions%1.wss",ceil (random 5)];
		_sound2 = format ["A3\Sounds_F\ambient\battlefield\battlefield_firefight%1.wss",ceil (random 4)];
		if (!(surfaceIsWater getPos _logic)) then {_allsounds pushBack _sound2;} else {AmB_nosound = true};
		if ((random (_intensity * _SSize / _Scale)) < (random (_Scale * _Isize / _intensity)) or (surfaceIsWater getPos _logic) or AmB_nosound) then {_allsounds pushBack _sound1;};
		_vol = switch (true) do {
			case (_logic distance player <= 250) : {random .4};
			case (_logic distance player > 250 and _logic distance player <= 500) : {random 1};
			case (_logic distance player > 500 and _logic distance player <= 800) : {random 1.5};
			case (_logic distance player > 800 and _logic distance player <= 1000) : {random 2};
			case (_logic distance player > 1000 and _logic distance player <= 1500) : {random 2.5};
			case (_logic distance player > 1500 and _logic distance player <= 2000) : {random 3};
			case (_logic distance player > 2000) : {random 4};
		};
		_maxtype = (count _allsounds);
		_sound = _allsounds select (floor random _maxtype);
		_pitch = if (_sound == _sound1) then {random .5 + .5} else {random .5 + .9};
		_volumn = if (_sound == _sound1) then {_vol + random 1} else {_vol + random .5};
		playsound3d [_sound,_logic,false,getPosasl _logic,_volumn,_pitch,0];
 	};
	_source = _mod;
	_plays = true;
	AmB_nosound = false;
	_center = createCenter sideLogic;
	_group = createGroup _center;
	_logic = _group createUnit ["LOGIC",(getPos _source) , [], 0, ""];
	_Scale = _source getVariable "Scale";
	_Ssize = _Scale/(_Scale*.1)/_Scale^.5*10;
	_intensity = _source getVariable "Intensity";
	_Isize = _intensity/(_intensity*.1)/_intensity^.5*10;

	while {_plays} do {
		_battle_radius = random ((_Ssize * 3) + (_Isize * 3));
		_ScaleR = random round _Scale;
		_SsizeR = random round _Ssize;
		_intensityR = random round _intensity;
		_IsizeR = random round _Isize;
		//if (isNull _source) then {_plays = false};
		_saS = (Ceil random (_SSizeR / 3.5));
		for "_sa" from 1 to _saS do {
			sleep Ceil ((random (_intensityR / 7) + random (_intensityR / 7))/7);
			[_source,_logic,_units,_battle_radius,_intensityR,_ScaleR,_SsizeR,_IsizeR] spawn AMBSBattle;
		};
		sleep Round ((random (_ScaleR) + random (_ScaleR))/7);
	};
	deleteVehicle _logic;
};

true
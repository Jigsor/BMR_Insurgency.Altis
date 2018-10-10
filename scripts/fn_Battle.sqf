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
	INSambs=[player,42,42] execVM "fn_Battle.sqf";
	1) is where you want the central point of battle sounds to originate
	2) would be a skirmish
	3) would be the intensity of that Skirmish. Which would be light intensity

	terminate script with code:
	terminate INSambs;
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	Moderate edit by Jigsor.
*/

params [["_mod",objNull,[objNull]], ["_scaleM",24,[0]], ["_intensityM",36,[0]]];

if (isNull _mod) exitWith {};

private _sideB = INS_Blu_side;

_mod setVariable ["Scale", _scaleM];
_mod setVariable ["Intensity", _intensityM];

AMBSBattle = {
	params ['_source','_logic','_battleRadius','_intensity','_Scale','_SSize','_Isize'];
	private _saI = (Round (random _Isize)/3.5);
	if (_battleRadius < 200) then {_battleRadius = 200};

	for "_sb" from 1 to _saI do {
		[_logic,_source,_battleRadius,_intensity,_SSize,_Scale,_Isize] spawn AMBSWarfare;
		sleep Floor ((random (_intensity / 7) + random (_intensity / 7)) / 3.5);
	};
};

AMBSWarfare = {
	params ['_logic','_source','_radius','_intensity','_Scale','_SSize','_Isize'];
	private _allsounds = [];
	if (_radius < 200) then {_radius = 200};

	_logic setPos (_source modelToWorld [random _radius - Random _radius,random _radius - Random _radius,random 1 - Random 2]);

	private _sound1 = format ["A3\Sounds_F\ambient\battlefield\battlefield_explosions%1.wss",ceil (random 5)];
	private _sound2 = format ["A3\Sounds_F\ambient\battlefield\battlefield_firefight%1.wss",ceil (random 4)];

	if (!(surfaceIsWater getPos _logic)) then {_allsounds pushBack _sound2;} else {missionNamespace setVariable ["AmB_nosound",true];};
	if ((random (_intensity * _SSize / _Scale)) < (random (_Scale * _Isize / _intensity)) or {surfaceIsWater getPos _logic} or {missionNamespace getVariable ["AmB_nosound",false]}) then {_allsounds pushBack _sound1};

	private _dis = _logic distance player;
	private _vol = switch (true) do {
		case (_dis <= 250) : {random .4};
		case (_dis <= 500 && {_dis > 250}) : {random 1};
		case (_dis <= 800 && {_dis > 500}) : {random 1.5};
		case (_dis <= 1000 && {_dis > 800}) : {random 2};
		case (_dis <= 1500 && {_dis > 1000}) : {random 2.5};
		case (_dis <= 2000 && {_dis > 1500}) : {random 3};
		case (_dis > 2000) : {random 4};
	};

	private _sound = selectRandom _allsounds;
	_pitch = if (_sound isEqualTo _sound1) then {random .5 + .5} else {random .5 + .9};
	_volume = if (_sound isEqualTo _sound1) then {_vol + random 1} else {_vol + random .5};

	playsound3d [_sound,_logic,false,getPosasl _logic,_volume,_pitch,0];
};

missionNamespace setVariable ["AmB_nosound",false];
private _plays = true;
private _logic = (createGroup sideLogic) createUnit ["Logic",(getPos _mod),[],0,"NONE"];
private _Scale = _mod getVariable "Scale";
private _Ssize = _Scale/(_Scale*.1)/_Scale^.5*10;
private _intensity = _mod getVariable "Intensity";
private _Isize = _intensity/(_intensity*.1)/_intensity^.5*10;

while {_plays} do {
	_battleRadius = random ((_Ssize * 3) + (_Isize * 3));
	_ScaleR = random round _Scale;
	_SsizeR = random round _Ssize;
	_intensityR = (random round _intensity) * (playersNumber _sideB max 1);
	_IsizeR = round random _Isize;
	_saS = (Ceil random (_SSizeR / 3.5));
	for "_sa" from 1 to _saS do {
		sleep Ceil ((random (_intensityR / 7) + random (_intensityR / 7))/7);
		if (_mod distance player < 1501) then {
			[_mod,_logic,_battleRadius,_intensityR,_ScaleR,_SsizeR,_IsizeR] spawn AMBSBattle;
		};
	};
	sleep Round ((random (_ScaleR) + random (_ScaleR))/7);
};

deleteVehicle _logic;

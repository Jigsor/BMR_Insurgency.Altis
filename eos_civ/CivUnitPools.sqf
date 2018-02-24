private ["_tempArray","_InfPool","_MotPool","_ACHPool","_CHPool","_uavPool","_stPool","_shipPool","_diverPool","_crewPool","_heliCrew","_ArmPool"];
_faction=(_this select 0);
_type=(_this select 1);
_tempArray=[];

// ADD CLASSNAMES 	
	if (_faction==7) then {
	_InfPool=	INS_civlist;
	_ArmPool=	[];
	_MotPool=	[];
	_ACHPool=	[];
	_CHPool=	[];
	_uavPool=	[];
	_stPool=	[];
	_shipPool=	[];
	_diverPool=	[];
	_crewPool=	[];
	_heliCrew=	[];};

////////////////////////////////////////////////////////////////////////////////////////
if (_type isEqualTo 0) then {
	for "_i" from 0 to 5 do{
		_unit=selectRandom _InfPool;
		_tempArray pushBack _unit;
	};
};

if (_type isEqualTo 1) then {_tempArray=_diverPool;};

// CREATE ARMOUR & CREW
if (_type isEqualTo 2) then {
	_tempUnit=selectRandom _ArmPool;
	_temparray pushBack _tempUnit;
	_crew=selectRandom _crewPool;
	_temparray pushBack _crew;
};

// CREATE ATTACK CHOPPER & CREW
if (_type isEqualTo 3) then {
	_tempUnit=selectRandom _ACHPool;
	_temparray pushBack _tempUnit;
	_crew=selectRandom _heliCrew;
	_temparray pushBack _crew;
};

// CREATE TRANSPORT CHOPPER & CREW
if (_type isEqualTo 4) then {
	_tempUnit=selectRandom _CHPool;
	_temparray pushBack _tempUnit;
	_crew=selectRandom _heliCrew;
	_temparray pushBack _crew;
};

// CREATE STATIC & CREW
if (_type isEqualTo 5) then {
	_tempUnit=selectRandom _stPool;
	_temparray pushBack _tempUnit;
	_crew=selectRandom _crewPool;
	_temparray pushBack _crew;
};
if (_type isEqualTo 6) then {_tempArray=selectRandom _uavPool;};

// CREATE TRANSPORT & CREW
if (_type isEqualTo 7) then {
	_tempUnit=selectRandom _MotPool;
	_temparray pushBack _tempUnit;
	_crew=selectRandom _crewPool;
	_temparray pushBack _crew;
};

// CREATE BOAT & DIVER CREW
if (_type isEqualTo 8) then {
	_tempUnit=selectRandom _shipPool;
	_temparray pushBack _tempUnit;
	_crew=selectRandom _diverPool;
	_temparray pushBack _crew;
};

// CREATE CARGO
if (_type isEqualTo 9) then {
	for "_i" from 0 to 5 do{
		_unit=selectRandom _InfPool;
		_temparray pushBack _unit;
	};
};

// CREATE DIVER CARGO
if (_type isEqualTo 10) then {
	for "_i" from 0 to 5 do{
		_unit=selectRandom _diverPool;
		_temparray pushBack _unit;
	};
};

//hint format ["%1",_tempArray];
_tempArray
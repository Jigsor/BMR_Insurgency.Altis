params ["_faction","_type"];
private _fac = if (_faction isEqualTo 1) then {missionNamespace getVariable "BMR_major_facArr"} else {missionNamespace getVariable "BMR_minor_facArr"};
private _tempArray=[];

// CREATE FOOT SOLDIERS
if (_type isEqualTo 0) then {
	for "_i" from 0 to 5 step 1 do {
		_unit=selectRandom (_fac # 0);
		_tempArray pushBack _unit;
	};
};

if (_type isEqualTo 1) then {_tempArray=(_fac # 8)};

// CREATE ARMOUR & CREW
if (_type isEqualTo 2) then {
	_tempUnit=selectRandom (_fac # 1);
	_temparray pushBack _tempUnit;
	_crew=selectRandom (_fac # 9);
	_temparray pushBack _crew;
};

// CREATE ATTACK CHOPPER & CREW
if (_type isEqualTo 3) then {
	_tempUnit=selectRandom (_fac # 3);
	_temparray pushBack _tempUnit;
	_crew=selectRandom (_fac # 10);
	_temparray pushBack _crew;
};

// CREATE TRANSPORT CHOPPER & CREW
if (_type isEqualTo 4) then {
	_tempUnit=selectRandom (_fac # 4);
	_temparray pushBack _tempUnit;
	_crew=selectRandom (_fac # 10);
	_temparray pushBack _crew;
};

// CREATE STATIC & CREW
if (_type isEqualTo 5) then {
	_tempUnit=selectRandom (_fac # 6);
	_temparray pushBack _tempUnit;
	_crew=selectRandom (_fac # 9);
	_temparray pushBack _crew;
};
if (_type isEqualTo 6) then {_tempArray=selectRandom (_fac # 5)};

// CREATE TRANSPORT & CREW
if (_type isEqualTo 7) then {
	_tempUnit=selectRandom (_fac # 2);
	_temparray pushBack _tempUnit;
	_crew=selectRandom (_fac # 9);
	_temparray pushBack _crew;
};

// CREATE BOAT & DIVER CREW
if (_type isEqualTo 8) then {
	_tempUnit=selectRandom (_fac # 7);
	_temparray pushBack _tempUnit;
	_crew=selectRandom (_fac # 8);
	_temparray pushBack _crew;
};

// CREATE CARGO
if (_type isEqualTo 9) then {
	for "_i" from 0 to 5 step 1 do{
		_unit=selectRandom (_fac # 0);
		_temparray pushBack _unit;
	};
};

// CREATE DIVER CARGO
if (_type isEqualTo 10) then {
	for "_i" from 0 to 5 step 1 do{
		_unit=selectRandom (_fac # 8);
		_temparray pushBack _unit;
	};
};

//hint format ["%1",_tempArray];
_tempArray
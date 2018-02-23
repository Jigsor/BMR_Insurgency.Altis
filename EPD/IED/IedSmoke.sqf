/* Written by Brian Sweeney - [EPD] Brian*/
_loc = _this select 0;
_aslLoc = [_loc select 0, _loc select 1, getTerrainHeightASL [_loc select 0, _loc select 1]];
_numPlumes = 20 + floor random 10;

for "_i" from 0 to _numPlumes -1 do{
	_r = floor random 3;
	switch(_r) do
	{
		case 0:
		{
			[_loc, _aslLoc] spawn {call SAND_TRAIL_SMOKE;};
		};
		case 1: 
		{
			[_loc, _aslLoc] spawn {call GRAY_TRAIL_SMOKE;};
		};
		case 2:
		{
			[_loc, _aslLoc] spawn {call BROWN_TRAIL_SMOKE;};
		};
	};

};
[_aslLoc] spawn { call CREATE_RING};

SAND_TRAIL_SMOKE = {
	_loc = _this select 0;
	_aslLoc = _this select 1;

	_size = 1 + random 3;

	_thingToFling = "Land_Bucket_F" createVehicle [0,0,0];
	_thingToFling hideObject true;
	_thingToFling setPos _loc;
	_smoke = "#particlesource" createVehicle _aslLoc;
	_smoke setposasl _aslLoc;
	_smoke setParticleCircle [0, [0, 0, 0]];
	_smoke setParticleRandom [0, [0.25, 0.25, 0], [0, 0, 0], 0, 1, [0, 0, 0, 0.1], 0, 0];
	_smoke setParticleParams [["\A3\data_f\cl_fireD", 1, 0, 1], "", "Billboard", 1, 10, [0, 0, 2], [0, 0, 0], 0, 10, 7.85, 0.375, [_size,2*_size], [[.55, .47, .37, .75], [0.78, 0.76, 0.71, 0]], [0.08], 1, 0, "", "", _thingToFling];
	_smoke setDropInterval 0.02;

	_thingToFling setVelocity [(random 40)-20, (random 40)-20, 5+(random 30)];
	_thingToFling allowDamage false;
	_sleepTime = (random 1);
	_currentTime = 0;

	while { _currentTime < _sleepTime and _size > 0} do {
		//_thingToFling hideObject true;
		_smoke setParticleParams [["\A3\data_f\cl_fireD", 1, 0, 1], "", "Billboard", 1, 10, [0, 0, 2], [0, 0, 0], 0, 10, 7.85, 0.375, [_size,2*_size], [[.55, .47, .37, .75], [0.78, 0.76, 0.71, 0]], [0.08], 1, 0, "", "", _thingToFling];

		_sleep = random .05;
		_size = _size - (6*_sleep);
		_currentTime = _currentTime + _sleep;
		sleep _sleep;
	};

	_thingToFling setpos [0,0,0];
	deletevehicle _smoke;
	deletevehicle _thingToFling;
};

GRAY_TRAIL_SMOKE = {
	_loc = _this select 0;
	_aslLoc = _this select 1;

	_size = 1 + random 3;

	_thingToFling = "Land_Bucket_F" createVehicle [0,0,0];
	_thingToFling hideObject true;
	_thingToFling setPos _loc;
	_smoke = "#particlesource" createVehicle _aslLoc;
	_smoke setposasl _aslLoc;
	_smoke setParticleCircle [0, [0, 0, 0]];
	_smoke setParticleRandom [0, [0.25, 0.25, 0], [0, 0, 0], 0, 1, [0, 0, 0, 0.1], 0, 0];
	_smoke setParticleParams [["\A3\data_f\cl_fireD", 1, 0, 1], "", "Billboard", 1, 10, [0, 0, 2], [0, 0, 0], 0, 10, 7.85, 0.375, [_size,2*_size], [[.1, .1, .1, .75], [0.78, 0.76, 0.71, 0]], [0.08], 1, 0, "", "", _thingToFling];
	_smoke setDropInterval 0.02;

	_thingToFling setVelocity [(random 40)-20, (random 40)-20, 5+(random 30)];
	_thingToFling allowDamage false;
	_sleepTime = (random 1);
	_currentTime = 0;
	
	while { _currentTime < _sleepTime and _size > 0} do {
		//_thingToFling hideObject true;
		_smoke setParticleParams [["\A3\data_f\cl_fireD", 1, 0, 1], "", "Billboard", 1, 10, [0, 0, 2], [0, 0, 0], 0, 10, 7.85, 0.375, [_size,2*_size], [[.1, .1, .1, .75], [0.78, 0.76, 0.71, 0]], [0.08], 1, 0, "", "", _thingToFling];

		_sleep = random .05;
		_size = _size - (6*_sleep);
		_currentTime = _currentTime + _sleep;
		sleep _sleep;
	};

	_thingToFling setpos [0,0,0];
	deletevehicle _smoke;
	deletevehicle _thingToFling;
};

BROWN_TRAIL_SMOKE = {
	_loc = _this select 0;
	_aslLoc = _this select 1;

	_size = 1 + random 3;

	_thingToFling = "Land_Bucket_F" createVehicle [0,0,0];
	_thingToFling hideObject true;
	_thingToFling setPos _loc;
	_smoke = "#particlesource" createVehicle _aslLoc;
	_smoke setposasl _aslLoc;
	_smoke setParticleCircle [0, [0, 0, 0]];
	_smoke setParticleRandom [0, [0.25, 0.25, 0], [0, 0, 0], 0, 1, [0, 0, 0, 0.1], 0, 0];
	_smoke setParticleParams [["\A3\data_f\cl_fireD", 1, 0, 1], "", "Billboard", 1, 10, [0, 0, 2], [0, 0, 0], 0, 10, 7.85, 0.375, [_size,2*_size], [[0.55, 0.41, 0.25, 1], [0.55, 0.41, 0.25, 0]], [0.08], 1, 0, "", "", _thingToFling];
	_smoke setDropInterval 0.02;

	_thingToFling setVelocity [(random 40)-20, (random 40)-20, 5+(random 30)];
	_thingToFling allowDamage false;
	_sleepTime = (random 1);
	_currentTime = 0;

	while { _currentTime < _sleepTime and _size > 0} do {
		//_thingToFling hideObject true;
		_smoke setParticleParams [["\A3\data_f\cl_fireD", 1, 0, 1], "", "Billboard", 1, 10, [0, 0, 2], [0, 0, 0], 0, 10, 7.85, 0.375, [_size,2*_size], [[0.55, 0.41, 0.25, 1], [0.55, 0.41, 0.25, 0]], [0.08], 1, 0, "", "", _thingToFling];

		_sleep = random .05;
		_size = _size - (6*_sleep);
		_currentTime = _currentTime + _sleep;
		sleep _sleep;
	};

	_thingToFling setpos [0,0,0];
	deletevehicle _smoke;
	deletevehicle _thingToFling;
};

CREATE_RING = {
	//.55, .47, .37 sand color
	//.78, .76, .71 whitish color
	//.1, .1, .1 dark gray
	//0, 0, 0 black
	_aslLoc = _this select 0;

	_smoke1 = "#particlesource" createVehicle _aslLoc;
	_smoke1 setposasl _aslLoc;
	_smoke1 setParticleCircle [0, [0, 0, 0]];
	_smoke1 setParticleRandom [0, [5, 5, 0], [8, 8, 1], 0, 0.25, [0.05, 0.05, 0.05, 0.1], 0, 0];
	_smoke1 setParticleParams [["\A3\data_f\cl_fireD", 1, 0, 1], "", "Billboard", 1, 30, [0, 0, 0], [0, 0, 0], 0, 10, 7.85, .375, [8, 12, 16], [[0, 0, 0, 1], [0.35, 0.35, 0.35, 0.95], [0.35, 0.35, 0.35, 0]], [0.08], 1, 0, "", "", _aslLoc];
	_smoke1 setDropInterval .01;

	_smoke2 = "#particlesource" createVehicle _aslLoc;
	_smoke2 setposasl _aslLoc;
	_smoke2 setParticleCircle [0, [0, 0, 0]];
	_smoke2 setParticleRandom [0, [5, 5, 0], [8, 8, 1], 0, 0.25, [0.05, 0.05, 0.05, 0.1], 0, 0];
	_smoke2 setParticleParams [["\A3\data_f\cl_fireD", 1, 0, 1], "", "Billboard", 1, 30, [0, 0, 0], [0, 0, 0], 0, 10, 7.85, .375, [8, 12, 16], [[.78, .76, .71, 1], [.35, .35, .35, 0.8], [0.35, 0.35, 0.35, 0]], [0.08], 1, 0, "", "", _aslLoc];
	_smoke2 setDropInterval .01;

	_smoke3 = "#particlesource" createVehicle _aslLoc;
	_smoke3 setposasl _aslLoc;
	_smoke3 setParticleCircle [0, [0, 0, 0]];
	_smoke3 setParticleRandom [0, [5, 5, 0], [8, 8, 1], 0, 0.25, [0.05, 0.05, 0.05, 0.1], 0, 0];
	_smoke3 setParticleParams [["\A3\data_f\cl_fireD", 1, 0, 1], "", "Billboard", 1, 30, [0, 0, 0], [0, 0, 0], 0, 10, 7.85, .375, [8, 12, 16], [[.55, .47, .37, 1], [.35, .35, .35, 0.95], [0.35, 0.35, 0.35, 0]], [0.08], 1, 0, "", "", _aslLoc];
	_smoke3 setDropInterval .01;

	_smoke4 = "#particlesource" createVehicle _aslLoc;
	_smoke4 setposasl _aslLoc;
	_smoke4 setParticleCircle [0, [0, 0, 0]];
	_smoke4 setParticleRandom [0, [5, 5, 0], [8, 8, 1], 0, 0.25, [0.05, 0.05, 0.05, 0.1], 0, 0];
	_smoke4 setParticleParams [["\A3\data_f\cl_fireD", 1, 0, 1], "", "Billboard", 1, 30, [0, 0, 0], [0, 0, 0], 0, 10, 7.85, .375, [8, 12, 16], [[.1, .1, .1, 1], [.2, .2, .2, 0.9], [0.35, 0.35, 0.35, 0]], [0.08], 1, 0, "", "", _aslLoc];
	_smoke4 setDropInterval .01;

	_smokes = [_smoke1,_smoke2, _smoke3,_smoke4];

	sleep 1.5;

	_smoke1 setDropInterval .05;
	_smoke2 setDropInterval .05;
	_smoke3 setDropInterval .05;
	_smoke4 setDropInterval .05;

	_smoke1 setParticleRandom [0, [9, 9, 0], [7, 7, 1], 0, 0.25, [0.05, 0.05, 0.05, 0.1], 0, 0];
	_smoke2 setParticleRandom [0, [9, 9, 0], [7, 7, 1], 0, 0.25, [0.05, 0.05, 0.05, 0.1], 0, 0];
	_smoke3 setParticleRandom [0, [9, 9, 0], [7, 7, 1], 0, 0.25, [0.05, 0.05, 0.05, 0.1], 0, 0];
	_smoke4 setParticleRandom [0, [9, 9, 0], [7, 7, 1], 0, 0.25, [0.05, 0.05, 0.05, 0.1], 0, 0];

	_smoke1 setParticleParams [["\A3\data_f\cl_fireD", 1, 0, 1], "", "Billboard", 1, 30, [0, 0, 0], [0, 0, 0], 0, 10, 7.85, .375, [8, 12, 16], [[.35, .35, .35, 1], [.2, .2, .2, 0.9], [0.35, 0.35, 0.35, 0]], [0.08], 1, 0, "", "", _aslLoc];
	_smoke2 setParticleParams [["\A3\data_f\cl_fireD", 1, 0, 1], "", "Billboard", 1, 30, [0, 0, 0], [0, 0, 0], 0, 10, 7.85, .375, [8, 12, 16], [[.35, .35, .35, 1], [.2, .2, .2, 0.9], [0.35, 0.35, 0.35, 0]], [0.08], 1, 0, "", "", _aslLoc];
	_smoke3 setParticleParams [["\A3\data_f\cl_fireD", 1, 0, 1], "", "Billboard", 1, 30, [0, 0, 0], [0, 0, 0], 0, 10, 7.85, .375, [8, 12, 16], [[.35, .35, .35, 1], [.2, .2, .2, 0.9], [0.35, 0.35, 0.35, 0]], [0.08], 1, 0, "", "", _aslLoc];
	_smoke4 setParticleParams [["\A3\data_f\cl_fireD", 1, 0, 1], "", "Billboard", 1, 30, [0, 0, 0], [0, 0, 0], 0, 10, 7.85, .375, [8, 12, 16], [[.35, .35, .35, 1], [.2, .2, .2, 0.9], [0.35, 0.35, 0.35, 0]], [0.08], 1, 0, "", "", _aslLoc];

	sleep 3;

	_smoke1 setParticleRandom [0, [12, 12, 0], [6, 6, 1], 0, 0.25, [0.05, 0.05, 0.05, 0.1], 0, 0];
	_smoke2 setParticleRandom [0, [12, 12, 0], [6, 6, 1], 0, 0.25, [0.05, 0.05, 0.05, 0.1], 0, 0];
	_smoke3 setParticleRandom [0, [12, 12, 0], [6, 6, 1], 0, 0.25, [0.05, 0.05, 0.05, 0.1], 0, 0];
	_smoke4 setParticleRandom [0, [12, 12, 0], [6, 6, 1], 0, 0.25, [0.05, 0.05, 0.05, 0.1], 0, 0];

	sleep 3;

	_smoke1 setParticleRandom [0, [15, 15, 0], [4, 4, 1], 0, 0.25, [0.05, 0.05, 0.05, 0.1], 0, 0];
	_smoke2 setParticleRandom [0, [15, 15, 0], [4, 4, 1], 0, 0.25, [0.05, 0.05, 0.05, 0.1], 0, 0];
	_smoke3 setParticleRandom [0, [15, 15, 0], [4, 4, 1], 0, 0.25, [0.05, 0.05, 0.05, 0.1], 0, 0];
	_smoke4 setParticleRandom [0, [15, 15, 0], [4, 4, 1], 0, 0.25, [0.05, 0.05, 0.05, 0.1], 0, 0];

	sleep 25;
	{
		deletevehicle _x;
	} foreach _smokes;

};
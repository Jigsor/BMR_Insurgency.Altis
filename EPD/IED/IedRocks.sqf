/* Written by Brian Sweeney - [EPD] Brian*/
_loc = _this select 0;
_aslLoc = [_loc select 0, _loc select 1, getTerrainHeightASL [_loc select 0, _loc select 1]];
_col = [0,0,0];
_c1 = _col select 0;
_c2 = _col select 1;
_c3 = _col select 2;

_rocks1 = "#particlesource" createVehicle _aslLoc;
_rocks1 setposasl _aslLoc;
_rocks1 setParticleParams [["\A3\data_f\ParticleEffects\Universal\Mud.p3d", 1, 0, 1], "", "SpaceObject", 1, 12.5, [0, 0, 0], [0, 0, 15], 5, 100, 7.9, 1, [.45, .45], [[0.1, 0.1, 0.1, 1], [0.25, 0.25, 0.25, 0.5], [0.5, 0.5, 0.5, 0]], [0.08], 1, 0, "", "", _aslLoc,0,false,0.3];
_rocks1 setParticleRandom [0, [1, 1, 0], [15, 15, 10], 3, 0.25, [0, 0, 0, 0.1], 0, 0];
_rocks1 setDropInterval 0.01;
_rocks1 setParticleCircle [0, [0, 0, 0]];

_rocks2 = "#particlesource" createVehicle _aslLoc;
_rocks2 setposasl _aslLoc;
_rocks2 setParticleParams [["\A3\data_f\ParticleEffects\Universal\Mud.p3d", 1, 0, 1], "", "SpaceObject", 1, 12.5, [0, 0, 0], [0, 0, 15], 5, 100, 7.9, 1, [.27, .27], [[0.1, 0.1, 0.1, 1], [0.25, 0.25, 0.25, 0.5], [0.5, 0.5, 0.5, 0]], [0.08], 1, 0, "", "", _aslLoc,0,false,0.3];
_rocks2 setParticleRandom [0, [1, 1, 0], [15, 15, 10], 3, 0.25, [0, 0, 0, 0.1], 0, 0];
_rocks2 setDropInterval 0.01;
_rocks2 setParticleCircle [0, [0, 0, 0]];

_rocks3 = "#particlesource" createVehicle _aslLoc;
_rocks3 setposasl _aslLoc;
_rocks3 setParticleParams [["\A3\data_f\ParticleEffects\Universal\Mud.p3d", 1, 0, 1], "", "SpaceObject", 1, 12.5, [0, 0, 0], [0, 0, 15], 5, 100, 7.9, 1, [.09, .09], [[0.1, 0.1, 0.1, 1], [0.25, 0.25, 0.25, 0.5], [0.5, 0.5, 0.5, 0]], [0.08], 1, 0, "", "", _aslLoc,0,false,0.3];
_rocks3 setParticleRandom [0, [1, 1, 0], [15, 15, 10], 3, 0.25, [0, 0, 0, 0.1], 0, 0];
_rocks3 setDropInterval 0.01;
_rocks3 setParticleCircle [0, [0, 0, 0]];


_rocks = [_rocks1,_rocks2, _rocks3];
sleep .5;
{
	deletevehicle _x;
} foreach _rocks;
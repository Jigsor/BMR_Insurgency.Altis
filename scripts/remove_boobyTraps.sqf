//remove_boobyTraps.sqf by Jigsor

if (!isServer) exitwith {};
waitUntil {time > 62};

private ["_szPosArry","_safeZones","_a","_cl","_cs","_tb","_mb","_bm","_loop"];
_szPosArry = [];
_safeZones = Blu4_mkrs + ["Airfield"];

{
	_pos = getmarkerPos _x;
	_szPosArry pushBack _pos;
} forEach _safeZones;

for [{_loop=0}, {_loop<1}, {_loop=_loop}] do {

	_a = [];
	{
		_cl = _x nearObjects ["CraterLong",500];
		{deleteVehicle _x} count _cl;

		_cs = _x nearObjects ["CraterLong_small",500];
		{deleteVehicle _x} count _cs;

		_tb = _x nearObjects ["TimeBombCore",50];
		{if (mineActive _x) then {_a pushBack _x};} forEach _tb;

		_mb = _x nearObjects ["minebase",50];
		{_a pushBack _x} count _mb;

		_bm = _x nearObjects ["BoundingMineBase",50];
		{_a pushBack _x} count _bm;

		{deleteVehicle _x;} count _a;
		sleep 1;
	} forEach _szPosArry;
	sleep 120;
};
//MAD Ambient Life (Traffic) v1, SP and fully MP compatible
//by MAD T, NSS-Gamers.com
//credits to TPW for TPW MODS: enhanced realism/immersion, without him this would not be possible.

//Note: This is a derivative work of TPW´s TPW MODS: enhanced realism/immersion. It contains some code of it but it´s main difference is that this
//works on dedicated servers. It is still WIP;

MAD_maxCarDensity = _this # 0; //number of cars around 1 player at the same time
MAD_carSpawnDistance = _this # 1; //how far cars spawn away from player
MAD_maxCarDistance = _this # 2; //max distance until cars despawn

//Jig adding exclusion zone
if (isNil "WBpos") then {WBpos = getPosATL trig_alarm1init};
//Jig adding exclusion distance
ExcDis = 600;
private _lcWorldname = toLowerANSI (worldName);
if (_lcWorldname in ["tem_anizay","clafghan","napf","napfwinter","kapaulio","wl_rosche","xcam_taunus","enoch","vt7"]) then {ExcDis = 750};
if (_lcWorldname isEqualTo "rhspkl") then {ExcDis = 1000};
//Jig adding map size
MTnlRad = getnumber (configfile >> "CfgWorlds" >> worldName >> "mapSize");
if ((isNil "MTnlRad") || {MTnlRad isEqualTo 0}) then {MTnlRad = 30000};
if (_lcWorldname isEqualTo "stratis") then {MTnlRad = 6700};

MAD_carsArray = [];

MAD_getDrivingRoads = {
	_position = _this;
	_roads = _position nearRoads MAD_maxCarDistance;
	_roads
};

MAD_getSpawnRoads = {
	_position = _this;
	_farRoads = (_position nearRoads MAD_maxCarDistance) select {(_position distance position _x > MAD_carSpawnDistance) && {(_x distance2D WBpos > ExcDis)}};
	_farRoads
};

if (!isDedicated and isMultiplayer) then
{
	0 spawn {
		while {true} do	{
			_roads = (position player) call MAD_getSpawnRoads;
			_var = player getVariable ["MAD_roadsNear", false];

			if (_roads isNotEqualTo []) then {
				if (!_var) then {
					player setVariable ["MAD_roadsNear", true, true];
				};
			}
			else
			{
				if (_var) then {
					player setVariable ["MAD_roadsNear", false, true];
				};
			};

			sleep 10;
		};
	};
};

MAD_spawnCar = {
	params ["_position","_count"];

	_roads = _position call MAD_getSpawnRoads;

	if (_roads isNotEqualTo [])  then {
		_carlist = INS_civ_Veh_Car;

		if (daytime > 5 or daytime < 20) then {
			_carlist append INS_civ_Veh_Utl;
		};

		_roadseg = selectRandom _roads;
		_spawnpos = getposasl _roadseg;
		_spawndir = getdir _roadseg;
		_car = selectRandom _carlist;
		_sqname = creategroup civilian;
		_spawncar = _car createVehicle _spawnpos;
		_spawncar setdir _spawndir;
		[_spawncar] call BMRINS_fnc_bypassVehCrashDamage;
		[_spawncar] call BMRINS_fnc_civVehTextureGlobal;
		[_spawncar] call BMRINS_fnc_setPlate;
		_spawncar setfuel 0.5 + (random 0.5);
		MAD_carsArray pushBack _spawncar;

		//Driver
		_civtype = selectRandom INS_civlist;
		_driver = _sqname createUnit [_civtype,_spawnpos, [], 0, "FORM"];
		_driver addeventhandler ["killed", {_this spawn INSciviKilled_fnc}];
		(group _driver) setVariable ["zbe_cacheDisabled",true];
		_driver moveindriver _spawncar;
		_spawncar setvariable ["MAD_car_driver", _driver];
		_driver setbehaviour "SAFE";
		_driver disableAI "MINEDETECTION";

		_spawncar addEventHandler ["GetOut", {
			params ["","","_unit"];
			MAD_carsArray pushBack _unit;
		}];

		[leader _sqname] call MAD_carWaypoint;
	};
};

MAD_carWaypoint = {
	_driver = _this # 0;
	_grp = group _driver;
	if (count waypoints _grp > 12) exitWith {};
	_locations = nearestLocations [getPos _driver, ["NameVillage","NameCity","NameCityCapital","NameLocal","CityCenter"], MTnlRad];
	_randomLocation = selectRandom _locations;
	_locationPos = locationPosition _randomLocation;
	_roads = _locationPos call MAD_getDrivingRoads;
	_road = selectRandom _roads;

	if (_roads isNotEqualTo []) then {
		_wp = getposasl _road;
		_waypoint = _grp addWaypoint [_wp, 0];
		[_grp,0] setWaypointCompletionRadius 30;
		_waypoint setWaypointStatements ["true", "[this] call MAD_carWaypoint"];
	};
};

MAD_deleteCars = {
	private _players = [];

	if (isMultiplayer) then	{
		{
			if (isPlayer _x) then {
				_players pushBack _x;
			};
		} forEach playableUnits;
	}else{
		_players = [player];
	};

	_index = MAD_carsArray findIf {vehicleVarName _x isEqualTo "sstBomber"};
	if (_index != -1) then {MAD_carsArray deleteAt _index};

	private "_car";
	{
		_car = _x;
		_c = 0;

		{
			if (_car distance _x > MAD_maxCarDistance && {(lineintersects [eyepos _x,getposasl _car,_x,_car]) || (terrainintersectasl [eyepos _x,getposasl _car])}) then {
				_c = _c + 1;
			};
		} forEach _players;

		if (_c isEqualTo (count _players)) then	{
			private _driver = (_car getvariable ["MAD_car_driver", objNull]);

			if (!isNull _driver) then {
				_group = group _driver;
				moveout _driver;
				deleteVehicle _driver;
				deleteGroup _group;
			};

			MAD_carsArray = MAD_carsArray - [_car];
			deleteVehicle _car;
		};
	} forEach MAD_carsArray;
};

if (isServer) then {
	if (isMultiplayer) then	{
		while {true} do {
			call MAD_deleteCars;

			{
				_player = _x;
				_count = 0;
				_var = _player getVariable ["MAD_roadsNear", false];

				if (_var) then {
					{
						if (_x distance _player < MAD_maxCarDistance) then {
							_count = _count + 1;
						};
					} forEach MAD_carsArray;

					if (_count < MAD_maxCarDensity) then {
						[(position _player), _count] call MAD_spawnCar;
					};
				};
			} forEach playableUnits;

			sleep 10;
		};
	}
	else
	{
		while {true} do	{
			call MAD_deleteCars;

			_count = 0;
			_var = player getVariable ["MAD_roadsNear", false];

			if (_var) then {
				{
					if (_x distance player < MAD_maxCarDistance) then {
						_count = _count + 1;
					};
				} forEach MAD_carsArray;

				if (_count < MAD_maxCarDensity) then {
					[(position player), _count] call MAD_spawnCar;
				};
			};

			sleep 10;
		};
	};
};
//tky_evo_performance report by GITS Tankbsuter
//put me in the mission scripts folder and fire me up from init.sqf or similar with nul = execVM "Scripts\tky_evo_performance_report.sqf";
diag_log "perfmon";

params ["_mypause"];
private ["_myentities","_westcars","_eastcars","_resistancecars","_civiliancars","_westmen","_civmen","_westair","_eastair","_resistanceair","_animals","_totalgrps","_resistancemen"];

//hint format ["pause value:%1",_mypause];

if (!isServer) exitWith {};
if (DebugEnabled < 1) exitWith {};
if (_mypause == 0) exitWith {};

_numDeadMarkers = 0;

while {true} do
{
	_myentities = entities "";
	_westcars = {_x isKindOf "Car" && side _x isEqualTo west} count _myentities;
	_eastcars = {_x isKindOf "Car" && side _x isEqualTo east} count _myentities;
	_resistancecars = {_x isKindOf "Car" && side _x isEqualTo resistance} count _myentities;
	_civiliancars = {_x isKindOf "Car" && side _x isEqualTo civilian} count _myentities;

	_westmen = {_x isKindOf "SoldierWB"} count _myentities;
	_eastmen = {_x isKindOf "SoldierEB"} count _myentities;
	_resistancemen = {_x isKindOf "SoldierGB"} count _myentities;
	_civmen = {_x isKindOf "Civilian"} count _myentities;

	_westair = {_x isKindOf "Air" && side _x isEqualTo west} count _myentities;
	_eastair = {_x isKindOf "Air" && side _x isEqualTo east} count _myentities;
	_resistanceair = {_x isKindOf "Air" && side _x isEqualTo resistance} count _myentities;

	_animals = {_x isKindOf "Animal_Base_F"} count _myentities;
	_totalgrps = count allgroups;

	diag_log format ["===tky performance output for %1, %2, %3.%4, %5===", missionName, productVersion select 1, productVersion select 2, productVersion select 3, productVersion select 4];
	diag_log format ["Missiontime %1 Servertime %2", floor Time, floor serverTime];
	diag_log format ["FPS %1 WestPlayers %2 EastPlayers %3 Entities %4", floor diag_fps,  playersNumber west, playersNumber east, count _myentities];
	diag_log format ["Occupied Vehicles West=%1 East=%2 Resistance=%3 Civilian=%4", _westcars,_eastcars,_resistancecars,_civiliancars];
	diag_log format ["Dismounted Men West=%1 East=%2 Ind=%3 Civs=%4", _westmen,_eastmen,_resistancemen, _civmen];
	diag_log format ["Airborne West=%1 East=%2 Resistance=%3", _westair,_eastair,_resistanceair];
	diag_log format ["Dead men=%1 Animals=%2", count alldeadmen, _animals];
	diag_log format ["Groups=%1", _totalgrps];

	if (!isDedicated) then
	{
		player groupchat format ["Missiontime %1 Servertime %2", floor Time, floor serverTime];
		player groupchat format ["FPS %1 WestPlayers %2 EastPlayers %3 Entities %4", floor diag_fps,  playersNumber west, playersNumber east, count _myentities];
		player groupchat format ["Occupied Vehicles West=%1 East=%2 Resistance=%3 Civilian=%4", _westcars,_eastcars,_resistancecars,_civiliancars];
		player groupchat format ["Dismounted Men West=%1 East=%2 Ind=%3 Civs=%4", _westmen,_eastmen,_resistancemen, _civmen];
		player groupchat format ["Airborne West=%1 East=%2 Resistance=%3", _westair,_eastair,_resistanceair];
		player groupchat format ["Dead men=%1 Groups=%2 Animals=%3", count alldeadmen, count allGroups, _animals];
		player groupchat format ["%1 %2 @ %3", (name player), side player, position player];

		for "_i" from 1 to _numDeadMarkers step 1 do {
			_deadmarkname = format ["DeadMarker%1", _i];
			if !(getMarkerType _deadmarkname isEqualTo "") then {
				deleteMarkerLocal _deadmarkname;
			};
		};

		_i = 0;
		{
			_i = _i + 1;
			_deadmarkname = format ["DeadMarker%1", _i];
			_deadmark = createMarkerLocal [_deadmarkname, position _x];
			_deadmark setMarkerShapeLocal "ICON";
			_deadmark setMarkerTypeLocal "mil_unknown";
			_deadmark setMarkerSizeLocal [0.5, 0.5];

			if (!alive _x) then
			{
				_deadmark setMarkerColorLocal "ColorBlack";
				_deadmark setMarkerTextLocal format ["Dead %1", typeOf _x];
			}
			else
			{
				if (side _x isEqualTo west) then {
					_deadmark setMarkerColorLocal "ColorBlue";
				}else{
					if (side _x isEqualTo east) then {
						_deadmark setMarkerColorLocal "ColorRed";
					}else{
						if (side _x isEqualTo resistance) then {
							_deadmark setMarkerColorLocal "ColorGreen";
						}else{
							if (side _x isEqualTo civilian) then {
								_deadmark setMarkerColorLocal "ColorWhite";
							}else{
								_deadmark setMarkerColorLocal "ColorYellow";
							};
						};
					};
				};

				if (_x isKindOf "Boat") then {
					_deadmark setMarkerTextLocal format ["Boat %1", typeOf _x];
					_deadmark setMarkerTypeLocal "Boat";
				}else{
					if (_x isKindOf "Car") then {
						_deadmark setMarkerTextLocal format ["Car %1", typeOf _x];
						_deadmark setMarkerTypeLocal "c_car";
					}else{
						if (_x isKindOf "Air") then {
							_deadmark setMarkerTextLocal format ["Air %1", typeOf _x];
							_deadmark setMarkerTypeLocal "b_air";
						}else{
							if (_x isKindOf "Civilian") then {
								_deadmark setMarkerTextLocal format ["Civ %1", typeOf _x];
								_deadmark setMarkerTypeLocal "c_unknown";
							}else{
								if (_x isKindOf "Animal_Base_F") then {
									_deadmark setMarkerTextLocal format ["%1", typeOf _x];
									_deadmark setMarkerColorLocal "ColorBrown";
								}else{
									if (_x isKindOf "SoldierWB") then {
										_deadmark setMarkerTextLocal format ["Sol %1", typeOf _x];
										_deadmark setMarkerTypeLocal "b_inf";
									}else{
										if (_x isKindOf "SoldierEB") then {
											_deadmark setMarkerTextLocal format ["Sol %1", typeOf _x];
											_deadmark setMarkerTypeLocal "o_inf";
										}else{
											if (_x isKindOf "Tank") then {
												_deadmark setMarkerTextLocal format ["Tank %1", typeOf _x];
												_deadmark setMarkerTypeLocal "b_armor";
											}else{
												_deadmark setMarkerTextLocal format ["%1 - %2", typeOf _x, side _x];
											};
										};
									};
								};
							};
						};
					};
				};
			};
		} forEach _myentities;

		_numDeadMarkers = _i;

	};

	sleep _mypause;
};
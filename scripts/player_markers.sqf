/*
AUTHOR: aeroson
NAME: player_markers.sqf
VERSION: 2.6

DOWNLOAD & PARTICIPATE:
	https://github.com/aeroson/a3-misc
	http://forums.bistudio.com/showthread.php?156103-Dynamic-Player-Markers

DESCRIPTION:
	A script to mark players on map
	All markers are created locally
	Designed to be dynamic, small and fast
	Shows driver/pilot, vehicle name and number of passengers
	Click vehicle marker to unfold its passengers list
	Lets BTC mark unconscious players
	Shows Norrin's revive unconscious units
	Shows who is in control of UAV unit

USAGE:
	in (client's) init do:
	0 = [] execVM 'player_markers.sqf';
	this will show players for your side in multiplayer
	or you and all ais on your side in singleplayer

	to change this you can add any of the following options
		"players" will show players
		"ais" will show ais
		"allsides" will show all sides not only the units on player's side
	0 = ["player","ai"] execVM 'player_markers.sqf';
	this will show all player and all ais, you can add allside if you want to show all sides
	once you add any of these default behaviour is not used
*/

if (isDedicated) exitWith {}; // is server
if (!isNil{AeroPlayerMkrsPos}) exitWith {}; // already running

private _showAllSides=false;
private _showPlayers=false;
private _showAIs=true;

if(count _this==0) then {
	_showAllSides=false;
	_showPlayers=true;
	//_showAIs=!isMultiplayer;
};

{
	private _l=toLowerANSI _x;
	if(_l in ["player","players"]) then {
		_showPlayers=true;
	};
	if(_l in ["ai","ais"]) then {
		_showAIs=true;
	};
	if(_l in ["allside","allsides"]) then {
		_showAllSides=true;
	};
} forEach _this;

AeroPlayerMkrsPos = [0,0];

["PlayerMarkers_mapclick","onMapSingleClick", {
	AeroPlayerMkrsPos=_pos;
}] call BIS_fnc_addStackedEventHandler;

private "_mkrNo";
private _getNextMkr = {
	_mkrNo = _mkrNo + 1;
	private _mkr = format["um%1",_mkrNo];
	if(markerType _mkr isEqualTo "") then {
		createMarkerLocal [_mkr, _this];
	} else {
		_mkr setMarkerPosLocal _this;
	};
	_mkr;
};

private _getMkrCol = {
	[(((side _this) call bis_fnc_sideID) call bis_fnc_sideType),true] call bis_fnc_sidecolor;
};
disableSerialization;

while {true} do {
	uisleep 1;
	_mkrNo = 0;

	// show players or player's vehicles
	{
		private _show = false;
		private _injured = false;
		private _u = _x;

		if(
			(
				(_showAIs && {!isPlayer _u} && {0=={ {_x==_u} count crew _x>0} count allUnitsUav}) ||
				(_showPlayers && {isPlayer _u})
			) && {
				_showAllSides || side _u isEqualTo side player
			}
		) then {
			if((crew vehicle _u) select 0 == _u) then {
				_show = true;
			};
			if(!alive _u || damage _u > 0.9) then {
				_injured = true;
			};
			if(!isNil {_u getVariable "hide"}) then {
				_show = false;
			};
			if(_u getVariable ["BTC_need_revive",-1] == 1 || {lifeState _u isEqualTo "INCAPACITATED"} || {_u getVariable ["ACE_isUnconscious", false]}) then {
				_injured = true;
				_show = false;
			};
		};

		if(_show) then {
			private _veh = vehicle _u;
			_pos = getPosWorld _veh;
			_col = _u call _getMkrCol;

			private _mkrTxt = _pos call _getNextMkr;
			_mkrTxt setMarkerColorLocal _col;
 			_mkrTxt setMarkerTypeLocal "c_unknown";
			_mkrTxt setMarkerSizeLocal [0.8,0];

			private _mkr = _pos call _getNextMkr;
			_mkr setMarkerColorLocal _col;
			_mkr setMarkerDirLocal getDir _veh;
			_mkr setMarkerTypeLocal "mil_triangle";
			_mkr setMarkerTextLocal "";
			if(_veh == vehicle player) then {
				_mkr setMarkerSizeLocal [0.8,1];
			} else {
				_mkr setMarkerSizeLocal [0.5,0.7];
			};

			private "_txt";
 			if(_veh != _u && !(_veh isKindOf "ParachuteBase")) then {
				_txt = format["[%1]", getText(configFile>>"CfgVehicles">>typeOf _veh>>"DisplayName")];
				if(!isNull driver _veh && {alive driver _veh}) then {
					_txt = format["%1 %2", name driver _veh, _txt];
				};

				private "_num";
				if((AeroPlayerMkrsPos distance2D getPosWorld _veh) < 50) then {
					AeroPlayerMkrsPos = getPosWorld _veh;
					_num = 0;
					{
						if(alive _x && isPlayer _x && _x != driver _veh) then {
							_txt = format["%1%2 %3", _txt, if(_num>0)then{","}else{""}, name _x];
							_num = _num + 1;
						};
					} forEach crew _veh;
				} else {
					_num = {alive _x && isPlayer _x && _x != driver _veh} count crew _veh;
					if (_num>0) then {
						if (isNull driver _veh) then {
							_txt = format["%1 %2", _txt, name (crew _veh select 0)];
							_num = _num - 1;
						};
						if (_num>0) then {
							_txt = format["%1 +%2", _txt, _num];
						};
					};
				};
			} else {				
				_txt = ["Unidentified", name _x] select (alive _x); //if dead "Unidentified" is selected
			};
			_mkrTxt setMarkerTextLocal _txt;
		};
	} forEach allUnits;

	// show player controlled uavs
	{
		if(isUavConnected _x) then {
			private _u=(uavControl _x) select 0;
			if(
				(
					(_showAIs && {!isPlayer _u}) ||
					(_showPlayers && {isPlayer _u})
				) && {
					_showAllSides || side _u==side player
				}
			) then {
				_col = _x call _getMkrCol;
				_pos = getPosWorld _x;

				private _mkr = _pos call _getNextMkr;
				_mkr setMarkerColorLocal _col;
				_mkr setMarkerDirLocal getDir _x;
				_mkr setMarkerTypeLocal "mil_triangle";
				_mkr setMarkerTextLocal "";
				if(_u == player) then {
					_mkr setMarkerSizeLocal [0.8,1];
				} else {
					_mkr setMarkerSizeLocal [0.5,0.7];
				};

				private _mkrTxt = _pos call _getNextMkr;
				_mkrTxt setMarkerColorLocal _col;
				_mkrTxt setMarkerTypeLocal "c_unknown";
				_mkrTxt setMarkerSizeLocal [0.8,0];
				_mkrTxt setMarkerTextLocal format["%1 [%2]", name _u, getText(configFile>>"CfgVehicles">>typeOf _x>>"DisplayName")];
			};
		};
	} forEach allUnitsUav;

	_mkrNo = _mkrNo + 1;
	private _mkr = format["um%1",_mkrNo];
	while {(markerType _mkr) != ""} do {
		deleteMarkerLocal _mkr;
		_mkrNo = _mkrNo + 1;
		_mkr = format["um%1",_mkrNo];
	};
};
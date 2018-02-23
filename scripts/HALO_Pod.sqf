/*
OPTRE_Fnc_HEV
Author: Big_Wilk
Modified to not depend on HEV module by Costno and Jigsor
*/

private ["_arr","_units","_allHEVs","_aiHevOverWater","_chuteArray","_dir","_dir2","_relDir","_door","_delay"];

_arr				= (_this select 3);
_units				= [];	// Units that will be effected
_launchDelay	 		= 3;	// 3 Second delay
_randomXYVelocity 		= 0.5;	// Randomised Velocity
_launchSpeed 			= -250;	// Speed HEVs will be launched at
_manualControl			= 1;	// Can the player take manual control of the HEV? 0: No, 1: Rotate Only 2: Full Control (Not Implemented).

_startHeight 			= 2800;	// The Height your start at and the ship your are deployed from will spawn (if wanted)
_hevDropArmtmosphereStartHeight = 2000;	// The height atmospheric entry effects start at
_hevDropArmtmosphereEndHeight 	= 1000;	// The height atmospheric entry effects end at
_chuteDeployHeightHeight 	= 500;	// The height HEvs chute deploy at, the height engines switch off at
_chuteDetachHeight		= 200;	// The height the HEVs chute detaches at

_deleteChutesOnDetach		= true;	// TRUE chutes are deleted after they are detached fro, HEVs, FALSE they be added to the clean up system.
_deleteHEVsAfter 		= 30;	// Number in seconds representing how much time must pass before the HEVs are allowed to be deleted.
_DirOfShip			= 0;	// direction ship faces WIP.

if (_arr isEqualTo 0) then {_units pushBack player;};
if ((_arr isEqualTo 1) || (_arr isEqualTo 2)) then {
	if (leader group player != player) exitWith {player sideChat localize "STR_BMR_group_leaders_only"};
	if (count units group player < 2) exitWith {};
	if (count bon_recruit_queue > 0) then { waitUntil {sleep 1; count bon_recruit_queue < 1}; };
	_grp = group player;
	{if (!(isPlayer _x) && (vehicle _x == _x)) then {_units pushBack _x;};} forEach (units _grp);
	if (_arr isEqualTo 2) then {_units pushBack player};
};

//Genrate a position to Halo with mapclick
if ({_x in (items player + assignedItems player)}count ["ItemMap"] < 1) exitWith {hint localize "STR_BMR_missing_map"};

openMap true;
player groupChat "Map Click";
mapclick = false;

["HALO_mapclick","onMapSingleClick", {
	clickpos = _pos;
	mapclick = true;
}] call BIS_fnc_addStackedEventHandler;

waituntil {mapclick or !(visiblemap)};
["HALO_mapclick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;

if (!visibleMap) exitwith {hint "Standby";};

_pos = clickpos;
sleep 1;
openMap false;

///////////////////////////// Spawn HEVs //////////////////////////////////////////////////////////////////////
 
_hevArray = [];			// All HEVs created
_hevArrayPlayer = [];	// All HEVs created	for players
_hevArrayAi = [];		// All HEVs created for ai
_listOfPlayers = [];	// All players units
_listOfAi = []; 		// All ai units

{
	if (vehicle _x == _x AND alive _x) then {
		_unitDir = getDir _x;

		_dir = floor random 360;
		_dir2 = floor random 360;
		_spawnPos = [round((_pos select 0)-15*sin(_dir)), round((_pos select 1)-15*cos(_dir2)), _startHeight];

		_hev = createVehicle ["OPTRE_HEV", _spawnPos, [], 0, "FLY"];
		_relDir = _hev getRelDir [(_pos select 0),(_pos select 1)];
		_hev setDir _relDir;

		_hev lock true;
		_hevArray pushBack _hev;

		[_x,_hev] remoteExec ["moveInDriver", _x, false];
		[_x,false] remoteExec ["allowDamage", _x, false];

		if (isPlayer _x) then {
			_listOfPlayers pushBack _x;
			_hevArrayPlayer pushBack _hev;
			_hev setVariable ["OPTRE_PlayerControled",true,true];
		} else {
			_listOfAi pushBack _x;
			_hevArrayAi pushBack _hev;
		};
	};
} forEach _units;

///////////////////////////// Start Drop + Down Boaster Effects ///////////////////////////////////////////////

sleep _launchDelay; // Admire the veiw!

{

	detach _x; // Start the drop!

	_light = "#lightpoint" createVehicle [0,0,0];
	[0,_x,_light] remoteExec ["OPTRE_fnc_PlayerHEVEffectsUpdate_Light", 0, false];

	_fire = "#particlesource" createVehicle [0,0,0];
	_fire setParticleClass "RocketBackfireRPG";
	_fire attachto [_x,[0,1.5,0.6]];

	sleep (random 0.5); // Brief Pause

	if (_x getVariable ["OPTRE_PlayerControled",false]) then {
		[(random _randomXYVelocity),(random _randomXYVelocity),_launchSpeed,_manualControl] remoteExec ["OPTRE_fnc_PlayerHEVEffectsUpdate_BoasterDown", _x, false];
	} else {
		[_x, [(random _randomXYVelocity),(random _randomXYVelocity),_launchSpeed]] remoteExec ["setVelocity", _x, false];
	};

	_x setVariable ["OPTRE_HEVeffects",[_fire,_light],false];

	{if !(isNull attachedTo _x) then {"OPTRE_Sounds_Detach" remoteExec ["playSound", driver _x, false];};} forEach _hevArrayPlayer;

} forEach _hevArray;

_secondsOfSleep = count _hevArray * 0.5;
sleep (if (_secondsOfSleep > 22) then {0} else {22 - _secondsOfSleep});

{{deleteVehicle _x; sleep 0.5;} forEach (_x getVariable ["OPTRE_HEVeffects",[]]);} forEach _hevArray;

/////////////////////////////// Atmosphere Entry Effects //////////////////////////////////////////////////////

if (_hevDropArmtmosphereStartHeight > -1) then {

	waitUntil {{(((getPos _x) select 2) < _hevDropArmtmosphereStartHeight)} count _hevArray > 0};
	{
		_light = "#lightpoint" createVehicle [1,1,1];
		[1,_x,_light] remoteExec ["OPTRE_fnc_PlayerHEVEffectsUpdate_Light", 0, false];

		_fire = "#particlesource" createVehicle [0,0,0];
		_fire setParticleClass "IncinerateFire";
		_fire attachto [ _x, [0,0,-2]];

		_x setVariable ["OPTRE_HEVeffects",[_fire,_light],false];

		if (_x getVariable ["OPTRE_PlayerControled",false]) then { [_hevDropArmtmosphereEndHeight] remoteExec ["OPTRE_fnc_PlayerHEVEffectsUpdate_ReEntrySounds", _x, false]; };

		sleep (random 0.5);

	} forEach _hevArray;

	waitUntil {{(((getPos _x) select 2) < _hevDropArmtmosphereEndHeight)} count _hevArray > 0};
	{{deleteVehicle _x;} forEach (_x getVariable ["OPTRE_HEVeffects",[]]); sleep .5;} forEach _hevArray;

};

/////////////////////////////// Chute Open ////////////////////////////////////////////////////////////////////

waitUntil {{(((getPos _x) select 2) < _chuteDeployHeightHeight)} count _hevArray > 0};
_chuteArray = [];
{
	_chute = "OPTRE_HEV_Chute" createVehicle [0,0,0];
	_chute attachTo [_x, [0,-0.2,1.961]];
	_chuteArray pushBack _chute;

	_chute animate ["wing1_rotation",1];
	_chute animate ["wing2_rotation",1];
	_chute animate ["wing3_rotation",1];
	_chute animate ["wing4_rotation",1];

	if (_x getVariable ["OPTRE_PlayerControled",false]) then {[_chute] remoteExec ["OPTRE_fnc_PlayerHEVEffectsUpdate_Chute", _x, false];};

	[_x, [0,0,-10]] remoteExec ["setVelocity", _x, false];
	_x setVariable ["OPTRE_HEVChute",_chute, true];

	sleep .5;

	_chute animate ["wing1_rotation",0];
	_chute animate ["wing2_rotation",0];
	_chute animate ["wing3_rotation",0];
	_chute animate ["wing4_rotation",0];

	_chute disableCollisionWith _x;

} forEach _hevArray;

sleep 1.5;

waitUntil {{(((getPos _x) select 2) < _chuteDetachHeight)} count _hevArray > 0};
{
	_chute = (_x getVariable ["OPTRE_HEVChute", objNull]);
	detach _chute;
	_chute setVelocity [(random 2.5),(random 2.5),20];
	sleep .5;
} forEach _hevArray;

/////////////////////////////// Handle Landing ////////////////////////////////////////////////////////////////

{[_x] remoteExec ["OPTRE_fnc_HEVHandleLanding", driver _x, false];} forEach _hevArray;

/////////////////////////////// Clean Up //////////////////////////////////////////////////////////////////////

{deleteVehicle _x;} forEach _chuteArray;
[_hevArray,_deleteHEVsAfter] remoteExec ["OPTRE_fnc_HEVCleanUp", 2, false];

/////////////////////////////// Ai Land In Water Fix //////////////////////////////////////////////////////////

_aiHevOverWater = [];
{
	if (surfaceIsWater getPos _x OR (isPlayer (driver _x))) then {_aiHevOverWater pushBack _x;};
} forEach _hevArrayAi;
if (count _hevArrayAi > 0) then {
	_time = time + 60;
	{
		waitUntil { ( ((getPosASL _x) select 2) < 1 OR (time > _time) OR !(alive driver _x) ) };
		sleep (random 1);
		_x lock false;
		0 = [_x, 0, true] spawn OPTRE_fnc_HEVDoor;
	} forEach _aiHevOverWater;
};

//Alternative cleanup.  Todo - should be moved to server side
sleep 3;
_door = objNull;
_delay = round (90 / (count _hevArray));
while {count _hevArray > 0} do {
	if (vectorMagnitudeSqr velocity (_hevArray select 0) <= 0.5) then {
		uiSleep _delay;
		if (count _hevArray < 2) then {
			if (isPlayer objectParent (_hevArray select 0) && Alive objectParent (_hevArray select 0)) then {
				moveOut objectParent (_hevArray select 0);
			};
		};
		_door = getPosWorld (_hevArray select 0) nearestObject "OPTRE_HEV_Door";
		deleteVehicle (_hevArray select 0);
		if (!isNull _door) then {deleteVehicle _door};
		_hevArray deleteAt 0;
	}else{
		uiSleep 1;
	};
};
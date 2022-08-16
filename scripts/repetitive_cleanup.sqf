/*
	AUTHOR: aeroson
	NAME: repetitive_cleanup.sqf
	VERSION: 1.9

	DESCRIPTION:
	Can delete everything that is not really needed
	dead bodies, dropped items, smokes, chemlights, explosives, empty groups
	Works even on Altis, it eats only items which are/were 100m from all units

	If you want something to withstand the clean up, paste this into it's init:
	this setVariable["persistent",true];
*/

if (!isServer) exitWith {}; // isn't server

#define PUSH(A,B) A pushBack B;
#define REM(A,B) A=A-[B];

                                     // (0 means don't delete)
private _ttdBodies           = 2*60; // seconds to delete dead bodies
private _ttdVehiclesDead     = 5*60; // seconds to delete dead vehicles // <- mostly redundant because destroyed vehicles are managed by killed eventhandlers in BMR Insurgency
private _ttdVehiclesImmobile = 0;    // immobile vehicles // <- not needed
private _ttdWeapons          = 2*60; // seconds to delete dropped weapons
private _ttdPlanted          = 0;    // planted explosives - interferes with minefield task if set above 0
private _ttdSmokes           = 6*60; // seconds to delete dropped smokes/chemlights
private _ttdCraters          = 1*60; // seconds to delete craters
private _ttdJetParts         = 5*60; // seconds to delete canopies,ejection seats

if ((_ttdBodies + _ttdVehiclesDead + _ttdVehiclesImmobile +_ttdWeapons + _ttdSmokes + _ttdCraters + _ttdJetParts) isEqualTo 0) exitWith {}; // all times are 0, we do not want to run this script at all

private _objectsToCleanup=[];
private _timesWhenToCleanup=[];

private _addToCleanup = {
	params ["_object"];
	if(!(_object getVariable["persistent",false])) then {
		_newTime = (_this select 1)+time;
		_index = _objectsToCleanup find _object;
		if(_index == -1) then {
			PUSH(_objectsToCleanup,_object)
			PUSH(_timesWhenToCleanup,_newTime)
		} else {
			_currentTime = _timesWhenToCleanup select _index;
			if(_currentTime>_newTime) then {
				_timesWhenToCleanup set[_index, _newTime];
			};
		};
	};
};

private _removeFromCleanup = {
	params ["_object"];
	_index = _objectsToCleanup find _object;
	if(_index != -1) then {
		_objectsToCleanup set[_index, 0];
		_timesWhenToCleanup set[_index, 0];
	};
};


while{true} do {

	sleep 10;

	{
	    _unit = _x;

		if (_ttdWeapons>0) then {
			{
				{
					[_x, _ttdWeapons] call _addToCleanup;
				} forEach (getPosATL _unit nearObjects [_x, 100]);
			} forEach ["WeaponHolder","GroundWeaponHolder","WeaponHolderSimulated"];
		};

		if (_ttdPlanted>0) then {
			{
				{
					[_x, _ttdPlanted] call _addToCleanup;
				} forEach (getPosATL _unit nearObjects [_x, 100]);
			} forEach ["TimeBombCore"];
		};

		if (_ttdSmokes>0) then {
			{
				{
					[_x, _ttdSmokes] call _addToCleanup;
				} forEach (getPosATL _unit nearObjects [_x, 100]);
			} forEach ["SmokeShell"];
		};

		if (_ttdCraters>0) then {
			{
				{
					[_x, _ttdCraters] call _addToCleanup;
				} forEach (getPosATL _unit nearObjects [_x, 100]);
			} forEach ["CraterLong","CraterLong_small"];
		};

		if (_ttdJetParts>0) then {
			{
				{
					[_x, _ttdJetParts] call _addToCleanup;
				} forEach (getPosATL _unit nearObjects [_x, 100]);
			} forEach ["Plane_Canopy_Base_F","Ejection_Seat_Base_F","I_Ejection_Seat_Plane_Fighter_04_F","rhs_k36d5_seat","ffaa_av8b2_Canopy","rhs_mi28_wing_right","rhs_mi28_wing_left","rhs_a10_acesII_seat","rhs_vs1_seat","RHS_JST_A29_Ejection_Seat","CUP_B_Ejection_Seat_A10_USA","CUP_AV8B_EjectionSeat","CUP_AirVehicles_EjectionSeat","uns_mig21_ejection_seat"];
		};

	} forEach allUnits;

	{deleteGroup _x} forEach (allGroups select {local _x && {(count units _x) isEqualTo 0}});

	if (_ttdBodies>0) then {
		{
			[_x, _ttdBodies] call _addToCleanup;
		} forEach allDeadMen;
	};

	if (_ttdVehiclesDead>0) then {
		{
			if(_x == vehicle _x) then { // make sure its vehicle
				[_x, _ttdVehiclesDead] call _addToCleanup;
			};
		} forEach (allDead - allDeadMen); // all dead without dead men == mostly dead vehicles
	};

	if (_ttdVehiclesImmobile>0) then {
		{
			if(!canMove _x && {alive _x}count crew _x==0) then {
				[_x, _ttdVehiclesImmobile] call _addToCleanup;
			} else {
				[_x] call _removeFromCleanup;
			};
		} forEach vehicles;
	};


	REM(_objectsToCleanup,0)
	REM(_timesWhenToCleanup,0)

	{
		if(isNull(_x)) then {
			_objectsToCleanup set[_forEachIndex, 0];
			_timesWhenToCleanup set[_forEachIndex, 0];
		} else {
			if(_timesWhenToCleanup select _forEachIndex < time) then {
				deleteVehicle _x;
				_objectsToCleanup set[_forEachIndex, 0];
				_timesWhenToCleanup set[_forEachIndex, 0];
			};
		};
	} forEach _objectsToCleanup;

	REM(_objectsToCleanup,0)
	REM(_timesWhenToCleanup,0)

};
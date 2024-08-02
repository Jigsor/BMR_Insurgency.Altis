/*
	File: fn_paradrop.sqf
	Version: 1.1
	
	Author(s): cobra4v320 - effects adapted from old halo.sqs, sounds from freesound.org
	
	Description: allows AI units and players to paradrop - fixes AI bug
	
	Parameters:
	0: UNIT    - (object) the unit that will be doing the paradrop
	1: VEHICLE - (object) the vehicle that will be doing the paradrop
	2: (optional) SAVELOADOUT - (boolean) true to save backpack and its contents, and add a "fake" backpack to the front of the unit.
	3: (optional) CHEMLIGHT - (boolean) true if the units will use chemlights
	
	Example(s):
	[this, helo_1, true, true] call COB_fnc_paradrop
*/
if (!isServer || isDedicated) exitWith {};

//Parameters
private ["_unit","_vehicle","_saveLoadOut","_chemLight"]; 
_unit 	 	 = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_vehicle 	 = [_this, 1, objNull, [objNull]] call BIS_fnc_param;
_saveLoadOut = [_this, 2, true, [true]] call BIS_fnc_param;
_chemLight	 = [_this, 3, false, [false]] call BIS_fnc_param;

//Validate parameters
if (isNull _unit) exitWith {"Unit parameter must not be objNull. Accepted: OBJECT" call BIS_fnc_error};
if (isNull _vehicle) exitWith {"Vehicle parameter must not be objNull. Accepted: OBJECT" call BIS_fnc_error};

//create a log entry
["Paradrop function has started"] call BIS_fnc_log;

//save the backpack and its contents, also adds fake pack to front of unit
if (_saveLoadOut && !isNull (unitBackpack _unit)) then {
	private ["_pack","_class","_magazines","_weapons","_items"];
	_pack	   = unitBackpack _unit;
	_class	   = typeOf _pack;
	_magazines = getMagazineCargo _pack;
	_weapons   = getWeaponCargo _pack;
	_items	   = getItemCargo _pack;

	removeBackpack _unit; //remove the backpack
	_unit addBackpack "b_parachute";

	//attach the bacpack to the unit
	[_unit,_class,_magazines,_weapons,_items] spawn {
		private ["_unit","_class","_magazines","_weapons","_items"];
		_unit		= _this select 0;
		_class		= _this select 1;
		_magazines	= _this select 2;
		_weapons 	= _this select 3;
		_items 		= _this select 4;
			
		private "_packHolder";
		_packHolder = createVehicle ["groundWeaponHolder", [0,0,0], [], 0, "can_collide"];
		_packHolder addBackpackCargoGlobal [_class, 1];
				
		waitUntil {animationState _unit == "para_pilot"};
		_packHolder attachTo [vehicle _unit,[-0.07,0.67,-0.13],"pelvis"]; 
		_packHolder setVectorDirAndUp [[0,-0.2,-1],[0,1,0]];
				
		waitUntil {isTouchingGround _unit || (getPos _unit select 2) < 1};
		deleteVehicle _packHolder; //delete the backpack in front
		_unit addBackpack _class; //return the backpack
		clearAllItemsFromBackpack _unit; //clear all gear from new backpack

		for "_i" from 0 to (count (_magazines select 0) - 1) do {
			(unitBackpack _unit) addMagazineCargoGlobal [(_magazines select 0) select _i,(_magazines select 1) select _i]; //return the magazines
		};
		for "_i" from 0 to (count (_weapons select 0) - 1) do {
			(unitBackpack _unit) addWeaponCargoGlobal [(_weapons select 0) select _i,(_weapons select 1) select _i]; //return the weapons
		};
		for "_i" from 0 to (count (_items select 0) - 1) do {
			(unitBackpack _unit) addItemCargoGlobal [(_items select 0) select _i,(_items select 1) select _i]; //return the items
		};
	};
} else {
	if ((backpack _unit) != "b_parachute") then {_unit addBackpack "B_parachute"}; //add the parachute if unit has no backpack
};

//eject from vehicle
[_unit,_vehicle] spawn {
	private ["_unit","_vehicle","_altitude"];
	_unit = _this select 0;
	_vehicle = _this select 1;

	_altitude = (getPos _vehicle select 2);
	_unit allowDamage false; //keep the AI from being injured when in para_pilot, its an AI bug
	
	if (_altitude > 3040 && (headgear _unit) != "H_CrewHelmetHeli_B") then {_unit addHeadgear "H_CrewHelmetHeli_B"};
	
	unassignVehicle _unit;
	_unit action ["EJECT", _vehicle];
	_unit setDir getDir _vehicle;
	_unit setPos [(getPos _vehicle select 0), (getPos _vehicle select 1) - random 15 + random 30, _altitude - 4];
	_unit setVelocity [0,20,-20];
	
	if (isPlayer _unit) then {	
		_unit action ["OpenParachute",_unit];
		
		// Parachute opening effect for more immersion
		playSound "open_chute"; //play chute opening sound
		setAperture 0.05; 
		setAperture -1;
		"DynamicBlur" ppEffectEnable true;  
		"DynamicBlur" ppEffectAdjust [8.0];  
		"DynamicBlur" ppEffectCommit 0.01;
		sleep 1;
		"DynamicBlur" ppEffectAdjust [0.0]; 
		"DynamicBlur" ppEffectCommit 3;
		sleep 3;
		"DynamicBlur" ppEffectEnable false;
		"RadialBlur" ppEffectAdjust [0.0, 0.0, 0.0, 0.0]; 
		"RadialBlur" ppEffectCommit 1.0; 
		"RadialBlur" ppEffectEnable false;
	
		[_unit] spawn {
			private "_unit";
			_unit = _this select 0;
			
			while {(getPos _unit select 2) > 2 && alive _unit} do {
				playSound "para_pilot"; //play sound
				sleep 4.2;
			};
		};
	};

	waitUntil {isTouchingGround _unit || (getPos _unit select 2) < 1}; //wait for unit to touch ground

	if (!isPlayer _unit) then {
		_unit setPos [(getPos _unit select 0), (getPos _unit select 1), 0]; //this removes the unit from the parachute
		_unit setVelocity [0,0,0]; //set speed to zero
		_unit setVectorUp [0,0,1]; //set the unit upright
		sleep 1;
		_unit allowDamage TRUE; //allow unit to be damaged again
	} else {
		playSound "close_chute";//play chute closing sound
		cutText ["", "BLACK FADED", 999];
		sleep 2;
		cutText ["", "BLACK IN", 2];
		_unit allowDamage TRUE; //allow unit to be damaged again
	};
};
	
//add a chemlight to helmet
if (_chemLight) then {
	[_chemLight,_unit] spawn {
		private ["_chemlight","_unit","_light"];
		_chemLight = _this select 0;
		_unit	   = _this select 1;
		
		_light = "chemlight_red" createVehicle [0,0,0]; //create the chemlight
		
		waitUntil {animationState _unit == "para_pilot"};
		
		if (headgear _unit != "") then {
			_light attachTo [vehicle _unit,[0,0.14,0.84],"head"]; 
			_light setVectorDirAndUp [[0,1,-1],[0,1,0.6]];
		} else {
			_light attachTo [vehicle _unit,[-0.13,-0.09,0.56],"LeftShoulder"];  
			_light setVectorDirAndUp [[0,0,1],[0,1,0]];
		};
		
		waitUntil {isTouchingGround _unit || (getPos _unit select 2) < 1};
		detach _light;
		deleteVehicle _light; //delete the chemlight
	};
};

//create a log entry
["Paradrop function has completed"] call BIS_fnc_log;

//Return Value
_unit;
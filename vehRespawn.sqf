/* ---------------------------------------------------------------------------------------------------

File: vehRespawn.sqf
Author: Iceman77

Description:
Respawn destroyed and abandoned vehicles

Parameter(s):
_this select 0: vehicle 
_this select 1: abandoned delay in minute(s) - Required
_this select 2: destroyed delay in minute(s) - Required
_this select 3: Function to call for the newly spawned vehicle (for custom armaments etc) - Optional

How to use - Vehicle Init Line: 
_nul = [this, 2, 1, {[_this] call TAG_FNC_TankInit}] execVM "vehRespawn.sqf"; << 2 minute abandoned delay, 1 minute destroyed delay, call the function that disables the TI
_nul = [this, 2, 1, {}] execVM "vehrespawn.sqf"; << 2 minute abandoned delay, 1 minute destroyed delay, NO function called for the newly respawned vehicle (standard way)

---------------------------------------------------------------------------------------------------- */

private ["_veh","_abandonDelay","_deadDelay","_vehInit","_dir","_vehPos","_vehtype","_vehName"];

_veh = _this select 0;
_abandonDelay = (_this select 1) * 60;
_deadDelay = (_this select 2) * 180;
_vehInit = _this select 3;
_dir = getDir _veh;
_vehPos = getPos _veh;
_vehtype = typeOf _veh;
_vehName = vehicleVarName _veh;

if (isServer) then {
	uiSleep (random 1);
	While {True} Do {
		uiSleep 1;
		if ((alive _veh) && {canMove _veh} && {{alive _x} count crew _veh isEqualTo 0}) then {
			_abandoned = true;

			for "_i" from 0 to _abandonDelay step 1 do {
				if (({alive _x} count (crew _veh) > 0) || (!alive _veh) || (!canMove _veh)) exitWith {_abandoned = false;};
				sleep 1;
			};

			if (_abandoned && {_veh distance2D _vehPos > 10}) then {
				deleteVehicle _veh;
				sleep 1;

				_veh = createVehicle [_vehtype, _vehPos, [], 0, "CAN_COLLIDE"];
				_veh setDir _dir;
				_veh setPos [_vehPos select 0, _vehPos select 1,0];
				if !(_vehName isEqualTo "") then {
					missionNamespace setVariable [_vehName, _veh];
					publicVariable _vehName;
				};
				_veh call _vehInit;
				_veh setdamage 0;
			};
		};

		if ((!alive _veh) || (!canMove _veh)) then {
			_dead = true;

			for "_i" from 0 to _deadDelay step 1 do {
				if (({alive _x} count (crew _veh) > 0) || (canMove _veh)) exitWith {_dead = false;};
				uiSleep 1;
			};

			if (_dead) then {
				deleteVehicle _veh;
				sleep 1;

				_veh = createVehicle [_vehtype, _vehPos, [], 0, "CAN_COLLIDE"];
				_veh setDir _dir;
				_veh setPos [_vehPos select 0, _vehPos select 1,0];
				if !(_vehName isEqualTo "") then {
					missionNamespace setVariable [_vehName, _veh];
					publicVariable _vehName;
				};
				_veh call _vehInit;
				_veh setdamage 0;
			};
		};
	};
};
// INS_Bail.sqf //

private ["_target","_loadout","_veh"];

_target = player;
_veh = vehicle player;

hint "";

//(vehicle player) getHitPointDamage "hitEngine";
//_allVehHitPoints = (configfile >> "CfgVehicles" >> _veh >> "HitPoints") call BIS_fnc_getCfgSubClasses;

if ((driver _veh == player) && {(getDammage _veh < 0.68) && ((isEngineOn _veh) || ((vehicle player) getHitPointDamage "hitEngine" < 0.68))}) exitWith {hint localize "STR_BMR_Bail_restrictOnDamage"};

if (soundVolume isEqualTo 0.3) then {1 fadeSound 1};

moveOut _target;

_loadout = [_target] call ATM_Getloadout;
0=[_target] call Frontpack;

removeBackpack _target;
sleep 0.5;
_target addBackpack "B_Parachute";

while {(getPos _target select 2) > 2} do {
	if !(isTouchingGround _target and isNull objectParent player) then {
		playSound "Vent2";
		sleep (0.9 + random 0.3);
		playSound "Vent";
	};
	if !(INS_ACE_para) then {
		if((getPosATL _target select 2 < 150) || (getPosASL _target select 2 < 150)) then {
			_target action ["OpenParachute", _target];
		};
	};
	if(!alive _target) then {
		_target setPos [getPos _target select 0, getPos _target select 1, 0];
		0=[_target,_loadout] call ATM_Setloadout;
	};
};

deleteVehicle (_target getVariable "frontpack"); _target setVariable ["frontpack",nil,true];

0=[_target,_loadout] call ATM_Setloadout;
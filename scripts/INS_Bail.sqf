// INS_Bail.sqf //

private _p = player;
private _veh = vehicle player;

hint "";

//(vehicle player) getHitPointDamage "hitEngine";
//_allVehHitPoints = (configfile >> "CfgVehicles" >> _veh >> "HitPoints") call BIS_fnc_getCfgSubClasses;

if ((player isEqualTo driver _veh) && {(getDammage _veh < 0.7) && ((isEngineOn _veh) || ((vehicle player) getHitPointDamage "hitEngine" < 0.7))}) exitWith {hint localize "STR_BMR_Bail_restrictOnDamage"};

if (soundVolume isEqualTo 0.5) then {1 fadeSound 1};

moveOut _p;

private _loadout = [_p] call ATM_Getloadout;
0=[_p] call Frontpack;

removeBackpack _p;
sleep 0.5;
_p addBackpack "B_Parachute";

while {(getPos _p select 2) > 2} do {
	if !(isTouchingGround _p and isNull objectParent _p) then {
		playSound "Vent2";
		sleep (0.9 + random 0.3);
		playSound "Vent";
	};
	if !(INS_ACE_para) then {
		if((getPosATL _p select 2 < 150) || (getPosASL _p select 2 < 150)) then {
			_p action ["OpenParachute", _p];
		};
	};
	if(!alive _p) then {
		_p setPos [getPos _p select 0, getPos _p select 1, 0];
		0=[_p,_loadout] call ATM_Setloadout;
	};
};

deleteVehicle (_p getVariable "frontpack"); _p setVariable ["frontpack",nil,true];

0=[_p,_loadout] call ATM_Setloadout;
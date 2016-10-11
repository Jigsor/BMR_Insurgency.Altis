/* original work from: Tankbuster */
/* adapted from:  Dynamic IED script by - Mantis -*/
/* Rewritten by Brian Sweeney - [EPD] Brian*/

(_this select 0) removeAllEventHandlers "HitPart";

_arr = _this select 3;

if(format["%1",_arr select 1] != "") then {terminate (_arr select 1);};
_chance = baseDisarmChance;
_trigger = _arr select 0;
_iedNumber = _arr select 2;

_bonusAdded = false;
{
	if((not _bonusAdded) and ((typeof player) isKindOf _x )) then {
		_chance = _chance + bonusDisarmChance;
		_bonusAdded = true;
	};
} foreach betterDisarmers;

if (((random 100) < _chance)) then {
	//player switchMove "AinvPknlMstpSlayWrflDnon_medic";
	[[[player], {(_this select 0) switchMove "AinvPknlMstpSlayWrflDnon_medic";}], "BIS_fnc_call", nil, false, false] call BIS_fnc_MP;
	disableUserInput true;
	sleep 6;
	disableUserInput false;
	deletevehicle (_trigger);
	[[_this select 0],"removeAct", true, true] spawn BIS_fnc_MP;
	hint "Successfully Disarmed!";
} else {
	[[[player], {(_this select 0) switchMove "AinvPknlMstpSlayWrflDnon_medic";}], "BIS_fnc_call", nil, false, false] call BIS_fnc_MP;
	disableUserInput true;
	sleep 2;
	disableUserInput false;
	[getpos player] spawn {call DISARM_EXPLOSIONS;};
	deletevehicle (_trigger);
	[[_this select 0],"removeAct", true, true] spawn BIS_fnc_MP;
	deletevehicle (_this select 0);
	hint "Failed to Disarm!";
};

eventHandlers set [_iedNumber, "true;"];
publicVariable "eventHandlers";

removeAct = {
 _unit = _this select 0;
 _unit removeaction 0;
};

DISARM_EXPLOSIONS = {
	_iedPosition = _this select 0;
	_explosiveSequence = ["Bo_GBU12_LGB_MI10","Bo_GBU12_LGB_MI10","M_PG_AT","R_80mm_HE"];
	[[_iedPosition] , "IED_SMOKE", true, false] spawn BIS_fnc_MP;
	[[_iedPosition] , "IED_SCREEN_EFFECTS", true, false] spawn BIS_fnc_MP;
	for "_i" from 0 to (count _explosiveSequence) -1 do{
		[[_iedPosition] , "IED_ROCKS", true, false] spawn BIS_fnc_MP;
		_explosive = (_explosiveSequence select _i);
		_xCoord = (random 4)-2;
		_yCoord = (random 4)-2;
		_bomb = _explosive createVehicle _iedPosition;
		_bomb setPos [(_iedPosition select 0)+_xCoord,(_iedPosition select 1)+_yCoord, 0];
		if(((position player) distanceSqr getPos _bomb) < 40000) then {  //less than 200 meters away
			addCamShake[1+random 5, 1+random 3, 5+random 15];
		};
		sleep random .03;
	};
};
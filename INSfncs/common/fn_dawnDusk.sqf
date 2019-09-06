_dawnDusk = date call BIS_fnc_sunriseSunsetTime;
missionNameSpace setVariable ["BMR_DawnDusk",_dawnDusk];
_cache = missionNameSpace getVariable ["BMR_DawnDusk",[]];
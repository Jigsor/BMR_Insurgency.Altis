_grp=(_this select 0);

_grp setVariable ["zbe_cacheDisabled",true];
_skillset = server getvariable (_this select 1);
{
	_unit = _x;
	{
		_skillvalue = (_skillset select _forEachIndex) + (random 0.2) - (random 0.2);
		_unit setSkill [_x,_skillvalue];
	} forEach ['aimingAccuracy','aimingShake','aimingSpeed','spotDistance','spotTime','courage','reloadSpeed','commanding','general'];

	if (EOS_DAMAGE_MULTIPLIER != 1) then {_unit removeAllEventHandlers "HandleDamage";_unit addEventHandler ["HandleDamage",{_damage = (_this select 2)*EOS_DAMAGE_MULTIPLIER;_damage}];};
	if (EOS_CIV_KILLCOUNTER) then {_unit addEventHandler ["killed", "null=[] execVM ""eos\functions\EOS_CIV_KILLCOUNTER.sqf"""]};
	// ADD CUSTOM SCRIPTS TO UNIT HERE

	//Jig adding
	_unit addeventhandler ["killed","[(_this select 0)] spawn remove_carcass_fnc"];

} forEach (units _grp);
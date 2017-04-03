_grp=(_this select 0);

_skillset = server getvariable (_this select 1);
{
	_unit = _x;
	{
		_skillvalue = (_skillset select _forEachIndex) + (random 0.2) - (random 0.2);
		_unit setSkill [_x,_skillvalue];
	} forEach ['aimingAccuracy','aimingShake','aimingSpeed','spotDistance','spotTime','courage','reloadSpeed','commanding','general'];

	if (EOS_DAMAGE_MULTIPLIER != 1) then {_unit removeAllEventHandlers "HandleDamage";_unit addEventHandler ["HandleDamage",{_damage = (_this select 2)*EOS_DAMAGE_MULTIPLIER;_damage}];};
	//if (EOS_KILLCOUNTER) then {_unit addEventHandler ["killed", "null=[] execVM ""eos\functions\EOS_KillCounter.sqf"""]};

	//Jig adding
	if (side _unit == east) then {
		_unit unlinkItem "NVGoggles_OPFOR";
		if ((_this select 2) in eosFacNVG) then {
			_unit linkItem "NVGoggles_OPFOR";
		};
	}else{
		if (side _unit == resistance) then {
			_unit unlinkItem "NVGoggles_INDEP";
			if ((_this select 2) in eosFacNVG) then {
				_unit linkItem "NVGoggles_INDEP";
			};
		};
	};
	_unit addPrimaryWeaponItem "acc_flashlight";
	_unit enableGunLights "forceOn";//"AUTO"
	_unit addeventhandler ["killed","[(_this select 0)] spawn remove_carcass_fnc"];
	if (Fatigue_ability isEqualTo 0) then {_unit enableStamina false;};
	if (INS_op_faction isEqualTo 16) then {[_unit] call Trade_Biofoam_fnc};

} forEach (units _grp);
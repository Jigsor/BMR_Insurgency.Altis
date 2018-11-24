_grp=(_this # 0);

_skillset = server getvariable (_this # 1);
{
	_unit = _x;
	{
		_skillvalue = (_skillset select _forEachIndex) + (random 0.2) - (random 0.2);
		_unit setSkill [_x,_skillvalue];
	} forEach ['aimingAccuracy','aimingShake','aimingSpeed','spotDistance','spotTime','courage','reloadSpeed','commanding','general'];

	if !(AIdamMod isEqualTo 1) then {_unit removeAllEventHandlers "HandleDamage";_unit addEventHandler ["HandleDamage",{_damage = (_this select 2)*AIdamMod;_damage}];};
	//if (EOS_KILLCOUNTER) then {_unit addEventHandler ["killed", "null=[] execVM 'eos\functions\EOS_KillCounter.sqf'"]};

	_unit addEventHandler ["Reloaded", {//Jig adding
		params ["_unit", "_weapon", "_muzzle", "_newmag", ["_oldmag", ["","","",""]]];
		if (_oldmag # 2 isEqualType "") then {_unit addMagazine (_newmag # 0)} else {_unit addMagazine (_oldmag # 0)};
	}];

	//Jig adding
	if (side _unit isEqualTo east) then {
		_unit unlinkitem (hmd _unit);
		if ((_this # 2) in eosFacNVG) then {
			_unit linkItem "NVGoggles_OPFOR";
		};
	}else{
		if (side _unit isEqualTo resistance) then {
			_unit unlinkitem (hmd _unit);
			if ((_this # 2) in eosFacNVG) then {
				_unit linkItem "NVGoggles_INDEP";
			};
		};
	};
	_unit addPrimaryWeaponItem "acc_flashlight";
	_unit enableGunLights "forceOn";//"AUTO"
	_unit addeventhandler ["killed","[(_this # 0)] spawn remove_carcass_fnc"];
	if (Fatigue_ability isEqualTo 0) then {_unit enableStamina false};
	if (INS_op_faction isEqualTo 16) then {[_unit] call Trade_Biofoam_fnc};

} forEach (units _grp);
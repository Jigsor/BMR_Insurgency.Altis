_grp=(_this # 0);
_skillset = server getvariable (_this # 1);
_nvg = if ((_this # 2) isEqualTo 1) then {(missionNamespace getVariable "BMR_major_facArr") # 11} else {(missionNamespace getVariable "BMR_minor_facArr") # 11};
_grpSide = side _grp;
_dd = missionNameSpace getVariable ["BMR_DawnDusk",[]];
_dd params ["_dawn","_dusk"];
_isNight = if (daytime > _dusk || daytime < _dawn) then {true} else {false};

{
	_unit = _x;
	{
		_skillvalue = (_skillset select _forEachIndex) + (random 0.2) - (random 0.2);
		_unit setSkill [_x,_skillvalue];
	} forEach ['aimingAccuracy','aimingShake','aimingSpeed','spotDistance','spotTime','courage','reloadSpeed','commanding','general'];

	if (AIdamMod isNotEqualTo 1) then {_unit removeAllEventHandlers "HandleDamage";_unit addEventHandler ["HandleDamage",{_damage = (_this select 2)*AIdamMod;_damage}];};
	//if (EOS_KILLCOUNTER) then {_unit addEventHandler ["killed", "null=[] execVM 'eos\functions\EOS_KillCounter.sqf'"]};

	_unit addEventHandler ["Reloaded", {//Jig adding
		params ["_unit", "_weapon", "_muzzle", "_newmag", ["_oldmag", ["","","",""]]];
		if (_oldmag # 2 isEqualType "") then {_unit addMagazine (_newmag # 0)} else {_unit addMagazine (_oldmag # 0)};
	}];

	//Jig adding
	_binocs = binocular _unit;
	if (_binocs isNotEqualTo "") then {_unit removeWeapon _binocs};
	_unit unlinkitem (hmd _unit);
	if (_grpSide isEqualTo east && {(_nvg && {_isNight})}) then {
		_unit linkItem "NVGoggles_OPFOR";
	};
	if (_grpSide isEqualTo resistance && {(_nvg && {_isNight})}) then {
		_unit linkItem "NVGoggles_INDEP";
	};

	if (_isNight) then {
		_unit addPrimaryWeaponItem "acc_flashlight";
		_unit enableGunLights "forceOn";//"AUTO"
	}
	else
	{
		_wepAcc = _unit weaponAccessories primaryWeapon _unit;
		if (_wepAcc param [1, ""] != "") then {_unit removePrimaryWeaponItem _wepAcc # 1};
	};

	_unit addeventhandler ["killed","[(_this # 0)] spawn remove_carcass_fnc"];
	if (INS_op_faction in [20]) then {[_unit] call Trade_Biofoam_fnc};

} forEach (units _grp);
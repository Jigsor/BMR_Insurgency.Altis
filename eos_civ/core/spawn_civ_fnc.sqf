
IF (isnil "server")then{hint "YOU MUST PLACE A GAME LOGIC NAMED SERVER!";};
EOS_fnc_spawncivvehicle=compile preprocessfilelinenumbers "eos_civ\functions\eos_SpawnCivVehicle.sqf";
eos_fnc_civ_grouphandlers=compile preprocessfilelinenumbers "eos_civ\functions\civ_setSkill.sqf";
eos_fnc_findsafepos_civ=compile preprocessfilelinenumbers "eos_civ\functions\civ_findSafePos.sqf";
eos_fnc_spawngroup_civ= compile preprocessfile "eos_civ\functions\civ_fnc.sqf";
eos_fnc_setcargo_civ = compile preprocessfile "eos_civ\functions\civ_cargo_fnc.sqf";
EOS_fnc_taskpatrol_civ= compile preprocessfile "eos_civ\functions\civ_shk_patrol.sqf";
SHK_civ_pos= compile preprocessfile "eos_civ\functions\SHK_civ_pos.sqf";
shk_fnc_fillhouse_civ = compile preprocessFileLineNumbers "scripts\SHK_buildingpos.sqf";
eos_fnc_getcivunitpool= compile preprocessfilelinenumbers "eos_civ\CivUnitPools.sqf";
call compile preprocessfilelinenumbers "eos_civ\Civ_AI_Skill.sqf";

EOS_Civ_Deactivate = {
	params ["_mkr"];
	{
		_x setmarkercolor "ColorBlack";
		_x setmarkerAlpha 0;
	}foreach _mkr;
};

EOS_civ_debug = {
	params ["_mkr","_n","_note","_pos"];
	_mkrID=format ["%3:%1,%2",_mkr,_n,_note];
	deletemarker _mkrID;
	_debugMkr = createMarker[_mkrID,_pos];
	_mkrID setMarkerType "Mil_dot";
	_mkrID setMarkercolor "ColorBlue";
	_mkrID setMarkerText _mkrID;
	_mkrID setMarkerAlpha 0.5;
};
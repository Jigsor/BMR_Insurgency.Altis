// SingleThreadCrateRefill.sqf by Jigsor
// Refills all ammo boxes that have names listed in Arrays INS_Op4_wepCrates and INS_Blu4_wepCrates defined in INS_definitions.sqf.
// Param 0=sleep delay before refilling next crate.

if (!isServer) exitWith {};
waitUntil {time > 11};

private ["_t","_all_c_params","_crates","_crate","_c_params","_items","_BPs","_mags","_weps","_c"];

_t = _this select 0;
_all_c_params = [];
_crates = INS_Op4_wepCrates + INS_Blu4_wepCrates - [INS_E_tent];

{if ((isNull _x) || (!alive _x)) then {_crates =_crates - [_x];};} forEach _crates;

{
	_crate = _x;
	_items = ItemCargo _crate;
	_BPs = backpackCargo _crate;
	_mags = magazineCargo _crate;
	_weps = WeaponCargo _crate;
	_c_params = [_crate,_items,_BPs,_mags,_weps];

	_all_c_params pushBack _c_params;
} forEach _crates;

while {true} do {
	{
		_c = _x;
		if (alive (_c select 0)) then {
			if (count (_c select 1) != 0) then {
				clearItemCargoGlobal (_c select 0);
				{(_c select 0) addItemCargoGlobal [_x, 1];} count (_c select 1);
			};
			if (count (_c select 2) != 0) then {
				clearBackpackCargoGlobal (_c select 0);
				{(_c select 0) addBackpackCargoGlobal [_x, 1];} count (_c select 2);
			};
			clearMagazineCargoGlobal (_c select 0);
			{(_c select 0) addMagazineCargoGlobal [_x, 1];} count (_c select 3);
			clearWeaponCargoGlobal (_c select 0);
			{(_c select 0) addWeaponCargoGlobal [_x, 1];} count (_c select 4);
			sleep 0.3;
		};
	} forEach _all_c_params;
	sleep _t;
};
// SingleThreadCrateRefill.sqf by Jigsor
// Refills all ammo boxes that have names listed in Arrays INS_Op4_wepCrates and INS_Blu4_wepCrates defined in INS_definitions.sqf.
// Param 0=sleep delay between refill cycles.

if (!isServer) exitWith {};
waitUntil {time > 11};

params [["_t", 180, [0]]];
private _crates = INS_Op4_wepCrates + INS_Blu4_wepCrates - [INS_E_tent];
private _all_c_params = [];

{if ((isNull _x) || (!alive _x)) then {_crates =_crates - [_x];};} forEach _crates;

private ["_crate","_items","_BPs","_mags","_weps","_c_params"];
{
	_crate = _x;
	_items = ItemCargo _crate;
	_BPs = backpackCargo _crate;
	_mags = magazineCargo _crate;
	_weps = WeaponCargo _crate;
	_c_params = [_crate,_items,_BPs,_mags,_weps];

	_all_c_params pushBack _c_params;
} forEach _crates;

private "_c";
while {true} do {
	{
		_c = _x;
		if (alive (_c # 0)) then {
			if !((_c # 1) isEqualTo []) then {
				clearItemCargoGlobal (_c # 0);
				{(_c # 0) addItemCargoGlobal [_x, 1];} count (_c # 1);
			};
			if !((_c # 2) isEqualTo []) then {
				clearBackpackCargoGlobal (_c # 0);
				{(_c # 0) addBackpackCargoGlobal [_x, 1];} count (_c # 2);
			};
			clearMagazineCargoGlobal (_c # 0);
			{(_c # 0) addMagazineCargoGlobal [_x, 1];} count (_c # 3);
			clearWeaponCargoGlobal (_c # 0);
			{(_c # 0) addWeaponCargoGlobal [_x, 1];} count (_c # 4);
			sleep 0.3;
		};
	} forEach _all_c_params;
	sleep _t;
};
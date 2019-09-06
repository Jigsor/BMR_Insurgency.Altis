private _p = player;
private _bannedWeapons = ["HLC_wp_M134Painless"];
private _found = false;

if (currentWeapon _p in _bannedWeapons) then {
	_p removeWeapon currentWeapon _p;
	_found = true;
};
if (secondaryWeapon _p in _bannedWeapons) then {
	_p removeweapon secondaryWeapon _p;
	_found = true;
};
if (handgunWeapon _p in _bannedWeapons) then {
	_p removeWeapon (handgunWeapon _p);
	_found = true;
};
if (!isNull backpackContainer _p && {(weaponCargo backpackContainer _p) findIf {_x in _bannedWeapons} != -1}) then {
	{
		_p removeItemFromBackpack _x;
	} forEach _bannedWeapons;
	_found = true;
};
if (_found) then {hintSilent "Sorry, Weapon Banned :("};
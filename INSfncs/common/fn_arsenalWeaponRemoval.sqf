private _p = player;
private _bannedWeapons = ["HLC_wp_M134Painless"];		//Optional restriction: Headgear with FLIR- 	"NVGogglesB_blk_F","NVGogglesB_grn_F","NVGogglesB_gry_F","H_HelmetO_ViperSP_hex_F","H_HelmetO_ViperSP_ghex_F"
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

private _allHG = assignedItems _p;
_allHG pushBack (headgear _p);
private _detected = (_bannedWeapons arrayIntersect _allHG);
if !(_detected isEqualTo []) then {
	{_p unlinkItem _x;} forEach _detected;
	_found = true;
};

if (_found) then {hintSilent "Sorry, Weapon Banned :("};
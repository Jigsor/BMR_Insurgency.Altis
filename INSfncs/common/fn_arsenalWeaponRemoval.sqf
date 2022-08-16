// simple black listing
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
if (_detected isNotEqualTo []) then {
	{_p unlinkItem _x;} forEach _detected;
	_found = true;
};

if (_found) then {hintSilent "Sorry, Weapon Banned :("};

// More thorough check against Arsenal whitelists if whitelisting is enabled. Should be compatible with Ace or Vanilla Arsenal or work even if profile data is hacked.
private _illegalKit = false;
private _whiteList = false;
private _list = [];
private _pS = playerSide;
private _aT = INS_VA_type;

if (_pS isEqualTo WEST && _aT in [1,2]) then {
	BMRINS_profileSave = "BMR_bis_fnc_saveInventory_west_data";
	_list = call BMRINS_fnc_BluforVA;
	_whiteList = true;
};
if (_pS isEqualTo EAST && _aT in [2,3]) then {
	BMRINS_profileSave = "BMR_bis_fnc_saveInventory_east_data";
	_list = call BMRINS_fnc_InsurgentVA;
	_whiteList = true;
};

if (!_whiteList) exitWith {};

private _currInv = getUnitLoadout _p;
_currInv = str _currInv splitString "[]," joinString ",";
_currInv = parseSimpleArray ("[" + _currInv + "]");
_currInv = _currInv arrayIntersect _currInv select {_x isEqualType "" && {_x != ""}};
//copyToClipboard str _currInv;

_list = str _list splitString "[]," joinString ",";
_list = parseSimpleArray ("[" + _list + "]");
_list = _list arrayIntersect _list select {_x isEqualType "" && {_x != ""}};

private _item = "";
for "_i" from 0 to (count _currInv) -1 do {
	_item = _currInv # 0;
	if !(_item in _list) exitWith {
		_illegalKit = true;
	};
	_currInv deleteAt 0;
};

if (_illegalKit) then {
	removeAllAssignedItems _p;
	removeAllWeapons _p;
	removeAllAssignedItems _p;
	removeAllContainers _p;
	removeHeadgear _p;
	removeGoggles _p;
	hint format ["You have a non whitelisted arsenal item '%1'. Now your naked", _item];
	if (!isServer) then {diag_log text format["!!!! BMR notice You have a non whitelisted arsenal item in this kit. Class name: '%1'", _item]};
	private _n = name _p;
	private _sPS = str _pS;
	[_n, _sPS, _item] remoteExec ['BMRINS_fnc_reportIllegalItem', 2];
};
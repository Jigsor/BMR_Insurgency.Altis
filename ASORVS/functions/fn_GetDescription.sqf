_vehicle = _this select 0;
_ret = "";
_headerformat = "<t shadow='2' size='1'>";
_itemformat = "<t shadow='2' size='2'>";
_weaponsToHide = ["Horn"];
_seats = [_vehicle] call ASORVS_fnc_VehicleSlots;

_driver = { _x == "DRIVER" } count _seats;
_commander = {_x == "COMMANDER" } count _seats;
_cargo = ({_x == "TRANSPORT" } count _seats) + ({_x == "PLAYERTURRET" } count _seats);
_gunners = { _x == "GUNNER" } count _seats;
_copilots = { _x == "COPILOT" } count _seats;
_playerturrets = ({_x == "PLAYERTURRET" } count _seats);
_isair = (_vehicle isKindOf "Plane") || (_vehicle isKindOf "Helicopter");
if((_driver > 0) || (_commander > 0) || (_gunners > 0)) then {
	_ret = _ret + _headerformat + "Crew </t><br/>" + _itemformat;
	_firstcrew = true;
	if(_driver > 0) then {
		_driverword = "Driver";
		if(_isair) then { _driverword = "Pilot"; };
		if(_driver == 1) then {
			_ret = _ret + _driverword;
		} else {
			_ret = _ret + format["%1 %2s", _driver, _driverword];
		};
		_firstcrew = false;
	};
	if(_copilots > 0) then {
		if((!_firstcrew)) then {
			if((_gunners == 0) && (_commander == 0)) then { _ret = _ret +  " and "; } else { _ret = _ret + ", "; };
		};
		if(_copilots == 1) then {
			_ret = _ret + "Copilot";
		} else {
			_ret = _ret + format["%1 Copilots", _driver];
		};
		_firstcrew = false;
	};
	if(_commander > 0) then {
		if((!_firstcrew)) then {
			if(_gunners > 0) then { _ret = _ret + ", "; } else { _ret = _ret + " and "; };
		};
		if(_commander == 1) then {
			_ret = _ret + "Commander";
		} else {
			_ret = _ret + format["%1 Commanders", _commander];
		};
		_firstcrew = false;
	};
	if(_gunners > 0) then {
		if(!_firstcrew) then { _ret = _ret +  " and "; };
		if(_gunners == 1) then {
			_ret = _ret + "Gunner";
		} else {
			_ret = _ret + format["%1 Gunners", _gunners];
		};
		_firstcrew = false;
	};
	_ret = _ret + "</t><br/>";
};
if(_cargo > 0) then {
	if(_playerturrets > 0) then {
	_ret = _ret + _headerformat + format["Passengers</t><br/>%1%2 (%3 can shoot from vehicle)</t><br/>",_itemformat, _cargo, _playerturrets];
	} else {
	_ret = _ret + _headerformat + format["Passengers</t><br/>%1%2</t><br/>",_itemformat, _cargo];
	};
};
_weapons = [_vehicle] call ASORVS_fnc_VehicleWeapons;
_weapons = _weapons - _weaponsToHide;
if(count _weapons > 0) then {
	_ret = _ret + _headerformat + "Weapons</t><br/>" + _itemformat;
	_first = true;
	while {count _weapons > 0} do {
		if(!_first) then {
			_ret = _ret + ", ";
		};
		_weapon = _weapons select 0;
		_count = {tolower(_x) == tolower(_weapon) } count _weapons;
		if(_count > 1) then {
			_ret = _ret + format ["%1x %2", _count, _weapon];
		} else {
			_ret = _ret + _weapon;
		};
		_first = false;
		_weapons = _weapons - [_weapon];
	};
	_ret = _ret + "</t><br/>";
};

_weight = getMass _vehicle;
_ret = _ret + _headerformat + format["Mass</t><br/>%1%2kg</t><br/>", _itemformat, _weight];

_slingLoadable = count (getArray (configFile >> "CfgVehicles" >> typeOf _vehicle >> "slingLoadCargoMemoryPoints")) > 0;
if(_slingLoadable || !_isAir) then { //only show air vehicles if they are slingloadable (never?)
	_ret = _ret + _headerformat + format["Can Be Slingloaded</t><br/>%1%2</t><br/>", _itemformat, if(_slingLoadable) then {"Yes"} else {"No"}];
};
_maxSlingloadMass = getNumber (configFile >> "CfgVehicles" >> typeOf _vehicle >> "slingLoadMaxCargoMass"); 
if(_maxSlingloadMass > 0) then {
	_ret = _ret + _headerformat + format["Maximum Slingload Mass</t><br/>%1%2kg</t><br/>", _itemformat, _maxSlingloadMass];
};

_ret
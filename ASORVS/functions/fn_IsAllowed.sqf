private["_class", "_RTBlacklist", "_RTWhitelist", "_result", "_useFullLists"];
_class = [_this, 0, "", [""]] call BIS_fnc_Param;
if(_class == "") exitWith {false;};
_useFullLists = [_this, 1, false, [true]] call BIS_fnc_Param;
//if runtime black/whitelists haven't been defined, then must be preinit so use normal black/whitelist.
_RTBlacklist = if(isNil 'ASORVS_RuntimeBlacklist') then { [] } else { ASORVS_RuntimeBlacklist };
_RTWhitelist = if(isNil 'ASORVS_RuntimeWhitelist') then { [] } else { ASORVS_RuntimeWhitelist };
_result = true;

//check full lists
if(_useFullLists) then {
	if(_class in ASORVS_Blacklist) then {
		_result = false;
	};
	if((count ASORVS_Whitelist > 0) && (!(_class in ASORVS_Whitelist))) then {
		_result = false;
	};
};

//check runtime lists
if(_class in _RTBlacklist) exitWith { false; };
if((count _RTWhitelist > 0) && (!(_class in _RTWhitelist))) exitWith {false};

_result

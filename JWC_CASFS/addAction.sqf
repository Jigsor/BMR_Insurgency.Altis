_object = _this select 0;
_maxDist = _this select 1;
_lock = _this select 2;
_num = _this select 3;

_str = format[("<t color='#FF9000'>") + (localize "STR_JWC_CAS_field_system") + "</t>"];

_object addAction [_str, "JWC_CASFS\casMenu.sqf", [_maxDist, _lock, _num], -1, false, true, ""];
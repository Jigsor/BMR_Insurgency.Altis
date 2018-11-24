params ["_object","_maxDist","_lock","_num"];

_str = format[("<t color='#FF9000'>") + (localize "STR_JWC_CAS_field_system") + "</t>"];

_object addAction [_str, "JWC_CASFS\casMenu.sqf", [_maxDist, _lock, _num], -1, false, true, ""];
_iedNumber = _this select 0;
_origin = _this select 1;
_side = _this select 2;
_sectionNumber = _this select 3;

_st = [] call GET_SIZE_AND_TYPE;
[_iedNumber, _origin, _st select 0, _st select 1, _side] call CREATE_IED;

if((disarmedSections select _sectionNumber) == "") then {
	disarmedSections set [_sectionNumber, format["isNull t_%1 && ! isNull ied_%1", _iedNumber]];
	explodedSections set [_sectionNumber, format["isNull ied_%1", _iedNumber]];
} else {
	disarmedSections set [_sectionNumber, format["%2 && isNull t_%1 && ! isNull ied_%1", _iedNumber, disarmedSection select _sectionNumber]];
	explodedSections set [_sectionNumber, format["%2 || isNull ied_%1", _iedNumber, disarmedSection select _sectionNumber]];
};
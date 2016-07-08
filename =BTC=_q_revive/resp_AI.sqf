private ["_unit"];

_unit = _this;
_marker = "";
_side = _unit getVariable ["btc_qr_side",""];;
switch (_side) do {
	case (west) : {_marker = "respawn_west";};
	case (east) : {_marker = "respawn_east";};
	case (resistance) : {_marker = "respawn_guerrila";};
	case (civilian) : {_marker = "respawn_civilian";};
};
_unit setPos (getMarkerPos _marker);
_unit setDamage 0;
_unit call btc_qr_fnc_var;
{_unit enableAI _x} foreach ["TARGET","AUTOTARGET","MOVE","ANIM"];
_unit switchMove "";
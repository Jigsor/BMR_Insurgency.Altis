private _unit = _this;
_marker = "";
_side = _unit getVariable ["btc_qr_side",""];;
switch (_side) do {
	case (west) : {_marker = "Respawn_West";};
	case (east) : {_marker = "Respawn_East";};
	case (resistance) : {_marker = "Respawn_Guerrila";};
	case (civilian) : {_marker = "respawn_civilian";};
};
_unit setPos (markerPos _marker);
_unit setDamage 0;
_unit call btc_qr_fnc_var;
{_unit enableAI _x} foreach ["TARGET","AUTOTARGET","MOVE","ANIM"];
_unit switchMove "";
//Remove waypoints
// [_veh] call BMRINS_fnc_removeWPs;

params [["_veh",objNull]];
if (isNull _veh) exitWith {};

private _isOnFoot = isNull objectParent _veh;
if (_isOnFoot) then {
	_grp = group _veh;
} else {
	//_grp = group (driver _veh);
	_grp = (group (crew _veh # 0));
};

for "_i" from count waypoints _grp - 1 to 0 step -1 do {
	deleteWaypoint [_grp, _i];
};
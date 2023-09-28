params ["_mkr","_veh","_counter"];
_veh params ["_vehicle","","_grp","_cargoGrp"];

_debug=false;
_pos = [_mkr,false] call SHK_pos;
private _pad = createVehicle ["Land_HelipadEmpty_F", _pos, [], 0, "NONE"];
if (_debug) then {0= [_mkr,_counter,"Unload Pad",(getpos _pad)] call EOS_debug};

{_x allowFleeing 0} forEach units _grp;
{_x allowFleeing 0} forEach units _cargoGrp;

_wp1 = _grp addWaypoint [_pos, 0];
_wp1 setWaypointSpeed "FULL";
_wp1 setWaypointType "UNLOAD";
_wp1 setWaypointStatements ["true", "(vehicle this) LAND 'GET IN';"];

 waituntil {sleep 0.2; _vehicle distance _pad < 30};
_cargoGrp leaveVehicle _vehicle;

waitUntil{sleep 0.2; {_x in _vehicle} count units _cargoGrp == 0};
if (_debug) then {hint "Transport unloaded"};
0 = [_cargoGrp,_mkr] call eos_fnc_taskpatrol;

_wp2 = _grp addWaypoint [[0,0,0], 0];
_wp2 setWaypointSpeed "FULL";
_wp2 setWaypointType "MOVE";
//_wp2 setWaypointStatements ["true", "{deleteVehicle _x} forEach crew (vehicle this) + [vehicle this];"];
_wp2 setWaypointStatements ["true", "deleteVehicleCrew (vehicle this); deleteVehicle (vehicle this);"];

deletevehicle _pad;
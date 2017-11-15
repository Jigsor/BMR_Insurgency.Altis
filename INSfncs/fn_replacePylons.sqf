// Applies respawn module init field defined custom loadouts to aircraft. By BIS, modified by Jigsor.
//call from vehicle respawn module expression field
//if (isServer) then {  params [["_newVeh",objNull],["_oldVeh",objNull]];  0 = [_newVeh, pylonArrayName] call BMRINS_fnc_replacePylons;  };
params [["_veh",objNull],["_pylons",[]]];
if (_veh isEqualType "") exitWith {0 = [_veh, _pylons] spawn BMRINS_fnc_replacePylons;};
private _pylonPaths = (configProperties [configFile >> "CfgVehicles" >> typeOf _veh >> "Components" >> "TransportPylonsComponent" >> "Pylons", "isClass _x"]) apply {getArray (_x >> "turret")};
private _nonPylonWeapons = [];
{ _nonPylonWeapons append getArray (_x >> "weapons") } forEach ([_veh, configNull] call BIS_fnc_getTurrets);
{ _veh removeWeaponGlobal _x } forEach ((weapons _veh) - _nonPylonWeapons);
{ _veh setPylonLoadOut [_forEachIndex + 1, _x, true, _pylonPaths select _forEachIndex] } forEach _pylons;

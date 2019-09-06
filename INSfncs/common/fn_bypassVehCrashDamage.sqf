//Disable damage for non projectile hits
params [["_veh",objNull]];
if (isNull _veh) exitWith {};
_veh addEventHandler ["HandleDamage", {
    params ["_unit","_hitSelection","_damage","","_projectile"];
    if (count _projectile == 0) then {_damage = _unit getHit _hitSelection};
    _damage
}];
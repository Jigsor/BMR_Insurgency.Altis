//Revove all weapons and items from vehicle inventory
//usage: [_vehicle] call BMRINS_fnc_clearVehCargo;
params [["_veh",objNull]];
if (isNull _veh) exitWith {};
clearBackpackCargoGlobal _veh;
clearItemCargoGlobal _veh;
clearMagazineCargoGlobal _veh;
clearWeaponCargoGlobal _veh;
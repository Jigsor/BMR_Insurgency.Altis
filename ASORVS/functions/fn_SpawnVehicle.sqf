objNull spawn {
	sleep 2; //wait for client to be able to check vehicles positions properly again.
	_somedeleted =false;
	{
		deleteVehicle _x;
		_somedeleted =true;
	} forEach (ASORVS_VehicleSpawnPos nearEntities ASORVS_VehicleSpawnRadius);
	if(_somedeleted) then {
		sleep 2;
	};
	_veh = createVehicle [ASORVS_CurrentVehicle, ASORVS_VehicleSpawnPos, [], 0, "CAN_COLLIDE"];
	_veh setDir ASORVS_VehicleSpawnDir;
	[_veh] call anti_collision;
	_veh setVehicleLock "UNLOCKED";
	if(getNumber(configFile >> "CfgVehicles" >> typeOf _veh >> "isUav")==1) then {createVehicleCrew _veh};
	if ((typeOf _veh) in INS_add_Chaff) then {_veh addweapon "CMFlareLauncher"; _veh addmagazine "120Rnd_CMFlare_Chaff_Magazine";};
	if (_veh isKindOf "Ship") then {[_veh] call Push_Acc};
	if (typeOf _veh isEqualTo "I_Heli_Transport_02_F") then {[_veh] spawn BMR_resetDamage};//workaround for weird new bug. Mohawk damages itself a moment after creation.
};
private _disableSim = [];
private _compFound = false;

private _vehRepairComp = {
	 _dis = 100;
	 _farpType = typeOf Jig_m_obj;
	 _needSimulation =  nearestObjects [Jig_m_obj, [_farpType,"EmptyDetector","Car","Plane","Tank","Helicopter","CAManBase","StaticWeapon","Land_PortableLight_double_F","Land_Loudspeakers_F","Lamps_base_F","ReammoBox","Windsock_01_F","Land_RepairDepot_01_tan_F","Land_RepairDepot_01_green_F","Helipad_base_F","FlexibleTank_01_sand_F","FlexibleTank_01_sand_F","FlexibleTank_01_forest_F","B_Slingload_01_Ammo_F","B_Slingload_01_Medevac_F","B_Slingload_01_Repair_F"], _dis, true];
	 _allObjs = nearestObjects [Jig_m_obj, [], _dis, true];
	 _disableSim = _allObjs select {!(_x in _needSimulation)};
	 _disableSim
};

private _BTClogDS = {
	params [["_array", [], [[]], []]];
	{
		_x enableSimulation false;
		_x setVariable ["BTC_cannot_lift",1];
		_x setVariable ["BTC_cannot_drag",1];
		_x setVariable ["BTC_cannot_load",1];
		_x setVariable ["BTC_cannot_place",1];
	} forEach _array;
};

if ((!isNil "Jig_m_obj") && {!isNull Jig_m_obj}) then {
	if ((!isNil "trig_alarm1init") && {!isNull trig_alarm1init}) then {
		if (Jig_m_obj inArea trig_alarm1init) then {_compFound = true};
	};
	if ((!isNil "trig_alarm3init") && {!isNull trig_alarm3init}) then {
		if (Jig_m_obj inArea trig_alarm3init) then {_compFound = true};
	};

	if (_compFound) then {
		_disableSim = call _vehRepairComp;
		[_disableSim] call _BTClogDS;
	};
};

if (INS_ACE_drag) then {
	_INS_log_blacklist = [INS_Wep_box,INS_flag,INS_Op4_flag,INS_nade_Nbox,INS_ammo_Nbox,INS_weps_Nbox,INS_launchers_Nbox,INS_sup_Nbox,INS_weps_Cbox,INS_ammo_Cbox,INS_nade_Cbox,INS_launchers_Cbox,INS_demo_Cbox,INS_sup_Cbox];//Logistics named objects blacklist
	_disableSim append _INS_log_blacklist;
	{
		[_x, false, [0,0,0], 0] call ace_dragging_fnc_setDraggable;
		[_x, false, [0,0,0], 0] call ace_dragging_fnc_setCarryable;
	} forEach _INS_log_blacklist;
};
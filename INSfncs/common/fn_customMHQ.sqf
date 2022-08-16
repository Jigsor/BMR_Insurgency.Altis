//MHQ vehicle customizations
// find available customizations with [vehicle player] call BIS_fnc_getVehicleCustomization;
params [["_veh", objNull]];
if (isNull _veh) exitWith {};
private _type = typeOf _veh;
private _customization = [];

if (INS_Blu_side isEqualTo WEST) then {
	if (_type isEqualTo "I_APC_Wheeled_03_cannon_F") then {
		_veh animateSource ["HideTurret",1];
		_veh lockTurret [[0],true];
		_veh lockTurret [[0,0],true];
		_customization = [["Guerilla_02",1], ["showCamonetHull",0,"showBags",1,"showBags2",1,"showTools",1,"showSLATHull",0]];
	};
	if (_type in ["B_APC_Wheeled_01_cannon_F","B_T_APC_Wheeled_01_cannon_F"]) then {
		_veh animateSource ["HideTurret",1];
		_veh lockTurret [[0],true];
		_veh lockTurret [[0,0],true];
	};
	if (typeOf _veh isEqualTo "I_MRAP_03_F") then {
		_customization = [["Blufor",1],[]];
	};
	if (typeOf _veh isEqualTo "CUP_B_M1126_ICV_M2_Desert") then {
		_customization = [["Desert",1],["HideSlat_Woodland",0,"HideSlat_Desert",1]];
	};
};

if (INS_Blu_side isEqualTo RESISTANCE) then {
	if (_type isEqualTo "I_APC_Wheeled_03_cannon_F") then {
		_veh animateSource ["HideTurret",1];
		_veh lockTurret [[0],true];
		_veh lockTurret [[0,0],true];
		_customization = [[], ["showCamonetHull",0,"showBags",1,"showBags2",1,"showTools",1,"showSLATHull",0]];
	};
};

if (_customization isNotEqualTo []) then {
	[_veh, _customization # 0, _customization # 1] call BIS_fnc_initVehicle;
};
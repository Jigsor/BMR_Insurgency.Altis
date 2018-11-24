// Applies editor detected sensor settings on respawned aircraft. By Jigsor.
//private _sensors = listVehicleSensors _oldVeh; 0 = [_newVeh,_oldVeh,_sensors] call BMRINS_fnc_reinstateSensors;

params [["_newVeh",objNull],["_oldVeh",objNull],["_sensors",[]]];
//diag_log text format ["Detected Sensors: %1", _sensors];
if (!isServer) exitWith {};
if (_newVeh isEqualType "" && time > 5) exitWith {};
if (_newVeh isEqualType "") exitWith {
	//diag_log text "Preinit Sensor Detection Failed, Trying Postinit";
	0 = [_newVeh, _oldVeh, _sensors] spawn BMRINS_fnc_reenstateSenors;
};
{
	private _thisSensor = _x select 0;
	//diag_log text format ["Current Sensor: %1", _thisSensor];
	if (_oldVeh isVehicleSensorEnabled _thisSensor select 0 select 1) then {
		_newVeh enableVehicleSensor [_thisSensor, true];
	} else {
		_newVeh enableVehicleSensor [_thisSensor, false];
	};
} forEach _sensors;
{
	private _thisSensor = _x select 1;
	//diag_log text format ["Current Sensor: %1", _thisSensor];
	if (_oldVeh isVehicleSensorEnabled _thisSensor select 0 select 1) then {
		_newVeh enableVehicleSensor [_thisSensor, true];
	} else {
		_newVeh enableVehicleSensor [_thisSensor, false];
	};
} forEach _sensors;

if (vehicleReportOwnPosition _oldVeh) then {_newVeh setVehicleReportOwnPosition true};
if (vehicleReportRemoteTargets _oldVeh) then {_newVeh setVehicleReportRemoteTargets true};
if (vehicleReceiveRemoteTargets _oldVeh) then {_newVeh setVehicleReceiveRemoteTargets true};
 /******************************************************************************
 *                        ,1             ,-===========.
 *                       /,| ___________((____________\\_                _
 *    ,========.________//_|/===========._#############L_Y_....-----====//
 *   (#######(==========\################\=======.______ --############((
 *    `=======`"        ` ===============|::::.___|[ ))[JW]#############\\
 *                                       |####|     ""\###|   :##########\\
 *                                      /####/         \##\     ```"""=,,,))
 *     C R E A T E D   B Y   B T K     /####/           \##\
 *                                    '===='             `=`
 *******************************************************************************
 *
 *  The main script engine. This file executes the load AND drop functions...
 *
 ******************************************************************************/

// Include the Objects Setup
#include "Settings_Objects.sqf";

// Variables
params ["_Transporter","_Unit","_Action","_ActArray"];
_Selected = _ActArray # 0;
_TransporterType = typeOf _Transporter;
_TransporterName = getText (configFile >> "CfgVehicles" >> (typeOf _Transporter) >> "displayName");

// Create variables for Transporter Setup detection
_SelectedTransporterTypeS = false;_SelectedTransporterTypeM = false;_SelectedTransporterTypeL = false;_SelectedTransporterTypeXL = false;

// Include the Transporter Setup
#include "Settings_Transporter.sqf";

private _BTK_Hint_Loading = {
	// BTK_Hint - Loading in...
	params ["_ObjectName","_TransporterName"];
	hint parseText format ["
	<t align='left' color='#e5b348' size='1.2'><t shadow='1'shadowColor='#000000'>Cargo Drop</t></t>
	<img color='#ffffff' image='BTK\Cargo Drop\Images\img_line_ca.paa' align='left' size='0.79' />
	<t align='left' color='#eaeaea' size='1.0'>Loading <t color='#fdd785'>%1</t> into <t color='#fdd785'>%2</t> ...</t>
	<img color='#ffffff' image='BTK\Cargo Drop\Images\img_line_ca.paa' align='left' size='0.79' />
	",_ObjectName,_TransporterName];
};
private _BTK_Hint_Loaded = {
	// BTK_Hint - Loaded
	params ["_ObjectName","_TransporterName"];
	hint parseText format ["
	<t align='left' color='#e5b348' size='1.2'><t shadow='1'shadowColor='#000000'>Cargo Drop</t></t>
	<img color='#ffffff' image='BTK\Cargo Drop\Images\img_line_ca.paa' align='left' size='0.79' />
	<t align='left' color='#eaeaea' size='1.0'><t color='#fdd785'>%1</t> loaded.</t>
	<img color='#ffffff' image='BTK\Cargo Drop\Images\img_line_ca.paa' align='left' size='0.79' />
	", _ObjectName,_TransporterName];
};
private _BTK_Hint_Unloading = {
	// BTK_Hint - Unloading...
	params ["_ObjectName","_TransporterName"];
	hint parseText format ["
	<t align='left' color='#e5b348' size='1.2'><t shadow='1'shadowColor='#000000'>Cargo Drop</t></t>
	<img color='#ffffff' image='BTK\Cargo Drop\Images\img_line_ca.paa' align='left' size='0.79' />
	<t align='left' color='#eaeaea' size='1.0'>Unloading <t color='#fdd785'>%1</t> from <t color='#fdd785'>%2</t> ...</t>
	<img color='#ffffff' image='BTK\Cargo Drop\Images\img_line_ca.paa' align='left' size='0.79' />
	",_ObjectName,_TransporterName];
};
private _BTK_Hint_Unloaded = {
	// BTK_Hint - Unloaded
	params ["_ObjectName","_TransporterName"];
	hint parseText format ["
	<t align='left' color='#e5b348' size='1.2'><t shadow='1'shadowColor='#000000'>Cargo Drop</t></t>
	<img color='#ffffff' image='BTK\Cargo Drop\Images\img_line_ca.paa' align='left' size='0.79' />
	<t align='left' color='#eaeaea' size='1.0'><t color='#fdd785'>%1</t> unloaded.</t>
	<img color='#ffffff' image='BTK\Cargo Drop\Images\img_line_ca.paa' align='left' size='0.79' />
	",_ObjectName,_TransporterName];
};
private _BTK_Hint_Dropping = {
	// BTK_Hint - Dropping...
	params ["_ObjectName","_TransporterName"];
	hint parseText format ["
	<t align='left' color='#e5b348' size='1.2'><t shadow='1'shadowColor='#000000'>Cargo Drop</t></t>
	<img color='#ffffff' image='BTK\Cargo Drop\Images\img_line_ca.paa' align='left' size='0.79' />
	<t align='left' color='#eaeaea' size='1.0'>Dropping <t color='#fdd785'>%1</t> ...</t>
	<img color='#ffffff' image='BTK\Cargo Drop\Images\img_line_ca.paa' align='left' size='0.79' />
	",_ObjectName,_TransporterName];
};
private _BTK_Hint_Dropped = {
	// BTK_Hint - Dropped
	params ["_ObjectName","_TransporterName"];
	hint parseText format ["
	<t align='left' color='#e5b348' size='1.2'><t shadow='1'shadowColor='#000000'>Cargo Drop</t></t>
	<img color='#ffffff' image='BTK\Cargo Drop\Images\img_line_ca.paa' align='left' size='0.79' />
	<t align='left' color='#eaeaea' size='1.0'><t color='#fdd785'>%1</t> dropped.</t>
	<img color='#ffffff' image='BTK\Cargo Drop\Images\img_line_ca.paa' align='left' size='0.79' />
	",_ObjectName,_TransporterName];
};
private _BTK_Hint_outOf_Range = {
	// BTK_Hint - Nothing to load in range
	hint parseText format ["
		<t align='left' color='#e5b348' size='1.2'><t shadow='1'shadowColor='#000000'>Cargo Drop</t></t>
		<img color='#ffffff' image='BTK\Cargo Drop\Images\img_line_ca.paa' align='left' size='0.79' />
		<t align='left' color='#eaeaea' size='1.0'>Nothing to load in range!<br /><br />Please move the object closer to the transporter.</t>
		<img color='#ffffff' image='BTK\Cargo Drop\Images\img_line_ca.paa' align='left' size='0.79' />
	"];
};

// Supported types
if (!(_SelectedTransporterTypeS) && !(_SelectedTransporterTypeM) && !(_SelectedTransporterTypeL) && !(_SelectedTransporterTypeXL)) exitWith {
	// BTK_Hint - Not supported
	hint parseText format ["
		<t align='left' color='#e5b348' size='1.2'><t shadow='1'shadowColor='#000000'>Cargo Drop</t></t>
		<img color='#ffffff' image='BTK\Cargo Drop\Images\img_line_ca.paa' align='left' size='0.79' />
		<t align='left' color='#eaeaea' size='1.0'>This vehicle does not support cargo transports!</t>
		<img color='#ffffff' image='BTK\Cargo Drop\Images\img_line_ca.paa' align='left' size='0.79' />
	"];

_Transporter removeAction _Action;
};

sleep 1;

// Unit in transporter
if ((_Unit in _Transporter) && !(_Selected == "UnloadCargo")) exitWith {
	// BTK_Hint - You have to get out
	hint parseText format ["
		<t align='left' color='#e5b348' size='1.2'><t shadow='1'shadowColor='#000000'>Cargo Drop</t></t>
		<img color='#ffffff' image='BTK\Cargo Drop\Images\img_line_ca.paa' align='left' size='0.79' />
		<t align='left' color='#eaeaea' size='1.0'>You have to <t color='#fdd785'>get out</t> to load cargo!</t>
		<img color='#ffffff' image='BTK\Cargo Drop\Images\img_line_ca.paa' align='left' size='0.79' />
	"];

_Transporter removeAction _Action;
};

// Unload function
if (_Selected == "UnloadCargo") exitWith {
	// 2low
	if (!((getpos _Transporter) select 2 <= 2.1) && ((getpos _Transporter) select 2 <= 50)) exitWith {
		// BTK_Hint - Flying too low
		hint parseText format ["
			<t align='left' color='#e5b348' size='1.2'><t shadow='1'shadowColor='#000000'>Cargo Drop</t></t>
			<img color='#ffffff' image='BTK\Cargo Drop\Images\img_line_ca.paa' align='left' size='0.79' />
			<t align='left' color='#eaeaea' size='1.0'>You have to fly above <t color='#fdd785'>50m</t> to drop the cargo!</t>
			<br />
			<t align='left' color='#eaeaea' size='1.0'>Or hover below <t color='#fdd785'>2m</t> to unload the cargo!</t>
			<img color='#ffffff' image='BTK\Cargo Drop\Images\img_line_ca.paa' align='left' size='0.79' />
		"];
	};

	//Jig adding moving to fast because of detach bug at high speed.
	if (vectorMagnitudeSqr velocity _Transporter >= 16) exitWith {
		// Hint - Moving to fast
		hint parseText format ["
			<t align='left' color='#e5b348' size='1.2'><t shadow='1'shadowColor='#000000'>Cargo Drop</t></t>
			<img color='#ffffff' image='BTK\Cargo Drop\Images\img_line_ca.paa' align='left' size='0.79' />
			<t align='left' color='#eaeaea' size='1.0'>Reduce all vector velocities <t color='#fdd785'>to less than 16km/h</t> to drop the cargo!</t>
			<img color='#ffffff' image='BTK\Cargo Drop\Images\img_line_ca.paa' align='left' size='0.79' />
		"];
	};

	_Transporter removeAction _Action;

	if ((getpos _Transporter) select 2 <= 1.5) then {
		UnloadCargo = true;
		DoUnload = true;
		_Transporter setVariable ["BTK_CargoDrop_ActionAdded", false];
		_Transporter setVariable ["BTK_CargoDrop_TransporterLoaded", false, true];
	}else{
		UnloadCargo = true;
		DoUnload = false;// Jig adding
		DoDrop = true;
		_Transporter setVariable ["BTK_CargoDrop_ActionAdded", false];
		_Transporter setVariable ["BTK_CargoDrop_TransporterLoaded", false, true];
	};
};

/**** Load in - Small ****/
if ((_Selected == "LoadCargo") && (_SelectedTransporterTypeS)) exitWith {
	// Get nearest objects
	_TransporterPos = _Transporter modelToWorld [0,0,0];
	_ObjectsInRange = nearestObjects [_Transporter, _ObjectsS, 15];

	// If no objects, exit with
	if (_ObjectsInRange isEqualTo []) exitWith {
		// BTK_Hint - Nothing to load in range
		call _BTK_Hint_outOf_Range;
	};

	// Else, select the object from list
	_Object = _ObjectsInRange # 0;
	_Object setVariable ["BTK_CargoDrop_ObjectLoaded", true];
	_Transporter setVariable ["BTK_CargoDrop_TransporterLoaded", true];

	// Get the object name
	_ObjectName = getText (configFile >> "CfgVehicles" >> (typeOf _Object) >> "displayName");

	// BTK_Hint - Loading in...
	[_ObjectName,_TransporterName] call _BTK_Hint_Loading;

	// remove the Action
	_Transporter removeAction _Action;

	// Animate ramp
	sleep 1;
	_Transporter animateDoor ["CargoRamp_Open", 1];

	// Attach object to transporter
	sleep 3;

	// Fix for F35
	if (_Transporter isKindOf "F35_base") then {
	_Object attachTo [_Transporter,[0,0.5,-2.5]];
	}else{
	_Object attachTo [_Transporter,[0,0.5,-1.6]];
	};

	_Object enableSimulation false;

	// Disable R3F
	_Object setVariable ["R3F_LOG_disabled", true];

	// Animate ramp again
	sleep 1;
	_Transporter animateDoor ["CargoRamp_Open", 0];

	// BTK_Hint - Loaded
	[_ObjectName,_TransporterName] call _BTK_Hint_Loaded;

	// add unload/drop Action
	_UnloadAction = _Transporter addAction [("<t size='1.5' shadow='2' color='#12F905'>" + (localize "STR_BMR_unload_cargo") + "</t>"),"BTK\Cargo Drop\Engine.sqf",["UnloadCargo"], 9];

	// Wait until unload
	waitUntil {UnloadCargo || !(alive _Transporter) || !(alive _Object)};

	// If destroyed
	if (!(alive _Transporter) || !(alive _Object)) exitWith {};

	// If unload
	if (DoUnload) then {
		// Reset variables
		DoUnload = false;
		DoDrop = false;
		UnloadCargo = false;
		_Object setVariable ["BTK_CargoDrop_ObjectLoaded", false];
		_Object enableSimulation true;

		// BTK_Hint - Unloading...
		[_ObjectName,_TransporterName] call _BTK_Hint_Unloading;

		// Animate ramp
		sleep 1;
		_Transporter animateDoor ["CargoRamp_Open", 1];

		// Detach object
		sleep 3;
		_Object attachTo [_Transporter,[12,0,0]];
		sleep 0.2;
		deTach _Object;
		sleep 0.2;
		_Object setPos [(getPos _Object select 0),(getPos _Object select 1),0];

		// Enable R3F
		_Object setVariable ["R3F_LOG_disabled", false];

		// Animate ramp again
		sleep 1;
		_Transporter animateDoor ["CargoRamp_Open", 0];

		// BTK_Hint - Unloaded
		[_ObjectName,_TransporterName] call _BTK_Hint_Unloaded;
	};

	// If drop
	if (DoDrop) then {
		// BTK_Hint - Dropping...
		[_ObjectName,_TransporterName] call _BTK_Hint_Dropping;

		// Reset variables
		DoUnload = false;
		DoDrop = false;
		UnloadCargo = false;
		_Object setVariable ["BTK_CargoDrop_ObjectLoaded", false];
		_Object enableSimulation true;

		// Animate ramp
		sleep 1;
		_Transporter animateDoor ["CargoRamp_Open", 1];

		// Detach object (drop)
		sleep 2;
		_Object setVariable ["R3F_LOG_disabled", false];
		deTach _Object;
		_Object attachTo [_Transporter,[0,-21,0]];
		sleep 0.1;
		deTach _Object;
		_Object setPos [(getPos _Object select 0),(getPos _Object select 1),(getPos _Object select 2)-6];

		// Create parachute and smoke
		sleep 2;
		_Parachute = "NonSteerable_Parachute_F" createVehicle position _Object;
		_Parachute setPos (getPos _Object);
		_BlueSmoke = "SmokeShellBlue" createVehicle position _Object;
		_BlueSmoke setPos (getPos _Object);
		_Object attachTo [_Parachute,[0,0,-1.5]];

		// Animate ramp again
		sleep 1;
		_Transporter animateDoor ["CargoRamp_Open", 0];

		// BTK_Hint - Dropped
		[_ObjectName,_TransporterName] call _BTK_Hint_Dropped;

		// Wait until ground reached
		waitUntil {(getPos _Object select 2) < 2};
		deTach _Object;
		sleep 3;
		_Object setPos [(getPos _Object select 0),(getPos _Object select 1),0.001];

		// Enable R3F
		_Object setVariable ["R3F_LOG_disabled", false];

		// Delete parachute and smoke
		sleep 15;
		deleteVehicle _BlueSmoke;
		deleteVehicle _Parachute;
	};
};

/**** Load in - Medium ****/
if ((_Selected == "LoadCargo") && (_SelectedTransporterTypeM)) exitWith {
	// Get nearest objects
	_TransporterPos = _Transporter modelToWorld [0,0,0];
	_ObjectsInRange = nearestObjects [_Transporter, _ObjectsM, 15];

	// If no objects, exit with
	if (_ObjectsInRange isEqualTo []) exitWith {
		// BTK_Hint - Nothing to load in range
		call _BTK_Hint_outOf_Range;
	};

	// Else, select the object from list
	_Object = _ObjectsInRange # 0;
	_Object setVariable ["BTK_CargoDrop_ObjectLoaded", true];
	_Transporter setVariable ["BTK_CargoDrop_TransporterLoaded", true];

	// Get the object name
	_ObjectName = getText (configFile >> "CfgVehicles" >> (typeOf _Object) >> "displayName");

	// BTK_Hint - Loading in...
	[_ObjectName,_TransporterName] call _BTK_Hint_Loading;

	// remove the Action
	_Transporter removeAction _Action;

	// Animate ramp
	sleep 1;
	_Transporter animateDoor ["CargoRamp_Open", 1];

	// Attach object to transporter
	sleep 3;
	_Object attachTo [_Transporter,[0,1,-0.3]];

	// Disable R3F
	_Object setVariable ["R3F_LOG_disabled", true];

	// Animate ramp again
	sleep 1;
	_Transporter animateDoor ["CargoRamp_Open", 0];

	// BTK_Hint - Loaded
	[_ObjectName,_TransporterName] call _BTK_Hint_Loaded;

	// add unload/drop Action
	_UnloadAction = _Transporter addAction [("<t size='1.5' shadow='2' color='#12F905'>" + (localize "STR_BMR_unload_cargo") + "</t>"),"BTK\Cargo Drop\Engine.sqf",["UnloadCargo"], 9];

	// Wait until unload
	waitUntil {UnloadCargo || !(alive _Transporter) || !(alive _Object)};

	// If destroyed
	if (!(alive _Transporter) || !(alive _Object)) exitWith {};

	// If unload
	if (DoUnload) then {
		// Reset variables
		DoUnload = false;
		DoDrop = false;
		UnloadCargo = false;
		_Object setVariable ["BTK_CargoDrop_ObjectLoaded", false];

		// BTK_Hint - Unloading...
		[_ObjectName,_TransporterName] call _BTK_Hint_Unloading;

		// Animate ramp
		sleep 1;
		_Transporter animateDoor ["CargoRamp_Open", 1];

		// Detach object
		sleep 3;
		_Object attachTo [_Transporter,[15,0,0]];
		sleep 0.2;
		deTach _Object;
		sleep 0.2;
		_Object setPos [(getPos _Object select 0),(getPos _Object select 1),0];

		// Enable R3F
		_Object setVariable ["R3F_LOG_disabled", false];

		// Animate ramp again
		sleep 1;
		_Transporter animateDoor ["CargoRamp_Open", 0];

		// BTK_Hint - Unloaded
		[_ObjectName,_TransporterName] call _BTK_Hint_Unloaded;
	};

	// If drop
	if (DoDrop) then {
		// BTK_Hint - Dropping...
		[_ObjectName,_TransporterName] call _BTK_Hint_Dropping;

		// Reset variables
		DoUnload = false;
		DoDrop = false;
		UnloadCargo = false;
		_Object setVariable ["BTK_CargoDrop_ObjectLoaded", false];

		// Animate ramp
		sleep 1;
		_Transporter animateDoor ["CargoRamp_Open", 1];

		// Detach object (drop)
		sleep 2;
		_Object setVariable ["R3F_LOG_disabled", false];
		deTach _Object;
		_Object attachTo [_Transporter,[0,-21,0]];
		sleep 0.1;
		deTach _Object;
		_Object setPos [(getPos _Object select 0),(getPos _Object select 1),(getPos _Object select 2)-6];

		// Create parachute and smoke
		sleep 2;
		_Parachute = "NonSteerable_Parachute_F" createVehicle position _Object;
		_Parachute setPos (getPos _Object);
		_BlueSmoke = "SmokeShellBlue" createVehicle position _Object;
		_BlueSmoke setPos (getPos _Object);
		_Object attachTo [_Parachute,[0,0,-1.5]];

		// Animate ramp again
		sleep 1;
		_Transporter animateDoor ["CargoRamp_Open", 0];

		// BTK_Hint - Dropped
		[_ObjectName,_TransporterName] call _BTK_Hint_Dropped;

		// Wait until ground reached
		waitUntil {(getPos _Object select 2) < 2};
		deTach _Object;
		sleep 3;
		_Object setPos [(getPos _Object select 0),(getPos _Object select 1),0.001];

		// Enable R3F
		_Object setVariable ["R3F_LOG_disabled", false];

		// Delete parachute and smoke
		sleep 15;
		deleteVehicle _BlueSmoke;
		deleteVehicle _Parachute;
	};
};

/****Load in - Large****/
if ((_Selected == "LoadCargo") && (_SelectedTransporterTypeL)) exitWith {
	// Get nearest objects
	_TransporterPos = _Transporter modelToWorld [0,0,0];
	_ObjectsInRange = nearestObjects [_Transporter, _ObjectsL, 15];

	// If no objects, exit with
	if (_ObjectsInRange isEqualTo []) exitWith {
		// BTK_Hint - Nothing to load in range
		call _BTK_Hint_outOf_Range;
	};

	// Else, select the object from list
	_Object = _ObjectsInRange # 0;
	_Object setVariable ["BTK_CargoDrop_ObjectLoaded", true];
	_Transporter setVariable ["BTK_CargoDrop_TransporterLoaded", true];

	// Get the object name
	_ObjectName = getText (configFile >> "CfgVehicles" >> (typeOf _Object) >> "displayName");

	// BTK_Hint - Loading in...
	[_ObjectName,_TransporterName] call _BTK_Hint_Loading;

	// remove the Action
	_Transporter removeAction _Action;

	// Animate ramp
	sleep 1;
	_Transporter animateDoor ["CargoRamp_Open", 1];

	// Attach object to transporter
	sleep 3;

	// Fix for B17
	if (_Transporter isKindOf "I44_Plane_A_B17_AAF") then {
		_Object attachTo [_Transporter,[0,4.5,10.5]];
	};

	// Disable R3F
	_Object setVariable ["R3F_LOG_disabled", true];

	// Animate ramp again
	sleep 1;
	_Transporter animateDoor ["CargoRamp_Open", 0];

	// BTK_Hint - Loaded
	[_ObjectName,_TransporterName] call _BTK_Hint_Loaded;

	// add unload/drop Action
	_UnloadAction = _Transporter addAction [("<t size='1.5' shadow='2' color='#12F905'>" + (localize "STR_BMR_unload_cargo") + "</t>"),"BTK\Cargo Drop\Engine.sqf",["UnloadCargo"], 9];

	// Wait until unload
	waitUntil {UnloadCargo || !(alive _Transporter) || !(alive _Object)};

	// If destroyed
	if (!(alive _Transporter) || !(alive _Object)) exitWith {};

	// If unload
	if (DoUnload) then {
		// Reset variables
		DoUnload = false;
		DoDrop = false;
		UnloadCargo = false;
		_Object setVariable ["BTK_CargoDrop_ObjectLoaded", false];

		// BTK_Hint - Unloading...
		[_ObjectName,_TransporterName] call _BTK_Hint_Unloading;

		// Animate ramp
		sleep 1;
		_Transporter animateDoor ["CargoRamp_Open", 1];

		// Detach object
		sleep 3;
		_Object attachTo [_Transporter,[0,-20,0]];
		sleep 0.2;
		deTach _Object;
		sleep 0.2;
		_Object setPos [(getPos _Object select 0),(getPos _Object select 1),0];

		// Enable R3F
		_Object setVariable ["R3F_LOG_disabled", false];

		// Animate ramp again
		sleep 1;
		_Transporter animateDoor ["CargoRamp_Open", 0];

		// BTK_Hint - Unloaded
		[_ObjectName,_TransporterName] call _BTK_Hint_Unloaded;
	};

	// If drop
	if (DoDrop) then {
		// BTK_Hint - Dropping...
		[_ObjectName,_TransporterName] call _BTK_Hint_Dropping;

		// Reset variables
		DoUnload = false;
		DoDrop = false;
		UnloadCargo = false;
		_Object setVariable ["BTK_CargoDrop_ObjectLoaded", false];

		// Animate ramp
		sleep 1;
		_Transporter animateDoor ["CargoRamp_Open", 1];

		// Detach object (drop)
		sleep 2;
		_Object setVariable ["R3F_LOG_disabled", false];
		deTach _Object;
		_Object attachTo [_Transporter,[0,-21,0]];
		sleep 0.1;
		deTach _Object;
		_Object setPos [(getPos _Object select 0),(getPos _Object select 1),(getPos _Object select 2)-6];

		// Create parachute and smoke
		sleep 2;
		_Parachute = "NonSteerable_Parachute_F" createVehicle position _Object;
		_Parachute setPos (getPos _Object);
		_BlueSmoke = "SmokeShellBlue" createVehicle position _Object;
		_BlueSmoke setPos (getPos _Object);
		_Object attachTo [_Parachute,[0,0,-1.5]];

		// Animate ramp again
		sleep 1;
		_Transporter animateDoor ["CargoRamp_Open", 0];

		// BTK_Hint - Dropped
		[_ObjectName,_TransporterName] call _BTK_Hint_Dropped;

		// Wait until ground reached
		waitUntil {(getPos _Object select 2) < 2};
		deTach _Object;
		sleep 3;
		_Object setPos [(getPos _Object select 0),(getPos _Object select 1),0.001];

		// Enable R3F
		_Object setVariable ["R3F_LOG_disabled", false];

		// Delete parachute and smoke
		sleep 15;
		deleteVehicle _BlueSmoke;
		deleteVehicle _Parachute;
	};
};

/**** Load in - Xtra Large ****/
if ((_Selected == "LoadCargo") && (_SelectedTransporterTypeXL)) exitWith {
	// Get nearest objects
	_TransporterPos = _Transporter modelToWorld [0,0,0];
	_ObjectsInRange = nearestObjects [_Transporter, _ObjectsXL, 20];

	// If no objects, exit with
	if (_ObjectsInRange isEqualTo []) exitWith {
		// BTK_Hint - Nothing to load in range
		call _BTK_Hint_outOf_Range;
	};

	// Else, select the object from list
	_Object = _ObjectsInRange # 0;
	_Object setVariable ["BTK_CargoDrop_ObjectLoaded", true, true];
	_Transporter setVariable ["BTK_CargoDrop_TransporterLoaded", true, true];

	// Get the object name
	_ObjectName = getText (configFile >> "CfgVehicles" >> (typeOf _Object) >> "displayName");

	// BTK_Hint - Loading in...
	[_ObjectName,_TransporterName] call _BTK_Hint_Loading;

	// remove the Action
	_Transporter removeAction _Action;

	// Animate ramp
	sleep 1;
	if ((_Transporter isKindOf "rhsusf_CH53E_USMC_D") || (_Transporter isKindOf "rhsusf_CH53E_USMC_W")) then {
		_Transporter animateDoor ["ramp_bottom", 1];
	}else{
		_Transporter animateDoor ["CargoRamp_Open", 1];
	};

	// Attach object to transporter
	sleep 3;

	// Fix for cars/apc/trucks
	if (_Object isKindOf "Car" || _Object isKindOf "Truck" || _Object isKindOf "Wheeled_APC") then {
		if (_Object isKindOf "Car") then {
			_Object attachTo [_Transporter,[0,1,-2.1]];
		};
		if (_Object isKindOf "Truck") then {
			_Object attachTo [_Transporter,[0,1.4,-2.6]];
		};
		if (_Object isKindOf "Wheeled_APC") then {
			_Object attachTo [_Transporter,[0,2.2,-1.8]];
		};
	}else{
		// Fix for Mohawk
		if (_Transporter isKindOf "I_Heli_Transport_02_F") then {
			_Object attachTo [_Transporter,[0,1,-1.5]];
		};
		// Fix for CH53E
		if ((_Transporter isKindOf "rhsusf_CH53E_USMC_D") || (_Transporter isKindOf "rhsusf_CH53E_USMC_W")) then {
			_Object attachTo [_Transporter,[0,-1.6,1.48]];
		};
		// CUP Merlin
		if (_Transporter isKindOf "CUP_B_Merlin_HC3A_Armed_GB") then {
			_Object attachTo [_Transporter,[0,-0.2,2.09]];
		};
		// Fix for Pelican
		if (_Transporter isKindOf "OPTRE_Pelican_unarmed") then {
			_Object attachTo [_Transporter,[0,-4,0.04]];//[0,-4,0.14]
		};
		// NH90 NFH
		if (_Transporter isKindOf "ffaa_nh90_nfh_transport") then {
			_Object attachTo [_Transporter,[0.075,0.1,-1.2]];
		};
	};

	// Disable R3F
	_Object setVariable ["R3F_LOG_disabled", true];

	// Animate ramp again
	sleep 1;
	_Transporter animateDoor ["CargoRamp_Open", 0];

	// BTK_Hint - Loaded
	[_ObjectName,_TransporterName] call _BTK_Hint_Loaded;

	// add unload/drop Action
	UnloadCargo = false;
	_UnloadAction = _Transporter addAction [("<t size='1.5' shadow='2' color='#12F905'>" + (localize "STR_BMR_unload_cargo") + "</t>"),"BTK\Cargo Drop\Engine.sqf",["UnloadCargo"], 9];

	// Wait until unload
	waitUntil {UnloadCargo || !(alive _Transporter) || !(alive _Object)};

	// If destroyed
	if (!(alive _Transporter) || !(alive _Object)) exitWith {};

	// If unload
	if (DoUnload) then {
		// Reset variables
		DoUnload = false;
		DoDrop = false;
		UnloadCargo = false;
		_Object setVariable ["BTK_CargoDrop_ObjectLoaded", false, true];

		// BTK_Hint - Unloading...
		[_ObjectName,_TransporterName] call _BTK_Hint_Unloading;

		// Animate ramp
		sleep 1;
		_Transporter animateDoor ["CargoRamp_Open", 1];

		// Detach object
		sleep 3;
		_Object attachTo [_Transporter,[0,-20,0]];
		sleep 0.3;
		deTach _Object;
		sleep 0.3;
		_Object setPos [(getPos _Object select 0),(getPos _Object select 1),0];

		// Enable R3F
		_Object setVariable ["R3F_LOG_disabled", false];

		// Animate ramp again
		sleep 1;
		_Transporter animateDoor ["CargoRamp_Open", 1];

		// BTK_Hint - Unloaded
		[_ObjectName,_TransporterName] call _BTK_Hint_Unloaded;
	};

	// If drop
	if (DoDrop) then {
		// BTK_Hint - Dropping...
		[_ObjectName,_TransporterName] call _BTK_Hint_Dropping;

		// Reset variables
		DoUnload = false;
		DoDrop = false;
		UnloadCargo = false;
		_Object setVariable ["BTK_CargoDrop_ObjectLoaded", false, true];

		// Animate ramp
		sleep 1;
		_Transporter animateDoor ["CargoRamp_Open", 1];

		// Detach object (drop)
		sleep 2;
		_Object setVariable ["R3F_LOG_disabled", false];
		deTach _Object;
		_Object attachTo [_Transporter,[0,-21,0]];
		sleep 0.3;
		deTach _Object;
		_Object setPos [(getPos _Object select 0),(getPos _Object select 1),(getPos _Object select 2)-6];

		// Create parachute and smoke
		sleep 2;
		_Parachute = "NonSteerable_Parachute_F" createVehicle position _Object;
		_Parachute setPos (getPos _Object);
		_BlueSmoke = "SmokeShellBlue" createVehicle position _Object;
		_BlueSmoke setPos (getPos _Object);
		_Object attachTo [_Parachute,[0,0,-1.5]];

		// Animate ramp again
		sleep 1;
		_Transporter animateDoor ["CargoRamp_Open", 0];

		// BTK_Hint - Dropped
		[_ObjectName,_TransporterName] call _BTK_Hint_Dropped;

		// Wait until ground reached
		waitUntil {(getPos _Object select 2) < 2};
		deTach _Object;
		sleep 3;
		_Object setPos [(getPos _Object select 0),(getPos _Object select 1),0.001];

		// Enable R3F
		_Object setVariable ["R3F_LOG_disabled", false];

		// Delete parachute and smoke
		sleep 15;
		deleteVehicle _BlueSmoke;
		deleteVehicle _Parachute;
	};
};
/*
 extraction_fncs.sqf v1.14 by Jigsor
 [] call compile preProcessFile "INSfncs\extraction_fncs.sqf";
 runs in JIG_EX\extraction_init.sqf
 Heli Extraction Position and Evacuation Functions
*/
 
// Global hint
JIG_EX_MPhint_fnc = { hint _this };
extraction_pos_fnc = {
	// Actual Evac Position based on requested map click evac position
	private ["_posnotfound","_c","_dis","_cooX","_cooY","_wheX","_wheY","_randPos","_newPos","_mkr","_veh","_lzName"];
	_posnotfound = [];
	_c = 0;
	_dis = JIG_EX_Clear_Pos_Dis;
	_cooX = (getMarkerPos "extractmkr" select 0);
	_cooY = (getMarkerPos "extractmkr" select 1);
	_wheX = random (_dis*2)-_dis;
	_wheY = random (_dis*2)-_dis;
	_randPos = [_cooX+_wheX,_cooY+_wheY,0];
	_newPos = _randPos isFlatEmpty [20,50,0.4,2,0,false,player];

	while {(count _newPos) < 1} do {
		_newPos = _randPos isFlatEmpty [JIG_EX_Chopper_size,256,0.5,2,0,false,player];
		_c = _c + 1;
		if (_c > 2) exitWith {_newPos = [];};
		sleep 0.2;
	};

	if (!(_newPos isEqualTo [])) then {
		if !(getMarkerColor "tempPUmkr" isEqualTo "") then {deleteMarker "tempPUmkr";};
		_mkr = createMarker ["tempPUmkr", _newPos];
		_mkr setMarkerShape "ELLIPSE";
		"tempPUmkr" setMarkerSize [1, 1];
		"tempPUmkr" setMarkerShape "ICON";
		"tempPUmkr" setMarkerType "mil_dot";
		"tempPUmkr" setMarkerColor "ColorOrange";
		"tempPUmkr" setMarkerText "Extraction Position";
		[[[_mkr],east],"Hide_Mkr_fnc",EAST] spawn BIS_fnc_MP;

		_veh = createVehicle ["Land_HelipadEmpty_F", getMarkerPos "tempPUmkr", [], 0, "NONE"];
		sleep 0.1;
		_lzName = "EvacLZpad";
		_veh setVehicleVarName _lzName;
		missionNamespace setVariable [_lzName,_veh,true];
		_veh Call Compile Format ["%1=_This; PublicVariable ""%1""",_lzName];
		sleep 1;
	};

	if (_newPos isEqualTo []) exitWith {_posnotfound;};
	"extractmkr" setMarkerAlpha 0;
	_newPos;
};
drop_off_pos_fnc = {
	// Actual Drop Off Position based on requested map click drop off position
	private ["_posnotfound","_c","_dis","_cooX","_cooY","_wheX","_wheY","_randPos","_newPos","_tempPUmkr2","_veh","_VarLZName"];
	_posnotfound = [];
	_c = 0;
	_dis = JIG_EX_Clear_Pos_Dis;
	_cooX = (getMarkerPos "dropmkr" select 0);
	_cooY = (getMarkerPos "dropmkr" select 1);
	_wheX = random (_dis*2)-_dis;
	_wheY = random (_dis*2)-_dis;
	_randPos = [_cooX+_wheX,_cooY+_wheY,0];
	_newPos = _randPos isFlatEmpty [20,50,0.4,2,0,false,player];

	while {(count _newPos) < 1} do {
		_newPos = _randPos isFlatEmpty [JIG_EX_Chopper_size,256,0.5,2,0,false,player];
		_c = _c + 1;
		if (_c > 2) exitWith {_newPos = [];};
		sleep 0.2;
	};

	if (!(_newPos isEqualTo [])) then {
		if !(getMarkerColor "tempDropMkr" isEqualTo "") then {deleteMarker "tempDropMkr";};
		_tempPUmkr2 = createMarker ["tempDropMkr", _newPos];
		_tempPUmkr2 setMarkerShape "ELLIPSE";
		"tempDropMkr" setMarkerSize [1, 1];
		"tempDropMkr" setMarkerShape "ICON";
		"tempDropMkr" setMarkerType "mil_dot";
		"tempDropMkr" setMarkerColor "ColorOrange";
		"tempDropMkr" setMarkerText "Drop Off Position";
		[[[_tempPUmkr2],east],"Hide_Mkr_fnc",EAST] spawn BIS_fnc_MP;

		_veh = createVehicle ["Land_HelipadEmpty_F", getMarkerPos "tempDropMkr", [], 0, "NONE"];
		sleep 0.1;
		_VarLZName = "DropLZpad";
		_veh setVehicleVarName _VarLZName;
		_veh Call Compile Format ["%1=_This ; PublicVariable ""%1""",_VarLZName];
		sleep 1;
	};

	if (_newPos isEqualTo []) exitWith {_posnotfound;};
	"dropmkr" setMarkerAlpha 0;
	_newPos;
};
Evac_Spawn_Loc = {
	// Spawn position of Evac heli
	private ["_mkr","_mkrPos","_eDir","_veh","_VarSHName"];
	if !(getMarkerColor "EvacSpawnMkr" isEqualTo "") then {deleteMarker "EvacSpawnMkr";};
	_mkr = createMarker ["EvacSpawnMkr", getposATL EvacLZpad];
	_mkr setMarkerShape "ELLIPSE";
	"EvacSpawnMkr" setMarkerSize [1, 1];
	"EvacSpawnMkr" setMarkerShape "ICON";
	"EvacSpawnMkr" setMarkerType "Empty";
	"EvacSpawnMkr" setMarkerColor "ColorRed";
	"EvacSpawnMkr" setMarkerText "Evac Spawn Pos";
	"EvacSpawnMkr" setMarkerPos [(getMarkerPos "tempPUmkr" select 0) + (JIG_EX_Spawn_Dis * sin floor(random 360)), (getMarkerPos "tempPUmkr" select 1) + (JIG_EX_Spawn_Dis * cos floor(random 360)), 0];
	_mkrPos = getMarkerPos "EvacSpawnMkr";
	_eDir = [_mkrPos, EvacLZpad] call BIS_fnc_dirTo;
	EvacSpawnPad = createVehicle ["Land_HelipadEmpty_F", getMarkerPos "EvacSpawnMkr", [], 0, "NONE"];
	EvacSpawnPad setDir _eDir;
};
Ex_LZ_smoke_fnc = {
	// Pops Smoke and Chemlight at Extraction LZ
	[localize "STR_BMR_heli_extraction_smoke", "JIG_EX_MPhint_fnc"] call BIS_fnc_mp;
	private ["_smokeColor","_chemLight","_smoke","_i","_flrObj"];
	_smokeColor = JIG_EX_Smoke_Color;
	_chemLight = createVehicle ["Chemlight_green", getPosATL EvacLZpad, [], 0, "NONE"];
	sleep 1;
	_flrObj = "F_20mm_Red" createvehicle ((EvacHeliW1) ModelToWorld [0,100,200]);
	_flrObj setVelocity [0,0,-10];
	sleep 0.1;
	_i = 0;
	while {_i < 7} do {
		_smoke = createVehicle [_smokeColor, [(position EvacLZpad select 0) + 2, (position EvacLZpad select 1) + 2, 55], [], 0, "NONE"];
		_i = _i + 1;
		sleep 20;
	};
	deleteVehicle _chemLight;
};
Drop_LZ_smoke_fnc = {
	// Pops Smoke and Chemlight at Drop Off LZ
	private ["_smokeColor","_chemLight","_smoke","_i"];
	_smokeColor = JIG_EX_Smoke_Color;
	_chemLight = createVehicle ["Chemlight_green", getPosATL DropLZpad, [], 0, "NONE"];
	sleep 1;
	_i = 0;
	while {_i < 3} do {
		_smoke = createVehicle [_smokeColor, [(position DropLZpad select 0) + 1, (position DropLZpad select 1) + 1, 55], [], 0, "NONE"];
		_i = _i + 1;
		sleep 12.5;
	};
};
Cancel_Evac_fnc = {
	(_this select 1) removeAction (_this select 2);

	if (JIG_EX_Caller in EvacHeliW1) then {
		if (getPosATL JIG_EX_Caller select 2 >9) then {
			hint "This is the end my friend";
		};
	};// if evac cancelled while aboard evac and above 9 meters from ground then caller and passengers could fall to death.
	if (((count crew EvacHeliW1) < 1) && (alive EvacHeliW1)) then {deleteVehicle EvacHeliW1};
	{
		if (alive _x) then {deleteVehicle _x; sleep 0.1}
	} forEach (crew EvacHeliW1);
	if (!alive EvacHeliW1) then {
		{
			if (alive _x) then {deleteVehicle _x; sleep 0.1}
		} forEach (units EvacHeliW1);
	}else{
		{
			if (alive _x) then {deleteVehicle _x; sleep 0.1}
		} forEach (units EvacHeliW1);
		deleteVehicle EvacHeliW1;
	};
	{deleteVehicle _x;} forEach [EvacSpawnPad, EvacLZpad];
};
JIP_Reset_Evac_fnc = {
	if (not (isNull EvacHeliW1)) then {
		if (((count crew EvacHeliW1) < 1) && (alive EvacHeliW1)) then {deleteVehicle EvacHeliW1};
		{
			if (alive _x) then {deleteVehicle _x; sleep 0.1}
		} forEach (crew EvacHeliW1);
		if (!alive EvacHeliW1) then {
			{
				if (alive _x) then {deleteVehicle _x; sleep 0.1}
			} forEach (units EvacHeliW1);
		}else{
			{
				if (alive _x) then {deleteVehicle _x; sleep 0.1}
			} forEach (units EvacHeliW1);
			deleteVehicle EvacHeliW1;
		};
		EvacHeliW1 = ObjNull;
		publicVariable "EvacHeliW1";
		sleep 1;
		resetEvac = false;
		publicVariable "resetEvac";
	}else{
		resetEvac = false;
		publicVariable "resetEvac";
		sleep 1;
		evac_toggle = true;
		publicVariable "evac_toggle";
	};
	resetEvac
};
animate_doors_fnc = {
	private "_veh";
	_veh = _this select 0;
	switch (true) do {
		case (_veh isKindOf "B_Heli_Transport_01_camo_F"): {if ((_veh doorPhase "door_R") == 0) then {{_veh animateDoor [_x, 1]} forEach ["door_L","door_R"];} else {{_veh animateDoor [_x, 0]} forEach ["door_L","door_R"];}};
		case (_veh isKindOf "B_CTRG_Heli_Transport_01_tropic_F"): {if ((_veh doorPhase "door_R") == 0) then {{_veh animateDoor [_x, 1]} forEach ["door_L","door_R"];} else {{_veh animateDoor [_x, 0]} forEach ["door_L","door_R"];}};
		case (_veh isKindOf "B_Heli_Transport_01_F"): {if ((_veh doorPhase "door_R") == 0) then {{_veh animateDoor [_x, 1]} forEach ["door_L","door_R"];} else {{_veh animateDoor [_x, 0]} forEach ["door_L","door_R"];}};
		case (_veh isKindOf "CH49_Mohawk_FG"): {if (_veh animationPhase "door_back_R" < 0.5) then {{_veh animateDoor [_x, 1]} forEach ["door_back_L","door_back_R"];} else {{_veh animateDoor [_x, 0]} forEach ["door_back_L","door_back_R"];}};//_veh animateDoor ["CargoRamp_Open",1]
		case (_veh isKindOf "I_Heli_Transport_02_F"): {if (_veh animationPhase "door_back_R" < 0.5) then {{_veh animateDoor [_x, 1]} forEach ["door_back_L","door_back_R"];} else {{_veh animateDoor [_x, 0]} forEach ["door_back_L","door_back_R"];}};//_veh animateDoor ["CargoRamp_Open",1]	 
		case (_veh isKindOf "O_Heli_Attack_02_black_F"): {if ((_veh doorPhase "door_R") == 0) then {{_veh animateDoor [_x, 1]} forEach ["door_L","door_R"];} else {{_veh animateDoor [_x, 0]} forEach ["door_L","door_R"];}};
		case (_veh isKindOf "O_Heli_Attack_02_F"): {if ((_veh doorPhase "door_R") == 0) then {{_veh animateDoor [_x, 1]} forEach ["door_L","door_R"];} else {{_veh animateDoor [_x, 0]} forEach ["door_L","door_R"];}};		
		case (_veh isKindOf "kyo_MH47E_base"): {if ((_veh doorPhase "Ani_Hatch1") == 0) then {{_veh animateDoor [_x, 1]} forEach ["Ani_Hatch1","Ani_Hatch2"];} else {{_veh animateDoor [_x, 0]} forEach ["Ani_Hatch1","Ani_Hatch2"];}};		
		default {};
	};
};
AmbExRadio_fnc = {
	// Ambient Radio Chatter in/near Vehicles (TPW code)
	private ["_c","_run","_veh","_sound"];
	_run = true;
	_c = 0;
	while {_run} do	{
		if (player != vehicle player) then {
			playmusic format ["RadioAmbient%1",floor (random 31)];
		}
		else
		{
			_veh = ((position player) nearEntities [["Air", "Landvehicle"], 10]) select 0;
			if !(isnil "_veh") then {
			_sound = format ["A3\Sounds_F\sfx\radio\ambient_radio%1.wss",floor (random 31)];
			playsound3d [_sound,_veh,true,getPosasl _veh,1,1.1,20];
			};
		};
		sleep 30;
		_c = _c + 1;
		if (_c > 3) exitWith {_run = false};
	};
	if (not(_run)) exitWith {};
};
remove_carcass_fncJE = {
	// Deletes dead bodies and destroyed vehicles. Code by BIS.
	private "_unit";
	_unit = _this select 0;
	if (not (_unit isKindOf "Man")) then {
		{_x setpos position _unit} forEach crew _unit;
		sleep 30.0;
		deletevehicle _unit;
	};
	if (_unit isKindOf "Man") then {
		if(not ((vehicle _unit) isKindOf "Man")) then {_unit setpos (position vehicle _unit)};
		[_unit] joinSilent grpNull;
		sleep 35.0;
		hideBody _unit;
		_unit removeAllEventHandlers "killed";
	};
};
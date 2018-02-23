// MoveOp4Base.sqf by Jigsor
// Relocate Op4 Base/"Respawn_East" marker position.
private ["_op4_player","_mL","_aP","_bs","_rwp","_pP","_cooX","_cooY","_dis","_wheX","_wheY","_Op4rP","_pnf","_c","_sP","_centerPos","_bp","_dir"];

_op4_player = _this select 0;
_pnf = false;
_rwp = nil;
_bp = getMarkerPos "Respawn_West";
_aP = playableUnits - entities INS_op4_players;// exclude east players
_mL = if (INS_p_rev > 5) then {false}else{true};

waitUntil {!isNull _op4_player};

if (count _aP > 0) then {
	{
		_bs = (vectorMagnitudeSqr velocity _x > 8);
		_pos = (getPos _x);
		if (_bs || _pos select 2 > 4) then {_aP = _aP - [_x];};
	} foreach _aP;// exclude players in moving vehicles, above ground, in aircraft or in high structures
}else{
	_pnf = true;
};

if (count _aP > 0) then {	
	_rwp = _aP select (floor (random (count _aP)));
	_aP = _aP - ["_rwp"];
	while {!isNil "_rwp" && {_rwp distance _bp < 600}} do {
		_rwp = _aP select (floor (random (count _aP)));
		_aP = _aP - ["_rwp"];
	};
};// exclude players to close to blufor base

if (!isNil "_rwp") then {
	// Move Op4 Base within 250 to 500 meters of blufor player
	_pP = getPos _rwp;
	_cooX = _pP select 0;
	_cooY = _pP select 1;
	_wheX = [250,500] call BIS_fnc_randomInt;
	_wheY = [250,500] call BIS_fnc_randomInt;
	if (floor random 2 isEqualTo 0) then {_wheX = _wheX - (_wheX * 2)};
	if (floor random 2 isEqualTo 0) then {_wheY = _wheY - (_wheY * 2)};
	_Op4rP = [_cooX+_wheX,_cooY+_wheY,0];
	_c = 0;
	_sP = _Op4rP isFlatEmpty [8,384,0.5,2,0,false,ObjNull];

	while {(count _sP) < 1} do {
		_sP = _Op4rP isFlatEmpty [5,384,0.9,2,0,false,ObjNull];
		_c = _c + 1;
		if (_c > 5) exitWith {_pnf = true;};
		sleep 0.2;
	};
	if (count _sP > 0) exitWith {if (_mL) then {BTC_r_base_spawn setPos _sP}; "Respawn_East" setMarkerPos _sP;};
}else{
	_pnf = true;
};

if (_pnf) then {
	if (INS_MHQ_enabled && {!isNil "Opfor_MHQ"}) then {
		// Move to Op4 MHQ
		if (_mL) then {BTC_r_base_spawn setPos getMarkerPos "Opfor_MHQ"};
		"Respawn_East" setMarkerPos getMarkerPos "Opfor_MHQ";
		_dir = random 359;
		player setPos [(getMarkerPos "Opfor_MHQ" select 0)-10*sin(_dir),(getMarkerPos "Opfor_MHQ" select 1)-10*cos(_dir)];
	}else{
		// Move Op4 Base to center
		_centerPos = getPosATL center;
		_cooX = _centerPos select 0;
		_cooY = _centerPos select 1;
		_dis = 400;
		_wheX = random (_dis*2)-_dis;
		_wheY = random (_dis*2)-_dis;
		_Op4rP = [_cooX+_wheX,_cooY+_wheY,0];
		_sP = _Op4rP isFlatEmpty [10,384,0.5,2,0,false,ObjNull];

		while {(count _sP) < 1} do {
			_wheX = random (_dis*2)-_dis;
			_wheY = random (_dis*2)-_dis;
			_Op4rP = [_cooX+_wheX,_cooY+_wheY,0];
			_sP = _Op4rP isFlatEmpty [5,384,0.9,2,0,false,ObjNull];
			sleep 0.2;
		};
		if (_mL) then {BTC_r_base_spawn setPos _sP};
		"Respawn_East" setMarkerPos _sP;
	};
};
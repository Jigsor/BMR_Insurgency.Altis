if (!isServer) exitWith {};

params ["_mkr","_a","_b","_c","_d","_settings",["_cache",false]];

_a params ["_aGrps","_aSize"];
_aSize params ["_aMin"];
_b params ["_bGrps","_bSize"];
_bSize params ["_bMin"];
_c params ["_cGrps","_cSize"];
_d params ["_dGrps","_eGrps","_fGrps","_fSize"];
_settings params ["_faction","_mA","_distance","_side",["_heightLimit",true],["_debug",false]];
//_debug = true;

private _mPos=markerpos _mkr;
private _mkrX=markerSize _mkr # 0;
private _mkrY=markerSize _mkr # 1;
private _mkrAgl=markerDir _mkr;

private "_enemyFaction";
private "_civZone";
if (_side isEqualTo EAST) then {_enemyFaction="east";_civZone=false;};
if (_side isEqualTo WEST) then {_enemyFaction="west";_civZone=false;};
if (_side isEqualTo INDEPENDENT) then {_enemyFaction="GUER";_civZone=false;};
if (_side isEqualTo CIVILIAN) then {_enemyFaction="civ";_civZone=true;};

private "_mAH";
private "_mAN";
if (_mA isEqualTo 0) then {_mAH=1; _mAN=0.5;};
if (_mA isEqualTo 1) then {_mAH=0; _mAN=0;};
if (_mA isEqualTo 2) then {_mAH=0.5; _mAN=0.5;};

private ["_newpos","_dGrp","_bGroup","_fGrp","_eGrp","_aGrp","_units","_bGrp","_actCond","_cGrp"];

// INITIATE ZONE
private _trig=format ["EOScivTrig%1",_mkr];

private _eosActivated=objNull;
if (!_cache) then {
	if ismultiplayer then {
		if (_heightLimit) then {
			_actCond="{vehicle _x in thisList && isplayer _x && ((getPosATL _x) select 2) < 5} count playableunits > 0";
		}else{
			_actCond="{vehicle _x in thisList && isplayer _x} count playableunits > 0";
		};
	}else{
		if (_heightLimit) then {
			_actCond="{vehicle _x in thisList && isplayer _x && ((getPosATL _x) select 2) < 5} count allUnits > 0";
		}else{
			_actCond="{vehicle _x in thisList && isplayer _x} count allUnits > 0";
		};
	};

	_eosActivated = createTrigger ["EmptyDetector",_mPos];
	_eosActivated setTriggerArea [(_distance+_mkrX),(_distance+_mkrY),_mkrAgl,FALSE];
	_eosActivated setTriggerActivation ["WEST","PRESENT",true];
	_eosActivated setTriggerTimeout [1, 1, 1, true];
	_eosActivated setTriggerStatements [_actCond,"",""];

	server setvariable [_trig,_eosActivated];

}else{
	_eosActivated=server getvariable _trig;
};

_mkr setmarkerAlpha _mAN;
if (markerColor _mkr isNotEqualTo CivVictoryColor) then { //IF MARKER IS GREEN DO NOT CHANGE COLOUR
	_mkr setmarkercolor CivhostileColor;
};

waituntil {sleep 0.1; triggeractivated _eosActivated};	//WAIT UNTIL PLAYERS IN ZONE
if (markerColor _mkr isNotEqualTo "ColorBlack") then {
	if (markerColor _mkr isNotEqualTo VictoryColor) then {_mkr setmarkerAlpha _mAH;};

	// SPAWN HOUSE PATROLS
	for "_c" from 1 to _aGrps step 1 do {
		if (isnil "_aGrp") then {_aGrp=[]};
		if (_cache) then {
			_cacheGrp=format ["CHP%1",_c];
			_units=_eosActivated getvariable _cacheGrp;
			_aSize=[_units,_units];
			_aMin=_aSize # 0;
			if (_debug)then{player sidechat format ["ID:%1,restore - %2",_cacheGrp,_units];};
		};
		if (_aMin > 0) then {
			_aGroup=[_mPos,_aSize,_faction,_side] call eos_fnc_spawngroup_civ;
			if ((surfaceiswater _mPos) && (getTerrainHeightASL _mPos < -0.5)) then {
				0=[_aGroup,_mkr] call EOS_fnc_taskpatrol_civ;
			}else{
				0=[_mPos,units _aGroup,_mkrX,0,[0,20],true,true] call shk_fnc_fillhouse_civ;
			};
			_aGrp set [count _aGrp,_aGroup];
			0=[_aGroup,"civINFskill"] call eos_fnc_civ_grouphandlers;
			if (_debug) then {PLAYER SIDECHAT (format ["Spawned House Patrol: %1",_counter]);0= [_mkr,_counter,"House Patrol",getpos (leader _aGroup)] call EOS_civ_debug};
		};
	};

	// SPAWN PATROLS
	for "_c" from 1 to _bGrps step 1 do {
		if (isnil "_bGrp") then {_bGrp=[]};
		if (_cache) then {
			_cacheGrp=format ["CPA%1",_c];
			_units=_eosActivated getvariable _cacheGrp;
			_bSize=[_units,_units];
			_bMin=_bSize # 0;
			if (_debug)then{player sidechat format ["ID:%1,restore - %2",_cacheGrp,_units]};
		};
		if (_bMin > 0) then {
			_pos = [_mkr,true] call SHK_civ_pos;
			_bGroup=[_pos,_bSize,_faction,_side] call eos_fnc_spawngroup_civ;
			0=[_bGroup,_mkr] call EOS_fnc_taskpatrol_civ;
			_bGrp set [count _bGrp,_bGroup];
			0=[_bGroup,"civINFskill"] call eos_fnc_civ_grouphandlers;
			if (_debug) then {PLAYER SIDECHAT (format ["Spawned Patrol: %1",_c]);0= [_mkr,_c,"patrol",getpos (leader _bGroup)] call EOS_civ_debug};
		};
	};

	//SPAWN LIGHT VEHICLES
	for "_c" from 1 to _cGrps step 1 do {
		if (isnil "_cGrp") then {_cGrp=[]};

		private _vehType=7;
		private _cargoType=9;
		_newpos=[_mkr,50] call eos_fnc_findsafepos_civ;
		if (surfaceiswater _newpos) then {
			if (getTerrainHeightASL _newpos < -0.5) then {
				_vehType=8;
				_cargoType=10;
			};
		};

		_cGroup=[_newpos,_side,_faction,_vehType]call EOS_fnc_spawcivnvehicle;
		if ((_cSize # 0) > 0) then {
			0=[(_cGroup # 0),_cSize,(_cGroup # 2),_faction,_cargoType] call eos_fnc_setcargo_civ;
		};

		0=[(_cGroup # 2),"civLIGskill"] call eos_fnc_civ_grouphandlers;
		0=[(_cGroup # 2),_mkr] call EOS_fnc_taskpatrol_civ;
		_cGrp set [count _cGrp,_cGroup];

		if (_debug) then {player sidechat format ["Light Vehicle:%1 - r%2",_c,_cGrps];0= [_mkr,_c,"Light Veh",(getpos leader (_cGroup # 2))] call EOS_civ_debug};
	};

	//SPAWN ARMOURED VEHICLES
	for "_c" from 1 to _dGrps step 1 do {
		if (isnil "_dGrp") then {_dGrp=[]};

		_newpos=[_mkr,50] call eos_fnc_findsafepos_civ;
		private _vehType=2;
		if (surfaceiswater _newpos) then {
			if (getTerrainHeightASL _newpos < -0.5) then {
				_vehType=8;
			};
		};

		_dGroup=[_newpos,_side,_faction,_vehType]call EOS_fnc_spawcivnvehicle;

		0=[(_dGroup # 2),"civARMskill"] call eos_fnc_civ_grouphandlers;
		0=[(_dGroup # 2),_mkr] call EOS_fnc_taskpatrol_civ;
		_dGrp set [count _dGrp,_dGroup];

		if (_debug) then {player sidechat format ["Armoured:%1 - r%2",_c,_dGrps];0= [_mkr,_c,"Armour",(getpos leader (_dGroup # 2))] call EOS_civ_debug};
	};

	//SPAWN STATIC PLACEMENTS
	for "_c" from 1 to _eGrps step 1 do {
		if (surfaceiswater _mPos) exitwith {};
		if (isnil "_eGrp") then {_eGrp=[]};

		_newpos=[_mkr,50] call eos_fnc_findsafepos_civ;
		_eGroup=[_newpos,_side,_faction,5]call EOS_fnc_spawcivnvehicle;

		0=[(_eGroup # 2),"civSTAskill"] call eos_fnc_civ_grouphandlers;
		_eGrp set [count _eGrp,_eGroup];

		if (_debug) then {player sidechat format ["Static:%1",_c];0= [_mkr,_c,"Static",(getpos leader (_eGroup # 2))] call EOS_civ_debug};
	};

	//SPAWN CHOPPER
	for "_c" from 1 to _fGrps step 1 do {
		if (isnil "_fGrp") then {_fGrp=[]};
		private _vehType=if ((_fSize # 0) > 0) then {4}else{3};
		_newpos=(markerpos _mkr) getPos [1500, random 360];
		_fGroup=[_newpos,_side,_faction,_vehType,"FLY"]call EOS_fnc_spawnvehicle;
		_fGrp set [count _fGrp,_fGroup];

		if ((_fSize select 0) > 0) then {
			private _cargoGrp=createGroup _side;
			0=[(_fGroup # 0),_fSize,_cargoGrp,_faction,9] call eos_fnc_setcargo_civ;
			0=[_cargoGrp,"civINFskill"] call eos_fnc_civ_grouphandlers;
			_fGroup set [count _fGroup,_cargoGrp];
			null = [_mkr,_fGroup,_c] execvm "eos_civ\functions\CivTransportUnload_fnc.sqf";
		}else{
			_wp1 = (_fGroup # 2) addWaypoint [(markerpos _mkr), 0];
			_wp1 setWaypointSpeed "FULL";
			_wp1 setWaypointType "SAD";
		};

		0=[(_fGroup # 2),"civAIRskill"] call eos_fnc_civ_grouphandlers;

		if (_debug) then {player sidechat format ["Chopper:%1",_c];0= [_mkr,_c,"Chopper",(getpos leader (_fGroup # 2))] call EOS_civ_debug};
	};

	//SPAWN ALT TRIGGERS
	private _clear = createTrigger ["EmptyDetector",_mPos];
	_clear setTriggerArea [_mkrX,_mkrY,_mkrAgl,FALSE];
	_clear setTriggerActivation [_enemyFaction,"NOT PRESENT",true];
	_clear setTriggerStatements ["this","",""];
	private _taken = createTrigger ["EmptyDetector",_mPos];
	_taken setTriggerArea [_mkrX,_mkrY,_mkrAgl,FALSE];
	_taken setTriggerActivation ["ANY","PRESENT",true];
	_taken setTriggerStatements ["{vehicle _x in thisList && isplayer _x && ((getPosATL _x) select 2) < 5} count allUnits > 0","",""];
	private _eosAct=true;
	while {_eosAct} do {
		// IF PLAYER LEAVES THE AREA OR ZONE DEACTIVATED
		if (!triggeractivated _eosActivated || markerColor _mkr isEqualTo "ColorBlack") exitwith {
			if (_debug) then {if (markerColor _mkr isNotEqualTo "ColorBlack") then {hint "Restarting Zone AND deleting units";}else{hint "EOS zone deactivated";};};
			//CACHE LIGHT VEHICLES
			if (!isnil "_cGrp") then {
				{
					_x params ["_vehicle","_crew","_grp"];
					if (!alive _vehicle || {!alive _x} foreach _crew) then {_cGrps= _cGrps - 1};
					{deleteVehicle _x} forEach (_crew);
					if ({isplayer _x} count (crew _vehicle) < 1) then {{deleteVehicle _x} forEach[_vehicle]};
					{deleteVehicle _x} foreach units _grp;deleteGroup _grp;
				}foreach _cGrp;
				if (_debug) then {player sidechat format ["ID:c%1",_cGrps]};
			};

			// CACHE ARMOURED VEHICLES
			if (!isnil "_dGrp") then {
				{
					_x params ["_vehicle","_crew","_grp"];
					if (!alive _vehicle || {!alive _x} foreach _crew) then {_dGrps= _dGrps - 1};
					{deleteVehicle _x} forEach (_crew);
					if ({isplayer _x} count (crew _vehicle) < 1) then {{deleteVehicle _x} forEach[_vehicle]};
					{deleteVehicle _x} foreach units _grp;deleteGroup _grp;
				}foreach _dGrp;
				if (_debug) then {player sidechat format ["ID:c%1",_dGrps]};
			};

			// CACHE PATROL INFANTRY
			if (!isnil "_bGrp") then {
				private _n=0;
				{
					_n=_n+1;_units={alive _x} count units _x;_cacheGrp=format ["CPA%1",_n];
					if (_debug) then{player sidechat format ["ID:%1,cache - %2",_cacheGrp,_units]};
					_eosActivated setvariable [_cacheGrp,_units];
					{deleteVehicle _x} foreach units _x;deleteGroup _x;
				}foreach _bGrp;
			};

			// CACHE HOUSE INFANTRY
			if (!isnil "_aGrp") then {
				private _n=0;
				{
					_n=_n+1;_units={alive _x} count units _x;_cacheGrp=format ["CHP%1",_n];
					if (_debug) then{player sidechat format ["ID:%1,cache - %2",_cacheGrp,_units]};
					_eosActivated setvariable [_cacheGrp,_units];
					{deleteVehicle _x} foreach units _x;deleteGroup _x;
				}foreach _aGrp;
			};

			// CACHE MORTARS
			if (!isnil "_eGrp") then {
				{
					_x params ["_vehicle","_crew","_grp"];
					if (!alive _vehicle || {!alive _x} foreach _crew) then {_eGrps= _eGrps - 1};
					{deleteVehicle _x} forEach (_crew);
					if ({isplayer _x} count (crew _vehicle) < 1) then {{deleteVehicle _x} forEach[_vehicle]};
					{deleteVehicle _x} foreach units _grp;deleteGroup _grp;
				}foreach _eGrp;
			};

			// CACHE HELICOPTER TRANSPORT
			if (!isnil "_fGrp") then {
				{
					_x params ["_vehicle","_crew","_grp","_cargoGrp"];
					if (!alive _vehicle || {!alive _x} foreach _crew) then {_fGrps= _fGrps - 1};
					{deleteVehicle _x} forEach (_crew);
					if ({isplayer _x} count (crew _vehicle) < 1) then {{deleteVehicle _x} forEach[_vehicle]};
					{deleteVehicle _x} foreach units _grp;deleteGroup _grp;
					if (!isnil "_cargoGrp") then {
					{deleteVehicle _x} foreach units _cargoGrp;deleteGroup _cargoGrp;};
				}foreach _fGrp;
			};

			_eosAct=false;
			if (_debug) then {hint "Zone Cached"};
		};
		if (triggeractivated _clear && triggeractivated _taken && !_civZone)exitwith
		{// IF ZONE CAPTURED BEGIN CHECKING FOR ENEMIES
			_cGrps=0;_aGrps=0;_bGrps=0;_dGrps=0;_eGrps=0;_fGrps=0;
			while {triggeractivated _eosActivated && markerColor _mkr isNotEqualTo "ColorBlack"} do {
				if (!triggeractivated _clear) then {
					_mkr setmarkercolor CivhostileColor;
					_mkr setmarkerAlpha _mAH;
					if (_debug) then {hint "Zone Lost"};
				}else{
					_mkr setmarkercolor CivVictoryColor;
					_mkr setmarkerAlpha _mAN;
					if (_debug) then {hint "Zone Captured"};
				};
				sleep 1;
			};
			// PLAYER LEFT ZONE
			_eosAct=false;
		};
		sleep 0.5;
	};

	deletevehicle _clear;deletevehicle _taken;

	if (markerColor _mkr isNotEqualTo "ColorBlack") then {
		null = [_mkr,[_aGrps,_aSize],[_bGrps,_bSize],[_cGrps,_cSize],[_dGrps,_eGrps,_fGrps,_fSize],_settings,true] execVM "eos_civ\core\eos_civ_core.sqf";
	}else{
		_mkr setmarkeralpha 0;
	};
};
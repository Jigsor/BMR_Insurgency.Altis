if (RedHot > 0) then {RedHot = RedHot -1};

HCPresent = if (isNil "Any_HC_present") then {False} else {True};

if ((!isServer && hasInterface) || (HCPresent && isServer)) exitWith{};

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
private _trig=format ["EOSTrigger%1",_mkr];

//WAIT UNTIL activated zones less than or equal to limiter
private _mz=Max_Act_Gzones;
if (RedHot > _mz) then {
	waituntil {sleep 1; RedHot <= _mz};
};

private _eosActivated=objNull;
if (!_cache) then {

	if (_heightLimit) then {
		_actCond="((RedHot <= Max_Act_Gzones) && {{vehicle _x in thisList && isplayer _x && ((getPosATL _x) select 2) < 10} count playableunits > 0})";
	}else{
		_actCond="((RedHot <= Max_Act_Gzones) && {{vehicle _x in thisList && isplayer _x} count playableunits > 0})";
	};

	_eosActivated = createTrigger ["EmptyDetector",_mPos];
	_eosActivated setTriggerArea [(_distance+_mkrX),(_distance+_mkrY),_mkrAgl,FALSE];
	_eosActivated setTriggerActivation ["WEST","PRESENT",true];
	_eosActivated setTriggerTimeout [2, 2, 2, true];
	_eosActivated setTriggerStatements [_actCond,"",""];

	server setvariable [_trig,_eosActivated];

}else{
	_eosActivated=server getvariable _trig;
};

_mkr setmarkerAlpha _mAN;
if (markerColor _mkr isNotEqualTo VictoryColor) then { //IF MARKER IS GREEN DO NOT CHANGE COLOUR
	_mkr setmarkercolor hostileColor;
};

waituntil {sleep 0.1; triggeractivated _eosActivated && RedHot <= _mz}; //WAIT UNTIL PLAYERS IN ZONE and count of activated zones less than or equal to limiter
if (markerColor _mkr isNotEqualTo "ColorBlack") then {
	if (markerColor _mkr isNotEqualTo VictoryColor) then {_mkr setmarkerAlpha _mAH; RedHot = RedHot +1;};

	// SPAWN HOUSE PATROLS
	for "_c" from 1 to _aGrps step 1 do {
		if (isnil "_aGrp") then {_aGrp=[]};
		if (_cache) then {
			_cacheGrp=format ["HP%1",_c];
			_units=_eosActivated getvariable _cacheGrp;
			_aSize=[_units,_units];
			_aMin=_aSize # 0;
			if (_debug)then{player sidechat format ["ID:%1,restore - %2",_cacheGrp,_units];};
		};
		if (_aMin > 0) then {
			_aGroup=[_mPos,_aSize,_faction,_side] call eos_fnc_spawngroup;
			if ((surfaceiswater _mPos) && (getTerrainHeightASL _mPos < -0.5)) then {
				0=[_aGroup,_mkr] call EOS_fnc_taskpatrol;
			}else{
				0=[_mPos,units _aGroup,_mkrX,0,[0,20],true,true] call shk_fnc_fillhouse;
			};
			_aGrp set [count _aGrp,_aGroup];
			0=[_aGroup,"INFskill",_faction] call eos_fnc_grouphandlers;
			if (_debug) then {PLAYER SIDECHAT (format ["Spawned House Patrol: %1",_c]);0= [_mkr,_c,"House Patrol",getpos (leader _aGroup)] call EOS_debug};
		};
	};

	// SPAWN PATROLS
	for "_c" from 1 to _bGrps step 1 do {
		if (isnil "_bGrp") then {_bGrp=[]};
		if (_cache) then {
			_cacheGrp=format ["PA%1",_c];
			_units=_eosActivated getvariable _cacheGrp;
			_bSize=[_units,_units];
			_bMin=_bSize # 0;
			if (_debug)then{player sidechat format ["ID:%1,restore - %2",_cacheGrp,_units]};
		};
		if (_bMin > 0) then {
			_pos=[_mkr,true] call SHK_pos;
			_bGroup=[_pos,_bSize,_faction,_side] call eos_fnc_spawngroup;
			0=[_bGroup,_mkr] call EOS_fnc_taskpatrol;
			_bGrp set [count _bGrp,_bGroup];

			0=[_bGroup,"INFskill",_faction] call eos_fnc_grouphandlers;
			if (_debug) then {PLAYER SIDECHAT (format ["Spawned Patrol: %1",_c]);0= [_mkr,_c,"patrol",getpos (leader _bGroup)] call EOS_debug};
		};
	};

	//SPAWN LIGHT VEHICLES
	for "_c" from 1 to _cGrps step 1 do {
		if (isnil "_cGrp") then {_cGrp=[]};

		private _vehType=7;
		private _cargoType=9;
		_newpos=[_mkr,50] call eos_fnc_findsafepos;
		if (surfaceiswater _newpos) then {
			if (getTerrainHeightASL _newpos < -0.5) then {
				_vehType=8;
				_cargoType=10;
			};
		};

		_cGroup=[_newpos,_side,_faction,_vehType]call EOS_fnc_spawnvehicle;
		if ((_cSize # 0) > 0) then {
			0=[(_cGroup # 0),_cSize,(_cGroup # 2),_faction,_cargoType] call eos_fnc_setcargo;
		};

		0=[(_cGroup # 2),"LIGskill",_faction] call eos_fnc_grouphandlers;
		0=[(_cGroup # 2),_mkr] call EOS_fnc_taskpatrol;
		_cGrp set [count _cGrp,_cGroup];

		if (_debug) then {player sidechat format ["Light Vehicle:%1 - r%2",_c,_cGrps];0= [_mkr,_c,"Light Veh",(getpos leader (_cGroup # 2))] call EOS_debug};
	};

	//SPAWN ARMOURED VEHICLES
	for "_c" from 1 to _dGrps step 1 do {
		if (isnil "_dGrp") then {_dGrp=[]};

		_newpos=[_mkr,50] call eos_fnc_findsafepos;
		private _vehType=2;
		if (surfaceiswater _newpos) then {
			if (getTerrainHeightASL _newpos < -0.5) then {
				_vehType=8;
			};
		};

		_dGroup=[_newpos,_side,_faction,_vehType]call EOS_fnc_spawnvehicle;
		//diag_log format ["SpawnedVehicle: %1 Vehicle Crew: %2 Vehicle Group: %3", _dGroup # 0, _dGroup # 1, _dGroup # 2];//Jig

		0=[(_dGroup # 2),"ARMskill",_faction] call eos_fnc_grouphandlers;
		0=[(_dGroup # 2),_mkr] call EOS_fnc_taskpatrol;
		_dGrp set [count _dGrp,_dGroup];

		if (_debug) then {player sidechat format ["Armoured:%1 - r%2",_c,_dGrps];0= [_mkr,_c,"Armour",(getpos leader (_dGroup # 2))] call EOS_debug};
	};

	//SPAWN STATIC PLACEMENTS
	for "_c" from 1 to _eGrps step 1 do {
		if ((surfaceiswater _mPos) && (getTerrainHeightASL _mPos < -0.3)) exitwith {};
		if (isnil "_eGrp") then {_eGrp=[]};

		_newpos=[_mkr,50] call eos_fnc_findsafepos;
		_eGroup=[_newpos,_side,_faction,5]call EOS_fnc_spawnvehicle;

		0=[(_eGroup # 2),"STAskill",_faction] call eos_fnc_grouphandlers;
		_eGrp set [count _eGrp,_eGroup];

		if (_debug) then {player sidechat format ["Static:%1",_c];0= [_mkr,_c,"Static",(getpos leader (_eGroup # 2))] call EOS_debug};
	};

	//SPAWN CHOPPER
	for "_c" from 1 to _fGrps step 1 do {
		if (isnil "_fGrp") then {_fGrp=[]};
		_vehType=if ((_fSize # 0) > 0) then {4}else{3};
		_newpos=(markerpos _mkr) getPos [1500, random 360];
		_fGroup=[_newpos,_side,_faction,_vehType,"FLY"]call EOS_fnc_spawnvehicle;
		_fGrp set [count _fGrp,_fGroup];

		if ((_fSize select 0) > 0) then {
			private _cargoGrp=createGroup _side;
			0=[(_fGroup # 0),_fSize,_cargoGrp,_faction,9] call eos_fnc_setcargo;
			0=[_cargoGrp,"INFskill",_faction] call eos_fnc_grouphandlers;
			_fGroup set [count _fGroup,_cargoGrp];
			null = [_mkr,_fGroup,_c] execvm "eos\functions\TransportUnload_fnc.sqf";
		}else{
			_wp1 = (_fGroup # 2) addWaypoint [(markerpos _mkr), 0];
			_wp1 setWaypointSpeed "FULL";
			_wp1 setWaypointType "SAD";
		};

		0=[(_fGroup # 2),"AIRskill",_faction] call eos_fnc_grouphandlers;

		if (_debug) then {player sidechat format ["Chopper:%1",_c];0= [_mkr,_c,"Chopper",(getpos leader (_fGroup # 2))] call EOS_debug};
	};

	//SPAWN ALT TRIGGERS
	private _clear = createTrigger ["EmptyDetector",_mPos];
	_clear setTriggerArea [_mkrX,_mkrY,_mkrAgl,FALSE];
	_clear setTriggerActivation [_enemyFaction,"NOT PRESENT",true];
	_clear setTriggerStatements ["this","",""];
	private _taken = createTrigger ["EmptyDetector",_mPos];
	_taken setTriggerArea [_mkrX,_mkrY,_mkrAgl,FALSE];
	_taken setTriggerActivation ["ANY","PRESENT",true];
	_taken setTriggerTimeout [1, 1, 1, true];
	_taken setTriggerStatements ["{vehicle _x in thisList && isplayer _x && side _x isEqualTo WEST && ((getPosATL _x) select 2) < 5} count allUnits > 0","",""];
	private _eosAct=true;
	private _cacheDelay=DeAct_Gzone_delay; //Cache: Delay caching by X minutes parameter
	private _cc=0;
	while {_eosAct} do {
		// IF PLAYER LEAVES THE AREA OR ZONE DEACTIVATED
		if ( !triggeractivated _eosActivated) then {
			if ( _cc > 0) then {_cc = _cc - 1};
		} else {
			_cc=_cacheDelay * 60 / 2; //Cache: Calculate the delay for according minutes //rip
		}; //Cache: Decrease counter with each loop

		if (_cc <= 0 && (!triggeractivated _eosActivated || markerColor _mkr isEqualTo "ColorBlack")) exitwith { //Cache: Check if caching counter hit 0
			if (_debug) then {if !(markerColor _mkr isEqualTo "ColorBlack") then {hint "Restarting Zone AND deleting units";}else{hint "EOS zone deactivated";};};
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
					_n=_n+1;_units={alive _x} count units _x;_cacheGrp=format ["PA%1",_n];
					if (_debug) then{player sidechat format ["ID:%1,cache - %2",_cacheGrp,_units]};
					_eosActivated setvariable [_cacheGrp,_units];
					{deleteVehicle _x} foreach units _x;deleteGroup _x;
				}foreach _bGrp;
			};

			// CACHE HOUSE INFANTRY
			if (!isnil "_aGrp") then {
				private _n=0;
				{
					_n=_n+1;_units={alive _x} count units _x;_cacheGrp=format ["HP%1",_n];
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
			while {triggeractivated _eosActivated && (markerColor _mkr isNotEqualTo "ColorBlack")} do {
				if (!triggeractivated _clear) then {
					_mkr setmarkercolor hostileColor;
					_mkr setmarkerAlpha _mAH;
					if (_debug) then {hint "Zone Lost"};
				}else{
					_mkr setmarkercolor VictoryColor;
					_mkr setmarkerAlpha _mAN;
					if (_debug) then {hint "Zone Captured"};
				};
				sleep 1;
			};
			// PLAYER LEFT ZONE
			_eosAct=false;
		};
		uiSleep 2; //Cache: Reduce cpu usage from while loop //rip
	};

	deletevehicle _clear;deletevehicle _taken;

	if (markerColor _mkr isNotEqualTo "ColorBlack") then {
		null = [_mkr,[_aGrps,_aSize],[_bGrps,_bSize],[_cGrps,_cSize],[_dGrps,_eGrps,_fGrps,_fSize],_settings,true] execVM "eos\core\eos_core.sqf";
	}else{
		_mkr setmarkeralpha 0;
	};
};
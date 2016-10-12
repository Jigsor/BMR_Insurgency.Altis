/*
INS_SuicideBomber.sqf by Jigsor
movement section by Zooloo75/Stealthstick
recruit existing civilian by SupahG33K
*/

if (!isServer) exitWith {};

private ["_delay","_ins_debug","_basePos","_safeZone_rad","_maxtype","_loop"];

if (DebugEnabled > 0) then {_ins_debug = true;}else{waitUntil {time > 60}; _ins_debug = false;};
_delay = true;
_basePos = getMarkerPos "Respawn_West";
_safeZone_rad = 600;// radius _basePos marker safe zone/spawn suicide bomber beyond this distance
sstBomber = ObjNull;
random_w_player4 = ObjNull;
random_civ_bomber = ObjNull;
_maxtype = (count suicide_bmbr_weps)-1;

"sstBomber" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
"random_w_player4" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
"random_civ_bomber" addPublicVariableEventHandler {call compile format ["%1",_this select 1]}; //SupahG33K - draftee

for [{_loop=0}, {_loop<1}, {_loop=_loop}] do
{
	sleep 2;
	if (_delay) then {sleep 90;};
	waitUntil {sleep 2; isNull sstBomber || !(alive sstBomber)};
	if ((isNull sstBomber) || (not(alive sstBomber))) then
	{
		private "_random_sleep";
		if (_ins_debug) then
		{
			_random_sleep = [10,20] call BIS_fnc_randomInt;
			sleep _random_sleep;
		} else {
			_random_sleep = [420,1500] call BIS_fnc_randomInt;
			sleep _random_sleep;
		};

		private ["_jig_bmbr_xcoor","_jig_bmbr_coor_ref","_jig_bmbr_ycoor","_bmbr_pos","_VarHunterName","_unit","_targetSide","_explosiveClass","_runCode","_nearUnits","_explosive","_centerC","_class","_civgrp","_btarget"];	
		_centerC = createCenter civilian;
		_civgrp = createGroup Civilian;
		_bmbr_pos = [];
		_targetSide = WEST;
		_delay = false;
		_runCode = 1;
		_explosiveClass = suicide_bmbr_weps select (round random _maxtype);
		_VarHunterName = "sstBomber";
		random_w_player4 = nil;
		random_civ_bomber = nil; //SupahG33K - draftee

		publicVariableServer "random_w_player4";
		sleep 3;
		publicVariableServer "random_civ_bomber"; //SupahG33K - draftee
		sleep 3;
		call find_bombee_fnc;
		sleep 3;

		if (isNil "random_w_player4") exitWith {_delay = true; diag_log "No credible target for suicide bomber";};  //No/Bad target, GNDN

		if (_ins_debug) then {
			diag_log text format ["Bomber West Human Target1: %1", random_w_player4];
			titletext ["INS_SuicideBomber.sqf running","plain down"];
		};

		_jig_bmbr_coor_ref = getPos random_w_player4;

		if (isNil "_jig_bmbr_coor_ref") exitWith {_delay = true; diag_log "Bad Position information for suicide bomber target";};  //Bad position, GNDN
		if (_jig_bmbr_coor_ref distance _basePos < _safeZone_rad) exitWith {_delay = true; diag_log "Suicide Bomber target inside base area - aborting";};  //Target inside safe zone, GNDN

		_jig_bmbr_xcoor = (getPos random_w_player4 select 0);
		_jig_bmbr_ycoor = (getPos random_w_player4 select 1);
		if (_ins_debug) then {diag_log text format ["Random Player Bomber Target Pos : %1", _jig_bmbr_coor_ref];};

		//SupahG33K - look for existing local civilian
		call find_civ_bomber_fnc;
		sleep 3;

		//SupahG33K - Create a new bomber if we can't recruit one
		if(isNil "random_civ_bomber") then {
			diag_log "No Civilian Jihadi Draftee Available";
			_bmbr_pos = _bmbr_pos + [_jig_bmbr_xcoor,_jig_bmbr_ycoor] call bmbr_spawnpos_fnc;

			private _c = 0;

			while {_bmbr_pos isEqualTo []} do
			{
				_bmbr_pos = _bmbr_pos + [_jig_bmbr_xcoor,_jig_bmbr_ycoor] call bmbr_spawnpos_fnc;
				if (!(_bmbr_pos isEqualTo [])) exitWith {_bmbr_pos;};
				_c = _c + 1;
				if (_c > 3) exitWith {if (_ins_debug) then {hintsilent "suitable pos for sstBomber not found";}; _bmbr_pos = [];};
				sleep 10;
			};
			if (_bmbr_pos isEqualTo []) exitWith {_delay = true;};

			_class = INS_civlist select (floor (random (count INS_civlist)));
			_unit = _civgrp createUnit [_class, _bmbr_pos, [], 0, "NONE"];
			sleep jig_tvt_globalsleep;

			_unit addeventhandler ["killed",{_this call killed_ss_bmbr_fnc; [(_this select 0)] spawn remove_carcass_fnc}];

			_bmbrdir = [random_w_player4, _unit] call BIS_fnc_dirTo;
			if (_bmbrdir < 0) then {_bmbrdir = _bmbrdir + 360}; //SupahG33K - check for negative heading

			_unit setDir _bmbrdir;
			[_unit] joinSilent _civgrp;
			(group _unit) setVariable ["zbe_cacheDisabled",true];
			_unit SetUnitPos "UP";
			_unit setSkill ["endurance", 1];
			_unit setSkill ["spotTime", 0.8];
			_unit setSkill ["courage", 1];
			_unit setSkill ["spotDistance", 1];
			_unit allowFleeing 0;
			_unit enableStamina false;
			_unit disableAI "AUTOTARGET";
			_unit disableAI "FSM";
			_unit setVehicleVarName _VarHunterName; sstBomber = _unit;
			_unit Call Compile Format ["%1=_This ; PublicVariable ""%1""",_VarHunterName];
			uiSleep 3;
		} else {
			//diag_log "SupahG33K - Civilian Jihadi Draftee found and being equipped for martyrdom";
			if (_ins_debug) then {titletext ["Civilian Jihadi Draftee found and being equipped for martyrdom","plain down"];};
			_unit = random_civ_bomber;
			_unit addeventhandler ["killed",{_this call killed_ss_bmbr_fnc}];

			_bmbrdir = [random_w_player4, _unit] call BIS_fnc_dirTo;
			if (_bmbrdir < 0) then {_bmbrdir = _bmbrdir + 360}; //SupahG33K - check for negative heading

			_unit setDir _bmbrdir;
			[_unit] joinSilent _civgrp;
			_unit SetUnitPos "UP";
			_unit setSkill ["endurance", 1];
			_unit setSkill ["spotTime", 0.8];
			_unit setSkill ["courage", 1];
			_unit setSkill ["spotDistance", 1];
			_unit allowFleeing 0;
			_unit enableStamina false;
			_unit disableAI "AUTOTARGET";
			_unit disableAI "FSM";
			_unit setVehicleVarName _VarHunterName; sstBomber = _unit;
			_unit Call Compile Format ["%1=_This ; PublicVariable ""%1""",_VarHunterName];
			sleep 3;
			//diag_log "SupahG33K Civilian Jihadi Draftee briefed and sent on his way";
		};

		// movement section
		while {alive sstBomber && _runCode isEqualTo 1} do
		{
			_nearUnits = nearestObjects [_unit, ["CAManBase"], 300];
			_nearUnits deleteAt 0;

			{
				if (!(side _x == _targetSide)) then {_nearUnits = _nearUnits - [_x];};
			} count _nearUnits;

			if(count _nearUnits > 0) then
			{
				_btarget = _nearUnits select 0;

				[_unit,_btarget] spawn {
					params ["_unit","_btarget"];

					while {alive _unit and !isNull _btarget} do {
						_unit doMove (getPosATL _btarget);
						_unit setspeedMode "NORMAL";
						sleep 8;
					};
				};//Jig adding

				waitUntil {sleep 1; (_unit distance getPosATL (_nearUnits select 0) > 300) || (_unit distance getPosATL (_nearUnits select 0) < 17)};

				//Target out of range, remove bomber
				if (_unit distance getPosATL (_nearUnits select 0) > 300)
				exitWith
				{
					_runCode = 0;
					_unit setPos [0,0,0];
					_unit removeAllEventHandlers "killed";
					_unit setdamage 1;
					sleep 1;
					deleteVehicle _unit;
					sleep 1;
				};//Jig adding

				// Charge Target & Detonate Bomb
				if(_unit distance (_nearUnits select 0) < 17)
				exitWith
				{
					_unit setspeedMode "full";
					_runCode = 0;
					_explosive = _explosiveClass createVehicle (position _unit);
					sleep jig_tvt_globalsleep;

					//Shout and explode
					[_unit,_explosive] spawn {
						_unit = _this select 0;
						_explosive = _this select 1;
						//_unit setmimic "combat";
						nul = [_unit,"shout"] call mp_Say3D_fnc;
						//_unit setRandomLip true;
						uiSleep 2;
						_explosive setDamage 1;
						_unit addRating 2000;
					};

					//Remove explosive and event handlers
					[_explosive,_unit] spawn {
						_explosive = _this select 0;
						_unit = _this select 1;
						waitUntil {!alive _unit};
						deleteVehicle _explosive;
					};

					_unitpos = (getPosATL _unit);
					if(round(random(1)) isEqualTo 0) then
					{
					_explosive attachTo [_unit,[-0.02,-0.07,0.042],"rightHand"];
					_unit setPos _unitpos;
					}
					else
					{
					_explosive attachTo [_unit,[-0.02,-0.07,0.042],"leftHand"];
					_unit setPos _unitpos;
					};
				};
			}
			else
			{
			_unit setPos [0,0,0];
			_unit removeAllEventHandlers "killed";
			_unit setdamage 1;
			sleep 1;
			deleteVehicle _unit;
			sleep 1;
			};// Jig adding else

			if (!isNull _civgrp) then {deleteGroup _civgrp;};

			sleep 1;
		};
	};
};
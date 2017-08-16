//V1.2 Script by: Ghost - calls in a support UGV until dead
//ghst_ugvsupport = [(getmarkerpos "spawnmarker"),"typeofugv",max number of ugvs,delay in mins] execvm "scripts\ghst_ugvsupport.sqf";
//ghst_ugvsupport = [(getmarkerpos "ugv_support"),"B_UGV_01_rcws_F",2,30] execvm "scripts\ghst_ugvsupport.sqf";

private ["_spawnmark","_type","_max_num","_delay","_dir","_smoke1","_chute1","_ugv1","_wGrp","_ugv_num","_score","_points","_deficit","_exit","_groundPos","_grpExists"];

_spawnmark = _this select 0;// spawn point where ugv spawns and deletes
_type = _this select 1;// type of ugv to spawn i.e. "B_UGV_01_rcws_F"
_max_num = _this select 2;//max number of ugvs allowed per player
_delay = (_this select 3) * 60;// time before ugv support can be called again
_grpExists = false;
_score = getPlayerScores player select 5;
_points = 25;
_exit = false;

//Jig adding block below. If _max_num is reached then if _points earned since last call attemp then 1 ugv request allowed.
if (player getVariable "ghst_ugvsup" == _max_num) then {
	if (isNil {player getVariable "ugvOpScore"}) then {
		player setVariable ["ugvOpScore", _score];
		_exit = true;
	}else{
		if ((_score - _points) >= player getVariable "ugvOpScore") then {
			_ugv_num = player getVariable "ghst_ugvsup";
			_ugv_num = _ugv_num - 1;
			player setVariable ["ghst_ugvsup", _ugv_num];
			player setVariable ["ugvOpScore", _score];
		}else{
			_exit = true;
		};
	};
};

if (_exit) exitwith {
	_deficit = abs((player getVariable "ugvOpScore") - (_score - _points));
	player groupchat format ["UGV support at max number of %1. Requires %2 more points.", _max_num, _deficit];
};

openMap true;
player groupchat localize "STR_BMR_ugv_mapclick";
mapclick = false;

["UGVdrop_mapclick","onMapSingleClick", {
	clickpos = _pos;
	mapclick = true;
}] call BIS_fnc_addStackedEventHandler;

waituntil {mapclick or !(visiblemap)};
["UGVdrop_mapclick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;

if (!visibleMap) exitwith {hint localize "STR_BMR_UGV_supReady";};

_pos = clickpos;
sleep 1;
openMap false;

_dir = [_spawnmark, _pos] call BIS_fnc_dirTo;

_smoke1 = createVehicle ["SmokeShellBlue", _pos, [], 0, "NONE"];
sleep jig_tvt_globalsleep;

_chute1 = createVehicle ["B_Parachute_02_F",[0,0,0], [], 0, "FLY"];
_chute1 setpos [(_pos select 0), (_pos select 1), 150];

_ugv1 = createVehicle [_type, _spawnmark, [], 0, "NONE"];
sleep jig_tvt_globalsleep;

_ugv1 attachTo [_chute1,[0,0,1]];

_ugv_num = player getVariable "ghst_ugvsup";
_ugv_num = _ugv_num + 1;
player setVariable ["ghst_ugvsup", _ugv_num];

if (player getVariable "ghst_ugvsup" == _max_num) then {//Jig adding start point counter
	if (isNil {player getVariable "ugvOpScore"}) then {
		player setVariable ["ugvOpScore", _score];
	}else{
		if ((_score - _points) >= player getVariable "ugvOpScore") then {
			_ugv_num = player getVariable "ghst_ugvsup";
			_ugv_num = _ugv_num - 1;
			player setVariable ["ghst_ugvsup", _ugv_num];
			player setVariable ["ugvOpScore", _score];
		};
	};
};

waituntil {(getposatl _ugv1 select 2) < 1.5};
detach _ugv1;
_ugv1 setpos [getpos _ugv1 select 0,getpos _ugv1 select 1,0];
sleep 1;

if (alive _ugv1) then {// jig adding/change - ugv is recreated on landing because on some terrains bug prevents engine from starting after halo drop.
	_damage = damage _ugv1;
	_groundPos = [getpos _ugv1 select 0,getpos _ugv1 select 1,getposatl _ugv1 select 2];
	_dir = direction _ugv1;

	if  (count(lineIntersectsObjs [(getposASL _ugv1), [(getposASL _ugv1 select 0),(getposASL _ugv1 select 1), ((getposASL _ugv1 select 2) + 20)]]) > 1) then {
		_groundPos = [_groundPos, 0, 50, 10, 0, 0.6, 0] call BIS_fnc_findSafePos;
	};

	deleteVehicle _ugv1;
	_ugv1 = createVehicle [_type, _groundPos, [], 0, "NONE"]; sleep jig_tvt_globalsleep;

	_ugv1 setDir _dir;
	_ugv1 setDamage _damage;

	if (alive _ugv1) then {
		createVehicleCrew _ugv1;
		_wGrp = (group (crew _ugv1 select 0)); sleep jig_tvt_globalsleep;

		//connect player to ugv
		player connectTerminalToUav _ugv1;

		_wGrp setBehaviour "COMBAT";
		_wGrp setSpeedMode "Normal";
		_wGrp setCombatMode "RED";

		_ugv1 sidechat localize "STR_BMR_ugv_movingTo_smoke";

		_ugv1 doMove _pos;
		_grpExists = true;
	};
};

While {true} do {
	if (!(alive _ugv1) or !(canMove _ugv1)) exitwith {player groupchat localize "STR_BMR_ugv_lost";};
	if (fuel _ugv1 < 0.2) then {_ugv1 sidechat "Fuel getting low. Need to refuel soon";};
	sleep 10;
};
sleep 30;

{deletevehicle _x} foreach crew _ugv1;
deletevehicle _ugv1;

sleep 20;
if (_grpExists) then {deletegroup _wGrp;};
sleep _delay;

_ugv_num = player getVariable "ghst_ugvsup";
_ugv_num = _ugv_num - 1;
player setVariable ["ghst_ugvsup", _ugv_num];

if (true) exitwith {};
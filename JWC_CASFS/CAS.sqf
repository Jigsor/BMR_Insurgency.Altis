private ["_velocityZ"];

if (waitCAS) exitWith {titleText ["CAS already enroute, cancel current CAS or wait for bomb drop before next request!","PLAIN DOWN"]};

waitCAS = true;
_object = _this select 0;
_distance = _this select 1;
_doLock = _this select 2;
_num = _this select 3;
_casType = _this select 4;
_loc = getMarkerPos (_this select 5);
_id = _this select 6;

_lockobj = createAgent ["Logic", [(_loc select 0), (_loc select 1), 0], [] , 0 , "CAN_COLLIDE"];
_lockobj setPos _loc;

_lock = getPosASL _lockobj select 2;
_loc = visiblePosition _lockobj;
_dir = random 360;
_dis = 3500;
_speed = 200;
_setheight = getTerrainHeightASL [(_loc select 0) + _dis * sin _dir, (_loc select 1) + _dis * cos _dir];
_ranPos = [(_loc select 0) + _dis * sin _dir, (_loc select 1) + _dis * cos _dir, _setheight + 260];
_dirTo = [_ranPos, _lockobj] call BIS_fnc_dirTo;

_veh = [_ranPos, _dirTo, "B_Plane_CAS_01_F", WEST] call bis_fnc_spawnvehicle;
sleep jig_tvt_globalsleep;

_buzz = _veh select 0;
_grp = _veh select 2;

_vel = velocity _buzz;
_buzz setVelocity [(_vel select 0)+(sin _dirTo*_speed),(_vel select 1)+ (cos _dirTo*_speed),(_vel select 2)];

[_buzz] execVM "JWC_CASFS\track.sqf";

_buzz allowDamage false;

{
	_x setCaptive true;
	_x allowDamage false;
} forEach (units _grp);

(leader _grp) sideChat localize "STR_JWC_CAS_inbound";

_grp setBehaviour "STEALTH";
_grp setSpeedMode "FULL";
_grp setCombatMode "BLUE";

(driver _buzz) doMove _loc;

doCounterMeasure =
{
  _plane = _this select 0;
  for "_i" from 1 to 4 do
  {
    _bool = _plane fireAtTarget [_plane,"CMFlareLauncher"];
    sleep 0.3;
  };
  sleep 3;
  _plane = _this select 0;
  for "_i" from 1 to 4 do
  {
    _bool = _plane fireAtTarget [_plane,"CMFlareLauncher"];
    sleep 0.3;
  };
};

while {true} do
{
  if (_buzz distance _lockobj <= 660) exitwith {};
  if (!alive _buzz) exitwith {};
  if (abortCAS) exitWith {};
  sleep 0.01;
};

if (!alive _buzz) exitwith
{
  casRequest = false;
  deleteMarker "CAS_TARGET";
};

waitCAS = false;

if (abortCAS) exitWith
{
  _buzz move _ranPos;
  (leader _grp) sideChat localize "STR_JWC_CAS_aborted";
  abortCAS = true;
  waitUntil{_buzz distance _object >= 2000 || !alive _buzz || speed _buzz < 1};
  {
    deleteVehicle vehicle _x;
    deleteVehicle _x;
  } forEach units _grp;
};

usedCAS = usedCAS + 1;

_object removeAction _id;

if (usedCAS < usedCAS) then
{
  _num = _num - usedCAS;
  [_object, _distance, _doLock, _num] execVM "JWC_CASFS\addAction.sqf"
};


[_buzz] spawn doCounterMeasure;

if ((alive _buzz) && (_casType == "JDAM")) then
{
  _drop = createAgent ["Logic", [getPos _buzz select 0, getPos _buzz select 1, 0], [] , 0 , "CAN_COLLIDE"];
  _height = 225 + _lock;
  _ASL = getPosASL _drop select 2;
  _height = _height - _ASL;
  _bomb = "Bo_GBU12_LGB" createvehicle [getPos _drop select 0, getPos _drop select 1, _height];
  _bomb setDir ((_loc select 0)-(getPos _bomb select 0)) atan2 ((_loc select 1)-(getPos _bomb select 1));
  _dist = _bomb distance _loc;
  if (_dist > 536) then
  {
    _diff = _dist - 536;
    _diff = _diff * 0.150;
    _velocityZ = 85 - _diff;
  };
  if (_dist < 536) then
  {
    _diff = 536 - _dist;
    _diff = _diff * 0.150;
    _velocityZ = 85 + _diff;
  };
  _bDrop = sqrt(((getPosASL _bomb select 2)-_lock)/4.9);
  _bVelX = ((_loc select 0)-(getPos _bomb select 0))/_bDrop;
  _bVelY = ((_loc select 1)-(getPos _bomb select 1))/_bDrop;
  _bomb setVelocity [_bVelX,_bVelY,(velocity _bomb select 2) - _velocityZ];
  deleteVehicle _drop;
};

if ((alive _buzz) && (_casType == "CBU")) then
{
  _drop = createAgent ["Logic", [getPos _buzz select 0, getPos _buzz select 1, 0], [] , 0 , "CAN_COLLIDE"];
  _height = 225 + _lock;
  _ASL = getPosASL _drop select 2;
  _height = _height - _ASL;
  _height = _height + 40;
  _cbu = "Bo_GBU12_LGB" createvehicle [getPos _drop select 0, getPos _drop select 1, _height];
  _cbu setDir ((_loc select 0)-(getPos _cbu select 0)) atan2 ((_loc select 1)-(getPos _cbu select 1));
  _dist = _cbu distance _loc;
  if (_dist > 536) then
  {
    _diff = _dist - 536;
    _diff = _diff * 0.150;
    _velocityZ = 85 - _diff;
  };
  if (_dist < 536) then
  {
    _diff = 536 - _dist;
    _diff = _diff * 0.150;
    _velocityZ = 85 + _diff;
  };
  _bDrop = sqrt(((getPosASL _cbu select 2)-_lock)/4.9);
  _bVelX = ((_loc select 0)-(getPos _cbu select 0))/_bDrop;
  _bVelY = ((_loc select 1)-(getPos _cbu select 1))/_bDrop;
  _cbu setVelocity [_bVelX,_bVelY,(velocity _cbu select 2) - _velocityZ];
  waitUntil{getPos _cbu select 2 <= 40};
  _pos = getPos _cbu;
  _effect = "SmallSecondary" createvehicle _pos;
  deleteVehicle _cbu;
  for "_i" from 1 to 35 do
  {
    _explo = "G_40mm_HEDP" createvehicle _pos;
    _explo setVelocity [-35 + (random 70),-35 + (random 70),-50];
    sleep 0.025;
  };
  deleteVehicle _drop;
};

if ((alive _buzz) && (_casType == "COMBO")) then
{
  _drop = createAgent ["Logic", [getPos _buzz select 0, getPos _buzz select 1, 0], [] , 0 , "CAN_COLLIDE"];
  _height = 225 + _lock;
  _ASL = getPosASL _drop select 2;
  _height = _height - _ASL;
  _bomb = "Bo_GBU12_LGB" createvehicle [getPos _drop select 0, getPos _drop select 1, _height];
  _bomb setDir ((_loc select 0)-(getPos _bomb select 0)) atan2 ((_loc select 1)-(getPos _bomb select 1));
  _dist = _bomb distance _loc;
  if (_dist > 536) then
  {
    _diff = _dist - 536;
    _diff = _diff * 0.150;
    _velocityZ = 85 - _diff;
  };
  if (_dist < 536) then
  {
    _diff = 536 - _dist;
    _diff = _diff * 0.150;
    _velocityZ = 85 + _diff;
  };
  _bDrop = sqrt(((getPosASL _bomb select 2)-_lock)/4.9);
  _bVelX = ((_loc select 0)-(getPos _bomb select 0))/_bDrop;
  _bVelY = ((_loc select 1)-(getPos _bomb select 1))/_bDrop;
  _bomb setVelocity [_bVelX,_bVelY,(velocity _bomb select 2) - _velocityZ];
  deleteVehicle _drop;
  while {true} do
  {
    if (_buzz distance _lockobj <= 560) exitwith {};
    if (!alive _buzz) exitwith {};
    if (abortCAS) exitWith {};
    sleep 0.01;
  };
  _drop = createAgent ["Logic", [getPos _buzz select 0, getPos _buzz select 1, 0], [] , 0 , "CAN_COLLIDE"];
  _height = 225 + _lock;
  _ASL = getPosASL _drop select 2;
  _height = _height - _ASL;
  _height = _height + 40;
  _cbu = "Bo_GBU12_LGB" createvehicle [getPos _drop select 0, getPos _drop select 1, _height];
  _cbu setDir ((_loc select 0)-(getPos _cbu select 0)) atan2 ((_loc select 1)-(getPos _cbu select 1));
  _dist = _cbu distance _loc;
  if (_dist > 536) then
  {
    _diff = _dist - 536;
    _diff = _diff * 0.150;
    _velocityZ = 85 - _diff;
  };
  if (_dist < 536) then
  {
    _diff = 536 - _dist;
    _diff = _diff * 0.150;
    _velocityZ = 85 + _diff;
  };
  _bDrop = sqrt(((getPosASL _cbu select 2)-_lock)/4.9);
  _bVelX = ((_loc select 0)-(getPos _cbu select 0))/_bDrop;
  _bVelY = ((_loc select 1)-(getPos _cbu select 1))/_bDrop;
  _cbu setVelocity [_bVelX,_bVelY,(velocity _cbu select 2) - _velocityZ];
  deleteVehicle _drop;
  waitUntil{getPos _cbu select 2 <= 40};
  _pos = getPos _cbu;
  _effect = "SmallSecondary" createvehicle _pos;
  deleteVehicle _cbu;
  for "_i" from 1 to 35 do
  {
    _explo = "G_40mm_HEDP" createvehicle _pos;
    _explo setVelocity [-35 + (random 70),-35 + (random 70),-50];
    sleep 0.025;
  };
};

if (_casType == "COMBO") then
{
  (leader _grp) sideChat localize "Bombs dropped";
}
else
{
  (leader _grp) sideChat "Bomb dropped";
};

deleteVehicle _lockobj;

casRequest = false;

deleteMarker "CAS_TARGET";
(leader _grp) sideChat localize "STR_JWC_CAS_rtb";

_grp = group _buzz;

waitUntil{_buzz distance _object >= 2000 || !alive _buzz || speed _buzz < 1};
{
  _num = _num - 1;
  deleteVehicle vehicle _x;
  deleteVehicle _x;
  sleep 60;
  [_object, _distance, _doLock, _num] execVM "JWC_CASFS\addAction.sqf"
} forEach units _grp;
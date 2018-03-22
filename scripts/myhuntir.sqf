//High-altitude Unit Navigated Tactical Imaging Round script by bardosy
//Add the player's action into "myhuntiraction" global variable.
//Example: myhuntiraction = player addAction ["use HuntIR", "scripts\myhuntir.sqf", [], 1, false, true, "", "true"]; lck_markercnt=0;

player removeAction myhuntiraction;
myhuntirfired=false;
_firedeventhandlernumber = (player addEventHandler ["Fired",{if ((_this select 4) == "F_40mm_White") then {myhuntirfired=true;}}]);
Hintsilent localize "STR_BMR_HuntIR_tip1";
waitUntil {sleep 0.1; myhuntirfired};
sleep 0.3;
player removeEventHandler ["Fired", _firedeventhandlernumber];
_granat = nearestObject [player,"F_40mm_White"];

if (isNull _granat) exitWith {Hintsilent "STR_BMR_HuntIR_tip2";myhuntiraction = player addAction ["use HuntIR", "scripts\myhuntir.sqf", [], 1, false, true, "", "true"];};

_magassag = (getPos _granat) select 2;
sleep 0.2;
while {_magassag > (getPos _granat) select 2} do {
  _magassag = (getPos _granat) select 2;
  //hintsilent format["alt=%1",_magassag];
  sleep 0.1;
};

//_veh = createVehicle ["Sign_Sphere10cm_F", (getPos _granat), [], 0, "NONE"];
sleep 1;
_sattgt = "Logic" createVehicleLocal [getPos _granat select 0, getPos _granat select 1, -10];
_sattgt setDir 0;
_sattgt setpos [getPos _granat select 0, getPos _granat select 1, 0];
sleep 0.01;

lck_huntirreset=0;
lck_marker=0;
lck_nvg=0;
keyout = 0;
movesatx = 0;
movesaty = 0;
zoom = 0;
_zoominout = 1;
dive = 0;
_divepos = 0;

openMap false;
0 fadesound 0;
disableserialization;
keyspressed = compile preprocessFile "scripts\myhuntir_keydown.sqf";
HuntIR_Eh = (findDisplay 46) displayAddEventHandler ["KeyDown","_this call keyspressed"];//updated Jig

_granatpos = [(getPos _granat) select 0, (getPos _granat) select 1, ((getPos _granat) select 2)+50];
_sattgt setpos [getPos _granat select 0, (getPos _granat select 1)-1, 0];
deleteVehicle _granat;

_camera = "camera" camcreate _granatpos;
_camera cameraeffect ["Internal", "BACK"];
showCinemaBorder false;
_camera camSetTarget _sattgt;
_camera camSetFOV 1;
_camera camCommit 0;

TitleText["                                        Quit: Numpad End,   NightVision: Numpad PgUp\n                                        Move: arrows,  Zoom: Numpad +/-,  Marker: Num PgDn\n                                        Help: Numpad 5,   Reset: Numpad Home","PLAIN DOWN"];

_ido=1;
while {(_granatpos select 2 > 2)} do {
	if (_ido mod 10 isEqualTo 0) then {
		TitleText["                                        Quit: Numpad End,   NightVision: Numpad PgUp\n                                        Move: arrows,  Zoom: Numpad +/-,  Marker: Num PgDn\n                                        Help: Numpad 5,   Reset: Numpad Home","PLAIN DOWN"];
	};
	if (not alive player) exitWith {};
	if (keyout > 0) exitwith {};
	if (lck_huntirreset > 0) then {
		lck_huntirreset=0;
		_sattgt setpos [_granatpos select 0, (_granatpos select 1)-1, 0];
		_zoominout = 1;
	};
	if (lck_marker > 0) then {
		lck_marker = 0;
		_markercon = createMarker [format["huntirmarker%1",lck_markercnt], getPos _sattgt];
		_markercon setMarkerType "mil_dot";
		_markercon setMarkerColor "ColorBlack";
		_markercon setMarkerText format["HuntIR%1",lck_markercnt];
		lck_markercnt = lck_markercnt + 1;
		publicVariable "lck_markercnt";
	};
	if ((movesatx != 0) or (movesaty != 0) or (zoom != 0) or (dive != 0)) then {
		satpos = [(getpos _sattgt select 0) + movesatx, (getpos _sattgt select 1) + movesaty, 0];
		_sattgt setpos [satpos select 0, satpos select 1, 0];
		_zoominout = _zoominout + zoom;
		_divepos = _divepos + dive;
		if (_zoominout < 0.02) then {_zoominout = 0.02};
		if (_zoominout > 3) then {_zoominout = 3};
	};
	_camera camSetPos _granatpos;
	_camera camSetTarget _sattgt;
	_camera camSetFOV _zoominout;
	_camera camCommit 0;

	movesatx = 0;
	movesaty = 0;
	zoom = 0;
	dive = 0;

	//hintsilent format["magassag = %1",_granatpos select 2];
	waituntil{camCommitted _camera};
	_ido = _ido + 0.02;
	sleep 0.02;
	_granatpos = [_granatpos select 0, _granatpos select 1, (_granatpos select 2)-0.04];
};

camUseNVG false;
false setCamUseTi 0;
player cameraEffect ["Terminate","BACK"];
camdestroy _camera;
deletevehicle _sattgt;
camUseNVG false;
(findDisplay 46) displayRemoveEventHandler ["KeyDown", HuntIR_Eh];//updated Jig
0 fadesound 1;
//hintsilent format["granat itt volt x=%1, y=%2",_debugx,_debugy];
myhuntiraction = player addAction ["use HuntIR", "scripts\myhuntir.sqf", [], 1, false, true, "", "true"];
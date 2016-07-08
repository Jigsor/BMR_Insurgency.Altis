player allowdamage false;

_dummy = "Land_HelipadEmpty_F" createVehicle [0,0,0];
btc_qr_cam_t = "Land_HelipadEmpty_F" createVehicle [0,0,0];
player attachTo [_dummy,[0,0,5000]];

btc_qr_spawn_selected = false;

titleText ["","BLACK IN",2];

closeDialog 0;

disableSerialization;
_dlg = createDialog "btc_qr_dlg_resp";
_ui = uiNamespace getVariable "btc_qr_dlg_resp";
_ui displayAddEventHandler ["KeyDown", "if ((_this select 1) == 1) then { true }"];

_idc = 181;

lbClear _idc;
{
	_text = markerText _x;
	if (_text isEqualTo "") then {_text = _x;};
	_index = lbAdd [ _idc, _text ];
	lbSetData [ _idc, _index, _x ];
} foreach btc_qr_def_spawn;

lbSetCurSel [_idc,0];
lbSort [(_ui displayCtrl _idc), "ASC"];

btc_qr_cam_t setpos (getMarkerPos (lbData [_idc, lbCurSel _idc]));
btc_qr_cam = "camera" camCreate (getMarkerPos (lbData [_idc, lbCurSel _idc]));
btc_qr_cam cameraEffect ["internal", "BACK"];
btc_qr_cam camSetPos (btc_qr_cam_t modelToWorld [btc_qr_cam_dist,btc_qr_cam_dist,(abs btc_qr_cam_dist)]);
btc_qr_cam camSetTarget btc_qr_cam_t;
btc_qr_cam camCommit 0;

waitUntil {btc_qr_spawn_selected};

detach player;
player enableSimulation false;

player setPos getMarkerPos (lbData [_idc, lbCurSel _idc]);
player switchMove "";
player allowdamage true;
player enableSimulation true;
closeDialog 0;

player cameraEffect ["terminate","back"];
camDestroy btc_qr_cam;

{deleteVehicle _x} foreach [btc_qr_cam_t,_dummy];

titleText ["","BLACK IN",2];
sleep 3;
titleText ["","PLAIN"];
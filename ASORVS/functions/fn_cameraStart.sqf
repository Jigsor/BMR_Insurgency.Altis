#include "macro.sqf"
ASORVS_Rotating = false;
ASORVS_MovingY = false;
ASORVS_CurrentRotation = 45;
_distancex = .7;
_distancey = 19;
_height = 3;
_fov = .3;
_bgTexture = "#(rgb,8,8,3)color(0,0,0,1)";
_heightInAir = 50;
_platformOffset =2;
ASORVS_Position = [(random -1400), (random -1400), 0];

_seaHeight =  0 max ((ASLtoATL ASORVS_Position) select 2);
ASORVS_Platform = "FlagChecked_F" createVehicleLocal ASORVS_Position;
ASORVS_Platform setPosATL [ASORVS_Position select 0, (ASORVS_Position select 1), _seaHeight + _heightInAir - 20];
//hideObject ASORVS_Platform;

_logo = ASORVS_BackgroundLogo;
_playerinsignia = (player call BIS_fnc_getUnitInsignia);
if(ASORVS_UnitInsigniaAsBackground && (_playerinsignia != "")) then {
	_logo = getText (configFile >> "CfgUnitInsignia" >> _playerinsignia >> "texture");
};

ASORVS_Background = "UserTexture10m_F" createVehicleLocal [0,0,0];
ASORVS_Background setPosATL [(ASORVS_Position select 0) + .55, (ASORVS_Position select 1) - 6.9, _seaHeight + 3  + _heightInAir];
ASORVS_Background setDir 180;
ASORVS_Background setObjectTexture [0, _logo];
//hideObject ASORVS_Floor;

_bgCountX = 9;
_bgCountY = 5;
_bgLeft = -(_bgCountX * 0.5) * 10;
_bgTop = -(_bgCountY * 0.5) * 10;
ASORVS_Backgrounds = [];
for[{_bgX = 0}, {_bgX < _bgCountX}, {_bgX = _bgX + 1}] do {
	for[{_bgY = 0}, {_bgY < _bgCountY}, {_bgY = _bgY + 1}] do {
		_bg = "UserTexture10m_F" createVehicleLocal [0,0,0];
		_bg setPosATL [(ASORVS_Position select 0) + _bgLeft + (_bgX * 10), (ASORVS_Position select 1) -9, _seaHeight + _heightInAir  + _bgTop + (_bgY * 10)];
		_bg setDir 180;
		_bg setObjectTexture [0,_bgTexture];
		_bg enableSimulation false;
		ASORVS_Backgrounds set [count ASORVS_Backgrounds, _bg];
	};
};
for[{_bgX = 0}, {_bgX < _bgCountX}, {_bgX = _bgX + 1}] do {
	for[{_bgY = 0}, {_bgY < _bgCountY}, {_bgY = _bgY + 1}] do {
		_bg = "UserTexture10m_F" createVehicleLocal [0,0,0];
		_bg setPosATL [(ASORVS_Position select 0) + _bgLeft + (_bgX * 10), (ASORVS_Position select 1) -8.95, _seaHeight + _heightInAir  + _bgTop + (_bgY * 10)];
		_bg setDir 180;
		_bg setObjectTexture [0,ASORVS_BackgroundTile];
		_bg enableSimulation false;
		ASORVS_Backgrounds set [count ASORVS_Backgrounds, _bg];
	};
};
ASORVS_ClonePos = [ASORVS_Position select 0, ASORVS_Position select 1, _seaHeight+5 + _heightInAir];
[] spawn ASORVS_fnc_ResetClone;
//ASORVS_Clone enableSimulation false;
_pos = ASORVS_Position;

/*
ASORVS_OriginalPos = position ASORVS_Player;
"BlockConcrete_F" createVehicleLocal _pos;
ASORVS_Player setPos [_pos select 0, _pos select 1, 3];
ASORVS_Player setDir 0;
ASORVS_Player action ["WeaponOnBack", ASORVS_Player];
*/

_cameraTarget = [(_pos select 0) + _distancex, (_pos select 1) , _seaHeight+3 + _heightInAir];
_cameraPos = [(_pos select 0) + _distancex, (_pos select 1)+ _distancey, _seaHeight+3 + _heightInAir];
ASORVS_CameraTarget = "LOGIC" createVehicleLocal _cameraTarget;
ASORVS_CameraTarget setPosATL _cameraTarget;

sleep 0.1;
ASORVS_Camera = "camera" camCreate _cameraPos;
ASORVS_Camera cameraEffect ["Internal", "BACK"];
ASORVS_Camera camPrepareTarget ASORVS_CameraTarget;
//ASORVS_Camera camPrepareRelPos [0,  -_distancey, 0 ];
ASORVS_Camera camPrepareFOV _fov;
showCinemaBorder false;
ASORVS_Camera setPosATL _cameraPos;
ASORVS_Camera camCommitPrepared 0;

ASORVS_CameraPosMinZoom = _cameraPos;
ASORVS_CameraPosMaxZoom = [_cameraPos, ASORVS_Position, 0.7] call ASORVS_fnc_vectorLerp;
ASORVS_CameraTargetMinZoom = _cameraTarget;
ASORVS_CameraTargetMaxZoom = _cameraTarget vectorAdd (ASORVS_CameraPosMaxZoom vectorDiff ASORVS_CameraPosMinZoom );
ASORVS_CameraMinY = _seaHeight+ 2.5 + _heightInAir;
ASORVS_CameraMaxY = _seaHeight+3.5 + _heightInAir;
ASORVS_CurrentZoom = 0;
ASORVS_CurrentY = ((_cameraPos select 2) - ASORVS_CameraMinY) / (ASORVS_CameraMaxY - ASORVS_CameraMinY);
ASORVS_Light = "#lightpoint" createVehicleLocal _cameraPos;
ASORVS_Light setPosATL _cameraPos;
_brightness = 1;
if(worldName in ASORVS_brightMaps) then {_brightness = 0.3;};

ASORVS_Light setLightBrightness _brightness;
ASORVS_Light setLightAmbient[1,1,1];
ASORVS_Light setLightColor[1,1,1];
//BIS_DEBUG_CAM = true;

ASORVS_RotateDirection = 0;

//PIP camera
_camera = "camera" camcreate position cameraon;
_camera campreparepos (ASORVS_VehicleSpawnPos vectorAdd [0,0,5]);
_camera campreparetarget ASORVS_VehicleSpawnPos;
_camera camPrepareFov 5;
_camera camcommitprepared 0;
ASORVS_RenderTarget = _camera;
ASORVS_RenderTarget cameraeffect ["External","BACK","rt12"];
 ASORVS_Camera cameraEffect ["Internal", "BACK"];
waitUntil {!isNull (findDisplay ASORVS_Main_Display)};
_pipcontrol = ASORVS_getControl(ASORVS_Main_Display,434603);
_pipcontrol ctrlSetText  "#(argb,256,256,1)r2t(rt12,1.0)";

/*
while {ASORVS_Open} do {
	if(ASORVS_RotateDirection != 0) then {
		ASORVS_Clone setDir (getDir ASORVS_Clone + ASORVS_RotateDirection);
	};
	sleep 0.05;
};*/
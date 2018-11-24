#define HCAM_UI_DISP (uiNamespace getVariable "hcam_ui_disp")
#define HCAM_CTRL_PIP (uiNamespace getVariable "hcam_ctrl_pip")
#define HCAM_CTRL_TITLE (uiNamespace getVariable "hcam_ctrl_title")
#define HCAM_CTRL_BACK (uiNamespace getVariable "hcam_ctrl_back")
#define HCAM_CTRL_FRONT (uiNamespace getVariable "hcam_ctrl_front")

if (hcam_active || !hasInterface) exitWith {};

private _old = "";
private _neck = "Sign_Sphere10cm_F" createVehicleLocal position player;
private _pilot = "Sign_Sphere10cm_F" createVehicleLocal position player;
private _target = "Sign_Sphere10cm_F" createVehicleLocal position player;
hideObject _neck;
hideObject _pilot;
hideObject _target;
_target attachTo [_neck,[0.5,10,0]];


// Create camera ->todo
//[player,_target,player,0] call BIS_fnc_liveFeed;
hcam_cam = "camera" camCreate getPos player;
waitUntil {hcam_cam != ObjNull};
808 cutRsc ["RscHcamDialog", "PLAIN"];
HCAM_CTRL_PIP ctrlsettext "#(argb,256,256,1)r2t(rendertarget0,1.0)";

if (hcam_zoom == 0) then {
	HCAM_CTRL_BACK ctrlSetPosition [0.85*safezoneW+safezoneX, 0.725*safezoneH+safezoneY,0.15*safezoneW,0.11*safezoneH];
	HCAM_CTRL_PIP ctrlSetPosition [0.8635*safezoneW+safezoneX, 0.733*safezoneH+safezoneY,0.122*safezoneW,0.095*safezoneH];
	HCAM_CTRL_TITLE ctrlSetPosition [0.8635*safezoneW+safezoneX, 0.81*safezoneH+safezoneY,0.122*safezoneW,0.015*safezoneH];
	HCAM_CTRL_FRONT ctrlSetPosition [0.8635*safezoneW+safezoneX, 0.733*safezoneH+safezoneY,0.122*safezoneW,0.095*safezoneH];
	
	HCAM_CTRL_BACK ctrlCommit 0;
	HCAM_CTRL_PIP ctrlCommit 0;
	HCAM_CTRL_TITLE ctrlCommit 0;
	HCAM_CTRL_FRONT ctrlCommit 0;
};

hcam_offset = [-0.18,0.08,0.05];
hcam_cam attachTo [_neck,hcam_offset];
hcam_cam camSetFov 0.6;
hcam_cam camSetTarget _target;
hcam_cam camCommit 2;

"rendertarget0" setPiPEffect [3, 1, 0.8, 1, 0.1, [0.3, 0.3, 0.3, -0.1], [1.0, 0.0, 1.0, 1.0], [0, 0, 0, 0]];

hcam_active = true;
private _camOn = false;
private "_units";

while {!isNil {hcam_cam} && {!isNull hcam_cam}} do {
	if (!((goggles player) in hcam_goggles)) then {
		hcam_cam cameraEffect ["Terminate", "BACK"];
		_camOn = false;
		camDestroy hcam_cam;
		hcam_cam = nil;
	} else {
		if (hcam_units isEqualTo "group") then {
		  _units = units (group player);
		} else {
		  _units = hcam_units;
		};

		if (hcam_id >= count _units) then {hcam_id = 0};
		hcam_target = _units select hcam_id;

		if (alive hcam_target && {name hcam_target != _old}) then {
			_neck attachTo [hcam_target,[0,0,0],"neck"];
			_pilot attachTo [hcam_target,[0,0,0],"pilot"];
			_old = name hcam_target;
			hcam_cam cameraEffect ["Internal", "BACK","rendertarget0"];
			HCAM_CTRL_TITLE ctrlsettext (name hcam_target);
		};

		if ((headgear hcam_target) in hcam_headgear) then {
			if (!_camOn) then {
				hcam_cam cameraEffect ["Internal", "BACK","rendertarget0"];
				"rendertarget0" setPiPEffect [3, 1, 0.8, 1, 0.1, [0.3, 0.3, 0.3, -0.1], [1.0, 0.0, 1.0, 1.0], [0, 0, 0, 0]];
				HCAM_CTRL_PIP ctrlsettext "#(argb,256,256,1)r2t(rendertarget0,1.0)";
				_camOn = true;
			};
		} else {
			if (_camOn) then {
				hcam_cam cameraEffect ["Terminate", "BACK"];
				_camOn = false;
			};
		};

		if (_camOn) then {
			private _veh = vehicle hcam_target;

			if (hcam_target != _veh) then {
				_mempoints = getArray (configfile >> "CfgVehicles" >> (typeOf _veh) >> "memoryPointDriverOptics");
				if (_mempoints isEqualTypeParams ["",""]) then {
					hcam_cam attachTo [_veh,[0,0,0], _mempoints select 0];
					_target attachTo [_veh,[0,1,0], _mempoints select 0];
				};
			} else {
				private _pos1 = hcam_target worldToModel getPos _pilot;
				private _pos2 = hcam_target worldToModel getPos _neck;

				private _vx1 = (_pos1 select 0) - (_pos2 select 0);
				private _vy1 = (_pos1 select 1) - (_pos2 select 1);
				private _vz1 = (_pos1 select 2) - (_pos2 select 2);
				private _dir = (_vx1 atan2 _vy1) - 25;
				private _dive = (_vy1 atan2 _vz1) + 35;

				if ((sin _dive) isEqualTo 0) then {_dive = _dive +1};
				private _tz = ((1 / sin _dive) * cos _dive);

				hcam_cam attachTo [_neck,hcam_offset];
				_target attachTo [_neck,[0.5,10,_tz*10]];
				_neck setDir _dir;
				sleep 0.1;
			};
		} else {
			sleep 1;
		};
	};
};

808 cutFadeOut 0;
hcam_active = false;
deleteVehicle _neck;
deleteVehicle _pilot;
deleteVehicle _target;
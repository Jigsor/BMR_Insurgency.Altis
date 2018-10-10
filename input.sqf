#define HCAM_UI_DISP (uiNamespace getVariable "hcam_ui_disp")
#define HCAM_CTRL_PIP (uiNamespace getVariable "hcam_ctrl_pip")
#define HCAM_CTRL_TITLE (uiNamespace getVariable "hcam_ctrl_title")
#define HCAM_CTRL_BACK (uiNamespace getVariable "hcam_ctrl_back")
#define HCAM_CTRL_FRONT (uiNamespace getVariable "hcam_ctrl_front")
#define T_HCAM_KEY 55

params ["","_key","_shift","_ctrl","_alt"];

if ((_key != T_HCAM_KEY) || {!((goggles player) in hcam_goggles)}) exitWith {};

private "_units";

if (hcam_units isEqualTo "group") then {
	_units = units (group player);
} else {
	_units = hcam_units;
};

if (!_shift && !_ctrl && _alt) then {
	if (hcam_active) then {
		hcam_cam cameraEffect ["Terminate", "BACK"];
		camDestroy hcam_cam;
		hcam_cam = nil;
	};
};

if (_shift && !_ctrl && !_alt) then {
	if (hcam_active) then {
		if (hcam_zoom == 1) then {
			HCAM_CTRL_BACK ctrlSetPosition [0.85*safezoneW+safezoneX, 0.725*safezoneH+safezoneY,0.15*safezoneW,0.11*safezoneH];
			HCAM_CTRL_PIP ctrlSetPosition [0.8635*safezoneW+safezoneX, 0.733*safezoneH+safezoneY,0.122*safezoneW,0.095*safezoneH];
			HCAM_CTRL_TITLE ctrlSetPosition [0.8635*safezoneW+safezoneX, 0.81*safezoneH+safezoneY,0.122*safezoneW,0.015*safezoneH];
			HCAM_CTRL_FRONT ctrlSetPosition [0.8635*safezoneW+safezoneX, 0.733*safezoneH+safezoneY,0.122*safezoneW,0.095*safezoneH];

			HCAM_CTRL_BACK ctrlCommit 1;
			HCAM_CTRL_PIP ctrlCommit 1;
			HCAM_CTRL_TITLE ctrlCommit 1;
			HCAM_CTRL_FRONT ctrlCommit 1;

			hcam_zoom = 0;
		} else {
			HCAM_CTRL_BACK ctrlSetPosition [0.78*safezoneW+safezoneX, 0.67*safezoneH+safezoneY,0.22*safezoneW,0.17*safezoneH];
			HCAM_CTRL_PIP ctrlSetPosition [0.8*safezoneW+safezoneX, 0.68*safezoneH+safezoneY,0.18*safezoneW,0.15*safezoneH];
			HCAM_CTRL_TITLE ctrlSetPosition [0.8*safezoneW+safezoneX, 0.81*safezoneH+safezoneY,0.18*safezoneW,0.02*safezoneH];
			HCAM_CTRL_FRONT ctrlSetPosition [0.8*safezoneW+safezoneX, 0.68*safezoneH+safezoneY,0.18*safezoneW,0.15*safezoneH];

			HCAM_CTRL_BACK ctrlCommit 1;
			HCAM_CTRL_PIP ctrlCommit 1;
			HCAM_CTRL_TITLE ctrlCommit 1;
			HCAM_CTRL_FRONT ctrlCommit 1;

			hcam_zoom = 1;
		};
	};
};

if (!_shift && !_ctrl && !_alt) then {
	if (!hcam_active) then {
		nul = [] execVM (hcam_basepath + "scripts\helmetcam.sqf");
	} else {
		if (count _units > 1) then {
			hcam_id = hcam_id + 1;
			if (hcam_id >= count _units) then {hcam_id = 0};
			hcam_cam cameraEffect ["Terminate", "BACK"];
		};
	};
};
if ( (_this select 0) == "mission" ) then {
	hcam_basepath = "";
	hcam_configpath = "";
} else {
	hcam_basepath = "\T_Helmetcam\";
	hcam_configpath = "\userconfig\T\";
};


if (isDedicated) exitWith {};
if (IamHC) exitwith {};

// Define vars (or see if they have already been assigned by the server)
if (isNil "hcam_goggles") then {
  hcam_goggles = ["G_Tactical_Clear"];
};
if (isNil "hcam_headgear") then {
  hcam_headgear = ["H_HelmetB","H_HelmetB_paint"," H_HelmetB_light","H_HelmetO_ocamo","H_PilotHelmetHeli_B","H_PilotHelmetHeli_O"];
};
if (isNil "hcam_units") then {
  hcam_units = "group";
};

hcam_active = false;
hcam_id = 0;
hcam_zoom = 1;

hcam_ui_init = {
	_disp = _this select 0;
	uiNamespace setVariable ["hcam_ui_disp", _disp];
	uiNamespace setVariable ["hcam_ctrl_pip", _disp displayCtrl 0];
	uiNamespace setVariable ["hcam_ctrl_title", _disp displayCtrl 1];
	uiNamespace setVariable ["hcam_ctrl_back", _disp displayCtrl 2];
	uiNamespace setVariable ["hcam_ctrl_front", _disp displayCtrl 3];
	(_disp displayCtrl 0) ctrlSetText "#(argb,256,256,1)r2t(rendertarget0,1.0)";
};

// Init
waitUntil {!isNull (findDisplay 46)};
(findDisplay 46) displayAddEventHandler ["KeyDown"," nul=[_this select 1,_this select 2,_this select 3,_this select 4] execVM (hcam_basepath+'input.sqf'); "];

// fn_DigiHeading.sqf by Jigsor
// Digital Heading of Sceen Center

private _display = uiNamespace getVariable ["jig_headingDisplay", displayNull];

if (!isNull _display) exitWith {
    "jig_headingDisplay" cutText ["", "PLAIN"];
    false
};

waitUntil {sleep 1.1; (!isNull player && {(player getVariable ["BTC_need_revive",0] == 0) && !(lifeState player isEqualTo "INCAPACITATED") && !(player getVariable ["ACE_isUnconscious", false])})};

"jig_headingDisplay" cutRsc ["RscTitleDisplayEmpty", "PLAIN", 0, false];
private _display = uiNamespace getVariable "RscTitleDisplayEmpty";
uiNamespace setVariable ["jig_headingDisplay", _display];

private _vignette = _display displayCtrl 1202;
_vignette ctrlShow false;

private _heading = _display ctrlCreate ["RscStructuredText", -1];
_display setVariable ["jig_headingDisplay", _heading];

getResolution params ["_screenW","_screenH","","","_aspectRatio","_uiSize"];

private _ctrlWidth = 0.06;
private _ctrlHeight = _ctrlWidth / 2 * _aspectRatio;
private _horiz = (safeZoneXAbs + (safeZoneWAbs / 2)) - (_ctrlWidth / 2);
private _y = safezoneY;
private _uiScaleFactor = getNumber (configFile >> "UIScaleFactor");
private _ctrlScale = if (_screenW > 2047 && {_aspectRatio > 1.24}) then {((_uiSize min 0.99) / _uiScaleFactor) * _uiScaleFactor} else {1};

_heading ctrlSetPosition [_horiz, _y, _ctrlWidth, _ctrlHeight];
_heading ctrlSetScale _ctrlScale;
_heading ctrlCommit 0;

private _ctrl = _display ctrlCreate ["RscMapControl", -1];

_ctrl ctrlSetPosition [0,0,0,0];
_ctrl ctrlCommit 0;

_ctrl ctrlAddEventHandler ["Draw", {
	params ["_ctrl"];
	private _heading = ctrlParent _ctrl getVariable "jig_headingDisplay";
	_heading ctrlSetStructuredText parseText format ["<t size='%1'>%2</t>", 2 * 0.32 / (getResolution#5), round(player getdir positionCameraToWorld [0,0,100])];
	_heading ctrlSetTextColor [(profileNamespace getVariable ["GUI_BCG_RGB_R", 0.98]), (profileNamespace getVariable ["GUI_BCG_RGB_G", 0.06]), (profileNamespace getVariable ["GUI_BCG_RGB_B", 0.06]), 0.65];
}];
true
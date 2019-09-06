// by Jigsor
disableSerialization;
params ["_Dialog","_DikCode","_shiftState","_ctrlState","_altState"];
private _return = false;
if (_DikCode isEqualTo 35) then {//DIK_H 0x23
	if (!_shiftState && !_ctrlState && !_altState) then {
		closeDialog 0;
		createDialog "Jig_H_Menu"
	} else {
		if (!isNull (uiNamespace getVariable "Jig_Y_Menu")) then {closeDialog 0}
	};
};
//[_DikCode] spawn { hint format["%1", _this]; uiSleep 1; hint "" };
_return = true
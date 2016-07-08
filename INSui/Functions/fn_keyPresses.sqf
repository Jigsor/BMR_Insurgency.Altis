// by Dirty Haz

disableSerialization;

private ["_handled", "_D", "_Key", "_Shift", "_Ctrl", "_Alt"];

_D = _this select 0;
_Key = _this select 1;
_Shift = _this select 2;
_Ctrl = _this select 3;
_Alt = _this select 4;
_handled = false;

keyPress_Y = false;

switch (_Key) do {

// T - case 20, Y - case 21
case 21: {
if (!_Shift && !_Ctrl && !_Alt) then {
if (!keyPress_Y) then {keyPress_Y = true; _handled = true; closeDialog 0; createDialog "DH_Y_Menu";} else {keyPress_Y = false;};
};
};

};

_handled = true;
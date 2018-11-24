#include "macro.sqf"
#define CATEGORY_SPACING  .01
#define CT_SHORTCUTBUTTON 16
#define TOTAL_WIDTH (safezoneW * 0.34)
#define LABEL_WIDTH .21
#define DIALOG_MARGIN .01
#define ITEM_HEIGHT (1/25)
#define ITEM_WIDTH (ITEM_HEIGHT*(3/4))
#define MULTI_COMBO_WIDTH (TOTAL_WIDTH - DIALOG_MARGIN - (CATEGORY_SPACING*5) - LABEL_WIDTH - ITEM_WIDTH*3)
private ["_firstIDC", "_controlcount", "_ypos", "_height", "_scale", "_control"];
disableSerialization;
_firstIDC = _this select 0;
_controlcount = _this select 1;
_ypos = _this select 2;
_height = _this param [3, (1/25), [1.0]];

for "_i" from 0 to (_controlcount-1) step 1 do {
	_control = ASORVS_getControl(ASORVS_Main_Display,_firstIDC + _i);
	_currentpos = ctrlPosition _control;
	_currentpos set [1, _ypos];
	if((ctrlType _control) == CT_SHORTCUTBUTTON) then {
		_scale = _height / ITEM_HEIGHT;
		_control ctrlSetScale _scale;
		//plus button
		if(_i == 3) then {
			_currentpos set [0, safezoneX + TOTAL_WIDTH - (ITEM_WIDTH*_scale) - DIALOG_MARGIN];
		};
	} else {
		_currentpos set [3, _height];
	};
	//count text
	if((_controlcount > 4) && ((_i == 2) || (_i >= 4))) then {
		_scale = _height / ITEM_HEIGHT;
		_currentpos set [0, safezoneX + MULTI_COMBO_WIDTH + CATEGORY_SPACING*2 + LABEL_WIDTH + (ITEM_WIDTH*_scale)];
		_currentpos set [2, TOTAL_WIDTH - LABEL_WIDTH - MULTI_COMBO_WIDTH - CATEGORY_SPACING*2 - DIALOG_MARGIN - (ITEM_WIDTH*_scale*2)];
	};
	_control ctrlSetPosition _currentpos;
	//_control ctrlEnable true;
	_control ctrlShow true;

	if((_controlcount > 4) && (_i == (_controlcount - 1))) then {
		_control ctrlShow false;
		_control ctrlEnable false;
		_control = ASORVS_getControl(ASORVS_Main_Display,_firstIDC + _i-1);
		_control ctrlShow false;
		_control ctrlEnable false;
	};
};
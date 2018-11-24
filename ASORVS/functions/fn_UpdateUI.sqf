#include "macro.sqf"
disableSerialization;
#define CATEGORY_SPACING  .01
#define ITEM_SPACING .005
#define ITEM_HEIGHT (1/25)
#define DIALOG_MARGIN .01
#define LABEL_WIDTH .21
#define TOTAL_WIDTH (safezoneW * 0.33333)
#define SAVE_WIDTH 0.1
#define TOP_SPACING .005
#define TOP (safezoneY + TOP_SPACING)
#define TEXT_SIZE .04

#define FULLCOMBO_WIDTH (TOTAL_WIDTH - (DIALOG_MARGIN * 2) - LABEL_WIDTH)

#define BOX_COMBO_WIDTH ((FULLCOMBO_WIDTH/5) - (ITEM_SPACING * 4))
#define BOX_COMBO_HEIGHT ((BOX_COMBO_WIDTH *0.86)*(4/3))
#define BOX_SPACING ((FULLCOMBO_WIDTH - BOX_COMBO_WIDTH*5) / 4)

#define ASORVS_ControlHeight  (1/25)
#define ASORVS_ControlSpacing  0.005
#define ASORVS_CategorySpacing 0.01
#define ASORVS_TopMargin ASORVS_ControlSpacing
#define ASORVS_MultiComboControls 6
#define END_CATEGORY _y = _y + ASORVS_CategorySpacing; _categoryCount = _categoryCount + 1;
#define END_ITEM _y = _y + ASORVS_ControlHeight + ASORVS_ControlSpacing; _lineCount = _lineCount + 1;
#define SHOW_ITEM(FIRSTIDC, IDCCOUNT) [FIRSTIDC, IDCCOUNT, _y] call ASORVS_fnc_updateUIShow; END_ITEM
#define HIDE_ITEM(FIRSTIDC, IDCCOUNT) [FIRSTIDC, IDCCOUNT, _y] call ASORVS_fnc_updateUIhide;
#define SHOW_SINGLEITEM_IF(FIRSTIDC, SHOWCONDITION)  if(SHOWCONDITION) then {SHOW_ITEM(FIRSTIDC, 2)} else {HIDE_ITEM(FIRSTIDC, 2)};
#define SHOW_SINGLEITEMCAT_IF(FIRSTIDC, SHOWCONDITION)  if(SHOWCONDITION) then {SHOW_ITEM(FIRSTIDC, 2) END_CATEGORY} else {HIDE_ITEM(FIRSTIDC, 2)};
#define SHOW_MULTICOMBO_IF(FIRSTIDC, SHOWCONDITION, COMBOCOUNT) \
	if(SHOWCONDITION) then { [FIRSTIDC, 1, _y] call ASORVS_fnc_updateUIShow; } else { [FIRSTIDC, 1, _y] call ASORVS_fnc_updateUIHide; }; \
	_currentIDC = FIRSTIDC + 1; \
	_previousIDC = _currentIDC; \
	for[{_t = 0}, {_t < COMBOCOUNT}, {_t = _t + 1}] do 	{ \
		if(((_t > 0) && ((lbCurSel _previousIDC) == 0)) || !SHOWCONDITION) then { \
			HIDE_ITEM(_currentIDC, ASORVS_MultiComboControls) } else { \
			SHOW_ITEM(_currentIDC, ASORVS_MultiComboControls) }; \
		_previousIDC = _currentIDC; \
		_currentIDC = _currentIDC + 10; }; 
#define SHOW_MULTICOMBOCAT_IF(FIRSTIDC, SHOWCONDITION, COMBOCOUNT) \
	SHOW_MULTICOMBO_IF(FIRSTIDC, SHOWCONDITION, COMBOCOUNT) \
	if(SHOWCONDITION) then { END_CATEGORY };

#define ENDSHRUNK_ITEM _y = _y + _itemHeight + ASORVS_ControlSpacing;
#define ENDSHRUNK_CATEGORY _y = _y + ASORVS_CategorySpacing;
#define SHOWSHRUNK_ITEM(FIRSTIDC, IDCCOUNT) [FIRSTIDC, IDCCOUNT, _y, _itemHeight] call ASORVS_fnc_updateUIShow; ENDSHRUNK_ITEM;
#define SHOWSHRUNK_SINGLEITEM_IF(FIRSTIDC, SHOWCONDITION)  if(SHOWCONDITION) then {SHOWSHRUNK_ITEM(FIRSTIDC, 2)} else {HIDE_ITEM(FIRSTIDC, 2)};
#define SHOWSHRUNK_SINGLEITEMCAT_IF(FIRSTIDC, SHOWCONDITION)  if(SHOWCONDITION) then {SHOWSHRUNK_ITEM(FIRSTIDC, 2) ENDSHRUNK_CATEGORY} else {HIDE_ITEM(FIRSTIDC, 2)};
#define SHOWSHRUNK_MULTICOMBO_IF(FIRSTIDC, SHOWCONDITION, COMBOCOUNT) \
	if(SHOWCONDITION) then { [FIRSTIDC, 1, _y, _itemHeight] call ASORVS_fnc_updateUIShow; } else { [FIRSTIDC, 1, _y] call ASORVS_fnc_updateUIHide; }; \
	_currentIDC = FIRSTIDC + 1; \
	_previousIDC = _currentIDC; \
	for[{_t = 0}, {_t < COMBOCOUNT}, {_t = _t + 1}] do 	{ \
		if(((_t > 0) && ((lbCurSel _previousIDC) == 0)) || !SHOWCONDITION) then { \
			HIDE_ITEM(_currentIDC, ASORVS_MultiComboControls) } else { \
			SHOWSHRUNK_ITEM(_currentIDC, ASORVS_MultiComboControls) }; \
		_previousIDC = _currentIDC; \
		_currentIDC = _currentIDC + 10; };
#define SHOWSHRUNK_MULTICOMBOCAT_IF(FIRSTIDC, SHOWCONDITION, COMBOCOUNT) \
	SHOWSHRUNK_MULTICOMBO_IF(FIRSTIDC, SHOWCONDITION, COMBOCOUNT) \
	if(SHOWCONDITION) then { ENDSHRUNK_CATEGORY };

private "_y";

_lineCount = 1;
_categoryCount = 0;
_y = safezoneY + ASORVS_TopMargin;//safezoneY + ASORVS_ControlHeight + ASORVS_ControlSpacing;

//preset is never hidden
HIDE_ITEM(ASORVS_preset_label, 3);
END_CATEGORY

_presetbottom = _y - (ASORVS_CategorySpacing * 0.5);
_weapontop = _presetbottom;// - (ASORVS_CategorySpacing );//_y - (ASORVS_CategorySpacing * 0.5);
_y = safezoneY - (1/25);
SHOW_ITEM(ASORVS_primary_label, 2, ITEM_HEIGHT*3)

//lines with 2 controls
{
	_control = ASORVS_getControl(ASORVS_Main_Display,_x);
	_control ctrlCommit 0.1;
	_control = ASORVS_getControl(ASORVS_Main_Display,_x+1);
	_control ctrlCommit 0.1;
} forEach [ASORVS_primary_label];
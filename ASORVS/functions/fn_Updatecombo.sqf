#include "macro.sqf"
_comboIDC = _this select 0;
_currentItem = _this select 1;
_items = call ASORVS_fnc_GetFilteredItems;
_additionalCheck = [_this, 4, {true}, [{}]] call BIS_fnc_Param;
_control = ASORVS_getControl(ASORVS_Main_Display,_comboIDC);
if(ASORVS_FirstLoad) then {
	lbClear _control;
	{
		_details = _x;
		if((count _details > 0) && (!((_details select DBF_Class) in ASORVS_RuntimeBlacklist)) && (_details call _additionalCheck)) then {
			_control lbAdd format["%1", (_details select DBF_Name)]; //Displayname on list
			_control lbSetData [(lbSize _control)-1,(_details select DBF_Class)]; //Data for index is classname
			if ((_details select DBF_Class) in _currentItem) then {
				_control lbSetCurSel (lbSize _control)-1;
			};
			_control lbSetValue [(lbSize _control)-1,(_details select DBF_Index)]; //index 
			_control lbSetPicture [(lbSize _control)-1,(_details select DBF_Picture)];
		};
	} forEach (_items);
}else{
	for [{_i = 0}, {_i < (lbSize _control)}, {_i = _i + 1}] do {
		if((_control lbData _i) in _currentItem) then {
			_control lbSetCurSel _i;
		};
	};
};
lbSort [_control, "ASC"];
for "_i" from 0 to ((lbSize _control) - 1) step 1 do {
	if((_control lbData _i) in _currentItem) then {
		_control lbSetCurSel _i;
	};
};
if((lbCurSel _control) == -1) then {
	_control lbSetCurSel 0;
};
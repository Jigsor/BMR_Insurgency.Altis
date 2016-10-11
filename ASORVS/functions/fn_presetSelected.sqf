#include "macro.sqf"
disableSerialization;

private["_uniformchecked", "_vestchecked", "_backpackchecked", "_slot","_loadout","_primary","_launcher","_handgun","_magazines","_uniform","_vest","_backpack","_items","_primitems","_secitems","_handgunitems","_uitems","_vitems","_bitems","_handle", "_oldBackpack", "_oldUniform", "_oldVest", "_oldHeadgear", "_oldGoggles", "_oldNV", "_oldRadio", "_oldRadios"];
waitUntil{isNil {ASORVS_loading_preset} };
_combo = ASORVS_getControl(ASORVS_Main_Display, ASORVS_preset_combo);
_slot = _combo lbValue (lbCurSel _combo);
if(_slot == -1) exitWith {};
_loadout = +(profileNamespace getVariable format["%1_gear_new_%2",ASORVS_VAS_Prefix, _slot]);
if(!ASORVS_ShowBackpack) then {
	_oldBackpack = call ASORVS_fnc_GetBackpack;
};
if(!ASORVS_ShowUniform) then {
	_oldUniform = call ASORVS_fnc_GetUniform;
};
if(!ASORVS_ShowVest) then {
	_oldVest = call ASORVS_fnc_GetUniform;
};
if(!ASORVS_ShowHeadgear) then {
	_oldHeadgear = call ASORVS_fnc_GetHeadgear;
};
if(!ASORVS_ShowGoggles) then {
	_oldGoggles = call ASORVS_fnc_GetGoggles;
};
if(!ASORVS_ShowNightvision) then {
	_oldNV = call ASORVS_fnc_GetNightvision;
};
if(ASORVS_DisableLoadingUniqueRadios) then {
	_oldRadio = call ASORVS_fnc_GetRadio;
	_oldRadios = [];
	{ if([_x] call ASORVS_fnc_IsRadio) then { _oldRadios = _oldRadios + [_x]; }; } forEach (call ASORVS_fnc_GetInventoryItems);
};

//[_loadout] call ASORVS_fnc_applyGearArray;
ASORVS_CurrentInventory = (_loadout call ASORVS_fnc_ApplyBlacklist);
ASORVS_BackpackCapacityChanged = true;
ASORVS_VestCapacityChanged = true;
ASORVS_UniformCapacityChanged = true;
ASORVS_WeightChanged = true;

//put weapon items in the form ["", "" ,""] and not [""]
_oldPrimaryWeaponItems = +call ASORVS_fnc_GetPrimaryWeaponItems;
_oldSecondaryWeaponItems = +call ASORVS_fnc_GetLauncherItems;
_oldHandgunItems = +call ASORVS_fnc_GetHandgunItems;

ASORVS_CurrentInventory set [GSVI_PrimaryItems, ["", "", ""]];
ASORVS_CurrentInventory set [GSVI_LauncherItems, ["", "", ""]];
ASORVS_CurrentInventory set [GSVI_HandgunItems, ["", "", ""]];
{
	if((_x != "") && !(isNil '_x')) then {
		[_x] call ASORVS_fnc_AddPrimaryWeaponItem;
	};
} forEach _oldPrimaryWeaponItems;
{
	if((_x != "") && !(isNil '_x')) then {
		[_x] call ASORVS_fnc_AddLauncherItem;
	};
} forEach _oldSecondaryWeaponItems;
{
	if((_x != "") && !(isNil '_x')) then {
		[_x] call ASORVS_fnc_AddHandgunItem;
	};
} forEach _oldHandgunItems;
if(!ASORVS_ShowBackpack) then {
	[_oldBackpack] call ASORVS_fnc_AddBackpack;
};
if(!ASORVS_ShowUniform) then {
	[_oldUniform] call ASORVS_fnc_AddUniform;
};
if(!ASORVS_ShowVest) then {
	[_oldVest] call ASORVS_fnc_AddVest;
};
if(!ASORVS_ShowHeadgear) then {
	[_oldHeadgear] call ASORVS_fnc_AddHeadgear;
};
if(!ASORVS_ShowGoggles) then {
	[_oldGoggles] call ASORVS_fnc_AddGoggles;
};
if(!ASORVS_ShowNightvision) then {
	[_oldNV] call ASORVS_fnc_AddNightvision;
};

if(ASORVS_DisableLoadingUniqueRadios) then {
	//equipped radio
	_loadedradiobase = [call ASORVS_fnc_GetRadio, true] call ASORVS_fnc_GetRadioClass;
	_oldRadioBase = [_oldRadio, true] call ASORVS_fnc_GetRadioClass;
	call ASORVS_fnc_RemoveRadio;
	if(_loadedradiobase == _oldRadioBase) then {
		[[_oldRadio, false] call ASORVS_fnc_GetRadioClass] call ASORVS_fnc_AddRadio;
	} else {
		[_loadedradiobase] call ASORVS_fnc_AddRadio;
	};
	//inventory radios
	_loadedRadios = [];
	{ 
		if([_x] call ASORVS_fnc_IsRadio) then { 
			[_x] call ASORVS_fnc_RemoveInventoryItem;
			_loadedradiobase = [_x, true] call ASORVS_fnc_GetRadioClass;
			_matchingRadio = "";
			for [{_i = 0}, {(_i < (count _oldRadios)) && (_matchingRadio == "")}, {_i = _i + 1}] do {
				if (_loadedradiobase == [_oldRadios select _i, true] call ASORVS_fnc_GetRadioClass) then {
					_matchingRadio = _oldRadios select _i;
					_oldRadios set [_i, "DEL"];
				};
			};
			_oldRadios = _oldRadios - ["DEL"];
			if(_matchingRadio == "") then {
				[_x] call ASORVS_fnc_AddInventoryItem;
			} else {
				//can keep the old ID
				[_matchingRadio] call ASORVS_fnc_AddInventoryItem;
			};
		}; 
	} forEach (call ASORVS_fnc_GetInventoryItems);
};
[_slot] call ASORVS_fnc_ReloadMainDialog;
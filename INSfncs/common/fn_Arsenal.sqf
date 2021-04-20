
#include "\A3\ui_f\hpp\defineDIKCodes.inc"
#include "\A3\Ui_f\hpp\defineResinclDesign.inc"

/*
INS_arsenal_content= [BMR_backpacks, BMR_items, BMR_magazines, BMR_weapons];
{
	_toAdd = INS_arsenal_content select _forEachIndex;
	_fnc = missionNamespace getVariable format [ "BIS_fnc_addVirtual%1Cargo", _x ];
	[INS_Wep_box, _toAdd, false, false ] call _fnc;
}forEach [ "backpack", "item", "magazine", "weapon" ];
*/

BMR_RemoveAllMagazines = {
	{player removeMagazine _x} forEach (magazines player);
	{
		_p= _x;
		{ _p removePrimaryWeaponItem _x} forEach (primaryWeaponMagazine _p);
		{ _p removeSecondaryWeaponItem _x} forEach (secondaryWeaponMagazine _p);
		{ _p removeHandgunItem _x } forEach (handgunMagazine _p);

	} forEach [player];
	systemChat 'Magazines removed';
};

BMR_fncLoadSave = {
	disableserialization;
	_display = _this # 0;
	_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
	_hideTemplate = true;
	_ctrlTemplateName = _display displayctrl IDC_RSCDISPLAYARSENAL_TEMPLATE_EDITNAME;

	['showMessage',[_display,format ['INS loadout: %1', ctrltext _ctrlTemplateName]]] call bis_fnc_arsenal;

	if (ctrlenabled _ctrlTemplateName) then {
		//--- Save
		[
			_center,
			[profilenamespace,ctrltext _ctrlTemplateName],
			[
				_center getvariable ["BIS_fnc_arsenal_face",face _center],
				speaker _center,
				_center call bis_fnc_getUnitInsignia
			]
		] call BMR_fnc_saveInventory;
	} else {
		//--- Load
		_ctrlTemplateValue = _display displayctrl IDC_RSCDISPLAYARSENAL_TEMPLATE_VALUENAME;
		if ((_ctrlTemplateValue lbvalue lnbcurselrow _ctrlTemplateValue) >= 0) then {
			_inventory = _ctrlTemplateValue lnbtext [lnbcurselrow _ctrlTemplateValue,0];
			[_center,[profilenamespace,_inventory]] call BMR_fnc_loadinventory;
			_center switchmove "";

			//--- Load custom data
			_ctrlTemplateValue = _display displayctrl IDC_RSCDISPLAYARSENAL_TEMPLATE_VALUENAME;
			_data = profilenamespace getvariable [BMRINS_profileSave,[]];
			_name = _ctrlTemplateValue lnbtext [lnbcurselrow _ctrlTemplateValue,0];
			_nameID = _data find _name;
			if (_nameID >= 0) then {
				_inventory = _data select (_nameID + 1);
				_inventoryCustom = _inventory select 10;
				_center setface (_inventoryCustom select 0);
				_center setvariable ["BIS_fnc_arsenal_face",(_inventoryCustom select 0)];
				_center setspeaker (_inventoryCustom select 1);
				[_center,_inventoryCustom select 2] call bis_fnc_setUnitInsignia;
			};

			["ListSelectCurrent",[_display]] call bis_fnc_arsenal;
		} else {
			_hideTemplate = false;
		};
	};
	if (_hideTemplate) then {
		_ctrlTemplate = _display displayctrl IDC_RSCDISPLAYARSENAL_TEMPLATE_TEMPLATE;
		_ctrlTemplate ctrlsetfade 1;
		_ctrlTemplate ctrlcommit 0;
		_ctrlTemplate ctrlenable false;

		_ctrlMouseBlock = _display displayctrl IDC_RSCDISPLAYARSENAL_MOUSEBLOCK;
		_ctrlMouseBlock ctrlenable false;
	};
};


BMR_fnc_loadinventory = {
	// modification of BIS_fnc_loadinventory
	/*
		Author: Karel Moricky

		Description:
		Add config defined inventory to an unit

		Parameter(s):
			0: OBJECT - object which will receive the loadout
			1:
				CONFIG - link to CfgVehicles soldier or to CfgRespawnInventory
				ARRAY in format [NAMESPACE or GROUP or OBJECT,STRING] - inventory saved using BIS_fnc_saveInventory
			2: ARRAY of STRINGs - config entries to be ignored (e.g. "weapons", "uniform", ...)

		Returns:
		BOOL
	*/

	#define DEFAULT_SLOT 0
	#define MUZZLE_SLOT 101
	#define OPTICS_SLOT 201
	#define FLASHLIGHT_SLOT 301
	#define FIRSTAIDKIT_SLOT 401
	#define FINS_SLOT 501
	#define BREATHINGBOMB_SLOT 601
	#define NVG_SLOT 602
	#define GOGGLE_SLOT 603
	#define SCUBA_SLOT 604
	#define HEADGEAR_SLOT 605
	#define UNIFORM_SLOT 801// just for DEBUG
	#define FACTOR_SLOT 607

	#define HMD_SLOT       616
	#define BINOCULAR_SLOT 617
	#define MEDIKIT_SLOT   619
	#define RADIO_SLOT    611

	#define VEST_SLOT      701
	#define BACKPACK_SLOT  901

	scopename _fnc_scriptName;
	private ["_cfg","_inventory","_isCfg","_blacklist"];
	_object = _this param [0,objnull,[objnull]];

	_cfg = _this param [1,configfile,[configfile,"",[]]];
	_inventory = [];
	switch (typename _cfg) do {
		case (typename ""): {
			_cfg = configfile >> "cfgvehicles" >> _cfg;
		};
		case (typename []): {
			if ({typename _x != typename ""} count _cfg == 0) then {
				_cfg = [_cfg,configfile] call bis_fnc_configpath;
			} else {
				if (count _cfg == 1) then {
					_inventory = _cfg select 0;
				} else {
					private ["_namespace","_name","_data","_nameID"];
					_namespace = _cfg param [0,missionnamespace,[missionnamespace,grpnull,objnull]];
					_name = _cfg param [1,"",[""]];
					_data = _namespace getvariable [BMRINS_profileSave,[]];
					_nameID = _data find _name;
					if (_nameID >= 0) then {
						_inventory = _data select (_nameID + 1);
						_cfg = [_inventory];
					} else {
						["Inventory '%1' not found",_name] call bis_fnc_error; breakout _fnc_scriptName;
					};
				};
			};
		};
	};
	_isCfg = count _inventory == 0;

	_blacklist = _this param [2,[],[[]]];
	{_blacklist set [_foreachindex,tolower _x];} foreach _blacklist;

	//--- Send to where the object is local (weapons can be changed only locally)
	if !(local _object) exitwith {[[_object,_cfg,_blacklist],_fnc_scriptName,_object] call bis_fnc_mp; false};

	//--- Process items
	private ["_items","_linkedItemsMisc","_vest","_headgear","_goggles"];
	_items = [];
	_linkedItemsMisc = [];
	_vest = "";
	_headgear = ""; //--- Added as assigned item
	_goggles = ""; //--- Added as assigned item
	if (_isCfg) then {
		_items = getarray (_cfg >> "items");
		_linkedItems = getarray (_cfg >> "linkedItems");
		_linkedItemsMisc = [];
		{
			_item = _x;
			if (typename _item == typename []) then {_item = _item call bis_fnc_selectrandom;};

			if (isclass (configfile >> "cfgglasses" >> _item)) then {
				_goggles = _item;
			} else {
				private ["_type"];
				_type = getnumber (configfile >> "cfgweapons" >> _item >> "iteminfo" >> "type");
				switch _type do {
					case VEST_SLOT: {_vest = _item;};
					case HEADGEAR_SLOT: {_headgear = _item;};
					//case GOGGLE_SLOT: {_goggles = _item;};
					default {_linkedItemsMisc set [count _linkedItemsMisc,_item];};
				};
			};
		} foreach _linkedItems;
	} else {
		_vest = _inventory select 1 select 0;
		_headgear = _inventory select 3;
		_goggles = _inventory select 4;
		//_linkedItemsMisc = (_inventory select 9) + (_inventory select 6 select 1) + (_inventory select 7 select 1) + (_inventory select 8 select 1);
		//--- Do isNil check because weaponAccessories command can return nil
		_linkedItemsMisc = (_inventory select 9);
		if (!isnil {_inventory select 6 select 1}) then {_linkedItemsMisc = _linkedItemsMisc + (_inventory select 6 select 1)} else {_linkedItemsMisc = _linkedItemsMisc + ["","",""];};
		if (!isnil {_inventory select 7 select 1}) then {_linkedItemsMisc = _linkedItemsMisc + (_inventory select 7 select 1)} else {_linkedItemsMisc = _linkedItemsMisc + ["","",""];};
		if (!isnil {_inventory select 8 select 1}) then {_linkedItemsMisc = _linkedItemsMisc + (_inventory select 8 select 1)} else {_linkedItemsMisc = _linkedItemsMisc + ["","",""];};
	};

	//--- Remove
	if !("uniform" in _blacklist) then {
		removeuniform _object;
	};
	if !("vest" in _blacklist) then {
		removevest _object;
	};
	if !("headgear" in _blacklist) then {
		removeheadgear _object;
	};
	if !("goggles" in _blacklist) then {
		removegoggles _object;
	};
	if !("backpack" in _blacklist) then {
		removebackpack _object;
	};
	if !("items" in _blacklist) then {
		removeallitems _object;
	};
	if !("linkeditems" in _blacklist) then
	{
		private["_headgear","_goggles"];

		//store headgear & goggles to prevent uncontrolled removal
		_headgear = headgear _object;
		_goggles = goggles _object;

		removeallassigneditems _object;

		//re-store headgear & goggles
		if (_headgear != "") then
		{
			_object addheadgear _headgear;
		};
		if (_goggles != "") then
		{
			_object addgoggles _goggles;
		};
	};
	if !("weapons" in _blacklist) then {
		removeallweapons _object;
	};
	if !("transportMagazines" in _blacklist) then {
		if (count (getmagazinecargo _object select 0) > 0) then {clearmagazinecargoglobal _object;};
	};
	if !("transportWeapons" in _blacklist) then {
		if (count (getweaponcargo _object select 0) > 0) then {clearweaponcargoglobal _object;};
	};
	if !("transportItems" in _blacklist) then {
		if (count (getitemcargo _object select 0) > 0) then {clearitemcargoglobal _object;};
	};

	//--- Add
	if !("uniform" in _blacklist) then {
		private ["_uniform"];
		_uniform = "";
		if (_isCfg) then {
			_uniform = _cfg >> "uniformClass";
			_uniform = if (isarray _uniform) then {(getarray _uniform) call bis_fnc_selectrandom} else {gettext _uniform};
		} else {
			_uniform = _inventory select 0 select 0;
		};
		if (_uniform != "") then {
			if (isclass (configfile >> "cfgWeapons" >> _uniform)) then {
				_object forceadduniform _uniform;
			} else {
				["Uniform '%1' does not exist in CfgWeapons",_uniform] call bis_fnc_error;
			};
		};
	};
	if !("vest" in _blacklist) then {
		if (_vest != "") then {
			if (isclass (configfile >> "cfgWeapons" >> _vest)) then {
				_object addvest _vest;
			} else {
				["Vest '%1' does not exist in CfgWeapons",_vest] call bis_fnc_error;
			};
		};
	};
	if !("headgear" in _blacklist) then {
		if (_headgear != "") then {
			if (isclass (configfile >> "cfgWeapons" >> _headgear)) then {
				_object addheadgear _headgear;
			} else {
				["Headgear '%1' does not exist in CfgWeapons",_headgear] call bis_fnc_error;
			};
		};
	};
	if !("goggles" in _blacklist) then {
		if (_goggles != "") then {
			if (isclass (configfile >> "cfgGlasses" >> _goggles)) then {
				_object addgoggles _goggles;
			} else {
				["Goggles '%1' does not exist in CfgGlasses",_goggles] call bis_fnc_error;
			};
		};
	};
	if !("backpack" in _blacklist) then {
		private ["_backpack"];
		_backpack = "";
		if (_isCfg) then {
			_backpack = _cfg >> "backpack";
			_backpack = if (isarray _backpack) then {(getarray _backpack) call bis_fnc_selectrandom} else {gettext _backpack};
		} else {
			_backpack = _inventory select 2 select 0;
		};
		if (_backpack == "") then {
			// Unit has no backpack
			removeBackpack _object;
		} else {
			if (isclass (configfile >> "cfgVehicles" >> _backpack)) then {
				_object addbackpack _backpack;

				// Default backpacks have default loadouts. Must be cleared if not loaded from config.
				if (!(_isCfg)) then {clearAllItemsFromBackpack _object};
			} else {
				["Backpack '%1' does not exist in CfgVehicles",_backpack] call bis_fnc_error;
			};
		};
	};
	if !("magazines" in _blacklist) then {
		if (_isCfg) then {
			private ["_magazines"];
			_magazines = getarray (_cfg >> "magazines");
			{
				if (_x != "") then {
					_magazine = _x;
					if (typename _magazine == typename []) then {_magazine = _magazine call bis_fnc_selectrandom;};
					_object addmagazine _magazine;
				};
			} foreach _magazines;
		} else {
			//--- Add magazines to be loaded in weapons by default
			if ({!isnil "_x"} count (_inventory select 6) > 2) then {
				{
					if (_x != "") then {_object addmagazine _x;};
				} foreach [_inventory select 6 select 2,_inventory select 7 select 2,_inventory select 8 select 2];
			};
		};
	};
	if !("weapons" in _blacklist) then {
		private ["_weapons"];
		_weapons = if (_isCfg) then {getarray (_cfg >> "weapons")} else {[_inventory select 5,_inventory select 6 select 0,_inventory select 7 select 0,_inventory select 8 select 0]};
		{
			if (_x != "") then {
				_weapon = _x;
				if (typename _weapon == typename []) then {_weapon = _weapon call bis_fnc_selectrandom;};
				_object addweapon _weapon;
			};
		} foreach _weapons;
	};
	if !(_isCfg) then {
		//--- Add container items (only after weapons were added together with their default magazines)
		if !("uniform" in _blacklist) then {{_object additemtouniform _x;} foreach (_inventory select 0 select 1);};
		if !("vest" in _blacklist) then {{_object additemtovest _x;} foreach (_inventory select 1 select 1);};
		if !("backpack" in _blacklist) then {{_object additemtobackpack _x;} foreach (_inventory select 2 select 1);};
	};
	if !("transportMagazines" in _blacklist) then {
		if (_isCfg) then {
			private ["_transportMagazines"];
			_transportMagazines = [];
			{
				_transportMagazines set [count _transportMagazines,[gettext (_x >> "magazine"),getnumber (_x >> "count")]];
			} foreach ([_cfg >> "transportMagazines"] call bis_fnc_subclasses);
			{
				if ((_x select 0) != "") then {
					_object addmagazinecargoglobal _x;
				};
			} foreach _transportMagazines;
		};
	};
	if !("items" in _blacklist) then {
		{
			if (_x != "") then {
				_object additem _x;
			};
		} foreach _items;
	};
	if !("linkeditems" in _blacklist) then {
		{
			if (_x != "") then {
				_object linkitem _x;
				_object addPrimaryWeaponItem _x;
				_object addSecondaryWeaponItem _x;
				_object addHandgunItem _x;
			};
		} foreach _linkedItemsMisc;
	};
	if !("transportWeapons" in _blacklist) then {
		if (_isCfg) then {
			private ["_transportWeapons"];
			_transportWeapons = [];
			{
				_transportWeapons set [count _transportWeapons,[gettext (_x >> "weapon"),getnumber (_x >> "count")]];
			} foreach ([_cfg >> "transportWeapons"] call bis_fnc_subclasses);
			{
				if ((_x select 0) != "") then {
					_object addweaponcargoglobal _x;
				};
			} foreach _transportWeapons;
		};
	};
	if !("transportItems" in _blacklist) then {
		if (_isCfg) then {
			private ["_transportItems"];
			_transportItems = [];
			{
				_transportItems set [count _transportItems,[gettext (_x >> "name"),getnumber (_x >> "count")]];
			} foreach ([_cfg >> "transportItems"] call bis_fnc_subclasses);
			{
				if ((_x select 0) != "") then {
					_object additemcargoglobal _x;
				};
			} foreach _transportItems;
		};
	};
	true
};


BMR_fnc_saveInventory = {
	// modification of BIS_fnc_saveInventory
	//systemchat 'BMR_fnc_saveInventory';
	/*
		Author: Karel Moricky

		Description:
		Save unit's loadout

		Parameter(s):
			0: OBJECT - unit of which loadout will be saved
			1: ARRAY in format
				0: NAMESPACE or GROUP or OBJECT - target in which namespace the loadout will be saved
				1: STRING - loadout name
			2 (Optional): ARRAY - custom params to be saved along the loadout (default: [])
			3 (Optional): BOOL - true to delete the loadout (default: false)

		Returns:
		ARRAY - saved value
	*/
	private ["_center","_path","_custom","_delete","_namespace","_name"];
	_center = _this param [0,player,[objnull]];
	_path = _this param [1,[],[[]]];
	_custom = _this param [2,[],[[]]];
	_delete = _this param [3,false,[false]];

	_namespace = _path param [0,missionnamespace,[missionnamespace,grpnull,objnull]];
	_name = _path param [1,"",[""]];

	//--- Get magazines loaded to weapons
	private ["_primaryWeaponMagazine","_secondaryWeaponMagazine","_handgunMagazine"];
	_primaryWeaponMagazine = "";
	_secondaryWeaponMagazine = "";
	_handgunMagazine = "";
	{
		if (count _x > 4 && {typename (_x select 4) == typename []}) then {
			private ["_weapon","_magazine"];
			_weapon = _x select 0;
			_magazine = _x select 4 select 0;
			if !(isnil "_magazine") then {
				switch _weapon do {
					case (primaryweapon _center): {_primaryWeaponMagazine = _magazine;};
					case (secondaryweapon _center): {_secondaryWeaponMagazine = _magazine;};
					case (handgunweapon _center): {_handgunMagazine = _magazine;};
				};
			};
		};
	} foreach weaponsitems _center;

	//--- Get current values
	private ["_export"];
	_export = [
		/* 00 */	[uniform _center,uniformitems _center],
		/* 01 */	[vest _center,vestitems _center],
		/* 02 */	[backpack _center,backpackitems _center],
		/* 03 */	headgear _center,
		/* 04 */	goggles _center,
		/* 05 */	binocular _center,
		/* 06 */	[primaryweapon _center call bis_fnc_baseWeapon,_center weaponaccessories primaryweapon _center,_primaryWeaponMagazine],
		/* 07 */	[secondaryweapon _center call bis_fnc_baseWeapon,_center weaponaccessories secondaryweapon _center,_secondaryWeaponMagazine],
		/* 08 */	[handgunweapon _center call bis_fnc_baseWeapon,_center weaponaccessories handgunweapon _center,_handgunMagazine],
		/* 09 */	assigneditems _center - [binocular _center],
		/* 10 */	_custom
	];

	//--- Store
	private ["_data","_nameID"];
	_data = _namespace getvariable [BMRINS_profileSave,[]];
	_nameID = _data find _name;
	if (_delete) then {
		if (_nameID >= 0) then {
			_data set [_nameID,objnull];
			_data set [_nameID + 1,objnull];
			_data = _data - [objnull];
		};
	} else {
		if (_nameID < 0) then {
			_nameID = count _data;
			_data set [_nameID,_name];
		};
		_data set [_nameID + 1,_export];
	};
	_namespace setvariable [BMRINS_profileSave,_data];
	profilenamespace setvariable ["bis_fnc_saveInventory_profile",true];
	if !(isnil {profilenamespace getvariable "bis_fnc_saveInventory_profile"}) then {saveprofilenamespace};

	_export
};


#define GETVIRTUALCARGO\
	_virtualItemCargo =\
		(missionnamespace call bis_fnc_getVirtualItemCargo) +\
		(_cargo call bis_fnc_getVirtualItemCargo) +\
		items _center +\
		assigneditems _center +\
		primaryweaponitems _center +\
		secondaryweaponitems _center +\
		handgunitems _center +\
		[uniform _center,vest _center,headgear _center,goggles _center];\
	_virtualWeaponCargo = [];\
	{\
		_weapon = _x call bis_fnc_baseWeapon;\
		_virtualWeaponCargo set [count _virtualWeaponCargo,_weapon];\
		{\
			private ["_item"];\
			_item = gettext (_x >> "item");\
			if !(_item in _virtualItemCargo) then {_virtualItemCargo set [count _virtualItemCargo,_item];};\
		} foreach ((configfile >> "cfgweapons" >> _x >> "linkeditems") call bis_fnc_returnchildren);\
	} foreach ((missionnamespace call bis_fnc_getVirtualWeaponCargo) + (_cargo call bis_fnc_getVirtualWeaponCargo) + weapons _center + [binocular _center]);\
	_virtualMagazineCargo = (missionnamespace call bis_fnc_getVirtualMagazineCargo) + (_cargo call bis_fnc_getVirtualMagazineCargo) + magazines _center;\
	_virtualBackpackCargo = (missionnamespace call bis_fnc_getVirtualBackpackCargo) + (_cargo call bis_fnc_getVirtualBackpackCargo) + [backpack _center];

#define CONDITION(LIST)	(_fullVersion || {"%ALL" in LIST} || {{_item == _x} count LIST > 0})

BMR_fnc_showTemplates = {
	_display = _this select 0;
	_ctrlTemplateValue = _display displayctrl IDC_RSCDISPLAYARSENAL_TEMPLATE_VALUENAME;
	lnbclear _ctrlTemplateValue;
	_data = profilenamespace getvariable [BMRINS_profileSave,[]];
	_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
	_cargo = (missionnamespace getvariable ["BIS_fnc_arsenal_cargo",objnull]);

	GETVIRTUALCARGO

	for "_i" from 0 to (count _data - 1) step 2 do {
		_name = _data select _i;
		_inventory = _data select (_i + 1);

		_inventoryWeapons = [
			(_inventory select 5), //--- Binocular
			(_inventory select 6 select 0), //--- Primary weapon
			(_inventory select 7 select 0), //--- Secondary weapon
			(_inventory select 8 select 0) //--- Handgun
		] - [""];
		_inventoryMagazines = (
			(_inventory select 0 select 1) + //--- Uniform
			(_inventory select 1 select 1) + //--- Vest
			(_inventory select 2 select 1) //--- Backpack items
		) - [""];
		_inventoryItems = (
			[_inventory select 0 select 0] + (_inventory select 0 select 1) + //--- Uniform
			[_inventory select 1 select 0] + (_inventory select 1 select 1) + //--- Vest
			(_inventory select 2 select 1) + //--- Backpack items
			[_inventory select 3] + //--- Headgear
			[_inventory select 4] + //--- Goggles
			(_inventory select 6 select 1) + //--- Primary weapon items
			(_inventory select 7 select 1) + //--- Secondary weapon items
			(_inventory select 8 select 1) + //--- Handgun items
			(_inventory select 9) //--- Assigned items
		) - [""];
		_inventoryBackpacks = [_inventory select 2 select 0] - [""];

		_lbAdd = _ctrlTemplateValue lnbaddrow [_name];
		_ctrlTemplateValue lnbsetpicture [[_lbAdd,1],gettext (configfile >> "cfgweapons" >> (_inventory select 6 select 0) >> "picture")];
		_ctrlTemplateValue lnbsetpicture [[_lbAdd,2],gettext (configfile >> "cfgweapons" >> (_inventory select 7 select 0) >> "picture")];
		_ctrlTemplateValue lnbsetpicture [[_lbAdd,3],gettext (configfile >> "cfgweapons" >> (_inventory select 8 select 0) >> "picture")];
		_ctrlTemplateValue lnbsetpicture [[_lbAdd,4],gettext (configfile >> "cfgweapons" >> (_inventory select 0 select 0) >> "picture")];
		_ctrlTemplateValue lnbsetpicture [[_lbAdd,5],gettext (configfile >> "cfgweapons" >> (_inventory select 1 select 0) >> "picture")];
		_ctrlTemplateValue lnbsetpicture [[_lbAdd,6],gettext (configfile >> "cfgvehicles" >> (_inventory select 2 select 0) >> "picture")];
		_ctrlTemplateValue lnbsetpicture [[_lbAdd,7],gettext (configfile >> "cfgweapons" >> (_inventory select 3) >> "picture")];
		_ctrlTemplateValue lnbsetpicture [[_lbAdd,8],gettext (configfile >> "cfgglasses" >> (_inventory select 4) >> "picture")];

		if (
			{_item = _x; !CONDITION(_virtualWeaponCargo) || !isclass(configfile >> "cfgweapons" >> _item)} count _inventoryWeapons > 0
			||
			{_item = _x; !CONDITION(_virtualItemCargo + _virtualMagazineCargo) || {isclass(configfile >> _x >> _item)} count ["cfgweapons","cfgglasses","cfgmagazines"] == 0} count _inventoryMagazines > 0
			||
			{_item = _x; !CONDITION(_virtualItemCargo + _virtualMagazineCargo) || {isclass(configfile >> _x >> _item)} count ["cfgweapons","cfgglasses","cfgmagazines"] == 0} count _inventoryItems > 0
			||
			{_item = _x; !CONDITION(_virtualBackpackCargo) || !isclass(configfile >> "cfgvehicles" >> _item)} count _inventoryBackpacks > 0
		) then {
			_ctrlTemplateValue lnbsetcolor [[_lbAdd,0],[1,1,1,0.25]];
			_ctrlTemplateValue lbsetvalue [_lbAdd,-1];
		};
	};
	_ctrlTemplateValue lnbsort [0,false];

	["templateSelChanged",[_display]] call bis_fnc_arsenal;
};


BMR_fnc_buttonSave = {
	_display = _this # 0;
	[_display] call BMR_fnc_showTemplates;

	_ctrlTemplate = _display displayctrl IDC_RSCDISPLAYARSENAL_TEMPLATE_TEMPLATE;
	_ctrlTemplate ctrlsetfade 0;
	_ctrlTemplate ctrlcommit 0;
	_ctrlTemplate ctrlenable true;

	_ctrlMouseBlock = _display displayctrl IDC_RSCDISPLAYARSENAL_MOUSEBLOCK;
	_ctrlMouseBlock ctrlenable true;

	{
		(_display displayctrl _x) ctrlsettext localize "str_disp_int_save";
	} foreach [IDC_RSCDISPLAYARSENAL_TEMPLATE_TITLE,IDC_RSCDISPLAYARSENAL_TEMPLATE_BUTTONOK];
	{
		_ctrl = _display displayctrl _x;
		_ctrl ctrlshow true;
		_ctrl ctrlenable true;
	} foreach [IDC_RSCDISPLAYARSENAL_TEMPLATE_TEXTNAME,IDC_RSCDISPLAYARSENAL_TEMPLATE_EDITNAME];

	_ctrlTemplateName = _display displayctrl IDC_RSCDISPLAYARSENAL_TEMPLATE_EDITNAME;
	ctrlsetfocus _ctrlTemplateName;

	_ctrlTemplateValue = _display displayctrl IDC_RSCDISPLAYARSENAL_TEMPLATE_VALUENAME;
	_ctrlTemplateButtonOK = _display displayctrl IDC_RSCDISPLAYARSENAL_TEMPLATE_BUTTONOK;
	_ctrlTemplateButtonOK ctrlenable true;
	_ctrlTemplateButtonDelete = _display displayctrl IDC_RSCDISPLAYARSENAL_TEMPLATE_BUTTONDELETE;
	_ctrlTemplateButtonDelete ctrlenable ((lnbsize _ctrlTemplateValue select 0) > 0);

	['showMessage',[_display,localize "STR_A3_RscDisplayArsenal_message_save"]] call BIS_fnc_arsenal;
};

BMR_fnc_buttonLoad = {
	_display = _this # 0;
	_ctrlTemplate = _display displayctrl IDC_RSCDISPLAYARSENAL_TEMPLATE_TEMPLATE;
	_ctrlTemplate ctrlsetfade 0;
	_ctrlTemplate ctrlcommit 0;
	_ctrlTemplate ctrlenable true;
	_ctrlMouseBlock = _display displayctrl IDC_RSCDISPLAYARSENAL_MOUSEBLOCK;
	_ctrlMouseBlock ctrlenable true;
	ctrlsetfocus _ctrlMouseBlock;
	{
		(_display displayctrl _x) ctrlsettext localize "str_disp_int_load";
	} foreach [IDC_RSCDISPLAYARSENAL_TEMPLATE_TITLE,IDC_RSCDISPLAYARSENAL_TEMPLATE_BUTTONOK];
	{
		_ctrl = _display displayctrl _x;
		_ctrl ctrlshow false;
		_ctrl ctrlenable false;
	} foreach [IDC_RSCDISPLAYARSENAL_TEMPLATE_TEXTNAME,IDC_RSCDISPLAYARSENAL_TEMPLATE_EDITNAME];
	_ctrlTemplateValue = _display displayctrl IDC_RSCDISPLAYARSENAL_TEMPLATE_VALUENAME;
	if (lnbcurselrow _ctrlTemplateValue < 0) then {_ctrlTemplateValue lnbsetcurselrow 0;};
	ctrlsetfocus _ctrlTemplateValue;
};

BMR_fnc_buttonTemplateDelete = {
	_display = _this # 0;
	_ctrlTemplateValue = _display displayctrl IDC_RSCDISPLAYARSENAL_TEMPLATE_VALUENAME;
	_cursel = lnbcurselrow _ctrlTemplateValue;
	_name = _ctrlTemplateValue lnbtext [_cursel,0];

	[_center,[profilenamespace,_name],nil,true] call BMR_fnc_saveInventory;
	[_display] call BMR_fnc_showTemplates;
	_ctrlTemplateValue lnbsetcurselrow (_cursel max (lbsize _ctrlTemplateValue - 1));
	["templateSelChanged",[_display]] call bis_fnc_arsenal;
};


[missionNamespace, "arsenalOpened", {

	disableSerialization;
	params ["_display"];

	//enter block
	//allow ESC UP DOWN BACKSPACE AND DEL
	_display displayAddEventHandler ["keydown", "if !((_this select 1) in [1,200,208,14,211]) then {true};"];
	_c = _display displayctrl IDC_RSCDISPLAYARSENAL_CONTROLSBAR_BUTTONSAVE;
	_c ctrlRemoveAllEventHandlers "buttonclick";
	_c ctrlSetText ('INS '+ctrlText _c);
	_c ctrlSetBackgroundColor [0.6, 1, 0, 0.5 ];
	_c ctrlSetTextColor [0, 0, 0, 1];
	_c ctrladdeventhandler ["buttonclick","[ctrlparent (_this select 0)] call BMR_fnc_showTemplates; [ctrlparent (_this select 0)] call BMR_fnc_buttonSave;"];

	_c = _display displayctrl IDC_RSCDISPLAYARSENAL_CONTROLSBAR_BUTTONLOAD;
	_c ctrlRemoveAllEventHandlers "buttonclick";
	_c ctrlSetText ('INS '+ctrlText _c);
	_c ctrlSetBackgroundColor [1, 0.6, 0, 0.5 ];
	_c ctrlSetTextColor [0, 0, 0, 1];
	_c ctrladdeventhandler ["buttonclick","[ctrlparent (_this select 0)] call BMR_fnc_showTemplates; [ctrlparent (_this select 0)] call BMR_fnc_buttonLoad;"];

	_c = _display displayCtrl IDC_RSCDISPLAYARSENAL_TEMPLATE_BUTTONOK;
	_c ctrlRemoveAllEventHandlers "buttonclick";
	_c ctrlSetText ('INS '+ctrlText _c);
	_c ctrlSetBackgroundColor [1, 1, 0, 0.5 ];
	_c ctrlSetTextColor [0, 0, 0, 1];
	_c ctrladdeventhandler ["buttonclick","[ctrlparent (_this select 0)] call BMR_fncLoadSave; "];

	_c = _display displayctrl IDC_RSCDISPLAYARSENAL_TEMPLATE_BUTTONDELETE;
	_c ctrlRemoveAllEventHandlers "buttonclick";
	_c ctrladdeventhandler ["buttonclick","[ctrlparent (_this select 0)] call BMR_fnc_buttonTemplateDelete;"];

	_c = _display displayCtrl IDC_RSCDISPLAYARSENAL_TEMPLATE_VALUENAME;
	_c ctrlRemoveAllEventHandlers "LBDblClick";

	_c = _display displayctrl IDC_RSCDISPLAYARSENAL_CONTROLSBAR_BUTTONIMPORT;
	_c ctrlEnable  true;
	_c ctrlRemoveAllEventHandlers "buttonclick";
	_c ctrlSetBackgroundColor [1, 0, 0, 0.5 ];
	_c ctrlAddEventHandler ["buttonclick", { call BMR_RemoveAllMagazines}];
	_c ctrlSetText 'Clear (M)';

	(_display displayctrl IDC_RSCDISPLAYARSENAL_CONTROLSBAR_BUTTONRANDOM) ctrlEnable  true;

}] call BIS_fnc_addScriptedEventHandler;
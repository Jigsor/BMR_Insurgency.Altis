// // // // // // // // // // // // // // // // // // // // // // // // // // // // //
// Mine Detector Script
// Version alpha 0.6
// Date: 2015.02.27
// Author: Lala14
// // // // // // // // // // // // // // // // // // // // // // // // // // // // //

// init line:
// null = [] execVM "minedetector.sqf";
/*Definable Start*/
MDMineDetectorAction = 1; //1 means player has to use an addaction to use the minedetector otherwise it won't work, 0 = player doesnt need an addaction and it is always on
MDMineDetectorWalkOnly = 1; //Requires MDMineDetectorAction = 1, Forces when the addAction is on that the player will be forced to work (if is already forced walk then the action will not un force walk the player)
MDMineDetectorVisualise = 1; //Requires MDMineDetectorAction =1, Makes the player hold a minedetector when using it
/*Definable End*/
waitUntil {!isNull player};

// config [ ["kindOf AMMO classnames",pitch multiplier(noise),distance multiplier (noise),"kindOf cfgVehicles classnames"] ]
if (isNil "MDLala_Config") then { MDLala_Config = [] };
MDLala_Config = MDLala_Config + [
	["SafeGaurdForMods",14,5,"Unknown"],
	["ATMine_Range_Ammo",14,5,"ATMine"],
	["APERSMine_Range_Ammo",14,5,"APERSMine"],
	["APERSTripMine_Wire_Ammo",14,5,"APERSTripMine"],
	["APERSBoundingMine_Range_Ammo",9,10,"APERSBoundingMine"],
	["SLAMDirectionalMine_Wire_Ammo",14,5,"SLAMDirectionalMine"],
	["ClaymoreDirectionalMine_Remote_Ammo",14,5,"Claymore_F"],
	["DemoCharge_Remote_Ammo",14,5,"DemoCharge_F"],
	["SatchelCharge_Remote_Ammo",14,5,"SatchelCharge_F"],
	["UnderwaterMine_Range_Ammo",14,5,"UnderwaterMine"],
	["UnderwaterMineAB_Range_Ammo",14,5,"UnderwaterMineAB"],
	["UnderwaterMinePDM_Range_Ammo",14,5,"UnderwaterMinePDM"],
	["IEDUrbanSmall_Remote_Ammo",14,5,"IEDUrbanSmall_F"],
	["IEDLandSmall_Remote_Ammo",14,5,"IEDLandSmall_F"],
	["IEDUrbanBig_Remote_Ammo",14,5,"IEDUrbanBig_F"],
	["IEDLandBig_Remote_Ammo",14,5,"IEDLandBig_F"]
];

MDLALA_fnc_in_List = {
	private _indexno = 0;

	{
		if ((_x select 0) isEqualTo _this) then
		{
			_indexno = _forEachIndex;
		};
	}forEach MDLala_Config;
	_indexno
};

MDLALA_fnc_Condition_Detect = {
	params ["_unit"];
	private _mine = [];

	//nearestObjects [_unit, ["MineBase","MineGeneric"],10]; <--- not working :D
	//"ATMine","APERSMine","APERSTripMine","APERSBoundingMine","SLAMDirectionalMine","Claymore_F","DemoCharge_F","SatchelCharge_F","UnderwaterMine","UnderwaterMineAB","UnderwaterMinePDM","IEDUrbanSmall_F","IEDLandSmall_F","IEDUrbanBig_F","IEDLandBig_F"
	if (nearestObject [_unit, "TimeBombCore"] distance _unit < nearestObject [_unit, "MineBase"] distance _unit) then {_mine = [nearestObject [_unit, "TimeBombCore"]];};
	if (nearestObject [_unit, "TimeBombCore"] distance _unit > nearestObject [_unit, "MineBase"] distance _unit) then {_mine = [nearestObject [_unit, "MineBase"]];};

	if (_mine isEqualTo [] OR {_mine select 0 distance _unit > 10}) then {_mine = _unit nearObjects ["TimeBombCore", 10];}; //these are innaccurate but may prove worthy
	if (_mine isEqualTo [] OR {_mine select 0 distance _unit > 10}) then {_mine = _unit nearObjects ["MineBase", 10];}; //these are innaccurate but may prove worthy
	if (typeof (nearestObject [_unit, "TimeBombCore"]) == "APERSBoundingMine_Range_Ammo" && _unit distance (nearestObject [_unit, "TimeBombCore"]) < 6) then {_mine = [nearestObject [_unit, "TimeBombCore"]]}; //override for this mine since it's set off radius is 5m
	_mine;
};

MDLALA_fnc_Mine_Noise = {
	private ["_unit","_missiondir","_timesleep","_pitch","_minedo"];
	_unit = _this select 0;
	if (!alive _unit OR isNull _unit) exitWith {};
	_action = _this select 1;
	if (count _this < 2) then {_action = false;};
	_missiondir = call { private _arr = toArray str missionConfigFile; _arr resize (count _arr - 15); toString _arr };
	_timesleep = 5;
	_pitch = 5;


	waitUntil{"MineDetector" in items _unit && count ([_unit] call MDLALA_fnc_Condition_Detect) > 0};

	while {(([_unit] call MDLALA_fnc_Condition_Detect select 0) distance _unit) < 10} do
	{
		if (!("MineDetector" in items _unit) OR (vehicle _unit != _unit) OR !(alive _unit)) exitWith {};
		_minetype = typeOf ([_unit] call MDLALA_fnc_Condition_Detect select 0);
		_minename = getText (configFile >> "cfgVehicles" >> (MDLala_Config select (_minetype call MDLALA_fnc_in_List) select 3) >> "displayName");
		_distance = ([_unit] call MDLALA_fnc_Condition_Detect select 0) distance _unit;

		_pitch = (MDLala_Config select (_minetype call MDLALA_fnc_in_List) select 1) - _distance;
		_timesleep = (_distance / (MDLala_Config select (_minetype call MDLALA_fnc_in_List) select 2));

		hintSilent format ["Mine = %4\nDistance = %1\nTime Until Next Beep =  %2\nPitch = %3",_distance,_timesleep,_pitch,_minename];
		playSound3D ["A3\UI_F\data\sound\CfgNotifications\addItemOk.wss",_unit,false,[getPosASL _unit select 0,getPosASL _unit select 1,(getPosASL _unit select 2) + 1],100,_pitch,5];
		sleep _timesleep;
	};

	if (_action) then
	{
		_minedo = [_unit,true,(_this select 2)] spawn MDLALA_fnc_Mine_Noise;
		_unit setVariable ["MineDetectorStart",_minedo,true];
	} else {
		[_unit] spawn MDLALA_fnc_Mine_Noise;
	};
};

MDLALA_fnc_returnAttachedObjects = {
	params ["_array","_item"];
	_found = false;

	{
		if (_item == typeOf _x) exitWith {_found = true};
	}forEach _array;
	_found;
};

MDLALA_fnc_visualMineDetector = {
	params ["_unit"];

	if ([attachedObjects _unit,"Item_MineDetector"] call MDLALA_fnc_returnAttachedObjects) exitWith {};

	_unit switchMove "AmovPercMstpSrasWrflDnon_AmovPercMstpSrasWpstDnon_end";
	private _visualiseDetector = createVehicle ["Item_MineDetector", (getPosATL _unit), [], 0, "NONE"];
	_visualiseDetector attachTo [_unit, [0.01, 0, 0.6], "LeftHandMiddle1"];
	waitUntil {isNil {_unit getVariable "MineDetectorStart"}};
	deleteVehicle _visualiseDetector;
	_unit switchMove "AmovPercMstpSrasWrflDnon_AmovPercMstpSrasWpstDnon_end";
};

MDLALA_fnc_MineDetector_selectAction = {
	params ["_unit","_action","_actionid","_minedo"];
	if (!isNull objectParent _unit) exitWith {hintSilent "You must be on foot or in water to Deploy Mine Detector"};
	private _walkingalready = _unit getVariable ["MineDetectorWalk",false];

	if (isForcedWalk _unit && !_walkingalready) then {_unit setVariable ["MineDetectorWalking",isForcedWalk _unit,true];};

	if (_action && !_walkingalready) then {
		_unit setUserActionText [_actionid,("<t color='#FF0000'>") + (localize 'STR_BMR_StopMineDetector') + "</t>"];
		if (MDMineDetectorWalkOnly isEqualTo 1) then {
			_unit forceWalk true;
		};
		_unit setVariable ["MineDetectorWalk",true,true];
		_minedo = [_unit,true,_actionid] spawn MDLALA_fnc_Mine_Noise;
		_unit setVariable ["MineDetectorStart",_minedo,true];
		if (MDMineDetectorVisualise isEqualTo 1) then {
			[_unit] spawn MDLALA_fnc_visualMineDetector;
		};
	} else {
	_unit setUserActionText [_actionid,("<t color='#12F905'>") + (localize 'STR_BMR_UseMineDetector') + "</t>"];
		if (isNil {_unit getVariable "MineDetectorWalking"}) then {
			_unit forceWalk false;
		};
	_unit setVariable ["MineDetectorWalk",false,true];
	_unit setVariable ["MineDetectorWalking",nil,true];
	terminate (_unit getVariable "MineDetectorStart");
	_unit setVariable ["MineDetectorStart",nil,true];
	};
};

MDLALA_fnc_MineDetector_addAction = {
	params ["_unit"];
	if (isNil {_unit getVariable "MDMineDetectorActions"}) then {
		_unit addAction [("<t color='#12F905'>") + (localize 'STR_BMR_UseMineDetector') + "</t>",{[(_this select 0),true,(_this select 2)] spawn MDLALA_fnc_MineDetector_selectAction;}, [], 0, false, true, "", '"MineDetector" in items _target'];
		_unit setVariable ["MDMineDetectorActions",true,true]
	};
};

sleep 0.1;
if (MDMineDetectorAction isEqualTo 1) then
{
	[player] spawn MDLALA_fnc_MineDetector_addAction;
	player addEventHandler ["Respawn",{ (_this select 0) setVariable ["MDMineDetectorActions",nil,true]; [(_this select 0)] spawn MDLALA_fnc_MineDetector_addAction; }];
} else {
	[player] spawn MDLALA_fnc_Mine_Noise;
	player addEventHandler ["Respawn",{ [(_this select 0)] spawn MDLALA_fnc_Mine_Noise;} ];
};
//systemChat "Mine Detector: Initialized";
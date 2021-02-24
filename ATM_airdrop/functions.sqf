///////////////////////////////////////////////////////////
//                =ATM= Airdrop       	 				 //
//         		 =ATM=Pokertour        		       		 //
//				version : 6.0							 //
//				date : 12/02/2014						 //
//                   visit us : atmarma.fr               //
///////////////////////////////////////////////////////////

fnc_alt_onsliderchange={
	private["_dialog","_text","_value"];
	disableSerialization;

	_dialog = findDisplay 2900;
	_text = _dialog displayCtrl 2902;
	_value = _this select 0;

	Altitude = round(_value);
	_text ctrlSetText format["%1", round(_value)];
};

pkChangeKey={
	_index = lbCurSel 2903;
	switch _index do {
		case 0:{};//Fr Keyboard
		case 1:{ATMkeys=16};//A
		case 2:{ATMkeys=48};//B
		case 3:{ATMkeys=46};//C
		case 4:{ATMkeys=32};//D
		case 5:{ATMkeys=18};//E
		case 6:{ATMkeys=33};//F
		case 7:{ATMkeys=34};//G
		case 8:{ATMkeys=35};//H
		case 9:{ATMkeys=23};//I
		case 10:{ATMkeys=36};//J
		case 11:{ATMkeys=37};//K
		case 12:{ATMkeys=38};//L
		case 13:{ATMkeys=39};//M
		case 14:{ATMkeys=49};//N
		case 15:{ATMkeys=24};//O
		case 16:{ATMkeys=25};//P
		case 17:{ATMkeys=30};//Q
		case 18:{ATMkeys=19};//R
		case 19:{ATMkeys=31};//S
		case 20:{ATMkeys=20};//T
		case 21:{ATMkeys=22};//U
		case 22:{ATMkeys=47};//V
		case 33:{ATMkeys=44};//W
		case 24:{ATMkeys=45};//X
		case 25:{ATMkeys=21};//Y
		case 26:{ATMkeys=17};//Z
		case 27:{};//US Keyboard
		case 28:{ATMkeys=30};//A
		case 29:{ATMkeys=48};//B
		case 30:{ATMkeys=46};//C
		case 31:{ATMkeys=32};//D
		case 32:{ATMkeys=18};//E
		case 33:{ATMkeys=33};//F
		case 34:{ATMkeys=34};//G
		case 35:{ATMkeys=35};//H
		case 36:{ATMkeys=23};//I
		case 37:{ATMkeys=36};//J
		case 38:{ATMkeys=37};//K
		case 39:{ATMkeys=38};//L
		case 40:{ATMkeys=50};//M
		case 41:{ATMkeys=49};//N
		case 42:{ATMkeys=24};//O
		case 43:{ATMkeys=25};//P
		case 44:{ATMkeys=16};//Q
		case 45:{ATMkeys=19};//R
		case 46:{ATMkeys=31};//S
		case 47:{ATMkeys=20};//T
		case 48:{ATMkeys=22};//U
		case 49:{ATMkeys=47};//V
		case 50:{ATMkeys=17};//W
		case 51:{ATMkeys=45};//X
		case 52:{ATMkeys=21};//Y
		case 53:{ATMkeys=44};//Z
	};
};

dokeyDown={
	private ["_r","_key_delay","_cutawaysound"];
	_key_delay  = 0.3;
	player setvariable ["ATMcrKey",false];
	_r = false ;

	if (player getvariable["ATMcrKey",true] && (_this select 1) isEqualTo ATMkeys) exitwith {player setvariable["ATMcrKey",false]; [_key_delay] spawn {sleep (_this select 0);player setvariable["ATMcrKey",true]; }; _r};
	if ((_this select 1) isEqualTo ATMkeys) then {
		if  (player != vehicle player && player getvariable ["ATMcutaway",true]) then {
			playSound "Para";
			_cut = nearestObjects [player, ["Steerable_Parachute_F"], 5];
			{deletevehicle _x} count _cut;
			player addBackpack "B_Parachute";
			deletevehicle (player getvariable "frontpack"); player setvariable ["frontpack",nil];
			player setvariable["ATMcrKey",true];
			player setvariable ["ATMcutaway",false];
			(findDisplay 46) displayRemoveEventHandler ["KeyDown", Cut_Rope];
			IsCutRope = true;
		};
		_r=true;
	};
	_r;
};

ATM_Getloadout={
	_gear = [];
	_headgear = headgear player;
	_back_pack = backpack player;
	_back_pack_items = getItemCargo (unitBackpack player);
	_back_pack_weap = getWeaponCargo (unitBackpack player);
	_back_pack_maga = getMagazineCargo (unitBackpack player);

	_gear =
	[
		_headgear,
		_back_pack,
		_back_pack_items,
		_back_pack_weap,
		_back_pack_maga
	];
	_gear
};

ATM_Setloadout={
	params ["_unit","_gear"];
	removeheadgear _unit;
	removeBackPack _unit;
	_unit addBackpack "B_AssaultPack_blk";
	removeBackPack _unit;
	if ((_gear select 1) != "") then {_unit addBackPack (_gear select 1);clearAllItemsFromBackpack _unit;};
	if ((_gear select 0) != "") then {_unit addHeadgear (_gear select 0)};
	if (count ((_gear select 3) select 0) > 0) then	{
		for "_i" from 0 to (count ((_gear select 3) select 0) - 1) step 1 do {
			(unitBackpack _unit) addweaponCargoGlobal [((_gear select 3) select 0) select _i,((_gear select 3) select 1) select _i];
		};
	};
	if (count ((_gear select 4) select 0) > 0) then	{
		for "_i" from 0 to (count ((_gear select 4) select 0) - 1) step 1 do {
			(unitBackpack _unit) addMagazineCargoGlobal [((_gear select 4) select 0) select _i,((_gear select 4) select 1) select _i];
		};
	};
	if (count ((_gear select 2) select 0) > 0) then	{
		for "_i" from 0 to (count ((_gear select 2) select 0) - 1) step 1 do {
			(unitBackpack _unit) addItemCargoGlobal [((_gear select 2) select 0) select _i,((_gear select 2) select 1) select _i];
		};
	};
};

Frontpack={
	if (isNull unitBackpack _target) exitWith {};
	_pack = unitBackpack _target;
	_class = typeOf _pack;

	[_target,_class] spawn {
		params ["_target","_class","_packHolder"];

		_packHolder = createVehicle ["groundWeaponHolder", [0,0,0], [], 0, "CAN_COLLIDE"];
		_packHolder addBackpackCargo [_class, 1];
		_packHolder attachTo [_target,[0.1,0.56,-.72],"pelvis"];
		_target setvariable ["frontpack", _packHolder];
		_packHolder setVectorDirAndUp [[0,1,0],[0,0,-1]];

		waitUntil {sleep 0.1; animationState _target == "para_pilot"};
		_packHolder attachTo [vehicle _target,[0.1,0.72,0.52],"pelvis"];
		_packHolder setVectorDirAndUp [[0,0.1,1],[0,1,0.1]];
	};
};
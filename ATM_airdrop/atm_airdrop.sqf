/*
	=ATM= Airdrop
	=ATM=Pokertour
	version : 6.0
	date : 12/02/2014
	visit us : atmarma.fr
*/

waitUntil {!isNull player};

_z = (getPos player) # 2;
Altitude = 500;

hint Localize "STR_ATM_hinton";
openMap true;

createDialog "ATM_AD_ALTITUDE_SELECT";
disableSerialization;
private _dialog = findDisplay 2900;
private _s_alt = _dialog displayCtrl 2901;
private _s_alt_text = _dialog displayCtrl 2902;
_s_alt_text ctrlSetText format["%1", Altitude];
_s_alt sliderSetRange [500,20000];
_s_alt slidersetSpeed [100,100,100];
_s_alt sliderSetPosition Altitude;

Keys = 0;
IsCutRope = false;

_ctrl = _dialog displayCtrl 2903;
{_index = _ctrl lbAdd _x} count ["Fr Keyboard","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","US Keyboard","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
lbSetCurSel [2903, 0];

ATM_Jump_mapclick = false;
["PlayerHalo_mapclick","onMapSingleClick", {
	ATM_Jump_clickpos = _pos;
	ATM_Jump_mapclick = true;
}] call BIS_fnc_addStackedEventHandler;//Jig adding

waitUntil {ATM_Jump_mapclick or !(visiblemap)};
["PlayerHalo_mapclick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;//Jig adding

if (!visibleMap) exitwith {
	systemChat "Halo jump canceled.";
	breakOut "main";
};
_pos = ATM_Jump_clickpos;
ATM_Jump_mapclick = if(true) then{
	call compile format ['
	mkr_halo = createmarker ["mkr_halo", ATM_Jump_Clickpos];
	"mkr_halo" setMarkerTypeLocal "hd_dot";
	"mkr_halo" setMarkerColorLocal "ColorGreen";
	"mkr_halo" setMarkerTextLocal "Jump";'];
};

_target = player;
RedOn = _target addAction["<t color='#B40404'>Chemlight Red On</t>", "ATM_airdrop\atm_chem_on.sqf",["Chemlight_red"],6,false,false,"","_target == player"];
BlueOn = _target addAction["<t color='#68ccf6'>Chemlight Blue On</t>", "ATM_airdrop\atm_chem_on.sqf",["Chemlight_blue"],6,false,false,"","_target == player"];
YellowOn = _target addAction["<t color='#fcf018'>Chemlight Yellow On</t>", "ATM_airdrop\atm_chem_on.sqf",["Chemlight_yellow"],6,false,false,"","_target == player"];
GreenOn = _target addAction["<t color='#30fd07'>Chemlight Green On</t>", "ATM_airdrop\atm_chem_on.sqf",["Chemlight_green"],6,false,false,"","_target == player"];
IrOn = _target addAction["<t color='#FF00CC'>Strobe IR On</t>", "ATM_airdrop\atm_chem_on.sqf",["NVG_TargetC"],6,false,false,"","_target == player"];

_loadout=[_target] call ATM_Getloadout;

_posJump = markerPos "mkr_halo";
_x = _posJump # 0;
_y = _posJump # 1;
_z = _posJump # 2;
_target setPos [_x,_y,_z+Altitude];

openMap false;
deleteMarker "mkr_halo";

0=[_target] call Frontpack;

removeBackpack _target;
sleep 0.5;
_target addBackpack "B_Parachute";
if ((getPos _target # 2) >= 8000) then {
	removeHeadgear _target;
	_target addHeadgear "H_CrewHelmetHeli_B";
	sleep 0.5;
};

hintsilent "";
hint Localize "STR_ATM_hintjump";
Cut_Rope = (FindDisplay 46) displayAddEventHandler ["KeyDown","_this call dokeyDown"];

while {(getPos _target # 2) > 2} do {
	if !(isTouchingGround _target and isNull objectParent player) then {
		if(floor random 3 isEqualTo 0) then {playSound "Vent"};
		sleep (1 + random 0.3);
		if(floor random 3 isEqualTo 0) then {playSound "Vent2"};
	};
	if !(INS_ACE_para) then {//Jig adding
		if ((getPos _target # 2) < 160) then {
			_target action ["OpenParachute", _target];
		};
	};
	if(!alive _target) then {
		_target setPos [getPos _target # 0, getPos _target # 1, 0];
		0=[_target,_loadout] call ATM_Setloadout;
	};
};

_target switchmove "";//Jig adding
hint Localize "STR_ATM_hintload";
_target removeAction RedOn;
_target removeAction BlueOn;
_target removeAction YellowOn;
_target removeAction GreenOn;
_target removeaction Iron;
deletevehicle (_target getvariable "frontpack"); _target setvariable ["frontpack",nil,true];
deletevehicle (_target getvariable "lgtarray"); _target setvariable ["lgtarray",nil,true];
if (!IsCutRope) then {(findDisplay 46) displayRemoveEventHandler ["KeyDown", Cut_Rope]};

sleep 3;
hintsilent "";
sleep 1;

0=[_target,_loadout] call ATM_Setloadout;
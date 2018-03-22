waitUntil {!isNull player && player == player};
#include "=BTC=_functions.sqf"

call BTC_CS_acts;

_eh = player addEventHandler ["respawn", {
	_actions = [] spawn {
		waitUntil {sleep 1; Alive player};
		call BTC_CS_acts;
	};
}];
BTC_main_cc =
[
	"Motorcycle",1,
	"Car",3,
	"Truck",10,
	"Wheeled_APC",5,
	"Tank",5,
	"Ship",3,
	"Helicopter",6
];
BTC_main_rc =
[
	"ReammoBox_F",2,
	"thingX",3,
	"StaticWeapon",3,
	"Strategic",2,
	"Motorcycle",3,
	"Land_BarGate_F",3,
	"HBarrier_base_F",5,
	"Land_BagFence_Long_F",3,
	"Wall_F",5,
	"BagBunker_base_F",5,
	"Car",11,
	"Truck",15,
	"Wheeled_APC",20,
	"Tank",25,
	"Ship",15,
	"Helicopter",9999
];
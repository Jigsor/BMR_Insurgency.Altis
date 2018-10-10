/*
	File: fn_tawvdInit.sqf
	Author: Bryan "Tonic" Boardwine	
	Description:
	Master init for TAW View Distance (Addon version).
	If the script verson is present it will exit.
*/

/*
if(!isMultiplayer) exitWith {};
tawvd_foot = viewDistance;
tawvd_car = viewDistance;
tawvd_air = viewDistance;
tawvd_syncObject = true; //Enable the automatic syncing of Object View rendering with the current view distance.
tawvd_object = tawvd_foot;
tawvd_addon_disable = true;
//The hacky method... Apparently if you stall (sleep or waitUntil) with CfgFunctions you stall the mission initialization process... Good job BIS, why wouldn't you spawn it via preInit or postInit?
*/

if(isNil {tawvd_foot}) then
{
tawvd_foot = viewDistance;
tawvd_car = viewDistance;
tawvd_air = viewDistance;

tawvd_syncObject = true; //Enable the automatic syncing of Object View rendering with the current view distance.
tawvd_object = tawvd_foot;
tawvd_addon_disable = true;
};

0 spawn {
	waitUntil {!isNull player && player == player};
	waitUntil{!isNil "BIS_fnc_init"};
	waitUntil {!(isNull (findDisplay 46))};

	// tawvd_action = player addAction["<t color='#FF0000'>Settings</t>",TAWVD_fnc_openTAWVD,[],-99,false,false,"",''];

	0 spawn TAWVD_fnc_trackViewDistance;
};
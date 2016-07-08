/*
	File: fn_transferNetwork.sqf
	Author: Bryan "Tonic" Boardwine

	Description:
	Receives information sent for a transfer request and prompts the user.

	STR_VAS_Transfer_Request
*/
private["_sender, _selectNum"];
_sender = _this select 0;
_loadoutName = _this select 1;

if (name _sender == "") exitWith {};

if(!createDialog "LT_prompt") exitWith {hint format["%1 tried to send you a saved loadout but we couldn't open the menu.",_sender];};
disableSerialization;
waitUntil {!isNull (findDisplay 2550)};

((findDisplay 2550) displayCtrl 2551) ctrlSetStructuredText parseText format["<t align='center'><t size='.8px'>%1 %2</t></t><br/><t align='center'><t size='0.6px'>%3</t></t>", (name _sender) ,"wants to transfer you their loadout.", "Would you like to receive this loadout?"];

((findDisplay 2550) displayCtrl 2552) ctrlSetText "Yes";

((findDisplay 2550) displayCtrl 2553) ctrlSetText "No";

waitUntil {!isNil "lt_prompt_choice"};
if(lt_prompt_choice) then
{
	[player, [missionNamespace, _loadoutName]] call bis_fnc_loadInventory;
	hint "Loadout Transfered";
};

lt_prompt_choice = nil;
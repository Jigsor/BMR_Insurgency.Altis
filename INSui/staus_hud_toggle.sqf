//staus_hud_switch.sqf by Jig

private ["_run", "_SHhandle"];

_run = true;

if (status_hud_on) exitWith
	{
	("ICE_Layer" call BIS_fnc_rscLayer) cutText ["","PLAIN"];
	status_hud_on = false;
	player setVariable ["stathud_resp", false];
	};

_SHhandle = [] spawn ICE_HUD;
status_hud_on = true;
player setVariable ["stathud_resp", true];

while {_run} do 
	{
	if (!alive player) then 
		{
		("ICE_Layer" call BIS_fnc_rscLayer) cutText ["","PLAIN"];
		status_hud_on = false;
		_run = false;
		};

	if (status_hud_on) then 
		{
		} else 
		{
		("ICE_Layer" call BIS_fnc_rscLayer) cutText ["","PLAIN"];
		_run = false;
		};

	 uiSleep 1
	};

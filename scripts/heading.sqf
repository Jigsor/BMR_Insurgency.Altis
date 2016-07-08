/*
 GeneralCarver Display Heading Script Display Heading Script
 Author: GeneralCarver
 Version: 3
 Date: 11/21/10
 Description: This script displays the heading of the player for two seconds and then hides it.

 Change Log
v1 - 11/4/10 - Released.
v2 - 11/12/10 - Added "press k to toggle off" to on screen comments
v3 11/21/10 - moved text to lower left, speeded up refresh rate.
*/

private ["_mydir","_continue_script"];

_continue_script = true;

if (gc_heading_on) exitWith
	{
	gc_heading_on = false;
	player setVariable ["dhs_resp", false];
	};

gc_heading_on = true;
player setVariable ["dhs_resp", true];

while {_continue_script} do 
	{
	if (!alive player) then 
		{
		gc_heading_on = false;
		_continue_script = false;
		};

	if (gc_heading_on) then 
		{
		} else 
		{
		_continue_script = false;
		};

	_mydir = getdir player;
	_mydir = round(_mydir);
	cutText [("                              HEADING: " + str _mydir), "PLAIN DOWN", 0.1];

	 uiSleep 0.25
	};

cutText [" ", "PLAIN"];
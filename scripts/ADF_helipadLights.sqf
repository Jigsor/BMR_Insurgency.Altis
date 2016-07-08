/****************************************************************
ARMA Mission Development Framework
ADF version: 1.41 / JULY 2015

Script: Helipad lights
Author: Whiztler
Script version: 1.3

Game type: n/a
File: ADF_helipadLights.sqf
****************************************************************
Create (runway) lights around a circular helipad.

Instructions:

Place a helipad (circle) on the map. in the init put:
null = [this] execVM "Core\ADF_helipadLights.sqf";

Runway lights that can be used: 
"Land_runway_edgelight"
"Land_runway_edgelight_pYlue_f"
"Land_Flush_Light_green_F"
"Land_Flush_Light_red_F"
"Land_Flush_Light_yellow_F"
****************************************************************/

if (isServer) then { // Executed by the server entity only.
	private ["_ADF_hpl_hpLight","_ADF_hpl_hpLoc","_ADF_hpl_rd","_ADF_hpl_nr","_ADF_hpl_sp","_ADF_hpl_pX","_ADF_hpl_pY","_ADF_hpl_oPos","_ADF_hpl_cLight"];
	_ADF_hpl_hpLight 	= []; // Define the array.
	_ADF_hpl_hpLoc 	= getPos (_this select 0); // get the object's location and alt.
	_ADF_hpl_rd 		= 5.75; // Radius. 5.75 creates the light on the edge of the helipad.
	_ADF_hpl_nr 		= 8; // nr. of lights to be spawned on the helidpad.
	_ADF_hpl_sp 		= 360/_ADF_hpl_nr; // Define spacing based on the number of objects.

	for "_ADF_hpl_circle" from 1 to 360 step _ADF_hpl_sp do { // loop
		_ADF_hpl_pX = (_ADF_hpl_hpLoc select 0)+(sin(_ADF_hpl_circle)*_ADF_hpl_rd);
		_ADF_hpl_pY = (_ADF_hpl_hpLoc select 1)+(cos(_ADF_hpl_circle)*_ADF_hpl_rd);
		_ADF_hpl_oPos = [_ADF_hpl_pX, _ADF_hpl_pY, _ADF_hpl_hpLoc select 2];
		_ADF_hpl_cLight = createVehicle [ "Land_Flush_Light_yellow_F", _ADF_hpl_oPos, [], 0, "CAN_COLLIDE"]; // Create the light
		_ADF_hpl_cLight modelToWorld _ADF_hpl_oPos; // Position the light on the helipad.
		_ADF_hpl_hpLight pushBack _ADF_hpl_cLight; // Add the created light to the array.
	};// Close loop when _nr of lights have been created.
};
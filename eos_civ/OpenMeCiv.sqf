/* EOS 1.98 by BangaBob 
GROUP SIZES
 0 = 1
 1 = 2,4
 2 = 4,8
 3 = 8,12
 4 = 12,16
 5 = 16,20

EXAMPLE CALL - EOS
 null = [["MARKERNAME","MARKERNAME2"],[2,1,70],[0,1],[1,2,30],[2,60],[2],[1,0,10],[1,0,250,WEST]] call EOS_Civ_Spawn;
 null=[["M1","M2","M3"],[HOUSE GROUPS,SIZE OF GROUPS,PROBABILITY],[PATROL GROUPS,SIZE OF GROUPS,PROBABILITY],[LIGHT VEHICLES,SIZE OF CARGO,PROBABILITY],[ARMOURED VEHICLES,PROBABILITY], [STATIC VEHICLES,PROBABILITY],[HELICOPTERS,SIZE OF HELICOPTER CARGO,PROBABILITY],[FACTION,MARKERTYPE,DISTANCE,SIDE,HEIGHTLIMIT,DEBUG]] call EOS_Civ_Spawn;
*/

EOS_Civ_Spawn = compile preprocessfilelinenumbers "eos_civ\core\eos_civ_launch.sqf";
null=[] execVM "eos_civ\core\spawn_civ_fnc.sqf";
//onplayerConnected {[] execVM "eos_civ\functions\EOS_Civ_Markers.sqf";};
if (isServer) then {["updateCivEOSmkrs","onplayerConnected", {[] execVM "eos_civ\functions\EOS_Civ_Markers.sqf";}] call BIS_fnc_addStackedEventHandler;};

CivVictoryColor="colorGreen";	// Colour of marker after completion
CivhostileColor="colorRed";	// Default colour when enemies active
EOS_CIV_KILLCOUNTER=false;		// Counts killed units

//Calling EOS_Civ_Spawn 17 times
for "_i" from 1 to 17 do
{
    null = [[format["civmkr%1", _i]],[2,1,CivProbability],[1,0,CivProbability],[0,0],[0],[0],[0,0],[7,1,500,CIVILIAN]] call EOS_Civ_Spawn;
};  

 /******************************************************************************
 *                        ,1             ,-===========.
 *                       /,| ___________((____________\\_                _
 *    ,========.________//_|/===========._#############L_Y_....-----====//
 *   (#######(==========\################\=======.______ --############((
 *    `=======`"        ` ===============|::::.___|[ ))[JW]#############\\
 *                                       |####|     ""\###|   :##########\\
 *                                      /####/         \##\     ```"""=,,,))
 *     C R E A T E D   B Y   B T K     /####/           \##\
 *                                    '===='             `=`
 *******************************************************************************
 *
 *  This file starts the Drop Cargo Script.
 *
 *  To disable the script at all put a // in front of the line.
 *  
 *  Example:
 *  // execVM "BTK\Cargo Drop\Init.sqf";
 *
 ******************************************************************************/

if (IamHC) exitWith {};

//// Wait until player ready, exit if server
waitUntil {!isNull player};
if (!local player) exitWith {};
if (playerSide == east) exitWith {};

///// Launch the init once
execVM "BTK\Cargo Drop\InitBTK.sqf";
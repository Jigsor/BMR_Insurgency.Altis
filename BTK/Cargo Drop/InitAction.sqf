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
 *  Adds the load cargo action to the vehicle.
 *
 ******************************************************************************/

//// Variables
params ["_Transporter","_Unit"];

//// Check for action
_BTK_CargoDrop_ActionAdded = _Transporter getVariable ["BTK_CargoDrop_ActionAdded", false];
if (_BTK_CargoDrop_ActionAdded) exitWith {};

//// If no action continue here
_Transporter setVariable ["BTK_CargoDrop_ActionAdded", true];
_CargoAction = _Transporter addAction [("<t color=""#fadfbe"">" + (localize "STR_BMR_load_cargo") + "</t>"),"BTK\Cargo Drop\Engine.sqf",["LoadCargo"], 5, false, false, "", "vehicle _this == player"];

//// remove Action
waitUntil {(position _Unit distance _Transporter > 20) || !(alive _Unit) || !(alive _Transporter)};
_Transporter removeAction _CargoAction;
_Transporter setVariable ["BTK_CargoDrop_ActionAdded", false];
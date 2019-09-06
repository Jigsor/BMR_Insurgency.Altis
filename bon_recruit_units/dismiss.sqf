params ["_unit"];

_unit action ["getOut",vehicle _unit];
sleep 2;

hint format["%1 %2 has been dismissed",getText (configFile >> "CfgVehicles" >> typeOf _unit >> "displayname"),name _unit];
deleteVehicle _unit;
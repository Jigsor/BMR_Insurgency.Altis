params ["_ied","_iedSize","_iedPosition","_trigger","_iedNumber"];

//if(EPD_IED_debug) then {player sidechat format["synching %1 and %2", compile _trigger, compile _ied];};

call compile format['%1 addEventHandler ["HitPart", {[_this, %1, "%2", %3, %5,%4] call EXPLOSION_EVENT_HANDLER;}];',_ied,_iedSize, _iedPosition, _trigger,_iedNumber];
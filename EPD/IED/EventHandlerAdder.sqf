_ied = _this select 0;
_iedSize = _this select 1;
_iedPosition = _this select 2;
_trigger = _this select 3;
_iedNumber = _this select 4;

//if(EPD_IED_debug) then {player sidechat format["synching %1 and %2", compile _trigger, compile _ied];};

call compile format['%1 addEventHandler ["HitPart", {[_this, %1, "%2", %3, %5,%4] call EXPLOSION_EVENT_HANDLER;}];',_ied,_iedSize, _iedPosition, _trigger,_iedNumber];
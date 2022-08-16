_target = _this # 0;
_caller = _this # 1;
_id = _this # 2;
_ltcolor = (_this select 3) select 0;

_caller removeAction _id;

deletevehicle (_caller getvariable ["lgtarray", objNull]); _caller setvariable ["lgtarray",nil,true];
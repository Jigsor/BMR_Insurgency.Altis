params [["_veh",objNull]];
private _prefix = selectRandom ["BMRisLife","BMRisLove","Innocent","uCryAlot","LaterHater","EatMyDust","SweetOnions","ReadBriefing","UBnewbie","WeKnowUrPos","StealMe"];
private _suffix = str(floor random 100);
private _plateNo = _prefix + _suffix;
if (!isNull _veh) then {_veh setPlateNumber _plateNo};

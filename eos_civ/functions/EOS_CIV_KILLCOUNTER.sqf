private "_eosKills";
_eosKills=server getVariable "EOSkillCounter";
if (isNil "_eosKills") then {_eosKills=0;};
_eosKills=_eosKills + 1;
server setVariable ["EOScivKillCounter",_eosKills,true];
hint format ["Units Killed: %1",_eosKills];
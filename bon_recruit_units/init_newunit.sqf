_unit = _this select 0;

if(isServer) then{
	[_unit] execFSM (BON_RECRUIT_PATH+"unit_lifecycle.fsm");
} else {
	bon_recruit_newunit = _unit;
	publicVariable "bon_recruit_newunit";
};

if (Fatigue_ability isEqualTo 0) then {[_unit] call INS_full_stamina;};
if (INS_GasGrenadeMod isEqualTo 1) then {removeHeadgear _unit; _unit addHeadgear "H_CrewHelmetHeli_B";};
_unit addAction ["<t color='#1d78ed'>Dismiss</t>",BON_RECRUIT_PATH+"dismiss.sqf",[],-10,false,true,""];
_unit setVariable ["BIS_noCoreConversations", true];//_unit setSpeaker "NoVoice";
_unit SetUnitPos "UP";
[_unit] call INS_Recruit_skill;
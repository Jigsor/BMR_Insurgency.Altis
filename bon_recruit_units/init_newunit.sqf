params ["_unit"];

if(isServer) then{
	[_unit] execFSM (BON_RECRUIT_PATH+"unit_lifecycle.fsm");
} else {
	bon_recruit_newunit = _unit;
	publicVariable "bon_recruit_newunit";
};

if (Fatigue_ability isEqualTo 0) then {[_unit] call INS_full_stamina};
if (INS_op_faction in [20]) then {[_unit] call Trade_Biofoam_fnc};

if (INS_GasGrenadeMod isEqualTo 1 && !(INS_op_faction in [21])) then {
	if (INS_op_faction in [20]) then {
		removeHeadgear _unit;
		_unit addHeadgear "OPTRE_UNSC_CH252_Helmet_Vacuum_DES";
	}else{
		removeGoggles _unit;
		_unit addGoggles "G_AirPurifyingRespirator_01_F";
	};
};

_unit addAction ["<t color='#1d78ed'>Dismiss</t>",BON_RECRUIT_PATH+"dismiss.sqf",[],-10,false,true,""];
_unit setVariable ["BIS_noCoreConversations", true];//_unit setSpeaker "NoVoice";
//_unit disableAI "RADIOPROTOCOL";//breaks locked on missile warning sound?
_unit SetUnitPos "UP";
[_unit] call INS_Recruit_skill;
//by Bon_Inf*
//Modified by Moser 07/20/2014

BON_RECRUIT_PATH = "bon_recruit_units\";
bon_recruit_queue = [];
bon_dynamic_list = true;// Select false if you want to use a a static unit list. You can customize static lists in recruitable_units_static.sqf

if(isServer) then{
	"bon_recruit_newunit" addPublicVariableEventHandler {
		params ["","_newunit"];
		[_newunit] execFSM (BON_RECRUIT_PATH+"unit_lifecycle.fsm");
	};
};
if(isDedicated) exitWith{};
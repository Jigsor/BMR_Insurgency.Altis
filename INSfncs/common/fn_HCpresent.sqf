if  (!isServer && !hasInterface) then {
	IamHC = true;
	Any_HC_present = true; publicVariable "Any_HC_present";
	if (name player == "HC_1") then {HC_1Present = true; publicVariable "HC_1Present"};
	if (name player == "HC_2") then {HC_2Present = true; publicVariable "HC_2Present"};
};
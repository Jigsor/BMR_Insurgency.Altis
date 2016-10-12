disableSerialization;

if(!createDialog "LT_CheckPlayerMenu") exitWith {hint "Couldn't open player menu?"};
_control = ((findDisplay 2610) displayCtrl 2612);


{
	if(side _x == playerSide) then
	{

		if (str(_x) != str(player)) then
		{
			_control lbAdd format["%1", name _x];
			_control lbSetData[(lbSize _control)-1,str _x];
		};
	};
} foreach playableUnits;
private _menu ="
	<br/><font size='18'>ADMINISTRATOR TOOLS</font>
	<br/>Only logged in administrator or server host can see this breifing section and have access to these tools.
	<br/><br/>
";
_menu = _menu + "
	<br/><font size='18'>ZEUS SUPPORT</font>
	<br/>Ares mod is highly recommended to enhance and add functionality to ZEUS.
	<br/>Ctrl+Y to open and close Zeus interface.
	<br/><executeClose expression=""[player,true] spawn INS_Zeus_MP;"">	Assign or remove ZEUS with public notice</executeClose>
	<br/><executeClose expression=""[player,false] spawn INS_Zeus_MP;"">	Assign or remove ZEUS privately</executeClose>
	<br/>
	<br/><font size='18'>BRIGHTER NIGHTS</font>
	<br/><executeClose expression=""[] spawn {waitUntil {!isNil 'INS_Brighter_Nights'}; [3] remoteExec ['INS_Brighter_Nights', [0,-2] select isDedicated, false];};"">	Activate Brighter Nights</executeClose>
	<br/><executeClose expression=""[] spawn {waitUntil {!isNil 'INS_Brighter_Nights'}; [1] remoteExec ['INS_Brighter_Nights', [0,-2] select isDedicated, false];};"">	Deactivate Brighter Nights</executeClose>
	<br/>
	<br/><font size='18'>DUST STORM</font>
	<br/>Click any to start Dust Storm. Click any to end Dust Storm.
	<br/><executeClose expression=""[] spawn {waitUntil {!isNil 'JIG_Dust_Storm_Server'}; [12] remoteExec ['JIG_Dust_Storm_Server', 2, false];};"">	Low Speed Dust Storm</executeClose>
	<br/><executeClose expression=""[] spawn {waitUntil {!isNil 'JIG_Dust_Storm_Server'}; [22] remoteExec ['JIG_Dust_Storm_Server', 2, false];};"">	High Speed Dust Storm</executeClose>
	<br/>
	<br/><font size='18'>GIVE YOURSELF VEHICLE REWARD</font>
";
private _link1 = format ["<br/>	<executeCloseClose expression=""player spawn INS_Vehicle_Reward;"">%1</executeCloseClose>", localize "STR_BMR_veh_reward"];
_menu = _menu + _link1;
private _link2 = format ["<br/><br/>	<executeCloseClose expression=""[] spawn {waitUntil {!isNull player}; [player,player] call INS_Flip_Veh;};"">%1</executeCloseClose>", localize "STR_BMR_flip_veh"];
_menu = _menu + _link2;
player createDiaryRecord ["Diary", ["Administrator Menu", _menu]];
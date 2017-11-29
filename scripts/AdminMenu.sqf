private _menu ="
	<br/><font size='18'>ADMINISTRATOR TOOLS</font>
	<br/>Only logged in administrator or server host can see this breifing section and have access to these tools.
	<br/><br/>
";
_menu = _menu + "
	<br/><font size='18'>ZEUS SUPPORT</font>
	<br/>Ares mod is highly recommended to enhance and add functionality to ZEUS.
	<br/><execute expression=""[player,true] spawn INS_Zeus_MP;"">	Assign or remove ZEUS with public notice</execute>
	<br/><execute expression=""[player,false] spawn INS_Zeus_MP;"">	Assign or remove ZEUS privately</execute>
	<br/>
	<br/><font size='18'>BRIGHTER NIGHTS</font>
	<br/><execute expression=""[] spawn {waitUntil {!isNil 'INS_Brighter_Nights'}; [3] remoteExec ['INS_Brighter_Nights', [0,-2] select isDedicated, false];};"">	Activate Brighter Nights</execute>
	<br/><execute expression=""[] spawn {waitUntil {!isNil 'INS_Brighter_Nights'}; [1] remoteExec ['INS_Brighter_Nights', [0,-2] select isDedicated, false];};"">	Deactivate Brighter Nights</execute>
	<br/>
	<br/><font size='18'>DUST STORM</font>
	<br/>Click any to start Dust Storm. Click any to end Dust Storm.
	<br/><execute expression=""[] spawn {waitUntil {!isNil 'JIG_Dust_Storm_Server'}; [12] remoteExec ['JIG_Dust_Storm_Server', 2, false];};"">	Low Speed Dust Storm</execute>
	<br/><execute expression=""[] spawn {waitUntil {!isNil 'JIG_Dust_Storm_Server'}; [22] remoteExec ['JIG_Dust_Storm_Server', 2, false];};"">	High Speed Dust Storm</execute>
	<br/>
	<br/><font size='18'>GIVE YOURSELF VEHICLE REWARD</font>
";
private _link1 = format ["<br/>	<execute expression=""player spawn INS_Vehicle_Reward;"">%1</execute>", localize "STR_BMR_veh_reward"];
_menu = _menu + _link1;
player createDiaryRecord ["Diary", ["Administrator Menu", _menu]];
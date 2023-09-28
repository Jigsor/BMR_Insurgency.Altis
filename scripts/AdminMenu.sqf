private _menu ="
	<br/><font size='18'>ADMINISTRATOR TOOLS</font>
	<br/>Only logged in administrator or server host can see this breifing section and have access to these tools.
	<br/><br/>
";
_menu = _menu + "
	<br/><font size='18'>ZEUS SUPPORT</font>
	<br/>Achilles client side mod is highly recommended to enhance and add functionality to ZEUS.
	<br/>Ctrl+Y to open and close Zeus interface.
	<br/><executeClose expression=""[player,true] spawn INS_Zeus_MP;"">	Assign or remove ZEUS with public notice</executeClose>
	<br/><executeClose expression=""[player,false] spawn INS_Zeus_MP;"">	Assign or remove ZEUS privately</executeClose>
	<br/><executeClose expression=""if (time > 1) then {_p = player; [_p] remoteExec ['BMRINS_fnc_zeusAddAllObjects', [0,-2] select isDedicated];};"">	Add all objects to ZEUS</executeClose>
	<br/>
	<br/><font size='18'>BRIGHTER NIGHTS</font>
	<br/><executeClose expression=""0 spawn {waitUntil {!isNil 'INS_Brighter_Nights'}; [3] remoteExec ['INS_Brighter_Nights', [0,-2] select isDedicated];};"">	Activate Brighter Nights</executeClose>
	<br/><executeClose expression=""0 spawn {waitUntil {!isNil 'INS_Brighter_Nights'}; [1] remoteExec ['INS_Brighter_Nights', [0,-2] select isDedicated];};"">	Deactivate Brighter Nights</executeClose>
	<br/>
	<br/><font size='18'>DUST STORM</font>
	<br/>Click any to start Dust Storm. Click any to end Dust Storm.
	<br/><executeClose expression=""0 spawn {waitUntil {!isNil 'JIG_Dust_Storm_Server'}; [12] remoteExec ['JIG_Dust_Storm_Server', 2];};"">	Low Speed Dust Storm</executeClose>
	<br/><executeClose expression=""0 spawn {waitUntil {!isNil 'JIG_Dust_Storm_Server'}; [22] remoteExec ['JIG_Dust_Storm_Server', 2];};"">	High Speed Dust Storm</executeClose>
	<br/>
	<br/><font size='18'>SNOW</font>
	<br/>Click to start Snow. Click again to end Snow.
	<br/><executeClose expression=""0 spawn {waitUntil {!isNil 'JIG_Snow_Server'}; [2] remoteExec ['JIG_Snow_Server', 2];};"">	Light Snow Storm</executeClose>
	<br/>
	<br/><font size='18'>GIVE YOURSELF VEHICLE REWARD</font>
";
private _link1 = format ["<br/>	<executeClose expression=""player spawn INS_Vehicle_Reward;"">%1</executeClose>", localize "STR_BMR_veh_reward"];
_menu = _menu + _link1;
_menu = _menu + "
	<br/><br/><font size='18'>FLIP NEAR VEHICLE</font>
";
private _link2 = format ["<br/>	<executeClose expression=""0 spawn {waitUntil {!isNull player}; [player,player] call INS_Flip_Veh;};"">%1</executeClose>", localize "STR_BMR_flip_veh"];
_menu = _menu + _link2;
_menu = _menu + "
	<br/><br/><font size='18'>CANCEL CURRENT SIDE MISSION</font>
";
private _link3 = format ["<br/>	<executeClose expression=""0 spawn {waitUntil {!isNil 'BMRINS_fnc_SideMissionCancel'}; [] remoteExec ['BMRINS_fnc_SideMissionCancel', [0,-2] select isDedicated];};"">%1</executeClose>", localize "STR_BMR_Side_Canx"];
_menu = _menu + _link3;
_menu = _menu + "
	<br/><br/><font size='18'>FORCE RANDOM SIDE MISSION GENERATOR</font>
	<br/>Careful! Do not spam this function. Use this function if for some weird reason the auto mission generator stoped creating missions. Note typical time between auto generated missions is 35 - 50 seconds.
";
private _link4 = format ["<br/>	<executeClose expression=""0 spawn {waitUntil {!isNil 'BMRINS_fnc_requestRandomMission'}; [] remoteExec ['BMRINS_fnc_requestRandomMission', [0,-2] select isDedicated];};"">%1</executeClose>", localize "STR_BMR_Side_Request"];
_menu = _menu + _link4;
_menu = _menu + "
	<br/><br/><font size='18'>MANUAL MISSION PROGRESSION SAVE</font>
	<br/>Use this function if you intend to restore current progress after a server shut down/restart.
";
private _link5 = format ["<br/>	<executeClose expression=""0 spawn {waitUntil {!isNil 'Manual_ProgressionSave'}; [] remoteExec ['Manual_ProgressionSave'];};"">%1</executeClose>", localize "STR_BMR_SaveProgression"];
_menu = _menu + _link5;
_menu = _menu + "
	<br/><br/><font size='18'>MANUAL MISSION PROGRESSION RESET AND MISSION END</font>
	<br/>Use this option to clear any saved progression to prepare for a mission restart from begining. Only has affect if progression saving was enabled.
";
private _link6 = format ["<br/>	<executeClose expression=""0 spawn {waitUntil {!isNil 'Manual_ProgressionClearnEnd'}; [] remoteExec ['Manual_ProgressionClearnEnd', [0,-2] select isDedicated];};"">%1</executeClose>", localize "STR_BMR_ClearProgression"];
_menu = _menu + _link6;
private _tips ="
	<br/>
	<br/><font size='18'>Recommendations:</font>
	<br/>
	<br/>1. Do not use damage modifiers on players and only use them on unmoded A3 AI units with exception when using OPTRE mod.
	<br/>
	<br/>2. Do not stay assigned to Zeus. This will keep the AI load on dedicated server. This does not apply to local hosted servers and host is Admin by default.
	<br/>
	<br/>3. This mission works great with optional ASR_AI3 mod. After installation go to Configure Addons and set radio distance less than or equal to zone trigger distance to reduce unnecessary load on server. Use -filePatching launch parameter.
	<br/>
	<br/>4. Allow use of CBA_A3 mod and install it on the server. This will add extra actions/exclusive mission features on aircraft for players; 1.Bail from Chopper 2.Auto Countermeasure for fixed wing 3.3D Turret Compass
	<br/>
	<br/>5. The optional reccomended mods above can be hidden and not be made a requirement of clients by not editing this mission with these mods enabled and using -serverMod launch parameter.
	<br/>
	<br/>6. Lower Server Difficulty setting viewDistance to 1000-1200 for increased performance. Note this also affects air patrole spotting/weapons engagement capability.
	<br/>
	<br/>7. Restrict mods by using server keys and install all non client side mods on server for maximum performance of server and all clients.
	<br/>
	<br/>For example, each bullet fired causes an error on machines that do not have the mod it comes from and that moded chopper/uniform the client is flying in which server or some players cannot see has no armor for those machines missing the mod. Performance will continually degrade after some time for all machines. This mission can run weeks on end without performance degradation if these steps are taken.
	<br/>
	<br/>8. Restoring mission progression is only intended to work with one terrain. This means you must load the same terrain mission version in wich saving progession was enabled. Ex. Saving progression on BMR Insurgency Altis was enabled then Admin loaded BMR Insurgency Tanoa with progession restoration enabled. This will not work correctly.
	<br/>
	<br/>9. Manually kicking Headless Client will effectivley reset/reinforce uncaptured zones as if no enemy had been killed in these zones when HC(s) reconnect/JIP.  If using 2 headless clients then both should be kicked at the same time. As a side affect, the current objective may complete or it's defences deleted because all enemy AI get deleted when a headless client disconnects and leaves AI behind.
	<br/>
	<br/>10. The server does not automatically begin saving progression until one task has been completed.
";
_menu = _menu + _tips;
player createDiaryRecord ["Diary", ["Administrator Menu", _menu]];
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
	<br/><executeClose expression=""[] spawn {waitUntil {!isNil 'INS_Brighter_Nights'}; [3] remoteExec ['INS_Brighter_Nights', [0,-2] select isDedicated];};"">	Activate Brighter Nights</executeClose>
	<br/><executeClose expression=""[] spawn {waitUntil {!isNil 'INS_Brighter_Nights'}; [1] remoteExec ['INS_Brighter_Nights', [0,-2] select isDedicated];};"">	Deactivate Brighter Nights</executeClose>
	<br/>
	<br/><font size='18'>DUST STORM</font>
	<br/>Click any to start Dust Storm. Click any to end Dust Storm.
	<br/><executeClose expression=""[] spawn {waitUntil {!isNil 'JIG_Dust_Storm_Server'}; [12] remoteExec ['JIG_Dust_Storm_Server', 2];};"">	Low Speed Dust Storm</executeClose>
	<br/><executeClose expression=""[] spawn {waitUntil {!isNil 'JIG_Dust_Storm_Server'}; [22] remoteExec ['JIG_Dust_Storm_Server', 2];};"">	High Speed Dust Storm</executeClose>
	<br/>
	<br/><font size='18'>GIVE YOURSELF VEHICLE REWARD</font>
";
private _link1 = format ["<br/>	<executeClose expression=""player spawn INS_Vehicle_Reward;"">%1</executeClose>", localize "STR_BMR_veh_reward"];
_menu = _menu + _link1;
_menu = _menu + "
	<br/><br/><font size='18'>Flip Near Vehicle</font>
";
private _link2 = format ["<br/>	<executeClose expression=""[] spawn {waitUntil {!isNull player}; [player,player] call INS_Flip_Veh;};"">%1</executeClose>", localize "STR_BMR_flip_veh"];
_menu = _menu + _link2;
_menu = _menu + "
	<br/><br/><font size='18'>Manual Mission Progression Save</font>
";
private _link3 = format ["<br/>	<executeClose expression=""[] spawn {waitUntil {!isNil 'Manual_ProgressionSave'}; [] remoteExec ['Manual_ProgressionSave'];};"">%1</executeClose>", localize "STR_BMR_SaveProgression"];
_menu = _menu + _link3;
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
	<br/>6. Hide enemyTags in Server Difficulty Settings so that Enemy AI markers do not appear on map.
	<br/>
	<br/>7. Lower Server Difficulty setting viewDistance to 1000-1200 for increased performance. Note this also affects air patrole spotting/weapons engagement capability.
	<br/>
	<br/>8. Restrict mods by using server keys and install all non client side mods on server for maximum performance of server and all clients.
	<br/>
	<br/>For example, each bullet fired causes an error on machines that do not have the mod it comes from and that moded chopper/unifor the client is flying in wich server or some players cannot see has no armor for those machines missing the mod. Performance will continually degrade after some time for all machines. This mission can run weeks on end without performance degradation if mod these steps are taken.
	<br/>
	<br/>9. Restoring mission progression is only intended to work with one terrain. This means you must load the same terrain mission version in wich saving progession was enabled. Ex. Saving progression on BMR Insurgency Altis was enabled then Admin loaded BMR Insurgency Tanoa with progession restoration enabled. This will not work correctly.
	<br/>
	<br/>10. Select one of the progression saving options in lobby when using Headless Client incase HC crashes or gets kicked so it may rejoin and continue where it left off.
	<br/>
	<br/>11. Manually kicking Headless Client will effectivley reset/reinforce uncaptured zones as if no enemy had been killed in these zones. If using 2 headless clients then both should be kicked. As a side affect the current objective may complete or its defences deleted because all enemy AI get deleted when a headless client disconnects and leaves AI behind. To use this feature 'save mission progression and restore if any is saved' lobby option must be selected at game start or else when headless client reconnects it will spawn AI in green zones.
	<br/>
	<br/>12. When not using headless client and using auto progression saving, the server does not begin saving progression untill one task has been completed.
";
_menu = _menu + _tips;
player createDiaryRecord ["Diary", ["Administrator Menu", _menu]];
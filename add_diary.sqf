player createDiaryRecord ["Diary", ["3rd Party Credits","
	<br />Original insurgency by pogoman, Fireball, and Kol9yN.
	<br />Insurgency is based off the game mode created by the Project
	<br />	Reality team, originally released for
	<br />	Arma 2 Operation Arrowhead.
	<br />
	<br />----------------------------- Scripts -----------------------------
	<br />EOS v1.98 by BangaBob (H8erMaker)
	<br />=BTC=_revive v.98, =BTC= Logistics,
	<br />=BTC= Quick Revive and =BTC=_TK_punishment
	<br />	by BTC Giallustio
	<br />TAW view Distance v1.4 by Tonic
	<br />randomWeather2.sqf by Meatball.
	<br />real_weather.sqf v1.3 Original Release by team code34
	<br />	nicolas_boiteux@yahoo.fr.
	<br />vehRespawn.sqf, and ICE_HUD by Iceman77
	<br />repetitive_cleanup.sqf v1.7, player_markers.sqf v2.6,
	<br />set_loadout.sqf and get_loadout.sqf by aeroson.
	<br />JW Custom Close Air Support v0.1b.by JW Custom
	<br />Display Heading Script v3 by GeneralCarver.
	<br />Halo =ATM= Airdrop v6.0 by pokertour.
	<br />Traffic by MAD T.
	<br />Randomly generated roadside IED's by brians200
	<br />v1g Fast Rope by [STELS]Zealot
	<br />x_reload by Xeno
	<br />ghst_PutinBuild.sqf and ghst_PutinBuildIntel.sqf cores by Ghost
	<br />ghst_ugvsupport.sqf by Ghost
	<br />T-Helmetcam by Tajin
	<br />HuntIR script v1.0 by Bardosy
	<br />tky_evo_performance report by GITS Tankbuster
	<br />SHK_buildingpos.sqf v0.12 and shk_taskmaster by Shuko
	<br />BTK Cargo Drop v1.92 by sxp2high
	<br />zbe_cache_script_v4.6a by zorrobyte
	<br />Bon's Infantry Recruitment Redux -- by Moser
	<br />Mine Detector Script version alpha 0.6 by Lala14
	<br />Fog script v1.62 by Rockhount[BAfH]
	<br />ASOR Vehicle Selector v1.4 by Lecks
	<br />INS_SuicideBomber.sqf recruit civilian modification by SupahG33K
	<br />fn_Battle.sqf by Mikey74
	<br />Loadout Transfer by S.Crowe
	<br />ADF_helipadLights.sqf by Whiztler
	<br />
	<br />-------------------------- Functions ----------------------------
	<br />remove_carcass_fnc code by BIS
	<br />Ambient radio chatter code by TPW
	<br />BTC_m_fnc_only_server, BTC_AI_init and BTC_repair_wreck,
	<br />	by BTC Giallustio
	<br />fnc_ghst_build_positions and fnc_ghst_rand_position by Ghost
	<br />X_fnc_returnVehicleTurrets by Joris-Jan van 't Land
	<br />find_west_target_fnc based on example by Mattar_Tharkari in
	<br />	BIS Community Forums
	<br />Dialog U.I. by Dirty Haz
	<br />rej_fnc_bezier by Rejenorst
	<br />Boat push - v0.1  by BearBison
	<br />find_civ_bomber_fnc by SupahG33K
	<br />killed_ss_bmbr_fnc modified by SupahG33K
	<br />
	<br />------------------------ Development --------------------------
	<br />Thanks to BIS for such a great platform.
	<br />Thanks to BIS Community and BIS Community Forums
	<br />AJAX and Onion Gamers for hosting, testing and feedback.
	<br />All the Black Mamba Rangers
	<br />Thanks to all the Forum members who provided feedback.
	<br />Mr.Ripley for extensive long run testing, analyzing
	<br />	and feedback especially in Headless Client addition.
	<br />BMR_Insurgency_v1_44 release in Honor and Memory of
	<br />	Robert Lynn Lewellen. AKA Spectrum Warrior of Elite Arma Warriors
	<br />	who exposed me to scripting, Insurgency and Evolution game modes back in Arma 1.
	<br />
	"]];
player createDiaryRecord ["Diary", ["Credits","
	<br />Mission Author - Jigsor =BMR=
	<br />
	<br />Many original functions and scripts by Jigsor =BMR=.
	<br />Several functions and scripts by BTC Giallustio and Ghost
	<br />were modified by Jigsor =BMR=.
	<br/><br/><img image='images\bmrbw.paa' widwidth='256' height='256'/>"]];
player createDiaryRecord ["Diary", ["INFO","
	-------------------
	<br />-- Settings --
	<br />
	-------------------
	<br />Press Y key for Graphic Settings, Digital Heading and HUD.
	<br />
	<br />Squads are can be altered by pressing U.
	<br />
	<br />Supported PIP live feeds from the helmet-cameras of their fellow group members. Requires Tactical Glasses and helmet with camera. * - Activates camera / switches to next group member. Alt+* - Deactivates camera. Shift+* - Toggles size of the display.
	<br />
	-------------------  
	<br />-- Support --
	<br />
	-------------------
	<br />JTAC and Team leader CAS1 can call for Close Air Support. UAV Operators can call for air dropped UGV and launch parachute camera by firing a white flare from 203 grenade launcher. Engineer can build a FARP to repair, rearm and flip vehicles if he has a Bobcat or Repair Truck close by. Medics can build a small sandbag wall to provide cover. Team Leader CAS1 can call for squad heli evac. Sniper, Marksmen and Spotter classes can enable/disable bullet cam.
	<br />
	-------------------
	<br />-- Vehicles --
	<br />
	-------------------
	<br />Vehicles from base will respawn if destroyed. All Blufor Mobile Head Quarters have Virtual Arsenal. Opfor MHQ has deploy option to move ammo crates to MHQ location. The Bobcat can Tow other vehicles. GhostHawks can lift light vehicles. Mohawk and Huron can lift heavy and light vehicles. Earn an air dropped asset of your choice by destroying an ammo cache if Enemy Armor Probability parameter is set above 0%.
	<br />
	-------------------
	<br />-- Respawn --
	<br />
	-------------------
	<br /> The following Repawn, MHQ, and Teleport options can vary depending lobby parameter -Revive system- settings.
	<br />
	<br />Blufor -- Can choose to respawn at BASE, MHQ_1, MHQ_2, or MHQ_3 if no one revives you. You may also choose teleport to MHQs or Halo from Flag Pole at base.
	<br />
	<br />Opfor -- Choose Base to respawn in vicinity of Blufor players who have activated zones. If no zones are activated you will spawn in center of map or Choose Opfor_MHQ to spawn on your MHQ. If MHQ system enabled, teleport to MHQ from base flagpole is available.
	<br />
	<br />While waiting for a revive you can spectate and control camera with usual movement controls.
	<br />
	<br />To have a fully restored loadout/kit after respawn or revive, use scroll action Save Loadout at main ammo box.
  "]];
player createDiaryRecord ["Diary", ["Briefing","Gather Intel on Ammo Cache location by picking up suitcases. Destroy Ammo Caches with satchel or demo charges. Clear all red zones of enemy forces. Complete random objectives. Get Some!"]];
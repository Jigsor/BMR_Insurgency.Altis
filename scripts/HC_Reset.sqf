// HC_Reset.sqf 
// Server side script
// To install make folder in Server Game directory named Server. This file HC_Reset.sqf should reside in that folder Ex. C:\Program Files (x86)\Steam\SteamApps\common\Arma 3\Server
// Sends admin password to Server so Server can  have permission to kick Headless Client when performing preventive maintenance from unattended_maintenance.sqf. Work around for Spawn Bug on Headless Client. After some time AI cease to spawn by EOS though triggers still fire.
// Replace blahblahblah with your server admin password.
// This will not be accessible to any player so no security risk here... and is recommended to set if using Headless Client other wise this is not needed.

if (!isServer) exitWith {};
CCServerAdminPasswordCC = "blahblahblah";
publicVariableServer "CCServerAdminPasswordCC";
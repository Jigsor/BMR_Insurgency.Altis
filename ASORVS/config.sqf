ASORVS_SideRestriction = true;
ASORVS_BrightMaps = [];

ASORVS_UnitInsigniaAsBackground = false;
//Background logo. Can be in a mod or in a mission. .paa (recommended) or .jpg
ASORVS_BackgroundLogo =   "A3\ui_f\data\Logos\arma3_expansion_ca.paa";
//ASORVS_BackgroundLogo = "images\bmrbw.paa"; //Image in your mission folder.
//ASORVS_BackgroundLogo = "clan-textures\clan_logo.paa"; //Image in clan-textures.pbo addon

//Background tile (Arma 3 loading screen noise)
ASORVS_BackgroundTile = "A3\ui_f\data\GUI\cfg\LoadingScreens\loadingnoise_ca.paa";

//Items that should not be shown in any lists
ASORVS_Blacklist = ["O_MBT_02_arty_F","O_T_MBT_02_arty_ghex_F"];
//You can also add a blacklist per side AND/OR per faction. All blacklists that match player when ASORVS is opened will be included. Examples:
//ASORVS_Blacklist_WEST = []; //hide items for all west units
//ASORVS_Blacklist_BLU_F = []; //hide items for all NATO (class name BLU_F) units

//Only these items will show in any lists. Items not in these lists will be removed when opening ASORVS. Only base radios from TFAR / ACRE need to be added.
//ASORVS_Whitelist ["ItemRadio"];
//You can also add a whitelist per side and/or per faction. Items in this list MUST also be in ASORVS_Whitelist if it exists.
//ASORVS_Blacklist_WEST = ["ItemRadio"]; //hide items for all west units
//ASORVS_Blacklist_BLU_F = ["ItemRadio"]; //hide items for all NATO (class name BLU_F) units
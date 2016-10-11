/* Written by Brian Sweeney - [EPD] Brian*/

call compile preprocessFileLineNumbers "EPD\Ied_Settings.sqf";

if(isserver) then {
	eventHandlers = [];
	publicVariable "eventHandlers";
	
	iedsAdded = false;
	publicVariable "iedsAdded";
};


IED = compile preprocessFileLineNumbers "EPD\IED\Ied.sqf";
IED_SMOKE = compile preprocessFileLineNumbers "EPD\IED\IedSmoke.sqf";
IED_ROCKS = compile preprocessFileLineNumbers "EPD\IED\IedRocks.sqf";
IED_SCREEN_EFFECTS = compile preprocessFileLineNumbers "EPD\IED\IedPlayerEffects.sqf";
CHECK_ARRAY = compile preprocessFileLineNumbers "EPD\IED\CheckArray.sqf";
CREATE_IED = compile preprocessFileLineNumbers "EPD\IED\CreateIed.sqf";
CREATE_FAKE = compile preprocessFileLineNumbers "EPD\IED\CreateFake.sqf";
CREATE_PLACES_OF_INTEREST = compile preprocessFileLineNumbers "EPD\IED\createPlacesOfInterest.sqf";
EXPLOSION_CHECK = compile preprocessFileLineNumbers "EPD\IED\ExplosionCheck.sqf";
EXPLOSIVESEQUENCE_SMALL = compile preprocessFileLineNumbers "EPD\IED\ExplosiveSequenceSmall.sqf";
EXPLOSIVESEQUENCE_MEDIUM = compile preprocessFileLineNumbers "EPD\IED\ExplosiveSequenceMedium.sqf";
EXPLOSIVESEQUENCE_LARGE = compile preprocessFileLineNumbers "EPD\IED\ExplosiveSequenceLarge.sqf";
EXPLOSIVESEQUENCE_SECONDARY = compile preprocessFileLineNumbers "EPD\IED\ExplosiveSequenceSecondary.sqf";
INITIAL_EXPLOSION = compile preprocessFileLineNumbers "EPD\IED\InitialExplosion.sqf";
SPAWN_SECONDARY = compile preprocessFileLineNumbers "EPD\IED\CreateSecondary.sqf";
CREATE_SPECIFIC_IED = compile preprocessFileLineNumbers "EPD\IED\CreateSpecificIed.sqf";
CREATE_RANDOM_IEDS = compile preprocessFileLineNumbers "EPD\IED\CreateRandomIeds.sqf";
GET_SIZE_AND_TYPE = compile preprocessFileLineNumbers "EPD\IED\GetSizeAndType.sqf";
FIND_LOCATION_BY_ROAD = compile preprocessFileLineNumbers "EPD\IED\FindLocationByRoad.sqf";
PROJECTILE_DETECTION = compile preprocessFileLineNumbers "EPD\IED\ProjectileDetection.sqf";
EXPLOSION_WATCHER = compile preprocessFileLineNumbers "EPD\IED\ExplosionWatcher.sqf";
EXPLOSION_EVENT_HANDLER = compile preprocessFileLineNumbers "EPD\IED\ExplosionEventHandler.sqf";
EXPLOSION_EVENT_HANDLER_ADDER  = compile preprocessFileLineNumbers "EPD\IED\EventHandlerAdder.sqf";
SECONDARY_EVENT_ADDER = compile preprocessFileLineNumbers "EPD\IED\SecondaryEventAdder.sqf";
Disarm = compile preprocessFileLineNumbers "EPD\IED\disarmAddAction.sqf";

iedSecondaryItemsCount = count iedSecondaryItems;
iedSmallItemsCount = count iedSmallItems;
iedMediumItemsCount = count iedMediumItems;
iedLargeItemsCount = count iedLargeItems;

if(isserver) then {
	_script = iedArray call IED;
	
	iedsAdded = true;
	publicVariable "iedsAdded";
	//free some memory
	safeRoads = nil;
	predefinedLocations = nil;
	placesOfInterest = nil;
	cities = nil;
	villages = nil;
	locals = nil;

};

waituntil{sleep .5; (!isnull player and iedsAdded)};
//player sidechat "Synching IEDs... You may experience lag for a few seconds";
//hint format["%1 ieds to synch", count eventHandlers];

for "_i" from 0 to (count eventHandlers) -1 do{
	call compile (eventHandlers select _i);
	if(EPD_IED_debug) then {player sidechat (format["%1 synched", _i+1]);};
};

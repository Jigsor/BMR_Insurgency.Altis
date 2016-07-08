/* original work from: Tankbuster */
/* adapted from:  Dynamic IED script by - Mantis -*/
/* Rewritten by Brian Sweeney - [EPD] Brian*/

if(!isserver) exitwith {};
if (isnil ("iedcounter")) then {iedcounter=0;} ;
if (isnil ("junkcounter")) then {junkcounter=0;} ;

[] call CREATE_PLACES_OF_INTEREST;

ehExplosiveSuperClasses = ["RocketCore", "MissileCore", "SubmunitionCore", "GrenadeCore", "ShellCore"];
publicVariable "ehExplosiveSuperClasses";

explosiveSuperClasses = ["TimeBombCore","BombCore", "Grenade"];
publicVariable "explosiveSuperClasses";

explosiveBullets = ["B_20mm", "B_20mm_Tracer_Red", "B_30mm_HE", "B_30mm_HE_Tracer_Green", "B_30mm_HE_Tracer_Red", "B_30mm_HE_Tracer_Yellow", "B_30mm_MP", "B_30mm_MP_Tracer_Green", "B_30mm_MP_Tracer_Red", "B_30mm_MP_Tracer_Yellow", "B_35mm_AA", "B_35mm_AA_Tracer_Green", "B_35mm_AA_Tracer_Red", "B_35mm_AA_Tracer_Yellow", "B_40mm_GPR", "B_40mm_GPR_Tracer_Green", "B_40mm_GPR_Tracer_Red", "B_40mm_GPR_Tracer_Yellow"];
publicVariable "explosiveBullets";

thingsToIgnore = ["SmokeShell", "FlareCore", "IRStrobeBase", "GrenadeHand_stone", "Smoke_120mm_AMOS_White", "TMR_R_DG32V_F"];
publicVariable "thingsToIgnore";

private["_paramArray", "_paramCounter", "_handles"];

_paramCounter = 0;
_paramArray = _this;
_handleCounter = 0;
_handles = [];

safeRoads = [];
for "_i" from 0 to (count safeZones) -1 do{
	_found = false;
	_name = safeZones select _i;
	_origin = [0,0,0];
	_distance = 0;
	for "_j" from 0 to (count placesOfInterest) -1 do{
		if(placesOfInterest select _j select 0 == _name) then {
			_found = true;
			_origin = placesOfInterest select _j select 1;
			_distance = placesOfInterest select _j select 2;
			_j = count placesOfInterest;
		};
	};

	if(not _found) then {
		for "_j" from 0 to (count predefinedLocations) -1 do{
			if(predefinedLocations select _j select 0 == _name) then {
				_found = true;
				_origin = predefinedLocations select _j select 1;
				_distance = predefinedLocations select _j select 2;
				_j = count predefinedLocations;
			};
		};

		if(not _found) then {
			_origin = getmarkerpos (_name);
			if(hideIedMarker) then {
				(_name) setMarkerAlpha 0;
			};
			_size = getMarkerSize (_name);
			_distance = ((_size select 0) + (_size select 1))/2;
		};
	};

	if(not ([_origin,[0,0,0]] call BIS_fnc_areEqual)) then {
		safeRoads = safeRoads + (_origin nearRoads _distance);
	};
};

disarmedSections = [];
explodedSections = [];
for "_i" from 0 to (count _paramArray) -1 do{
	disarmedSections set [_i, ""];
	explodedSections set [_i, ""];
};

while{_paramCounter < count _paramArray} do {

	_arr = _paramArray select _paramCounter;

	if(_arr select 0 in ["All", "AllCities", "AllVillages", "AllLocals"]) then {
		_arrToLoop = [];
		if(_arr select 0 == "All") then {
			_arrToLoop = placesOfInterest;
		};
		if(_arr select 0 == "AllCities") then {
			_arrToLoop = cities;
		};
		if(_arr select 0 == "AllVillages") then {
			_arrToLoop = villages;
		};
		if(_arr select 0 == "AllLocals") then {
			_arrToLoop = locals;
		};

		for "_i" from 0 to (count _arrToLoop) -1 do{
			_place = _arrToLoop select _i;
			_origin = _place select 1;
			_distance = _place select 2;
			_iedsToPlace = floor (_distance / 100.0);
			_junkToPlace = _iedsToPlace;
			_side = _arr select ((count _arr) -1);

			//prevent race condition...
			_iedc = iedcounter;
			_junkc = junkcounter;

			_handle = [_origin, _distance, _side, _iedsToPlace, _junkToPlace, _iedc, _junkc, _paramCounter] spawn CREATE_RANDOM_IEDS;
			iedcounter = iedcounter + _iedsToPlace;
			junkcounter = junkcounter + _junkToPlace;
			_handles set [_handleCounter, _handle];
			_handleCounter = _handleCounter + 1;
		};
	} else {
		_origin = [0,0,0];
		_distance = [0,0,0];
		_placesOfInterestIndex = -1;
		for "_i" from 0 to (count placesOfInterest) -1 do{
			if(placesOfInterest select _i select 0 == _arr select 0) then {
				_placesOfInterestIndex = _i;
				_i = (count placesOfInterest);
			};
		};
		if(_placesOfInterestIndex > -1) then {
			_origin = placesOfInterest select _placesOfInterestIndex select 1;
			_distance = placesOfInterest select _placesOfInterestIndex select 2;
		} else {
			_predefinedLocationIndex = -1;//_cityNames find (_arr select 0);
			for "_i" from 0 to (count predefinedLocations) -1 do{
				if(predefinedLocations select _i select 0 == _arr select 0) then {
					_predefinedLocationIndex = _i;
					_i = (count predefinedLocations);
				};
			};

			if(_predefinedLocationIndex > -1) then {
				_origin = predefinedLocations select _predefinedLocationIndex select 1;
				_distance = predefinedLocations select _predefinedLocationIndex select 2;
			} else {
				_origin = getmarkerpos (_arr select 0);
				if(hideIedMarker) then {
					(_arr select 0) setMarkerAlpha 0;
				};
				_size = getMarkerSize (_arr select 0);
				_distance = ((_size select 0) + (_size select 1))/2;
			};
		};

		if(not ([_origin,[0,0,0]] call BIS_fnc_areEqual)) then { //don't bother if the marker doesn't exist
			if(_distance > 1) then {
				_side = "";
				_iedsToPlace = 0;
				_junkToPlace = 0;
				if(count _arr == 2) then {
					_iedsToPlace = ceil (_distance / 100.0);
					_junkToPlace = _iedsToPlace;
					_side = _arr select 1;
				} else {
					if( count _arr == 3) then {
						_iedsToPlace = _arr select 1;
						_junkToPlace = _iedsToPlace;
						_side = _arr select 2;
					} else {
						_iedsToPlace = _arr select 1;
						_junkToPlace = _arr select 2;
						_side = _arr select 3;
					};
				};

				//prevent race condition...
				_iedc = iedcounter;
				_junkc = junkcounter;

				_handle = [_origin, _distance, _side, _iedsToPlace, _junkToPlace, _iedc, _junkc, _paramCounter] spawn CREATE_RANDOM_IEDS;
				iedcounter = iedcounter + _iedsToPlace;
				junkcounter = junkcounter + _junkToPlace;
				_handles set [_handleCounter, _handle];
			}
			else  //single IED exactly on the marker spot
			{
				_side = _arr select ((count _arr) -1);
				_chance = 100;

				if(count _arr > 2) then {_chance = _arr select ((count _arr) -2);};

				//prevent race condition...
				_iedc = iedcounter;
				_junkc = junkcounter;

				if((random 100) < _chance) then {
					_handle = [_iedc, _origin, _side, _paramCounter, _paramCounter] spawn CREATE_SPECIFIC_IED;
					iedcounter = iedcounter + 1;
					_handles set [_paramCounter, _handle];
				} else {
					_st = [] call GET_SIZE_AND_TYPE;
					[_junkc, _origin, _st select 1] spawn CREATE_FAKE;
					junkcounter = junkcounter + 1;
				};
			};
			_handleCounter = _handleCounter + 1;
		} else {
			disarmedSections set [_paramCounter, "true"];
			explodedSections set [_paramCounter, "false"];
		};
	};
	_paramCounter = _paramCounter + 1;
};

waituntil{sleep .5; [_handles] call CHECK_ARRAY;};
publicVariable "eventHandlers";
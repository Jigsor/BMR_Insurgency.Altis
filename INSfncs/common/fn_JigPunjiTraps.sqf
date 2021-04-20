// JigPunjiTraps.sqf by Jigsor
// Places traps in thick trees and bushes.
// Cleans up all previously created traps + markers and randomly places new ones each time script runs.
// Mines can be detected by anyone with IED detector.

if (!isServer) exitWith {};
if !(isClass(configFile >> "cfgPatches" >> "uns_main")) exitWith {diag_log "!!!BMR Insurgency warning! Punji traps cannot be created. You are missing Unsung mod";};
if (!canSuspend) exitWith {[] spawn BMRINS_fnc_JigPunjiTraps};
waituntil {!isNil "all_eos_mkrs"};
private _mkrs = + all_eos_mkrs;
waitUntil {time > 0};

// Editable
private _trapsC = 125;		//Total trap objects
private _maxLoops = 6000;	//Increase this number if less than desired trap objects are created.
private _trapTypes = ["uns_tripwire_punj1","uns_tripwire_punj2","uns_tripwire_punj3","uns_tripwire_punj4","uns_tripwire_rdg33","uns_tripwire_shell"];//Trap type classnames
private _TBrad = 11;		//Radius of trees and bush density to hide traps;
private _minTB = 12;		//Minum trees and bushes required in radius variable _TBrad to hide traps.
private _rmE = true;		//Reveal traps to side EAST
private _rmW = false;		//Reveal traps to side WEST
private _rmI = true;		//Reveal traps to side Independent/Resistance.
private _rmC = true;		//Reveal traps to side Civilian.
// End Editable

if (!isNil "allTrapMkrs") then {{deleteMarker _x} forEach allTrapMkrs;};
if (!isNil "allTraps") then {{deleteVehicle _x} forEach allTraps;};
allTrapMkrs = [];
allTraps = [];

private _debug = DebugEnabled;//1 - Show markers
private _options = "+trees +forest*10";//"+trees +forest*10 -meadow"
private _sbp = [];
private _c = 0;
private _r = 0;
private _mkr = "";
private _maxRad = 300;

for "_i" from 1 to 6000 do {

	_r = floor(random (count _mkrs));
	_mkr = _mkrs # _r;
	_mkrs deleteAt _r;

	if (count _mkrs < 2) then {
		diag_log "!!! BMR notice. All potential visable grid markers surveyed for trap areas. Recycling markers.";
		_mkrs = + all_eos_mkrs;
		_maxRad = _maxRad + 25;
	};

	private _mkrPos = markerPos _mkr;
	private _precision = selectRandom [7,12,17];
	private _rad = floor linearConversion [0, 1, random 1, 125 min _maxRad, _maxRad max 125 + 1];
	_sbp = selectBestPlaces [_mkrPos, _rad, _options, _precision, 2];

	_pos = selectRandom [(_sbp # 0) # 0, (_sbp # 1) # 0];

	if ((count nearestTerrainObjects [_pos, ["TREE","SMALL TREE","BUSH"], _TBrad, false, true]) >= _minTB) then {

		private _SN = surfaceNormal _pos;
		_SN params ["_SNx","_SNy"];

		if ( !(surfaceIsWater _pos) && {(abs _SNx < 0.13) && (abs _SNy < 0.13)} && {!isOnRoad _pos} ) then {

			//player setPos _pos; sleep 0.3;
			private _type = selectRandom _trapTypes;
			private _trap = createMine [_type, _pos, [], 0];
			allTraps pushBack _trap;
			_trap setVariable ["persistent",true];

			_c = _c + 1;
			private _n = format["TRAP_%1", _c];
			private _m = createMarker [_n, getPosWorld _trap];
			_m setMarkerType "mil_dot";
			_m setMarkerColor "ColorBrown";
			_m setMarkerText _n;
			_m setMarkerAlpha _debug;
			allTrapMkrs pushBack _m;
		};
	};

	if (count allTraps > _trapsC) exitWith {};
};

if (_rmE) then {{east revealMine _x} count allTraps};
if (_rmW) then {{west revealMine _x} count allTraps};
if (_rmI) then {{independent revealMine _x} count allTraps};
if (_rmC) then {{civilian revealMine _x} count allTraps};
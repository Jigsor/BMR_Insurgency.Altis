// JigIEDs.sqf by Jigsor
// Mines can be detected by anyone with IED detector

if (!hasInterface && !isDedicated) exitWith {};

JIG_IED_FX = {
	params ["_trig"];
	addCamShake [5, 5, 20];
	[player, 1] call BIS_fnc_dirtEffect;
	playSound3d['A3\Missions_F_EPA\data\sounds\combat_deafness.wss', _trig, false, getPosASL _trig, 15, 1, 50];
};
if (!isServer) exitWith {};

[] spawn {

	// Editable
	private _IEDs = 70;							//Total IED objects including decoys
	private _decoyChance = 25;					//Percent of decoy chance
	private _revealMines_East = true;			//Reveal IEDs to side EAST
	private _revealMines_West = false;			//Reveal IEDs to side WEST
	private _revealMines_Independent = true;	//Reveal IEDs to side Independent/Resistance.
	private _revealMines_Civilian = true;		//Reveal IEDs to side Civilian.
	// End Editable

	private _IED_Debug = if (DebugEnabled isEqualTo 1) then {TRUE}else{FALSE}; //Show markers

	if (_IED_Debug && hasInterface) then {hintSilent format["attempting to create %1 IEDs...",_IEDs]};

	IEDtypes = ["IEDLandBig_F","IEDLandSmall_F","IEDUrbanBig_F","IEDUrbanSmall_F"];
	IEDblast = ["Bo_Mk82","Rocket_03_HE_F","M_Mo_82mm_AT_LG","Bo_GBU12_LGB","Bo_GBU12_LGB_MI10","HelicopterExploSmall"];

	private _roads = [worldsize/2, worldsize/2] nearRoads worldsize;

	{
		if ((["bridge", getModelInfo _x select 0] call BIS_fnc_inString) ||
		(_x distance2D (getMarkerPos "Respawn_West") < 750) ||
		(_x distance2D (getMarkerPos "Airfield") < 1000) ||
		(_x distance2D (getMarkerPos "Respawn_East") < 200)) then {
			_roads = _roads - [_x];
		};
	} forEach _roads;

	if (!isNil "allMkrs") then {{deleteMarker _x} forEach allMkrs;};
	if (!isNil "allIEDS") then {{deleteVehicle _x} forEach allIEDS;};

	allMkrs = [];
	allIEDS = [];
	private _n = 0;
	private _iedPosList = [];

	private ["_r","_road","_name","_m"];

	while{count _roads > 0 && count allIEDS < _IEDs} do {
		_r = (count _roads - 1) min (round random (count _roads));
		_road = _roads select _r;
		_roads = _roads - [_road];

		if (count roadsConnectedTo _road >= 2) then {

			private _type = selectRandom IEDtypes,
			private _roadSize = (boundingBox _road);
			private _roadSidePos = (_road modelToWorld [(_roadSize select 1 select 0) * 0.6, 0, 0]);
			private _position = _roadSidePos findEmptyPosition [0,2,_type];

			private "_ied";
			if (_position isEqualTo []) then {
				_ied = createMine [_type, getPos _road, [], random [4, 6, 8]];
			} else {
				_ied = createMine [_type, _position, [], 0];
			};
			_iedPosList pushBack (getPosATL _ied);
			allIEDS pushBack _ied;
			_ied setVariable ["persistent",true];

			_n = _n + 1;
			_name = format["IED_%1", _n];
			_m = createmarker [_name, getPosWorld _ied];
			_m setmarkertype "mil_dot";
			_m SetMarkerText _name;
			if (!_IED_Debug) then {_m setMarkerAlpha 0};
			allMkrs pushBack _m;
		};
	};

	private _Active_IED_count = round (_IEDs -((_decoyChance/100) *_IEDs));

	for "_i" from 1 to _Active_IED_count do {
		private ["_rIEDpos","_actCond","_onActiv","_IEDtrig"];

		_rIEDpos = selectRandom _iedPosList;
		_iedPosList = _iedPosList - [_rIEDpos];

		_actCond = "this && {vehicle _x in thisList} count playableUnits > 0 && {mineActive _x} count (getPosATL thisTrigger nearObjects ['TimeBombCore', 2]) > 0";
		_onActiv = "
			selectRandom IEDblast createVehicle getPosATL thisTrigger;
			{
				_irP = _x;
				[thisTrigger] remoteExec ['JIG_IED_FX', _irP, false];
			} forEach thisList;
			{deleteVehicle _x;} count nearestObjects [getPosATL thisTrigger, IEDtypes, 2, true];
		";
		_onDeActiv = "deleteVehicle thisTrigger";

		_IEDtrig = createTrigger ["EmptyDetector", _rIEDpos];
		_IEDtrig setTriggerArea [2, 2, 0, FALSE];
		_IEDtrig setTriggerActivation ["WEST", "PRESENT", true];
		_IEDtrig setTriggerTimeout [1, 1, 1, true];
		_IEDtrig setTriggerStatements [_actCond, _onActiv, _onDeActiv];
	};

	if (_revealMines_East) then {{east revealMine _x} foreach allIEDS};
	if (_revealMines_West) then {{west revealMine _x} foreach allIEDS};
	if (_revealMines_Independent) then {{independent revealMine _x} foreach allIEDS};
	if (_revealMines_Civilian) then {{civilian revealMine _x} foreach allIEDS};
};
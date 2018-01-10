// JigIEDs.sqf by Jigsor
// Cleans up all previously created mines + markers and randomly places new ones each time script runs. Placed on road and road side.
// Mines can be detected by anyone with IED detector.

if (!isServer) exitWith {};
[] spawn {

	// Editable
	private _IEDs = 70;			//Total IED objects including decoys
	private _decoyChance = 25;	//Percent of decoy chance
	private _rmE = true;		//Reveal IEDs to side EAST
	private _rmW = false;		//Reveal IEDs to side WEST
	private _rmI = true;		//Reveal IEDs to side Independent/Resistance.
	private _rmC = true;		//Reveal IEDs to side Civilian.
	// End Editable

	private _debug = DebugEnabled;//Show markers
	private _roads = [worldsize/2, worldsize/2] nearRoads worldsize;
	IEDtypes = ["IEDLandBig_F","IEDLandSmall_F","IEDUrbanBig_F","IEDUrbanSmall_F"];
	IEDblast = ["Bo_Mk82","Rocket_03_HE_F","M_Mo_82mm_AT_LG","Bo_GBU12_LGB","Bo_GBU12_LGB_MI10","HelicopterExploSmall"];

	if (_debug isEqualTo 1) then {
		private _txt = format["attempting to create %1 IEDs...", _IEDs];
		_txt remoteExec ['JIG_MPhint_fnc', [0,-2] select isDedicated];
	};

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
			_pos = _roadSidePos findEmptyPosition [0,2,_type];

			private "_ied";
			if (_pos isEqualTo []) then {
				_ied = createMine [_type, getPos _road, [], random [4, 6, 8]];
			} else {
				_ied = createMine [_type, _pos, [], 0];
			};
			_iedPosList pushBack (getPosATL _ied);
			allIEDS pushBack _ied;
			_ied setVariable ["persistent",true];

			_n = _n + 1;
			_name = format["IED_%1", _n];
			_m = createMarker [_name, getPosWorld _ied];
			_m setMarkerType "mil_dot";
			_m setMarkerText _name;
			_m setMarkerAlpha _debug;
			allMkrs pushBack _m;
		};
	};

	private _trigs = [];
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
		_IEDtrig setTriggerTimeout [0.5, 0.5, 0.5, true];
		_IEDtrig setTriggerStatements [_actCond, _onActiv, _onDeActiv];
		_trigs pushBack _IEDtrig;
	};

	sleep 2;
	{_x hideObjectGlobal true} forEach _trigs;
	sleep 5;
	{_x hideObject false} forEach _trigs;

	if (_rmE) then {{east revealMine _x} count allIEDS};
	if (_rmW) then {{west revealMine _x} count allIEDS};
	if (_rmI) then {{independent revealMine _x} count allIEDS};
	if (_rmC) then {{civilian revealMine _x} count allIEDS};
};
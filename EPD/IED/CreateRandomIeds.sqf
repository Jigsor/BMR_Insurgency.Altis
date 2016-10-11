_origin = (_this select 0);
_distance = (_this select 1);
_side = (_this select 2);
_iedAmountToPlace = (_this select 3);
_fakeAmountToPlace = (_this select 4);
_iedCounterOffset = (_this select 5);
_fakeCounterOffset = (_this select 6);
_sectionNumber = (_this select 7);
_counter = 0;

_roads = (_origin nearRoads _distance) - safeRoads;
_roadCount = count _roads;
if(_roadCount > 0) then {
	while{_counter < _iedAmountToPlace} do {

		_iedSize = [] call GET_SIZE_AND_TYPE;
		_iedType = _iedSize select 1;
		_iedSize = _iedSize select 0;
		_iedPos = [_roads, _roadCount] call FIND_LOCATION_BY_ROAD;
		[_iedCounterOffset+_counter, _iedPos, _iedSize, _iedType, _side] call CREATE_IED;	
		if((disarmedSections select _sectionNumber) == "") then {
			disarmedSections set [_sectionNumber, format["isNull t_%1 && ! isNull ied_%1", _iedCounterOffset+_counter]];
			explodedSections set [_sectionNumber, format["isNull ied_%1", _iedCounterOffset+_counter]];
		} else {
			disarmedSections set [_sectionNumber, format["%2 && isNull t_%1 && ! isNull ied_%1", _iedCounterOffset+_counter, disarmedSections select _sectionNumber]];
			explodedSections set [_sectionNumber, format["%2 || isNull ied_%1", _iedCounterOffset+_counter, explodedSections select _sectionNumber]];
		};
		_counter = _counter + 1;
	};

	_counter = 0;
	while{_counter < _fakeAmountToPlace} do {

		_junkType = ([] call GET_SIZE_AND_TYPE) select 1;
		_junkPosition = [_roads, _roadCount] call FIND_LOCATION_BY_ROAD;
		[_fakeCounterOffset+_counter,_junkPosition, _junkType] call CREATE_FAKE;
		_counter = _counter + 1;
	};
} else {
	while{_counter < _iedAmountToPlace} do {
		eventHandlers set[_iedCounterOffset+_counter, "true;"];
		_counter = _counter + 1;
	};
	if((disarmedSections select _sectionNumber) == "") then {
		disarmedSections set [_sectionNumber, "true"];
		explodedSections set [_sectionNumber, "false"];
	} else {
		disarmedSections set [_sectionNumber, format["%1 && true", disarmedSections select _sectionNumber]];
		explodedSections set [_sectionNumber, format["%2 || false", explodedSections select _sectionNumber]];
	};
};
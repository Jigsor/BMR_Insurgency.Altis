_placesToKeep = ["NameCityCapital","NameCity","NameVillage", "NameLocal"];
_cities = ["NameCityCapital","NameCity"];
_villages = ["NameVillage"];
_locals = ["NameLocal"];
placesOfInterest = [];
cities = [];
villages = [];
locals = [];
_placesCfg = configFile >> "CfgWorlds" >> worldName >> "Names";
_allCounter = 0;
_cityCounter = 0;
_villageCounter = 0;
_localCounter = 0;
for "_i" from 0 to (count _placesCfg)-1 do
{
	_place = _placesCfg select _i;
	_name =	getText(_place >> "name");
	_sizeX = getNumber (_place >> "radiusA");
    _sizeY = getNumber (_place >> "radiusB");
	_avgSize = (_sizeX+_sizeY)/2;
	_position = getArray (_place >> "position");
	_type = getText(_place >> "type");
	if(_type in _placesToKeep) then	{
		placesOfInterest set [_allCounter, [_name, _position, _avgSize]];
		_allCounter = _allCounter + 1;
	};
	if(_type in _cities) then {
		cities set [_cityCounter, [_name, _position, _avgSize]];
		_cityCounter = _cityCounter + 1;
	};
	if(_type in _villages) then	{
		villages set [_villageCounter, [_name, _position, _avgSize]];
		_villageCounter = _villageCounter + 1;
	};
	if(_type in _locals) then {
		locals set [_localCounter, [_name, _position, _avgSize]];
		_localCounter = _localCounter + 1;
	};
};
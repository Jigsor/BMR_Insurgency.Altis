_roads = _this select 0;
_roadCount = _this select 1;
_orthogonalDist = 5;
_road = _roads select(floor random(_roadCount));
_dir = 0;
if(count (roadsConnectedTo _road) > 0) then {
	_dir  = [_road, (roadsConnectedTo _road) select 0] call BIS_fnc_DirTo;
};
_position = getpos _road;
_opositionX = _position select 0;
_opositionY = _position select 1;

_offSetDirection = 1;
if((random 100) > 50) then { _offSetDirection = -1;};

_positionX = _opositionX + (random 5) * _offSetDirection * sin(_dir);
_positionY = _opositionY + (random 5) * _offSetDirection * cos(_dir);

if((random 100) > 50) then { _offSetDirection = -1 * _offSetDirection;};

_tx = _positionX;
_ty = _positionY;

while{isOnRoad [_tx,_ty,0]} do{
	_orthogonalDist = _orthogonalDist + _offSetDirection;
	_tx = (_positionX + (_orthogonalDist * cos(_dir)));
	_ty = (_positionY + (_orthogonalDist * sin(_dir)));
};

_extraOffSet = 1 + random 5;
//move it off the road a random amount
_tx = (_positionX + ((_orthogonalDist + _extraOffSet *_offSetDirection) * cos(_dir)));
_ty = (_positionY + ((_orthogonalDist + _extraOffSet *_offSetDirection) * sin(_dir)));

//ensure we didn't put it on another road, this happens a lot at Y type intersections
while{isOnRoad [_tx,_ty,0]} do
{
	_extraOffSet = _extraOffSet - 0.5;
	_tx = (_positionX + ((_orthogonalDist + _extraOffSet *_offSetDirection) * cos(_dir)));
	_ty = (_positionY + ((_orthogonalDist + _extraOffSet *_offSetDirection) * sin(_dir)));
};

[_tx,_ty,0];
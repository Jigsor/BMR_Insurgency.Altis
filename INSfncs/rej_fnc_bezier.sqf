////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-- This script is a Bezier Curve function and will return a specified number of points along the Bezier Curve --//
//call with:
//_curvePosArr = [startPos,endPos,controlPos,4,true,true] call rej_fnc_bezier;
//hint format["POSITIONS RETURNED: %1",(curvePositionsArray)];
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
private["_vector1","_vector2","_controlVector","_numberOfPoints","_removeStartPos","_x","_y","_increments","_positions"];
_vector1 = _this select 0;
_vector2 = _this select 1;
_controlVector = _this select 2;
_numberOfPoints = _this select 3;
_removeStartPos = _this select 4;
_debug_mkr = _this select 5;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-- Double distance for the control vector to make the peak of the curve pass through the controlVector --//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
_midPoint_1 = ((_vector1 select 0) + (_vector2 select 0)) / 2;
_midPoint_2 = ((_vector1 select 1) + (_vector2 select 1)) / 2;
_midPoint = [_midPoint_1,_midPoint_2,0];
_midPoint_1 = ((_vector1 select 0) + (_vector2 select 0)) / 2;
_midPoint_2 = ((_midPoint select 1) + (_midPoint select 1)) / 2;
_midPoint = [_midPoint_1,_midPoint_2,0];
_vectorDiff = _controlVector vectorDiff _midPoint;
_controlVector = _controlVector vectorAdd _vectorDiff;
/////////////////////////
//-- Calculate curve --//
/////////////////////////
if (_numberOfPoints >= 1) then
{
	_increments = 1 / _numberOfPoints;
	_positions = [];
	for [{_i = 0.0},{_i <= 1},{_i =_i + _increments}] do {
		_x = ((1 - _i) * (1 - _i) * (_vector1 select 0) + 2 * (1 - _i) * _i * (_controlVector select 0) + _i * _i * (_vector2 select 0));
		_y =((1 - _i) * (1 - _i) * (_vector1 select 1) + 2 * (1 - _i) * _i * (_controlVector select 1) + _i * _i * (_vector2 select 1));
		if (_debug_mkr) then
		{
			_markname = format["%1 %2%3",("testmarker"),(ceil random 999),(ceil random 999),(ceil random 999)];
			_marker = createMarker [_markname,[_x,_y,0]];
			_markname setMarkerType "hd_dot";
			_markname setMarkerColor "ColorBlack";
		};
		_positions pushback [_x,_y,0];
	};
	if (_removeStartPos) then
	{
		_positions deleteAt 0;
	};
} else {
	_positions = _vector2;
};
_positions
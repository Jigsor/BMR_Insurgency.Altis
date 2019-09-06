/*
Modified version of BIS_fnc_objectMapper
by Jigsor
Parameters:
Array - center position
Direction - Scalar
Array
*/
params [["_newPos",[0,0,0],[[]]], ["_dir",0,[0]], ["_data",[],[[]]]];
_newPos params ["_posX","_posY"];

private _multiplyMatrixFunc = {
	params ["_array1","_array2"];
	_result = [
		(((_array1 select 0) select 0)*(_array2 select 0))+(((_array1 select 0) select 1)*(_array2 select 1)),
		(((_array1 select 1) select 0)*(_array2 select 0))+(((_array1 select 1) select 1)*(_array2 select 1))
	];
	_result
};

for "_i" from 0 to (count _data) - 1 step 1 do {
	(_data # _i) params ["_obj","_relPos","_azimuth"];
	private _rotMatrix =[[cos _dir, sin _dir],[-(sin _dir), cos _dir]];
	private _newRelPos = [_rotMatrix, _relPos] call _multiplyMatrixFunc;
	private _newDir = (_dir + _azimuth);
	if (_newDir < 0) then {_newDir = _newDir + 360};
	if (_newDir > 360) then {_newDir = _newDir - 360};
	_obj setDir _newDir;
	_obj setPos [_posX + (_newRelPos select 0), _posY + (_newRelPos select 1), _relPos # 2];
};
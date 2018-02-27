/*
Modified version of BIS_fnc_objectGrabber
by Jigsor
Parameters:
Array - list of objects
Array - center position
*/
params [["_objs",[ObjNull],[[]]], ["_anchorPos",[0,0,0],[[]]]];
private _return = [];
for "_i" from 0 to ((count _objs) - 1) do {
	private ["_obj","_objPos","_dX","_dY","_z","_dir"];
	_obj = _objs select _i;
	//_objPos = getPosWorld _obj;
	_objPos = getPosATL _obj;
	if (!isNull _obj) then {
		_objPos = getPosATL _obj;
		_dX = (_objPos select 0) - (_anchorPos select 0);
		_dY = (_objPos select 1) - (_anchorPos select 1);
		_z = if (isTouchingGround _obj) then {0} else {_objPos select 2};
		_dir = direction _obj;
		_return pushBack [_obj,[_dX,_dY,_z],_dir];
	};
};
_return
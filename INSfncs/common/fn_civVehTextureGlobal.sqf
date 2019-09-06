params ["_veh"];
private _textures = getObjectTextures _veh;

/*
{
	_veh setObjectTextureGlobal [_forEachIndex, _x];
} forEach _textures;
*/

private _c = 0;
{
	_veh setObjectTextureGlobal [_c, _x];
	_c = _c + 1;
} forEach _textures;
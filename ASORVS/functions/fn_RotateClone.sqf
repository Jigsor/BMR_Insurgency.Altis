if(ASORVS_Rotating) then {
	ASORVS_CurrentRotation = (getDir ASORVS_Clone) +  (_this select 1) * 10;
	ASORVS_Clone setDir ASORVS_CurrentRotation;
};
if(ASORVS_MovingY) then {
	ASORVS_CurrentY = ASORVS_CurrentY + ((_this select 2)* 0.01);
	ASORVS_CurrentY = (0.5 - ASORVS_CurrentZoom*0.5) max ASORVS_CurrentY;
	ASORVS_CurrentY = (0.5 + ASORVS_CurrentZoom*0.5) min ASORVS_CurrentY;
	_cameraPos = [ASORVS_CameraPosMinZoom, ASORVS_CameraPosMaxZoom, ASORVS_CurrentZoom] call ASORVS_fnc_vectorLerp;
	_y = ASORVS_CameraMinY + ((ASORVS_CameraMaxY - ASORVS_CameraMinY) * ASORVS_CurrentY);
	_cameraPos set [2,_y];
	_cameraTarget = [ASORVS_CameraTargetMinZoom, ASORVS_CameraTargetMaxZoom, ASORVS_CurrentZoom]  call ASORVS_fnc_vectorLerp;
	_cameraTarget set [2,_y];
	ASORVS_Camera setPosATL _cameraPos;
	ASORVS_CameraTarget setPosATL _cameraTarget;
	ASORVS_Camera camCommitPrepared 0.2;
};
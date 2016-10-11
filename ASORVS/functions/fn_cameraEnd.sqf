player cameraEffect ["terminate","back"];
camDestroy ASORVS_Camera;
BIS_DEBUG_CAM = nil;
detach ASORVS_Clone;
deleteVehicle ASORVS_Clone;
ASORVS_Clone = nil;
deleteVehicle ASORVS_Platform;
deleteVehicle ASORVS_Background;
deleteVehicle ASORVS_Light;
{ deleteVehicle _x;  } forEach ASORVS_Backgrounds;

deleteVehicle ASORVS_CameraTarget;
camDestroy ASORVS_RenderTarget;

if (player getVariable "cancelCreate") then {
	player setVariable ["createEnabled", true];
	player sideChat localize "STR_BMR_postpone_reward";
	deleteMarkerLocal "VehDrop";
};
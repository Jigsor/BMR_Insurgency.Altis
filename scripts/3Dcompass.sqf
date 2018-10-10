/*
3Dcompass.sqf
Credit to KillZoneKid for original code. http://killzonekid.com/arma-scripting-tutorials-3d-compass/
Adapted by Jigsor to run when player in Helicopter and has Gunner View. Remove next line in description.ext to disable script.
(_this select 0) addAction['Gunner 3D Compass', {execVM 'scripts\3Dcompass.sqf'; (_this select 0)removeAction(_this select 2);}, [], -1.1, false, true, 'holdBreath', '_target==(vehicle _this)'];
*/
sleep 0.5;
waitUntil {sleep 2; (cameraView isEqualTo "GUNNER") || (isNull objectParent player)};
if (isNull objectParent player) exitWith {};
INSheliVehP = vehicle player;

INS3Dcomp = addMissionEventHandler ["EachFrame", {

	{
		_center = positionCameraToWorld [0,0,3];//need something better to handle moving vehicle
		_x params ["_letter", "_color", "_offset1", "_offset2"];
		drawIcon3D ["", _color, _center vectorAdd _offset1, 0, 0, 0, _letter, 2, 0.05, "PuristaMedium"];
		drawIcon3D ["",	_color, _center vectorAdd _offset2, 0, 0, 0, ".", 2, 0.05, "PuristaMedium"];
	} count [
		["N",[1,1,1,1],[0,1,0],[0,0.5,0]],
		["S",[1,1,1,0.7],[0,-1,0],[0,-0.5,0]],
		["E",[1,1,1,0.7],[1,0,0],[0.5,0,0]],
		["W",[1,1,1,0.7],[-1,0,0],[-0.5,0,0]]
	];

	if ((INSheliVehP != vehicle player) || (cameraView != "GUNNER")) then {
		if (cameraView != "GUNNER" && INSheliVehP == vehicle player) then { execVM "scripts\3Dcompass.sqf"; };
		if (INSheliVehP != vehicle player && alive INSheliVehP) then {
			0 spawn {
				_3dcact = (vehicle INSheliVehP) addAction["Gunner 3D Compass", {execVM "scripts\3Dcompass.sqf";(_this select 0)removeAction(_this select 2);}, [], -1.1, false, true, "holdBreath", "_target==(vehicle _this)"];
			};
		};
		removeMissionEventHandler ["EachFrame", _thisEventHandler];
	};

}];
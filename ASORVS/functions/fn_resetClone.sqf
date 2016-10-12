#include "macro.sqf"
private ["_currentVehicle", "_desiredVehicle", "_clonepos"];
disableSerialization;
if(isNil 'ASORVS_Clone') then {ASORVS_Clone = objNull;};
_currentVehicle = typeOf ASORVS_Clone;
_desiredVehicle = ASORVS_CurrentVehicle;
if(_currentVehicle != _desiredVehicle) then {
	deleteVehicle ASORVS_Clone;
	if(_desiredVehicle != "") then {
		ASORVS_Clone = ASORVS_CurrentVehicle createVehicleLocal ASORVS_ClonePos;
		ASORVS_Clone setPosATL ASORVS_ClonePos;
		_vehcfg = (configFile >> "cfgVehicles" >> _desiredVehicle);
		_bottom = 0;
		if(isClass (_vehcfg >> "Wheels") && {count (_vehcfg >> "Wheels") > 0}) then {
			_wheel = (_vehcfg >> "Wheels") select 0;
			_wheelcenter = ASORVS_Clone selectionPosition getText (_wheel >> "center");
			_wheelboundary = ASORVS_Clone selectionPosition getText (_wheel >> "boundary");
			_bottom = (_wheelcenter select 2) - (_wheelboundary distance _wheelcenter);
		}else{
			//ASORVS_Clone setPosATL ASORVS_ClonePos;
			//_bottom = ((((ASORVS_Clone modelToWorld [0,0,0])) select 2) - (getPos ASORVS_Clone select 2));
			/*_driveon = getArray (_vehcfg >> "driveOnComponent");
			if ((count _driveon > 0)) then {
				_wheelcenter = ASORVS_Clone selectionPosition ((_driveon select (count _driveon - 1)));
				_bottom = (_wheelcenter select 2);// + ((getNumber (_vehcfg >> "wheelCircumference"))/(Pi*2)); 
			}else{
				_bounds = boundingBox ASORVS_Clone;
				_bottom = (_bounds select 0 select 2) min (_bounds select 1 select 2);
			};*/
		};
		_bounds = boundingBox ASORVS_Clone;
		_length = abs((_bounds select 0 select 1) - (_bounds select 1 select 1));
		_miny = (_bounds select 0 select 1) min (_bounds select 1 select 1);
		//-(_miny)+(_length*0.5)
		ASORVS_Clone attachTo [ASORVS_Platform, [0,0,20 - _bottom]];
		if(_bottom == 0) then {
			_bottom = ((getPosATL ASORVS_Clone) select 2) - ((getPosATL ASORVS_Platform) select 2) - 20;
			detach ASORVS_Clone;
			ASORVS_Clone attachTo [ASORVS_Platform, [0,0,21 - _bottom]];
		};
		ASORVS_Clone setDir ASORVS_CurrentRotation;
		ASORVS_Clone engineOn true;
		ASORVS_Clone setPilotLight true;
		ASORVS_Clone setCollisionLight true;

		_fov = 0.3 max ((sizeOf _desiredVehicle) / 40);
		ASORVS_Camera camPrepareFOV _fov;
		ASORVS_Camera camCommitPrepared 2;
	};
	_description = [ASORVS_Clone] call ASORVS_fnc_GetDescription;
	_descriptionControl = ASORVS_getControl(ASORVS_Main_Display, ASORVS_Description);
	_descriptionControl ctrlSetStructuredText parseText _description;
	_descriptionHeight = ctrlTextHeight _descriptionControl;
	_descriptionPos = ctrlPosition _descriptionControl;
	_descriptionPos set [1, safezoneY + (3/25)];
	_descriptionControl ctrlSetPosition _descriptionPos;
	_descriptionControl ctrlCommit 0;
};
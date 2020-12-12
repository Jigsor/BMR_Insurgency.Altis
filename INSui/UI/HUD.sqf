ICE_HUD = {
	waitUntil {!isNull player};

	disableSerialization;
	("ICE_Layer" call BIS_fnc_rscLayer) cutRsc ["TAG_ICEHUD","PLAIN"];

	_display = uiNamespace getVariable "TAG_ICE_display";
	_ctrlDir = _display displayCtrl 520500;
	_ctrlFps = _display displayCtrl 520501;
	_ctrlHps = _display displayCtrl 520502;
	_ctrlSta = _display displayCtrl 520503;

	private "_heading";
	while {!isNull _display} do {

		sleep 0.1;
		_ctrlFps ctrlSetText format ["%1", round diag_fps];
		_ctrlHps ctrlSetText format ["%1%2", round((1 - (damage player)) * 100), "%"];
		_ctrlSta ctrlSetText format ["%1%2", round((1 - (getFatigue player)) * 100), "%"];

		switch (true) do {
			case (GetDammage Player < 0.25): {_ctrlHps ctrlSetTextColor [0,0.5,0,1]};
			case (GetDammage Player >= 0.25): {_ctrlHps ctrlSetTextColor [1,1,0,1]};
			case (GetDammage Player >= 0.5): {_ctrlHps ctrlSetTextColor [1,0.645,0,1]};
			case (GetDammage Player >= 0.75): {_ctrlHps ctrlSetTextColor [1,0,0,1]};
			case (getFatigue Player < 0.20): {_ctrlSta ctrlSetTextColor [0,0,1,1]};
			case (getFatigue Player >= 0.20): {_ctrlSta ctrlSetTextColor [1,1,0,1]};
			case (getFatigue Player >= 0.40): {_ctrlSta ctrlSetTextColor [1,0.645,0,1]};
			case (getFatigue Player >= 0.60): {_ctrlSta ctrlSetTextColor [1,0,0,1]};
		};

		_dir = if (isNull objectParent player) then {getDir player}else{getDir vehicle player};

		_heading = call {
			_dir45 = round (_dir/45) ;
			if (_dir45 == 1) exitWith {"NE"};
			if (_dir45 == 2) exitWith {"E"};
			if (_dir45 == 3) exitWith {"SE"};
			if (_dir45 == 4) exitWith {"S"};
			if (_dir45 == 5) exitWith {"SW"};
			if (_dir45 == 6) exitWith {"W"};
			if (_dir45 == 7) exitWith {"NW"};
			"N"
		} ;

		_ctrlDir ctrlSetText format ["%1", _heading];
    };
};
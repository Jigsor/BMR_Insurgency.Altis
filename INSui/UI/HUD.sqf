ICE_HUD = 
{
    waitUntil {!isNull player};
    if (!local Player) exitWith {};

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
            case (GetDammage Player < 0.25): {_ctrlHps ctrlSetTextColor [0,0.5,0,1];};
            case (GetDammage Player >= 0.25): {_ctrlHps ctrlSetTextColor [1,1,0,1];};
            case (GetDammage Player >= 0.5): {_ctrlHps ctrlSetTextColor [1,0.645,0,1];};
            case (GetDammage Player >= 0.75): {_ctrlHps ctrlSetTextColor [1,0,0,1];};
		    case (getFatigue Player < 0.20): {_ctrlSta ctrlSetTextColor [0,0,1,1];};
            case (getFatigue Player >= 0.20): {_ctrlSta ctrlSetTextColor [1,1,0,1];};
            case (getFatigue Player >= 0.40): {_ctrlSta ctrlSetTextColor [1,0.645,0,1];};
            case (getFatigue Player >= 0.60): {_ctrlSta ctrlSetTextColor [1,0,0,1];};
		};

		If (vehicle player != player) Then {
            _dir = getDir vehicle player;
			switch (true) do {
			    case (_dir >= 337.5 || _dir < 22.5): {_heading = "N";};
				case (_dir >= 292.5 && _dir < 337.5): {_heading = "NW";};
				case (_dir >= 247.5 && _dir < 292.5): {_heading = "W";};
			    case (_dir >= 202.5 && _dir < 247.5): {_heading ="SW";};
			    case (_dir >= 157.5 && _dir < 202.5): {_heading ="S";};
				case (_dir >= 112.5 && _dir < 157.5): {_heading ="SE";};
				case (_dir >= 67.5 && _dir < 112.5): {_heading ="E";};
				case (_dir >= 22.5 && _dir < 67.5): {_heading ="NE";};
			};
			_ctrlDir ctrlSetText format ["%1", _heading];

        } Else {
            _dir = getDir player;
		    switch (true) do {
			    case (_dir >= 337.5 || _dir < 22.5): {_heading = "N";};
				case (_dir >= 292.5 && _dir < 337.5): {_heading = "NW";};
			    case (_dir >= 247.5 && _dir < 292.5): {_heading = "W";};
				case (_dir >= 202.5 && _dir < 247.5): {_heading ="SW";};
				case (_dir >= 157.5 && _dir < 202.5): {_heading ="S";};
				case (_dir >= 112.5 && _dir < 157.5): {_heading ="SE";};
				case (_dir >= 67.5 && _dir < 112.5): {_heading ="E";};
				case (_dir >= 22.5 && _dir < 67.5): {_heading ="NE";};
			};
			_ctrlDir ctrlSetText format ["%1", _heading];
        };
    };
};
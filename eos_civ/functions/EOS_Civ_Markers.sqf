_eosMkrsCiv=server getvariable ["EOSmarkersCiv", []];

{_x setMarkerAlpha (MarkerAlpha _x);
_x setMarkercolor (markerColor _x);
}foreach _eosMkrsCiv;

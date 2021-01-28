_eosMarkers=server getvariable ["EOSmarkers", []];

{_x setMarkerAlpha (markerAlpha _x);
_x setMarkercolor (markercolor _x);
}foreach _eosMarkers;

_eosMarkers=server getvariable "EOSmarkersCiv";

{_x setMarkerAlpha (MarkerAlpha _x);
_x setMarkercolor (getMarkercolor _x);
}foreach _eosMarkers;

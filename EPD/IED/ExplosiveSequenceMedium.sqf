params ["_iedPosition","_ied","_iedNumber"];
_explosiveSequence = ["M_Titan_AA_long","HelicopterExploSmall","M_PG_AT","M_Titan_AT"];

[_iedPosition, _explosiveSequence, _ied, _iedNumber] spawn INITIAL_EXPLOSION;
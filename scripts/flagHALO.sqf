hint "Click on the map where you want to be dropped!.";
openMap true;

onMapSingleClick {
    onMapSingleClick {};
	player setpos _pos; 
	[player, 1500, false, true, true] call COB_fnc_HALO;
	hint '';
	openMap false;
	true
};
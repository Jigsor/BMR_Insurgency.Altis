// Add any Stacked Event Handler key that is running on server added by mods currently running on server to StackedEHkeysWhiteList and update list for clients.
// No stacked EHs are removed here. They are only detected and added to list.
if (isServer) then {

	if (isNil "StackedEHkeysWhiteList") then {
		StackedEHkeysWhiteList = ["CBA_PFH","updateEOSmkrs","smokeNear","BABE_MAINLOOP","processPlayerPositionsHandler"];
	};

	{
		_event = _x;
		_namespaceId = "BIS_stackedEventHandlers_";
		_namespaceEvent = _namespaceId + _event;
		_data = missionNameSpace getVariable [_namespaceEvent, []];
		{
			private ["_itemId","_allowed","_serverKey"];
			_allowed = _data select count _data -1 select 0;
			if (_allowed in StackedEHkeysWhiteList) then {
				_data deleteAt count _data -1;
			}else{
				_serverKey = _data select (count _data)-1;
				StackedEHkeysWhiteList pushBack _serverKey;
			};
		} foreach _data;
	} forEach ["oneachframe", "onpreloadstarted", "onpreloadfinished", "onmapsingleclick", "onplayerconnected", "onplayerdisconnected"];
	publicVariable "StackedEHkeysWhiteList";
	StackedEHkeysWhiteList
};
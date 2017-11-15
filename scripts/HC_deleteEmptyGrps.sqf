// Delete empty groups on Headless Client.
if (!hasInterface && !isDedicated) then	{
	waitUntil {time > 150};
	sleep (random 30);
	while {true} do {
		sleep 400.0123;		
		{
			if ((count (units _x)) == 0) then {
				deleteGroup _x;
				_x = grpNull;
				_x = nil
			}
		} forEach allGroups;
	};
};
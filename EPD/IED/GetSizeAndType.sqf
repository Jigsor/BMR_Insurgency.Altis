_size = "SMALL";
 r = floor random (smallChance+mediumChance+largeChance);
 if(r>smallChance) then {
	_size = "MEDIUM";
 };
 
 if(r>smallChance+mediumChance) then {
	_size = "LARGE";
 };

_type = "";
if(_size == "SMALL") then {
	_type = iedSmallItems select(floor random(iedSmallItemsCount));
} else {
	if(_size == "MEDIUM") then {
		_type = iedMediumItems select(floor random(iedMediumItemsCount));
	} else { //large
		_type = iedLargeItems select(floor random(iedLargeItemsCount));
	};
};
[_size,_type];
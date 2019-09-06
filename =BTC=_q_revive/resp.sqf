private _unit = _this;

_unit setVariable ["btc_qr_resp",true];

private _isPlayer = isPlayer _unit;

if (!btc_qr_AI_resp && {!_isPlayer}) exitWith {_unit setDamage 1;};

if (isMultiplayer) then
{
	if (_isPlayer) then
	{
		closeDialog 0;
		_unit setDamage 1;
		titleText ["","BLACK FADED"];
		0 spawn {
			waitUntil {Alive player};

			if (playerSide isEqualTo EAST) then {//Jig adding
				Op4handle = [player] execVM "scripts\MoveOp4Base.sqf";
				waitUntil { scriptDone Op4handle };
			};

			if (!isNil {_unit getVariable "btc_qr_on_respawn"}) then {
				_unit spawn (_unit getVariable "btc_qr_on_respawn");
			};
			if (btc_qr_multiple_spawn) exitWith {0 spawn btc_qr_fnc_multiple_spawn};
			titleText ["","PLAIN"];
			player call btc_qr_fnc_var
		};
	}else{
		_unit call btc_qr_fnc_resp_AI;
		if (!isNil {_unit getVariable "btc_qr_on_respawn"}) then {_unit spawn (_unit getVariable "btc_qr_on_respawn");};
	};
}
else
{
	if (_isPlayer) then
	{
		0 spawn {
			titleText ["","BLACK OUT",1];
			sleep 0.9;
			titleText ["","BLACK FADED"];
			closeDialog 0;

			player call btc_qr_fnc_resp_AI;
			if (!isNil {_unit getVariable "btc_qr_on_respawn"}) then {_unit spawn (_unit getVariable "btc_qr_on_respawn");};
			if (btc_qr_multiple_spawn) exitWith {0 spawn btc_qr_fnc_multiple_spawn};

			titleText ["","BLACK IN",2];
			sleep 3;
			titleText ["","PLAIN"];
		};
	}else{
		_unit call btc_qr_fnc_resp_AI;
		if (!isNil {_unit getVariable "btc_qr_on_respawn"}) then {_unit spawn (_unit getVariable "btc_qr_on_respawn");};
	};
};
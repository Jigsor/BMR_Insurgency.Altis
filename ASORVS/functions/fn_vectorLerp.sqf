_v1 = _this select 0;
_v2 = _this select 1;
_amount = _this select 2;

[((_v1 select 0) + (((_v2 select 0)-(_v1 select 0)) * _amount)), ((_v1 select 1) + (((_v2 select 1)-(_v1 select 1)) * _amount)), ((_v1 select 2) + (((_v2 select 2)-(_v1 select 2)) * _amount))];
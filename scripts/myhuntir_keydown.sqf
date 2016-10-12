
_key = _this select 1;

//player globalchat format ["key=%1", _key];
_step = 2;

//up arrow
if (_key == 205) then { movesatx = _step };
//down arrow
if (_key == 203) then { movesatx = -1 * _step };
//right arrow
if (_key == 200) then { movesaty = _step };
//left arrow
if (_key == 208) then { movesaty = -1 * _step };
//Numpad +
if (_key == 78) then { zoom = -0.01 };
//Numpad -
if (_key == 74) then { zoom = 0.01};
//Numpad Up
if (_key == 72) then { dive = _step };
//Numpad Down
if (_key == 80) then { dive = -1 * _step };


//az itt kovetkezo if-ben ha Arrowheadben hasznaljuk, akkor engedjuk a lck_nvg-t 2,3-nak is, nem csak 0,1-nek
//Numpad PgUp key
if (_key == 73) then {
 if (lck_nvg==0) then {
   false setCamUseTi 0; camUseNVG true;
   //camUseNVG true;
   lck_nvg=1;
 } else {
   if (lck_nvg==1) then {
     camUseNVG false; true setCamUseTi 0;
     lck_nvg=2;
   } else {
     if (lck_nvg==2) then {
       camUseNVG false; true setCamUseTi 1;
       lck_nvg=3;
     } else {
      if (lck_nvg==3) then {
         camUseNVG false; false setCamUseTi 0;
         lck_nvg=0;
       };
     };
   };


 };
};


if (_key == 71) then {
    lck_huntirreset = 1;
};

if (_key == 81) then {
    lck_marker = 1;
};


if (_key == 76) then {
  TitleText["                                        Quit: Numpad End,   NightVision: Numpad PgUp\n                                        Move: arrows,  Zoom: Numpad +/-,  Marker: Num PgDn\n                                        Help: Numpad 5,   Reset: Numpad Home","PLAIN DOWN"];
};


//Numpad End key
if (_key == 79) then { keyout = _key };
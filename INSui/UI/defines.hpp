  class IceBaseTextHUD
  {
	access = 0;
	type = CT_STATIC;
	style = ST_CENTER;
	idc = -1;
	colorBackground[] = {0,0,0,0};
	colorText[] = {1,1,1,0.8};
	text = "";
	fixedWidth = 0;
	x = 0;
	y = 0;
	h = 0;
	w = 0;
	shadow = 2;
	font = "puristaMedium";
	sizeEx = "0.035";

  };

  class IceBasePictureHUD
  {
	access = 0;
	type = CT_STATIC;
	style = 0x30 + 0x800;
	idc = -1;
	colorBackground[] = {0,0,0,0};
	colorText[] = {1,1,1,1};
	font = "puristaMedium";
	sizeEx = 0;
	lineSpacing = 0;
	text = "";
	fixedWidth = 0;
	shadow = 0;
	x = 0;
	y = 0;
	w = 0.2;
	h = 0.15;
  };

  class TAG_ICEHUD
  {
	idd = -1; 
	duration = 1e+1000;
	fadeIn = 0; 
	fadeOut = 0; 
	onLoad = "uiNamespace setVariable ['TAG_ICE_display', _this select 0];";

	class Controls 
	{

		class HUD_DIRECTION : IceBaseTextHUD
		{
			text = "";
			idc = 520500;
			sizeEx = "0.02 / (getResolution select 5)";
			x = 0.95 * safezoneW + safezoneX;
			y = 0.9125 * safezoneH + safezoneY;
			w = 0.02  * safezoneW;
			h = 0.02  * safezoneH;
		};

		class HUD_FPS : IceBaseTextHUD
		{
			text = "";
			sizeEx = "0.02 / (getResolution select 5)";
			idc = 520501;
			x = 0.949 * safezoneW + safezoneX;
			y = 0.9325 * safezoneH + safezoneY;
			w = 0.02  * safezoneW;
			h = 0.02  * safezoneH;
		};

		class HUD_HEALTH : IceBaseTextHUD
		{
			text = "";
			idc = 520502;
			sizeEx = "0.02 / (getResolution select 5)";
			x = 0.945 * safezoneW + safezoneX;
			y = 0.95 * safezoneH + safezoneY;
			w = 0.035  * safezoneW;
			h = 0.025  * safezoneH;
		};

		class HUD_fatigue : IceBaseTextHUD
		{
			text = "";
			idc = 520503;
			sizeEx = "0.02 / (getResolution select 5)";
			x = 0.945 * safezoneW + safezoneX;
			y = 0.9685 * safezoneH + safezoneY;
			w = 0.035  * safezoneW;
			h = 0.025  * safezoneH;
		};

		class HUD_compass_PIC : IceBasePictureHUD
		{
			text = "\A3\Weapons_F\Data\UI\gear_item_compass_ca.paa";
			idc = -1;
			x = 0.975 * safezoneW + safezoneX;
			y = 0.9075 * safezoneH + safezoneY;
			w = 0.025 * safezoneW;
			h = 0.025 * safezoneH;
		};

		class HUD_fps_PIC : IceBasePictureHUD
		{
			text = "images\fps.paa";
			idc = -1;
			x = 0.98 * safezoneW + safezoneX;
			y = 0.9325 * safezoneH + safezoneY;
			w = 0.015 * safezoneW;
			h = 0.015 * safezoneH;
		};

		class HUD_HEALTH_PIC : IceBasePictureHUD
		{
			text = "images\health.paa";
			idc = -1;
			x = 0.98 * safezoneW + safezoneX;
			y = 0.955 * safezoneH + safezoneY;
			w = 0.015 * safezoneW;
			h = 0.015 * safezoneH;
		};

		class HUD_fatigue_PIC : IceBasePictureHUD
		{
			text = "images\fatigue.paa";
			idc = -1;
			x = 0.98 * safezoneW + safezoneX;
			y = 0.97525 * safezoneH + safezoneY;
			w = 0.015 * safezoneW;
			h = 0.015 * safezoneH;
		};
   
	};

};
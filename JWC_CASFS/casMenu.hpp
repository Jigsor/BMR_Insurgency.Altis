class casMenu
{
	idd = 100001;
	movingEnable = 1;
	controlsBackground[] = {background};
	objects[] = {};
	onLoad="uiNamespace setVariable ['casMenu', _this select 0]";
	controls[] = {bgEdge,bottom,top,lineTop,lineBottom,btnRequest,btnCancel,btnDummy,btnExit,checkEdge,checkbg,Checkbox,mapbg,map,snapText,snapTitle,help};


	class background : JWC_BG
	{
		x = 0.0;
		y = 0.0;
		w = 0.525;
		h = 0.680";
		idc = 100199;
		colorBackground[] = {0, 0, 0, 1};
	};


	class bgEdge : JWC_Text
	{
  	        x = 0.001;
  	        y = 0.001;
  	        w = 0.522;
                h = 0.677;
		font = "PuristaSemibold";
		sizeEx = 0.03921;
		colorText[] = {0, 0, 0, 1};
		colorBackground[] = {0.65, 0.65, 0.65, 1};
                moving = 0;
		text = "";
	};	


	class btnExit: JWC_Button
        {
		idc = 100111;
		text = "Exit Menu";
		action = "closeDialog 0";
		y = 0.619;
                x = 0.400;
		w = 0.178;
		h = 0.090;
                color[] = {0, 0, 0, 1};
		colorFocused[] = { 1, 1, 1, 1 }; 
		colorBackgroundFocused[] = { 1, 1, 1, 0 };  
        	animTextureNormal   = "";
                animTextureDisabled = "";
        	animTextureOver     = "";
        	animTextureFocused  = "";
                animTexturePressed  = "";
        	animTextureDefault  = "";
		class TextPos 
		{
			left = 0.023;
			top = 0.027;
			right = 0.005;
			bottom = 0.005;
		};

	};


	class btnRequest: JWC_Button
        {
		idc = 100112;
		text = "Request CAS";
		action = "casRequest = true; abortCAS = false; closeDialog 0";
		y = 0.619;
		x = 0.006;
		w = 0.178;
		h = 0.090;
                color[] = {0, 0, 0, 1};
		colorFocused[] = { 1, 1, 1, 1 }; 
		colorBackgroundFocused[] = { 1, 1, 1, 0 };  
        	animTextureNormal   = "";
                animTextureDisabled = "";
        	animTextureOver     = "";
        	animTextureFocused  = "";
                animTexturePressed  = "";
        	animTextureDefault  = "";
		class TextPos 
		{
			left = 0.023;
			top = 0.027;
			right = 0.005;
			bottom = 0.005;
		};

	};
	

	class btnCancel: JWC_Button
        {
		idc = 100113;
		text = "Cancel CAS";
		action = "abortCAS = true; closeDialog 0";
		y = 0.619;
		x = 0.156;
		w = 0.178;
		h = 0.090;
                color[] = {0, 0, 0, 1};
		colorFocused[] = { 1, 1, 1, 1 }; 
		colorBackgroundFocused[] = { 1, 1, 1, 0 };  
        	animTextureNormal   = "";
                animTextureDisabled = "";
        	animTextureOver     = "";
        	animTextureFocused  = "";
                animTexturePressed  = "";
        	animTextureDefault  = "";
		class TextPos 
		{
			left = 0.023;
			top = 0.027;
			right = 0.005;
			bottom = 0.005;
		};

	};


	class btnDummy: JWC_Button
        {
		idc = 100114;
		text = "";
		action = "";
		y = -0.500;
		x = -0.500;
		w = 0.001;
		h = 0.001;
                color[] = {1, 1, 0, 0};
		colorFocused[] = { 1, 1, 1, 1 }; 
		colorBackgroundFocused[] = { 1, 1, 1, 0 };  
        	animTextureNormal   = "";
                animTextureDisabled = "";
        	animTextureOver     = "";
        	animTextureFocused  = "";
                animTexturePressed  = "";
        	animTextureDefault  = "";
		class TextPos 
		{
			left = 0.023;
			top = 0.027;
			right = 0.005;
			bottom = 0.005;
		};

	};


	class lineTop : JWC_Text
	{
		x = 0.001;
		y = 0.035;
		w = 0.522;
		h = 0.001;
		font = "PuristaSemibold";
		sizeEx = 0.03921;
		colorText[] = {0, 0, 0, 1};
		colorBackground[] = {0, 0, 0, 1};
                moving = 1;
		text = "";
	};


	class top : JWC_Text
	{
		x = 0.001;
		y = 0.001;
		w = 0.522;
		h = 0.033;
		font = "PuristaSemibold";
		sizeEx = 0.03921;
		colorText[] = {0, 0, 0, 1};
		colorBackground[] = {1,0.45,0,0.8};
                moving = 1;
		text = "CAS Field System";
	};	


	class lineBottom : JWC_Text
	{
		x = 0.001;
		y = 0.644;
		w = 0.522;
		h = 0.001;
		font = "PuristaSemibold";
		sizeEx = 0.03921;
		colorText[] = {0, 0, 0, 1};
		colorBackground[] = {0, 0, 0, 1};
                moving = 1;
		text = "";
	};


	class bottom : JWC_Text
	{
		x = 0.001;
		y = 0.645;
		w = 0.522;
		h = 0.033;
		font = "PuristaSemibold";
		sizeEx = 0.01521;
		colorText[] = {0.543, 0.5742, 0.4102, 0.80};
		colorBackground[] = {1,0.45,0,0.8};
                moving = 0;
		text = "";
	};


	class mapbg : JWC_Text
	{
		x = 0.011;
		y = 0.052;
		w = 0.502;
		h = 0.501;
		font = "PuristaSemibold";
		sizeEx = 0.01521;
		colorText[] = {0.543, 0.5742, 0.4102, 0.80};
		colorBackground[] = {0,0,0,1};
                moving = 0;
		text = "";
	};


	class map : JWC_Map
        {

		idc = 100115;
		x = 0.012;
		y = 0.054;
		w = 0.50;
		h = 0.5;
		colorBackground[] = {1, 1, 1, 1};
	};


	class Checkbox : JWC_CheckBox
	{
		idc = 100116;
		type = 7;
		style = 2;
  	        x = 0.011;
  	        y = 0.554;
  	        w = 0.503;
                h = 0.025;
		colorText[] = {1, 1, 1, 1};
		color[] = {0, 0, 0, 0};
		colorBackground[] = {0, 0, 1, 0.7};
		colorTextSelect[] = {1, 1, 1, 1};
		colorSelectedBg[] = {0, 0, 0, 1};
		colorSelect[] = {0, 0, 0, 1};
		colorTextDisable[] = {1, 1, 1, 1};
		colorDisable[] = {1, 1, 1, 1};
		font = "PuristaMedium";
		sizeEx = 0.0208333;
		rows = 1;
		columns = 3;
		strings[] = {"JDAM","CBU(AP)","JDAM/CBU(AP)"};
		checked_strings[] = {"JDAM","CBU(AP)","JDAM/CBU(AP)"};
       	        onCheckBoxesSelChanged = "if (_this select 1 == 0) then {casType = 'JDAM'}; if (_this select 1 == 1) then {casType = 'CBU'}; if (_this select 1 == 2) then {casType = 'COMBO'}";
	};


	class checkEdge : JWC_Text
	{
  	        x = 0.011;
  	        y = 0.554;
  	        w = 0.503;
                h = 0.027;
		font = "PuristaSemibold";
		sizeEx = 0.03921;
		colorText[] = {0, 0, 0, 1};
		colorBackground[] = {0, 0, 0, 1};
                moving = 0;
		text = "";
	};	


	class checkbg : JWC_Text
	{
  	        x = 0.012;
  	        y = 0.555;
  	        w = 0.500;
                h = 0.024;
		font = "PuristaSemibold";
		sizeEx = 0.03921;
		colorText[] = {0, 0, 0, 1};
		colorBackground[] = {0.65, 0.65, 0.65, 1};
                moving = 0;
		text = "";
	};

	class snapTitle : JWC_Text
	{
                idc = 100117;
                style = ST_LEFT;
		x = 0.012;
		y = 0.595;
		w = 0.302;
		h = 0.030;
		font = "TahomaB";
		sizeEx = 0.02000;
		colorText[] = {0,0,0,0.8};
		colorBackground[] = {0,0,0,0};
                moving = 0;
		text = "Press [A] to toggle 'Snap to nearest target' :";
	};

	class snapText : JWC_Text
	{
                idc = 100118;
                style = ST_LEFT;
		x = 0.311;
		y = 0.595;
		w = 0.15;
		h = 0.030;
		font = "TahomaB";
		sizeEx = 0.02000;
		colorText[] = {1, 0, 0, 0.5};
		colorBackground[] = {0,0,0,0};
                moving = 0;
		text = "<Disabled>";
	};


	class help : JWC_Text
	{
                idc = 100119;
		x = 0.012;
		y = 0.058;
		w = 0.500;
		h = 0.030;
		font = "TahomaB";
		sizeEx = 0.02300;
		colorText[] = {1,1,1,0.8};
		colorBackground[] = {0,0,0,0};
                moving = 0;
		text = "Click on map to designate target position";
	};
};
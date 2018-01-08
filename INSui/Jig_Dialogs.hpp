// by Jigsor

class Jig_Y_Menu {
	movingEnable = false;
	enableSimulation = true;
	idd = 29876;
	onLoad = "uiNamespace setVariable ['Jig_Y_Menu', _this select 0]";
	onUnLoad = "";

	class Controls {

		class Bg: Jig_RscPicture {
			idc = -1;
			text = "#(argb,8,8,3)color(0,0,0,0.7)";
			x = 0.42125 * safezoneW + safezoneX;
			y = 0.385174 * safezoneH + safezoneY;
			w = 0.1575 * safezoneW;
			h = 0.266059 * safezoneH;
		};
		class Client_Settings: Jig_RscButton {
			action = "closeDialog 0; call TAWVD_fnc_openTAWVD";
			idc = -1;
			text = "$STR_BMR_UI_view_settings";
			x = 0.425056 * safezoneW + safezoneX;
			y = 0.402819 * safezoneH + safezoneY;
			w = 0.15 * safezoneW;
			h = 0.045674 * safezoneH;
		};
		class Toggle_Heading: Jig_RscButton {
			action = "closeDialog 0; execVM 'scripts\heading.sqf'";
			idc = -1;
			text = "$STR_BMR_UI_toggle_heading";
			x = 0.425056 * safezoneW + safezoneX;
			y = 0.449589 * safezoneH + safezoneY;
			w = 0.15 * safezoneW;
			h = 0.045674 * safezoneH;
		};
		class Ice_Man_Hud: Jig_RscButton {
			action = "closeDialog 0; execVM 'INSui\staus_hud_toggle.sqf'";
			idc = -1;
			text = "$STR_BMR_UI_status_hud";
			x = 0.425056 * safezoneW + safezoneX;
			y = 0.496359 * safezoneH + safezoneY;
			w = 0.15 * safezoneW;
			h = 0.045674 * safezoneH;
		};
		class Ear_Plugs: Jig_RscButton {
			action = "closeDialog 0; call INS_EarPlugs";
			idc = -1;
			text = "$STR_BMR_earPlugs";
			x = 0.425056 * safezoneW + safezoneX;
			y = 0.543129 * safezoneH + safezoneY;
			w = 0.15 * safezoneW;
			h = 0.045674 * safezoneH;
		};
		class Amb_Life_Toggle: Jig_RscButton {
			action = "closeDialog 0; if (environmentEnabled select 0) then {enableEnvironment [false, (environmentEnabled select 1)]; hintSilent localize 'STR_BMR_OFF'} else {enableEnvironment [true, (environmentEnabled select 1)]; hintSilent localize 'STR_BMR_ON'}";
			idc = -1;
			text = "$STR_BMR_ambientLife";
			x = 0.425056 * safezoneW + safezoneX;
			y = 0.589899 * safezoneH + safezoneY;
			w = 0.15 * safezoneW;
			h = 0.045674 * safezoneH;
		};
		class Exit_Front {
			type = 0;
			idc = -1;
			style = 48;
			x = 0.565625 * safezoneW + safezoneX;
			y = 0.354368 * safezoneH + safezoneY;
			w = 0.013125 * safezoneW;
			h = 0.0280062 * safezoneH;
			font = "PuristaMedium";
			sizeEx = 0.04;
			colorBackground[] = {0, 0, 0, 0};
			colorText[] = {1, 1, 1, 1};
			text = "images\exit.paa";
		};
		class Exit_Back: Jig_RscButton {
			action = "closeDialog 0";
			idc = -1;
			text = "";
			x = 0.565625 * safezoneW + safezoneX;
			y = 0.354368 * safezoneH + safezoneY;
			w = 0.013125 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
	};
};
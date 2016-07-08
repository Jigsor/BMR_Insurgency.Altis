class btc_qr_dlg
{
	name = btc_qr_dlg;
	idd = -1;
	movingEnable = 1;
	controlsBackground[] = {Background};
	objects[] = {};
	controls[] = {respawn,call_for_help,text_time};

	onLoad = "uiNamespace setVariable [""btc_qr_dlg"", _this select 0];";

	class Background 
	{
		colorBackground[] = {0, 0, 0, 0};
		type = 0;
		colorText[] = {1, 1, 1, 1};
		sizeEx = 0.04;
		style = 48;
		font = "PuristaMedium";
		idc=-1;
		x = "safeZoneXAbs";
		y = "SafeZoneY";
		w = "safeZoneWAbs + 0.05";
		h = "SafeZoneH + 0.05";
		text = "=BTC=_q_revive\data\unc.paa";
	};
	class respawn 
	{
		onMouseButtonClick = "player call btc_qr_fnc_resp;";
		idc = -1;
		type = 1;
		style = 2;
		colorText[] = {1, 1, 1, 1};
		colorDisabled[] = {1, 1, 1, 0};
		colorBackground[] = {0, 0, 1, 0};
		colorBackgroundDisabled[] = {0,0,1,0};
		colorBackgroundActive[] = {0,0,1,0};
		colorFocused[] = {0,0,1,0};
		colorShadow[] = {0,0,0,0};
		colorBorder[] = {0,0,0,0};
		soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1};
		soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1};
		soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1};
		soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1};
		
		x = 0.5 * safezoneW + safezoneX;
		y = 0.1 * safezoneH + safezoneY;
		w = 0.18 * safezoneW;
		h = 0.0286915 * safezoneH;
		shadow = 2;
		font = "PuristaMedium";
		sizeEx = 0.03921;
		offsetX = 0.003;
		offsetY = 0.003;
		offsetPressedX = 0.002;
		offsetPressedY = 0.002;
		borderSize = 0;
		text = "Respawn";
		action = "";			
	};
	class call_for_help : respawn
	{
		idc = 171;
		x = 0.3 * safezoneW + safezoneX;
		onMouseButtonClick = "[player] call btc_qr_fnc_call_for_help";
		text = "Call for help";
	};
	class text_time 
	{
		idc = 172;
		x = 0.45 * safezoneW + safezoneX;
		y = 0.8 * safezoneH + safezoneY;
		w = 0.18 * safezoneW;
		h = 0.0286915 * safezoneH;
		type = 0;
		style = 0;
		shadow = 0;
		colorShadow[] = {0, 0, 0, 0.5};
		font = "PuristaMedium";
		SizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
		text = "";
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0, 0, 0, 0};
		linespacing = 1;			
	};
};
class btc_qr_dlg_resp
{
	name = btc_qr_dlg_resp;
	idd = -1;
	movingEnable = 1;
	controlsBackground[] = {};
	objects[] = {};
	controls[] = {confirm,spawn_list};

	onLoad = "uiNamespace setVariable [""btc_qr_dlg_resp"", _this select 0];";

	class confirm 
	{
		onMouseButtonClick = "btc_qr_spawn_selected = true;";
		idc = -1;
		type = 1;
		style = 2;
		colorText[] = {1, 1, 1, 1};
		colorDisabled[] = {1, 1, 1, 0};
		colorBackground[] = {0, 0, 1, 0};
		colorBackgroundDisabled[] = {0,0,1,0};
		colorBackgroundActive[] = {0,0,1,0};
		colorFocused[] = {0,0,1,0};
		colorShadow[] = {0,0,0,0};
		colorBorder[] = {0,0,0,0};
		soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1};
		soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1};
		soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1};
		soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1};
		
		x = 0.55 * safezoneW + safezoneX;
		y = 0.09 * safezoneH + safezoneY;
		w = 0.18 * safezoneW;
		h = 0.0286915 * safezoneH;
		shadow = 2;
		font = "PuristaMedium";
		sizeEx = 0.03921;
		offsetX = 0.003;
		offsetY = 0.003;
		offsetPressedX = 0.002;
		offsetPressedY = 0.002;
		borderSize = 0;
		text = "Confirm";
		action = "";			
	};
	class spawn_list
	{
		style = 16;
		type = 4;
		idc = 181;
		x = 0.3 * safezoneW + safezoneX;
		y = 0.09 * safezoneH + safezoneY;
		w = 0.18 * safezoneW;
		h = 0.0286915 * safezoneH;
		shadow = 0;
		onLBSelChanged = "btc_qr_cam_t setpos (getMarkerPos (lbData [181, lbCurSel 181]));btc_qr_cam camSetPos (btc_qr_cam_t modelToWorld [btc_qr_cam_dist,btc_qr_cam_dist,(abs btc_qr_cam_dist)]);btc_qr_cam camSetTarget btc_qr_cam_t;btc_qr_cam camCommit 0;";
		colorSelect[] = {0,0,0,1};
		colorText[] = {0.95,0.95,0.95,1};
		colorBackground[] = {0,0,0,1};
		colorSelectBackground[] = {1,1,1,0.7};
		colorScrollBar[] = {1,0,0,1};
		arrowEmpty = "\A3\ui_f\data\GUI\RscCommon\rsccombo\arrow_combo_ca.paa";
		arrowFull = "\A3\ui_f\data\GUI\RscCommon\rsccombo\arrow_combo_active_ca.paa";
		wholeHeight = 0.45;
		color[] = {1,1,1,1};
		colorActive[] = {1,0,0,1};
		colorDisabled[] = {1,1,1,0.25};
		font = "PuristaMedium";
		sizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.85)";
		class ComboScrollBar
		{
			color[] = {1,1,1,0.6};
			colorActive[] = {1,1,1,1};
			colorDisabled[] = {1,1,1,0.3};
			thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
			arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
			arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
			border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
		};
		soundSelect[] = { "", 0, 1 };
		soundExpand[] = { "", 0, 1 };
		soundCollapse[] = { "", 0, 1 };
		maxHistoryDelay = 0;
	};
};
#define CT_STATIC		0
#define CT_BUTTON		1
#define CT_EDIT			2
#define CT_SLIDER		3
#define CT_COMBO		4
#define CT_LISTBOX		5
#define CT_TOOLBOX		6
#define CT_CHECKBOXES		7
#define CT_PROGRESS		8
#define CT_HTML			9
#define CT_STATIC_SKEW		10
#define CT_ACTIVETEXT		11
#define CT_TREE			12
#define CT_STRUCTURED_TEXT	13
#define CT_3DSTATIC		20
#define CT_3DACTIVETEXT		21
#define CT_3DLISTBOX		22
#define CT_3DHTML		23
#define CT_3DSLIDER		24
#define CT_3DEDIT		25
#define CT_OBJECT		80
#define CT_OBJECT_ZOOM		81
#define CT_OBJECT_CONTAINER	82
#define CT_OBJECT_CONT_ANIM	83
#define CT_USER			99
#define ST_HPOS			0x0F
#define ST_LEFT			0
#define ST_RIGHT		1
#define ST_CENTER		2
#define ST_UP			3
#define ST_DOWN			4
#define ST_VCENTER		5
#define ST_TYPE			0xF0
#define ST_SINGLE		0
#define ST_MULTI		16
#define ST_TITLE_BAR		32
#define ST_PICTURE		48
#define ST_FRAME		64
#define ST_BACKGROUND		80
#define ST_GROUP_BOX		96
#define ST_GROUP_BOX2		112
#define ST_HUD_BACKGROUND	128
#define ST_TILE_PICTURE		144
#define ST_WITH_RECT		160
#define ST_LINE			176
#define ST_SHADOW		256
#define ST_NO_RECT		512
#define ST_TITLE		ST_TITLE_BAR + ST_CENTER
#define FontHTML		"PuristaSemibold"
#define FontM			"PuristaSemibold"
#define Dlg_ROWS		36
#define Dlg_COLS		90
#define Dlg_CONTROLHGT		((100/Dlg_ROWS)/100)
#define Dlg_COLWIDTH		((100/Dlg_COLS)/100)
#define Dlg_TEXTHGT_MOD		0.9
#define Dlg_ROWSPACING_MOD	1.3
#define Dlg_ROWHGT		(Dlg_CONTROLHGT*Dlg_ROWSPACING_MOD)
#define Dlg_TEXTHGT		(Dlg_CONTROLHGT*Dlg_TEXTHGT_MOD)

class JWC_Text {
	type = CT_STATIC;
	idc = -1;
	style = ST_CENTER;
	colorBackground[] = {0, 0, 0, 0};
	colorText[] = {1, 1, 1, 1};
	font = FontM;
	sizeEx = 0.015;
};

class JWC_StructuredText {
	type = CT_STRUCTURED_TEXT;
	idc = -1;
	style = ST_CENTER;
	colorBackground[] = {0, 0, 0, 0};
	colorText[] = {1, 1, 1, 1};
	font = FontM;
	sizeEx = 0.015;
};

class JWC_BG: JWC_Text {
	type = CT_STATIC;
	idc = -1;
	style = ST_LEFT;
	colorBackground[] = {0.02, 0.11, 0.27, 0.7};
	colorText[] = {1, 1, 1, 0};
	font = FontM;
	sizeEx = 0.015;
	text="";
};

class JWC_Map {
	idc = -1;
	type=101;
	style=48;
	moveOnEdges = 1;
	x = 0;
	y = 0;
	w = 1;
	h = 1;
	shadow = 0;
	ptsPerSquareSea = 5;
	ptsPerSquareTxt = 3;
	ptsPerSquareCLn = 10;
	ptsPerSquareExp = 10;
	ptsPerSquareCost = 10;
	ptsPerSquareFor = 9;
	ptsPerSquareForEdge = 9;
	ptsPerSquareRoad = 6;
	ptsPerSquareObj = 9;
	showCountourInterval = 0;
	widthRailWay = 4;
	scaleMin = 0.001000;
	scaleMax = 1.000000;
	scaleDefault = 0.160000;
	maxSatelliteAlpha = 0.850000;
	alphaFadeStartScale = 0.350000;
	alphaFadeEndScale = 0.400000;
	colorBackground[]  = {0.969000, 0.957000, 0.949000, 1.000000};
	colorText[] = {0, 0, 0, 1};
	colorSea[]  = {0.467000, 0.631000, 0.851000, 0.500000};
	colorForest[]  = {0.624000, 0.780000, 0.388000, 0.500000};
	colorForestBorder[]  = {0.000000, 0.000000, 0.000000, 0.000000};
	colorRocks[]  = {0.000000, 0.000000, 0.000000, 0.300000};
	colorRocksBorder[]  = {0.000000, 0.000000, 0.000000, 0.000000};
	colorLevels[]  = {0.286000, 0.177000, 0.094000, 0.500000};
	colorMainCountlines[]  = {0.572000, 0.354000, 0.188000, 0.500000};
	colorCountlines[]  = {0.572000, 0.354000, 0.188000, 0.250000};
	colorMainCountlinesWater[]  = {0.491000, 0.577000, 0.702000, 0.600000};
	colorCountlinesWater[]  = {0.491000, 0.577000, 0.702000, 0.300000};
	colorPowerLines[]  = {0.100000, 0.100000, 0.100000, 1.000000};
	colorRailWay[]  = {0.800000, 0.200000, 0.000000, 1.000000};
	colorNames[]  = {0.100000, 0.100000, 0.100000, 0.900000};
	colorInactive[]  = {1.000000, 1.000000, 1.000000, 0.500000};
	colorOutside[]  = {0.000000, 0.000000, 0.000000, 1.000000};
	colorTracks[]  = {0.840000, 0.760000, 0.650000, 0.150000};
	colorTracksFill[]  = {0.840000, 0.760000, 0.650000, 1.000000};
	colorRoads[]  = {0.700000, 0.700000, 0.700000, 1.000000};
	colorRoadsFill[]  = {1.000000, 1.000000, 1.000000, 1.000000};
	colorMainRoads[]  = {0.900000, 0.500000, 0.300000, 1.000000};
	colorMainRoadsFill[]  = {1.000000, 0.600000, 0.400000, 1.000000};
	colorGrid[]  = {0.100000, 0.100000, 0.100000, 0.600000};
	colorGridMap[]  = {0.100000, 0.100000, 0.100000, 0.600000};
	font = "TahomaB";
	sizeEx = 0.04;
	fontLabel = "PuristaMedium";
	sizeExLabel = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
	fontGrid = "TahomaB";
	sizeExGrid = 0.020000;
	fontUnits = "TahomaB";
	sizeExUnits = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
	fontNames = "PuristaMedium";
	sizeExNames = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8) * 2";
	fontInfo = "PuristaMedium";
	sizeExInfo = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
	fontLevel = "TahomaB";
	sizeExLevel = 0.020000;
	text = "#(argb,8,8,3)color(1,1,1,1)";
	class Legend {
		x = "SafeZoneX + (((safezoneW / safezoneH) min 1.2) / 40)";
		y = "SafeZoneY + safezoneH - 4.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
		w = "10 * (((safezoneW / safezoneH) min 1.2) / 40)";
		h = "3.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
		font = "PuristaMedium";
		sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
		colorBackground[]  = {1, 1, 1, 0.500000};
		color[]  = {0, 0, 0, 1};
	};
	class Task {
		icon = "\A3\ui_f\data\map\mapcontrol\taskIcon_CA.paa";
		iconCreated = "\A3\ui_f\data\map\mapcontrol\taskIconCreated_CA.paa";
		iconCanceled = "\A3\ui_f\data\map\mapcontrol\taskIconCanceled_CA.paa";
		iconDone = "\A3\ui_f\data\map\mapcontrol\taskIconDone_CA.paa";
		iconFailed = "\A3\ui_f\data\map\mapcontrol\taskIconFailed_CA.paa";
		color[]  = {"(profilenamespace getvariable ['IGUI_TEXT_RGB_R',0])", "(profilenamespace getvariable ['IGUI_TEXT_RGB_G',1])", "(profilenamespace getvariable ['IGUI_TEXT_RGB_B',1])", "(profilenamespace getvariable ['IGUI_TEXT_RGB_A',0.8])"};
		colorCreated[]  = {1, 1, 1, 1};
		colorCanceled[]  = {0.700000, 0.700000, 0.700000, 1};
		colorDone[]  = {0.700000, 1, 0.300000, 1};
		colorFailed[]  = {1, 0.300000, 0.200000, 1};
		size = 27;
		importance = 1;
		coefMin = 1;
		coefMax = 1;
	};
	class Waypoint {
		icon = "\A3\ui_f\data\map\mapcontrol\waypoint_ca.paa";
		color[]  = {0, 0, 0, 1};
                size = 20;
		coefMin = 0.9;
		coefMax = 4;
		importance = "1.2 * 16 * 0.05";
	};
	class WaypointCompleted {
		icon = "\A3\ui_f\data\map\mapcontrol\waypointCompleted_ca.paa";
		color[]  = {0, 0, 0, 1};
                size = 20;
		coefMin = 0.9;
		coefMax = 4;
		importance = "1.2 * 16 * 0.05";
	};
	class ActiveMarker {
		icon = "\ca\ui\data\map_waypoint_completed_ca.paa";
		size = 20;
		color[] = {0, 0.9, 0, 1};
		importance = "1.2 * 16 * 0.05";
		coefMin = 0.9;
		coefMax = 4;
	};
	class CustomMark {
		icon = "\A3\ui_f\data\map\mapcontrol\custommark_ca.paa";
		size = 24;
		importance = 1;
		coefMin = 1;
		coefMax = 1;
		color[]  = {0, 0, 0, 1};
	};
	class Command {
		icon = "\A3\ui_f\data\map\mapcontrol\waypoint_ca.paa";
		size = 18;
		importance = 1;
		coefMin = 1;
		coefMax = 1;
		color[]  = {1, 1, 1, 1};
	};
	class Bush {
		icon = "\A3\ui_f\data\map\mapcontrol\bush_ca.paa";
		color[]  = {0.450000, 0.640000, 0.330000, 0.400000};
		size = "14/2";
		importance = "0.2 * 14 * 0.05 * 0.05";
		coefMin = 0.250000;
		coefMax = 4;
	};
	class Rock {
		icon = "\A3\ui_f\data\map\mapcontrol\rock_ca.paa";
		color[]  = {0.100000, 0.100000, 0.100000, 0.800000};
		size = 12;
		importance = "0.5 * 12 * 0.05";
		coefMin = 0.250000;
		coefMax = 4;
	};
	class SmallTree {
		icon = "\A3\ui_f\data\map\mapcontrol\bush_ca.paa";
		color[]  = {0.450000, 0.640000, 0.330000, 0.400000};
		size = 12;
		importance = "0.6 * 12 * 0.05";
		coefMin = 0.250000;
		coefMax = 4;
	};
	class Tree {
		icon = "\A3\ui_f\data\map\mapcontrol\bush_ca.paa";
		color[]  = {0.450000, 0.640000, 0.330000, 0.400000};
		size = 12;
		importance = "0.9 * 16 * 0.05";
		coefMin = 0.250000;
		coefMax = 4;
	};
	class busstop {
		icon = "\A3\ui_f\data\map\mapcontrol\busstop_CA.paa";
		size = 24;
		importance = 1;
		coefMin = 0.850000;
		coefMax = 1.000000;
		color[]  = {1, 1, 1, 1};
	};
	class fuelstation {
		icon = "\A3\ui_f\data\map\mapcontrol\fuelstation_CA.paa";
		size = 24;
		importance = 1;
		coefMin = 0.850000;
		coefMax = 1.000000;
		color[]  = {1, 1, 1, 1};
	};
	class hospital {
		icon = "\A3\ui_f\data\map\mapcontrol\hospital_CA.paa";
		size = 24;
		importance = 1;
		coefMin = 0.850000;
		coefMax = 1.000000;
		color[]  = {1, 1, 1, 1};
	};
	class church {
		icon = "\A3\ui_f\data\map\mapcontrol\church_CA.paa";
		size = 24;
		importance = 1;
		coefMin = 0.850000;
		coefMax = 1.000000;
		color[]  = {1, 1, 1, 1};
	};
	class lighthouse {
		icon = "\A3\ui_f\data\map\mapcontrol\lighthouse_CA.paa";
		size = 24;
		importance = 1;
		coefMin = 0.850000;
		coefMax = 1.000000;
		color[]  = {1, 1, 1, 1};
	};
	class power {
		icon = "\A3\ui_f\data\map\mapcontrol\power_CA.paa";
		size = 24;
		importance = 1;
		coefMin = 0.850000;
		coefMax = 1.000000;
		color[]  = {1, 1, 1, 1};
	};
	class powersolar {
		icon = "\A3\ui_f\data\map\mapcontrol\powersolar_CA.paa";
		size = 24;
		importance = 1;
		coefMin = 0.850000;
		coefMax = 1.000000;
		color[]  = {1, 1, 1, 1};
	};
	class powerwave {
		icon = "\A3\ui_f\data\map\mapcontrol\powerwave_CA.paa";
		size = 24;
		importance = 1;
		coefMin = 0.850000;
		coefMax = 1.000000;
		color[]  = {1, 1, 1, 1};
	};
	class powerwind {
		icon = "\A3\ui_f\data\map\mapcontrol\powerwind_CA.paa";
		size = 24;
		importance = 1;
		coefMin = 0.850000;
		coefMax = 1.000000;
		color[]  = {1, 1, 1, 1};
	};
	class quay {
		icon = "\A3\ui_f\data\map\mapcontrol\quay_CA.paa";
		size = 24;
		importance = 1;
		coefMin = 0.850000;
		coefMax = 1.000000;
		color[]  = {1, 1, 1, 1};
	};
	class shipwreck {
		icon = "\A3\ui_f\data\map\mapcontrol\shipwreck_CA.paa";
		size = 24;
		importance = 1;
		coefMin = 0.850000;
		coefMax = 1.000000;
		color[]  = {1, 1, 1, 1};
	};
	class transmitter {
		icon = "\A3\ui_f\data\map\mapcontrol\transmitter_CA.paa";
		size = 24;
		importance = 1;
		coefMin = 0.850000;
		coefMax = 1.000000;
		color[]  = {1, 1, 1, 1};
	};
	class watertower {
		icon = "\A3\ui_f\data\map\mapcontrol\watertower_CA.paa";
		size = 24;
		importance = 1;
		coefMin = 0.850000;
		coefMax = 1.000000;
		color[]  = {1, 1, 1, 1};
	};
	class Cross {
		icon = "\A3\ui_f\data\map\mapcontrol\Cross_CA.paa";
		size = 24;
		importance = 1;
		coefMin = 0.850000;
		coefMax = 1.000000;
		color[]  = {0, 0, 0, 1};
	};
	class Chapel {
		icon = "\A3\ui_f\data\map\mapcontrol\Chapel_CA.paa";
		size = 24;
		importance = 1;
		coefMin = 0.850000;
		coefMax = 1.000000;
		color[]  = {0, 0, 0, 1};
	};
	class Bunker {
		icon = "\A3\ui_f\data\map\mapcontrol\bunker_ca.paa";
		size = 14;
		importance = "1.5 * 14 * 0.05";
		coefMin = 0.250000;
		coefMax = 4;
		color[]  = {0, 0, 0, 1};
	};
	class Fortress {
		icon = "\A3\ui_f\data\map\mapcontrol\bunker_ca.paa";
		size = 16;
		importance = "2 * 16 * 0.05";
		coefMin = 0.250000;
		coefMax = 4;
		color[]  = {0, 0, 0, 1};
	};
	class Fountain {
		icon = "\A3\ui_f\data\map\mapcontrol\fountain_ca.paa";
		size = 11;
		importance = "1 * 12 * 0.05";
		coefMin = 0.250000;
		coefMax = 4;
		color[]  = {0, 0, 0, 1};
	};
	class Ruin {
		icon = "\A3\ui_f\data\map\mapcontrol\ruin_ca.paa";
		size = 16;
		importance = "1.2 * 16 * 0.05";
		coefMin = 1;
		coefMax = 4;
		color[]  = {0, 0, 0, 1};
	};
	class Stack {
		icon = "\A3\ui_f\data\map\mapcontrol\stack_ca.paa";
		size = 20;
		importance = "2 * 16 * 0.05";
		coefMin = 0.900000;
		coefMax = 4;
		color[]  = {0, 0, 0, 1};
	};
	class Tourism {
		icon = "\A3\ui_f\data\map\mapcontrol\tourism_ca.paa";
		size = 16;
		importance = "1 * 16 * 0.05";
		coefMin = 0.700000;
		coefMax = 4;
		color[]  = {0, 0, 0, 1};
	};
	class ViewTower {
		icon = "\A3\ui_f\data\map\mapcontrol\viewtower_ca.paa";
		size = 16;
		importance = "2.5 * 16 * 0.05";
		coefMin = 0.500000;
		coefMax = 4;
		color[]  = {0, 0, 0, 1};
	};
	class LineMarker {
		lineDistanceMin = 3e-005;
		lineLengthMin = 5;
		lineWidthThick = 0.014;
		lineWidthThin = 0.008;
		textureComboBoxColor = "#(argb,8,8,3)color(1,1,1,1)";
	};
};

class JWC_Button {
	idc = -1;
	type = 16;
	style = 0;
	y = 0.509;
	x = 0.538;
	w = 0.178;
	h = 0.09;
	size = 0.03;
	sizeEx = 0.03;
	color[] = {0.8, 0.8, 0, 0.80};
	color2[] = {0.85, 0.85, 0.85, 0.3};
	colorBackground[] = {0,0,0,0.6};
	colorbackground2[] = {0,0,0,0.6};
	colorDisabled[] = {0.85, 0.85, 0.85,0.4};
	periodFocus = 1.2;
	periodOver = 0.2;
	class HitZone {
		left = 0.004;
		top = 0.029;
		right = 0.004;
		bottom = 0.029;
	};
	class ShortcutPos {
		left = 0.0145;
		top = 0.026;
		w = 0.0392157;
		h = 0.0522876;
	};
	class TextPos {
		left = 0.03;
		top = 0.026;
		right = 0.005;
		bottom = 0.005;
	};
	textureNoShortcut = "";
	animTextureNormal   = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButtonMain\normal_ca.paa";
	animTextureDisabled = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButtonMain\disabled_ca.paa";
	animTextureOver     = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButtonMain\over_ca.paa";
	animTextureFocused  = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButtonMain\focus_ca.paa";
	animTexturePressed  = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButtonMain\down_ca.paa";
	animTextureDefault  = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButtonMain\normal_ca.paa";
	period = 0;
	font = "PuristaSemibold";
	soundEnter[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundEnter", 0.09, 1};
	soundPush[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundPush", 0.0, 0};
	soundClick[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundClick", 0.07, 1};
	soundEscape[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundEscape", 0.09, 1};
	class Attributes {
		font = "PuristaSemibold";
		color = "#E5E5E5";
		align = "left";
		shadow = "true";
	};
	class AttributesImage {
		font = "PuristaSemibold";
		color = "#E5E5E5";
		align = "left";
		shadow = "true";
	};
};

class JWC_CheckBox {
	idc = -1;
	type = 7;
	style = 0;
	x = 0.550;
	y = 0.18;
	w = 0.15;
	h = 0.15;
	colorText[] = {1, 0, 0, 1};
	color[] = {0, 0, 0, 0};
	colorBackground[] = {0, 0, 1, 1};
	colorTextSelect[] = {0, 0.800000, 0, 1};
	colorSelectedBg[] = {0, 0, 0, 1};
	colorSelect[] = {0, 0, 0, 1};
	colorTextDisable[] = {0.400000, 0.400000, 0.400000, 1};
	colorDisable[] = {0.400000, 0.400000, 0.400000, 1};
	font = "PuristaMedium";
	sizeEx = 0.0208333;
	rows = 1;
	columns = 1;
	strings[] = {""};
	checked_strings[] = {""};
};
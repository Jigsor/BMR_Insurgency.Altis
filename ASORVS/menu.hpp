#include "common.hpp"
#define CATEGORY_SPACING  .01
#define ITEM_SPACING .005
#define ITEM_HEIGHT (1/25)
#define ITEM_WIDTH (ITEM_HEIGHT*(3/4))
#define DIALOG_MARGIN .01
#define LABEL_WIDTH .21
#define TOTAL_WIDTH (safezoneW * 0.34)

#define TOP_SPACING .005
#define TOP (safezoneY + TOP_SPACING)
#define TEXT_SIZE .04

#define FULLCOMBO_WIDTH (TOTAL_WIDTH - (DIALOG_MARGIN * 2) - LABEL_WIDTH)

#define BOX_COMBO_WIDTH ((FULLCOMBO_WIDTH/5) - (ITEM_SPACING * 4))
#define BOX_COMBO_HEIGHT ((BOX_COMBO_WIDTH *0.86)*(4/3))
#define BOX_SPACING ((FULLCOMBO_WIDTH - BOX_COMBO_WIDTH*5) / 4)
#define MULTI_COMBO_WIDTH (TOTAL_WIDTH - DIALOG_MARGIN - (CATEGORY_SPACING*5) - LABEL_WIDTH - ITEM_WIDTH*3)
#define SAVE_WIDTH (TOTAL_WIDTH - DIALOG_MARGIN - CATEGORY_SPACING*2 - LABEL_WIDTH - MULTI_COMBO_WIDTH)
#define TRANSPARENT_TEXTURE "#(rgb,8,8,3)color(0,0,0,0)"
/*	class primaryWeaponAmmoCombo : ASORVS_AmmoCombo
	{
		idc= 420011;
		y = safezoneY + (ITEM_HEIGHT + ITEM_SPACING) * 2;
	};
	class primaryWeaponAmmoMinus : ASORVS_MinusButton
	{
		idc= 420012;
		y = safezoneY + (ITEM_HEIGHT + ITEM_SPACING) * 2;
	};
	class primaryWeaponAmmoCount : ASORVS_CountText
	{
		idc= 420013;
		y = safezoneY + (ITEM_HEIGHT + ITEM_SPACING) * 2;
	};
	class primaryWeaponAmmoPlus : ASORVS_PlusButton
	{
		idc= 420014;
		y = safezoneY + (ITEM_HEIGHT + ITEM_SPACING) * 2;
	};*/
#define MULTICOMBO(NAME,FIRSTIDC,YPOS) \
class NAME##Combo : ASORVS_AmmoCombo { \
	idc= FIRSTIDC; \
	y = YPOS; }; \
class NAME##Minus : ASORVS_MinusButton { \
	idc= FIRSTIDC+1; \
	y = YPOS; };\
class NAME##Count : ASORVS_CountText { \
	idc= FIRSTIDC+2; \
	y = YPOS; };\
class NAME##CountTextBoxBG : ASORVS_CountTextBoxBG { \
	idc= FIRSTIDC+4; \
	y = -1000; \
};\
class NAME##CountTextBox : ASORVS_CountTextBox { \
	idc= FIRSTIDC+5; \
	y = -1000; \
	onLoad = "(this select 0) ctrlShow false; (this select 0) ctrlEnable false"; \
	onKillFocus = "_this spawn ASORVS_fnc_numberDeselected;";\
	onChar = "_this spawn ASORVS_fnc_numberCharEntered";\
};\
class NAME##Plus : ASORVS_PlusButton { \
	idc= FIRSTIDC+3; \
	y = YPOS; };

#define SINGLECOMBO(NAME,FIRSTIDC,YPOS) \
class NAME##Combo : ASORVS_FullCombo \
{ \
	idc= FIRSTIDC;\
	y = YPOS;	\
};
#define LABEL(NAME, FIRSTIDC, YPOS, TEXT) \
	class NAME##Text : ASORVS_FieldLabel \
	{ \
		idc= FIRSTIDC; \
		text=TEXT; \
		y = YPOS; \
	};
#define HEADING(NAME, FIRSTIDC, YPOS, TEXT) \
	class NAME##Text : ASORVS_FieldLabelHeading \
	{ \
		idc= FIRSTIDC; \
		text=TEXT; \
		y = YPOS; \
	};
#define false 0
#define true 1
class ASORVS_FieldLabel : ASORVS_RscText
{
	style = 0x01;//ST_RIGHT
	x = safezoneX + DIALOG_MARGIN;
	h = ITEM_HEIGHT;
	w = LABEL_WIDTH - DIALOG_MARGIN;
	sizeEx = TEXT_SIZE;
};
class ASORVS_FieldLabelHeading : ASORVS_FieldLabel
{
	font = "PuristaSemiBold";
};
class ASORVS_FullCombo : ASORVS_RscCombo
{
	x = safezoneX + DIALOG_MARGIN + LABEL_WIDTH;
	w = FULLCOMBO_WIDTH;
	h = ITEM_HEIGHT;
	soundExpand[] = {"", 0.0, 1};
	soundCollapse[] = {"", 0.0, 1};
	//need to work out wtf this does
	maxHistoryDelay = 1000;
	autoScrollSpeed = 1000;
	onLBSelChanged = "_this spawn ASORVS_fnc_selectionChanged";
	sizeEx = TEXT_SIZE;
	colorFrame[] = {1,1,1,0};
	colorBox[] = {1,1,1,0};
	colorBorder[] = {1,1,1,0};
	colorPicture[] = {1,1,1,1};
	colorPictureDisabled[] = {1,1,1,1};
	colorPictudeDisabled[] = {1,1,1,1};
	colorPictureSelected[] = {1,1,1,1};
	//style=ST_FRAME;
	colorBackground[] = {.3, .3, .3, 0.5};
	style=ST_MULTI + ST_SHADOW + ST_KEEP_ASPECT_RATIO + ST_FRAME;
};
class ASORVS_BoxCombo : ASORVS_RscCombo
{
	x = safezoneX + DIALOG_MARGIN + LABEL_WIDTH;
	soundExpand[] = {"", 0.0, 1};
	soundCollapse[] = {"", 0.0, 1};
	//need to work out wtf this does
	maxHistoryDelay = 1000;
	autoScrollSpeed = 1000;
	onLBSelChanged = "_this spawn ASORVS_fnc_selectionChanged";
	colorFrame[] = {1,1,1,1};
	colorBox[] = {1,1,1,1};
	colorBorder[] = {1,1,1,1};
	colorPicture[] = {1,1,1,1};
	colorPictureDisabled[] = {1,1,1,1};
	colorPictudeDisabled[] = {1,1,1,1};
	colorPictureSelected[] = {1,1,1,1};
	//style=ST_FRAME;
	arrowEmpty="#(argb,8,8,3)color(0,0,0,0)";
	arrowFull="#(argb,8,8,3)color(0,0,0,0)";
	colorBackground[] = {.3, .3, .3, 1};
	w=BOX_COMBO_WIDTH;
	h=BOX_COMBO_HEIGHT;
	style=ST_PICTURE;
};
class ASORVS_AmmoCombo : ASORVS_FullCombo
{
	w = MULTI_COMBO_WIDTH;
	sizeEx = TEXT_SIZE;
};

class ASORVS_MinusButton :ASORVS_RscShortcutButton
{
	x = safezoneX + (TOTAL_WIDTH - DIALOG_MARGIN - CATEGORY_SPACING*3 - ITEM_WIDTH*3);

	//text= "ASORVS\images\minus_ca.paa";
	textureNoShortcut =  "ASORVS\images\minus_ca.paa";
	onButtonClick = "_this spawn ASORVS_fnc_PressMinus; false";
	sizeEx = TEXT_SIZE;
	/*animTextureDefault = "ASORVS\images\minus_ca.paa";
	animTextureNormal = "ASORVS\images\minus_ca.paa";
	animTextureDisabled = "ASORVS\images\minus_ca.paa";
	animTextureOver =  "ASORVS\images\minus_ca.paa";
	animTextureFocused = "ASORVS\images\minus_ca.paa";
	animTexturePressed =  "ASORVS\images\minus_ca.paa";*/
	w = ITEM_WIDTH;//1/30;
	type = CT_SHORTCUTBUTTON;
	h = ITEM_HEIGHT;
	style = ST_KEEP_ASPECT_RATIO;
	class ShortcutPos{
		left=0;
		top=0;
		w=ITEM_WIDTH;
		h=ITEM_HEIGHT;
	};
	#define ANIMTEXTURECOLOR "#(rgb,8,8,3)color(0.15,0.15,0.15,1)"
	colorBackground[] = {1,1,1,1};
	animTextureDefault = ANIMTEXTURECOLOR;
	animTextureNormal = ANIMTEXTURECOLOR;
	animTextureDisabled =   "#(rgb,8,8,3)color(0.05,0.05,0.05,1)";
	animTextureOver =  "#(rgb,8,8,3)color(1,1,1,1)";
	animTextureFocused =  "#(rgb,8,8,3)color(1,1,1,1)";
	animTexturePressed =  "#(rgb,8,8,3)color(1,1,1,1)";
	color2[]={0,0,0,1};
	color[]={1,1,1,1};
	colorFocused[]={1,1,1,1};
	/* default A3
	animTextureDefault = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\normal_ca.paa";
	animTextureNormal = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\normal_ca.paa";
	animTextureDisabled = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\normal_ca.paa";
	animTextureOver = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\over_ca.paa";
	animTextureFocused = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\focus_ca.paa";
	animTexturePressed = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\down_ca.paa";
	*/
};
class ASORVS_CountText : ASORVS_RscButton
{
	text="20";
	style = ST_CENTER;
	w = ITEM_WIDTH + CATEGORY_SPACING*3;
	h = ITEM_HEIGHT;
	x = safezoneX + (TOTAL_WIDTH - DIALOG_MARGIN - ITEM_HEIGHT*2 - CATEGORY_SPACING);
	onSetFocus = "_this spawn ASORVS_fnc_numberSelected;";
	sizeEx = TEXT_SIZE;
	colorBackground[] = {0.3, 0.3, 0.3, 1};
};
class ASORVS_CountTextBoxBG : ASORVS_RscText
{
	//type=CT_STATIC;
	//style = 0;

	text="";
	w = ITEM_HEIGHT;
	h = ITEM_HEIGHT;
	x = safezoneX + (TOTAL_WIDTH - DIALOG_MARGIN - ITEM_HEIGHT*2);
	colorBackground[] = {1,1,1,1};
	colorText[] = {0,1,0,1};
	colorDisabled[] = {1,1,1,1};
	 colorBackgroundDisabled[] = { 1, 1, 1, 1 };   // background color for disabled state
  	colorBackgroundActive[] = { 1, 1, 1, 1 };   // background color for active state
	color[] = {1,1,0,1};
	colorBorder[] = {0,0,1,1}; // grey
	colorFrame[] = {1,0,0,1};
	colorBackground2[] = {0,1,0,1};
	visible = false;
	autocomplete = false;
	colorSelection[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 1};
	class Attributes
	{
		shadow = "false";
	};
};
class ASORVS_CountTextBox : ASORVS_RscEdit
{
	text="20";
	w = ITEM_HEIGHT;
	h = ITEM_HEIGHT;
	x = safezoneX + (TOTAL_WIDTH - DIALOG_MARGIN - ITEM_HEIGHT*2);
	colorBackground[] = {1,1,1,1};
	colorText[] = {0,0,0,1};
	colorDisabled[] = {1,1,1,1};
		colorBorder[] = {0,0,0,1};
			colorFrame[] = {0,0,0,1};
	  colorShadow[] = {0.5,0.5,0.5,1}; // darkgrey
	 colorBackgroundDisabled[] = { 1, 1, 1, 1 };   // background color for disabled state
  	colorBackgroundActive[] = { 1, 1, 1, 1 };   // background color for active state
	color[] = {1,1,1,1};
	style = ST_FRAME + ST_CENTER;
	autocomplete = false;
	visible = false;
	colorSelection[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 1};
	sizeEx = TEXT_SIZE;
};
class ASORVS_PlusButton :ASORVS_MinusButton
{
	textureNoShortcut =  "ASORVS\images\plus_ca.paa";
	x = safezoneX + (TOTAL_WIDTH - ITEM_HEIGHT*(3/4)) - DIALOG_MARGIN;
	onButtonClick = "_this spawn ASORVS_fnc_PressPlus; false";
};
class ASORVS_Main_Dialog {
	idd = 418000;
	name= "ASORVS_Main_Dialog";
	movingEnable = 1;
	enableSimulation = true;
	onLoad = "ASORVS_Open = true; [] spawn ASORVS_fnc_ReloadMainDialog; ";
	onUnload = "ASORVS_Open = false; [] spawn ASORVS_fnc_Closed; ";
	onMouseMoving = "_this spawn ASORVS_fnc_RotateClone";
	class controlsBackground {
	};

	class controls {

		class PictureinPicture : ASORVS_RscPicture
		{
			idc=434603;
			w = 0.5;
			h = 0.5;
			x= safezoneX +safezoneW - 0.5;
			y= safezoneY + safezoneH - (2*ITEM_HEIGHT) - 0.5;
				type = 0;
				style = 48;
				text = "";
						colorText[] = {1,1,1,1};
				colorBackground[] = {0, 0, 0, 0.3};
				font = "TahomaB";
					sizeEx = 0;
					lineSpacing = 0;
					fixedWidth = 0;
					shadow = 0;
		};
		HEADING(preset, 419000, TOP + (ITEM_HEIGHT*0), "Preset");
		HEADING(primaryWeapon, 420000, TOP + CATEGORY_SPACING + ITEM_HEIGHT + ITEM_SPACING, "" );
		class vehicleCombo : ASORVS_FullCombo
		{
			idc= 420001;
			y = safezoneY;
			h = ITEM_HEIGHT * 3;
			w=2;
			sizeEx = TEXT_SIZE * 3;
			colorSelectBackground[]={1,1,1,0};
			color[]={0,0,0,0};
			colorActive[]={1,0,0,0};
			colorDisabled[]={1,1,1,0};
			colorSelect[]={1,1,1,1};
			colorText[]={0.7,0.7,0.7,1};
			colorBackground[]={0,0,0,0};
			colorscrollbar[]={1,0,0,0};
			arrowEmpty=TRANSPARENT_TEXTURE;
			arrowFull=TRANSPARENT_TEXTURE;
			wholeHeight=safezoneH;
			shadow=2;
			x= safezoneX;
		};
		class Description : ASORVS_RscStructuredText {
			idc=426001;
			x = safezoneX + ITEM_SPACING*5;
			y = safezoneY + safezoneH - 1;
			w=1;
			h=1;
		};

		class closeButton : ASORVS_PlusButton {
			idc = 427010;
			textureNoShortcut =  "A3\ui_f\data\gui\Rsc\RscDisplayArcadeMap\icon_exit_cross_ca.paa";
			onButtonClick = "closeDialog 0; player setVariable ['createEnabled', true];";
			w = ITEM_WIDTH*2;
			h = ITEM_HEIGHT*2;
			x = safezoneX +safezoneW - ITEM_WIDTH*2;
			y = safezoneY;
			class ShortcutPos{
				left=0;
				top=0;
				w=ITEM_WIDTH*2;
				h=ITEM_HEIGHT*2;
			};
			#define ANIMTEXTURECOLORCLOSE "#(rgb,8,8,3)color(0.5,0,0,1)"
			colorBackground[] = {1,1,1,1};
			animTextureDefault = ANIMTEXTURECOLORCLOSE;
			animTextureNormal = ANIMTEXTURECOLORCLOSE;
			animTextureDisabled =  "#(rgb,8,8,3)color(0.05,0.05,0.05,1)";
			animTextureOver =  "#(rgb,8,8,3)color(0.7,0,0,1)";
			animTextureFocused =  "#(rgb,8,8,3)color(0.7,0,0,1)";
			animTexturePressed =  "#(rgb,8,8,3)color(0.4,0,0,1)";
		};

		class spawnVehicleButton : ASORVS_PlusButton {
			idc = 26010;
			textureNoShortcut =  "" ;
			text = "<t size='2' align='center'>ISSUE VEHICLE</t>";
			onButtonClick = "[] spawn ASORVS_fnc_SpawnVehicle; player setVariable ['cancelCreate', false]; closeDialog 0;";
			w = 0.5;
			h = ITEM_HEIGHT*2;
			x = safezoneX +safezoneW - 0.5;//-CATEGORY_SPACING;
			y = safezoneY + safezoneH - (ITEM_HEIGHT*2);
			class ShortcutPos {
				left=0;
				top=0;
				w=ITEM_WIDTH*2;
				h=ITEM_HEIGHT*2;
			};
			class TextPos {
				top=-0.0075;
				left="(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1) * (3/4)";
				right=0.005;
				bottom=-0.0075;//"(((((safezoneW / safezoneH) min 1.2) / 1.2) / 20) - (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)) / 4";
			};
			#define ANIMTEXTURECOLOROK "#(rgb,8,8,3)color(0,0.5,0,1)"
			colorBackground[] = {1,1,1,1};
			animTextureDefault = ANIMTEXTURECOLOROK;
			animTextureNormal = ANIMTEXTURECOLOROK;
			animTextureDisabled =  ANIMTEXTURECOLOROK;
			animTextureOver =  "#(rgb,8,8,3)color(0.05,0.05,0.05,1)";
			animTextureFocused =  "#(rgb,8,8,3)color(0,0.7,0,1)";
			animTexturePressed =  "#(rgb,8,8,3)color(0,0.4,0,1)";
			onMouseEnter="[] spawn ASORVS_fnc_ShowPIP;";
			onMouseExit="[] spawn ASORVS_fnc_HidePIP;";
		};

		class rotateDragThing : ASORVS_RscPicture
		{
			idc = 425004;
			type = 1;
			style = 48;
			text="";
				font = "PuristaMedium";
			onMouseButtonDown = "_this spawn ASORVS_fnc_RotateCloneStart";
			onMouseButtonUp = "_this spawn ASORVS_fnc_RotateCloneStop";
			onMouseZChanged = "_this spawn ASORVS_fnc_Zoom";
			//onMouseEnter="[1] spawn ASORVS_fnc_RotateClone";
			//onMouseExit="[0] spawn ASORVS_fnc_RotateCloneStop";
			colorText[] = {0,0,0,0};
			colorDisabled[] = {0,0,0,0};
			colorBackground[] = {0,0,0,0};
			colorBackgroundActive[] = {0,0,0,0};
			colorBackgroundDisabled[] = {0,0,0,0};
			offsetX = 0.003;
			offsetY = 0.003;
			offsetPressedX = 0.002;
			offsetPressedY = 0.002;
			colorFocused[] = {0,0,0,0};
			colorShadow[] = {0, 0, 0, 0};
			colorBorder[] = {0, 0, 0, 0};
			borderSize = 0.0;
			soundEnter[] = {"\A3\ui_f\data\Sound\RscButtonMenu\soundEnter", 0.09, 1};
			soundPush[] = {"\A3\ui_f\data\Sound\RscButtonMenu\soundPush", 0.0, 0};
			soundClick[] = {"\A3\ui_f\data\Sound\RscButtonMenu\soundClick", 0.07, 1};
			soundEscape[] = {"\A3\ui_f\data\Sound\RscButtonMenu\soundEscape", 0.09, 1};
			w=safezoneW; //remove item height so it doesn't overlap the close button
			h=safezoneH - ITEM_HEIGHT*4;
			y=safezoneY + ITEM_HEIGHT*2;
			x=safezoneX + TOTAL_WIDTH;
		};


	};
};


class ASORVS_SaveDialog {
	idd = 420999;
	name = "ASORVS Save";
	movingEnable = false;
	enableSimulation = true;
	onLoad = "[] spawn ASORVS_fnc_OpenSave";
	class controlsBackground {	};
	class controls {
		class Title : ASORVS_RscTitle {
			idc=-1;
			text = "Save Preset";
			x = safezoneX + DIALOG_MARGIN;
			y = TOP;
			w = TOTAL_WIDTH - DIALOG_MARGIN;
		};
		class SelectSlotLabel: ASORVS_RscText {
			idc = -1;
			text = "Select a slot:";
			y= TOP + (ITEM_HEIGHT*2);
			x = safezoneX + DIALOG_MARGIN;
			w = TOTAL_WIDTH - DIALOG_MARGIN;
			h = ITEM_HEIGHT;
		};
		class SaveSlotsList : ASORVS_RscListBox {
			idc = 421000;
			x = safezoneX + DIALOG_MARGIN;
			y = TOP + (ITEM_HEIGHT*3);
			w = TOTAL_WIDTH - (DIALOG_MARGIN*2);
			h = 1;
			onLBSelChanged = "[] spawn ASORVS_fnc_SaveSlotChanged";
		};
		class EnterNameLabel: ASORVS_RscText {
			idc = -1;
			text = "Preset Name:";
			x = safezoneX + DIALOG_MARGIN;
			y = TOP + (ITEM_HEIGHT*3) + 1 + CATEGORY_SPACING;
			w = LABEL_WIDTH;
			h = ITEM_HEIGHT;
		};
		class EnterNameTextbox: ASORVS_RscEdit {
			idc = 421001;
			text = "New Preset";
			x = safezoneX + DIALOG_MARGIN + LABEL_WIDTH + (DIALOG_MARGIN *2);
			y = TOP + (ITEM_HEIGHT*3) + CATEGORY_SPACING + 1;
			w = TOTAL_WIDTH - LABEL_WIDTH - (DIALOG_MARGIN*4);
			h = ITEM_HEIGHT;
		};
		class CancelButton : ASORVS_RscButtonMenu {
			idd = 421002;
			text = "Cancel";
			x = safezoneX + DIALOG_MARGIN;
			y = TOP + (ITEM_HEIGHT*4) + (CATEGORY_SPACING*2) + 1;
			w = (TOTAL_WIDTH / 3) - ((DIALOG_MARGIN/2)*2) - DIALOG_MARGIN;
			h = ITEM_HEIGHT;
			onButtonClick = "(findDisplay 420999) closeDisplay 0";
		};
		class DeleteButton : ASORVS_RscButtonMenu {
			idd = 421004;
			text = "Delete";
			x = safezoneX + (TOTAL_WIDTH / 3) + ((DIALOG_MARGIN/2)*2);
			y = TOP + (ITEM_HEIGHT*4) + (CATEGORY_SPACING*2) + 1;
			w = (TOTAL_WIDTH / 3) - ((DIALOG_MARGIN/2)*2) - DIALOG_MARGIN;
			h = ITEM_HEIGHT;
			onButtonClick = "createDialog ""ASORVS_ConfirmDeleteDialog"";";
		};
		class SaveButton : ASORVS_RscButtonMenu {
			idc = 421003;
			text = "Save";
			x = safezoneX + ((TOTAL_WIDTH / 3)*2) + ((DIALOG_MARGIN/2)*2);
			y = TOP + (ITEM_HEIGHT*4) + (CATEGORY_SPACING*2) + 1;
			w = (TOTAL_WIDTH / 3) - ((DIALOG_MARGIN/2)*2) - DIALOG_MARGIN;
			h = ITEM_HEIGHT;
			onButtonClick = "[] spawn ASORVS_fnc_savePressed";
		};
	};
};
class ASORVS_ConfirmDeleteDialog {
	idd = 421999;
	name = "ASORVS Delete Preset";
	movingEnable = false;
	enableSimulation = true;
	onLoad = "[] spawn ASORVS_fnc_DeleteConfirm";
	class controlsBackground {
	};
	class controls {
		class Title : ASORVS_RscTitle {
			idc=-1;
			text = "Delete Preset";
			x = safezoneX + DIALOG_MARGIN;
			y = TOP;
			w = TOTAL_WIDTH - DIALOG_MARGIN;
		};
		class SelectSlotLabel: ASORVS_RscText {
			idc = 422001;
			text = "Are you sure you want to delete the preset?";
			y= TOP + (ITEM_HEIGHT*2);
			x = safezoneX + DIALOG_MARGIN;
			w = TOTAL_WIDTH - DIALOG_MARGIN;
			h = ITEM_HEIGHT;
		};
		class CancelButton : ASORVS_RscButtonMenu {
			idd = 422002;
			text = "Cancel";
			x = safezoneX + DIALOG_MARGIN;
			y = TOP + (ITEM_HEIGHT*4) + (CATEGORY_SPACING*2);
			w = (TOTAL_WIDTH / 2) - ((DIALOG_MARGIN/2)*2) - DIALOG_MARGIN;
			h = ITEM_HEIGHT;
			onButtonClick = "(findDisplay 421999) closeDisplay 0";			
		};
		class DeleteButton : ASORVS_RscButtonMenu {
			idd = 422003;
			text = "Delete";
			x = safezoneX + (TOTAL_WIDTH / 3) + ((DIALOG_MARGIN/2)*2);
			y = TOP + (ITEM_HEIGHT*4) + (CATEGORY_SPACING*2);
			w = (TOTAL_WIDTH / 2) - ((DIALOG_MARGIN/2)*2) - DIALOG_MARGIN;
			h = ITEM_HEIGHT;
			onButtonClick = "[] spawn ASORVS_fnc_deletePressed";
		};
	};
};

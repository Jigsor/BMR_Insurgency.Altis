/*
	Loosely based off Bryan "Tonic" Boardwine's VAS addon, and I use the term loosely liberally
*/

#include "LTcommon.hpp"

class LT_TransferMenu
{
	idd = 2560;
	name = "LT_transfermenu";
	movingEnabled = false;
	enableSimulation = true;

	class Controls
	{
		class MainMenu : VAS_RscControlsGroup
		{
			idc = 2600;

			class Controls
			{
				class VAS_RscTitleBackground : VAS_RscText
				{
					idc = -1;
					colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
					x = 0.25;
					y = 0.2;
					w = 0.5;
					h = (1 / 25);
				};

				class MainBackground : VAS_RscText
				{
					colorBackground[] = {0,0,0,0.7};
					idc = -1;
					x = 0.25;
					y = 0.2 + (11 / 250);
					w = 0.5;
					h = 0.6 - (22 / 250);
				};

				class Title : VAS_RscTitle
				{
					idc = -1;
					text = "Select Player to Transfer Loadout";
					x = 0.25;
					y = 0.2;
					w = 0.5;
					h = (1 / 25);
				};

				class UnitsList : VAS_RscListBox 
				{
					idc = 2601;
					text = "";
					sizeEx = 0.035;
					canDrag = 1;
					x = 0.26; y = 0.26;
					w = 0.47; h = 0.45;
				};

				class TransBtn : VAS_RscButtonMenu
				{
					idc = -1;
					text = "Transfer";
					action = "[] call LT_fnc_transferLoadout";
					//action = "nil = [""BAS""] ExecVM ""transferAction.sqf"";";
					x = 0.26 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
					y = 0.8 - (1 / 25);
					w = (6.25 / 40);
					h = (1 / 25);
				};
			};
		};
	};
};

class LT_TransferLoadout
{
	idd = 2570;
	name = "LT_transferloadout";
	movingEnabled = false;
	enableSimulation = true;

	class Controls
	{
		class MainMenu : VAS_RscControlsGroup
		{
			idc = 2700;

			class Controls
			{
				class VAS_RscTitleBackground : VAS_RscText
				{
					idc = -1;
					colorBackground[] = { "(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])" };
					x = 0.25;
					y = 0.2;
					w = 0.5;
					h = (1 / 25);
				};

				class MainBackground : VAS_RscText
				{
					colorBackground[] = { 0, 0, 0, 0.7 };
					idc = -1;
					x = 0.25;
					y = 0.2 + (11 / 250);
					w = 0.5;
					h = 0.6 - (22 / 250);
				};

				class Title : VAS_RscTitle
				{
					idc = -1;
					text = "Select Loadout to Transfer";
					x = 0.25;
					y = 0.2;
					w = 0.5;
					h = (1 / 25);
				};

				class UnitsList : VAS_RscListBox
				{
					idc = 2701;
					text = "";
					sizeEx = 0.035;
					canDrag = 1;
					x = 0.26; y = 0.26;
					w = 0.47; h = 0.45;
				};

				class TransBtn : VAS_RscButtonMenu
				{
					idc = -1;
					text = "Transfer";
					action = "[] call LT_fnc_transferAction";
					//action = "nil = [""BAS""] ExecVM ""transferAction.sqf"";";
					x = 0.26 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
					y = 0.8 - (1 / 25);
					w = (6.25 / 40);
					h = (1 / 25);
				};
			};
		};
	};
};

class LT_LoadoutMenu
{
	idd = 2580;
	name = "LT_loadoutmenu";
	movingEnabled = false;
	enableSimulation = true;

	class Controls
	{
		class MainMenu : VAS_RscControlsGroup
		{
			idc = 2800;

			class Controls
			{
				class VAS_RscTitleBackground : VAS_RscText
				{
					idc = -1;
					colorBackground[] = { "(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])" };
					x = 0.25;
					y = 0.2;
					w = 0.5;
					h = (1 / 25);
				};

				class MainBackground : VAS_RscText
				{
					colorBackground[] = { 0, 0, 0, 0.7 };
					idc = -1;
					x = 0.25;
					y = 0.2 + (11 / 250);
					w = 0.5;
					h = 0.6 - (22 / 250);
				};

				class Title : VAS_RscTitle
				{
					idc = -1;
					text = "Select Loadout to Load";
					x = 0.25;
					y = 0.2;
					w = 0.5;
					h = (1 / 25);
				};

				class LoadoutList : VAS_RscListBox
				{
					idc = 2801;
					text = "";
					sizeEx = 0.035;
					canDrag = 1;
					x = 0.26; y = 0.26;
					w = 0.47; h = 0.45;
				};

				class TransBtn : VAS_RscButtonMenu
				{
					idc = -1;
					text = "Load Loadout";
					action = "[] call LT_fnc_loadLoadout";
					//action = "nil = [""BAS""] ExecVM ""transferAction.sqf"";";
					x = 0.26 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
					y = 0.8 - (1 / 25);
					w = (6.25 / 40);
					h = (1 / 25);
				};
			};
		};
	};
};

class LT_CheckPlayerMenu
{
	idd = 2610;
	name = "LT_checkPlayerMenu";
	movingEnabled = false;
	enableSimulation = true;

	class Controls
	{
		class MainMenu : VAS_RscControlsGroup
		{
			idc = 2611;

			class Controls
			{
				class VAS_RscTitleBackground : VAS_RscText
				{
					idc = -1;
					colorBackground[] = { "(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])" };
					x = 0.25;
					y = 0.2;
					w = 0.5;
					h = (1 / 25);
				};

				class MainBackground : VAS_RscText
				{
					colorBackground[] = { 0, 0, 0, 0.7 };
					idc = -1;
					x = 0.25;
					y = 0.2 + (11 / 250);
					w = 0.5;
					h = 0.6 - (22 / 250);
				};

				class Title : VAS_RscTitle
				{
					idc = -1;
					text = "Select Player to Load Their Loadout";
					x = 0.25;
					y = 0.2;
					w = 0.5;
					h = (1 / 25);
				};

				class LoadoutList : VAS_RscListBox
				{
					idc = 2612;
					text = "";
					sizeEx = 0.035;
					canDrag = 1;
					x = 0.26; y = 0.26;
					w = 0.47; h = 0.45;
				};

				class TransBtn : VAS_RscButtonMenu
				{
					idc = -1;
					text = "Load Player LO";
					action = "[] call LT_fnc_trasferCheckPlayerLO";
					x = 0.26 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
					y = 0.8 - (1 / 25);
					w = (6.25 / 40);
					h = (1 / 25);
				};
			};
		};
	};
};

class LT_prompt 
{
	idd = 2550;
	name = "LT_prompt";
	movingEnabled = false;
	enableSimulation = true;

	class controlsBackground {
		class VAS_RscTitleBackground:VAS_RscText {
			colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
			idc = -1;
			x = 0.3;
			y = 0.2;
			w = 0.47;
			h = (1 / 25);
		};

		class MainBackground:VAS_RscText {
			colorBackground[] = {0, 0, 0, 0.7};
			idc = -1;
			x = 0.3;
			y = 0.2 + (11 / 250);
			w = 0.47;
			h = 0.22 - (22 / 250);
		};
	};

	class controls 
	{
		class InfoMsg : VAS_RscStructuredText
		{
			idc = 2551;
			sizeEx = 0.020;
			text = "";
			x = 0.287;
			y = 0.2 + (11 / 250);
			w = 0.5; h = 0.12;
		};

		class yesBTN : VAS_RscButtonMenu {
			idc = 2552;
			text = "$STR_VAS_Prompt_addToWeapon";
			//colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
			onButtonClick = "lt_prompt_choice = true; closeDialog 0;";
			x = 0.145 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.42 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};

		class noBTN : VAS_RscButtonMenu {
			idc = 2553;
			text = "$STR_VAS_Prompt_addToInv";
			//colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
			onButtonClick = "lt_prompt_choice = false; closeDialog 0;";
			x = 0.455 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.42 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};

		class blankPHVAS : VAS_RscText
		{
			colorBackground[] = {0, 0, 0, 0.7};
			idc = -1;
			x = 0.304 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.42 - (1 / 25);
			w = (5.9 / 40);
			h = (1 / 25);
		};
	};
};

class LT_MainMenu
{
	idd = 2400;
	name = "LT_mainMenu";
	movingEnabled = false;
	enableSimulation = true;

	class controlsBackground {
		class VAS_RscTitleBackground :VAS_RscText {
			colorBackground[] = { "(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])" };
			idc = -1;
			text = "Loadout Transfer Menu";
			x = 0.3;
			y = 0.2;
			w = 0.47;
			h = (1 / 25);
		};

		class MainBackground :VAS_RscText {
			colorBackground[] = { 0, 0, 0, 0.7 };
			idc = -1;
			x = 0.3;
			y = 0.2 + (11 / 250);
			w = 0.47;
			h = 0.4;
		};
	};

	class controls {

		class LoadBtn : VAS_RscButtonMenu
		{
			idc = 2401;
			text = "Load";
			colorBackground[] = { "(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5 };
			onButtonClick = "[] spawn LT_fnc_loadoutMenu;";
			x = 0.51; y = 0.30;
			w = (7.25 / 40);
			h = (1 / 25);
		};

		class TransferBtn : VAS_RscButtonMenu
		{
			idc = 2402;
			text = "Transfer";
			colorBackground[] = { "(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5 };
			onButtonClick = "[] spawn LT_fnc_transferMenu;";
			x = 0.51; y = 0.35;
			w = (7.25 / 40);
			h = (1 / 25);
		};

		class ArsenalBtn : VAS_RscButtonMenu
		{
			idc = 2403;
			text = "Arsenal";
			colorBackground[] = { "(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5 };
			onButtonClick = "closeDialog 0; [""Open"",true] spawn BIS_fnc_arsenal;";
			x = 0.51; y = 0.40;
			w = (7.25 / 40);
			h = (1 / 25);
		};

		class ManageLOsBtn : VAS_RscButtonMenu
		{
			idc = 2404;
			text = "Manage LOs";
			colorBackground[] = { "(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5 };
			onButtonClick = "[] spawn Lt_fnc_manageLoadouts;";
			x = 0.51; y = 0.45;
			w = (7.25 / 40);
			h = (1 / 25);
		};

		class LoadServerBtn : VAS_RscButtonMenu
		{
			idc = 2405;
			text = "Server LOs";
			colorBackground[] = { "(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5 };
			onButtonClick = "hint ""Not Implemented Yet""";
			x = 0.51; y = 0.50;
			w = (7.25 / 40);
			h = (1 / 25);
		};


		class AdminServerBtn : VAS_RscButtonMenu
		{
			idc = 2406;
			text = "Check Player";
			colorBackground[] = { "(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5 };
			onButtonClick = "[] spawn LT_fnc_checkPlayerMenu;";
			x = 0.51; y = 0.55;
			w = (7.25 / 40);
			h = (1 / 25);
		};

		class ButtonClose : VAS_RscButtonMenu {
			idc = -1;
			//shortcuts[] = {0x00050000 + 2};
			text = "Close";
			onButtonClick = "closeDialog 0;";
			x = 0.38;
			y = 0.7 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};

		class ButtonSaveGear : VAS_RscButtonMenu {
			idc = -1;
			text = "Save Gear";
			onButtonClick = "createDialog ""LT_Save_Diag"";";
			x = 0.38 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.7 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};

		class ltLogo : VAS_RscPictureKeepAspect
		{
			colorBackground[] = { 0, 0, 0, 0.7 };
			idc = -1;
			text = "LT\images\LT.paa";

			x = 0.33;
			y = 0.3;
			w = 0.15;
			h = 0.15;
		};
	};

};

class LT_Modify_Diag {
	idd = 2510;
	name = "LT Save";
	movingEnable = false;
	enableSimulation = true;
	onLoad = "[0] spawn LT_fnc_modifyLoad";

	class controlsBackground {
		class VAS_RscTitleBackground :VAS_RscText {
			colorBackground[] = { "(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])" };
			idc = -1;
			x = 0.1;
			y = 0.2;
			w = 0.6;
			h = (1 / 25);
		};

		class MainBackground :VAS_RscText {
			colorBackground[] = { 0, 0, 0, 0.7 };
			idc = -1;
			x = 0.1;
			y = 0.2 + (11 / 250);
			w = 0.6;
			h = 0.6 - (22 / 250);
		};
	};

	class controls
	{
		class Title : VAS_RscTitle {
			colorBackground[] = { 0, 0, 0, 0 };
			idc = -1;
			text = "Save Loadout";
			x = 0.1;
			y = 0.2;
			w = 0.6;
			h = (1 / 25);
		};

		class SaveLoadoutList : VAS_RscListBox
		{
			idc = 2511;
			text = "";
			sizeEx = 0.035;
			onLBSelChanged = "[0] spawn LT_fnc_loadoutChange";

			x = 0.12; y = 0.26;
			w = 0.330; h = 0.360;
		};

		class SaveFetchList : VAS_RscListBox
		{
			idc = 2513;
			colorBackground[] = { 0, 0, 0, 0 };
			text = "";
			sizeEx = 0.030;
			onLBSelChanged = "[0] spawn LT_fnc_loadoutModify";

			x = 0.45; y = 0.26;
			w = 0.23; h = 0.360;
		};

		class SaveLoadEdit : VAS_RscEdit
		{
			idc = 2512;
			text = "";

			x = -0.05 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.73 - (1 / 25);
			w = (13 / 40);
			h = (1 / 25);
		};

		class CloseSaveMenu : VAS_RscButtonMenu {
			idc = -1;
			text = "Close";
			onButtonClick = "closeDialog 0;";
			x = -0.06 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.8 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};

		class GearSaveMenu : VAS_RscButtonMenu {
			idc = 2518;
			text = "Rename";
			colorBackground[] = { "(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5 };
			onButtonClick = "[] spawn LT_fnc_changeName";
			x = 0.35 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.73 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};
	};
};

class LT_Save_Diag {
	idd = 2620;
	name = "LT Save";
	movingEnable = false;
	enableSimulation = true;
	onLoad = "[0] spawn LT_fnc_saveLoad";

	class controlsBackground {
		class VAS_RscTitleBackground :VAS_RscText {
			colorBackground[] = { "(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])" };
			idc = -1;
			x = 0.1;
			y = 0.2;
			w = 0.6;
			h = (1 / 25);
		};

		class MainBackground :VAS_RscText {
			colorBackground[] = { 0, 0, 0, 0.7 };
			idc = -1;
			x = 0.1;
			y = 0.2 + (11 / 250);
			w = 0.6;
			h = 0.6 - (22 / 250);
		};
	};

	class controls
	{
		class Title : VAS_RscTitle {
			colorBackground[] = { 0, 0, 0, 0 };
			idc = -1;
			text = "Save Loadout";
			x = 0.1;
			y = 0.2;
			w = 0.6;
			h = (1 / 25);
		};

		class SaveLoadoutList : VAS_RscListBox
		{
			idc = 2621;
			text = "";
			sizeEx = 0.035;
			onLBSelChanged = "[0] spawn LT_fnc_saveLoChange";

			x = 0.12; y = 0.26;
			w = 0.330; h = 0.360;
		};

		class SaveLoadEdit : VAS_RscEdit
		{
			idc = 2623;
			text = "";

			x = -0.05 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.73 - (1 / 25);
			w = (13 / 40);
			h = (1 / 25);
		};

		class CloseSaveMenu : VAS_RscButtonMenu {
			idc = -1;
			text = "Close";
			onButtonClick = "closeDialog 0;";
			x = -0.06 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.8 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};

		class GearSaveMenu : VAS_RscButtonMenu {
			idc = -1;
			text = "Save";
			colorBackground[] = { "(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5 };
			onButtonClick = "[] spawn LT_fnc_saveGear";
			x = 0.35 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.73 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};
	};
};
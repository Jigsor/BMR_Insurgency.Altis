 /******************************************************************************
 *                        ,1             ,-===========.
 *                       /,| _____________________\\_                _
 *    ,========.________//_|/===========._#############L_Y_....-----====//
 *   (#######(==========\################\=======.______ --############((
 *    `=======`"        ` ===============|::::.___|[ ))[JW]#############\\
 *                                       |####|     ""\###|   :##########\\
 *                                      /####/         \##\     ```"""=,,,))
 *     C R E A T E D   B Y   B T K     /####/           \##\
 *                                    '===='             `=`
 *******************************************************************************
 *
 *  The supported transporter types.
 *	Edit below.
 *
 *	You can use the whole class tree:
 *	http://community.bistudio.com/wiki/ArmA_2:_CfgVehicles
 *	http://community.bistudio.com/wiki/ArmA_2_OA:_CfgVehicles
 *
 ******************************************************************************/
 
//// Small
if (_TransporterType in [
	"AH6_Base_EP1",
	"Su25_base",
	"F35_base",
	"AV8B2",
	"A10",
	"AH1_Base",
	"AH64_base_EP1",
	"Kamov_Base",
	"An2_Base_EP1",
	"L39_base",
	"An2_Base_EP1",
	"AW159_Lynx_BAF",
	"MQ9PredatorB"
]) then {_SelectedTransporterTypeS = true;};

//// Medium
if (_TransporterType in [
	"UH1_Base",
	"UH60_Base",
	"UH60M_base_EP1",
	"BAF_Merlin_HC3_D",
	"Mi24_Base",
	"UH1H_base"
]) then {_SelectedTransporterTypeM = true;};

//// Large
if (_TransporterType in [
	"CH47_base_EP1",
	"Mi17_base",
	"Mi171Sh_Base_EP1",
	"MV22"
]) then {_SelectedTransporterTypeL = true;};

//// XTRA Large
if (_TransporterType in [
	"C130J_base",
	"I_Heli_Transport_02_F",
	"rhsusf_CH53E_USMC_D",
	"rhsusf_CH53E_USMC_W",
	"CUP_B_Merlin_HC3A_Armed_GB",
	"OPTRE_Pelican_unarmed",
	"ffaa_nh90_nfh_transport"
]) then {_SelectedTransporterTypeXL = true;};
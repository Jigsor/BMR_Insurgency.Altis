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
if (
(_Transporter isKindOf "AH6_Base_EP1") ||
(_Transporter isKindOf "Su25_base") ||
(_Transporter isKindOf "F35_base") ||
(_Transporter isKindOf "AV8B2") ||
(_Transporter isKindOf "A10") ||
(_Transporter isKindOf "AH1_Base") ||
(_Transporter isKindOf "AH64_base_EP1") ||
(_Transporter isKindOf "Kamov_Base") ||
(_Transporter isKindOf "An2_Base_EP1") ||
(_Transporter isKindOf "L39_base") ||
(_Transporter isKindOf "An2_Base_EP1") ||
(_Transporter isKindOf "AW159_Lynx_BAF") ||
(_Transporter isKindOf "MQ9PredatorB")
) then { _SelectedTransporterTypeS = true; };

//// Medium
if (
(_Transporter isKindOf "UH1_Base") ||
(_Transporter isKindOf "UH60_Base") ||
(_Transporter isKindOf "UH60M_base_EP1") ||
(_Transporter isKindOf "BAF_Merlin_HC3_D") ||
(_Transporter isKindOf "Mi24_Base") ||
(_Transporter isKindOf "UH1H_base")
) then { _SelectedTransporterTypeM = true; };

//// Large
if (
(_Transporter isKindOf "CH47_base_EP1") ||
(_Transporter isKindOf "Mi17_base") ||
(_Transporter isKindOf "Mi171Sh_Base_EP1") ||
(_Transporter isKindOf "MV22")
) then { _SelectedTransporterTypeL = true; };

//// XTRA Large
if (
(_Transporter isKindOf "C130J_base") ||
(_Transporter isKindOf "I_Heli_Transport_02_F") ||
(_Transporter isKindOf "rhsusf_CH53E_USMC_D") ||
(_Transporter isKindOf "rhsusf_CH53E_USMC_W") ||
(_Transporter isKindOf "CUP_B_Merlin_HC3A_Armed_GB") ||
(_Transporter isKindOf "OPTRE_Pelican_armed_black") ||
(_Transporter isKindOf "ffaa_nh90_nfh_transport")
) then { _SelectedTransporterTypeXL = true; };
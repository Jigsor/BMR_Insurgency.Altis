class CfgSounds
{
	sounds[] = {NoSound,cantDo,Vent,Vent2,Para,shout,introfx,siren,HighVoltage,boo};
	//class NoSound {name="NoSound";sound[]={"", 0, 1};titles[] = {};};
//JW Custom CAS	
	class cantDo {name="cantDo";sound[]={"JWC_CASFS\cantDo.ogg", 1.0, 1.0};titles[] = {};};
//Suicide Bomber
	class shout {name="shout";sound[]={"Sound\shout.ogg", 4, 1, 100};titles[] = {};};
//Jig's Sounds
	class introfx {name="introfx";sound[]={"Sound\introfx.ogg", db-10, 1.0};titles[] = {};};
	class siren {name="siren";sound[]={"Sound\siren.ogg", db+18, 1.0,900};titles[] = {};};	
	class HighVoltage {name="HighVoltage";sound[]={"Sound\HighVoltage.ogg", db+19, 1.0,900};titles[] = {};};
	class boo {name="boo";sound[]={"Sound\boo.ogg", db+3, 1.0};titles[] = {};};
};
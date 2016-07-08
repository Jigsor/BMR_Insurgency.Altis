// INFANTRY SKILL
_InfskillSet = [
0.30, // aimingAccuracy
0.45, // aimingShake
0.7, // aimingSpeed
0.9, // spotDistance
0.5, // spotTime
0.9, // courage
1, // reloadSpeed
1, // commanding
1 // general
];

// ARMOUR SKILL
_ArmSkillSet = [
0.25, // aimingAccuracy
0.45, // aimingShake
0.6, // aimingSpeed
0.4, // spotDistance
0.4, // spotTime
1, // courage
1, // reloadSpeed
1, // commanding
1 // general
];

// LIGHT VEHICLE skill
_LigSkillSet = [
0.25, // aimingAccuracy
0.45, // aimingShake
0.6, // aimingSpeed
0.4, // spotDistance
0.4, // spotTime
1, // courage
1, // reloadSpeed
1, // commanding
1 // general
];

// HELICOPTER SKILL
_AIRskillSet = [
0.25, // aimingAccuracy
0.45, // aimingShake
0.6, // aimingSpeed
0.4, // spotDistance
0.4, // spotTime
1, // courage
1, // reloadSpeed
1, // commanding
1  // general
];

// STATIC SKILL
_STAskillSet = [
0.25, // aimingAccuracy
0.45, // aimingShake
0.6, // aimingSpeed
0.4, // spotDistance
0.4, // spotTime
1, // courage
1, // reloadSpeed
1, // commanding
1 // general
];

server setvariable ["civINFskill",_InfskillSet];
server setvariable ["civARMskill",_ArmSkillSet];
server setvariable ["civLIGskill",_LigSkillSet];
server setvariable ["civAIRskill",_AIRskillSet];
server setvariable ["civSTAskill",_STAskillSet];
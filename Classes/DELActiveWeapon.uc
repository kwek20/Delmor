/**
 * JAVADOC!!!!!!!!!!!!!!!!!!!!!11111111one
 */
class DELActiveWeapon extends UDKWeapon;

var DELMeleeWeapon MeleeWeapon;
var DELMagic ActiveMagic;
var array<DELMagic> AbilityList;
var bool magician;

simulated function StartFire(byte FireModeNum){
	if(FireModeNum == 0){
		MeleeWeapon.StartFire(0);
	} else if(magician && FireModeNum == 1){
		ActiveMagic.StartFire(0);
	} else{
		`log("cannot use magic yet");
	}
}

simulated function TimeWeaponEquipping(){
	MeleeWeapon.TimeWeaponEquipping();
}

simulated function GetMagic(){
	magician = true;
	ActiveMagic = AbilityList[0];
}

simulated function SwitchMagic(int number){
	if(magician){
		ActiveMagic = AbilityList[number-1];
	} else{
		`log("cannot use magic yet");
	}
}


DefaultProperties
{
	magician = false;

	MeleeWeapon=DELMeleeWeapon'Delmor.DELMeleeWeapon'
	AbilityList[0] = DELMagic'DELMagic'
	AbilityList[1] = DELMagic'DELMagic'
	AbilityList[2] = DELMagic'DELMagic'
}

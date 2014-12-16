class DELMeleeWeaponRatClaws extends DELMeleeWeapon;

DefaultProperties
{
	criticalHitChance = 0
	criticalDamageMultiplier = 1
	damageMin = 1;
	damageMax = 1;
	
	bHardAttach = true
	swordHiltSocketName = SwordHiltSocket
	swordTipSocketName = SwordTipSocket
	handSocketName = WeaponPoint

	dmgType = class'DELDmgTypeMelee'

	MaxSwings=3
	Swings(0)=3

	FireInterval(0)=0.5

	damageMin = 5;
	damageMax = 15;

	bMeleeWeapon=true;
	bInstantHit=true;
	bCanThrow=false;

	FiringStatesArray(0)="Swinging"
	WeaponFireTypes(0)=EWFT_Custom
}
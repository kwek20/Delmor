class DELMeleeWeaponRatClaws extends DELMeleeWeapon;

DefaultProperties
{
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
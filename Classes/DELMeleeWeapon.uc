/**
 * Sword used in Delmor
 */
class DELMeleeWeapon extends UDKWeapon;
var() const name SwordHiltSocketName;
var() const name SwordTipSocketName;

var array<Actor> SwingHitActors;
var const int Swings;
var const int MaxSwings;

simulated state WeaponFiring{
	simulated event Tick(float DeltaTime){

	}
}



DefaultProperties
{
	MaxSwings=2
	Swings(0)=2
	bMeleeWeapon=true;
	bInstantHit=true;
	bCanThrow=false;
	WeaponFireTypes(0)=EWFT_Custom
}

/**
 * Sword used in Delmor
 * made bij Harmen Wiersma
 */
class DELMeleeWeapon extends UDKWeapon;
var() const name SwordHiltSocketName,SwordTipSocketName, SwordAnimationName;
var array<Actor> SwingHitActors;

var array<int> Swings;
var const int MaxSwings;

simulated state WeaponFiring{
	simulated event Tick(float DeltaTime){
	}
}


function Vector GetSwordSocketLocation(Name SocketName){
	local Vector SocketLocation;
	local Rotator SwordRotation;
	local SkeletalMeshComponent SMC;
	SMC = SkeletalMeshComponent(Mesh);
	
	if (SMC != none && SMC.GetSocketByName(SocketName) != none){
		SMC.GetSocketWorldLocationAndRotation(SocketName, SocketLocation, SwordRotation);
	}
	return SocketLocation;
}

DefaultProperties
{
	MaxSwings=3
	Swings(0)=3

	bMeleeWeapon=true;
	bInstantHit=true;
	bCanThrow=false;
	FiringStatesArray(0)="Swinging"

	WeaponFireTypes(0)=EWFT_Custom
}

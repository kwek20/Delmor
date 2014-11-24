/**
 * Sword used in Delmor
 * made bij Harmen Wiersma
 */
class DELMeleeWeapon extends DELWeapon;
var() const name swordHiltSocketName,swordTipSocketName, swordAnimationName;
var array<Actor> swingHitActors;

var array<int> swings;
var const int maxSwings;

simulated state WeaponFiring{
	simulated event Tick(float DeltaTime){
		super.Tick(DeltaTime);
		TraceSwing();
	}

	
	simulated event EndState(Name NextStateName)
	{
		super.EndState(NextStateName);
		SetTimer(GetFireInterval(CurrentFireMode), false, nameof(ResetSwings));
	}
}

simulated function TraceSwing()
{
	local Actor HitActor;
	local Vector HitLoc, HitNorm, SwordTip, SwordHilt, Momentum;
	local int DamageAmount;

	SwordTip = GetSwordSocketLocation(SwordTipSocketName);
	SwordHilt = GetSwordSocketLocation(SwordHiltSocketName);
	DamageAmount = calculateDamage();


	foreach TraceActors(class'Actor', HitActor, HitLoc, HitNorm, SwordTip, SwordHilt)
	{
		if (HitActor != self && AddToSwingHitActors(HitActor))
		{
			Momentum = Normal(SwordTip - SwordHilt) * InstantHitMomentum[CurrentFireMode];
			HitActor.TakeDamage(DamageAmount, Instigator.Controller, HitLoc, Momentum, class'DamageType');
			//PlaySound(SwordClank);
		}
	}
}

function bool AddToSwingHitActors(Actor HitActor)
{
	local int i;

	for (i = 0; i < SwingHitActors.Length; i++)
	{
		if (SwingHitActors[i] == HitActor)
		{
			return false;
		}
	}

	SwingHitActors.AddItem(HitActor);
	return true;
}

simulated function Vector GetSwordSocketLocation(Name SocketName){
	local Vector SocketLocation;
	local Rotator SwordRotation;
	local SkeletalMeshComponent SMC;
	SMC = SkeletalMeshComponent(Mesh);
	
	if (SMC != none && SMC.GetSocketByName(SocketName) != none){
		SMC.GetSocketWorldLocationAndRotation(SocketName, SocketLocation, SwordRotation);
	}
	return SocketLocation;
}

simulated function int CalculateDamage(){
	local int damageRange, damage;
	damageRange = (damageMax - damageMin);
	damage = Rand(damageRange);
	if (doesCrit()) damage = addCrit(damage);
	return damage;
}

simulated function bool doesCrit(){
	local int wheelOfFortune;
	wheelOfFortune = Rand(100);
	return wheelOfFortune<criticalHitChance;
}

simulated function int addCrit(int damage){
	return damage * criticalDamageMultiplier;
}


DefaultProperties
{
	MaxSwings=3
	Swings(0)=3

	damageMin = 10;
	damageMax = 50;

	bMeleeWeapon=true;
	bInstantHit=true;
	bCanThrow=false;
	FiringStatesArray(0)="Swinging"

	WeaponFireTypes(0)=EWFT_Custom
}

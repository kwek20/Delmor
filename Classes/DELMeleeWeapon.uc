/**
 * Sword used in Delmor
 * made bij Harmen Wiersma
 */
class DELMeleeWeapon extends DELWeapon;
var() const name swordHiltSocketName,swordTipSocketName, swordAnimationName, handSocketName;
var array<Actor> swingHitActors;
var class<DamageType> dmgType;

var array<int> swings;
var const int maxSwings;

simulated state Swinging extends WeaponFiring {
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

function ResetSwings()
{
	RestoreAmmo(MaxSwings);
}

simulated function TimeWeaponEquipping()
{
    super.TimeWeaponEquipping();
    AttachWeaponTo( Instigator.Mesh,handSocketName );
}
 
simulated function AttachWeaponTo( SkeletalMeshComponent MeshCpnt, optional Name SocketName )
{
    MeshCpnt.AttachComponentToSocket(Mesh,SocketName);
}

simulated event SetPosition(UDKPawn Holder){
    local SkeletalMeshComponent compo;
    local SkeletalMeshSocket socket;
    local Vector FinalLocation;
 
    compo = Holder.Mesh;
    if (compo != none){
        socket = compo.GetSocketByName(handSocketName);
        if (socket != none){
            FinalLocation = compo.GetBoneLocation(socket.BoneName);
        }
    } //And we probably should do something similar for the rotation <img src="http://www.moug-portfolio.info/wp-includes/images/smilies/icon_smile.gif" alt=":)" class="wp-smiley"> 
 
    SetLocation(FinalLocation);
}

simulated function TraceSwing(){
	local Actor HitActor;
	local Vector HitLoc, HitNorm, SwordTip, SwordHilt, Momentum;
	local int DamageAmount;

	SwordTip = GetSwordSocketLocation(SwordTipSocketName);
	SwordHilt = GetSwordSocketLocation(SwordHiltSocketName);
	//DamageAmount = FCeil(InstantHitDamage[CurrentFireMode]);
	DamageAmount = calculateDamage();


	foreach TraceActors(class'Actor', HitActor, HitLoc, HitNorm, SwordTip, SwordHilt)
	{
		if (HitActor != self && AddToSwingHitActors(HitActor))
		{
			//Momentum = Normal(SwordTip - SwordHilt) * InstantHitMomentum[CurrentFireMode];
			HitActor.TakeDamage(DamageAmount, Instigator.Controller, HitLoc, Momentum, dmgType);
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



function RestoreAmmo(int Amount, optional byte FireModeNum)
{
	Swings[FireModeNum] = Min(Amount, MaxSwings);
}

function ConsumeAmmo(byte FireModeNum)
{
	if (HasAmmo(FireModeNum))
	{
		Swings[FireModeNum]--;
	}
}

simulated function bool HasAmmo(byte FireModeNum, optional int Ammount)
{
	return Swings[FireModeNum] > Ammount;
}

simulated function FireAmmunition(){
	StopFire(CurrentFireMode);
	SwingHitActors.Remove(0, SwingHitActors.Length);

	if (HasAmmo(CurrentFireMode)){
		`log(Swings[0]);
		if (MaxSwings - Swings[0] == 0) {
			DelPlayer(Owner).SwingAnim.PlayCustomAnim('Lucian_slash1', 1.f,0.1f,0.1f,false,true);
		} else if (MaxSwings - Swings[0] == 1){
			DelPlayer(Owner).SwingAnim.PlayCustomAnim('Lucian_slash1', 1.0);
			`log("surprise motherf***er");
		} else {
			DelPlayer(Owner).SwingAnim.PlayCustomAnim('Lucian_slash1', 1.0);
		}

		//PlayWeaponAnimation(SwordAnimationName, GetFireInterval(CurrentFireMode));
		super.FireAmmunition();
	}
}
DefaultProperties
{
	bHardAttach = true
	swordHiltSocketName = SwordHiltSocket
	swordTipSocketName = SwordTipSocket
	handSocketName = WeaponPoint
	//swordHiltSocketName = StartControl
	//swordTipSocketName = EndControl

	dmgType = class'DELDmgTypeMelee'


	MaxSwings=3
	Swings(0)=3

	FireInterval(0)=0.25

	damageMin = 10;
	damageMax = 50;

	bMeleeWeapon=true;
	bInstantHit=true;
	bCanThrow=false;

	FiringStatesArray(0)="Swinging"

	WeaponFireTypes(0)=EWFT_Custom

}

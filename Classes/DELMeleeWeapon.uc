/**
 * Sword used in Delmor
 * made bij Harmen Wiersma
 */
class DELMeleeWeapon extends DELWeapon;
var() const name swordHiltSocketName,swordTipSocketName, swordAnimationName;
var array<Actor> swingHitActors;

var array<int> swings;
var const int maxSwings;

simulated state Swinging{
	simulated event Tick(float DeltaTime){
		super.Tick(DeltaTime);
		TraceSwing();
	}
	simulated event BeginState(Name NextStateName){
		`log("Swing that mothafucka");
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

simulated function TimeWeaponEquipping(){
    super.TimeWeaponEquipping();
    AttachWeaponTo( instigator.Mesh,'WeaponPoint' );
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
        socket = compo.GetSocketByName('WeaponPoint');
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

simulated function FireAmmunition()
{
	StopFire(CurrentFireMode);
	SwingHitActors.Remove(0, SwingHitActors.Length);

	if (HasAmmo(CurrentFireMode))
	{
	/*	if (MaxSwings - Swings[0] == 0) {
			MeleeWeaponPawn(Owner).SwingAnim.PlayCustomAnim('SwingOne', 1.0);
		} else if (MaxSwings - Swings[0] == 1){
			MeleeWeaponPawn(Owner).SwingAnim.PlayCustomAnim('SwingTwo', 1.0);
		}
		else{
			MeleeWeaponPawn(Owner).SwingAnim.PlayCustomAnim('SwingThree', 1.0);
		}*/



		PlayWeaponAnimation(SwordAnimationName, GetFireInterval(CurrentFireMode));

		super.FireAmmunition();
	}
}
DefaultProperties
{
	bHardAttach = true
	swordHiltSocketName = swordHiltSocket
	swordTipSocketName = swordTipSocket

	MaxSwings=3
	Swings(0)=3

	damageMin = 10;
	damageMax = 50;

	bMeleeWeapon=true;
	bInstantHit=true;
	bCanThrow=false;
	bInvisible=true;
	FiringStatesArray(0)="Swinging"

	WeaponFireTypes(0)=EWFT_Custom

	Begin Object class=SkeletalMeshComponent Name=MeleeWeapon
        SkeletalMesh=SkeletalMesh'GDC_Materials.Meshes.SK_ExportSword2'
        FOV=60
		HiddenGame=FALSE
        HiddenEditor=FALSE
        //Animations=MeshSequenceA
        //AnimSets(0)=AnimSet'CastersSwordPackage.Sword.AnimSetSword'
        bForceUpdateAttachmentsInTick=True
        Scale=0.9000000
	End Object
    Mesh=MeleeWeapon
	
    Components.Add(MeleeWeapon)
}

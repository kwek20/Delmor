/**
 * Sword used in Delmor
 * made bij Harmen Wiersma
 */
class DELMeleeWeapon extends DELWeapon;
var() const name swordHiltSocketName,swordTipSocketName, swordAnimationName;
var array<Actor> swingHitActors;

var array<int> swings;
var const int maxSwings;

simulated state Swinging extends WeaponFiring {
	simulated event Tick(float DeltaTime){
		super.Tick(DeltaTime);
		TraceSwing();
	}
	/*simulated event BeginState(Name NextStateName){
		`log("Swing that mothafucka");
		FireAmmunition();
	}*/
	
	simulated event EndState(Name NextStateName)
	{
		super.EndState(NextStateName);
		SetTimer(GetFireInterval(CurrentFireMode), false, nameof(ResetSwings));
		`log("i have swinged my sword");
	}
}

function ResetSwings()
{
	RestoreAmmo(MaxSwings);
}

simulated function TimeWeaponEquipping()
{
    super.TimeWeaponEquipping();
    AttachWeaponTo( Instigator.Mesh,'WeaponPoint' );
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
			//Momentum = Normal(SwordTip - SwordHilt) * InstantHitMomentum[CurrentFireMode];
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
	`log("FireAmmunition");
	StopFire(CurrentFireMode);
	SwingHitActors.Remove(0, SwingHitActors.Length);

	if (HasAmmo(CurrentFireMode))
	{
		`log("Swing:");
		`log(Swings[0]);
		if (MaxSwings - Swings[0] == 0) {
			`log(Swings[0]);
			DelPlayer(Owner).SwingAnim.PlayCustomAnim('Lucian_slash1', 1.f,0.1f,0.1f,false,true);
		} else if (MaxSwings - Swings[0] == 1){
			DelPlayer(Owner).SwingAnim.PlayCustomAnim('Lucian_slash1', 1.0);
		}
		else{
			DelPlayer(Owner).SwingAnim.PlayCustomAnim('Lucian_slash1', 1.0);
		}
		`log("swing complete?");


		//PlayWeaponAnimation(SwordAnimationName, GetFireInterval(CurrentFireMode));


		super.FireAmmunition();
	}
}
DefaultProperties
{
	bHardAttach = true
	swordHiltSocketName = SwordHiltSocket
	swordTipSocketName = SwordTipSocket
	//swordHiltSocketName = StartControl
	//swordTipSocketName = EndControl


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

	Begin Object class=SkeletalMeshComponent Name=MeleeWeapon
        SkeletalMesh=SkeletalMesh'Delmor_Character.Meshes.sk_lucian_sword'
        FOV=60
		HiddenGame=FALSE
        HiddenEditor=FALSE
        //Animations=MeshSequenceA
        AnimSets(0)=AnimSet'Delmor_Character.Lucian_walking'
		AnimtreeTemplate=AnimTree'Delmor_Character.Lucian_AnimTree'
        bForceUpdateAttachmentsInTick=True
		bCacheAnimSequenceNodes=false
		AlwaysLoadOnClient=true
		AlwaysLoadOnServer=true
		CastShadow=true
		BlockRigidBody=true
		bUpdateSkelWhenNotRendered=false
		bIgnoreControllersWhenNotRendered=true
		bUpdateKinematicBonesFromAnimation=true
		bCastDynamicShadow=true
		RBChannel=RBCC_Untitled3
		RBCollideWithChannels=(Untitled3=true)
		bOverrideAttachmentOwnerVisibility=true
		bAcceptsDynamicDecals=false
		bHasPhysicsAssetInstance=true
		TickGroup=TG_PreAsyncWork
		MinDistFactorForKinematicUpdate=0.2f
		bChartDistanceFactor=true
		RBDominanceGroup=20
		Scale=1.f
		bAllowAmbientOcclusion=false
		bUseOnePassLightingOnTranslucency=true
		bPerBoneMotionBlur=true
	End Object
    Mesh=MeleeWeapon
	
    Components.Add(MeleeWeapon)
}

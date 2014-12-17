/**
 * fist weapons
 */
class DELMeleeWeaponFists extends DELMeleeWeapon;
/**
 * socketnames of the lefthanded 'weapon'
 */
var() const name offHandHiltSocketName, offHandTipSocketName;

/**
 * overrides the normal attachweapon to because there is no mesh
 */
simulated function AttachWeaponTo( SkeletalMeshComponent MeshCpnt, optional Name SocketName ){
    //simply overriding shit, nothing else
}

/**
 * overrides the setposition of delmeleeweapon
 */
simulated event SetPosition(UDKPawn Holder){
//woohoo another override
}

/**
 * addition of traceswing so that also the other hand is traced
 */
simulated function TraceSwing(){
	local Vector SwordTip2, SwordHilt2;
	local Actor HitActor;
	local Vector HitLoc, HitNorm, Momentum;
	local int DamageAmount;
	super.TraceSwing();

	//gets the socket locations of alternative 'weapon'
	SwordTip2 = GetSwordSocketLocation(offHandTipSocketName);
	SwordHilt2 = GetSwordSocketLocation(offHandHiltSocketName);

	//trace the altweapon
	foreach TraceActors(class'Actor', HitActor, HitLoc, HitNorm, SwordTip2, SwordHilt2){
		if (HitActor != self && AddToSwingHitActors(HitActor)){
			HitActor.TakeDamage(DamageAmount, Instigator.Controller, HitLoc, Momentum, dmgType);
			//PlaySound(SwordClank);
		}
	}
}

/**
 * gets the location of the socket
 * @param socketname name of the socket
 * @return location of socket
 */
simulated function Vector GetSwordSocketLocation(Name SocketName){
	local Vector SocketLocation;
	local Rotator SwordRotation;
	local SkeletalMeshComponent SMC;

	SMC = DELPawn(owner).Mesh;


	if (SMC != none && SMC.GetSocketByName(SocketName) != none){
		SMC.GetSocketWorldLocationAndRotation(SocketName, SocketLocation, SwordRotation);
	}
	return SocketLocation;
}

DefaultProperties
{
	criticalHitChance = 0
	criticalDamageMultiplier = 1
	damageMin = 1;
	damageMax = 1;

	animname1 = attack1
	animname2 = attack2
	animname3 = attack1
	swordHiltSocketName = R_wrist
	swordTipSocketName = R_nail
	offHandHiltSocketName = L_wrist
	offHandTipSocketName = L_nail
	critChance = 0;

	Begin Object class=SkeletalMeshComponent Name=MeleeWeapon
		SkeletalMesh=SkeletalMesh'delmor_character.Meshes.sk_lucian_sword2'
        FOV=60
		HiddenGame=FALSE
        HiddenEditor=FALSE
        //Animations=MeshSequenceA
        AnimSets(0)=AnimSet'Delmor_Character.Ratman_anim'
		AnimtreeTemplate=AnimTree'Delmor_Character.Ratman_AnimTree'
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

class DELMeleeWeaponFists extends DELMeleeWeapon;

var() const name offHandHiltSocketName, offHandTipSocketName;

simulated function AttachWeaponTo( SkeletalMeshComponent MeshCpnt, optional Name SocketName ){
    //simply overriding shit, nothing else
}

simulated event SetPosition(UDKPawn Holder){
//woohoo another override
}

simulated function TraceSwing(){
	local Vector SwordTip2, SwordHilt2;
	local Actor HitActor;
	local Vector HitLoc, HitNorm, Momentum;
	local int DamageAmount;
	super.TraceSwing();

	SwordTip2 = GetSwordSocketLocation(offHandTipSocketName);
	SwordHilt2 = GetSwordSocketLocation(offHandHiltSocketName);

	`log( "SwordTip2: "$SwordTip2 );
	`log( "SwordHilt2: "$SwordHilt2 );

	foreach TraceActors(class'Actor', HitActor, HitLoc, HitNorm, SwordTip2, SwordHilt2){
		if (HitActor != self && AddToSwingHitActors(HitActor)){
			HitActor.TakeDamage(DamageAmount, Instigator.Controller, HitLoc, Momentum, dmgType);
			//PlaySound(SwordClank);
		}
	}
}

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

class DELMeleeWeaponDemonSlayer extends DELMeleeWeapon;

DefaultProperties
{
	bHardAttach = true
	swordHiltSocketName = SwordHiltSocket
	swordTipSocketName = SwordTipSocket
	handSocketName = WeaponPoint

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

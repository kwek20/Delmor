class DELMeleeWeaponDagger extends DELMeleeWeapon;

DefaultProperties
{
	FireInterval(0)=0.25

	criticalHitChance = 50
	criticalDamageMultiplier = 2
	damageMin = 20;
	damageMax = 40;

	Begin Object class=SkeletalMeshComponent Name=MeleeWeapon
        SkeletalMesh=SkeletalMesh'Delmor_Weapons.Meshes.sk_dagger'
        FOV=60
		HiddenGame=FALSE
        HiddenEditor=FALSE
        //Animations=MeshSequenceA
        AnimSets(0)=AnimSet'Delmor_Character.AnimSets.Lucian_anim'
		AnimtreeTemplate=AnimTree'Delmor_Character.AnimTrees.Lucian_AnimTree'

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
		Scale=3.0
		bAllowAmbientOcclusion=false
		bUseOnePassLightingOnTranslucency=true
		bPerBoneMotionBlur=true
	End Object
	Mesh=MeleeWeapon
    Components.Add(MeleeWeapon)
}

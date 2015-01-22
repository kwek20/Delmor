/**
 * the standard sword used by delmorians. 
 * is named Demonslayer for the high count of demons and monsters that are slain by this very weapon
 * @author Harmen Wiersma
 */
class DELMeleeWeaponDemonSlayer extends DELMeleeWeapon;

DefaultProperties
{
	Begin Object class=SkeletalMeshComponent Name=MeleeWeapon
        SkeletalMesh=SkeletalMesh'Delmor_Character.Meshes.sk_lucian_sword'
		PhysicsAsset = PhysicsAsset'Delmor_Character.Meshes.sk_lucian_sword_Physics'
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
		Scale=1.f
		bAllowAmbientOcclusion=false
		bUseOnePassLightingOnTranslucency=true
		bPerBoneMotionBlur=true
	End Object
    Mesh=MeleeWeapon
    Components.Add(MeleeWeapon)

	criticalHitChance = 15
}

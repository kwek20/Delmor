/**
 * class for the weapon called Butcher
 * @author harmen wiersma
 */
class DELMeleeWeaponTheButcher extends DELMeleeWeapon;

DefaultProperties
{
	Begin Object class=SkeletalMeshComponent Name=MeleeWeapon
        SkeletalMesh=SkeletalMesh'delmor_character.Meshes.sk_lucian_sword2'
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
}

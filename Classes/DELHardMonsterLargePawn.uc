/**
 * @author Bram
 * Pawn class for the hard enemy
 */
class DELHardMonsterLargePawn extends DELHostilePawn
      placeable
	  Config(Game);

defaultproperties
{
	ControllerClass=class'Delmor.DELHardMonsterLargeController'

	//Mesh
	Components.Remove(ThirdPersonMesh)
	Begin Object Name=ThirdPersonMesh
		SkeletalMesh=SkeletalMesh'CH_IronGuard_Male.Mesh.SK_CH_IronGuard_MaleA'
		AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
		PhysicsAsset=PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
		AnimtreeTemplate=AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
		Scale3D=(X=2, Y=2, Z=4)
		HiddenGame=False
		HiddenEditor=False
		bHasPhysicsAssetInstance=True
		bAcceptsLights=true
		Translation=(Z=12.0)
	End Object
	Mesh=ThirdPersonMesh
    Components.Add(ThirdPersonMesh)

	health = 1000
	healthMax = 1000
	healthRegeneration = 0
	GroundSpeed = 95
}
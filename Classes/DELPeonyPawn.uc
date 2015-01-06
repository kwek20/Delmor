/**
 * Pawn off Peony
 * @author Bram Arts
 */
class DELPeonyPawn extends DELNPCPawn
      placeable
	  Config(Game);

DefaultProperties
{
	Components.Remove(ThirdPersonMesh)
	Begin Object Name=ThirdPersonMesh
		SkeletalMesh=SkeletalMesh'Delmor_Character.Meshes.sk_Peony'
		AnimSets(0)=AnimSet'Delmor_Character.AnimSets.Peony_Anim'
		AnimtreeTemplate=AnimTree'Delmor_Character.animtrees.Peony_AnimTree'
		PhysicsAsset=PhysicsAsset'Delmor_Character.PhysicsAsset.sk_Peony_Physics'
		HiddenGame=False
		HiddenEditor=False
		Scale3D=(X=1, Y=1, Z=1)
		bHasPhysicsAssetInstance=false
		bAcceptsLights=true
		Translation=(Z=-45.0)
	End Object
	Mesh=ThirdPersonMesh
    Components.Add(ThirdPersonMesh)
	ControllerClass=class'DELPeonyController'
	GroundSpeed = 100
}

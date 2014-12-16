/**
 * @author Anders Egberts
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
		SkeletalMesh=SkeletalMesh'Delmor_Character.sk_culpa_Big'
		AnimSets(0)=AnimSet'Delmor_Character.Cupla_big_anim'
		PhysicsAsset=PhysicsAsset'Delmor_Character.sk_culpa_Big_Physics'
		AnimtreeTemplate=AnimTree'Delmor_Character.Culpa_big_AnimTree'
		Scale3D=(X=1, Y=1, Z=1)
		HiddenGame=False
		HiddenEditor=False
		bHasPhysicsAssetInstance=True
		bAcceptsLights=true
		Translation=(Z=-136.0)
	End Object
	Mesh=ThirdPersonMesh
    Components.Add(ThirdPersonMesh)

	health = 1000
	healthMax = 1000
	healthRegeneration = 0
	GroundSpeed = 95

	Begin Object Name=CollisionCylinder
		CollisionRadius = 36.0;
		CollisionHeight = +132.0;
	end object
}
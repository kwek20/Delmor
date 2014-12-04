/**
 * Pawn class used for the goat.
 */
class DELGoatPawn extends DELAnimalPawn
      placeable
	  Config(Game);

simulated function PostBeginPlay() {
	super.PostBeginPlay();
	`log(self);
}

/**
 * The mesh for the Goat and his speed.
 */
DefaultProperties
{
	Components.Remove(ThirdPersonMesh);
	Begin Object Name=ThirdPersonMesh
		SkeletalMesh=SkeletalMesh'Delmor_Character.Chicken'
		AnimSets(0)=AnimSet'Delmor_Character.Chicken_anim'
		AnimtreeTemplate=AnimTree'Delmor_Character.Chicken_animTree'
		HiddenGame=False
		HiddenEditor=False
		Scale3D=(X=1, Y=1, Z=1)
		bHasPhysicsAssetInstance=false
		bAcceptsLights=true
		Translation=(Z=1.0)
	End Object
	Mesh=ThirdPersonMesh
    Components.Add(ThirdPersonMesh)
	ControllerClass=class'Delmor.DELGoatController'
	GroundSpeed=50
}

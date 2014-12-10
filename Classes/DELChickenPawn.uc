/**
 * Pawn class used for the goat.
 */
class DELChickenPawn extends DELAnimalPawn
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
		SkeletalMesh=SkeletalMesh'Delmor_Character.sk_chicken'
		AnimSets(0)=AnimSet'Delmor_Character.Chicken_anim'
		AnimtreeTemplate=AnimTree'Delmor_Character.Chicken_animTree'
		HiddenGame=False
		HiddenEditor=False
		Scale3D=(X=1, Y=1, Z=1)
		bHasPhysicsAssetInstance=false
		bAcceptsLights=true
		Translation=(Z=-19.0)
	End Object
	Mesh=ThirdPersonMesh
    Components.Add(ThirdPersonMesh)
	
	Begin Object Name=CollisionCylinder
	CollisionRadius = 22.0;
	CollisionHeight = +16.0;
	end object

	ControllerClass=class'DELChickenController'
	GroundSpeed=50
}

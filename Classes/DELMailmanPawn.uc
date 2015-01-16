/**
 * Pawn van de Guard
 * @author Bram Arts
 */
class DELMailmanPawn extends DELNPCPawn
      placeable
	  Config(Game);

var DELMailmanController MyController;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	if(Controller == none)
		SpawnDefaultController();
	SetPhysics(PHYS_Walking);
	if (MyController == none)
	{
		MyController = Spawn(class'DELMailmanController', self);
	}
	
}


DefaultProperties
{
	Components.Remove(ThirdPersonMesh)
	Begin Object Name=ThirdPersonMesh
		SkeletalMesh=SkeletalMesh'Delmor_Character.Meshes.sk_mailman'
		AnimSets(0)=AnimSet'Delmor_Character.AnimSets.Mailman_AnimSets'
		AnimtreeTemplate=AnimTree'Delmor_Character.AnimTrees.Mailman_AnimTree'
		PhysicsAsset=PhysicsAsset'Delmor_Character.PhysicsAsset.sk_mailman_Physics'
		HiddenGame=False
		HiddenEditor=False
		Scale3D=(X=1, Y=1, Z=1)
		bHasPhysicsAssetInstance=false
		bAcceptsLights=true
		Translation=(Z=-19.0)
	End Object
	Mesh=ThirdPersonMesh
    Components.Add(ThirdPersonMesh)
	ControllerClass=class'Delmor.DELMailmanController'
	GroundSpeed = 100
}

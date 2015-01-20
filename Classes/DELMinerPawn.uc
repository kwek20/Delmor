/**
 * Pawn van de Guard
 * @author Bram Arts
 */
class DELMinerPawn extends DELNPCPawn
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
		MyController = Spawn(class'DELMinerController', self);
	}
	
}


DefaultProperties
{
	Components.Remove(ThirdPersonMesh)
	Begin Object Name=ThirdPersonMesh
		SkeletalMesh=SkeletalMesh'Delmor_Character.Meshes.sk_Miner'
		AnimSets(0)=AnimSet'Delmor_Character.AnimSets.Miner_anim'
		AnimtreeTemplate=AnimTree'Delmor_Character.AnimTrees.Miner_AnimTree'
		PhysicsAsset=PhysicsAsset'Delmor_Character.PhysicsAsset.sk_Miner_Physics'
		HiddenGame=False
		HiddenEditor=False
		Scale3D=(X=1, Y=1, Z=1)
		bHasPhysicsAssetInstance=false
		bAcceptsLights=true
		Translation=(Z=-46.0)
	End Object
	Mesh=ThirdPersonMesh
    Components.Add(ThirdPersonMesh)
	ControllerClass=class'Delmor.DELMinerController'
	GroundSpeed = 100
}

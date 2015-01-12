/**
 * Pawn van de Guard
 * @author Bram Arts
 */
class DELGuardPawn extends DELNPCPawn
      placeable
	  Config(Game);


var() array<Pathnode> pathNodeList;
var() bool patrollingLine;
var DELGuardController MyController;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	if(Controller == none)
		SpawnDefaultController();
	SetPhysics(PHYS_Walking);
	if (MyController == none)
	{
		MyController = Spawn(class'DELGuardController', self);
	}
	
}


DefaultProperties
{
	Components.Remove(ThirdPersonMesh)
	Begin Object Name=ThirdPersonMesh
		SkeletalMesh=SkeletalMesh'Delmor_Character.Meshes.sk_guard'
		AnimSets(0)=AnimSet'Delmor_Character.AnimSets.Guard_anim'
		AnimtreeTemplate=AnimTree'Delmor_Character.AnimTrees.Guard_AnimTree'
		PhysicsAsset=PhysicsAsset'Delmor_Character.PhysicsAsset.Guard_idle_Physics'
		HiddenGame=False
		HiddenEditor=False
		Scale3D=(X=1, Y=1, Z=1)
		bHasPhysicsAssetInstance=false
		bAcceptsLights=true
		Translation=(Z=-42.0)
	End Object
	Mesh=ThirdPersonMesh
    Components.Add(ThirdPersonMesh)
	ControllerClass=class'Delmor.DELGuardController'
	GroundSpeed = 100
}

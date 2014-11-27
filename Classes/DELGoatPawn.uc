class DELGoatPawn extends DELAnimalPawn
      placeable
	  Config(Game);

simulated event PostBeginPlay() {
	super.PostBeginPlay();
	`log(Mesh.SkeletalMesh);
}
DefaultProperties
{
	Components.Remove(ThirdPersonMesh);
	Begin Object Name=ThirdPersonMesh
		SkeletalMesh=SkeletalMesh'KismetGame_Assets.Anims.SK_Jazz'
		AnimSets(0)=AnimSet'KismetGame_Assets.Anims.SK_Jazz_Anims'
		AnimtreeTemplate=AnimTree'KismetGame_Assets.Anims.Jazz_AnimTree'
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

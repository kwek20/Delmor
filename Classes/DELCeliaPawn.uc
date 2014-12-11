class DELCeliaPawn extends DELNPCPawn
      placeable
	  Config(Game);


DefaultProperties
{
	Components.Remove(ThirdPersonMesh)
	Begin Object Name=ThirdPersonMesh
		SkeletalMesh=SkeletalMesh'Delmor_Character.Meshes.sk_celia'
		AnimSets(0)=AnimSet'Delmor_Character.Celia_anim'
		AnimtreeTemplate=AnimTree'Delmor_Character.Celia_AnimTree'
		PhysicsAsset=PhysicsAsset'Delmor_Character.sk_celia_Physics'
		HiddenGame=False
		HiddenEditor=False
		Scale3D=(X=1, Y=1, Z=1)
		bHasPhysicsAssetInstance=false
		bAcceptsLights=true
		Translation=(Z=-47.0)
	End Object
	Mesh=ThirdPersonMesh
    Components.Add(ThirdPersonMesh)
	ControllerClass=class'DELCeliaController'
	GroundSpeed = 100
}

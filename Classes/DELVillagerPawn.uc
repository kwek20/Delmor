class DELVillagerPawn extends DELAnimalPawn
	placeable;

DefaultProperties
{
	controllerClass = class'DELVillagerController'

	Components.Remove(ThirdPersonMesh);
	Begin Object Name=ThirdPersonMesh
		SkeletalMesh=SkeletalMesh'Delmor_Character.Meshes.sk_villager'
		AnimSets(0)=AnimSet'Delmor_Character.AnimSets.Villager_anim'
		AnimtreeTemplate=AnimTree'Delmor_Character.AnimTrees.Villager_AnimTree'
		PhysicsAsset=PhysicsAsset'Delmor_Character.PhysicsAsset.sk_villager_Physics'
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

	GroundSpeed=100.0

	keepInRam = false
}
